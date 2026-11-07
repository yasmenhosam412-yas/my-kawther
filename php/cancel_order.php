<?php
/**
 * Order Cancellation Endpoint - Server Side Fix
 * Properly handles order cancellation with status checking
 * Fixes: "لا يمكن إلغاء هذا الطلب" always returning
 * Also fixes: HTTP 422 Unprocessable Entity (WebDAV) error
 */

// Always set these headers first
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS, GET');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
header('Cache-Control: no-cache, must-revalidate');

// Handle OPTIONS preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Initialize response variables
$response = [
    'success' => false,
    'message' => '',
    'code' => '',
    'order_id' => 0,
    'current_status' => ''
];

// Configuration - MUST update these!
$dbHost = 'localhost';
$dbName = 'pharmacy_db';    // <<<--- UPDATE: Your database name
$dbUser = 'root';           // <<<--- UPDATE: Your database username
$dbPass = '';               // <<<--- UPDATE: Your database password
$charset = 'utf8mb4';

try {
    // Create PDO connection
    $pdo = new PDO("mysql:host=$dbHost;dbname=$dbName;charset=$charset", $dbUser, $dbPass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
} catch (PDOException $e) {
    // Database connection failed - return JSON error response
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Database connection failed',
        'code' => 'db_error',
        'details' => $e->getMessage()
    ]);
    exit();
}

// Get request method and order ID
$method = $_SERVER['REQUEST_METHOD'];
$orderId = 0;

if (isset($_GET['order_id'])) {
    $orderId = (int)$_GET['order_id'];
} elseif (isset($_POST['order_id'])) {
    $orderId = (int)$_POST['order_id'];
}

// Read request body for additional data (like reason)
$data = json_decode(file_get_contents('php://input'), true ?? true);
$reason = isset($data['reason']) && !empty(trim($data['reason'])) 
    ? trim($data['reason']) 
    : 'Customer requested cancellation';

// Default responses
$response['code'] = 'no_action';

// Check if order ID is valid
if ($orderId <= 0) {
    $response['message'] = 'Invalid order ID';
    $response['code'] = 'invalid_order_id';
    http_response_code(400);
    echo json_encode($response);
    exit();
}

// Get order from database
$stmt = $pdo->prepare("SELECT id, status, user_id, total_price FROM orders WHERE id = :order_id");
$stmt->bindParam(':order_id', $orderId, PDO::PARAM_INT);
$stmt->execute();
$order = $stmt->fetch();

if (!$order) {
    $response['message'] = 'Order not found';
    $response['code'] = 'order_not_found';
    http_response_code(404);
    echo json_encode($response);
    exit();
}

// Store current status
$currentStatus = $order['status'];
$response['current_status'] = $currentStatus;

// Define allowed statuses for cancellation
// These are the statuses where cancellation is permitted
$allowedCancellationStatuses = ['pending', 'picking', 'packed', 'confirmed'];

// Define statuses where cancellation is NOT allowed
$cannotCancelStatuses = ['completed', 'canceled', 'delivered', 'out_for_delivery'];

// Check if cancellation is allowed for this order
$canCancel = in_array($currentStatus, $allowedCancellationStatuses);

// If cancellation is not allowed, return the Arabic message with specific reason
if (!$canCancel) {
    // Provide specific messages based on current status
    switch ($currentStatus) {
        case 'completed':
            $response['message'] = 'هذا الطلب已完成 ولا يمكن إلغاؤه';
            break;
        case 'canceled':
            $response['message'] = 'هذا الطلب已被 Cancelled بالفعل';
            break;
        case 'delivered':
        case 'delivered':
            $response['message'] = 'هذا الطلب已送达已送达، لا يمكن إلغاء التوصيل';
            break;
        default:
            $response['message'] = 'لا يمكن إلغاء هذا الطلب';
            break;
    }
    $response['code'] = 'cancel_not_allowed';
    http_response_code(422); // WebDAV Unprocessable Entity
    echo json_encode($response);
    exit();
}

// Cancellation is allowed - proceed with database update
try {
    // Start transaction for atomicity
    $pdo->beginTransaction();
    
    // Update order status to canceled
    $updateStmt = $pdo->prepare(
        "UPDATE orders 
         SET status = 'canceled', 
             updated_at = NOW(),
             cancellation_reason = :reason,
             canceled_at = NOW()
         WHERE id = :order_id AND status != 'canceled'"
    );
    
    $updateStmt->bindParam(':reason', $reason, PDO::PARAM_STR);
    $updateStmt->bindParam(':order_id', $orderId, PDO::PARAM_INT);
    
    $updateExecuted = $updateStmt->execute();
    
    if (!$updateExecuted || $updateStmt->rowCount() === 0) {
        throw new Exception('Failed to update order status or no rows affected');
    }
    
    // Log the cancellation in cancellation log table
    $logStmt = $pdo->prepare(
        "INSERT INTO order_cancellation_log (order_id, canceled_by, reason, canceled_at)
         VALUES (:order_id, :canceled_by, :reason, NOW())"
    );
    
    // Get user ID - try session first, then default to 'customer'
    $canceledBy = 'customer';
    if (isset($_SESSION['user_id'])) {
        $canceledBy = $_SESSION['user_id'];
    }
    
    $logStmt->bindParam(':order_id', $orderId, PDO::PARAM_INT);
    $logStmt->bindParam(':canceled_by', $canceledBy, PDO::PARAM_STR);
    $logStmt->bindParam(':reason', $reason, PDO::PARAM_STR);
    $logStmt->execute();
    
    // Commit the transaction
    $pdo->commit();
    
    // Build success response
    $response['success'] = true;
    $response['message'] = 'Order canceled successfully';
    $response['code'] = 'cancel_success';
    $response['order_id'] = $orderId;
    $response['new_status'] = 'canceled';
    $response['canceled_at'] = date('Y-m-d H:i:s');
    $response['current_status_before'] = $currentStatus;
    
    http_response_code(200);
    echo json_encode($response);
    exit();
    
} catch (PDOException $e) {
    // Rollback transaction on database error
    $pdo->rollBack();
    
    $response['message'] = 'Database error: ' . $e->getMessage();
    $response['code'] = 'db_error';
    http_response_code(500);
    echo json_encode($response);
    exit();
    
} catch (Exception $e) {
    // Rollback transaction on other errors
    try {
        $pdo->rollBack();
    } catch (PDOException $rollBackEx) {
        // Ignore rollback failure
    }
    
    $response['message'] = 'Failed to cancel order: ' . $e->getMessage();
    $response['code'] = 'cancellation_failed';
    http_response_code(500);
    echo json_encode($response);
    exit();
}
```
# Order Cancellation PHP Backend

## Setup Instructions

### 1. Database Configuration
Edit `cancel_order.php` and update these values:
```php
$host = 'localhost';
$db   = 'your_database_name';    // Replace with your DB name
$user = 'your_db_user';          // Replace with your DB user
$pass = 'your_db_password';      // Replace with your DB password
```

### 2. Required Database Tables
Run the SQL migration `db_migration_orders.sql` on your MySQL server:
```bash
mysql -u your_user -p your_database < db_migration_orders.sql
```

### 3. PHP Server Configuration
Ensure your PHP server is running on port 8000:
```bash
php -S 0.0.0.0:8000 -t /path/to/your/php/folder
```

### 4. API Endpoint
**POST** `http://0.0.0.0:8000/cancel_order.php`

### 5. Request Format (JSON)
```json
{
    "order_id": 123,          // Required: The order ID to cancel
    "reason": "Customer requested cancellation"  // Optional: Cancellation reason
}
```

### 6. Response Formats

**Success Response:**
```json
{
    "status": "success",
    "message": "Order canceled successfully",
    "order_id": 123,
    "new_status": "canceled",
    "canceled_at": "2024-01-15 14:30:00"
}
```

**Info Response (Already Canceled):**
```json
{
    "status": "info",
    "message": "Order is already canceled",
    "order_id": 123
}
```

**Error Responses:**
- **400**: `{"status": "error", "message": "Invalid order ID"}`
- **405**: `{"status": "error", "message": "Method not allowed. Use POST."}`
- **500**: `{"status": "error", "message": "Database connection failed: ..."}`
- **500**: `{"status": "error", "message": "Failed to cancel order: ..."}`

### 6. PHP Server Integration

Add this route to your existing PHP server or create a new file:

```bash
# If using built-in PHP server
php -S 0.0.0.0:8000 -t /path/to/php/folder
```

Or add to your existing .htaccess or Apache/Nginx config:
```apache
# For Apache with mod_rewrite
RewriteEngine On
RewriteRule ^cancel_order$ cancel_order.php [NC,L]
```

### 7. Flutter Integration (Dio D DIO D)

Add this Dio interceptor or method to your Flutter app:

```dart
import 'package:dio/dio.dart';

Future<void> cancelOrder(int orderId, {String reason = 'Customer requested cancellation'}) async {
  final Dio dio = Dio();
  
  try {
    final response = await dio.post(
      'http://0.0.0.0:8000/cancel_order.php',
      data: {
        'order_id': orderId,
        'reason': reason,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    
    if (response.data['status'] == 'success') {
      // Order successfully canceled
      // Refresh order data, show success message, etc.
      print('Order canceled: ${response.data['message']}');
    } else if (response.data['status'] == 'info') {
      // Order already canceled
      print('${response.data['message']}');
    } else {
      // Handle error
      print('Error: ${response.data['message']}');
    }
  } on DioException catch (e) {
    print('Dio Error: ${e.message}');
  }
}
```

### 8. Usage in Flutter Cubit/Bloc

Add to your order management cubit:

```dart
void cancelCurrentOrder() {
  final orderId = currentOrder.value.id;
  cancelOrder(orderId).then((_) {
    // Refresh order state
    refetchOrderData();
    // Show success snack bar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order canceled successfully')),
    );
  }).catchError((error) {
    // Show error snack bar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to cancel: $error')),
    );
  });
}
```

### 9. Testing the Endpoint

```bash
# Using curl
curl -X POST http://0.0.0.0:8000/cancel_order.php \
  -H "Content-Type: application/json" \
  -d '{"order_id": 1, "reason": "Customer requested cancellation"}'

# Expected output:
# {"status":"success","message":"Order canceled successfully","order_id":1,"new_status":"canceled","canceled_at":"2024-01-15 14:30:00"}
```

### 10. Important Notes

- Ensure your `orders` table has a `status` column with ENUM: 'pending', 'picking', 'packed', 'confirmed', 'on_delivery', 'compiled', 'canceled'
- The `order_cancellation_log` table tracks cancellation history
- Update the `isShipped` logic in `track_order.dart` if needed (already includes 'canceled')
- The Flutter `order_state_stepper.dart` now properly shows canceled as step 6
- All ARB localization strings are in place (English: "Canceled", Arabic: "ألغيت")
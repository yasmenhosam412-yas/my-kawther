<?php
/**
 * Return Image Endpoint
 * Serves return product images from the server
 * Fixes: 404 Not Found error for return-image endpoint
 */

header('Content-Type: image/jpeg');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Cache-Control: public, max-age=3600');

// Handle OPTIONS preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Get the image filename from the URL
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$filename = basename($path); // Get just the filename portion

if (empty($filename)) {
    http_response_code(400);
    // Return a placeholder red image in JSON format as fallback
    // Since we need to output image data, we'll write a minimal error response
    // and exit - the client will handle the 404
    exit();
}

// Define the base directory where return images are stored
// Update this path to match your actual image storage location
$baseDir = __DIR__ . '/return_images/';

// Try to find the image in multiple possible locations
$possiblePaths = [
    // Direct path from filename
    $baseDir . $filename,
    // Path with prefix
    $baseDir . 'return_' . $filename,
    // Path with uid prefix (the image UUID format)
    $baseDir . 'return_' . substr($filename, 0, 8) . '/' . $filename,
];

$imagePath = null;
foreach ($possiblePaths as $path) {
    if (file_exists($path) && is_file($path)) {
        $imagePath = $path;
        break;
    }
}

// Also check if the filename already includes a path structure
if (!$imagePath && strpos($filename, '/') !== false) {
    $imagePath = $baseDir . $filename;
}

// If no image found, try to serve a default placeholder
if (!$imagePath || !file_exists($imagePath)) {
    // Create a minimal 1x1 transparent PNG
    $placeholder = base64_decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAAABCAQAAAC1HAwAAAAABlEQVR4nGN+AABAAAASsV/nKwAAAABJRU5ErkJggg==');
    header('Content-Type: image/png');
    echo $placeholder;
    exit();
}

// Determine the content type based on file extension
$ext = strtolower(pathinfo($imagePath, PATHINFO_EXTENSION));
$contentType = 'image/jpeg'; // default

if ($ext === 'png') {
    $contentType = 'image/png';
} elseif ($ext === 'gif') {
    $contentType = 'image/gif';
} elseif ($ext === 'webp') {
    $contentType = 'image/webp';
} elseif ($ext === 'bmp') {
    $contentType = 'image/bmp';
}

// Send the image file
header('Content-Type: ' . $contentType);
header('Content-Length: ' . filesize($imagePath));
header('Cache-Control: max-age=86400'); // 1 day cache
readfile($imagePath);
exit();
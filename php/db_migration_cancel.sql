-- Database Migration for Order Cancellation Support
-- Run this on your MySQL server to add the necessary columns and tables

-- 1. Add cancellation columns to existing orders table if they don't exist
ALTER TABLE orders ADD COLUMN IF NOT EXISTS status ENUM('pending', 'picking', 'packed', 'confirmed', 'on_delivery', 'compiled', 'canceled') DEFAULT 'pending';
ALTER TABLE orders ADD COLUMN IF NOT EXISTS canceled_at TIMESTAMP NULL;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS cancellation_reason TEXT;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- 2. Create order_cancellation_log table if it doesn't exist
CREATE TABLE IF NOT EXISTS order_cancellation_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    canceled_by VARCHAR(100) NOT NULL DEFAULT 'customer',
    reason TEXT,
    canceled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id)
);

-- 3. Insert initial statuses if the orders table is new
-- INSERT IGNORE INTO orders (status) VALUES ('pending'), ('picking'), ('packed'), ('confirmed'), ('on_delivery'), ('compiled'), ('canceled');

-- 4. Sample queries for reference:

-- Check current order status:
-- SELECT id, status, updated_at FROM orders WHERE id = 1;

-- Cancel an order:
-- UPDATE orders SET status = 'canceled', updated_at = NOW(), cancellation_reason = 'Customer request', canceled_at = NOW() WHERE id = 123 AND status != 'canceled';

-- Check cancellation log:
-- SELECT * FROM order_cancellation_log WHERE order_id = 123 ORDER BY canceled_at DESC LIMIT 1;

-- Get all orders with their status:
-- SELECT id, status, updated_at, cancellation_reason, canceled_at FROM orders LIMIT 10;
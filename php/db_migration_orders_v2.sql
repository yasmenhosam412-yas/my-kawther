-- Order Table Migration with Cancellation Support
-- Run this on your MySQL server to add cancellation support

-- If orders table already exists, alter it to add cancellation columns
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS status ENUM('pending', 'picking', 'packed', 'confirmed', 'on_delivery', 'compiled', 'canceled') DEFAULT 'pending',
ADD COLUMN IF NOT EXISTS canceled_at TIMESTAMP NULL,
ADD COLUMN IF NOT EXISTS cancellation_reason TEXT,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Create order_cancellation_log table if not exists
CREATE TABLE IF NOT EXISTS order_cancellation_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    canceled_by VARCHAR(100) NOT NULL DEFAULT 'customer',
    reason TEXT,
    canceled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id)
);

-- Insert initial statuses if not exist (for new tables)
-- INSERT IGNORE INTO status_table (name) VALUES ('pending'), ('picking'), ('packed'), ('confirmed'), ('on_delivery'), ('compiled'), ('canceled');

-- Sample query to check current order statuses:
-- SELECT id, status, updated_at FROM orders LIMIT 5;

-- Sample query to cancel an order:
-- UPDATE orders SET status = 'canceled', updated_at = NOW(), cancellation_reason = 'Customer request', canceled_at = NOW() WHERE id = 123 AND status != 'canceled';

-- Sample query to check cancellation log:
-- SELECT * FROM order_cancellation_log WHERE order_id = 123 ORDER BY canceled_at DESC LIMIT 1;
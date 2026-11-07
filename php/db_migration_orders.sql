-- Order Table Migration for Cancellation Support
-- Add this to your existing orders table or create new

-- Create orders table if not exists
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    status ENUM('pending', 'picking', 'packed', 'confirmed', 'on_delivery', 'compiled', 'canceled') DEFAULT 'pending',
    total DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    tax DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    discount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    payment_method VARCHAR(50) DEFAULT 'cash_on_delivery',
    shipping_address TEXT,
    phone_number VARCHAR(20),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    canceled_at TIMESTAMP NULL,
    
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_order_number (order_number)
);

-- Create order items table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL,
    color VARCHAR(20) DEFAULT NULL,
    size VARCHAR(20) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id)
);

-- Create order cancellation log table
CREATE TABLE IF NOT EXISTS order_cancellation_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    canceled_by VARCHAR(100) NOT NULL DEFAULT 'customer',
    reason TEXT,
    canceled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id)
);

-- Insert sample status enum values if needed
-- ALTER TABLE orders MODIFY status ENUM('pending', 'picking', 'packed', 'confirmed', 'on_delivery', 'compiled', 'canceled') DEFAULT 'pending';

-- Grant permissions (if needed)
-- GRANT SELECT, INSERT, UPDATE ON orders TO 'your_user'@'localhost';
-- GRANT SELECT, INSERT ON order_cancellation_log TO 'your_user'@'localhost';

-- Note: Update the PHP cancel_order.php to match your actual database name, 
-- user, password, and table names.
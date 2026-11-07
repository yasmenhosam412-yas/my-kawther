-- Database Migration for Return Images
-- Create directory structure notes and table for tracking return images

-- Note: Create a directory 'return_images/' in the same folder as this PHP script
-- The directory should contain the return product images

-- Sample table to track return images if needed
CREATE TABLE IF NOT EXISTS return_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    return_order_id INT NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    image_name VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    file_size INT,
    mime_type VARCHAR(50),
    
    FOREIGN KEY (return_order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_return_order_id (return_order_id)
);

-- Sample queries:

-- Insert a return image record:
-- INSERT INTO return_images (return_order_id, image_path, image_name, file_size, mime_type)
-- VALUES (123, '/path/to/return_images/return-cd7XnBIUZSUJ.jpg', 'return-cd7XnBIUZSUJ.jpg', 123456, 'image/jpeg');

-- Get return images for a specific order:
-- SELECT * FROM return_images WHERE return_order_id = 123;

-- Get a specific image path:
-- SELECT image_path FROM return_images WHERE id = 1;
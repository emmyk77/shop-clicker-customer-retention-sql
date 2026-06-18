INSERT INTO customers (full_name, age, gender, location, signup_date) VALUES
('John Ade', 28, 'Male', 'Lagos', '2025-12-10'),
('Mary Okafor', 34, 'Female', 'Abuja', '2025-10-15'),
('David James', 25, 'Male', 'Port Harcourt', '2025-11-12'),
('Sarah Bello', 30, 'Female', 'Ibadan', '2025-12-08'),
('Michael Obi', 40, 'Male', 'Enugu', '2025-12-20'),
('Grace Umeh', 22, 'Female', 'Benin', '2025-10-18'),
('Paul Yusuf', 29, 'Male', 'Kaduna', '2025-09-01'),
('Linda Eze', 31, 'Female', 'Owerri', '2025-11-11'),
('Samuel Ayo', 27, 'Male', 'Ilorin', '2025-12-05'),
('Joy Musa', 35, 'Female', 'Jos', '2025-10-14');

INSERT INTO products (product_name, price, category) VALUES
('Wireless Mouse', 25.00, 'Electronics'),
('Office Chair', 120.00, 'Furniture'),
('Water Bottle', 15.00, 'Accessories'),
('Running Shoes', 80.00, 'Fashion'),
('Bluetooth Speaker', 60.00, 'Electronics');

INSERT INTO purchases (customer_id, product_id, quantity, total_amount, purchase_date) VALUES
(1, 1, 1, 25.00, '2025-10-01'),
(1, 5, 1, 60.00, '2026-01-15'),
(2, 2, 1, 120.00, '2025-09-20'),
(3, 4, 2, 160.00, '2026-02-10'),
(4, 3, 3, 45.00, '2025-11-12'),
(5, 1, 1, 25.00, '2025-08-05'),
(6, 5, 1, 60.00, '2026-03-01'),
(7, 2, 1, 120.00, '2025-07-22'),
(8, 4, 1, 80.00, '2025-12-25'),
(9, 3, 2, 30.00, '2026-01-30'),
(2, 1, 1, 25.00, '2026-02-05'),
(3, 3, 1, 15.00, '2026-03-12');

INSERT INTO customer_interactions (customer_id, interaction_type, interaction_date, feedback_rating) VALUES
(1, 'Email', '2026-01-20', 4),
(2, 'Chat', '2026-02-15', 5),
(3, 'Phone Call', '2026-03-10', 3),
(4, 'Email', '2025-11-20', 2),
(5, 'Chat', '2025-09-01', 2),
(6, 'Phone Call', '2026-03-05', 4),
(7, 'Email', '2025-08-01', 1),
(8, 'Chat', '2025-12-30', 3);

INSERT INTO customer_feedback (customer_id, feedback_date, feedback_content, satisfaction_rating) VALUES
(1, '2026-01-22', 'Delivery was fast and product was good.', 4),
(2, '2026-02-18', 'Excellent shopping experience.', 5),
(3, '2026-03-11', 'Product quality was fair.', 3),
(4, '2026-01-05', 'Customer service was poor.', 2),
(5, '2025-10-10', 'The item arrived damaged.', 1),
(7, '2026-02-01', 'Response to complaint was slow.', 2),
(8, '2026-03-02', 'Average experience.', 3);
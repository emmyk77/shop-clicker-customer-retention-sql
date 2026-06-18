
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10),
    location VARCHAR(100) default 'nigeria',
    signup_date DATE NOT NULL
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50) NOT NULL
);

CREATE TABLE purchases (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    purchase_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE customer_interactions (
    interaction_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    interaction_type VARCHAR(50) NOT NULL,
    interaction_date DATE NOT NULL,
    feedback_rating INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE customer_feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    feedback_date DATE NOT NULL,
    feedback_content TEXT,
    satisfaction_rating INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

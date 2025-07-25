create database retailshop;
use retailshop;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0
);


CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE
);

INSERT INTO customers VALUEs(1,'Alice', 'alice@example.com', '1234567890', '123 Main St');
INSERT INTO customers VALUEs(2,'Bob', 'bob@example.com', '2345678901', '456 Oak Ave');

INSERT INTO products (name, description, price, stock_quantity) VALUES
('Laptop', 'High performance laptop', 1200.00, 10),
('Phone', 'Smartphone with good camera', 800.00, 20);

INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1, '2025-07-20', 2000.00, 'Shipped'),
(2, '2025-07-21', 800.00, 'Pending');

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1200.00),  -- Laptop
(1, 2, 1, 800.00),   -- Phone
(2, 2, 1, 800.00);   -- Phone

INSERT INTO payments (order_id, payment_date, amount, payment_method, payment_status) VALUES
(1, '2025-07-21', 2000.00, 'Credit Card', 'Completed'),
(2, '2025-07-22', 800.00, 'PayPal', 'Pending');

select * from customers;
select * from products;
select * from orders;
select * from order_items;
select * from payments;

SELECT 
    p.name AS product_name,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.price) AS total_revenue
FROM 
    order_items oi
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    p.name;
    
    SELECT 
    o.order_id,
    o.order_date,
    c.name AS customer_name,
    o.total_amount,
    o.status
FROM 
    orders o
JOIN 
    customers c ON o.customer_id = c.customer_id;
    
    CREATE VIEW completed_payments AS
SELECT 
    p.payment_id,
    o.order_id,
    c.name AS customer_name,
    p.amount,
    p.payment_method,
    p.payment_status,
    p.payment_date
FROM 
    payments p
JOIN 
    orders o ON p.order_id = o.order_id
JOIN 
    customers c ON o.customer_id = c.customer_id
WHERE 
    p.payment_status = 'Completed';
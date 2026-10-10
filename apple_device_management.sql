CREATE TABLE Devices (
    device_id INT PRIMARY KEY AUTO_INCREMENT,
    device_name VARCHAR(100) NOT NULL,
    device_type VARCHAR(50) NOT NULL,
    release_year INT NOT NULL,
    base_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Specifications (
    spec_id INT PRIMARY KEY AUTO_INCREMENT,
    device_id INT,
    screen_size VARCHAR(20),
    battery_life VARCHAR(50),
    weight VARCHAR(20),
    camera_megapixels VARCHAR(20),
    FOREIGN KEY (device_id) REFERENCES Devices(device_id)
);


CREATE TABLE Operating_Systems (
    os_id INT PRIMARY KEY AUTO_INCREMENT,
    device_id INT,
    os_name VARCHAR(50) NOT NULL,
    version VARCHAR(20) NOT NULL,
    release_date DATE NOT NULL,
    FOREIGN KEY (device_id) REFERENCES Devices(device_id)
);

CREATE TABLE Processors (
    processor_id INT PRIMARY KEY AUTO_INCREMENT,
    device_id INT,
    processor_name VARCHAR(50) NOT NULL,
    cores INT NOT NULL,
    clock_speed VARCHAR(20) NOT NULL,
    FOREIGN KEY (device_id) REFERENCES Devices(device_id)
);

CREATE TABLE Storage_Options (
    storage_id INT PRIMARY KEY AUTO_INCREMENT,
    device_id INT,
    storage_capacity VARCHAR(20) NOT NULL,
    price_difference DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (device_id) REFERENCES Devices(device_id)
);

CREATE TABLE Colors (
    color_id INT PRIMARY KEY AUTO_INCREMENT,
    device_id INT,
    color_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (device_id) REFERENCES Devices(device_id)
);

CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    device_id INT,
    store_location VARCHAR(100) NOT NULL,
    quantity_available INT NOT NULL,
    last_updated DATE NOT NULL,
    FOREIGN KEY (device_id) REFERENCES Devices(device_id)
);

CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(150) NOT NULL,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
    device_id INT,
    customer_id INT,
    order_date DATE NOT NULL,
    quantity_ordered INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),
    FOREIGN KEY (device_id) REFERENCES Devices(device_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Devices (device_name, device_type, release_year, base_price) VALUES
('iPhone 15 Pro', 'Smartphone', 2023, 4030.93),
('MacBook Air M2', 'Laptop', 2022, 3484.85),
('iPad Pro M4', 'Tablet', 2024, 3599);

INSERT INTO Specifications (device_id, screen_size, battery_life, weight, camera_megapixels) VALUES
(1, '6.1 inches', '23 hours', '187g', '48 MP'),
(2, '13.6 inches', '18 hours', '1.24kg', 'N/A'),
(3, '13 inches', '10 hours', '579g', '12 MP');

INSERT INTO Operating_Systems (device_id, os_name, version, release_date) VALUES
(1, 'iOS', '17.0', '2023-09-12'),
(2, 'macOS', 'Ventura', '2022-10-24'),
(3, 'iPadOS', '17.0', '2024-04-01');

INSERT INTO Processors (device_id, processor_name, cores, clock_speed) VALUES
(1, 'A17 Pro', 6, '3.78 GHz'),  
(2, 'Apple M2', 8, '3.49 GHz'), 
(3, 'Apple M4', 10, '3.90 GHz');

INSERT INTO Storage_Options (device_id, storage_capacity, price_difference) VALUES
(1, '128GB', 0),
(1, '256GB', 200),
(1, '512GB', 400),
(1, '1TB', 600),
(2, '256GB', 0),
(2, '512GB', 800),
(2, '1TB', 1600),
(2, '2TB', 3200),
(3, '256GB', 0),
(3, '512GB', 400),
(3, '1TB', 800),
(3, '2TB', 1600);

INSERT INTO Colors (device_id, color_name) VALUES
(1, 'Titanium Black'),
(1, 'Titanium White'),
(1, 'Titanium Blue'),
(1, 'Titanium Natural'),
(2, 'Midnight'),
(2, 'Starlight'),
(2, 'Space Gray'),
(2, 'Silver'),
(3, 'Silver'),
(3, 'Space Gray');

INSERT INTO Inventory (device_id, store_location, quantity_available, last_updated) VALUES
(1, 'Riyadh Store', 100, '2025-03-01'),
(1, 'Jeddah Store', 75, '2025-03-02'),
(2, 'Dubai Store', 50, '2025-03-03'),
(2, 'Abu Dhabi Store', 40, '2025-03-04'),
(3, 'London Store', 30, '2025-03-05'),
(3, 'Berlin Store', 25, '2025-03-06');

INSERT INTO Suppliers (supplier_name, contact_info, country) VALUES
('Foxconn', 'contact@foxconn.com', 'China'),
('Pegatron', 'contact@pegatron.com', 'Taiwan');


CREATE VIEW Device_Details AS
SELECT 
    d.device_id,
    d.device_name,
    d.device_type,
    d.release_year,
    d.base_price,
    os.os_name,
    os.version AS os_version,
    p.processor_name,
    p.cores,
    p.clock_speed
FROM Devices d
JOIN Operating_Systems os ON d.device_id = os.device_id
JOIN Processors p ON d.device_id = p.device_id;


CREATE VIEW Inventory_Status AS
SELECT 
    d.device_name,
    i.store_location,
    i.quantity_available,
    i.last_updated
FROM Inventory i
JOIN Devices d ON i.device_id = d.device_id
WHERE i.quantity_available > 0;


CREATE VIEW Supplier_Order_Summary AS
SELECT 
    s.supplier_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity_ordered) AS total_quantity,
    SUM(o.total_price) AS total_spent
FROM Orders o
JOIN Suppliers s ON o.supplier_id = s.supplier_id
GROUP BY s.supplier_name;


CREATE VIEW Customer_Latest_Order AS
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    o.order_id,
    o.order_date,
    o.quantity_ordered,
    o.total_price
FROM Customers c
JOIN Orders o 
    ON c.customer_id = o.customer_id
WHERE o.order_date = (
    SELECT MAX(order_date) 
    FROM Orders o2 
    WHERE o2.customer_id = c.customer_id
);

CREATE VIEW Device_Colors AS
SELECT 
    d.device_name,
    GROUP_CONCAT(c.color_name ORDER BY c.color_name SEPARATOR ', ') AS available_colors 
FROM Devices d
JOIN Colors c ON d.device_id = c.device_id
GROUP BY d.device_name;


SELECT * FROM Devices;
SELECT * FROM Specifications;
SELECT * FROM Operating_Systems;
SELECT * FROM Processors;
SELECT * FROM Storage_Options;
SELECT * FROM Colors;
SELECT * FROM Inventory;
SELECT * FROM Suppliers;
SELECT * FROM Customers;
SELECT * FROM Orders;



SELECT * FROM Device_Details;
SELECT * FROM Inventory_Status;
SELECT * FROM Supplier_Order_Summary;
SELECT * FROM Customer_Latest_Order;
SELECT * FROM Device_Colors;


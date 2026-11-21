DROP DATABASE IF EXISTS elearning_platform;
CREATE DATABASE elearning_platform;
USE elearning_platform;
CREATE TABLE learners (
    learner_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    country VARCHAR(50)
);
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2)
);
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    learner_id INT,
    course_id INT,
    quantity INT,
    purchase_date DATE,
    FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
SELECT * FROM learners;
SELECT * FROM courses;
INSERT INTO purchases
(purchase_id, learner_id, course_id, quantity, purchase_date)
VALUES
(1001, 1, 101, 2, '2026-01-05'),
(1002, 2, 102, 1, '2026-01-07'),
(1003, 3, 103, 2, '2026-01-10'),
(1004, 1, 104, 1, '2026-01-12'),
(1005, 4, 101, 3, '2026-01-15'),
(1006, 5, 105, 2, '2026-01-18'),
(1007, 2, 103, 1, '2026-01-20'),
(1008, 3, 102, 2, '2026-01-22');
INSERT INTO learners (learner_id, full_name, country)
VALUES
(1, 'Arun Kumar', 'India'),
(2, 'Priya Sharma', 'India'),
(3, 'John Smith', 'USA'),
(4, 'Sarah Wilson', 'UK'),
(5, 'David Lee', 'Singapore');
INSERT INTO courses
(course_id, course_name, category, unit_price)
VALUES
(101, 'Python for Beginners', 'Programming', 499.00),
(102, 'Advanced SQL', 'Database', 799.00),
(103, 'Power BI Masterclass', 'Data Analytics', 999.00),
(104, 'Machine Learning Basics', 'Artificial Intelligence', 1299.00),
(105, 'Excel for Business', 'Business', 399.00);
SELECT * FROM purchases;
SELECT
    l.learner_id,
    l.full_name,
    l.country,
    c.course_name,
    c.category,
    p.quantity,
    FORMAT(p.quantity * c.unit_price, 2) AS total_amount,
    p.purchase_date
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
ORDER BY total_amount DESC;
SELECT
    l.learner_id,
    l.full_name,
    l.country,
    p.purchase_id,
    c.course_name,
    p.quantity,
    p.purchase_date
FROM learners l
LEFT JOIN purchases p
    ON l.learner_id = p.learner_id
LEFT JOIN courses c
    ON p.course_id = c.course_id
ORDER BY l.learner_id;
SELECT
    c.course_id,
    c.course_name,
    c.category,
    p.purchase_id,
    p.learner_id,
    p.quantity,
    p.purchase_date
FROM purchases p
RIGHT JOIN courses c
    ON p.course_id = c.course_id
ORDER BY c.course_id;
SELECT
    l.learner_id,
    l.full_name,
    l.country,
    FORMAT(
        COALESCE(SUM(p.quantity * c.unit_price), 0),
        2
    ) AS total_spending
FROM learners l
LEFT JOIN purchases p
    ON l.learner_id = p.learner_id
LEFT JOIN courses c
    ON p.course_id = c.course_id
GROUP BY
    l.learner_id,
    l.full_name,
    l.country
ORDER BY SUM(p.quantity * c.unit_price) DESC;
SELECT
    c.course_id,
    c.course_name,
    SUM(p.quantity) AS total_quantity_sold
FROM courses c
INNER JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY
    c.course_id,
    c.course_name
ORDER BY total_quantity_sold DESC, c.course_id ASC
LIMIT 3;
SELECT
    c.category,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_revenue,
    COUNT(DISTINCT p.learner_id) AS unique_learners
FROM courses c
INNER JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.category
ORDER BY SUM(p.quantity * c.unit_price) DESC;
SELECT
    l.learner_id,
    l.full_name,
    COUNT(DISTINCT c.category) AS total_categories
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
GROUP BY
    l.learner_id,
    l.full_name
HAVING COUNT(DISTINCT c.category) > 1;
SELECT
    c.course_id,
    c.course_name,
    c.category,
    c.unit_price
FROM courses c
LEFT JOIN purchases p
    ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL;
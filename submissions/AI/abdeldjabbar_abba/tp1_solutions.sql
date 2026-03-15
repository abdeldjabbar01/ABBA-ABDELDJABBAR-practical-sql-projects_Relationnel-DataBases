
-- TP1: University Management System
-- Author: ABDELDJABBAR Abba


-- 1 Create and use the database
CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;


-- 2 Create tables with constraints

CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12,2),
    department_head VARCHAR(100),
    creation_date DATE
);

-- Table: professors
CREATE TABLE professors (
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DECIMAL(10,2),
    specialization VARCHAR(100),
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: students
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    department_id INT,
    level VARCHAR(20) CHECK (level IN ('L1','L2','L3','M1','M2')),
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: courses
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK (credits > 0),
    semester INT CHECK (semester IN (1,2)),
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: enrollments
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress' CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id, academic_year)
);

-- Table: grades
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30) CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),
    grade DECIMAL(5,2) CHECK (grade BETWEEN 0 AND 20),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. Create indexes
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- 4. Insert test data

-- Departments
INSERT INTO departments (department_id, department_name, building, budget, department_head, creation_date) VALUES
(1, 'Computer Science', 'Building A', 500000.00, 'Dr. Smith', '2010-09-01'),
(2, 'Mathematics', 'Building B', 350000.00, 'Dr. Johnson', '2010-09-01'),
(3, 'Physics', 'Building C', 400000.00, 'Dr. Williams', '2010-09-01'),
(4, 'Civil Engineering', 'Building D', 600000.00, 'Dr. Brown', '2010-09-01');

-- Professors
INSERT INTO professors (professor_id, last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
(1, 'Wonder', 'Alice', 'alice.wonder@univ.edu', '123-456-7890', 1, '2015-08-15', 75000.00, 'Database Systems'),
(2, 'Builder', 'Bob', 'bob.builder@univ.edu', '123-456-7891', 1, '2016-09-01', 72000.00, 'Software Engineering'),
(3, 'Coder', 'Carol', 'carol.coder@univ.edu', '123-456-7892', 1, '2017-01-10', 70000.00, 'Artificial Intelligence'),
(4, 'Math', 'David', 'david.math@univ.edu', '123-456-7893', 2, '2014-08-20', 68000.00, 'Algebra'),
(5, 'Physics', 'Eva', 'eva.physics@univ.edu', '123-456-7894', 3, '2013-07-01', 71000.00, 'Quantum Mechanics'),
(6, 'Civil', 'Frank', 'frank.civil@univ.edu', '123-456-7895', 4, '2012-05-12', 73000.00, 'Structural Engineering');

-- Students
INSERT INTO students (student_id, student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
(1, 'S001', 'Doe', 'John', '2000-01-15', 'john.doe@student.univ', '111-222-3333', '123 Main St', 1, 'L3', '2023-09-01'),
(2, 'S002', 'Smith', 'Jane', '2001-03-20', 'jane.smith@student.univ', '111-222-3334', '456 Oak Ave', 1, 'M1', '2022-09-01'),
(3, 'S003', 'Johnson', 'Alice', '2002-07-10', 'alice.johnson@student.univ', '111-222-3335', '789 Pine Rd', 2, 'L2', '2024-09-01'),
(4, 'S004', 'Brown', 'Bob', '2000-11-05', 'bob.brown@student.univ', '111-222-3336', '321 Elm St', 2, 'L3', '2023-09-01'),
(5, 'S005', 'Davis', 'Charlie', '2001-09-12', 'charlie.davis@student.univ', '111-222-3337', '654 Maple Dr', 3, 'M1', '2022-09-01'),
(6, 'S006', 'Evans', 'Diana', '2003-02-28', 'diana.evans@student.univ', '111-222-3338', '987 Cedar Ln', 3, 'L2', '2024-09-01'),
(7, 'S007', 'Foster', 'Eve', '2000-04-18', 'eve.foster@student.univ', '111-222-3339', '147 Birch Blvd', 4, 'L3', '2023-09-01'),
(8, 'S008', 'Green', 'Frank', '2002-10-30', 'frank.green@student.univ', '111-222-3340', '258 Spruce Way', 4, 'L2', '2024-09-01');

-- Courses
INSERT INTO courses (course_id, course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
(1, 'CS101', 'Introduction to Programming', 'Basic programming concepts', 6, 1, 1, 1, 30),
(2, 'CS102', 'Data Structures', 'Advanced programming', 5, 2, 1, 2, 25),
(3, 'CS201', 'Database Systems', 'Relational databases', 6, 1, 1, 1, 30),
(4, 'MATH101', 'Calculus I', 'Limits and derivatives', 5, 1, 2, 4, 40),
(5, 'MATH201', 'Linear Algebra', 'Vectors and matrices', 5, 2, 2, 4, 35),
(6, 'PHY101', 'Classical Mechanics', 'Newtonian physics', 6, 1, 3, 5, 30),
(7, 'CIV101', 'Structural Analysis', 'Beams and trusses', 6, 2, 4, 6, 30);

-- Enrollments
INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, academic_year, status) VALUES
(1, 1, 1, '2024-09-01', '2024-2025', 'In Progress'),
(2, 1, 2, '2024-09-01', '2024-2025', 'In Progress'),
(3, 1, 3, '2024-09-01', '2024-2025', 'In Progress'),
(4, 2, 3, '2024-09-01', '2024-2025', 'In Progress'),
(5, 2, 4, '2024-09-01', '2024-2025', 'In Progress'),
(6, 2, 6, '2024-09-01', '2024-2025', 'In Progress'),
(7, 3, 4, '2024-09-01', '2024-2025', 'In Progress'),
(8, 3, 5, '2024-09-01', '2024-2025', 'In Progress'),
(9, 4, 4, '2024-09-01', '2024-2025', 'In Progress'),
(10, 4, 5, '2024-09-01', '2024-2025', 'In Progress'),
(11, 5, 6, '2024-09-01', '2024-2025', 'In Progress'),
(12, 5, 1, '2024-09-01', '2024-2025', 'In Progress'),
(13, 6, 6, '2024-09-01', '2024-2025', 'In Progress'),
(14, 7, 7, '2024-09-01', '2024-2025', 'In Progress'),
(15, 8, 7, '2024-09-01', '2024-2025', 'In Progress'),
(16, 1, 1, '2023-09-01', '2023-2024', 'Passed'),
(17, 1, 2, '2023-09-01', '2023-2024', 'Passed'),
(18, 2, 1, '2023-09-01', '2023-2024', 'Passed'),
(19, 2, 2, '2023-09-01', '2023-2024', 'Failed'),
(20, 3, 4, '2023-09-01', '2023-2024', 'Passed'),
(21, 4, 4, '2023-09-01', '2023-2024', 'Passed'),
(22, 5, 6, '2023-09-01', '2023-2024', 'Passed'),
(23, 7, 7, '2023-09-01', '2023-2024', 'Passed');

-- Grades
INSERT INTO grades (grade_id, enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 16, 'Exam', 15.00, 1.00, '2023-12-15', NULL),
(2, 16, 'Assignment', 17.00, 1.00, '2023-11-10', NULL),
(3, 17, 'Exam', 14.00, 1.00, '2023-12-20', NULL),
(4, 17, 'Lab', 16.00, 1.00, '2023-10-05', NULL),
(5, 18, 'Exam', 18.00, 1.00, '2023-12-15', NULL),
(6, 18, 'Project', 16.00, 1.00, '2023-11-30', NULL),
(7, 19, 'Exam', 8.00, 1.00, '2023-12-20', NULL),
(8, 19, 'Lab', 9.00, 1.00, '2023-10-05', NULL),
(9, 20, 'Exam', 12.00, 1.00, '2023-12-10', NULL),
(10, 20, 'Assignment', 14.00, 1.00, '2023-11-15', NULL),
(11, 21, 'Exam', 13.00, 1.00, '2023-12-10', NULL),
(12, 21, 'Assignment', 11.00, 1.00, '2023-11-15', NULL),
(13, 22, 'Exam', 16.00, 1.00, '2023-12-18', NULL),
(14, 22, 'Lab', 15.00, 1.00, '2023-11-20', NULL),
(15, 23, 'Exam', 17.00, 1.00, '2023-12-22', NULL),
(16, 23, 'Project', 18.00, 1.00, '2023-12-05', NULL);

-- 5. Solutions to the 30 queries


-- Q1. List all students with their main information
SELECT last_name, first_name, email, level FROM students;

-- Q2. Display all professors from the Computer Science department
SELECT last_name, first_name, email, specialization 
FROM professors 
WHERE department_id = 1;

-- Q3. Find all courses with more than 5 credits
SELECT course_code, course_name, credits 
FROM courses 
WHERE credits > 5;

-- Q4. List students enrolled in L3 level
SELECT student_number, last_name, first_name, email 
FROM students 
WHERE level = 'L3';

-- Q5. Display courses from semester 1
SELECT course_code, course_name, credits, semester 
FROM courses 
WHERE semester = 1;


-- Q6. Display all courses with the professor's name
SELECT c.course_code, c.course_name, CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7. List all enrollments with student name and course name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, 
       c.course_name, 
       e.enrollment_date, 
       e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q8. Display students with their department name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, 
       d.department_name, 
       s.level
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id;

-- Q9. List grades with student name, course name, and grade obtained
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, 
       c.course_name, 
       g.evaluation_type, 
       g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q10. Display professors with the number of courses they teach
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, 
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;


-- Q11. Calculate the overall average grade for each student
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, 
       AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q12. Count the number of students per department
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id;

-- Q13. Calculate the total budget of all departments
SELECT SUM(budget) AS total_budget FROM departments;

-- Q14. Find the total number of courses per department
SELECT d.department_name, COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id;

-- Q15. Calculate the average salary of professors per department
SELECT d.department_name, AVG(p.salary) AS average_salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id;


-- Q16. Find the top 3 students with the best averages
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, 
       AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;

-- Q17. List courses with no enrolled students
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18. Display students who have passed all their courses (status = 'Passed')
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, 
       COUNT(*) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id
HAVING COUNT(*) = (SELECT COUNT(*) FROM enrollments e2 WHERE e2.student_id = s.student_id);

-- Q19. Find professors who teach more than 2 courses
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, 
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20. List students enrolled in more than 2 courses
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, 
       COUNT(e.enrollment_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.enrollment_id) > 2;


-- Q21. Find students with an average higher than their department's average
WITH student_avg AS (
    SELECT s.student_id, s.department_id, 
           CONCAT(s.last_name, ' ', s.first_name) AS student_name,
           AVG(g.grade) AS student_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id
),
dept_avg AS (
    SELECT sa.department_id, AVG(sa.student_avg) AS dept_avg
    FROM student_avg sa
    GROUP BY sa.department_id
)
SELECT sa.student_name, sa.student_avg, da.dept_avg
FROM student_avg sa
JOIN dept_avg da ON sa.department_id = da.department_id
WHERE sa.student_avg > da.dept_avg;

-- Q22. List courses with more enrollments than the average number of enrollments
WITH course_enrollments AS (
    SELECT c.course_id, c.course_name, COUNT(e.enrollment_id) AS enrollment_count
    FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_id
),
avg_enrollments AS (
    SELECT AVG(enrollment_count) AS avg_count FROM course_enrollments
)
SELECT ce.course_name, ce.enrollment_count
FROM course_enrollments ce, avg_enrollments ae
WHERE ce.enrollment_count > ae.avg_count;

-- Q23. Display professors from the department with the highest budget
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, 
       d.department_name, 
       d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24. Find students with no grades recorded
SELECT CONCAT(last_name, ' ', first_name) AS student_name, email
FROM students s
WHERE NOT EXISTS (
    SELECT 1 FROM enrollments e 
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    WHERE e.student_id = s.student_id
);

-- Q25. List departments with more students than the average
WITH dept_counts AS (
    SELECT d.department_id, d.department_name, COUNT(s.student_id) AS student_count
    FROM departments d
    LEFT JOIN students s ON d.department_id = s.department_id
    GROUP BY d.department_id
),
avg_count AS (
    SELECT AVG(student_count) AS avg_students FROM dept_counts
)
SELECT dc.department_name, dc.student_count
FROM dept_counts dc, avg_count ac
WHERE dc.student_count > ac.avg_students;


-- Q26. Calculate the pass rate per course (grades >= 10/20)
SELECT c.course_name, 
       COUNT(g.grade_id) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       (SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(g.grade_id)) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- Q27. Display student ranking by descending average
SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) AS rank,
       CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC;

-- Q28. Generate a report card for student with student_id = 1
SELECT c.course_name, 
       g.evaluation_type, 
       g.grade, 
       g.coefficient, 
       (g.grade * g.coefficient) AS weighted_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_id = 1;

-- Q29. Calculate teaching load per professor (total credits taught)
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, 
       SUM(c.credits) AS total_credits
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
SELECT c.course_name, 
       COUNT(e.enrollment_id) AS current_enrollments, 
       c.max_capacity,
       (COUNT(e.enrollment_id) * 100.0 / c.max_capacity) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING percentage_full > 80;
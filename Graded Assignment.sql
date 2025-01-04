
CREATE TABLE Departments (
    department_id VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(50)
);
CREATE TABLE Employee_Details (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10),
    department_id VARCHAR(10),
    job_title VARCHAR(50),
    hire_date DATE,
    salary DECIMAL(10, 2),
    manager_id INT,
    location VARCHAR(50),
    performance_score VARCHAR(20),
    certifications VARCHAR(100),
    experience_years INT,
    shift VARCHAR(20),
    remarks TEXT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);
CREATE TABLE Attendance_Records (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    date DATE NOT NULL,
    check_in_time TIME,
    check_out_time TIME,
    total_hours DECIMAL(4, 2),
    location VARCHAR(50),
    shift VARCHAR(20),
    manager_id INT,
    overtime_hours DECIMAL(4, 2),
    days_present INT,
    days_absent INT,
    sick_leaves INT,
    vacation_leaves INT,
    late_check_ins INT,
    remarks TEXT,
    FOREIGN KEY (employee_id) REFERENCES Employee_Details(employee_id)
);
CREATE TABLE Project_Assignments (
    project_id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    project_status VARCHAR(50),
    client_name VARCHAR(100),
    budget DECIMAL(15, 2),
    team_size INT,
    manager_id INT,
    technologies_used VARCHAR(200),
    location VARCHAR(50),
    hours_worked DECIMAL(10, 2),
    milestones_achieved INT,
    risks_identified VARCHAR(200),
    FOREIGN KEY (employee_id) REFERENCES Employee_Details(employee_id)
);
INSERT INTO Departments (department_id, department_name)
VALUES ('DPT001', 'IT'),
       ('DPT002', 'Networks'),
       ('DPT003', 'Data Science'),
       ('DPT004', 'Cloud Solutions');

## 1. Employee productivity Analysis
SELECT e.employee_id, e.employee_name, a.total_hours, a.days_absent
FROM Employee_Details e
JOIN Attendance_Records a ON e.employee_id = a.employee_id
ORDER BY a.total_hours DESC, a.days_absent ASC
;

### 2. Departmental Training Impact
SELECT d.department_name, AVG(t.feedback_score) AS avg_feedback_score, AVG(e.performance_score) AS avg_performance_score
FROM Departments d
JOIN Employee_Details e ON d.department_id = e.department_id
JOIN Training t ON e.employee_id = t.employeeid
GROUP BY d.department_name
ORDER BY avg_feedback_score DESC;

##3. Project Budget Efficiency
SELECT p.project_id, p.project_name, p.budget, SUM(p.hours_worked) AS total_hours_worked,
       (p.budget / SUM(p.hours_worked)) AS cost_per_hour
FROM Project_Assignments p
GROUP BY p.project_id, p.project_name, p.budget
ORDER BY cost_per_hour ASC;

###4. Attendance Consistency
SELECT d.department_name, AVG(a.days_present) AS avg_days_present, AVG(a.days_absent) AS avg_days_absent
FROM Departments d
JOIN Employee_Details e ON d.department_id = e.department_id
JOIN Attendance_Records a ON e.employee_id = a.employee_id
GROUP BY d.department_name
ORDER BY avg_days_present DESC, avg_days_absent ASC;

###5. Training and Project Success Correlation
SELECT t.technologies_covered, p.project_name, SUM(p.milestones_achieved) AS milestones_achieved
FROM training t
JOIN Project_Assignments p ON FIND_IN_SET(t.technologies_covered, p.technologies_used) > 0
GROUP BY t.technologies_covered, p.project_name
ORDER BY milestones_achieved DESC;

###6. High-Impact Employees
SELECT e.employee_id, e.employee_name, p.project_name, p.budget, e.performance_score
FROM Employee_Details e
JOIN Project_Assignments p ON e.employee_id = p.employee_id
WHERE p.budget > 100000 AND e.performance_score = 'Excellent'
ORDER BY p.budget DESC;

###7. Cross-Analysis of Training and Project Success
SELECT e.employee_id, e.employee_name, t.technologies_covered, p.project_name, p.milestones_achieved
FROM Employee_Details e
JOIN training t ON e.employee_id = t.employeeid
JOIN Project_Assignments p ON e.employee_id = p.employee_id
WHERE FIND_IN_SET(t.technologies_covered, p.technologies_used) > 0
ORDER BY p.milestones_achieved DESC;

###8. Overall Insights into Training Costs
SELECT d.department_name, SUM(t.cost) AS total_training_cost
FROM Departments d
JOIN training t ON d.department_id = t.department_id
GROUP BY d.department_name
ORDER BY total_training_cost DESC;

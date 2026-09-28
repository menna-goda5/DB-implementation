CREATE TABLE campus (
    campus_id INT PRIMARY KEY,
    campus_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20)
);

CREATE TABLE department (
    dept_id INT PRIMARY KEY,
    dept_code VARCHAR(20) UNIQUE NOT NULL,
    dept_name VARCHAR(100) NOT NULL,
    campus_id INT REFERENCES campus(campus_id) ON DELETE SET NULL,
    head_faculty_id INT -- Foreign key for FACULTY table
);

CREATE TABLE faculty (
    faculty_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    rank VARCHAR(50),
    dept_id INT REFERENCES department(dept_id) ON DELETE SET NULL
);

-- Add Foreign Key for Department Head back to Department
ALTER TABLE department 
ADD CONSTRAINT fk_dept_head 
FOREIGN KEY (head_faculty_id) REFERENCES faculty(faculty_id) ON DELETE SET NULL;

CREATE TABLE program (
    program_id INT PRIMARY KEY,
    program_name VARCHAR(100) NOT NULL,
    level VARCHAR(50),
    duration_years INT,
    dept_id INT REFERENCES department(dept_id) ON DELETE CASCADE
);

CREATE TABLE student (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(20),
    enrollment_date DATE,
    program_id INT REFERENCES program(program_id) ON DELETE SET NULL,
    advisor_faculty_id INT REFERENCES faculty(faculty_id) ON DELETE SET NULL
);

CREATE TABLE student_campus_history (
    history_id INT PRIMARY KEY,
    student_id INT REFERENCES student(student_id) ON DELETE CASCADE,
    from_campus INT REFERENCES campus(campus_id) ON DELETE SET NULL,
    to_campus INT REFERENCES campus(campus_id) ON DELETE SET NULL,
    transfer_date DATE NOT NULL,
    reason VARCHAR(255)
);

CREATE TABLE classroom (
    classroom_id INT PRIMARY KEY,
    building VARCHAR(100) NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    capacity INT,
    room_type VARCHAR(50),
    campus_id INT REFERENCES campus(campus_id) ON DELETE CASCADE
);

CREATE TABLE time_slot (
    timeslot_id INT PRIMARY KEY,
    day_of_week VARCHAR(15) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL
);

CREATE TABLE course (
    course_id INT PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_title VARCHAR(150) NOT NULL,
    credit_hours INT NOT NULL,
    level VARCHAR(50),
    dept_id INT REFERENCES department(dept_id) ON DELETE CASCADE
);

CREATE TABLE course_offering (
    offering_id INT PRIMARY KEY,
    course_id INT REFERENCES course(course_id) ON DELETE CASCADE,
    semester VARCHAR(20) NOT NULL,
    academic_year INT NOT NULL,
    start_date DATE,
    end_date DATE,
    mode VARCHAR(50),
    classroom_id INT REFERENCES classroom(classroom_id) ON DELETE SET NULL,
    timeslot_id INT REFERENCES time_slot(timeslot_id) ON DELETE SET NULL
);

CREATE TABLE offering_instructor (
    offering_id INT REFERENCES course_offering(offering_id) ON DELETE CASCADE,
    faculty_id INT REFERENCES faculty(faculty_id) ON DELETE CASCADE,
    role VARCHAR(50),
    PRIMARY KEY (offering_id, faculty_id)
);

CREATE TABLE enrollment (
    enrollment_id INT PRIMARY KEY,
    student_id INT REFERENCES student(student_id) ON DELETE CASCADE,
    offering_id INT REFERENCES course_offering(offering_id) ON DELETE CASCADE,
    enroll_date DATE NOT NULL,
    status VARCHAR(50),
    final_grade VARCHAR(5),
    grade_date DATE
);





INSERT INTO campus (campus_id, campus_name, address, phone) VALUES
(1, 'Pharos', 'Smouha, Alexandria', '03-5550101'),
(2, 'Smart Village Campus', 'Cairo Alex Desert Rd', '02-3330202'),
(3, 'Technology Campus', 'Borg El Arab', '03-5550505');


INSERT INTO department (dept_id, dept_code, dept_name, campus_id) VALUES
(101, 'CS', 'Computer Science', 1),
(102, 'CYS', 'Cybersecurity', 1),
(103, 'AI', 'Artificial Intelligence', 2),
(104, 'SE', 'Software Engineering', 3);



INSERT INTO faculty (faculty_id, first_name, last_name, email, phone, rank, dept_id) VALUES
(1, 'Dr. Ahmed', 'Hassan', 'ahmed.hassan@univ.edu', '01011112222', 'Professor', 101),
(2, 'Dr. Sarah', 'El-Sayed', 'sarah.sayed@univ.edu', '01022223333', 'Associate Professor', 102),
(3, 'Dr. Mohamed', 'Ali', 'mohamed.ali@univ.edu', '01033334444', 'Assistant Professor', 103),
(4, 'Dr. Nour', 'Ibrahim', 'nour.ibrahim@univ.edu', '01044445555', 'Lecturer', 104);



UPDATE department SET head_faculty_id = 1 WHERE dept_id = 101;
UPDATE department SET head_faculty_id = 2 WHERE dept_id = 102;
UPDATE department SET head_faculty_id = 3 WHERE dept_id = 103;
UPDATE department SET head_faculty_id = 4 WHERE dept_id = 104;



INSERT INTO program (program_id, program_name, level, duration_years, dept_id) VALUES
(1, 'CS.Sc. Computer Science', 'Undergraduate', 4, 101),
(2, 'CYS.SC. Cybersecurity', 'Undergraduate', 4, 102),
(3, 'AI.Sc. Artificial Intelligence', 'Undergraduate', 4, 103),
(4, 'SE.Sc. Software Engineering', 'Postgraduate', 4, 104);


INSERT INTO student (student_id, first_name, last_name, email, phone, date_of_birth, gender, enrollment_date, program_id, advisor_faculty_id) VALUES
(201, 'Menna', 'Mahmoud', 'menna.m@student.univ.edu', '01112345678', '2006-10-15', 'Female', '2023-09-01', 2, 2),
(202, 'Youssef', 'Ali', 'youssef.a@student.univ.edu', '01123456789', '2005-11-20', 'Male', '2022-09-01', 1, 1),
(203, 'Mariam', 'Mohamed', 'mariam.m@student.univ.edu', '01134567890', '2006-09-09', 'Female', '2023-09-01', 1, 1),
(204, 'Mai', 'Ahmed', 'mai.a@student.univ.edu', '01145678901', '2003-08-25', 'Female', '2022-09-01', 3, 3),
(205, 'Hana', 'Tarek', 'hana.t@student.univ.edu', '01156789012', '2001-01-30', 'Female', '2024-01-15', 4, 4);


INSERT INTO student_campus_history (history_id, student_id, from_campus, to_campus, transfer_date, reason) VALUES
(1, 204, 1, 2, '2023-10-15', 'Closer to AI Labs'),
(2, 205, 1, 3, '2024-03-01', 'Postgraduate Research Facility');


INSERT INTO classroom (classroom_id, building, room_number, capacity, room_type, campus_id) VALUES
(301, 'Building A', 'A-101', 120, 'CS Lecture', 1),
(302, 'Building B', 'B-204', 20, 'CS Lab', 1),
(303, 'Building C', 'C-301', 125, 'CYS Lecture', 1),
(304, 'Building A', 'E-102', 100, 'AI Lab', 2),
(305, 'Building E', 'T-402', 25, 'Seminar Room', 3);

INSERT INTO time_slot (timeslot_id, day_of_week, start_time, end_time) VALUES
(1, 'Sunday', '08:30:00', '10:30:00'),
(2, 'Sunday', '10:35:00', '12:30:00'),
(3, 'Monday', '14:30:00', '16:30:00'),
(4, 'Tuesday', '12:00:00', '13:30:00'),
(5, 'Wednesday', '14:00:00', '16:00:00');

INSERT INTO course (course_id, course_code, course_title, credit_hours, level, dept_id) VALUES
(401, 'CS101', 'Introduction to Programming', 3, 'Level 100', 101),
(402, 'CYS301', 'Network Security & Defense', 3, 'Level 300', 102),
(403, 'AI201', 'Machine Learning Fundamentals', 4, 'Level 200', 103),
(404, 'SE401', 'Software Architecture', 3, 'Level 400', 104),
(405, 'CYS302', 'Ethical Hacking', 3, 'Level 300', 102);

INSERT INTO course_offering (offering_id, course_id, semester, academic_year, start_date, end_date, mode, classroom_id, timeslot_id) VALUES
(501, 401, 'Fall', 2026, '2026-10-01', '2027-01-25', 'In-Person', 301, 1),
(502, 402, 'Fall', 2026, '2026-10-01', '2027-01-25', 'In-Person', 302, 2),
(503, 403, 'Fall', 2026, '2026-10-01', '2027-01-25', 'Hybrid', 303, 3),
(504, 404, 'Spring', 2026, '2026-02-10', '2026-06-01', 'In-Person', 304, 4),
(505, 405, 'Spring', 2026, '2026-02-10', '2026-06-01', 'Online', 302, 5);

INSERT INTO offering_instructor (offering_id, faculty_id, role) VALUES
(501, 1, 'Lead Instructor'),
(502, 2, 'Lead Instructor'),
(503, 3, 'Lead Instructor'),
(504, 4, 'Lead Instructor'),
(505, 2, 'Lead Instructor');

INSERT INTO enrollment (enrollment_id, student_id, offering_id, enroll_date, status, final_grade, grade_date) VALUES
(601, 201, 502, '2026-09-15', 'Enrolled', NULL, NULL),
(602, 202, 501, '2026-09-14', 'Enrolled', NULL, NULL),
(603, 203, 501, '2026-09-14', 'Enrolled', NULL, NULL),
(604, 204, 503, '2026-09-16', 'Enrolled', NULL, NULL),
(605, 205, 504, '2026-02-02', 'Completed', 'A', '2026-06-05');


---عايزة اعرض جدول الطلاب مع أسماء برامجهم والأقسام والمرشد الأكاديمي

SELECT 
    s.student_id, 
    s.first_name || ' ' || s.last_name AS student_name,
    p.program_name,
    d.dept_name,
    f.first_name || ' ' || f.last_name AS advisor_name
FROM student s
JOIN program p ON s.program_id = p.program_id
JOIN department d ON p.dept_id = d.dept_id
LEFT JOIN faculty f ON s.advisor_faculty_id = f.faculty_id;


---عايزة اعرف الجدول الدراسي لكل طالب (المواد، المواعيد، القاعات، واسم الدكتور)

SELECT 
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_code,
    c.course_title,
    co.semester,
    ts.day_of_week,
    ts.start_time,
    cr.building || ' - ' || cr.room_number AS location,
    f.first_name || ' ' || f.last_name AS instructor
FROM enrollment e
JOIN student s ON e.student_id = s.student_id
JOIN course_offering co ON e.offering_id = co.offering_id
JOIN course c ON co.course_id = c.course_id
LEFT JOIN classroom cr ON co.classroom_id = cr.classroom_id
LEFT JOIN time_slot ts ON co.timeslot_id = ts.timeslot_id
LEFT JOIN offering_instructor oi ON co.offering_id = oi.offering_id
LEFT JOIN faculty f ON oi.faculty_id = f.faculty_id;


---عايزة اعرض تاريخ نقل الطلاب من فرع لفرع مع اسم المقر القديم والجديد

SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    c1.campus_name AS moved_from,
    c2.campus_name AS moved_to,
    h.transfer_date,
    h.reason
FROM student_campus_history h
JOIN student s ON h.student_id = s.student_id
JOIN campus c1 ON h.from_campus = c1.campus_id
JOIN campus c2 ON h.to_campus = c2.campus_id;



---عايزة ارصد درجات الطلاب وحساب نهاية الترم

UPDATE enrollment 
SET status = 'Completed', 
    final_grade = 'A+', 
    grade_date = CURRENT_DATE 
WHERE student_id = 201 AND offering_id = 502;

---عايزة اغير رئيس قسم السايبر (Cybersecurity Department)

UPDATE department 
SET head_faculty_id = 2 
WHERE dept_code = 'CYS';

---عشان احسب عدد الطلاب المسجلين في كل قسم

SELECT 
    d.dept_name, 
    COUNT(s.student_id) AS total_students
FROM department d
LEFT JOIN program p ON d.dept_id = p.dept_id
LEFT JOIN student s ON p.program_id = s.program_id
GROUP BY d.dept_name;

---عشان احسب عدد المواد المطروحة في كل فرع

SELECT 
    cam.campus_name, 
    COUNT(co.offering_id) AS total_offerings
FROM campus cam
JOIN classroom cl ON cam.campus_id = cl.campus_id
JOIN course_offering co ON cl.classroom_id = co.classroom_id
GROUP BY cam.campus_name;

---ابحث عن طالب باسم معين

SELECT * 
FROM student 
WHERE first_name = 'Menna';

---اعرض كل المواد التابعة لقسم معين

SELECT course_code, course_title, credit_hours 
FROM course 
WHERE dept_id = 102;

---استعراض قائمة دكاترة كلية معينة مع أرقام هواتفهم

SELECT first_name, last_name, email, phone 
FROM faculty 
WHERE dept_id = 101;

---اعرف القاعات الموجودة في مقر معين

SELECT building, room_number, capacity, room_type 
FROM classroom 
WHERE campus_id = 1;

---البحث عن المواد الأونلاين فقط

SELECT offering_id, course_id, semester, academic_year 
FROM course_offering 
WHERE mode = 'Online';

---اعرف الطلاب المقيدين في برنامج دراسي معين

SELECT student_id, first_name, last_name, email 
FROM student 
WHERE program_id = 4;

---البحث عن الطلاب المولودين بعد سنة معينة

SELECT student_id, first_name, last_name, date_of_birth 
FROM student 
WHERE date_of_birth > '2004-01-01';

---البحث عن الطلاب المولودين قبل سنة معينة

SELECT student_id, first_name, last_name, date_of_birth 
FROM student 
WHERE date_of_birth < '2004-01-01';

---عرض المواد التي عدد ساعاتها المعتمدة أكبر من 3

SELECT course_code, course_title, credit_hours 
FROM course 
WHERE credit_hours > 3;

---اعرف الطلاب الذين أنهوا موادهم بالفعل وحصلوا على تقدير (Final Grade)

SELECT student_id, offering_id, final_grade, grade_date 
FROM enrollment 
WHERE final_grade IS NOT NULL;

---اعرف المواعيد المسجلة يوم الأحد

SELECT timeslot_id, start_time, end_time 
FROM time_slot 
WHERE day_of_week = 'Sunday';

---البحث عن أعضاء هيئة التدريس برتبة أستاذ (Professor)

SELECT first_name, last_name, email, rank 
FROM faculty 
WHERE rank = 'Professor';

---اعرض أسباب نقل الطلاب بين الفروع

SELECT student_id, transfer_date, reason 
FROM student_campus_history;
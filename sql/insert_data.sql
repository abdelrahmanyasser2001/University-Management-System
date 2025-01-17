--INSERTING SAMPLE DATA INTO TABLES
-- Insert into DEPARTMENT
INSERT INTO DEPARTMENT (DEPARTMENT_ID, DEPARTMENT_NAME)
VALUES (1, 'Computer Science');
INSERT INTO DEPARTMENT (DEPARTMENT_ID, DEPARTMENT_NAME)
VALUES (2, 'Mathematics');
INSERT INTO DEPARTMENT (DEPARTMENT_ID, DEPARTMENT_NAME)
VALUES (3, 'Physics');

SELECT * FROM DEPARTMENT;

-- Insert into CLASSROOM
INSERT INTO CLASSROOM (CLASSROOM_ID, ROOM_NUMBER, CAPACITY, LOCATION)
VALUES (1, 'A101', 30, 'Building A');
INSERT INTO CLASSROOM (CLASSROOM_ID, ROOM_NUMBER, CAPACITY, LOCATION)
VALUES (2, 'B202', 50, 'Building B');
INSERT INTO CLASSROOM (CLASSROOM_ID, ROOM_NUMBER, CAPACITY, LOCATION)
VALUES (3, 'C303', 40, 'Building C');

SELECT * FROM CLASSROOM;

-- Insert into PROFESSOR
INSERT INTO PROFESSOR (PROFESSOR_ID, PROFESSOR_NAME, BIRTH_DATE, EMAIL, HIRE_DATE, PHONE_NUMBER, DEPARTMENT_ID)
VALUES (1, 'Dr. Smith', TO_DATE('1980-05-15', 'YYYY-MM-DD'), 'smith@example.com', TO_DATE('2010-08-01', 'YYYY-MM-DD'), 1234567890, 1);
INSERT INTO PROFESSOR (PROFESSOR_ID, PROFESSOR_NAME, BIRTH_DATE, EMAIL, HIRE_DATE, PHONE_NUMBER, DEPARTMENT_ID)
VALUES (2, 'Dr. Johnson', TO_DATE('1975-07-20', 'YYYY-MM-DD'), 'johnson@example.com', TO_DATE('2005-09-15', 'YYYY-MM-DD'), 9876543210, 2);

SELECT * FROM PROFESSOR;

-- Insert into STUDENT
-- Insert into COURSE
INSERT INTO COURSE (COURSE_ID, COURSE_NAME, CREDIT_HOURS, DEPARTMENT_ID)
VALUES (1, 'Database Systems', 3, 1);
INSERT INTO COURSE (COURSE_ID, COURSE_NAME, CREDIT_HOURS, DEPARTMENT_ID)
VALUES (2, 'Algorithms', 4, 1);
INSERT INTO COURSE (COURSE_ID, COURSE_NAME, CREDIT_HOURS, DEPARTMENT_ID)
VALUES (3, 'Linear Algebra', 3, 2);

SELECT * FROM COURSE;

-- Insert into ENROLLMENT
-- Insert into TEACH

-- Insert into COURSE_SCHEDULE
INSERT INTO COURSE_SCHEDULE (CS_ID, DAYOFWEEK, START_TIME, END_TIME, COURSE_ID, CLASSROOM_ID)
VALUES (1, 'Monday', TO_TIMESTAMP('09:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('10:30:00', 'HH24:MI:SS'), 1, 1);
INSERT INTO COURSE_SCHEDULE (CS_ID, DAYOFWEEK, START_TIME, END_TIME, COURSE_ID, CLASSROOM_ID)
VALUES (2, 'Wednesday', TO_TIMESTAMP('11:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('12:30:00', 'HH24:MI:SS'), 2, 2);

SELECT * FROM COURSE_SCHEDULE;


# University Management System Documentation

## 1. Project Overview

This project is a university management system designed to handle students, professors, courses, departments, enrollments, and course schedules. It includes features for managing student data, professor assignments, course enrollments, and academic performance, such as GPA calculation and grade assignment. The project leverages stored procedures, functions, triggers, and sequences to ensure data integrity, automate calculations, and enforce business rules.

---
### Features:
- Student Enrollment Management
- Course Scheduling and Assignment
- Professor Workload Tracking
- Department and Course Management
- Enrollment and Department Statistics
---
## 2. Database Schema
###  Database Schema Diagram

Here is the ERD (Entity-Relationship Diagram) for the University Management System:

![ERD](University-Management-System/uni schema.png)

The schema involves the following core tables:

- **STUDENT**: Stores student details.
- **COURSE**: Stores information about courses offered.
- **PROFESSOR**: Contains details about professors.
- **DEPARTMENT**: Holds information about departments.
- **ENROLLMENT**: Represents student enrollments in courses.
- **TEACH**: Links professors to courses they teach.
- **COURSE_SCHEDULE**: Stores the scheduling information of courses in classrooms.
- **CLASSROOM**: Represents available classrooms for courses.

The relationships between these entities ensure the system works seamlessly for academic management.

---
## Table Descriptions


**1. STUDENT:**

* Attributes: STUDENT_ID, STUDENT_NAME, EMAIL, BIRTH_DATE, CREDIT_HOURS, DEPARTMENT_ID

**2. PROFESSOR:**

* Attributes: PROFESSOR_ID, PROFESSOR_NAME, EMAIL, DEPARTMENT_ID

**3. COURSE:**

* Attributes: COURSE_ID, COURSE_NAME, CREDITS, DEPARTMENT_ID

**4. ENROLLMENT:**

* Attributes: ENROLLMENT_ID, START_DATE, END_DATE, STUDENT_ID, COURSE_ID, GRADE

**5. DEPARTMENT:**

* Attributes: DEPARTMENT_ID, DEPARTMENT_NAME

**6. TEACH:**

* Attributes: TEACH_ID, SEMESTER, YEAR, PROFESSOR_ID, COURSE_ID

**7. CLASSROOM:**

* Attributes: CLASSROOM_ID, CLASSROOM_NAME, CAPACITY

**8. COURSE_SCHEDULE:**

* Attributes: CS_ID, DAYOFWEEK, START_TIME, END_TIME, COURSE_ID, CLASSROOM_ID
---
## 3. Stored Procedures

### 3.1. `ADD_NEW_STUD`

**Purpose**: Adds a new student to the `STUDENT` table.

- **Input Parameters**:
  - `V_STUDENT_ID`: Student's unique ID.
  - `V_STUDENT_NAME`: Name of the student.
  - `V_EMAIL`: Email of the student.
  - `V_BIRTH_DATE`: Birth date of the student.
  - `V_DEPARTMENT_ID`: ID of the department to which the student belongs.

- **Process**:
  1. It checks if the department exists in the `DEPARTMENT` table.
  2. If the department exists, a new student is added to the `STUDENT` table with an initial `CREDIT_HOURS` value of 0.
  3. If the department does not exist, an error is raised.
  4. Upon successful insertion, a message confirming the student addition is output.

### 3.2. `ASSIGN_COURSE_TO_PROF`

**Purpose**: Assigns a professor to teach a course for a specific semester and year.

- **Input Parameters**:
  - `V_SEMESTER`: The semester during which the course is taught.
  - `V_YEAR`: The academic year.
  - `V_PROFESSOR_ID`: The professor's ID.
  - `V_COURSE_ID`: The ID of the course.

- **Process**:
  1. The procedure first checks if the professor and course exist in their respective tables (`PROFESSOR` and `COURSE`).
  2. If both exist, the course-professor assignment is made in the `TEACH` table.
  3. A confirmation message is printed once the assignment is complete.
  4. If the professor or course does not exist, an error is raised.

### 3.3. `ASSIGN_GRADE`

**Purpose**: Assigns or updates the grade for a student in a particular course.

- **Input Parameters**:
  - `V_ENROLLMENT_ID`: The enrollment ID for the student-course relationship.
  - `V_GRADE`: The grade to assign.

- **Process**:
  1. Checks if the enrollment exists in the `ENROLLMENT` table.
  2. Verifies that the course's `END_DATE` is not in the future (grade cannot be assigned until the course has ended).
  3. Updates the grade in the `ENROLLMENT` table.
  4. If the enrollment does not exist or the course has not ended, an error is raised.

### 3.4. `CAL_GPA`

**Purpose**: Calculates a student's GPA (Grade Point Average) based on completed courses.

- **Input Parameters**:
  - `V_STUDENT_ID`: The student's unique ID.
- **Output**:
  - `V_GPA`: The calculated GPA.

- **Process**:
  1. It calculates the total grade points by multiplying the grade in each course by the course's credit hours and sums the total credit hours.
  2. If the student has completed any courses, it calculates the GPA as the total grade points divided by the total credit hours.
  3. If no courses have been completed, the GPA is set to `NULL`.

### 3.5. `DEL_COURSE`

**Purpose**: Deletes a course along with its associated data from related tables.

- **Input Parameters**:
  - `V_COURSE_ID`: The course's unique ID.

- **Process**:
  1. The procedure first checks if the course exists in the `COURSE` table.
  2. It then deletes the course from the `COURSE`, `COURSE_SCHEDULE`, `ENROLLMENT`, and `TEACH` tables to maintain data integrity.
  3. If the course does not exist, an error is raised.

### 3.6. `ENROLL_STUDENT_COURSE`

**Purpose**: Enrolls a student in a course for a given time period.

- **Input Parameters**:
  - `V_START_DATE`: The start date of the course enrollment.
  - `V_END_DATE`: The end date of the course enrollment.
  - `V_STUDENT_ID`: The student's unique ID.
  - `V_COURSE_ID`: The course's unique ID.

- **Process**:
  1. It checks if both the student and the course exist.
  2. It ensures that the start date is not in the past.
  3. Enrolls the student in the course if all checks pass.
  4. If any condition fails, an appropriate error is raised.

### 3.7. `SCHEDULE_COURSE`

**Purpose**: Schedules a course in a classroom at a specific time.

- **Input Parameters**:
  - `V_DAYOFWEEK`: Day of the week the course is scheduled.
  - `V_START_TIME`: Start time for the class.
  - `V_END_TIME`: End time for the class.
  - `V_COURSE_ID`: The course's unique ID.
  - `V_CLASSROOM_ID`: The classroom's unique ID.

- **Process**:
  1. It ensures that both the course and the classroom exist.
  2. It checks that there is no conflict in the schedule (the classroom cannot be double-booked at the same time).
  3. If no conflict is found, the course schedule is added to the `COURSE_SCHEDULE` table.

### 3.8. `UPD_STD`

**Purpose**: Updates a student's personal details.

- **Input Parameters**:
  - `V_STUDENT_ID`: The student's unique ID.
  - `V_STUDENT_NAME`: The updated name of the student.
  - `V_EMAIL`: The updated email of the student.
  - `V_BIRTH_DATE`: The updated birth date.
  - `V_DEPARTMENT_ID`: The updated department ID.

- **Process**:
  1. It checks if the department exists before making any updates.
  2. If the student exists, the procedure updates the student's details in the `STUDENT` table.
  3. A message is printed confirming the update. If the student does not exist, an error is raised.

---

## 4. Sequences

4.1. **ENROLLMENT_ID_SEQ**:  
   This sequence is used to generate unique `ENROLLMENT_ID`s for the `ENROLLMENT` table, ensuring no duplicates in student-course enrollments.

4.2. **TEACH_ID_SEQ**:  
   This sequence is used for generating unique `TEACH_ID`s in the `TEACH` table, ensuring that each professor-course assignment is uniquely identifiable.

4.3. **CS_ID_SEQ**:  
   This sequence generates unique `CS_ID`s for the `COURSE_SCHEDULE` table to track each course's schedule separately.

---

## 5. Functions

### 5.1. `DEP_LOAD`

**Purpose**: Returns the number of students in a particular department.

- **Input**: `V_DEPARTMENT_ID`: Department ID.
- **Output**: Returns the number of students enrolled in that department.

### 5.2. `GET_STUDENT_COURSE_COUNT`

**Purpose**: Returns the number of courses a student is currently enrolled in.

- **Input**: `V_STUDENT_ID`: The student's unique ID.
- **Output**: Returns the count of courses the student is currently enrolled in.

### 5.3. `PROF_LOAD`

**Purpose**: Returns the number of courses a professor is currently teaching.

- **Input**: `V_PROFESSOR_ID`: The professor's unique ID.
- **Output**: Returns the number of courses assigned to the professor.

---

## 6. Triggers

### 6.1. `TRG_GRADE_CHECK`

**Purpose**: Ensures that only valid grades ('A', 'B', 'C', 'D', 'F') are assigned and prevents grade updates before the course end date.

- **Action**: Triggered before updating the `GRADE` in the `ENROLLMENT` table.
- **Logic**:
  1. If the grade is invalid (not A, B, C, D, or F), an error is raised.
  2. If the end date of the course is in the future, grade updates are not allowed.

### 6.2. `TRG_CGPA`

**Purpose**: Automatically recalculates the CGPA (Cumulative Grade Point Average) whenever a student's `CREDIT_HOURS` data changes.

- **Action**: Triggered before an insert or update on the `CREDIT_HOURS` column in the `STUDENT` table.
- **Logic**:
  1. Recalculates the GPA using the student's completed courses and updates the `CGPA` field accordingly.

### 6.3. `TRG_AUTO_ASSGIN_CH`

**Purpose**: Automatically updates a student's total `CREDIT_HOURS` when a grade is assigned.

- **Action**: Triggered after updating the `GRADE` in the `ENROLLMENT` table.
- **Logic**:
  1. If the grade is valid, it updates the student's total `CREDIT_HOURS` in the `STUDENT` table based on the course's credit hours.

---

## 7. Exception Handling

The system implements robust error handling in stored procedures, functions, and triggers to ensure smooth operation and prevent data integrity issues. Below are the custom error messages and the situations where they are triggered:

### Common Error Codes:

- **-20012**: Raised when a department does not exist in the system.
  - Example: In the `ADD_NEW_STUD` procedure, this error is raised if a student is being added to a non-existent department.
  
- **-20009**: Raised when a student does not exist.
  - Example: In the `GET_STUDENT_COURSE_COUNT` function, this error occurs if the provided student ID does not match any existing student.

- **-20008**: Raised when a professor does not exist.
  - Example: In the `ASSIGN_COURSE_TO_PROF` procedure, this error is raised if the professor ID does not exist.

- **-20010**: Raised when an invalid grade (outside the allowed 'A', 'B', 'C', 'D', 'F') is entered.
  - Example: Trigger `TRG_GRADE_CHECK` will throw this error when a grade that is not in the valid set is attempted to be assigned.

- **-20011**: Raised when attempting to update a grade before the course's end date.
  - Example: Trigger `TRG_GRADE_CHECK` will trigger this error if an attempt is made to update a grade before the `END_DATE` of the course.

### Error Handling in Triggers:

- **TRG_GRADE_CHECK**: This trigger checks whether a grade is valid and whether the grade can be updated. It raises an error if the grade is invalid or if the course's end date has not yet passed.

- **TRG_CGPA**: This trigger ensures that the CGPA is recalculated automatically when the `CREDIT_HOURS` for a student change. It raises an error if there is any inconsistency during the GPA calculation.

By handling these exceptions, the system ensures that only valid operations are performed, protecting the integrity of the academic data.


## 8. Example Usage

### Example 1: Adding a New Student
```sql
BEGIN
    ADD_NEW_STUD(1001, 'John Doe', 'john.doe@example.com', TO_DATE('1998-05-15', 'YYYY-MM-DD'), 10);
END;
```

### Example 2: Assigning a Professor to a Course
```sql
BEGIN
    ASSIGN_COURSE_TO_PROF('Fall', 2025, 101, 301);
END;
```
### Example 3: Enrolling a Student in a Course
```sql
BEGIN
    ENROLL_STUDENT_COURSE(TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-06-01', 'YYYY-MM-DD'), 1001, 301);
END;
```


## 9. Conclusion

The **University Management System** effectively manages the academic data for students, professors, courses, enrollments, and departments. The system utilizes a combination of **stored procedures**, **functions**, **triggers**, and **sequences** to ensure data consistency, automate tasks, and enforce business rules, significantly improving the overall management process.

Key features include:

- **Stored Procedures**: Automate repetitive tasks such as adding new students, assigning courses to professors, and updating grades.
- **Functions**: Simplify complex queries such as calculating the number of students in a department or counting a student’s enrolled courses.
- **Triggers**: Enforce business rules such as valid grade entry, recalculating CGPA when credits change, and updating student credit hours after course completion.
- **Sequences**: Ensure that unique IDs are generated for students, enrollments, and course schedules.

The project helps universities streamline their academic processes, from managing enrollments to calculating GPAs and enforcing grade constraints. With automated calculations and error handling, it minimizes human error, ensures consistency, and saves time for both students and administrators.

By integrating these advanced database features, this system creates an efficient and scalable solution for university management, ensuring smooth operation and compliance with academic regulations.

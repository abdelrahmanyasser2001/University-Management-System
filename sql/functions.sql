/*
Retrieve Professor Workload
Calculate the total number of courses a professor is teaching in a semester.
*/

CREATE OR REPLACE FUNCTION PROF_LOAD(V_PROFESSOR_ID  PROFESSOR.PROFESSOR_ID%TYPE)
RETURN NUMBER IS
V_COUNT NUMBER := 0;
V_PROF_EXISTS NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO V_PROF_EXISTS
    FROM PROFESSOR
    WHERE PROFESSOR_ID = V_PROFESSOR_ID;

    IF V_PROF_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20008,'PROFESSOR DOES NOT EXIST!');
    END IF;

    SELECT COUNT(*)
    INTO V_COUNT
    FROM TEACH
    WHERE PROFESSOR_ID = V_PROFESSOR_ID;
    
    RETURN V_COUNT;
END;

SELECT PROF_LOAD(2) FROM DUAL;


/*
Get student count
return the total number of students in department
*/

CREATE OR REPLACE FUNCTION DEP_LOAD(V_DEPARTMENT_ID  DEPARTMENT.DEPARTMENT_ID%TYPE)
RETURN NUMBER IS
V_COUNT NUMBER := 0;
V_DEPARTMENT_EXISTS NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO V_DEPARTMENT_EXISTS
    FROM DEPARTMENT
    WHERE DEPARTMENT_ID = V_DEPARTMENT_ID;

    IF V_DEPARTMENT_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20012,'DEPARTMENT DOES NOT EXIST!');
    END IF;

    SELECT COUNT(*)
    INTO V_COUNT
    FROM STUDENT
    WHERE DEPARTMENT_ID = V_DEPARTMENT_ID;
    
    RETURN V_COUNT;
END;

SELECT DEP_LOAD(1) FROM DUAL;


/*
Get Student Enrollment Count
Return the total number of courses a student is currently enrolled in.
*/

CREATE OR REPLACE FUNCTION GET_STUDENT_COURSE_COUNT(V_STUDENT_ID    STUDENT.STUDENT_ID%TYPE)
RETURN NUMBER IS
V_COUNT NUMBER := 0;
V_STUDENT_EXISTS NUMBER := 0 ;
BEGIN
    SELECT COUNT(*)
    INTO V_STUDENT_EXISTS
    FROM STUDENT
    WHERE STUDENT_ID = V_STUDENT_ID;

    IF V_STUDENT_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20009, 'STUDENT DOES NOT EXIST!');
    END IF;

    SELECT COUNT(*)
    INTO V_COUNT
    FROM ENROLLMENT
    WHERE STUDENT_ID = V_STUDENT_ID AND
    SYSDATE BETWEEN START_DATE AND END_DATE;
    
    RETURN V_COUNT;
END;

SELECT GET_STUDENT_COURSE_COUNT(2) FROM DUAL;


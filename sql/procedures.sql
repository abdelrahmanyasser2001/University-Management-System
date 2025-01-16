CREATE OR REPLACE PROCEDURE CAL_GPA (
    V_STUDENT_ID IN     STUDENT.STUDENT_ID%TYPE,
    V_GPA        OUT    STUDENT.CGPA%TYPE
) IS

    V_TOTAL_GRADE_POINTS  NUMBER :=0 ;
    V_TOTAL_CREDIT_HOURS  NUMBER :=0 ;
BEGIN

    SELECT SUM(E.GRADE * C.CREDIT_HOURS), SUM(C.CREDIT_HOURS)
    INTO V_TOTAL_GRADE_POINTS , V_TOTAL_CREDIT_HOURS
    FROM ENROLLMENT E JOIN COURSE C 
    ON E.COURSE_ID = C.COURSE_ID
    WHERE E.STUDENT_ID =V_STUDENT_ID;

    IF V_TOTAL_CREDIT_HOURS > 0 THEN
        V_GPA := V_TOTAL_GRADE_POINTS / V_TOTAL_CREDIT_HOURS;
    ELSE
        V_GPA := NULL;
    END IF;
END;


/*
Register a New Student
Add a student to the database while ensuring their department exists.
*/

CREATE OR REPLACE PROCEDURE ADD_NEW_STUD (
    V_STUDENT_NAME  STUDENT.STUDENT_NAME%TYPE,
    V_EMAIL         STUDENT.EMAIL%TYPE,
    V_BIRTH_DATE    STUDENT.BIRTH_DATE%TYPE,
    V_DEPARTMENT_ID STUDENT.DEPARTMENT_ID%TYPE
    )IS
    V_DEPARTMENT_EXISTS NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO V_DEPARTMENT_EXISTS
    FROM DEPARTMENT
    WHERE DEPARTMENT_ID = V_DEPARTMENT_ID;

    IF V_DEPARTMENT_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20001,'DEPARTEMENT DOES NOT EXIST');
    END IF;

    INSERT INTO STUDENT (STUDENT_ID,STUDENT_NAME,EMAIL,BIRTH_DATE,CREDIT_HOURS,DEPARTMENT_ID)
    VALUES(STUDENT_ID_SEQ.NEXTVAL,V_STUDENT_NAME,V_EMAIL,V_BIRTH_DATE,0,V_DEPARTMENT_ID);

    DBMS_OUTPUT.PUT_LINE('STUDENT ADDED SUCCESSFULLY!');

END;



BEGIN
    ADD_NEW_STUD(
        V_STUDENT_NAME  => 'Emily Brown',
        V_EMAIL         => 'emily.brown@example.com',
        V_BIRTH_DATE    => TO_DATE('2003-08-15', 'YYYY-MM-DD'),
        V_DEPARTMENT_ID => 1
    );

    ADD_NEW_STUD(
        V_STUDENT_NAME  => 'James Carter',
        V_EMAIL         => 'james.carter@example.com',
        V_BIRTH_DATE    => TO_DATE('2002-12-05', 'YYYY-MM-DD'),
        V_DEPARTMENT_ID => 2 
    );

    ADD_NEW_STUD(
        V_STUDENT_NAME  => 'Sophia Miller',
        V_EMAIL         => 'sophia.miller@example.com',
        V_BIRTH_DATE    => TO_DATE('2001-03-22', 'YYYY-MM-DD'),
        V_DEPARTMENT_ID => 3 
    );

    ADD_NEW_STUD(
        V_STUDENT_NAME  => 'Liam Wilson',
        V_EMAIL         => 'liam.wilson@example.com',
        V_BIRTH_DATE    => TO_DATE('2004-10-11', 'YYYY-MM-DD'),
        V_DEPARTMENT_ID => 1
    );

    ADD_NEW_STUD(
        V_STUDENT_NAME  => 'Olivia Davis',
        V_EMAIL         => 'olivia.davis@example.com',
        V_BIRTH_DATE    => TO_DATE('2000-07-30', 'YYYY-MM-DD'),
        V_DEPARTMENT_ID => 2 
    );
END;

SELECT * FROM STUDENT;



/*
Update student data
*/

CREATE OR REPLACE PROCEDURE UPD_STD(
    V_STUDENT_ID    STUDENT.STUDENT_ID%TYPE,
    V_STUDENT_NAME  STUDENT.STUDENT_NAME%TYPE,
    V_EMAIL         STUDENT.EMAIL%TYPE,
    V_BIRTH_DATE    STUDENT.BIRTH_DATE%TYPE,
    V_DEPARTMENT_ID STUDENT.DEPARTMENT_ID%TYPE
    ) IS
    V_DEPARTMENT_EXISTS NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO V_DEPARTMENT_EXISTS
    FROM DEPARTMENT
    WHERE DEPARTMENT_ID = V_DEPARTMENT_ID;

    IF V_DEPARTMENT_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'DEPARTMENT DOES NOT EXIST');
    END IF;

    UPDATE STUDENT
    SET 
        STUDENT_NAME = V_STUDENT_NAME,
        EMAIL = V_EMAIL,
        BIRTH_DATE = V_BIRTH_DATE,
        DEPARTMENT_ID = V_DEPARTMENT_ID
    WHERE STUDENT_ID = V_STUDENT_ID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'STUDENT NOT FOUND');
    END IF;

    DBMS_OUTPUT.PUT_LINE('STUDENT DATA UPDATED SUCCESSFULLY!');

END;

SELECT * FROM STUDENT;

BEGIN
    UPD_STD(
        V_STUDENT_ID    => 2,
        V_STUDENT_NAME  => 'George Wassouf',
        V_EMAIL         => 'George Wassouf@example.com',
        V_BIRTH_DATE    => TO_DATE('2001-4-01', 'YYYY-MM-DD'),
        V_DEPARTMENT_ID => 1
    );
END;



/*
Assign a Professor to a Course
Link a professor to a course, ensuring both entities exist.
*/

DESCRIBE TEACH;

CREATE OR REPLACE PROCEDURE ASSIGN_COURSE_TO_PROD(
    V_SEMESTER      TEACH.SEMESTER%TYPE,
    V_YEAR          TEACH.YEAR%TYPE,
    V_PROFESSOR_ID  TEACH.PROFESSOR_ID%TYPE,
    V_COURSE_ID     TEACH.COURSE_ID%TYPE          
    ) IS
    V_PROF_EXISTS NUMBER := 0;
    V_COURSE_EXISTS NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO V_PROF_EXISTS
    FROM PROFESSOR
    WHERE PROFESSOR_ID = V_PROFESSOR_ID;

    IF V_PROF_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20001,'PROFESSOR DOES NOT EXIST');
    END IF;

    SELECT COUNT(*)
    INTO V_COURSE_EXISTS
    FROM COURSE
    WHERE COURSE_ID = V_COURSE_ID;

    IF V_COURSE_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20002,'COURSE DOES NOT EXIST');
    END IF;

    INSERT INTO TEACH (TEACH_ID,SEMESTER , YEAR , PROFESSOR_ID , COURSE_ID)
    VALUES(TEACH_ID_SEQ.NEXTVAL,V_SEMESTER , V_YEAR , V_PROFESSOR_ID , V_COURSE_ID);

    DBMS_OUTPUT.PUT_LINE('PROFESSOR ASSIGNED TO COURSE SUCCESSFULLY!');

END;

BEGIN
    ASSIGN_COURSE_TO_PROD(
        V_SEMESTER     => 'Spring',
        V_YEAR         => 2025,
        V_PROFESSOR_ID => 1, 
        V_COURSE_ID    => 1  
    );

    ASSIGN_COURSE_TO_PROD(
        V_SEMESTER     => 'Fall',
        V_YEAR         => 2025,
        V_PROFESSOR_ID => 2, 
        V_COURSE_ID    => 2  
    );

    ASSIGN_COURSE_TO_PROD(
        V_SEMESTER     => 'Summer',
        V_YEAR         => 2025,
        V_PROFESSOR_ID => 1, 
        V_COURSE_ID    => 3  
    );

    ASSIGN_COURSE_TO_PROD(
        V_SEMESTER     => 'Spring',
        V_YEAR         => 2025,
        V_PROFESSOR_ID => 2,
        V_COURSE_ID    => 1  
    );

    ASSIGN_COURSE_TO_PROD(
        V_SEMESTER     => 'Fall',
        V_YEAR         => 2025,
        V_PROFESSOR_ID => 1, 
        V_COURSE_ID    => 2
    );
END;

SELECT * FROM TEACH;

/*
Schedule a Course
Add a schedule for a course in a specific classroom, ensuring no conflicts.
*/

DESCRIBE COURSE_SCHEDULE;

CREATE OR REPLACE PROCEDURE SCHEDULE_COURSE(
    V_DAYOFWEEK     COURSE_SCHEDULE.DAYOFWEEK%TYPE,
    V_START_TIME    COURSE_SCHEDULE.START_TIME%TYPE,
    V_END_TIME      COURSE_SCHEDULE.END_TIME%TYPE,
    V_COURSE_ID     COURSE_SCHEDULE.COURSE_ID%TYPE,
    V_CLASSROOM_ID  COURSE_SCHEDULE.CLASSROOM_ID%TYPE
    )IS
    V_COUNT   NUMBER;
    V_COURSE_EXISTS NUMBER := 0;
    V_CLASSROOM_EXISTS NUMBER := 0 ;
BEGIN
    SELECT COUNT(*)
    INTO V_COURSE_EXISTS
    FROM COURSE
    WHERE COURSE_ID = V_COURSE_ID;

    IF V_COURSE_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20002,'COURSE DOES NOT EXIST');
    END IF;

    SELECT COUNT(*)
    INTO V_CLASSROOM_EXISTS
    FROM CLASSROOM
    WHERE CLASSROOM_ID = V_CLASSROOM_ID;

    IF V_CLASSROOM_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20003,'CLASSROOM DOES NOT EXIST');
    END IF;

    SELECT COUNT(*) 
    INTO V_COUNT
    FROM COURSE_SCHEDULE WHERE 
    DAYOFWEEK = V_DAYOFWEEK AND 
    (
        (V_START_TIME BETWEEN START_TIME AND END_TIME) OR
        (V_END_TIME BETWEEN START_TIME AND END_TIME) OR
        (START_TIME BETWEEN V_START_TIME AND V_END_TIME)OR
        (END_TIME BETWEEN V_START_TIME AND V_END_TIME)
    );

    IF V_COUNT > 1 THEN
        RAISE_APPLICATION_ERROR(-20004,'Schedule conflict: Classroom is already booked at this time');
    END IF;

    INSERT INTO COURSE_SCHEDULE(CS_ID , DAYOFWEEK , START_TIME , END_TIME , COURSE_ID , CLASSROOM_ID)
    VALUES(CS_ID_SEQ.NEXTVAL , V_DAYOFWEEK , V_START_TIME , V_END_TIME , V_COURSE_ID , V_CLASSROOM_ID);

    DBMS_OUTPUT.PUT_LINE('COURSE SCHEDULE ADDED SUCCESSFULLY!');
END;

BEGIN
    SCHEDULE_COURSE(
        V_DAYOFWEEK     => 'Monday',
        V_START_TIME    => TO_DATE('08:00:00', 'HH24:MI:SS'),
        V_END_TIME      => TO_DATE('10:00:00', 'HH24:MI:SS'),
        V_COURSE_ID     => 1,
        V_CLASSROOM_ID  => 1
    );

    SCHEDULE_COURSE(
        V_DAYOFWEEK     => 'Tuesday',
        V_START_TIME    => TO_DATE('10:00:00', 'HH24:MI:SS'),
        V_END_TIME      => TO_DATE('12:00:00', 'HH24:MI:SS'),
        V_COURSE_ID     => 2,
        V_CLASSROOM_ID  => 2
    );

    SCHEDULE_COURSE(
        V_DAYOFWEEK     => 'Wednesday',
        V_START_TIME    => TO_DATE('13:00:00', 'HH24:MI:SS'),
        V_END_TIME      => TO_DATE('15:00:00', 'HH24:MI:SS'),
        V_COURSE_ID     => 3,
        V_CLASSROOM_ID  => 3
    );

    SCHEDULE_COURSE(
        V_DAYOFWEEK     => 'Thursday',
        V_START_TIME    => TO_DATE('09:00:00', 'HH24:MI:SS'),
        V_END_TIME      => TO_DATE('11:00:00', 'HH24:MI:SS'),
        V_COURSE_ID     => 1,
        V_CLASSROOM_ID  => 1
    );

    SCHEDULE_COURSE(
        V_DAYOFWEEK     => 'Friday',
        V_START_TIME    => TO_DATE('11:00:00', 'HH24:MI:SS'),
        V_END_TIME      => TO_DATE('13:00:00', 'HH24:MI:SS'),
        V_COURSE_ID     => 2,
        V_CLASSROOM_ID  => 2
    );

    DBMS_OUTPUT.PUT_LINE('Sample course schedules added successfully!');
END;

SELECT * FROM COURSE_SCHEDULE;


/*
Enroll a Student in a Course
Register a student for a course and update the enrollment table.
*/

CREATE OR REPLACE PROCEDURE ENROLL_STUDENT_COURSE(
    V_START_DATE    ENROLLMENT.START_DATE%TYPE,
    V_END_DATE      ENROLLMENT.END_DATE%TYPE,
    V_STUDENT_ID    ENROLLMENT.STUDENT_ID%TYPE,
    V_COURSE_ID     ENROLLMENT.COURSE_ID%TYPE

    ) IS
    V_STUDENT_EXISTS NUMBER := 0 ;
    V_COURSE_EXISTS  NUMBER := 0 ;
BEGIN
    SELECT COUNT(*)
    INTO V_STUDENT_EXISTS
    FROM STUDENT
    WHERE STUDENT_ID = V_STUDENT_ID;

    IF V_STUDENT_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20005 ,'STUDENT DOES NOT EXIST!');
    END IF;

    SELECT COUNT(*)
    INTO V_COURSE_EXISTS
    FROM COURSE
    WHERE COURSE_ID = V_COURSE_ID;
    
    IF V_COURSE_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20006,'COURSE DOES NOT EXIST!');
    END IF;

    IF V_START_DATE < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20007 ,'START DATE CAN NOT BE IN THE PAST!');
    END IF;

    INSERT INTO ENROLLMENT (ENROLLMENT_ID , START_DATE , END_DATE , STUDENT_ID , COURSE_ID , GRADE)
    VALUES (ENROLLMENT_ID_SEQ.NEXTVAL , V_START_DATE , V_END_DATE , V_STUDENT_ID , V_COURSE_ID , NULL);

    DBMS_OUTPUT.PUT_LINE('ENROLLMENT ADDED SUCCESSFULLY!');
END;

BEGIN
    ENROLL_STUDENT_COURSE(
        V_START_DATE => TO_DATE('2025-02-01', 'YYYY-MM-DD'),
        V_END_DATE   => TO_DATE('2025-05-01', 'YYYY-MM-DD'),
        V_STUDENT_ID => 1,
        V_COURSE_ID  => 1
    );

    ENROLL_STUDENT_COURSE(
        V_START_DATE => TO_DATE('2025-02-01', 'YYYY-MM-DD'),
        V_END_DATE   => TO_DATE('2025-05-01', 'YYYY-MM-DD'),
        V_STUDENT_ID => 1,
        V_COURSE_ID  => 2
    );

    ENROLL_STUDENT_COURSE(
        V_START_DATE => TO_DATE('2025-02-01', 'YYYY-MM-DD'),
        V_END_DATE   => TO_DATE('2025-05-01', 'YYYY-MM-DD'),
        V_STUDENT_ID => 2,
        V_COURSE_ID  => 1
    );

    ENROLL_STUDENT_COURSE(
        V_START_DATE => TO_DATE('2025-03-01', 'YYYY-MM-DD'),
        V_END_DATE   => TO_DATE('2025-06-01', 'YYYY-MM-DD'),
        V_STUDENT_ID => 2,
        V_COURSE_ID  => 3
    );

    ENROLL_STUDENT_COURSE(
        V_START_DATE => TO_DATE('2025-03-01', 'YYYY-MM-DD'),
        V_END_DATE   => TO_DATE('2025-06-01', 'YYYY-MM-DD'),
        V_STUDENT_ID => 3,
        V_COURSE_ID  => 2
    );

    ENROLL_STUDENT_COURSE(
        V_START_DATE => TO_DATE('2025-03-01', 'YYYY-MM-DD'),
        V_END_DATE   => TO_DATE('2025-06-01', 'YYYY-MM-DD'),
        V_STUDENT_ID => 3,
        V_COURSE_ID  => 3
    );

    ENROLL_STUDENT_COURSE(
        V_START_DATE => TO_DATE('2025-04-01', 'YYYY-MM-DD'),
        V_END_DATE   => TO_DATE('2025-07-01', 'YYYY-MM-DD'),
        V_STUDENT_ID => 4,
        V_COURSE_ID  => 1
    );

    ENROLL_STUDENT_COURSE(
        V_START_DATE => TO_DATE('2025-04-01', 'YYYY-MM-DD'),
        V_END_DATE   => TO_DATE('2025-07-01', 'YYYY-MM-DD'),
        V_STUDENT_ID => 4,
        V_COURSE_ID  => 2
    );

    ENROLL_STUDENT_COURSE(
        V_START_DATE => TO_DATE('2025-04-01', 'YYYY-MM-DD'),
        V_END_DATE   => TO_DATE('2025-07-01', 'YYYY-MM-DD'),
        V_STUDENT_ID => 5,
        V_COURSE_ID  => 2
    );

    ENROLL_STUDENT_COURSE(
        V_START_DATE => TO_DATE('2025-04-01', 'YYYY-MM-DD'),
        V_END_DATE   => TO_DATE('2025-07-01', 'YYYY-MM-DD'),
        V_STUDENT_ID => 5,
        V_COURSE_ID  => 3
    );
END;

SELECT * FROM ENROLLMENT;


/*
assign student's enrollment grade 
after enrollment end date update the enrollment table.
*/

CREATE OR REPLACE PROCEDURE ASSIGN_GRADE(
    V_ENROLLMENT_ID ENROLLMENT.ENROLLMENT_ID%TYPE,
    V_GRADE         ENROLLMENT.GRADE%TYPE
    )IS
    V_ENROLLMENT_EXISTS NUMBER :=0 ;
    V_END_DATE          DATE ;
BEGIN
    SELECT COUNT(*)
    INTO V_ENROLLMENT_EXISTS
    FROM ENROLLMENT
    WHERE ENROLLMENT_ID = V_ENROLLMENT_ID;

    SELECT END_DATE 
    INTO V_END_DATE
    FROM ENROLLMENT
    WHERE ENROLLMENT_ID = V_ENROLLMENT_ID;

    IF V_ENROLLMENT_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20006 ,'ENROLLMENT DOES NOT EXIST!');
    END IF;

    IF V_END_DATE < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20007 , 'ENROLLMENT END DATE DIDNT END YET!');
    END IF;

    UPDATE ENROLLMENT SET GRADE = V_GRADE WHERE ENROLLMENT_ID = V_ENROLLMENT_ID;
    DBMS_OUTPUT.PUT_LINE('GRADE UPDATED SUCCESSFULLY!');
END;


/*
Remove a Course
Delete a course and cascade updates to related tables like ENROLLMENT and TEACH.
*/

CREATE OR REPLACE PROCEDURE DEL_COURE(
    V_COURSE_ID     COURSE.COURSE_ID%TYPE
    ) IS
    V_COURSE_EXISTS NUMBER :=0;
BEGIN
    SELECT COUNT(*)
    INTO V_COURSE_EXISTS
    FROM COURSE
    WHERE COURSE_ID = V_COURSE_ID;
    
    IF V_COURSE_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20007,'COURSE DOES NOT EXIST!');
    END IF;

    DELETE FROM COURSE_SCHEDULE WHERE COURSE_ID = V_COURSE_ID ;
    DELETE FROM TEACH WHERE COURSE_ID = V_COURSE_ID ;
    DELETE FROM ENROLLMENT WHERE COURSE_ID = V_COURSE_ID;
    DELETE FROM COURSE WHERE COURSE_ID = V_COURSE_ID;

    DBMS_OUTPUT.PUT_LINE('COURSE DELETED SUCCESSFULLY!');
END;

BEGIN
    DEL_COURE(
        V_COURSE_ID => 3
    );
END;

SELECT * FROM COURSE;


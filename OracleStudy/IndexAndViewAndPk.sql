--1) 어제 만든 SCORE_STGR 테이블의 SNO 컬럼에 INDEX를 추가하세요.
CREATE INDEX SCORE_STGR
ON STUDENT(SNO);

SELECT *
    FROM SCORE_STGR;


--2) 어제 만든 ST_COURSEPF 테이블의 SNO, CNO, PNO 다중 컬럼에 INDEX를 추가하세요.
CREATE INDEX ST_COURSEPF
ON ST_COURSEPF(SNO, CNO, PNO);

SELECT *
    FROM ST_COURSEPF;
    
--뷰 이름은 자유
--1) 학생의 학점 4.5 만점으로 환산된 정보를 검색할 수 있는 뷰를 생성하세요.
CREATE OR REPLACE VIEW MYAVR(
    SNO,
    SNAME,
    TO_CHAR(AVR*(4.5/4.0),90.99)
    FROM STUDENT
    );



--2) 각 과목별 평균 점수를 검색할 수 있는 뷰를 생성하세요.
CREATE OR REPLACE VIEW V_AVG_SCORE(
    CNO,
    CNAME,
    MAJOR,
    AVG_AVR 
) AS (
    SELECT C.CNO
        , C.CNAME
        , ST.MAJOR
        , ROUND(AVG(ST.AVR), 2) AS AVG_AVR
        FROM COURSE C 
        JOIN SCORE SC ON C.CNO = SC.CNO
        JOIN STUDENT ST ON SC.SNO = ST.SNO
        GROUP BY C.CNO, C.CNAME, ST.MAJOR       
);

SELECT *
    FROM V_AVG_SCORE;
   


--3) 각 사원과 관리자의 이름을 검색할 수 있는 뷰를 생성하세요.
CREATE OR REPLACE VIEW COMPANY(
    ENO,
    MGR,
    MGR_NAME
    ENAME,
    JOB,
    HDATE
    
) AS (
    SELECT E.ENO
        ,E.MGR
        ,E.ENAME
        ,E.MGR
        ,E.JOB
        ,E.HDATE
        FROM EMP E
        JOIN EMP EM
        ON E.MGR = EM.ENO
        );

SELECT *
    FROM COMPANY;
    


--4) 각 과목별 기말고사 평가 등급(A~F)까지와 해당 학생 정보를 검색할 수 있는 뷰를 생성하세요.
CREATE OR REPLACE VIEW V_AVG_SCORE(
    CNO,
    CNAME,
    SNO,
    SNAME,
    MAJOR,
    AVG_GRADE
) AS (
    SELECT C.CNO,
        C.CNAME,
        SC.SNO,
        ST.SNAME,
        ST.MAJOR,
        CASE 
            WHEN AVG(SC.RESULT) >= 90 THEN 'A'
            WHEN AVG(SC.RESULT) >= 80 THEN 'B'
            WHEN AVG(SC.RESULT) >= 70 THEN 'C'
            WHEN AVG(SC.RESULT) >= 60 THEN 'D'
            ELSE 'F'
        END AS AVG_GRADE
    FROM COURSE C
    JOIN SCORE SC ON C.CNO = SC.CNO
    JOIN STUDENT ST ON SC.SNO = ST.SNO
    GROUP BY C.CNO, C.CNAME, SC.SNO, ST.SNAME, ST.MAJOR
);

--다른방법 
CREATE OR REPLACE VIEW V_AVG_SCORE(
    CNO, 
    CNAME,
    SNO,
    SNAME,
    MAJOR,
    GRADE
)
        AS(
        SELECT CNO,
        CNAME,
        SNO,
        SNAME,
        MAJOR,
        GRADE
            FROM SCORE
            JOIN COURSE ON SCORE.CNO = COURSE.CNO
            JOIN SCGRADE ON SCORE.RESULT BETWEEN SCGRADE.LOSCORE AND SCGRADE.HISCORE
            JOIN STUDENT ON SCORE.SNO = STUDENT.SNO
            );


SELECT *
    FROM V_AVG_SCORE;


--5) 물리학과 교수의 과목을 수강하는 학생의 명단을 검색할 뷰를 생성하세요.
CREATE OR REPLACE VIEW physics(
    CNO,
    CNAME,
    PNAME,
    SECTION,
    SNO,
    SNAME
) AS (
    SELECT C.CNO
        , C.CNAME
        , P.PNAME
        , P.SECTION
        , ST.SNO
        , ST.SNAME
        FROM COURSE C
        NATURAL JOIN STUDENT ST
        JOIN PROFESSOR P 
        ON SECTION LIKE '%물리%'
        GROUP BY C.CNO, C.CNAME, P.PNAME, P.SECTION, ST.SNO, ST.SNAME
    );

SELECT *
    FROM physics;
    


--1) 4.5 환산 평점이 가장 높은 3인의 학생을 검색하세요.
SELECT ROWNUM,
       AVG_AVR_4_5,
       SNAME
FROM (
    SELECT SNAME,
           ROUND(AVG(AVR*4.5/4),2) AS AVG_AVR_4_5 -- 4.5로 환산한 평점 계산
    FROM STUDENT 
    GROUP BY SNO, SNAME, AVR -- 학생별 평균 평점 계산
    ORDER BY AVG_AVR_4_5 DESC -- 내림차순 정렬
)
WHERE ROWNUM <= 3; -- 상위 3명의 학생 검색


--2) 기말고사 과목별 평균이 높은 3과목을 검색하세요.
    
SELECT ROWNUM,
       MAJOR,
       AVG_RESULT
FROM (
    SELECT S.MAJOR,
           ROUND(AVG(SC.RESULT),2) AS AVG_RESULT --기말 평균을 구한다 
    FROM STUDENT S
    JOIN SCORE SC ON S.SNO = SC.SNO
    GROUP BY S.MAJOR --학과를 그룹화 
    ORDER BY AVG_RESULT DESC --내림차순 
)
WHERE ROWNUM <= 3;



--3) 학과별, 학년별, 기말고사 평균이 순위 3까지를 검색하세요.(학과, 학년, 평균점수 검색)
SELECT ROWNUM,
       MAJOR,
       SYEAR,
       AVG_RESULT2
       
FROM (
    SELECT ST.MAJOR,
           ST.SYEAR,
           ROUND(AVG(SC.RESULT),2) AS AVG_RESULT2 --기말 평균을 구한다 
    FROM STUDENT ST
    JOIN SCORE SC ON ST.SNO = SC.SNO
    GROUP BY ST.MAJOR, ST.SYEAR
    ORDER BY AVG_RESULT2 DESC --내림차순 
)
WHERE ROWNUM <= 3;


--4) 기말고사 성적이 높은 과목을 담당하는 교수 3인을 검색하세요.(교수이름, 과목명, 평균점수 검색)
SELECT ROWNUM,
       CNAME,
       PNAME,
       AVG_RESULT3
FROM (
    SELECT C.CNAME,
           P.PNAME,
           ROUND(AVG(SC.RESULT),2) AS AVG_RESULT3
    FROM COURSE C
    JOIN SCORE SC ON C.CNO = SC.CNO
    JOIN PROFESSOR P ON C.PNO = P.PNO
    GROUP BY C.CNAME, P.PNAME
    ORDER BY AVG_RESULT3 DESC
)
WHERE ROWNUM <= 3;


--5) 교수별로 현재 수강중인 학생의 수를 검색하세요.
SELECT 
    P.PNO,
    P.PNAME,
    C.CNO,
    C.CNAME,
    COUNT(*) AS SNUM 
    FROM PROFESSOR P
    JOIN COURSE C ON P.PNO = C.PNO
    JOIN SCORE SC ON SC.CNO = C.CNO
    GROUP BY P.PNO, P.PNAME, C.CNO, C.CNAME;


--1) CNO이 PK인 COURSE_PK 테이블을 생성하세요.(1번 방식으로)
CREATE TABLE COURSE_PK3(
    CNO NUMBER PRIMARY KEY
);

--2) PNO이 PK인 PROFESSOR_PK 테이블을 생성하세요.(2번 방식으로)
CREATE TABLE PROFESSOR_PK(
    PNO NUMBER,
    PNAME VARCHAR2(20),
    SSECTION VARCHAR2(10),
    HIREDATE DATE,
    CONSTRAINT PROFESSOR_PK PRIMARY KEY(PNO)
);


--3) PF_TEMP 테이블에 PNO을 PK로 추가하세요.
ALTER TABLE PF_TEMP
    ADD CONSTRAINT PF_TEMP PRIMARY KEY(PNO);


--4) COURSE_PROFESSOR 테이블에 CNO, PNO을 PK로 추가하세요.

ALTER TABLE COURSE_PROFESSOR
    DROP PRIMARY KEY;

ALTER TABLE COURSE_PROFESSOR    
    ADD CONSTRAINT COURSE_PROFESSOR PRIMARY KEY(CNO, PNO);


--5) BOARD_NO(NUMBER)를 PK로 갖으면서 BOARD_TITLE(VARCHAR2(200)), BOARD_CONTENT(VARCHAR2(2000)), 
--   BOARD_WRITER(VARCHAR2(20)), BOARD_FRGT_DATE(DATE), BOARD_LMDF_DATE(DATE) 컬럼을 갖는 T_BOARD 테이블을 생성하세요.
DROP TABLE T_BOARD;

CREATE TABLE T_BOARD(
    BOARD_NO NUMBER,
    BOARD_TITLE VARCHAR2(200),
    BOARD_CONTENT VARCHAR2(2000),
    BOARD_WRITER VARCHAR2(20),
    BOARD_FRGT_DATE DATE,
    BOARD_LMDF_DATE DATE
);



--6) BOARD_NO(NUMBER), BOARD_FILE_NO(NUMBER)를 PK로 갖으면서 BOARD_FILE_NM(VARCHAR2(200)), BOARD_FILE_PATH(VARCHAR2(2000)),
--   ORIGIN_FILE_NM(VARCHAR2(200)) 컬럼을 갖는 T_BOARD_FILE 테이블을 생성하세요.
CREATE TABLE T_BOARD_FILE(
    BOARD_NO NUMBER,
    BOARD_FILE_NO NUMBER,
    BOARD_FILE_NM VARCHAR2(200),
    BOARD_FILE_PATH VARCHAR2(2000),
    ORIGIN_FILE_NM VARCHAR2(200)
);



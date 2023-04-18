--1. DML
--1-1. INSERT INTO
--일부 컬럼만 데이터를 저장 
INSERT INTO EMP(ENO, ENAME, JOB, HDATE, SAL)
VALUES(3006, '홍길동', '개발', SYSDATE, 3000);
--실행하면 1행이 삽입되었습니다 라고 나온다. 그 뒤에는 커밋을 해줘야함!
COMMIT;
--COMMIT 직접 입력안하고 그냥 위에 버튼 눌러도 가능. 

--모든 컬럼의 데이터를 저장
INSERT INTO EMP
--부서번호는 '' 잊지말자 
VALUES('3007', '임꺽정', '설계', '2008', SYSDATE, 3000, 200, '30');
COMMIT;

--COMMIT, ROLLBACK
--COMMIT은 작업의 완료
--ROLLBACK은 작업의 취소, COMMIT되기 전의 변경사항을 모두 취소. 

INSERT INTO EMP
VALUES('3008', '장길산1', '분석', '2008', SYSDATE, 3000, 100, '20');
INSERT INTO EMP
VALUES('3009', '장길산2', '분석', '2008', SYSDATE, 3000, 100, '20');
INSERT INTO EMP
VALUES('3010', '장길산3', '분석', '2008', SYSDATE, 3000, 100, '20');
INSERT INTO EMP
VALUES('3011', '장길산4', '분석', '2008', SYSDATE, 3000, 1100, '20');
ROLLBACK;

--1-2. INSERT INTO 다량의 데이터 한 번에 저장
Create TABLE EMP_COPY2(
    ENO VARCHAR2(4),
    ENAME VARCHAR2(20), 
    JOB VARCHAR2(10),
    MGR VARCHAR2(4),
    HDATE DATE,
    SAL NUMBER(5),
    COMM NUMBER(5),
    DNO VARCHAR2(2)
);

--EMP 테이블에서 DNO이 30인 데이터들만 가져와서 저장
INSERT INTO EMP_COPY2
SELECT *
    FROM EMP
    WHERE DNO = '30';
COMMIT;


--COURSE_PROFESS 테이블 
CREATE TABLE COURSE_PROFESS1(
    CNO VARCHAR2(8),
    CNAME VARCHAR2(20),
    ST_NUM NUMBER(1, 0),
    PNO VARCHAR2(8),
    PNAME VARCHAR2(20)
);


--COURSE, PROFESSOR 조인해서 PNAME까지 저장
INSERT INTO COURSE_PROFESS1
SELECT C.CNO
    , C.CNAME
    , C.ST_NUM
    , PNO
    , P.PNAME
    FROM COURSE C
    LEFT JOIN PROFESSOR P; 
COMMIT;
    



SELECT *
    FROM COURSE_PROFESS1;
    
--데이터를 삭제하는 DELETE FROM
DELETE FROM COURSE_PROFESS1;

--1-3. UPDATE SET
--전체 데이터 수정
UPDATE EMP_COPY2
    SET 
        MGR = '0001';
        
ROLLBACK;
        
SELECT *
    FROM EMP_COPY2;
        
--사원번호 3005번 보너스 1800으로 수정 
UPDATE EMP_COPY2
    SET
        COMM = 1800
    WHERE ENO = '3005';
    
--사원번호 3005번 보너스 1800으로 수정(연산사용)
UPDATE EMP_COPY2
    SET
        COMM = COMM * 3
    WHERE ENO = '3005';


--PROFESSOR 테이블의 HIREDATE를 + 20년 해서 업데이트
UPDATE PROFESSOR
SET HIREDATE = ADD_MONTHS(HIREDATE, 240);

SELECT *
    FROM PROFESSOR;

--이미 커밋을 했으면 롤백을 해도 추가된 데이터가 전으로 돌아가지 않는다 
--그럴땐 delete로 삭제해줘야함
--수정하고 싶을땐 커밋하기 전에 롤백을 해줘야함


--EMP_COPY의 데이터 삭제
DELETE FROM EMP_COPY2;


--EMP의 전체 데이터를 EMP_COPY에 저장
INSERT INTO EMP_COPY2
SELECT * FROM EMP;

SELECT * FROM EMP_COPY2;


--20, 30번 부서 사원들 60부서로 통합 보너스가 현재 보너스의 * 1.5 
UPDATE EMP_COPY2
    SET
        DNO = '60',
        COMM = COMM * 1.5
    WHERE DNO IN ('20', '30');
    
--DEPT_COPY 테이블 생성
CREATE TABLE DEPT_COPY2
    AS SELECT * FROM DEPT;
    
SELECT * 
    FROM DEPT_COPY2;
    
--서브쿼리를 이용한 데이터 수정
UPDATE DEPT_COPY2
    SET
        (DNO, DNAME) = (
                        SELECT DNO
                            , DNAME
                            FROM DEPT
                            WHERE DNO = '50'
                            )
    WHERE DNO IN ('20', '30');

--40번 부서의 DIRECTOR를 EMP테이블의 급여가 제일 높은 사원으로 업데이트
UPDATE DEPT_COPY2
    SET
        DIRECTOR = (
                SELECT ENO
                FROM EMP
                WHERE SAL = (
                            SELECT MAX(SAL)
                            FROM EMP
                    )
            )
    WHERE DNO = '40';

SELECT * FROM DEPT_COPY2;

--1-4. DELETE FROM
--전체 데이터 삭제 => 조건절 생략
DELETE FROM EMP_COPY2;

SELECT * FROM EMP_COPY2;

--일부 데이터만 삭제 => where절로 조건 추가 
DELETE FROM EMP_COPY2
WHERE JOB = '지원';

--WHERE 절에 서브쿼리를 사용하여 특정 데이터 삭제
--EMP_COPY2에서 급여가 4000이상되는 사원 정보 삭제
DELETE FROM EMP_COPY2
WHERE ENO IN (
            SELECT ENO
                FROM EMP_COPY2
                WHERE SAL >= 4000
            );


--STUDENT 테이블 참조하여 ST_COPY 테이블 생성
CREATE TABLE ST_COPY
        AS SELECT * FROM STUDENT;
        


--SCORE 학생별 기말고사 성적 평균이 60이상인 학생정보 ST_COPY에서 삭제 
DELETE FROM ST_COPY
--매핑될 값 똑같이 지정할것 
WHERE SNO in (
        SELECT SNO
        FROM SCORE
        GROUP BY SNO
        HAVING AVG(RESULT) >= 60
        );
        
--사라진값 확인         
SELECT *
    FROM ST_COPY
    WHERE SNO IN ('915301', '935602');

--1-5. LOCK
--수정후 트랜잭션 완료 안
UPDATE EMP_COPY2
    SET ENAME = 'rrr'
    WHERE DNO = '60';
    
SELECT * FROM EMP_COPY2;

--select deadlock 구문(데이터가 많을 경우)
SELECT A.*
    , B.*
    , C.*
    FROM STUDENT A,
        SCORE B,
        PROFESSOR C;




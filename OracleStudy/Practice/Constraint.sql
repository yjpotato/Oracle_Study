--1) SCORE 테이블과 동일한 구조를 갖는 SCORE_CHK를 생성하고 RESULT 60이상 90이하만 입력 가능하도록 하세요.
-- SCORE_CHK 테이블 생성
--CHECK 조건 따지기 
CREATE TABLE SCORE_CHK(
    SNO NUMBER,
    CNO NUMBER,
    RESULT NUMBER CHECK(RESULT BETWEEN 60 AND 90)
    
);

INSERT INTO SCORE_CHK VALUES(1,1,70);
INSERT INTO SCORE_CHK VALUES(2,2,50);
INSERT INTO SCORE_CHK VALUES(3,1,80);
INSERT INTO SCORE_CHK VALUES(4,1,90); 

SELECT *
    FROM SCORE_CHK;
  


--2) STUDENT 테이블과 동일한 구조를 갖는 STUDENT_COPY 테이블을 생성하면서 SNO은 PK로 SNAME은 NOT NULL로 SYEAR의 DEFAULT는 1로 
--   설정하세요.
--NOT NULL 널값이 있으면 안된다. 널값이 들어오면 오류 
CREATE TABLE STUDENT_COPY(
        SNO NUMBER PRIMARY KEY, 
        SNAME VARCHAR2(20) NOT NULL,
        SEX VARCHAR2(3),
        SYEAR NUMBER DEFAULT 1,
        MAJOR VARCHAR2(20),
        AVR NUMBER
);

SELECT *
    FROM STUDENT_COPY;

--3) COURSE 테이블과 동일한 구조를 갖는 COURSE_CONTSRAINT 테이블을 생성하면서 CNO, CNAME을 PK로 PNO은 PROFESSOR_PK의 PNO을 참조하여
--   FK로 설정하고 ST_NUM은 DEFAULT 2로 설정하세요.

--   CONSTRAINT 제약조건을 호출할때 사용 
--FK 변수명 지정시 FK_테이블명_변수명 REFERENCES 참조할 테이블(참조할값) 
CREATE TABLE COURSE_CONTSRAINT (
    CNO NUMBER , 
    CNAME VARCHAR2(20),
    ST_NUM NUMBER DEFAULT 2,
    PNO NUMBER CONSTRAINT FK_COURSE_CONTSRAINT_PNO REFERENCES PROFESSOR_PK(PNO), 
    CONSTRAINT PK_COURSE_CONTSRAINT_CNO PRIMARY KEY(CNO, CNAME)

);



--4) 다음 구조를 갖는 테이블을 생성하세요.
--   T_SNS                              T_SNS_DETAIL                        T_SNS_UPLOADED
--   SNS_NO(PK)    SNS_NM               SNS_NO(PK, FK)   SNS_BEN            SNS_NO(PK, FK)    SNS_UPL_NO(PK)
--     1            페북                   1               4000                   1                  1
--     2           인스타                  2               10000                  1                  2
--     3           트위터                  3               30000                  2                  1
--                                                                               2                  2
CREATE TABLE T_SNS(
    SNS_NO NUMBER PRIMARY KEY,
    SNS_NM VARCHAR2(20)
);

CREATE TABLE T_SNS_DETAIL(
    SNS_NO NUMBER CONSTRAINT FK_T_SNS_DETAIL_NO REFERENCES T_SNS(SNS_NO),
    SNS_BEN NUMBER, CONSTRAINT PK_T_SNS_DETAIL_BEN PRIMARY KEY(SNS_NO)
);

CREATE TABLE T_SNS_UPLOADED(
    SNS_NO NUMBER CONSTRAINT FK_T_SNS_UPLOADED_NO REFERENCES T_SNS_DETAIL(SNS_NO),
    SNS_UPL_NO NUMBER ,
    CONSTRAINT PK_T_SNS_UPLOADED_NO PRIMARY KEY(SNS_NO, SNS_UPL_NO ) -- pk,fk를 두개 불러와야하는데 T_SNS에는 pk만 있으니 둘 다 있는 T_SNS_DETAIL를 불러온다 
);



--1) 다음 구조를 갖는 테이블을 생성하세요.
--PRODUCT 테이블 - PNO NUMBER PK              : 제품번호
--                PNMAE VARCHAR2(50)          : 제품이름
--                PRI NUMBER                  : 제품단가
--PAYMENT 테이블 - MNO NUMBER PK              : 전표번호
--               PDATE DATE NOT NULL         : 판매일자
--                CNAME VARCHAR2(50) NOT NULL : 고객명
--                TOTAL NUMBER TOTAL > 0      : 총액
--PAYMENT_DETAIL - MNO NUMBER PK FK           : 전표번호
--                PNO NUMBER PK FK            : 제품번호
--                AMOUNT NUMBER NOT NULL      : 수량
--                AMOUNT NUMBER NOT NULL      : 단가
--                TOTAL_PRICE NUMBER NOT NULL TOTAL_PRICE > 0 : 금액

CREATE TABLE PRODUCT(
    PNO NUMBER PRIMARY KEY,
    PNMAE VARCHAR2(50),
    PRI NUMBER
);

CREATE TABLE PAYMENT(
    MNO NUMBE PRIMARY KEY,
    PDATE DATE NOT NULL,
    CNAME VARCHAR2(50) NOT NULL,
    TOTAL NUMBER CHECK(TOTAL > 0)
);

CREATE TABLE PAYMENT_DETAIL(
    MNO NUMBER CONSTRAINT FK_PA_DE_MNO REFERENCES PAYMENT (MNO),
    PNO NUMBER CONSTRAINT FK_PA_DE_PNO REFERENCES PRODUCT (PNO),
    AMOUNT NUMBER NOT NULL,
    PRICE NUMBER NOT NULL,
    TOTAL_PRICE NUMBER CHECK (TOTAL_PRICE > 0) NOT NULL,
    CONSTRAINT PK_PA_DE PRIMARY KEY (MNO, PNO)
    
);









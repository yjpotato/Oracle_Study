/*
조건에 부합하는 중고거래 상태 조회하기

다음은 중고거래 게시판 정보를 담은 USED_GOODS_BOARD 테이블입니다. USED_GOODS_BOARD 테이블은 다음과 같으며 BOARD_ID, WRITER_ID, TITLE, CONTENTS, PRICE, CREATED_DATE, STATUS, VIEWS은 게시글 ID, 작성자 ID, 게시글 제목, 게시글 내용, 가격, 작성일, 거래상태, 조회수를 의미합니다.

Column name	Type	Nullable
BOARD_ID	VARCHAR(5)	FALSE
WRITER_ID	VARCHAR(50)	FALSE
TITLE	VARCHAR(100)	FALSE
CONTENTS	VARCHAR(1000)	FALSE
PRICE	NUMBER	FALSE
CREATED_DATE	DATE	FALSE
STATUS	VARCHAR(10)	FALSE
VIEWS	NUMBER	FALSE


문제
USED_GOODS_BOARD 테이블에서 2022년 10월 5일에 등록된 중고거래 게시물의 게시글 ID, 작성자 ID, 게시글 제목, 가격, 거래상태를 조회하는 SQL문을 작성해주세요.
 거래상태가 SALE 이면 판매중, RESERVED이면 예약중, DONE이면 거래완료 분류하여 출력해주시고, 결과는 게시글 ID를 기준으로 내림차순 정렬해주세요.


*/


SELECT board_id,writer_id,title, price ,CASE WHEN status = 'SALE' THEN '판매중'
WHEN status = 'RESERVED' THEN '예약중' 
WHEN status = 'DONE' THEN '거래완료' END status
FROM used_goods_board
WHERE board_id IN(SELECT board_id FROM used_goods_board WHERE created_date = '2022-10-05')
ORDER BY board_id DESC
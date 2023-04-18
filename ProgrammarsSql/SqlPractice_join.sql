/*
다음은 어느 의류 쇼핑몰에서 판매중인 상품들의 상품 정보를 담은 PRODUCT 테이블과 오프라인 상품 판매 정보를 담은 OFFLINE_SALE 테이블 입니다.
 PRODUCT 테이블은 아래와 같은 구조로 PRODUCT_ID, PRODUCT_CODE, PRICE는 각각 상품 ID, 상품코드, 판매가를 나타냅니다.

Column name	Type	Nullable
PRODUCT_ID	INTEGER	FALSE
PRODUCT_CODE	VARCHAR(8)	FALSE
PRICE	INTEGER	FALSE

FFLINE_SALE 테이블은 아래와 같은 구조로 되어있으며 OFFLINE_SALE_ID, PRODUCT_ID, SALES_AMOUNT,
 SALES_DATE는 각각 오프라인 상품 판매 ID, 상품 ID, 판매량, 판매일을 나타냅니다.

Column name	Type	Nullable
OFFLINE_SALE_ID	INTEGER	FALSE
PRODUCT_ID	INTEGER	FALSE
SALES_AMOUNT	INTEGER	FALSE
SALES_DATE	DATE	FALSE

문제 : PRODUCT 테이블과 OFFLINE_SALE 테이블에서 상품코드 별 매출액(판매가 * 판매량) 합계를 출력하는 SQL문을 작성해주세요. 
결과는 매출액을 기준으로 내림차순 정렬해주시고 매출액이 같다면 상품코드를 기준으로 오름차순 정렬해주세요.

*/
select p.product_code, 
    sum(p.price * o.sales_amount) as sales
from product p
inner join offline_sale o on p.product_id = o.product_id
group by p.product_code
order by sales desc, p.product_code asc; 


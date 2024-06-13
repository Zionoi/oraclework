--1. 춘 기술대학교의 학과 이름과 계열을 표시하시오. 단, 출력 헤더는 "학과 명", "계열"으로 표시하도록 한다.
select DEPARTMENT_NAME "학과 명", CATEGORY "계열"
FROM tb_department;

--2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.
SELECT DEPARTMENT_NAME ||'의 정원은'|| CAPACITY || '입니다'
FROM TB_DEPARTMENT;

--3번제외 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 한다. 
--3번제외 그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오.

--4. 입학정원이 20명 이상 30명 이하인 학과들의 학과 이름과 계열을 출력하시오
select DEPARTMENT_NAME "학과 명", CATEGORY "계열"
FROM tb_department
WHERE CAPACITY >= 20 AND CAPACITY <=30;

--==============================================================================
--                            춘대학교 펑션 문제
--==============================================================================

--1. 영어영문학과(학과코드 002) 학생들의 이름, 입학 년도를 입학 년도가 빠른 순으로 표시하는 sql 문장을 작성하시오 (단, 헤더는 '학번', '이름', '입학년도' 가 표시되도록 한다.)
select STUDENT_NAME 학번, ENTRANCE_DATE 이름
from TB_STUDENT
where DEPARTMENT_NO = '002'
order by ENTRANCE_DATE DESC;

--2 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다.
-- 그 교수의 이름과 주민번호를 화면에 출력하는 SQL문장을 작성해 보자 
-- (* 이때 올바르게 작성한 SQL문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것)

SELECT PROFESSOR_NAME,PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME) != 3;

--3 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오.
-- 단 이때 나이가 적은 사람에서 많은 사람 순서로 화면에 출력되도록 만드시오.
-- (단, 교수 중 2000년 이후 출생자는 없으며 출력헤더는 "교수이름", "나이"로 한다
-- 나이는 '만'으로 계산한다.)
SELECT PROFESSOR_NAME 교수이름,PROFESSOR_SSN, FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(PROFESSOR_SSN,1,6)))/12) 나이
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) IN ('1', '3')
ORDER BY 나이 ASC;

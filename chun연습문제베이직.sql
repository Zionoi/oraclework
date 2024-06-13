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






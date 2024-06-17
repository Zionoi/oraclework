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
SELECT PROFESSOR_NAME 교수이름,PROFESSOR_SSN, FLOOR(MONTHS_BETWEEN(TO_DATE(SUBSTR(PROFESSOR_SSN,1,6),'YYMMDD'),SYSDATE)/12) 나이,
    TO_CHAR(TO_DATE(SUBSTR(PROFESSOR_SSN,1,6),'YYMMDD'),'YYYYMMDD') - TO_CHAR(TO_DATE('01000101','YYYYMMDD'),'YYYYMMDD')
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) IN ('1', '3')
ORDER BY 나이 ASC;

--교수님 풀이
select professor_name 교수이름, extract(year from sysdate) - (19 ||substr(professor_ssn,1,2)) 나이
from tb_professor
where substr(professor_ssn,8,1) = 1
order by 나이;

--4 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오.
--출력 헤더는 " 이름 " 이 찍히도록 한다. (성이 2자인 경우는 없다고 가정)
SELECT SUBSTR(PROFESSOR_NAME,2) 이름
FROM TB_PROFESSOR;

--5 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가?
--이때, 19살에 입학하면 재수를 하지 않은 것으로 간주한다
SELECT STUDENT_NAME, EXTRACT(YEAR FROM ENTRANCE_DATE) - EXTRACT(YEAR FROM (TO_DATE(SUBSTR(STUDENT_SSN,1,6)))) "입학할때 나이"
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - EXTRACT(YEAR FROM (TO_DATE(SUBSTR(STUDENT_SSN,1,6)))) > 19;

--6. 2020년 크리스마스는 무슨 요일인가?
SELECT TO_CHAR(TO_DATE(201225),'DAY')
FROM DUAL;

--7. TO_DATE('99/10/11', 'YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미할까?
-- 또 TO_DATE('99/10/11;,'RR/MM/DD'), TO_DATE('49/10/11;,'RR/MM/DD')은 각각 몇 년 몇 월 몇 일을 의미할까? 

SELECT TO_DATE('99/10/11', 'YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD'),
        TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD')
FROM DUAL;

--8 춘 기술대학교의 2000 년도 이후 입학자들은 학번이 A로 시작하게 되어있다. 2000년도
-- 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오
SELECT STUDENT_NO, STUDENT_NAME
FROM tb_student
WHERE SUBSTR(STUDENT_NO,1,1) != 'A';


--9 학번이 A517178인 한아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오
-- 단, 이때 출력화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림 하여 소수점 이하 한 자리까지만 표시
SELECT  ROUND(AVG(POINT),1) 평점
FROM tb_grade
WHERE student_no = 'A517178';

--10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 만들어 결과값 출력
SELECT DEPARTMENT_NO 학과번호, COUNT(*) "학생수(명)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;

--11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는지 알아내는 SQL문을 작성
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

--12. 학번이 A112113인 김고운 학생의 년도 별 평점을 구하는 SQL문을 작성
-- 단, 이때 출력 화면의 헤더는 "년도", "년도 별 평점"이라고 하고, 점수는
-- 반올림하여 소수점 이하 한 자리까지만 표시한다
SELECT TERM_NO, ROUND(AVG(POINT),1)
    FROM tb_grade
    WHERE STUDENT_NO = 'A112113'
    GROUP BY TERM_NO
    HAVING TERM_NO > 200201;
    -- GROUB BY있는 쿼리문에 WHERE이 무조건 못들어오는게 아니다
--        GROUB BY가 묶은 컬럼의 조건식만 HAVING에 적어주고 그 외에 조건은 WHERE로 묶을수 있다

-- 교수님 풀이
select substr(term_no,1,4)년도, round(avg(point),1) "년도 별 평점"
from tb_grade
where student_no = 'A112113'
group by substr(term_no,1,4);



--13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오
SELECT DEPARTMENT_NO, COUNT(DECODE(absence_yn, 'Y', 1))
FROM tb_student
GROUP BY department_no
 
ORDER BY DEPARTMENT_NO;
--COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2001',1))

--14 춘 대학교에 다니는 동명이인 학생들의 이름을 찾고자 한다.
-- 어떤 SQL문장을 사용하면 가능하겠는가?
SELECT student_name, COUNT(*)
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT(*)>1;


--15 학번이 A112113인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점,
-- 총 평점을 구하는 SQL문을 작성하시오,( 단, 평점은 소수점 1자리까지만 반올림한다)
SELECT EXTRACT(YEAR FROM(TO_DATE(TERM_NO,'YYYYMM'))) 년도, 
       EXTRACT(MONTH FROM(TO_DATE(TERM_NO,'YYYYMM'))) 학기,
       ROUND(AVG(POINT),1)
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(EXTRACT(YEAR FROM TO_DATE(TERM_NO, 'YYYYMM')),
                EXTRACT(MONTH FROM TO_DATE(TERM_NO, 'YYYYMM')));


GROUP BY CUBE(DEPT_CODE, JOB_CODE)




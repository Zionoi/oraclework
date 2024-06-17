/*
    *서브쿼리
     : 하나의 SQL문 안에 포함된 또다른 SELECT문
     - 메인 SQP문을 위해 보조 역할을 하는 쿼리문

*/
-- 사원 김정보와 같은 부서에 속한 사원을 조회하시오
-- 1. 김정보의 부서를 먼저 조회해야한다. 
SELECT DEPT_CODE
 FROM EMPLOYEE
  WHERE EMP_NAME = '김정보';
--=> D9 조회됨

--2. 부서가 D9 인 사원 조회
SELECT EMP_NAME
 FROM EMPLOYEE
  WHERE DEPT_CODE = 'D9';
  
-- 위의 단계를 하나의 쿼리문으로 합침
SELECT EMP_NAME
 FROM EMPLOYEE
  WHERE DEPT_CODE = (SELECT DEPT_CODE
                     FROM EMPLOYEE
                     WHERE EMP_NAME = '김정보'); 
                     -- 이게 바로 서브 쿼리

-- 전 직원의 평균급여보다 더 많은 급여를 받는 사원의 사원명, 사번, 직급코드, 급여 조회
SELECT EMP_NAME, EMP_ID, JOB_CODE,SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEE);

------------------------------------------------------------------------------------------
/*
    * 서브쿼리의 구분
     서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라 구문

    - 단일행 서브쿼리 : 서브쿼리의 조회 결과값이 오로지 1개 일때 (1행 1열)
    - 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 여러행 일때 (여러행 1열)
    - 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 여러열 일때 (1행 다중열)
    - 다중행다중열 서브쿼리 : 서브쿼리의 조회 결과값이 어려행 여러열 일때 (여러행 여러열)
    
    >> 서브쿼리의 종류가 뭐냐에 따라 서브쿼리 앞에 붙는 연산자가 달라짐    
*/
-------------------------------------------------------------------------------------------
/*
    1. 단일행 서브쿼리 : 서브쿼리의 조회 결과값이 오로지 1개 일때 (1행 1열)
        일반 비교연산자 사용 가능
        =, !=, >, <....
*/
-- 1) 전 직원의 평균 급여보다 더 적게 받는 직원의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY<(SELECT AVG(SALARY) FROM EMPLOYEE);

--2) 최저급여를 받는 사원의 사번, 사원명, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);

--3) 박정보 사원의 급여보다 더 많이받는 사원들의 사번, 사원명, 부서코드, 급여를 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '박정보');

--JOIN 
--4) 박정보 사원의 급여보다 더 많이받는 사원들의 사번, 사원명, 부서명, 급여 조회
-- >> 오라클구문 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
 AND SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '박정보');

-- >> ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) 
 AND SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '박정보');

-- JOIN 문에서 WHERE 없이 바로 AND 문으로 서브쿼리 사용해도 값이 같더라 그래도 혹시모르니 WHERE쓰자

--5) 왕정보사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명 조회 (단, 왕정보는 제외
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE=DEPT_ID 
AND EMP_NAME != '왕정보' 
AND DEPT_CODE = (SELECT DEPT_CODE 
                 FROM EMPLOYEE 
                 WHERE EMP_NAME = '왕정보');

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
    AND EMP_NAME ^= '왕정보' 
    AND DEPT_CODE = (SELECT DEPT_CODE 
                     FROM EMPLOYEE 
                     WHERE EMP_NAME = '왕정보');

-- GROUP BY
--6) 부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회 
--   6.1 부서별 급여합 중 가장 큰 값 하나만 조회
SELECT MAX(SUM(SALARY))
 FROM EMPLOYEE
  GROUP BY DEPT_CODE;

--  6.2 부서별 급여합이 17700000인 부서
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000; -- GROUP BY에서는 WHERE말고 HAVING을 사용한다

-- 위의 쿼리문을 하나로
SELECT DEPT_CODE, TO_CHAR(SUM(SALARY),'FML999,999,999,999')
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);
-------------------------------------------------------------------------------------------
/*
    2. 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 여러행 일때 (여러행 1열)
    - IN 서브쿼리 : 여러개의 결과값중에서 한개라도 일치하는값이 있다면 그걸 갖고온다
        >(비교연산자) ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 클 경우
                                    (여러개의 결과값 중에서 가장 작은값 보다 클경우)        
        < ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 작은 경우
                                    (여러개의 결과값 중에서 가장 큰값 보다 작을경우)        

    비교대상 > ANY (값1, 값2, 값3,,,) 
   = 비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
      값 들중에서 가장 작은값보다 비교대상이 크면 가져온다  
            
    비교대상 < ANY (값1, 값2, 값3,,,)
      값 들중에서 가장 큰값보다 비교대상이 작으면 가져온다    
    
*/
-- 1) 조정연 또는 전지연 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회
--  1.1 조정연 또는 전지연의 직급
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('조정연', '전지연');

--  1.2 J3, J7 직급인 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3','J7');


SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME IN ('조정연', '전지연'));


-- 사원 -> 대리 -> 과ㅏㅈㅇ
-- 2) 대리 직급임에도 불구하고 과장직급 급여들 중 최소급여보다 많이 받는 직원의 사번, 사원명, 직급, 급여 조회
--  2.1. 과장들의 급여
SELECT SALARY
 FROM EMPLOYEE
 JOIN JOB USING (JOB_CODE)
 WHERE JOB_NAME = '과장'; -- 2200000, 2500000, 3760000

--  2.2 직급이 대리이면서 급여가 위의 목록의 값 보다 하나라도 큰 사원
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
   WHERE JOB_NAME = '대리'
   AND SALARY > ANY(2200000, 2500000, 3760000);

-- 위의 커리문을 하나로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
   WHERE JOB_NAME = '대리'
   AND SALARY > ANY(SELECT SALARY
                    FROM EMPLOYEE
                    JOIN JOB USING (JOB_CODE)
                    WHERE JOB_NAME = '과장');

-- 단일행 쿼리로도 가능
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
   WHERE JOB_NAME = '대리'
   AND SALARY > ANY(SELECT MIN(SALARY)
                    FROM EMPLOYEE
                    JOIN JOB USING (JOB_CODE)
                    WHERE JOB_NAME = '과장');

-----------------------------------------------------------------------------------------------------------
/*
    3. 다중열 서브쿼리
     : 결과값이 한행이고 컬럼수가 여러개 일 때

*/
-- 1) 장정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 사우너들의 사원명, 부서코드, 직급코드, 입사일 조회
--      1.1 장정보사원의 부서코드와 직급코드를 가져오기
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '장정보';


SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
 FROM EMPLOYEE
 WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '장정보')
    AND JOB_CODE = (SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '장정보'); -- 부서코드와 직급코드를 따로따로 서브쿼리로 가져오면 너무 길어짐
--다중열 서브쿼리로 하면
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
 FROM EMPLOYEE
 WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '장정보');

-- 지정보 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사번, 사원명, 직급코드, 사수번호
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '지정보');


-----------------------------------------------------------------------------------------------------------
/*
    3. 다중행 다중열 서브쿼리
     : 결과값이 여러행이고 컬럼수가 여러개 일 때

*/
--1) 각 직급별 최소급여 금액을 받는 사원이 사번, 사원명, 직급코드, 급여조회

--    1.1 먼저 각 직급별 최소급여를 구해야한다
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
GROUP BY JOB_CODE = 'J1' AND SALARY = 8000000  -- 원래는 GROUP BY에는 HAVING 절로 써야하나 다중행열 서브쿼리 이해를 돕기위한 중간 쿼리이므로 직관적으로 AND 사용
    OR JOB_CODE = '2' AND SALARY = 3700000
    ....;       -- 이런문법은 없다

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) = ('J1',8000000)
    OR(JOB_CODE, SALARY) = ('J2',3700000)
    ....; -- 너무 길어진다
    
-- 서브쿼리를 이용하면
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                                FROM EMPLOYEE
                                GROUP BY JOB_CODE);
--                                ORDER BY (JOB_CODE);

--2) 각 부서별 최고급여를 받는 사원들의 사번, 사원명, 부서코드, 급여조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE(DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                            FROM EMPLOYEE
                            GROUP BY DEPT_CODE);

-----------------------------------------------------------------------------------------------------------
/*
    인라인 뷰 (INLINE VIEW)  : 서브쿼리를 수행한 결과를 마치 테이블처럼 사용
                                FROM절에 서브쿼리 작성

    - 주로 사용하는 예 : TOP-N분석 (위에서 N번째까지 분석- 상위 몇위만 가져오기)

*/
--1) 사원들의 사번, 이름, 보너스를 포함한 연봉, 부서코드 조회(연봉에 NULL이 안나오게)
-- 단, 보너스포함 연봉이 3000만원이상인 사람들만 조회
SELECT EMP_ID, EMP_NAME, (SALARY*NVL(1+BONUS,1))*12 연봉, DEPT_CODE
FROM EMPLOYEE
-- WHERE 연봉 >= 3000000;  => 오류 - 우선순위가 WHERE가 SELET보다 먼저이므로 연봉으로 별칭이 아직 정해지기 전이라 별칭을 쓸수없다
WHERE (SALARY*NVL(1+BONUS,1))*12 >= 3000000;

-- 별칭을 사용하고 싶다면 INLINE VIEW를 사용하면 된다
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, (SALARY*NVL(1+BONUS,1))*12 연봉, DEPT_CODE
        FROM EMPLOYEE)
WHERE 연봉 >= 30000000;       

-- 인라인뷰안에 테이블에서도 몇개만 추려서 가져올수도 있다
SELECT EMP_ID, EMP_NAME, 연봉
FROM (SELECT EMP_ID, EMP_NAME, (SALARY*NVL(1+BONUS,1))*12 연봉, DEPT_CODE
        FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

/*
SELECT EMP_ID, EMP_NAME, 연봉, HIRE_DATE
FROM (SELECT EMP_ID, EMP_NAME, (SALARY * NVL(1+BONUS,1))*12 연봉, DEPT_CODE
            FROM EMPLOYEE)
WHERE 연봉 >= 30000000;  --  FROM절 뒤의 테이블에 HIRE_DATE라는 컬럼은 없다
*/

--TOP-N분석
--전 직원중 급여가 가장 높은 상위 5명만 조회
--*ROWNUM : 오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 순번을 부여
-- 기본적으로 오라클 및 데이터베이스에는 순서가 없으나 ROWNUM을 사용하면 순서를 부여해줄수 있다
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC; -- ROWNUM 번호가 꼬임  ==> 순서 FROM -> SELECT -> ORDER

-- 상위 등수가 제대로 조회되지 않는다. 전체 데이터중 우선순위가 더 높은 FROM절에서 먼저 ROWNUM 번호가 매겨지고 그다음 SALARY 내림차순이 되기때문
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <=10
ORDER BY SALARY DESC;

-- 인라인뷰로 먼저 ORDER BY를 한 후, ROWNUM을 붙여줘야한다
SELECT *
FROM (SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC);

SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC)
WHERE ROWNUM <= 5; -- 오류

SELECT ROWNUM,*
FROM (SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC)
WHERE ROWNUM <= 5; -- 오류

-- 테이블에 별칭 부여하면 가능
SELECT ROWNUM,E.*
FROM (SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC)E
WHERE ROWNUM <= 5;

-- 가장 최근에 입사한 사원 5명의 사원명, 급여, 입사일 조회
SELECT ROWNUM, EMP_NAME, SALARY, HIRE_DATE
 FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <=5;

--3) 각 부서별 평균급여가 높은 3개 부서의 부서코드, 평균급여 조회
SELECT ROWNUM, E.*
    FROM(SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
            FROM EMPLOYEE
            GROUP BY DEPT_CODE
            ORDER BY 평균급여 DESC) E
WHERE ROWNUM <= 3;

-----------------------------------------------------------------------------------------------------------
/*
   *WITH
     : 서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 FROM절에 기술
     - 장점 
      같은 서브쿼리가 여러번 사용될 경우 중복 작성을 피할 수 있고, 실행속도가 빠르다
      
    MINUS나 UNION 처럼 SELECT 절이 두번 나올때 주로 사용함
    
    
*/

WITH TOPN_SAL AS (SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
                    FROM EMPLOYEE
                    GROUP BY DEPT_CODE
                    ORDER BY 평균급여 DESC)
SELECT*
    FROM TOPN_SAL
    WHERE ROWNUM <= 3;

-- 실행시 세미콜론이 붙으면 위에 정의한 WITH는 소멸됨. 재사용 불가
SELECT*
    FROM TOPN_SAL
    WHERE ROWNUM <= 3; -- 오류뜸

--==============================================================================================
/*
    * 순위 매기는 함수(WINDOW FUNCTION)
    RANK()OVER(정렬기준) | DENSE_RAKE() OVER(정렬기준)
    -RANK()OVER(정렬기준): 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
                            EX) 공동1위가 2명이면 그 다음 순위는 3위
    -DENSE_RANK() OVER(정렬기준) : 동일한 순위 이후 그 다음 등수를 무조건 1씩 증가 시킴
                            EX) 공동1위가 2명이어도 그 다음 순위는 2위
    
*/

--급여가 높은 순서대로 순위 매겨서 사원명, 급여, 순위 출력
SELECT EMP_NAME, SALARY, RANK()OVER(ORDER BY SALARY DESC) 순위
 FROM EMPLOYEE; -- 공동 19등 이후에 20위 건너뛰고 21등
 
SELECT EMP_NAME, SALARY, DENSE_RANK()OVER(ORDER BY SALARY DESC) 순위
 FROM EMPLOYEE; --공동 19등 이후에 20위부터 순위매김
 
 --급여가 상위 5위인 사람의 사원명, 급여, 순위 조회
SELECT EMP_NAME, SALARY, RANK()OVER(ORDER BY SALARY DESC) 순위
 FROM EMPLOYEE
 WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5; -- 오류
 --윈도우 함수는 WHERE절에서 사용 못함. SELECT 절에서만 사용가능. RANK() OVER는 윈도우 함수 
 
 --> 인라인 뷰를 사용하면 됨
 SELECT *
 FROM (SELECT EMP_NAME, SALARY, RANK()OVER(ORDER BY SALARY DESC) 순위
        FROM EMPLOYEE)
 WHERE 순위 <= 5;
 
 --> WITH와 같이 사용
 WITH TOPN_SALARY AS (SELECT EMP_NAME, SALARY, RANK()OVER(ORDER BY SALARY DESC) 순위
                         FROM EMPLOYEE)
 SELECT *
  FROM TOPN_SALARY
  WHERE 순위 <= 5;

--------------------------------------------------------- 연습문제 --------------------------------------------------------
-- 1. 2020년 12월 25일의 요일 조회
SELECT TO_CHAR(TO_DATE('20201225','YYYYMMDD' ),'DAY') FROM DUAL;

-- 2. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회    
SELECT EMP_NAME, EMP_NO,DEPT_CODE,JOB_NAME
FROM EMPLOYEE E,JOB J, DEPARTMENT D
WHERE DEPT_CODE = DEPT_ID 
AND J.JOB_CODE = E.JOB_CODE 
AND SUBSTR(EMP_NO,8,1) IN(2,4) 
AND SUBSTR(EMP_NAME,1,1) 
AND SUBSTR(EMP_NO,1,2) BETWEEN 70 AND 79
LIKE '전%';

--교수님 풀이
SELECT EMP_NAME, EMP_NO,DEPT_CODE,JOB_NAME
 FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN JOB USING(JOB_CODE)
  WHERE SUBSTR(EMP_NO,1,2) >= 70 
  AND SUBSTR(EMP_NO,1,2) <=79 
  AND SUBSTR(EMP_NO,8,1) = 2 
  AND EMP_NAME LIKE '전%';

-- 3. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
SELECT ROWNUM,E.*
FROM (SELECT EMP_ID, EMP_NAME,
        EXTRACT(YEAR FROM SYSDATE)- (19||SUBSTR(EMP_NO,1,2)) 나이, DEPT_TITLE 부서명, JOB_NAME 직급명
        FROM EMPLOYEE
        JOIN JOB USING(JOB_CODE)
        JOIN DEPARTMENT ON (EMPLOYEE.DEPT_CODE=DEPARTMENT.DEPT_ID)
        ORDER BY 나이)E
WHERE ROWNUM = '1';

--교수님 풀이
SELECT EMP_ID, EMP_NAME, 
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM (TO_DATE(SUBSTR(EMP_NO,1,2),'RR'))) AS 나이,
    DEPT_TITLE,
    JOB_NAME
FROM EMPLOYEE
 JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN JOB USING(JOB_CODE)
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM (TO_DATE(SUBSTR(EMP_NO,1,2),'RR'))) =
    (SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM (TO_DATE(SUBSTR(EMP_NO,1,2),'RR')))) 
     FROM EMPLOYEE); 
        

-- 4. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND EMP_NAME LIKE '%하%';

-- 5. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
AND DEPT_CODE IN ('D5', 'D6');

-- 6. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
SELECT EMP_NAME, BONUS,DEPT_TITLE,LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
JOIN LOCATION ON(LOCAL_CODE=LOCATION_ID)
AND BONUS IS NOT NULL;

-- 7. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE E.JOB_CODE=J.JOB_CODE AND E.DEPT_CODE=D.DEPT_ID AND D.LOCATION_ID = L.LOCAL_CODE;

-- 8. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회 
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON( DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('한국', '일본');

-- 9. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '하정연');

-- 10. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회 (NVL 이용)
SELECT EMP_NAME, JOB_NAME, NVL(SALARY,1)
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE BONUS IS NULL AND JOB_CODE IN ('J4','J7');

-- 11. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
SELECT COUNT(CASE WHEN ENT_YN = 'N' THEN 1 END) 퇴사하지않은사람,
        COUNT(CASE WHEN ENT_YN = 'Y' THEN 1 END) 퇴사자
FROM EMPLOYEE;

--교수님 풀이
SELECT COUNT(*)
 FROM EMPLOYEE
 GROUP BY ENT_YN;

-- 12. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회
SELECT ROWNUM,EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, 연봉
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, (SALARY*NVL(1+BONUS,1))*12 연봉
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE) 
ORDER BY 연봉 DESC)
WHERE ROWNUM <= 5;

--교수님 풀이
SELECT *
 FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE,
                RANK()OVER(ORDER BY(SALARY*NVL(1+BONUS,1)*12) DESC) 순위
        FROM EMPLOYEE
            JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
            JOIN JOB USING(JOB_CODE))
WHERE 순위 <=5;


-- 13. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	13-1. JOIN과 HAVING 사용    
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON( DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (SELECT SUM(SALARY) FROM EMPLOYEE)/5;

-- 교수님 풀이
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON( DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (SELECT SUM(SALARY)*0.2 FROM EMPLOYEE);

--	13-2. 인라인 뷰 사용      
SELECT *
FROM (SELECT DEPT_TITLE, SUM(SALARY)
        FROM EMPLOYEE
        JOIN DEPARTMENT ON( DEPT_ID = DEPT_CODE)
        GROUP BY DEPT_TITLE
        HAVING SUM(SALARY) > (SELECT SUM(SALARY) FROM EMPLOYEE)/5);

--교수님 풀이
SELECT *
FROM (SELECT DEPT_TITLE, SUM(SALARY) "부서별 합"
        FROM EMPLOYEE
        JOIN DEPARTMENT ON( DEPT_ID = DEPT_CODE)
        GROUP BY DEPT_TITLE)
 WHERE "부서별 합" > (SELECT SUM(SALARY)*0.2 FROM EMPLOYEE);

--	13-3. WITH 사용
WITH INLINE AS (SELECT DEPT_TITLE, SUM(SALARY)
                FROM EMPLOYEE
                JOIN DEPARTMENT ON( DEPT_ID = DEPT_CODE)
                GROUP BY DEPT_TITLE
                HAVING SUM(SALARY) > (SELECT SUM(SALARY) FROM EMPLOYEE)/5)

SELECT *
FROM INLINE;

-- 교수님 풀이
WITH TOTAL_SAL AS (SELECT DEPT_TITLE, SUM(SALARY) "부서별 합"
        FROM EMPLOYEE
        JOIN DEPARTMENT ON( DEPT_ID = DEPT_CODE)
        GROUP BY DEPT_TITLE)
SELECT *
FROM TOTAL_SAL
WHERE "부서별 합" > (SELECT SUM(SALARY)*0.2 FROM EMPLOYEE);


-- 14. 부서명별 급여 합계 조회(NULL도 조회되도록)
--ANSI 구문
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID=DEPT_CODE)
GROUP BY DEPT_TITLE;

--오라클
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+)
GROUP BY DEPT_TITLE;


-- 15. WITH를 이용하여 급여합과 급여평균 조회
WITH SUM_SAL AS(SELECT SUM(SALARY) 급여합, ROUND(SUM(SALARY)/COUNT(EMP_ID),1) 급여평균 FROM EMPLOYEE)
SELECT *
FROM SUM_SAL;

-- 교수님 풀이
WITH SUM_SAL AS (SELECT SUM(SALARY) FROM EMPLOYEE),
     AVG_SAL AS (SELECT CEIL(AVG(SALARY)) FROM EMPLOYEE)

SELECT * FROM SUM_SAL
UNION
SELECT * FROM AVG_SAL;








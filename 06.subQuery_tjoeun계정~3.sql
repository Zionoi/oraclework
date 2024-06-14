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


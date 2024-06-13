--------------------------------------------------
--GROUP
/*
    *GROUP BY 절
    그룹기준을 제시할 수 있는 구문(해당 그룹별로 여러 그룹으로 묶을 수 있음)
    여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
*/
-- 전체 직원 급여 합계
SELECT SUM(SALARY)
 FROM EMPLOYEE; -- 전체사원을 하나의 그룹으로 묶어서 총합

--각 부서별 급여의 합게
SELECT DEPT_CODE,SUM(SALARY) -- 그룹바이로 그룹을 묶을땐 보통 그룹바이에 지정한 그룹을 컬럼에 같이 넣어서 조회한다
 FROM EMPLOYEE
 GROUP BY DEPT_CODE;

--각 부서별 사원의 수
SELECT DEPT_CODE, COUNT(*)  --그룹으로 되어있는것들의 모든행 갯수
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, COUNT(*), SUM(SALARY) -- 이런식으로 한번에 여러개를 그룹으로 묶어서 조회할수도있다
FROM EMPLOYEE
GROUP BY DEPT_CODE --FROM 과 ORDER BY의 사이에 둔다
ORDER BY 3;


--각 직급별 직원의 수와 급여의 합계 조회
SELECT JOB_CODE, COUNT(*), SUM(SALARY)
 FROM EMPLOYEE
 GROUP BY JOB_CODE
 ORDER BY JOB_CODE;
 
 -- 각 직급별 직원의 수, 보너스를 받는 사원수, 급여 합, 평균급여, 최저급여, 최고급여
 SELECT JOB_CODE, COUNT(*), COUNT(BONUS), SUM(SALARY), ROUND(AVG(SALARY)), MIN(SALARY), MAX(SALARY)
 FROM EMPLOYEE
 GROUP BY JOB_CODE;
 
 -- GROUP BY 함수식 사용가능
 SELECT DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여') 성별, COUNT(*) 인원수
 FROM EMPLOYEE
 GROUP BY SUBSTR(EMP_NO,8,1);


-- GROUB BY절에 여러 컬럼 기술
SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE -- 두개를 묶어서 하나의 그룹으로 
ORDER BY DEPT_CODE;


----------------------------------------------------------------
/*
    *HAVING 절 : 그룹에 대한 조건을 제시할 때 사용(주로 그룹함수식을 가지고 조건을 제시할 때 사용)
*/
--각 부서별 평균 급여 => 그룹바이만 있으면 된다
SELECT DEPT_CODE, AVG(SALARY)
    FROM EMPLOYEE
    GROUP BY DEPT_CODE;
    
-- 각 부서별 평균 급여가 3백만원 이상인 부서들만 조회
/*
SELECT DEPT_CODE, AVG(SALARY)
    FROM EMPLOYEE
    WHERE AVG(SALARY) >= 3000000 -- 오류 그룹바이일때는 WHERE를 쓸수 없다
    GROUP BY DEPT_CODE; -- 오류 : 그룹함수에서 조건은 WHERE절에서 하면 안됨
*/

SELECT DEPT_CODE, CEIL(AVG(SALARY))
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    HAVING AVG(SALARY) >= 3000000;


-- 문제
--1. 직급코드, 직급 직급별 총 급여 합(단, 직급별 급여합이 1000만원 이상인 직급만 조회)
SELECT JOB_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

--2. 부서별 보너스를 받는 사원이 없는 부서만 부서코드를 조회
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING count(case when bonus IS not NULL then 1 end) = 0;






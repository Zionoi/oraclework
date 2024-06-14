/*

    JOIN
    두개 이상의 테이블에서 데이터를 조회하고자 할 때 사용하는 구문
    조회 결과는 하나의 결과물(RESULT SET) 

    => 관계형 데이터베이스에서 SQL문을 이용한 테이블간의 '관계'를 맺는 방법
    
    JOIN은 크게 "오라클 전용구문" 과 "ANSI구문" 이 있다(ANSI == 미국국립표준협회)
    --오라클만 오라클전용이있고 다른 DB는 ANSI구문으로 사용한다

=====================================================================================================    
                                          [JOIN 용어 정리]
-----------------------------------------------------------------------------------------------------
                오라클 전용 구문                   |                   ANSI
-----------------------------------------------------------------------------------------------------
                  등가조인                        |       내부조인(INNER JOIN) => JOIN USING | ON                         
                (EQUAL JOIN)                    |        자연조인(NATURAL JOIN) => JOIN USING (각 테이블에 동일한 컬럼명이 한개만 있을때 사용)
-----------------------------------------------------------------------------------------------------
                  포괄조인                        |        왼쪽 외부조인(LEFT OUTER JOIN)                      
                (LEFT OUTER)                    |         오른쪽 외부조인(RIGHT OUTER JOIN)           
                (RIGHT OUTER)                   |         전체 외부조인(FULL OUTER JOIN)     
-----------------------------------------------------------------------------------------------------
              자체조인(SELF JOIN)                 |                JOIN ON                      
         비등가 조인(NON EQUAL JOIN)              |                  
-----------------------------------------------------------------------------------------------------              
          카테시안 곱(CARTESIAN PRODUCT)          |           교차조인(CROSS JOIN)                     
-----------------------------------------------------------------------------------------------------       
*/ 

/*
            1. 등가조인 / 내부조인
                연결시키는 컬럼의 값이 " 일치하는 행들만" 조인되어 조회( = 일치하지 않는 행은 조회에서 제외)

*/

/*
        >> 오라클 전용 구분
            -- FROM 절에 조회하고자 하는 테이블들을 나열(, 구분자료)
            -- WHERE절에 매칭시킬 컬럼(연결고리)에 대한 조건 제시함
            
*/
--1) 연결한 컬럼명이 다른 경우(EMPLOYEE: DEPT_CODE, DEPARTMENT: DEPT_ID)
-- 사번, 사원명, 부서코드, 부서명을 조회  
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT -- 오라클은 JOIN하기쉬움 그냥 컬럼명 넣고 FROM에 테이블명 넣어주면됨
WHERE DEPT_CODE = DEPT_ID
ORDER BY EMP_ID;
-- 일치하는 행이 없으면 조회에서 제외

--2) 연결할 컬럼명이 같은경우 (EMPLOYEE: JOB_CODE, JOB:JOB_CODE
-- 사번, 사원명, 직급코드, 직급명
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
 FROM EMPLOYEE, JOB
 WHERE JOB_CODE = JOB_CODE;
 -- 오류. 두테이블에 같은이름의 컬럼이 있을땐 어떤테이블의 JOB_CODE인지 명시를 해줘야 오류가 안난다

--수정
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
 FROM EMPLOYEE, JOB
 WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 별칭을 이용해도 가능
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
    FROM EMPLOYEE E, JOB J          -- 이렇게 테이블명에 별칭을 지정할 수 있다. FROM절의 우선순위가 제일 높다
    WHERE E.JOB_CODE = J.JOB_CODE;
          
/*
    >> ANSI 구문
        - FROM절에 기준이 되는 테이블을 하나만 기술
        - JOIN절에 같이 조회하고자 하는 테이블 기술
        - JOIN USING, JOIN ON
        
*/
-- 1) 연결한 컬럼명이 다른 경우(EMPLOYEE: DEPT_CODE, DEPARTMENT: DEPT_ID)
--     => 오로지 JOIN ON 구문만 사용

-- 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
    FROM EMPLOYEE
    JOIN department ON (DEPT_CODE = DEPT_ID);


--2) 연결할 컬럼명이 같은경우 (EMPLOYEE: JOB_CODE, JOB:JOB_CODE
--   => JOIN ON과 JOIN USING 둘 다 사용가능

-- 사번, 사원명, 직급코드, 직급명
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
    FROM EMPLOYEE
     JOIN JOB USING (JOB_CODE); -- ()안에 하나만 사용할때는 USING
-- JOIN USING : 두 테이블의 컬럼명이 같은경우 1개만 기술

-- JOIN ON 사용
--      => 두 테이블의 컬럼명을 모두 기술
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
    FROM EMPLOYEE
     JOIN JOB ON (EMPLOYEE.JOB_CODE = JOB.JOB_CODE);          
                
-- 별칭 사용가능
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
    FROM EMPLOYEE E
     JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE); 
     
-- 3) 추가 조건이 있을때
-- 직급이 대리인 사원의 사번, 사원명, 직급명, 급여를 조회
-- >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
 FROM EMPLOYEE E, JOB J
 WHERE e.job_code = J.JOB_CODE
    AND JOB_NAME = '대리';



-- >> ANSI 전용 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
 FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME = '대리';


------------------------------------------  실습 문제  -------------------------------------------
-- 1. 부서가 인사관리부인 사원들의 사번, 이름,  부서명, 보너스 조회
--  >> 오라클 전용 구문
SELECT EMP_ID,EMP_NAME,DEPT_TITLE, BONUS
FROM employee,department
WHERE DEPT_CODE = DEPT_ID AND DEPT_TITLE = '인사관리부'
ORDER BY EMP_NAME;


--  >> ANSI 구문
SELECT EMP_ID,EMP_NAME,DEPT_TITLE, BONUS
 FROM employee
  JOIN department ON(DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = '인사관리부';

-- 2. DEPARTMENT과 LOCATION을 참고하여 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
--  >> 오라클 전용 구문
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
 FROM DEPARTMENT, LOCATION
 WHERE LOCAL_CODE = LOCATION_ID;

--  >> ANSI 구문
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
 FROM DEPARTMENT
  JOIN LOCATION ON(LOCAL_CODE = LOCATION_ID);


-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
--  >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
 FROM EMPLOYEE,DEPARTMENT
  WHERE DEPT_CODE = DEPT_ID AND BONUS IS NOT NULL;


--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
 FROM EMPLOYEE
  JOIN DEPARTMENT ON( DEPT_CODE = DEPT_ID) AND BONUS IS NOT NULL;

-- 4. 부서가 총무부가 아닌 사원들의 사원명, 급여, 부서명 조회
--  >> 오라클 전용 구문 
SELECT EMP_NAME, SALARY, DEPT_TITLE
    FROM EMPLOYEE, DEPARTMENT
        WHERE DEPT_CODE = DEPT_ID AND DEPT_TITLE != '총무부';

--  >> ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
    FROM EMPLOYEE
        JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) AND DEPT_TITLE != '총무부';
     
--------------------------------------------------------------------------------------------------
/*
    2. 포괄조인 / 외부조인
     : 두 테이블간의 JOIN시 일치하지 않는 행도 포함시켜 조회 가능
     단, 반드시 LEFT/ RIGHT를 지정해야 됨(기준이 되는 테이블 지정)

*/
-- 사원명, 부서명, 급여, 연봉
--내부조인 사용시
SELECT EMP_NAME,DEPT_CODE, DEPT_TITLE, SALARY, SALARY*12 연봉
 FROM EMPLOYEE, department
  WHERE DEPT_CODE = DEPT_ID; 
-- DEPT_CODE가 NULL값인 사원2명은 제외됨. 
-- 부서에 배정된 사원이 없는 부서도 제외됨 D3,D5,D7

 --포괄조인으로 DEPT_CODE를 기준으로 조회하면 DEPT_CODR가 NULL값인 사원도 전부다 가져올 수 있음
-- 사원명, 부서명, 급여, 연봉(부서배치가 안된 사원도 모두 조회)
--1) LEFT[OUTER] JOIN : 두 테이블 중 왼쪽에 기술된 테이블을 기준으로 JOIN
-- >> ANSI 구문
SELECT EMP_NAME,DEPT_CODE, DEPT_TITLE, SALARY, SALARY*12 연봉
 FROM EMPLOYEE LEFT JOIN department ON (DEPT_CODE = DEPT_ID);

-- >> 오라클 전용 구문
SELECT EMP_NAME,DEPT_CODE, DEPT_TITLE, SALARY, SALARY*12 연봉
 FROM EMPLOYEE, department
  WHERE DEPT_CODE = DEPT_ID(+);
  -- 기준으로 삼고자 하는 테이블의 반대편 테이블의 컬럼 뒤에(+) 붙이기

--1) RIGHT[OUTER] JOIN : 두 테이블 중 오른쪽에 기술된 테이블을 기준으로 JOIN
-- >> ANSI 구문
SELECT EMP_NAME,DEPT_CODE, DEPT_TITLE, SALARY, SALARY*12 연봉
 FROM EMPLOYEE
 RIGHT JOIN department ON (DEPT_CODE = DEPT_ID);

-- >> 오라클 전용 구문
SELECT EMP_NAME,DEPT_CODE, DEPT_TITLE, SALARY, SALARY*12 연봉
 FROM EMPLOYEE, department
  WHERE DEPT_CODE(+) = DEPT_ID;


--3) FULL[OUTER]JOIN : 두 테이블이 가진 모든 행 조회(단, 오라클전용 구문은 없음)
SELECT EMP_NAME,DEPT_CODE, DEPT_TITLE, SALARY, SALARY*12 연봉
 FROM EMPLOYEE
 FULL JOIN department ON (DEPT_CODE = DEPT_ID);

--------------------------------------------------------------------------------------------------
/*
    2. 비등가 조인
        : 매칭시킬 컬럼에 대한 조건식 작성시 '=' (등호)를 사용하지 않는 JOIN
*/

--사원명, 급여, 급여레벨 조회
-- >> 오라클전용 구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
--WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;


-- >> ANSI구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE
 JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

--SAL_GRADE 테이블에 데이터가 없어서 다시 입력함
/*
 INSERT INTO SAL_GRADE VALUES('S1',6000000,10000000);
INSERT INTO SAL_GRADE VALUES('S2',5000000,5999999);
INSERT INTO SAL_GRADE VALUES('S3',4000000,4999999);
INSERT INTO SAL_GRADE VALUES('S4',3000000,3999999);
INSERT INTO SAL_GRADE VALUES('S5',2000000,2999999);
INSERT INTO SAL_GRADE VALUES('S6',1000000,1999999);
*/
--------------------------------------------------------------------------------------------------
/*
    3. 자체 조인
        : 같은 테이블을 다시 한번 조인하는 경우
*/
-- 전체사원의 사원번호, 사원명, 부서코드, 사수번호, 사수명, 사수부서코드     
-->> 오라클 전용 구문
-- 사수가 있는 사원만 조회
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE,
        M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
 FROM EMPLOYEE E, EMPLOYEE M  -- 같은 테이블에서 여러 컬럼을 비교할땐 별칭을 따로 부여해서 구분지어주면된다
 WHERE E.MANAGER_ID = M.EMP_ID; 


SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE,
        M.EMP_ID 사수번호, M.EMP_NAME 사수명, M.DEPT_CODE 사수부서코드
 FROM EMPLOYEE E, EMPLOYEE M 
 WHERE E.MANAGER_ID = M.EMP_ID(+);  -- (+)으로 사수가없는 사원도 같이 출력할 수 있다. -> E.MANAGER_ID기준으로 전부다 출력
 
-->> ANSI 구문 
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE,
        M.EMP_ID 사수번호, M.EMP_NAME 사수명, M.DEPT_CODE 사수부서코드
 FROM EMPLOYEE E
 LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID(+));  -- 레프트조인으로 사수가없는 사원도 같이 출력할 수 있다. -> EMPLOYEE E 기준으로 전부다 출력
--------------------------------------------------------------------------------------------------
/*
    4. 다중 조인
        : 2개 이상의 테이블을 JOIN 하는 경우
*/
-- 사번, 사원명, 부서명, 직급명 조회
-- EMPLOYEE     DEPT_CODE   JOB_CODE 
-- DEPARTMENT   DEPT_ID
-- JOB                      JOB_CODE

-- >>오라클 전용 구문(LEFT JOIN을 하지 않으면 NULL제외)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
    FROM EMPLOYEE, DEPARTMENT,JOB
      WHERE DEPT_CODE = DEPT_ID     -- 이 구문으로 직원마다 모든 테이블값 대조되는거 막은 후에
        AND EMPLOYEE.JOB_CODE = JOB.JOB_CODE;  -- 여기 구문으로 테이블에 직급코드가 같은 사원만 출력

-- >>ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
    FROM EMPLOYEE 
        JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        JOIN JOB USING(JOB_CODE); -- JOIN에 들어가는 컬럼이 하나면 USING 사용가능 그럼 별칭도 필요가 없어진다 ON으로할경우 각 JOB_CODE가 어디 JOB_CODE인지 지정해줘야한다

-- >> 사번, 사원명, 부서명, 지역명 조회
--EMPLOYEE      DEPT_CODE
--DEPARTMENT    DEPT_ID     LOCATION_ID
--LOCATION                  LOCAL_CODE

--  >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
    FROM EMPLOYEE, DEPARTMENT, LOCATION
    WHERE DEPT_CODE = DEPT_ID(+) AND LOCATION_ID = LOCAL_CODE
    ORDER BY EMP_ID;
-- >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
    FROM EMPLOYEE
   LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    LEFT JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

------------------------------------------  실습 문제  -------------------------------------------
-- 1. 사번, 사원명, 부서명, 지역명, 국가명 조회(EMPLOYEE, DEPARTMENT, LOCATION, NATIONAL 조인)
--  >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
    FROM EMPLOYEE, DEPARTMENT D, LOCATION L, NATIONAL N
        WHERE DEPT_CODE(+) = DEPT_ID 
        AND D.LOCATION_ID = L.LOCAL_CODE 
        AND L.NATIONAL_CODE = N.NATIONAL_CODE;


--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL USING(NATIONAL_CODE);


-- 2. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회 (모든 테이블 다 조인)
--  >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE,JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
    FROM DEPARTMENT D,EMPLOYEE E,JOB J,LOCATION L,NATIONAL N,SAL_GRADE S
        WHERE DEPT_CODE = DEPT_ID(+)
            AND E.JOB_CODE = J.JOB_CODE
            AND LOCATION_ID = LOCAL_CODE
            AND L.NATIONAL_CODE = N.NATIONAL_CODE
            AND SALARY BETWEEN MIN_SAL AND MAX_SAL;


--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE,JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
    FROM EMPLOYEE
       JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
       JOIN JOB USING (JOB_CODE)
       JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
       JOIN NATIONAL USING(NATIONAL_CODE)
       JOIN SAL_GRADE ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);











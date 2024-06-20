/*
        * VIEW
          SELECT문을 저장해둘수 있는 객체
          (자주 쓰이는 긴 SELECT문을 저장해 두었다가 호출하여 사용할 수 있다)
          일종의 임시테이블 같은 존재(실제 데이터가 담겨있는건 아님, 데이터베이스 아님 -> 논리적 테이블)
*/

-- 한국 근무하는 사원의 사번, 사원명, 부서명, 급여, 근무국가명
SELECT EMP_ID, EMP_NAME, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
JOIN LOCATION ON LOCAL_CODE = LOCATION_ID
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';

-- 러시아 근무하는 사원의 사번, 사원명, 부서명, 급여, 근무국가명
SELECT EMP_ID, EMP_NAME, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
JOIN LOCATION ON LOCAL_CODE = LOCATION_ID
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '러시아';

-- 일본 근무하는 사원의 사번, 사원명, 부서명, 급여, 근무국가명
SELECT EMP_ID, EMP_NAME, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
JOIN LOCATION ON LOCAL_CODE = LOCATION_ID
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '일본';

-- 위처럼 나라명만 바꾸면 되는 복잡하고 긴 셀렉문을 VIEW로 짧게 줄일수 있다
--------------------------------------------------------------------------------
/*
    1. VIEW생성
    
    [표현법]
    CREATE VIEW 뷰명
    AS 서브쿼리;
    
    *VIWE도 컬럼에 별칭부여 가능
*/
CREATE VIEW VM_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, SALARY, NATIONAL_NAME
    FROM EMPLOYEE
     JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
     JOIN LOCATION ON LOCAL_CODE = LOCATION_ID
     JOIN NATIONAL USING (NATIONAL_CODE);

--GRANT CREATE VIEW TO TJOEUN; -- VIEW를 생성하기 위해서는 권한을 줘야한다. 이 구문만 관리자계정으로 바꾼후 실행 함

SELECT * FROM VM_EMPLOYEE;

--한국에서 근무하는사원 조회
SELECT *
FROM VM_EMPLOYEE
WHERE NATIONAL_NAME = '한국';

SELECT *
FROM VM_EMPLOYEE
WHERE NATIONAL_NAME = '러시아';

SELECT *
FROM VM_EMPLOYEE
WHERE NATIONAL_NAME = '일본';
--------------------------------------------------------------------------------
/*
    *뷰컬럼에 별칭부여
        서브쿼리의 서브쿼리에 함수식, 산술식이 기술되면 반드시 별칭 부여해 줘야함

*/
-- 전 사원의 사번, 사원명, 직급명, 성별(남/여), 근무년수를 조회할 수있는 VIEW(VM_EMP_JOB)를 생성하시오
-- CREAT OR REPLACE CIEW : 이미 같은 이름의 뷰가 있으면 덮어쓰기 함. 없으면 생성
CREATE OR REPLACE VIEW VM_EMP_JOB
AS SELECT EMP_ID,
       EMP_NAME,
       JOB_NAME,
       DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여') 성별,
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);
-- 함수식이 들어간 컬럼에 별칭 부여 안하면 오류뜸 별칭 꼭 부여하기


-- 별칭을 다른 방식으로도 부여 가능
CREATE OR REPLACE VIEW VM_EMP_JOB(사번, 사원명, 직급명, 성별, 근무년수)
AS SELECT EMP_ID,
       EMP_NAME,
       JOB_NAME,
       DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여'),
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- 뷰에서 성별이 여자인 사원의 사원명, 근무년수 가져오기
SELECT 사원명, 근무년수
FROM VM_EMP_JOB
WHERE 성별 = '여';

--뷰에서 근무년수가 30년이상인 사원 가져오기
SELECT 사원명,직급명, 근무년수
FROM VM_EMP_JOB
WHERE 근무년수 >= 30;

--------------------------------------------------------------------------------
/*
    *뷰 삭제
    DROP VIEW 뷰명

    테이블 삭제와 같아
    
*/
DROP VIEW VM_EMP_JOB;


--------------------------------------------------------------------------------
/*
    * 생성된 VIEW를 통해 DML사용
        VIEW에서 INSERET, UPDATE, DELETE를 실행하면 실제 데이터베이스에 반영됨
    
*/
-- 뷰(VM_JOB) JOB테이브르이 모든컬럼 서브쿼리
CREATE OR REPLACE VIEW VM_JOB
AS SELECT * FROM JOB;

--뷰에 한행추가
INSERT INTO VM_JOB VALUES('J8','인턴');

SELECT * FROM JOB;
SELECT * FROM VM_JOB;

--뷰에 UPDATE
UPDATE VM_JOB SET 직급명 = '알바'
WHERE 직급코드 = 'J8';

--뷰에서 삭제
DELETE FROM VM_JOB
WHERE 직급코드 = 'J8';

/*
    *단, DML명령어로 조작이 불가능한 경우가 더 많음
        1) 뷰에 정의되지않은 컬럼을 조작하고자 하는 경우
        2) 뷰의 정의되어 있는 컬럼 중에 원본테이블 상에 NOT NULL제약조건이 지정되어 있는경우
        3) 산술식 함수식으로 정의 되어 있는 경우
        4) 그룹함수(SUM, AVG, COUNT)나 GROUP BY절이 포함되어 있는 경우
        5) DISTINCT(중복제외) 구문이 포함된 경우(원본 테이블에서 중복된 값중에 VIEW에서 변경할 행이 어떤컬럼인지 알수없다)
        6) JOIN을 이용하여 여러 테이블을 연결 시켜놓은 경우
        
*/
--1) 뷰에 정의되어 있지 않은 컬럼을 조작하고자 하는경우
CREATE OR REPLACE VIEW VM_JOB
AS SELECT JOB_CODE FROM JOB;


SELECT * FROM JOB;
SELECT * FROM VM_JOB;

--INSERT(오류)
INSERT INTO VM_JOB(JOB_CODE, JOV_NAME) VALUES('J8','인턴'); -- 뷰에없는 컬럼에 값을 입력하려고 함

--UPDATE(오류)
UPDATE VM_JOB
    SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J7'; -- 뷰에는 JOB_NAME이 없어어 오류
--DELETE(오류)
DELETE
 FROM VM_JOB
 WHERE JOB_NAME = '사원';
 
 
-- 2) 뷰의 정의되어 있는 컬럼 중에 원본테이블 상에 NOT NULL제약조건이 지정되어 있는경우


CREATE OR REPLACE VIEW VM_JOB
AS SELECT JOB_NAME FROM JOB;


SELECT * FROM JOB;
SELECT * FROM VM_JOB;

--INSERT(오류)
INSERT INTO VM_JOB VALUES('인턴'); -- 원본에 같은행에 값들중에 NOT NULL제약조건이 있으면 뷰에서는 사용하지 않는 컬럼이라 하더라도 행을 추가할수 없다
-- 이대로 INSERT하면 실제 원본테이블에는 (NULL, '인턴'); 과 같은형태로 들어가게되는것 , JOB_CODE는 NULL값 허용 안하므로 오류

--UPDATE(성공)
UPDATE VM_JOB 
    SET JOB_NAME = '인턴'
    WHERE JOB_NAME = '사원';

--DELETE 할 때 부모테이블을 VIEW로 만들었다면 외래키 제약조건도 따져야 한다.
-- 자식테이블에 쓰고 있는 데이터라면 삭제 안됨



-- 3) 산술식 함수식으로 정의 되어 있는 경우
CREATE OR REPLACE VIEW VM_EMP_SAL
    AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 연봉
    FROM EMPLOYEE;

--INSERT (오류) : 연봉은 원본테이블에 없는 컬럼
INSERT INTO VM_EMP_SAL VALUES(300,'김상진', 3000000, 36000000);
--오류 보고 -SQL 오류: ORA-01733: 가상 열은 사용할 수 없습니다

--UPDATE(오류) : 연봉은 원본테이블 없는 컬럼
UPDATE VM_EMP_SAL
    SET 연봉 = 20000000
    WHERE EMP_ID = 214;
    
--UPDATE (성공)
UPDATE VM_EMP_SAL
 SET SALARY = 2000000
 WHERE EMP_ID = 214;
--이건 가능하다

ROLLBACK;


--4) 그룹함수(SUM, AVG, COUNT)나 GROUP BY절이 포함되어 있는 경우
CREATE OR REPLACE VIEW VM_GROUP_DEPT
    AS SELECT DEPT_CODE, SUM(SALARY) 합계, CEIL(AVG(SALARY)) 평균
            FROM EMPLOYEE
            GROUP BY DEPT_CODE;
            

--INSERT (오류) : VIEW에서 작업하는건 원본에도 적용됨. VM_GROUP_DEPT에는 각 그룹이 하나지만 원본에는 여러 DEPT_CODE가 있으므로 어떤 DEPT_CODE인지 알수없어 오류
INSERT INTO VM_GROUP_DEPT VALUES('D3',8000000,4000000); 

--UPDATE (오류)
UPDATE VM_GROUP_DEPT
    SET 합계 = 9000000
WHERE DEPT_CODE = 'D1';

--DELETE(오류)
DELETE FROM VM_GROUP_DEPT
WHERE DEPT_CODE = 'D1';


-- 5) DISTINCT(중복제외) 구문이 포함된 경우
--(원본 테이블에서 중복된 값중에 VIEW에서 변경할 행이 어떤컬럼인지 알수없다)
CREATE OR REPLACE VIEW VM_JOB
AS SELECT DISTINCT JOB_CODE
    FROM EMPLOYEE;
    
--INSERT (오류)
INSERT INTO VM_JOB VALUES('J8');

--UPDATE (오류)
UPDATE VM_JOB
    SET JOB_CODE = 'J8'
WHERE VM_JOB = 'J1';

--DELETE(오류)
DELETE FROM VM_JOB
WHERE JOB_CODE = 'J2';



--  6) JOIN을 이용하여 여러 테이블을 연결 시켜놓은 경우
CREATE OR REPLACE VIEW VM_JOIN
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
    
--INSERT (오류)
INSERT INTO VM_JOIN VALUES(600,'황미연','회계관리부');

--UPDATE (성공) 성공
UPDATE VM_JOIN 
    SET EMP_NAME = '김새로'
WHERE EMP_ID = 201;

--UPDATE(오류) 
UPDATE VM_JOIN 
 SET DEPT_TITLE = '인사관리부'
 WHERE EMP_ID = 201;

--DELETE
DELETE FROM VM_JOIN
WHERE EMP_ID = 200;


----------------------------------------------------------------------------
/*
*VIEW 옵션
    CREATE [OR REPLACE] [FORCE | NOFORCE]VIEW 뷰명
    AS 서브쿼리
    [WITH CHECK OPTION]
    [WITH READ ONLY];
    
    1) OR REPLACE : 기존에 동일한 뷰가 있다면 덮어쓰기, 없다면 새로 생성
    2) FORCE | NOFORCE
      >FORCE : 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰가 생성됨
      >NOFORCE : 서브쿼리에 기술된 테이블이 존재해야만 뷰가 생성됨(생략시 기본값)
    3) WITH CHECK OPTION : DML(UPDATE,DELETE,INSERT)시 서브쿼리에 기술된 조건에 부합한 값으로만 DML가능하도록 함
    4) WITH READ ONLY : DML을 수행할수 없고 뷰 조회(SELECT)만 가능    
        
*/
--2) FORCE | NOFORCE
--  NOFORCE
CREATE OR REPLACE NOFORCE VIEW VM_EMP
AS SELECT TCODE, TNAME, TCONTENT
    FROM IT;    --IT라는 테이블은 없다 NOFORCE 설정이므로 뷰생성 불가능


--  FORCE
CREATE OR REPLACE FORCE VIEW VM_EMP
AS SELECT TCODE, TNAME, TCONTENT
    FROM IT;    --IT라는 테이블은 없지만 FORCE 설정이므로 뷰생성 가능


INSERT INTO VM_EMP VALUES(1,'NAME','CONTENT'); --오류 해당 뷰를 FORCE설정으로 생성하긴 했지만 안에 자료형등 설정이 안되어있으므로 INSERT 불가
-- 실제 뷰를 사용하려면 IT라는 실존테이블이 있어야 사용가능
CREATE TABLE IT (
    TCODE NUMBER,
    TNAME VARCHAR2(20),
    TCONTENT VARCHAR2(100)  
);


--3) WITH CHECK OPTION

--WITH를 사용하지 않았을 때
CREATE OR REPLACE VIEW VM_EMP
AS SELECT *
    FROM EMPLOYEE
    WHERE SALARY >= 3000000;


--UPDATE 204번의 급여를 2000000으로 수정
UPDATE VM_EMP
 SET SALARY = 2000000
 WHERE EMP_ID = 204;


ROLLBACK;

--WITH를 사용하여 VIEW 생성

CREATE OR REPLACE VIEW VM_EMP
AS SELECT *
    FROM EMPLOYEE
    WHERE SALARY >= 3000000
WITH CHECK OPTION;
    
--UPDATE 204번의 급여를 2000000으로 수정
UPDATE VM_EMP
 SET SALARY = 2000000
 WHERE EMP_ID = 204;
--오류 보고 -SQL 오류: ORA-01402: 뷰의 WITH CHECK OPTION의 조건에 위배 됩니다
--WITH CHECK OPIONT (3000000미만으로는 수정 불가

UPDATE VM_EMP
 SET SALARY = 4000000
 WHERE EMP_ID = 204;
 --이건 가능
 
ROLLBACK;

--4) WITH READ ONLY 
CREATE OR REPLACE VIEW VM_EMP
AS SELECT EMP_ID, EMP_NAME, BONUS
    FROM EMPLOYEE
    WHERE BONUS IS NOT NULL
    WITH READ ONLY;
    
DELETE FROM VM_EMP WHERE EMP_ID = 204; -- 오류(DML실행 불가)
--오류 보고 - SQL 오류: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.

SELECT * FROM VM_EMP; -- SELECT는 가능



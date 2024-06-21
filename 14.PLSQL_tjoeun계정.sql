/*
    *PL / SQL
    PROCEDURAL LANGUAGE EXTENSION TO SQL
    
    오라클 자체에 내장되어있는 절차적 언어 (프로그램)
    SQL문장 내에서 변수의 정의, 조건처리(IF), 반복처리(LOOP, FOR, WHILE)등을 지원하여
    SQL의 단점을 보완함
    다수의 SQL문을 한번에 실행 가능(BLOCK구조)
    
    *구조
    -[선언부(DECLARE SECTION)]: DECLARE로 시작, 변수나 상수를 선언 및 초기화 하는 부분
    -실행부(EXECUTABLE SECTION) : BEGIN 으로 시작, SQL문 또는 제어문(조건문, 반복문)등의 로직을 기술하는 부분
    -[예외처리(EXCEPTION SECTION)] : EXCEPTION 으로 시작, 예외 발생시 해결하기 위한 구문을 미리 기술해 두는 부분

*/

--===============================* 화면에 출력하기 ===================================
SET SERVEROUTPUT ON;
-- 이걸 설정해줘야 화면에 출력할수있음 
-- 오라클 껐다가 다시키면 다시 설정해야함

--HELLO ORACLE을 출력해보자
BEGIN
 DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/

-- = System.out.println("HELLO ORACLE"); 과 같다

/*
    1.DECLARE 선언부
    변수, 상수 선언하는 공간(선언과 동시에 초기화도 가능)
    일반타입변수, 레퍼런스타입의 변수, ROW타입의 변수
    
    1.1 일반타입변수 선언 및 초기화
        [표현식] 
        변수명 [CONSTANT]자료형 [:= 값];  --> := 값 안넣어주면 초기화를 안한것, 상수일땐 CONSTANT를 써준다

*/
DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.1415;

BEGIN
    EID := 600;
    ENAME := '임수정';
    

DBMS_OUTPUT.PUT_LINE('EID : '||EID);
DBMS_OUTPUT.PUT_LINE('ENAME : '||ENAME);
DBMS_OUTPUT.PUT_LINE('PI : '||PI);
END;
/


-- 사용자로부터 값을 받아서 출력하기 자바에 스캐너같은거
-- 변수명 앞에 &을 붙이면됨 문자열이면 '&변수명' 이렇게 안에 같이 넣기
DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.1415;
BEGIN
    EID := &번호;
    ENAME := '&이름';
    
    DBMS_OUTPUT.PUT_LINE('EID : '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : '||PI);
END;
/
-------------------------------------------------------------------------------------------
/*
    1.2 레퍼런스타입변수 선언 및 초기화
     : 어떤 테이블의 어떤 컬럼의 테이터타입을 참조하여 그 타입으로 지정
     
     [표현식]
       변수명 테이블명.컬럼명%TYPE;

*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    EID := '300';
    ENAME := '유재석';
    SAL := 4000000;

    DBMS_OUTPUT.PUT_LINE('EID : '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||SAL);
END;
/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    --사번이 200번인 사원의 사번, 이름, 급여 조회하여 각 변수에 대입
    SELECT EMP_ID, EMP_NAME, SALARY
      INTO EID, ENAME, SAL
        FROM EMPLOYEE
        WHERE EMP_ID = &사번;
        
    DBMS_OUTPUT.PUT_LINE('EID : '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||SAL);

END;
/

-----------------------------실습문제--------------------------------------------
/*
    레퍼런스타입변수로 EID, ENAME, JCODE, SAL, DTITLE를 선언하고
    각 자료형 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALAARY), DEPARTMENT(DEPT_TITLE)들을 참조하도록
    
    사용자가 입력한 사번의 사원의 사번, 사원명, 직급코드, 급여, 부서명 조회 한 후 각 변수에 담아 출력
*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID,ENAME,JCODE,SAL,DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
    WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('EID : '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE : '||JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL : '||SAL);
    DBMS_OUTPUT.PUT_LINE('DTITLE : '||DTITLE);
END;
/

-------------------------------------------------------------------------------------
/*
    1.3 ROW타입의 변수
     : 테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수
     
     [표현식]
     변수명 테이블명%ROWTYPE;
*/
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * 
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;

DBMS_OUTPUT.PUT_LINE('사원명 : '||E.EMP_NAME);
DBMS_OUTPUT.PUT_LINE('급여 : '||E.SALARY);
--DBMS_OUTPUT.PUT_LINE('보너스 : '||E.BONUS);
--DBMS_OUTPUT.PUT_LINE('보너스 : '||NVL((E.BONUS),'없음'));
DBMS_OUTPUT.PUT_LINE('보너스 : '||NVL((E.BONUS),0));
END;
/

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT EMP_NAME, SALARY, BONUS  -- 이렇게하면 안된다. ROWTYPE을 사용할땐 무조건 * 을가져와야한다.
    INTO E                          -- ROWTYPE 변수가 모든 컬럼을 받는것이므로 SELECT에서 선택적으로 컬럼을 가져오면 나머지값은 알수 없다
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    DBMS_OUTPUT.PUT_LINE('사원명 : '||E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||E.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스 : '||NVL((E.BONUS),0));
END;
/

-------------------------------------------------------------------------------------
/*
    2.실행부
    
        <조건부>
        1) IF 조건식 THEN 실행내용 END IF; (단일 IF문)
*/

-- 사번을 입력받아 사번, 이름, 급여, 보너스(%) 출력
-- 단, 보너스를 받지 않는 사원은 '보너스를 지급받지 않는 사원입니다' 출력

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
  SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO EID, ENAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사번 : '||EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||SALARY);
    
    IF BONUS = 0
    THEN DBMS_OUTPUT.PUT_LINE('보너스를 받지 않는 사원입니다.');
    END IF;
    
    
    DBMS_OUTPUT.PUT_LINE('보너스 : '||BONUS*100||'%');
END;
/


-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF;   (IF-ELSE)

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
  SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO EID, ENAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사번 : '||EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||SALARY);
    
    IF BONUS = 0
    THEN DBMS_OUTPUT.PUT_LINE('보너스를 받지 않는 사원입니다.');
   
    ELSE
         DBMS_OUTPUT.PUT_LINE('보너스 : '||BONUS*100||'%');
    END IF;

END;
/


-----------------------------실습문제--------------------------------------------
/*
    레퍼런스 변수 : EID, ENAME, DTITLE, NCODE
        참조컬럼 : EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    일반변수 : TEAM(소속)

    실행 : 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 변수에 대입
        단) NCODE값이 KO일 경우 => TEAM변수에 '국내팀'
            NCODE값이 KO가 아닐경우 => TEAM변수에 '해외팀'
        출력 : 사번, 이름, 부서명, 소속
*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(10);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCAL_CODE = LOCATION_ID
    JOIN NATIONAL USING (NATIONAL_CODE)
    WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사번 : '||EID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : '||DTITLE);
    IF NCODE = 'KO'
        THEN TEAM := '국내팀';
    ELSE
        TEAM := '해외팀';
    END IF;
    DBMS_OUTPUT.PUT_LINE('소속 : '|| TEAM);

    
    END;
    /
        


-------------------------------------------------------------------------------------
/*    
  3)IF-ELSE IF 조건문
    IF 조건식 1
        THEN 실행 내용1
    ELSIF 조건식 2
        THEN 실행 내용2
    ELSIF 조건식 3
        THEN 실행 내용3
    ELSE
        실행 내용4
    END IF;
  
*/  
-- 사용자로부터 시험점수를 입력받아 점수별로 학점 출력

DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE := &점수;
    
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 '||SCORE||'점 이고 학점은 '||GRADE||' 입니다');

END;
/
---------------------------------------실습문제----------------------------------------------
/*
    사용자로부터 사번을 입력받아 사원의 급여를 조회하여 SAL변수에 저장
    500만원 이상이면 '고급'
    499~300만원 이면'중급'
    나머지 '초급
*/
--DECLARE
--    EID NUMBER := &사번;
--    SAL;

-------------------------------------------------------------------------------------------
/*
    4) CASE 문(WEITH CASE 문과 동일)
        CASE 비교대상자
            WHEN 비교할 값1 THEN 실행내용1
            WHEN 비교할 값2 THEN 실행내용2
            WHEN 비교할 값3 THEN 실행내용3
            ELSE 실행내용4          => Default와 같음  
        END;
*/
-- 사용자로부터 사번을 입력받아 DEPT_CODE를 조회해서
-- DEPT_CODE가 D1이면 인사관리부....
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DCODE EMPLOYEE.DEPT_CODE%TYPE;
    DNAME VARCHAR2(30);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_CODE
    INTO EID,ENAME, DCODE
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DNAME := CASE DCODE
        WHEN 'D1' THEN '인사관리부'
        WHEN 'D2' THEN '회계관리부'
        WHEN 'D3' THEN '마케팅부'
        WHEN 'D4' THEN '국내영업부'
--        WHEN 'D5' THEN DNAME := '해외영업1부'
--        WHEN 'D6' THEN DNAME := '해외영업2부'
--        WHEN 'D7' THEN DNAME := '해외영업3부'
        WHEN 'D8' THEN '기술지원부'
        WHEN 'D9' THEN '총무부'
        ELSE '해외영업부'
        
    END;
    DBMS_OUTPUT.PUT_LINE(ENAME||'는 '|| DNAME||'입니다');
END;
/

--------------------------------------------------------------------------------------
/*
    <LOOP>
    (1) LOOP문
    
    [표현식]
    LOOP
        반복적으로 실행할 구문;
        -반복문을 빠져나갈 구문;
    END LOOP;
    
    * 반복문을 빠져나갈 조건문 2가지
     - IF 조건식 THEN EXIT; END IF;
     - EXIT WHEN 조건식;
     

*/

--IF 조건식 THEN EXIT; END IF;
DECLARE 
    N NUMBER :=1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N+1;
        
        IF N = 6 THEN EXIT;
        END IF;
    END LOOP;
END;
/

--EXIT WHEN 조건식;
DECLARE 
    N NUMBER :=1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N+1;
        
        EXIT WHEN N=6;
    END LOOP;
END;
/

--------------------------------------------------------------------------------------
/*
    (2) FOR LOOP문
    FOR 변수 IN [REVERSE] 초기값..최종값
    LOOP
        반복할 실행문;
    END LOOP;

*/
--1~5까지 출력
BEGIN
    FOR I IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/
    
    
--REVERSE   
--5~1까지 출력
BEGIN
    FOR I IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/    

DROP TABLE TEST;

CREATE TABLE TEST(
    TNO NUMBER PRIMARY KEY,
    TDATE DATE
);


CREATE SEQUENCE SEQ_TNO;

BEGIN
    FOR J IN 1..100
    LOOP
        INSERT INTO TEST VALUES(SEQ_TNO.NEXTVAL,SYSDATE);
    END LOOP;
END;
/

--------------------------------------------------------------------------------------
/*
    (3)WHILE LOOP문
    
    [표현식]
    WHILE 반복문이 수행할 조건 (참이면 수행 거짓이면 빠져나옴)
    LOOP
        반복할 실행문;
    END LOOP;
*/

--1~5까지 출력해보자
DECLARE
    N NUMBER := 1;

BEGIN
    WHILE N<=5
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N+1;
    END LOOP;
END;
/
    


--------------------------------------------------------------------------------------
/*
    3. 예외처리부
    EXCEPTION : 예외를 처리하는 구문
    
    [표현식]
    EXCEPTION
        WHEN 예외명1 THEN 예외처리구문1;
        WHEN 예외명2 THEN 예외처리구문2;
        ...
        WHEN OTHERS THEN 예외처리구문N; (모든 예외처리)
    
    * 시스템 예외(오라클에서 미리정의해둔 예외)
     - NO_DATE_FOUND : SELECT한 결과가 한 행도 없을 경우
     - TOO_MANY_ROWS : SELECT한 결과가 여러행 일 경우
     - ZERO_DIVIDE : 0으로 나눌 때
     - DUP_VAL_ON_INDEX : UNIQUE제약조건에 위배되었을 때
     ...

*/

--ZERO_DIVIDE : 0으로 나눌 때   
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10/&숫자;
    DBMS_OUTPUT.PUT_LINE('결과 : '||RESULT);
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다');
END;
/
    
    
-- DUP_VAL_ON_INDEX : UNIQUE제약조건에 위배되었을 때
BEGIN
    UPDATE EMPLOYEE
        SET EMP_ID = '&변경할사번'
    WHERE EMP_NAME = '김새로';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다');
END;
/


-- TOO_MANY_ROWS : SELECT한 결과가 여러행 일 경우

-- 사수번호가 211번은 1명, 사수번호가 200번은 5명, 202번은 없음
-- 사수번호를 입력받아 사수로 가지고 있는 사원의 정보 출력
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EID, ENAME
    FROM EMPLOYEE
    WHERE MANAGER_ID = &사수사번;

    DBMS_OUTPUT.PUT_LINE('사번 : '||EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : '||ENAME);
EXCEPTION 
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 행이 조회되었습니다');
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회 결과가 없습니다');

END;
/


------------------------------연습문제------------------------------------
/*
1. 사원의 연봉을 구하는 PL/SQL작성, 보너스가 있는 사원은 보너스도 포함하여 계산
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    ESAL EMPLOYEE.SALARY%TYPE;
    EBONUS EMPLOYEE.BONUS%TYPE;
    
BEGIN
    SELECT EMP_ID,EMP_NAME, SALARY, SALARY*(1+(NVL(BONUS,0)))*12 연봉
    INTO EID, ENAME, ESAL, EBONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE(ENAME||'사원의 연봉은 '||TO_CHAR(EBONUS,'FML999,999,999')||'원 이다');
END;
/


/*
2. 구구단 짝수단 출력
    2-1) FOR LOOP
    2-2) WHILE LOOP

*/
--DECLARE
--    X NUMBER := 2;
--    Y NUMBER := 1;
--BEGIN

--FOR LOOP

BEGIN
    FOR X IN 2..8
             LOOP
      IF X IN (2,4,6,8)
        THEN
            FOR Y IN 1..9
            LOOP
                DBMS_OUTPUT.PUT_LINE(X || ' * ' ||Y|| ' = ' || X*Y);
            END LOOP;
                    END IF;

        END LOOP;
        
END;
/

--교수님 풀이
BEGIN
    FOR DAN IN 2..9
    LOOP
        IF MOD(DAN,2) = 0
            THEN
                FOR SU IN 1..9
                    LOOP
                        DBMS_OUTPUT.PUT_LINE(DAN||'*'||SU||'='||DAN*SU);
                    END LOOP;
                DBMS_OUTPUT.PUT_LINE('');
            END IF;
        END LOOP;
    END;
/

    
--WHILE LOOP
DECLARE
    X NUMBER := 2;
    Y NUMBER := 1;
BEGIN
    WHILE X <= 9
     LOOP
        Y := 1;
        WHILE Y<=9
        LOOP
        DBMS_OUTPUT.PUT_LINE(X || ' * ' ||Y|| ' = ' || X*Y);
        Y := Y+1;
        END LOOP;
       DBMS_OUTPUT.PUT_LINE(''); 
     X := X+2;
     END LOOP;
END;
/

    
/*
                <   함   수   >
                전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
                
                - 단일행 함수 : n개의 값을 읽어들여 n개의 결과값 반환(매 행마다 실행)
                - 그룹 함수 : n개의 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
                
                >> select절에 단일행 함수와 그룹함수를 함께 사용할 수 없다.
                >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, 


*/

-----------------------------------단일행 함수----------------------------------------
--=========================================================================
--                                      문자처리 함수
--=====================================================================
/*
        LENGTH / LENGTHB => NUMBER로 반환
        
        LENGTH(컬럼 |'문자열') : 해당 문자열의 글자수 반환
        LENGTHB(컬럼 |'문자열') : 해당 문자열의 BYTE수 반환
            - 한글 : XE버전일때 => 1글자당 3BYTE(ㄱ, ㅏ 등도 3BYTE)
                      EE버전일 때 => 1글자당 2BYTE
            - 그외 : 1글자당 1BYTE
            
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
    FROM DUAL;      -- DUAL : 오라클에서 제공하는 가상테이블 연습용으로 많이 쓰임

SELECT LENGTH('OLACLE'), LENGTHB('ORCLE')
    FROM DUAL;
    
SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME),
          EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
    FROM EMPLOYEE;



--------------------------------------------------------------------------
/*
    * INSTR : 문자열로부터 특정문자의 시작위치(INDEX)를 찾아서 반환(반환형: NUMBER)
        - ORACLE에서 INDEX번호는 1부터 시작, 찾을 문자가 없으면 0반환
        
        [표현법]
        INSTR(컬럼 | '문자열', '찾고자하는 문자', [찾을위치의 시작값, [순번]])
            - 찾을위치 시작값
               1 : 앞에서부터 찾기(기본값)
              -1 : 뒤에서부터 찾기
*/

    select instr('JAVASCRIPTJAVAORACLE', 'A' ) FROM DUAL;
    select instr('JAVASCRIPTJAVAORACLE', 'A', 1 ) FROM DUAL;  -- 시작값 1  : 앞에서부터 A 찾기 위랑 결과같음
    select instr('JAVASCRIPTJAVAORACLE', 'A', -1 ) FROM DUAL; -- 시작값 -1 : 뒤에서부터 A 찾기
    select instr('JAVASCRIPTJAVAORACLE', 'A', 1, 3 ) FROM DUAL;  --  시작값 1 순번 3 : 앞에서부터 3번째 A 위치값 반환
    select instr('JAVASCRIPTJAVAORACLE', 'A', -1, 2 ) FROM DUAL; -- 시작값 -1 순번 2 : 뒤에서부터 2번째 A 위치값 반환
    select instr('JAVASCRIPTJAVAORACLE', 'A',  5 ) FROM DUAL;   -- 시작값 기본값 순번 5 : 앞에서부터 5번째 A 위치 값 반환 

    select instr('JAVASCRIPTJAVAORACLE', 'A', 3 ) FROM DUAL; 


-- EMAIL에서 '_'과 '@' 위치를 찾아보자     
SELECT  EMAIL, INSTR(EMAIL, '_') "_의 위치", INSTR(EMAIL, '@') "@의 위치" -- 값이 없으면 0 반환됨
    FROM EMPLOYEE;


---------------------------------------------------------------------------------------
/*
    *SUBSTR : 문자열에서 특정 문자열을 추출하여 반환(반환형 : NUMBER)
        [표현법]
        SUBSTR(컬럼| '문자열', POSITION, [LENGTH])
        -POSITION : 문자열을 추출할 시작위치 INDEX
        -LENGTH : 추출할 문자의 갯수 (생략시 마지막까지 추출)


*/

SELECT SUBSTR ('ORACLEHTMLCSS', 7) FROM DUAL;
SELECT SUBSTR ('ORACLEHTMLCSS', 7, 4) FROM DUAL;
SELECT SUBSTR ('ORACLEHTMLCSS', 1,6) FROM DUAL;
SELECT SUBSTR ('ORACLEHTMLCSS', -7,4) FROM DUAL; -- 음수는 뒤에서부터 시작위치를 셈

--EMPLOYEE 에서 사원명, 주민번호, 성별(주민번호에서 성별만 추출하기)
SELECT EMP_NAME, EMP_NO, SUBSTR (EMP_NO, 8,1) 성별
    FROM EMPLOYEE;

-- EMPLOYEE에서 여자사원들의 사원번호, 사원명, 성별조회
SELECT EMP_ID, EMP_NAME, SUBSTR (EMP_NO, 8,1) 성별
    FROM EMPLOYEE
--    WHERE EMP_NO LIKE '_______2%' OR EMP_NO LIKE '_______4%';
    WHERE SUBSTR (EMP_NO, 8,1) IN (1, 3)
    ORDER BY 2;
    
-- EMPLOYEE 에서 사원명, 이메일, @기준 앞자리 조회(아이디 조회)
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1) 아이디
    FROM EMPLOYEE;
------------------------------------------------------------

/*
    *LPAD / RPAD : 문자열을 조회할 때 통일감있게 조회하고자 할 때 (O반환형 : CHARACTER)
        [] 대괄호친건 옵션. 넣어도되고 안넣어도 됨.
        [표현법]
        LPAD/RPAD ('문자열', 최종적으로 반환할 문자의 길이, [덧붙이고자하는 문자(선택)]
         - 문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N길이만큼의 문자열 반환
             
*/
-- EMPLOYEE에서 사원명, 이메일(길이 25, 오른쪽 정렬)
SELECT EMP_NAME, EMAIL, LPAD(EMAIL, 25)  -- 왼쪽기준 길이 25만큼 글 정렬됨. 원하는글자 덧붙였으면 그만큼 글 넣은후 남은 공간은 길이가 20이 될때까지 공백으로 채우거나 잘림
    FROM employee;
    
SELECT EMP_NAME, EMAIL, LPAD(EMAIL, 25, '#')
    FROM EMPLOYEE;
    
SELECT EMP_NAME, EMAIL, RPAD(EMAIL, 25, '#')
    FROM EMPLOYEE;    
    
-- EMPLOYEE에서 사번, 사원명, 주민번호(단, 123456-1****** 형식으로 출력)
SELECT EMP_ID 사번, EMP_NAME 사원명, RPAD(SUBSTR(EMP_NO, 1,8),14,'*') 주민번호
    FROM EMPLOYEE;

SELECT EMP_ID 사번, EMP_NAME 사원명, SUBSTR(EMP_NO, 1,8) || '******' 주민번호
    FROM EMPLOYEE;
    
    
----------------------------------------------------------------

/*
    * LTRIM/RTRIM : 문자열에서 특정문자를 제거한 나머지를 반환 (반환형 : CHARACTER)
    
    * TRIM : 문자열에서 앞/뒤 양쪽에 있는 특정문자를 제거한 나머지를 반환 반환형 같음
        -주의사항: 제거할 문자 1글자만 가능( LTRIM/RTRIM에서는 여러글자 가능 )
    
    [표현법]
    LTRIM / RTRIM('문자열', [제거하고자하는 문자들]) => [] 안넣으면 공백을 제거함
    
    TRIM([LEADING|TRAILING|BOTH] 제거하고자하는 문자들 FROM '문자열' => [] 안에 세개중 하나. 안넣으면 기본이 양쪽다제거
            -LEADING : 앞 제거(LTRIM 과 같음)
            -TRAILING : 뒤 제거(RTRIM 과 같음
    
        
    문자열의 왼쪽 또는 오른쪽으로 제거하고자하는 문자들을 찾아서 제거한 나머지 문자열 반환
*/

--제거하고자하는 문자를 넣지않으면 공백 제거
SELECT LTRIM('      TJOEUN        ')||'학원' FROM DUAL; -- 아무것도 안넣었으니 왼쪽공백제거됨
SELECT RTRIM('      TJOEUN        ')||'학원' FROM DUAL; -- 아무것도 안넣었으니 오른쪽공백제거됨

SELECT LTRIM('JAVAJAVASCRIPT', 'JAVA') FROM DUAL;-- 자바 두개 제거
SELECT LTRIM('JAVA JAVASCRIPT', 'JAVA') FROM DUAL;-- 공백이나 다른글씨가있으면 그 뒤부터 자바를 찾음 => 공백뒤에 자바 한개 제거

SELECT LTRIM('BACACABCFISDACB', 'ABC') FROM DUAL; -- FISDACB 출력됨. 단어구분이아니라 글자기준으로 해당값 제거
SELECT LTRIM('37284BAC38290','0123456789') FROM DUAL; -- 숫자만 제거됨

SELECT RTRIM('BACACABCFISDACB', 'ABC') FROM DUAL; -- BACACABCFISD 출력됨. RTRIM은 뒤에서부터 제거함
SELECT RTRIM('37284BAC38290','0123456789') FROM DUAL; -- 뒤에 숫자만 제거됨

--BOTH가 기본값 : 양쪽제거
SELECT TRIM ('        TJOEUN         ') FROM DUAL; -- 앞뒤 공백제거 TRIM 사용시 기준 입력 안할시 앞뒤 공백 제거 기본값
SELECT TRIM ('A' FROM 'AAABAKAEFWKAAA') FROM DUAL; -- 앞뒤 'A' 제거, 
SELECT TRIM ('AB' FROM 'ABAABAKAEFWKAABA') FROM DUAL; 

SELECT TRIM(LEADING 'A' FROM 'AAABKSLEIDKAA') FROM DUAL; -- 앞을 제거하시오 (LTRIM과 같음)
SELECT TRIM(TRAILING 'A' FROM 'AAABKSLEIDKAA') FROM DUAL; -- 뒤를 제거하시오 (RTRIM과 같음)

----------------------------------------------
/*
    * LOWER /UPPER / INITCAP : 문자열을 대소문자로 변환 및 단어의 앞글자만 대문자로 변환
    [표현법]
    LOWER ('문자열') : 소문자로 변환
    UPPER ('문자열')
    INITCAP ('문자열')
*/

SELECT LOWER('Java JavaScript ORACLE') from dual; --전부 소문자로 바뀜
SELECT upper('java javaScript oracle') from dual; --전부 대문자로 바뀜
SELECT INITCAP('java javaScript jracle') from dual; -- 공백기준 첫글자만 대문자로 변환

--employee에서 이메일을 대문자로 출력해보자
select upper(email) from employee;

-----------------------------------------------------
/*
    * concat : 문자열 두개를 하나로 합친 후 반환
    
    [표현법]
    CONCAT('문자열', '문자열')
*/
 SELECT CONCAT('Oracle','오라클') FROM DUAL;
 SELECT 'Oracle'||'오라클' from dual;   --위와 같은 결과
 
-- SELECT CONCAT('Oracle', '오라클','02-1234-5678') from dual;  -- 이렇게하면 오류. 문자열(인수)는 2개만 추가 할수있다.
 ------------------------------------------------------------------
 /*
    * REPLACE : 기존문자열을 새로운 문자열로 바꿈
    
    [표현법]
    REPLACE('문자열','기존문자열','바꿀문자열')
    
 
 */
 
 -- EMPLOYEE에서 EMAIL의 문자를 tjoeun.or.kr -> naver.com 바꾸어 출력
 SELECT EMAIL, REPLACE (EMAIL,'tjoeun.or.kr','naver.com') "변경된 이메일" from employee; 
 
 ----------------------------------------------------------------
 /*
    *ABS : 숫자의 절대값을 구하는 함수
    
    [표현법]
    ABS(NUMBER)
 
 */
 
SELECT ABS(-5) FROM DUAL;
SELECT ABS(-3.14) FROM DUAL; 
-------------------------------------------------------------------
/*
    MOD : 두 수를 나눈 나머지값 반환
    [표현법]
    MOD(NUMBER1, NUMBER2)  1에서 2를 나눈 나머지
*/
SELECT MOD( 10,3) FROM DUAL;
SELECT MOD( 5,2) FROM DUAL;
 
 --------------------------------------------------------------------
 /*
    *ROUND : 반올림한 결과 반환
    
    [표현법]
    ROUND(NUMBER, [위치]) 위치생략하면 정수반환(소숫점 반올림한다는말)
 
 */
SELECT ROUND(1234.367) FROM DUAL;  --1234   
SELECT ROUND(1234.567) FROM DUAL;  --1235 
SELECT ROUND(1234.123, 2) FROM DUAL;  --1234.12 => 지정한 소숫점 둘째자리까지 반올림해서 출력
SELECT ROUND(1234567, -2) FROM DUAL;  --1234600 => - 음수값을 자리지정하면 해당하는 정수자리부터 반올림하고 아래 정수들은 전부 0으로 ㅂ변환 
---------------------------------------------------------------------
/*
    CEIL : 올림한 결과 반환(무조건 올림)
    
    [표현법]
    CEIL(NUMBER)

*/
SELECT CEIL(123.4566) FROM DUAL; --  124
SELECT CEIL(-123.4566) FROM DUAL; --  -123
---------------------------------------------------------------------
/*
    FLOOR : 내림한 결과 반환(무조건 내림)
    
    [표현법]
    FLOOR(NUMBER)

*/
SELECT FLOOR(1235.712343) FROM DUAL; --1235
SELECT FLOOR(-1235.712343) FROM DUAL; --   -1236
-------------------------------------------------------------------
/*

    TRUNC : 위치 지정 가능한 버림처리 함수
    [표현법]
    TRUNC(NUMBER, [위치지정])
*/
SELECT TRUNC(123.789) FROM DUAL; -- 위치지정 안하면 FLOOR랑 같음 무조건 내림
SELECT TRUNC(1123.789, 1) FROM DUAL; -- 1123.7 출력 => 지정한 소숫첨 첫째자리까지 남기고 다 버림.
SELECT TRUNC(1123.789, -1) FROM DUAL; -- 1120 출력 => -1 음수 자리지정하면 해당 정수자리까지 버리고 버린자리는 0으로 반환
SELECT TRUNC(-1123.789, -1) FROM DUAL; -- -1120 출력 => -1 음수 자리지정하면 해당 정수자리까지 버리고 버린자리는 0으로 반환
SELECT TRUNC(-1123.789, -2) FROM DUAL; -- -1100

--=================================================================
                    날짜처리
--=================================================================
/*
    *SYSDATE : 시스템 날짜 및 시간반환
*/

SELECT SYSDATE FROM DUAL; 
-- 현재시간 반환
--------------------------------------------------------
/*
    *MONTHS_BETWEEN(DATE1,DATE2) : 두 날짜 사이의 개월수 반환
    
    [표현법]
    MONTHS_BETWEEN(날짜1,날짜2)

*/
SELECT EMP_NAME, HIRE_DATE,CEIL(SYSDATE-HIRE_DATE) 근무일수
    FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)),'개월차') 근무개월수 
    FROM EMPLOYEE;
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' 근무개월수 
    FROM EMPLOYEE;

-------------------------------------------------------------------
/*

    *ADD_MONTHS(DATE, NUMBER) : 특정날짜에 해당 숫자만큼 개월수를 더해 반환
        => NUMBER는 개월수 단위
*/
SELECT ADD_MONTHS(SYSDATE, 1) FROM DUAL; --현재날짜에 1개월 더해진 날짜 반환

-- EMPLOYEE에서 사원명, 입사일, 입사후 정직원 날짜 (입사후 6개월) 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) "정직원된 날짜"
    FROM EMPLOYEE;

-------------------------------------------------------------------
/*

    *NEXT_DAY(DATE, 요일[문자|숫자]) : 특정날짜 이후에 가까운 해당 요일의 날짜를 반환해주는 함수 
        => 요일은 문자나 숫자 둘다 가능 (일요일 = 1)
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL; -- 오늘 날짜로부터 가장 가까운 금요일 출력
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금') FROM DUAL; -- 오늘 날짜로부터 가장 가까운 금요일 출력
SELECT SYSDATE, NEXT_DAY(SYSDATE, 6) FROM DUAL; -- 오늘 날짜로부터 가장 가까운 금요일 출력


--SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL; -- 오류 => 현재 언어설정이 한국어라 영어로 쓰면 오류뜸

-- ======================언어변경==================================
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
--SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL; -- 언어설정을 아메리칸으로 바꾸면 오류가 안뜸

ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-------------------------------------------------------------------
/*

    *LAST_DAY(DATE) : 해당월의 마지막 날짜를 반환해주는 함수
        
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;

--EMPLOYEE에서 사원명, 입사일 입사월의 마지막 날짜 출력
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) "입사한달의 마지막 날" FROM EMPLOYEE;


-------------------------------------------------------------------
/*

    * EXTRACT : 특정 날짜로 부터 년도|월|일 값을 추출하여 반환해주는 함수(반환형 : NUMBER)
    
     EXTRACT(YEAR FROM DATE) : 년도 추출
     EXTRACT(MONTH FROM DATE) : 월만 추출
     EXTRACT(DAY FROM DATE) : 일만 추출
        
*/
-- EMPLOYEE에서 사원명, 입사년도, 입사월, 입사일 조회

SELECT EMP_NAME,
            EXTRACT(YEAR FROM HIRE_DATE) 입사년도,
            EXTRACT(MONTH FROM HIRE_DATE) 입사월,
            EXTRACT(DAY FROM HIRE_DATE) 입사일
    FROM EMPLOYEE
    ORDER BY 입사년도, 입사월, 입사일;  --년도, 월, 일 순으로 올림차순 

--======================================================================
--                                형변환 함수    
--======================================================================
/*
    *TO_CHAR : 숫자 또는 날짜 타입의 값을 문자로 변환시켜주는 함수
            반환결과를 특정 형식에 맞게 출력할수 도 있다
        TO_CHAR(숫자|날짜,[포멧])   =>[포멧] 안넣으면 그대로 출력
*/
------------------> 숫자 => 문자타입
/*
    [포맷]
    * 접두어 : L -> LOCAL(설정된 나라)의 화폐단위
    * 9 : 해당자리의 숫자를 의미한다
        - 해당 자리에 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표시
    
    * 0 : 해당자리의 숫자를 의미한다    
        - 해당 자리에 값이 없을 경우 0으로 표시하고, 숫자의 길이를 고정적으로 표시할때 주로 사용
    * FM : 해당 자리에 값이 없을 경우 자리차지를 하지 않음 (그냥 99... 쓸때랑 자리차지 여부가 다름)
    
*/
SELECT TO_CHAR(1234), 1234 from dual; -- 1234 출력 보여지는건 같으나 to_char는 문자열로 형변환되어 왼쪽정렬됨.
SELECT TO_CHAR(1234)+35 , 1234+35 from dual; -- to_char사용해도 연산시 자동으로 숫자형으로 변환되어 연산후 숫자형 출력됨.

SELECT TO_CHAR(1234, '999999') from dual; --   1234
SELECT TO_CHAR(1234, '000000') from dual; -- 001234
SELECT TO_CHAR(1234, 'L999999') from dual; --          ￦1234    -- 오른쪽 정렬로 바뀜.(숫자)
-- 문자는 왼쪽정렬, 숫자는 오른쪽 정렬

SELECT TO_CHAR(1234, 'L99,999') from dual; --         ￦1,234    -- 3자리마다 , 를 찍어줄수도 있다

SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999'), TO_CHAR(SALARY*12,'L999,999,999,999') FROM EMPLOYEE;
SELECT TO_CHAR(123.456, 'FM99999.999'), -- 123.456
       TO_CHAR(123.456, 'FM9990.99'), -- 123.46
       TO_CHAR(0.100, 'FM9990.999'), -- 0.1
       TO_CHAR(0.100, 'FM9999.999') -- .1
       FROM DUAL;

SELECT TO_CHAR(123.456, '99999.999'), --   123.456
       TO_CHAR(123.456, '9990.99'), --  123.46
       TO_CHAR(0.100, '9990.999'), --    0.100
       TO_CHAR(0.100, '9999.999') --     .100
       FROM DUAL;      

------------------> 날짜 => 문자타입
SELECT TO_CHAR(SYSDATE, 'PM') "KOREA",
        TO_CHAR(SYSDATE, 'AM', 'NLS_DATE_LANGUAGE = AMERICAN') "AMERICAN"  -- TO_CHAR 괄호안에서 로컬 국가 설정 가능
        FROM DUAL;


-- 시간  AM / PM 표시
SELECT TO_CHAR(SYSDATE, 'AM') "KOREA" -- 'AM' 부분 AM을 넣던 PM을 넣던 상관없음
    FROM DUAL; -- 지금 시간기준 오전 또는 오후 출력됨

ALTER SESSION SET NLS_LANGUAGE = AMERICAN; -- 미국으로 언어 바꿈
SELECT TO_CHAR(SYSDATE, 'AM') "AMERICA"
    FROM DUAL; -- 미국으로 로컬시간 변경해서 PM 또는 AM 출력
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- 12시간 형식, 24시간 형식
SELECT TO_CHAR(SYSDATE,'AM HH:MI:SS') FROM DUAL; -- 12시간 형식
SELECT TO_CHAR(SYSDATE,'HH24:MI:SS') FROM DUAL; -- 24시간 형식

-- 날짜
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD DAY') FROM DUAL; --2024-06-12 수요일 출력
SELECT TO_CHAR(SYSDATE,'MON,YYYY') FROM DUAL;

-- YYYY년 MM월 DD일 요일 출력하고싶다면
SELECT TO_CHAR(SYSDATE,'"오우"YYYY"년 "MM"월 "DD"일 " DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'DL') FROM DUAL;  --위에걸 이렇게 줄일수 있다.

--입사일을 ????년 ?월 ?일 ?요일 로 출력
SELECT EMP_NAME ||'의 입사일은 '|| TO_CHAR(HIRE_DATE, 'DL')||'이다' 입사일 FROM EMPLOYEE;

---------------------년도
/*
    YY : 무조건 '20'이 앞에 붙는다
    RR : 50년을 기준으로 작으면 '20'을 크면 '19'를 붙인다
*/

--나중에 데이터 할때 더 깊게 배울예정 지금은 이상태로하면 RR과 YY의 차이를 알수 없다.
SELECT TO_CHAR(SYSDATE, 'YYYY'),
        TO_CHAR(SYSDATE, 'YY'),
        TO_CHAR(SYSDATE, 'RRRR'),
        TO_CHAR(SYSDATE, 'RR')
    FROM DUAL;


-- 환경설정 바꾸고 도구 -> 환경설정 -> 데이터베이스 -> NLS -> 날짜 포멧을 RRRR/MM/DD
SELECT TO_CHAR(SYSdate,'yyyy'),     -- 2024
        to_char(SYSdate, 'yy'),     -- 24
        to_char(SYSdate, 'rrrr'),   -- 2024
        to_char(SYSdate, 'rr'),     -- 24
        to_char(SYSDate, 'YEAR')    -- TWENTY TWENTY-FOUR
    from DUAL;
        
-- 데이터를 날짜 타입으로 변환하려면
SELECT TO_DATE('981213','RRMMDD'),TO_DATE('981213','YYMMDD'),TO_DATE('021213','RRMMDD'),TO_DATE('021213','YYMMDD') FROM DUAL;
SELECT TO_DATE('981213','RRMMDD') FROM DUAL;
SELECT TO_DATE('981213','YYMMDD') FROM DUAL;

SELECT TO_DATE('021213','RRMMDD') FROM DUAL;
SELECT TO_DATE('021213','YYMMDD') FROM DUAL;

SELECT TO_CHAR(TO_DATE('981213','RRMMDD'),'yyyy'),     -- 1998
        to_char(TO_DATE('981213','RRMMDD'), 'yy'),     -- 98
        to_char(TO_DATE('981213','RRMMDD'), 'rrrr'),   -- 1998
        to_char(TO_DATE('981213','RRMMDD'), 'rr'),     -- 98
        to_char(TO_DATE('981213','RRMMDD'), 'YEAR')    -- NINETEEN NINETY-EIGHT
    from DUAL;

SELECT TO_CHAR(TO_DATE('981213','YYMMDD'),'yyyy'),     -- 2098
        to_char(TO_DATE('981213','YYMMDD'), 'yy'),     -- 98
        to_char(TO_DATE('981213','YYMMDD'), 'rrrr'),   -- 2098
        to_char(TO_DATE('981213','YYMMDD'), 'rr'),     -- 98
        to_char(TO_DATE('981213','YYMMDD'), 'YEAR')    -- TWENTY NINETY-EIGHT
    from DUAL;
    
    
    
--------------------월
SELECT TO_CHAR(SYSDATE, 'MM'),          --06
        TO_CHAR(SYSDATE, 'MON'),        --6월 
        TO_CHAR(SYSDATE, 'MONTH'),      --6월 
        TO_CHAR(SYSDATE, 'RM')  --로마기호로     --VI  
    FROM DUAL;
    
--------------------일
SELECT TO_CHAR(SYSDATE,'DDD'),         --연을 기준으로 며칠째인지  164
        TO_CHAR(SYSDATE,'DD'),         --월을 기준으로 며칠째인지  12
        TO_CHAR(SYSDATE,'D')           --주를 기준으로 며칠째인지  4
    FROM DUAL;

--------------------요일
SELECT TO_CHAR(SYSDATE,'DAY'),      --수요일
        TO_CHAR(SYSDATE, 'DY')      --수
    FROM DUAL;






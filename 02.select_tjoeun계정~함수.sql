/*
                <   함   수   >
                전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
                
                - 단일행 함수 : n개의 값을 읽어들여 n개의 결과값 반환(매 행마다 실행)
                - 그룹 함수 : n개의 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
                
                >> select절에 단일행 함수와 그룹함수를 함께 사용할 수 없다.
                >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절


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
SELECT TO_CHAR(SYSDATE,'YYYY"년" MM"월" DD"일" DAY') FROM DUAL;
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

----------------------------------------------------------------------------
/*
    *TO_DATE : 숫자나 문자를 날짜타입으로 변환
    TO_DATE(숫자|날짜, [포맷]
*/

SELECT TO_DATE(20240613) FROM DUAL;
SELECT TO_DATE(240613) FROM DUAL;

--SELECT TO_DATE(010610) FROM DUAL; -- 숫자로 앞이 0일때 오류뜸
SELECT TO_DATE('010610') FROM DUAL; -- 이렇게 문자로 형변환하면 잘 출력된다

SELECT TO_DATE('070407 020814', 'YYMMDD HHMISS') FROM DUAL;  --이렇게하면 시간이 출력안된다
SELECT TO_CHAR(TO_DATE('070407 020814', 'YYMMDD HHMISS'),'YY-MM-DD HH:MI:SS') FROM DUAL; -- 이렇게 CHAR 형변환후 원하는 포멧을 지정해주면 제대로 출력된다.

SELECT TO_CHAR('070407 020814', 'YY-MM-DD HH:MI:SS') FROM DUAL; --이렇게하면 앞 인자에 숫자는 날짜로 인식할수 없어서 오류가뜸. 위에 TO_DATE로 날짜라고 인식시켜줘야 제대로 출력이됨
SELECT TO_CHAR(170407, 'YYMMDD') FROM DUAL; --이것도 마찬가지로 그냥 숫자만 넣으면 날짜로 인식을 못해서 오류뜸. TO_DATE로 날짜타입변환 해줘야함.

--SELECT TO_DATE('041030 143000','YYMMDD HHMISS') FROM DUAL; -- 오전 오후 유의해야함 그냥 HHMISS 했을땐 시간값을 12가 넘어가지 않게 입력해야 오류가 안뜬다
SELECT TO_DATE('041030 143000','YYMMDD HH24MISS') FROM DUAL;    -- 또는 HH24MISS로 24시간으로 설정해주면 제대로 출력할 수 있다.

SELECT TO_DATE('981213', 'YYMMDD') FROM DUAL;   --  YY : 무조건 현재세기로 반영
SELECT TO_DATE('021213', 'YYMMDD') FROM DUAL;

SELECT TO_DATE('981213', 'RRMMDD') FROM DUAL;   --  RR : 50미만 일 때는 현재세기, 50이상이면 이전 세기 반영
SELECT TO_DATE('021213', 'RRMMDD') FROM DUAL;  

---------------------------------------------------------------------------------
/*
    *TO_NUMBER : 문자를 숫자타입으로 변환
    TO_NUMBER(숫자|날짜,[포맷])
*/
SELECT TO_NUMBER('012354899323') FROM DUAL; --문자를 숫자로 변환
SELECT '1000' + '500' FROM DUAL; -- 문자로 입력해도 연산자 입력시 숫자로 인식됨(단 숫자안에 1,000 + 5,000 같이 , 있으면 오류뜸)
-- SELECT '1,000' + '5,000' FROM DUAL; -- 숫자에 , 컴마가 들어가서 오류
SELECT TO_NUMBER('1,000,000', '9,999,999')+ TO_NUMBER('50,000','99,999') FROM DUAL; -- 이런식으로 컴마들어간 숫자 문자열을 99,999포멧으로 인식시켜 제대로 숫자로 변환하면 연산할수있다.
--===========================================================================================================
--                                            NULL처리 함수
--===========================================================================================================
/*
   * NVL (컬럼, 해당컬럼이 NULL일 경우 반환할 값)
*/
SELECT EMP_NAME, NVL(BONUS, 0) -- NVL : BONUS의 컬럼값이 NULL일경우 0으로 반환하시오
    FROM EMPLOYEE;

-- 전사원의 사원명, 연봉(보너스 포함)
SELECT EMP_NAME, (SALARY + SALARY*BONUS)*12 --BONUS가 NULL일경우 연산시 NULL값 반환된다
FROM EMPLOYEE;

SELECT EMP_NAME, (SALARY + SALARY*NVL(BONUS,0))*12 --NVL로 BONUS의 값이 NULL경우 0으로 반환하게 해줘서 NULL값반환을 막을수 있다.
FROM EMPLOYEE;

SELECT EMP_NAME, (SALARY*(1+NVL(BONUS,0)))*12 -- 이렇게하면 위와 똑같은 값이 나온다.
FROM EMPLOYEE;

--EMPLOYEE에서 전사원의 사원명, 부서코드(부서가 없으면 '부서없음'출력)
select EMP_NAME 이름 , NVL(DEPT_CODE, '부서없음') 부서코드 FROM EMPLOYEE;

---------------------------------------------------------------------------------
/*
    * NVL2(컬럼, 반환 값1, 반환 값 2)
    - 반환 값1 : 컬럼에 값이 존재할 때 반환되는 값
    - 반환 값2 : 컬럼에 값이 NULL일 때 반환되는 값
*/
-- EMPLOYEE에서 사원명, 급여, 보너스, 성과급(보너스를 받는사람은 50%, 보너스를 못받는사람 10%를 줄거다)
SELECT EMP_NAME, SALARY, BONUS, SALARY*NVL2(BONUS,0.5,0.1) 성과급 FROM EMPLOYEE;


--EMPLOYEE에서 전사원의 사원명, 부서코드(부서가 있으면 '부서있음' 부서가 없으면 '부서없음'출력)
select EMP_NAME 이름 , NVL2(DEPT_CODE,'부서있음', '부서없음') 부서코드 FROM EMPLOYEE;

---------------------------------------------------------------------------------
/*
    * NULLIF(비교대상1, 비교대상2)
    - 두 개의 값이 일치하면 NULL반환
    - 두 개의 값이 일치하지 않으면 비교대상1 값을 반환
*/
SELECT NULLIF('1234','1234') FROM DUAL; --NULL
SELECT NULLIF('1234','5678') FROM DUAL; --1234

--===========================================================================================================
--                                            선택 함수
--===========================================================================================================
/*
    *DECODE(비교하고자하는 대상(컬럼|산술연산|함수식), 비교값1, 결과값1, 비교값2, 결과값2, ...)
    
    SWITCH(비교대상){
     CASE 비교값1 : 결과값1
     CASE 비교값2 : 결과값2
      ...
     DEFAULT :
    }

*/
--EMPLOYEE에서 사번, 사원명, 주민번호, 성별(남,여)조회
SELECT EMP_ID, EMP_NAME, EMP_NO,DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여','3','남','4','여') 성별
    FROM EMPLOYEE;
    
-- EMPLOYEE에서 사원명, 급여, 직급코드, 인상된 급여(급여 조회시 각 직급별로 인상하여 조회)
    --J7인 사원은 급여를 10%인상 (SALARY*1.1)
    --J6인 사원은 급여를 10%인상 (SALARY*1.15)
    --J5인 사원은 급여를 10%인상 (SALARY*1.2)
    --그외의 사원은 급여를 10%인상 (SALARY*1.05)

SELECT EMP_NAME, SALARY, JOB_CODE, 
                                   TO_CHAR(SALARY*DECODE(JOB_CODE,'J7',1.1,
                                                                  'J6',1.15,
                                                                  'J5',1.2,
                                                                  1.05),
                                                                  'L999,999,999,999') "인상된 급여"
                                                                  FROM EMPLOYEE order by JOB_CODE;

---------------------------------------------------------------------------------
/*
    * CASE WHEN THEN
      END
            조건식 참이면      결과값 실행  나머지는 ELSE실행
      [표현식]
      CASE WHER 조건식1 THEN 결과값1
           WHER 조건식2 THEN 결과값2
           ...
           ELSE 결과값N
      END
       --END를 꼭 써줘야한다. 
     
     ******   
      (자바의 IF ELSE와 같다)
      IF(조건식1) 결과값1
      ELSE IF(조건식2) 결과값2
      ...
      ELSE 결과값N
     ******
*/
-- EMPLOYEE에서 사원명, 급여, 급수(급여가 5백만원 이상이면 '고급' 그렇지 않고 3백5십만원 이상이면 '중급' 나머지 '초급')
SELECT EMP_NAME, SALARY, 
    CASE WHEN SALARY>= 5000000 THEN '고급'
         WHEN SALARY>= 3500000 THEN '중급'
         ELSE '초급'
    END AS 급수
FROM EMPLOYEE;

--===========================================================================================================
--                                            그룹 함수
--===========================================================================================================
/*
    * SUM(컬럼) : 컬럼들의 값의 합계

*/
--EMPLOYEE에서 전사원의 총급여의 합조회
SELECT TO_CHAR(SUM(SALARY),'L999,999,999,999') 총급여 FROM EMPLOYEE;

-- 남자 사원의 총 급여의 합
SELECT SUM(SALARY)
    FROM EMPLOYEE
    WHERE SUBSTR(EMP_NO,8,1) IN (1,3);

SELECT SUM(SALARY)
    FROM EMPLOYEE
    WHERE DECODE(SUBSTR(EMP_NO,8,1),'1','남','3','남')='남';

-- 부서코드가 D5인 사원의 연봉(보너스)의 합
SELECT TO_CHAR(SUM(SALARY*(1+NVL(BONUS,'0')))*12,'FML999,999,999,999')
    FROM EMPLOYEE
    WHERE DEPT_CODE LIKE 'D5'; -- LIKE 대신 = 써도된다

---------------------------------------------------------------------------------
/*
    * AVG(컬럼) : 해당 컬럼들의 평균
*/
--전사원의 급여평균
SELECT AVG(SALARY)
    FROM EMPLOYEE;

SELECT ROUND(AVG(SALARY)) -- ROUND() : 소숫점 반올림
    FROM EMPLOYEE;

SELECT ROUND(AVG(SALARY),-1) -- 정수 첫째자리는 반올림
    FROM EMPLOYEE;

---------------------------------------------------------------------------------
/*
    * MIN/MAX:컬럼값중에서 가장 큰값, 가장 작은값
        MIN(컬럼) 
*/    
SELECT MIN(SALARY), MIN(EMP_NAME), MIN(HIRE_DATE)   -- MIN에는 숫자만 올수있는건 아니다 문자가 왔을땐 내림차순 제일 앞부분이 출력
FROM EMPLOYEE;                                      -- 날짜가 왔을땐 제일 빠른 날짜

SELECT MAX(SALARY), MAX(EMP_NAME), MAX(HIRE_DATE)
FROM EMPLOYEE;

---------------------------------------------------------------------------------
/*
    * COUNT : 행의 갯수
        COUNT(*|컬럼|DISTINCT컬럼) => 세개중에 하나 적으면 됨
            -COUNT(*) : 조회된 결과의 모든 행의 갯수
            -CONUT(컬럼) : 제시한 컬럼에서 NULL값을 제외한 행의 갯수
            -COUNT(DISTINCT 컬럼): 해당 컬럼값에서 중복값을 제외한 후의 행의 갯수
*/    
-- 전체 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE;

-- 여자 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)IN('2','4');

-- 보너스를 받는 사원의 수
SELECT COUNT(BONUS)  --NULL값은 자동으로 제외된다
FROM EMPLOYEE;

--부서배치를 받은 사원의 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

--현재 사원들이 총 몇개의 부서에 분포되어있는지 조회
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

--=============================종 합 문 제=============================== TO_CHAR(SUBSTR(EMP_NO,1,6),'YYMMDD')

-- 1. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
SELECT EMP_NAME,
            EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,6))) 생년,
            EXTRACT(MONTH FROM TO_DATE(SUBSTR(EMP_NO,1,6))) 생월,
            EXTRACT(DAY FROM TO_DATE(SUBSTR(EMP_NO,1,6))) 생일
FROM EMPLOYEE;
--선생님 풀이
SELECT EMP_NAME,
--       19|| SUBSTR(EMP_NO,1,2)생년,
        TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,2),'RR'),'RRRR')생년,
        SUBSTR(EMP_NO,3,2)생월,
        SUBSTR(EMP_NO,5,2)생일
FROM EMPLOYEE;                


-- 2. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
SELECT EMP_NAME, SUBSTR(EMP_NO,1,7)||'*******'
FROM EMPLOYEE;

--교수님 풀이
SELECT EMP_ID,EMP_NAME, RPAD(SUBSTR(EMP_NO,1,7),14,'*') 주민번호
FROM EMPLOYEE;


-- 3. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
--   (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
SELECT EMP_NAME, ABS(FLOOR(HIRE_DATE - SYSDATE)) 근무일수1, FLOOR(SYSDATE-HIRE_DATE) 근무일수2
FROM EMPLOYEE;

--교수님 풀이
SELECT EMP_NAME, FLOOR(ABS(HIRE_DATE-SYSDATE)) 근무일수1, FLOOR(SYSDATE-HIRE_DATE) 근무일수2
FROM EMPLOYEE; // ABS와 FLOOR위치에따라서 음수 내림값때문에 값이 1씩 바뀔수 있다

-- 4. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT *
FROM EMPLOYEE
WHERE MOD(EMP_ID,'2') != '0';


-- 5. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT *
FROM EMPLOYEE
WHERE FLOOR(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12)>= 20;
--교수님 풀이
SELECT *
 FROM EMPLOYEE
 WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE)>240;



-- 6. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
SELECT EMP_NAME, TO_CHAR(SALARY,'FML999,999,999,999')
FROM EMPLOYEE;

-- 7. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이 조회
--   (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며 
--   나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)
SELECT EMP_NAME, DEPT_CODE, 
        TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6)),'YY"년" MM"월" DD"일"') 생년월일, 
        FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(EMP_NO,1,6)))/12) 나이
FROM EMPLOYEE;

--교수님 풀이
SELECT EMP_NAME, DEPT_CODE, 
        SUBSTR(EMP_NO,1,6)||'년'||SUBSTR(EMP_NO,3,2)||'월'||SUBSTR(EMP_NO,5,2)||'일' "생년월일", 
        EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RRRR')) 나이
FROM EMPLOYEE;


-- 8. EMPLOYEE테이블에서 부서코드가 D5, D6, D9인 사원만 조회하되 D5면 총무부
--   , D6면 기획부, D9면 영업부로 처리(EMP_ID, EMP_NAME, DEPT_CODE, 총무부)
--    (단, 부서코드 오름차순으로 정렬)
--풀이 1
SELECT EMP_ID, EMP_NAME, DEPT_CODE, 
        CASE WHEN DEPT_CODE = 'D5' THEN '총무부'
             WHEN DEPT_CODE = 'D6' THEN '기획부'
             WHEN DEPT_CODE = 'D9' THEN '영업부'
        END 부서명
FROM EMPLOYEE 
WHERE DEPT_CODE IN('D5','D6','D9') ORDER BY DEPT_CODE;

--풀이2
SELECT EMP_ID, EMP_NAME, DEPT_CODE,
        DECODE(DEPT_CODE,'D5','총무부','D6','기획부','D9','영업부') 부서명
FROM EMPLOYEE 
WHERE DEPT_CODE IN('D5','D6','D9') ORDER BY 3; -- 위에 입력한 컬럼중 3번째 컬럼 오름차순 정렬


-- 9. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리, 
--    주민번호 앞자리와 뒷자리의 합 조회
SELECT EMP_NAME, SUBSTR(emp_NO,1,6),SUBSTR(EMP_NO,8), SUBSTR(emp_NO,1,6) + SUBSTR(EMP_NO,8) "주민번호 앞, 뒷자리합"
FROM EMPLOYEE 
WHERE EMP_ID LIKE 201;

--교수님 풀이
SELECT EMP_NAME, 
        SUBSTR(EMP_NO,1,6) 생년월일, 
        SUBSTR(EMP_NO,8) "주민등록번호 뒷자리",
        SUBSTR(emp_NO,1,6) + SUBSTR(EMP_NO,8) "주민번호 앞, 뒷자리합"
 FROM EMPLOYEE
 WHERE EMP_ID = '201';


-- 10. EMPLOYEE테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회
SELECT SUM(SALARY + SALARY*NVL(BONUS,0))*12
FROM EMPLOYEE 
WHERE DEPT_CODE LIKE 'D5';

--교수님 풀이
SELECT SUM(SALARY*NVL(1+BONUS,1)*12)
 FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5';



-- 11. EMPLOYEE테이블에서 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
--      전체 직원 수, 2001년, 2002년, 2003년, 2004



--    EXTRACT(YEAR FROM HIRE_DATE)

SELECT COUNT(*) AS "전체 직원수",
    SUM(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2001 THEN 1 ELSE 0 END) "2001",
    SUM(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2002 THEN 1 ELSE 0 END) "2002",
    SUM(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2003 THEN 1 ELSE 0 END) "2003",
    SUM(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2004 THEN 1 ELSE 0 END) "2004"
FROM EMPLOYEE;

-- 전체 입사년도
SELECT EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE;

 -- 2001년, 2002년, 2003년, 2004년 개수
SELECT COUNT(*) 전체직원수,
        COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2001',1)) "2001년",
        COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2002',1)) "2002년",
        COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2003',1)) "2003년",
        COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2004',1)) "2004년"
 FROM EMPLOYEE;
 
SELECT COUNT(*) 전체직원수,
         COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2001 THEN 1 END) "2001",
         COUNT(CASE WHEN TO_CHAR(HIRE_DATE, 'RRRR') = '2013' THEN 1 END) "2013",
         COUNT(DECODE(TO_CHAR(HIRE_DATE, 'RRRR'), '2004',1)) "2004"
 FROM EMPLOYEE;         
        
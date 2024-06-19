/*
    데이터를 변경하는건 UPDATE, INSERT, DELETE
    구조를 변경하는건 ALTER, CREATE, DROP


    *ALTER
     객체를 변경하는 구문
     
     [표현식]
     ALTER TABLE 테이블명 변경할 내용;
     
     -변경할 내용
      1) 컬럼 추가 / 수정 / 삭제
      2) 제약조건 추가 / 삭제 -> 제약조건은 한번넣으면 수정불가( 수정하려면 삭제하고 다시 새로 추가해야함)
      3) 컬럼명 / 제약조건명 / 테이블명 변경     
     
*/

--------------------------------------------------------------------------------------
/*
      1) 컬럼 추가 / 수정 / 삭제
*/
/*
  1.1 컬럼 추가 (ADD)  
  
  [표현법]
  ADD 컬럼명 데이터 타입 [DEFAULT 기본값]
*/

--DEPT_COPY에 CNAME컬럼 추가
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);

--DEPT_COPY에 LNAME컬럼 추가 기본값으로 '한국'
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(30) DEFAULT '한국';


--------------------------------------------------------------------------------------

/*
     1.2 컬럼 수정 (MODIFY)  
  
    [표현법]
    --데이터 타입 수정
    MODIFY 컬럼명 바꾸고자 하는 데이터 타입
    
    - DEFAULT 값 수정
    MODIFY 컬럼명 DEFAULT 바꾸고자 하는 기본값

    
    *문자를 숫자로 변경 못함 (굳이 하려면 컬럼안에 문자 다지우고 타입변경해야함)
    
*/
-- DEPT_COPY테이블의 DEPT_ID의 자료형 CHAR(3) 로 변경해보잣
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);

--DEPT_COPY테이블의 DEPT_ID를 자료형 NUMBER로 변경해보자
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;
--오류 : 이미 컬럼값에 숫자로 변경할수 없는 값(문자)이 있어서 넘버로 수정할수 없다.

-- DEPT_COPY테이블의 DEPT_TITLE의 자료형 VARCHAR(15) 로 변경해보자
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10);
--오류 : 이미 들어있는 데이터값의 크기가 변경하려는 자료형보다 큰 값이 들어있기 때문 

--DEPT_COPY테이블의 DEPT_TITLE의 자료형 VARCHAR(40)로 변경해보자
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR(40);
--DEPT_COPY테이블의 LOCATION_ID 자료형 VARCHAR(2)로 변경해보자
ALTER TABLE DEPT_COPY MODIFY LOCATION_ID VARCHAR(2);
--DEPT_COPY테이블의 LNAME컬럼의 기본값을 '미국'으로 변경해보자
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT '미국';

--위에 3개 구문을 한꺼번에 해줄수 있다

--다중변경
ALTER TABLE DEPT_COPY 
    MODIFY DEPT_TITLE VARCHAR2(40)
    MODIFY LOCATION_ID VARCHAR2(2)
    MODIFY LNAME DEFAULT '미국';
--요렇게


/*
     1.3 컬럼 삭제 (DROP COLUMN)  
        * 그냥 DROP만 쓰면 테이블삭제 DROP COLUMN 쓰면 컬럼 삭제
        
        ** ROLLBACK 안됨
        
    [표현법]
    - DROP COLUMN 컬럼명 
*/
-- DEPT_COPY테이블에서 CNAME컬럼을 삭제해보자
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;

--DROP은 다중 삭제 안됨

-- DEPT_COPY테이블에서 DEPT_TITLE컬럼을 삭제해보자
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
-- DEPT_COPY테이블에서 LOCATION_ID 컬럼을 삭제해보자
ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
-- DEPT_COPY테이블에서 LNAME 컬럼을 삭제해보자
ALTER TABLE DEPT_COPY DROP COLUMN LNAME;


ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;
--마지막 남은열은 삭제 할 수 없다. 테이블에 최소한 1개의 컬럼은 존재해야 한다.

---------------------------------------------------------------------------
/*
    
    *2 제약조건 추가 / 삭제
    >2.1제약조건 추가
   
    ALTER TABLE 테이블명 변경할 내용 
     - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명)
     - FROEIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명[(참조할컬럼명)]
     - UNIQUE : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명)
     - CHECK : ALTER TABLE 테이블명 ADD CHECK(컬럼에 대한 조건식)
     - NOT NULL : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL   -- NOT NULL은 설정을 안해도 이미 기존에 NULLABLE 테이블이 있는상태임 그래서 ADD로 추가하는게 아닌 MODIFY로 수정해주는것
     
     + 제약조건명을 지정하려면 CONSTRAINT 제약조건명 제약조건
     
    2.2 제약조건 삭제
    DROP CONSTRAINT 제약조건
    MODIFY 컬럼명 NULL(NOT NULL제약조건을 NULL 바꿀때)
    
*/
--DEPARTMENT 테이블을 복사하여 DEPT_COPY테이블 생성
-- DEPT_COPY테이블에 LNAME컬럼 추가

-- DEPT_COPY테이블 제약조건 추가
--1) DEPT_ID컬럼에 기본키 
--2) DEPT_TITLE컬럼에 UNIQUE
--3) LNAME컬럼에 NOT NULL

CREATE TABLE DEPT_COPY
AS SELECT *
FROM DEPARTMENT;


ALTER TABLE DEPT_COPY ADD LNAME VARCHAR(20) DEFAULT '미국';

ALTER TABLE DEPT_COPY 
            ADD CONSTRAINT DCOPY_PK PRIMARY KEY(DEPT_ID)
            ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_TITLE)
            MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL;


--제약조건 삭제
ALTER TABLE DEPT_COPY
DROP CONSTRAINT SYS_C007511;

--다중조건 가능
ALTER TABLE DEPT_COPY
    DROP CONSTRAINT SYS_C007512
    MODIFY LNAME NULL;


---------------------------------------------------------------------------
/*
    3) 컬럼명 / 제약조건명 / 테이블명 변경 
        3.1 컬럼명 변경
            [표현법]
            RENAME COLUMN 기존컬럼명 TO 바꿀 컬럼명
*/

--DEPT_COPY 테이블의 DEPT_TITLE컬럼명을 DEPT_NAME으로 변경
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

/*
        3.2 제약조건명 변경
            
            [표현법]
            RENAME CONSTRAINT 기존제약조건명 TO 바꿀 제약조건명
*/
--아까 지웠던 제약조건 다시넣기
ALTER TABLE DEPT_COPY 
            ADD CONSTRAINT DCOPY_PK PRIMARY KEY(DEPT_ID)
            ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_NAME)
            MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL;

-- 제약조건명 변경해보다
ALTER TABLE DEPT_COPY 
    RENAME CONSTRAINT DCOPY_UQ TO COPY_UNIQUE;

/*
        3.3 제약조건명 변경
            
            [표현법]
            RENAME [기존테이블명] TO 바꿀 테이블명
*/
--
ALTER TABLE DEPT_COPY
    RENAME TO DEPT_TEST;

-----------------------------------------------------------------------
--테이블 삭제
DROP TABLE DEPT_TEST;

/*
    -테이블 삭제시 외래키의 부모테이블은 삭제 안됨.(자식테이블이 사용하고 있기 때문)
    그래도 삭제하고 싶다면
    *방법1:자식테이블 먼저 삭제한 후 부모테이블 삭제
    *방법2:부모테이블만 삭제하는 제약조건 같이 삭제하는방법 (외래키(FOREIGN KEY 삭제)
            DROP TABLE 부모테이블명 CASCADE CONSTRAINT;
*/



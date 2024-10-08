-- 한 줄 주석 대시두개 자바랑 단축키가 같다 ctrl + /

/*

        여러줄 주석
       단축키 : alt + shift + C

    실행 단축키
    ctrl + enter  


    커서가 있는 줄 실행 단축키 : crtl + enter

*/



--  나의 계정 보기
show user;


-- 사용자 계정 조회
select * from dba_users;
/*
    - 조회시
    select 속성명 from 테이블명
*/

select username, user_id from dba_users;

--  내가 사용할 user를 계정 생성
/*
    오라클 12버전부터 일반사용자는 c##로 시작하는 이름을 가져야 함
    비밀번호는 문자로만 가능함
*/

-- user1을 생성하고 싶다면
--CREATE USER user1 IDENTIFIED BY '1234'; -- 이렇게하면 오류뜸 유저명에 c##이 없어서

--create user c##user1 IDENTIFIED by '1234'; -- 따옴표 넣으니까 오류뜸

create user c##user1 IDENTIFIED by 1234; -- c##user1 유저 생성완료

----------------------- 유저 만들때마다 c##을 넣어야해서 불편하다
-- c## 키워드를 회피하는 설정
alter session set "_oracle_script" = true; -- 이렇게하면 유저명에 c## 안붙여도 됨

-- 수업시간에 사용할 user 생성 
/*
계정명은 대소문자 안가림
create user 계정명 identified by 비밀번호
*/
create user tjoeun identified by 1234;


----------------유저생성후 권한을 줘야함-------------
-- 권한생성 방법
/*
 [표현법] GRANT 권한1, 권한2, .... TO 계정명;
*/
grant resource, connect to tjoeun;   --데이터베이스에 접근하거나 로그인하는 권한을 tjoeun에 부여함

--유저를 삭제하고 싶다면
--DROP USER USER명  CASCAED;


-------------------- insert 시 생성된 유저에게 테이블스페이스에 얼마만큼의 영역을 할당할 것인지 정해줘야함 (용량을 넣어줘야함)
-- 보통은 이렇게 리미트 없이 설정하지만
alter user tjoeun default tablespace users quota unlimited on users;

-- 특정 용량을 설정해줄땐 이렇게 해주면 됨.
alter user tjoeun quota 30M on users;


-- 춘대학교 사용하려면
-- 1. 춘 사용자 만들기
-- 2. CHUN 접속 (+버튼으로 하면됨)
-- 3. table 열기(이때, chun사용자 선택) -> 스크립트로 실행
--

--춘대학교 사용자 만들기
alter session set "_oracle_script" = true; 
create user chun identified by 1234;
grant resource, connect to chun;
alter user chun default tablespace users quota unlimited on users;


--DDL 사용자 만들기
alter session set "_oracle_script" = true; 
create user DDL identified by 1234;
grant resource, connect to DDL;
alter user DDL default tablespace users quota unlimited on users;


--마트 사용자 만들기
alter session set "_oracle_script" = true; 
create user mart identified by 1234;
grant resource, connect to mart;
alter user mart default tablespace users quota unlimited on users;

--JSP 사용자 만들기
alter session set "_oracle_script" = true; 
create user JSP identified by 1234;
grant resource, connect to JSP;
alter user JSP default tablespace users quota unlimited on users;

--vote 사용자 만들기
alter session set "_oracle_script" = true; 
create user vote identified by 1234;
grant resource, connect to vote;
alter user vote default tablespace users quota unlimited on users;

--board 사용자 만들기
alter session set "_oracle_script" = true; 
create user board identified by 1234;
grant resource, connect to board;
alter user board default tablespace users quota unlimited on users;

--mybatis 사용자 만들기
alter session set "_oracle_script" = true; 
create user mybatis identified by 1234;
grant resource, connect to mybatis;
alter user mybatis default tablespace users quota unlimited on users;

--SPRINGBOOT 사용자 만들기
alter session set "_oracle_script" = true; 
create user SPRINGBOOT identified by 1234;
grant resource, connect to SPRINGBOOT;
alter user SPRINGBOOT default tablespace users quota unlimited on users;


--HOMEPAGE 사용자 만들기
alter session set "_oracle_script" = true; 
create user HOMEPAGE identified by 1234;
grant resource, connect to HOMEPAGE;
alter user HOMEPAGE default tablespace users quota unlimited on users;

--project5 사용자 만들기
alter session set "_oracle_script" = true; 
create user project5 identified by 1234;
grant resource, connect to project5;
alter user project5 default tablespace users quota unlimited on users;

--project5 사용자 만들기
alter session set "_oracle_script" = true; 
create user dicom identified by 1234;
grant resource, connect to dicom;
alter user dicom default tablespace users quota unlimited on users;

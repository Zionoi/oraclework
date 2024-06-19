/*



*/

create table sample (
    ID NUMBER,
    PWD VARCHAR2(30)
);

INSERT INTO SAMPLE VALUES(1,'pass01');


SELECT * FROM TJOEUN.EMPLOYEE;

INSERT INTO TJOEUN.EMPLOYEE (EMP_ID,EMP_NAME,EMP_NO,JOB_CODE)
        VALUES(400,'아무개','201212-1385769','J2');

----------------------------------------------------------------------------------------------
/*
    *ROLE
        : 특정 권한들을 하나의 집합으로 모아놓은 것
        
        CONNET : CREATE + SESSION
        RESOURCE : CREATE TABLE + CREATE SEQUENCE + ...
        DBA : 시스템 및 객체관리에 대한 모든 권한을 갖고 있는 롤
        
        GRANT CONNECT, RESOURCE TO 계정명;

*/







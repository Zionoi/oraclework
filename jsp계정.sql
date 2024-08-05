create TABLE member(
    id varchar2(20) primary key,
    pwd VARCHAR2(20) not null,
    name VARCHAR2(20) not null,
    gender char(1),
    birthday CHAR(6),
    email VARCHAR2(30),
    zipcode CHAR(5),
    address varchar2(100),
    detailAddress VARCHAR2(50),
    hobby char(5),
    job varchar2(30)
);

comment on column member.id is'아이디';
comment on column member.pwd is'비밀번호';
comment on column member.name is'이름';
comment on column member.gender is'성별';
comment on column member.birthday is'생일';
comment on column member.email is'이메일';
comment on column member.zipcode is'우편번호';
comment on column member.address is'주소';
comment on column member.detailAddress is'상세주소';
comment on column member.hobby is'취미';
comment on column member.job is'직업';

INSERT INTO member(ID, PWD, NAME) VALUES('user01', 'pass01','홍길동');


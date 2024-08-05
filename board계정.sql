create table board(
    num number primary key,
    name VARCHAR2(20) not null,
    subject varchar2(50) not null,
    content varchar2(4000) not null,
    pos number,
    ref number,
    depth number,
    regdate date,
    pass varchar2(20) not null,
    ip varchar2(50),
    count Number default '0'
);

drop SEQUENCE seq_board;
create SEQUENCE SEQ_BOARD NOCYCLE NOCACHE;

insert into board values(SEQ_BOARD.NEXTVAL, '박길동', '제목1', '내용1', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-01', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '김길동', '제목2', '내용2', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-05', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '송길동', '제목3', '내용3', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-12', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '한길동', '제목4', '내용4', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-14', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '곽길동', '제목5', '내용5', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-25', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '원길동', '제목6', '내용6', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-04', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '임길동', '제목7', '내용7', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-07', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '신길동', '제목8', '내용8', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-11', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '박길동', '제목9', '내용9', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-22', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '정길동', '제목10', '내용10', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-29', '1234', '0:0:0:0:0:0:0:1', default);

insert into board values(SEQ_BOARD.NEXTVAL, '우재남', '제목11', '내용11', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-01', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '이고잉', '제목12', '내용12', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-05', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '송미영', '제목13', '내용13', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-12', '1234', '0:0:0:0:0:0:0:1', default);


commit;

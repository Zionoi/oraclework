create TABLE votelist(
    num number primary key,
    question VARCHAR2(200) not null,
    sdate date,
    edate date,
    wdate date,
    type number DEFAULT '1' not null,
    active number DEFAULT '1'
);

create TABLE voteitem(
    listnum number,
    itemnum number,
    item VARCHAR2(50),
    count number DEFAULT '0',
    primary key(listnum, itemnum)
);

create SEQUENCE SEQ_VOTE;

COMMENT ON COLUMN VOTELIST.NUM IS '설문번호';
COMMENT ON COLUMN VOTELIST.QUESTION IS '설문내용';
COMMENT ON COLUMN VOTELIST.SDATE IS '투표시작날짜';
COMMENT ON COLUMN VOTELIST.EDATE IS '투표종료날짜';
COMMENT ON COLUMN VOTELIST.WDATE IS '설문작성날짜';
COMMENT ON COLUMN VOTELIST.TYPE IS '중복투표허용여부';
COMMENT ON COLUMN VOTELIST.ACTIVE IS '설문활성화여부';

COMMENT ON COLUMN VOTEITEM.LISTNUM IS '답변이소속된설문번호';
COMMENT ON COLUMN VOTEITEM.ITEMNUM IS '답변번호';
COMMENT ON COLUMN VOTEITEM.ITEM IS '답변내용';
COMMENT ON COLUMN VOTEITEM.COUNT IS '투표수';

drop table voteitem;

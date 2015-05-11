whenever sqlerror exit sql.sqlcode;

CREATE TABLE BANK01.BATCH_RERA_CONTROL_PROC (
	RERA_MODE VARCHAR2(10 CHAR) NOT NULL
	,LAST_UPDATE TIMESTAMP DEFAULT SYSDATE NOT NULL
);

INSERT INTO BANK01.BATCH_RERA_CONTROL_PROC (RERA_MODE) VALUES ('UNKNOWN');

COMMIT;

exit

whenever sqlerror exit sql.sqlcode;
set serveroutput on;

DECLARE
	ql_stmt VARCHAR2(2000);
	V_ESQUEMA VARCHAR2(2000) := 'BANK01';
	cuenta NUMBER;
BEGIN
	
  select count(*) into cuenta from sys.all_views where view_name='TMP_REC_CNT_LIBRES' AND OWNER=V_ESQUEMA;
  IF cuenta>0 THEN
    dbms_output.put_line('ELIMINANDO VISTA: '||V_ESQUEMA||'.TMP_REC_CNT_LIBRES');
	  ql_stmt := 'DROP VIEW '||V_ESQUEMA||'.TMP_REC_CNT_LIBRES';
	  EXECUTE IMMEDIATE ql_stmt;
    dbms_output.put_line('VISTA ELIMINADA: '||V_ESQUEMA||'.TMP_REC_CNT_LIBRES');
  END IF;

  select count(*) into cuenta from sys.all_tables where table_name='TMP_REC_CNT_LIBRES' AND OWNER=V_ESQUEMA;
  IF cuenta>0 THEN
    dbms_output.put_line('ELIMINANDO TABLA: '||V_ESQUEMA||'.TMP_REC_CNT_LIBRES');
	  ql_stmt := 'DROP TABLE '||V_ESQUEMA||'.TMP_REC_CNT_LIBRES PURGE';
	  EXECUTE IMMEDIATE ql_stmt;
    dbms_output.put_line('TABLA ELIMINADA: '||V_ESQUEMA||'.TMP_REC_CNT_LIBRES');
  END IF;
  
  /*CREA LA VISTA*/
  ql_stmt := 'CREATE VIEW '||V_ESQUEMA||'.TMP_REC_CNT_LIBRES AS
		SELECT /*+ PARALLEL */ DISTINCT CNT.CNT_ID, CPE.PER_ID 
		FROM BATCH_DATOS_CNT CNT
     		INNER JOIN BATCH_DATOS_CNT_PER CPE ON CNT.CNT_ID = CPE.CNT_ID
        LEFT OUTER JOIN BATCH_DATOS_CNT_EXP BDCE ON BDCE.CNT_ID=CNT.CNT_ID
    WHERE BDCE.CNT_ID IS NULL';
  EXECUTE IMMEDIATE ql_stmt;
  dbms_output.put_line('VISTA: '||V_ESQUEMA||'.TMP_REC_CNT_LIBRES CREADA');
END;
/ 
EXIT
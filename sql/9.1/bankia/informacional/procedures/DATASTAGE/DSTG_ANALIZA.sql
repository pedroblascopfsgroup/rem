create or replace PROCEDURE "DSTG_ANALIZA"("P_OWNER" IN VARCHAR2, "P_TABLA" IN VARCHAR2 ) AS
-- ===============================================================================================
-- Autor: Fran Gutiérrez, PFS Group
-- Fecha creacion: Octubre 2014
-- Responsable ultima modificacion:
-- Fecha ultima modificacion:
-- Motivos del cambio:
-- Cliente: Recovery BI Bankia
--
-- Descripcion:  Actualización estadísticas DSTG
-- ===============================================================================================


BEGIN

DECLARE
   	L_PARTITIONED VARCHAR2(3);
   	BEGIN
    	--DBMS_OUTPUT.PUT_LINE('Analizando tabla : '||P_OWNER||'.'||P_TABLA);
     	L_PARTITIONED:=NULL;
     	BEGIN
       	SELECT PARTITIONED INTO L_PARTITIONED
       	FROM all_tables WHERE TABLE_NAME=Upper(P_TABLA) AND ROWNUM=1 AND OWNER =Upper(P_OWNER);
     	EXCEPTION WHEN others THEN
       	L_PARTITIONED:=NULL;
     	END;

       	IF L_PARTITIONED = 'YES' THEN
         	DBMS_STATS.gather_table_stats(OWNNAME => Upper(P_OWNER), TABNAME => Upper(p_tabla),
           	DEGREE => 14, ESTIMATE_PERCENT  => 20, METHOD_OPT => 'FOR ALL INDEXED COLUMNS SIZE 10',
           	GRANULARITY => 'PARTITION', CASCADE => TRUE);
         	DBMS_STATS.gather_table_stats(OWNNAME => Upper(P_OWNER), TABNAME => Upper(p_tabla),
           	DEGREE => 14, ESTIMATE_PERCENT  => 20, METHOD_OPT => 'FOR ALL INDEXED COLUMNS SIZE 10',
           	GRANULARITY => 'GLOBAL', CASCADE => TRUE);
           	--DBMS_OUTPUT.PUT_LINE('Actualizadas estadísticas tabla : '||P_OWNER||'.'||P_TABLA);
       	ELSE
           	DBMS_STATS.gather_table_stats(OWNNAME => Upper(P_OWNER), TABNAME => Upper(p_tabla),
         	DEGREE => 14, ESTIMATE_PERCENT  => 20, METHOD_OPT => 'FOR ALL COLUMNS size 1',
         	GRANULARITY => 'GLOBAL', CASCADE => TRUE);
         	--DBMS_OUTPUT.PUT_LINE('Actualizadas estadísticas tabla : '||P_OWNER||'.'||P_TABLA);
       	END IF;

        DBMS_OUTPUT.PUT_LINE('[INFO] Ejecución DSTG_ANALIZA ' || P_TABLA || ' OK');

    	EXCEPTION WHEN OTHERS THEN
          	DBMS_OUTPUT.PUT_LINE('ERROR al pasar estadisticas' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );

   	end;
 END;
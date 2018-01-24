--/*
--#########################################
--## AUTOR=Sergio Belenguer Gadea
--## FECHA_CREACION=20180125
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-3391
--## PRODUCTO=NO
--## 
--## Finalidad: Modificar tabla
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ERR_NUM NUMBER;-- Numero de errores
  ERR_MSG VARCHAR2(2048);-- Mensaje de error
  V_MSQL VARCHAR2(4000 CHAR);
  COUNTER NUMBER(2);
  V_TABLA_REP VARCHAR2(30 CHAR) := 'OFERTAS_REPOSICIONAR';
  V_TABLA VARCHAR2(40 CHAR) := 'MIG2_TRAMITES_OFERTAS_REP';

BEGIN
    
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_REP||''' AND OWNER = '''||V_ESQUEMA||''' ';
    EXECUTE IMMEDIATE V_MSQL INTO COUNTER;    

    IF (COUNTER = 1) THEN
    	DBMS_OUTPUT.PUT_LINE('[INICIO] Añadir columna a la tabla '||V_ESQUEMA||'.'||V_TABLA_REP||'.');
   	V_MSQL := 'select COUNT(1) from all_tab_columns where TABLE_NAME='''||V_TABLA_REP||''' AND COLUMN_NAME=''PVC_ID''';
    	EXECUTE IMMEDIATE V_MSQL INTO COUNTER;
	DBMS_OUTPUT.PUT_LINE(COUNTER);
    	IF (COUNTER = 0) THEN
    		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_REP||'
           		ADD PVC_ID NUMBER(16,0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('Tabla '||V_TABLA_REP||' modificada.');
	END IF;
	
    END IF;

    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' ';
    EXECUTE IMMEDIATE V_MSQL INTO COUNTER;    

    IF (COUNTER = 1) THEN
    	DBMS_OUTPUT.PUT_LINE('[INICIO] Añadir columna a la tabla '||V_ESQUEMA||'.'||V_TABLA||'.');
   	V_MSQL := 'select COUNT(1) from all_tab_columns where TABLE_NAME='''||V_TABLA||''' AND COLUMN_NAME=''PVC_ID''';
    	EXECUTE IMMEDIATE V_MSQL INTO COUNTER;
    	IF (COUNTER=0) THEN
    		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||'
           		ADD PVC_ID NUMBER(16,0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('Tabla '||V_TABLA||' modificada.');
	END IF;
    END IF;
	
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT

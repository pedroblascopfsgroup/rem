--/*
--##########################################
--## AUTOR=DANIEL ALBERT PÉREZ
--## FECHA_CREACION=20180502
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-628
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
   
  V_ESQUEMA       VARCHAR2(25 CHAR):= 'REM01'; 	    -- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M     VARCHAR2(25 CHAR):= 'REMMASTER'; 	-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  err_num         NUMBER; 													-- Numero de errores
  err_msg         VARCHAR2(2048); 									-- Mensaje de error
  V_MSQL          VARCHAR2(4000 CHAR);
  V_TABLA         VARCHAR2(30 CHAR) := '#TABLA_COPIADA#';
  V_TABLA_COPIADA VARCHAR2(30 CHAR);
  V_SUFIJO        VARCHAR2(3 CHAR) := '#SUFIJO#';
  V_COUNT         NUMBER(38);

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INICIO]');

  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

  IF V_COUNT = 1 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA||' existente');

    V_MSQL := 'SELECT SUBSTR(TABLE_NAME,1,26)||'''||V_SUFIJO||''' FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_TABLA_COPIADA;

    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_COPIADA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT = 1 THEN
      V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA_COPIADA;
      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA_COPIADA||' eliminada por ser copia anterior');

    END IF;

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA;
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT > 0 THEN
      V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA_COPIADA||'
        AS SELECT * 
        FROM '||V_ESQUEMA||'.'||V_TABLA;
      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA||' copiada en '||V_TABLA_COPIADA);

    ELSE

      DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA||' no copiada por estar vacía');

    END IF;
  ELSE

    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA||' no existente');

  END IF;

  DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    ROLLBACK;
    RAISE;
END;
/
EXIT

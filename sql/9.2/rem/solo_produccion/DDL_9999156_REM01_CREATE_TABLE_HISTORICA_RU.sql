--/*
--##########################################
--## AUTOR=VIOREL REMUS OIVIDIU
--## FECHA_CREACION=20180710
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1304
--## PRODUCTO=NO
--##
--## Finalidad: Crear las tablas históricas de los procesos apr_load_ur_con_prov_facturas, apr_load_ur_facturas_ventas, apr_load_ur_sin_prov_facturas, apr_load_ur_situacion_facturas 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

  V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_COUNT NUMBER(16); -- Vble. para contar.
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_PREFIX VARCHAR2(2 CHAR) := 'H_';
  TYPE T_TABLA IS TABLE OF VARCHAR2(30 CHAR);
  V_TABLA T_TABLA := T_TABLA('APR_AUX_I_UR_FACT_PROV','AUX_URF_UR_FACTURAS','APR_AUX_I_UR_FACT_SIN_PROV','APR_AUX_I_UR_FACT_SIT');
  V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-1304';
  V_HIST VARCHAR2(30 CHAR);
    
BEGIN

  DBMS_OUTPUT.PUT_LINE('[INICIO]');

  FOR I IN V_TABLA.FIRST .. V_TABLA.LAST
  LOOP

    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA(I)||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
    IF V_COUNT = 1 THEN
      V_HIST := V_PREFIX || SUBSTR(V_TABLA(I),1,30);
      V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_HIST||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

      IF V_COUNT = 0 THEN
        V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_HIST||' AS
          SELECT AUX.*, SYSDATE FECHA_PROCESADO, ROWID ID_ROW 
          FROM '||V_ESQUEMA||'.'||V_TABLA(I)||' AUX';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_HIST);

      ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la tabla '||V_HIST);

      END IF;
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;

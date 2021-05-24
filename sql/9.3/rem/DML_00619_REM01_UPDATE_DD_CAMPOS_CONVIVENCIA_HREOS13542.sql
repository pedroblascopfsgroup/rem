--/*
--#########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210419
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13542
--## PRODUCTO=NO
--## 
--## Finalidad: Borrado Lógico campos de Convivencia Sareb
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
  V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_TABLA_COS VARCHAR2(50 CHAR):= 'DD_COS_CAMPOS_ORIGEN_CONV_SAREB';
  V_TABLA_CCS VARCHAR2(50 CHAR):= 'DD_CCS_CAMPOS_CONV_SAREB';
  V_TABLA_CONF2 VARCHAR2(50 CHAR):= 'ACT_CONF2_ACCION';
  V_TABLA_CONF3 VARCHAR2(50 CHAR):= 'ACT_CONF3_MAPEO';
  V_COUNT NUMBER(16); -- Vble. para contar.
  V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-13542';
  ACT_NUM_ACTIVO_UVEM NUMBER(32);
  DD_SCR_DESCRIPCION VARCHAR2(72 CHAR);
  ACT_NUM_ACTIVO_OLD NUMBER(32);
  ACT_NUM_ACTIVO_NEW NUMBER(32);


BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICACION BORRADO LOGICO EN '||V_TABLA_COS);
  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_COS||' SET 
          USUARIOBORRAR = '''||V_USUARIO||'''
        , FECHABORRAR = SYSDATE
        , BORRADO = 1
        WHERE DD_COS_CODIGO IN (''170'',''171'') AND BORRADO = 0
        ';
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICACION BORRADO LOGICO EN '||V_TABLA_CCS);
  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_CCS||' SET 
          USUARIOBORRAR = '''||V_USUARIO||'''
        , FECHABORRAR = SYSDATE
        , BORRADO = 1
        WHERE DD_COS_ID IN (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.'||V_TABLA_COS||'  
        WHERE DD_COS_CODIGO IN (''170'',''171'')) AND BORRADO = 0
        ';
  EXECUTE IMMEDIATE V_SQL;

  DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICACION BORRADO LOGICO EN '||V_TABLA_CONF2);
  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_CONF2||' SET 
          USUARIOBORRAR = '''||V_USUARIO||'''
        , FECHABORRAR = SYSDATE
        , BORRADO = 1
        WHERE DD_COS_ID IN (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.'||V_TABLA_COS||'  
        WHERE DD_COS_CODIGO IN (''170'',''171'')) AND BORRADO = 0
        ';
  EXECUTE IMMEDIATE V_SQL;

  DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICACION BORRADO LOGICO EN '||V_TABLA_CONF3);
  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_CONF3||' SET 
          USUARIOBORRAR = '''||V_USUARIO||'''
        , FECHABORRAR = SYSDATE
        , BORRADO = 1
        WHERE DD_CCS_ID IN (SELECT DD_CCS_ID FROM '||V_ESQUEMA||'.'||V_TABLA_CCS||'  
        WHERE DD_COS_ID IN (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.'||V_TABLA_COS||'  
        WHERE DD_COS_CODIGO IN (''170'',''171''))) AND BORRADO = 0
        ';
  EXECUTE IMMEDIATE V_SQL;
 
    
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
EXIT;

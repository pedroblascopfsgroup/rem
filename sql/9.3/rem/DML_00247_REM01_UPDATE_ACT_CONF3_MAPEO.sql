--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210119
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12825
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
  V_TABLA VARCHAR2(50 CHAR):= 'ACT_CONF3_MAPEO';
  V_COUNT NUMBER(16); -- Vble. para contar.
  V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-12825';
  ACT_NUM_ACTIVO_UVEM NUMBER(32);
  DD_SCR_DESCRIPCION VARCHAR2(72 CHAR);
  ACT_NUM_ACTIVO_OLD NUMBER(32);
  ACT_NUM_ACTIVO_NEW NUMBER(32);


BEGIN

  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
          USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        , AC3_TRANSFORMACION = ''LEFT JOIN (SELECT CASE WHEN AUX.VALOR_NUEVO = 1 THEN 1 WHEN AUX.VALOR_NUEVO = 0 THEN 0 END SPS_OCUPADO, AUX.ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ESPARTA_EXCEL1 AUX WHERE AUX.CAMPO = ''''007'''') CRUCE ON CRUCE.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO''
        WHERE DD_CCS_ID = (SELECT CCS.DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB CCS 
        JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON COS.DD_COS_ID = CCS.DD_COS_ID AND COS.BORRADO = 0
        WHERE DD_CCS_CAMPO = ''SPS_OCUPADO'' AND CCS.BORRADO = 0 AND COS.DD_COS_CODIGO = ''007'')
        ';
  EXECUTE IMMEDIATE V_SQL;
  
    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
          USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        , AC3_TRANSFORMACION = ''LEFT JOIN (SELECT CASE WHEN AUX.VALOR_NUEVO = 1 THEN 1 WHEN AUX.VALOR_NUEVO = 0 THEN 0 END CHECK_SUBROGADO, AUX.ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ESPARTA_EXCEL1 AUX WHERE AUX.CAMPO = ''''008'''') CRUCE ON CRUCE.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO''
        WHERE DD_CCS_ID = (SELECT CCS.DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB CCS 
        JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON COS.DD_COS_ID = CCS.DD_COS_ID AND COS.BORRADO = 0
        WHERE CCS.BORRADO = 0 AND COS.DD_COS_CODIGO = ''008'')
        ';
  EXECUTE IMMEDIATE V_SQL;
  
    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
          USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        , AC3_TRANSFORMACION = ''LEFT JOIN (SELECT CASE WHEN AUX.VALOR_NUEVO = 1 THEN 1 WHEN AUX.VALOR_NUEVO = 0 THEN 0 END SPS_OCUPADO, AUX.ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ESPARTA_EXCEL1 AUX WHERE AUX.CAMPO = ''''009'''') CRUCE ON CRUCE.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO''
        WHERE DD_CCS_ID = (SELECT CCS.DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB CCS 
        JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON COS.DD_COS_ID = CCS.DD_COS_ID AND COS.BORRADO = 0
        WHERE DD_CCS_CAMPO = ''SPS_OCUPADO'' AND CCS.BORRADO = 0 AND COS.DD_COS_CODIGO = ''009'')
        ';
  EXECUTE IMMEDIATE V_SQL;
  
    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
          USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        , AC3_TRANSFORMACION = ''LEFT JOIN (SELECT CASE WHEN AUX.VALOR_NUEVO = 1 THEN 1 WHEN AUX.VALOR_NUEVO = 0 THEN 0 END SPS_ACC_ANTIOCUPA, AUX.ACT_NUM_ACTIVO FROM ESPARTA_EXCEL1 AUX WHERE AUX.CAMPO = ''''013'''') CRUCE ON CRUCE.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO''
        WHERE DD_CCS_ID = (SELECT CCS.DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB CCS 
        JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON COS.DD_COS_ID = CCS.DD_COS_ID AND COS.BORRADO = 0
        WHERE CCS.BORRADO = 0 AND COS.DD_COS_CODIGO = ''013'')
        ';
  EXECUTE IMMEDIATE V_SQL;
  
      V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
          USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        , AC3_TRANSFORMACION = ''LEFT JOIN (SELECT CASE WHEN AUX.VALOR_NUEVO = 1 THEN 1 WHEN AUX.VALOR_NUEVO = 0 THEN 0 END ACT_VPO, AUX.ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ESPARTA_EXCEL1 AUX WHERE AUX.CAMPO = ''''024'''') CRUCE ON CRUCE.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO''
        WHERE DD_CCS_ID = (SELECT CCS.DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB CCS 
        JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON COS.DD_COS_ID = CCS.DD_COS_ID AND COS.BORRADO = 0
        WHERE CCS.BORRADO = 0 AND COS.DD_COS_CODIGO = ''024'')
        ';
  EXECUTE IMMEDIATE V_SQL;
  
      V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
          USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        , AC3_TRANSFORMACION = ''LEFT JOIN (SELECT CASE WHEN AUX.VALOR_NUEVO = 1 THEN 1 WHEN AUX.VALOR_NUEVO = 0 THEN 0 END TIENE_ANEJOS_REGISTRALES, AUX.ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ESPARTA_EXCEL1 AUX WHERE AUX.CAMPO = ''''119'''') CRUCE ON CRUCE.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO''
        WHERE DD_CCS_ID = (SELECT CCS.DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB CCS 
        JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON COS.DD_COS_ID = CCS.DD_COS_ID AND COS.BORRADO = 0
        WHERE CCS.BORRADO = 0 AND COS.DD_COS_CODIGO = ''119'')
        ';
  EXECUTE IMMEDIATE V_SQL;
  
    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
          USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        , AC3_TRANSFORMACION = ''LEFT JOIN (SELECT CASE WHEN AUX.VALOR_NUEVO = 1 THEN 1 WHEN AUX.VALOR_NUEVO = 0 THEN 0 END SPS_ACC_TAPIADO, AUX.ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ESPARTA_EXCEL1 AUX WHERE AUX.CAMPO = ''''096'''') CRUCE ON CRUCE.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO''
        WHERE DD_CCS_ID = (SELECT CCS.DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB CCS 
        JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON COS.DD_COS_ID = CCS.DD_COS_ID AND COS.BORRADO = 0
        WHERE CCS.BORRADO = 0 AND COS.DD_COS_CODIGO = ''096'')
        ';
  EXECUTE IMMEDIATE V_SQL;
  
      V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
          USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        , AC3_TRANSFORMACION = ''JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL CRUCE ON CRUCE.ACT_ID = ACT.ACT_ID AND CRUCE.BORRADO = 0 LEFT JOIN (SELECT CASE WHEN AUX.VALOR_NUEVO = 1 THEN 1 WHEN AUX.VALOR_NUEVO = 0 THEN 0 END EDI_ASCENSOR, AUX.ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ESPARTA_EXCEL1 AUX WHERE AUX.CAMPO = ''''016'''') CRUCE ON CRUCE.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO''
        WHERE DD_CCS_ID = (SELECT CCS.DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB CCS 
        JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON COS.DD_COS_ID = CCS.DD_COS_ID AND COS.BORRADO = 0
        WHERE CCS.BORRADO = 0 AND COS.DD_COS_CODIGO = ''016'')
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

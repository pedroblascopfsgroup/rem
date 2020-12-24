--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20201221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12514
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
  V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-12514';
  ACT_NUM_ACTIVO_UVEM NUMBER(32);
  DD_SCR_DESCRIPCION VARCHAR2(72 CHAR);
  ACT_NUM_ACTIVO_OLD NUMBER(32);
  ACT_NUM_ACTIVO_NEW NUMBER(32);


BEGIN

  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
          USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        , AC3_TRANSFORMACION = ''LEFT JOIN '||V_ESQUEMA||'.DD_MCN_MOTIVO_CALIFIC_NEG CRUCE ON CRUCE.DD_MCN_CODIGO = TMP.VALOR_NUEVO AND CRUCE.BORRADO = 0''
        WHERE DD_CCS_ID = (SELECT CCS.DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB CCS 
        JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON COS.DD_COS_ID = CCS.DD_COS_ID AND COS.BORRADO = 0
        WHERE CCS.BORRADO = 0 AND COS.DD_COS_CODIGO = ''140'')
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

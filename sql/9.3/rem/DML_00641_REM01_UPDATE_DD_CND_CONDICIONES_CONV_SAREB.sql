--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210521
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13988
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
  V_TABLA VARCHAR2(50 CHAR):= 'DD_CND_CONDICIONES_CONV_SAREB';
  V_COUNT NUMBER(16); -- Vble. para contar.
  V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-13988';
  ACT_NUM_ACTIVO_UVEM NUMBER(32);
  DD_SCR_DESCRIPCION VARCHAR2(72 CHAR);
  ACT_NUM_ACTIVO_OLD NUMBER(32);
  ACT_NUM_ACTIVO_NEW NUMBER(32);


BEGIN

  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
          USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        , QUERY_ACT = ''SELECT DISTINCT ACT.ACT_ID 
			FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			JOIN '||V_ESQUEMA||'.TMP_CONV_SAREB TMP ON TMP.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO 
			JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON TMP.ORIGEN = COS.DD_COS_CODIGO
			WHERE COS.DD_COS_CODIGO IN (''''029'''',''''030'''',''''031'''',''''032'''',''''033'''',''''034'''',''''035'''',''''036'''',''''037'''',''''038'''',''''039'''') 
			AND EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
			JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID 
			JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01''''
			WHERE OFR.BORRADO = 0 AND ACTO.ACT_ID = ACT.ACT_ID)''
        WHERE DD_CND_CODIGO = ''OFR_VUE_CAR''
        ';
  EXECUTE IMMEDIATE V_SQL;

  DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros');
    
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

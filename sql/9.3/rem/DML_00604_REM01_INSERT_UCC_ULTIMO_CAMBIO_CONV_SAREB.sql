--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210503
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13845
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
  V_TABLA VARCHAR2(50 CHAR):= 'UCC_ULTIMO_CAMBIO_CONV_SAREB';
  V_COUNT NUMBER(16); -- Vble. para contar.
  V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-13845';
  ACT_NUM_ACTIVO_UVEM NUMBER(32);
  DD_SCR_DESCRIPCION VARCHAR2(72 CHAR);
  ACT_NUM_ACTIVO_OLD NUMBER(32);
  ACT_NUM_ACTIVO_NEW NUMBER(32);


BEGIN

  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'  
            (
            ACT_ID
            , DD_COS_ID
            , VALOR
            )
            (SELECT 
            ULT_VALOR.ACT_ID,
            ULT_VALOR.DD_COS_ID,
            ULT_VALOR.VALOR
            FROM 
            (SELECT ACT_ID
            , DD_COS_ID
            , VALOR
            , ROW_NUMBER() OVER (PARTITION BY HCCN.ACT_ID, HCCN.DD_COS_ID ORDER BY HCCN.CCN_ID DESC) RN 
            FROM '||V_ESQUEMA||'.H_CCN_CAMBIOS_CONV_SAREB HCCN ) ULT_VALOR
            JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON ULT_VALOR.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0
            WHERE ULT_VALOR.RN = 1
            AND COS.DD_COS_CODIGO IN (''002'',''004'',''018'',''040'',''042'',''044'',''046'',''048'',''050'',''052'',''054'',''058'',''060'',''062''))';
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

--/*
--#########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180605
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-899
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
--    V_TABLA VARCHAR2(25 CHAR):= 'POP_PLANTILLAS_OPERACION';
--    V_COUNT NUMBER(16); -- Vble. para contar.
--    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
--    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-899';

BEGIN

	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL 
				ADD AJD_EXP_DEF_TESTI NUMBER(4,0)
				';
 	
 	EXECUTE IMMEDIATE V_SQL;
 	
 	V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.AJD_EXP_DEF_TESTI IS ''Expedientes con Defectos Testimonio''
				';
 	
 	EXECUTE IMMEDIATE V_SQL;
 
 	
 	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL 
				ADD ADN_EXP_DEF_TESTI NUMBER(4,0)
				';
 	
 	EXECUTE IMMEDIATE V_SQL;
 	
 	V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.ADN_EXP_DEF_TESTI IS ''Expedientes con Defectos Testimonio''
				';
 	
 	EXECUTE IMMEDIATE V_SQL;

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

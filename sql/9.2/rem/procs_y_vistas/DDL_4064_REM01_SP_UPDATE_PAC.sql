--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=201803
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-643
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
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.UPDATE_PAC
   (  ACT_NUM_ACTIVO IN NUMBER
	, PAC_INCLUIDO IN NUMBER
	, PAC_CHECK_TRA_ADMISION IN NUMBER
	, PAC_CHECK_GESTIONAR IN NUMBER
	, PAC_CHECK_ASIGNAR_MEDIADOR IN NUMBER
	, PAC_CHECK_COMERCIALIZAR IN NUMBER
	, PAC_CHECK_FORMALIZAR IN NUMBER
	, PL_OUTPUT OUT VARCHAR2
   )
   
   AS

   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar        
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ACT_ID NUMBER(32);
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   DESCRIPCION VARCHAR2(64 CHAR);

BEGIN

	EXECUTE IMMEDIATE 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||'' INTO ACT_ID;


	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO SET
				  PAC_INCLUIDO = '||PAC_INCLUIDO||'
				, PAC_CHECK_TRA_ADMISION = '||PAC_CHECK_TRA_ADMISION||'
				, PAC_CHECK_GESTIONAR = '||PAC_CHECK_GESTIONAR||'
				, PAC_CHECK_ASIGNAR_MEDIADOR = '||PAC_CHECK_ASIGNAR_MEDIADOR||'
				, PAC_CHECK_COMERCIALIZAR = '||PAC_CHECK_COMERCIALIZAR||'
				, PAC_CHECK_FORMALIZAR = '||PAC_CHECK_FORMALIZAR||'
			 WHERE ACT_ID = '||ACT_ID;
			 
	EXECUTE IMMEDIATE V_SQL;
	
	PL_OUTPUT := '[INFO] actualizado el perímetro del activo '||ACT_NUM_ACTIVO||' a '||' 
				  PAC_INCLUIDO = '||PAC_INCLUIDO||'
				, PAC_CHECK_TRA_ADMISION = '||PAC_CHECK_TRA_ADMISION||'
				, PAC_CHECK_GESTIONAR = '||PAC_CHECK_GESTIONAR||'
				, PAC_CHECK_ASIGNAR_MEDIADOR = '||PAC_CHECK_ASIGNAR_MEDIADOR||'
				, PAC_CHECK_COMERCIALIZAR = '||PAC_CHECK_COMERCIALIZAR||'
				, PAC_CHECK_FORMALIZAR = '||PAC_CHECK_FORMALIZAR||'';


COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END UPDATE_PAC;
/
EXIT;

--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20190308
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3543
--## PRODUCTO=NO
--## 
--## Finalidad: borrar duplicados en las tablas ACT_GES_DIST_GESTORES, GAC_GESTOR_ADD_ACTIVO y GEE_GESTOR_ENTIDAD 
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3543';

BEGIN

--BUSCA Y ACTUALIZA DD_TPN_TIPO_INMUEBLE

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso.');

		V_SQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES WHERE ID = 27200';

		EXECUTE IMMEDIATE V_SQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] Se han BORRADO en total '||SQL%ROWCOUNT||' registros en la tabla ACT_GES_DIST_GESTORES.');
		
		V_SQL := 'DELETE FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC
			  	WHERE GEE_ID IN (
						7526935,
						7540437,
						7529073,
						7550704,
						7543342,
						7551177,
						7532807,
						7546273,
						7532809,
						7532808,
						7546563,
						7525209,
						7545380,
						7529074,
						7536606,
						7534488,
						7525206,
						7544330,
						7530717,
						7544511,
						7544494,
						7525208,
						7523059,
						7534487,
						7540439,
						7543906,
						7549692,
						7548704,
						7550002,
						7538337,
						7553250,
						7553031,
						7526936,
						9507145,
						10113536,
						10213788
						 
							)';

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han BORRADO en total '||SQL%ROWCOUNT||' registros en la tabla GAC_GESTOR_ADD_ACTIVO.');

		V_SQL := 'DELETE FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
			  	WHERE GEE_ID IN (
						7526935,
						7540437,
						7529073,
						7550704,
						7543342,
						7551177,
						7532807,
						7546273,
						7532809,
						7532808,
						7546563,
						7525209,
						7545380,
						7529074,
						7536606,
						7534488,
						7525206,
						7544330,
						7530717,
						7544511,
						7544494,
						7525208,
						7523059,
						7534487,
						7540439,
						7543906,
						7549692,
						7548704,
						7550002,
						7538337,
						7553250,
						7553031,
						7526936,
						9507145,
						10113536,
						10213788)';

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han BORRADO en total '||SQL%ROWCOUNT||' registros en la tabla GEE_GESTOR_ENTIDAD.');

		V_SQL := 'DELETE FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
			  	WHERE GEH_ID IN (
						6454598,
						6463859,
						6454596,
						6476228,
						6468865,
						6476700,
						6456241,
						6471797,
						6456243,
						6456242,
						6472086,	
						6448584,
						6470903,
						6454597,
						6460009,
						6462131,
						6450729,
						6469853,
						6456240,
						6470034,
						6470017,
						6450731,
						6450730,
						6460010,
						6463861,
						6469430,
						6475215,
						6474226,
						6475524,
						6465961,
						6478773,
						6478553,
						6452459,
						8767578,
						9402384,
						9951262)';

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han BORRADO en total '||SQL%ROWCOUNT||' registros en la tabla GAC_GESTOR_ADD_ACTIVO.');

		V_SQL := 'DELETE FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
			  	WHERE GEH_ID IN (
						6454598,
						6463859,
						6454596,
						6476228,
						6468865,
						6476700,
						6456241,
						6471797,
						6456243,
						6456242,
						6472086,	
						6448584,
						6470903,
						6454597,
						6460009,
						6462131,
						6450729,
						6469853,
						6456240,
						6470034,
						6470017,
						6450731,
						6450730,
						6460010,
						6463861,
						6469430,
						6475215,
						6474226,
						6475524,
						6465961,
						6478773,
						6478553,
						6452459,
						8767578,
						9402384,
						9951262)';


		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han BORRADO en total '||SQL%ROWCOUNT||' registros en la tabla GEH_GESTOR_ENTIDAD_HIST.');


		COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el proceso.');

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

--/*
--#########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20200328
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6756
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion registros 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_TABLA VARCHAR2(100 CHAR) := 'TAC_TAREAS_ACTIVOS'; -- Tabla Destino
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6756';
	V_NUM_REGISTROS NUMBER; -- Cuenta registros 
	
BEGIN
  V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' TAC USING (
				SELECT  tar_id
				FROM(
				  SELECT tar.tar_id, TAR.TAR_TAREA_FINALIZADA, ROW_NUMBER() OVER(PARTITION BY TRA.TRA_ID ORDER BY TAR.TAR_ID DESC) AS RN 
				  FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP 
				  inner JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TAP.TAP_ID = TEX.TAP_ID
				  inner JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID 
				  inner JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAR.TAR_ID = TAC.TAR_ID 
				  inner JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TAC.TRA_ID = TRA.TRA_ID 
				  inner JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TAC.ACT_ID = ACT.ACT_ID 
				  inner join '||V_ESQUEMA||'.ACT_TBJ_trabajo tbj on tbj.TBJ_ID = TRA.TBJ_ID
				  WHERE  tbj.dd_ttr_id = 23 
				  and act.dd_cra_id = 101 
				  and act.dd_scr_id = 363 
				  AND  TRA.DD_EPR_ID = 30
				  AND TRA.BORRADO = 0 and tbj.borrado = 0 
				  and tap.tap_codigo in (''T013_PBCReserva'',
				                         ''T013_ResultadoPBC'',
				                         ''T013_FirmaPropietario'',
				                         ''T013_DefinicionOferta''
				                         )
				)
				C
				WHERE RN = 1 and C.TAR_TAREA_FINALIZADA = 0
			) TMP 
			ON (TMP.tar_id = TAC.tar_id)
			WHEN MATCHED THEN UPDATE SET 
			TAC.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME LIKE ''isanchezmu''),
			TAC.USUARIOMODIFICAR = '''||V_USUARIO||''',
			TAC.FECHAMODIFICAR = SYSDATE';
			
	EXECUTE IMMEDIATE V_SQL;	
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualzado en total '||V_NUM_REGISTROS||' registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'');
	COMMIT;
	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------'||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||V_SQL||CHR(10);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;

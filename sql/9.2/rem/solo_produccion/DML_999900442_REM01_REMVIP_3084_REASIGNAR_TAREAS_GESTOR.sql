--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190128
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3084
--## PRODUCTO=NO
--## 
--## Finalidad: Reasignar tareas a gestores.
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

	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	
BEGIN

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE REASIGNACIÓN DE TAREAS...');
      
 
      V_SENTENCIA :=   'MERGE INTO REM01.TAC_TAREAS_ACTIVOS T1
						USING 
						(
								SELECT DISTINCT TAC.TAR_ID, 
												USU2.USU_ID GESTOR_VIEJO_ID, USU.USU_USERNAME GESTOR_VIEJO,
												USU.USU_ID GESTOR_NUEVO_ID, USU.USU_USERNAME GESTOR_NUEVO
								FROM REM01.AUX_MMC_REMVIP_3084                  AUX
								JOIN REMMASTER.USU_USUARIOS                     USU
								  ON USU.USU_USERNAME = AUX.CIF_PROVEEDOR
								JOIN REM01.ACT_TBJ_TRABAJO                      TBJ
								  ON TBJ.TBJ_NUM_TRABAJO = AUX.TRABAJO
								JOIN REM01.ACT_TRA_TRAMITE                      TRA
								  ON TRA.TBJ_ID = TBJ.TBJ_ID
								JOIN REM01.TAC_TAREAS_ACTIVOS                   TAC
								  ON TAC.TRA_ID = TRA.TRA_ID
								LEFT JOIN REM01.TAR_TAREAS_NOTIFICACIONES       TAR
								  ON TAR.TAR_ID = TAC.TAR_ID
								LEFT JOIN REM01.TEX_TAREA_EXTERNA               TEX
								  ON TEX.TAR_ID = TAR.TAR_ID
								LEFT JOIN REM01.TAP_TAREA_PROCEDIMIENTO         TAP
								  ON TEX.TAP_ID = TAP.TAP_ID
								LEFT JOIN REM01.DD_TPO_TIPO_PROCEDIMIENTO       TPO
								  ON TPO.DD_TPO_ID = TAP.DD_TPO_ID
								LEFT JOIN REMMASTER.USU_USUARIOS                USU2
								  ON USU2.USU_ID = TAC.USU_ID
								WHERE TAR.TAR_TAREA_FINALIZADA = 0 
								  AND TAP.TAP_CODIGO = ''T004_AnalisisPeticion''
						) T2
						ON (T1.TAR_ID = T2.TAR_ID)
						WHEN MATCHED THEN 
						UPDATE SET
							T1.USU_ID = T2.GESTOR_NUEVO_ID,
							T1.USUARIOMODIFICAR = ''REMVIP-3084'',
							T1.FECHAMODIFICAR = SYSDATE
      ';

      EXECUTE IMMEDIATE V_SENTENCIA;    
      DBMS_OUTPUT.PUT_LINE('	[INFO] REASIGNADAS  '||SQL%ROWCOUNT||' TAREAS.');
      
      DBMS_OUTPUT.PUT_LINE('[FIN]');
    
	  COMMIT;
      
           
EXCEPTION
WHEN OTHERS THEN
	DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
	DBMS_OUTPUT.put_line('-----------------------------------------------------------');
	DBMS_OUTPUT.put_line(SQLERRM);
	ROLLBACK;
	RAISE;
END;
/
EXIT;

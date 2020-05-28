--/*
--###########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200519
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7308
--## PRODUCTO=NO
--## 
--## Finalidad: CERRAR TRAMITES Y TAREAS DE TRABAJOS ANULADOS DEL PUNTO 4 Y 5
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
alter session set NLS_NUMERIC_CHARACTERS = '.,';


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-7308';
  USU_ID  NUMBER(16);
  TBJ_ID  NUMBER(16);
	
  
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TRA_TRAMITE T1
	    USING (SELECT DISTINCT
			tra.tra_id
			FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP
			inner JOIN REM01.TEX_TAREA_EXTERNA TEX ON TAP.TAP_ID = TEX.TAP_ID
			inner JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID and tar.TAR_TAREA_FINALIZADA = 0
			inner JOIN REM01.TAC_TAREAS_ACTIVOS TAC ON TAR.TAR_ID = TAC.TAR_ID
			inner JOIN REM01.ACT_TRA_TRAMITE TRA ON TAC.TRA_ID = TRA.TRA_ID 
			inner join REM01.ACT_TBJ_trabajo tbj on tbj.TBJ_ID = TRA.TBJ_ID 
			inner join rem01.act_tbj atbj on atbj.tbj_id = tbj.tbj_id 
			inner join REM01.ACT_PVC_PROVEEDOR_CONTACTO pvc on tbj.pvc_id = pvc.pvc_id 
			inner join REMMASTER.USU_USUARIOS usu on usu.usu_id = pvc.usu_id
			inner join REM01.ACT_ACTIVO act on act.act_id = atbj.act_id
			inner join rem01.aux_remvip_7294 aux on AUX.NUM_TRABAJO = tbj.tbj_num_trabajo
			WHERE TRA.BORRADO = 0 and tar.borrado = 0
			and TBJ.DD_TTR_ID <> 23
			and tbj.usuariocrear = ''MIG_DIVARIAN'' 
		  ) T2
	    ON (T1.TRA_ID = T2.TRA_ID)
	  WHEN MATCHED THEN
	    UPDATE 
	       SET T1.TRA_FECHA_FIN = SYSDATE,
			T1.DD_EPR_ID = 5,
		   	T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
		   	T1.FECHAMODIFICAR = SYSDATE ';
		
	EXECUTE IMMEDIATE V_MSQL;  
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros EN ACT_TRA_TRAMITE ');  

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
	    USING (SELECT DISTINCT
			tar.tar_id
			FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP
			inner JOIN REM01.TEX_TAREA_EXTERNA TEX ON TAP.TAP_ID = TEX.TAP_ID
			inner JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID and tar.TAR_TAREA_FINALIZADA = 0
			inner JOIN REM01.TAC_TAREAS_ACTIVOS TAC ON TAR.TAR_ID = TAC.TAR_ID
			inner JOIN REM01.ACT_TRA_TRAMITE TRA ON TAC.TRA_ID = TRA.TRA_ID 
			inner join REM01.ACT_TBJ_trabajo tbj on tbj.TBJ_ID = TRA.TBJ_ID 
			inner join rem01.act_tbj atbj on atbj.tbj_id = tbj.tbj_id 
			inner join REM01.ACT_PVC_PROVEEDOR_CONTACTO pvc on tbj.pvc_id = pvc.pvc_id 
			inner join REMMASTER.USU_USUARIOS usu on usu.usu_id = pvc.usu_id
			inner join REM01.ACT_ACTIVO act on act.act_id = atbj.act_id
			inner join rem01.aux_remvip_7294 aux on AUX.NUM_TRABAJO = tbj.tbj_num_trabajo
			WHERE TRA.BORRADO = 0 and tar.borrado = 0
			and TBJ.DD_TTR_ID <> 23
			and tbj.usuariocrear = ''MIG_DIVARIAN'' 
		  )T2
	    ON (T1.TAR_ID = T2.TAR_ID)
	  WHEN MATCHED THEN
	    UPDATE 
	       SET T1.BORRADO = 1,
		T1.TAR_FECHA_FIN = SYSDATE,
		T1.TAR_TAREA_FINALIZADA = 1,
		T1.USUARIOBORRAR = '''||V_USUARIO||''',
		T1.FECHABORRAR = SYSDATE';
		
	EXECUTE IMMEDIATE V_MSQL;  
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAR_TAREAS_NOTIFICACIONES ');  
		
    	COMMIT;

   	DBMS_OUTPUT.PUT_LINE('[FIN] ');

EXCEPTION

   WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;
        RAISE;          

END;

/

EXIT

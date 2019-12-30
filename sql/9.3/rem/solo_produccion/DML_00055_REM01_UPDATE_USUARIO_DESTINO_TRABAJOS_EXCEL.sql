--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191219
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5874
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR DESTINATARIO TAREAS VIVAS GESTOR MANTENIMIENTO
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5874.1'; -- USUARIOCREAR/USUARIOMODIFICAR.

    
BEGIN		


        DBMS_OUTPUT.PUT_LINE('[INICIO] Reasignando tareas abiertas al usuario grupgact');	

	V_MSQL := ' MERGE INTO REM01.TAC_TAREAS_ACTIVOS T1
		    USING( 
			SELECT TAR.TAR_ID
			FROM REM01.TAC_TAREAS_ACTIVOS TAC
			INNER JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TAC.TAR_ID = TAR.TAR_ID 
			INNER JOIN REM01.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID
			INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID = TAC.ACT_ID 
			INNER JOIN REM01.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAC.TAR_ID
			INNER JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
			INNER JOIN REMMASTER.USU_USUARIOS USU ON TAC.USU_ID = USU.USU_ID
			INNER JOIN REM01.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = TRA.TBJ_ID
			INNER JOIN REM01.AUX_REMVIP_5874 AUX ON TBJ.TBJ_NUM_TRABAJO = AUX.NUM_TRABAJO
			WHERE TRA.DD_EPR_ID = 30 
			AND (ACT.DD_CRA_ID = 21 OR ACT.DD_CRA_ID = 43) 
			AND TAP.DD_TGE_ID = 362 
			AND TAR.BORRADO = 0
			AND USU.USU_USERNAME <> ''usugruhpm'' 
			AND TAP.TAP_CODIGO NOT LIKE ''%Result%'' 
			AND (TBJ.TBJ_GESTOR_ACTIVO_RESPONSABLE <> 50479 OR TBJ.TBJ_RESPONSABLE_TRABAJO <> 50479)
			) T2
		    ON (T1.TAR_ID = T2.TAR_ID)
		    WHEN MATCHED THEN UPDATE SET
		    T1.USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE USU_USERNAME = ''grupgact''),
		    USUARIOMODIFICAR = ''' || V_USR || ''',	
		    FECHAMODIFICAR = SYSDATE';	

	--DBMS_OUTPUT.PUT_LINE(V_MSQL); 	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de TAC_TAREAS_ACTIVOS '); 

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;	

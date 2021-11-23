--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20211123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10713
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

V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_M VARCHAR2(10 CHAR) := '#ESQUEMA_MASTER#';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_NUM_TABLAS NUMBER(16);
V_MSQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN 
 

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZACIÓN USUARIO ASIGNADO TAREA.');
 
         V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC USING(
						SELECT DISTINCT TAC.TAR_ID, USU2.USU_ID
						FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
						INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID AND TAR.TAR_TAREA_FINALIZADA = 0 AND TAR.BORRADO = 0
						INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAC.TAR_ID AND TEX.BORRADO = 0
						INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID AND TAP.TAP_CODIGO IN (''T013_CierreEconomico'',''T017_CierreEconomico'') AND TAP.BORRADO = 0
						INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TAC.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0
						INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.ACT_ID = ACT.ACT_ID AND TRA.BORRADO = 0 AND TRA.TRA_FECHA_FIN IS NULL
						INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_ID = TAC.USU_ID AND USU.BORRADO = 0
						INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU2 ON USU2.BORRADO = 0 AND USU2.USU_USERNAME = ''grucontroller''
						AND TAC.BORRADO = 0 AND TAC.USU_ID != USU2.USU_ID) AUX 
					ON (AUX.TAR_ID = TAC.TAR_ID)
					WHEN MATCHED THEN UPDATE SET
					TAC.USU_ID = AUX.USU_ID,
					TAC.USUARIOMODIFICAR = ''REMVIP-10713'',
					TAC.FECHAMODIFICAR = SYSDATE';
   	  	EXECUTE IMMEDIATE V_MSQL;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - Actualizadas '||SQL%ROWCOUNT||' tareas a grucontroller.');
  
  
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

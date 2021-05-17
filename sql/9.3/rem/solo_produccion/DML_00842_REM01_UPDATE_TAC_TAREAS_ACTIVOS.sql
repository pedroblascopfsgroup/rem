--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210510
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9659
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar gestor de tareas
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

	-- Variables
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9659';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
   	
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR TABLA TAC_TAREAS_ACTIVOS.');

	V_SQL := '
		MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1
			USING (
				SELECT TAC.TAR_ID, USU.USU_ID FROM '||V_ESQUEMA||'.AUX_REMVIP_9659 AUX
				INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
				INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON ACT.ACT_ID = TAC.ACT_ID
				INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TAC.TRA_ID = TRA.TRA_ID AND TRA.DD_TPO_ID = 3449
				LEFT JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON AUX.USU_USERNAME = USU.USU_USERNAME
				) T2
			ON (T1.TAR_ID = T2.TAR_ID)
				WHEN MATCHED THEN UPDATE
			SET				
				T1.USU_ID = T2.USU_ID,
				T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
				T1.FECHAMODIFICAR = SYSDATE';										
			
	EXECUTE IMMEDIATE V_SQL;
        
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');  
		
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

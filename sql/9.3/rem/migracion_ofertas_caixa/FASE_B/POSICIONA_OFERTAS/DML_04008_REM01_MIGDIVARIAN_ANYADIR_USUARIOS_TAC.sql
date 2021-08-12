--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20201116
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-HREOS-12141
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar usuarios en la TAC para las tareas paralelas de BBVA.
--## 
--## INSTRUCCIONES:  
--## VERSIONES:
--## 		0.1 Versión inicial HREOS-12141
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

TABLE_COUNT NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_M VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

/* !!!!!!!!!!! OJO PARA LA PROXIMA MIGRACION HAY QUE MODIFICAR LAS CONDICIONES DONDE SE MIRAN LAS TAREAS (NOMBRES) PORQUE CON LAS TILDES PARECE
QUE NO LO PILLA BIEN Y NO ACTUALIZA. ECHAR UN OJO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/













BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la modificacion de usuarios de la TAC_TAREAS_ACTIVOS');

		
	-------------------------------------------------
    --INSERCION EN TAC_TAREAS_ACTIVOS--
    -------------------------------------------------
    
        DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN TAC_TAREAS_USUARIOS de usuarios y supervisores (DEFINICION OFERTA, RESOLUCIÓN COMITÉ, RESPUESTA OFERTANTE, RATIFICACIÓN COMITÉ)');
		
						
	V_SENTENCIA := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC USING(
			    SELECT ACT_ID, USU_ID, TAR_ID, TRA_ID, row_num FROM (SELECT DISTINCT GAC.ACT_ID, GEE.USU_ID,    ROW_NUMBER() OVER (
				  PARTITION BY GAC.ACT_ID
				  ORDER BY GEE.USU_ID
			       ) row_num, TAC.TAR_ID, TAC.TRA_ID
			    FROM '||V_ESQUEMA||'.gee_gestor_entidad GEE
			    INNER JOIN '||V_ESQUEMA||'.gac_gestor_add_activo GAC
			    ON GAC.GEE_ID = GEE.GEE_ID
			    INNER JOIN '||V_ESQUEMA_M||'.dd_tge_tipo_gestor TGE
			    ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''HAYAGBOINM''
			    INNER JOIN '||V_ESQUEMA||'.ACT_TBJ ACB 
			    ON ACB.ACT_ID = GAC.ACT_ID
			    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			    ON GAC.ACT_ID = ACT.ACT_ID
			    INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
			    ON TAC.ACT_ID = ACT.ACT_ID
			    INNER JOIN '||V_ESQUEMA||'.tar_tareas_notificaciones TAR
			    ON TAR.TAR_ID = TAC.TAR_ID AND TAR.TAR_TAREA IN(''Definición oferta'', ''Resolución comité'', ''Respuesta ofertante'', ''Ratificación comité'')
			    WHERE GEE.BORRADO = 0 AND ACT.USUARIOCREAR = ''MIG_BBVA''
			    ) WHERE row_num = 1
			) AUX ON (AUX.TAR_ID = TAC.TAR_ID AND AUX.TRA_ID = TAC.TRA_ID)
			WHEN MATCHED THEN UPDATE SET
			TAC.USU_ID = AUX.USU_ID,
			TAC.SUP_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE USU_USERNAME = ''lclaret'')
			WHERE TAC.USU_ID != AUX.USU_ID or TAC.USU_ID is null

			';
	EXECUTE IMMEDIATE V_SENTENCIA;

	DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS modificada. '||SQL%ROWCOUNT||' Filas.');
	
	   DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN TAC_TAREAS_USUARIOS de usuarios y supervisores (CIERRE ECONÓMICO)');
		
						
	V_SENTENCIA := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC USING(
			    SELECT ACT_ID, USU_ID, TAR_ID, TRA_ID, row_num FROM (SELECT DISTINCT GAC.ACT_ID, GEE.USU_ID,    ROW_NUMBER() OVER (
				  PARTITION BY GAC.ACT_ID
				  ORDER BY GEE.USU_ID
			       ) row_num, TAC.TAR_ID, TAC.TRA_ID
			    FROM '||V_ESQUEMA||'.gee_gestor_entidad GEE
			    INNER JOIN '||V_ESQUEMA||'.gac_gestor_add_activo GAC
			    ON GAC.GEE_ID = GEE.GEE_ID
			    INNER JOIN '||V_ESQUEMA_M||'.dd_tge_tipo_gestor TGE
			    ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GCONT''
			    INNER JOIN '||V_ESQUEMA||'.ACT_TBJ ACB 
			    ON ACB.ACT_ID = GAC.ACT_ID
			    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			    ON GAC.ACT_ID = ACT.ACT_ID
			    INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
			    ON TAC.ACT_ID = ACT.ACT_ID
			    INNER JOIN '||V_ESQUEMA||'.tar_tareas_notificaciones TAR
			    ON TAR.TAR_ID = TAC.TAR_ID AND TAR.TAR_TAREA IN(''Cierre económico'')
			    WHERE GEE.BORRADO = 0 AND ACT.USUARIOCREAR = ''MIG_BBVA''
			    ) WHERE row_num = 1
			) AUX ON (AUX.TAR_ID = TAC.TAR_ID AND AUX.TRA_ID = TAC.TRA_ID)
			WHEN MATCHED THEN UPDATE SET
			TAC.USU_ID = AUX.USU_ID,
			TAC.SUP_ID = AUX.USU_ID
			WHERE TAC.USU_ID != AUX.USU_ID or TAC.USU_ID is null

			';
	EXECUTE IMMEDIATE V_SENTENCIA;

	DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS modificada. '||SQL%ROWCOUNT||' Filas.');
	
    DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN TAC_TAREAS_USUARIOS de usuarios y supervisores (INSTRUCCIONES RESERVA Y OBTENCIÓN CONTRATO RESERVA)');
		
						
	V_SENTENCIA := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC USING(
			    SELECT ACT_ID, USU_ID, TAR_ID, TRA_ID, row_num FROM (SELECT DISTINCT GAC.ACT_ID, GEE.USU_ID,    ROW_NUMBER() OVER (
				  PARTITION BY GAC.ACT_ID
				  ORDER BY GEE.USU_ID
			       ) row_num, TAC.TAR_ID, TAC.TRA_ID
			    FROM '||V_ESQUEMA||'.gee_gestor_entidad GEE
			    INNER JOIN '||V_ESQUEMA||'.gac_gestor_add_activo GAC
			    ON GAC.GEE_ID = GEE.GEE_ID
			    INNER JOIN '||V_ESQUEMA_M||'.dd_tge_tipo_gestor TGE
			    ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''HAYAGBOINM''
			    INNER JOIN '||V_ESQUEMA||'.ACT_TBJ ACB 
			    ON ACB.ACT_ID = GAC.ACT_ID
			    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			    ON GAC.ACT_ID = ACT.ACT_ID
			    INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
			    ON TAC.ACT_ID = ACT.ACT_ID
			    INNER JOIN '||V_ESQUEMA||'.tar_tareas_notificaciones TAR
			    ON TAR.TAR_ID = TAC.TAR_ID AND TAR.TAR_TAREA IN (''Instrucciones reserva'', ''Obtención contrato reserva'')
			    WHERE GEE.BORRADO = 0 AND ACT.USUARIOCREAR = ''MIG_BBVA''
			    ) WHERE row_num = 1
			) AUX ON (AUX.TAR_ID = TAC.TAR_ID AND AUX.TRA_ID = TAC.TRA_ID)
			WHEN MATCHED THEN UPDATE SET
			TAC.USU_ID = AUX.USU_ID,
			TAC.SUP_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE USU_USERNAME = ''lclaret'')
			WHERE TAC.USU_ID != AUX.USU_ID or TAC.USU_ID is null

			';
	EXECUTE IMMEDIATE V_SENTENCIA;

	DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS modificada. '||SQL%ROWCOUNT||' Filas.');


  DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN TAC_TAREAS_USUARIOS de usuarios y supervisores  (POSICIONAMIENTO Y FIRMA, Y DOCUMENTOS POST-VENTA)');

		V_SENTENCIA := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC USING(
				    SELECT ACT_ID, USU_ID, TAR_ID, TRA_ID, row_num FROM (SELECT DISTINCT GAC.ACT_ID, GEE.USU_ID,    ROW_NUMBER() OVER (
					  PARTITION BY GAC.ACT_ID
					  ORDER BY GEE.USU_ID
				       ) row_num, TAC.TAR_ID, TAC.TRA_ID
				    FROM '||V_ESQUEMA||'.gee_gestor_entidad GEE
				    INNER JOIN '||V_ESQUEMA||'.gac_gestor_add_activo GAC
				    ON GAC.GEE_ID = GEE.GEE_ID
				    INNER JOIN '||V_ESQUEMA_M||'.dd_tge_tipo_gestor TGE
				    ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GIAFORM''
				    INNER JOIN '||V_ESQUEMA||'.ACT_TBJ ACB 
				    ON ACB.ACT_ID = GAC.ACT_ID
				    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT 
				    ON GAC.ACT_ID = ACT.ACT_ID
				    INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
				    ON TAC.ACT_ID = ACT.ACT_ID
				    INNER JOIN '||V_ESQUEMA||'.tar_tareas_notificaciones TAR
				    ON TAR.TAR_ID = TAC.TAR_ID AND TAR.TAR_TAREA IN (''Posicionamiento y firma'', ''Documentos post-venta'')
				    WHERE GEE.BORRADO = 0 AND ACT.USUARIOCREAR = ''MIG_BBVA''
				    ) WHERE row_num = 1
				) AUX ON (AUX.TAR_ID = TAC.TAR_ID AND AUX.TRA_ID = TAC.TRA_ID)
				WHEN MATCHED THEN UPDATE SET
				TAC.USU_ID = AUX.USU_ID
				WHERE TAC.USU_ID != AUX.USU_ID or TAC.USU_ID is null
			';

	EXECUTE IMMEDIATE V_SENTENCIA;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS modificada. '||SQL%ROWCOUNT||' Filas.');

		V_SENTENCIA := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC USING(
				    SELECT ACT_ID, USU_ID, TAR_ID, TRA_ID, row_num FROM (SELECT DISTINCT GAC.ACT_ID, GEE.USU_ID,    ROW_NUMBER() OVER (
					  PARTITION BY GAC.ACT_ID
					  ORDER BY GEE.USU_ID
				       ) row_num, TAC.TAR_ID, TAC.TRA_ID
				    FROM '||V_ESQUEMA||'.gee_gestor_entidad GEE
				    INNER JOIN '||V_ESQUEMA||'.gac_gestor_add_activo GAC
				    ON GAC.GEE_ID = GEE.GEE_ID
				    INNER JOIN '||V_ESQUEMA_M||'.dd_tge_tipo_gestor TGE
				    ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''SFORM''
				    INNER JOIN '||V_ESQUEMA||'.ACT_TBJ ACB 
				    ON ACB.ACT_ID = GAC.ACT_ID
				    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT 
				    ON GAC.ACT_ID = ACT.ACT_ID
				    INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
				    ON TAC.ACT_ID = ACT.ACT_ID
				    INNER JOIN '||V_ESQUEMA||'.tar_tareas_notificaciones TAR
				    ON TAR.TAR_ID = TAC.TAR_ID AND TAR.TAR_TAREA IN (''Posicionamiento y firma'', ''Documentos post-venta'')
				    WHERE GEE.BORRADO = 0 AND ACT.USUARIOCREAR = ''MIG_BBVA''
				    ) WHERE row_num = 1
				) AUX ON (AUX.TAR_ID = TAC.TAR_ID AND AUX.TRA_ID = TAC.TRA_ID)
				WHEN MATCHED THEN UPDATE SET
				TAC.SUP_ID = AUX.USU_ID
				WHERE TAC.SUP_ID != AUX.USU_ID or TAC.SUP_ID is null
			';
	EXECUTE IMMEDIATE V_SENTENCIA;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS modificada. '||SQL%ROWCOUNT||' Filas.');
	
	
 DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN TAC_TAREAS_USUARIOS de usuarios y supervisores  (PBC RESERVA)');

		V_SENTENCIA := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC USING(
				    SELECT ACT_ID, USU_ID, TAR_ID, TRA_ID, row_num FROM (SELECT DISTINCT GAC.ACT_ID, GEE.USU_ID,    ROW_NUMBER() OVER (
					  PARTITION BY GAC.ACT_ID
					  ORDER BY GEE.USU_ID
				       ) row_num, TAC.TAR_ID, TAC.TRA_ID
				    FROM '||V_ESQUEMA||'.gee_gestor_entidad GEE
				    INNER JOIN '||V_ESQUEMA||'.gac_gestor_add_activo GAC
				    ON GAC.GEE_ID = GEE.GEE_ID
				    INNER JOIN '||V_ESQUEMA_M||'.dd_tge_tipo_gestor TGE
				    ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GFORM''
				    INNER JOIN '||V_ESQUEMA||'.ACT_TBJ ACB 
				    ON ACB.ACT_ID = GAC.ACT_ID
				    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT 
				    ON GAC.ACT_ID = ACT.ACT_ID
				    INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
				    ON TAC.ACT_ID = ACT.ACT_ID
				    INNER JOIN '||V_ESQUEMA||'.tar_tareas_notificaciones TAR
				    ON TAR.TAR_ID = TAC.TAR_ID AND TAR.TAR_TAREA IN (''PBC Reserva'', ''PBC Venta'')
				    WHERE GEE.BORRADO = 0 AND ACT.USUARIOCREAR = ''MIG_BBVA''
				    ) WHERE row_num = 1
				) AUX ON (AUX.TAR_ID = TAC.TAR_ID AND AUX.TRA_ID = TAC.TRA_ID)
				WHEN MATCHED THEN UPDATE SET
				TAC.USU_ID = AUX.USU_ID
				WHERE TAC.USU_ID != AUX.USU_ID or TAC.USU_ID is null
			';

	EXECUTE IMMEDIATE V_SENTENCIA;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS modificada. '||SQL%ROWCOUNT||' Filas.');

		V_SENTENCIA := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC USING(
				    SELECT ACT_ID, USU_ID, TAR_ID, TRA_ID, row_num FROM (SELECT DISTINCT GAC.ACT_ID, GEE.USU_ID,    ROW_NUMBER() OVER (
					  PARTITION BY GAC.ACT_ID
					  ORDER BY GEE.USU_ID
				       ) row_num, TAC.TAR_ID, TAC.TRA_ID
				    FROM '||V_ESQUEMA||'.gee_gestor_entidad GEE
				    INNER JOIN '||V_ESQUEMA||'.gac_gestor_add_activo GAC
				    ON GAC.GEE_ID = GEE.GEE_ID
				    INNER JOIN '||V_ESQUEMA_M||'.dd_tge_tipo_gestor TGE
				    ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''SFORM''
				    INNER JOIN '||V_ESQUEMA||'.ACT_TBJ ACB 
				    ON ACB.ACT_ID = GAC.ACT_ID
				    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT 
				    ON GAC.ACT_ID = ACT.ACT_ID
				    INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
				    ON TAC.ACT_ID = ACT.ACT_ID
				    INNER JOIN '||V_ESQUEMA||'.tar_tareas_notificaciones TAR
				    ON TAR.TAR_ID = TAC.TAR_ID AND TAR.TAR_TAREA IN (''PBC Reserva'',''PBC Venta'')
				    WHERE GEE.BORRADO = 0 AND ACT.USUARIOCREAR = ''MIG_BBVA''
				    ) WHERE row_num = 1
				) AUX ON (AUX.TAR_ID = TAC.TAR_ID AND AUX.TRA_ID = TAC.TRA_ID)
				WHEN MATCHED THEN UPDATE SET
				TAC.SUP_ID = AUX.USU_ID
				WHERE TAC.SUP_ID != AUX.USU_ID or TAC.SUP_ID is null
			';
	EXECUTE IMMEDIATE V_SENTENCIA;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS modificada. '||SQL%ROWCOUNT||' Filas.');
	COMMIT;
	
	
	DBMS_OUTPUT.PUT_LINE('[FIN] Acaba la inserción de usuarios en la TAC');
	
      
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
	

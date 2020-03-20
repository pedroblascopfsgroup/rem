--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20200306
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5732
--## PRODUCTO=NO
--## Finalidad: DML para borrar lógicamente las tareas asociadas a activos borrados lógicamente.
--## INSTRUCCIONES: 
--## VERSIONES: 1.0 version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
	V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIOBORRAR VARCHAR(100 CHAR):= 'REMVIP-5732';
	err_num NUMBER;
	err_msg VARCHAR2(255);
	  
	V_TABLA_AUX VARCHAR2(30 CHAR):= 'AUX_TRAMITE_ACTIVOS_BORRADOS'; -- Tabla con los datos de entrada
	
	V_NUM_INFORME NUMBER(16); -- Vble. para seleccionar el siguiente número de informe.  
	  
BEGIN	
	
	DBMS_OUTPUT.put_line('[INICIO] COMIENZA EL PROCESO PARA BORRAR LOS TRÁMITES Y TAREAS RELACIONADOS A ACTIVOS BORRADOS');
		
	DBMS_OUTPUT.put_line('[INFO] TRUNCANDO de '||V_TABLA_AUX);
	
	#ESQUEMA#.OPERACION_DDL.DDL_TABLE('TRUNCATE', V_TABLA_AUX);
	
	DBMS_OUTPUT.put_line('[INFO] RELLENANDO '||V_TABLA_AUX);
	
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_AUX||'
				SELECT DISTINCT TAC.TRA_ID, TAC.BORRADO TAC_BORRADO, TRA.BORRADO TRA_BORRADO, TAR.BORRADO TAR_BORRADO
				FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
				INNER JOIN '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO VTAR ON TAC.TAR_ID = VTAR.TAR_ID
				INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = TAC.ACT_ID
				INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID
				INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
				WHERE ACT.BORRADO = 1
				AND (TAC.BORRADO = 0 OR TRA.BORRADO = 0 OR TAR.BORRADO = 0)';
				
	EXECUTE IMMEDIATE V_SQL;	
	
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
			        USING (			
						SELECT DISTINCT TAC.TAR_ID
						FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA 
						     INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
						     INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TAC.ACT_ID = ACT.ACT_ID
						     INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
						WHERE TRA.TRA_ID IN
						(
							SELECT TRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' WHERE TAR_BORRADO = 0
						)
			        ) T2 
	        		ON (T1.TAR_ID = T2.TAR_ID )
					WHEN MATCHED THEN 
						UPDATE
						SET T1.BORRADO = 1,
						    T1.USUARIOBORRAR = '''||V_USUARIOBORRAR||''',
						    T1.FECHABORRAR   = SYSDATE,
						    T1.TAR_FECHA_FIN = SYSDATE,
						    T1.TAR_TAREA_FINALIZADA = 1';
	
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAR_TAREAS_NOTIFICACIONES ');  
	
	
	-----------------------------------------------------------------------------------------------------------------
	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_TRA_TRAMITE - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TRA_TRAMITE T1
		        USING (		
					SELECT DISTINCT TAC.TRA_ID, TAC.ACT_ID
					FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA 
					     INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
					     INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TAC.ACT_ID = ACT.ACT_ID
					     INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
					WHERE TRA.TRA_ID IN
					(
						SELECT TRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' WHERE TRA_BORRADO = 0
					)
		        ) T2 
		        ON (T1.TRA_ID = T2.TRA_ID AND T1.ACT_ID = T2.ACT_ID )
				WHEN MATCHED THEN UPDATE
				SET T1.BORRADO = 1,
				    T1.USUARIOBORRAR = '''||V_USUARIOBORRAR||''',
				    T1.FECHABORRAR   = SYSDATE,
				    T1.TRA_FECHA_FIN = SYSDATE'

	;

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_TRA_TRAMITE ');  
	
	
	-----------------------------------------------------------------------------------------------------------------
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAC_TAREAS_ACTIVOS - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1
		        USING (
					SELECT DISTINCT TAC.TRA_ID, TAC.ACT_ID, TAC.TAR_ID
					FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA 
					     INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
					     INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TAC.ACT_ID = ACT.ACT_ID
					     INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
					WHERE TRA.TRA_ID IN
					(
						SELECT TRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' WHERE TAC_BORRADO = 0
					)		
		        ) T2 
		        ON (T1.TRA_ID = T2.TRA_ID AND T1.ACT_ID = T2.ACT_ID AND T1.TAR_ID = T2.TAR_ID )
				WHEN MATCHED THEN UPDATE
				SET T1.BORRADO = 1,
				    T1.USUARIOBORRAR = ''' || V_USUARIOBORRAR || ''',
				    T1.FECHABORRAR   = SYSDATE';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAC_TAREAS_ACTIVOS ');  
	
	
	-----------------------------------------------------------------------------------------------------------------
		
	DBMS_OUTPUT.put_line('[INFO] BORRADOS LÓGICAMENTE TAREAS Y TRÁMITES RELACIONADOS A ACTIVOS CON BORRADO LÓGICO');		
				
	DBMS_OUTPUT.put_line('[FIN] LIMPIEZA DE TAREAS Y TRÁMITES FINALIZADA');
	

	COMMIT;
   

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


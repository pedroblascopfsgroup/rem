--/*
--#########################################
--## AUTOR=IKER ADOT
--## FECHA_CREACION=20190510
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6274
--## PRODUCTO=NO
--## 
--## Finalidad: Merge de las gestorias en vuelo de cajamar
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

  V_ESQUEMA VARCHAR2(30 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  USUARIOCREAR VARCHAR2(50 CHAR):= 'HREOS-6274';

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO] ');

      -------------------------------------------------
      --INSERCION EN GESTORES--
      -------------------------------------------------   
      
      -------------------------------------------------
      --INSERCION EN GEE--
      -------------------------------------------------
      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
				USING ( 
						SELECT TMP.GEE_ID, TMP.USU_ID_NUEVO, TMP.ECO_ID FROM '||V_ESQUEMA||'.TMP_RECONFG_GEST_FORM TMP
				) TMP1
				ON (
					GEE.GEE_ID = TMP1.GEE_ID
				)
				WHEN MATCHED THEN 
				UPDATE SET
						  GEE.USU_ID = TMP1.USU_ID_NUEVO,
						  GEE.USUARIOMODIFICAR = '''||USUARIOCREAR||''',
						  GEE.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN 
				INSERT (GEE.GEE_ID, GEE.USU_ID, GEE.DD_TGE_ID, GEE.USUARIOCREAR, GEE.FECHACREAR, GEE.USUARIOMODIFICAR)
				  VALUES (
						  '||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL,
						  TMP1.USU_ID_NUEVO,
						  (
							SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''GIAFORM'' AND TGE.BORRADO = 0
						  ),
						  '''||USUARIOCREAR||''',
						  SYSDATE,
						  TMP1.ECO_ID
				  )
      ';
      EXECUTE IMMEDIATE V_SQL;      
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TABLAS||' registros insertados/modificados en GEE.');  
      
      -------------------------------------------------
      --INSERCION EN GCO--
      -------------------------------------------------
      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO (GEE_ID, ECO_ID)
                SELECT GEE.GEE_ID, 
                       TO_NUMBER(GEE.USUARIOMODIFICAR) 
				FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE 
				WHERE USUARIOCREAR = '''||USUARIOCREAR||'''
				  AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO GCO WHERE GCO.GEE_ID = GEE.GEE_ID)
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TABLAS||' registros insertados en GCO.');				
    
      -------------------------------------------------
      --INSERCION EN GEH--
      -------------------------------------------------
      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST T1
				USING (
					SELECT DISTINCT GEH.GEH_ID
					FROM '||V_ESQUEMA||'.TMP_RECONFG_GEST_FORM				TMP
					JOIN '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO 			GCH ON GCH.ECO_ID = TMP.ECO_ID
					JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST     		GEH ON GEH.GEH_ID = GCH.GEH_ID
					WHERE GEH.DD_TGE_ID IN (
										SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GIAFORM''
										) 
					AND TMP.TIPO_GESTOR = ''GIAFORM''
					AND GEH.GEH_FECHA_HASTA IS NULL
				) T2 
				ON (
					T1.GEH_ID = T2.GEH_ID
				)
				WHEN MATCHED THEN 
				UPDATE SET
					T1.GEH_FECHA_HASTA = SYSDATE,
					T1.USUARIOMODIFICAR = '''||USUARIOCREAR||''',
					T1.FECHAMODIFICAR = SYSDATE
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TABLAS||' registros modificados en GEH.');    

      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST (GEH_ID, USU_ID, DD_TGE_ID, GEH_FECHA_DESDE, GEH_FECHA_HASTA, USUARIOCREAR, FECHACREAR, BORRADO, USUARIOMODIFICAR)
				
				SELECT '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL  	AS GEH_ID,
					   TMP.USU_ID_NUEVO                						AS USU_ID,
					   TGE.DD_TGE_ID                                        AS DD_TGE_ID,
					   SYSDATE AS GEH_FECHA_DESDE,
					   NULL AS GEH_FECHA_HASTA,
					   '''||USUARIOCREAR||''',
					   SYSDATE,
					   0,
					   TMP.ECO_ID
				FROM '||V_ESQUEMA||'.TMP_RECONFG_GEST_FORM      TMP
				JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR       TGE ON TGE.DD_TGE_CODIGO = TMP.TIPO_GESTOR
				WHERE TMP.TIPO_GESTOR = ''GIAFORM''
	  ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TABLAS||' registros insertados en GEH.');
    
      -------------------------------------------------
      --INSERCION EN GCH--
      -------------------------------------------------
      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO (GEH_ID, ECO_ID)
				SELECT GEH.GEH_ID,
					   TO_NUMBER(GEH.USUARIOMODIFICAR)
				FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST     GEH 
				WHERE USUARIOCREAR = '''||USUARIOCREAR||'''
	  ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TABLAS||' registros insertados en GCH.');    
    
      -------------------------------------------------
      --RESTAURAMOS EN GEH--
      -------------------------------------------------
      V_SQL := 'UPDATE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST 
				SET USUARIOMODIFICAR = NULL
				WHERE USUARIOCREAR = '''||USUARIOCREAR||'''
	  ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TABLAS||' registros restaurados en GEH.');
      
      -------------------------------------------------
      --RESTAURAMOS EN GEE--
      -------------------------------------------------
      V_SQL := 'UPDATE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD 
				SET USUARIOMODIFICAR = NULL
				WHERE USUARIOCREAR = '''||USUARIOCREAR||'''
	  ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TABLAS||' registros restaurados en GEE.');
      
      -------------------------------------------------
      --ACTUALIZACION DE TAREAS, DESPUES DE REVISION DE TAREAS VIVAS--
      -------------------------------------------------
	  V_SQL := 'MERGE INTO REM01.TAC_TAREAS_ACTIVOS 	        T1
				USING (
					SELECT DISTINCT TMP.USU_ID_NUEVO, TAC.TAR_ID
					FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL			ECO
					JOIN '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO				GCO ON GCO.ECO_ID = ECO.ECO_ID
					JOIN '||V_ESQUEMA||'.TMP_RECONFG_GEST_FORM		 	TMP ON TMP.ECO_ID = GCO.ECO_ID
					JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD		        GEE ON GEE.GEE_ID = GCO.GEE_ID
					JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR           TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GIAFORM''
					JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO                  TBJ ON TBJ.TBJ_ID = ECO.TBJ_ID
					JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE		            TRA ON TRA.TBJ_ID = TBJ.TBJ_ID
					JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS		        TAC ON TAC.TRA_ID = TRA.TRA_ID
					JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES	    TAR ON TAR.TAR_ID = TAC.TAR_ID AND TAR.TAR_FECHA_FIN IS NULL AND TAR.TAR_TAREA_FINALIZADA = 0 
						AND TAR.tar_tarea in (''Informe jurídico'',''Posicionamiento y firma'',''Documentos post-venta'')
					JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO	 	TPO ON TPO.DD_TPO_ID = TRA.DD_TPO_ID AND TPO.DD_TPO_CODIGO = ''T013''
					) T2
				ON
					(
					T1.TAR_ID = T2.TAR_ID
					)
				WHEN MATCHED THEN
				UPDATE
				SET
					T1.USU_ID = T2.USU_ID_NUEVO,
					T1.USUARIOMODIFICAR = '''||USUARIOCREAR||''',
					T1.FECHAMODIFICAR = SYSDATE
	  ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TABLAS||' registros modificados en TAC.');
 
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('[FIN]');   
       
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

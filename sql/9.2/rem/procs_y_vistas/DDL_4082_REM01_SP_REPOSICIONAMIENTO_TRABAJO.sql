--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190513
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1965
--## PRODUCTO=NO
--##
--## Finalidad: Crear SP pra reposicionar trabajos.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE       #ESQUEMA#.REPOSICIONAMIENTO_TRABAJO (USUARIO VARCHAR2
		, TRABAJO VARCHAR2
        , ID_TRAMITE VARCHAR2
        , TAREA_TRAMITE VARCHAR2
		, PL_OUTPUT OUT VARCHAR2) AUTHID CURRENT_USER AS

	  
	  V_MSQL VARCHAR2 (32000 CHAR);
      V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
      V_ESQUEMA_MASTER VARCHAR2(20 CHAR) := '#ESQUEMA_MASTER#';
      V_USUARIO VARCHAR2(50 CHAR) := USUARIO;
      V_TABLA VARCHAR2(40 CHAR) := 'TRABAJOS_REPOSICIONAR'; -- Vble. Tabla pivote
      V_SENTENCIA VARCHAR2(2600 CHAR);
      V_TAREA_TRAMITE VARCHAR2(100 CHAR):= TRIM(TAREA_TRAMITE);
      PL_OUTPUT2 VARCHAR2 (32000 CHAR);
      
      -- Vbls. para el cursor
      V_TBJ_ID NUMBER(16) := 0; -- Vble. para almacenar el TBJ_ID
      S_TRA NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TRA_ID
      S_TAR NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TAR_ID
      S_TEX NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TEX_ID

      -- Cursor que almacena las secuencias
      CURSOR CURSOR_TRABAJOS IS
      SELECT DISTINCT TBJ_ID  FROM #ESQUEMA#.TRABAJOS_REPOSICIONAR TRA
      ;

      -- Tablas de volcado
      V_TABLA_TBJ VARCHAR2(30 CHAR) := 'ACT_TBJ_TRABAJO';
      V_TABLA_ACT_TBJ VARCHAR2(30 CHAR) := 'ACT_TBJ';
      V_TABLA_TRA VARCHAR2(30 CHAR) := 'ACT_TRA_TRAMITE';
      V_TABLA_TAR VARCHAR2(30 CHAR) := 'TAR_TAREAS_NOTIFICACIONES';
      V_TABLA_ETN VARCHAR2(30 CHAR) := 'ETN_EXTAREAS_NOTIFICACIONES';
      V_TABLA_TEX VARCHAR2(30 CHAR) := 'TEX_TAREA_EXTERNA';
      V_TABLA_TAC VARCHAR2(30 CHAR) := 'TAC_TAREAS_ACTIVOS';

BEGIN

      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------') ;
      DBMS_OUTPUT.PUT_LINE('----------------PROCESO DE GENERACION DE TRAMITES ---------------------') ;
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------') ;

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TRABAJOS_REPOSICIONAR --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] APROVISIONANDO LA TABLA AUXILIAR '||V_TABLA||'...');

      V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'';

      --DBMS_OUTPUT.PUT_LINE(V_MSQL);

      EXECUTE IMMEDIATE V_MSQL;
        
      IF ID_TRAMITE = '0' THEN
        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (TBJ_ID, ACT_ID, TPO_ID, TAP_ID ,TRA_ID ,TRA_PROCES_BPM)
                        SELECT DISTINCT TBJ.TBJ_ID
                                        , ACT.ACT_ID
                                        , TPO.DD_TPO_ID AS DD_TPO_ID
                                        , TAP.TAP_ID AS TAP_ID
                                        , TRA.TRA_ID
                                        , TRA.TRA_PROCESS_BPM  
                        FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
                            LEFT JOIN '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_ID = TBJ.DD_TTR_ID AND TTR.DD_TTR_CODIGO IN (''01'',''02'',''03'',''04'',''05'')
                            LEFT JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST ON EST.DD_EST_ID = TBJ.DD_EST_ID AND EST.DD_EST_CODIGO IN (''01'',''04'',''09'',''10'',''11'',''13'')
                            LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ ATB ON ATB.TBJ_ID = TBJ.TBJ_ID
                            LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ATB.ACT_ID AND ACT.BORRADO = 0
                            LEFT JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON (TBJ.TBJ_ID = TRA.TBJ_ID) OR (ACT.ACT_ID = TRA.ACT_ID)
                            LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_CODIGO = SUBSTR('''||TAREA_TRAMITE||''',1,4)
                            LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_CODIGO = '''||TAREA_TRAMITE||'''
                            LEFT JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR ON STR.DD_STR_ID = TBJ.DD_STR_ID
                        WHERE TBJ.BORRADO = 0 AND TBJ.TBJ_NUM_TRABAJO = '||TRABAJO||'';
            
          --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    
          EXECUTE IMMEDIATE V_MSQL;
      
      ELSE
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (TBJ_ID, ACT_ID, TPO_ID, TAP_ID ,TRA_ID ,TRA_PROCES_BPM)
                        SELECT DISTINCT TBJ.TBJ_ID
                                        , ACT.ACT_ID
                                        , TPO.DD_TPO_ID AS DD_TPO_ID
                                        , TAP.TAP_ID AS TAP_ID
                                        , TRA.TRA_ID
                                        , TRA.TRA_PROCESS_BPM  
                        FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
                            LEFT JOIN '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_ID = TBJ.DD_TTR_ID AND TTR.DD_TTR_CODIGO IN (''01'',''02'',''03'',''04'',''05'')
                            LEFT JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST ON EST.DD_EST_ID = TBJ.DD_EST_ID AND EST.DD_EST_CODIGO IN (''01'',''04'',''09'',''10'',''11'',''13'')
                            LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ ATB ON ATB.TBJ_ID = TBJ.TBJ_ID
                            LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ATB.ACT_ID AND ACT.BORRADO = 0
                            LEFT JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON (TBJ.TBJ_ID = TRA.TBJ_ID) OR (ACT.ACT_ID = TRA.ACT_ID)
                            LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_CODIGO = SUBSTR('''||TAREA_TRAMITE||''',1,4)
                            LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_CODIGO = '''||TAREA_TRAMITE||'''
                            LEFT JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR ON STR.DD_STR_ID = TBJ.DD_STR_ID
                        WHERE TBJ.BORRADO = 0 AND TBJ.TBJ_NUM_TRABAJO = '||TRABAJO||' AND TRA.TRA_ID = '||ID_TRAMITE||'';
            
          --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    
          EXECUTE IMMEDIATE V_MSQL;
          
      END IF;
      
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

      ---------------------------------------------------------------------------------------------------------------
      -- UPDATE TRABAJOS_REPOSICIONAR (TBJ_ID, TRA_ID, TAR_ID, TEX_ID) --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] GENERANDO TRA_ID, TAR_ID, TEX_ID...');

      OPEN CURSOR_TRABAJOS;

      LOOP
            FETCH CURSOR_TRABAJOS INTO V_TBJ_ID;
            EXIT WHEN CURSOR_TRABAJOS%NOTFOUND;

                    V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL FROM DUAL';
                    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                    EXECUTE IMMEDIATE V_MSQL INTO S_TAR;
                    V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL FROM DUAL';
                    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                    EXECUTE IMMEDIATE V_MSQL INTO S_TEX;

                    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR TRA
                                SET     TRA.TAR_ID = '||S_TAR||'
                                    ,   TRA.TEX_ID = '||S_TEX||'
                                WHERE TBJ_ID = '||V_TBJ_ID||' ';
                    --DBMS_OUTPUT.PUT_LINE(V_MSQL);                                
                    EXECUTE IMMEDIATE V_MSQL;

      END LOOP;

      CLOSE CURSOR_TRABAJOS;
        
      COMMIT;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada.');

      ---------------------------------------------------------------------------------------------------------------
      -- UPDATE TRABAJOS_REPOSICIONAR (USU_ID, SUP_ID) --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO USU_ID Y SUP_ID...');

     V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
							USING (SELECT DISTINCT T1.ACT_ID, T1.TBJ_ID, T1.TPO_ID, T1.TAP_ID, T3.USU_ID
								FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
								JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID
								JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T3 ON T3.GEE_ID = T2.GEE_ID
								JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR T4 ON T4.DD_TGE_ID = T3.DD_TGE_ID
								JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO T5 ON T5.DD_TPO_ID = T1.TPO_ID
								JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO T6 ON T6.TAP_ID = T1.TAP_ID
								WHERE T1.USU_ID IS NULL AND T5.DD_TPO_CODIGO = ''T004'' AND T6.TAP_CODIGO = '''||V_TAREA_TRAMITE||''' AND T4.DD_TGE_CODIGO = ''GACT'') T2
							ON (T1.TBJ_ID = T2.TBJ_ID AND T1.ACT_ID = T2.ACT_ID)
							WHEN MATCHED THEN UPDATE SET
								T1.USU_ID = T2.USU_ID';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;                    

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR actualizada. '||SQL%ROWCOUNT||' Filas.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
						USING (SELECT DISTINCT T1.ACT_ID, T1.TBJ_ID, T1.TPO_ID, T1.TAP_ID, T3.USU_ID
							FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
							JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID
							JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T3 ON T3.GEE_ID = T2.GEE_ID
							JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR T4 ON T4.DD_TGE_ID = T3.DD_TGE_ID
							JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO T5 ON T5.DD_TPO_ID = T1.TPO_ID
							JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO T6 ON T6.TAP_ID = T1.TAP_ID
							WHERE T1.SUP_ID IS NULL AND T5.DD_TPO_CODIGO = ''T004'' AND T6.TAP_CODIGO = '''||V_TAREA_TRAMITE||''' AND T4.DD_TGE_CODIGO = ''SUPACT'') T2
						ON (T1.TBJ_ID = T2.TBJ_ID AND T1.ACT_ID = T2.ACT_ID)
						WHEN MATCHED THEN UPDATE SET
							T1.SUP_ID = T2.USU_ID';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR actualizada. '||SQL%ROWCOUNT||' Filas.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
						USING (SELECT DISTINCT T1.ACT_ID, T1.TBJ_ID, T1.TPO_ID, T1.TAP_ID, T3.USU_ID
							FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
							JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID
							JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T3 ON T3.GEE_ID = T2.GEE_ID
							JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR T4 ON T4.DD_TGE_ID = T3.DD_TGE_ID
							JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO T5 ON T5.DD_TPO_ID = T1.TPO_ID
							JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO T6 ON T6.TAP_ID = T1.TAP_ID
							WHERE T1.USU_ID IS NULL AND T5.DD_TPO_CODIGO = ''T003'' AND T6.TAP_CODIGO = '''||V_TAREA_TRAMITE||''' AND T4.DD_TGE_CODIGO = ''GACT'') T2
						ON (T1.TBJ_ID = T2.TBJ_ID AND T1.ACT_ID = T2.ACT_ID)
						WHEN MATCHED THEN UPDATE SET
							T1.USU_ID = T2.USU_ID';
   --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR actualizada. '||SQL%ROWCOUNT||' Filas.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
						USING (SELECT DISTINCT T1.ACT_ID, T1.TBJ_ID, T1.TPO_ID, T1.TAP_ID, T3.USU_ID
							FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
							JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID
							JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T3 ON T3.GEE_ID = T2.GEE_ID
							JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR T4 ON T4.DD_TGE_ID = T3.DD_TGE_ID
							JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO T5 ON T5.DD_TPO_ID = T1.TPO_ID
							JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO T6 ON T6.TAP_ID = T1.TAP_ID
							WHERE T1.SUP_ID IS NULL AND T5.DD_TPO_CODIGO = ''T003'' AND T6.TAP_CODIGO = '''||V_TAREA_TRAMITE||''' AND T4.DD_TGE_CODIGO = ''SUPACT'') T2
						ON (T1.TBJ_ID = T2.TBJ_ID AND T1.ACT_ID = T2.ACT_ID)
						WHEN MATCHED THEN UPDATE SET
							T1.SUP_ID = T2.USU_ID';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);                        
    EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR actualizada. '||SQL%ROWCOUNT||' Filas.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
						USING (SELECT DISTINCT T1.ACT_ID, T1.TBJ_ID, T1.TPO_ID, T1.TAP_ID, T3.USU_ID
							FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
							JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID
							JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T3 ON T3.GEE_ID = T2.GEE_ID
							JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR T4 ON T4.DD_TGE_ID = T3.DD_TGE_ID
							JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO T5 ON T5.DD_TPO_ID = T1.TPO_ID
							JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO T6 ON T6.TAP_ID = T1.TAP_ID
							WHERE T1.USU_ID IS NULL AND T5.DD_TPO_CODIGO = ''T008'' AND T6.TAP_CODIGO = '''||V_TAREA_TRAMITE||''' AND T4.DD_TGE_CODIGO = ''GADM'') T2
						ON (T1.TBJ_ID = T2.TBJ_ID AND T1.ACT_ID = T2.ACT_ID)
						WHEN MATCHED THEN UPDATE SET
							T1.USU_ID = T2.USU_ID';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);                        
    EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR actualizada. '||SQL%ROWCOUNT||' Filas.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
						USING (SELECT DISTINCT T1.ACT_ID, T1.TBJ_ID, T1.TPO_ID, T1.TAP_ID, T3.USU_ID
							FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
							JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID
							JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T3 ON T3.GEE_ID = T2.GEE_ID
							JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR T4 ON T4.DD_TGE_ID = T3.DD_TGE_ID
							JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO T5 ON T5.DD_TPO_ID = T1.TPO_ID
							JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO T6 ON T6.TAP_ID = T1.TAP_ID
							WHERE T1.USU_ID IS NULL AND T1.SUP_ID IS NULL AND T5.DD_TPO_CODIGO = ''T008'' AND T6.TAP_CODIGO = '''||V_TAREA_TRAMITE||''' AND T4.DD_TGE_CODIGO = ''SUPADM'') T2
						ON (T1.TBJ_ID = T2.TBJ_ID AND T1.ACT_ID = T2.ACT_ID)
						WHEN MATCHED THEN UPDATE SET
							T1.SUP_ID = T2.USU_ID';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);                       
    EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR actualizada. '||SQL%ROWCOUNT||' Filas.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
						USING (SELECT DISTINCT T1.ACT_ID, T1.TBJ_ID, T1.TPO_ID, T1.TAP_ID, T3.USU_ID
							FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
							JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO AUX ON AUX.TBJ_ID = T1.TBJ_ID
							JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID
							JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T3 ON T3.GEE_ID = T2.GEE_ID
							JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR T4 ON T4.DD_TGE_ID = T3.DD_TGE_ID
							JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO T5 ON T5.DD_TPO_ID = T1.TPO_ID
							JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO T6 ON T6.TAP_ID = T1.TAP_ID
							JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO T7 ON T7.DD_STR_ID = AUX.DD_STR_ID
							WHERE T1.USU_ID IS NULL AND T7.DD_STR_CODIGO IN (''13'',''15'',''16'',''17'') AND T5.DD_TPO_CODIGO = ''T002'' AND T6.TAP_CODIGO = '''||V_TAREA_TRAMITE||''' AND T4.DD_TGE_CODIGO = ''GADM'') T2
						ON (T1.TBJ_ID = T2.TBJ_ID AND T1.ACT_ID = T2.ACT_ID)
						WHEN MATCHED THEN UPDATE SET
							T1.USU_ID = T2.USU_ID';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);                        
    EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR actualizada. '||SQL%ROWCOUNT||' Filas.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
						USING (SELECT DISTINCT T1.ACT_ID, T1.TBJ_ID, T1.TPO_ID, T1.TAP_ID, T3.USU_ID
							FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
							JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO AUX ON AUX.TBJ_ID = T1.TBJ_ID
							JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID
							JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T3 ON T3.GEE_ID = T2.GEE_ID
							JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR T4 ON T4.DD_TGE_ID = T3.DD_TGE_ID
							JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO T5 ON T5.DD_TPO_ID = T1.TPO_ID
							JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO T6 ON T6.TAP_ID = T1.TAP_ID
							JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO T7 ON T7.DD_STR_ID = AUX.DD_STR_ID
							WHERE T1.SUP_ID IS NULL AND T7.DD_STR_CODIGO IN (''13'',''15'',''16'',''17'') AND T5.DD_TPO_CODIGO = ''T002'' AND T6.TAP_CODIGO = '''||V_TAREA_TRAMITE||''' AND T4.DD_TGE_CODIGO = ''SUPADM'') T2
						ON (T1.TBJ_ID = T2.TBJ_ID AND T1.ACT_ID = T2.ACT_ID)
						WHEN MATCHED THEN UPDATE SET
							T1.SUP_ID = T2.USU_ID';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR actualizada. '||SQL%ROWCOUNT||' Filas.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
						USING (SELECT DISTINCT T1.ACT_ID, T1.TBJ_ID, T1.TPO_ID, T1.TAP_ID, T3.USU_ID
							FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
							JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO AUX ON AUX.TBJ_ID = T1.TBJ_ID
							JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID
							JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T3 ON T3.GEE_ID = T2.GEE_ID
							JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR T4 ON T4.DD_TGE_ID = T3.DD_TGE_ID
							JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO T5 ON T5.DD_TPO_ID = T1.TPO_ID
							JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO T6 ON T6.TAP_ID = T1.TAP_ID
							LEFT JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO T7 ON T7.DD_STR_ID = AUX.DD_STR_ID AND NVL(T7.DD_STR_CODIGO,'' '') NOT IN (''13'',''15'',''16'',''17'')
							WHERE T1.USU_ID IS NULL AND T5.DD_TPO_CODIGO = ''T002'' AND T6.TAP_CODIGO = '''||V_TAREA_TRAMITE||''' AND T4.DD_TGE_CODIGO = ''GADM'') T2
						ON (T1.TBJ_ID = T2.TBJ_ID AND T1.ACT_ID = T2.ACT_ID)
						WHEN MATCHED THEN UPDATE SET
							T1.USU_ID = T2.USU_ID';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);                       
    EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR actualizada. '||SQL%ROWCOUNT||' Filas.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
						USING (SELECT DISTINCT T1.ACT_ID, T1.TBJ_ID, T1.TPO_ID, T1.TAP_ID, T3.USU_ID
							FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR T1
							JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO AUX ON AUX.TBJ_ID = T1.TBJ_ID
							JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID
							JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T3 ON T3.GEE_ID = T2.GEE_ID
							JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR T4 ON T4.DD_TGE_ID = T3.DD_TGE_ID
							JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO T5 ON T5.DD_TPO_ID = T1.TPO_ID
							JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO T6 ON T6.TAP_ID = T1.TAP_ID
							LEFT JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO T7 ON T7.DD_STR_ID = AUX.DD_STR_ID AND NVL(T7.DD_STR_CODIGO,'' '') NOT IN (''13'',''15'',''16'',''17'')
							WHERE T1.SUP_ID IS NULL AND T5.DD_TPO_CODIGO = ''T002'' AND T6.TAP_CODIGO = '''||V_TAREA_TRAMITE||''' AND T4.DD_TGE_CODIGO = ''SUPADM'') T2
						ON (T1.TBJ_ID = T2.TBJ_ID AND T1.ACT_ID = T2.ACT_ID)
						WHEN MATCHED THEN UPDATE SET
							T1.SUP_ID = T2.USU_ID';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);                        
    EXECUTE IMMEDIATE V_MSQL;                             

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR actualizada. '||SQL%ROWCOUNT||' Filas.');


    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL VOLCADO A LAS TABLAS DEFINITIVAS');


	  ------------------------------
      -- FINALIZAR TAREAS ACTIVAS --
      ------------------------------
      DBMS_OUTPUT.PUT_LINE('[INFO] FINALIZANDO TAREAS ACTIVAS ...');
      
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET
                        TAR_FECHA_FIN = SYSDATE
                    ,   TAR_TAREA_FINALIZADA  = 1
                    ,   USUARIOBORRAR = '''||V_USUARIO||'''
                    ,   FECHABORRAR = SYSDATE
                    ,   BORRADO = 1
                    WHERE TAR_ID in (SELECT DISTINCT TAR.TAR_ID 
                                        FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR aux
                                        inner join '||V_ESQUEMA||'.ACT_TRA_TRAMITE tra on aux.tra_id = tra.tra_id
                                        inner join '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC on tra.tra_id = tac.tra_id
                                        INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR on tac.tar_id = tar.tar_id
                                        inner join '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex on tex.tar_id = tar.tar_id
                                    )';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      
      EXECUTE IMMEDIATE V_MSQL;    
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES actualizada. '||SQL%ROWCOUNT||' Filas.');
                            
      V_MSQL := 'UPDATE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA SET
            USUARIOBORRAR  = '''||V_USUARIO||'''
        ,   FECHABORRAR = SYSDATE
        ,   BORRADO = 1
        WHERE TAR_ID in (SELECT DISTINCT TEX.TAR_ID 
                            FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR aux
                            inner join '||V_ESQUEMA||'.ACT_TRA_TRAMITE tra on aux.tra_id = tra.tra_id
                            inner join '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC on tra.tra_id = tac.tra_id
                            INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR on tac.tar_id = tar.tar_id
                            inner join '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex on tex.tar_id = tar.tar_id
                        )';  
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      
      EXECUTE IMMEDIATE V_MSQL;                        
                
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.TEX_TAREA_EXTERNA actualizada. '||SQL%ROWCOUNT||' Filas.');
      
      
      IF ID_TRAMITE = '0' THEN
        
        OPEN CURSOR_TRABAJOS;

            LOOP
                FETCH CURSOR_TRABAJOS INTO V_TBJ_ID;
                EXIT WHEN CURSOR_TRABAJOS%NOTFOUND;
    
                        V_MSQL := 'SELECT '||V_ESQUEMA||'.S_ACT_TRA_TRAMITE.NEXTVAL FROM DUAL';
                        --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                        EXECUTE IMMEDIATE V_MSQL INTO S_TRA;
                        
    
                        V_MSQL := 'UPDATE '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR TRA
                                    SET     TRA.TRA_ID = '||S_TRA||'
                                    WHERE TBJ_ID = '||V_TBJ_ID||' ';
                        --DBMS_OUTPUT.PUT_LINE(V_MSQL);                                
                        EXECUTE IMMEDIATE V_MSQL;
    
            END LOOP;
    
        CLOSE CURSOR_TRABAJOS;
      
      ---------------------------------------------------------------------------------------------------------------            
      -- INSERT ACT_TRA_TRAMITE --
      ---------------------------------------------------------------------------------------------------------------
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TRAMITE...');
      
      V_MSQL := '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TRA||'
            (
                  TRA_ID
                  ,TBJ_ID
                  ,DD_TPO_ID
                  ,DD_EPR_ID
                  ,TRA_DECIDIDO
                  ,TRA_PROCESS_BPM
                  ,TRA_PARALIZADO
                  ,TRA_FECHA_INICIO
                  ,VERSION
                  ,USUARIOCREAR
                  ,FECHACREAR
                  ,BORRADO
                  ,DD_TAC_ID
            )
            SELECT DISTINCT
                  MIG2.TRA_ID                                                                      AS TRA_ID
                  , MIG2.TBJ_ID                                                                    AS TBJ_ID
                  , MIG2.TPO_ID                                                                    AS DD_TPO_ID
                  , (SELECT DD_EPR_ID
                        FROM '||V_ESQUEMA_MASTER||'.DD_EPR_ESTADO_PROCEDIMIENTO
                        WHERE DD_EPR_CODIGO = ''10''
                        AND BORRADO = 0
                  )                                                                                AS DD_EPR_ID
                  , 0                                                                              AS TRA_DECIDIDO
                  , NULL                                                                           AS TRA_PROCESS_BPM
                  , 0                                                                              AS TRA_PARALIZADO
                  , SYSDATE                                                                        AS TRA_FECHA_INICIO
                  , 1                                                                              AS VERSION
                  , '''||V_USUARIO||'''                                                            AS USUARIOCREAR
                  , SYSDATE                                                                        AS FECHACREAR
                  , 0                                                                              AS BORRADO
                  , (SELECT DISTINCT DDTAC.DD_TAC_ID
                          FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR AUX
                          INNER JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO on AUX.tpo_id = tpo.dd_tpo_id
                          INNER JOIN '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION DDTAC ON TPO.DD_TAC_ID = DDTAC.DD_TAC_ID
                          WHERE DDTAC.BORRADO = 0
                  )                                                                                AS DD_TAC_ID
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
      ';
      
        --DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TRA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAR_TAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS NOTIFICACIONES...');

      V_MSQL := '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAR||'
            (
                  TAR_ID
                  , DD_EIN_ID
                  , DD_STA_ID
                  , TAR_CODIGO
                  , TAR_TAREA
                  , TAR_DESCRIPCION
                  , TAR_FECHA_INI
                  , TAR_EN_ESPERA
                  , TAR_ALERTA
                  , TAR_TAREA_FINALIZADA
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
                  , TAR_FECHA_VENC
                  , DTYPE
                  , NFA_TAR_REVISADA
            )
            SELECT DISTINCT
                  MIG2.TAR_ID                                                                               AS TAR_ID
                  , (SELECT EIN.DD_EIN_ID
                          FROM '||V_ESQUEMA_MASTER||'.DD_EIN_ENTIDAD_INFORMACION EIN
                          WHERE EIN.DD_EIN_CODIGO = ''61''
                          AND BORRADO = 0
                  )                                                                                                 AS DD_EIN_ID
                  , STA.DD_STA_ID                                                                         AS DD_STA_ID
                  , 1                                                                                              AS TAR_CODIGO
                  , TAP.TAP_DESCRIPCION                                                               AS TAR_TAREA
                  , TAP.TAP_DESCRIPCION                                                               AS TAR_DESCRIPCION
                  , SYSDATE                                                                                 AS TAR_FECHA_INI
                  , 0                                                                                             AS TAR_EN_ESPERA
                  , 0                                                                                              AS TAR_ALERTA
                  , 0                                                                                             AS TAR_TAREA_FINALIZADA
                  , 0                                                                                             AS VERSION
                  , '''||V_USUARIO||'''                                                                       AS USUARIOCREAR
                  , SYSDATE                                                                                 AS FECHACREAR
                  , 0                                                                                             AS BORRADO
                  , (SELECT SYSDATE + 3 FROM DUAL)                                          AS TAR_FECHA_VENC
                  , ''EXTTareaNotificacion''                                                               AS DTYPE
                  , 0                                                                                             AS NFA_TAR_REVISADA
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
                  INNER JOIN '||V_ESQUEMA_MASTER||'.DD_STA_SUBTIPO_TAREA_BASE STA ON STA.DD_STA_ID = TAP.DD_STA_ID
      '
      ;
        --DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAR||' cargada. '||SQL%ROWCOUNT||' Filas.');

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ETN_EXTAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS EXTERNAS NOTIFICACIONES...');

      V_MSQL := '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ETN||'
            (
                  TAR_ID
                  ,TAR_FECHA_VENC_REAL
            )
            SELECT DISTINCT
                  MIG2.TAR_ID
                  ,(SELECT SYSDATE + 3 FROM DUAL) AS TAR_FECHA_VENC_REAL
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
      '
      ;
      --DBMS_OUTPUT.PUT_LINE(V_MSQL); 
      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ETN||' cargada. '||SQL%ROWCOUNT||' Filas.');

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TEX_TAREA_EXTERNA --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS EXTERNAS...');

      V_MSQL := '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TEX||'
            (
                  TEX_ID
                  , TAR_ID
                  , TAP_ID
                  , TEX_TOKEN_ID_BPM
                  , TEX_DETENIDA
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
                  , TEX_NUM_AUTOP
                  , DTYPE
            )
            SELECT DISTINCT
                  MIG2.TEX_ID                   AS TEX_ID
                  , MIG2.TAR_ID                 AS TAR_ID
                  , MIG2.TAP_ID                 AS TAP_ID
                  , NULL                        AS TEX_TOKEN_ID_BPM
                  , 0                           AS TEX_DETENIDA
                  , 0                           AS VERSION
                  , '''||V_USUARIO||'''         AS USUARIOCREAR
                  , SYSDATE                     AS FECHACREAR
                  , 0                           AS BORRADO
                  , 0                           AS TEX_NUM_AUTOP
                  , ''EXTTareaExterna''         AS DTYPE
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
      '
      ;
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TEX||' cargada. '||SQL%ROWCOUNT||' Filas.');

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAC_TAREAS_ACTIVOS --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO RELACION TAREAS ACTIVOS...');

      V_MSQL := '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAC||'
            (
                  TAR_ID
                  , TRA_ID
                  , ACT_ID
                  , USU_ID
                  , SUP_ID
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
            )
            WITH UNICO_ACTIVO AS (
                  SELECT DISTINCT
                        MIG2.TAR_ID
                        , MIG2.TRA_ID
                        , MIG2.ACT_ID
                        , MIG2.USU_ID
                        , MIG2.SUP_ID
                        , ROW_NUMBER () OVER (PARTITION BY MIG2.TAR_ID ORDER BY MIG2.ACT_ID DESC) AS ORDEN
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
            )
            SELECT
                  UA.TAR_ID             AS TAR_ID
                  , UA.TRA_ID           AS TRA_ID
                  , UA.ACT_ID           AS ACT_ID
                  , UA.USU_ID           AS USU_ID
                  , UA.SUP_ID           AS SUP_ID
                  , 0                       AS VERSION
                  , '''||V_USUARIO||''' AS USUARIOCREAR
                  , SYSDATE           AS FECHACREAR
                  ,0                        AS BORRADO
            FROM UNICO_ACTIVO UA
            WHERE UA.ORDEN = 1
      '
      ;
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAC||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      #ESQUEMA#.ALTA_BPM_INSTANCES(V_USUARIO,PL_OUTPUT2);
            
      ELSE 
      
         ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAR_TAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS NOTIFICACIONES...');

      V_MSQL := '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAR||'
            (
                  TAR_ID
                  , DD_EIN_ID
                  , DD_STA_ID
                  , TAR_CODIGO
                  , TAR_TAREA
                  , TAR_DESCRIPCION
                  , TAR_FECHA_INI
                  , TAR_EN_ESPERA
                  , TAR_ALERTA
                  , TAR_TAREA_FINALIZADA
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
                  , TAR_FECHA_VENC
                  , DTYPE
                  , NFA_TAR_REVISADA
            )
            SELECT DISTINCT
                  MIG2.TAR_ID                                                                               AS TAR_ID
                  , (SELECT EIN.DD_EIN_ID
                          FROM '||V_ESQUEMA_MASTER||'.DD_EIN_ENTIDAD_INFORMACION EIN
                          WHERE EIN.DD_EIN_CODIGO = ''61''
                          AND BORRADO = 0
                  )                                                                                                 AS DD_EIN_ID
                  , STA.DD_STA_ID                                                                         AS DD_STA_ID
                  , 1                                                                                              AS TAR_CODIGO
                  , TAP.TAP_DESCRIPCION                                                               AS TAR_TAREA
                  , TAP.TAP_DESCRIPCION                                                               AS TAR_DESCRIPCION
                  , SYSDATE                                                                                 AS TAR_FECHA_INI
                  , 0                                                                                             AS TAR_EN_ESPERA
                  , 0                                                                                              AS TAR_ALERTA
                  , 0                                                                                             AS TAR_TAREA_FINALIZADA
                  , 0                                                                                             AS VERSION
                  , '''||V_USUARIO||'''                                                                       AS USUARIOCREAR
                  , SYSDATE                                                                                 AS FECHACREAR
                  , 0                                                                                             AS BORRADO
                  , (SELECT SYSDATE + 3 FROM DUAL)                                          AS TAR_FECHA_VENC
                  , ''EXTTareaNotificacion''                                                               AS DTYPE
                  , 0                                                                                             AS NFA_TAR_REVISADA
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
                  INNER JOIN '||V_ESQUEMA_MASTER||'.DD_STA_SUBTIPO_TAREA_BASE STA ON STA.DD_STA_ID = TAP.DD_STA_ID
      '
      ;
        --DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAR||' cargada. '||SQL%ROWCOUNT||' Filas.');

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ETN_EXTAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS EXTERNAS NOTIFICACIONES...');

      V_MSQL := '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ETN||'
            (
                  TAR_ID
                  ,TAR_FECHA_VENC_REAL
            )
            SELECT DISTINCT
                  MIG2.TAR_ID
                  ,(SELECT SYSDATE + 3 FROM DUAL) AS TAR_FECHA_VENC_REAL
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
      '
      ;
      --DBMS_OUTPUT.PUT_LINE(V_MSQL); 
      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ETN||' cargada. '||SQL%ROWCOUNT||' Filas.');

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TEX_TAREA_EXTERNA --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS EXTERNAS...');

      V_MSQL := '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TEX||'
            (
                  TEX_ID
                  , TAR_ID
                  , TAP_ID
                  , TEX_TOKEN_ID_BPM
                  , TEX_DETENIDA
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
                  , TEX_NUM_AUTOP
                  , DTYPE
            )
            SELECT DISTINCT
                  MIG2.TEX_ID                   AS TEX_ID
                  , MIG2.TAR_ID                 AS TAR_ID
                  , MIG2.TAP_ID                 AS TAP_ID
                  , MIG2.TRA_PROCES_BPM         AS TEX_TOKEN_ID_BPM
                  , 0                           AS TEX_DETENIDA
                  , 0                           AS VERSION
                  , '''||V_USUARIO||'''         AS USUARIOCREAR
                  , SYSDATE                     AS FECHACREAR
                  , 0                           AS BORRADO
                  , 0                           AS TEX_NUM_AUTOP
                  , ''EXTTareaExterna''         AS DTYPE
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
      '
      ;
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TEX||' cargada. '||SQL%ROWCOUNT||' Filas.');

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAC_TAREAS_ACTIVOS --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO RELACION TAREAS ACTIVOS...');

      V_MSQL := '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAC||'
            (
                  TAR_ID
                  , TRA_ID
                  , ACT_ID
                  , USU_ID
                  , SUP_ID
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
            )
            WITH UNICO_ACTIVO AS (
                  SELECT DISTINCT
                        MIG2.TAR_ID
                        , MIG2.TRA_ID
                        , MIG2.ACT_ID
                        , MIG2.USU_ID
                        , MIG2.SUP_ID
                        , ROW_NUMBER () OVER (PARTITION BY MIG2.TAR_ID ORDER BY MIG2.ACT_ID DESC) AS ORDEN
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
            )
            SELECT
                  UA.TAR_ID             AS TAR_ID
                  , UA.TRA_ID           AS TRA_ID
                  , UA.ACT_ID           AS ACT_ID
                  , UA.USU_ID           AS USU_ID
                  , UA.SUP_ID           AS SUP_ID
                  , 0                       AS VERSION
                  , '''||V_USUARIO||''' AS USUARIOCREAR
                  , SYSDATE           AS FECHACREAR
                  ,0                        AS BORRADO
            FROM UNICO_ACTIVO UA
            WHERE UA.ORDEN = 1
      '
      ;
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAC||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
    END IF;
     

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

--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190410
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0
--## INCIDENCIA_LINK=REMVIP-3934
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

  V_ESQUEMA VARCHAR2(30 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  USUARIO_MIGRACION VARCHAR2(50 CHAR):= 'MIG_APPLE';
  USUARIOCREAR VARCHAR2(50 CHAR):= 'REMVIP-3934-2';

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la asignacion de GFORM y GIAFORM para mediterraneo, ogf y gestinova.');

      -------------------------------------------------
      --INSERCION EN GESTORES--
      -------------------------------------------------   
      
      -------------------------------------------------
      --INSERCION EN GEE--
      -------------------------------------------------
      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T1
				USING (
						WITH GESTORES_APPLE AS (
							SELECT ACT.ACT_ID,TGE.DD_TGE_ID,TGE.DD_TGE_CODIGO, GEE.GEE_ID, USU.USU_USERNAME AS USUARIO
							FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
							JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
							JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID
							JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
							JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID
							WHERE ACT.USUARIOCREAR = ''MIG_APPLE'' AND TGE.DD_TGE_CODIGO IN (''GFORM'',''GIAFORM'')
						)
						SELECT ACT.ACT_NUM_ACTIVO, TGE.DD_TGE_CODIGO, TGE.DD_TGE_DESCRIPCION, AUX.GEE_ID, TGE.DD_TGE_ID, AUX.USUARIO, ACT.ACT_ID, PRV.DD_PRV_CODIGO, PRV.DD_PRV_DESCRIPCION,
							   (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME IN CASE WHEN TGE.DD_TGE_CODIGO = ''GFORM'' AND PRV.DD_PRV_CODIGO IN (''3'',''4'',''6'',''10'',''11'',''12'',''14'',''18'',''21'',''22'',''23'',''29'',''30'',''31'',''41'',''44'',''46'',''50'') THEN ''pdiez''
																									 WHEN TGE.DD_TGE_CODIGO = ''GFORM'' AND PRV.DD_PRV_CODIGO NOT IN (''3'',''4'',''6'',''10'',''11'',''12'',''14'',''18'',''21'',''22'',''23'',''29'',''30'',''31'',''41'',''44'',''46'',''50'') THEN ''mfuentesm''
																									 WHEN TGE.DD_TGE_CODIGO = ''GIAFORM'' AND PRV.DD_PRV_CODIGO IN (''1'',''3'',''7'',''12'',''15'',''20'',''26'',''27'',''32'',''33'',''35'',''36'',''38'',''39'',''46'',''48'',''51'',''52'') THEN ''ogf03''
																									 WHEN TGE.DD_TGE_CODIGO = ''GIAFORM'' AND PRV.DD_PRV_CODIGO IN (''4'',''6'',''10'',''11'',''14'',''18'',''21'',''22'',''23'',''29'',''30'',''31'',''41'',''44'',''50'') THEN ''mediterraneo03''
																									 WHEN TGE.DD_TGE_CODIGO = ''GIAFORM'' AND PRV.DD_PRV_CODIGO NOT IN (''1'',''3'',''7'',''12'',''15'',''20'',''26'',''27'',''32'',''33'',''35'',''36'',''38'',''39'',''46'',''48'',''51'',''52'',''4'',''6'',''10'',''11'',''14'',''18'',''21'',''22'',''23'',''29'',''30'',''31'',''41'',''44'',''50'') THEN ''gestinov03''
																																												  
								END) AS USU_ID,
								(SELECT USU_USERNAME FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME IN CASE WHEN TGE.DD_TGE_CODIGO = ''GFORM'' AND PRV.DD_PRV_CODIGO IN (''3'',''4'',''6'',''10'',''11'',''12'',''14'',''18'',''21'',''22'',''23'',''29'',''30'',''31'',''41'',''44'',''46'',''50'') THEN ''pdiez''
																									 WHEN TGE.DD_TGE_CODIGO = ''GFORM'' AND PRV.DD_PRV_CODIGO NOT IN (''3'',''4'',''6'',''10'',''11'',''12'',''14'',''18'',''21'',''22'',''23'',''29'',''30'',''31'',''41'',''44'',''46'',''50'') THEN ''mfuentesm''
																									 WHEN TGE.DD_TGE_CODIGO = ''GIAFORM'' AND PRV.DD_PRV_CODIGO IN (''1'',''3'',''7'',''12'',''15'',''20'',''26'',''27'',''32'',''33'',''35'',''36'',''38'',''39'',''46'',''48'',''51'',''52'') THEN ''ogf03''
																									 WHEN TGE.DD_TGE_CODIGO = ''GIAFORM'' AND PRV.DD_PRV_CODIGO IN (''4'',''6'',''10'',''11'',''14'',''18'',''21'',''22'',''23'',''29'',''30'',''31'',''41'',''44'',''50'') THEN ''mediterraneo03''
																									 WHEN TGE.DD_TGE_CODIGO = ''GIAFORM'' AND PRV.DD_PRV_CODIGO NOT IN (''1'',''3'',''7'',''12'',''15'',''20'',''26'',''27'',''32'',''33'',''35'',''36'',''38'',''39'',''46'',''48'',''51'',''52'',''4'',''6'',''10'',''11'',''14'',''18'',''21'',''22'',''23'',''29'',''30'',''31'',''41'',''44'',''50'') THEN ''gestinov03''
																																												  
								END) AS USU_USERNAME
						FROM '||V_ESQUEMA||'.ACT_ACTIVO                   ACT
						JOIN '||V_ESQUEMA||'.BIE_BIEN                     BIE ON BIE.BIE_ID = ACT.BIE_ID
						JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION             LOC ON LOC.BIE_ID = BIE.BIE_ID
						JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA         PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID
						JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR       TGE ON TGE.DD_TGE_CODIGO IN (''GFORM'',''GIAFORM'')
						LEFT JOIN GESTORES_APPLE                AUX ON AUX.ACT_ID = ACT.ACT_ID AND AUX.DD_TGE_ID = TGE.DD_TGE_ID   
						WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
				) T2
				ON (T1.GEE_ID = T2.GEE_ID)
				WHEN MATCHED THEN 
				UPDATE SET
						  T1.USU_ID = T2.USU_ID,
						  T1.USUARIOMODIFICAR = '''||USUARIOCREAR||''',
						  T1.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN INSERT (T1.GEE_ID, T1.USU_ID, T1.DD_TGE_ID, T1.USUARIOCREAR, T1.FECHACREAR, T1.BORRADO, T1.USUARIOMODIFICAR)
				  VALUES (
						  '||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL,
						  T2.USU_ID,
						  T2.DD_TGE_ID,
						  '''||USUARIOCREAR||''',
						  SYSDATE,
						  0,
						  T2.ACT_ID
				  )
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] '||V_NUM_TABLAS||' registros insertados/modificados en GEE.');  
      
      -------------------------------------------------
      --INSERCION EN GAC--
      -------------------------------------------------
      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO (GEE_ID, ACT_ID)
                SELECT GEE.GEE_ID, 
                       TO_NUMBER(GEE.USUARIOMODIFICAR) 
				FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE 
				WHERE USUARIOCREAR = '''||USUARIOCREAR||'''
				  AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC WHERE GAC.GEE_ID = GEE.GEE_ID)
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] '||V_NUM_TABLAS||' registros insertados en GAC.');				
    
      -------------------------------------------------
      --INSERCION EN GEH--
      -------------------------------------------------
      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST T1
				USING (
					SELECT ACT.ACT_NUM_ACTIVO,
						   GEH.GEH_ID
					FROM '||V_ESQUEMA||'.ACT_ACTIVO                  ACT
					JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
					JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST     GEH ON GEH.GEH_ID = GAH.GEH_ID
					WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
					  AND GEH.DD_TGE_ID IN (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO IN (''GFORM'',''GIAFORM''))
					  AND GEH.GEH_FECHA_HASTA IS NULL
				) T2 
				ON (T1.GEH_ID = T2.GEH_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.GEH_FECHA_HASTA = SYSDATE,
					T1.USUARIOMODIFICAR = '''||USUARIOCREAR||''',
					T1.FECHAMODIFICAR = SYSDATE
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] '||V_NUM_TABLAS||' registros modificados en GEH.');
    

      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST (GEH_ID, USU_ID, DD_TGE_ID, GEH_FECHA_DESDE, GEH_FECHA_HASTA, USUARIOCREAR, FECHACREAR, BORRADO, USUARIOMODIFICAR)
				WITH GESTORES_APPLE AS 
				(
					SELECT ACT.ACT_ID,TGE.DD_TGE_ID,TGE.DD_TGE_CODIGO, GEE.GEE_ID, USU.USU_USERNAME AS USUARIO, USU.USU_ID
					FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
					JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID
					JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
					JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID
					WHERE ACT.USUARIOCREAR = ''MIG_APPLE'' AND TGE.DD_TGE_CODIGO IN (''GFORM'',''GIAFORM'')
				)
				SELECT '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL                                                AS GEH_ID,
					   AUX.USU_ID                      																	AS USU_ID,
					   TGE.DD_TGE_ID                                                                                    AS DD_TGE_ID,
					   SYSDATE AS GEH_FECHA_DESDE,
					   NULL AS GEH_FECHA_HASTA,
					   '''||USUARIOCREAR||''',
					   SYSDATE,
					   0,
					   ACT.ACT_ID
				FROM '||V_ESQUEMA||'.ACT_ACTIVO                   ACT
				JOIN '||V_ESQUEMA||'.BIE_BIEN                     BIE ON BIE.BIE_ID = ACT.BIE_ID
				JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION             LOC ON LOC.BIE_ID = BIE.BIE_ID
				JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA         PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID
				JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR       TGE ON TGE.DD_TGE_CODIGO IN (''GFORM'',''GIAFORM'')
				LEFT JOIN GESTORES_APPLE                AUX ON AUX.ACT_ID = ACT.ACT_ID AND AUX.DD_TGE_ID = TGE.DD_TGE_ID   
				WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
	  ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] '||V_NUM_TABLAS||' registros insertados en GEH.');
    
      -------------------------------------------------
      --INSERCION EN GAH--
      -------------------------------------------------
      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO(GEH_ID, ACT_ID)
				SELECT GEH.GEH_ID,
					   TO_NUMBER(GEH.USUARIOMODIFICAR)
				FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST     GEH 
				WHERE USUARIOCREAR = '''||USUARIOCREAR||'''
	  ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] '||V_NUM_TABLAS||' registros insertados en GAH.');
    
    
      -------------------------------------------------
      --RESTAURAMOS EN GEH--
      -------------------------------------------------
      V_SQL := 'UPDATE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST 
				SET USUARIOMODIFICAR = NULL
				WHERE USUARIOCREAR = '''||USUARIOCREAR||'''
	  ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] '||V_NUM_TABLAS||' registros restaurados en GEH.');
      
      -------------------------------------------------
      --RESTAURAMOS EN GEE--
      -------------------------------------------------
      V_SQL := 'UPDATE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD 
				SET USUARIOMODIFICAR = NULL
				WHERE USUARIOCREAR = '''||USUARIOCREAR||'''
	  ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] '||V_NUM_TABLAS||' registros restaurados en GEE.');
    
 
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

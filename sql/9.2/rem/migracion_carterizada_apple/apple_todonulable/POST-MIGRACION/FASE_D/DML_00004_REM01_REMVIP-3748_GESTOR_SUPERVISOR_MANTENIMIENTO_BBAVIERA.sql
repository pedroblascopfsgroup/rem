--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190325
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0
--## INCIDENCIA_LINK=HREOS-5915
--## PRODUCTO=NO
--## 
--## Finalidad: gestor mantenimiento y supervisor bbaviera.
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

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la asignacion de GACT y SUPACT a Bbaviera.');

      -------------------------------------------------
      --INSERCION EN GESTORES--
      -------------------------------------------------   
      
      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T1
				USING (
					SELECT ACT.ACT_NUM_ACTIVO,
						   GEE.GEE_ID, 
						   (SELECT DD_TGE_DESCRIPCION FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_ID = GEE.DD_TGE_ID) AS TIPO_GESTOR,
						   (SELECT USU_USERNAME FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_ID = GEE.USU_ID) AS GESTOR
					FROM '||V_ESQUEMA||'.ACT_ACTIVO            ACT
					JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
					JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD    GEE ON GEE.GEE_ID = GAC.GEE_ID
					WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
					  AND GEE.DD_TGE_ID IN (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO IN (''GACT'', ''SUPACT''))
				) T2
				ON (T1.GEE_ID = T2.GEE_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''bbaviera''),
					T1.USUARIOMODIFICAR = ''MIG_APPLE_POST'',
					T1.FECHAMODIFICAR = SYSDATE
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] '||V_NUM_TABLAS||' registros insertados en GEE.');  
    
    
      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST T1
				USING (
					SELECT ACT.ACT_NUM_ACTIVO,
						   GEH.GEH_ID, 
						   (SELECT DD_TGE_DESCRIPCION FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_ID = GEH.DD_TGE_ID) AS TIPO_GESTOR,
						   (SELECT USU_USERNAME FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_ID = GEH.USU_ID) AS GESTOR,
						   GEH.GEH_FECHA_DESDE,
						   GEH.GEH_FECHA_HASTA
					FROM '||V_ESQUEMA||'.ACT_ACTIVO                  ACT
					JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
					JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST     GEH ON GEH.GEH_ID = GAH.GEH_ID
					WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
					  AND GEH.DD_TGE_ID IN (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO IN (''GACT'', ''SUPACT''))
					  AND GEH.USU_ID NOT IN (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''bbaviera'')
					  AND GEH.GEH_FECHA_HASTA IS NULL
				) T2 
				ON (T1.GEH_ID = T2.GEH_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.GEH_FECHA_HASTA = SYSDATE,
					T1.USUARIOMODIFICAR = ''MIG_APPLE_POST'',
					T1.FECHAMODIFICAR = SYSDATE
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] '||V_NUM_TABLAS||' registros modificados en GEH.');
    
    
      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST (GEH_ID, USU_ID, DD_TGE_ID, GEH_FECHA_DESDE, GEH_FECHA_HASTA, USUARIOCREAR, FECHACREAR, BORRADO, USUARIOMODIFICAR)
				SELECT '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL                                                          AS GEH_ID,
					   (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''bbaviera'')                      AS USU_ID,
					   GEH.DD_TGE_ID                                                                                    AS DD_TGE_ID,
					   SYSDATE AS GEH_FECHA_DESDE,
					   NULL AS GEH_FECHA_HASTA,
					   ''MIG_APPLE_POST'',
					   SYSDATE,
					   0,
					   ACT.ACT_ID
				FROM '||V_ESQUEMA||'.ACT_ACTIVO                  ACT
				JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
				JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST     GEH ON GEH.GEH_ID = GAH.GEH_ID
				WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
				  AND GEH.DD_TGE_ID IN (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO IN (''GACT'', ''SUPACT''))
				  AND GEH.USU_ID NOT IN (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''bbaviera'')
				  AND GEH.USUARIOMODIFICAR = ''MIG_APPLE_POST''
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] '||V_NUM_TABLAS||' registros insertados en GEH.');
    
    
      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO(GEH_ID, ACT_ID)
				SELECT GEH.GEH_ID,
					   TO_NUMBER(GEH.USUARIOMODIFICAR)
				FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST     GEH 
				WHERE USUARIOCREAR = ''MIG_APPLE_POST''
	  ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] '||V_NUM_TABLAS||' registros insertados en GAH.');
    
    
    
      V_SQL := 'UPDATE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST 
				SET USUARIOMODIFICAR = NULL
				WHERE USUARIOCREAR = ''MIG_APPLE_POST''
	  ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] '||V_NUM_TABLAS||' registros restaurados en GEH.');
    
 
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

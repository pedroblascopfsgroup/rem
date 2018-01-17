--/*
--###########################################
--## AUTOR=JUANJO ARBONA
--## FECHA_CREACION=20180117
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3607
--## PRODUCTO=NO
--## 
--## Finalidad: Re-asignar activos de mcanton a ndelaossa
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] COMIENZA EL PROCESO PARA LA RE-ASIGNACIÓN DE ACTIVOS DE mcanton A ndelaossa');
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_GEST_ACT'' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	IF V_NUM > 0 THEN
  
    		V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GEST_ACT';
		EXECUTE IMMEDIATE V_MSQL;
	
		V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.TMP_GEST_ACT';
		EXECUTE IMMEDIATE V_MSQL;
		
	END IF;

V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''ndelaossa''';
	EXECUTE IMMEDIATE V_MSQL INTO V_USU_NUEVO;
	
IF V_USU_NUEVO > 0 THEN

	V_MSQL := 'CREATE GLOBAL TEMPORARY TABLE '||V_ESQUEMA||'.TMP_GEST_ACT ON COMMIT PRESERVE ROWS AS (
	
	SELECT
	GEE_ID,
	DD_TGE_ID,
	'||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL AS GEH_ID,
	ACT_ID
	FROM (
	
		SELECT DISTINCT
		GEE.GEE_ID,
		GEE.DD_TGE_ID,
		GAC.ACT_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
		INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
		INNER JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE ON BIE.BIE_ID = ACT.BIE_ID AND BIE.BORRADO = 0
		INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GAC.GEE_ID = GEE.GEE_ID AND GEE.BORRADO = 0
		INNER JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID AND USU.BORRADO = 0
		INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.BORRADO = 0
		INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.BORRADO = 0
		WHERE ACT.BORRADO = 0
		AND SCM.DD_SCM_CODIGO NOT IN (''05'', ''06'')
		AND TGE.DD_TGE_CODIGO = ''GACT''
		AND CRA.DD_CRA_CODIGO = ''01''
		AND BIE.BIE_LOC_PROVINCIA IN (''1'', ''2'', ''5'', ''6'', ''7'', ''9'', ''10'', ''13'', ''15'', ''16'',	''19'',	''20'', ''22'', ''24'',''26'', ''27'', ''28'', ''30'', ''31'', ''32'', 							''33'', ''34'', ''36'', ''37'', ''39'', ''40'', ''42'',	''44'', ''45'',	''47'', ''48'', ''49'', ''50'')
		AND USU.USU_USERNAME = ''mcanton''))';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] SE VA A ACTUALIZAR EL GESTOR A '||V_NUM||' ACTIVOS.');
 
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO USU_ID EN GEE_GESTOR_ENTIDAD...');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
			  SET GEE.USU_ID = (SELECT USU.USU_ID
					     FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU
					     WHERE USU.USU_USERNAME = ''ndelaossa''),
				GEE.USUARIOMODIFICAR = ''HREOS-3607'',
				GEE.FECHAMODIFICAR = SYSDATE
			  WHERE GEE.GEE_ID IN (SELECT TMP.GEE_ID
			  			FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMP)';
			
			EXECUTE IMMEDIATE V_MSQL;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] GEE_GESTOR_ENTIDAD ACTUALIZADA...'||V_NUM||' REGISTROS.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO GEH_FECHA_HASTA EN GEH_GESTOR_ENTIDAD_HIST PARA DAR DE BAJA EL ANTERIOR GESTOR...');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
			  SET GEH.GEH_FECHA_HASTA = SYSDATE,
				GEH.USUARIOMODIFICAR = ''HREOS-3607'',
				GEH.FECHAMODIFICAR = SYSDATE
			  WHERE GEH.GEH_ID IN (SELECT GEH.GEH_ID
				         FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					 INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
					 INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
				   	 INNER JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE ON BIE.BIE_ID = ACT.BIE_ID AND BIE.BORRADO = 0
					 INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GAH.GEH_ID = GEH.GEH_ID AND GEH.BORRADO = 0
					 INNER JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON GEH.USU_ID = USU.USU_ID AND USU.BORRADO = 0
					 INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.BORRADO = 0
					 INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE ON GEH.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.BORRADO = 0
					 WHERE ACT.BORRADO = 0
					 AND SCM.DD_SCM_CODIGO NOT IN (''05'', ''06'')
					 AND GEH.GEH_FECHA_HASTA IS NULL
					 AND TGE.DD_TGE_CODIGO = ''GACT''
					 AND CRA.DD_CRA_CODIGO = ''01''
					 AND BIE.BIE_LOC_PROVINCIA IN (''1'', ''2'', ''5'', ''6'', ''7'', ''9'', ''10'', ''13'', ''15'', ''16'', ''19'', ''20'', ''22'', ''24'',''26'', ''27'', ''28'', ''30'', 									''31'', ''32'',	''33'', ''34'', ''36'', ''37'', ''39'', ''40'', ''42'',	''44'', ''45'',	''47'', ''48'', ''49'', ''50'')
					 AND USU.USU_USERNAME = ''mcanton'')';
			
			EXECUTE IMMEDIATE V_MSQL;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] GEH_GESTOR_ENTIDAD_HIST ACTUALIZADA...'||V_NUM||' REGISTROS.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO NUEVOS REGISTROS EN GEH_GESTOR_ENTIDAD_HIST PARA DAR DE ALTA EL NUEVO GESTOR...');
	
	EXECUTE IMMEDIATE '
	INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
	(GEH_ID,
	USU_ID,
	DD_TGE_ID,
	GEH_FECHA_DESDE,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	SELECT
	GEH_ID,
	(SELECT USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS WHERE USU_USERNAME = ''ndelaossa'' ) AS USU_ID, 
	DD_TGE_ID,
	SYSDATE AS GEH_FECHA_DESDE,
	''HREOS-3607'' AS USUARIOCREAR,
	SYSDATE AS FECHACREAR,
	0 AS BORRADO
	FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMP
	'
	;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '||V_NUM||' REGISTROS EN GEH_GESTOR_ENTIDAD_HIST.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO NUEVOS REGISTROS EN GAH_GESTOR_ACTIVO_HISTORICO PARA RELACIONAR LOS REGISTROS DE');
	DBMS_OUTPUT.PUT_LINE('       GEH_GESTOR_ENTIDAD_HIST CON LOS ACTIVOS...');
	
	EXECUTE IMMEDIATE '
	INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
	(GEH_ID,
	ACT_ID
	)
	SELECT 
	GEH_ID,
	ACT_ID
	FROM '||V_ESQUEMA||'.TMP_GEST_ACT
	'
	;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '||V_NUM||' REGISTROS EN GAH_GESTOR_ACTIVO_HISTORICO.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] GESTORES ACTUALIZADOS CORRECTAMENTE.'||CHR(10));
 	
	DBMS_OUTPUT.PUT_LINE('[INFO] SE VAN A RE-ASIGNAR LOS GESTORES PARA LAS TAREAS AFECTADAS...');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO USU_ID EN TAC_TAREAS_ACTIVO...');
	
	EXECUTE IMMEDIATE '
	MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC USING
	(
	SELECT
	TAC.TAR_ID,
	TAC.ACT_ID,
	TAC.USU_ID,
	GEE.GEE_ID,
	GEE.DD_TGE_ID as GEE_DD_TGE_ID,
	TAP.DD_TGE_ID as TAP_DD_TGE_ID,
	GEE.USU_ID as USU_ID_NEW
	FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC 
	INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
	  ON TAR.TAR_ID = TAC.TAR_ID
	INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX
	  ON TEX.TAR_ID = TAR.TAR_ID
	INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
	  ON TAP.TAP_ID = TEX.TAP_ID
	INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC 
	  ON GAC.ACT_ID = TAC.ACT_ID
	INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE 
	  ON GEE.GEE_ID = GAC.GEE_ID
	WHERE GEE.DD_TGE_ID = (select dd_tge_id from remmaster.dd_tge_tipo_gestor where dd_tge_codigo = ''GACT'')
	AND TAP.DD_TGE_ID = (select dd_tge_id from remmaster.dd_tge_tipo_gestor where dd_tge_codigo = ''GACT'') 
	AND TAC.USU_ID != GEE.USU_ID
	AND TAR.TAR_FECHA_FIN IS NULL
	--AND TAC.BORRADO = 0
	--AND TAR.BORRADO = 0
	--AND TEX.BORRADO = 0
	--AND TAP.BORRADO = 0
	AND GEE.BORRADO = 0
	AND GEE.USUARIOMODIFICAR = ''HREOS-3607''
	) TMP
	ON (TAC.TAR_ID = TMP.TAR_ID)
	WHEN MATCHED THEN UPDATE SET
	TAC.USU_ID = TMP.USU_ID_NEW,
	TAC.USUARIOMODIFICAR = ''HREOS-3607'',
	TAC.FECHAMODIFICAR = SYSDATE
	'
	;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||V_NUM||' REGISTROS EN TAC_TAREAS_ACTIVOS.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] TAREAS ACTUALIZADAS.'||CHR(10));

END IF;
	 
 	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_GEST_ACT'' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	IF V_NUM > 0 THEN
  
    		V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GEST_ACT';
		EXECUTE IMMEDIATE V_MSQL;
	
		V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.TMP_GEST_ACT';
		EXECUTE IMMEDIATE V_MSQL;
		
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]  PROCESO FINALIZADO CORRECTAMENTE ');

 
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

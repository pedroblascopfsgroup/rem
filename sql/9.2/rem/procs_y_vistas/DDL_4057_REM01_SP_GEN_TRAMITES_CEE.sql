--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20180314
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=HREOS-3916
--## PRODUCTO=SI
--## 
--## Finalidad: GEN_TRAMITES_CEE -> Generar los tramites CEE para aquellos activos que esten apunto de caducar.
--## VERSIONES:
--##        0.1 Version inicial 20180312
--##########################################
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

create or replace PROCEDURE GEN_TRAMITES_CEE AS

--***********************************************************************************
--                                                 
--***********************************************************************************

  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
  V_TABLA VARCHAR2(30 CHAR) := ''; 
  
  /* Variables */
  V_NUM_REGS NUMBER;
  V_NUM_TABLAS NUMBER;
  err_num NUMBER;
  err_msg VARCHAR2(255);
  V_DBID NUMBER(16);

BEGIN
  
  /*** 
    000 Truncar TMP_ACT_TO_GEN_TRB_CEE
    001 Rellenamos TMP_ACT_TO_GEN_TRB_CEE con los activos que vamos a generar el trabajo ACT.
    if (count> 0) {
        002 Insert Act_tbj_trabajo
        003 Insert Act_tbj
        004 Insert ACT_TRA_TRAMITE
        005 Insert TAR_TAREAS_NOTIFICACIONES
        006 Insert TEX_TAREA_EXTERNA
        007 Insert TAC_TAREAS_ACTIVOS
    }
    ¿?¿?¿? -> ACT_CFD_CONFIG_DOCUMENTO
  ***/

    /*** 000 Truncar TMP_ACT_TO_GEN_TRB_CEE ***/
    V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.TMP_ACT_TO_GEN_TRB_CEE';
    EXECUTE IMMEDIATE V_MSQL;
    V_NUM_REGS := SQL%ROWCOUNT;
    #ESQUEMA#.SP_LSP_LOGS( 'gen_tramites_cee', 'GEN_TRAMITES_CEE', 'Truncate '||V_TABLA, V_NUM_REGS, NULL);    
    
    COMMIT;
    
    /*** 001 Rellenamos TMP_ACT_TO_GEN_TRB_CEE ***/
    V_TABLA := 'TMP_ACT_TO_GEN_TRB_CEE';
    V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        ACT_ID,
        TBJ_ID,
        TRA_ID,
        TAR_ID,
        TEX_ID,
        ADO_FECHA_CALIFICACION,
        ADO_FECHA_CADUCIDAD,
        ACT_DESCRIPCION,
        USU_ID_GESTOR,
        USU_ID_SUPERVISOR        
    )
    SELECT 
        ACT.ACT_ID,
        '||V_ESQUEMA||'.S_ACT_TBJ_TRABAJO.nextval AS TBJ_ID,
        '||V_ESQUEMA||'.S_ACT_TRA_TRAMITE.nextval AS TRA_ID,
        '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.nextval AS TAR_ID,
        '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.nextval AS TEX_ID,
        ADO.ADO_FECHA_CALIFICACION,
        ADO.ADO_FECHA_CADUCIDAD,
        ACT.ACT_DESCRIPCION AS ACT_DESCRIPCION,
        GEE_GES.USU_ID AS USU_ID_GESTOR,
        GEE_SUP.USU_ID AS USU_ID_SUPERVISOR
    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
        JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND (DD_TPA_CODIGO = ''02'' OR DD_TPA_CODIGO = ''04'') /* 02 Vivienda or 04 industrial */
        JOIN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ADO ON ADO.ACT_ID = ACT.ACT_ID 
        JOIN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON CFD.CFD_ID = ADO.CFD_ID AND CFD.CFD_APLICA_F_CADUCIDAD = 1
        JOIN '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID AND TPD.DD_TPD_CODIGO = ''11'' /* 11 CEE (Certificado de eficiencia energética) */
        JOIN '||V_ESQUEMA||'.DD_EDC_ESTADO_DOCUMENTO EDC ON EDC.DD_EDC_ID = ADO.DD_EDC_ID AND EDC.DD_EDC_CODIGO = ''01'' /* 01 | Obtenido */
        JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO NOT IN (''05'',''06'') /* NO - 05 Vendido 06 Traspasado*/
        JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.PAC_CHECK_GESTIONAR = 1 /* En el perimetro de gestionar */
        JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC_GES ON GAC_GES.ACT_ID = ACT.ACT_ID
        JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE_GES ON GEE_GES.GEE_ID = GAC_GES.GEE_ID
        JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE_GES ON TGE_GES.DD_TGE_ID = GEE_GES.DD_TGE_ID AND TGE_GES.DD_TGE_CODIGO = ''GACT''
        JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC_SUP ON GAC_SUP.ACT_ID = ACT.ACT_ID
        JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE_SUP ON GEE_SUP.GEE_ID = GAC_SUP.GEE_ID
        JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE_SUP ON TGE_SUP.DD_TGE_ID = GEE_SUP.DD_TGE_ID AND TGE_SUP.DD_TGE_CODIGO = ''SUPACT''        
    WHERE NOT EXISTS (SELECT 1
                        FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
                        JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST ON EST.DD_EST_ID = TBJ.DD_EST_ID
                        WHERE TBJ.ACT_ID = ACT.ACT_ID
                        AND EST.DD_EST_CODIGO in (''01'',''04'',''13'') /* 01 Solicitado, 04 En trámite, 13 Validado */
                    ) /* No hay trabajo activo */
    AND (ADO.ADO_FECHA_CADUCIDAD is not null and ADO.ADO_FECHA_CADUCIDAD < trunc(sysdate+30))
    ';
    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_REGS := SQL%ROWCOUNT;
    #ESQUEMA#.SP_LSP_LOGS( 'gen_tramites_cee', 'GEN_TRAMITES_CEE', 'Insert '||V_TABLA, V_NUM_REGS, NULL);  
    
    
    COMMIT;


    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||'';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS > 0 THEN
    
    #ESQUEMA#.SP_LSP_LOGS( 'gen_tramites_cee', 'GEN_TRAMITES_CEE', 'Start gen tramites', 0, NULL);
    
    /*** 002 Insert ACT_TBJ_TRABAJO ***/
    V_TABLA := 'ACT_TBJ_TRABAJO';
    V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        tbj_id,
        act_id,
        agr_id,
        tbj_num_trabajo,
        pvc_id,
        usu_id,
        dd_ttr_id,
        dd_str_id,
        dd_est_id,
        tbj_descripcion,
        tbj_fecha_solicitud,
        tbj_fecha_tope,
        tbj_urgente,
        version,
        usuariocrear,
        fechacrear, 
        BORRADO,
        TBJ_GESTOR_ACTIVO_RESPONSABLE,
        TBJ_SUPERVISOR_ACT_RESPONSABLE
    ) 
    SELECT 
        TMP_ACT_TO_GEN_TRB_CEE.TBJ_ID, 
        TMP_ACT_TO_GEN_TRB_CEE.ACT_ID, 
        null as AGR_ID, 
        S_TBJ_NUM_TRABAJO.nextval,
        null AS pvc_id,
        (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE UPPER(USU_USERNAME) like ''SUPER'') AS usu_id, /* usuario = SUPER */
        (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR WHERE TTR.DD_TTR_CODIGO = ''02'') AS DD_TTR_ID, /* 02 | Obtención documentación */
        (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR WHERE STR.DD_STR_CODIGO = ''18'') AS DD_TTR_ID, /* Certificado Eficiencia Energética (CEE)*/
        (SELECT DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST WHERE EST.DD_EST_CODIGO = ''01'') AS DD_EST_ID,  /* 01	| Solicitado */
        CONCAT(''Certificado Eficiencia Energética (CEE). Lanzado automáticamente por próxima caducidad. '', TMP_ACT_TO_GEN_TRB_CEE.ACT_DESCRIPCION) AS TBJ_DESCRIPCION,
        sysdate AS TBJ_FECHA_SOLICITUD, 
        TMP_ACT_TO_GEN_TRB_CEE.ADO_FECHA_CADUCIDAD AS TBJ_FECHA_TOPE, 
        1 AS TBJ_URGENTE,
        1 AS VERSION,
        ''ALT_TRA_CEE'' AS USUARIOCREAR,
        sysdate AS FECHACREAR,
        0 AS BORRADO,
        TMP_ACT_TO_GEN_TRB_CEE.USU_ID_GESTOR AS TBJ_GESTOR_ACTIVO_RESPONSABLE,
        TMP_ACT_TO_GEN_TRB_CEE.USU_ID_SUPERVISOR AS TBJ_SUPERVISOR_ACT_RESPONSABLE
    FROM '||V_ESQUEMA||'.TMP_ACT_TO_GEN_TRB_CEE 
    ';
    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_REGS := SQL%ROWCOUNT;
    #ESQUEMA#.SP_LSP_LOGS( 'gen_tramites_cee', 'GEN_TRAMITES_CEE', 'Insert '||V_TABLA, V_NUM_REGS, NULL);  
    

    /*** 003 Insert ACT_TBJ ***/
    V_TABLA := 'ACT_TBJ';
    V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        ACT_ID,
        TBJ_ID,
        ACT_TBJ_PARTICIPACION
    ) 
    SELECT 
        TMP_ACT_TO_GEN_TRB_CEE.ACT_ID AS ACT_ID,
        TMP_ACT_TO_GEN_TRB_CEE.TBJ_ID AS TBJ_ID,
        100 AS ACT_TBJ_PARTICIPACION
    FROM '||V_ESQUEMA||'.TMP_ACT_TO_GEN_TRB_CEE
    ';
    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_REGS := SQL%ROWCOUNT;
    #ESQUEMA#.SP_LSP_LOGS( 'gen_tramites_cee', 'GEN_TRAMITES_CEE', 'Insert '||V_TABLA, V_NUM_REGS, NULL);  

    
    /*** 004 Insert ACT_TRA_TRAMITE ***/
    V_TABLA := 'ACT_TRA_TRAMITE';
    V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        TRA_ID,
        ACT_ID,
        TBJ_ID,
        DD_TPO_ID,
        DD_EPR_ID,
        TRA_TRA_ID,
        TRA_FECHA_INICIO,
        VERSION,
        USUARIOCREAR,
        FECHACREAR,
        BORRADO,
        DD_TAC_ID
    ) 
    SELECT 
        TMP_ACT_TO_GEN_TRB_CEE.TRA_ID AS TRA_ID,
        TMP_ACT_TO_GEN_TRB_CEE.ACT_ID AS ACT_ID,
        TMP_ACT_TO_GEN_TRB_CEE.TBJ_ID AS TBJ_ID,
        TPO_CEE.DD_TPO_ID AS DD_TPO_ID,
        EPR_ACEP.DD_EPR_ID,
        null AS TRA_TRA_ID,
        sysdate AS TRA_FECHA_INICIO,
        1 AS VERSION,
        ''ALT_TRA_CEE'' AS USUARIOCREAR,
        sysdate AS FECHACREAR,
        0 AS BORRADO,
        TPO_CEE.DD_TAC_ID AS DD_TAC_ID
    FROM '||V_ESQUEMA||'.TMP_ACT_TO_GEN_TRB_CEE
        , (SELECT DD_TPO_ID, DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''T003'') TPO_CEE
        , (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''03'') EPR_ACEP
    ';
    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_REGS := SQL%ROWCOUNT;
    #ESQUEMA#.SP_LSP_LOGS( 'gen_tramites_cee', 'GEN_TRAMITES_CEE', 'Insert '||V_TABLA, V_NUM_REGS, NULL);  
    
    
    /*** 005 Insert TAR_TAREAS_NOTIFICACIONES ***/
    V_TABLA := 'TAR_TAREAS_NOTIFICACIONES';
    V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        TAR_ID,
        DD_EIN_ID,
        DD_STA_ID,
        TAR_CODIGO,
        TAR_TAREA,
        TAR_DESCRIPCION,
        TAR_FECHA_INI,
        VERSION,
        USUARIOCREAR,
        FECHACREAR,
        BORRADO,
        TAR_FECHA_VENC
    )
    SELECT 
        TMP_ACT_TO_GEN_TRB_CEE.TAR_ID AS TAR_ID, 
        EIN_ACT.DD_EIN_ID AS DD_EIN_ID,
        TAP_FIRST_CEE.DD_STA_ID AS DD_STA_ID,
        1 AS TAR_CODIGO, 
        TAP_FIRST_CEE.TAP_DESCRIPCION AS TAR_TAREA,
        TAP_FIRST_CEE.TAP_DESCRIPCION AS TAR_DESCRIPCION,
        sysdate AS TAR_FECHA_INI,
        1 AS VERSION,
        ''ALT_TRA_CEE'' AS USUARIOCREAR,
        sysdate AS FECHACREAR,
        0 AS BORRADO,
        sysdate + 15 AS TAR_FECHA_VENC        
    FROM '||V_ESQUEMA||'.TMP_ACT_TO_GEN_TRB_CEE
        , (SELECT TAP_TAREA_PROCEDIMIENTO.TAP_ID, TAP_TAREA_PROCEDIMIENTO.DD_STA_ID, TAP_TAREA_PROCEDIMIENTO.TAP_DESCRIPCION
            FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T003_AnalisisPeticion'') TAP_FIRST_CEE
        , (SELECT DD_EIN_ID FROM '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION WHERE DD_EIN_CODIGO = 61) EIN_ACT
    ';
    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_REGS := SQL%ROWCOUNT;
    #ESQUEMA#.SP_LSP_LOGS( 'gen_tramites_cee', 'GEN_TRAMITES_CEE', 'Insert '||V_TABLA, V_NUM_REGS, NULL);  
    
    
    /*** 006 Insert TEX_TAREA_EXTERNA ***/
    V_TABLA := 'TEX_TAREA_EXTERNA';
    V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        TEX_ID,
        TAR_ID,
        TAP_ID,
        TEX_DETENIDA,
        VERSION,
        USUARIOCREAR,
        FECHACREAR,
        BORRADO,
        TEX_CANCELADA,
        TEX_NUM_AUTOP
    ) 
    SELECT 
        TMP_ACT_TO_GEN_TRB_CEE.TEX_ID AS TEX_ID, 
        TMP_ACT_TO_GEN_TRB_CEE.TAR_ID AS TAR_ID,
        TAP_FIRST_CEE.TAP_ID AS TAP_ID,
        0 AS TEX_DETENIDA,
        1 AS VERSION,
        ''ALT_TRA_CEE'' AS USUARIOCREAR,
        sysdate AS FECHACREAR,
        0 AS BORRADO,
        0 AS TEX_CANCELADA,
        0 AS TEX_NUM_AUTOP
    FROM '||V_ESQUEMA||'.TMP_ACT_TO_GEN_TRB_CEE
        , (SELECT TAP_TAREA_PROCEDIMIENTO.TAP_ID, TAP_TAREA_PROCEDIMIENTO.DD_STA_ID, TAP_TAREA_PROCEDIMIENTO.TAP_DESCRIPCION
            FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T003_AnalisisPeticion'') TAP_FIRST_CEE
    ';
    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_REGS := SQL%ROWCOUNT;
    #ESQUEMA#.SP_LSP_LOGS( 'gen_tramites_cee', 'GEN_TRAMITES_CEE', 'Insert '||V_TABLA, V_NUM_REGS, NULL);        

    
    /*** 007 Insert TAC_TAREAS_ACTIVOS ***/
    V_TABLA := 'TAC_TAREAS_ACTIVOS';
    V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        TAR_ID,
        TRA_ID,
        ACT_ID,
        USU_ID,
        SUP_ID,
        VERSION,
        USUARIOCREAR,
        FECHACREAR,
        BORRADO
    )
    SELECT
        TMP_ACT_TO_GEN_TRB_CEE.TAR_ID AS TAR_ID, 
        TMP_ACT_TO_GEN_TRB_CEE.TRA_ID AS TRA_ID,
        TMP_ACT_TO_GEN_TRB_CEE.ACT_ID AS ACT_ID,
        TMP_ACT_TO_GEN_TRB_CEE.USU_ID_GESTOR AS USU_ID,
        TMP_ACT_TO_GEN_TRB_CEE.USU_ID_SUPERVISOR AS SUP_ID,        
        1 AS VERSION,
        ''ALT_TRA_CEE'' AS USUARIOCREAR,
        sysdate AS FECHACREAR,
        0 AS BORRADO    
    FROM '||V_ESQUEMA||'.TMP_ACT_TO_GEN_TRB_CEE
    ';
    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_REGS := SQL%ROWCOUNT;
    #ESQUEMA#.SP_LSP_LOGS( 'gen_tramites_cee', 'GEN_TRAMITES_CEE', 'Insert '||V_TABLA, V_NUM_REGS, NULL);  


    COMMIT;

    #ESQUEMA#.SP_LSP_LOGS( 'gen_tramites_cee', 'GEN_TRAMITES_CEE', 'End gen tramites', 0, NULL);    
    
    ELSE
		#ESQUEMA#.SP_LSP_LOGS( 'gen_tramites_cee', 'GEN_TRAMITES_CEE', 'FIN (No hay activos en esta situación)', 0, NULL); 
	END IF;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;

END GEN_TRAMITES_CEE;
/
exit;


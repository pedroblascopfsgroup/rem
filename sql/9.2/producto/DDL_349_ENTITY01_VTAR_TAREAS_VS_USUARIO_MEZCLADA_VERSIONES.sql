--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160330
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0
--## INCIDENCIA_LINK=PRODUCTO-1063
--## PRODUCTO=SI
--## Finalidad: DDL para mezclar correctamente las versiones de los DDL 028, 031 y 032
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'VTAR_TAREA_VS_USUARIO';

BEGIN
    
	V_MSQL := '
  CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' ("USU_PENDIENTES", "USU_ESPERA", "USU_ALERTA", "DD_TGE_ID_PENDIENTE", "DD_TGE_ID_ESPERA", "DD_TGE_ID_ALERTA", "TAR_ID", "CLI_ID", "EXP_ID", "ASU_ID", "TAR_TAR_ID", "SPR_ID", "SCX_ID", "DD_EST_ID", "DD_EIN_ID", "DD_STA_ID", "TAR_CODIGO", "TAR_TAREA", "TAR_DESCRIPCION", "TAR_FECHA_FIN", "TAR_FECHA_INI", "TAR_EN_ESPERA", "TAR_ALERTA", "TAR_TAREA_FINALIZADA", "TAR_EMISOR", "VERSION", "USUARIOCREAR", "FECHACREAR", "USUARIOMODIFICAR", "FECHAMODIFICAR", "USUARIOBORRAR", "FECHABORRAR", "BORRADO", "PRC_ID", "CMB_ID", "SET_ID", "TAR_FECHA_VENC", "OBJ_ID", "TAR_FECHA_VENC_REAL", "DTYPE", "NFA_TAR_REVISADA", "NFA_TAR_FECHA_REVIS_ALER", "NFA_TAR_COMENTARIOS_ALERTA", "DD_TRA_ID", "CNT_ID", "TAR_DESTINATARIO", "TAR_TIPO_DESTINATARIO", "TAR_ID_DEST", "PER_ID", "RPR_REFERENCIA", "TAR_TIPO_ENT_COD", "TAR_DTYPE", "TAR_SUBTIPO_COD", "TAR_SUBTIPO_DESC", "PLAZO", "ENTIDADINFORMACION", "CODENTIDAD", "GESTOR", "TIPOSOLICITUDSQL", "IDENTIDAD", "FCREACIONENTIDAD", "CODIGOSITUACION", "IDTAREAASOCIADA", "DESCRIPCIONTAREAASOCIADA", "SUPERVISOR", "DIASVENCIDOSQL", "DESCRIPCIONENTIDAD", "SUBTIPOTARCODTAREA", "FECHACREACIONENTIDADFORMATEADA", "DESCRIPCIONEXPEDIENTE", "DESCRIPCIONCONTRATO", "IDENTIDADPERSONA", "VOLUMENRIESGOSQL", "TIPOITINERARIOENTIDAD", "PRORROGAFECHAPROPUESTA", "PRORROGACAUSADESCRIPCION", "CODIGOCONTRATO", "CONTRATO", "ZON_COD", "PEF_ID", "DD_TAC_ID", "DD_TPO_ID") AS 
WITH TMP_RIESGO AS (
SELECT CEX.EXP_ID EXP_ID, SUM (CASE
                             WHEN TRUNC (MOV.MOV_FECHA_EXTRACCION) = TRUNC (CNT.CNT_FECHA_EXTRACCION)
                                THEN MOV.MOV_RIESGO
                             ELSE 0
                          END) RIESGO
    FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CEX.CNT_ID = CNT.CNT_ID
         JOIN '||V_ESQUEMA||'.mov_movimientos mov ON cnt.cnt_id = mov.cnt_id
   WHERE 1 = 1
GROUP BY cex.exp_id
 )
  SELECT V.USU_PENDIENTES
      , CASE 
			WHEN (NVL(TAR.TAR_EN_ESPERA,0) = 1) 
			THEN COALESCE(ESP.USU_ID,NVL((SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = TAR.TAR_EMISOR), (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = TAR.USUARIOCREAR)),-1) ELSE -1 END USU_ESPERA '||Chr(13)||Chr(10)|| 
'		  
		  , V.USU_ALERTA, V.DD_TGE_ID_PENDIENTE
          , -1 DD_TGE_ID_ESPERA --DEPRECATED
          , V.DD_TGE_ID_ALERTA
          , TAR.TAR_ID, TAR.CLI_ID, TAR.EXP_ID, TAR.ASU_ID, TAR.TAR_TAR_ID, TAR.SPR_ID, TAR.SCX_ID
          , TAR.DD_EST_ID, TAR.DD_EIN_ID, TAR.DD_STA_ID, TAR.TAR_CODIGO, TAR.TAR_TAREA
      , CASE TAR.DD_EIN_ID
              WHEN 1
                THEN TAR.TAR_TAREA
              WHEN 3
                THEN ASU.ASU_NOMBRE
              WHEN 5
                THEN CASE WHEN TPO.DD_TPO_DESCRIPCION IS NOT NULL THEN ASU.ASU_NOMBRE || ''-'' || TPO.DD_TPO_DESCRIPCION ELSE ASU.ASU_NOMBRE END
              WHEN 10
                THEN TAR.TAR_DESCRIPCION
              ELSE TAR.TAR_DESCRIPCION
      END TAR_DESCRIPCION
	, TAR.TAR_FECHA_FIN, TAR.TAR_FECHA_INI, TAR.TAR_EN_ESPERA, TAR.TAR_ALERTA, TAR.TAR_TAREA_FINALIZADA, TAR.TAR_EMISOR, TAR.VERSION, TAR.USUARIOCREAR, TAR.FECHACREAR, TAR.USUARIOMODIFICAR
	, TAR.FECHAMODIFICAR, TAR.USUARIOBORRAR, TAR.FECHABORRAR, TAR.BORRADO, TAR.PRC_ID, TAR.CMB_ID, TAR.SET_ID, TAR.TAR_FECHA_VENC, TAR.OBJ_ID, TAR.TAR_FECHA_VENC_REAL, TAR.DTYPE, TAR.NFA_TAR_REVISADA
	, TAR.NFA_TAR_FECHA_REVIS_ALER, TAR.NFA_TAR_COMENTARIOS_ALERTA, TAR.DD_TRA_ID, TAR.CNT_ID, TAR.TAR_DESTINATARIO, TAR.TAR_TIPO_DESTINATARIO, TAR.TAR_ID_DEST, TAR.PER_ID, TAR.RPR_REFERENCIA, EIN.DD_EIN_CODIGO TAR_TIPO_ENT_COD
	, TAR.DTYPE TAR_DTYPE, STA.DD_STA_CODIGO TAR_SUBTIPO_COD, STA.DD_STA_DESCRIPCION TAR_SUBTIPO_DESC, '''' PLAZO -- TODO Sacar plazo para expediente y cliente
    ,CASE EIN.DD_EIN_CODIGO
       WHEN ''1'' -- Cliente
          THEN EIN.DD_EIN_DESCRIPCION || '' ['' || TAR.CLI_ID || '']''
       WHEN ''2''  --Expediente
          THEN EIN.DD_EIN_DESCRIPCION || '' ['' || TAR.EXP_ID || '']''
       WHEN ''3''  --Asunto
          THEN EIN.DD_EIN_DESCRIPCION || '' ['' || TAR.ASU_ID || '']''
       WHEN ''5''  --Procedimiento
          THEN EIN.DD_EIN_DESCRIPCION || '' ['' || TAR.PRC_ID || '']''
       WHEN ''7'' -- Objetivo
          THEN EIN.DD_EIN_DESCRIPCION || '' ['' || TAR.OBJ_ID || '']''		
       WHEN ''9''  --Persona 
          THEN EIN.DD_EIN_DESCRIPCION || '' ['' || TAR.PER_ID || '']'' 
       WHEN ''10'' --Notificacion 
          THEN EIN.DD_EIN_DESCRIPCION || '' ['' || TAR.TAR_ID || '']'' 
        -- TODO poner para el resto de unidades de gestion 
      ELSE '''' 
    END ENTIDADINFORMACION
	, CASE EIN.DD_EIN_CODIGO
      WHEN ''1'' --Cliente
        THEN TAR.CLI_ID
      WHEN ''2''  --Expediente
        THEN TAR.EXP_ID
      WHEN ''3''  --Asunto
        THEN TAR.ASU_ID
      WHEN ''5''  --Procedimiento
        THEN TAR.PRC_ID
      WHEN ''7'' -- Objetivo
        THEN TAR.OBJ_ID
      WHEN ''9''  --Persona 
        THEN TAR.PER_ID 
      WHEN ''10'' --Notificacion 
        THEN TAR.TAR_ID 
        -- TODO poner para el resto de unidades de gestion 
      ELSE -1 
    END CODENTIDAD
	, CASE WHEN STA.DD_STA_ID NOT IN (700, 701) THEN CASE EIN.DD_EIN_CODIGO
            WHEN ''1'' --Cliente
              THEN GES.APELLIDO_NOMBRE
            WHEN ''2''  --Expediente
              THEN GES.APELLIDO_NOMBRE
            WHEN ''3''  --Asunto
              THEN GES.APELLIDO_NOMBRE
            WHEN ''5''  --Procedimiento
              THEN GES.APELLIDO_NOMBRE
             WHEN ''7'' -- Objetivo
                THEN GES.APELLIDO_NOMBRE                
            WHEN ''9''  --Persona 
              THEN GES.APELLIDO_NOMBRE 
            WHEN ''10'' --Notificacion 
              THEN GES.APELLIDO_NOMBRE 
              -- TODO poner para el resto de unidades de gestion 
            ELSE NULL 
          END ELSE NULL END GESTOR 
	, CASE
      WHEN STA.DD_STA_CODIGO IN (''5'', ''6'', ''54'', ''41'', ''SOLPRORRFP'') THEN ''Prórroga'' 
      WHEN STA.DD_STA_CODIGO IN (''17'') THEN ''Cancelación Expediente'' 
      WHEN STA.DD_STA_CODIGO IN (''29'',''SOLEXPMGDEUDA'') THEN ''Expediente Manual'' 
      WHEN STA.DD_STA_CODIGO IN (''16'', ''28'', ''24'', ''26'', ''27'', ''589'', ''590'', ''15'') THEN ''Comunicación'' 
      WHEN STA.DD_STA_CODIGO IN (''NTGPS'') THEN ''NOTIFICACIÓN AUTOMÁTICA'' 
      ELSE '''' 
    END TIPOSOLICITUDSQL
	, CASE EIN.DD_EIN_CODIGO
      WHEN ''1'' -- Cliente
        THEN TAR.CLI_ID
      WHEN ''2''  --Expediente
        THEN TAR.EXP_ID
      WHEN ''3''  --Asunto
        THEN TAR.ASU_ID
      WHEN ''5''  --Procedimiento
        THEN TAR.PRC_ID
      WHEN ''7'' -- Objetivo
		THEN TAR.OBJ_ID
      WHEN ''9''  --Persona
        THEN TAR.PER_ID
      WHEN ''10'' --Notificacion
        THEN TAR.PRC_ID --Must be PRC_ID
        -- TODO poner para el resto de unidades de gestion
      ELSE -1
    END IDENTIDAD
	, CASE EIN.DD_EIN_CODIGO
      WHEN ''1'' --Cliente
        THEN CLI.CLI_FECHA_CREACION
      WHEN ''2''  --Expediente
        THEN EXP.FECHACREAR
      WHEN ''3''  --Asunto
        THEN ASU.FECHACREAR
      WHEN ''5''  --Procedimiento
        THEN PRC.FECHACREAR
      WHEN ''7'' -- Objetivo
        THEN OBJ.FECHACREAR
      WHEN ''9''  --Persona 
        THEN PER.FECHACREAR 
      WHEN ''10'' --Notificacion 
        THEN PER.FECHACREAR 
        -- TODO poner para el resto de unidades de gestion 
      ELSE NULL 
    END FCREACIONENTIDAD 
	, CASE EIN.DD_EIN_CODIGO 
      WHEN ''3'' 
      THEN EST.DD_EST_DESCRIPCION --asu.asu_situacion
        -- TODO poner para el resto de unidades de gestion
      ELSE ''''
    END CODIGOSITUACION
	, TAR.TAR_TAR_ID IDTAREAASOCIADA, ASOC.TAR_DESCRIPCION DESCRIPCIONTAREAASOCIADA
	, CASE EIN.DD_EIN_CODIGO
      WHEN ''1'' --Cliente
        THEN SUP.APELLIDO_NOMBRE
      WHEN ''2''  --Expediente
        THEN SUP.APELLIDO_NOMBRE
      WHEN ''3''  --Asunto
        THEN SUP.APELLIDO_NOMBRE
      WHEN ''5''  --Procedimiento
        THEN SUP.APELLIDO_NOMBRE
	  WHEN ''7'' -- Objetivo
		THEN SUP.APELLIDO_NOMBRE
      WHEN ''9''  --Persona
        THEN SUP.APELLIDO_NOMBRE
      WHEN ''10'' --Notificacion
        THEN SUP.APELLIDO_NOMBRE
        -- TODO poner para el resto de unidades de gestion
      ELSE NULL
    END SUPERVISOR
	, CASE
      WHEN TRUNC (TAR.TAR_FECHA_VENC) >= TRUNC(SYSDATE)
        THEN NULL
      ELSE EXTRACT (DAY FROM (SYSTIMESTAMP - (TRUNC (TAR.TAR_FECHA_VENC))))
    END DIASVENCIDOSQL
	, CASE EIN.DD_EIN_CODIGO
      WHEN ''1'' --Cliente
        THEN PER_CLI.PER_NOM50
      WHEN ''2''  --Expediente
        THEN EXP.EXP_DESCRIPCION
      WHEN ''3''  --Asunto
        THEN ASU.ASU_NOMBRE
      WHEN ''4''  --Tarea
        THEN TAR.TAR_DESCRIPCION
      WHEN ''5''  --Procedimiento
        THEN CASE WHEN TPO.DD_TPO_DESCRIPCION IS NOT NULL THEN ASU.ASU_NOMBRE || ''-'' || TPO.DD_TPO_DESCRIPCION ELSE ASU.ASU_NOMBRE END
      WHEN ''7'' --Objetivo
		THEN CASE WHEN PEROBJ.PER_NOM50 IS NOT NULL THEN PEROBJ.PER_NOM50 ELSE TOB.TOB_DESCRIPCION END
      WHEN ''9''  --Persona 
        THEN PER.PER_NOM50 
      WHEN ''10'' --Notificacion 
        THEN TAR.TAR_DESCRIPCION 
        -- TODO poner para el resto de unidades de gestion 
      ELSE NULL 
    END DESCRIPCIONENTIDAD
	, STA.DD_STA_CODIGO SUBTIPOTARCODTAREA
    ,CASE EIN.DD_EIN_CODIGO
      WHEN ''1'' --Cliente
        THEN TO_CHAR (CLI.FECHACREAR, ''DD/MM/YYYY'')
      WHEN ''2''  --Expediente
        THEN TO_CHAR (EXP.FECHACREAR, ''DD/MM/YYYY'')
      WHEN ''3''  --Asunto
        THEN TO_CHAR (ASU.FECHACREAR, ''DD/MM/YYYY'')
      WHEN ''5''  --Procedimiento
        THEN TO_CHAR (PRC.FECHACREAR, ''DD/MM/YYYY'')
      WHEN ''7'' --Objetivo
        THEN TO_CHAR(OBJ.FECHACREAR,''DD/MM/YYYY'')
      WHEN ''9''  --Persona 
        THEN TO_CHAR (PER.FECHACREAR, ''DD/MM/YYYY'') 
      WHEN ''10'' --Notificacion 
        THEN TO_CHAR (TAR.FECHACREAR, ''DD/MM/YYYY'') 
        -- TODO poner para el resto de unidades de gestion 
      ELSE NULL 
    END FECHACREACIONENTIDADFORMATEADA 
	, EXP.EXP_DESCRIPCION DESCRIPCIONEXPEDIENTE
    , NULL DESCRIPCIONCONTRATO -- TODO poner para contrato 
    ,CASE EIN.DD_EIN_CODIGO
        WHEN ''1'' --Cliente
          THEN CLI.PER_ID
        WHEN ''7'' --Objetivo
                THEN CMP.PER_ID
        ELSE NULL
     END IDENTIDADPERSONA
    ,CASE EIN.DD_EIN_CODIGO 
      WHEN ''5'' --Procedimiento
        THEN NVL (VRE_PRC.VRE, 0) --vre_via_prc 
	  WHEN ''2'' --Expediente
        THEN NVL (VRE_PRC.VRE, 0) --vre_via_prc 
          -- TODO poner para el resto de unidades de gestion 
      ELSE 0 
    END VOLUMENRIESGOSQL 
    ,CASE
        WHEN CLI.CLI_ID IS NOT NULL THEN TITI_CLI.DD_TIT_DESCRIPCION
        WHEN EXP.EXP_ID IS NOT NULL THEN TITI_EXP.DD_TIT_DESCRIPCION
        WHEN PER.PER_ID IS NOT NULL THEN TITI_PER.DD_TIT_DESCRIPCION
		WHEN PEROBJ.PER_ID IS NOT NULL THEN TITARR.DD_TIT_DESCRIPCION
        ELSE NULL
    END TIPOITINERARIOENTIDAD
    , NULL PRORROGAFECHAPROPUESTA -- TODO calcular la fecha prorroga propuesta 
    , NULL PRORROGACAUSADESCRIPCION -- TODO calcular la causa de la prorroga 
    , NULL CODIGOCONTRATO -- TODO poner para contrato 
    , NULL CONTRATO -- TODO calcular 
    ,V.ZON_COD
    ,V.PEF_ID
	,TAC.DD_TAC_ID
    ,TPO.DD_TPO_ID
  FROM 
    ( 
      SELECT * FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO_PART1 
        UNION ALL
      SELECT * FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO_PART2 
		UNION ALL
      SELECT * FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO_EXPE
		UNION ALL
	  SELECT * FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO_OBJ 
        UNION ALL
      SELECT * FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO_ACUERDOS
        UNION ALL
      SELECT * FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO_CLI
    ) V
    JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON V.TAR_ID = TAR.TAR_ID
    JOIN '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION EIN ON TAR.DD_EIN_ID = EIN.DD_EIN_ID
    JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE STA ON TAR.DD_STA_ID = STA.DD_STA_ID
    LEFT JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON TAR.PRC_ID = PRC.PRC_ID AND PRC.BORRADO = 0
    LEFT JOIN '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON TAR.ASU_ID = ASU.ASU_ID AND ASU.BORRADO = 0
    LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID
    LEFT JOIN '||V_ESQUEMA||'.VTAR_NOMBRES_USUARIOS GES ON V.USU_PENDIENTES = GES.USU_ID
    LEFT JOIN '||V_ESQUEMA||'.VTAR_NOMBRES_USUARIOS SUP ON V.USU_SUPERVISOR = SUP.USU_ID
    LEFT JOIN '||V_ESQUEMA||'.VTAR_NOMBRES_USUARIOS ESP ON TAR.TAR_EMISOR = ESP.APELLIDO_NOMBRE
    LEFT JOIN '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP ON TAR.EXP_ID = EXP.EXP_ID
      LEFT JOIN '||V_ESQUEMA||'.ARQ_ARQUETIPOS ARQ_EXP ON EXP.ARQ_ID = ARQ_EXP.ARQ_ID
        LEFT JOIN '||V_ESQUEMA||'.ITI_ITINERARIOS ITI_EXP ON ARQ_EXP.ITI_ID = ITI_EXP.ITI_ID
          LEFT JOIN '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS TITI_EXP ON ITI_EXP.DD_TIT_ID = TITI_EXP.DD_TIT_ID
    LEFT JOIN '||V_ESQUEMA||'.CLI_CLIENTES CLI ON TAR.CLI_ID = CLI.CLI_ID
      LEFT JOIN '||V_ESQUEMA||'.PER_PERSONAS PER_CLI ON CLI.PER_ID = PER_CLI.PER_ID
      LEFT JOIN '||V_ESQUEMA||'.ARQ_ARQUETIPOS ARQ_CLI ON CLI.ARQ_ID = ARQ_CLI.ARQ_ID
        LEFT JOIN '||V_ESQUEMA||'.ITI_ITINERARIOS ITI_CLI ON ARQ_CLI.ITI_ID = ITI_CLI.ITI_ID
          LEFT JOIN '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS TITI_CLI ON ITI_CLI.DD_TIT_ID = TITI_CLI.DD_TIT_ID
    LEFT JOIN '||V_ESQUEMA||'.PER_PERSONAS PER ON TAR.PER_ID = PER.PER_ID
      LEFT JOIN '||V_ESQUEMA||'.ARQ_ARQUETIPOS ARQ_PER ON PER.ARQ_ID = ARQ_PER.ARQ_ID
        LEFT JOIN '||V_ESQUEMA||'.ITI_ITINERARIOS ITI_PER ON ARQ_PER.ITI_ID = ITI_PER.ITI_ID
          LEFT JOIN '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS TITI_PER ON ITI_PER.DD_TIT_ID = TITI_PER.DD_TIT_ID
    LEFT JOIN '||V_ESQUEMA||'.OBJ_OBJETIVO OBJ ON TAR.OBJ_ID = OBJ.OBJ_ID
      LEFT JOIN '||V_ESQUEMA||'.TOB_TIPO_OBJETIVO TOB ON OBJ.TOB_ID = TOB.TOB_ID
      LEFT JOIN '||V_ESQUEMA||'.POL_POLITICA POL ON OBJ.POL_ID = POL.POL_ID
        LEFT JOIN '||V_ESQUEMA||'.CMP_CICLO_MARCADO_POLITICA CMP ON POL.CMP_ID = CMP.CMP_ID
			LEFT JOIN '||V_ESQUEMA||'.PER_PERSONAS PEROBJ ON CMP.PER_ID = PEROBJ.PER_ID
        		LEFT JOIN '||V_ESQUEMA||'.ARR_ARQ_RECUPERACION_PERSONA ARR ON PEROBJ.PER_ID = ARR.PER_ID
          			LEFT JOIN '||V_ESQUEMA||'.ARQ_ARQUETIPOS ARQARR ON ARR.ARQ_ID = ARQARR.ARQ_ID
            			LEFT JOIN '||V_ESQUEMA||'.ITI_ITINERARIOS ITIARR ON ARQARR.ITI_ID = ITIARR.ITI_ID
              				LEFT JOIN '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS TITARR ON ITIARR.DD_TIT_ID = TITARR.DD_TIT_ID
    LEFT JOIN '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS EST ON TAR.DD_EST_ID = EST.DD_EST_ID
    LEFT JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES ASOC ON TAR.TAR_TAR_ID = ASOC.TAR_ID
    LEFT JOIN '||V_ESQUEMA||'.VTAR_TAR_VRE_VIA_PRC VRE_PRC ON TAR.TAR_ID = VRE_PRC.TAR_ID
    LEFT JOIN '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION TAC ON TPO.DD_TAC_ID = TAC.DD_TAC_ID
    LEFT JOIN TMP_RIESGO ON EXP.EXP_ID = TMP_RIESGO.EXP_ID
';
  
 EXECUTE IMMEDIATE V_MSQL;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NOMBRE_VISTA||' Creada o reemplazada');     

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;

--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20150819
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-88
--## PRODUCTO=SI
--## Finalidad: DDL Para hacer join con la parte nueva de expedientes
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
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'VTAR_TAREA_VS_USUARIO';

BEGIN

    -- Comprobamos si existe la vista   
    V_SQL := 'SELECT COUNT(1) FROM ALL_VIEWS WHERE VIEW_NAME = '''||V_NOMBRE_VISTA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
         
    if V_NUM_TABLAS > 0 
     
     then          
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' Ya Existe');
          V_MSQL := 'DROP VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA;
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||'... Vista borrada');
    END IF;
    
    EXECUTE IMMEDIATE '
	CREATE VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' AS
		SELECT V.USU_PENDIENTES
      , CASE WHEN (NVL(TAR.TAR_EN_ESPERA,0) = 1) THEN NVL(ESP.USU_ID,-1) ELSE -1 END USU_ESPERA
		  -- , CASE WHEN v.en_espera=1 THEN esp.usu_id ELSE 1 END usu_espera
		  , V.USU_ALERTA, V.DD_TGE_ID_PENDIENTE
          , -1 DD_TGE_ID_ESPERA --DEPRECATED
          , V.DD_TGE_ID_ALERTA
          , TAR.TAR_ID, TAR.CLI_ID, TAR.EXP_ID, TAR.ASU_ID, TAR.TAR_TAR_ID, TAR.SPR_ID, TAR.SCX_ID
          , TAR.DD_EST_ID, TAR.DD_EIN_ID, TAR.DD_STA_ID, TAR.TAR_CODIGO, TAR.TAR_TAREA
          , CASE TAR.DD_EIN_ID
             WHEN 5
                THEN CASE WHEN TPO.DD_TPO_DESCRIPCION IS NOT NULL THEN ASU.ASU_NOMBRE || ''-'' || TPO.DD_TPO_DESCRIPCION ELSE ASU.ASU_NOMBRE END
             WHEN 3
                THEN ASU.ASU_NOMBRE
             ELSE TAR.TAR_DESCRIPCION
          END TAR_DESCRIPCION
          , TAR.TAR_FECHA_FIN, TAR.TAR_FECHA_INI, TAR.TAR_EN_ESPERA, TAR.TAR_ALERTA, TAR.TAR_TAREA_FINALIZADA, TAR.TAR_EMISOR, TAR.VERSION, TAR.USUARIOCREAR, TAR.FECHACREAR, TAR.USUARIOMODIFICAR
          , TAR.FECHAMODIFICAR, TAR.USUARIOBORRAR, TAR.FECHABORRAR, TAR.BORRADO, TAR.PRC_ID, TAR.CMB_ID, TAR.SET_ID, TAR.TAR_FECHA_VENC, TAR.OBJ_ID, TAR.TAR_FECHA_VENC_REAL, TAR.DTYPE, TAR.NFA_TAR_REVISADA
          , TAR.NFA_TAR_FECHA_REVIS_ALER, TAR.NFA_TAR_COMENTARIOS_ALERTA, TAR.DD_TRA_ID, TAR.CNT_ID, TAR.TAR_DESTINATARIO, TAR.TAR_TIPO_DESTINATARIO, TAR.TAR_ID_DEST, TAR.PER_ID, TAR.RPR_REFERENCIA, EIN.DD_EIN_CODIGO TAR_TIPO_ENT_COD
          , TAR.DTYPE TAR_DTYPE, STA.DD_STA_CODIGO TAR_SUBTIPO_COD, STA.DD_STA_DESCRIPCION TAR_SUBTIPO_DESC, '''' PLAZO  -- TODO Sacar plazo para expediente y cliente
          , CASE EIN.DD_EIN_CODIGO
             WHEN ''3''
                THEN EIN.DD_EIN_DESCRIPCION || '' ['' || TAR.ASU_ID || '']''
             WHEN ''5''
                THEN EIN.DD_EIN_DESCRIPCION || '' ['' || TAR.PRC_ID || '']''
             WHEN ''2''
                THEN EIN.DD_EIN_DESCRIPCION || '' ['' || TAR.EXP_ID || '']''
             WHEN ''9''
                THEN EIN.DD_EIN_DESCRIPCION || '' ['' || TAR.PER_ID || '']''
             -- TODO poner para el resto de unidades de gestion
          ELSE ''''
          END ENTIDADINFORMACION
          , CASE EIN.DD_EIN_CODIGO
             WHEN ''3''
                THEN TAR.ASU_ID
             WHEN ''5''
                THEN TAR.PRC_ID
             WHEN ''2''
                THEN TAR.EXP_ID
             WHEN ''9''
                THEN TAR.PER_ID
             -- TODO poner para el resto de unidades de gestion
          ELSE -1
          END CODENTIDAD
          , CASE WHEN STA.DD_STA_ID NOT IN (700, 701) THEN CASE EIN.DD_EIN_CODIGO
             WHEN ''3''
                THEN GES.APELLIDO_NOMBRE
             WHEN ''5''
                THEN GES.APELLIDO_NOMBRE
             WHEN ''2''
                THEN GES.APELLIDO_NOMBRE
             WHEN ''9''
                THEN GES.APELLIDO_NOMBRE
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END ELSE NULL END GESTOR
          , CASE
              WHEN STA.DD_STA_CODIGO IN (''5'', ''6'', ''54'', ''41'') THEN ''Prórroga''
              WHEN STA.DD_STA_CODIGO IN (''17'') THEN ''Cancelación Expediente''
              WHEN STA.DD_STA_CODIGO IN (''29'') THEN ''Expediente Manual''
              WHEN STA.DD_STA_CODIGO IN (''16'', ''28'', ''24'', ''26'', ''27'', ''589'', ''590'', ''15'') THEN ''Comunicación''
              ELSE ''''
          END TIPOSOLICITUDSQL
          , CASE EIN.DD_EIN_CODIGO
             WHEN ''3''
                THEN TAR.ASU_ID
             WHEN ''5''
                THEN TAR.PRC_ID
             WHEN ''2'' THEN TAR.EXP_ID
             WHEN ''9'' THEN TAR.PER_ID
             -- TODO poner para el resto de unidades de gestion
          ELSE -1
          END IDENTIDAD
          , CASE EIN.DD_EIN_CODIGO
             WHEN ''3''
                THEN ASU.FECHACREAR
             WHEN ''5''
                THEN PRC.FECHACREAR
             WHEN ''2''
                THEN EXP.FECHACREAR
             WHEN ''2''
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
             WHEN ''3''
                THEN SUP.APELLIDO_NOMBRE
             WHEN ''5''
                THEN SUP.APELLIDO_NOMBRE
             WHEN ''2'' THEN SUP.APELLIDO_NOMBRE
             WHEN ''9'' THEN SUP.APELLIDO_NOMBRE
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END SUPERVISOR
          , CASE
             WHEN TRUNC (TAR.TAR_FECHA_VENC) >= TRUNC(SYSDATE)
                THEN NULL
             ELSE EXTRACT (DAY FROM (SYSTIMESTAMP - (TRUNC (TAR.TAR_FECHA_VENC))))
          END DIASVENCIDOSQL
          , CASE EIN.DD_EIN_CODIGO
             WHEN ''3''
                THEN ASU.ASU_NOMBRE
             WHEN ''5''
                THEN CASE WHEN TPO.DD_TPO_DESCRIPCION IS NOT NULL THEN ASU.ASU_NOMBRE || ''-'' || TPO.DD_TPO_DESCRIPCION ELSE ASU.ASU_NOMBRE END
             WHEN ''2'' THEN EXP.EXP_DESCRIPCION
             WHEN ''9'' THEN PER.PER_NOM50
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END DESCRIPCIONENTIDAD
          , STA.DD_STA_CODIGO SUBTIPOTARCODTAREA,
          CASE EIN.DD_EIN_CODIGO
             WHEN ''3''
                THEN TO_CHAR (ASU.FECHACREAR, ''dd/mm/yyyy'')
             WHEN ''5''
                THEN TO_CHAR (PRC.FECHACREAR, ''dd/mm/yyyy'')
             WHEN ''2''
                THEN TO_CHAR (EXP.FECHACREAR, ''dd/mm/yyyy'')
             WHEN ''9''
                THEN TO_CHAR (PER.FECHACREAR, ''dd/mm/yyyy'')
             -- TODO poner para el resto de unidades de gestion
            ELSE NULL
          END FECHACREACIONENTIDADFORMATEADA
          , EXP.EXP_DESCRIPCION DESCRIPCIONEXPEDIENTE
          , NULL DESCRIPCIONCONTRATO     -- TODO poner para contrato
          , NULL IDENTIDADPERSONA   -- TODO poner para objetivo y para cliente
          , CASE EIN.DD_EIN_CODIGO
             WHEN ''5''
                THEN NVL (VRE_PRC.VRE, 0)  --vre_via_prc
              -- TODO poner para el resto de unidades de gestion
          ELSE 0
          END VOLUMENRIESGOSQL
          ,CASE 
            WHEN EXP.EXP_ID IS NOT NULL THEN TITI_EXP.DD_TIT_DESCRIPCION
            WHEN PER.PER_ID IS NOT NULL THEN TITI_PER.DD_TIT_DESCRIPCION
            ELSE NULL
          END TIPOITINERARIOENTIDAD
          , NULL PRORROGAFECHAPROPUESTA  -- TODO calcular la fecha prorroga propuesta
          , NULL PRORROGACAUSADESCRIPCION   -- TODO calcular la causa de la prorroga
          , NULL CODIGOCONTRATO   -- TODO poner para contrato
          , NULL CONTRATO    -- TODO calcular
          ,V.ZON_COD
          ,V.PEF_ID
FROM (SELECT *
             FROM VTAR_TAREA_VS_USUARIO_PART1
           UNION
           SELECT *
             FROM VTAR_TAREA_VS_USUARIO_PART2
           UNION
           SELECT *
              FROM VTAR_TAREA_VS_USUARIO_EXPE
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
    LEFT JOIN '||V_ESQUEMA||'.PER_PERSONAS PER ON TAR.PER_ID = PER.PER_ID
      LEFT JOIN '||V_ESQUEMA||'.ARQ_ARQUETIPOS ARQ_PER ON PER.ARQ_ID = ARQ_PER.ARQ_ID
        LEFT JOIN '||V_ESQUEMA||'.ITI_ITINERARIOS ITI_PER ON ARQ_PER.ITI_ID = ITI_PER.ITI_ID
          LEFT JOIN '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS TITI_PER ON ITI_PER.DD_TIT_ID = TITI_PER.DD_TIT_ID    
    LEFT JOIN '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS EST ON TAR.DD_EST_ID = EST.DD_EST_ID
    LEFT JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES ASOC ON TAR.TAR_TAR_ID = ASOC.TAR_ID
    LEFT JOIN '||V_ESQUEMA||'.VTAR_TAR_VRE_VIA_PRC VRE_PRC ON TAR.TAR_ID = VRE_PRC.TAR_ID
';

    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NOMBRE_VISTA||' Creada');     

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

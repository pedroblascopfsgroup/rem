--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20150702
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-88
--## PRODUCTO=SI
--## Finalidad: DDL Crear vista que obtiene las tareas pendientes de expediente
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
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'VTAR_TAREA_VS_USUARIO_P3_EXP';

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
	SELECT TN.TAR_ID_DEST USU_PENDIENTES
    	,CASE WHEN (NVL(TN.TAR_EN_ESPERA,0) = 1) THEN NVL(ESP.USU_ID,-1) ELSE -1 END USU_ESPERA
		-- , CASE WHEN v.en_espera=1 THEN esp.usu_id ELSE 1 END usu_espera
		, -1 USU_ALERTA, 
    	CASE
      		WHEN (STA.DD_STA_ID = 700 OR STA.DD_STA_ID = 701) THEN -1
      		WHEN NVL (TAP.DD_TGE_ID, 0) != 0 THEN TAP.DD_TGE_ID
      		WHEN STA.DD_TGE_ID IS NULL THEN CASE STA.DD_STA_GESTOR  WHEN 0 THEN 3 ELSE 2 END
      		ELSE STA.DD_TGE_ID
    	END DD_TGE_ID_PENDIENTE      
      	, -1 DD_TGE_ID_ESPERA --DEPRECATED
    	, CASE
        	WHEN (TN.TAR_ALERTA IS NOT NULL AND TN.TAR_ALERTA = 1) THEN NVL (TAP.DD_TSUP_ID, 3)
        	ELSE -1
      	END DD_TGE_ID_ALERTA          
        , TN.TAR_ID, TN.CLI_ID, TN.EXP_ID, TN.ASU_ID, TN.TAR_TAR_ID, TN.SPR_ID, TN.SCX_ID
        , TN.DD_EST_ID, TN.DD_EIN_ID, TN.DD_STA_ID, TN.TAR_CODIGO, TN.TAR_TAREA
        , CASE TN.DD_EIN_ID
        	WHEN 5
            	THEN CASE WHEN TPO.DD_TPO_DESCRIPCION IS NOT NULL THEN ASU.ASU_NOMBRE || ''-'' || TPO.DD_TPO_DESCRIPCION ELSE ASU.ASU_NOMBRE END
            WHEN 3
                THEN ASU.ASU_NOMBRE
            ELSE TN.TAR_DESCRIPCION
        END TAR_DESCRIPCION
        , TN.TAR_FECHA_FIN, TN.TAR_FECHA_INI, TN.TAR_EN_ESPERA, TN.TAR_ALERTA, TN.TAR_TAREA_FINALIZADA, TN.TAR_EMISOR, TN.VERSION, TN.USUARIOCREAR, TN.FECHACREAR, TN.USUARIOMODIFICAR
        , TN.FECHAMODIFICAR, TN.USUARIOBORRAR, TN.FECHABORRAR, TN.BORRADO, TN.PRC_ID, TN.CMB_ID, TN.SET_ID, TN.TAR_FECHA_VENC, TN.OBJ_ID, TN.TAR_FECHA_VENC_REAL, TN.DTYPE, TN.NFA_TAR_REVISADA
        , TN.NFA_TAR_FECHA_REVIS_ALER, TN.NFA_TAR_COMENTARIOS_ALERTA, TN.DD_TRA_ID, TN.CNT_ID, TN.TAR_DESTINATARIO, TN.TAR_TIPO_DESTINATARIO, TN.TAR_ID_DEST, TN.PER_ID, TN.RPR_REFERENCIA, DDTPOENTI.DD_EIN_CODIGO TAR_TIPO_ENT_COD
        , TN.DTYPE TAR_DTYPE, STA.DD_STA_CODIGO TAR_SUBTIPO_COD, STA.DD_STA_DESCRIPCION TAR_SUBTIPO_DESC, '''' PLAZO  -- TODO Sacar plazo para expediente y cliente
        , CASE DDTPOENTI.DD_EIN_CODIGO
             WHEN ''3''
                THEN DDTPOENTI.DD_EIN_DESCRIPCION || '' ['' || TN.ASU_ID || '']''
             WHEN ''5''
                THEN DDTPOENTI.DD_EIN_DESCRIPCION || '' ['' || TN.PRC_ID || '']''
             WHEN ''2''
                THEN DDTPOENTI.DD_EIN_DESCRIPCION || '' ['' || TN.EXP_ID || '']''
             WHEN ''9''
                THEN DDTPOENTI.DD_EIN_DESCRIPCION || '' ['' || TN.PER_ID || '']''
             -- TODO poner para el resto de unidades de gestion
          ELSE ''''
          END ENTIDADINFORMACION
          , CASE DDTPOENTI.DD_EIN_CODIGO
             WHEN ''3''
                THEN TN.ASU_ID
             WHEN ''5''
                THEN TN.PRC_ID
             WHEN ''2''
                THEN TN.EXP_ID
             WHEN ''9''
                THEN TN.PER_ID
             -- TODO poner para el resto de unidades de gestion
          ELSE -1
          END CODENTIDAD
          , CASE WHEN STA.DD_STA_ID NOT IN (700, 701) THEN CASE DDTPOENTI.DD_EIN_CODIGO
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
          , CASE DDTPOENTI.DD_EIN_CODIGO
             WHEN ''3''
                THEN TN.ASU_ID
             WHEN ''5''
                THEN TN.PRC_ID
             WHEN ''2'' THEN TN.EXP_ID
             WHEN ''9'' THEN TN.PER_ID
             -- TODO poner para el resto de unidades de gestion
          ELSE -1
          END IDENTIDAD
          , CASE DDTPOENTI.DD_EIN_CODIGO
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
          , CASE DDTPOENTI.DD_EIN_CODIGO
             WHEN ''3''
                THEN DDEST.DD_EST_DESCRIPCION --asu.asu_situacion
             -- TODO poner para el resto de unidades de gestion
          ELSE ''''
          END CODIGOSITUACION
          , TN.TAR_TAR_ID IDTAREAASOCIADA, ASOC.TAR_DESCRIPCION DESCRIPCIONTAREAASOCIADA
         , CASE DDTPOENTI.DD_EIN_CODIGO
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
             WHEN TRUNC (TN.TAR_FECHA_VENC) >= TRUNC(SYSDATE)
                THEN NULL
             ELSE EXTRACT (DAY FROM (SYSTIMESTAMP - (TRUNC (TN.TAR_FECHA_VENC))))
          END DIASVENCIDOSQL
          , CASE DDTPOENTI.DD_EIN_CODIGO
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
          CASE DDTPOENTI.DD_EIN_CODIGO
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
          , NULL DESCRIPCIONEXPEDIENTE  -- TODO poner para expediente
          , NULL DESCRIPCIONCONTRATO     -- TODO poner para contrato
          , NULL IDENTIDADPERSONA   -- TODO poner para objetivo y para cliente
          , CASE DDTPOENTI.DD_EIN_CODIGO
             WHEN ''5''
                THEN NVL (VRE_PRC.VRE, 0)  --vre_via_prc
              -- TODO poner para el resto de unidades de gestion
          ELSE 0
          END VOLUMENRIESGOSQL
          , NULL TIPOITINERARIOENTIDAD      -- TODO sacar para cliente y expediente
          , NULL PRORROGAFECHAPROPUESTA  -- TODO calcular la fecha prorroga propuesta
          , NULL PRORROGACAUSADESCRIPCION   -- TODO calcular la causa de la prorroga
          , NULL CODIGOCONTRATO   -- TODO poner para contrato
          , NULL CONTRATO    -- TODO calcular
          ,DDTAR.DD_TAR_CODIGO DD_TAR_COGIDO
          ,DDZON.ZON_COD
          ,CASE 
			WHEN STA.DD_STA_GESTOR = 1 
				THEN EST.PEF_ID_GESTOR 
			ELSE EST.PEF_ID_SUPERVISOR
		END PEF_ID
	FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TN
	  LEFT JOIN '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP ON TN.EXP_ID=EXP.EXP_ID
	    INNER JOIN '||V_ESQUEMA||'.ARQ_ARQUETIPOS ARQ ON EXP.ARQ_ID=ARQ.ARQ_ID
	    INNER JOIN '||V_ESQUEMA||'.OFI_OFICINAS OFI ON EXP.OFI_ID=OFI.OFI_ID 
	      INNER JOIN '||V_ESQUEMA||'.ZON_ZONIFICACION DDZON ON OFI.OFI_ID=DDZON.OFI_ID
	    LEFT JOIN '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS DDEST ON EXP.DD_EST_ID=DDEST.DD_EST_ID
	      LEFT JOIN '||V_ESQUEMA||'.EST_ESTADOS EST ON DDEST.DD_EST_ID=EST.DD_EST_ID
	  INNER JOIN '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS DDESTITI ON TN.DD_EST_ID=DDESTITI.DD_EST_ID
	  INNER JOIN '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION DDTPOENTI ON TN.DD_EIN_ID=DDTPOENTI.DD_EIN_ID
	  INNER JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE STA ON TN.DD_STA_ID=STA.DD_STA_ID 
	    INNER JOIN '||V_ESQUEMA_M||'.DD_TAR_TIPO_TAREA_BASE DDTAR ON STA.DD_TAR_ID=DDTAR.DD_TAR_ID 
	  LEFT JOIN '||V_ESQUEMA||'.VTAR_TAR_VRE_VIA_PRC VRE_PRC ON TN.TAR_ID = VRE_PRC.TAR_ID    
	  LEFT JOIN '||V_ESQUEMA||'.PER_PERSONAS PER ON TN.PER_ID = PER.PER_ID
	  LEFT JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON TN.PRC_ID = PRC.PRC_ID AND PRC.BORRADO = 0
	    LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID
	  LEFT JOIN '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON TN.ASU_ID = ASU.ASU_ID AND ASU.BORRADO = 0
	  LEFT JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TN.TAR_ID = TEX.TAR_ID
	     LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID  
	      LEFT JOIN '||V_ESQUEMA||'.VTAR_NOMBRES_USUARIOS SUP ON NVL(TAP.DD_TSUP_ID,3) = SUP.USU_ID
	  LEFT JOIN '||V_ESQUEMA||'.VTAR_NOMBRES_USUARIOS ESP ON TN.TAR_EMISOR = ESP.APELLIDO_NOMBRE
	  LEFT JOIN '||V_ESQUEMA||'.VTAR_NOMBRES_USUARIOS GES ON TN.TAR_ID_DEST = GES.USU_ID
	  LEFT JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES ASOC ON TN.TAR_TAR_ID = ASOC.TAR_ID
	WHERE  TN.BORRADO=0 
	  AND DDEST.DD_EST_CODIGO=DDESTITI.DD_EST_CODIGO 
	  AND ARQ.ITI_ID=EST.ITI_ID 
	  AND (TN.TAR_TAREA_FINALIZADA IS NULL OR TN.TAR_TAREA_FINALIZADA=0) 
	  AND DDTPOENTI.DD_EIN_CODIGO=2 --CODIGO_ENTIDAD_EXPEDIENTE;
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

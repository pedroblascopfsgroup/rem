--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160305
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0
--## INCIDENCIA_LINK=CMREC-1859
--## PRODUCTO=SI
--## Finalidad: DDL Para crear la vista de tareas pendientes para objetos tipo cliente
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
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'VTAR_TAREA_VS_USUARIO_CLI';

BEGIN

    -- Comprobamos si existe la vista   
    V_SQL := 'SELECT COUNT(1) FROM ALL_VIEWS WHERE VIEW_NAME = '''||V_NOMBRE_VISTA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
         
    IF V_NUM_TABLAS > 0 THEN          
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' Ya Existe');
          V_MSQL := 'DROP VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA;
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||'... Vista borrada');
    END IF;
    
	
	V_MSQL := '
	CREATE VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' ("TAR_ID", "USU_PENDIENTES", "USU_ALERTA", "USU_SUPERVISOR", "DD_TGE_ID_ALERTA", "DD_TGE_ID_PENDIENTE", "ZON_COD", "PEF_ID") AS 
	  SELECT
    TN.TAR_ID
    ,TN.TAR_ID_DEST USU_PENDIENTES
    ,-1 USU_ALERTA
    ,-1 USU_SUPERVISOR
    , CASE
        WHEN (TN.TAR_ALERTA IS NOT NULL AND TN.TAR_ALERTA = 1) THEN NVL (TAP.DD_TSUP_ID, 3)
        ELSE -1
      END DD_TGE_ID_ALERTA
    ,	CASE
      		WHEN (STA.DD_STA_ID = 700 OR STA.DD_STA_ID = 701) THEN -1
      		WHEN NVL (TAP.DD_TGE_ID, 0) != 0 THEN TAP.DD_TGE_ID
      		WHEN STA.DD_TGE_ID IS NULL THEN CASE STA.DD_STA_GESTOR  WHEN 0 THEN 3 ELSE 2 END
      		ELSE STA.DD_TGE_ID
    	END DD_TGE_ID_PENDIENTE
    ,DDZON.ZON_COD
    ,CASE
      WHEN STA.DD_STA_GESTOR = 1
        THEN EST.PEF_ID_GESTOR
      ELSE EST.PEF_ID_SUPERVISOR
    END PEF_ID
	FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TN
    LEFT JOIN '||V_ESQUEMA||'.CLI_CLIENTES CLI ON TN.CLI_ID = CLI.CLI_ID
	    INNER JOIN '||V_ESQUEMA||'.ARQ_ARQUETIPOS ARQ ON CLI.ARQ_ID=ARQ.ARQ_ID
	    INNER JOIN '||V_ESQUEMA||'.OFI_OFICINAS OFI ON CLI.OFI_ID=OFI.OFI_ID
	      INNER JOIN '||V_ESQUEMA||'.ZON_ZONIFICACION DDZON ON OFI.OFI_ID=DDZON.OFI_ID
	    LEFT JOIN '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS DDEST ON CLI.DD_EST_ID=DDEST.DD_EST_ID
	      LEFT JOIN '||V_ESQUEMA||'.EST_ESTADOS EST ON DDEST.DD_EST_ID=EST.DD_EST_ID
	  INNER JOIN '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS DDESTITI ON TN.DD_EST_ID=DDESTITI.DD_EST_ID
	  INNER JOIN '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION DDTPOENTI ON TN.DD_EIN_ID=DDTPOENTI.DD_EIN_ID
	  INNER JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE STA ON TN.DD_STA_ID=STA.DD_STA_ID
	  LEFT JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TN.TAR_ID = TEX.TAR_ID
	     LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
	WHERE  TN.BORRADO=0
	  AND DDEST.DD_EST_CODIGO=DDESTITI.DD_EST_CODIGO
	  AND ARQ.ITI_ID=EST.ITI_ID
	  AND (TN.TAR_TAREA_FINALIZADA IS NULL OR TN.TAR_TAREA_FINALIZADA=0)
	  AND DDTPOENTI.DD_EIN_CODIGO=1 --CODIGO_ENTIDAD_CLIENTE';

 DBMS_OUTPUT.PUT_LINE('[INFO] '||V_MSQL);  
 EXECUTE IMMEDIATE V_MSQL;

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

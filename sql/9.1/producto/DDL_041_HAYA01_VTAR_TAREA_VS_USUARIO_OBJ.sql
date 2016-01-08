/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20150826
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-192
--## PRODUCTO=SI
--## Finalidad: DDL Crear vista que obtiene los objetivos pendientes
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
    
--    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
--    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
--    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'VTAR_TAREA_VS_USUARIO_OBJ';

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
  SELECT
    TN.TAR_ID
    ,TN.TAR_ID_DEST USU_PENDIENTES
    ,-1 USU_ALERTA
    ,-1 USU_SUPERVISOR
    , CASE
        WHEN (TN.TAR_ALERTA IS NOT NULL AND TN.TAR_ALERTA = 1) THEN NVL (TAP.DD_TSUP_ID, 3)
        ELSE -1
      END DD_TGE_ID_ALERTA
    	,CASE
      		WHEN (STA.DD_STA_ID = 700 OR STA.DD_STA_ID = 701) THEN -1
      		WHEN NVL (TAP.DD_TGE_ID, 0) != 0 THEN TAP.DD_TGE_ID
      		WHEN STA.DD_TGE_ID IS NULL THEN CASE STA.DD_STA_GESTOR  WHEN 0 THEN 3 ELSE 2 END
      		ELSE STA.DD_TGE_ID
    	END DD_TGE_ID_PENDIENTE
    , CASE
            WHEN STA.DD_STA_GESTOR = 1
              THEN TO_CHAR(ZONGES.ZON_COD)
            ELSE TO_CHAR(ZONSUP.ZON_COD)
      END ZON_COD
    ,CASE
      WHEN STA.DD_STA_GESTOR = 1
        THEN POL.PEF_ID_GESTOR
      ELSE POL.PEF_ID_SUPER
    END PEF_ID
FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TN
  INNER JOIN '||V_ESQUEMA||'.OBJ_OBJETIVO OBJ ON TN.OBJ_ID = OBJ.OBJ_ID
    INNER JOIN '||V_ESQUEMA||'.POL_POLITICA POL ON OBJ.POL_ID = POL.POL_ID
      LEFT JOIN '||V_ESQUEMA||'.ZON_ZONIFICACION ZONGES ON POL.ZON_ID_GESTOR = ZONGES.ZON_ID
      LEFT JOIN '||V_ESQUEMA||'.ZON_ZONIFICACION ZONSUP ON POL.ZON_ID_SUPER = ZONSUP.ZON_ID
  LEFT JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TN.TAR_ID = TEX.TAR_ID
    LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
  INNER JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE STA ON TN.DD_STA_ID=STA.DD_STA_ID
WHERE TN.BORRADO=0
	  AND (TN.TAR_TAREA_FINALIZADA IS NULL OR TN.TAR_TAREA_FINALIZADA=0)
    AND TN.DD_EIN_ID = 7 -- CODIGO OBJETIVO
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

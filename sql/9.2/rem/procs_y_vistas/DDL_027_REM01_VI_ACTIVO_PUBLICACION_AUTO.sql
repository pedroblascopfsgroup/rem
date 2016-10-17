 --/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20161015
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL creación de la vista de filtro de activos para publicar automáticamente.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count NUMBER(3); -- Vble. para validar la existencia de las Secuencias.
    table_count NUMBER(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count NUMBER(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count NUMBER(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_TEXT_VISTA VARCHAR2(30 CHAR) := 'V_ACTIVO_PUBLI_AUTO'; -- Vble. auxiliar para almacenar el nombre de la vista.
    V_MSQL VARCHAR2(4000 CHAR);
    CUENTA NUMBER(1); -- Vble. existencia de la vista.
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'MATERIALIZED VIEW';
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('Vista materializada: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('Vista materializada borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('Vista: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('Vista borrada OK');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('Crear nueva vista: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'..');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||' 
	AS
		SELECT
			VISTA.ACT_ID,
			VISTA.ESTADO_PUBLICACION_CODIGO	
			
		FROM
			' || V_ESQUEMA || '.V_BUSQUEDA_PUBLICACION_ACTIVO VISTA,
			' || V_ESQUEMA || '.ACT_ACTIVO ACTIVO

		WHERE
			vista.ADMISION = 1 -- Que el activo tenga el check de admision.
			AND vista.GESTION = 1 -- Que el activo tenga el check de gestion.
			AND vista.PRECIO = 1 -- Que el activo tenga el check de precios.
			AND vista.INFORME_COMERCIAL = 1 -- Que el activo tenga el informe comercial aceptado.
			AND vista.ACT_ID = activo.ACT_ID -- Que el ID de la vista y el activo se correspondan.
			AND activo.ACT_FECHA_IND_PUBLICABLE IS NOT NULL -- Que el activo tenga el check de publicable (fecha publicable).
			AND (vista.ESTADO_PUBLICACION_CODIGO IS NULL OR vista.ESTADO_PUBLICACION_CODIGO NOT IN (''01'', ''03'', ''04'', ''05'')) -- Que el activo no se encuentre en ningun tipo de publicacion ordinaria o despublicado forzado.
		';

  DBMS_OUTPUT.PUT_LINE('Vista creada OK');
  
END;
/

EXIT;
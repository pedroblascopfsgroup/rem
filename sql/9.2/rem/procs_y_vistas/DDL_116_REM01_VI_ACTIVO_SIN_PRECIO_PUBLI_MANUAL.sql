 --/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20161212
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1297
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
    V_TEXT_VISTA VARCHAR2(30 CHAR) := 'V_ACTIVO_SIN_PRECIO_PUBLI_MAN'; -- Vble. auxiliar para almacenar el nombre de la vista.
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
      ACTIVO.ACT_FECHA_IND_PUBLICABLE,
			VISTA.ESTADO_PUBLICACION_CODIGO,
			(SELECT COND.RUINA + COND.PENDIENTE_INSCRIPCION + COND.OBRANUEVA_SINDECLARAR + COND.SIN_TOMA_POSESION_INICIAL + COND.PROINDIVISO + 
			COND.OBRANUEVA_ENCONSTRUCCION + COND.OCUPADO_CONTITULO + COND.TAPIADO + COND.ESTADO_PORTAL_EXTERNO + COND.OCUPADO_SINTITULO +
			COND.DIVHORIZONTAL_NOINSCRITA + NVL2(COND.OTRO, 1, 0) FROM ' || V_ESQUEMA || '.V_COND_DISPONIBILIDAD COND WHERE activo.ACT_ID = cond.ACT_ID) AS CONDICIONADO
			
		FROM
			' || V_ESQUEMA || '.V_BUSQUEDA_PUBLICACION_ACTIVO VISTA,
			' || V_ESQUEMA || '.ACT_RPA_REGLAS_PUBLICA_AUTO REGLA,
			' || V_ESQUEMA || '.ACT_ACTIVO ACTIVO

		WHERE
			VISTA.CARTERA_CODIGO IN (SELECT CRA.DD_CRA_CODIGO FROM DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_ID IN(REGLA.DD_CRA_ID)) -- Donde el activo sea de la cartera que indica la regla.
			AND VISTA.TIPO_ACTIVO_CODIGO IN (SELECT TPA.DD_TPA_CODIGO FROM DD_TPA_TIPO_ACTIVO TPA WHERE TPA.DD_TPA_ID IN (REGLA.DD_TPA_ID)) -- Donde el activo sea del tipo que indica la regla.
			AND VISTA.SUBTIPO_ACTIVO_CODIGO IN (SELECT SAC.DD_SAC_CODIGO FROM DD_SAC_SUBTIPO_ACTIVO SAC WHERE SAC.DD_SAC_ID IN (REGLA.DD_SAC_ID)) -- Donde el activo sea del subtipo que indica la regla.
			AND REGLA.borrado = 0 -- Que la regla no se encuentre borrada.
			AND VISTA.ADMISION = 1 -- Que el activo tenga el check de admision.
			AND VISTA.GESTION = 1 -- Que el activo tenga el check de gestion.
			AND VISTA.PRECIO = 0 -- Que el activo no tenga el check de precios.
			AND VISTA.INFORME_COMERCIAL = 1 -- Que el activo tenga el informe comercial aceptado.
			AND VISTA.ACT_ID = ACTIVO.ACT_ID -- Que el ID de la vista y el activo se correspondan.
			AND (VISTA.ESTADO_PUBLICACION_CODIGO IS NULL OR VISTA.ESTADO_PUBLICACION_CODIGO NOT IN (''01'', ''03'', ''04'', ''05'')) -- Que el activo no se encuentre en ningun tipo de publicacion ordinaria o despublicado forzado.
		';

  DBMS_OUTPUT.PUT_LINE('Vista creada OK');
  
END;
/

EXIT;
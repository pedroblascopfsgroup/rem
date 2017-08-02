 --/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170731
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2583
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
  EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||' (act_id, informe_comercial, act_fecha_ind_publicable, estado_publicacion_codigo, condicionado)
AS
   SELECT vista.act_id, vista.informe_comercial, activo.act_fecha_ind_publicable, vista.estado_publicacion_codigo,
          (SELECT   cond.ruina
                  + cond.pendiente_inscripcion
                  + cond.obranueva_sindeclarar
                  + cond.sin_toma_posesion_inicial
                  + cond.proindiviso
                  + cond.obranueva_enconstruccion
                  + cond.ocupado_contitulo
                  + cond.tapiado
                  + cond.estado_portal_externo
                  + cond.ocupado_sintitulo
                  + cond.divhorizontal_noinscrita
                  + NVL2 (cond.otro, 1, 0)
             FROM ' || V_ESQUEMA || '.v_cond_disponibilidad cond
            WHERE activo.act_id = cond.act_id) AS condicionado
     FROM ' || V_ESQUEMA || '.v_busqueda_publicacion_activo vista, ' || V_ESQUEMA || '.act_rpa_reglas_publica_auto regla, ' || V_ESQUEMA || '.act_activo activo
    WHERE vista.cartera_codigo IN (SELECT cra.dd_cra_codigo
                                     FROM dd_cra_cartera cra
                                    WHERE cra.dd_cra_id IN (regla.dd_cra_id))                                                                  -- Donde el activo sea de la cartera que indica la regla.
      AND vista.tipo_activo_codigo IN (SELECT tpa.dd_tpa_codigo
                                         FROM dd_tpa_tipo_activo tpa
                                        WHERE tpa.dd_tpa_id IN (regla.dd_tpa_id))                                                                   -- Donde el activo sea del tipo que indica la regla.
      AND vista.subtipo_activo_codigo IN (SELECT sac.dd_sac_codigo
                                            FROM dd_sac_subtipo_activo sac
                                           WHERE sac.dd_sac_id IN (regla.dd_sac_id))                                                             -- Donde el activo sea del subtipo que indica la regla.
      AND regla.borrado = 0                                                                                                                                     -- Que la regla no se encuentre borrada.
      AND vista.admision = 1                                                                                                                                -- Que el activo tenga el check de admision.
      AND vista.gestion = 1                                                                                                                                  -- Que el activo tenga el check de gestion.
      AND vista.precio = 0                                                                                                                                -- Que el activo no tenga el check de precios.
	  AND VISTA.INFORME_COMERCIAL = 1 -- Que tenga IC aceptado se evalua directamente en el procedure ACTIVO_PUBLICACION_AUTO
      AND vista.act_id = activo.act_id                                                                                                             -- Que el ID de la vista y el activo se correspondan.
      AND (vista.estado_publicacion_codigo IS NULL OR vista.estado_publicacion_codigo NOT IN (''01'', ''03'', ''04'', ''05'')
          )                                                                                             -- Que el activo no se encuentre en ningun tipo de publicacion ordinaria o despublicado forzado.
      AND activo.borrado = 0

    ';

  DBMS_OUTPUT.PUT_LINE('Vista creada OK');
  
END;
/

EXIT;
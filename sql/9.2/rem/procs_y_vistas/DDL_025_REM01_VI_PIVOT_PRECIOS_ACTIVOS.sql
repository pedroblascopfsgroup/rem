--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20180522
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4118
--## PRODUCTO=NO
--## Finalidad: DDL con vista de ultimo precio por activo. Correccion para quitar los borrados logicos de valoraciones
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_PIVOT_PRECIOS_ACTIVOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_PIVOT_PRECIOS_ACTIVOS...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_PIVOT_PRECIOS_ACTIVOS';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_PIVOT_PRECIOS_ACTIVOS... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_PIVOT_PRECIOS_ACTIVOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_PIVOT_PRECIOS_ACTIVOS...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_PIVOT_PRECIOS_ACTIVOS';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_PIVOT_PRECIOS_ACTIVOS... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.V_PIVOT_PRECIOS_ACTIVOS...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_PIVOT_PRECIOS_ACTIVOS 
	AS
  		with pivot_data as (
			select * from (
				SELECT val.act_id,dd_tpc_codigo, val_fecha_inicio, val_fecha_fin, val_importe
				FROM ' || V_ESQUEMA || '.ACT_activo act
        inner join ' || V_ESQUEMA || '.ACT_VAL_VALORACIONES VAL 
        on val.act_id = act.act_id
        JOIN ' || V_ESQUEMA || '.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID
        WHERE act.borrado = 0
        and VAL.BORRADO = 0))
				select * from pivot_data
				pivot (max(val_fecha_inicio) as F_INI,
				max(val_fecha_fin) as F_FIN,
				max(val_importe) for dd_tpc_codigo in (''01'' as "VNC",
				''02'' as "APROBADO_VENTA_WEB",
				''03'' as "APROBADO_RENTA_WEB",
				''04'' as "MINIMO_AUTORIZADO",
				''07'' as "DESCUENTO_APROBADO",
				''09'' as "VALOR_VPO",
				''11'' as "VALOR_ESTIMADO_VENTA",
				''12'' as "VALOR_ESTIMADO_RENTA",
				''13'' as "DESCUENTO_PUBLICADO",
				''14'' as "VALOR_REF",
				''15'' as "PT",
				''16'' as "VALOR_ASESORADO_LIQ",
				''17'' as "VACBE",
				''18'' as "COSTE_ADIQUISICION",
				''19'' as "FSV_VENTA",
				''20'' as "FSV_RENTA",
				''21'' as "DEUDA_BRUTA",
				''22'' as "VALOR_RAZONABLE"))';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_PIVOT_PRECIOS_ACTIVOS...Creada OK');
  
END;
/

EXIT;

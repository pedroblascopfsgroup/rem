 --/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160912
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL creación de la vista busqueda de proveedores.
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
    V_TEXT_VISTA VARCHAR2(30 CHAR) := 'V_BUSQUEDA_PROVEEDORES'; -- Vble. auxiliar para almacenar el nombre de la vista.
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
			PVE.PVE_ID,
			TEP.DD_TEP_CODIGO AS TIPO_PROVEEDOR_CODIGO,
			TEP.DD_TEP_DESCRIPCION AS TIPO_PROVEEDOR_DESCRIPCION,
			TPR.DD_TPR_CODIGO AS SUBTIPO_PROVEEDOR_CODIGO,
			TPR.DD_TPR_DESCRIPCION AS SUBTIPO_PROVEEDOR_DESCRIPCION,
			PVE.PVE_DOCIDENTIF AS NIF_PROVEEDOR,
			PVE.PVE_NOMBRE AS NOMBRE_PROVEEDOR,
			PVE.PVE_NOMBRE_COMERCIAL AS NOMBRE_COMERCIAL_PROVEEDOR,
			EPR.DD_EPR_CODIGO AS ESTADO_PROVEEDOR_CODIGO,
			EPR.DD_EPR_DESCRIPCION AS ESTADO_PROVEEDOR_DESCRIPCION,
			PVE.PVE_OBSERVACIONES AS OBSERVACIONES_PROVEEDOR,
			PVE.PVE_FECHA_ALTA AS FECHA_ALTA_PROVEEDOR,
			PVE.PVE_FECHA_BAJA AS FECHA_BAJA_PROVEEDOR,
			TPE.DD_TPE_CODIGO AS TIPO_PERSONA_PROVEEDOR_CODIGO,
			CRA.DD_CRA_CODIGO AS CARTERA,
			PVE.PVE_AMBITO AS AMBITO_PROVEEDOR,
			PRV.DD_PRV_CODIGO AS PROVINCIA_PROVEEDOR,
			LOC.DD_LOC_CODIGO AS MUNICIPIO_PROVEEDOR,
			PVE.PVE_CP AS CODIGO_POSTAL_PROVEEDOR,
			PVC.PVC_DOCIDENTIF AS NIF_PERSONA_CONTACTO,
			PVC.PVC_NOMBRE AS NOMBRE_PERSONA_CONTACTO,
			PVE.PVE_HOMOLOGADO AS HOMOLOGADO_PROVEEDOR,
			CPR.DD_CPR_CODIGO AS CALIFICACION_PROVEEDOR,
			PVE.PVE_TOP AS TOP_PROVEEDOR,
			PRO.PRO_NOMBRE AS PROPIETARIO_ACTIVO_VINCULADO
			
		FROM ' || V_ESQUEMA || '.ACT_PVE_PROVEEDOR PVE
		LEFT JOIN ' || V_ESQUEMA || '.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_TEP_TIPO_ENTIDAD_PROVEEDOR TEP ON TEP.DD_TEP_ID = TPR.DD_TEP_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_EPR_ESTADO_PROVEEDOR EPR ON PVE.DD_EPR_ID = EPR.DD_EPR_ID
		LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_TPE_TIPO_PERSONA TPE ON PVE.DD_TPE_ID = TPE.DD_TPE_ID
		LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_PRV_PROVINCIA PRV ON PVE.DD_PRV_ID = PRV.DD_PRV_ID
		LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_LOC_LOCALIDAD LOC ON PVE.DD_LOC_ID = LOC.DD_LOC_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_CPR_CALIFICACION_PROVEEDOR CPR ON PVE.DD_CPR_ID = CPR.DD_CPR_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_PVC_PROVEEDOR_CONTACTO PVC ON PVC.PVE_ID = PVE.PVE_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_ETP_ENTIDAD_PROVEEDOR ETP ON ETP.PVE_ID = PVE.PVE_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_CRA_CARTERA CRA ON ETP.DD_CRA_ID = CRA.DD_CRA_ID
		LEFT JOIN ' || V_ESQUEMA || '.AIN_ACTIVO_INTEGRADO AIN ON PVE.PVE_ID = AIN.PVE_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_PAC_PROPIETARIO_ACTIVO PAC ON AIN.ACT_ID = PAC.ACT_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_PRO_PROPIETARIO PRO ON PAC.PRO_ID = PRO.PRO_ID';

  DBMS_OUTPUT.PUT_LINE('Vista creada OK');
  
END;
/

EXIT;
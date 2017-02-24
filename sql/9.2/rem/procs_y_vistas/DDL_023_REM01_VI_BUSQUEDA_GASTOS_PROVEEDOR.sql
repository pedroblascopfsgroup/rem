--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20161026
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL
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
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_BUSQUEDA_GASTOS_PROVEEDOR' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_BUSQUEDA_GASTOS_PROVEEDOR' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR 
	AS
		SELECT
				GPV.GPV_ID,
				GPV.GPV_NUM_GASTO_HAYA,
				NULL AS ACT_ID,
				NULL AS ACT_NUM_ACTIVO,
				1 AS RANGO, 
			    GPV.GPV_REF_EMISOR,
				GPV.PRG_ID,
		        TGA.DD_TGA_DESCRIPCION,
				TGA.DD_TGA_CODIGO,
				STG.DD_STG_DESCRIPCION,
				STG.DD_STG_CODIGO,
				EGA.DD_EGA_CODIGO,
				EGA.DD_EGA_DESCRIPCION,
				GPV.GPV_CONCEPTO,
				GPV.PVE_ID_EMISOR,
				GPV.GPV_FECHA_EMISION, 
				TPE.DD_TPE_DESCRIPCION,
				TPE.DD_TPE_CODIGO,
				DEG.DD_DEG_DESCRIPCION,
				DEG.DD_DEG_CODIGO,
				GDE.GDE_ID,
				GDE.GDE_IMPORTE_TOTAL,
				GDE.GDE_FECHA_PAGO,
				GDE.GDE_FECHA_TOPE_PAGO,
				EAH.DD_EAH_CODIGO,
				EAH.DD_EAH_DESCRIPCION,
				EAP.DD_EAP_CODIGO,
				EAP.DD_EAP_DESCRIPCION,
				GPV.GPV_NUM_GASTO_GESTORIA,
				NULL AS GGE_AUTORIZACION_PROPIETARIO,
				GPV.GPV_CUBRE_SEGURO,
				TPR.DD_TPR_CODIGO,
				TPR.DD_TPR_DESCRIPCION,
				TEP.DD_TEP_CODIGO,
				TEP.DD_TEP_DESCRIPCION,
				PRG.PRG_NUM_PROVISION,
				PVE.PVE_NOMBRE,
				PVE.PVE_DOCIDENTIF,
				PVE.PVE_COD_UVEM,
				PVE.PVE_COD_REM,
				GGE.GGE_FECHA_ANULACION,
				GGE.GGE_FECHA_RP,
				PRO.PRO_NOMBRE,
				PRO.PRO_DOCIDENTIF,
				(SELECT PVEGEST.PVE_ID FROM ' || V_ESQUEMA || '.ACT_PVE_PROVEEDOR PVEGEST WHERE GPV.PVE_ID_GESTORIA = PVEGEST.PVE_ID) AS PVE_ID_GESTORIA,
		        NULL AS DD_CRA_CODIGO,
		        NULL AS DD_CRA_DESCRIPCION,        
		        NULL AS DD_SCR_CODIGO,
		        NULL AS DD_SCR_DESCRIPCION,
		        GPV.GPV_EXISTE_DOCUMENTO
		
		FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
		LEFT JOIN ' || V_ESQUEMA || '.DD_TGA_TIPOS_GASTO TGA ON GPV.DD_TGA_ID = TGA.DD_TGA_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_STG_SUBTIPOS_GASTO STG ON GPV.DD_STG_ID = STG.DD_STG_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_EGA_ESTADOS_GASTO EGA ON GPV.DD_EGA_ID = EGA.DD_EGA_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_TPE_TIPOS_PERIOCIDAD TPE ON GPV.DD_TPE_ID = TPE.DD_TPE_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_DEG_DESTINATARIOS_GASTO DEG ON GPV.DD_DEG_ID = DEG.DD_DEG_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_PVE_PROVEEDOR PVE ON GPV.PVE_ID_EMISOR = PVE.PVE_ID
		INNER JOIN ' || V_ESQUEMA || '.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GPV.GPV_ID = GDE.GPV_ID
		INNER JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH ON GGE.DD_EAH_ID = EAH.DD_EAH_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_EAP_ESTADOS_AUTORIZ_PROP EAP ON GGE.DD_EAP_ID = EAP.DD_EAP_ID
		LEFT JOIN ' || V_ESQUEMA || '.PRG_PROVISION_GASTOS PRG ON GPV.PRG_ID = PRG.PRG_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_TEP_TIPO_ENTIDAD_PROVEEDOR TEP ON TPR.DD_TEP_ID = TEP.DD_TEP_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
		WHERE GPV.BORRADO = 0';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR...Creada OK');
  
  EXECUTE IMMEDIATE 'COMMENT ON TABLE ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR IS ''VISTA PARA RECOGER LOS GASTOS DE PROVEEDORES''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GPV_ID IS ''Código identificador único del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PRG_ID IS ''Código identificador único de la provisión''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GPV_REF_EMISOR IS ''Número de factura/referencia/liquidación del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TGA_DESCRIPCION IS ''Tipo de gasto Descripción''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TGA_CODIGO IS ''Tipo de gasto Código''';  
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_STG_DESCRIPCION IS ''Subtipo de gasto descripción''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_STG_CODIGO IS ''Subtipo de gasto código''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GPV_CONCEPTO IS ''Concepto del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PVE_ID_EMISOR IS ''Proveedor del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GPV_FECHA_EMISION IS ''Fecha emisión del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TPE_DESCRIPCION IS ''Tipo de periodicidad del gasto descripción''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TPE_CODIGO IS ''Tipo de periodicidad del gasto código''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_DEG_DESCRIPCION IS ''Tipo de destinatario del gasto descripción''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_DEG_CODIGO IS ''Tipo de destinatario del gasto código''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PVE_COD_UVEM IS ''Código de Proveedor''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GDE_ID IS ''Código identificador único del detalle del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GDE_IMPORTE_TOTAL IS ''Importe total del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GDE_FECHA_PAGO IS ''Fecha de pago del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GDE_FECHA_TOPE_PAGO IS ''Fecha tope de pago del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_EAH_CODIGO IS ''Estado autorización Haya código''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_EAH_DESCRIPCION IS ''Estado autorización Haya descripción''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_EAP_CODIGO IS ''Estado autorización Propietario código''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_EAP_DESCRIPCION IS ''Estado autorización Propietario descripción''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GPV_NUM_GASTO_GESTORIA IS ''Número del gasto para la gestoria del gasto.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GGE_AUTORIZACION_PROPIETARIO IS ''Identificador si necesita autorización del propietario.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GPV_CUBRE_SEGURO IS ''Gasto cubierto por seguro..''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PRG_NUM_PROVISION IS ''Número de provisión.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PVE_DOCIDENTIF IS ''Número de documento identificativo del proveedor..''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TPR_CODIGO IS ''Tipo de proveedor codigo.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TPR_DESCRIPCION IS ''Tipo de proveedor descripción..''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TEP_CODIGO IS ''Tipo entidad proveedor código.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TEP_DESCRIPCION IS ''Tipo entidad proveedor descripción.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PVE_NOMBRE IS ''Nombre del proveedor.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GGE_FECHA_ANULACION IS ''Fecha de anulación.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GGE_FECHA_RP IS ''Fecha de retención de pago.''';
  
  DBMS_OUTPUT.PUT_LINE('Creados los comentarios en CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR...Creada OK');
  
END;
/

EXIT;
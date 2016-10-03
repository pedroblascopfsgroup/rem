--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20160921
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
			    GPV.GPV_REF_EMISOR,
				GPV.PRG_ID,
		        TGA.DD_TGA_DESCRIPCION,
				STG.DD_STG_DESCRIPCION,
				GPV.GPV_CONCEPTO,
				GPV.PVE_ID_EMISOR,
				GPV.GPV_FECHA_EMISION,
				TPE.DD_TPE_DESCRIPCION,
				DEG.DD_DEG_DESCRIPCION,
				PVE.PVE_COD_UVEM,
				GDE.GDE_ID,
				GDE.GDE_IMPORTE_TOTAL,
				GDE.GDE_FECHA_PAGO,
				GDE.GDE_FECHA_TOPE_PAGO			
		FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
		LEFT JOIN ' || V_ESQUEMA || '.DD_TGA_TIPOS_GASTO TGA ON GPV.DD_TGA_ID = TGA.DD_TGA_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_STG_SUBTIPOS_GASTO STG ON GPV.DD_STG_ID = STG.DD_STG_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_TPE_TIPOS_PERIOCIDAD TPE ON GPV.DD_TPE_ID = TPE.DD_TPE_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_DEG_DESTINATARIOS_GASTO DEG ON GPV.DD_DEG_ID = DEG.DD_DEG_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_PVE_PROVEEDOR PVE ON GPV.PVE_ID_EMISOR = PVE.PVE_ID
		LEFT JOIN ' || V_ESQUEMA || '.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GPV.GPV_ID = GDE.GPV_ID';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR...Creada OK');
  
  EXECUTE IMMEDIATE 'COMMENT ON TABLE ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR IS ''VISTA PARA RECOGER LOS GASTOS DE PROVEEDORES''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GPV_ID IS ''Código identificador único del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PRG_ID IS ''Código identificador único de la provisión''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GPV_REF_EMISOR IS ''Número de factura/referencia/liquidación del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TGA_DESCRIPCION IS ''Tipo de gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_STG_DESCRIPCION IS ''Subtipo de gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GPV_CONCEPTO IS ''Concepto del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PVE_ID_EMISOR IS ''Proveedor del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GPV_FECHA_EMISION IS ''Fecha emisión del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TPE_DESCRIPCION IS ''Tipo de periodicidad del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_DEG_DESCRIPCION IS ''Tipo de destinatario del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PVE_COD_UVEM IS ''Código de Proveedor''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GDE_ID IS ''Código identificador único del detalle del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GDE_IMPORTE_TOTAL IS ''Importe total del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GDE_FECHA_PAGO IS ''Fecha de pago del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GDE_FECHA_TOPE_PAGO IS ''Fecha tope de pago del gasto''';
  
  
  DBMS_OUTPUT.PUT_LINE('Creados los comentarios en CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR...Creada OK');
  
END;
/

EXIT;
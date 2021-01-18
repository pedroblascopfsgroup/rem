--/*
--##########################################
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20210107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-12661
--## PRODUCTO=NO
--## Finalidad: DDL creación vista VI_BUSQUEDA_GASTOS_PROVEEDOR_E.
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - Sergio Ortuño - 20180904 - REMVIP-1699
--##        0.2 Añadido campo GGE.GGE_MOTIVO_RECHAZO_PROP para motivo de rechazo bankia
--##		    0.3 Carles Molins 	- Campo subcartera
--##		    0.4 Juan Beltrán		- Campo partida presupuestaria
--##		    0.5 Juan Beltrán		- Campos concepto contable y provision fondos 
--##		    0.6 Daniel Algaba		- Adaptación de consulta al nuevo modelo de facturación
--##            0.7 DAP             - Añadir campos
--##		    0.8 Jesus Jativa		- Añadidos campos GLD_PRINCIPAL_SUJETO||GLD_PRINCIPAL_NO_SUJETO||GLD_RECARGO||GLD_INTERES_DEMORA||GLD_COSTAS
--##                                      para HREOS-12661
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Número de errores.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;

BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_BUSQUEDA_GASTOS_PROVEEDOR_E' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR_E...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E';
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR_E... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_BUSQUEDA_GASTOS_PROVEEDOR_E' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR_E...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E';
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR_E... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR_E...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E
	AS
		SELECT
        GPV.GPV_ID||GEN.ENT_ID AS ID_VISTA,
        GPV.GPV_ID,
        GPV.GPV_NUM_GASTO_HAYA,
        GPV.PRG_ID,
        GPV.GPV_CONCEPTO,
        GPV.PVE_ID_EMISOR,
        GPV.GPV_REF_EMISOR,
        GPV.GPV_FECHA_EMISION,
        GPV.GPV_NUM_GASTO_GESTORIA,
        GPV.GPV_CUBRE_SEGURO,
        GPV.GPV_EXISTE_DOCUMENTO,
        NVL(GPV.GPV_ALERTAS, 0) AS GPV_ALERTAS,
        TGA.DD_TGA_DESCRIPCION,
        TGA.DD_TGA_CODIGO,
        STG.DD_STG_DESCRIPCION,
        STG.DD_STG_CODIGO,
        EGA.DD_EGA_CODIGO,
        EGA.DD_EGA_DESCRIPCION,
        TPE.DD_TPE_DESCRIPCION,
        TPE.DD_TPE_CODIGO,
        DEG.DD_DEG_DESCRIPCION,
        DEG.DD_DEG_CODIGO,
        GDE.GDE_ID,
        GDE.GDE_IMPORTE_TOTAL,
        GDE.GDE_FECHA_PAGO,
        GDE.GDE_FECHA_TOPE_PAGO,
        NVL2(GLD.DD_TIT_ID,0,1) AS SUJETO_IMPUESTO_INDIRECTO,
        EAH.DD_EAH_CODIGO,
        EAH.DD_EAH_DESCRIPCION,
        EAP.DD_EAP_CODIGO,
        EAP.DD_EAP_DESCRIPCION,
        TPR.DD_TPR_CODIGO,
        TPR.DD_TPR_DESCRIPCION,
        TEP.DD_TEP_CODIGO,
        TEP.DD_TEP_DESCRIPCION,
        PVE.PVE_NOMBRE,
        PVE.PVE_DOCIDENTIF,
        PVE.PVE_COD_UVEM,
        PVE.PVE_COD_REM,
        GGE.GGE_FECHA_ANULACION,
        GGE.GGE_FECHA_RP,
        GGE.GGE_FECHA_EAH AS FECHA_AUTORIZACION,
        PRO.PRO_NOMBRE,
        PRO.PRO_DOCIDENTIF,
        MRH.DD_MRH_DESCRIPCION AS MOTIVO_RECHAZO,
        GGE.GGE_MOTIVO_RECHAZO_PROP,
        CRA.DD_CRA_CODIGO,
        CRA.DD_CRA_DESCRIPCION,
        SCR.DD_SCR_CODIGO,
        SCR.DD_SCR_DESCRIPCION,
        PVEG.PVE_ID AS PVE_ID_GESTORIA,  
        PVEG.PVE_NOMBRE AS PVE_NOMBRE_GESTORIA,
        PRG.PRG_NUM_PROVISION AS PROVISION_FONDOS,
        GLD.GLD_ID AS ID_LINEA,
        GLD.GLD_CPP_BASE AS PTDA_PRESUPUESTARIA,
        GLD.GLD_CCC_BASE AS CONCEPTO_CONTABLE,
        GLD.GLD_CCC_TASAS CC_TASAS,
        GLD.GLD_CPP_TASAS PP_TASAS,
        GLD.GLD_CCC_RECARGO CC_RECARGO,
        GLD.GLD_CPP_RECARGO PP_RECARGO,
        GLD.GLD_CCC_INTERESES CC_INTERESES,
        GLD.GLD_CPP_INTERESES PP_INTERESES,
        GLD.GLD_SUBCUENTA_BASE SC_BASE,
        GLD.GLD_APARTADO_BASE APDO_BASE,
        GLD.GLD_CAPITULO_BASE CAP_BASE,
        GLD.GLD_SUBCUENTA_RECARGO SC_RECARGO,
        GLD.GLD_APARTADO_RECARGO APDO_RECARGO,
        GLD.GLD_CAPITULO_RECARGO CAP_RECARGO,
        GLD.GLD_SUBCUENTA_TASA SC_TASA,
        GLD.GLD_APARTADO_TASA APDO_TASA,
        GLD.GLD_CAPITULO_TASA CAP_TASA,
        GLD.GLD_SUBCUENTA_INTERESES SC_INTERESES,
        GLD.GLD_APARTADO_INTERESES APDO_INTERESES,
        GLD.GLD_CAPITULO_INTERESES CAP_INTERESES,
        GLD.GLD_PRINCIPAL_SUJETO IMP_PRINCIPAL_SUJETO,
        GLD.GLD_PRINCIPAL_NO_SUJETO IMP_PRINCIPAL_NO_SUJETO,
        GLD.GLD_RECARGO IMP_RECARGO,
        GLD.GLD_INTERES_DEMORA IMP_INTERES_DEMORA,
        GLD.GLD_COSTAS IMP_COSTES_TASAS,
        CASE ENT.DD_ENT_CODIGO
            WHEN ''ACT'' THEN TO_CHAR(ACT.ACT_NUM_ACTIVO)
            WHEN ''GEN'' THEN AGS.AGS_ACTIVO_GENERICO
            ELSE TO_CHAR(GEN.ENT_ID)
        END AS ELEMENTO,
        ENT.DD_ENT_DESCRIPCION,
        ENT.DD_ENT_CODIGO,
        GEN.GLD_PARTICIPACION_GASTO,
        GEN.GLD_REFERENCIA_CATASTRAL
    FROM '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV
    JOIN '|| V_ESQUEMA ||'.DD_TGA_TIPOS_GASTO TGA ON GPV.DD_TGA_ID = TGA.DD_TGA_ID
        AND TGA.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.DD_EGA_ESTADOS_GASTO EGA ON GPV.DD_EGA_ID = EGA.DD_EGA_ID
        AND EGA.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.DD_DEG_DESTINATARIOS_GASTO DEG ON GPV.DD_DEG_ID = DEG.DD_DEG_ID
        AND DEG.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE ON GPV.PVE_ID_EMISOR = PVE.PVE_ID
        AND PVE.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GPV.GPV_ID = GDE.GPV_ID
        AND GDE.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID
        AND GGE.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
        AND PRO.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
        AND CRA.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON GPV.DD_TPE_ID = TPE.DD_TPE_ID
        AND TPE.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
        AND GLD.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO STG ON GLD.DD_STG_ID = STG.DD_STG_ID
        AND STG.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
        AND GEN.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_ENT_ENTIDAD_GASTO ENT ON GEN.DD_ENT_ID = ENT.DD_ENT_ID
        AND ENT.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GEN.ENT_ID
        AND ENT.DD_ENT_CODIGO = ''ACT''
        AND ACT.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.ACT_AGS_ACTIVO_GENERICO_STG AGS ON AGS.AGS_ID = GEN.ENT_ID
        AND ENT.DD_ENT_CODIGO = ''GEN''
        AND AGS.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVEG ON GPV.PVE_ID_GESTORIA = PVEG.PVE_ID
        AND PVEG.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH ON GGE.DD_EAH_ID = EAH.DD_EAH_ID
        AND EAH.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_EAP_ESTADOS_AUTORIZ_PROP EAP ON GGE.DD_EAP_ID = EAP.DD_EAP_ID
        AND EAP.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID
        AND TPR.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_TEP_TIPO_ENTIDAD_PROVEEDOR TEP ON TPR.DD_TEP_ID = TEP.DD_TEP_ID
        AND TEP.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
        AND SCR.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_MRH_MOTIVOS_RECHAZO_HAYA MRH ON GGE.DD_MRH_ID = MRH.DD_MRH_ID
        AND MRH.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.PRG_PROVISION_GASTOS PRG ON PRG.PRG_ID = GPV.PRG_ID
        AND PRG.BORRADO = 0
    WHERE GPV.BORRADO = 0';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR_E...Creada OK');

  EXECUTE IMMEDIATE 'COMMENT ON TABLE ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E IS ''VISTA PARA RECOGER LOS GASTOS DE PROVEEDORES''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GPV_ID IS ''Código identificador único del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PRG_ID IS ''Código identificador único de la provisión''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GPV_REF_EMISOR IS ''Número de factura/referencia/liquidación del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_TGA_DESCRIPCION IS ''Tipo de gasto Descripción''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_TGA_CODIGO IS ''Tipo de gasto Código''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_STG_DESCRIPCION IS ''Subtipo de gasto descripción''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_STG_CODIGO IS ''Subtipo de gasto código''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GPV_CONCEPTO IS ''Concepto del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PVE_ID_EMISOR IS ''Proveedor del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GPV_FECHA_EMISION IS ''Fecha emisión del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_TPE_DESCRIPCION IS ''Tipo de periodicidad del gasto descripción''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_TPE_CODIGO IS ''Tipo de periodicidad del gasto código''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_DEG_DESCRIPCION IS ''Tipo de destinatario del gasto descripción''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_DEG_CODIGO IS ''Tipo de destinatario del gasto código''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PVE_COD_UVEM IS ''Código de Proveedor''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GDE_ID IS ''Código identificador único del detalle del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GDE_IMPORTE_TOTAL IS ''Importe total del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GDE_FECHA_PAGO IS ''Fecha de pago del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GDE_FECHA_TOPE_PAGO IS ''Fecha tope de pago del gasto''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_EAH_CODIGO IS ''Estado autorización Haya código''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_EAH_DESCRIPCION IS ''Estado autorización Haya descripción''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_EAP_CODIGO IS ''Estado autorización Propietario código''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_EAP_DESCRIPCION IS ''Estado autorización Propietario descripción''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GPV_NUM_GASTO_GESTORIA IS ''Número del gasto para la gestoria del gasto.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GPV_CUBRE_SEGURO IS ''Gasto cubierto por seguro..''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PVE_DOCIDENTIF IS ''Número de documento identificativo del proveedor..''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_TPR_CODIGO IS ''Tipo de proveedor codigo.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_TPR_DESCRIPCION IS ''Tipo de proveedor descripción..''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_TEP_CODIGO IS ''Tipo entidad proveedor código.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_TEP_DESCRIPCION IS ''Tipo entidad proveedor descripción.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PVE_NOMBRE IS ''Nombre del proveedor.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GGE_FECHA_ANULACION IS ''Fecha de anulación.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GGE_FECHA_RP IS ''Fecha de retención de pago.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GPV_NUM_GASTO_HAYA IS ''Número de gasto HAYA.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GGE_FECHA_ANULACION IS ''Fecha de acnulación.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PVE_COD_REM IS ''Código REM de proveedor.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PRO_NOMBRE IS ''Nombre del propietario.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PRO_DOCIDENTIF IS ''Documento identificativo del propietario.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_CRA_CODIGO IS ''Código de la cartera del activo.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_CRA_DESCRIPCION IS ''Descripción de la cartera del activo.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_SCR_CODIGO IS ''Código de la subcartera del activo.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_SCR_DESCRIPCION IS ''Descripción de la subcartera del activo.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.GPV_EXISTE_DOCUMENTO IS ''Indica si existe documento.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PVE_ID_GESTORIA IS ''ID de proveedor de tipo gestoría asociado al gasto.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PVE_NOMBRE_GESTORIA IS ''Nombre de proveedor de tipo gestoría asociado al gasto.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.SUJETO_IMPUESTO_INDIRECTO IS ''Indica si el gasto está sujeto a impuestos indirectos.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_EGA_CODIGO IS ''Código de estado del gasto.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.DD_EGA_DESCRIPCION IS ''Descripcion de estado del gasto.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.ELEMENTO IS ''Número del activo/genérico/promoción.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PTDA_PRESUPUESTARIA IS ''Partida presupuestaria.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.CONCEPTO_CONTABLE IS ''Cuenta contable.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PROVISION_FONDOS IS ''Provision fondos.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.ID_LINEA IS ''Identificador de la línea de detalle.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.CC_TASAS IS ''Cuenta contable de tasas y costas.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PP_TASAS IS ''Partida presupuestaria de tasas y costas.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.CC_RECARGO IS ''Cuenta contable de recargos.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PP_RECARGO IS ''Partida presupuestaria de recargos.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.CC_INTERESES IS ''Cuenta contable de intereses.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.PP_INTERESES IS ''Partida presupuestaria de intereses.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.SC_BASE IS ''Subcuenta contable base.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.APDO_BASE IS ''Apartado base.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.CAP_BASE IS ''Capítulo base.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.SC_RECARGO IS ''Subcuenta contable de recargos.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.APDO_RECARGO IS ''Apartado de recargos.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.CAP_RECARGO IS ''Capítulo de recargos.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.SC_TASA IS ''Subcuenta contable de tasas y costas.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.APDO_TASA IS ''Apartado de tasas y costas.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.CAP_TASA IS ''Capítulo de tasas y costas.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.SC_INTERESES IS ''Subcuenta contable de intereses.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.APDO_INTERESES IS ''Apartado de intereses.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.CAP_INTERESES IS ''Capítulo de intereses.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.IMP_PRINCIPAL_SUJETO IS ''Importe principal sujeto a impuestos.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.IMP_PRINCIPAL_NO_SUJETO IS ''Importe principal no sujeto a impuestos.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.IMP_RECARGO IS ''Importe de recargo.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.IMP_INTERES_DEMORA IS ''Importe de intereses por demora.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR_E.IMP_COSTES_TASAS IS ''Importe de tasas y costas.''';


  DBMS_OUTPUT.PUT_LINE('Creados los comentarios en CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR_E...Creada OK');

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

--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20201008
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-10618
--## PRODUCTO=NO
--## Finalidad: DDL creación vista VI_BUSQUEDA_GASTOS_PROVEEDOR.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - Juanjo Arbona - 20180411 - REMVIP-471
--##        0.2 Añadido campo GGE.GGE_MOTIVO_RECHAZO_PROP para motivo de rechazo bankia - Victor Olivares - 20190304 - HREOS-5384
--##        0.3 Añadido campo TBJ_GPV.TBJ_NUM_TRABAJO para filtrar busqueda por numTrabajo - HREOS-8159
--##        0.4 Adaptación de consulta al nuevo modelo de facturación - Daniel Algaba - HREOS-10618
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
		    GPV.GPV_ID
		    , GPV.GPV_NUM_GASTO_HAYA
		    , GPV.PRG_ID
		    , GPV.GPV_CONCEPTO
		    , GPV.PVE_ID_EMISOR
		    , GPV.GPV_REF_EMISOR
		    , GPV.GPV_FECHA_EMISION
		    , GPV.GPV_NUM_GASTO_GESTORIA
		    , GPV.GPV_CUBRE_SEGURO
		    , GPV.GPV_EXISTE_DOCUMENTO
		    , NVL(GPV.GPV_ALERTAS, 0) AS GPV_ALERTAS
		    , TGA.DD_TGA_DESCRIPCION
		    , TGA.DD_TGA_CODIGO
		    , STG.DD_STG_DESCRIPCION
		    , STG.DD_STG_CODIGO
		    , EGA.DD_EGA_CODIGO
		    , EGA.DD_EGA_DESCRIPCION
		    , TPE.DD_TPE_DESCRIPCION
		    , TPE.DD_TPE_CODIGO
		    , DEG.DD_DEG_DESCRIPCION
		    , DEG.DD_DEG_CODIGO
		    , GDE.GDE_ID
		    , GDE.GDE_IMPORTE_TOTAL
		    , GDE.GDE_FECHA_PAGO
		    , GDE.GDE_FECHA_TOPE_PAGO
		    , GLD_TIT.DD_TIT_ID AS SUJETO_IMPUESTO_INDIRECTO
		    , EAH.DD_EAH_CODIGO
		    , EAH.DD_EAH_DESCRIPCION
		    , EAP.DD_EAP_CODIGO
		    , EAP.DD_EAP_DESCRIPCION
		    , TPR.DD_TPR_CODIGO
		    , TPR.DD_TPR_DESCRIPCION
		    , TEP.DD_TEP_CODIGO
		    , TEP.DD_TEP_DESCRIPCION
		    , PVE.PVE_NOMBRE
		    , PVE.PVE_DOCIDENTIF
		    , PVE.PVE_COD_UVEM
		    , PVE.PVE_COD_REM
		    , GGE.GGE_FECHA_ANULACION
		    , GGE.GGE_FECHA_RP
		    , GGE.GGE_FECHA_EAH AS FECHA_AUTORIZACION
		    , PRO.PRO_NOMBRE
		    , PRO.PRO_DOCIDENTIF
		    , MRH.DD_MRH_DESCRIPCION AS MOTIVO_RECHAZO
		    , GGE.GGE_MOTIVO_RECHAZO_PROP
		    , CRA.DD_CRA_CODIGO
		    , CRA.DD_CRA_DESCRIPCION
		    , PVEG.PVE_ID AS PVE_ID_GESTORIA 
		    , PVEG.PVE_NOMBRE AS PVE_NOMBRE_GESTORIA
		    , TBJ.TBJ_NUM_TRABAJO AS TBJ_NUM_TRABAJO
		FROM '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV
		INNER JOIN '|| V_ESQUEMA ||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GPV.GPV_ID = GDE.GPV_ID
		    AND GDE.BORRADO = 0
		INNER JOIN '|| V_ESQUEMA ||'.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID
		    AND GGE.BORRADO = 0
		INNER JOIN '|| V_ESQUEMA ||'.DD_TGA_TIPOS_GASTO TGA ON GPV.DD_TGA_ID = TGA.DD_TGA_ID
		    AND TGA.BORRADO = 0
		INNER JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
		    AND PRO.BORRADO = 0
		INNER JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
		    AND CRA.BORRADO = 0
		INNER JOIN '|| V_ESQUEMA ||'.DD_EGA_ESTADOS_GASTO EGA ON GPV.DD_EGA_ID = EGA.DD_EGA_ID
		    AND EGA.BORRADO = 0
		INNER JOIN '|| V_ESQUEMA ||'.DD_DEG_DESTINATARIOS_GASTO DEG ON GPV.DD_DEG_ID = DEG.DD_DEG_ID
		    AND DEG.BORRADO = 0
		INNER JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE ON GPV.PVE_ID_EMISOR = PVE.PVE_ID
		    AND PVE.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID
		    AND TPR.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.DD_TEP_TIPO_ENTIDAD_PROVEEDOR TEP ON TPR.DD_TEP_ID = TEP.DD_TEP_ID
		    AND TEP.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON GPV.DD_TPE_ID = TPE.DD_TPE_ID
		    AND TPE.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVEG ON GPV.PVE_ID_GESTORIA = PVEG.PVE_ID
		    AND PVEG.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH ON GGE.DD_EAH_ID = EAH.DD_EAH_ID
		    AND EAH.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.DD_EAP_ESTADOS_AUTORIZ_PROP EAP ON GGE.DD_EAP_ID = EAP.DD_EAP_ID
		    AND EAP.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
		    AND GLD.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO STG ON GLD.DD_STG_ID = STG.DD_STG_ID
		    AND STG.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.GLD_TBJ GLDTBJ ON GLDTBJ.GLD_ID = GLD.GLD_ID
		    AND GLDTBJ.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ ON GLDTBJ.TBJ_ID = TBJ.TBJ_ID
		    AND TBJ.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.DD_MRH_MOTIVOS_RECHAZO_HAYA MRH ON GGE.DD_MRH_ID = MRH.DD_MRH_ID
		    AND MRH.BORRADO = 0
		LEFT JOIN (
		    SELECT GLD.GPV_ID, NVL2(GLD.DD_TIT_ID, 1, 0) DD_TIT_ID, ROW_NUMBER() OVER(PARTITION BY GLD.GPV_ID ORDER BY NVL2(GLD.DD_TIT_ID, 1, 0) DESC) RN
		    FROM '|| V_ESQUEMA ||'.GLD_GASTOS_LINEA_DETALLE GLD
		    WHERE GLD.BORRADO = 0
		    ) GLD_TIT ON GLD_TIT.GPV_ID = GPV.GPV_ID
		        AND GLD_TIT.RN = 1
		WHERE GPV.BORRADO = 0';
    
    --##########################################
    -- NOTA IMPORTANTE!!!: SE QUITA EL JOIN CON GPV_ACT POR RENDIMIENTO, Y SE AÑADE AL FILTRAR SI ES NECESARIO. 
    -- EN CASO DE TENER QUE AÑADIRLO DE NUEVO HABRÁ QUE HACER MOFIFICACIONES TAMBIEN A LA HORA DE FILTRAR
    --##########################################

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
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GPV_CUBRE_SEGURO IS ''Gasto cubierto por seguro..''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PVE_DOCIDENTIF IS ''Número de documento identificativo del proveedor..''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TPR_CODIGO IS ''Tipo de proveedor codigo.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TPR_DESCRIPCION IS ''Tipo de proveedor descripción..''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TEP_CODIGO IS ''Tipo entidad proveedor código.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_TEP_DESCRIPCION IS ''Tipo entidad proveedor descripción.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PVE_NOMBRE IS ''Nombre del proveedor.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GGE_FECHA_ANULACION IS ''Fecha de anulación.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GGE_FECHA_RP IS ''Fecha de retención de pago.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GPV_NUM_GASTO_HAYA IS ''Número de gasto HAYA.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GGE_FECHA_ANULACION IS ''Fecha de acnulación.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PVE_COD_REM IS ''Código REM de proveedor.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PRO_NOMBRE IS ''Nombre del propietario.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PRO_DOCIDENTIF IS ''Documento identificativo del propietario.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_CRA_CODIGO IS ''Código de la cartera del activo.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_CRA_DESCRIPCION IS ''Descripción de la cartera del activo.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.GPV_EXISTE_DOCUMENTO IS ''Indica si existe documento.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PVE_ID_GESTORIA IS ''ID de proveedor de tipo gestoría asociado al gasto.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.PVE_NOMBRE_GESTORIA IS ''Nombre de proveedor de tipo gestoría asociado al gasto.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.SUJETO_IMPUESTO_INDIRECTO IS ''Indica si el gasto está sujeto a impuestos indirectos.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_EGA_CODIGO IS ''Código de estado del gasto.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.DD_EGA_DESCRIPCION IS ''Descripcion de estado del gasto.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_PROVEEDOR.TBJ_NUM_TRABAJO IS ''Numero del trabajo relacionado con el gasto.''';
  
  DBMS_OUTPUT.PUT_LINE('Creados los comentarios en CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_PROVEEDOR...Creada OK');

	EXCEPTION
	WHEN OTHERS THEN 
	DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
	DBMS_OUTPUT.put_line('-----------------------------------------------------------');
	DBMS_OUTPUT.put_line(SQLERRM);
	DBMS_OUTPUT.put_line(V_MSQL);
	ROLLBACK;
	RAISE;   

END;
/

EXIT;

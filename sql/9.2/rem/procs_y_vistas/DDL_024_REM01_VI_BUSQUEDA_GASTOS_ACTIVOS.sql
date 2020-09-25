--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200918
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-8070
--## PRODUCTO=NO
--## Finalidad: DDL
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Añadido sumatorio con la tabla Prinex
--##        0.3 Nuevo calculo porcentaje participacion activos de trabajos en gastos
--##		0.4 Sumar participación y porcentaje mismo activo en gasto
--##		0.5 Añadir filtros de borrado
--##		0.6 REMVIP-8070 Error división entre 0
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_BUSQUEDA_GASTOS_ACTIVOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_ACTIVOS...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_ACTIVOS';
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_ACTIVOS... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_BUSQUEDA_GASTOS_ACTIVOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_ACTIVOS...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_ACTIVOS';
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_ACTIVOS... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_ACTIVOS...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_ACTIVOS
	AS
	SELECT 
		GPV_ACT_ID,
	    GPV_ID,
	    ACT_ID,
	    SUM(GPV_PARTICIPACION_GASTO) AS GPV_PARTICIPACION_GASTO,
	    ACT_NUM_ACTIVO,
	    DIRECCION,
	   SUM(IMPORTE_PROPORCIONAL_TOTAL) AS IMPORTE_PROPORCIONAL_TOTAL,
	    REFERENCIAS,
	    GPV_REFERENCIA_CATASTRAL,
	    DD_SAC_CODIGO,
	    DD_SAC_DESCRIPCION,
	    PVE_ID_EMISOR,
	    GPV_REF_EMISOR,
	    DD_TGA_CODIGO,
	    DD_TGA_DESCRIPCION,
	    DD_STG_CODIGO,
	    DD_STG_DESCRIPCION,
	    GPV_CONCEPTO,
	    DD_TPE_CODIGO,
	    DD_TPE_DESCRIPCION,
	    GPV_FECHA_EMISION,
	    GGE_OBSERVACIONES,
	    GPV_NUM_GASTO_HAYA,
	    GDE_FECHA_PAGO,
	    GDE_IMPORTE_TOTAL,
	    DD_EGA_CODIGO,
	    DD_EGA_DESCRIPCION
	FROM (SELECT 
      	GPV_ACT_ID,
	    GPV_ID,
	    ACT_ID,      
	    GPV_PARTICIPACION_GASTO,
	    ACT_NUM_ACTIVO,
	    DIRECCION,
	   (GDE_IMPORTE_TOTAL * GPV_PARTICIPACION_GASTO) / 100 AS IMPORTE_PROPORCIONAL_TOTAL,
	    REFERENCIAS,
	    GPV_REFERENCIA_CATASTRAL,
	    DD_SAC_CODIGO,
	    DD_SAC_DESCRIPCION,
	    PVE_ID_EMISOR,
	    GPV_REF_EMISOR,
	    DD_TGA_CODIGO,
	    DD_TGA_DESCRIPCION,
	    DD_STG_CODIGO,
	    DD_STG_DESCRIPCION,
	    GPV_CONCEPTO,
	    DD_TPE_CODIGO,
	    DD_TPE_DESCRIPCION,
	    GPV_FECHA_EMISION,
	    GGE_OBSERVACIONES,
	    GPV_NUM_GASTO_HAYA,
	    GDE_FECHA_PAGO,
	    GDE_IMPORTE_TOTAL,
	    DD_EGA_CODIGO,
	    DD_EGA_DESCRIPCION
      FROM (
SELECT
	    GPV_ACT_ID,
	    GPV_ID,
	    ACT_ID,
      	CASE WHEN GDE_IMPORTE_TOTAL = 0 THEN 0
             ELSE COALESCE((((ACT_TBJ_PARTICIPACION / 100) * TBJ_IMPORTE_TOTAL) / GDE_IMPORTE_TOTAL * 100), GPV_PARTICIPACION_GASTO) 
           END GPV_PARTICIPACION_GASTO,
	    ACT_NUM_ACTIVO,
	    DIRECCION,
	    REFERENCIAS,
	    GPV_REFERENCIA_CATASTRAL,
	    DD_SAC_CODIGO,
	    DD_SAC_DESCRIPCION,
	    PVE_ID_EMISOR,
	    GPV_REF_EMISOR,
	    DD_TGA_CODIGO,
	    DD_TGA_DESCRIPCION,
	    DD_STG_CODIGO,
	    DD_STG_DESCRIPCION,
	    GPV_CONCEPTO,
	    DD_TPE_CODIGO,
	    DD_TPE_DESCRIPCION,
	    GPV_FECHA_EMISION,
	    GGE_OBSERVACIONES,
	    GPV_NUM_GASTO_HAYA,
	    GDE_FECHA_PAGO,
	    GDE_IMPORTE_TOTAL,
	    DD_EGA_CODIGO,
	    DD_EGA_DESCRIPCION
	FROM(
		SELECT 
				GPVACT.GPV_ACT_ID,
				GPVACT.GPV_ID,
				GPVACT.ACT_ID,
			  GPVACT.GPV_PARTICIPACION_GASTO,
				ACT.ACT_NUM_ACTIVO,
				BIELOC.BIE_LOC_NOMBRE_VIA || '' '' || BIELOC.BIE_LOC_NUMERO_DOMICILIO || '' - '' || BIELOC.BIE_LOC_COD_POST AS DIRECCION,
				REFERENCIAS,
				GPVACT.GPV_REFERENCIA_CATASTRAL,
				SAC.DD_SAC_CODIGO,
				SAC.DD_SAC_DESCRIPCION,
				GPV.PVE_ID_EMISOR,
				GPV.GPV_REF_EMISOR,
				TGA.DD_TGA_CODIGO,
				TGA.DD_TGA_DESCRIPCION,
				STG.DD_STG_CODIGO,
				STG.DD_STG_DESCRIPCION,
				GPV.GPV_CONCEPTO,
				TPE.DD_TPE_CODIGO,
				TPE.DD_TPE_DESCRIPCION,
				GPV.GPV_FECHA_EMISION,
				GGE.GGE_OBSERVACIONES,
				GPV.GPV_NUM_GASTO_HAYA,
				GDE.GDE_FECHA_PAGO,
                		NVL(NVL(GDE.GDE_PRINCIPAL_SUJETO,GDE.GDE_PRINCIPAL_NO_SUJETO),0)+NVL((SELECT SUM(GPL.GPL_IMPORTE_GASTO)
                                    FROM '||V_ESQUEMA||'.GPL_GASTOS_PRINEX_LBK GPL
                                     WHERE GPL.GPV_ID = GPVACT.GPV_ID
                                     AND GPL.ACT_ID IS NOT NULL
                                     AND GPL.GPL_IMPORTE_GASTO IS NOT NULL
                                     GROUP BY GPL.GPV_ID
                                ),0) GDE_IMPORTE_TOTAL,
				EGA.DD_EGA_CODIGO,
				EGA.DD_EGA_DESCRIPCION,
        ATBJ.ACT_TBJ_PARTICIPACION,
        TBJ.TBJ_IMPORTE_TOTAL
		FROM '||V_ESQUEMA||'.GPV_ACT GPVACT
		LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GPVACT.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIELOC ON BIELOC.BIE_ID = ACT.BIE_ID AND BIELOC.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC ON ACT.DD_SAC_ID = SAC.DD_SAC_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ACTICO ON ACT.ACT_ID = ACTICO.ACT_ID AND ACTICO.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GPVACT.GPV_ID AND GPV.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GPVACT.GPV_ID = GDE.GPV_ID AND GDE.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPVACT.GPV_ID AND GGE.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON GPV.DD_TGA_ID = TGA.DD_TGA_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON GPV.DD_STG_ID = STG.DD_STG_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON GPV.DD_TPE_ID = TPE.DD_TPE_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON GPV.DD_EGA_ID = EGA.DD_EGA_ID
	    LEFT JOIN '||V_ESQUEMA||'.GPV_TBJ GTBJ ON GTBJ.GPV_ID = GPV.GPV_ID AND GTBJ.BORRADO = 0
	    LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ ATBJ ON ATBJ.TBJ_ID = GTBJ.TBJ_ID
	    LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = GTBJ.TBJ_ID AND TBJ.BORRADO = 0
		LEFT JOIN (SELECT ACT_ID, LISTAGG(CAT_REF_CATASTRAL,'','') WITHIN GROUP (ORDER BY CAT_ID) AS REFERENCIAS FROM '||V_ESQUEMA||'.ACT_CAT_CATASTRO GROUP BY ACT_ID) REF ON REF.ACT_ID=ACT.ACT_ID
    WHERE ATBJ.ACT_ID = ACT.ACT_ID OR GTBJ.GPV_ID IS NULL
		))) 
	GROUP BY GPV_ACT_ID,
	    GPV_ID,
	    ACT_ID,
	    ACT_NUM_ACTIVO,
	    DIRECCION,
	    REFERENCIAS,
	    GPV_REFERENCIA_CATASTRAL,
	    DD_SAC_CODIGO,
	    DD_SAC_DESCRIPCION,
	    PVE_ID_EMISOR,
	    GPV_REF_EMISOR,
	    DD_TGA_CODIGO,
	    DD_TGA_DESCRIPCION,
	    DD_STG_CODIGO,
	    DD_STG_DESCRIPCION,
	    GPV_CONCEPTO,
	    DD_TPE_CODIGO,
	    DD_TPE_DESCRIPCION,
	    GPV_FECHA_EMISION,
	    GGE_OBSERVACIONES,
	    GPV_NUM_GASTO_HAYA,
	    GDE_FECHA_PAGO,
	    GDE_IMPORTE_TOTAL,
	    DD_EGA_CODIGO,
	    DD_EGA_DESCRIPCION';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_ACTIVOS...Creada OK');

 -- EXECUTE IMMEDIATE 'COMMENT ON TABLE ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_ACTIVOS IS ''VISTA PARA RECOGER LOS GASTOS DE PROVEEDORES''';
 -- EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTOS_ACTIVOS.GPV_ID IS ''Código identificador único del gasto''';


  DBMS_OUTPUT.PUT_LINE('Creados los comentarios en CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTOS_ACTIVOS...Creada OK');
EXCEPTION

   WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;

        RAISE; 

END;
/

EXIT;

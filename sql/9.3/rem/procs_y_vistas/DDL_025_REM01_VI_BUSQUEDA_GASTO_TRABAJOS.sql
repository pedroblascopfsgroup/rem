--/*
--##########################################
--## AUTOR= IVAN REPISO
--## FECHA_CREACION=20210325
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-9321
--## PRODUCTO=NO
--## Finalidad: Crear la vista VI_BUSQUEDA_GASTO_TRABAJOS.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Sin borrado en asociación gasto-trabajo.
--##        0.3 Adaptación de consulta al nuevo modelo de facturación - Daniel Algaba - HREOS-10618
--##		0.4 Adaptación de consulta para ver el tipo de línea y los importes - Lara Pablo - HREOS-11041
--##        0.5 Importe de trabajos: si emisor Haya IMPORTE_TOTAL, sino IMPORTE_PRESUPUESTO - IVAN REPISO - REMVIP-9321
--##########################################
--*/


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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_BUSQUEDA_GASTO_TRABAJOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTO_TRABAJOS...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTO_TRABAJOS';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTO_TRABAJOS... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_BUSQUEDA_GASTO_TRABAJOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTO_TRABAJOS...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTO_TRABAJOS';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTO_TRABAJOS... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTO_TRABAJOS...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.VI_BUSQUEDA_GASTO_TRABAJOS 
	AS
		SELECT
				GLDTBJ.GLD_TBJ_ID GPV_TBJ_ID,
				GLD.GPV_ID,
				GLDTBJ.TBJ_ID,
				TBJ.TBJ_NUM_TRABAJO,
				TBJ.TBJ_CUBRE_SEGURO,
				 CASE WHEN( PVE.PVE_DOCIDENTIF = ''A86744349'')
                    THEN TBJ.TBJ_IMPORTE_TOTAL
                    ELSE TBJ.TBJ_IMPORTE_PRESUPUESTO
                END TBJ_IMPORTE_TOTAL,
				TBJ.TBJ_FECHA_EJECUTADO,
				TBJ.TBJ_FECHA_SOLICITUD,
				TBJ.TBJ_FECHA_CIERRE_ECONOMICO,
				TTR.DD_TTR_CODIGO,
				TTR.DD_TTR_DESCRIPCION,
				STR.DD_STR_CODIGO,
				STR.DD_STR_DESCRIPCION,
				GLD.GLD_ID,
				(STG.DD_STG_DESCRIPCION || '' '' || NVL(TIT.DD_TIT_DESCRIPCION, '' '') || '' - '' || NVL2(GLD.GLD_IMP_IND_TIPO_IMPOSITIVO, TO_CHAR(GLD.GLD_IMP_IND_TIPO_IMPOSITIVO) || '' %'', '' - '')) DESCRIPCION_LINEA    
										
		FROM ' || V_ESQUEMA || '.GLD_GASTOS_LINEA_DETALLE GLD
        JOIN ' || V_ESQUEMA || '.GLD_TBJ GLDTBJ ON GLD.GLD_ID = GLDTBJ.GLD_ID AND GLDTBJ.BORRADO = 0
		JOIN ' || V_ESQUEMA || '.ACT_TBJ_TRABAJO TBJ ON GLDTBJ.TBJ_ID = TBJ.TBJ_ID AND TBJ.BORRADO = 0
		JOIN ' || V_ESQUEMA || '.DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_ID = TBJ.DD_TTR_ID
		JOIN ' || V_ESQUEMA || '.DD_STR_SUBTIPO_TRABAJO STR ON STR.DD_STR_ID = TBJ.DD_STR_ID
		JOIN ' || V_ESQUEMA || '.DD_STG_SUBTIPOS_GASTO STG ON GLD.DD_STG_ID = STG.DD_STG_ID AND STG.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.DD_TIT_TIPOS_IMPUESTO TIT ON GLD.DD_TIT_ID = TIT.DD_TIT_ID AND TIT.BORRADO = 0
 		JOIN ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV ON GLD.GPV_ID = GPV.GPV_ID AND GPV.BORRADO = 0
    JOIN ' || V_ESQUEMA || '.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = GPV.PVE_ID_EMISOR AND PVE.BORRADO = 0
        LEFT JOIN ' || V_ESQUEMA || '.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_ID = GPV.DD_DEG_ID AND DEG.BORRADO = 0 
		WHERE GLD.BORRADO = 0
    ';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_BUSQUEDA_GASTO_TRABAJOS...Creada OK');
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
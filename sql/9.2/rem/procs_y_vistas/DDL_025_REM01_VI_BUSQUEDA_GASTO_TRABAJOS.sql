--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200723
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-10618
--## PRODUCTO=NO
--## Finalidad: Crear la vista VI_BUSQUEDA_GASTO_TRABAJOS.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Sin borrado en asociación gasto-trabajo.
--##        0.3 Adaptación de consulta al nuevo modelo de facturación - Daniel Algaba - HREOS-10618
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
				TBJ.TBJ_IMPORTE_TOTAL,
				TBJ.TBJ_FECHA_EJECUTADO,
				TBJ.TBJ_FECHA_SOLICITUD,
				TBJ.TBJ_FECHA_CIERRE_ECONOMICO,
				TTR.DD_TTR_CODIGO,
				TTR.DD_TTR_DESCRIPCION,
				STR.DD_STR_CODIGO,
				STR.DD_STR_DESCRIPCION
										
		FROM ' || V_ESQUEMA || '.GLD_GASTOS_LINEA_DETALLE GLD
        INNER JOIN ' || V_ESQUEMA || '.GLD_TBJ GLDTBJ ON GLD.GLD_ID = GLDTBJ.GLD_ID AND GLDTBJ.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.ACT_TBJ_TRABAJO TBJ ON GLDTBJ.TBJ_ID = TBJ.TBJ_ID AND TBJ.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_ID = TBJ.DD_TTR_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_STR_SUBTIPO_TRABAJO STR ON STR.DD_STR_ID = TBJ.DD_STR_ID
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
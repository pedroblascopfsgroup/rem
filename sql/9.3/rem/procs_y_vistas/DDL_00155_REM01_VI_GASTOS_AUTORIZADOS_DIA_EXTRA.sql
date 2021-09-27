--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210920
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10467
--## PRODUCTO=SI
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
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
	V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
    V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
	V_TABLA VARCHAR2(30 CHAR) := 'V_GASTOS_AUTORIZADOS_DIA_EXTRA';
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_GASTOS_AUTORIZADOS_DIA_EXTRA...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_GASTOS_AUTORIZADOS_DIA_EXTRA AS
	SELECT DISTINCT
	V_DIA.ID_GASTO_HAYA,
	V_DIA.ID_HAYA,
	BBVA.BBVA_LINEA_FACTURA AS LINEA_FACTURA,
	((GLD.GLD_IMPORTE_TOTAL * GLDENT.GLD_PARTICIPACION_GASTO)/100) AS IMPORTE_PROPORCIONAL_GASTO,
	AGR.AGR_NUM_AGRUP_REM AS ID_AGRUPACION

	FROM '|| V_ESQUEMA ||'.V_GASTOS_AUTORIZADOS_DIA V_DIA
	JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON V_DIA.ID_HAYA = ACT.ACT_NUM_ACTIVO
	JOIN '|| V_ESQUEMA ||'.ACT_BBVA_ACTIVOS BBVA ON ACT.ACT_ID = BBVA.ACT_ID
	JOIN '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV ON V_DIA.ID_GASTO_HAYA = GPV_NUM_GASTO_HAYA
	JOIN '|| V_ESQUEMA ||'.GLD_GASTOS_LINEA_DETALLE GLD ON GPV.GPV_ID = GLD.GPV_ID AND GLD.BORRADO = 0
	JOIN '|| V_ESQUEMA ||'.GLD_ENT GLDENT ON GLD.GLD_ID = GLDENT.GLD_ID AND GLDENT.BORRADO = 0
	LEFT JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
	LEFT JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID AND AGR.BORRADO = 0 AND AGR.AGR_ELIMINADO = 0 AND AGR.AGR_FECHA_BAJA IS NULL';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_GASTOS_AUTORIZADOS_DIA_EXTRA...Creada OK');

  IF V_ESQUEMA_MASTER != V_ESQUEMA THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_MASTER||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_MASTER||''); 

	END IF;

	IF V_ESQUEMA_3 != V_ESQUEMA THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 

	END IF;

	IF V_ESQUEMA_4 != V_ESQUEMA THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 

	END IF;

  EXCEPTION
	     WHEN OTHERS THEN
	          err_num := SQLCODE;
	          err_msg := SQLERRM;
	
	          DBMS_OUTPUT.PUT_LINE('KO no modificada');
	          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
	          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
	          DBMS_OUTPUT.put_line(err_msg);
	
	          ROLLBACK;
	          RAISE;   
  
END;
/

EXIT;

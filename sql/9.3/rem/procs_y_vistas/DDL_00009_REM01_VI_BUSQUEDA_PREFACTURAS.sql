--/*
--##########################################
--## AUTOR=Sergio Salt
--## FECHA_CREACION=20200926
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10987
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - Pablo Gacia Pallás (HREOS-10987)
--##		0.2 Añadir FechaPrefactura
--##			0.3 Se añade estado gasto
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

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_PREFACTURAS...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_PREFACTURAS 

	AS
		SELECT DISTINCT PFA_ID, ALB_ID, PFA_NUM_PREFACTURA, DD_EPF_DESCRIPCION, PVE_NOMBRE, PRO_NOMBRE, ANYO, NVL(IMPORTE_TOTAL,0.0) IMPORTE_TOTAL
		   , NVL(IMPORTE_CLIENTE,0.0) IMPORTE_CLIENTE, NUMTRABAJOS
		   , LISTAGG (GPV_NUM_GASTO_HAYA, '', '') WITHIN GROUP (ORDER BY GPV_NUM_GASTO_HAYA) OVER (PARTITION BY PFA_NUM_PREFACTURA) NUM_GASTOS, DD_EGA_DESCRIPCION AS ESTADO_GASTO, PFA_FECHA_PREFACTURA
		FROM (
		   SELECT
		       PFA.PFA_ID,
			   PFA.ALB_ID,
		       PFA.PFA_NUM_PREFACTURA,
		       PVE.PVE_NOMBRE,
		       PRO.PRO_NOMBRE,
		       EPF.DD_EPF_DESCRIPCION,
		       TO_CHAR(TBJ.TBJ_FECHA_VALIDACION,''YYYY'') ANYO,
		       SUM(TBJ.TBJ_IMPORTE_PRESUPUESTO) AS IMPORTE_TOTAL,
		       SUM(TBJ.TBJ_IMPORTE_TOTAL) AS IMPORTE_CLIENTE,
		       (SELECT COUNT(TBJ_ID) FROM REM01.ACT_TBJ_TRABAJO ATT INNER JOIN REM01.PFA_PREFACTURA PREF ON PREF.PFA_ID = ATT.PFA_ID AND PREF.BORRADO = 0 WHERE ATT.BORRADO = 0 AND ATT.PFA_ID = PFA.PFA_ID) AS NUMTRABAJOS,
		       GPV.GPV_NUM_GASTO_HAYA,
		       PFA.PFA_FECHA_PREFACTURA,
		       EGA.DD_EGA_DESCRIPCION
		   FROM ' || V_ESQUEMA ||'.PFA_PREFACTURA PFA
		   JOIN ' || V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE ON PFA.PVE_ID = PVE.PVE_ID
		   JOIN ' || V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PFA.PRO_ID = PRO.PRO_ID
		   JOIN ' || V_ESQUEMA ||'.DD_EPF_ESTADO_PREFACTURA EPF ON PFA.DD_EPF_ID = EPF.DD_EPF_ID
		   LEFT JOIN ' || V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ ON PFA.PFA_ID = TBJ.PFA_ID
		   LEFT JOIN ' || V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.PFA_ID = PFA.PFA_ID
		   LEFT JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
		   GROUP BY PFA.PFA_ID, PFA.ALB_ID, PFA.PFA_NUM_PREFACTURA, PVE.PVE_NOMBRE, PRO.PRO_NOMBRE, EPF.DD_EPF_DESCRIPCION, TO_CHAR(TBJ.TBJ_FECHA_VALIDACION,''YYYY''), GPV.GPV_NUM_GASTO_HAYA, PFA.PFA_FECHA_PREFACTURA, EGA.DD_EGA_DESCRIPCION
		   ) ORDER BY 1
		';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_PREFACTURAS...Creada OK');

  COMMIT;

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

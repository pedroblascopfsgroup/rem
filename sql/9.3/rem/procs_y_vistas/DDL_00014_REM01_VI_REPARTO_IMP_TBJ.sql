--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20200917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11187
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
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_REPARTO_IMP_TBJ...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_REPARTO_IMP_TBJ AS
  	WITH PART_TBJ_LIN AS (
	    SELECT GLD.GLD_ID, TBJ.TBJ_ID
	        , TBJ.TBJ_IMPORTE_PRESUPUESTO/SUM(TBJ.TBJ_IMPORTE_PRESUPUESTO) OVER(PARTITION BY GLD.GLD_ID) PART_TBJ_LIN_PVE
	        , TBJ.TBJ_IMPORTE_TOTAL/SUM(TBJ.TBJ_IMPORTE_TOTAL) OVER(PARTITION BY GLD.GLD_ID) PART_TBJ_LIN_CLI
	    FROM '||V_ESQUEMA||'.GLD_TBJ GTB
	    JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GLD_ID = GTB.GLD_ID
	        AND GLD.BORRADO = 0
	    JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = GTB.TBJ_ID
	        AND TBJ.BORRADO = 0
	    WHERE NVL(TBJ.TBJ_IMPORTE_PRESUPUESTO, 0) > 0
	        AND NVL(TBJ.TBJ_IMPORTE_TOTAL, 0) > 0
	        AND NVL(TBJ.TBJ_IMPORTE_TOTAL, 0) >= NVL(TBJ.TBJ_IMPORTE_PRESUPUESTO, 0)
	)
	, PRINCIPAL AS (
	    SELECT GLD.GPV_ID, GLD.GLD_ID, GEN.GLD_ENT_ID, ATB.ACT_ID, ATB.TBJ_ID
	        , ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 2) PARTICIPACION_PVE
	        , ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 2) PARTICIPACION_CLI
	        , ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 2) + 100 - SUM(ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 2)) OVER(PARTITION BY GLD.GLD_ID) AJUSTE_PVE
	        , ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 2) + 100 - SUM(ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 2)) OVER(PARTITION BY GLD.GLD_ID) AJUSTE_CLI
	        , ROW_NUMBER() OVER(PARTITION BY GLD.GLD_ID ORDER BY 1) RN
	    FROM '||V_ESQUEMA||'.GLD_ENT GEN
	    JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GEN.DD_ENT_ID
	        AND ENT.BORRADO = 0
	    JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GLD_ID = GEN.GLD_ID
	        AND GLD.BORRADO = 0
	    JOIN '||V_ESQUEMA||'.GLD_TBJ GTB ON GTB.GLD_ID = GLD.GLD_ID
	        AND GTB.BORRADO = 0
	    JOIN '||V_ESQUEMA||'.ACT_TBJ ATB ON ATB.TBJ_ID = GTB.TBJ_ID
	        AND ATB.ACT_ID = GEN.ENT_ID
	    JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = GTB.TBJ_ID
	        AND TBJ.BORRADO = 0
	    JOIN PART_TBJ_LIN PTL ON PTL.GLD_ID = GLD.GLD_ID
	        AND PTL.TBJ_ID = TBJ.TBJ_ID
	    WHERE GEN.BORRADO = 0
	        AND ENT.DD_ENT_CODIGO = ''ACT''
	)
	SELECT PP.GPV_ID, PP.GLD_ID, PP.GLD_ENT_ID
	    , CASE WHEN PP.RN = 1 THEN PP.AJUSTE_PVE ELSE PP.PARTICIPACION_PVE END PARTICIPACION_PVE
	    , CASE WHEN PP.RN = 1 THEN PP.AJUSTE_CLI ELSE PP.PARTICIPACION_CLI END PARTICIPACION_CLI
	FROM PRINCIPAL PP';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_REPARTO_IMP_TBJ...Creada OK');

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

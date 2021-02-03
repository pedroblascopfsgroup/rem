--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20210201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8708
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
	WITH SUPLIDOS AS (
	    SELECT PSU.TBJ_ID
	            , NVL(
	            SUM(
	                CASE
	                    WHEN TAD.DD_TAD_CODIGO = ''01''
	                        THEN -NVL(PSU.PSU_IMPORTE, 0)
	                    WHEN TAD.DD_TAD_CODIGO = ''02''
	                        THEN NVL(PSU.PSU_IMPORTE, 0)
	                    ELSE NVL(PSU.PSU_IMPORTE, 0)
	                END
	            )
	        , 0) IMPORTE_PROV_SUPL
	    FROM '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO PSU 
	    JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = PSU.TBJ_ID
	        AND TBJ.BORRADO = 0
	    LEFT JOIN '||V_ESQUEMA||'.DD_TAD_TIPO_ADELANTO TAD ON TAD.DD_TAD_ID = PSU.DD_TAD_ID
	        AND TAD.BORRADO = 0
	    WHERE PSU.BORRADO = 0
	    GROUP BY PSU.TBJ_ID
	)
	, PART_TBJ_LIN AS ( 
	    SELECT
	           GLD.GPV_ID
	         , GLD.GLD_ID
	         , TBJ.TBJ_ID
	         , (TBJ.TBJ_IMPORTE_PRESUPUESTO + NVL(SUP.IMPORTE_PROV_SUPL, 0)) / SUM(TBJ.TBJ_IMPORTE_PRESUPUESTO + NVL(SUP.IMPORTE_PROV_SUPL, 0))
	                                           OVER(PARTITION BY GLD.GLD_ID)       PART_TBJ_LIN_PVE
	         , (TBJ.TBJ_IMPORTE_TOTAL + NVL(SUP.IMPORTE_PROV_SUPL, 0)) / SUM(TBJ.TBJ_IMPORTE_TOTAL + NVL(SUP.IMPORTE_PROV_SUPL, 0))
	                                     OVER(PARTITION BY GLD.GLD_ID)       PART_TBJ_LIN_CLI
	     FROM
	            '|| V_ESQUEMA ||'.GLD_TBJ GTB
	         JOIN '|| V_ESQUEMA ||'.GLD_GASTOS_LINEA_DETALLE    GLD ON GLD.GLD_ID = GTB.GLD_ID
	          AND GLD.BORRADO = 0
	         JOIN '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO             TBJ ON TBJ.TBJ_ID = GTB.TBJ_ID
	          AND TBJ.BORRADO = 0
	        LEFT JOIN SUPLIDOS SUP ON SUP.TBJ_ID = TBJ.TBJ_ID
	    WHERE
	          (
	            (
	                NVL(TBJ.TBJ_IMPORTE_PRESUPUESTO, 0) <> 0
	                AND NVL(TBJ.TBJ_IMPORTE_TOTAL, 0) <> 0
	            )
	            OR (
	                NVL(SUP.IMPORTE_PROV_SUPL, 0) <> 0
	            )
	         )
	          AND GTB.BORRADO = 0
	), PRINCIPAL AS (
	    SELECT PTL.GPV_ID, PTL.GLD_ID, GEN.GLD_ENT_ID
	        , CASE WHEN ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 4) < 0.01 THEN 0.01 ELSE ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 4) END PARTICIPACION_PVE
	        , CASE WHEN ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 4) < 0.01 THEN 0.01 ELSE ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 4) END PARTICIPACION_CLI
	        , CASE WHEN ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 4) < 0.01 THEN 0.01 ELSE ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 4) END + 100 - SUM(CASE WHEN ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 4) < 0.01 THEN 0.01 ELSE ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 4) END) OVER(PARTITION BY PTL.GLD_ID) AJUSTE_PVE
	        , CASE WHEN ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 4) < 0.01 THEN 0.01 ELSE ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 4) END + 100 - SUM(CASE WHEN ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 4) < 0.01 THEN 0.01 ELSE ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 4) END) OVER(PARTITION BY PTL.GLD_ID) AJUSTE_CLI
	        , ROW_NUMBER() OVER(PARTITION BY PTL.GLD_ID ORDER BY PTL.PART_TBJ_LIN_CLI DESC) RN_CLI
	    FROM PART_TBJ_LIN PTL
	    JOIN '|| V_ESQUEMA ||'.GLD_ENT GEN ON GEN.GLD_ID = PTL.GLD_ID
	        AND GEN.BORRADO = 0
	    JOIN '|| V_ESQUEMA ||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GEN.DD_ENT_ID
	        AND ENT.BORRADO = 0
	    JOIN '|| V_ESQUEMA ||'.ACT_TBJ ATB ON ATB.ACT_ID = GEN.ENT_ID
	        AND ATB.TBJ_ID = PTL.TBJ_ID
	    WHERE ENT.DD_ENT_CODIGO = ''ACT''
	), RN_1 AS (
	    SELECT GPV_ID, GLD_ID, GLD_ENT_ID
	        , SUM(AJUSTE_PVE) PARTICIPACION_PVE, SUM(AJUSTE_CLI) PARTICIPACION_CLI
	    FROM PRINCIPAL
	    WHERE RN_CLI = 1
	    GROUP BY GPV_ID, GLD_ID, GLD_ENT_ID
	), RN_RESTO AS (
	    SELECT GPV_ID, GLD_ID, GLD_ENT_ID
	    	, SUM(PARTICIPACION_PVE) PARTICIPACION_PVE, SUM(PARTICIPACION_CLI) PARTICIPACION_CLI
	    FROM PRINCIPAL
	    WHERE RN_CLI > 1
	    GROUP BY GPV_ID, GLD_ID, GLD_ENT_ID
	)
	SELECT GPV_ID, GLD_ID, GLD_ENT_ID, PARTICIPACION_PVE, PARTICIPACION_CLI
	FROM RN_1
	UNION
	SELECT GPV_ID, GLD_ID, GLD_ENT_ID, PARTICIPACION_PVE, PARTICIPACION_CLI
	FROM RN_RESTO';

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

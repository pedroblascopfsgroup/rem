--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16581
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 REMVIP-9697 - IVAN REPISO - Exportar area peticionaria
--##        0.3 REMVIP-9763 - Juan Bautista Alfonso - Añadido campo de cartera del propietario
--##        0.4 HREOS-16581 - Daniel Algaba - Añadido cruce con la nueva tabla de prefacturas
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
    err_num NUMBER; -- Número de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_EXPORTAR_TRABAJOS_ALBARANES...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_EXPORTAR_TRABAJOS_ALBARANES 

	AS
        SELECT  
            ROWNUM ID,
            ALB.ALB_NUM_ALBARAN,
            ALB.ALB_FECHA_ALBARAN,
            ESTALB.DD_ESA_CODIGO,
            ESTALB.DD_ESA_DESCRIPCION,
            (SELECT COUNT(PFA_ID) FROM '|| V_ESQUEMA ||'.PFA_PREFACTURA PFAP INNER JOIN '|| V_ESQUEMA ||'.ALB_ALBARAN ALBA ON ALBA.ALB_ID = PFAP.ALB_ID AND ALBA.BORRADO = 0 WHERE PFAP.BORRADO = 0 AND ALBA.ALB_ID = ALB.ALB_ID) NUMPREFACTURA_ALB,
            COUNT(1) OVER(PARTITION BY ALB.ALB_ID) NUMTRABAJO_ALB,
            SUM(NVL(TBJ.TBJ_IMPORTE_TOTAL,0)) OVER(PARTITION BY ALB.ALB_ID) SUM_TOTAL_ALB,
            SUM(NVL(TBJ.TBJ_IMPORTE_PRESUPUESTO,0)) OVER(PARTITION BY ALB.ALB_ID) SUM_PRESUPUESTO_ALB,
            PFA.PFA_NUM_PREFACTURA,
            PFA.PFA_FECHA_PREFACTURA,
            PVE.PVE_ID,
            PVE.PVE_NOMBRE,
            PRO.PRO_DOCIDENTIF,
            PRO.PRO_NOMBRE,
            EPF.DD_EPF_CODIGO,
            EPF.DD_EPF_DESCRIPCION,
            GPV.GPV_NUM_GASTO_HAYA,
            EGA.DD_EGA_CODIGO,
            EGA.DD_EGA_DESCRIPCION,
            COUNT(1) OVER(PARTITION BY PFA.PFA_ID) NUMTRABAJO_PFA,
            SUM(NVL(TBJ.TBJ_IMPORTE_TOTAL,0)) OVER(PARTITION BY PFA.PFA_ID) SUM_TOTAL_PFA,
            SUM(NVL(TBJ.TBJ_IMPORTE_PRESUPUESTO,0)) OVER(PARTITION BY PFA.PFA_ID) SUM_PRESUPUESTO_PFA,
            TBJ.TBJ_NUM_TRABAJO,
            TTR.DD_TTR_CODIGO,
            TTR.DD_TTR_DESCRIPCION,
            STR.DD_STR_CODIGO,
            STR.DD_STR_DESCRIPCION,
            TBJ.TBJ_DESCRIPCION,
            TO_CHAR(TBJ.TBJ_FECHA_SOLICITUD,''YYYY'') ANYO_TRABAJO,
            EST.DD_EST_CODIGO,
            EST.DD_EST_DESCRIPCION,
            NVL(TBJ.TBJ_IMPORTE_TOTAL,0) TBJ_IMPORTE_TOTAL,
            NVL(TBJ.TBJ_IMPORTE_PRESUPUESTO,0) TBJ_IMPORTE_PRESUPUESTO,
            IRE.DD_IRE_CODIGO,	
			      IRE.DD_IRE_DESCRIPCION,
            CRA.DD_CRA_CODIGO,
            CRA.DD_CRA_DESCRIPCION
        FROM '|| V_ESQUEMA ||'.ALB_ALBARAN ALB
        LEFT JOIN '|| V_ESQUEMA ||'.DD_ESA_ESTADO_ALBARAN ESTALB ON ALB.DD_ESA_ID = ESTALB.DD_ESA_ID AND ESTALB.BORRADO = 0
        JOIN '|| V_ESQUEMA ||'.PFA_PREFACTURA PFA ON ALB.ALB_ID = PFA.ALB_ID AND ALB.BORRADO = 0
        JOIN '|| V_ESQUEMA ||'.PTG_PREFACTURAS PTG ON PFA.PFA_ID = PTG.PFA_ID AND PTG.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.DD_EPF_ESTADO_PREFACTURA EPF ON EPF.DD_EPF_ID = PFA.DD_EPF_ID AND EPF.BORRADO = 0
        JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE ON PFA.PVE_ID = PVE.PVE_ID AND PVE.BORRADO = 0
        JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PTG.PRO_ID = PRO.PRO_ID AND PRO.BORRADO = 0
        JOIN '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ ON PTG.TBJ_ID = TBJ.TBJ_ID AND TBJ.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.DD_TTR_TIPO_TRABAJO TTR ON TBJ.DD_TTR_ID = TTR.DD_TTR_ID AND TTR.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.DD_STR_SUBTIPO_TRABAJO STR ON TBJ.DD_STR_ID = STR.DD_STR_ID AND STR.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.DD_EST_ESTADO_TRABAJO EST ON TBJ.DD_EST_ID = EST.DD_EST_ID AND EST.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV ON PTG.GPV_ID = GPV.GPV_ID AND GPV.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.DD_EGA_ESTADOS_GASTO EGA ON GPV.DD_EGA_ID = EGA.DD_EGA_ID AND EGA.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.DD_IRE_IDENTIFICADOR_REAM IRE	ON TBJ.DD_IRE_ID = IRE.DD_IRE_ID AND IRE.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID AND CRA.BORRADO = 0
        WHERE ALB.BORRADO = 0';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_EXPORTAR_TRABAJOS_ALBARANES...Creada OK');

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

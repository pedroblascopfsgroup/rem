--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20201123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12178
--## PRODUCTO=NO
--## Finalidad: Vista para calcular el importe bruto de los gastos de Liberbank
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
-- 0.1
DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    ERR_NUM NUMBER; -- N?mero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_IMPORTE_BRUTO_GASTO_LBK' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_IMPORTE_BRUTO_GASTO_LBK...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_IMPORTE_BRUTO_GASTO_LBK';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_IMPORTE_BRUTO_GASTO_LBK... borrada OK'); 
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_IMPORTE_BRUTO_GASTO_LBK' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_IMPORTE_BRUTO_GASTO_LBK...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_IMPORTE_BRUTO_GASTO_LBK';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_IMPORTE_BRUTO_GASTO_LBK... borrada OK');
  END IF;  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_IMPORTE_BRUTO_GASTO_LBK...');
  EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.V_IMPORTE_BRUTO_GASTO_LBK 
  AS
    SELECT GPV.GPV_ID
        , CAST(
            SUM(
                NVL(GLD.GLD_PRINCIPAL_SUJETO, 0)
                + NVL(GLD.GLD_PRINCIPAL_NO_SUJETO, 0)
                + NVL(GLD.GLD_RECARGO, 0)
                + NVL(GLD.GLD_INTERES_DEMORA, 0)
                + NVL(GLD.GLD_COSTAS, 0)
                + NVL(GLD.GLD_OTROS_INCREMENTOS, 0)
                + NVL(GLD.GLD_PROV_SUPLIDOS, 0)
            ) AS NUMBER(16,2)
        ) IMPORTE_BRUTO
    FROM '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV
    JOIN '|| V_ESQUEMA ||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
        AND GLD.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID 
        AND PRO.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID 
        AND CRA.BORRADO = 0
    WHERE GPV.BORRADO = 0
        AND CRA.DD_CRA_CODIGO = ''08''
    GROUP BY GPV.GPV_ID';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_IMPORTE_BRUTO_GASTO_LBK...Creada OK');
  
  EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
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

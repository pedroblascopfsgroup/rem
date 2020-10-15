--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20201008
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10757
--## PRODUCTO=NO
--## Finalidad: Vista para calcular el importe de los gastos Liberbank separado por activos
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_IMPORTES_GASTOS_LBK' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_IMPORTES_GASTOS_LBK...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_IMPORTES_GASTOS_LBK';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_IMPORTES_GASTOS_LBK... borrada OK'); 
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_IMPORTES_GASTOS_LBK' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_IMPORTES_GASTOS_LBK...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_IMPORTES_GASTOS_LBK';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_IMPORTES_GASTOS_LBK... borrada OK');
  END IF;  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_IMPORTES_GASTOS_LBK...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_IMPORTES_GASTOS_LBK AS
    WITH IMPORTE_ACTIVO_GASTO AS (
        SELECT GPV.GPV_ID, GEN.ENT_ID, ENT.DD_ENT_ID
            ,  SUM(NVL(GEN.GLD_PARTICIPACION_GASTO, 0) / 100 * GLD.GLD_IMPORTE_TOTAL) 
                IMPORTE_ACTIVO_GASTO
        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
        JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
            AND GLD.BORRADO = 0
        JOIN '||V_ESQUEMA||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
            AND GEN.BORRADO = 0
        JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GEN.DD_ENT_ID
        WHERE GPV.BORRADO = 0
        GROUP BY GPV.GPV_ID, GEN.ENT_ID, ENT.DD_ENT_ID
    )
    , IMPORTE_GASTO AS (
        SELECT GPV.GPV_ID, SUM(NVL(GLD.GLD_IMPORTE_TOTAL, 0)) IMPORTE_GASTO
        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
        JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
            AND GLD.BORRADO = 0
        WHERE GPV.BORRADO = 0
        GROUP BY GPV.GPV_ID
    )
    SELECT IAG.GPV_ID, IAG.ENT_ID, IAG.DD_ENT_ID
        , CASE 
            WHEN DCL.DIARIO1 = ''20'' THEN 
                ROUND((IAG.IMPORTE_ACTIVO_GASTO / IMG.IMPORTE_GASTO) * ((NVL(P20.P20_GASTO, 100) / 100 * DCL.DIARIO1_TIPO / 100 + 1) * (DCL.DIARIO1_BASE) + NVL(DCL.DIARIO2_BASE, 0)), 2)
            WHEN DCL.DIARIO1 = ''1'' THEN
                ROUND((IAG.IMPORTE_ACTIVO_GASTO / IMG.IMPORTE_GASTO) * ((DCL.DIARIO1_BASE) + NVL(DCL.DIARIO2_BASE, 0)), 2)
            WHEN DCL.DIARIO1 = ''2'' THEN
                ROUND((IAG.IMPORTE_ACTIVO_GASTO / IMG.IMPORTE_GASTO) * ((DCL.DIARIO1_TIPO / 100 + 1) * (DCL.DIARIO1_BASE) + NVL(DCL.DIARIO2_BASE, 0)), 2)
            WHEN DCL.DIARIO1 = ''60'' THEN
                ROUND((IAG.IMPORTE_ACTIVO_GASTO / IMG.IMPORTE_GASTO) * (DCL.DIARIO1_BASE), 2)
            END IMPORTE_ACTIVO
    FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
    JOIN IMPORTE_ACTIVO_GASTO IAG ON IAG.GPV_ID = GPV.GPV_ID
    JOIN IMPORTE_GASTO IMG ON IMG.GPV_ID = IAG.GPV_ID
    JOIN '||V_ESQUEMA||'.V_DIARIOS_CALCULO_LBK DCL ON DCL.GPV_ID = IAG.GPV_ID
    LEFT JOIN '||V_ESQUEMA||'.ACT_P20_PRORRATA_DIARIO20 P20 ON P20.PRO_ID = GPV.PRO_ID
        AND P20.BORRADO = 0
    WHERE GPV.BORRADO = 0
        AND IMG.IMPORTE_GASTO <> 0
  ';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_IMPORTES_GASTOS_LBK...Creada OK');
  
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

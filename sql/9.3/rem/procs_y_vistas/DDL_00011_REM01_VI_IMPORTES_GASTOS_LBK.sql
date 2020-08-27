--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20200827
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
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_IMPORTES_GASTOS_LBK 
  AS
    SELECT T1.GPV_ID, T3.ENT_ID ID_ELEMENTO, T6.DD_ENT_DESCRIPCION TIPO_ELEMENTO, 1 IMPORTE_GASTO
    FROM '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR T1
    JOIN '|| V_ESQUEMA ||'.GLD_GASTOS_LINEA_DETALLE T2 ON T1.GPV_ID = T2.GPV_ID AND T2.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.GLD_ENT T3 ON T3.GLD_ID = T2.GLD_ID
    JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO T4 ON T4.PRO_ID = T1.PRO_ID AND T4.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA T5 ON T5.DD_CRA_ID = T4.DD_CRA_ID AND T5.DD_CRA_CODIGO = ''08''
    LEFT JOIN '|| V_ESQUEMA ||'.DD_ENT_ENTIDAD_GASTO T6 ON T6.DD_ENT_ID = T3.DD_ENT_ID
    WHERE T1.BORRADO = 0';

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

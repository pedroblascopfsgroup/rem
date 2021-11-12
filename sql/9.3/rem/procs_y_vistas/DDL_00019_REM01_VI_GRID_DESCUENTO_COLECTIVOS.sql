--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210603
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14196
--## PRODUCTO=NO
--## Finalidad: vista para sacar descuentos colectivos
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_GRID_DESCUENTO_COLECTIVOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_GRID_DESCUENTO_COLECTIVOS...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_GRID_DESCUENTO_COLECTIVOS';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_GRID_DESCUENTO_COLECTIVOS... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_GRID_DESCUENTO_COLECTIVOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_GRID_DESCUENTO_COLECTIVOS...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_GRID_DESCUENTO_COLECTIVOS';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_GRID_DESCUENTO_COLECTIVOS... borrada OK');
  END IF;

  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_DESCUENTO_COLECTIVOS...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_GRID_DESCUENTO_COLECTIVOS 
	AS
    SELECT 
      DCC.ADC_ID AS ID_DESCUENTO
    , ACT.ACT_ID AS ID_ACTIVO
    , ACT.ACT_NUM_ACTIVO AS NUM_ACTIVO
    , DDD.DD_DCC_CODIGO AS CODIGO_DESCUENTOS
    , DDD.DD_DCC_DESCRIPCION AS DESCRIPCION_DESCUENTOS
    , TPC.DD_TPC_CODIGO AS CODIGO_PRECIOS
    , TPC.DD_TPC_DESCRIPCION AS DESCRIPCION_PRECIOS
        
    FROM 
        '||V_ESQUEMA||'.ACT_DCC_DESCUENTO_COLECTIVOS DCC
        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = DCC.ACT_ID AND ACT.BORRADO = 0
        LEFT JOIN '||V_ESQUEMA||'.DD_DCC_DESCUENTOS_COLECTIVOS DDD ON DDD.DD_DCC_ID = DCC.DD_DCC_ID AND DDD.BORRADO = 0
        LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = DCC.DD_TPC_ID AND TPC.BORRADO = 0
        WHERE DCC.BORRADO = 0
        ORDER BY CODIGO_DESCUENTOS ASC, CODIGO_PRECIOS ASC';
		

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_DESCUENTO_COLECTIVOS...Creada OK');
  
  EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
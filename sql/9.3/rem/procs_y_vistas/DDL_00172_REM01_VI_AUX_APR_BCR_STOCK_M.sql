--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220317
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-17348
--## PRODUCTO=NO
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
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN
	
-- Modificación de la vista AUX_APR_BCR_STOCK_M.

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'AUX_APR_BCR_STOCK_M' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA = 0 THEN
    DBMS_OUTPUT.PUT_LINE('CREATE MATERIALIZED VIEW '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK_M...');
    EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK_M AS SELECT * FROM AUX_APR_BCR_STOCK';  

    DBMS_OUTPUT.PUT_LINE('CREATE MATERIALIZED VIEW '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK_M...Creada OK');
  ELSE 
    DBMS_OUTPUT.PUT_LINE(''|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK_M...Ya existe, borramos y creamos');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW '||V_ESQUEMA||'.AUX_APR_BCR_STOCK_M';
    EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK_M AS SELECT * FROM AUX_APR_BCR_STOCK';        
  END IF;

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

--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20210607
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-14188
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
	
-- Modificación de la vista VI_STOCK_OFERTAS_CAIXA.

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_STOCK_OFERTAS_CAIXA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_STOCK_OFERTAS_CAIXA...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_STOCK_OFERTAS_CAIXA';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_STOCK_OFERTAS_CAIXA... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_STOCK_OFERTAS_CAIXA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_STOCK_OFERTAS_CAIXA...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_STOCK_OFERTAS_CAIXA';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_STOCK_OFERTAS_CAIXA... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_STOCK_OFERTAS_CAIXA...');
  EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.VI_STOCK_OFERTAS_CAIXA
      AS
		SELECT DISTINCT 
			OFR.OFR_NUM_OFERTA AS ID_OFERTA_HAYA,
			OCA.OFR_NUM_OFERTA_CAIXA AS ID_OFERTA_CLIENTE,
			ECO.ECO_NUM_EXPEDIENTE AS ID_EXPEDIENTE_COMERCIAL
		FROM '|| V_ESQUEMA ||'.OFR_OFERTAS_CAIXA OCA
		INNER JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OCA.OFR_ID = OFR.OFR_ID AND OFR.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO ON OFR.OFR_ID = ECO.OFR_ID AND ECO.BORRADO=0
		WHERE OCA.BORRADO = 0';  

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_STOCK_OFERTAS_CAIXA...Creada OK');

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

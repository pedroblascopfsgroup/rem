--/*
--##########################################
--## AUTOR=CARLOS FELIU
--## FECHA_CREACION=20160413
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_LLAVES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_LLAVES...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_LLAVES';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_LLAVES... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_LLAVES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_LLAVES...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_LLAVES';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_LLAVES... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_LLAVES...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_LLAVES 
	AS
		SELECT 
	          MLV.MLV_ID,
			  LLV.LLV_ID,
	          ACT.ACT_ID,
			  LLV.LLV_NOMBRE_CENTRO,
			  LLV.LLV_ARCHIVO1,
			  LLV.LLV_ARCHIVO2,
			  LLV.LLV_ARCHIVO3,
			  LLV.LLV_COMPLETO,
			  LLV.LLV_MOTIVO_INCOMPLETO,
			  TTE.DD_TTE_CODIGO,
			  TTE.DD_TTE_DESCRIPCION,
			  MLV.MLV_COD_TENEDOR,
			  MLV.MLV_NOM_TENEDOR,
			  MLV.MLV_FECHA_ENTREGA,
			  MLV.MLV_FECHA_DEVOLUCION	
		  
		FROM ' || V_ESQUEMA || '.ACT_LLV_LLAVE LLV
	    INNER JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON LLV.ACT_ID = ACT.ACT_ID
		INNER JOIN ' || V_ESQUEMA || '.ACT_MLV_MOVIMIENTO_LLAVE MLV ON LLV.LLV_ID = MLV.LLV_ID AND MLV.BORRADO = 0
	    INNER JOIN ' || V_ESQUEMA || '.DD_TTE_TIPO_TENEDOR TTE ON TTE.DD_TTE_ID = MLV.DD_TTE_ID AND TTE.BORRADO = 0
		WHERE LLV.BORRADO = 0';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_LLAVES...Creada OK');
  
END;
/

EXIT;
--/*
--##########################################
--## AUTOR=Diego Carrasco Parra
--## FECHA_CREACION=20190614
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6607
--## PRODUCTO=NO
--##
--## Finalidad: Añadir columna DD_ORC_ID en la tabla OFR_OFERTAS
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_COLUMNA VARCHAR2(30 CHAR):= 'DD_ORC_ID'; -- Vble. para almacenar el nombre de la columna.
    V_TABLA VARCHAR2(50 CHAR):= 'OFR_OFERTAS'; -- Vble. para almacenar el nombre de la tabla.
    V_NUM_COLS NUMBER(16); --Vble. para validar la existencia de una columna  
   
    BEGIN
    
	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''|| V_COLUMNA ||''' AND TABLE_NAME= '''|| V_TABLA ||''' AND OWNER='''|| V_ESQUEMA ||''''; 
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLS;

	-- Si existe la columna no hacemos nada
	IF V_NUM_COLS = 0 THEN 
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA ||'.'|| V_TABLA ||' ADD ('|| V_COLUMNA ||' NUMBER(16))';
	ELSE
		DBMS_OUTPUT.PUT_LINE('YA EXISTE EL COLUMNA');
	END IF;   

	V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'|| V_TABLA ||'.'|| V_COLUMNA ||' IS ''Clave forenea que relaciona la OFR con el DD_ORC_ORIGEN_COMPRADOR''';	
	EXECUTE IMMEDIATE V_SQL;

	V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''FK_OFR_DD_ORC'' AND OWNER = UPPER('''||V_ESQUEMA||''')';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLS;

	-- Si existe la columna no hacemos nada
	IF V_NUM_COLS = 0 THEN 
		V_SQL := 'ALTER TABLE '||V_ESQUEMA ||'.'|| V_TABLA ||' ADD CONSTRAINT FK_OFR_DD_ORC FOREIGN KEY (DD_ORC_ID) REFERENCES '||V_ESQUEMA||'.DD_ORC_ORIGEN_COMPRADOR (DD_ORC_ID) ';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('AÑADIDA FOREIGN KEY');
	ELSE
		DBMS_OUTPUT.PUT_LINE('YA EXISTE LA RESTRICCIÓN');
	END IF;

	COMMIT;   
            
EXCEPTION
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

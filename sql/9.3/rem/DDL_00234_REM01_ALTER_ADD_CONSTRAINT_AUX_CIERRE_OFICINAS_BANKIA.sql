--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210423
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10454
--## PRODUCTO=NO
--## Finalidad: Modificar PK
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AUX_CIERRE_OFICINAS_BANKIA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CONSTRAINT_NAME VARCHAR2(2400 CHAR) := 'AUX_CIERRE_OFICINAS_BANKIA_PK';
    V_COLUMN_ID VARCHAR(30 CHAR) := 'ECO_ID';
    V_COLUMN_OFICINA_ANTERIOR VARCHAR(30 CHAR) := 'OFICINA_ANTERIOR';

BEGIN
	-- Verificar si la CONSTRAINTS ya existe. Si ya existe la CONSTRAINTS, no se hace nada con esta
	V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = '''||V_CONSTRAINT_NAME||''' 
                and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_CONSTRAINT_NAME||' CONSTRAINT EXISTE, se borra y crea de nuevo');
		DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en '||V_ESQUEMA||'.'||V_TEXT_TABLA||'] -------------------------------------------');

		V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA||' DROP CONSTRAINT '||V_CONSTRAINT_NAME||'';
		EXECUTE IMMEDIATE V_MSQL;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_CONSTRAINT_NAME||' CONSTRAINT NO EXISTE, se crea. ');
        V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA||' ADD CONSTRAINT '||V_CONSTRAINT_NAME||' PRIMARY KEY ('||V_COLUMN_ID||','||V_COLUMN_OFICINA_ANTERIOR||')';
	    EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_CONSTRAINT_NAME||' CONSTRAINT CREADA. ');
	END IF;

    --Si se ha borrado, se crea
    IF V_NUM_TABLAS = 1 THEN
        
        V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA||' ADD CONSTRAINT '||V_CONSTRAINT_NAME||' PRIMARY KEY ('||V_COLUMN_ID||','||V_COLUMN_OFICINA_ANTERIOR||')';
	    EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_CONSTRAINT_NAME||' CONSTRAINT BORRADA Y CREADA. ');
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
          DBMS_OUTPUT.put_line('---------------------------QUERY---------------------------'); 
          DBMS_OUTPUT.put_line(V_MSQL);

          ROLLBACK;
          RAISE;          
END;

/

EXIT

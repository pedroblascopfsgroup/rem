--/*
--##########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20191105
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6959
--## PRODUCTO=NO
--## Finalidad: DDL Modificacion de la tabla PCC_PROV_CARTERA_CONFIG
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial Alejandro Valverde HREOS-6959
--##        0.2 Versión corregida
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NOMBRE_TABLA VARCHAR2(50 CHAR) := 'PCC_PROV_CARTERA_CONFIG'; -- Vble. auxiliar para el nombre de la tabla.
    V_NOMBRE_TABLA_REF VARCHAR2(50 CHAR) := 'DD_SCR_SUBCARTERA';
    V_NOMBRE_COL_CRA VARCHAR2(50 CHAR) := 'DD_CRA_ID'; -- Vble. auxiliar para el nombre de la columna.
    V_NOMBRE_COL_ID_HAYA VARCHAR2(50 CHAR) := 'ID_HAYA'; -- Vble. auxiliar para el nombre de la columna.
    V_NOMBRE_COL_SCR VARCHAR2(50 CHAR) := 'DD_SCR_ID'; -- Vble. auxiliar para el nombre de la columna.
    V_TIPO VARCHAR (27 CHAR) := 'NUMBER (16,0)'; -- Vble. auxiliar para el tipo de la columna
    V_TEXT VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    BEGIN
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_NOMBRE_TABLA||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla
    IF V_NUM_TABLAS = 1 THEN
	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_NOMBRE_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' AND COLUMN_NAME = '''|| V_NOMBRE_COL_SCR||''' ';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	--si no existe la columna la creamos
	IF V_NUM_TABLAS = 0 THEN
            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_NOMBRE_TABLA||' ADD '|| V_NOMBRE_COL_SCR||' '|| V_TIPO;
            EXECUTE IMMEDIATE V_MSQL;   
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_NOMBRE_TABLA||' columna '|| V_NOMBRE_COL_SCR||' añadida');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] La columna ' ||V_NOMBRE_COL_SCR || ' ya existe ');
    	END IF;

	--Restricciones     
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Añadiendo las restricciones a las columnas añadidas ');
	V_SQL := 'SELECT COUNT(CONSTRAINT_NAME) FROM USER_CONS_COLUMNS WHERE TABLE_NAME = '''||V_NOMBRE_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' AND COLUMN_NAME = '''|| V_NOMBRE_COL_SCR||''' ';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    	IF V_NUM_TABLAS = 0 THEN
    
		V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_NOMBRE_TABLA_REF||''' ';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS = 1 THEN
		    V_SQL := 'ALTER TABLE '|| V_NOMBRE_TABLA||' ADD CONSTRAINT FK_PCC_'||V_NOMBRE_COL_SCR||' FOREIGN KEY ('||V_NOMBRE_COL_SCR||') REFERENCES '||V_NOMBRE_TABLA_REF||' ('||V_NOMBRE_COL_SCR||')';
		EXECUTE IMMEDIATE V_SQL;

		ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ' ||V_NOMBRE_TABLA_REF || ' no existe.');		
		END IF;

		--Cambio a Nullable en las columnas 

		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_NOMBRE_TABLA||' MODIFY '||V_NOMBRE_COL_CRA||' NULL';
		EXECUTE IMMEDIATE V_SQL;
		
		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_NOMBRE_TABLA||' MODIFY '||V_NOMBRE_COL_ID_HAYA||' NULL';
		EXECUTE IMMEDIATE V_SQL;
		
	    ELSE 
		DBMS_OUTPUT.PUT_LINE('[INFO] La columna ' ||V_NOMBRE_COL_SCR || ' ya posee la restriccion pertinente');
	    END IF;	
	--Comentarios

	DBMS_OUTPUT.PUT_LINE('[INFO] Añadiendo los comentarios a las columnas añadidas ');

	V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_NOMBRE_TABLA||'.'||V_NOMBRE_COL_SCR||' IS ''Código identificador único de la subcartera.'' ';    EXECUTE IMMEDIATE V_SQL;


    ELSE	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA ||'.'||V_NOMBRE_TABLA||'... La tabla NO existe.');
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

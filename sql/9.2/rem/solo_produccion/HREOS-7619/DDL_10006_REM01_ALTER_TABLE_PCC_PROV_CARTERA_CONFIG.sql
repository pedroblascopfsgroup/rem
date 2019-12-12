--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20191029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7149
--## PRODUCTO=NO
--## Finalidad: DDL Modificacion de la tabla PCC_PROV_CARTERA_CONFIG
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
    ERR_NUM NUMBER(16);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NOMBRE_TABLA VARCHAR2(1000 CHAR) := 'PCC_PROV_CARTERA_CONFIG'; -- Vble. auxiliar para el nombre de la tabla.
    V_NOMBRE_COL_CLIE_GD VARCHAR2(100 CHAR) := 'CLIENTE_GD'; -- Vble. auxiliar para el nombre de la columna.
    V_TIPO VARCHAR2(50 CHAR) := 'VARCHAR2(50 CHAR)'; -- Vble. auxiliar.
    V_TEXT VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    BEGIN
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_NOMBRE_TABLA||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla
    IF V_NUM_TABLAS = 1 THEN
    		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_NOMBRE_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' AND COLUMN_NAME = '''|| V_NOMBRE_COL_CLIE_GD||''' ';
    		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    		--si no existe la columna la creamos
    		IF V_NUM_TABLAS = 0 THEN
	            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_NOMBRE_TABLA||' ADD '|| V_NOMBRE_COL_CLIE_GD||' '|| V_TIPO;
	            EXECUTE IMMEDIATE V_MSQL;   
	            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_NOMBRE_TABLA||' columna '|| V_NOMBRE_COL_CLIE_GD||' añadida');
                ELSE 
                    DBMS_OUTPUT.PUT_LINE('[INFO] La columna ' ||V_NOMBRE_COL_CLIE_GD || ' ya existe ');
            END IF;	

            --Comentarios

        DBMS_OUTPUT.PUT_LINE('[INFO] Añadiendo los comentarios a las columnas añadidas ');

        V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_NOMBRE_TABLA||'.'||V_NOMBRE_COL_CLIE_GD||' IS ''Código Identificador del cliente gestor documental.'' ';    EXECUTE IMMEDIATE V_SQL;


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

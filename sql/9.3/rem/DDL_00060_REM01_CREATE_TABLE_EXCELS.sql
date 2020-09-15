--/*
--######################################### 
--## AUTOR=Josep Ros
--## FECHA_CREACION=20200915
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11054
--## PRODUCTO=SI
--## 
--## Finalidad: Creacion de las tablas para la generacion de informes ESPARTA
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN


FOR contador IN 1..4
LOOP

      
-- COMPROBAMOS SI EXISTE LA TABLA
    -- V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''ESPARTA_EXCEL'||contador||''' and owner = '''||V_ESQUEMA||'''';
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ESPARTA_EXCEL'||contador||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si no existe la tabla, la creamos
	IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ESPARTA_EXCEL'||contador||' ya existe, se procede a eliminar para recrearse');
	V_SQL := 'DROP TABLE '||V_ESQUEMA||'.ESPARTA_EXCEL'||contador;
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ESPARTA_EXCEL'||contador||' ha sido eliminada.');
	END IF;

	IF contador = 1 THEN
	V_SQL :='CREATE TABLE '||V_ESQUEMA||'.ESPARTA_EXCEL'||contador||'(	
		  ACT_NUM_ACTIVO NUMBER(16) NOT NULL
		, CAMPO VARCHAR2(3500 CHAR) 
		, VALOR_ANTERIOR VARCHAR2(3500 CHAR)
		, VALOR_NUEVO VARCHAR2(3500 CHAR)
		, SUBTIPO_REGISTRO VARCHAR2(3500 CHAR)
		, ID_REGISTRO NUMBER(16)
		  )';
	ELSIF contador = 2 THEN
	V_SQL :='CREATE TABLE '||V_ESQUEMA||'.ESPARTA_EXCEL'||contador||'(      
                  ACT_NUM_ACTIVO NUMBER(16) NOT NULL
                , CAMPO VARCHAR2(3500 CHAR) 
                , VALOR_ACTUAL VARCHAR2(3500 CHAR)
                , VALOR_NUEVO VARCHAR2(3500 CHAR)
                , SUBTIPO_REGISTRO VARCHAR2(3500 CHAR)
                , ID_REGISTRO NUMBER(16)
                  )';

	ELSE
	V_SQL :='CREATE TABLE '||V_ESQUEMA||'.ESPARTA_EXCEL'||contador||'(	
		  ACT_NUM_ACTIVO NUMBER(16) NOT NULL
		, CAMPO VARCHAR2(3500 CHAR) 
		, VALOR_ACTUAL VARCHAR2(3500 CHAR)
		, VALOR_NUEVO VARCHAR2(3500 CHAR)
		, DESCRIPCION VARCHAR2(3500 CHAR)
		, SUBTIPO_REGISTRO VARCHAR2(3500 CHAR)
		, ID_REGISTRO NUMBER(16)
		  )';

	END IF;
        EXECUTE IMMEDIATE V_SQL;

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ESPARTA_EXCEL'||contador||'.ACT_NUM_ACTIVO IS ''Número de activo'' ';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ESPARTA_EXCEL'||contador||'.CAMPO IS ''Nombre del campo del activo'' ';
		EXECUTE IMMEDIATE V_MSQL;
		
		IF contador = 1 THEN
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ESPARTA_EXCEL'||contador||'.VALOR_ANTERIOR IS ''Valor anterior del campo del activo'' ';
		ELSE
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ESPARTA_EXCEL'||contador||'.VALOR_ACTUAL IS ''Valor actual del campo del activo'' ';
		END IF;
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ESPARTA_EXCEL'||contador||'.VALOR_NUEVO IS ''Valor nuevo del campo del activo'' ';
		EXECUTE IMMEDIATE V_MSQL;
		IF contador > 2 THEN
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ESPARTA_EXCEL'||contador||'.DESCRIPCION IS ''Descripcion del activo o campo'' ';
		EXECUTE IMMEDIATE V_MSQL;
		END IF;
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ESPARTA_EXCEL'||contador||'.SUBTIPO_REGISTRO IS ''Tipo de Unidad de Gestión'' ';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ESPARTA_EXCEL'||contador||'.ID_REGISTRO IS ''Identificador de la Unidad de Gestión'' ';
		EXECUTE IMMEDIATE V_MSQL;
		

        DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ESPARTA_EXCEL'||contador||' creada');
                  
        V_SQL := 'CREATE INDEX act_num_activo_idx'||contador||' on '||V_ESQUEMA||'.ESPARTA_EXCEL'||contador||'(ACT_NUM_ACTIVO)';    
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Índice act_num_activo_idx'||contador||' en la tabla ESPARTA_EXCEL'||contador||' creado');
	DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------');
  

END LOOP;

    COMMIT;  
    
EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;

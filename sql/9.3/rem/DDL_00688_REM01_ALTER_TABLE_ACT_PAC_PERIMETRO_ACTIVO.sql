--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211229
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16822
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: Script para borrado de columnas de una tabla
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 			-- Configuracion Esquemas
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_MSQL VARCHAR2(4000 CHAR); 							-- Vble. para consulta que valida la existencia de una tabla.
	V_DD_BCO_ID VARCHAR2(4000 CHAR); 							-- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); 							-- Vble. para validar la existencia de una tabla.
	V_NUM_SEQ NUMBER(16); 								-- Vble. para validar la existencia de una secuencia.  
	ERR_NUM NUMBER(25); 								-- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); 						-- Vble. auxiliar para registrar errores en el script.
	V_USR VARCHAR2(30 CHAR) := 'HREOS-16822'; 			-- USUARIOCREAR/USUARIOMODIFICAR.
	V_TABLA_1 VARCHAR2(2400 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO'; 		-- Vble. auxiliar para almacenar el nombre de la tabla de ref1.
	V_CAMPO_1 VARCHAR2(2400 CHAR) := 'DD_BCO_ID'; 		-- Vble. auxiliar para almacenar el nombre del campo de ref1.
	V_TABLA_2 VARCHAR2(2400 CHAR) := 'DD_BCO_BAJA_CONTABLE_BBVA'; 		-- Vble. auxiliar para almacenar el nombre de la tabla de ref1.

	
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] Inserción del campo en la tabla '''||V_TABLA_1||''':');
		--INSERTAMOS COLUMNA NUEVA CON SU FK
		 --Comprobacion de la tabla referencia
          V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_2||'''';
          EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

          IF V_NUM_TABLAS > 0 THEN
            -- Comprobamos si existe columna      
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||V_CAMPO_1||''' and TABLE_NAME = '''||V_TABLA_1||''' and owner = '''||V_ESQUEMA||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
            
            -- Si existe la columna cambiamos/establecemos solo la FK
              IF V_NUM_TABLAS = 1 THEN
                  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_1||' '||V_CAMPO_1||'... Ya existe, modificamos la FK');
                  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_1||' DROP CONSTRAINT FK_'||V_CAMPO_1||'';
                  EXECUTE IMMEDIATE V_MSQL;
                  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_1||'.'||V_CAMPO_1||'... FK Dropeada');
                  
                  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_1||' ADD (CONSTRAINT FK_'||V_CAMPO_1||' FOREIGN KEY 
                                        ('||V_CAMPO_1||') REFERENCES '||V_ESQUEMA||'.'||V_TABLA_2||' ('||V_CAMPO_1||') ON DELETE SET NULL)';
                  EXECUTE IMMEDIATE V_MSQL;
                  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_1||'.'||V_CAMPO_1||'... FK Modificada');
              
              --Si no existe la columna, la creamos y establecemos la FK
              ELSE
				        V_MSQL := 'SELECT DD_BCO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_2||' WHERE DD_BCO_CODIGO = ''03''';
            	  EXECUTE IMMEDIATE V_MSQL INTO V_DD_BCO_ID;

                  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_1||' ADD ('||V_CAMPO_1||' NUMBER(16,0) DEFAULT '||V_DD_BCO_ID||')';
                  EXECUTE IMMEDIATE V_MSQL;
                  DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.'||V_TABLA_1||'.'||V_CAMPO_1||'... Creada');

                  -- Creamos comentario	
                  V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA_1||'.'||V_CAMPO_1||' IS ''ID estados baja contable BBVA''';		
                  EXECUTE IMMEDIATE V_MSQL;
                  
                  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA_1||'... Comentario en columna creado.');

                  -- Creamos FK	
                  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_1||' ADD (CONSTRAINT FK_'||V_CAMPO_1||' FOREIGN KEY 
                                        ('||V_CAMPO_1||') REFERENCES '||V_ESQUEMA||'.'||V_TABLA_2||' ('||V_CAMPO_1||') ON DELETE SET NULL)';
                  EXECUTE IMMEDIATE V_MSQL;
                  DBMS_OUTPUT.PUT_LINE('[INFO] Constraint Creada');     
              END IF;
          ELSE
            DBMS_OUTPUT.PUT_LINE('No se puede añadir el campo porque la tabla a la que hace referencia no existe');
          END IF;

	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
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

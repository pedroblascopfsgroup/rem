--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16765
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
	V_SQL VARCHAR2(4000 CHAR); 							-- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); 							-- Vble. para validar la existencia de una tabla.
	V_NUM_SEQ NUMBER(16); 								-- Vble. para validar la existencia de una secuencia.  
	ERR_NUM NUMBER(25); 								-- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); 						-- Vble. auxiliar para registrar errores en el script.
	V_USR VARCHAR2(30 CHAR) := 'HREOS-16765'; 			-- USUARIOCREAR/USUARIOMODIFICAR.
	V_TABLA_1 VARCHAR2(2400 CHAR) := 'GLD_ENT'; 		-- Vble. auxiliar para almacenar el nombre de la tabla de ref1.
	V_CAMPO_1 VARCHAR2(2400 CHAR) := 'DD_TCO_ID'; 		-- Vble. auxiliar para almacenar el nombre del campo de ref1.
	V_CAMPO_2 VARCHAR2(2400 CHAR) := 'DD_CBC_ID'; 		-- Vble. auxiliar para almacenar el nombre del campo de ref2.
	V_TABLA_2 VARCHAR2(2400 CHAR) := 'DD_CBC_CARTERA_BC'; 		-- Vble. auxiliar para almacenar el nombre de la tabla de ref2.

	
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrado de campos en la tabla '''||V_TABLA_1||''':');

		--BORRAMOS COLUMNA
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''DD_TCO_ID'' AND TABLE_NAME = '''||V_TABLA_1||''' AND OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		-- Si existe la columna se borra
		IF V_NUM_TABLAS > 0 THEN
			DBMS_OUTPUT.PUT_LINE('	[INFO] La columna '||V_CAMPO_1||' existe. Se borrará.');
			
			-- Se borra la columna
			EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_1||' DROP COLUMN '||V_CAMPO_1||'');
			
			DBMS_OUTPUT.PUT_LINE('	[INFO] Columna borrada.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('	[ERROR] La columna no existe. No se hace nada');
		END IF;


	DBMS_OUTPUT.PUT_LINE('[INICIO] Inserción del campo en la tabla '''||V_TABLA_1||''':');
		--INSERTAMOS COLUMNA NUEVA CON SU FK
		 --Comprobacion de la tabla referencia
          V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_1||'''';
          EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

          IF V_NUM_TABLAS > 0 THEN
            -- Comprobamos si existe columna      
            V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||V_CAMPO_2||''' and TABLE_NAME = '''||V_TABLA_1||''' and owner = '''||V_ESQUEMA||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            -- Si existe la columna cambiamos/establecemos solo la FK
              IF V_NUM_TABLAS = 1 THEN
                  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_1||' '||V_CAMPO_2||'... Ya existe, modificamos la FK');
                  V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_1||' DROP CONSTRAINT FK_GEN_'||V_CAMPO_2||'';
                  EXECUTE IMMEDIATE V_SQL;
                  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_1||'.'||V_CAMPO_2||'... FK Dropeada');
                  
                  V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_1||' ADD (CONSTRAINT FK_GEN_'||V_CAMPO_2||' FOREIGN KEY 
                                        ('||V_CAMPO_2||') REFERENCES '||V_ESQUEMA||'.'||V_TABLA_2||' ('||V_CAMPO_2||') ON DELETE SET NULL)';
                  EXECUTE IMMEDIATE V_SQL;
                  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_1||'.'||V_CAMPO_2||'... FK Modificada');
              
              --Si no existe la columna, la creamos y establecemos la FK
              ELSE
                  V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_1||' ADD ('||V_CAMPO_2||' NUMBER(16,0) )';
                  EXECUTE IMMEDIATE V_SQL;
                  DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.'||V_TABLA_1||'.'||V_CAMPO_2||'... Creada');

                  -- Creamos comentario	
                  V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA_1||'.'||V_CAMPO_2||' IS ''ID Estados cartera BC''';		
                  EXECUTE IMMEDIATE V_SQL;
                  
                  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA_1||'... Comentario en columna creado.');

                  -- Creamos FK	
                  V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_1||' ADD (CONSTRAINT FK_GEN_'||V_CAMPO_2||' FOREIGN KEY 
                                        ('||V_CAMPO_2||') REFERENCES '||V_ESQUEMA||'.'||V_TABLA_2||' ('||V_CAMPO_2||') ON DELETE SET NULL)';
                  EXECUTE IMMEDIATE V_SQL;
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

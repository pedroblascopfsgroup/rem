--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210512
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-88888
--## PRODUCTO=NO
--##
--## Finalidad:        Anyadir columna a la BIE_LOCALIZACION
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
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
	V_USR VARCHAR2(30 CHAR) := 'HREOS-88888'; 			-- USUARIOCREAR/USUARIOMODIFICAR.
	V_TABLA VARCHAR2(2400 CHAR) := 'ACT_LOC_LOCALIZACION'; 		-- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
	-- ARRAY CON NUEVAS COLUMNAS
	TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
	TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
	V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
		-- 		NOMBRE CAMPO 				TIPO CAMPO 					DEFAULT 		DESCRIPCION
		T_ALTER('LOC_DIRECCION_DOS', 		'VARCHAR2(250 CHAR)', 		'', 			'Complemento de la calle.')
	);
	V_T_ALTER T_ALTER;
	
	
BEGIN
	-- Bucle que CREA las nuevas columnas 
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST LOOP
		V_T_ALTER := V_ALTER(I);
		
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.'||V_T_ALTER(1)||' Comprobando si ya existe...');
		-- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(1)||''' AND TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;	
		
		IF V_NUM_TABLAS = 0 THEN
			--No existe la columna y la creamos
			DBMS_OUTPUT.PUT_LINE('	[OK] No existe '''||V_T_ALTER(1)||'''. Insertando...');
			V_SQL := 'ALTER TABLE '||V_TABLA|| ' ADD ('||V_T_ALTER(1)||' '||V_T_ALTER(2)||' '||V_T_ALTER(3)||')';
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('	[INFO] El campo '''||V_T_ALTER(1)||''' ha sido insertado correctamente en la tabla, con tipo '''||V_T_ALTER(2)||''' y restricción '''||V_T_ALTER(3)||'''.');
			
			-- Creamos comentario
			V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_T_ALTER(1)||' IS '''||V_T_ALTER(4)||'''';
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('	[INFO] Comentario de campo creado.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('	[ERROR] El campo ya existe. No se hace nada.');
		END IF;
	END LOOP;
	
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

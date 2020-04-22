--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=202004212
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10134
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en GPV_GASTOS_PROVEEDOR los campos GPV_SUPLIDOS_VINCULADOS y GPV_NUMERO_FACTURA_PPAL.
--## INSTRUCCIONES:
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################
--*/

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
	V_NUM NUMBER(16); 
	
	V_TABLA VARCHAR2(27 CHAR) := 'GPV_GASTOS_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USU VARCHAR2(30 CHAR) := 'HREOS-10134'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

	TYPE T_VAR IS TABLE OF VARCHAR2(100);
	TYPE T_ARRAY_VAR IS TABLE OF T_VAR;
	V_VAR T_ARRAY_VAR := T_ARRAY_VAR(
	-- COLUMN 								TYPE 					DEFAULT
		T_VAR('GPV_SUPLIDOS_VINCULADOS', 	'NUMBER(16,0)', 		'DEFAULT 2'), 
		T_VAR('GPV_NUMERO_FACTURA_PPAL', 	'VARCHAR2(128 CHAR)', 	'')
	); 
	V_TMP_VAR T_VAR;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Verificando si la tabla '''||V_TABLA||''' existe...');
	V_SQL := 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM = 1 THEN
		FOR I IN V_VAR.FIRST .. V_VAR.LAST LOOP
			V_TMP_VAR := V_VAR(I);
			
			DBMS_OUTPUT.PUT_LINE('	[INFO] Añadiendo el campo '''||V_TMP_VAR(1)||'''...');
			V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_TMP_VAR(1)||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM;
			
			IF V_NUM = 0 THEN
				V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD ('||V_TMP_VAR(1)||' '||V_TMP_VAR(2)||' '||V_TMP_VAR(3)||')';
				EXECUTE IMMEDIATE V_SQL;
				DBMS_OUTPUT.PUT_LINE('	[OK] Campo añadido.');
				
			ELSE
				DBMS_OUTPUT.PUT_LINE('	[ERROR] El campo ya existe.');
			END IF;
		END LOOP;
		
		EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TABLA||''' AND CONSTRAINT_NAME = ''FK_GPV_SUPLIDOS_VINCULADOS''' INTO V_NUM;
		IF V_NUM = 0 THEN
			V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_GPV_SUPLIDOS_VINCULADOS FOREIGN KEY (GPV_SUPLIDOS_VINCULADOS) REFERENCES '||V_ESQUEMA_M||'.DD_SIN_SINO(DD_SIN_ID))';
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('	[INFO] Foreign key FK_GPV_SUPLIDOS_VINCULADOS - DD_SIN_ID creada');
		ELSE
			DBMS_OUTPUT.PUT_LINE('	[ERROR] Ya existe la foreign key FK_GPV_SUPLIDOS_VINCULADOS para DD_SIN_SINO.DD_SIN_ID.');
		END IF;
	END IF;
	
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TABLA||' actualizada correctamente.');


EXCEPTION
	WHEN OTHERS THEN
		err_num := SQLCODE;
		err_msg := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(err_msg);
		ROLLBACK;
		RAISE;          

END;
/
EXIT

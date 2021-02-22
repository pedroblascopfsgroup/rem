--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20210205
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-00000
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla H_REENVIO_GASTOS
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM NUMBER(16); -- Vble. para validar la existencia de una tabla.  
	V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	V_TABLA VARCHAR2(2400 CHAR) := 'H_REENVIO_GASTOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
	TYPE T_COMMENT IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_COMMENT IS TABLE OF T_COMMENT;
	V_COMMENT T_ARRAY_COMMENT := T_ARRAY_COMMENT(
	-- 	COLUMN 							COMMENT
		T_COMMENT('GPV_ID', 			'Gasto reenviado'),
		T_COMMENT('USUARIO', 			'Indica el usuario que modificó el registro.'),
		T_COMMENT('FECHA', 				'Indica la fecha de reautorización.'),
		T_COMMENT('DD_EGA_ID', 			'Indica el estado del gasto cuando se reautorizó.'),
		T_COMMENT('DD_EAH_ID', 			'Indica el estado del gasto cuando se reautorizó.'),
		T_COMMENT('DD_EAP_ID', 			'Indica el estado del gasto cuando se reautorizó.')
	); 
	V_TMP_COMMENT T_COMMENT;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	-- Verificar si la tabla ya existe
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN
		
		-- Creamos la tabla
		DBMS_OUTPUT.PUT_LINE('	[INFO] Creando tabla '||V_ESQUEMA||'.'||V_TABLA||'...');
		V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
			GPV_ID 		 	NUMBER(16,0) 			NOT NULL ENABLE, 
			USUARIO 		VARCHAR2(50 CHAR) 		NOT NULL ENABLE, 
			FECHA 			TIMESTAMP (6) 			NOT NULL ENABLE,
			DD_EGA_ID		NUMBER(16,0),
			DD_EAH_ID		NUMBER(16,0),
			DD_EAP_ID		NUMBER(16,0)
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('	[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');
	END IF;

	-- Creamos comentarios
	FOR I IN V_COMMENT.FIRST .. V_COMMENT.LAST LOOP
		V_TMP_COMMENT := V_COMMENT(I);
		
		V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.'||TRIM(V_TMP_COMMENT(1))||' IS '''||TRIM(V_TMP_COMMENT(2))||'''';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('	[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

	COMMIT;

EXCEPTION
	WHEN OTHERS THEN 
		DBMS_OUTPUT.PUT_LINE('KO!');
		err_num := SQLCODE;
		err_msg := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(err_msg);
		DBMS_OUTPUT.put_line('-----------------------V_SQL--------------------------------'); 
		DBMS_OUTPUT.put_line(V_SQL); 
		ROLLBACK;
		RAISE;
END;
/
EXIT;

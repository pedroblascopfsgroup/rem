--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20200710
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10525
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla PFA_ALB
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
	
	V_TABLA VARCHAR2(2400 CHAR) := 'PFA_ALB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	--V_PK_COLUMN VARCHAR2(500 CHAR):= 'GSS_ID'; -- Vble. para la columna PK
	--V_UK_COLUMN VARCHAR2(500 CHAR):= 'GSS_ID'; -- Vble. para la columna UK
	
	TYPE T_FK IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_FK IS TABLE OF T_FK;
	V_FK T_ARRAY_FK := T_ARRAY_FK(
	-- 	COLUMN 					COLUMN 			TABLE 					FK_NAME
		T_FK('PFA_ID', 			'PFA_ID', 		'PFA_PREFACTURA', 		'FK_PFA_ALB_PFA_ID'), 
		T_FK('ALB_ID', 			'ALB_ID', 		'ALB_ALBARAN', 			'FK_PFA_ALB_ALB_ID')
	); 
	V_TMP_FK T_FK;
	
	TYPE T_COMMENT IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_COMMENT IS TABLE OF T_COMMENT;
	V_COMMENT T_ARRAY_COMMENT := T_ARRAY_COMMENT(
	-- 	COLUMN 							COMMENT
		T_COMMENT('PFA_ID', 			'Prefactura.'), 
		T_COMMENT('ALB_ID', 			'Albarán.'),
		T_COMMENT('VERSION', 			'Indica la versión del registro.')
	); 
	V_TMP_COMMENT T_COMMENT;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	-- Verificar si la tabla ya existe
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 1 THEN
		DBMS_OUTPUT.PUT_LINE('	[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
	END IF;

	-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM; 
	IF V_NUM = 1 THEN
		DBMS_OUTPUT.PUT_LINE('	[INFO] '|| V_ESQUEMA ||'.S_'||V_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
	END IF; 
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('	[INFO] Creando tabla '||V_ESQUEMA||'.'||V_TABLA||'...');
	V_SQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TABLA||' (
		PFA_ID 				NUMBER(16,0) 			NOT NULL, 
		ALB_ID 				NUMBER(16,0) 			NOT NULL ENABLE, 
		VERSION 			NUMBER(38,0) 			DEFAULT 0 NOT NULL ENABLE
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');
	
	-- Creamos índice
	--V_SQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TABLA||'_PK ON '||V_ESQUEMA||'.'||V_TABLA||'('||TRIM(V_PK_COLUMN)||') TABLESPACE '||V_TABLESPACE_IDX;
	--EXECUTE IMMEDIATE V_SQL;
	--DBMS_OUTPUT.PUT_LINE('	[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... Indice creado.');
	
	-- Creamos primary key
	--V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY ('||TRIM(V_PK_COLUMN)||') USING INDEX)';
	--EXECUTE IMMEDIATE V_SQL;
	--DBMS_OUTPUT.PUT_LINE('	[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... PK creada.');
	
	-- Verificar si la UK existe y, si no es así, la creamos:
	--DBMS_OUTPUT.PUT_LINE('	[INFO] Verificando si existe la clave única ''UK_'||V_UK_COLUMN||'''');
	--V_SQL := 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''UK_'||V_UK_COLUMN||'''';
	--EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	--IF V_NUM = 0 THEN
	--	DBMS_OUTPUT.PUT_LINE('	[INFO] Añadiendo clave única...');
	--	EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT UK_'||V_UK_COLUMN||' UNIQUE ('||V_UK_COLUMN||')';
	--	DBMS_OUTPUT.PUT_LINE('	[OK] Hecho.');
	--ELSE
	--	DBMS_OUTPUT.PUT_LINE('	[ERROR] La clave única UK_'||V_UK_COLUMN||' ya existe.');
	--END IF;
	
	-- Creamos secuencia
	V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||'... Secuencia creada');
	
	-- Creamos FK's
 	FOR I IN V_FK.FIRST .. V_FK.LAST LOOP
		V_TMP_FK := V_FK(I);
		
		EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TABLA||''' AND CONSTRAINT_NAME = '''||V_TMP_FK(4)||'''' INTO V_NUM;
		IF V_NUM = 0 THEN
			V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||TRIM(V_TMP_FK(4))||' FOREIGN KEY ('||TRIM(V_TMP_FK(1))||') REFERENCES '||V_ESQUEMA||'.'||TRIM(V_TMP_FK(3))||'('||TRIM(V_TMP_FK(2))||'))';
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('	[INFO] Foreign key '''||TRIM(V_TMP_FK(4))||''' creada');
		ELSE
			DBMS_OUTPUT.PUT_LINE('	[ERROR] Ya existe la foreign key '''||TRIM(V_TMP_FK(4))||'''.');
		END IF;
	END LOOP;

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

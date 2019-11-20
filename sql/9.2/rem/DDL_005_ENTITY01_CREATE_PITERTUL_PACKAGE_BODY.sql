--/*
--#########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20190307
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.1.0
--## INCIDENCIA_LINK=ARQ-1613
--## PRODUCTO=SI
--##
--## Finalidad: Crear nuevo cuerpo para el paquete pitertul en la DB.
--##
--## INSTRUCCIONES:
--## VERSIONES:
--##	0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	lt_procedures_collection DBMS_SQL.VARCHAR2A;
	lc_cursor INTEGER DEFAULT DBMS_SQL.OPEN_CURSOR;
	ln_result NUMBER DEFAULT 0;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[BEGIN]');

	DBMS_OUTPUT.PUT('[INFO] Create new PACKAGE BODY pitertul...');

	lt_procedures_collection(1) :=
	'create or replace PACKAGE BODY PITERTUL IS

		/*
		 *	@PRIVATE
		 *	Este procedimiento recibe una matriz con columnas para crear o modificar sobre la tabla que recibe por parámetro.
		 *	El procedimiento puede discernir entre la operación ADD o MODIFY de la tabla según ya existan o no las columnas.
		 *
		 *	@param TABLE_SCHEME VARCHAR2 Nombre del esquema en el que se encuentra la tabla.
		 *	@param TABLE_NAME VARCHAR2 Nombre de la tabla a la que añadir o modificar las columnas de la matriz.
		 *	@param TABLE_COLUMNS MATRIX_TABLE Matriz de columnas que componen la tabla. Si no existen se crean, si existen se modifican.
		 *	@param LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO (Opcional) Indica en el nivel de verbosidad del registro de sucesos.
		 */
		PROCEDURE private_add_or_modify_columns_to_table(TABLE_SCHEME VARCHAR2, TABLE_NAME VARCHAR2, TABLE_COLUMNS MATRIX_TABLE, LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO) AS
			V_TMP ARRAY_TABLE;
			V_COUNT NUMBER(1);
			V_COUNT_2 NUMBER(1);

		BEGIN

			IF TABLE_COLUMNS.FIRST IS NOT NULL THEN
				FOR col_index IN TABLE_COLUMNS.FIRST .. TABLE_COLUMNS.LAST
				LOOP
					V_TMP := TABLE_COLUMNS(col_index);

					EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''''''||V_TMP(1)||'''''' and TABLE_NAME = ''''''||TABLE_NAME||'''''' and owner = ''''''||TABLE_SCHEME||'''''''' INTO V_COUNT;

					IF V_COUNT = 0 THEN
						IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
							DBMS_OUTPUT.PUT(''[INFO]		 Add column ''||V_TMP(1)||'' ''||V_TMP(2)||''...'');
						END IF;

						EXECUTE IMMEDIATE ''ALTER TABLE ''||TABLE_SCHEME||''.''||TABLE_NAME||'' ADD (''||UPPER(V_TMP(1))||'' ''||V_TMP(2)||'')'';

					ELSE
						IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
							DBMS_OUTPUT.PUT(''[INFO]		 Modify column ''||V_TMP(1)||'' ''||V_TMP(2)||''...'');
						END IF;

						-- Debido a limitaciones de Oracle para soportar el atributo ''null'' o ''not null'' cuando una columna ya se encuentra en ese modo:
						EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''''''||V_TMP(1)||'''''' and TABLE_NAME = ''''''||TABLE_NAME||'''''' and owner = ''''''||TABLE_SCHEME||'''''' and NULLABLE = ''''Y'''''' INTO V_COUNT;
						EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ''||TABLE_SCHEME||''.''||TABLE_NAME||'' WHERE ROWNUM = 1'' INTO V_COUNT_2;

						CASE
							WHEN V_COUNT = 0 AND UPPER(V_TMP(2)) LIKE ''%NOT NULL%'' THEN
								-- Si la columna ya se encuentra en no nulable quitar not null de los atributos.
								EXECUTE IMMEDIATE ''ALTER TABLE ''||TABLE_SCHEME||''.''||TABLE_NAME||'' MODIFY (''||V_TMP(1)||'' ''||REGEXP_REPLACE(UPPER(V_TMP(2)), ''NOT NULL'', '''')||'')'';

							WHEN V_COUNT = 1 AND UPPER(V_TMP(2)) LIKE ''%NULL%'' AND UPPER(V_TMP(2)) NOT LIKE ''%NOT NULL%'' THEN
								-- Si la columna ya se encuentra en nulable quitar null de los atributos.
								EXECUTE IMMEDIATE ''ALTER TABLE ''||TABLE_SCHEME||''.''||TABLE_NAME||'' MODIFY (''||V_TMP(1)||'' ''||REGEXP_REPLACE(UPPER(V_TMP(2)), ''NULL'', '''')||'')'';

							WHEN V_COUNT = 0 AND UPPER(V_TMP(2)) LIKE ''%NULL%'' AND UPPER(V_TMP(2)) NOT LIKE ''%NOT NULL%'' THEN
								-- Si la columna no es nulable y se quiere pasar a nulable
								EXECUTE IMMEDIATE ''ALTER TABLE ''||TABLE_SCHEME||''.''||TABLE_NAME||'' MODIFY (''||V_TMP(1)||'' ''||V_TMP(2)||'')'';

							WHEN V_COUNT = 1 AND UPPER(V_TMP(2)) LIKE ''%NOT NULL%'' AND V_COUNT_2 > 0 THEN
								-- Si la columna ya se encuentra en nulable y se quiere pasar a no nulable en una tabla no vacía
								raise_application_error(-20006, ''It is forbidden to change the NULL attribute of a column when the table has data'');

							ELSE
								EXECUTE IMMEDIATE ''ALTER TABLE ''||TABLE_SCHEME||''.''||TABLE_NAME||'' MODIFY (''||V_TMP(1)||'' ''||V_TMP(2)||'')'';

						END CASE;
					END IF;

					EXECUTE IMMEDIATE ''COMMENT ON COLUMN ''||TABLE_SCHEME||''.''||TABLE_NAME||''.''||V_TMP(1)||'' IS ''''''||V_TMP(3)||'''''''';

					IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
						DBMS_OUTPUT.PUT_LINE(''and commentary...DONE'');
					END IF;

				END LOOP;

				IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

			ELSE
				IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
					DBMS_OUTPUT.PUT_LINE(''NONE'');
				END IF;
			END IF;

		END;';

		lt_procedures_collection(2) :=
		'

		/*
		 *	@PUBLIC
		 *	Este procedimiento recibe una matriz con índices para crear o modificar sobre las columnas de la tabla que recibe por parámetro.
		 *	El procedimiento trata  los índices respetando las propias columnas afectadas y el orden de las mismas. Si encuentra que ya existe
		 *	una casuística similar, muestra un mensaje y continua.
		 *
		 *	@param TABLE_SCHEME VARCHAR2 Nombre del esquema en el que se encuentra la tabla.
		 *	@param TABLE_NAME VARCHAR2 Nombre de la tabla a la que añadir o modificar las columnas de la matriz.
		 *	@param TABLE_INDEX MATRIX_TABLE (Opcional) Coleccion de índices para generar en la tabla.
		 *	@param LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO (Opcional) Indica en el nivel de verbosidad del registro de sucesos.
		 */
		PROCEDURE private_add_index_to_table(TABLE_SCHEME VARCHAR2, TABLE_NAME VARCHAR2, TABLE_CHARS VARCHAR2, TABLE_INDEX MATRIX_TABLE, LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO) AS
			V_TMP ARRAY_TABLE;
			V_COUNT NUMBER(1);

		BEGIN

			IF TABLE_INDEX.FIRST IS NOT NULL THEN
				FOR i_index IN TABLE_INDEX.FIRST .. TABLE_INDEX.LAST
				LOOP
					V_TMP := TABLE_INDEX(i_index);

					EXECUTE IMMEDIATE ''SELECT count(1) FROM (SELECT INDEX_NAME, listagg(column_name, '''','''') within group (order by column_position) COLUMNS FROM ALL_IND_COLUMNS WHERE table_name = ''''''||TABLE_NAME||''''''
					and index_owner= ''''''||TABLE_SCHEME||'''''' GROUP BY INDEX_NAME) INDEX_LIST WHERE INDEX_LIST.COLUMNS = ''''''||REGEXP_REPLACE(V_TMP(2), '' '', '''')||'''''''' INTO V_COUNT;

					IF V_COUNT = 0 THEN
						IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
							DBMS_OUTPUT.PUT(''[INFO]		 Create index on column/s: ''||V_TMP(2)||''...'');
						END IF;

						EXECUTE IMMEDIATE ''SELECT COUNT(UNIQUE index_name)+1 FROM all_ind_columns WHERE table_name = ''''''||TABLE_NAME||'''''' AND index_owner = ''''''||TABLE_SCHEME||'''''''' INTO V_COUNT;

						CASE
							WHEN V_TMP(1) = INDEX_TYPE.NORMAL THEN
								EXECUTE IMMEDIATE ''CREATE INDEX ''||TABLE_CHARS||''_IDX''||V_COUNT||'' ON ''||TABLE_SCHEME||''.''||TABLE_NAME||'' (''||V_TMP(2)||'')'';

							WHEN V_TMP(1) = INDEX_TYPE.BITMAP THEN
								EXECUTE IMMEDIATE ''CREATE BITMAP INDEX ''||TABLE_CHARS||''_IDX''||V_COUNT||'' ON ''||TABLE_SCHEME||''.''||TABLE_NAME||'' (''||V_TMP(2)||'')'';

							ELSE
								NULL;
						END CASE;

						IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
							DBMS_OUTPUT.PUT_LINE(''DONE'');
						END IF;
					ELSE
						IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
							DBMS_OUTPUT.PUT_LINE(''[INFO]		 ''||TABLE_SCHEME||''.''||TABLE_NAME||'' already has an index with those columns: ''||V_TMP(2));
						END IF;
					END IF;

				END LOOP;

				IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

			ELSE
				IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
					DBMS_OUTPUT.PUT_LINE(''NONE'');
				END IF;
			END IF;

		END;';

		lt_procedures_collection(3) :=
		'

		/*
		 *	@PRIVATE
		 *	Este procedimiento genera columnas de auditoría estándar a la tabla que recibe como parámetro.
		 *
		 *	@param TABLE_SCHEME VARCHAR2 Nombre del esquema en el que se encuentra la tabla.
		 *	@param TABLE_NAME VARCHAR2 Nombre de la tabla a la que añadir las columnas de auditoría.
		 *	@param LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO (Opcional) Indica en el nivel de verbosidad del registro de sucesos.
		 */
		PROCEDURE private_set_audit_to_table (TABLE_SCHEME VARCHAR2, TABLE_NAME VARCHAR2, LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO) AS

			AUDIT_COLUMNS MATRIX_TABLE := MATRIX_TABLE(
			--				NOMBRE						TIPO COLUMNA									COMENTARIO
				ARRAY_TABLE(''VERSION'',				''NUMBER(38,0) DEFAULT 0 NOT NULL'',		''Indica la versión de la modificación del registro.''),
				ARRAY_TABLE(''USUARIOCREAR'',			''VARCHAR2(50 CHAR) NOT NULL'', 			''Indica el usuario que ha creado el registro.''),
				ARRAY_TABLE(''FECHACREAR'',				''TIMESTAMP(6) NOT NULL'', 					''Indica la fecha en la que se ha creado el registro.''),
				ARRAY_TABLE(''USUARIOMODIFICAR'',		''VARCHAR2(50 CHAR)'',						''Indica el usuario que ha modificado el registro.''),
				ARRAY_TABLE(''FECHAMODIFICAR'',			''TIMESTAMP(6)'',							''Indica la fecha en la que se ha modificado el registro.''),
				ARRAY_TABLE(''USUARIOBORRAR'',			''VARCHAR2(50 CHAR)'',						''Indica el usuario que ha borrado el registro.''),
				ARRAY_TABLE(''FECHABORRAR'', 			''TIMESTAMP(6)'',							''Indica la fecha en la que se ha borrado el registro.''),
				ARRAY_TABLE(''BORRADO'', 				''NUMBER(1,0) DEFAULT 0 NOT NULL'',			''Indica la fecha en la que se ha borrado el registro.'')
			);

		BEGIN

			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT_LINE(''[INFO] Setting up audit on ''|| TABLE_SCHEME ||''.''|| TABLE_NAME ||'':'');
			ELSE
				DBMS_OUTPUT.PUT(''[INFO] Setting up audit on ''|| TABLE_SCHEME ||''.''|| TABLE_NAME ||''...'');
			END IF;

			private_add_or_modify_columns_to_table(TABLE_SCHEME, TABLE_NAME, AUDIT_COLUMNS, LOG_LEVEL);

		END;';

		lt_procedures_collection(4) :=
		'

		/*
		 *	@PUBLIC
		 *	Este procedimiento genera una nueva tabla o modifica la estructura de una tabla ya existente.
		 *
		 *	@param TABLE_SCHEME VARCHAR2 Nombre del esquema en el que se encuentra o se crea la tabla.
		 *	@param TABLESPACE_IDX VARCHAR2 Nombre del tablespace en el que se encuentra o se crea la tabla.
		 *	@param TABLE_NAME VARCHAR2 Nombre de la tabla a crear o modificar.
		 *	@param TABLE_COMMENT VARCHAR2 Comentario de tabla.
		 *	@param TABLE_COLUMNS MATRIX_TABLE Matriz de columnas que componen la tabla. Si no existen se crean, si existen se modifican.
		 *	@param COLUMNS_FK MATRIX_TABLE DEFAULT NULL (opcional) Matriz de claves foraneas que se establecen sobre las columnas de la tabla.
		 *	@param TABLE_INDEX MATRIX_TABLE (Opcional) Coleccion de índices para generar en la tabla.
		 *	@param LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO (Opcional) Indica en el nivel de verbosidad del registro de sucesos.
		 */
		PROCEDURE create_or_modify_common_table(TABLE_SCHEME VARCHAR2, TABLESPACE_IDX VARCHAR2, TABLE_NAME VARCHAR2, TABLE_COMMENT VARCHAR2, TABLE_COLUMNS MATRIX_TABLE, TABLE_HAS_AUDIT BOOLEAN DEFAULT TRUE, COLUMNS_FK MATRIX_TABLE DEFAULT NULL, TABLE_INDEX MATRIX_TABLE DEFAULT NULL, LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO) AS
			V_COUNT NUMBER(2);
			V_ELAPSED_TIME NUMBER;
			V_TMP ARRAY_TABLE;
			V_TABLE_CHARS VARCHAR2(3 CHAR);
			V_TABLE_NAME VARCHAR2(125 CHAR);
			V_ORACLE_ENVIRONMENT_VERSION VARCHAR(100 CHAR);
			V_ORACLE_ENV_MAX_TABLE_CHARS NUMBER(3);
			V_ORACLE_ENVIRONMENT_MAX_CHARS NUMBER(3);

		BEGIN

			DBMS_OUTPUT.ENABLE(buffer_size => NULL);
			V_ELAPSED_TIME := DBMS_UTILITY.GET_TIME;

			-- Obtener entorno de ejecución
			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				EXECUTE IMMEDIATE ''SELECT BANNER FROM v$version where BANNER like ''''Oracle%'''''' INTO V_ORACLE_ENVIRONMENT_VERSION;
				DBMS_OUTPUT.PUT_LINE(''[DEBUG] ''||V_ORACLE_ENVIRONMENT_VERSION);
			END IF;

			-- Obtener carácteres máximos del entorno
			EXECUTE IMMEDIATE ''SELECT DATA_LENGTH FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''''ALL_TAB_COLUMNS'''' AND COLUMN_NAME = ''''TABLE_NAME'''''' INTO V_ORACLE_ENVIRONMENT_MAX_CHARS;
			V_ORACLE_ENV_MAX_TABLE_CHARS := V_ORACLE_ENVIRONMENT_MAX_CHARS-3;
			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT_LINE(''[DEBUG] Oracle environment machine supports up to ''||V_ORACLE_ENVIRONMENT_MAX_CHARS||'' characters on names'');
			END IF;

			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT(''[DEBUG] Checking mandatory parameters...'');
			END IF;

			-- Comprobar parámetros obligatorios de entrada
			IF TABLE_SCHEME IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_SCHEME ; Parameter position: 1'');
			END IF;

			IF TABLESPACE_IDX IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLESPACE_IDX ; Parameter position: 2'');
			END IF;

			IF TABLE_NAME IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_NAME ; Parameter position: 3'');
			END IF;

			IF TABLE_COMMENT IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_COMMENT ; Parameter position: 4'');
			END IF;

			IF TABLE_COLUMNS IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_COLUMNS ; Parameter position: 5'');
			END IF;

			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			V_TABLE_NAME := UPPER(TABLE_NAME);

			-- Comprobar longitud de carácteres en el nombre de la tabla
			IF LENGTH(V_TABLE_NAME) > V_ORACLE_ENV_MAX_TABLE_CHARS THEN
				raise_application_error(-20002, ''The table name exceeds the length available on the environment machine. The oracle environment machine supports no more than ''||V_ORACLE_ENV_MAX_TABLE_CHARS||'' characters per name on tables'');
			END IF;

			-- Comprobar que el nombre de tabla empieza por tres carácteres y una barra baja
			EXECUTE IMMEDIATE ''SELECT COUNT(1)  FROM DUAL WHERE REGEXP_SUBSTR(''''''||V_TABLE_NAME||'''''',''''^..._'''') IS NOT NULL'' INTO V_COUNT;
			IF V_COUNT < 1 THEN
				raise_application_error(-20003, ''Is mandatory that table name starts with 3 letters plus undescore (XXX_TABLE_NAME_EXAMPLE)'');
			END IF;

			-- Obtener carácteres identificativos de la tabla
			V_TABLE_CHARS := SUBSTR(V_TABLE_NAME, 1, 3);
			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT_LINE(''[DEBUG] Acquired table identifier chars: '' || V_TABLE_CHARS);
			END IF;

			-- Comprobar longitud de carácteres en el nombre de las columnas
			FOR col_index IN TABLE_COLUMNS.FIRST .. TABLE_COLUMNS.LAST
			LOOP
				V_TMP := TABLE_COLUMNS(col_index);

				IF LENGTH(V_TMP(1)) > V_ORACLE_ENVIRONMENT_MAX_CHARS THEN
					raise_application_error(-20002, ''The column name in ''||V_TMP(1)||'' exceeds the length available on the environment machine. The oracle environment machine supports no more than ''||V_ORACLE_ENVIRONMENT_MAX_CHARS||'' characters per name on columns'');
				END IF;

			END LOOP;

			-- Inicia el proceso DDL
			DBMS_OUTPUT.PUT_LINE(''[BEGIN]'');

			EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''''''||V_TABLE_NAME||'''''' and owner = ''''''||TABLE_SCHEME||'''''''' INTO V_COUNT;

			IF V_COUNT = 0 THEN
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT_LINE(''[INFO] Table ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||'' not exists, creating:'');
				ELSE
					DBMS_OUTPUT.PUT(''[INFO] Table ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||'' not exists, creating...'');
				END IF;

				-- Crear la tabla base con columna del identificador único
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT(''[INFO]		 Create base table ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||''...'');
				END IF;
				EXECUTE IMMEDIATE ''CREATE TABLE ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||'' (''||V_TABLE_CHARS||''_ID NUMBER(16,0) NOT NULL) LOGGING NOCOMPRESS NOCACHE NOPARALLEL NOMONITORING'';
				EXECUTE IMMEDIATE ''COMMENT ON COLUMN ''||TABLE_SCHEME||''.''||V_TABLE_NAME||''.''||V_TABLE_CHARS||''_ID IS ''''Indica el código identificador único del registro.'''''';
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

				-- Crear sequence
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT(''[INFO]		 Create sequence ''|| TABLE_SCHEME ||''.S_''|| V_TABLE_NAME ||''...'');
				END IF;
				EXECUTE IMMEDIATE ''CREATE SEQUENCE ''||TABLE_SCHEME||''.S_''||V_TABLE_NAME||'''';
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

				-- Crear índice para la columna del identificador único
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT(''[INFO]		 Unique index on '' ||TABLE_SCHEME||''.''||V_TABLE_NAME||''.''||V_TABLE_CHARS||''_ID...'');
				END IF;
				EXECUTE IMMEDIATE ''CREATE UNIQUE INDEX ''||V_TABLE_CHARS||''_IDX_PK ON ''||TABLE_SCHEME||''.''||V_TABLE_NAME||''(''||V_TABLE_CHARS||''_ID) TABLESPACE ''||TABLESPACE_IDX;
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

				-- Crear primary key para la columna del identificador único
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT(''[INFO]		 Primary Key on '' ||TABLE_SCHEME||''.''||V_TABLE_NAME||''.''||V_TABLE_CHARS||''_ID...'');
				END IF;
				EXECUTE IMMEDIATE ''ALTER TABLE ''||TABLE_SCHEME||''.''||V_TABLE_NAME||'' ADD (CONSTRAINT ''||V_TABLE_CHARS||''_PK PRIMARY KEY (''||V_TABLE_CHARS||''_ID) USING INDEX)'';
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

				-- Crear comentario de tabla
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT(''[INFO]		 Comment on table '' ||TABLE_SCHEME||''.''||V_TABLE_NAME||''...'');
				END IF;
				EXECUTE IMMEDIATE ''COMMENT ON TABLE ''||TABLE_SCHEME||''.''||V_TABLE_NAME||'' IS ''''''||TABLE_COMMENT||'''''''';
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

				IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

			ELSE
				DBMS_OUTPUT.PUT_LINE(''[INFO] Table ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||'' already exists.'');

			END IF;

			-- Alterar las columnas de la tabla
			DBMS_OUTPUT.PUT_LINE(''[INFO]'');
			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT_LINE(''[INFO] Alter ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||'' columns:'');
			ELSE
				DBMS_OUTPUT.PUT(''[INFO] Alter ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||'' columns...'');
			END IF;
			private_add_or_modify_columns_to_table(TABLE_SCHEME, V_TABLE_NAME, TABLE_COLUMNS, LOG_LEVEL);

			-- Establecer auditoria en la tabla
			DBMS_OUTPUT.PUT_LINE(''[INFO]'');
			IF TABLE_HAS_AUDIT THEN
				private_set_audit_to_table(TABLE_SCHEME, V_TABLE_NAME, LOG_LEVEL);
			END IF;

			-- Crear fks
			DBMS_OUTPUT.PUT_LINE(''[INFO]'');
			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT_LINE(''[INFO] Foreign Keys on '' ||TABLE_SCHEME||''.''||V_TABLE_NAME||'':'');
			ELSE
				DBMS_OUTPUT.PUT(''[INFO] Foreign Keys on '' ||TABLE_SCHEME||''.''||V_TABLE_NAME||''...'');
			END IF;
			IF COLUMNS_FK.FIRST IS NOT NULL THEN
				FOR fk_index IN COLUMNS_FK.FIRST .. COLUMNS_FK.LAST
				LOOP
					V_TMP := COLUMNS_FK(fk_index);

					EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ALL_CONSTRAINTS CONS INNER JOIN ALL_CONS_COLUMNS COL ON COL.CONSTRAINT_NAME = CONS.CONSTRAINT_NAME WHERE CONS.OWNER = ''''''||V_TMP(1)||''''''
					AND CONS.TABLE_NAME = ''''''||V_TMP(2)||'''''' AND CONS.CONSTRAINT_TYPE = ''''R'''' AND COL.COLUMN_NAME = ''''''||V_TMP(3)||'''''''' INTO V_COUNT;

					IF V_COUNT = 0 THEN
						EXECUTE IMMEDIATE ''SELECT COUNT(1)+1 FROM ALL_CONSTRAINTS CONS INNER JOIN ALL_CONS_COLUMNS COL ON COL.CONSTRAINT_NAME = CONS.CONSTRAINT_NAME
						WHERE CONS.OWNER = ''''''||V_TMP(1)||'''''' AND CONS.TABLE_NAME = ''''''||V_TMP(2)||'''''' AND CONS.CONSTRAINT_TYPE = ''''R'''''' INTO V_COUNT;

						IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
							DBMS_OUTPUT.PUT(''[INFO]		 Create foreign Key ''||V_TABLE_CHARS||''_FK''||V_COUNT||''...'');
						END IF;

						EXECUTE IMMEDIATE ''ALTER TABLE ''||V_TMP(1)||''.''||V_TMP(2)||'' ADD (CONSTRAINT ''||V_TABLE_CHARS||''_FK''||V_COUNT||'' FOREIGN KEY (''||V_TMP(3)||'')
						REFERENCES ''||V_TMP(4)||''.''||V_TMP(5)||'' (''||V_TMP(6)||'') ON DELETE SET NULL)'';

						IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
							DBMS_OUTPUT.PUT_LINE(''DONE'');
						END IF;

					ELSE
						IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
							DBMS_OUTPUT.PUT_LINE(''[INFO]		 Column ''||V_TMP(3)||'' already has a foreign key to ''||V_TMP(5)||''.''||V_TMP(6)||'''');
						END IF;
					END IF;

				END LOOP;

				IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

			ELSE
				IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
					DBMS_OUTPUT.PUT_LINE(''NONE'');
				END IF;
			END IF;

			-- Crear índices en la tabla
			DBMS_OUTPUT.PUT_LINE(''[INFO]'');
			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT_LINE(''[INFO] Index on ''||TABLE_SCHEME||''.''||V_TABLE_NAME||'':'');
			ELSE
				DBMS_OUTPUT.PUT(''[INFO] Index on ''||TABLE_SCHEME||''.''||V_TABLE_NAME||''...'');
			END IF;
			private_add_index_to_table(TABLE_SCHEME, V_TABLE_NAME, V_TABLE_CHARS, TABLE_INDEX, LOG_LEVEL);

			COMMIT;

			DBMS_OUTPUT.PUT_LINE(''[INFO]'');

			DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');

			DBMS_OUTPUT.PUT_LINE(''[DONE]'');


			EXCEPTION
			WHEN MANDATORY_PARAMETERS_EMPTY THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;

			WHEN ORACLE_ENV_MAX_NAME_CHARS_EXCEED THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;

			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''[ERROR] An error ocurred while the execution of the script: ''||TO_CHAR(SQLCODE));
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;
		END;';

		lt_procedures_collection(5) :=
		'

		/*
		 *	@PUBLIC
		 *	Este procedimiento genera una nueva tabla diccionario o modifica la estructura de una tabla diccionario ya existente.
		 *
		 *	@param TABLE_SCHEME VARCHAR2 Nombre del esquema en el que se encuentra o se crea la tabla.
		 *	@param TABLESPACE_IDX VARCHAR2 Nombre del tablespace en el que se encuentra o se crea la tabla.
		 *	@param TABLE_NAME VARCHAR2 Nombre de la tabla a crear o modificar.
		 *	@param TABLE_COMMENT VARCHAR2 Comentario de tabla.
		 *	@param LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO (Opcional) Indica en el nivel de verbosidad del registro de sucesos.
		 */
		PROCEDURE create_dictionary(TABLE_SCHEME VARCHAR2, TABLESPACE_IDX VARCHAR2, TABLE_NAME VARCHAR2, TABLE_COMMENT VARCHAR2, LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO) AS
			V_COUNT NUMBER(2);
			V_ELAPSED_TIME NUMBER;
			V_TMP ARRAY_TABLE;
			V_TABLE_CHARS VARCHAR2(3 CHAR);
			V_TABLE_NAME VARCHAR2(125 CHAR);
			V_ORACLE_ENVIRONMENT_VERSION VARCHAR(100 CHAR);
			V_ORACLE_ENV_MAX_TABLE_CHARS NUMBER(3);
			V_ORACLE_ENVIRONMENT_MAX_CHARS NUMBER(3);
			TABLE_COLUMNS MATRIX_TABLE;

		BEGIN

			DBMS_OUTPUT.ENABLE(buffer_size => NULL);
			V_ELAPSED_TIME := DBMS_UTILITY.GET_TIME;

			-- Obtener entorno de ejecución
			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				EXECUTE IMMEDIATE ''SELECT BANNER FROM v$version where BANNER like ''''Oracle%'''''' INTO V_ORACLE_ENVIRONMENT_VERSION;
				DBMS_OUTPUT.PUT_LINE(''[DEBUG] ''||V_ORACLE_ENVIRONMENT_VERSION);
			END IF;

			-- Obtener carácteres máximos del entorno
			EXECUTE IMMEDIATE ''SELECT DATA_LENGTH FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''''ALL_TAB_COLUMNS'''' AND COLUMN_NAME = ''''TABLE_NAME'''''' INTO V_ORACLE_ENVIRONMENT_MAX_CHARS;
			V_ORACLE_ENV_MAX_TABLE_CHARS := V_ORACLE_ENVIRONMENT_MAX_CHARS-3;
			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT_LINE(''[DEBUG] Oracle environment machine supports up to ''||V_ORACLE_ENVIRONMENT_MAX_CHARS||'' characters on names'');
			END IF;

			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT(''[DEBUG] Checking mandatory parameters...'');
			END IF;

			-- Comprobar parámetros obligatorios de entrada
			IF TABLE_SCHEME IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_SCHEME ; Parameter position: 1'');
			END IF;

			IF TABLESPACE_IDX IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLESPACE_IDX ; Parameter position: 2'');
			END IF;

			IF TABLE_NAME IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_NAME ; Parameter position: 3'');
			END IF;

			IF TABLE_COMMENT IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_COMMENT ; Parameter position: 4'');
			END IF;

			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			V_TABLE_NAME := UPPER(TABLE_NAME);

			-- Comprobar longitud de carácteres en el nombre de la tabla
			IF LENGTH(V_TABLE_NAME) > V_ORACLE_ENV_MAX_TABLE_CHARS THEN
				raise_application_error(-20002, ''The table name exceeds the length available on the environment machine. The oracle environment machine supports no more than ''||V_ORACLE_ENV_MAX_TABLE_CHARS||'' characters per name on tables'');
			END IF;

			-- Comprobar que el nombre de tabla empieza por letras DD, una barraja, tres carácteres y una barra baja
			EXECUTE IMMEDIATE ''SELECT COUNT(1)  FROM DUAL WHERE REGEXP_SUBSTR(''''''||V_TABLE_NAME||'''''',''''^DD_..._'''') IS NOT NULL'' INTO V_COUNT;
			IF V_COUNT < 1 THEN
				raise_application_error(-20003, ''Is mandatory that table name starts with DD plus undescore plus 3 letters plus undescore (DD_XXX_TABLE_NAME_EXAMPLE)'');
			END IF;

			-- Obtener carácteres identificativos de la tabla
			V_TABLE_CHARS := SUBSTR(V_TABLE_NAME, 4, 3);
			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT_LINE(''[DEBUG] Acquired table identifier chars: '' || V_TABLE_CHARS);
			END IF;

			-- Declarar dinámicamente las columnas estándar de una tabla diccionario
			TABLE_COLUMNS := MATRIX_TABLE(
			--				NOMBRE												TIPO COLUMNA							COMENTARIO
				ARRAY_TABLE(''DD_''||V_TABLE_CHARS||''_CODIGO'',				''VARCHAR2(30 CHAR) NOT NULL'',			''Indica el código único del dato insertado.''),
				ARRAY_TABLE(''DD_''||V_TABLE_CHARS||''_DESCRIPCION'',			''VARCHAR2(100 CHAR) NULL'', 			''Indica una breve descripción del dato que será mostrada en la interfaz.''),
				ARRAY_TABLE(''DD_''||V_TABLE_CHARS||''_DESCRIPCION_LARGA'',		''VARCHAR2(250 CHAR) NULL'', 			''Indica una descripción del dato más extensa, a veces utilizada para explicar la naturaleza del dato.'')
			);

			-- Inicia el proceso DDL
			DBMS_OUTPUT.PUT_LINE(''[BEGIN]'');

			EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''''''||V_TABLE_NAME||'''''' and owner = ''''''||TABLE_SCHEME||'''''''' INTO V_COUNT;

			IF V_COUNT = 0 THEN
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT_LINE(''[INFO] Table ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||'' not exists, creating:'');
				ELSE
					DBMS_OUTPUT.PUT(''[INFO] Table ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||'' not exists, creating...'');
				END IF;

				-- Crear la tabla diccionario con columna del identificador único.
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT(''[INFO]		 Create base table ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||''...'');
				END IF;
				EXECUTE IMMEDIATE ''CREATE TABLE ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||'' (DD_''||V_TABLE_CHARS||''_ID NUMBER(16,0) NOT NULL) LOGGING NOCOMPRESS NOCACHE NOPARALLEL NOMONITORING'';
				EXECUTE IMMEDIATE ''COMMENT ON COLUMN ''||TABLE_SCHEME||''.''||V_TABLE_NAME||''.DD_''||V_TABLE_CHARS||''_ID IS ''''Indica el código identificador único del registro.'''''';
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

				-- Crear sequence.
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT(''[INFO]		 Create sequence ''|| TABLE_SCHEME ||''.S_''|| V_TABLE_NAME ||''...'');
				END IF;
				EXECUTE IMMEDIATE ''CREATE SEQUENCE ''||TABLE_SCHEME||''.S_''||V_TABLE_NAME||'''';
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

				-- Crear índice para la columna del identificador único.
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT(''[INFO]		 Unique index on '' ||TABLE_SCHEME||''.''||V_TABLE_NAME||''.DD_''||V_TABLE_CHARS||''_ID...'');
				END IF;
				EXECUTE IMMEDIATE ''CREATE UNIQUE INDEX ''||V_TABLE_CHARS||''_IDX_PK ON ''||TABLE_SCHEME||''.''||V_TABLE_NAME||''(DD_''||V_TABLE_CHARS||''_ID) TABLESPACE ''||TABLESPACE_IDX;
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

				-- Crear primary key para la columna del identificador único.
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT(''[INFO]		 Primary Key on '' ||TABLE_SCHEME||''.''||V_TABLE_NAME||''.DD_''||V_TABLE_CHARS||''_ID...'');
				END IF;
				EXECUTE IMMEDIATE ''ALTER TABLE ''||TABLE_SCHEME||''.''||V_TABLE_NAME||'' ADD (CONSTRAINT ''||V_TABLE_CHARS||''_PK PRIMARY KEY (DD_''||V_TABLE_CHARS||''_ID) USING INDEX)'';
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

				-- Crear comentario de tabla.
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT(''[INFO]		 Comment on table '' ||TABLE_SCHEME||''.''||V_TABLE_NAME||''...'');
				END IF;
				EXECUTE IMMEDIATE ''COMMENT ON TABLE ''||TABLE_SCHEME||''.''||V_TABLE_NAME||'' IS ''''''||TABLE_COMMENT||'''''''';
				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

				IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
					DBMS_OUTPUT.PUT_LINE(''DONE'');
				END IF;

			ELSE
				DBMS_OUTPUT.PUT_LINE(''[INFO] Table ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||'' already exists.'');

			END IF;

			-- Alterar las columnas de la tabla.
			DBMS_OUTPUT.PUT_LINE(''[INFO]'');
			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT_LINE(''[INFO] Alter ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||'' columns:'');
			ELSE
				DBMS_OUTPUT.PUT(''[INFO] Alter ''|| TABLE_SCHEME ||''.''|| V_TABLE_NAME ||'' columns...'');
			END IF;
			private_add_or_modify_columns_to_table(TABLE_SCHEME, V_TABLE_NAME, TABLE_COLUMNS, LOG_LEVEL);

			-- Establecer auditoria en la tabla
			DBMS_OUTPUT.PUT_LINE(''[INFO]'');
			private_set_audit_to_table(TABLE_SCHEME, V_TABLE_NAME, LOG_LEVEL);

			-- Crear índice para la columna del código de diccionario único.
			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT(''[INFO]		 Unique index on '' ||TABLE_SCHEME||''.''||V_TABLE_NAME||''.DD_''||V_TABLE_CHARS||''_CODIGO...'');
			END IF;
			EXECUTE IMMEDIATE ''CREATE UNIQUE INDEX ''||V_TABLE_CHARS||''_IDX1 ON ''||TABLE_SCHEME||''.''||V_TABLE_NAME||''(DD_''||V_TABLE_CHARS||''_CODIGO) TABLESPACE ''||TABLESPACE_IDX;
			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			COMMIT;

			DBMS_OUTPUT.PUT_LINE(''[INFO]'');

			DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');

			DBMS_OUTPUT.PUT_LINE(''[DONE]'');

			EXCEPTION
			WHEN MANDATORY_PARAMETERS_EMPTY THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;

			WHEN ORACLE_ENV_MAX_NAME_CHARS_EXCEED THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;

			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''[ERROR] An error ocurred while the execution of the script: ''||TO_CHAR(SQLCODE));
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;
		END;';

		lt_procedures_collection(6) :=
		'

		/*
		 *	@PUBLIC
		 *	Este procedimiento rellena los registros de una tabla diccionario por los parámetros que recibe.
		 *
		 *	@param TABLE_SCHEME VARCHAR2 Nombre del esquema en el que se encuentra la tabla.
		 *	@param TABLE_NAME VARCHAR2 Nombre de la tabla a la que añadir las columnas de auditoría.
		 *	@param TABLE_COLUMNS ARRAY_TABLE Colección de columnas a modificar en la tabla.
		 *	@param TABLE_DATA MATRIX_TABLE Matriz de datos para rellenar los registros de la tabla.
		 *	@param AUDIT_USER VARCHAR2 Indica el usuario que va a realizar la modificación. Quedará registrado en la auditoría de los registros afectados.
		 *	@param LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO (Opcional) Indica en el nivel de verbosidad del registro de sucesos.
		 */
		PROCEDURE insert_or_update_dictionary(TABLE_SCHEME VARCHAR2, TABLE_NAME VARCHAR2, TABLE_DATA MATRIX_TABLE, AUDIT_USER VARCHAR2, LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO) AS
			V_SEQUENCE_NEXT_ID NUMBER(16);
			V_COUNT NUMBER(2);
			V_ELAPSED_TIME NUMBER;
			V_TMP ARRAY_TABLE;
			V_TABLE_CHARS VARCHAR2(3 CHAR);
			V_TABLE_NAME VARCHAR2(125 CHAR);
			V_ROW_UPGRADES_COUNT NUMBER(6) := 0;
			V_ORACLE_ENVIRONMENT_VERSION VARCHAR(100 CHAR);

		BEGIN

			DBMS_OUTPUT.ENABLE(buffer_size => NULL);
			V_ELAPSED_TIME := DBMS_UTILITY.GET_TIME;

			-- Obtener entorno de ejecución
			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				EXECUTE IMMEDIATE ''SELECT BANNER FROM v$version where BANNER like ''''Oracle%'''''' INTO V_ORACLE_ENVIRONMENT_VERSION;
				DBMS_OUTPUT.PUT_LINE(''[DEBUG] ''||V_ORACLE_ENVIRONMENT_VERSION);
			END IF;

			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT(''[DEBUG] Checking mandatory parameters...'');
			END IF;

			-- Comprobar parámetros obligatorios de entrada
			IF TABLE_SCHEME IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_SCHEME ; Parameter position: 1'');
			END IF;

			IF TABLE_NAME IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_NAME ; Parameter position: 2'');
			END IF;

			IF TABLE_DATA IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_DATA ; Parameter position: 3'');
			END IF;

			IF AUDIT_USER IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: AUDIT_USER ; Parameter position: 4'');
			END IF;

			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			V_TABLE_NAME := UPPER(TABLE_NAME);

			-- Comprobar si la tabla existe
			EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''''''||V_TABLE_NAME||'''''' and owner = ''''''||TABLE_SCHEME||'''''''' INTO V_COUNT;
			IF V_COUNT = 0 THEN
				raise_application_error(-20004, ''Dictionary table ''||V_TABLE_NAME||'' do not exists on ''||TABLE_SCHEME||'''');
			END IF;

			-- Obtener carácteres identificativos de la tabla
			V_TABLE_CHARS := SUBSTR(V_TABLE_NAME, 4, 3);
			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT_LINE(''[DEBUG] Acquired table identifier chars: '' || V_TABLE_CHARS);
			END IF;

			-- Inicia el proceso DML
			DBMS_OUTPUT.PUT_LINE(''[BEGIN]'');

			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT_LINE(''[INFO] Alter content from ''||TABLE_SCHEME||''.''||V_TABLE_NAME||'':'');
			ELSE
				DBMS_OUTPUT.PUT(''[INFO] Alter content from ''||TABLE_SCHEME||''.''||V_TABLE_NAME||''...'');
			END IF;

			IF TABLE_DATA.FIRST IS NOT NULL THEN
				FOR data_index IN TABLE_DATA.FIRST .. TABLE_DATA.LAST
				LOOP
					V_TMP := TABLE_DATA(data_index);

					EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ''||TABLE_SCHEME||''.''||V_TABLE_NAME||'' WHERE DD_''||V_TABLE_CHARS||''_CODIGO = ''''''||V_TMP(1)||'''''' '' INTO V_COUNT;
					IF V_COUNT = 0 THEN
						IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
							DBMS_OUTPUT.PUT(''[INFO]		Inserting new registry with code ''''''||V_TMP(1)||''''''...'');
						END IF;

						EXECUTE IMMEDIATE ''SELECT ''||TABLE_SCHEME||''.S_''||V_TABLE_NAME||''.NEXTVAL FROM DUAL'' INTO V_SEQUENCE_NEXT_ID;

						EXECUTE IMMEDIATE ''INSERT INTO ''||TABLE_SCHEME ||''.''||V_TABLE_NAME||'' (DD_''||V_TABLE_CHARS||''_ID, DD_''||V_TABLE_CHARS||''_CODIGO,
						DD_''||V_TABLE_CHARS||''_DESCRIPCION, DD_''||V_TABLE_CHARS||''_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
						SELECT ''||V_SEQUENCE_NEXT_ID||'', ''''''||V_TMP(1)||'''''', ''''''||V_TMP(2)||'''''', ''''''||V_TMP(3)||'''''',
						0, ''''''||AUDIT_USER||'''''', SYSDATE, 0 FROM DUAL'';

						V_ROW_UPGRADES_COUNT := V_ROW_UPGRADES_COUNT + SQL%ROWCOUNT;

						IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
							DBMS_OUTPUT.PUT_LINE(''DONE'');
						END IF;

					ELSE
						IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
							DBMS_OUTPUT.PUT(''[INFO]		Modifiyng registry with code ''''''||V_TMP(1)||''''''...'');
						END IF;

						EXECUTE IMMEDIATE ''UPDATE ''||TABLE_SCHEME||''.''||V_TABLE_NAME||'' SET DD_''||V_TABLE_CHARS||''_DESCRIPCION = ''''''||V_TMP(2)||'''''',
						DD_''||V_TABLE_CHARS||''_DESCRIPCION_LARGA = ''''''||V_TMP(3)||'''''', USUARIOMODIFICAR = ''''''||AUDIT_USER||'''''', FECHAMODIFICAR = SYSDATE,
						BORRADO = 0 WHERE DD_''||V_TABLE_CHARS||''_CODIGO = ''''''||V_TMP(1)||'''''''';

						V_ROW_UPGRADES_COUNT := V_ROW_UPGRADES_COUNT + SQL%ROWCOUNT;

						IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
							DBMS_OUTPUT.PUT_LINE(''DONE'');
						END IF;

					END IF;

				END LOOP;

			ELSE
				IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
					DBMS_OUTPUT.PUT_LINE(''NONE'');
				END IF;
			END IF;

			IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			COMMIT;

			DBMS_OUTPUT.PUT_LINE(''[INFO]'');

			DBMS_OUTPUT.PUT_LINE(''[INFO] Number of registries altered: ''||V_ROW_UPGRADES_COUNT);

			DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');

			DBMS_OUTPUT.PUT_LINE(''[DONE]'');

			EXCEPTION
			WHEN MANDATORY_PARAMETERS_EMPTY THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;

			WHEN TABLE_DO_NOT_EXISTS THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;

			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''[ERROR] An error ocurred while the execution of the script: ''||TO_CHAR(SQLCODE));
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;
		END;';

		lt_procedures_collection(7) :=
		'

		/*
		 *	@PUBLIC
		 *	Este procedimiento rellena los registros de una tabla por los parámetros que recibe.
		 *
		 *	@param TABLE_SCHEME VARCHAR2 Nombre del esquema en el que se encuentra la tabla.
		 *	@param TABLE_NAME VARCHAR2 Nombre de la tabla a la que añadir las columnas de auditoría.
		 *	@param TABLE_COLUMNS ARRAY_TABLE Colección de columnas involucradas en los registros a modificar en la tabla.
		 *	@param TABLE_DATA MATRIX_TABLE Matriz de datos para rellenar los registros de la tabla.
		 *	@param AUDIT_USER VARCHAR2 Indica el usuario que va a realizar la modificación. Quedará registrado en la auditoría de los registros afectados.
		 *	@param LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO (Opcional) Indica el nivel de verbosidad del registro de sucesos.
		 */
		PROCEDURE insert_common_table(TABLE_SCHEME VARCHAR2, TABLE_NAME VARCHAR2, TABLE_COLUMNS ARRAY_TABLE, TABLE_DATA MATRIX_TABLE, AUDIT_USER VARCHAR2, LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO) AS
			V_SEQUENCE_NEXT_ID NUMBER(16);
			V_COUNT NUMBER(2);
			V_ELAPSED_TIME NUMBER;
			V_TMP ARRAY_TABLE;
			V_TMP_CONCAT_COLUMNS VARCHAR2(250 CHAR);
			V_TMP_CONCAT_DATA VARCHAR2(250 CHAR);
			V_TMP_COL_DATA_TYPE ARRAY_TABLE := ARRAY_TABLE();
			V_TMP_ID NUMBER(16);
			V_TMP_TABLA_DESTINO ARRAY_TABLE;
			V_TMP1_VARCHAR VARCHAR2(125 CHAR);
			V_TMP2_VARCHAR VARCHAR2(125 CHAR);
			V_TMP3_VARCHAR VARCHAR2(125 CHAR);
			V_TMP_TABLA_DESTINO_MATRIX MATRIX_TABLE := MATRIX_TABLE();
			V_TABLE_CHARS VARCHAR2(3 CHAR);
			V_TABLE_NAME VARCHAR2(125 CHAR);
			V_ROW_UPGRADES_COUNT NUMBER(6) := 0;
			V_ORACLE_ENVIRONMENT_VERSION VARCHAR(100 CHAR);

		BEGIN

			DBMS_OUTPUT.ENABLE(buffer_size => NULL);
			V_ELAPSED_TIME := DBMS_UTILITY.GET_TIME;

			-- Obtener entorno de ejecución
			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				EXECUTE IMMEDIATE ''SELECT BANNER FROM v$version where BANNER like ''''Oracle%'''''' INTO V_ORACLE_ENVIRONMENT_VERSION;
				DBMS_OUTPUT.PUT_LINE(''[DEBUG] ''||V_ORACLE_ENVIRONMENT_VERSION);
			END IF;

			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT(''[DEBUG] Checking mandatory parameters...'');
			END IF;

			-- Comprobar parámetros obligatorios de entrada
			IF TABLE_SCHEME IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_SCHEME ; Parameter position: 1'');
			END IF;

			IF TABLE_NAME IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_NAME ; Parameter position: 2'');
			END IF;

			IF TABLE_COLUMNS IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_COLUMNS ; Parameter position: 3'');
			END IF;

			IF TABLE_DATA IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: TABLE_DATA ; Parameter position: 4'');
			END IF;

			IF AUDIT_USER IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: AUDIT_USER ; Parameter position: 5'');
			END IF;

			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			V_TABLE_NAME := UPPER(TABLE_NAME);

			-- Comprobar si la tabla existe
			EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''''''||V_TABLE_NAME||'''''' and owner = ''''''||TABLE_SCHEME||'''''''' INTO V_COUNT;
			IF V_COUNT = 0 THEN
				raise_application_error(-20004, ''Table ''||V_TABLE_NAME||'' do not exists on ''||TABLE_SCHEME||'''');
			END IF;

			-- Obtener carácteres identificativos de la tabla
			V_TABLE_CHARS := SUBSTR(V_TABLE_NAME, 1, 3);
			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT_LINE(''[DEBUG] Acquired table identifier chars: '' || V_TABLE_CHARS);
			END IF;

			-- Comprobar existencia de las columnas en la tabla y montar literal de unión entre columnas afectas
			FOR col_index IN TABLE_COLUMNS.FIRST .. TABLE_COLUMNS.LAST
			LOOP
				EXECUTE IMMEDIATE ''SELECT DATA_TYPE FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''''''||TABLE_COLUMNS(col_index)||'''''' and TABLE_NAME = ''''''||V_TABLE_NAME||'''''' and owner = ''''''||TABLE_SCHEME||'''''''' INTO V_TMP_CONCAT_DATA;
				IF V_TMP_CONCAT_DATA IS NULL THEN
					raise_application_error(-20005, ''Column ''||TABLE_COLUMNS(col_index)||'' do not exists on ''||TABLE_SCHEME||''.''||V_TABLE_NAME||'''');
				END IF;

				V_TMP_COL_DATA_TYPE.extend;
				V_TMP_COL_DATA_TYPE(col_index) := V_TMP_CONCAT_DATA;

				IF TABLE_COLUMNS(col_index) = TABLE_COLUMNS(1) THEN
					V_TMP_CONCAT_COLUMNS := TABLE_COLUMNS(col_index);
				ELSE
					V_TMP_CONCAT_COLUMNS := V_TMP_CONCAT_COLUMNS || '', '' || TABLE_COLUMNS(col_index);
				END IF;

				-- Comprobar si la columna tiene FK para deducir que el valor de entrada es un código. Obtener la tabla de destino para usarla más adelante
				EXECUTE IMMEDIATE ''SELECT count(1) FROM all_cons_columns origen INNER JOIN all_constraints cons ON origen.constraint_name = cons.constraint_name
				INNER JOIN all_cons_columns destino ON cons.r_constraint_name = destino.constraint_name WHERE origen.OWNER = ''''''||TABLE_SCHEME||'''''' AND origen.table_name = ''''''||V_TABLE_NAME||''''''
				AND origen.column_name = ''''''||TABLE_COLUMNS(col_index)||'''''' AND cons.constraint_type = ''''R'''''' INTO V_COUNT;

				V_TMP_TABLA_DESTINO_MATRIX.extend;

				IF V_COUNT > 0 THEN
					SELECT destino.owner, destino.table_name, SUBSTR(destino.table_name, 4, 3) INTO V_TMP1_VARCHAR, V_TMP2_VARCHAR,	V_TMP3_VARCHAR FROM all_cons_columns origen
					INNER JOIN all_constraints cons ON origen.constraint_name = cons.constraint_name
					INNER JOIN all_cons_columns destino ON cons.r_constraint_name = destino.constraint_name WHERE origen.OWNER = ''''||TABLE_SCHEME||'''' AND origen.table_name = ''''||V_TABLE_NAME||''''
					AND origen.column_name = ''''||TABLE_COLUMNS(col_index)||'''' AND cons.constraint_type = ''R'';

					V_TMP_TABLA_DESTINO := ARRAY_TABLE(V_TMP1_VARCHAR, V_TMP2_VARCHAR,	V_TMP3_VARCHAR);

					V_TMP_TABLA_DESTINO_MATRIX(col_index) := V_TMP_TABLA_DESTINO;
				ELSE
					V_TMP_TABLA_DESTINO_MATRIX(col_index) := NULL;
				END IF;

			END LOOP;

			-- Inicia el proceso DML
			DBMS_OUTPUT.PUT_LINE(''[BEGIN]'');

			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT_LINE(''[INFO] Alter content from ''||TABLE_SCHEME||''.''||V_TABLE_NAME||'':'');
			ELSE
				DBMS_OUTPUT.PUT(''[INFO] Alter content from ''||TABLE_SCHEME||''.''||V_TABLE_NAME||''...'');
			END IF;

			IF TABLE_DATA.FIRST IS NOT NULL THEN
				FOR data_index IN TABLE_DATA.FIRST .. TABLE_DATA.LAST
				LOOP
					V_TMP := TABLE_DATA(data_index);

					-- Montar literal de datos a insertar
					FOR col_data_index IN V_TMP.FIRST .. V_TMP.LAST
					LOOP
						V_TMP_TABLA_DESTINO := V_TMP_TABLA_DESTINO_MATRIX(col_data_index);

						IF V_TMP(col_data_index) = V_TMP(1) THEN
							IF V_TMP_TABLA_DESTINO_MATRIX(col_data_index) IS NOT NULL AND V_TMP(col_data_index) IS NOT NULL THEN
								-- Tratar dato como código de una tabla
								EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ''||V_TMP_TABLA_DESTINO(1)||''.''||V_TMP_TABLA_DESTINO(2)||'' WHERE DD_''||V_TMP_TABLA_DESTINO(3)||''_CODIGO = ''''''||V_TMP(col_data_index)||'''''''' INTO V_COUNT;
								IF V_COUNT = 0 THEN
									raise_application_error(-20007, ''The code ''''''||V_TMP(col_data_index)||'''''' do not match with any registry on ''||V_TMP_TABLA_DESTINO(1)||''.''||V_TMP_TABLA_DESTINO(2)||'''');
								END IF;
								EXECUTE IMMEDIATE ''SELECT DD_''||V_TMP_TABLA_DESTINO(3)||''_ID FROM ''||V_TMP_TABLA_DESTINO(1)||''.''||V_TMP_TABLA_DESTINO(2)||'' WHERE DD_''||V_TMP_TABLA_DESTINO(3)||''_CODIGO = ''''''||V_TMP(col_data_index)||'''''''' INTO V_TMP_ID;
								V_TMP_CONCAT_DATA := V_TMP_ID;

							ELSIF V_TMP(col_data_index) IS NULL THEN
								V_TMP_CONCAT_DATA := ''NULL'';

							ELSIF V_TMP_COL_DATA_TYPE(col_data_index) = ''VARCHAR2'' THEN
								-- tratar dato como cadena literal
								V_TMP_CONCAT_DATA := '''''''' || V_TMP(col_data_index) || '''''''';

							ELSE
								-- tratar dato como cualquier otra cosa
								V_TMP_CONCAT_DATA := V_TMP(col_data_index);

							END IF;
						ELSE
							IF V_TMP_TABLA_DESTINO_MATRIX(col_data_index) IS NOT NULL AND V_TMP(col_data_index) IS NOT NULL THEN
								-- Tratar dato como código de una tabla diccionario
								EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ''||V_TMP_TABLA_DESTINO(1)||''.''||V_TMP_TABLA_DESTINO(2)||'' WHERE DD_''||V_TMP_TABLA_DESTINO(3)||''_CODIGO = ''''''||V_TMP(col_data_index)||'''''''' INTO V_COUNT;
								IF V_COUNT = 0 THEN
									raise_application_error(-20007, ''The code ''''''||V_TMP(col_data_index)||'''''' do not match with any registry on ''||V_TMP_TABLA_DESTINO(1)||''.''||V_TMP_TABLA_DESTINO(2)||'''');
								END IF;
								EXECUTE IMMEDIATE ''SELECT DD_''||V_TMP_TABLA_DESTINO(3)||''_ID FROM ''||V_TMP_TABLA_DESTINO(1)||''.''||V_TMP_TABLA_DESTINO(2)||'' WHERE DD_''||V_TMP_TABLA_DESTINO(3)||''_CODIGO = ''''''||V_TMP(col_data_index)||'''''''' INTO V_TMP_ID;
								V_TMP_CONCAT_DATA := V_TMP_CONCAT_DATA || '', '' || V_TMP_ID;

							ELSIF V_TMP(col_data_index) IS NULL THEN
								-- tratar dato como nulo
								V_TMP_CONCAT_DATA := V_TMP_CONCAT_DATA || '', '' || ''NULL'';

							ELSIF V_TMP_COL_DATA_TYPE(col_data_index) = ''VARCHAR2'' THEN
								-- tratar dato como cadena literal
								V_TMP_CONCAT_DATA := V_TMP_CONCAT_DATA || '', '' || '''''''' || V_TMP(col_data_index) || '''''''';

							ELSE
								-- tratar dato como cualquier otra cosa
								V_TMP_CONCAT_DATA := V_TMP_CONCAT_DATA || '', '' || V_TMP(col_data_index);

							END IF;
						END IF;

					END LOOP;

					IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
						DBMS_OUTPUT.PUT(''[INFO]		Inserting new registry...'');
					END IF;

					EXECUTE IMMEDIATE ''SELECT ''||TABLE_SCHEME||''.S_''||V_TABLE_NAME||''.NEXTVAL FROM DUAL'' INTO V_SEQUENCE_NEXT_ID;

					EXECUTE IMMEDIATE ''INSERT INTO ''||TABLE_SCHEME||''.''||V_TABLE_NAME||'' (''||V_TABLE_CHARS||''_ID, ''||V_TMP_CONCAT_COLUMNS||'', VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
					SELECT ''||V_SEQUENCE_NEXT_ID||'', ''||V_TMP_CONCAT_DATA||'', 0, ''''''||AUDIT_USER||'''''', SYSDATE, 0 FROM DUAL'';

					V_ROW_UPGRADES_COUNT := V_ROW_UPGRADES_COUNT + SQL%ROWCOUNT;

					IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
						DBMS_OUTPUT.PUT_LINE(''DONE'');
					END IF;

				END LOOP;
			ELSE
				IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
					DBMS_OUTPUT.PUT_LINE(''NONE'');
				END IF;
			END IF;

			IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			COMMIT;

			DBMS_OUTPUT.PUT_LINE(''[INFO]'');

			DBMS_OUTPUT.PUT_LINE(''[INFO] Number of registries altered: ''||V_ROW_UPGRADES_COUNT);

			DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');

			DBMS_OUTPUT.PUT_LINE(''[DONE]'');

			EXCEPTION
			WHEN MANDATORY_PARAMETERS_EMPTY THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;

			WHEN TABLE_DO_NOT_EXISTS THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;

			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''[ERROR] An error ocurred while the execution of the script: ''||TO_CHAR(SQLCODE));
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;
		END;';

		lt_procedures_collection(8) :=
		'

		/*
		 *	@PUBLIC
		 *	Este procedimiento une en la tabla FUN_PEF cada una de las funciones que recibe como parámetro con el único perfil que recibe
		 *	como parámetro. Si el código del perfil que recibe no existe, genera un nuevo perfil en la tabla PEF_PERFILES, si el perfil
		 *	si que existe modifica su descripción y descripción larga.
		 *
		 *	@param SCHEME VARCHAR2 Esquema de la DB sobre el que realizar las operaciones.
		 *	@param MASTER_SCHEME VARCHAR2 Esquema maestro de la DB sobre el que realizar las operaciones.
		 *	@param PROFILE_CODE VARCHAR2 Código único del perfil a unir con las funciones.
		 *	@param PROFILE_DESCRIPTION VARCHAR2 Descripción del perfil a unir con las funciones.
		 *	@param PROFILE_L_DESCRIPTION VARCHAR2 Descripción larga del perfil a unir con las funciones.
		 *	@param ERASE_PREVIOUS_DATA BOOLEAN Indica si se purga la tabla de unión entre perfiles y funciones para todos los registros donde coincida con el perfil especificado.
		 *	@param FUNCTIONS_DATA ARRAY_TABLE Colección de funciones a unir con el perfil.
		 *	@param AUDIT_USER VARCHAR2 Indica el usuario que va a realizar la modificación. Quedará registrado en la auditoría de los registros afectados.
		 *	@param LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO (Opcional) Indica el nivel de verbosidad del registro de sucesos.
		 */
		PROCEDURE join_many_functions_to_profile(SCHEME VARCHAR2, MASTER_SCHEME VARCHAR2, PROFILE_CODE VARCHAR2, PROFILE_DESCRIPTION VARCHAR2, PROFILE_L_DESCRIPTION VARCHAR2, ERASE_PREVIOUS_DATA BOOLEAN, FUNCTIONS_DATA ARRAY_TABLE, AUDIT_USER VARCHAR2, LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO) AS
			V_PROFILES_TABLE VARCHAR2(30 CHAR)	:= ''PEF_PERFILES'';
			V_FUNCTIONS_TABLE VARCHAR2(30 CHAR)	:= ''FUN_FUNCIONES'';
			V_JOIN_TABLE VARCHAR2(30 CHAR)		:= ''FUN_PEF'';

			V_COUNT NUMBER(2);
			V_ELAPSED_TIME NUMBER;
			V_FUN_ID NUMBER(16);
			V_PEF_ID NUMBER(16);
			V_ROW_INSERT_COUNT NUMBER(6) := 0;
			V_ROW_DELETE_COUNT NUMBER(6) := 0;
			V_ORACLE_ENVIRONMENT_VERSION VARCHAR(100 CHAR);

		BEGIN

			DBMS_OUTPUT.ENABLE(buffer_size => NULL);
			V_ELAPSED_TIME := DBMS_UTILITY.GET_TIME;

			-- Obtener entorno de ejecución
			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				EXECUTE IMMEDIATE ''SELECT BANNER FROM v$version where BANNER like ''''Oracle%'''''' INTO V_ORACLE_ENVIRONMENT_VERSION;
				DBMS_OUTPUT.PUT_LINE(''[DEBUG] ''||V_ORACLE_ENVIRONMENT_VERSION);
			END IF;

			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT(''[DEBUG] Checking mandatory parameters...'');
			END IF;

			-- Comprobar parámetros obligatorios de entrada
			IF SCHEME IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: SCHEME ; Parameter position: 1'');
			END IF;

			IF MASTER_SCHEME IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: MASTER_SCHEME ; Parameter position: 2'');
			END IF;

			IF PROFILE_CODE IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: PROFILE_CODE ; Parameter position: 3'');
			END IF;

			IF PROFILE_DESCRIPTION IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: PROFILE_DESCRIPTION ; Parameter position: 4'');
			END IF;

			IF PROFILE_L_DESCRIPTION IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: PROFILE_L_DESCRIPTION ; Parameter position: 5'');
			END IF;

			IF ERASE_PREVIOUS_DATA IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: ERASE_PREVIOUS_DATA ; Parameter position: 6'');
			END IF;

			IF FUNCTIONS_DATA IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: FUNCTIONS_DATA ; Parameter position: 7'');
			END IF;

			IF AUDIT_USER IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: AUDIT_USER ; Parameter position: 8'');
			END IF;

			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			-- Comprobar integridad de las funciones
			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT(''[INFO] Checking functions array integrity...'');
			END IF;
			FOR fun_index IN FUNCTIONS_DATA.FIRST .. FUNCTIONS_DATA.LAST
			LOOP
				EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ''||MASTER_SCHEME||''.''||V_FUNCTIONS_TABLE||'' WHERE FUN_DESCRIPCION =  ''''''||FUNCTIONS_DATA(fun_index)||'''''''' INTO V_COUNT;
				IF V_COUNT = 0 THEN
					raise_application_error(-20008, ''The code ''''''||FUNCTIONS_DATA(fun_index)||'''''' do not match with any registry on ''||MASTER_SCHEME||''.''||V_FUNCTIONS_TABLE||'''');
				END IF;
			END LOOP;
			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			-- Inicia el proceso DML
			DBMS_OUTPUT.PUT_LINE(''[BEGIN]'');

			-- Comprobar integridad del perfil y obtener id del registro
			EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ''||SCHEME||''.''||V_PROFILES_TABLE||'' WHERE PEF_CODIGO = ''''''||PROFILE_CODE||'''''''' INTO V_COUNT;
			IF V_COUNT = 0 THEN
				DBMS_OUTPUT.PUT(''[INFO] A profile with unique code ''''''||PROFILE_CODE||'''''' not exists. Creating...'');
				EXECUTE IMMEDIATE ''INSERT INTO ''||SCHEME||''.''||V_PROFILES_TABLE||'' (PEF_ID, PEF_CODIGO, PEF_DESCRIPCION, PEF_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
									VALUES (''||SCHEME||''.S_''||V_PROFILES_TABLE||''.NEXTVAL, ''''''||PROFILE_CODE||'''''',''''''||PROFILE_DESCRIPTION||'''''',''''''||PROFILE_L_DESCRIPTION||'''''',
									0, ''''''||AUDIT_USER||'''''', SYSDATE, 0)'';
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			ELSE
				DBMS_OUTPUT.PUT(''[INFO] A profile with unique code ''''''||PROFILE_CODE||'''''' already exists. Modifying...'');
				EXECUTE IMMEDIATE ''UPDATE ''||SCHEME||''.''||V_PROFILES_TABLE||'' SET PEF_DESCRIPCION = ''''''||PROFILE_DESCRIPTION||'''''', PEF_DESCRIPCION_LARGA = ''''''||PROFILE_L_DESCRIPTION||'''''',
									USUARIOMODIFICAR = ''''''||AUDIT_USER||'''''', FECHAMODIFICAR = SYSDATE, BORRADO = 0 WHERE PEF_CODIGO = ''''''||PROFILE_CODE||'''''''';
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			EXECUTE IMMEDIATE ''SELECT PEF_ID FROM ''||SCHEME||''.''||V_PROFILES_TABLE||'' WHERE PEF_CODIGO = ''''''||PROFILE_CODE||'''''''' INTO V_PEF_ID;

			-- Descartar registros existentes anteriores para el perfil especificado si procede
			IF ERASE_PREVIOUS_DATA THEN
				DBMS_OUTPUT.PUT(''[INFO] Erasing previous join data using profile code ''''''||PROFILE_CODE||''''''...'');
				EXECUTE IMMEDIATE ''DELETE FROM ''||SCHEME||''.''||V_JOIN_TABLE||'' WHERE PEF_ID=(SELECT PEF_ID FROM ''||SCHEME||''.''||V_PROFILES_TABLE||'' WHERE PEF_CODIGO = ''''''||PROFILE_CODE||'''''')'';
				V_ROW_DELETE_COUNT := V_ROW_DELETE_COUNT + SQL%ROWCOUNT;
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			-- Insertar nuevos registros si no existe coincidencia de datos
			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT_LINE(''[INFO] Updating join table between functions and the profile with code ''''''||PROFILE_CODE||'''''':'');
			ELSE
				DBMS_OUTPUT.PUT(''[INFO] Updating join table between functions and the profile with code ''''''||PROFILE_CODE||''''''...'');
			END IF;

			FOR fun_index IN FUNCTIONS_DATA.FIRST .. FUNCTIONS_DATA.LAST
			LOOP
				EXECUTE IMMEDIATE ''SELECT FUN_ID FROM ''||MASTER_SCHEME||''.''||V_FUNCTIONS_TABLE||'' WHERE FUN_DESCRIPCION = ''''''||FUNCTIONS_DATA(fun_index)||'''''''' INTO V_FUN_ID;
				EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ''||SCHEME||''.''||V_JOIN_TABLE||'' WHERE FUN_ID = ''||V_FUN_ID||'' AND PEF_ID = ''||V_PEF_ID||'''' INTO V_COUNT;

				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT(''[INFO]		Registry with function code ''''''||FUNCTIONS_DATA(fun_index)||''''''...'');
				END IF;

				IF V_COUNT = 0 THEN
					EXECUTE IMMEDIATE ''INSERT INTO ''||SCHEME||''.''||V_JOIN_TABLE||'' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
										VALUES (''||V_FUN_ID||'', ''||V_PEF_ID||'', ''||SCHEME||''.S_''||V_JOIN_TABLE||''.NEXTVAL, 0, ''''''||AUDIT_USER||'''''', SYSDATE, 0)'';

					V_ROW_INSERT_COUNT := V_ROW_INSERT_COUNT + SQL%ROWCOUNT;

					IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
						DBMS_OUTPUT.PUT_LINE(''DONE'');
					END IF;

				ELSE
					IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
						DBMS_OUTPUT.PUT_LINE(''already exists'');
					END IF;
				END IF;

			END LOOP;

			IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			COMMIT;

			DBMS_OUTPUT.PUT_LINE(''[INFO]'');

			DBMS_OUTPUT.PUT_LINE(''[INFO] Number of deleted previous registries: ''||V_ROW_DELETE_COUNT);

			DBMS_OUTPUT.PUT_LINE(''[INFO] Number of new registries: ''||V_ROW_INSERT_COUNT);

			DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');

			DBMS_OUTPUT.PUT_LINE(''[DONE]'');

			EXCEPTION
			WHEN MANDATORY_PARAMETERS_EMPTY THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;

			WHEN FUNCTION_DO_NOT_EXIST THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;

			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE(''ERROR'');
				DBMS_OUTPUT.PUT_LINE(''[ERROR] An error ocurred while the execution of the script: ''||TO_CHAR(SQLCODE));
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
				DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
				DBMS_OUTPUT.PUT_LINE(SQLERRM);
				ROLLBACK;
				RAISE;
		END;';

		lt_procedures_collection(9) :=
		'

		/*
		 *	@PUBLIC
		 *	Este procedimiento une en la tabla FUN_PEF cada uno de los perfiles que recibe como parámetro con la única función que recibe
		 *	como parámetro. Si el código de la función que recibe no existe, genera una nueva en la tabla FUN_FUNCIONES, si la función
		 *	si que existe modifica su descripción.
		 *
		 *	@param SCHEME VARCHAR2 Esquema de la DB sobre el que realizar las operaciones.
		 *	@param MASTER_SCHEME VARCHAR2 Esquema maestro de la DB sobre el que realizar las operaciones.
		 *	@param FUNCTION_CODE VARCHAR2 Código único de la función a unir con los perfiles.
		 *	@param FUNCTION_DESCRIPTION VARCHAR2 Descripción de la función a unir con los perfiles.
		 *	@param ERASE_PREVIOUS_DATA BOOLEAN Indica si se purga la tabla de unión entre perfiles y funciones para todos los registros donde coincida con la función especificada.
		 *	@param FUNCTIONS_DATA ARRAY_TABLE Colección de perfiles a unir con la función.
		 *	@param AUDIT_USER VARCHAR2 Indica el usuario que va a realizar la modificación. Quedará registrado en la auditoría de los registros afectados.
		 *	@param LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO (Opcional) Indica el nivel de verbosidad del registro de sucesos.
		 */
		PROCEDURE join_many_profiles_to_function(SCHEME VARCHAR2, MASTER_SCHEME VARCHAR2, FUNCTION_CODE VARCHAR2, FUNCTION_DESCRIPTION VARCHAR2, ERASE_PREVIOUS_DATA BOOLEAN, PROFILES_DATA ARRAY_TABLE, AUDIT_USER VARCHAR2, LOG_LEVEL NUMBER DEFAULT OUTPUT_LEVEL.INFO) AS
			V_PROFILES_TABLE VARCHAR2(30 CHAR)	:= ''PEF_PERFILES'';
			V_FUNCTIONS_TABLE VARCHAR2(30 CHAR)	:= ''FUN_FUNCIONES'';
			V_JOIN_TABLE VARCHAR2(30 CHAR)		:= ''FUN_PEF'';

			V_COUNT NUMBER(2);
			V_ELAPSED_TIME NUMBER;
			V_FUN_ID NUMBER(16);
			V_PEF_ID NUMBER(16);
			V_ROW_INSERT_COUNT NUMBER(6) := 0;
			V_ROW_DELETE_COUNT NUMBER(6) := 0;
			V_ORACLE_ENVIRONMENT_VERSION VARCHAR(100 CHAR);

		BEGIN

			DBMS_OUTPUT.ENABLE(buffer_size => NULL);
			V_ELAPSED_TIME := DBMS_UTILITY.GET_TIME;

			-- Obtener entorno de ejecución
			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				EXECUTE IMMEDIATE ''SELECT BANNER FROM v$version where BANNER like ''''Oracle%'''''' INTO V_ORACLE_ENVIRONMENT_VERSION;
				DBMS_OUTPUT.PUT_LINE(''[DEBUG] ''||V_ORACLE_ENVIRONMENT_VERSION);
			END IF;

			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT(''[DEBUG] Checking mandatory parameters...'');
			END IF;

			-- Comprobar parámetros obligatorios de entrada
			IF SCHEME IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: SCHEME ; Parameter position: 1'');
			END IF;

			IF MASTER_SCHEME IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: MASTER_SCHEME ; Parameter position: 2'');
			END IF;

			IF FUNCTION_CODE IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: FUNCTION_CODE ; Parameter position: 3'');
			END IF;

			IF FUNCTION_DESCRIPTION IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: FUNCTION_DESCRIPTION ; Parameter position: 4'');
			END IF;

			IF ERASE_PREVIOUS_DATA IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: ERASE_PREVIOUS_DATA ; Parameter position: 5'');
			END IF;

			IF PROFILES_DATA IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: PROFILES_DATA ; Parameter position: 6'');
			END IF;

			IF AUDIT_USER IS NULL THEN
				raise_application_error(-20001, ''A mandatory parameter is empty: Parameter: AUDIT_USER ; Parameter position: 7'');
			END IF;

			IF LOG_LEVEL <= OUTPUT_LEVEL.DEBUG THEN
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			-- Comprobar integridad de los perfiles
			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT(''[INFO] Checking profiles array integrity...'');
			END IF;
			FOR profile_index IN PROFILES_DATA.FIRST .. PROFILES_DATA.LAST
			LOOP
				EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ''||SCHEME||''.''||V_PROFILES_TABLE||'' WHERE PEF_CODIGO =  ''''''||PROFILES_DATA(profile_index)||'''''''' INTO V_COUNT;
				IF V_COUNT = 0 THEN
					raise_application_error(-20009, ''The code ''''''||PROFILES_DATA(profile_index)||'''''' do not match with any registry on ''||SCHEME||''.''||V_PROFILES_TABLE||'''');
				END IF;
			END LOOP;
			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			-- Inicia el proceso DML
			DBMS_OUTPUT.PUT_LINE(''[BEGIN]'');

			-- Comprobar integridad de la función y obtener id del registro
			EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ''||MASTER_SCHEME||''.''||V_FUNCTIONS_TABLE||'' WHERE FUN_DESCRIPCION = ''''''||FUNCTION_CODE||'''''''' INTO V_COUNT;
			IF V_COUNT = 0 THEN
				DBMS_OUTPUT.PUT(''[INFO] A function with unique code ''''''||FUNCTION_CODE||'''''' not exists. Creating...'');
				EXECUTE IMMEDIATE ''INSERT INTO ''||MASTER_SCHEME||''.''||V_FUNCTIONS_TABLE||'' (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
									VALUES (''||MASTER_SCHEME||''.S_''||V_FUNCTIONS_TABLE||''.NEXTVAL, ''''''||FUNCTION_CODE||'''''',''''''||FUNCTION_DESCRIPTION||'''''', 0,
									''''''||AUDIT_USER||'''''', SYSDATE, 0)'';
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			ELSE
				DBMS_OUTPUT.PUT(''[INFO] A function with unique code ''''''||FUNCTION_CODE||'''''' already exists. Modifying...'');
				EXECUTE IMMEDIATE ''UPDATE ''||MASTER_SCHEME||''.''||V_FUNCTIONS_TABLE||'' SET FUN_DESCRIPCION_LARGA = ''''''||FUNCTION_DESCRIPTION||'''''', USUARIOMODIFICAR = ''''''||AUDIT_USER||'''''',
									FECHAMODIFICAR = SYSDATE, BORRADO = 0 WHERE FUN_DESCRIPCION = ''''''||FUNCTION_CODE||'''''''';
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			EXECUTE IMMEDIATE ''SELECT FUN_ID FROM ''||MASTER_SCHEME||''.''||V_FUNCTIONS_TABLE||'' WHERE FUN_DESCRIPCION = ''''''||FUNCTION_CODE||'''''''' INTO V_FUN_ID;

			-- Descartar registros existentes anteriores para la función especificada si procede
			IF ERASE_PREVIOUS_DATA THEN
				DBMS_OUTPUT.PUT(''[INFO] Erasing previous join data using function code ''''''||FUNCTION_CODE||''''''...'');
				EXECUTE IMMEDIATE ''DELETE FROM ''||SCHEME||''.''||V_JOIN_TABLE||'' WHERE FUN_ID=(SELECT FUN_ID FROM ''||MASTER_SCHEME||''.''||V_FUNCTIONS_TABLE||'' WHERE FUN_DESCRIPCION = ''''''||FUNCTION_CODE||'''''')'';
				V_ROW_DELETE_COUNT := V_ROW_DELETE_COUNT + SQL%ROWCOUNT;
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			-- Insertar nuevos registros si no existe coincidencia de datos
			IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
				DBMS_OUTPUT.PUT_LINE(''[INFO] Updating join table between profiles and the function with code ''''''||FUNCTION_CODE||'''''':'');
			ELSE
				DBMS_OUTPUT.PUT(''[INFO] Updating join table between profiles and the function with code ''''''||FUNCTION_CODE||''''''...'');
			END IF;

			FOR fun_index IN PROFILES_DATA.FIRST .. PROFILES_DATA.LAST
			LOOP
				EXECUTE IMMEDIATE ''SELECT PEF_ID FROM ''||SCHEME||''.''||V_PROFILES_TABLE||'' WHERE PEF_CODIGO = ''''''||PROFILES_DATA(fun_index)||'''''''' INTO V_PEF_ID;
				EXECUTE IMMEDIATE ''SELECT COUNT(1) FROM ''||SCHEME||''.''||V_JOIN_TABLE||'' WHERE FUN_ID = ''||V_FUN_ID||'' AND PEF_ID = ''||V_PEF_ID||'''' INTO V_COUNT;

				IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
					DBMS_OUTPUT.PUT(''[INFO]		Registry with profile code ''''''||PROFILES_DATA(fun_index)||''''''...'');
				END IF;

				IF V_COUNT = 0 THEN
					EXECUTE IMMEDIATE ''INSERT INTO ''||SCHEME||''.''||V_JOIN_TABLE||'' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
										VALUES (''||V_FUN_ID||'', ''||V_PEF_ID||'', ''||SCHEME||''.S_''||V_JOIN_TABLE||''.NEXTVAL, 0, ''''''||AUDIT_USER||'''''', SYSDATE, 0)'';

					V_ROW_INSERT_COUNT := V_ROW_INSERT_COUNT + SQL%ROWCOUNT;

					IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
						DBMS_OUTPUT.PUT_LINE(''DONE'');
					END IF;

				ELSE
					IF LOG_LEVEL <= OUTPUT_LEVEL.VERBOSE THEN
						DBMS_OUTPUT.PUT_LINE(''already exists'');
					END IF;
				END IF;

			END LOOP;

			IF LOG_LEVEL >= OUTPUT_LEVEL.INFO THEN
				DBMS_OUTPUT.PUT_LINE(''DONE'');
			END IF;

			COMMIT;

			DBMS_OUTPUT.PUT_LINE(''[INFO]'');

			DBMS_OUTPUT.PUT_LINE(''[INFO] Number of deleted previous registries: ''||V_ROW_DELETE_COUNT);

			DBMS_OUTPUT.PUT_LINE(''[INFO] Number of new registries: ''||V_ROW_INSERT_COUNT);

			DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');

			DBMS_OUTPUT.PUT_LINE(''[DONE]'');

			EXCEPTION
				WHEN MANDATORY_PARAMETERS_EMPTY THEN
					DBMS_OUTPUT.PUT_LINE(''ERROR'');
					DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
					DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
					DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
					DBMS_OUTPUT.PUT_LINE(SQLERRM);
					ROLLBACK;
					RAISE;

				WHEN PROFILE_DO_NOT_EXIST THEN
					DBMS_OUTPUT.PUT_LINE(''ERROR'');
					DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
					DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
					DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
					DBMS_OUTPUT.PUT_LINE(SQLERRM);
					ROLLBACK;
					RAISE;

				WHEN OTHERS THEN
					DBMS_OUTPUT.PUT_LINE(''ERROR'');
					DBMS_OUTPUT.PUT_LINE(''[ERROR] An error ocurred while the execution of the script: ''||TO_CHAR(SQLCODE));
					DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
					DBMS_OUTPUT.PUT_LINE(''[INFO] Elapsed time: '' || (dbms_utility.get_time - V_ELAPSED_TIME)/100 || '' seconds'');
					DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
					DBMS_OUTPUT.PUT_LINE(SQLERRM);
					ROLLBACK;
					RAISE;
		END;

	END PITERTUL;';

	DBMS_SQL.PARSE(
		c => lc_cursor,
		statement => lt_procedures_collection,
		lb => lt_procedures_collection.first,
		ub => lt_procedures_collection.last,
		lfflg => TRUE,
		language_flag => DBMS_SQL.NATIVE
	);

	ln_result := DBMS_SQL.EXECUTE(lc_cursor);

	DBMS_SQL.CLOSE_CURSOR(lc_cursor);

	DBMS_OUTPUT.PUT_LINE('OK with code ' || ln_result);

	DBMS_OUTPUT.PUT_LINE('[DONE]');

	COMMIT;

EXCEPTION
  WHEN OTHERS THEN
	IF DBMS_SQL.IS_OPEN(lc_cursor) THEN
		DBMS_SQL.CLOSE_CURSOR(lc_cursor);
	END IF;
	DBMS_OUTPUT.PUT_LINE('KO');
	DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:' || TO_CHAR(SQLCODE));
	DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
	DBMS_OUTPUT.PUT_LINE(SQLERRM);
	ROLLBACK;
	RAISE;

END;
/
EXIT;

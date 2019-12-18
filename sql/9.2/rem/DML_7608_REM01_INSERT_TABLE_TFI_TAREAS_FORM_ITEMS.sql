--/*
--#########################################
--## AUTOR=JULIAN DOLZ
--## FECHA_CREACION=20190919
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7608
--## PRODUCTO=NO
--##
--## FINALIDAD: Inserción de datos en la tabla TFI_TAREAS_FORM_ITEMS
--##
--## VERSIONES:
--##	0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON
SET DEFINE OFF

DECLARE
    -- Pitertul constants.
    V_SCHEME VARCHAR2(25 CHAR)          := '#ESQUEMA#'; -- Configuración de esquema. Asignada por Pitertul.
	V_MASTER_SCHEME VARCHAR2(25 CHAR)   := '#ESQUEMA_MASTER#'; -- Configuración de esquema master. Asignada por Pitertul.
    --V_VERBOSITY_LEVEL NUMBER(1)         := OUTPUT_LEVEL.INFO; -- Configuración de nivel de verbosidad en el output log.

	V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_TABLE_NAME VARCHAR2(125 CHAR)     := 'TFI_TAREAS_FORM_ITEMS'; -- Indica el nombre de la tabla de referencia.
	V_AUDIT_USER VARCHAR2(50 CHAR)		:= 'HREOS-7608'; -- Indica el usuario para registrar en la auditoría con cada cambio.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	V_ORDEN NUMBER(2);
	V_AUX_ORDEN NUMBER(2);
	TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
	V_DATA_VALUES T_ARRAY_TFI := T_ARRAY_TFI(
	--	Modificar estructura y contenido acorde con el número y orden de columnas especificadas en 'V_COLUMNS_ARRAY'.
--				  		'TFI_TIPO', 		'TFI_NOMBRE', 			'TFI_LABEL', 						'TFI_ERROR_VALIDACION', 		'TFI_VALIDACION',	 'TFI_BUSINESS_OPERATION'
		T_TFI(			'combobox',			'comboRealizacion',	'Realización de la AT',			'''Este campo es obligatorio''',				'''false''',			'DDSiNo'),
		T_TFI(			'combobox',			'motivoNoRealizacion',	'Motivo no realización',				'null',								'null',			'DDMotivoNoAT')
	);
	V_DATA_CODIGOS T_ARRAY_TFI := T_ARRAY_TFI(
		T_TFI('T004_ResultadoTarificada'),
		T_TFI('T004_ResultadoNoTarificada')
	);
	V_TMP_DATA_VALUES T_TFI;
	V_TMP_DATA_CODIGOS T_TFI;
	V_IDT VARCHAR2(125 CHAR);
	V_TFI_TIPO VARCHAR2(50) := 'elctrabajo';
	V_TFI_NOMBRE VARCHAR2(50) := 'observaciones';
	
BEGIN
	FOR A IN V_DATA_CODIGOS.FIRST .. V_DATA_CODIGOS.LAST
	LOOP
		V_TMP_DATA_CODIGOS := V_DATA_CODIGOS(A);

		V_MSQL := 'SELECT TAP_ID FROM '||V_SCHEME||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_DATA_CODIGOS(1)||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_IDT;

		V_MSQL := 'SELECT COUNT(1) FROM '||V_SCHEME||'.'||V_TABLE_NAME||' WHERE TAP_ID IN (
			'''||V_IDT||'''
		)';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
		--COMPROBAMOS SI EXISTE EL CODIGO DE LA TAP
		IF V_NUM_TABLAS > 0 THEN
			V_MSQL := 'SELECT TFI_ORDEN FROM '||V_SCHEME||'.'||V_TABLE_NAME||' WHERE TAP_ID IN (
			'''||V_IDT||'''
			)
			AND TFI_NOMBRE = '''||V_TFI_NOMBRE||''' ';
			EXECUTE IMMEDIATE V_MSQL INTO V_ORDEN;
			DBMS_OUTPUT.PUT_LINE('[INICIO] Insertando datos de TFI_TAREAS_FORM_ITEMS - adición a la tarea '||V_IDT||'');
			FOR I IN V_DATA_VALUES.FIRST .. V_DATA_VALUES.LAST
			LOOP

				V_TMP_DATA_VALUES := V_DATA_VALUES(I);
				V_MSQL := 'SELECT COUNT(1) FROM '||V_SCHEME||'.'||V_TABLE_NAME||' WHERE TAP_ID = '''||V_IDT||'''
					AND TFI_NOMBRE = '''||V_TMP_DATA_VALUES(2)||'''
					';
				EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
			
				--COMPROBAMOS QUE LOS NUEVOS CAMPOS NO EXISTAN PREVIAMENTE
				IF V_NUM_TABLAS > 0 THEN

					DBMS_OUTPUT.PUT_LINE('[INFO] El campo '||V_TMP_DATA_VALUES(2)||' ya existe.');
					V_ORDEN := V_ORDEN - 1;

				ELSE

					V_MSQL := 'INSERT INTO '||V_SCHEME||'.'||V_TABLE_NAME||' 
					(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					SELECT 
					'||V_SCHEME||'.S_'||V_TABLE_NAME||'.NEXTVAL AS TFI_ID,
					'||V_IDT||' AS TAP_ID,
					'||V_ORDEN||' AS TFI_ORDEN,
					'''||V_TMP_DATA_VALUES(1)||''' AS TFI_TIPO,
					'''||V_TMP_DATA_VALUES(2)||''' AS TFI_NOMBRE,
					'''||V_TMP_DATA_VALUES(3)||''' AS TFI_LABEL,
					'||V_TMP_DATA_VALUES(4)||' AS TFI_ERROR_VALIDACION,
					'||V_TMP_DATA_VALUES(5)||' AS TFI_VALIDACION,
					'''||V_TMP_DATA_VALUES(6)||''' AS TFI_BUSINESS_OPERATION,
					0 AS VERSION,
					'''||V_AUDIT_USER||''' AS USUARIOCREAR,
					SYSDATE AS FECHACREAR,
					0 AS BORRADO FROM DUAL';
					DBMS_OUTPUT.PUT_LINE(V_MSQL);
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Se ha insertado correctamente el registro '||V_TMP_DATA_VALUES(2)||' en la tabla '||V_SCHEME||'.'||V_TABLE_NAME||'');
				END IF;
				V_ORDEN := V_ORDEN + 1;
			END LOOP;

			V_MSQL := 'SELECT TFI_ORDEN FROM '||V_SCHEME||'.'||V_TABLE_NAME||' WHERE TAP_ID IN (
			'''||V_IDT||'''
			)
			AND TFI_NOMBRE = '''||V_TFI_NOMBRE||''' ';
			EXECUTE IMMEDIATE V_MSQL INTO V_AUX_ORDEN;

			IF V_ORDEN <> V_AUX_ORDEN THEN

			V_MSQL := 'UPDATE '||V_SCHEME||'.'||V_TABLE_NAME||'
			SET TFI_ORDEN = '||V_ORDEN||'
				WHERE TAP_ID = '''||V_IDT||'''
				AND TFI_NOMBRE = '''||V_TFI_NOMBRE||'''
				';
			EXECUTE IMMEDIATE V_MSQL;

			V_ORDEN := V_ORDEN + 1;

			V_MSQL := 'UPDATE '||V_SCHEME||'.'||V_TABLE_NAME||'
			SET TFI_ORDEN = '||V_ORDEN||'
				WHERE TAP_ID = '''||V_IDT||'''
				AND TFI_TIPO = '''||V_TFI_TIPO||'''
				';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] actualizada la posición de orden de los campos de  '||V_TMP_DATA_CODIGOS(1)||' en la tabla '||V_SCHEME||'.'||V_TABLE_NAME||'');	
			END IF;
			DBMS_OUTPUT.PUT_LINE('[INFO] La insercion de los datos '||V_TMP_DATA_CODIGOS(1)||' en la tabla '||V_SCHEME||'.'||V_TABLE_NAME||' a finalizado correctamente');
		
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe la tarea '||V_TMP_DATA_CODIGOS(1)||' en la tabla '||V_SCHEME||'.TAP_TAREA_PROCEDIMIENTO. No se realiza ningun cambio.');
			
		END IF;
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de insercion/actualizacion de la tabla '||V_SCHEME||'.'||V_TABLE_NAME||' a finalizado correctamente');

	COMMIT;


EXCEPTION
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE(SQLERRM);
	ROLLBACK;
	RAISE;
END;
/
EXIT
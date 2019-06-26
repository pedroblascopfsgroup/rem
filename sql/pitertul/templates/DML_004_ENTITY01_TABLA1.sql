--/*
--#########################################
--## AUTOR=PEDRO BLASCO
--## FECHA_CREACION=20190523
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.6.01
--## INCIDENCIA_LINK=RECOVERY-15050
--## PRODUCTO=NO
--##
--## FINALIDAD: [Explicación de la existencia de este script]
--##
--## INSTRUCCIONES:
--##	1. Especificar el esquema de la tabla en la variable 'V_TABLE_SCHEME' apuntando a la variables 'V_SCHEME' o 'V_MASTER_SCHEME'.
--##	2. Especificar el nombre de la tabla a crear o modificar en la variable 'V_TABLE_NAME'.
--##	3. Especificar el usuario que quedará registrado en la auditoria para los cambios en la tabla en la variable 'V_AUDIT_USER'.
--##	4. Configurar las columnas que se verán afectadas al crear un nuevo registro en la tabla en la variable 'V_COLUMNS_ARRAY'.
--##	5. Configurar los datos a generar en las columnas indicadas anteriormente de la tabla en la variable 'V_DATA_MATRIX' siguiendo el patrón de diseño.
--##
--##	** No modificar las zonas entre BEGIN -> EXIT, la lógica implementada lleva a cabo las operaciones necesarias con las variables en el DECLARE **
--##	Más información: http://bit.ly/pitertul-api
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
    V_VERBOSITY_LEVEL NUMBER(1)         := OUTPUT_LEVEL.INFO; -- Configuración de nivel de verbosidad en el output log.

    -- User defined variables.
    V_TABLE_SCHEME VARCHAR2(25 CHAR)    := V_SCHEME; -- Indica el esquema de la tabla de referencia.
    V_TABLE_NAME VARCHAR2(125 CHAR)     := 'AAA_TEST'; -- Indica el nombre de la tabla de referencia.
	V_AUDIT_USER VARCHAR2(50 CHAR)		:= 'RECOVERY-15050'; -- Indica el usuario para registrar en la auditoría con cada cambio.

	V_COLUMNS_ARRAY ARRAY_TABLE 		:= ARRAY_TABLE('AAA_DESCRIPCION', 'AAA_IMPORTE', 'DD_TST_ID'); -- Indica las columnas en las cuales insertar contenido.

	V_DATA_MATRIX MATRIX_TABLE := MATRIX_TABLE(
	--	Modificar estructura y contenido acorde con el número y orden de columnas especificadas en 'V_COLUMNS_ARRAY'.
		ARRAY_TABLE('Hollywood',	'1200',			'CONCUR'),
		ARRAY_TABLE('Cangrejo', 	'150',			'PRECON')
	);
--10009
--10010
BEGIN
    pitertul.insert_common_table(V_TABLE_SCHEME, V_TABLE_NAME, V_COLUMNS_ARRAY, V_DATA_MATRIX, V_AUDIT_USER, V_VERBOSITY_LEVEL);
EXCEPTION
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE(SQLERRM);
	ROLLBACK;
	RAISE;
END;
/
EXIT
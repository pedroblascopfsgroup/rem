--/*
--#########################################
--## AUTOR=Jose Antonio Gigante
--## FECHA_CREACION=20191016
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7955
--## PRODUCTO=SI
--##
--## FINALIDAD: [Explicación de la existencia de este script]
--##
--## INSTRUCCIONES:
--##	1. Especificar el esquema de la tabla en la variable 'V_TABLE_SCHEME' apuntando a la variables 'V_SCHEME' o 'V_MASTER_SCHEME'.
--##	2. Especificar el nombre de la tabla a crear o modificar en la variable 'V_TABLE_NAME'.
--##	3. Especificar el comentario aclarativo de la tabla en la variable 'V_TABLE_COMMENT'.
--##	4. Configurar las columnas a crear o modificar en la matriz 'V_COLUMNS_MATRIX'. No especificar la columna de ID único, se genera automáticamente al crear la tabla.
--##	5. Configurar las foreign keys (opcional) en la variable 'V_FK_MATRIX'. Puede quedarse vacía para no crear nada.
--##	6. Configurar los índices (opcional) en la variable 'V_INDEX_MATRIX'. Puede quedarse vacía para no crear nada.
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR)  := '#TABLESPACE_INDEX#'; -- Configuración tablespace de índices. Asignada por Pitertul.
--    V_VERBOSITY_LEVEL NUMBER(1)         := OUTPUT_LEVEL.INFO; -- Configuración de nivel de verbosidad en el output log.

    -- User defined variables.
    V_TABLE_SCHEME VARCHAR2(25 CHAR)    := V_SCHEME; -- Indica el esquema de la tabla de referencia.
    V_TABLE_NAME VARCHAR2(125 CHAR)     := 'CCC_CONFIG_CTAS_CONTABLES'; -- Indica el nombre de la tabla de referencia.
	V_TABLE_COMMENT VARCHAR2(250 CHAR)  := 'Comentario para la tabla de ejemplo'; -- Indica el comentario de la tabla de referencia.
    V_TABLE_HAS_AUDIT BOOLEAN           := TRUE; -- Indica si la tabla debe contener las columnas estándar de auditoría.

	V_COLUMNS_MATRIX MATRIX_TABLE := MATRIX_TABLE(
	--				    NOMBRE						TIPO COLUMNA		                COMENTARIO
		ARRAY_TABLE('CCC_REFACTURABLE', 		'NUMBER(1) DEFAULT 0 NOT NULL',     'Indica si es un gasto refacturable')
	);

	V_FK_MATRIX MATRIX_TABLE := MATRIX_TABLE(
	--                ESQUEMA_ORIGEN            TABLA_ORIGEN          	CAMPO_ORIGEN     ESQUEMA_DESTINO        TABLA_DESTINO           CAMPO_DESTINO
		--ARRAY_TABLE(''||V_TABLE_SCHEME||'',    ''||V_TABLE_NAME||'',    'DD_ABC_ID',    ''||V_SCHEME||'',      'DD_ABC_DICCIONARIO',   'DD_ABC_ID')
	);

    V_INDEX_MATRIX MATRIX_TABLE := MATRIX_TABLE(
    --                TIPO_INDICE                    COLUMNA/S_AFECTADA/S
    --  [INDEX_TYPE.NORMAL | INDEX_TYPE.BITMAP]
		--ARRAY_TABLE(INDEX_TYPE.NORMAL,               'XYZ_COLUMNA_A'),
        --ARRAY_TABLE(INDEX_TYPE.NORMAL,               'XYZ_COLUMNA_A, XYZ_COLUMNA_B')
    );

BEGIN
    pitertul.create_or_modify_common_table(V_TABLE_SCHEME, V_TABLESPACE_IDX, V_TABLE_NAME, V_TABLE_COMMENT, V_COLUMNS_MATRIX, V_TABLE_HAS_AUDIT, V_FK_MATRIX, V_INDEX_MATRIX/*, V_VERBOSITY_LEVEL*/);
EXCEPTION
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE(SQLERRM);
	ROLLBACK;
	RAISE;
END;
/
EXIT

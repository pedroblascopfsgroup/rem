--/*
--#########################################
--## AUTOR=JULIAN DOLZ
--## FECHA_CREACION=20190918
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7608
--## PRODUCTO=NO
--##
--## FINALIDAD: Inserción de valores en un diccionario
--##
--## INSTRUCCIONES:
--##	1. Especificar el esquema de la tabla en la variable 'V_TABLE_SCHEME' apuntando a la variables 'V_SCHEME' o 'V_MASTER_SCHEME'.
--##	2. Especificar el nombre de la tabla a crear o modificar en la variable 'V_TABLE_NAME'.
--##	3. Especificar el usuario que quedará registrado en la auditoria para los cambios en la tabla en la variable 'V_AUDIT_USER'.
--##	4. Configurar los datos a generar en la tabla diccionario en la variable 'V_DATA_MATRIX' siguiendo el patrón de diseño.
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
    V_TABLE_NAME VARCHAR2(125 CHAR)     := 'DD_MNA_MOTIVO_NO_AT'; -- Indica el nombre de la tabla de referencia.
	V_AUDIT_USER VARCHAR2(50 CHAR)		:= 'HREOS-7608'; -- Indica el usuario para registrar en la auditoría con cada cambio.

	V_DATA_MATRIX MATRIX_TABLE := MATRIX_TABLE(
	--				CODIGO		DESCRIPCION			DESCRIPCION_LARGA
		ARRAY_TABLE('SUSP_LANZAMIENTO',
		 	'Suspensión lanzamiento',
			 		'Suspensión lanzamiento'),
		ARRAY_TABLE('VIVIENDA_OCUPADA',
		 	'Vivienda Ocupada o con signos de ocupación (Puerta/cerradura forzada)',
			 			'Vivienda Ocupada o con signos de ocupación (Puerta/cerradura forzada)'),
        ARRAY_TABLE('VIVIENDA_TAPIADA',
		 	'Vivienda Tapiada',
			 	'Vivienda Tapiada'),
		ARRAY_TABLE('NO_POSESION_ACTIVO',
		 	'No se tiene posesión del activo',
			 	'No se tiene posesión del activo'),
		ARRAY_TABLE('NO_LLAVES',
		 	'No se dispone de llaves',
			 	'No se dispone de llaves'),
		ARRAY_TABLE('NO_LICENCIA_PERMISO',
		 	'Necesidad de Licencia/Permiso Administrativo',
			 	'Necesidad de Licencia/Permiso Administrativo'),
		ARRAY_TABLE('DATOS_ERRONEOS',
		 	'Comunicación datos erróneos (fecha, hora, dirección)',
			 	'Comunicación datos erróneos (fecha, hora, dirección)'),
		ARRAY_TABLE('PRODUCTOS_PELIGROSOS', 
			'Existencia de productos químicos/inflamables/peligrosos: No requiere adjuntar documentación',
				'Existencia de productos químicos/inflamables/peligrosos: No requiere adjuntar documentación'),
		ARRAY_TABLE('ORDEN_NO_INTERVENIR',
		 	'No se puede intervenir en el activo por orden de Seguridad/Policía',
			 	'No se puede intervenir en el activo por orden de Seguridad/Policía'),
		ARRAY_TABLE('NO_PRESENTADA_PERSONA',
		 	'Persona a acompañar (Tasador/Técnico CEE/Tercero) no se ha presentado',
			 	'Persona a acompañar (Tasador/Técnico CEE/Tercero) no se ha presentado'),
		ARRAY_TABLE('FUERA_PLAZO_PERSONA',
		 	'Persona a acompañar (Tasador/Técnico CEE/Tercero) fija fecha fuera del plazo',
			 	'Persona a acompañar (Tasador/Técnico CEE/Tercero) fija fecha fuera del plazo'),
		ARRAY_TABLE('AMPLIACION_PLAZO',
		 	'Aceptación por SSCC de ampliación de plazo',
			 	'Aceptación por SSCC de ampliación de plazo'),
		ARRAY_TABLE('CONDICIONES_CLIMATOLOGICAS', 	'Condiciones climatológicas',	'Condiciones climatológicas')
	);

BEGIN
    pitertul.insert_or_update_dictionary(V_TABLE_SCHEME, V_TABLE_NAME, V_DATA_MATRIX, V_AUDIT_USER, V_VERBOSITY_LEVEL);
EXCEPTION
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE(SQLERRM);
	ROLLBACK;
	RAISE;
END;
/
EXIT
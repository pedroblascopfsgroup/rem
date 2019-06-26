--/*
--#########################################
--## AUTOR=PEDRO BLASCO
--## FECHA_CREACION=20190523
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.6.01
--## INCIDENCIA_LINK=RECOVERY-15050
--## PRODUCTO=NO
--##
--## FINALIDAD: Inserción de funciones y asociación a perfiles
--##
--## INSTRUCCIONES:
--##	1. Especificar el usuario que quedará registrado en la auditoria para los cambios en la tabla en la variable 'V_AUDIT_USER'.
--##	2. Especificar el código de la función en la variable 'V_FUNCTION_CODE'. Si no existe una función con ese código se genera una nueva.
--##	3. Especificar la descripción de la función en la variable 'V_FUNCTION_DESCRIPTION'. Si no existe una función con el código anterior especificado
--##	   se genera una nueva y se le asigna esta descripción, si existe la función se modifica su descripción actual.
--##	4. Especificar si se deben eliminar los registros existentes en la tabla de unión entre perfiles y funciones aquellos registros que coincidan con
--##	   la función especificada en la variable 'V_ERASE_PREVIOUS_DATA'.
--##	5. Configurar los códigos de los perfiles a unir con la función indicados en la variable 'V_PROFILES_ARRAY'. Los perfiles deben existir previamente.
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
	V_SCHEME VARCHAR2(25 CHAR)          		:= '#ESQUEMA#'; -- Configuración de esquema. Asignada por Pitertul.
	V_MASTER_SCHEME VARCHAR2(25 CHAR)			:= '#ESQUEMA_MASTER#'; -- Configuración de esquema master. Asignada por Pitertul.
    V_VERBOSITY_LEVEL NUMBER(1)					:= OUTPUT_LEVEL.INFO; -- Configuración de nivel de verbosidad en el output log.

    -- User defined variables.
	V_AUDIT_USER VARCHAR2(50 CHAR)				:= 'RECOVERY-15050'; -- Indica el usuario para registrar en la auditoría con cada cambio.
	V_FUNCTION_CODE VARCHAR2(50 CHAR) 			:= 'FUNCION_PEDRO'; -- Indica el código de la función a unir con los perfiles.
	V_FUNCTION_DESCRIPTION VARCHAR2(50 CHAR)	:= 'Puede ver lo mismo que Pedro'; -- Indica la descripción de la función a unir con los perfiles.
	V_ERASE_PREVIOUS_DATA BOOLEAN				:= FALSE; -- Indica si se deben eliminar los registros existentes de unión entre funciones y perfiles para la función especificada.

	V_PROFILES_ARRAY ARRAY_TABLE := ARRAY_TABLE(
	--	Indica los códigos de los perfiles que van a unirse con la función esepecificada en 'V_FUNCTION_CODE'.
		'HAYAGESTEXT', 'HAYAACCBI', 'FULLPRECON'
	);

BEGIN
    pitertul.join_many_profiles_to_function(V_SCHEME, V_MASTER_SCHEME, V_FUNCTION_CODE, V_FUNCTION_DESCRIPTION, V_ERASE_PREVIOUS_DATA, V_PROFILES_ARRAY, V_AUDIT_USER, V_VERBOSITY_LEVEL);
EXCEPTION
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE(SQLERRM);
	ROLLBACK;
	RAISE;
END;
/
EXIT
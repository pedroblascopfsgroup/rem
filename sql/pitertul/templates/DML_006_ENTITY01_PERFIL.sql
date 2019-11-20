--/*
--#########################################
--## AUTOR=PEDRO BLASCO
--## FECHA_CREACION=20190523
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.6.01
--## INCIDENCIA_LINK=RECOVERY-15050
--## PRODUCTO=NO
--##
--## FINALIDAD: Inserción de perfiles y asociación a funciones
--##
--## INSTRUCCIONES:
--##	1. Especificar el usuario que quedará registrado en la auditoria para los cambios en la tabla en la variable 'V_AUDIT_USER'.
--##	2. Especificar el código del perfil en la variable 'V_PROFILE_CODE'. Si no existe un perfil con ese código se genera un nuevo.
--##	3. Especificar la descripción del perfil en la variable 'V_PROFILE_DESCRIPTION'. Si no existe un perfil con el código anterior especificado
--##	   se genera uno nuevo y se le asigna esta descripción, si existe el perfil se modifica su descripción actual.
--##	4. Especificar la descripción larga del perfil en la variable 'V_PROFILE_L_DESCRIPTION'. Si no existe un perfil con el código anterior especificado
--##	   se genera uno nuevo y se le asigna esta descripción larga, si existe el perfil se modifica su descripción larga actual.
--##	5. Especificar si se deben eliminar los registros existentes en la tabla de unión entre perfiles y funciones aquellos registros que coincidan con
--##	   el perfil especificado en la variable 'V_ERASE_PREVIOUS_DATA'.
--##	6. Configurar los códigos de las funciones a unir con el perfil indicadas en la variable 'V_FUNCTIONS_ARRAY'. Las funciones deben existir previamente.
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
	V_PROFILE_CODE VARCHAR2(100 CHAR) 			:= 'PERFIL_PEDRO'; -- Indica el código del perfil a unir con las funciones.
	V_PROFILE_DESCRIPTION VARCHAR2(50 CHAR)		:= 'Perfil para Pedro'; -- Indica la descripción del perfil a unir con las funciones.
	V_PROFILE_L_DESCRIPTION VARCHAR2(250 CHAR)	:= 'Perfil para Pedro largo'; -- Indica la descripción larga del perfil a unir con las funciones.
	V_ERASE_PREVIOUS_DATA BOOLEAN				:= FALSE; -- Indica si se deben eliminar los registros existentes de unión entre funciones y perfiles para el perfil especificado.

	V_FUNCTIONS_ARRAY ARRAY_TABLE := ARRAY_TABLE(
	--	Indica los códigos de las funciones que van a unirse con el perfil esepecificado en 'V_PROFILE_CODE'.
		'BUSQUEDA', 'ROLE_COMITE', 'EDITAR_TITULOS', 'EDITAR_PROCEDIMIENTO'
	);

BEGIN
    pitertul.join_many_functions_to_profile(V_SCHEME, V_MASTER_SCHEME, V_PROFILE_CODE, V_PROFILE_DESCRIPTION, V_PROFILE_L_DESCRIPTION, V_ERASE_PREVIOUS_DATA, V_FUNCTIONS_ARRAY, V_AUDIT_USER, V_VERBOSITY_LEVEL);
EXCEPTION
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE(SQLERRM);
	ROLLBACK;
	RAISE;
END;
/
EXIT
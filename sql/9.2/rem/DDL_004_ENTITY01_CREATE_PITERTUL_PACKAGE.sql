--/*
--######################################### 
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20190307
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.1.0
--## INCIDENCIA_LINK=ARQ-1613
--## PRODUCTO=SI
--##
--## Finalidad: Crear nuevo paquete pitertul en la DB.
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
BEGIN

	DBMS_OUTPUT.PUT_LINE('[BEGIN]');

	DBMS_OUTPUT.PUT('[INFO] Create new PACKAGE pitertul...');  
	EXECUTE IMMEDIATE 'create or replace PACKAGE PITERTUL IS

		-- Constants for this package.
		MANDATORY_PARAMETERS_EMPTY					EXCEPTION;
		ORACLE_ENV_MAX_NAME_CHARS_EXCEED			EXCEPTION;
		TABLE_NAME_STANDARD_NOMENCALTURE			EXCEPTION;
		TABLE_DO_NOT_EXISTS							EXCEPTION;
		COLUMN_DO_NOT_EXISTS						EXCEPTION;
		CHANGE_COL_NULL_ATRIBUTE_NON_EMPTY_TABLE	EXCEPTION;
		DICTIONARY_CODE_NOT_MATCH					EXCEPTION;
		FUNCTION_DO_NOT_EXIST						EXCEPTION;
		PROFILE_DO_NOT_EXIST						EXCEPTION;

		PRAGMA EXCEPTION_INIT(MANDATORY_PARAMETERS_EMPTY, -20001);
		PRAGMA EXCEPTION_INIT(ORACLE_ENV_MAX_NAME_CHARS_EXCEED, -20002);
		PRAGMA EXCEPTION_INIT(TABLE_NAME_STANDARD_NOMENCALTURE, -20003);
		PRAGMA EXCEPTION_INIT(TABLE_DO_NOT_EXISTS, -20004);
		PRAGMA EXCEPTION_INIT(COLUMN_DO_NOT_EXISTS, -20005);
		PRAGMA EXCEPTION_INIT(CHANGE_COL_NULL_ATRIBUTE_NON_EMPTY_TABLE, -20006);
		PRAGMA EXCEPTION_INIT(DICTIONARY_CODE_NOT_MATCH, -20007);
		PRAGMA EXCEPTION_INIT(FUNCTION_DO_NOT_EXIST, -20008);
		PRAGMA EXCEPTION_INIT(PROFILE_DO_NOT_EXIST, -20009);

		-- Public procedures.
		PROCEDURE create_or_modify_common_table(
			table_scheme     VARCHAR2,
			tablespace_idx   VARCHAR2,
			table_name       VARCHAR2,
			table_comment    VARCHAR2,
			table_columns    MATRIX_TABLE,
			table_has_audit  BOOLEAN DEFAULT TRUE,
			columns_fk       MATRIX_TABLE DEFAULT NULL,
			table_index      MATRIX_TABLE DEFAULT NULL,
			log_level        NUMBER DEFAULT OUTPUT_LEVEL.INFO
		);

		PROCEDURE create_dictionary(
			table_scheme     VARCHAR2,
			tablespace_idx   VARCHAR2,
			table_name       VARCHAR2,
			table_comment    VARCHAR2,
			log_level        NUMBER DEFAULT OUTPUT_LEVEL.INFO
		);

		PROCEDURE insert_or_update_dictionary(
			table_scheme   VARCHAR2,
			table_name     VARCHAR2,
			table_data     MATRIX_TABLE,
			audit_user     VARCHAR2,
			log_level      NUMBER DEFAULT OUTPUT_LEVEL.INFO
		);

		PROCEDURE insert_common_table(
			table_scheme   VARCHAR2,
			table_name     VARCHAR2,
			table_columns  ARRAY_TABLE,
			table_data     MATRIX_TABLE,
			audit_user     VARCHAR2,
			log_level      NUMBER DEFAULT OUTPUT_LEVEL.INFO
		);

		PROCEDURE join_many_functions_to_profile(
			scheme   				VARCHAR2,
			master_scheme   		VARCHAR2,
			profile_code			VARCHAR2,
			profile_description		VARCHAR2,
			profile_l_description	VARCHAR2,
			erase_previous_data	BOOLEAN,
			functions_data			ARRAY_TABLE,
			audit_user				VARCHAR2,
			log_level				NUMBER DEFAULT OUTPUT_LEVEL.INFO
		);

		PROCEDURE join_many_profiles_to_function(
			scheme   				VARCHAR2,
			master_scheme   		VARCHAR2,
			function_code			VARCHAR2,
			function_description	VARCHAR2,
			erase_previous_data	BOOLEAN,
			profiles_data			ARRAY_TABLE,
			audit_user				VARCHAR2,
			log_level				NUMBER DEFAULT OUTPUT_LEVEL.INFO
		);

	END PITERTUL;';
	DBMS_OUTPUT.PUT_LINE('OK');
				
	DBMS_OUTPUT.PUT_LINE('[DONE]');

	COMMIT;

EXCEPTION
  WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('KO');
	DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:' || TO_CHAR(SQLCODE));
	DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
	DBMS_OUTPUT.PUT_LINE(SQLERRM);
	ROLLBACK;
	RAISE;

END;
/
EXIT;
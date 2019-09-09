--/*
--######################################### 
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20190212
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.0.0
--## INCIDENCIA_LINK=ARQ-1613
--## PRODUCTO=SI
--##
--## Finalidad: Crear nuevo paquete output_level en la DB con constantes de uso.
--##			Define constantes de nivel de salida por consola. Utilizado por el paquete pitertul.
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

	DBMS_OUTPUT.PUT('[INFO] Create new PACKAGE INDICE...');  
	EXECUTE IMMEDIATE 'create or replace PACKAGE OUTPUT_LEVEL IS

		DEBUG   constant number(1):=1;
		VERBOSE constant number(1):=2;
		INFO    constant number(1):=3;

	END OUTPUT_LEVEL;';
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
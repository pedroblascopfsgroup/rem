--/*
--######################################### 
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20190212
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.0.0
--## INCIDENCIA_LINK=ARQ-1613
--## PRODUCTO=SI
--##
--## Finalidad: Crear nuevo paquete index_type en la DB con constantes de uso.
--##			Define constantes de tipo de índices. Utilizado por el paquete pitertul.
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

	DBMS_OUTPUT.PUT('[INFO] Create new PACKAGE INDEX_TYPE...');  
	EXECUTE IMMEDIATE 'create or replace PACKAGE INDEX_TYPE IS

		NORMAL constant number(1):=1;
		BITMAP constant number(1):=2;

	END INDEX_TYPE;';
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
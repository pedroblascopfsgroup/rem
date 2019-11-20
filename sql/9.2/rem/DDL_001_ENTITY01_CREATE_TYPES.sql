--/*
--######################################### 
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20190212
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.0.0
--## INCIDENCIA_LINK=ARQ-1613
--## PRODUCTO=SI
--## 
--## Finalidad: Crear nuevos tipos de contenido TYPE en la DB.
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
BEGIN

	DBMS_OUTPUT.PUT_LINE('[BEGIN]');

	DBMS_OUTPUT.PUT('[INFO] Create new TYPE ARRAY_TABLE...');  
	EXECUTE IMMEDIATE 'create or replace TYPE ARRAY_TABLE AS TABLE OF VARCHAR2(250 CHAR)';
	DBMS_OUTPUT.PUT_LINE('OK');

	DBMS_OUTPUT.PUT('[INFO] Create new TYPE ARRAY_TABLE...');  
	EXECUTE IMMEDIATE 'create or replace TYPE MATRIX_TABLE AS TABLE OF ARRAY_TABLE';
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
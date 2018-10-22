--/*
--#########################################
--## AUTOR=Ivan Castelló
--## FECHA_CREACION=20180914
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1816
--## PRODUCTO=NO
--## 
--## Finalidad: Crear tabla aux
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1816';
    V_SQL VARCHAR2(4000 CHAR); 
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  


BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Comprobamos existencia de la tabla AUX_SFORM_REMVIP_1816');

	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''AUX_SFORM_REMVIP_1816'' AND OWNER= '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;	


	IF V_NUM_TABLAS > 0 THEN

	    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.AUX_SFORM_REMVIP_1816 YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

	    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.AUX_SFORM_REMVIP_1816';
	    
	END IF;



	V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.AUX_SFORM_REMVIP_1816
				(ACT NUMBER(16,0) NOT NULL ENABLE, 
				USU NUMBER(16,0))';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Creada tabla AUX_SFORM_REMVIP_1816');


	EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||V_ESQUEMA||'.AUX_SFORM_REMVIP_1816 TO REM01';

   COMMIT;


EXCEPTION
    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;

END;
/
EXIT;

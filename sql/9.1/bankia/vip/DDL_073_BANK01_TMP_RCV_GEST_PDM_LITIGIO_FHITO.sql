--/*
--##########################################
--## AUTOR=DAVID GONZÁLEZ
--## FECHA_CREACION=20151020
--## ARTEFACTO=
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=BKREC-1160
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_SENTENCIA VARCHAR2(32000 CHAR); -- SENTENCIA A EJECUTAR (ANTERIORMENTE V_MSQL)
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- CONFIGURACIÓN ESQUEMA
	V_TABLA VARCHAR2(30 CHAR):= 'TMP_RCV_GEST_PDM_LITIGIO_FHITO'; -- DECLARA LA TABLA
	
BEGIN

	V_SENTENCIA:= 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' AS SELECT * FROM PFSRECOVERY.'||V_TABLA||'';
	EXECUTE IMMEDIATE V_SENTENCIA;

	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA||' creada en '||V_ESQUEMA||'.');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');


	EXCEPTION
	
     	WHEN OTHERS THEN
     
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(SQLERRM);

          ROLLBACK;
          RAISE;          

	END;
	/

	EXIT;

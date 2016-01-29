--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20151217
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1.0
--## INCIDENCIA_LINK=PRODUCTO-527
--## PRODUCTO=SI
--## Finalidad: Crear tabla PEM_PERSONAS_INICIALES y su correspondiente secuencia 
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_STRING VARCHAR2(10); -- Vble. para validar la existencia de si el campo es nulo
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

    BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos la existencia de la tabla PEM_PERSONAS_MANUALES');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME=''PEM_PERSONAS_MANUALES'' AND OWNER='''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
	
	IF V_COUNT = 0 THEN
		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.PEM_PERSONAS_MANUALES 
   					(PEM_ID NUMBER(16,0) PRIMARY KEY NOT NULL,
					 PEM_DOC_ID VARCHAR2(20 CHAR) NOT NULL, 
					 PEM_NOMBRE VARCHAR2(100 CHAR) NOT NULL, 
					 PEM_APELLIDO1 VARCHAR2(100 CHAR), 
					 PEM_APELLIDO2 VARCHAR2(100 CHAR), 
					 VERSION NUMBER(*,0) DEFAULT 0 NOT NULL, 
					 USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL, 
					 FECHACREAR TIMESTAMP (6) NOT NULL, 
					 USUARIOMODIFICAR VARCHAR2(50 CHAR), 
					 FECHAMODIFICAR TIMESTAMP (6), 
					 USUARIOBORRAR VARCHAR2(50 CHAR), 
					 FECHABORRAR TIMESTAMP (6), 
					 BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] La tabla PEM_PERSONAS_MANUALES ha sido creada correctamente.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] La tabla PEM_PERSONAS_MANUALES ya existia.');
	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos la existencia de la secuencia S_PEM_PERSONAS_MANUALES');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME=''S_PEM_PERSONAS_MANUALES'' AND SEQUENCE_OWNER='''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
	
	IF V_COUNT = 0 THEN
		V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_PEM_PERSONAS_MANUALES MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 CACHE 20 NOORDER  NOCYCLE';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] La secuencia S_PEM_PERSONAS_MANUALES ha sido creada correctamente.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] La secuencia S_PEM_PERSONAS_MANUALES ya existia.');
	END IF;	
	
	
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;

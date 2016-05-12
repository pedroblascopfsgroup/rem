--/*
--##########################################
--## AUTOR=Rafael Aracil López
--## FECHA_CREACION=20160428
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HRE
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla TMP_GESTOR_DOC
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    BEGIN

    -- ******** DD_DES_DECISION_SANCION *******
    DBMS_OUTPUT.PUT_LINE('******** TMP_GESTOR_DOC ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_GESTOR_DOC... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_PCO_LIQ_ESTADO
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_GESTOR_DOC'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_GESTOR_DOC... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_GESTOR_DOC
               ("ADA_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"ASU_ID" NUMBER(16,0) NOT NULL ENABLE,
  "PRC_ID" NUMBER(16,0),
	"ADA_NOMBRE" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"ADA_CONTENT_TYPE" VARCHAR2(100 CHAR) NOT NULL ENABLE, 
	"ADA_LENGTH" NUMBER(16,0) NOT NULL ENABLE, 
	"ADA_DESCRIPCION" VARCHAR2(1024 CHAR), 
  SERVICER_ID NUMBER(16,0) NOT NULL ENABLE, 
SERVICER_TIPO VARCHAR2(1024 CHAR), 
SERVICER_CLASE NUMBER(16,0) NOT NULL ENABLE, 
NOMBRE_ARCHIVO VARCHAR2(100 CHAR) NOT NULL ENABLE, 
TDN1 VARCHAR2(100 CHAR) NOT NULL ENABLE, 
TDN2 VARCHAR2(100 CHAR) NOT NULL ENABLE, 
idExpediente NUMBER(16,0),
idDocumento NUMBER(16,0)
			  )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TMP_GESTOR_DOC... Tabla creada');
	
		
    END IF;
    
    COMMIT;
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

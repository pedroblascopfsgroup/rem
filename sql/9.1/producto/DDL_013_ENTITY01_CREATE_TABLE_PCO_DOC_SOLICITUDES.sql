--/*
--##########################################
--## AUTOR=AGUSTIN MOMPO
--## FECHA_CREACION=20150625
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-75
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla PCO_DOC_SOLICITUDES
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

    BEGIN

    -- Creacion Tabla PCO_DOC_SOLICITUDES
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PCO_DOC_SOLICITUDES'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PCO_DOC_SOLICITUDES... Tabla YA EXISTE');
    ELSE
    		  --Creamos la tabla
    		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.PCO_DOC_SOLICITUDES
               (PCO_DOC_DSO_ID		      	NUMBER(16) 		 NOT NULL ENABLE
               ,PCO_DOC_PDD_ID			  	NUMBER(16) 		 NOT NULL ENABLE
			   ,DD_PCO_DSR_ID  	  		  	NUMBER(16) 	     
			   ,DD_PCO_DSA_ID  	  		  	NUMBER(16) 	     NOT NULL ENABLE
			   ,USD_ID  				  	NUMBER(16) 		 NOT NULL ENABLE
			   ,PCO_DOC_DSO_FECHA_SOLICITUD TIMESTAMP(6)
			   ,PCO_DOC_DSO_FECHA_ENVIO    	TIMESTAMP(6) 
			   ,PCO_DOC_DSO_FECHA_RESULTADO TIMESTAMP(6)
			   ,PCO_DOC_DSO_FECHA_RECEPCION TIMESTAMP(6)
			   ,SYS_GUID				    VARCHAR2(36 CHAR)
			   ,VERSION                   	INTEGER             DEFAULT 0  NOT NULL
		  	   ,USUARIOCREAR              	VARCHAR2(10 CHAR)   NOT NULL
		  	   ,FECHACREAR                	TIMESTAMP(6)        NOT NULL
		  	   ,USUARIOMODIFICAR          	VARCHAR2(10 CHAR)
		  	   ,FECHAMODIFICAR            	TIMESTAMP(6)
		  	   ,USUARIOBORRAR             	VARCHAR2(10 CHAR)
		  	   ,FECHABORRAR               	TIMESTAMP(6)
		  	   ,BORRADO                   	NUMBER(1)           DEFAULT 0  NOT NULL
			   ,CONSTRAINT PCO_DOC_SOLICITUDES PRIMARY KEY (PCO_DOC_DSO_ID)
			   ,CONSTRAINT PCO_DOC_SOLICITUDES_PDD FOREIGN KEY (PCO_DOC_PDD_ID) REFERENCES PCO_DOC_DOCUMENTOS (PCO_DOC_PDD_ID)
			   ,CONSTRAINT PCO_DOC_SOLICITUDES_DSR FOREIGN KEY (DD_PCO_DSR_ID) REFERENCES DD_PCO_DOC_SOLICIT_RESULTADO (DD_PCO_DSR_ID)
			   ,CONSTRAINT PCO_DOC_SOLICITUDES_DSA FOREIGN KEY (DD_PCO_DSA_ID) REFERENCES DD_PCO_DOC_SOLICIT_TIPOACTOR (DD_PCO_DSA_ID)
			   ,CONSTRAINT PCO_DOC_SOLICITUDES_USD FOREIGN KEY (USD_ID) REFERENCES USD_USUARIOS_DESPACHOS (USD_ID)
               )';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_DOC_SOLICITUDES... Tabla creada');
    		
    		execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_PCO_DOC_SOLICITUDES  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_PCO_DOC_SOLICITUDES... Secuencia creada correctamente.');
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
    
    
    
    
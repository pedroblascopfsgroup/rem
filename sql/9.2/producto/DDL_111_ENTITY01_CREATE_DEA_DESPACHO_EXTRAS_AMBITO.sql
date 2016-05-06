--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160605
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1272
--## PRODUCTO=SI
--##
--## Finalidad: DDL Creación de la tabla DEA_DESPACHO_EXTRAS_AMBITO, provincias donde el despacho actúa
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN

    -- ******** DEA_DESPACHO_EXTRAS_AMBITO *******
    DBMS_OUTPUT.PUT_LINE('******** DEA_DESPACHO_EXTRAS_AMBITO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DEA_DESPACHO_EXTRAS_AMBITO... Comprobaciones previas'); 
       
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DEA_DESPACHO_EXTRAS_AMBITO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DEA_DESPACHO_EXTRAS_AMBITO... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.DEA_DESPACHO_EXTRAS_AMBITO
               	(DEA_ID							NUMBER(16) 		 	NOT NULL ENABLE
               	,DD_PRV_ID				  		NUMBER(16)  	 	NOT NULL
			   	,DD_CCA_ID			  			NUMBER(16)
				,DES_ID							NUMBER(16)  		NOT NULL
 				,VERSION 				  	  	INTEGER DEFAULT 0   NOT NULL
  			   	,USUARIOCREAR              	  	VARCHAR2(50 CHAR)   NOT NULL
  			   	,FECHACREAR                	  	TIMESTAMP(6)        NOT NULL
  			   	,USUARIOMODIFICAR          	  	VARCHAR2(50 CHAR)
  			   	,FECHAMODIFICAR            	  	TIMESTAMP(6)
  			   	,USUARIOBORRAR             	  	VARCHAR2(50 CHAR)
  			   	,FECHABORRAR               	  	TIMESTAMP(6)
  			   	,BORRADO                   	  	NUMBER(1)           DEFAULT 0  NOT NULL
			   	,CONSTRAINT PK_DEA_DESPACHO_AMBITO_ID PRIMARY KEY (DEA_ID)
				,CONSTRAINT FK_DEA_DD_PRV FOREIGN KEY (DD_PRV_ID) REFERENCES '|| V_ESQUEMA_M ||'.DD_PRV_PROVINCIA (DD_PRV_ID)
				,CONSTRAINT FK_DEA_DD_CCA FOREIGN KEY (DD_CCA_ID) REFERENCES '|| V_ESQUEMA_M ||'.DD_CCA_COMUNIDAD (DD_CCA_ID)
				,CONSTRAINT FK_DEA_DES_ID FOREIGN KEY (DES_ID) REFERENCES '|| V_ESQUEMA ||'.DES_DESPACHO_EXTERNO (DES_ID)
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DEA_DESPACHO_EXTRAS_AMBITO... Tabla creada');
		
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DEA_DESPACHO_EXTRAS_AMBITO  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DEA_DESPACHO_EXTRAS_AMBITO... Secuencia creada correctamente.');

		COMMIT;
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
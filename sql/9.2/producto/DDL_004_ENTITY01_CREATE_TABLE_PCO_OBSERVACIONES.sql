--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160217
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-812
--## PRODUCTO=SI
--##
--## Finalidad: DDL Creación de la tabla PCO_OBS_OBSERVACIONES
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

    -- ******** PCO_OBS_OBSERVACIONES *******
    DBMS_OUTPUT.PUT_LINE('******** PCO_OBS_OBSERVACIONES ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PCO_OBS_OBSERVACIONES... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_IMV_IMPOSICION_VENTA
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PCO_OBS_OBSERVACIONES'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PCO_OBS_OBSERVACIONES... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.PCO_OBS_OBSERVACIONES
               	(PCO_OBS_ID						NUMBER(16) 		 	NOT NULL ENABLE
			   	,PCO_PRC_ID						NUMBER(16)   		NOT NULL ENABLE
               	,PCO_OBS_FECHA_ANOTACION	  	TIMESTAMP(6) 	 	
			   	,PCO_OBS_TEXTO_ANOTACION  		VARCHAR2(4000 CHAR) 
				,PCO_OBS_SECUENCIA_ANOTACION	NUMBER(2)
				,USU_ID							NUMBER(16)
 				,VERSION 				  	  	INTEGER DEFAULT 0   NOT NULL
  			   	,USUARIOCREAR              	  	VARCHAR2(10 CHAR)   NOT NULL
  			   	,FECHACREAR                	  	TIMESTAMP(6)        NOT NULL
  			   	,USUARIOMODIFICAR          	  	VARCHAR2(10 CHAR)
  			   	,FECHAMODIFICAR            	  	TIMESTAMP(6)
  			   	,USUARIOBORRAR             	  	VARCHAR2(10 CHAR)
  			   	,FECHABORRAR               	  	TIMESTAMP(6)
  			   	,BORRADO                   	  	NUMBER(1)           DEFAULT 0  NOT NULL
			   	,CONSTRAINT PK_PCO_OBS_OBSERVACIONES_ID PRIMARY KEY (PCO_OBS_ID)
			   	,CONSTRAINT FK_PCO_OBS_PCO_PRC FOREIGN KEY (PCO_PRC_ID) REFERENCES '|| V_ESQUEMA ||'.PCO_PRC_PROCEDIMIENTOS (PCO_PRC_ID)
				,CONSTRAINT FK_PCO_OBS_USU FOREIGN KEY (USU_ID) REFERENCES '|| V_ESQUEMA_M ||'.USU_USUARIOS (USU_ID)
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_OBS_OBSERVACIONES... Tabla creada');
  		
  		V_MSQL := 'CREATE INDEX ' || V_ESQUEMA || '.IDX_PCO_OBS_PCO_PRC_ID ON ' || V_ESQUEMA || '.PCO_OBS_OBSERVACIONES (PCO_PRC_ID) ' ||
		'  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 ' ||
  		'  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE ' || V_TS_INDEX;
  		EXECUTE IMMEDIATE V_MSQL;
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.IDX_PCO_OBS_PCO_PRC_ID... Indice creado hacia PCO_PRC_ID');
  		
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_PCO_OBS_OBSERVACIONES  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_PCO_OBS_OBSERVACIONES... Secuencia creada correctamente.');
		
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
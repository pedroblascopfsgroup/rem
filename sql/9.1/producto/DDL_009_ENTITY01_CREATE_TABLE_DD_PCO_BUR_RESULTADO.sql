--/*
--##########################################
--## AUTOR=VICENTE LOZANO
--## FECHA_CREACION=24-06-2015
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-76
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla DD_PCO_BFR_RESULTADO
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
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

    BEGIN

    -- ******** DD_PCO_LIQ_ESTADO *******
    DBMS_OUTPUT.PUT_LINE('******** DD_PCO_BFR_RESULTADO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_PCO_BFR_RESULTADO... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_PCO_LIQ_ESTADO
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_PCO_BFR_RESULTADO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_PCO_BFR_RESULTADO... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.DD_PCO_BFR_RESULTADO
               (DD_PCO_BFR_ID  	  	  		  NUMBER(16) 		  
			   ,DD_PCO_BFR_CODIGO		  	  VARCHAR2(20 CHAR)   NOT NULL ENABLE
               ,DD_PCO_BFR_DESCRIPCION  	  VARCHAR2(50 CHAR)   NOT NULL ENABLE
			   ,DD_PCO_BFR_DESCRIPCION_LARGA  VARCHAR2(250 CHAR)  NOT NULL ENABLE
 			   ,VERSION 				  	  INTEGER DEFAULT 0   NOT NULL
  			   ,USUARIOCREAR              	  VARCHAR2(10 CHAR)   NOT NULL
  			   ,FECHACREAR                	  TIMESTAMP(6)        NOT NULL
  			   ,USUARIOMODIFICAR          	  VARCHAR2(10 CHAR)
  			   ,FECHAMODIFICAR            	  TIMESTAMP(6)
  			   ,USUARIOBORRAR             	  VARCHAR2(10 CHAR)
  			   ,FECHABORRAR               	  TIMESTAMP(6)
  			   ,BORRADO                   	  NUMBER(1)           DEFAULT 0  NOT NULL
			   ,CONSTRAINT PK_DD_PCO_BFR_ID PRIMARY KEY (DD_PCO_BFR_ID)
			   ,CONSTRAINT UNIQUE_DD_PCO_BFR_CODIGO UNIQUE (DD_PCO_BFR_CODIGO)
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PCO_BFR_RESULTADO... Tabla creada');
		
		V_MSQL := 'CREATE INDEX ' || V_ESQUEMA || '.IDX_DD_PCO_BFR_RESULTADO ON ' || V_ESQUEMA || '.DD_PCO_BFR_RESULTADO (DD_PCO_BFR_DESCRIPCION) ' ||
		'  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 ' ||
  		'  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE ' || V_TS_INDEX;
  		EXECUTE IMMEDIATE V_MSQL;
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PCO_BFR_RESULTADO... Indice creado');
  		
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_PCO_BFR_RESULTADO  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_PCO_BFR_RESULTADO... Secuencia creada correctamente.');
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

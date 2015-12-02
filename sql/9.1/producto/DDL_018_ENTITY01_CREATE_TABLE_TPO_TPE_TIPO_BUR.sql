--/*
--##########################################
--## AUTOR=VICENTE LOZANO
--## FECHA_CREACION=14-07-2015
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-145
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla PCO_TPO_TPE_TIPO_BUR
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
    DBMS_OUTPUT.PUT_LINE('******** PCO_TPO_TPE_TIPO_BUR  ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PCO_TPO_TPE_TIPO_BUR... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_PCO_LIQ_ESTADO
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PCO_TPO_TPE_TIPO_BUR'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PCO_TPO_TPE_TIPO_BUR... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.PCO_TPO_TPE_TIPO_BUR
               (PCO_TPO_TPE_TIPO_BUR_ID	  NUMBER(16)
			   ,DD_TPO_ID  	  	  	      NUMBER(16) 
 			   ,DD_TPE_ID				  NUMBER(16)		  
			   ,DD_PCO_BFT_ID			  NUMBER(16)              
 			   ,VERSION 				  INTEGER DEFAULT 0   NOT NULL
  			   ,USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL
  			   ,FECHACREAR                TIMESTAMP(6)        NOT NULL
  			   ,USUARIOMODIFICAR          VARCHAR2(10 CHAR)
  			   ,FECHAMODIFICAR            TIMESTAMP(6)
  			   ,USUARIOBORRAR             VARCHAR2(10 CHAR)
  			   ,FECHABORRAR               TIMESTAMP(6)
  			   ,BORRADO                   NUMBER(1)           DEFAULT 0  NOT NULL
			   ,CONSTRAINT PK_PCO_TPO_TPE_TIPO_BUR PRIMARY KEY (PCO_TPO_TPE_TIPO_BUR_ID)
			   ,CONSTRAINT UNIQUE_PCO_TPO_TPE_TIPO_BUR UNIQUE (DD_TPO_ID,DD_TPE_ID,DD_PCO_BFT_ID)
			   ,CONSTRAINT FK_PCO_TPO_TPE_TIPO_BUR_TPO FOREIGN KEY (DD_TPO_ID) REFERENCES DD_TPO_TIPO_PROCEDIMIENTO (DD_TPO_ID)
			   ,CONSTRAINT FK_PCO_TPO_TPE_TIPO_BUR_TPE FOREIGN KEY (DD_TPE_ID) REFERENCES DD_TPE_TIPO_PROD_ENTIDAD (DD_TPE_ID)
			   ,CONSTRAINT FK_PCO_TPO_TPE_TIPO_BUR_BFT FOREIGN KEY (DD_PCO_BFT_ID) REFERENCES DD_PCO_BFT_TIPO (DD_PCO_BFT_ID)
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_TPO_TPE_TIPO_BUR... Tabla creada');
  		
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_PCO_TPO_TPE_TIPO_BUR  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_TPO_TPE_TIPO_BUR.. Secuencia creada correctamente.');
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

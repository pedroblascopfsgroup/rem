--/*
--##########################################
--## AUTOR=VICENTE LOZANO
--## FECHA_CREACION=24-06-2015
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-76
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla PCO_PRC_PROCEDIMIENTOS
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
	    
	 -- Creacion Tabla PCO_PRC_PROCEDIMIENTOS
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PCO_PRC_PROCEDIMIENTOS'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS... La tabla YA EXISTE');
    ELSE
    		  --Creamos la tabla
    		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS
               (PCO_PRC_ID				  		NUMBER(16)		  
			   ,PRC_ID  		  		        NUMBER(16) 		  NOT NULL ENABLE
			   ,PCO_PRC_TIPO_PRC_PROP  	  		NUMBER(16) 
			   ,PCO_PRC_TIPO_PRC_INICIADO 		NUMBER(16)
			   ,PCO_PRC_PRETURNADO 		  		INTEGER DEFAULT 0   NOT NULL
			   ,PCO_PRC_NUM_EXP_EXT 	  		VARCHAR2(50 CHAR)
			   ,PCO_PRC_NOM_EXP_JUD 	  		VARCHAR2(50 CHAR)
			   ,PCO_PRC_CNT_PRINCIPAL  	  		NUMBER(16)
			   ,PCO_PRC_NUM_EXP_INT 	  		VARCHAR2(50 CHAR)
			   ,DD_PCO_PTP_ID 		      		NUMBER(16)
			   ,SYS_GUID						VARCHAR2(36 CHAR)
			   ,VERSION                   		INTEGER             DEFAULT 0  NOT NULL
			   ,USUARIOCREAR              		VARCHAR2(10 CHAR)   NOT NULL
			   ,FECHACREAR                		TIMESTAMP(6)        NOT NULL
			   ,USUARIOMODIFICAR          		VARCHAR2(10 CHAR)
			   ,FECHAMODIFICAR            		TIMESTAMP(6)
			   ,USUARIOBORRAR             		VARCHAR2(10 CHAR)
			   ,FECHABORRAR               		TIMESTAMP(6)
			   ,BORRADO                   		NUMBER(1)           DEFAULT 0  NOT NULL
			   ,CONSTRAINT PK_PCO_PRC_PROCEDIMIENTOS PRIMARY KEY (PCO_PRC_ID)
			   ,CONSTRAINT UNIQUE_PCO_PRC_PROCEDIMIENTOS UNIQUE (PRC_ID)
			   ,CONSTRAINT FK_PCO_PRC_TIPO_PREP FOREIGN KEY (DD_PCO_PTP_ID) REFERENCES DD_PCO_PRC_TIPO_PREPARACION (DD_PCO_PTP_ID)
			   ,CONSTRAINT FK_PCO_PRC_PRC_PROC FOREIGN KEY (PRC_ID) REFERENCES PRC_PROCEDIMIENTOS (PRC_ID)
               ,CONSTRAINT FK_PCO_PRC_PRC_PROC_P FOREIGN KEY (PCO_PRC_TIPO_PRC_PROP) REFERENCES DD_TPO_TIPO_PROCEDIMIENTO (DD_TPO_ID)
               ,CONSTRAINT FK_PCO_PRC_PRC_PROC_I FOREIGN KEY (PCO_PRC_TIPO_PRC_INICIADO) REFERENCES DD_TPO_TIPO_PROCEDIMIENTO (DD_TPO_ID)
               )';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_PRC_PROCEDIMIENTOS... Tabla creada');
    		
    		execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_PCO_PRC_PROCEDIMIENTOS  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_PCO_PRC_PROCEDIMIENTOS... Secuencia creada correctamente.');
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

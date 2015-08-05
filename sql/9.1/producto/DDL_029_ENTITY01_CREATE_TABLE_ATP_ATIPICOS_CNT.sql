--/*
--##########################################
--## AUTOR=AGUSTIN MOMPO
--## FECHA_CREACION=20150804
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-161
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla ATP_ATIPICOS_CNT
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
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ATP_ATIPICOS_CNT'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ATP_ATIPICOS_CNT... La tabla YA EXISTE');
    ELSE
    		  --Creamos la tabla
    		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.ATP_ATIPICOS_CNT
               (ATP_ID				  		    NUMBER(16)
			   ,ATP_FECHA_EXTRACCION			TIMESTAMP(6) NOT NULL
               ,ATP_FECHA_DATO					TIMESTAMP(6) NOT NULL
               ,DD_TPE_ID						NUMBER(16) NOT NULL
			   ,CNT_ID						    NUMBER(16) NOT NULL
			   ,ATP_NUMERO_CONTRATO		        NUMBER(16)  NOT NULL
			   ,ATP_NUMERO_SPEC  	  	  		NUMBER(16) NOT NULL 
			   ,ATP_CODIGO_ATIPICO		 		NUMBER(21) NOT NULL
			   ,ATP_IMPORTE_ATIPICO   	 		NUMBER(16,2) NOT NULL
			   ,DD_TAT_ID			      		NUMBER(16) NOT NULL
			   ,DD_MAT_ID			           	NUMBER(16)
    		   ,ATP_FECHA_VALOR				    TIMESTAMP(6) NOT NULL
			   ,ATP_FECHA_MOVIMIENTO		    TIMESTAMP(6) NOT NULL
               ,ATP_CHAR_EXTRA1                 VARCHAR2(50 CHAR)
               ,ATP_CHAR_EXTRA2                 VARCHAR2(50 CHAR)
			   ,ATP_FLAG_EXTRA1     	  		VARCHAR2(1 CHAR)
			   ,ATP_FLAG_EXTRA2     	  		VARCHAR2(1 CHAR)
			   ,ATP_DATE_EXTRA1					TIMESTAMP(6)
			   ,ATP_DATE_EXTRA2					TIMESTAMP(6)
			   ,ATP_NUM_EXTRA1		 	  		NUMBER(16)
			   ,ATP_NUM_EXTRA2		 	  		NUMBER(16)
			   ,SYS_GUID						VARCHAR2(36 CHAR)
			   ,VERSION                   		INTEGER             DEFAULT 0  NOT NULL
			   ,USUARIOCREAR              		VARCHAR2(10 CHAR)   NOT NULL
			   ,FECHACREAR                		TIMESTAMP(6)        NOT NULL
			   ,USUARIOMODIFICAR          		VARCHAR2(10 CHAR)
			   ,FECHAMODIFICAR            		TIMESTAMP(6)
			   ,USUARIOBORRAR             		VARCHAR2(10 CHAR)
			   ,FECHABORRAR               		TIMESTAMP(6)
			   ,BORRADO                   		NUMBER(1)           DEFAULT 0  NOT NULL
			   ,CONSTRAINT PK_ATP_ATIPICOS_CNT PRIMARY KEY (ATP_ID)
			   ,CONSTRAINT FK_ATP_CNT_ID FOREIGN KEY (CNT_ID) REFERENCES CNT_CONTRATOS (CNT_ID)
			   ,CONSTRAINT FK_ATP_DD_TPE FOREIGN KEY (DD_TPE_ID) REFERENCES DD_TPE_TIPO_PROD_ENTIDAD (DD_TPE_ID)
			   ,CONSTRAINT FK_ATP_DD_TAT FOREIGN KEY (DD_TAT_ID) REFERENCES DD_TAT_TIPO_ATIPICO (DD_TAT_ID)
			   ,CONSTRAINT FK_ATP_DD_MAT FOREIGN KEY (DD_MAT_ID) REFERENCES DD_MAT_MOTIVO_ATIPICO (DD_MAT_ID)
               )';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ATP_ATIPICOS_CNT... Tabla creada');
    		
    		execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_ATP_ATIPICOS_CNT  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ATP_ATIPICOS_CNT... Secuencia creada correctamente.');
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

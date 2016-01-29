--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=28-09-2015
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-76
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla AEE_ACTUACION_EXPLORAR_EXP
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
	    
	 -- Creacion Tabla AEE_ACTUACION_EXPLORAR_EXP
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''AEE_ACTUACION_EXPLORAR_EXP'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.AEE_ACTUACION_EXPLORAR_EXP... La tabla YA EXISTE');
    ELSE
    		  --Creamos la tabla
    		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.AEE_ACTUACION_EXPLORAR_EXP
               (AEE_ID				  			NUMBER(16)		  NOT NULL ENABLE
			   ,EXP_ID  		  		        NUMBER(16) 		  NOT NULL ENABLE
			   ,DD_SSA_ID  	  					NUMBER(16) 
			   ,DD_VAA_ID 						NUMBER(16)
			   ,AEE_OBSERVACIONES 		  		VARCHAR2(2000 CHAR)
			   ,SYS_GUID						VARCHAR2(36 CHAR)
			   ,VERSION                   		INTEGER             DEFAULT 0  NOT NULL
			   ,USUARIOCREAR              		VARCHAR2(10 CHAR)   NOT NULL
			   ,FECHACREAR                		TIMESTAMP(6)        NOT NULL
			   ,USUARIOMODIFICAR          		VARCHAR2(10 CHAR)
			   ,FECHAMODIFICAR            		TIMESTAMP(6)
			   ,USUARIOBORRAR             		VARCHAR2(10 CHAR)
			   ,FECHABORRAR               		TIMESTAMP(6)
			   ,BORRADO                   		NUMBER(1)           DEFAULT 0  NOT NULL
			   ,CONSTRAINT PK_AEE_ACTUACIO_EXPLOR_EXP PRIMARY KEY (AEE_ID)
			   ,CONSTRAINT FK_AEE_ACTUACIO_EXP FOREIGN KEY (EXP_ID) REFERENCES EXP_EXPEDIENTES (EXP_ID)
			   ,CONSTRAINT FK_AEE_ACTUACIO_DD_VAA FOREIGN KEY (DD_VAA_ID) REFERENCES DD_VAA_VALORA_ACTU_AMIST (DD_VAA_ID)
               ,CONSTRAINT FK_AEE_ACTUACIO_DD_SSA FOREIGN KEY (DD_SSA_ID) REFERENCES DD_SSA_SUBTI_SOLUC_AMIST (DD_SSA_ID)
               )';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_PRC_PROCEDIMIENTOS... Tabla creada');
    		
    		execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_AEE_ACTUACION_EXPLORAR_EXP  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_AEE_ACTUACION_EXPLORAR_EXP... Secuencia creada correctamente.');
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

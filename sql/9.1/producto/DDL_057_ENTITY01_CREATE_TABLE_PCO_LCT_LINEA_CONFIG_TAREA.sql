--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20150828
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-130
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla PCO_LCT_LINEA_CONFIG_TAREA
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

    -- ******** PCO_LCT_LINEA_CONFIG_TAREA *******
    DBMS_OUTPUT.PUT_LINE('******** PCO_LCT_LINEA_CONFIG_TAREA ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA... Comprobaciones previas'); 
    
    -- Creacion Tabla PCO_LCT_LINEA_CONFIG_TAREA
    
    -- Comprobamos si existe la tabla   						   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PCO_LCT_LINEA_CONFIG_TAREA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA
               (
				PCO_LCT_ID NUMBER(16,0) NOT NULL ENABLE, 
				PCO_LCT_CODIGO_TAREA VARCHAR2(50 CHAR) NOT NULL ENABLE, 
				PCO_LCT_CODIGO_ACCION VARCHAR2(50 CHAR) NOT NULL ENABLE, 
				PCO_LCT_HQL VARCHAR2(4000 CHAR), 
				VERSION NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
				USUARIOCREAR VARCHAR2(10 CHAR) NOT NULL ENABLE, 
				FECHACREAR TIMESTAMP (6) NOT NULL ENABLE, 
				USUARIOMODIFICAR VARCHAR2(10 CHAR), 
				FECHAMODIFICAR TIMESTAMP (6), 
				USUARIOBORRAR VARCHAR2(10 CHAR), 
				FECHABORRAR TIMESTAMP (6), 
				BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,	
				CONSTRAINT PK_PCO_LCT PRIMARY KEY (PCO_LCT_ID),
			    CONSTRAINT UNIQUE_PCO_LCT_CODIGOS UNIQUE (PCO_LCT_CODIGO_TAREA,PCO_LCT_CODIGO_ACCION)	
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_LCT_LINEA_CONFIG_TAREA... Tabla creada');
											        
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_PCO_LCT_LINEA_CONFIG_TAREA  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_PCO_LCT_LINEA_CONFIG_TAREA... Secuencia creada correctamente.');
  		
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

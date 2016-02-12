--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20160202
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-75
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla ETG_ENTIDAD_TIPO_GESTOR
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

    -- ******** ETG_ENTIDAD_TIPO_GESTOR *******
    DBMS_OUTPUT.PUT_LINE('******** ETG_ENTIDAD_TIPO_GESTOR ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.ETG_ENTIDAD_TIPO_GESTOR... Comprobaciones previas'); 
    
    -- Creacion Tabla ETG_ENTIDAD_TIPO_GESTOR
    
    -- Comprobamos si existe la tabla   						   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ETG_ENTIDAD_TIPO_GESTOR'' and owner = '''||V_ESQUEMA_M||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.ETG_ENTIDAD_TIPO_GESTOR... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA_M||'.ETG_ENTIDAD_TIPO_GESTOR
               (
				DD_TGE_ID NUMBER(16,0) NOT NULL ENABLE, 
				ENTIDAD_ID NUMBER(16,0) NOT NULL ENABLE,
				CONSTRAINT "UK_ETG_ENTIDAD_TIPO_GESTOR" UNIQUE ("DD_TGE_ID", "ENTIDAD_ID")
                USING INDEX TABLESPACE '||V_TS_INDEX||' ENABLE	
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.ETG_ENTIDAD_TIPO_GESTOR... Tabla creada');
  		
		V_MSQL := 'CREATE INDEX ' || V_ESQUEMA_M || '.IDX1_ETG_ENTIDAD_TIPO_GESTOR ON ' || V_ESQUEMA_M || '.ETG_ENTIDAD_TIPO_GESTOR (ENTIDAD_ID) ' ||
		'  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 ' ||
  		'  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE ' || V_TS_INDEX;
  		EXECUTE IMMEDIATE V_MSQL;
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ETG_ENTIDAD_TIPO_GESTOR... Indice creado');
  		
  		V_MSQL := 'CREATE INDEX ' || V_ESQUEMA_M || '.IDX2_ETG_ENTIDAD_TIPO_GESTOR ON ' || V_ESQUEMA_M || '.ETG_ENTIDAD_TIPO_GESTOR (DD_TGE_ID) ' ||
		'  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 ' ||
  		'  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE ' || V_TS_INDEX;
  		EXECUTE IMMEDIATE V_MSQL;
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ETG_ENTIDAD_TIPO_GESTOR... Indice creado');
  		
  		V_MSQL := 'ALTER TABLE ' || V_ESQUEMA_M || '.ETG_ENTIDAD_TIPO_GESTOR ADD CONSTRAINT FK1_ETG_ENTIDAD_TIPO_GESTOR FOREIGN KEY (ENTIDAD_ID) ' ||
		'  REFERENCES  ' || V_ESQUEMA_M || '.ENTIDAD (ID)';
  		EXECUTE IMMEDIATE V_MSQL;
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ETG_ENTIDAD_TIPO_GESTOR... FK1 creada');
  		
  		V_MSQL := 'ALTER TABLE ' || V_ESQUEMA_M || '.ETG_ENTIDAD_TIPO_GESTOR ADD CONSTRAINT FK2_ETG_ENTIDAD_TIPO_GESTOR FOREIGN KEY (DD_TGE_ID) ' ||
		'  REFERENCES  ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR (DD_TGE_ID)';
  		EXECUTE IMMEDIATE V_MSQL;
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ETG_ENTIDAD_TIPO_GESTOR... FK2 creada');
  		
  		
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

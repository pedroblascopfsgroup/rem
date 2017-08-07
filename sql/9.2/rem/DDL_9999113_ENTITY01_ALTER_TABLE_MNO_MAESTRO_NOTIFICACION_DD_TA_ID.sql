--/*
--##########################################
--## AUTOR=JOSE MANUEL PÉREZ BARBERÁ
--## FECHA_CREACION=20160104
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.15
--## INCIDENCIA_LINK=RECOVERY-4298
--## PRODUCTO=SI
--##
--## Finalidad: DDL Añadir la columna DD_TA_ID a la tabla MNO_MAESTRO_NOTIFICACIONES
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
	
		    	 -- ******** MNO_MAESTRO_NOTIFICACIONES - Añadir campos *******
	 
    DBMS_OUTPUT.PUT_LINE('******** MNO_MAESTRO_NOTIFICACIONES - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''MNO_MAESTRO_NOTIFICACIONES'' and owner = '''||V_ESQUEMA||''' and column_name = ''DD_TA_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS >= 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MNO_MAESTRO_NOTIFICACIONES... el campo DD_TA_ID ya existe en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.MNO_MAESTRO_NOTIFICACIONES ADD(DD_TA_ID NUMBER(16,0))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MNO_MAESTRO_NOTIFICACIONES... Añadidos el campo DD_TA_ID');
        
        ----Creamos la FK
       	V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''MNO_MAESTRO_NOTIFICACIONES'' and owner = '''||V_ESQUEMA||''' and (CONSTRAINT_NAME = ''FK_TIPO_ANOTACION_DD_TA_ID'')';
	    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	    -- Si existe la PK
	    IF V_NUM_TABLAS >= 1 THEN
	    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ASU_ASUNTOS ... FK ya existen');
	    ELSE
		    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.MNO_MAESTRO_NOTIFICACIONES  ADD (
				CONSTRAINT FK_TIPO_ANOTACION_DD_TA_ID FOREIGN KEY (DD_TA_ID) 
					 REFERENCES ' || V_ESQUEMA || '.DD_TA_TIPO_ANOTACION (DD_TA_ID))';
			EXECUTE IMMEDIATE V_MSQL;     
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MNO_MAESTRO_NOTIFICACIONES ... FK Creada');
			
			execute immediate 'COMMENT ON COLUMN '||V_ESQUEMA||'.MNO_MAESTRO_NOTIFICACIONES.DD_TA_ID IS ''Tipo de anotación.''';
		
		END IF;
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

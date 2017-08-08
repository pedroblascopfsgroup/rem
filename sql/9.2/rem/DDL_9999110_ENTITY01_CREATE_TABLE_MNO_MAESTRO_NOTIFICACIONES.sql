--/*
--##########################################
--## AUTOR=DANIEL ALBERT PÉREZ
--## FECHA_CREACION=20161207
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2.14
--## INCIDENCIA_LINK=RECOVERY-4059
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla MNO_MAESTRO_NOTIFICACIONES
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

    BEGIN

    -- ******** DD_DES_DECISION_SANCION *******
    DBMS_OUTPUT.PUT_LINE('******** MNO_MAESTRO_NOTIFICACIONES ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MNO_MAESTRO_NOTIFICACIONES... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_PCO_LIQ_ESTADO
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MNO_MAESTRO_NOTIFICACIONES'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MNO_MAESTRO_NOTIFICACIONES... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MNO_MAESTRO_NOTIFICACIONES
               ( MNO_ID NUMBER(16,0) NOT NULL ENABLE
				  , DD_EIN_ID NUMBER(16,0) NOT NULL ENABLE
				  , DD_TNO_ID NUMBER (16,0) NOT NULL ENABLE
				  , EIN_ID NUMBER(16,0) NOT NULL ENABLE
				  , DD_EST_ID NUMBER(16,0)
				  , DD_STA_ID NUMBER(16,0) NOT NULL ENABLE
				  , TAR_TAREA VARCHAR2(100 CHAR) NOT NULL ENABLE
				  , TAR_DESCRIPCION VARCHAR2(4000 CHAR)
				  , TAR_ID_DEST NUMBER(16,0)
				  , FECHA_NOTIFICACION DATE DEFAULT SYSTIMESTAMP
				  , ENVIADA NUMBER(1,0) DEFAULT 0
				  , FECHA_ENVIO DATE
				  , CONSTRAINT PK_MNO_ID PRIMARY KEY (MNO_ID)
			  )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MNO_MAESTRO_NOTIFICACIONES... Tabla creada');
		
		execute immediate 'COMMENT ON COLUMN '||v_esquema||'.MNO_MAESTRO_NOTIFICACIONES.DD_EIN_ID IS ''Indicar entidad informacional sobre la que se va a generar la notificación (Expediente, Asuntos, Personas, etc).''';
		execute immediate 'COMMENT ON COLUMN '||v_esquema||'.MNO_MAESTRO_NOTIFICACIONES.DD_TNO_ID IS ''Indicar el tipo de notificación haciendo referencia al ID de la tabla DD_TNO_TIPO_NOTIFICACION''';
		execute immediate 'COMMENT ON COLUMN '||v_esquema||'.MNO_MAESTRO_NOTIFICACIONES.EIN_ID IS ''Indicar el ID de la entidad informacional sobre la que se va a generar la notificación (Expediente, Asuntos, Personas, etc).''';
		execute immediate 'COMMENT ON COLUMN '||v_esquema||'.MNO_MAESTRO_NOTIFICACIONES.DD_EST_ID IS ''Para Expedientes es necesario indicar este campo si se requiere para la notificación, para Asuntos se autogenera en el proceso de generación de notificaciones.''';
		execute immediate 'COMMENT ON COLUMN '||v_esquema||'.MNO_MAESTRO_NOTIFICACIONES.DD_STA_ID IS ''Indicar si se trata de una Anotación u otro tipo.''';
		execute immediate 'COMMENT ON COLUMN '||v_esquema||'.MNO_MAESTRO_NOTIFICACIONES.TAR_TAREA IS ''Título de la notificación.''';
		execute immediate 'COMMENT ON COLUMN '||v_esquema||'.MNO_MAESTRO_NOTIFICACIONES.TAR_DESCRIPCION IS ''Descripción de la notificación en caso de tipo Expediente. Y valor en tabla MEJ para visualizar la descripción en notificación sobre Asunto''';
		execute immediate 'COMMENT ON COLUMN '||v_esquema||'.MNO_MAESTRO_NOTIFICACIONES.TAR_ID_DEST IS ''Destinatario de la notificación.''';
		execute immediate 'COMMENT ON COLUMN '||v_esquema||'.MNO_MAESTRO_NOTIFICACIONES.FECHA_NOTIFICACION IS ''Fecha de creación de la notificación.''';
		execute immediate 'COMMENT ON COLUMN '||v_esquema||'.MNO_MAESTRO_NOTIFICACIONES.ENVIADA IS ''Flag de envío de la notificación. 1 si está enviada a su destinatario.''';
		execute immediate 'COMMENT ON COLUMN '||v_esquema||'.MNO_MAESTRO_NOTIFICACIONES.FECHA_ENVIO IS ''Fecha en la que se generó la notificación.''';
		
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_MNO_MAESTRO_NOTIFICACIONES  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_MNO_MAESTRO_NOTIFICACIONES... Secuencia creada correctamente.');
		
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

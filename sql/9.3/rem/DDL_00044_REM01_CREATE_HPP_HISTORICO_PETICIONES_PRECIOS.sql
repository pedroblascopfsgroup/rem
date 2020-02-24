--/*
--##########################################
--## AUTOR=Joaquin Bahamonde
--## FECHA_CREACION=20200224
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9486
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla HPP_HISTORICO_PETICIONES_PRECIOS
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_TABLA VARCHAR2(150 CHAR):= 'HPP_HISTORICO_PETICIONES_PRECIOS'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** HPP_HISTORICO_PETICIONES_PRECIOS *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla HPP_HISTORICO_PETICIONES_PRECIOS
    
    -- Comprobamos si existe la tabla   
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    -- Si no existe la tabla se crea
    IF V_NUM_TABLAS = 0 THEN        
        --Creamos la tabla
        DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TABLA||']');
            V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
                     HPP_ID                      NUMBER(16,0)                GENERATED BY DEFAULT AS IDENTITY
                    ,DD_TPP_ID              	 NUMBER(16,0)		         NOT NULL
                    ,HPP_FECHA_SOLICITUD         DATE
                    ,HPP_FECHA_SANCION           DATE
                    ,HPP_OBSEVACIONES            VARCHAR2(1024 CHAR)
                    ,VERSION                     NUMBER(1,0)                 DEFAULT 0
                    ,USUARIOCREAR                VARCHAR2(50 CHAR) 
                    ,FECHACREAR                  TIMESTAMP(6)                DEFAULT SYSTIMESTAMP
                    ,USUARIOMODIFICAR            VARCHAR2(50 CHAR) 
                    ,FECHAMODIFICAR              TIMESTAMP(6)
                    ,USUARIOBORRAR               VARCHAR2(50 CHAR)
                    ,FECHABORRAR                 TIMESTAMP(6)
                    ,BORRADO                     NUMBER(1,0)                 DEFAULT 0
                    ,CONSTRAINT PK_HPP_ID        PRIMARY KEY (HPP_ID)
                    ,CONSTRAINT FK_HPP_DD_TPP_ID FOREIGN KEY (DD_TPP_ID)     REFERENCES DD_TPP_TIPO_PETICION_PRECIO (DD_TPP_ID)
                    )';        	

            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
                    
        EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.'||V_TABLA||' IS ''Tabla para los históricos de peticiones de precios.''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.HPP_ID IS ''ID único del registro de la tabla''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_TPP_ID IS ''ID único del Tipo de peticion de precio''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.HPP_FECHA_SOLICITUD IS ''Fecha de solicitud del histórico de peticiones de precios''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.HPP_FECHA_SANCION IS ''Fecha de sanción del histórico de peticiones de precios''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.VERSION IS ''Indica la versión del registro''';  
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BORRADO IS ''Indicador de borrado''';
    
        DBMS_OUTPUT.PUT_LINE('Creados los comentarios en TABLA '|| V_ESQUEMA ||'.'||V_TABLA||'... OK');
    
        
    ELSE
        --Si existe la tabla no se hace nada
        DBMS_OUTPUT.PUT_LINE('[INFO] La Tabla' || V_ESQUEMA || '.'||V_TABLA||'... ya existe');
    END IF;
COMMIT;
DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
    
    
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;

--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20150514
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.10.13
--## INCIDENCIA_LINK=BCFI-614
--## PRODUCTO=SI
--## Finalidad: DDL
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN

    -- ******** DD_TCN_TIPO_CNAE *******
    DBMS_OUTPUT.PUT_LINE('******** DD_TCN_TIPO_CNAE ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_TCN_TIPO_CNAE... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_TCN_TIPO_CNAE'' and owner = '''||V_ESQUEMA_M||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN    
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA_M||'.DD_TCN_TIPO_CNAE
                  DROP PRIMARY KEY CASCADE';        
            EXECUTE IMMEDIATE V_MSQL;  
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_TCN_TIPO_CNAE... Claves primarias eliminadas');    
    END IF;
        -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_TCN_TIPO_CNAE'' and owner = '''||V_ESQUEMA_M||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP TABLE '||V_ESQUEMA_M||'.DD_TCN_TIPO_CNAE CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_TCN_TIPO_CNAE... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
        V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_TCN_TIPO_CNAE'' and sequence_owner = '''||V_ESQUEMA_M||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
        if V_NUM_TABLAS = 1 THEN            
            V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA_M||'.S_DD_TCN_TIPO_CNAE';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.S_DD_TCN_TIPO_CNAE... Secuencia eliminada');    
        END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TCN_TIPO_CNAE... Comprobaciones previas FIN'); 
    
    --Creamos la tabla y secuencias
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.S_DD_TCN_TIPO_CNAE...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA_M || '.S_DD_TCN_TIPO_CNAE';
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.S_DD_TCN_TIPO_CNAE... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA_M || '.DD_TCN_TIPO_CNAE
                    (
                      DD_TCN_ID                 NUMBER(16)          NOT NULL,
                      DD_TCN_CODIGO             VARCHAR2(10 CHAR)   NOT NULL,
                      DD_TCN_DESCRIPCION        VARCHAR2(50 CHAR)   NOT NULL,
                      DD_TCN_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  NOT NULL,
                      VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
                      USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
                      FECHACREAR                TIMESTAMP(6)        NOT NULL,
                      USUARIOMODIFICAR          VARCHAR2(10 CHAR),
                      FECHAMODIFICAR            TIMESTAMP(6),
                      USUARIOBORRAR             VARCHAR2(10 CHAR),
                      FECHABORRAR               TIMESTAMP(6),
                      BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
                    )';
    EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TCN_TIPO_CNAE... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA_M || '.PK_DD_TCN_TIPO_CNAE ON ' || V_ESQUEMA_M || '.DD_TCN_TIPO_CNAE
                    (DD_TCN_ID)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.PK_DD_TCN_TIPO_CNAE... Indice creado');
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA_M || '.DD_TCN_TIPO_CNAE ADD (
          CONSTRAINT PK_DD_TCN_TIPO_CNAE PRIMARY KEY (DD_TCN_ID),
          CONSTRAINT UK_DD_TCN_CODIGO UNIQUE (DD_TCN_CODIGO))';
        EXECUTE IMMEDIATE V_MSQL;              
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.PK_DD_TCN_TIPO_CNAE... PK creada');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TCN_TIPO_CNAE... OK');
    
    -- Damos permisos de lectura
    EXECUTE IMMEDIATE 'GRANT SELECT ON '||V_ESQUEMA_M||'.DD_TCN_TIPO_CNAE TO BANK01, MINIREC, RECOVERY_BANKIA_DWH, RECOVERY_BANKIA_DATASTAGE';
    
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
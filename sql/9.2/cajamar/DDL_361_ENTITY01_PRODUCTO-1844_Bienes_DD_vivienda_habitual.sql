--/*
--##########################################
--## AUTOR=JTD
--## FECHA_CREACION=20160602
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=PRODUCTO-1844
--## PRODUCTO=SI
--## Finalidad: DDL Crea nuevo diccionario
--##            Crear nuevo atributo en la tabla bie_bienes 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX     VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN

    -- ******** DD_DVI_DESTINO_VIVIENDA *******
    DBMS_OUTPUT.PUT_LINE('******** DD_DVI_DESTINO_VIVIENDA ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DVI_DESTINO_VIVIENDA... Comprobaciones previas'); 
    
	--Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_DVI_DESTINO_VIVIENDA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
	-- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN    
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_DVI_DESTINO_VIVIENDA DROP PRIMARY KEY CASCADE';        
      EXECUTE IMMEDIATE V_MSQL;  
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DVI_DESTINO_VIVIENDA... Claves primarias eliminadas');    
    END IF;
    
	-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_DVI_DESTINO_VIVIENDA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
       V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_DVI_DESTINO_VIVIENDA CASCADE CONSTRAINTS';
       EXECUTE IMMEDIATE V_MSQL;
       DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DVI_DESTINO_VIVIENDA... Tabla borrada');  
    END IF;
    
	-- Comprobamos si existe la secuencia
    V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_DVI_DESTINO_VIVIENDA'' and sequence_owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
    if V_NUM_TABLAS = 1 THEN            
       V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_DVI_DESTINO_VIVIENDA';
       EXECUTE IMMEDIATE V_MSQL;
       DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_DVI_DESTINO_VIVIENDA... Secuencia eliminada');    
    END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DVI_DESTINO_VIVIENDA... Comprobaciones previas FIN'); 
    
    --Creamos la tabla y secuencias
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_DVI_DESTINO_VIVIENDA...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_DVI_DESTINO_VIVIENDA';
    EXECUTE IMMEDIATE V_MSQL; 
    
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_DVI_DESTINO_VIVIENDA... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_DVI_DESTINO_VIVIENDA
                    (
                      DD_DVI_ID                 NUMBER(16)          NOT NULL,
                      DD_DVI_CODIGO             VARCHAR2(10 CHAR)   NOT NULL,
                      DD_DVI_DESCRIPCION        VARCHAR2(50 CHAR)   NOT NULL,
                      DD_DVI_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  NOT NULL,
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
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DVI_DESTINO_VIVIENDA... Tabla creada');
    
	V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_DVI_DESTINO_VIVIENDA ON ' || V_ESQUEMA || '.DD_DVI_DESTINO_VIVIENDA (DD_DVI_ID)  TABLESPACE ' || V_TS_INDEX;
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_DVI_DESTINO_VIVIENDA... Indice creado');
    
	V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_DVI_DESTINO_VIVIENDA ADD (
          CONSTRAINT PK_DD_DVI_DESTINO_VIVIENDA PRIMARY KEY (DD_DVI_ID),
         CONSTRAINT UK_DD_DVI_CODIGO UNIQUE (DD_DVI_CODIGO))';
    EXECUTE IMMEDIATE V_MSQL;              
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_DVI_DESTINO_VIVIENDA... PK creada');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DD_DVI_DESTINO_VIVIENDA... OK');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Pendiente ejecutar GRANTS.');
    DBMS_OUTPUT.PUT_LINE('[INFO] Fin script.');

    -- BIE_BIEN ADD COLUMN DD_DVI_ID
	DBMS_OUTPUT.PUT_LINE('******** [INICIO] De la modificación de la tabla BIE_BIEN ********');
	
	V_SQL := 'SELECT count(*) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''BIE_BIEN'' AND COLUMN_NAME = ''DD_DVI_ID'' and OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    DBMS_OUTPUT.PUT_LINE('[INFO] Buscando la columna DD_DVI_ID en la tabla BIE_BIEN');
    IF V_NUM_TABLAS = 0 THEN 
		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN ADD DD_DVI_ID NUMBER(16)'; 
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Columna DD_DVI_ID añadida correctamente');
	 ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] La columna ya existe');
    END IF;	

	-- BIE_BIEN ADD FK FK_BIE_BIEN_FK_DD_DVI
    DBMS_OUTPUT.PUT_LINE('[INFO] Empezamos creacion FK_BIE_BIEN_FK_DD_DVI');
  
    V_SQL := 'Select count(*) from user_constraints WHERE CONSTRAINT_NAME = ''FK_BIE_BIEN_FK_DD_DVI'' AND TABLE_NAME = ''BIE_BIEN'' and OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    DBMS_OUTPUT.PUT_LINE('[INFO] Buscando FK FK_BIE_BIEN_FK_DD_DVI en BIE_BIEN');
    IF V_NUM_TABLAS = 0 THEN
       execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_BIEN ADD CONSTRAINT FK_BIE_BIEN_FK_DD_DVI FOREIGN KEY (DD_DVI_ID) REFERENCES ' || V_ESQUEMA || '.DD_DVI_DESTINO_VIVIENDA (DD_DVI_ID) ENABLE';
       DBMS_OUTPUT.PUT_LINE('[FIN] Se ha creado la FK FK_BIE_BIEN_FK_DD_DVI');
    ELSE
       DBMS_OUTPUT.PUT_LINE('[FIN] La foreign key ya existe');
    END IF;
  
    COMMIT;

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
    

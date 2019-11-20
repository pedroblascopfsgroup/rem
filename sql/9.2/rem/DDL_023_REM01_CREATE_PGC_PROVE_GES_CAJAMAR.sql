--/*
--##########################################
--## AUTOR=José Antonio Gigante
--## FECHA_CREACION=20190805
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=func-rem-gestObjCajamar
--## INCIDENCIA_LINK=HREOS-7298
--## PRODUCTO=NO
--##
--## Finalidad: Creación de tabla para mapear oficinas con gestores
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-7298'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'PGC_PROVE_GES_CAJAMAR'; -- Tabla 
        
BEGIN
	  DBMS_OUTPUT.PUT_LINE('******** '||V_TEXT_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
		  DBMS_OUTPUT.PUT_LINE(V_TEXT_TABLA||'... Tabla YA EXISTE');    
    ELSE
      V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
              ( PGC_ID NUMBER(16,0) NOT NULL,
                PVE_ID NUMBER(16,0) NOT NULL,
                USU_ID NUMBER(16,0) NOT NULL,
                VERSION NUMBER(38,0) DEFAULT 0, 
				  	    USUARIOCREAR VARCHAR2 (50 CHAR) NOT NULL, 
				  	    FECHACREAR TIMESTAMP(6) NOT NULL, 
				  	    USUARIOMODIFICAR VARCHAR2 (50 CHAR), 
				  	    FECHAMODIFICAR TIMESTAMP(6), 
				  	    USUARIOBORRAR VARCHAR2 (50 CHAR), 
				  	    FECHABORRAR TIMESTAMP(6), 
				  	    BORRADO NUMBER(1,0) DEFAULT 0
              )';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||' ... Tabla creada');
    
      -- Buscando si la secuencia existe
      V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and sequence_owner = '''||V_ESQUEMA||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
        DBMS_OUTPUT.PUT_LINE('Secuencia YA EXISTE');
      ELSE
        -- Primero se crea la secuencia
        V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';	
        DBMS_OUTPUT.PUT_LINE('[INFO] Creando: '|| V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Secuencia creada correctamente.');
      END IF;
      -- Primary key
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (PGC_ID))';
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'_PK ... Primary key creada correctamente.');
      EXECUTE IMMEDIATE V_MSQL;
      -- FK ID_ACT_PVE_PROVEEDOR
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT PVE_'||V_TEXT_TABLA||'_FK FOREIGN KEY (PVE_ID) REFERENCES ACT_PVE_PROVEEDOR (PVE_ID))';
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PVE_'||V_TEXT_TABLA||'_FK ... FOREIGN KEY creada correctamente.');
      EXECUTE IMMEDIATE V_MSQL;
      -- FK ID_USUARIO
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT USU_'||V_TEXT_TABLA||'_FK FOREIGN KEY (USU_ID) REFERENCES '||V_ESQUEMA_M||'.USU_USUARIOS (USU_ID))';
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.USU_'||V_TEXT_TABLA||'_FK ... FOREIGN KEY creada correctamente.');
      EXECUTE IMMEDIATE V_MSQL;
      -- UK compuesta PVE_ID + BORRADO
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT PVE_'||V_TEXT_TABLA||'_UK UNIQUE (PVE_ID, BORRADO))';
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PVE_'||V_TEXT_TABLA||'_UK ... UNIQUE KEY creada correctamente.');
      EXECUTE IMMEDIATE V_MSQL;
      -- Los comentarios aclarando la funcionalidad de las columnas
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PGC_ID IS ''Código identificador del gestor comercial.''';
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PVE_ID IS ''Código identificador del proveedor.''';
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USU_ID IS ''Código identificador del usuaro.''';
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.VERSION IS ''Indica la version del registro.''';
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.BORRADO IS ''Indicador de borrado.''';
      DBMS_OUTPUT.PUT_LINE('[INFO] Fin añadir Comentarios de la columna COMMENTS.');

      -- Autorizando
      V_MSQL := 'grant select, insert, delete, update on '||V_ESQUEMA||'.'||V_TEXT_TABLA||' to '||V_ESQUEMA_M||' ';
      EXECUTE IMMEDIATE V_MSQL;
	    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA ||'... Permisos añadidos');
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
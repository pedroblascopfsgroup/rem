--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150525
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.0.1-rc03-hy
--## INCIDENCIA_LINK=HR-901
--## PRODUCTO=SI
--##
--## Finalidad: Nuevo diccionario para indicar el tipo de documento de adjudicación de un bien
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** DD_DAD_DOC_ADJUDICACION ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_DAD_DOC_ADJUDICACION... Comprobaciones previas'); 

    V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_DAD_DOC_ADJUDICACION'' and owner = '''||V_ESQUEMA_M||''' and CONSTRAINT_TYPE = ''P''';

    EXECUTE IMMEDIATE V_MSQL INTO table_count;

    -- Si existe la PK
    IF table_count = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA_M||'.DD_DAD_DOC_ADJUDICACION 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_DAD_DOC_ADJUDICACION... Claves primarias eliminadas');	
    END IF;
		
    -- Comprobamos si existe la tabla   
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_DAD_DOC_ADJUDICACION'' and owner = '''||V_ESQUEMA_M||'''';

    EXECUTE IMMEDIATE V_MSQL INTO table_count;

    -- Si existe la borramos
    IF table_count = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA_M||'.DD_DAD_DOC_ADJUDICACION CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_DAD_DOC_ADJUDICACION... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_DAD_DOC_ADJUDICACION'' and sequence_owner = '''||V_ESQUEMA_M||'''';
		EXECUTE IMMEDIATE V_MSQL INTO table_count; 
		if table_count = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA_M||'.S_DD_DAD_DOC_ADJUDICACION';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.S_DD_DAD_DOC_ADJUDICACION... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_DAD_DOC_ADJUDICACION... Comprobaciones previas FIN'); 


    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_DAD_DOC_ADJUDICACION...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA_M || '.S_DD_DAD_DOC_ADJUDICACION';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.S_DD_DAD_DOC_ADJUDICACION... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA_M || '.DD_DAD_DOC_ADJUDICACION
					(
            DD_DAD_ID NUMBER(16,0) NOT NULL ENABLE, 
            DD_DAD_CODIGO VARCHAR2(20 CHAR) NOT NULL ENABLE, 
            DD_DAD_DESCRIPCION VARCHAR2(50 CHAR), 
            DD_DAD_DESCRIPCION_LARGA VARCHAR2(250 CHAR), 
            VERSION NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
            USUARIOCREAR VARCHAR2(10 CHAR) NOT NULL ENABLE, 
            FECHACREAR TIMESTAMP (6) NOT NULL ENABLE, 
            USUARIOMODIFICAR VARCHAR2(10 CHAR), 
            FECHAMODIFICAR TIMESTAMP (6), 
            USUARIOBORRAR VARCHAR2(10 CHAR), 
            FECHABORRAR TIMESTAMP (6), 
            BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
					)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_DAD_DOC_ADJUDICACION... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA_M || '.UK_DD_DAD_DOC_ADJUDICACION ON ' || V_ESQUEMA_M || '.DD_DAD_DOC_ADJUDICACION
					(DD_DAD_CODIGO)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.UK_DD_DAD_DOC_ADJUDICACION... Indice creado');
    
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA_M || '.PK_DD_DAD_DOC_ADJUDICACION ON ' || V_ESQUEMA_M || '.DD_DAD_DOC_ADJUDICACION
					(DD_DAD_ID)';
		EXECUTE IMMEDIATE V_MSQL;
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA_M || '.DD_DAD_DOC_ADJUDICACION ADD (
                CONSTRAINT PK_DD_DAD_DOC_ADJUDICACION PRIMARY KEY (DD_DAD_ID),
                CONSTRAINT UK_DD_DAD_DOC_ADJUDICACION UNIQUE (DD_DAD_CODIGO)
                )';						
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.PK_DD_DAD_DOC_ADJUDICACION... Creando PK');	
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_DAD_DOC_ADJUDICACION... OK');
    
    V_MSQL := 'GRANT ALL ON ' || V_ESQUEMA_M || '.DD_DAD_DOC_ADJUDICACION TO ' || V_ESQUEMA;						
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_DAD_DOC_ADJUDICACION... Añadido GRANT');	
    
    COMMIT;
 
EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;
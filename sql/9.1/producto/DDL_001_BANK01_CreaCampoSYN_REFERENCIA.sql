--/*
--##########################################
--## AUTOR=G ESTELLES
--## FECHA_CREACION=20150603
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=-
--## PRODUCTO=SI
--##
--## Finalidad: Crear campos de enlace de sincronización para conectividad entre recovery
--## INSTRUCCIONES: Relanzable.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
   
BEGIN	

    VAR_TABLENAME := 'PRC_PROCEDIMIENTOS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''SYS_GUID'' AND TABLE_NAME=''' || VAR_TABLENAME || ''' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si NO existe la COLUMNA la crea
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || VAR_TABLENAME || ' ADD (SYS_GUID VARCHAR(36 CHAR) NULL)';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campo ' || VAR_TABLENAME || '.SYS_GUID creado');	
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_PRC_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_PRC_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_PRC_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';
    
    VAR_TABLENAME := 'ASU_ASUNTOS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''SYS_GUID'' AND TABLE_NAME=''' || VAR_TABLENAME || ''' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si NO existe la COLUMNA la crea
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || VAR_TABLENAME || ' ADD (SYS_GUID VARCHAR(36 CHAR) NULL)';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campo ' || VAR_TABLENAME || '.SYS_GUID creado');	
    END IF;

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_ASU_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_ASU_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_ASU_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';
    
    VAR_TABLENAME := 'TAR_TAREAS_NOTIFICACIONES';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''SYS_GUID'' AND TABLE_NAME=''' || VAR_TABLENAME || ''' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si NO existe la COLUMNA la crea
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || VAR_TABLENAME || ' ADD (SYS_GUID VARCHAR(36 CHAR) NULL)';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campo ' || VAR_TABLENAME || '.SYS_GUID creado');	
    END IF;

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_TAR_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_TAR_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_TAR_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

    VAR_TABLENAME := 'RCR_RECURSOS_PROCEDIMIENTOS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''SYS_GUID'' AND TABLE_NAME=''' || VAR_TABLENAME || ''' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si NO existe la COLUMNA la crea
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || VAR_TABLENAME || ' ADD (SYS_GUID VARCHAR(36 CHAR) NULL)';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campo ' || VAR_TABLENAME || '.SYS_GUID creado');	
    END IF;

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_RCR_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_RCR_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_RCR_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

    VAR_TABLENAME := 'ACU_ACUERDO_PROCEDIMIENTOS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''SYS_GUID'' AND TABLE_NAME=''' || VAR_TABLENAME || ''' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si NO existe la COLUMNA la crea
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || VAR_TABLENAME || ' ADD (SYS_GUID VARCHAR(36 CHAR) NULL)';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campo ' || VAR_TABLENAME || '.SYS_GUID creado');	
    END IF;

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_ACU_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_ACU_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_ACU_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';
	
/*
ALTER TABLE PRC_PROCEDIMIENTOS DROP (PRC_REF_INTEGRA);
ALTER TABLE ASU_ASUNTOS DROP (ASU_REF_INTEGRA);
ALTER TABLE TAR_TAREAS_NOTIFICACIONES DROP (TAR_REF_INTEGRA);
 */    
/*
SET SERVEROUTPUT ON; 
DECLARE
  guid varchar(36 CHAR);
BEGIN
  SELECT SYS_GUID() INTO guid FROM DUAL ;
  guid :=
        SUBSTR(guid,  1, 8) ||
        '-' || SUBSTR(guid,  9, 4) ||
        '-' || SUBSTR(guid, 13, 4) ||
        '-' || SUBSTR(guid, 17, 4) ||
        '-' || SUBSTR(guid, 21);

  dbms_output.put_line(guid);
  update prc_procedimientos set prc_ref_integra=guid where prc_id=495210;
END;
*/    
    
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
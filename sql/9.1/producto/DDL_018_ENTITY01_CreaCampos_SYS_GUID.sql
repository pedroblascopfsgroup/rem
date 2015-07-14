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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
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
    VAR_TABLENAME := 'BIE_BIEN';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_BIE_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_BIE_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_BIE_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';
*/
	
    VAR_TABLENAME := 'PRB_PRC_BIE';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_PRB_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_PRB_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_PRB_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';
	

    VAR_TABLENAME := 'CEX_CONTRATOS_EXPEDIENTE';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_CEX_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_CEX_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_CEX_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

    VAR_TABLENAME := 'SUB_SUBASTA';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_SUB_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_SUB_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_SUB_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

    VAR_TABLENAME := 'LOS_LOTE_SUBASTA';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_LOS_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_LOS_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_LOS_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

    VAR_TABLENAME := 'EXP_EXPEDIENTES';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_EXP_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_EXP_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_EXP_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

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

	
    VAR_TABLENAME := 'TEA_TERMINOS_ACUERDO';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_TEA_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_TEA_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_TEA_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

	
    VAR_TABLENAME := 'TEA_CNT';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_TEA_CNT_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_TEA_CNT_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_TEA_CNT_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

    VAR_TABLENAME := 'BIE_TEA';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_BIE_TEA_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_BIE_TEA_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_BIE_TEA_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

    VAR_TABLENAME := 'AAR_ACTUACIONES_REALIZADAS';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_AAR_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_AAR_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_AAR_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

    VAR_TABLENAME := 'AEA_ACTUACIO_EXPLOR_ACUERDO';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_AEA_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_AEA_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_AEA_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';
	
-- COV_CONVENIOS
	VAR_TABLENAME := 'COV_CONVENIOS';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_COV_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_COV_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_COV_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

-- COV_CONVENIOS_CREDITOS
	VAR_TABLENAME := 'COV_CONVENIOS_CREDITOS';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_COVCRE_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_COVCRE_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_COVCRE_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';
	
-- CRE_PRC_CEX
	VAR_TABLENAME := 'CRE_PRC_CEX';
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

    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_CRE_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_CRE_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_CRE_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

/*
DECLARE
  CURSOR crs_contratos_expediente
  IS
    SELECT CEX_ID
    FROM CEX_CONTRATOS_EXPEDIENTE
    WHERE sys_guid IS NULL
    ORDER BY cex_id;
  CURSOR crs_asuntos
  IS
    SELECT ASU_ID FROM ASU_ASUNTOS WHERE sys_guid IS NULL ORDER BY asu_id;
  CURSOR crs_expedientes
  IS
    SELECT EXP_ID FROM EXP_EXPEDIENTES WHERE sys_guid IS NULL ORDER BY exp_id;
  CURSOR crs_creditos
  IS
    SELECT CRE_CEX_ID FROM CRE_PRC_CEX WHERE sys_guid IS NULL ORDER BY cre_cex_id;
  guid VARCHAR(36 CHAR);
BEGIN
  FOR rce IN crs_contratos_expediente
  LOOP
    SELECT SYS_GUID() INTO guid FROM DUAL ;
    guid := SUBSTR(guid, 1, 8) || '-' || SUBSTR(guid, 9, 4) || '-' || SUBSTR(guid, 13, 4) || '-' || SUBSTR(guid, 17, 4) || '-' || SUBSTR(guid, 21);
    --dbms_output.put_line(guid);
    UPDATE CEX_CONTRATOS_EXPEDIENTE
    SET SYS_GUID=guid
    WHERE cex_id=rce.cex_id;
    COMMIT;
  END LOOP;
  FOR ras IN crs_asuntos
  LOOP
    SELECT SYS_GUID() INTO guid FROM DUAL ;
    guid := SUBSTR(guid, 1, 8) || '-' || SUBSTR(guid, 9, 4) || '-' || SUBSTR(guid, 13, 4) || '-' || SUBSTR(guid, 17, 4) || '-' || SUBSTR(guid, 21);
    --dbms_output.put_line(guid);
    UPDATE ASU_ASUNTOS
    SET SYS_GUID=guid
    WHERE asu_id=ras.asu_id;
    COMMIT;
  END LOOP;
  FOR rex IN crs_expedientes
  LOOP
    SELECT SYS_GUID() INTO guid FROM DUAL ;
    guid := SUBSTR(guid, 1, 8) || '-' || SUBSTR(guid, 9, 4) || '-' || SUBSTR(guid, 13, 4) || '-' || SUBSTR(guid, 17, 4) || '-' || SUBSTR(guid, 21);
    --dbms_output.put_line(guid);
    UPDATE EXP_EXPEDIENTES
    SET SYS_GUID=guid
    WHERE EXP_ID=rex.exp_id;
    COMMIT;
  END LOOP;
  FOR cre IN crs_creditos
  LOOP
    SELECT SYS_GUID() INTO guid FROM DUAL ;
    guid := SUBSTR(guid, 1, 8) || '-' || SUBSTR(guid, 9, 4) || '-' || SUBSTR(guid, 13, 4) || '-' || SUBSTR(guid, 17, 4) || '-' || SUBSTR(guid, 21);
    --dbms_output.put_line(guid);
    UPDATE CRE_PRC_CEX
    SET SYS_GUID    =guid
    WHERE CRE_CEX_ID=cre.CRE_CEX_ID;
    COMMIT;
  END LOOP;
END;
/

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
--/*
--##########################################
--## AUTOR=ALBERTO CAMPOS
--## FECHA_CREACION=20151027
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.8
--## INCIDENCIA_LINK=CMREC-884
--## PRODUCTO=SI
--##
--## Finalidad: Se crean los campos para guardar la entidad desde la que se ha tomado la decisión y la comunicación entre recoverys
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
BEGIN

	VAR_TABLENAME := 'DPR_DECISIONES_PROCEDIMIENTOS';
    
	DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''DPR_ENTIDAD'' AND TABLE_NAME=''' || VAR_TABLENAME || ''' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si NO existe la COLUMNA la crea
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || VAR_TABLENAME || ' ADD (DPR_ENTIDAD VARCHAR(255 CHAR) NULL)';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campo ' || VAR_TABLENAME || '.DPR_ENTIDAD creado');	
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''SYS_GUID'' AND TABLE_NAME=''' || VAR_TABLENAME || ''' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si NO existe la COLUMNA la crea
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || VAR_TABLENAME || ' ADD (SYS_GUID VARCHAR(32 CHAR) NULL)';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campo ' || VAR_TABLENAME || '.SYS_GUID creado');	
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_DPR_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_DPR_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_DPR_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

	DBMS_OUTPUT.PUT_LINE('******** FIN DE LA MODIFICACION DE DPR_DECISIONES_PROCEDIMIENTOS ********');
	
	VAR_TABLENAME := 'PRD_PROCEDIMIENTOS_DERIVADOS';
    
	DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''SYS_GUID'' AND TABLE_NAME=''' || VAR_TABLENAME || ''' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si NO existe la COLUMNA la crea
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || VAR_TABLENAME || ' ADD (SYS_GUID VARCHAR(32 CHAR) NULL)';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campo ' || VAR_TABLENAME || '.SYS_GUID creado');	
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''UK_PRD_SYS_GUID'' AND TABLE_NAME='''||VAR_TABLENAME||''' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.UK_PRD_SYS_GUID';
    END IF;
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_PRD_SYS_GUID  ON ' || V_ESQUEMA || '.'||VAR_TABLENAME||' (SYS_GUID)';

	DBMS_OUTPUT.PUT_LINE('******** FIN DE LA MODIFICACION DE PRD_PROCEDIMIENTOS_DERIVADOS ********'); 
	
	COMMIT;
	
EXCEPTION


	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/

EXIT;
/*
--##########################################
--## Author: Oscar Dorado
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Crea secuencia para diccionario DD_TFA_FICHERO_ADJUNTO y modifica columna DD_TFA_DESCRIPCION
--## INSTRUCCIONES:  Crea secuencia para diccionario DD_TFA_FICHERO_ADJUNTO y modifica columna DD_TFA_DESCRIPCION
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
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

    VAR_TABLENAME := 'DD_TFA_FICHERO_ADJUNTO';
    VAR_SEQUENCENAME := 'S_DD_TFA_FICHERO_ADJUNTO';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Comprobaciones previas'); 

    -- ELIMINAMOS LA SECUENCIA: S_DD_TFA_FICHERO_ADJUNTO
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''' || VAR_SEQUENCENAME || ''' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.' || VAR_SEQUENCENAME;
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_SEQUENCENAME || '... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... Comprobaciones previas FIN'); 
    
    -- CREAMOS LA SECUENCIA: S_DD_TFA_FICHERO_ADJUNTO
    V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.' || VAR_SEQUENCENAME;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_SEQUENCENAME || '... Secuencia creada');
    
    -- MODIFICA COLUMNA: DD_TFA_FICHERO_ADJUNTO.DD_TFA_DESCRIPCION
    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''DD_TFA_DESCRIPCION'' AND TABLE_NAME=''' || VAR_TABLENAME || ''' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la COLUMNA la modifica
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || VAR_TABLENAME || ' MODIFY(DD_TFA_DESCRIPCION VARCHAR2(100 CHAR))';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campo ' || VAR_TABLENAME || '.DD_TFA_DESCRIPCION modificado');	
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
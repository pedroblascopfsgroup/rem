--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20221020
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18832
--## PRODUCTO=NO
--## Finalidad: Creación diccionario AUX_GEH_COPIA_DATOS_MATRIZ
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
    V_TEXT_TABLA VARCHAR2(150 CHAR):= 'AUX_GEE_COPIA_DATOS_MATRIZ'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** DD_TPG_TPO_DOC_GASTO_ASOC *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TEXT_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_TPG_TPO_DOC_GASTO_ASOC
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si no existe la tabla se crea
    IF V_NUM_TABLAS = 1 THEN 
                		    
          -- Verificar si la tabla ya existe
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
	END IF;
        --Creamos la tabla
        DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TEXT_TABLA||']');
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                    GEE_ID                     	NUMBER(16,0)
	          , USU_ID              		NUMBER(16,0)
                  , DD_TGE_ID	                       NUMBER(16,0) 
                  , ACT_ID_MATRIZ			NUMBER(16,0) 
                  , ACT_ID_UA				NUMBER(16,0) 
			  )';        	

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Tabla creada');
					
        DBMS_OUTPUT.PUT_LINE('Creados los comentarios en TABLA '|| V_ESQUEMA ||'.AUX_FICHEROS_ENVIADOS_FTP... OK');
   

COMMIT;
DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
    
    
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

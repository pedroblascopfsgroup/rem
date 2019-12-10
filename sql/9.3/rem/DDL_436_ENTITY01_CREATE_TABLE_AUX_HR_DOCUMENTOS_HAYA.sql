--/*
--##########################################
--## AUTOR=IKER ADOT
--## FECHA_CREACION=20190613
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-6625
--## PRODUCTO=NO
--## 
--## Finalidad: DDL
--## INSTRUCCIONES: Crear tabla auxiliar para el ETL APR_MAIN_HR_DOCUMENTOS_HAYA
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
 
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_EXISTE NUMBER (1); -- Vlbe. para consultar si la sequencia existe.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA VARCHAR2(32 CHAR) := 'AUX_HR_DOCUMENTOS_HAYA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla auxiliar para el ETL APR_MAIN_HR_DOCUMENTOS_HAYA'; -- Vble. para los comentarios de las tablas.

    BEGIN

    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla auxiliar  
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla.
    IF V_NUM_TABLAS = 1 THEN 

		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe.');  
		
    ELSE
	
		--Creamos la tabla
		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'(
						COD_GASTO_REM		NUMBER(16,0),
						COD_ACTIVO_REM		NUMBER(16,0),
						F_ID_CLI_ENTIDAD	VARCHAR2(20 CHAR),
						MATRICULA			VARCHAR2(20 CHAR),
						RUTA_DOCUMENTO		VARCHAR2(255 CHAR),
						FECHA_DOCUMENTO		DATE,
						DATA_ID				VARCHAR2(21 CHAR),
						ESTAD_PROCESADO		VARCHAR2(4 CHAR)
					)'; 

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
		
		--Creamos comentario
		V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');
    
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

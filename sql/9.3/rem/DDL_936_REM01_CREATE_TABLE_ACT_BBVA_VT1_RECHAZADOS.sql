--/*
--##########################################
--## AUTOR=Dean Ibañez VIño
--## FECHA_CREACION=20200907
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10918
--## PRODUCTO=NO
--## Finalidad: Creacion ACT_BBVA_VT1_RECHAZADOS
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TABLA VARCHAR2(2400 CHAR) := 'ACT_BBVA_VT1_RECHAZADOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe.');
		
    ELSE
            -- Creamos la tabla
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TABLA||'...');
            V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TABLA||'
            (
                ACT_NUM_ACTIVO               NUMBER(16,0)
                ,FECHA_PROCESADO             TIMESTAMP (6)
                ,OPERACION                   VARCHAR(1)
                ,COD_ERROR                   VARCHAR(2)
                ,DESC_ERROR                  VARCHAR(200)
            )
            ';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');

            -- Creamos comentario
            V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS ''Tabla ACT_BBVA_VT1_RECHAZADOS.''';
		    EXECUTE IMMEDIATE V_MSQL;	
            V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.ACT_NUM_ACTIVO IS ''Identificador del activo''';
            EXECUTE IMMEDIATE V_SQL;
            V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.FECHA_PROCESADO IS ''Fecha del procesado del ETL''';
            EXECUTE IMMEDIATE V_SQL;
            V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.OPERACION IS ''A = Alta, M = Modificación, V = Venta ''';
            EXECUTE IMMEDIATE V_SQL;
            V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.COD_ERROR IS ''Código de error de las validaciones VT1''';
            EXECUTE IMMEDIATE V_SQL;
            V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.DESC_ERROR IS ''Descripción de error de las validaciones VT1''';
            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentarios creados.');
            
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');

    END IF;

	COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;

--/*
--##########################################
--## AUTOR=Vicente Martinez
--## FECHA_CREACION=20181002
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Añadir los campos nuevos de Fecha valor venta haya y liquidez a la tabla de Valoraciones y modificar DD_OPM para carga masiva
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.



 
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CRG_CARGAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO_MODIFICAR VARCHAR2(50 CHAR) := 'REMVIP-1868';
    V_COL VARCHAR2(2400 CHAR) := 'CRG_CARGAS_PROPIAS';


    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	
	IF V_NUM_TABLAS != 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... no existe.');
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... existe.');
		
		V_NUM_TABLAS := 0;    
    	V_MSQL:= 'SELECT COUNT(1) FROM USER_TAB_COLS WHERE UPPER(TABLE_NAME) =  '''||V_TEXT_TABLA||''' and UPPER(COLUMN_NAME) = '''||V_COL||''' ';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		
		IF V_NUM_TABLAS = 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.'||V_COL||' ya existe.');
		
			ELSE
			
				V_MSQL:='ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD '||V_COL||' NUMBER(1,0)';
				EXECUTE IMMEDIATE V_MSQL;	
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.'||V_COL||' creada.');
					
		END IF;

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
          DBMS_OUTPUT.PUT_LINE(V_MSQL);

          ROLLBACK;
          RAISE; 
         
END;

/

EXIT

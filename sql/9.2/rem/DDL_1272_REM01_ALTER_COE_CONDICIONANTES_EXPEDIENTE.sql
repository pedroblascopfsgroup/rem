--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20160908
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Añadir columnas para guardar los gastos de un alquiler
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
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'COE_CONDICIONANTES_EXPEDIENTE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    
    
    
BEGIN

	-- Comprobamos si existe columna COE_GASTOS_IBI
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''COE_GASTOS_IBI'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.COE_GASTOS_IBI... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (COE_GASTOS_IBI NUMBER(16,2))';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.COE_GASTOS_IBI... Creado');
	END IF;
	
		-- Comprobamos si existe columna COE_GASTOS_COMUNIDAD
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''COE_GASTOS_COMUNIDAD'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.COE_GASTOS_COMUNIDAD... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (COE_GASTOS_COMUNIDAD NUMBER(16,2))';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.COE_GASTOS_COMUNIDAD... Creado');
	END IF;
	
			-- Comprobamos si existe columna COE_GASTOS_SUMINISTROS
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''COE_GASTOS_SUMINISTROS'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.COE_GASTOS_SUMINISTROS... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (COE_GASTOS_SUMINISTROS NUMBER(16,2))';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.COE_GASTOS_SUMINISTROS... Creado');
	END IF;
	
				-- Comprobamos si existe columna DD_TPC_ID_IBI
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_TPC_ID_IBI'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPC_ID_IBI... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (DD_TPC_ID_IBI NUMBER(16,0))';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPC_ID_IBI... Creado');
	END IF;
	
					-- Comprobamos si existe columna DD_TPC_ID_COMUNIDAD_ALQUILER
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_TPC_ID_COMUNIDAD_ALQUILER'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPC_ID_COMUNIDAD_ALQUILER... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (DD_TPC_ID_COMUNIDAD_ALQUILER NUMBER(16,0))';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPC_ID_COMUNIDAD_ALQUILER... Creado');
	END IF;
	
					-- Comprobamos si existe columna DD_TPC_ID_IBI
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_TPC_ID_SUMINISTROS'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPC_ID_SUMINISTROS... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (DD_TPC_ID_SUMINISTROS NUMBER(16,0))';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPC_ID_SUMINISTROS... Creado');
	END IF;
	
	
	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.COE_CONDICIONANTES_EXPEDIENTE.COE_GASTOS_IBI        is ''Gastos IBI, oferta de tipo alquiler''  ';
	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.COE_CONDICIONANTES_EXPEDIENTE.COE_GASTOS_COMUNIDAD        is ''Gastos Comunidad, oferta de tipo alquiler''  ';
	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.COE_CONDICIONANTES_EXPEDIENTE.COE_GASTOS_SUMINISTROS        is ''Gastos Suministros, oferta de tipo alquiler''  ';
	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.COE_CONDICIONANTES_EXPEDIENTE.DD_TPC_ID_IBI        is ''IBI Por cuenta de, oferta alquiler''  ';
	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.COE_CONDICIONANTES_EXPEDIENTE.DD_TPC_ID_COMUNIDAD_ALQUILER        is ''Comunidad Por cuenta de, oferta alquiler''  ';
	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.COE_CONDICIONANTES_EXPEDIENTE.DD_TPC_ID_SUMINISTROS        is ''Suministros Por cuenta de, oferta alquiler''  ';

	
	
	EXCEPTION
	     WHEN OTHERS THEN
	          err_num := SQLCODE;
	          err_msg := SQLERRM;
	
	          DBMS_OUTPUT.PUT_LINE('KO no modificada');
	          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
	          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
	          DBMS_OUTPUT.put_line(err_msg);
	
	          ROLLBACK;
	          RAISE;          

END;

/

EXIT
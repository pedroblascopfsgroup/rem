--/*
--##########################################
--## AUTOR=Lara Pablo FLores
--## FECHA_CREACION=20190208
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5463
--## PRODUCTO=NO
--## Finalidad: Cambiar los campos de la tabla para que admita null.
--##           
--## INSTRUCCIONES: Inserta la columna fecha_anticipo en la tabla APR_AUX_GES_GASTOS_GR
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_COLUMN_NAME1 VARCHAR2(2400 CHAR) := 'DD_TPE_ID'; -- Vble. auxiliar para almacenar el nombre de la columna a añadir.
    V_COLUMN_NAME2 VARCHAR2(2400 CHAR) := 'DD_SIP_ID'; -- Vble. auxiliar para almacenar el nombre de la columna a añadir.
    V_COLUMN_NAME3 VARCHAR2(2400 CHAR) := 'OFR_ID'; -- Vble. auxiliar para almacenar el nombre de la columna a añadir.
    
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_HOG_HIST_OFERTA_GENCAT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    
BEGIN

 	-- Comprobamos si ya existe la columna que se va a añadir
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||V_COLUMN_NAME1||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 1 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||V_COLUMN_NAME1||'''... Ya existe');
      EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFY  ('||V_COLUMN_NAME1 ||' NULL)';
    ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME1||'... La columna no existe');        
    END IF;
        
    -- _________________________________________________________--
    
    
     V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||V_COLUMN_NAME2||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 1 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||V_COLUMN_NAME2||'''... Ya existe');
      EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFY  ('||V_COLUMN_NAME2||' NULL)';
    ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME2||'... La columna no existe');        
    END IF;
    
    
    -- _________________________________________________________--
    
    
     V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||V_COLUMN_NAME3||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 1 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||V_COLUMN_NAME3||'''... Ya existe');
      EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFY  ('||V_COLUMN_NAME3 ||' NULL)';
    ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME3||'... La columna no existe');        
    END IF;
  
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
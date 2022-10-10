--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220923
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12422
--## PRODUCTO=NO
--## Finalidad: Columna nueva en ACT_CPR_COM_PROPIETARIOS
--##           
--## INSTRUCCIONES: Inserta la columna CPR_OBSERV_COM_PROP en la tabla ACT_CPR_COM_PROPIETARIOS
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
    
    V_COLUMN_NAME VARCHAR2(2400 CHAR) := 'CPR_OBSERV_COM_PROP'; -- Vble. auxiliar para almacenar el nombre de la columna a añadir.
    V_COLUMN_TYPE VARCHAR2(2400 CHAR) := 'VARCHAR2(250 CHAR)'; -- Vble. auxiliar para almacenar el nombre de la columna a añadir.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CPR_COM_PROPIETARIOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN

 	-- Comprobamos si ya existe la columna que se va a añadir
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||V_COLUMN_NAME||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 1 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||V_COLUMN_NAME||'''... Ya existe');
    ELSE
      EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME||' '||V_COLUMN_TYPE||')';
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME||'... Creada');        
    END IF;

	-- Creamos comentarios columnas
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME||' IS ''Campo para observaciones en comunidad de propietarios'' ';      
    EXECUTE IMMEDIATE V_MSQL;


  
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

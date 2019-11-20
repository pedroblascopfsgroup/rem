--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20190325
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7942
--## PRODUCTO=NO
--##
--## Finalidad: Script creación columna y fk
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PLS_PLUSVALIA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_UK_NAME VARCHAR2(2400 CHAR) := 'UK_ACT_ID'; -- Vble para nombe de la UK
    
BEGIN	
	  --Verificar is existe la tabla, si no no se hace nada
  V_MSQL := 'select count(1) from ALL_TABLES where table_name = '''||V_TEXT_TABLA||'''';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
  IF V_NUM_TABLAS = 1 THEN
     -- Verificar si la FK ya existe. Si ya existe la FK, no se hace nada.
     V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = '''||V_UK_NAME||'''';
     EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
     IF V_NUM_TABLAS = 0 THEN
       --No existe la FK y la creamos
       V_MSQL := '
         ALTER TABLE '||V_TEXT_TABLA||'
         ADD CONSTRAINT '||V_UK_NAME||' UNIQUE
         (
           ACT_ID
         )';

       EXECUTE IMMEDIATE V_MSQL;
       --DBMS_OUTPUT.PUT_LINE('[3] '||V_MSQL);
       DBMS_OUTPUT.PUT_LINE('[INFO] UK creada con éxito');

    END IF;

  END IF;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TEXT_TABLA||' actualizada ok ');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          DBMS_OUTPUT.put_line(V_MSQL);

          ROLLBACK;
          RAISE;          

END;

/

EXIT   
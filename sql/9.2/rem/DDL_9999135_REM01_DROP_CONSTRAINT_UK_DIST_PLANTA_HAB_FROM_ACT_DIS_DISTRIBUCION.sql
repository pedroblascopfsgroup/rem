--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20172511
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: QUITAR CONSTRAINT QUE NO PERMITE VOLVER A INSERTAR DISTRIBUCIONES QUE HAN SIDO BORRADAS LOGICAMENTE, LA COMPROBACION SE SIGUE HACIENDO EN JAVA
--##           
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

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_DIS_DISTRIBUCION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN




V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = ''UK_DIST_PLANTA_HAB''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	              

    IF V_NUM_TABLAS > 0 THEN
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DROP CONSTRAINT UK_DIST_PLANTA_HAB ';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.UK_DIST_PLANTA_HAB... UNIQUE KEY BORRADA.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA RESTRICCION, NO SE PUEDE BORRAR AL NO EXISTIR');
    END IF;
    
    V_MSQL :=  'SELECT COUNT(1) FROM ALL_INDEXES where OWNER = '''||V_ESQUEMA||''' and INDEX_NAME = ''UK_DIST_PLANTA_HAB''';
    		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	    
    IF V_NUM_TABLAS > 0 THEN
        V_MSQL := 'DROP INDEX '||V_ESQUEMA||'.UK_DIST_PLANTA_HAB ';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] INDICE' ||V_ESQUEMA||'.UK_DIST_PLANTA_HAB KEY BORRADA.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA RESTRICCION, NO SE PUEDE BORRAR AL NO EXISTIR');
    END IF;
        

EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('[ERROR] ...KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT


--/*
--##########################################
--## AUTOR=Teresa Alonso
--## FECHA_CREACION=20170323
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1825
--## PRODUCTO=NO
--## Finalidad: Crear vista unidades poblacionales
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

    V_MSQL VARCHAR2( 32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2( 25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2( 25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2( 25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2( 4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER( 16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER( 16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER( 25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2( 1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2( 2400 CHAR); -- Vble. auxiliar 
    V_TEXT_VISTA VARCHAR2( 2400 CHAR) := 'V_UPO_UVEM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2( 2400 CHAR) := 'dd_upo_unid_poblacional'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2( 500 CHAR):= 'Vista Unidades Poblacionales.'; -- Vble. para los comentarios de las tablas

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_VISTA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_VISTA||'... Creación vista');
	

	-- Verificar si la vista ya existe
--	V_MSQL := 'SELECT COUNT( 1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
--	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
--	IF V_NUM_TABLAS = 1 THEN
--		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
--		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
--		
--	END IF;

	
	-- Creamos la vista
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_VISTA||'...');

	DBMS_OUTPUT.PUT_LINE('[INFO] ''' || V_ESQUEMA || '''.''' || V_TEXT_VISTA || '''...');
	V_MSQL := 'CREATE OR REPLACE FORCE VIEW "' || V_ESQUEMA || '"."' || V_TEXT_VISTA || '" ("DD_LOC_ID", "DD_UPO_CODIGO", "DD_UPO_DESCRIPCION") AS 
	           SELECT   dd_loc_id, LPAD (MAX (dd_upo_codigo), 9, ''0'') dd_upo_codigo, dd_upo_descripcion
	           FROM ' ||V_ESQUEMA_M || '.' || V_TEXT_TABLA || ' d2 
	           WHERE (d2.dd_upo_descripcion, d2.dd_loc_id) IN (SELECT d.dd_upo_descripcion, d.dd_loc_id
	                                                           FROM ' || V_ESQUEMA_M || '.' || V_TEXT_TABLA || ' d
	                                                           WHERE d.dd_upo_codigo LIKE ''%0000'')
	           GROUP BY dd_loc_id, dd_upo_descripcion' ;

        --DBMS_OUTPUT.PUT_LINE(  V_MSQL); 
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'... Vista creada.');

	COMMIT;

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

EXIT;

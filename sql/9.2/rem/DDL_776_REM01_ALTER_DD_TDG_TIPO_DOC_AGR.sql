--/*
--##########################################
--## AUTOR=Alfonso Rodriguez
--## FECHA_CREACION=20191104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-8258
--## PRODUCTO=NO
--## Finalidad: Borrar la columna DD_TDG_VISIBLE de la tabla DD_TDG_TIPO_DOC_AGR
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TDG_TIPO_DOC_AGR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_TDG_VISIBLE'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN

		-- si existe la columna DD_TDG_VISIBLE
		EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.act_adg_adjunto_agrupacion adg 
		set 
		DD_TDG_ID = null
		, USUARIOMODIFICAR = ''HREOS-8258''
		, FECHAMODIFICAR = SYSDATE
		where EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' tdg where tdg.dd_tdg_id=adg.dd_tdg_id and tdg.dd_tdg_visible=1)';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||' ACTUALIZAMOS A NULL SU FK');


		-- Borrar los visibles a 1
		EXECUTE IMMEDIATE 'delete from '||V_ESQUEMA||'.'||V_TEXT_TABLA||' where dd_tdg_visible=1';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.DD_TDG_VISIBLE... DATOS BORRADOS');


		-- Borrar columna visible si existe
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' DROP COLUMN dd_tdg_visible';  
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.DD_TDG_VISIBLE... COLUMNA BORRADA');


	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.DD_TDG_VISIBLE... Ya no Existe. No se hace nada');
	END IF;

	
	DBMS_OUTPUT.PUT_LINE('[FIN] OK - Operacion realizada correctamente.');
		
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

EXIT
--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160916
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Eliminar la columna ACT_FECHA_IND_BLOQUEO_PRECIO por estar duplicada con la columna ACT_BLOQUEO_PRECIO_FECHA_INI
--## y completar algunos comentarios en columnas de ACT_ACTIVO
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para gestionar los activos.'; -- Vble. para los comentarios de las tablas

    
    
    
BEGIN

/*
ALTER TABLE ACT_ACTIVO DROP COLUMN ACT_FECHA_IND_BLOQUEO_PRECIO;

ALTER TABLE ACT_ACTIVO RENAME COLUMN USU_ID TO ACT_BLOQUEO_PRECIO_USU_ID;

COMMENT ON COLUMN ACT_ACTIVO.ACT_BLOQUEO_PRECIO_FECHA_INI IS 'Indicador de activo bloqueado desde esta fecha';

COMMENT ON COLUMN ACT_ACTIVO.ACT_BLOQUEO_PRECIO_USU_ID IS 'Indicador de activo bloqueado por este usuario';

COMMENT ON COLUMN ACT_ACTIVO.DD_TPU_ID IS 'FK a tipo de publicacion del activo';

COMMENT ON COLUMN ACT_ACTIVO.DD_EPU_ID IS 'FK al estado de publicacion del activo';
*/

	-- Comprobamos si existe columna ACT_FECHA_IND_BLOQUEO_PRECIO (si es así, la borramos)
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''ACT_FECHA_IND_BLOQUEO_PRECIO'' and DATA_TYPE = ''DATE'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_FECHA_IND_BLOQUEO_PRECIO... No existe la columna. No se hace nada.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_FECHA_IND_BLOQUEO_PRECIO... Existe. se procede a eliminar la columna.');
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' DROP COLUMN ACT_FECHA_IND_BLOQUEO_PRECIO';	
	END IF;
	
	-- Comprobamos si existe columna USU_ID (si es así, la renombramos a ACT_BLOQUEO_PRECIO_USU_ID)
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''USU_ID'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USU_ID... Ya no existe con ese nombre. Actualmente debe ser ACT_BLOQUEO_PRECIO_USU_ID.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USU_ID... Existe. Se procede a renombrar columna a ACT_BLOQUEO_PRECIO_USU_ID');
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' RENAME COLUMN USU_ID TO ACT_BLOQUEO_PRECIO_USU_ID';
	END IF;
	
	-- Se agregan algunos comentarios de columnas de ACT_ACTIVO
	DBMS_OUTPUT.PUT_LINE('[INFO] Se agregan comentarios a columnas de '||V_ESQUEMA||'.'||V_TEXT_TABLA||'...');
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_BLOQUEO_PRECIO_FECHA_INI IS ''Indicador de activo bloqueado desde esta fecha'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_BLOQUEO_PRECIO_USU_ID IS ''Indicador de activo bloqueado por este usuario'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPU_ID IS ''FK a tipo de publicacion del activo'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_EPU_ID IS ''FK al estado de publicacion del activo'' ';
	

	DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT.');
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

EXIT
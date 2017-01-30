--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20170130
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1466
--## PRODUCTO=NO
--## Finalidad: Tabla para gestionar las direcciones de los proveedores - Correccion FK
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PRD_PROVEEDOR_DIRECCION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para gestionar los adjuntos de un proveedor.'; -- Vble. para los comentarios de las tablas

BEGIN


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');

	
	--Comprobamos si existe foreign key FK_DD_PRV_ID
	V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME= ''FK_PRD_PRV_ID'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_PRV_ID... Ya existe. Se borra primero.');		
		-- Se borra FK antigua
		V_MSQL := 'alter table '||V_ESQUEMA||'.ACT_PRD_PROVEEDOR_DIRECCION drop constraint "FK_PRD_PRV_ID"';
		EXECUTE IMMEDIATE V_MSQL;
	END IF;

	-- Creamos foreign key FK_DD_PRV_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_PRD_PRV_ID FOREIGN KEY (DD_PRV_ID) REFERENCES '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA (DD_PRV_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_PRD_PRV_ID... Foreign key creada.');
		

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
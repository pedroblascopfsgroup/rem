--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190605
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6440
--## PRODUCTO=NO
--## Finalidad: Tabla para gestionar el diccionario de estados civiles.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una sECVencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA_BORRADO VARCHAR2(30 CHAR) := 'DD_ECV_ESTADOS_CIVILES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_NUEVA VARCHAR2(30 CHAR) := 'DD_ECV_ESTADOS_CIVILES_URSUS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_DESTINO VARCHAR2(30 CHAR) := 'COM_COMPRADOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA_DESTINO|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA_DESTINO||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''FK_COMPRADOR_DDECV_URSUS'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS >= 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] BORRAMOS LA CONSTRAINT FK_COMPRADOR_DDECV_URSUS QUE APUNTA A '||V_TEXT_TABLA_BORRADO||'');
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_DESTINO||' DROP CONSTRAINT FK_COMPRADOR_DDECV_URSUS';		
		EXECUTE IMMEDIATE V_MSQL;	
	ELSE		
		DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA CONSTRAINT FK_COMPRADOR_DDECV_URSUS');
	END IF;

	-- Comprobar si existe la sECVencia.
	V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''FK_COMPRADOR_DDECVURSUS'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAMOS LA CONSTRAINT FK_COMPRADOR_DDECVURSUS QUE APUNTA A '||V_TEXT_TABLA_NUEVA||'');
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_DESTINO||' ADD CONSTRAINT FK_COMPRADOR_DDECVURSUS FOREIGN KEY (DD_ECV_ID_URSUS) REFERENCES '||V_TEXT_TABLA_NUEVA||' (DD_ECV_ID)';	
		EXECUTE IMMEDIATE V_MSQL;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE LA CONSTRAINT FK_COMPRADOR_DDECVURSUS');
	END IF; 
	COMMIT;

EXCEPTION
     WHEN OTHERS THEN 
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejECVción:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
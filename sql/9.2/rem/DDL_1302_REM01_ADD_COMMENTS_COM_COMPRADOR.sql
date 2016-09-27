--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20160920
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Añadir comentarios a las tablas
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
    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    	T_ALTER('COM_COMPRADOR','COM_ID','Código identificador único del comprador'),
		T_ALTER('COM_COMPRADOR','DD_TPE_ID','Tipo de persona'),
		T_ALTER('COM_COMPRADOR','COM_NOMBRE','Nombre del comprador'),
		T_ALTER('COM_COMPRADOR','COM_APELLIDOS','Apellidos del comprador'),
		T_ALTER('COM_COMPRADOR','DD_TDI_ID','Tipo de documento'),
		T_ALTER('COM_COMPRADOR','COM_DOCUMENTO','Documento del comprador'),
		T_ALTER('COM_COMPRADOR','COM_TELEFONO1','Teléfono 1 del comprador'),
		T_ALTER('COM_COMPRADOR','COM_TELEFONO2','Teléfono 2 del comprador'),
		T_ALTER('COM_COMPRADOR','COM_EMAIL','Email del comprador'),
		T_ALTER('COM_COMPRADOR','COM_DIRECCION','Dirección del comprador'),
		T_ALTER('COM_COMPRADOR','COM_MUNICIPIO','Municipio del comprador'),
		T_ALTER('COM_COMPRADOR','COM_CODIGO_POSTAL','Código postal del comprador'),
		T_ALTER('COM_COMPRADOR','COM_PROVINCIA','Provincio del comprador')
	);
    V_T_ALTER T_ALTER;


BEGIN
	

	-- Bucle que CREA las nuevas columnas 
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP

		V_T_ALTER := V_ALTER(I);

		-- Verificar si la columna EXISTE.
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(2)||''' and TABLE_NAME = '''||V_T_ALTER(1)||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN
			-- Creamos comentario	
			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_T_ALTER(1)||'.'||V_T_ALTER(2)||' IS '''||V_T_ALTER(3)||'''';		
			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE('[2] '||V_MSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_T_ALTER(1)||'.'||V_T_ALTER(2)||'... Comentario en columna creado.');
		END IF;

	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_T_ALTER(1)||' Añadidos comentarios ... OK *************************************************');
	COMMIT;	


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
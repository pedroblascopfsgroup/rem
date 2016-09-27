--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20160919
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
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
T_ALTER('FOR_FORMALIZACION','FOR_ID','Id de formalizacion'),
T_ALTER('FOR_FORMALIZACION','ECO_ID','Número del expediente'),
T_ALTER('FOR_FORMALIZACION','FOR_NOMBRE_NOTARIO','Nombre del notario'),
T_ALTER('FOR_FORMALIZACION','FOR_DIRECCION_NOTARIO','Dirección del notario'),
T_ALTER('FOR_FORMALIZACION','FOR_CONTACTO_NOTARIO','Contacto del notario'),
T_ALTER('FOR_FORMALIZACION','FOR_CONTACTO_CARGO','Cargo del notario'),
T_ALTER('FOR_FORMALIZACION','FOR_CONTACTO_EMAIL','Email del notario'),
T_ALTER('FOR_FORMALIZACION','FOR_CONTACTO_TELEFONO','Telefono contacto notario'),
T_ALTER('FOR_FORMALIZACION','FOR_PETICIONARIO','Peticionario'),
T_ALTER('FOR_FORMALIZACION','FOR_FECHA_PETICION','Fecha petición'),
T_ALTER('FOR_FORMALIZACION','FOR_FECHA_RESOLUCION','Fecha resolución'),
T_ALTER('FOR_FORMALIZACION','FOR_FECHA_ESCRITURA','Fecha escritura'),
T_ALTER('FOR_FORMALIZACION','FOR_FECHA_CONTABILIZACION','Fecha contabilización'),
T_ALTER('FOR_FORMALIZACION','FOR_FECHA_PAGO','Fecha pago'),
T_ALTER('FOR_FORMALIZACION','FOR_IMPORTE','Importe formalización'),
T_ALTER('FOR_FORMALIZACION','FOR_FORMA_PAGO','Forma de pago'),
T_ALTER('FOR_FORMALIZACION','FOR_GASTOS_CARGO','Gastos cargo'),
T_ALTER('FOR_FORMALIZACION','FOR_MOTIVO_RESOLUCION','Motivo resolución')
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
--/*
--##########################################
--## AUTOR=Salvador Puertes
--## FECHA_CREACION=20190905
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.16.0
--## INCIDENCIA_LINK=HREOS-7164
--## PRODUCTO=NO
--##
--## Finalidad: Eliminar columna DD_COS_PROPUESTO_ID
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

	V_COLUMN_NAME VARCHAR(30):= 'DD_COS_PROPUESTO_ID';
 
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_CREAR_FK VARCHAR2(2 CHAR) := 'SI'; -- [SI, NO] Vble. para indicar al script si debe o no crear tambien las relaciones Foreign Keys.

    
	-- ARRAY CON NUEVAS COLUMNAS
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    		-- NOMBRE CAMPO						TIPO CAMPO						DESCRIPCION
    	T_ALTER(  'DD_COS_PROPUESTO_ID',		 		'NUMBER(16,0)',						'ID Comité propuesto para la sanción.'	)
		);
    V_T_ALTER T_ALTER;

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas *************************************************');

	
	-- Bucle que CREA las nuevas columnas 
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP

		V_T_ALTER := V_ALTER(I);

		-- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(1)||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	

		IF V_NUM_TABLAS = 1 THEN
		--Existe la columna y la creamos
			DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_COLUMN_NAME||'] -------------------------------------------');
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' DROP COLUMN '||V_COLUMN_NAME;
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_COLUMN_NAME||']... Columna borrada.');
		END IF;

	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' SIN DD_COS_PROPUESTA_ID ... OK *************************************************');
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
	


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('[ERROR] ...KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
	  DBMS_OUTPUT.put_line('--------------------------SQL------------------------------'); 
          DBMS_OUTPUT.put_line(V_MSQL);
          DBMS_OUTPUT.put_line('---------------------------ERROR----------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);


          ROLLBACK;
          RAISE;          

END;

/

EXIT

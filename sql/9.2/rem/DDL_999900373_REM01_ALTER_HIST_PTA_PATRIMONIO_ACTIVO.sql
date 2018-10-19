--/*
--##########################################
--## AUTOR=Rasul Abdulaev
--## FECHA_CREACION=20181005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4546
--## PRODUCTO=NO
--## Finalidad: MODIFICACION DE COLUMNAS
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'HIST_PTA_PATRIMONIO_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CREAR_FK VARCHAR2(2 CHAR) := 'SI'; -- [SI, NO] Vble. para indicar al script si debe o no crear tambien las relaciones Foreign Keys.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA(  'DD_EAL_ID',							'NUMBER',	        '',				'Código identificador único del diccionario de estado alquiler',			'FK_DD_EAL_HIST_PTA', 				'DD_EAL_ID', 		V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER', 			'DD_EAL_ID'),
		T_TIPO_DATA(  'DD_TPI_ID',							'NUMBER',	        '',				'Código identificador único del diccionario de tipo inquilino', 			'FK_DD_TPI_HIST_PTA',				'DD_TPI_ID',		V_ESQUEMA||'.DD_TPI_TIPO_INQUILINO',			'DD_TPI_ID')
     
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN

	 -- LOOP para AÑADIR LAS COLUMNAS DE V_TIPO_DATA-----------------------------------------------------------------
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
	    -- Comprobamos si existe columna 
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||TRIM(V_TMP_TIPO_DATA(1))||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS = 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||TRIM(V_TMP_TIPO_DATA(1))||'''... Ya existe');
		ELSE
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||V_TMP_TIPO_DATA(3)||')';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(4)||'''';
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... Creada');

			DBMS_OUTPUT.PUT_LINE('[INFO] Creando FK...');

			V_MSQL := '
				ALTER TABLE '||V_TEXT_TABLA||'
				ADD CONSTRAINT '||TRIM(V_TMP_TIPO_DATA(5))||' FOREIGN KEY
				(
					'||TRIM(V_TMP_TIPO_DATA(6))||'
				)
				REFERENCES '||TRIM(V_TMP_TIPO_DATA(7))||'
				(
					'||TRIM(V_TMP_TIPO_DATA(8))||' 
				)
				ON DELETE SET NULL ENABLE
			';

			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ... '||TRIM(V_TMP_TIPO_DATA(5))||' creada en tabla: FK en columna '||TRIM(V_TMP_TIPO_DATA(6))||' hacia '||TRIM(V_TMP_TIPO_DATA(7))||'.'||TRIM(V_TMP_TIPO_DATA(8))||'... OK');

       	END IF;
      END LOOP;

      V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''CHECK_SUBROGADO'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
      IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CHECK_SUBROGADO ... Ya existe');
      ELSE
          EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CHECK_SUBROGADO NUMBER)';
          EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CHECK_SUBROGADO IS ''Indica si tiene el check Subrogado''';
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CHECK_SUBROGADO ... Creada');
      END IF;

    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' AMPLIADA CON COLUMNAS NUEVAS Y FKS .... OK *************************************************');
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');


	
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


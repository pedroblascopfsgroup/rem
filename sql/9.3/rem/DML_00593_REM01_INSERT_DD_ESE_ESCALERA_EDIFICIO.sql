--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210513
--## ARTEFACTO=online
--## VERSION_ARTEFACTO= 9.3
--## INCIDENCIA_LINK=HREOS-13938
--## PRODUCTO=NO
--##
--## Finalidad:            
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto  en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-13938';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_ESE_ESCALERA_EDIFICIO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- PARTIDA_PRESUPUESTARIA   DD_TGA_CODIGO  DD_TIM_CODIGO   DD_SCR_CODIGO
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('1','Escalera 1','Escalera 1'),
		T_TIPO_DATA('2','Escalera 2','Escalera 2'),
		T_TIPO_DATA('3','Escalera 3','Escalera 3'),
		T_TIPO_DATA('4','Escalera 4','Escalera 4'),
		T_TIPO_DATA('5','Escalera 5','Escalera 5'),
		T_TIPO_DATA('6','Escalera 6','Escalera 6'),
		T_TIPO_DATA('7','Escalera 7','Escalera 7'),
		T_TIPO_DATA('8','Escalera 8','Escalera 8'),
		T_TIPO_DATA('9','Escalera 9','Escalera 9'),
		T_TIPO_DATA('10','Escalera 10','Escalera 10'),
		T_TIPO_DATA('A','Escalera A','Escalera A'),
		T_TIPO_DATA('B','Escalera B','Escalera B'),
		T_TIPO_DATA('C','Escalera C','Escalera C'),
		T_TIPO_DATA('D','Escalera D','Escalera D'),
		T_TIPO_DATA('E','Escalera E','Escalera E'),
		T_TIPO_DATA('F','Escalera F','Escalera F'),
		T_TIPO_DATA('G','Escalera G','Escalera G'),
		T_TIPO_DATA('H','Escalera H','Escalera H'),
		T_TIPO_DATA('I','Escalera I','Escalera I'),
		T_TIPO_DATA('J','Escalera J','Escalera J'),
		T_TIPO_DATA('DR','Escalera Der.','Escalera Der.'),
		T_TIPO_DATA('IZ','Escalera Izq.','Escalera Izq.')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	-- LOOP para insertar los valores -----------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
		 
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			   
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE
				DD_ESE_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
				AND DD_ESE_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||'''
				AND DD_ESE_DESCRIPCION_LARGA = '''||V_TMP_TIPO_DATA(3)||'''';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS = 1 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO]: La '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
					DD_ESE_ID,DD_ESE_CODIGO, DD_ESE_DESCRIPCION,DD_ESE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES(
					'|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
					,'''||V_TMP_TIPO_DATA(1)||''','''||V_TMP_TIPO_DATA(2)||'''
					,'''||V_TMP_TIPO_DATA(3)||''',0,'''||V_ITEM||''',SYSDATE,0)';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
			END IF;
	END LOOP;
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' MODIFICADA CORRECTAMENTE ');
	   
	
	EXCEPTION
	     WHEN OTHERS THEN   
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

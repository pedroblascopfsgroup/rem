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

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_PLN_PLANTA_EDIFICIO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- PARTIDA_PRESUPUESTARIA   DD_TGA_CODIGO  DD_TIM_CODIGO   DD_SCR_CODIGO
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('0','<Ninguna entrada>','<Ninguna entrada>'),
        T_TIPO_DATA('1','1ª Planta','1ª Planta'),
		T_TIPO_DATA('2','2ª Planta','2ª Planta'),
		T_TIPO_DATA('3','3ª Planta','3ª Planta'),
		T_TIPO_DATA('4','4ª Planta','4ª Planta'),
		T_TIPO_DATA('5','5ª Planta','5ª Planta'),
		T_TIPO_DATA('6','6ª Planta','6ª Planta'),
		T_TIPO_DATA('7','7ª Planta','7ª Planta'),
		T_TIPO_DATA('8','8ª Planta','8ª Planta'),
		T_TIPO_DATA('9','9ª Planta','9ª Planta'),
		T_TIPO_DATA('10','10ª Planta','10ª Planta'),
		T_TIPO_DATA('11','11ª Planta','11ª Planta'),
		T_TIPO_DATA('12','12ª Planta','12ª Planta'),
		T_TIPO_DATA('13','13ª Planta','13ª Planta'),
		T_TIPO_DATA('14','14ª Planta','14ª Planta'),
		T_TIPO_DATA('15','15ª Planta','15ª Planta'),
		T_TIPO_DATA('16','16ª Planta','16ª Planta'),
		T_TIPO_DATA('17','17ª Planta','17ª Planta'),
		T_TIPO_DATA('18','18ª Planta','18ª Planta'),
		T_TIPO_DATA('19','19ª Planta','19ª Planta'),
		T_TIPO_DATA('20','20ª Planta','20ª Planta'),
		T_TIPO_DATA('21','21ª Planta','21ª Planta'),
		T_TIPO_DATA('22','22ª Planta','22ª Planta'),
		T_TIPO_DATA('23','23ª Planta','23ª Planta'),
		T_TIPO_DATA('24','24ª Planta','24ª Planta'),
		T_TIPO_DATA('25','25ª Planta','25ª Planta'),
		T_TIPO_DATA('26','26ª Planta','26ª Planta'),
		T_TIPO_DATA('27','27ª Planta','27ª Planta'),
		T_TIPO_DATA('28','28ª Planta','28ª Planta'),
		T_TIPO_DATA('29','29ª Planta','29ª Planta'),
		T_TIPO_DATA('30','30ª Planta','30ª Planta'),
		T_TIPO_DATA('31','31ª Planta','31ª Planta'),
		T_TIPO_DATA('32','32ª Planta','32ª Planta'),
		T_TIPO_DATA('33','33ª Planta','33ª Planta'),
		T_TIPO_DATA('34','34ª Planta','34ª Planta'),
		T_TIPO_DATA('35','35ª Planta','35ª Planta'),
		T_TIPO_DATA('36','36ª Planta','36ª Planta'),
		T_TIPO_DATA('37','37ª Planta','37ª Planta'),
		T_TIPO_DATA('38','38ª Planta','38ª Planta'),
		T_TIPO_DATA('39','39ª Planta','39ª Planta'),
		T_TIPO_DATA('40','40ª Planta','40ª Planta'),
		T_TIPO_DATA('41','41ª Planta','41ª Planta'),
		T_TIPO_DATA('42','42ª Planta','42ª Planta'),
		T_TIPO_DATA('43','43ª Planta','43ª Planta'),
		T_TIPO_DATA('44','44ª Planta','44ª Planta'),
		T_TIPO_DATA('45','45ª Planta','45ª Planta'),
		T_TIPO_DATA('46','46ª Planta','46ª Planta'),
		T_TIPO_DATA('47','47ª Planta','47ª Planta'),
		T_TIPO_DATA('48','48ª Planta','48ª Planta'),
		T_TIPO_DATA('49','49ª Planta','49ª Planta'),
		T_TIPO_DATA('50','50ª Planta','50ª Planta'),
		T_TIPO_DATA('51','51ª Planta','51ª Planta'),
		T_TIPO_DATA('52','52ª Planta','52ª Planta'),
		T_TIPO_DATA('53','53ª Planta','53ª Planta'),
		T_TIPO_DATA('54','54ª Planta','54ª Planta'),
		T_TIPO_DATA('55','55ª Planta','55ª Planta'),
		T_TIPO_DATA('56','56ª Planta','56ª Planta'),
		T_TIPO_DATA('57','57ª Planta','57ª Planta'),
		T_TIPO_DATA('58','58ª Planta','58ª Planta'),
		T_TIPO_DATA('500','Semisotano','Semisotano'),
		T_TIPO_DATA('501','Sótano 1','Sótano 1'),
		T_TIPO_DATA('502','Sótano 2','Sótano 2'),
		T_TIPO_DATA('503','Sótano 3','Sótano 3'),
		T_TIPO_DATA('504','Sótano 4','Sótano 4'),
		T_TIPO_DATA('505','Sótano 5','Sótano 5'),
		T_TIPO_DATA('506','Sótano 6','Sótano 6'),
		T_TIPO_DATA('507','Sótano 7','Sótano 7'),
		T_TIPO_DATA('508','Sótano 8','Sótano 8'),
		T_TIPO_DATA('509','Sótano 9','Sótano 9'),
		T_TIPO_DATA('510','Sótano 10','Sótano 10'),
		T_TIPO_DATA('511','Sótano 11','Sótano 11'),
		T_TIPO_DATA('512','Sótano 12','Sótano 12'),
		T_TIPO_DATA('513','Sótano 13','Sótano 13'),
		T_TIPO_DATA('514','Sótano 14','Sótano 14'),
		T_TIPO_DATA('515','Sótano 15','Sótano 15'),
		T_TIPO_DATA('516','Sótano 16','Sótano 16'),
		T_TIPO_DATA('517','Sótano 17','Sótano 17'),
		T_TIPO_DATA('518','Sótano 18','Sótano 18'),
		T_TIPO_DATA('519','Sótano 19','Sótano 19'),
		T_TIPO_DATA('900','Planta Baja','Planta Baja'),
		T_TIPO_DATA('901','Entresuelo','Entresuelo'),
		T_TIPO_DATA('902','Principal','Principal'),
		T_TIPO_DATA('903','Ático','Ático'),
		T_TIPO_DATA('904','Sobreático','Sobreático'),
		T_TIPO_DATA('905','Terraza','Terraza'),
		T_TIPO_DATA('906','Cubierta','Cubierta'),
		T_TIPO_DATA('907','Exterior','Exterior')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	-- LOOP para insertar los valores -----------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
		 
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			   
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE
				DD_PLN_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
				AND DD_PLN_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||'''
				AND DD_PLN_DESCRIPCION_LARGA = '''||V_TMP_TIPO_DATA(3)||'''';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS = 1 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO]: La '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
					DD_PLN_ID,DD_PLN_CODIGO, DD_PLN_DESCRIPCION,DD_PLN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES(
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

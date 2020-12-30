--/*
--##########################################
--## AUTOR=Josep Ros
--## FECHA_CREACION=20201007
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.7
--## INCIDENCIA_LINK=HREOS-11532
--## PRODUCTO=SI
--## Finalidad: DML para acutalizar en FES_FESTIVOS
--##           
--## INSTRUCCIONES:
--## VERSIONES: 0.1 - Versión Inicial
--##        
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuración Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuración Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el número de la sequencia.

    V_TEXT_TABLA VARCHAR2(40 CHAR) := 'FES_FESTIVOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    --V_TEXT_CHARS VARCHAR2(7 CHAR) := 'VIF'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_TEXT_USU_CREAR_MODIFICAR VARCHAR2(30 CHAR) := '''HREOS-11532'''; -- Vble. auxiliar para almacenar el nombre de usuario que altera los datos de la tabla.


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --	
/*						
         T_TIPO_DATA('2020' ,'8' , '1',  '10'),
         T_TIPO_DATA('2020' ,'8', '15', '16'),
         T_TIPO_DATA('2020' ,'8', '23', '23'),
         T_TIPO_DATA('2020' ,'8', '30', '30')   */
	
	T_TIPO_DATA('2014','1','1','1'),
	T_TIPO_DATA('2014','1','6','6'),
	T_TIPO_DATA('2014','4','18','18'),
	T_TIPO_DATA('2014','5','1','1'),
	T_TIPO_DATA('2014','8','15','15'),
	T_TIPO_DATA('2014','10','12','12'),
	T_TIPO_DATA('2014','11','1','1'),
	T_TIPO_DATA('2014','12','6','6'),
	T_TIPO_DATA('2014','12','8','8'),
	T_TIPO_DATA('2014','12','25','25'),
	T_TIPO_DATA('2015','1','1','1'),
	T_TIPO_DATA('2015','1','6','6'),
	T_TIPO_DATA('2015','4','6','6'),
	T_TIPO_DATA('2015','5','1','1'),
	T_TIPO_DATA('2015','8','15','15'),
	T_TIPO_DATA('2015','10','12','12'),
	T_TIPO_DATA('2015','11','1','1'),
	T_TIPO_DATA('2015','12','6','6'),
	T_TIPO_DATA('2015','12','8','8'),
	T_TIPO_DATA('2015','12','25','25'),
	T_TIPO_DATA('2016','1','3','3'),
	T_TIPO_DATA('2016','1','10','10'),
	T_TIPO_DATA('2016','1','17','17'),
	T_TIPO_DATA('2016','1','24','24'),
	T_TIPO_DATA('2016','1','31','31'),
	T_TIPO_DATA('2016','2','7','7'),
	T_TIPO_DATA('2016','2','14','14'),
	T_TIPO_DATA('2016','2','21','21'),
	T_TIPO_DATA('2016','2','28','28'),
	T_TIPO_DATA('2016','3','6','6'),
	T_TIPO_DATA('2016','3','13','13'),
	T_TIPO_DATA('2016','3','20','20'),
	T_TIPO_DATA('2016','3','27','27'),
	T_TIPO_DATA('2016','4','3','3'),
	T_TIPO_DATA('2016','4','10','10'),
	T_TIPO_DATA('2016','4','17','17'),
	T_TIPO_DATA('2016','4','24','24'),
	T_TIPO_DATA('2016','5','1','1'),
	T_TIPO_DATA('2016','5','8','8'),
	T_TIPO_DATA('2016','5','15','15'),
	T_TIPO_DATA('2016','5','22','22'),
	T_TIPO_DATA('2016','5','29','29'),
	T_TIPO_DATA('2016','6','5','5'),
	T_TIPO_DATA('2016','6','12','12'),
	T_TIPO_DATA('2016','6','19','19'),
	T_TIPO_DATA('2016','6','26','26'),
	T_TIPO_DATA('2016','7','3','3'),
	T_TIPO_DATA('2016','7','10','10'),
	T_TIPO_DATA('2016','7','17','17'),
	T_TIPO_DATA('2016','7','24','24'),
	T_TIPO_DATA('2016','7','31','31'),
	T_TIPO_DATA('2016','9','4','4'),
	T_TIPO_DATA('2016','9','11','11'),
	T_TIPO_DATA('2016','9','18','18'),
	T_TIPO_DATA('2016','9','25','25'),
	T_TIPO_DATA('2016','10','2','2'),
	T_TIPO_DATA('2016','10','9','9'),
	T_TIPO_DATA('2016','10','16','16'),
	T_TIPO_DATA('2016','10','23','23'),
	T_TIPO_DATA('2016','10','30','30'),
	T_TIPO_DATA('2016','11','6','6'),
	T_TIPO_DATA('2016','11','13','13'),
	T_TIPO_DATA('2016','11','20','20'),
	T_TIPO_DATA('2016','11','27','27'),
	T_TIPO_DATA('2016','12','4','4'),
	T_TIPO_DATA('2016','12','11','11'),
	T_TIPO_DATA('2016','12','18','18'),
	T_TIPO_DATA('2016','12','25','25'),
	T_TIPO_DATA('2016','8','1','1'),
	T_TIPO_DATA('2017','1','1','1'),
	T_TIPO_DATA('2017','1','8','8'),
	T_TIPO_DATA('2017','1','15','15'),
	T_TIPO_DATA('2017','1','22','22'),
	T_TIPO_DATA('2017','1','29','29'),
	T_TIPO_DATA('2017','2','5','5'),
	T_TIPO_DATA('2017','2','12','12'),
	T_TIPO_DATA('2017','2','19','19'),
	T_TIPO_DATA('2017','2','26','26'),
	T_TIPO_DATA('2017','3','5','5'),
	T_TIPO_DATA('2017','3','12','12'),
	T_TIPO_DATA('2017','3','19','19'),
	T_TIPO_DATA('2017','3','26','26'),
	T_TIPO_DATA('2017','4','2','2'),
	T_TIPO_DATA('2017','4','9','9'),
	T_TIPO_DATA('2017','4','16','16'),
	T_TIPO_DATA('2017','4','23','23'),
	T_TIPO_DATA('2017','4','30','30'),
	T_TIPO_DATA('2017','5','7','7'),
	T_TIPO_DATA('2017','5','14','14'),
	T_TIPO_DATA('2017','5','21','21'),
	T_TIPO_DATA('2017','5','28','28'),
	T_TIPO_DATA('2017','6','4','4'),
	T_TIPO_DATA('2017','6','11','11'),
	T_TIPO_DATA('2017','6','18','18'),
	T_TIPO_DATA('2017','6','25','25'),
	T_TIPO_DATA('2017','7','2','2'),
	T_TIPO_DATA('2017','7','9','9'),
	T_TIPO_DATA('2017','7','16','16'),
	T_TIPO_DATA('2017','7','23','23'),
	T_TIPO_DATA('2017','7','30','30'),
	T_TIPO_DATA('2017','9','3','3'),
	T_TIPO_DATA('2017','9','10','10'),
	T_TIPO_DATA('2017','9','17','17'),
	T_TIPO_DATA('2017','9','24','24'),
	T_TIPO_DATA('2017','10','1','1'),
	T_TIPO_DATA('2017','10','8','8'),
	T_TIPO_DATA('2017','10','15','15'),
	T_TIPO_DATA('2017','10','22','22'),
	T_TIPO_DATA('2017','10','29','29'),
	T_TIPO_DATA('2017','11','5','5'),
	T_TIPO_DATA('2017','11','12','12'),
	T_TIPO_DATA('2017','11','19','19'),
	T_TIPO_DATA('2017','11','26','26'),
	T_TIPO_DATA('2017','12','3','3'),
	T_TIPO_DATA('2017','12','10','10'),
	T_TIPO_DATA('2017','12','17','17'),
	T_TIPO_DATA('2017','12','24','24'),
	T_TIPO_DATA('2017','12','31','31'),
	T_TIPO_DATA('2017','8','1','31'),
	T_TIPO_DATA('2018','1','7','7'),
	T_TIPO_DATA('2018','1','14','14'),
	T_TIPO_DATA('2018','1','21','21'),
	T_TIPO_DATA('2018','1','28','28'),
	T_TIPO_DATA('2018','1','1','1'),
	T_TIPO_DATA('2018','1','6','6'),
	T_TIPO_DATA('2018','2','4','4'),
	T_TIPO_DATA('2018','2','11','11'),
	T_TIPO_DATA('2018','2','18','18'),
	T_TIPO_DATA('2018','2','25','25'),
	T_TIPO_DATA('2018','3','4','4'),
	T_TIPO_DATA('2018','3','11','11'),
	T_TIPO_DATA('2018','3','18','18'),
	T_TIPO_DATA('2018','3','25','25'),
	T_TIPO_DATA('2018','3','30','30'),
	T_TIPO_DATA('2018','4','1','1'),
	T_TIPO_DATA('2018','4','8','8'),
	T_TIPO_DATA('2018','4','15','15'),
	T_TIPO_DATA('2018','4','22','22'),
	T_TIPO_DATA('2018','4','29','29'),
	T_TIPO_DATA('2018','5','6','6'),
	T_TIPO_DATA('2018','5','13','13'),
	T_TIPO_DATA('2018','5','20','20'),
	T_TIPO_DATA('2018','5','27','27'),
	T_TIPO_DATA('2018','5','1','1'),
	T_TIPO_DATA('2018','6','3','3'),
	T_TIPO_DATA('2018','6','10','10'),
	T_TIPO_DATA('2018','6','17','17'),
	T_TIPO_DATA('2018','6','24','24'),
	T_TIPO_DATA('2018','7','1','1'),
	T_TIPO_DATA('2018','7','8','8'),
	T_TIPO_DATA('2018','7','15','15'),
	T_TIPO_DATA('2018','7','22','22'),
	T_TIPO_DATA('2018','7','29','29'),
	T_TIPO_DATA('2018','8','1','31'),
	T_TIPO_DATA('2018','9','2','2'),
	T_TIPO_DATA('2018','9','9','9'),
	T_TIPO_DATA('2018','9','16','16'),
	T_TIPO_DATA('2018','9','23','23'),
	T_TIPO_DATA('2018','9','30','30'),
	T_TIPO_DATA('2018','10','7','7'),
	T_TIPO_DATA('2018','10','14','14'),
	T_TIPO_DATA('2018','10','21','21'),
	T_TIPO_DATA('2018','10','28','28'),
	T_TIPO_DATA('2018','10','12','12'),
	T_TIPO_DATA('2018','11','4','4'),
	T_TIPO_DATA('2018','11','11','11'),
	T_TIPO_DATA('2018','11','18','18'),
	T_TIPO_DATA('2018','11','25','25'),
	T_TIPO_DATA('2018','11','1','1'),
	T_TIPO_DATA('2018','12','2','2'),
	T_TIPO_DATA('2018','12','9','9'),
	T_TIPO_DATA('2018','12','16','16'),
	T_TIPO_DATA('2018','12','23','23'),
	T_TIPO_DATA('2018','12','30','30'),
	T_TIPO_DATA('2018','12','6','6'),
	T_TIPO_DATA('2018','12','8','8'),
	T_TIPO_DATA('2018','12','25','25'),
	T_TIPO_DATA('2019','1','6','6'),
	T_TIPO_DATA('2019','1','13','13'),
	T_TIPO_DATA('2019','1','20','20'),
	T_TIPO_DATA('2019','1','27','27'),
	T_TIPO_DATA('2019','1','1','1'),
	T_TIPO_DATA('2019','2','3','3'),
	T_TIPO_DATA('2019','2','10','10'),
	T_TIPO_DATA('2019','2','17','17'),
	T_TIPO_DATA('2019','2','24','24'),
	T_TIPO_DATA('2019','3','3','3'),
	T_TIPO_DATA('2019','3','10','10'),
	T_TIPO_DATA('2019','3','17','17'),
	T_TIPO_DATA('2019','3','24','24'),
	T_TIPO_DATA('2019','3','31','31'),
	T_TIPO_DATA('2019','4','7','7'),
	T_TIPO_DATA('2019','4','14','14'),
	T_TIPO_DATA('2019','4','21','21'),
	T_TIPO_DATA('2019','4','28','28'),
	T_TIPO_DATA('2019','4','19','19'),
	T_TIPO_DATA('2019','5','5','5'),
	T_TIPO_DATA('2019','5','12','12'),
	T_TIPO_DATA('2019','5','19','19'),
	T_TIPO_DATA('2019','5','26','26'),
	T_TIPO_DATA('2019','5','1','1'),
	T_TIPO_DATA('2019','6','2','2'),
	T_TIPO_DATA('2019','6','9','9'),
	T_TIPO_DATA('2019','6','16','16'),
	T_TIPO_DATA('2019','6','23','23'),
	T_TIPO_DATA('2019','6','30','30'),
	T_TIPO_DATA('2019','7','7','7'),
	T_TIPO_DATA('2019','7','14','14'),
	T_TIPO_DATA('2019','7','21','21'),
	T_TIPO_DATA('2019','7','28','28'),
	T_TIPO_DATA('2019','8','1','31'),
	T_TIPO_DATA('2019','9','1','1'),
	T_TIPO_DATA('2019','9','8','8'),
	T_TIPO_DATA('2019','9','15','15'),
	T_TIPO_DATA('2019','9','22','22'),
	T_TIPO_DATA('2019','9','29','29'),
	T_TIPO_DATA('2019','10','6','6'),
	T_TIPO_DATA('2019','10','13','13'),
	T_TIPO_DATA('2019','10','20','20'),
	T_TIPO_DATA('2019','10','27','27'),
	T_TIPO_DATA('2019','10','12','12'),
	T_TIPO_DATA('2019','11','3','3'),
	T_TIPO_DATA('2019','11','10','10'),
	T_TIPO_DATA('2019','11','17','17'),
	T_TIPO_DATA('2019','11','24','24'),
	T_TIPO_DATA('2019','11','1','1'),
	T_TIPO_DATA('2019','12','1','1'),
	T_TIPO_DATA('2019','12','8','8'),
	T_TIPO_DATA('2019','12','15','15'),
	T_TIPO_DATA('2019','12','22','22'),
	T_TIPO_DATA('2019','12','29','29'),
	T_TIPO_DATA('2019','12','6','6'),
	T_TIPO_DATA('2019','12','25','25'),
	T_TIPO_DATA('2020','1','1','1'),
	T_TIPO_DATA('2020','1','5','5'),
	T_TIPO_DATA('2020','1','6','6'),
	T_TIPO_DATA('2020','1','12','12'),
	T_TIPO_DATA('2020','1','19','19'),
	T_TIPO_DATA('2020','1','26','26'),
	T_TIPO_DATA('2020','2','2','2'),
	T_TIPO_DATA('2020','2','9','9'),
	T_TIPO_DATA('2020','2','16','16'),
	T_TIPO_DATA('2020','2','23','23'),
	T_TIPO_DATA('2020','3','1','1'),
	T_TIPO_DATA('2020','3','8','8'),
	T_TIPO_DATA('2020','3','15','15'),
	T_TIPO_DATA('2020','3','22','22'),
	T_TIPO_DATA('2020','3','29','29'),
	T_TIPO_DATA('2020','4','5','5'),
	T_TIPO_DATA('2020','4','10','10'),
	T_TIPO_DATA('2020','4','12','12'),
	T_TIPO_DATA('2020','4','19','19'),
	T_TIPO_DATA('2020','4','26','26'),
	T_TIPO_DATA('2020','5','1','1'),
	T_TIPO_DATA('2020','5','3','3'),
	T_TIPO_DATA('2020','5','10','10'),
	T_TIPO_DATA('2020','5','17','17'),
	T_TIPO_DATA('2020','5','24','24'),
	T_TIPO_DATA('2020','5','31','31'),
	T_TIPO_DATA('2020','6','7','7'),
	T_TIPO_DATA('2020','6','14','14'),
	T_TIPO_DATA('2020','6','21','21'),
	T_TIPO_DATA('2020','6','28','28'),
	T_TIPO_DATA('2020','7','5','5'),
	T_TIPO_DATA('2020','7','12','12'),
	T_TIPO_DATA('2020','7','19','19'),
	T_TIPO_DATA('2020','7','26','26'),
	T_TIPO_DATA('2020','8','1','10'),
	T_TIPO_DATA('2020','9','6','6'),
	T_TIPO_DATA('2020','9','13','13'),
	T_TIPO_DATA('2020','9','20','20'),
	T_TIPO_DATA('2020','9','27','27'),
	T_TIPO_DATA('2020','10','4','4'),
	T_TIPO_DATA('2020','10','11','11'),
	T_TIPO_DATA('2020','10','12','12'),
	T_TIPO_DATA('2020','10','18','18'),
	T_TIPO_DATA('2020','10','25','25'),
	T_TIPO_DATA('2020','11','1','1'),
	T_TIPO_DATA('2020','11','2','2'),
	T_TIPO_DATA('2020','11','8','8'),
	T_TIPO_DATA('2020','11','15','15'),
	T_TIPO_DATA('2020','11','22','22'),
	T_TIPO_DATA('2020','11','29','29'),
	T_TIPO_DATA('2020','12','6','6'),
	T_TIPO_DATA('2020','12','7','7'),
	T_TIPO_DATA('2020','12','8','8'),
	T_TIPO_DATA('2020','12','13','13'),
	T_TIPO_DATA('2020','12','20','20'),
	T_TIPO_DATA('2020','12','25','25'),
	T_TIPO_DATA('2020','12','27','27'),
	T_TIPO_DATA('2020','8','15','16'),
	T_TIPO_DATA('2020','8','23','23'),
	T_TIPO_DATA('2020','8','30','30')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	


	DBMS_OUTPUT.PUT_LINE('[INICIO]');

  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS = 1 THEN

    DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'... Existe.');
	
	
    -- LOOP para insertar los valores
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE FES_YEAR = '''||V_TMP_TIPO_DATA(1)||'''   AND FES_MONTH = '''||V_TMP_TIPO_DATA(2)||''' AND FES_DAY_START= '''||V_TMP_TIPO_DATA(3)||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN				
          -- Si existe se modifica.
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| V_TMP_TIPO_DATA(1) ||'''');
          
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '|| 'SET 
					   FES_DAY_END = '''||V_TMP_TIPO_DATA(4)||''''|| 
					', USUARIOMODIFICAR = '||V_TEXT_USU_CREAR_MODIFICAR||''||
					', FECHAMODIFICAR = SYSDATE '||
					'WHERE FES_YEAR = '''||V_TMP_TIPO_DATA(1)||'''   AND FES_MONTH = '''||V_TMP_TIPO_DATA(2)||''' AND FES_DAY_START= '''||V_TMP_TIPO_DATA(3)||''' ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      ' FES_ID,
					   FES_YEAR,
					   FES_MONTH,
					   FES_DAY_START,
				       FES_DAY_END,
                       VERSION, 
                       USUARIOCREAR, 
                       FECHACREAR, 
                       BORRADO) ' ||
                      'SELECT 
                      '|| V_ID || ', 
                      '''||V_TMP_TIPO_DATA(1)||''',
                      '''||V_TMP_TIPO_DATA(2)||'''
                      ,'''||V_TMP_TIPO_DATA(3)||'''
                      ,'''||V_TMP_TIPO_DATA(4)||'''
                      ,0
                      , '||V_TEXT_USU_CREAR_MODIFICAR||'
                      ,SYSDATE
                      ,0 FROM DUAL';    
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

       END IF;
      END LOOP;
    END IF;
     
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

    COMMIT;


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


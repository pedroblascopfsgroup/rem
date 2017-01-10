--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20170104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1289
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en GRF_CRA_PRO los datos añadidos de T_ARRAY_DATA
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'GRF_CRA_PRO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    -- V_TRES_LETRAS_TABLA VARCHAR2(2400 CHAR) := 'GRF'; -- Vble. auxiliar para almacenar el sufijo de los campos de la tabla de ref.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(2500);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		-- DD_GRF_CODIGO, DD_CRA_CODIGO, CMA.DD_CMA_CODIGO, PRV.DD_PRV_CODIGO 
		-- Cartera 02 
		T_TIPO_DATA('7','02','01','41'),
		T_TIPO_DATA('7','02','01','29'),
		T_TIPO_DATA('7','02','01','23'),
		T_TIPO_DATA('7','02','01','4'),
		T_TIPO_DATA('7','02','01','21'),
		T_TIPO_DATA('7','02','01','18'),
		T_TIPO_DATA('7','02','01','14'),
		T_TIPO_DATA('7','02','01','11'),
		T_TIPO_DATA('6','02','02','22'),
		T_TIPO_DATA('6','02','02','44'),
		T_TIPO_DATA('6','02','02','50'),
		T_TIPO_DATA('6','02','03','33'),
		T_TIPO_DATA('6','02','04','7'),
		T_TIPO_DATA('6','02','05','35'),
		T_TIPO_DATA('6','02','05','38'),
		T_TIPO_DATA('6','02','06','39'),
		T_TIPO_DATA('6','02','07','5'),
		T_TIPO_DATA('6','02','07','37'),
		T_TIPO_DATA('6','02','07','34'),
		T_TIPO_DATA('6','02','07','9'),
		T_TIPO_DATA('6','02','07','47'),
		T_TIPO_DATA('6','02','07','40'),
		T_TIPO_DATA('6','02','07','42'),
		T_TIPO_DATA('6','02','07','24'),
		T_TIPO_DATA('6','02','07','49'),
		T_TIPO_DATA('6','02','08','2'),
		T_TIPO_DATA('6','02','08','16'),
		T_TIPO_DATA('6','02','08','45'),
		T_TIPO_DATA('6','02','08','13'),
		T_TIPO_DATA('6','02','08','19'),
		T_TIPO_DATA('7','02','09','17'),
		T_TIPO_DATA('7','02','09','43'),
		T_TIPO_DATA('7','02','09','25'),
		T_TIPO_DATA('7','02','09','8'),
		T_TIPO_DATA('6','02','10','3'),
		T_TIPO_DATA('6','02','10','12'),
		T_TIPO_DATA('6','02','10','46'),
		T_TIPO_DATA('6','02','11','10'),
		T_TIPO_DATA('6','02','11','6'),
		T_TIPO_DATA('6','02','12','36'),
		T_TIPO_DATA('6','02','12','27'),
		T_TIPO_DATA('6','02','12','15'),
		T_TIPO_DATA('6','02','12','32'),
		T_TIPO_DATA('7','02','13','28'),
		T_TIPO_DATA('6','02','14','30'),
		T_TIPO_DATA('6','02','15','31'),
		T_TIPO_DATA('6','02','16','20'),
		T_TIPO_DATA('6','02','16','1'),
		T_TIPO_DATA('6','02','16','48'),
		T_TIPO_DATA('7','02','17','26'),
		T_TIPO_DATA('7','02','18','51'),
		T_TIPO_DATA('No definido','02','19','52'),
		-- Cartera 03 
		T_TIPO_DATA('1','03','01','41'),
		T_TIPO_DATA('1','03','01','29'),
		T_TIPO_DATA('1','03','01','23'),
		T_TIPO_DATA('1','03','01','4'),
		T_TIPO_DATA('1','03','01','21'),
		T_TIPO_DATA('1','03','01','18'),
		T_TIPO_DATA('1','03','01','14'),
		T_TIPO_DATA('1','03','01','11'),
		T_TIPO_DATA('2','03','02','22'),
		T_TIPO_DATA('2','03','02','44'),
		T_TIPO_DATA('2','03','02','50'),
		T_TIPO_DATA('2','03','03','33'),
		T_TIPO_DATA('3','03','04','7'),
		T_TIPO_DATA('3','03','05','35'),
		T_TIPO_DATA('3','03','05','38'),
		T_TIPO_DATA('2','03','06','39'),
		T_TIPO_DATA('3','03','07','5'),
		T_TIPO_DATA('3','03','07','37'),
		T_TIPO_DATA('3','03','07','34'),
		T_TIPO_DATA('3','03','07','9'),
		T_TIPO_DATA('3','03','07','47'),
		T_TIPO_DATA('3','03','07','40'),
		T_TIPO_DATA('3','03','07','42'),
		T_TIPO_DATA('3','03','07','24'),
		T_TIPO_DATA('3','03','07','49'),
		T_TIPO_DATA('2','03','08','2'),
		T_TIPO_DATA('2','03','08','16'),
		T_TIPO_DATA('2','03','08','45'),
		T_TIPO_DATA('2','03','08','13'),
		T_TIPO_DATA('2','03','08','19'),
		T_TIPO_DATA('4','03','09','17'),
		T_TIPO_DATA('4','03','09','43'),
		T_TIPO_DATA('4','03','09','25'),
		T_TIPO_DATA('4','03','09','8'),
		T_TIPO_DATA('5','03','10','3'),
		T_TIPO_DATA('2','03','10','12'), -- Castellon
		T_TIPO_DATA('5','03','10','46'),
		T_TIPO_DATA('2','03','11','10'),
		T_TIPO_DATA('2','03','11','6'),
		T_TIPO_DATA('2','03','12','36'),
		T_TIPO_DATA('2','03','12','27'),
		T_TIPO_DATA('2','03','12','15'),
		T_TIPO_DATA('2','03','12','32'),
		T_TIPO_DATA('1','03','13','28'),
		T_TIPO_DATA('4','03','14','30'),
		T_TIPO_DATA('2','03','15','31'),
		T_TIPO_DATA('2','03','16','20'),
		T_TIPO_DATA('2','03','16','1'),
		T_TIPO_DATA('2','03','16','48'),
		T_TIPO_DATA('2','03','17','26'),
		T_TIPO_DATA('1','03','18','51'),
		T_TIPO_DATA('No definido','03','19','52')
			); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	
	V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'';
	EXECUTE IMMEDIATE V_MSQL;	
	 
	-- LOOP para insertar los valores en la tabla indicada
    	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||'] ');
    	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      	LOOP
             	V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
	        --Comprobamos el dato a insertar
        	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_GRF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''' ||
			' AND DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''' ||
			' AND DD_CMA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''' ||			
			' AND DD_PRV_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''';
        	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
	        --Si existe lo modificamos
        	IF V_NUM_TABLAS > 0 THEN				
				DBMS_OUTPUT.PUT_LINE('[ALERT]: REGISTRO YA INCLUIDO ANTERIORMENTE. -> DD_GRF_CODIGO = ['||TRIM(V_TMP_TIPO_DATA(1))||'], DD_CRA_CODIGO = ['||TRIM(V_TMP_TIPO_DATA(2))||'], DD_CMA_CODIGO = ['||TRIM(V_TMP_TIPO_DATA(3))||'], DD_PRV_CODIGO = ['||TRIM(V_TMP_TIPO_DATA(4))||'].'); 
			--Si no existe, lo insertamos   
       		ELSE
       			-- No hace falta secuencia.
          		-- V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
			-- EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      		'DD_GRF_CODIGO, DD_CRA_CODIGO, DD_CMA_CODIGO, DD_PRV_CODIGO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      		'SELECT '''||TRIM(V_TMP_TIPO_DATA(1))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','||
                      		'0, ''DML'',SYSDATE,0 FROM DUAL';
				DBMS_OUTPUT.PUT_LINE(V_MSQL);
          		EXECUTE IMMEDIATE V_MSQL;
          		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE. -> DD_GRF_CODIGO = ['||TRIM(V_TMP_TIPO_DATA(1))||'], DD_CRA_CODIGO = ['||TRIM(V_TMP_TIPO_DATA(2))||'], DD_CMA_CODIGO = ['||TRIM(V_TMP_TIPO_DATA(3))||'], DD_PRV_CODIGO = ['||TRIM(V_TMP_TIPO_DATA(4))||'].');
        	END IF;
      	END LOOP;
    	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
  
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


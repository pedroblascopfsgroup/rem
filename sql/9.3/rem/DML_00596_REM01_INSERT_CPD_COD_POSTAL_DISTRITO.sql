--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210514
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14035
--## PRODUCTO=NO
--## 
--## Finalidad: Script que añade los registros en la CPD_COD_POSTAL_DISTRITO
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

    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-13993';

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --COD_POSTAL    COD_DICCIONARIO
        T_TIPO_DATA('01207', '1'),
        T_TIPO_DATA('08001', '1'),
        T_TIPO_DATA('08002', '1'),
        T_TIPO_DATA('08003', '1'),
        T_TIPO_DATA('08004', '9'),
        T_TIPO_DATA('08005', '8'),
        T_TIPO_DATA('08006', '10'),
        T_TIPO_DATA('08007', '2'),
        T_TIPO_DATA('08008', '2'),
        T_TIPO_DATA('08009', '2'),
        T_TIPO_DATA('08010', '2'),
        T_TIPO_DATA('08011', '2'),
        T_TIPO_DATA('08012', '3'),
        T_TIPO_DATA('08013', '2'),
        T_TIPO_DATA('08014', '9'),
        T_TIPO_DATA('08015', '2'),
        T_TIPO_DATA('08016', '4'),
        T_TIPO_DATA('08017', '10'),
        T_TIPO_DATA('08018', '8'),
        T_TIPO_DATA('08019', '8'),
        T_TIPO_DATA('08020', '8'),
        T_TIPO_DATA('08021', '10'),
        T_TIPO_DATA('08022', '10'),
        T_TIPO_DATA('08023', '10'),
        T_TIPO_DATA('08024', '3'),
        T_TIPO_DATA('08025', '2'),
        T_TIPO_DATA('08026', '8'),
        T_TIPO_DATA('08027', '8'),
        T_TIPO_DATA('08028', '9'),
        T_TIPO_DATA('08028', '5'),
        T_TIPO_DATA('08029', '2'),
        T_TIPO_DATA('08029', '5'),
        T_TIPO_DATA('08030', '7'),
        T_TIPO_DATA('08031', '4'),
        T_TIPO_DATA('08032', '4'),
        T_TIPO_DATA('08033', '6'),
        T_TIPO_DATA('08034', '10'),
        T_TIPO_DATA('08035', '4'),
        T_TIPO_DATA('08036', '2'),
        T_TIPO_DATA('08037', '2'),
        T_TIPO_DATA('08038', '9'),
        T_TIPO_DATA('08041', '4'),
        T_TIPO_DATA('08042', '6'),
        T_TIPO_DATA('28001', '26'),
        T_TIPO_DATA('28002', '16'),
        T_TIPO_DATA('28003', '15'),
        T_TIPO_DATA('28003', '17'),
        T_TIPO_DATA('28004', '15'),
        T_TIPO_DATA('28005', '11'),
        T_TIPO_DATA('28005', '15'),
        T_TIPO_DATA('28006', '26'),
        T_TIPO_DATA('28007', '11'),
        T_TIPO_DATA('28007', '25'),
        T_TIPO_DATA('28008', '15'),
        T_TIPO_DATA('28008', '22'),
        T_TIPO_DATA('28009', '25'),
        T_TIPO_DATA('28010', '17'),
        T_TIPO_DATA('28011', '21'),
        T_TIPO_DATA('28011', '22'),
        T_TIPO_DATA('28012', '11'),
        T_TIPO_DATA('28012', '15'),
        T_TIPO_DATA('28013', '15'),
        T_TIPO_DATA('28014', '15'),
        T_TIPO_DATA('28014', '25'),
        T_TIPO_DATA('28015', '17'),
        T_TIPO_DATA('28016', '16'),
        T_TIPO_DATA('28017', '18'),
        T_TIPO_DATA('28018', '24'),
        T_TIPO_DATA('28019', '14'),
        T_TIPO_DATA('28020', '27'),
        T_TIPO_DATA('28021', '31'),
        T_TIPO_DATA('28022', '13'),
        T_TIPO_DATA('28023', '22'),
        T_TIPO_DATA('28024', '21'),
        T_TIPO_DATA('28025', '14'),
        T_TIPO_DATA('28026', '28'),
        T_TIPO_DATA('28027', '18'),
        T_TIPO_DATA('28028', '26'),
        T_TIPO_DATA('28029', '27'),
        T_TIPO_DATA('28029', '19'),
        T_TIPO_DATA('28030', '23'),
        T_TIPO_DATA('28031', '30'),
        T_TIPO_DATA('28032', '29'),
        T_TIPO_DATA('28033', '18'),
        T_TIPO_DATA('28033', '20'),
        T_TIPO_DATA('28034', '19'),
        T_TIPO_DATA('28035', '19'),
        T_TIPO_DATA('28036', '16'),
        T_TIPO_DATA('28037', '13'),
        T_TIPO_DATA('28038', '24'),
        T_TIPO_DATA('28039', '27'),
        T_TIPO_DATA('28040', '22'),
        T_TIPO_DATA('28041', '28'),
        T_TIPO_DATA('28042', '20'),
        T_TIPO_DATA('28042', '12'),
        T_TIPO_DATA('28043', '18'),
        T_TIPO_DATA('28043', '20'),
        T_TIPO_DATA('28044', '21'),
        T_TIPO_DATA('28045', '11'),
        T_TIPO_DATA('28046', '16'),
        T_TIPO_DATA('28047', '21'),
        T_TIPO_DATA('28048', '19'),
        T_TIPO_DATA('28049', '19'),
        T_TIPO_DATA('28050', '20'),
        T_TIPO_DATA('28051', '30'),
        T_TIPO_DATA('28052', '29'),
        T_TIPO_DATA('28053', '24'),
        T_TIPO_DATA('28054', '14'),
        T_TIPO_DATA('28055', '20')



		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en CPD_COD_POSTAL_DISTRITO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CPD_COD_POSTAL_DISTRITO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.CPD_COD_POSTAL_DISTRITO WHERE CPD_COD_POSTAL = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
                  AND DD_DIC_ID = (SELECT DD_DIC_ID FROM '||V_ESQUEMA||'.DD_DIC_DISTRITO_CAIXA WHERE DD_DIC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
	
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN			   
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: EL REGISTRO YA EXISTE '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CPD_COD_POSTAL_DISTRITO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CPD_COD_POSTAL_DISTRITO (' ||
                      'CPD_ID, CPD_COD_POSTAL, DD_DIC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ',
                      '''||V_TMP_TIPO_DATA(1)||''',
                      '||'(SELECT DD_DIC_ID FROM '||V_ESQUEMA||'.DD_DIC_DISTRITO_CAIXA WHERE DD_DIC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),
                       0,
                       '''||V_USUARIO||''',
                       SYSDATE,
                       0 
                       FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SCR_SUBCARTERA ACTUALIZADO CORRECTAMENTE ');
   

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
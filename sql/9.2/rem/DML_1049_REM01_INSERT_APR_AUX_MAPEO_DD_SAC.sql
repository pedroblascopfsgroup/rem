--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20191129
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5757
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en APR_AUX_MAPEO_DD_SAC los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Actualizar registros
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_MAPEO_DD_SAC'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar el id del registro
	V_USUARIO_CREAR VARCHAR2(20 CHAR) := 'REMVIP-5757'; -- Vble. auxiliar para almacenar el usuario crear
    V_USUARIO_MODIFICAR VARCHAR2(20 CHAR) := 'REMVIP-5757'; -- Vble. auxiliar para almacenar el usuario modificar	
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
	
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		  --T_TIPO_DATA('DD_CODIGO_SUBTIPO_REC','DD_CODIGO_TIPO_REM','DD_CODIGO_SUBTIPO_REM')
		T_TIPO_DATA('0904',	'02',	'09'),
		T_TIPO_DATA('0905',	'02',	'05'),
		T_TIPO_DATA('0906',	'02',	'08'),
		T_TIPO_DATA('0907',	'02',	'06'),
		T_TIPO_DATA('0908',	'05',	'21'),
		T_TIPO_DATA('0909',	'03',	'14'),
		T_TIPO_DATA('0910',	'03',	'14'),
		T_TIPO_DATA('0911',	'05',	'22'),
		T_TIPO_DATA('0912',	'03',	'13'),
		T_TIPO_DATA('0913',	'03',	'13'),
		T_TIPO_DATA('0914',	'03',	'13'),
		T_TIPO_DATA('0915',	'04',	'17'),
		T_TIPO_DATA('0916',	'04',	'18'),
		T_TIPO_DATA('0917',	'04',	'17'),
		T_TIPO_DATA('0918',	'04',	'37'),
		T_TIPO_DATA('0919',	'05',	'20'),
		T_TIPO_DATA('0920',	'03',	'16'),
		T_TIPO_DATA('0921',	'03',	'16'),
		T_TIPO_DATA('0922',	'03',	'16'),
		T_TIPO_DATA('0923',	'03',	'16'),
		T_TIPO_DATA('0924',	'01',	'27'),
		T_TIPO_DATA('0925',	'07',	'24'),
		T_TIPO_DATA('0926',	'07',	'25'),
		T_TIPO_DATA('0927',	'06',	'23'),
		T_TIPO_DATA('0928',	'01',	'04'),
		T_TIPO_DATA('0929',	'03',	'28'),
		T_TIPO_DATA('0930',	'03',	'29'),
		T_TIPO_DATA('0931',	'07',	'38'),
		T_TIPO_DATA('0932',	'08',	'30'),
		T_TIPO_DATA('0933',	'08',	'31'),
		T_TIPO_DATA('0934',	'08',	'32'),
		T_TIPO_DATA('0935',	'09',	'33'),
		T_TIPO_DATA('0936',	'08',	'34'),
		T_TIPO_DATA('0937',	'07',	'35'),
		T_TIPO_DATA('0938',	'05',	'24'),
		T_TIPO_DATA('0939',	'08',	'39'),
		T_TIPO_DATA('0940',	'07',	'26'),
		T_TIPO_DATA('0941',	'07',	'36'),
		T_TIPO_DATA('0942',	'02',	'12'),
		T_TIPO_DATA('0943',	'08',	'30'),
		T_TIPO_DATA('0946',	'04',	'17'),
		T_TIPO_DATA('0947',	'04',	'18'),
		T_TIPO_DATA('0948',	'04',	'17'),
		T_TIPO_DATA('0949',	'03',	'13'),
		T_TIPO_DATA('0950',	'03',	'13'),
		T_TIPO_DATA('0951',	'03',	'13')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en APR_AUX_MAPEO_DD_SAC -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);    
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
	    V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
	    --Comprobamos el dato a insertar
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_CODIGO_SUBTIPO_REC = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		--Si existe lo modificamos
		IF V_NUM_TABLAS > 0 THEN				
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       		
       		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'                        
                    SET DD_CODIGO_SUBTIPO_REM = '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''', 
						DD_CODIGO_TIPO_REM = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', 
                       	USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||''',
					   	FECHAMODIFICAR = SYSDATE
					WHERE DD_CODIGO_SUBTIPO_REC = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
					
       		EXECUTE IMMEDIATE V_MSQL;
          	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
		  
		--Si no existe, lo insertamos   
		ELSE       
	      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(3)) ||'''');     
	      
	      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
			   			DD_MSA_ID, 
						DD_CODIGO_SUBTIPO_REC, 
						DD_CODIGO_SUBTIPO_REM, 
						DD_CODIGO_TIPO_REM, 
						VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					   SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL, 
					   '''||V_TMP_TIPO_DATA(1)||''' ,
					   '''||V_TMP_TIPO_DATA(3)||''' ,
					   '''||TRIM(V_TMP_TIPO_DATA(2))||''' ,					   
					   0,'''|| V_USUARIO_CREAR ||''',SYSDATE,0 FROM DUAL';
	      EXECUTE IMMEDIATE V_MSQL;
	      
	      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');	      
		 END IF;
		 
      END LOOP;
      
   COMMIT;    
   DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT



   
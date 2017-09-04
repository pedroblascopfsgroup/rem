--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20170904
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK= HREOS-2745
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SCR_SUBCARTERA los datos añadidos en T_ARRAY_DATA
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

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --DD_SCR_CODIGO, DD_SCR_DESCRIPCION, DD_SCR_DESCRIPCION_LARGA, DD_CRA_CODIGO
    --cajamar
    T_TIPO_DATA('01' ,'FINANCIERO'	,'FINANCIERO'	,'01'),
    T_TIPO_DATA('02' ,'INMOBILIARIO'	,'INMOBILIARIO'	,'01'),
    --sareb
    T_TIPO_DATA('03' ,'FINANCIERO'	,'FINANCIERO'	,'02'),
    T_TIPO_DATA('04' ,'INMOBILIARIO'	,'INMOBILIARIO'	,'02'),
    --bankia
    T_TIPO_DATA('05' ,'FINANCIERO'	,'FINANCIERO'	,'03'),
    T_TIPO_DATA('06' ,'BANKIA HABITAT'	,'BANKIA HABITAT'	,'03'),
    T_TIPO_DATA('07' ,'BFA'	,'BFA'	,'03'),
    T_TIPO_DATA('08' ,'BANKIA'	,'BANKIA'	,'03'),
    T_TIPO_DATA('09' ,'TITULIZADA'	,'TITULIZADA'	,'03'),
    T_TIPO_DATA('14' ,'SOLVIA'	,'SOLVIA'	,'03'),
    T_TIPO_DATA('15' ,'SAREB'	,'SAREB'	,'03'),
    T_TIPO_DATA('19' ,'SAREB Pre-IBERO'	,'SAREB Pre-IBERO'	,'03'),
    --otras carteras
    T_TIPO_DATA('10' ,'FINSOLUTIA'	,'FINSOLUTIA'	,'04'),
    T_TIPO_DATA('20' ,'INMOCAM'	,'INMOCAM'	,'04'),
    --sin definir
    T_TIPO_DATA('12' ,'SIN DEFINIR'	,'SIN DEFINIR'	,'05'),
    --hyt
    T_TIPO_DATA('16' ,'INMOBILIARIO'		,'INMOBILIARIO'		,'06'),
    --cerberus
    T_TIPO_DATA('17' ,'INMOBILIARIO  '		,'INMOBILIARIO'		,'07'),
    --Liberbank
    T_TIPO_DATA('18' ,'INMOBILIARIO  '		,'INMOBILIARIO'		,'08')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_SCR_SUBCARTERA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_SCR_SUBCARTERA] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
        	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR 
						INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON SCR.DD_CRA_ID = CRA.DD_CRA_ID
						WHERE CRA.DD_CRA_CODIGO='''||TRIM(V_TMP_TIPO_DATA(4))||''''||' AND SCR.DD_SCR_CODIGO='''||TRIM(V_TMP_TIPO_DATA(1))||'''';
						
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			IF V_NUM_TABLAS > 0 THEN
        
	          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA '||
	                    'SET DD_SCR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
						', DD_SCR_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
						', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
						', DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''') '||
						'WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
	       
	     	ELSE
	     		DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	     		V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA '||
	            		'SET DD_CRA_ID= (SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO= '''||TRIM(V_TMP_TIPO_DATA(4))||''')'||
              ', DD_SCR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
							', DD_SCR_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
							' WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
	     		
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
	      
	      	END IF;
	       
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_SCR_SUBCARTERA.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA (' ||
                      'DD_SCR_ID, DD_SCR_CODIGO, DD_SCR_DESCRIPCION, DD_SCR_DESCRIPCION_LARGA, DD_CRA_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','||
                      '(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), 0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
      
      --Borrados: 
      -- Otras carteras->Inmobiliario
      -- Sin definir->Inmobiliario
      V_MSQL :='UPDATE '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA '||
      			'SET BORRADO=1'||
      			', USUARIOBORRAR= ''DML'''||
      			', FECHABORRAR=SYSDATE'||
      			' WHERE DD_CRA_ID= (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO=''05'')'||
      			' AND DD_SCR_CODIGO= ''13''';
      
      EXECUTE IMMEDIATE V_MSQL;
      
      V_MSQL :='UPDATE '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA '||
      			'SET BORRADO=1'||
      			', USUARIOBORRAR= ''DML'''||
      			', FECHABORRAR=SYSDATE'||
      			' WHERE DD_CRA_ID= (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO=''04'')'||
      			' AND DD_SCR_CODIGO= ''11''';
      
      EXECUTE IMMEDIATE V_MSQL;
      			
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS BORRADOS CORRECTAMENTE');
      
      
      
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
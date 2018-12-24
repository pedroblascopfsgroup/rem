--/*
--##########################################
--## AUTOR=Sergio Beleña Boix
--## FECHA_CREACION=20180731
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4351
--## PRODUCTO=NO
--## Finalidad: Script que añade en DD_EAV_ENTIDADES_AVALISTAS los datos añadidos en T_ARRAY_DATA
--##
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
        T_TIPO_DATA('01'	,'Bankia'		,'Bankia'),
        T_TIPO_DATA('02'	,'Bankinter'		,'Bankinter'),
        T_TIPO_DATA('03'	,'BBVA'		,'BBVA'),
        T_TIPO_DATA('04'	,'CaixaBank'		,'CaixaBank'),
        T_TIPO_DATA('05'	,'Caja de ingenieros'		,'Caja de ingenieros'),
        T_TIPO_DATA('06'	,'Caja Rural'		,'Caja Rural'),
        T_TIPO_DATA('07'	,'Caja Rural de Navarra'		,'Caja Rural de Navarra'),
        T_TIPO_DATA('08'	,'Cajamar'		,'Cajamar'),
        T_TIPO_DATA('09'	,'Cajasur'		,'Cajasur'),
        T_TIPO_DATA('10'	,'Deutche Bank'		,'Deutche Bank'),
        T_TIPO_DATA('11'	,'Ibercaja'		,'Ibercaja'),
        T_TIPO_DATA('12'	,'ING Direct'		,'ING Direct'),
        T_TIPO_DATA('13'	,'Kutxabank'		,'Kutxabank'),
        T_TIPO_DATA('14'	,'Liberbank'		,'Liberbank'),
        T_TIPO_DATA('15'	,'Openbank'		,'Openbank'),
        T_TIPO_DATA('16'	,'Pastor, Sabadell'		,'Pastor, Sabadell'),
        T_TIPO_DATA('17'	,'Santander'		,'Santander'),
        T_TIPO_DATA('18'	,'Unicaja'		,'Unicaja'),
        T_TIPO_DATA('19'	,'Otros'		,'Otros')
        
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_MOR_MOTIVO_RECHAZO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_EAV_ENTIDADES_AVALISTAS] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EAV_ENTIDADES_AVALISTAS WHERE DD_EAV_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_EAV_ENTIDADES_AVALISTAS '||
                    'SET DD_EAV_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_EAV_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''HREOS-4351'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_EAV_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_EAV_ENTIDADES_AVALISTAS.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_EAV_ENTIDADES_AVALISTAS ('||
                      'DD_EAV_ID, DD_EAV_CODIGO, DD_EAV_DESCRIPCION, DD_EAV_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''HREOS-4351'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_EAV_ENTIDADES_AVALISTAS ACTUALIZADO CORRECTAMENTE ');
   

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



   

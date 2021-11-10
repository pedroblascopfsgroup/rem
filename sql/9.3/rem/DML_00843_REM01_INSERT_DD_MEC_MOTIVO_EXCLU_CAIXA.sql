--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210813
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14163
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_MEC_MOTIVO_EXCLU_CAIXA los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.2 Versión
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-14163';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- DD_MEC_CODIGO  DD_MEC_DESCRIPCION  DD_MEC_DESCRIPCION_LARGA  
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('01', 'Problemas Jurídicos'),
        T_TIPO_DATA('02', 'Problemas Urbanísticos'),
        T_TIPO_DATA('03', 'Problemas Físicos'),
        T_TIPO_DATA('04', 'Retirada por estrategia comercial'),
        T_TIPO_DATA('05', 'Segregaciones - Agregaciones'),
        T_TIPO_DATA('06', 'Ocupaciones masivas'),
        T_TIPO_DATA('07', 'Problemas de propiedad'),
        T_TIPO_DATA('08', 'Problemas de localización'),
        T_TIPO_DATA('09', 'Cartera de venta'),
        T_TIPO_DATA('10', 'Cartera de crédito'),
        T_TIPO_DATA('11', 'Datos críticos erróneos'),
        T_TIPO_DATA('12', 'Reputacional'),
        T_TIPO_DATA('13', 'Administración pública'),
        T_TIPO_DATA('14', 'Reserva posible uso propio'),
        T_TIPO_DATA('15', 'Expropiaciones'),
        T_TIPO_DATA('16', 'Constitución préstamo promotor'),
        T_TIPO_DATA('17', 'Inmueble no vvda utilizado como vvda'),
        T_TIPO_DATA('18', 'Inmueble es una zona común')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_SCR_SUBCARTERA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_MEC_MOTIVO_EXCLU_CAIXA ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_MEC_MOTIVO_EXCLU_CAIXA WHERE DD_MEC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_MEC_MOTIVO_EXCLU_CAIXA '||
                    'SET DD_MEC_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
                        ', DD_MEC_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
                        ', USUARIOMODIFICAR = '''||TRIM(V_ITEM)||''' 
                         , FECHAMODIFICAR = SYSDATE '||
                    'WHERE DD_MEC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   

          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_MEC_MOTIVO_EXCLU_CAIXA.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_MEC_MOTIVO_EXCLU_CAIXA 
                      (' ||
                          ' DD_MEC_ID
                          , DD_MEC_CODIGO
                          , DD_MEC_DESCRIPCION
                          , DD_MEC_DESCRIPCION_LARGA
                          , VERSION
                          , USUARIOCREAR
                          , FECHACREAR
                          , BORRADO) ' ||
                      'SELECT 
                          '|| V_ID || '
                          ,'''||V_TMP_TIPO_DATA(1)||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
                          , 0
                          , '''||TRIM(V_ITEM)||'''
                          ,SYSDATE
                          ,0
                      FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_MEC_MOTIVO_EXCLU_CAIXA MODIFICADO CORRECTAMENTE ');
   

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

--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210616
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14344
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_EQV_CAIXA_REM los datos añadidos en T_ARRAY_DATA para el diccionario DD_BOR_BANCO_ORIGEN
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-14344';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- DD_NOMBRE_CAIXA DD_CODIGO_CAIXA  DD_DESCRIPCION_CAIXA  DD_DESCRIPCION_LARGA_CAIXA  DD_NOMBRE_REM  DD_CODIGO_REM
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('BANCO_ORIGEN','001', 'Banco Valencia','DD_BOR_BANCO_ORIGEN','001'),
        T_TIPO_DATA('BANCO_ORIGEN','002', 'Vip_1','DD_BOR_BANCO_ORIGEN','002'),
        T_TIPO_DATA('BANCO_ORIGEN','004', 'Fondos banco Valencia','DD_BOR_BANCO_ORIGEN','004'),
        T_TIPO_DATA('BANCO_ORIGEN','005', 'Soinmob','DD_BOR_BANCO_ORIGEN','005'),
        T_TIPO_DATA('BANCO_ORIGEN','006', 'Abanca','DD_BOR_BANCO_ORIGEN','006'),
        T_TIPO_DATA('BANCO_ORIGEN','007', 'Barclays','DD_BOR_BANCO_ORIGEN','007'),
        T_TIPO_DATA('BANCO_ORIGEN','008', 'Liberbank','DD_BOR_BANCO_ORIGEN','008'),
        T_TIPO_DATA('BANCO_ORIGEN','009', 'Banco de valencia','DD_BOR_BANCO_ORIGEN','009'),
        T_TIPO_DATA('BANCO_ORIGEN','010', 'real equility s.l.','DD_BOR_BANCO_ORIGEN','010'),
        T_TIPO_DATA('BANCO_ORIGEN','011', 'Vip viviendas y locales, s.l.u.','DD_BOR_BANCO_ORIGEN','011'),
        T_TIPO_DATA('BANCO_ORIGEN','012', 'Vipactivos, s.l.u.','DD_BOR_BANCO_ORIGEN','012'),
        T_TIPO_DATA('BANCO_ORIGEN','013', 'Vip gestión de inmuebles, s.l.u.','DD_BOR_BANCO_ORIGEN','013'),
        T_TIPO_DATA('BANCO_ORIGEN','014', 'Hip.2','DD_BOR_BANCO_ORIGEN','014'),
        T_TIPO_DATA('BANCO_ORIGEN','015', 'Vip promo. Inm. Sur, s.l.u.','DD_BOR_BANCO_ORIGEN','015'),
        T_TIPO_DATA('BANCO_ORIGEN','016', 'Banco de valencia, s.a.','DD_BOR_BANCO_ORIGEN','016'),
        T_TIPO_DATA('BANCO_ORIGEN','017', 'Bv','DD_BOR_BANCO_ORIGEN','017'),
        T_TIPO_DATA('BANCO_ORIGEN','018', 'Hip.5','DD_BOR_BANCO_ORIGEN','018'),
        T_TIPO_DATA('BANCO_ORIGEN','019', 'Hip.4','DD_BOR_BANCO_ORIGEN','019'),
        T_TIPO_DATA('BANCO_ORIGEN','020', 'Hip.3','DD_BOR_BANCO_ORIGEN','020'),
        T_TIPO_DATA('BANCO_ORIGEN','021', 'Pyme1','DD_BOR_BANCO_ORIGEN','021'),
        T_TIPO_DATA('BANCO_ORIGEN','022', 'Hip.1','DD_BOR_BANCO_ORIGEN','022'),
        T_TIPO_DATA('BANCO_ORIGEN','023', 'Ensanche urbano s.a.','DD_BOR_BANCO_ORIGEN','023'),
        T_TIPO_DATA('BANCO_ORIGEN','024', 'Pyme 2','DD_BOR_BANCO_ORIGEN','024'),
        T_TIPO_DATA('BANCO_ORIGEN','025', 'Vip promociones inmobiliarias sur, s.lu.','DD_BOR_BANCO_ORIGEN','025'),
        T_TIPO_DATA('BANCO_ORIGEN','026', 'Vip gestión de inmuebles, s.l.u.','DD_BOR_BANCO_ORIGEN','026'),
        T_TIPO_DATA('BANCO_ORIGEN','027', 'Vip viviendas y locales, s.l.u.','DD_BOR_BANCO_ORIGEN','027'),
        T_TIPO_DATA('BANCO_ORIGEN','028', 'Hábitat dos mil dieciocho, s.l.','DD_BOR_BANCO_ORIGEN','028'),
        T_TIPO_DATA('BANCO_ORIGEN','029', 'Vipcartera, s.l.','DD_BOR_BANCO_ORIGEN','029'),
        T_TIPO_DATA('BANCO_ORIGEN','030', 'BANKIA','DD_BOR_BANCO_ORIGEN','030'),
        T_TIPO_DATA('BANCO_ORIGEN','032', 'BFA','DD_BOR_BANCO_ORIGEN','032'),
        T_TIPO_DATA('BANCO_ORIGEN','033', 'CAJA RIOJA','DD_BOR_BANCO_ORIGEN','033'),
        T_TIPO_DATA('BANCO_ORIGEN','034', 'CAIXA LAIETANA','DD_BOR_BANCO_ORIGEN','034'),
        T_TIPO_DATA('BANCO_ORIGEN','035', 'CAJA INSULAR','DD_BOR_BANCO_ORIGEN','035'),
        T_TIPO_DATA('BANCO_ORIGEN','036', 'CAJA SEGOVIA','DD_BOR_BANCO_ORIGEN','036'),
        T_TIPO_DATA('BANCO_ORIGEN','037', 'BANCAJA','DD_BOR_BANCO_ORIGEN','037'),
        T_TIPO_DATA('BANCO_ORIGEN','038', 'CAJA AVILA','DD_BOR_BANCO_ORIGEN','038'),
        T_TIPO_DATA('BANCO_ORIGEN','039', 'SAREB','DD_BOR_BANCO_ORIGEN','039')

		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_EQV_CAIXA_REM ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EQV_CAIXA_REM WHERE DD_NOMBRE_CAIXA = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND DD_CODIGO_CAIXA='''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM '||
                    'SET   DD_DESCRIPCION_CAIXA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''|| 
                        ', DD_DESCRIPCION_LARGA_CAIXA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
                        ', DD_NOMBRE_REM = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
                        ', DD_CODIGO_REM = '''||TRIM(V_TMP_TIPO_DATA(5))||''''||         
                        ', USUARIOMODIFICAR = '''||TRIM(V_ITEM)||''' 
                         , FECHAMODIFICAR = SYSDATE '||
                    'WHERE DD_NOMBRE_CAIXA = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND DD_CODIGO_CAIXA='''||TRIM(V_TMP_TIPO_DATA(2))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''||TRIM(V_TMP_TIPO_DATA(2))||'''');   

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM 
                      (' ||'
                            DD_NOMBRE_CAIXA
                          , DD_CODIGO_CAIXA
                          , DD_DESCRIPCION_CAIXA
                          , DD_DESCRIPCION_LARGA_CAIXA
                          , DD_NOMBRE_REM
                          , DD_CODIGO_REM
                          , VERSION
                          , USUARIOCREAR
                          , FECHACREAR
                          , BORRADO) ' ||
                      'SELECT 
                          '''||TRIM(V_TMP_TIPO_DATA(1))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(3))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(3))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(4))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(5))||'''
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

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_EQV_CAIXA_REM MODIFICADO CORRECTAMENTE ');
   

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

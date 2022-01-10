--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16493
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en DD_CIC_CODIGO_ISO_CIRBE_BKP
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-16493';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
                  --ID    --CÓDIGO   --PAÍS
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('30001','1000','ANTARTIDA'),
        T_TIPO_DATA('30002','1001','SAN BARTOLOME'),
        T_TIPO_DATA('30003','1002','ISLAS ALAND'),
        T_TIPO_DATA('30004','1003','BUTAN'),
        T_TIPO_DATA('30005','1004','ISLAS BOUVET'),
        T_TIPO_DATA('30006','1005','ISLAS COCOS'),
        T_TIPO_DATA('30007','1006','CABO VERDE'),
        T_TIPO_DATA('30008','1008','ISLA CHRISTMAS'),
        T_TIPO_DATA('30009','1009','YIBUTI'),
        T_TIPO_DATA('30010','1010','SAHARA OCCIDENTAL'),
        T_TIPO_DATA('30011','1012','MICRONESIA'),
        T_TIPO_DATA('30012','1013','GUERNSEY'),
        T_TIPO_DATA('30013','1014','ISLAS SANDWICH DEL SUR'),
        T_TIPO_DATA('30014','1015','GUAM'),
        T_TIPO_DATA('30015','1016','ISLAS HEARD Y MCDONALD'),
        T_TIPO_DATA('30016','1017','CAMBOYA'),
        T_TIPO_DATA('30017','1018','SAN CRISTOBAL Y NIEVES'),
        T_TIPO_DATA('30018','1019','LIECHTENSTEIN'),
        T_TIPO_DATA('30019','1020','ISLAS NORFOLK'),
        T_TIPO_DATA('30020','1021','ISLAS NIUE'),
        T_TIPO_DATA('30021','1022','PALESTINA'),
        T_TIPO_DATA('30022','1023','SVALBARD'),
        T_TIPO_DATA('30023','1024','ESLOVAQUIA'),
        T_TIPO_DATA('30024','1025','SURINAM'),
        T_TIPO_DATA('30025','1026','ISLTAS TURCAS Y CAICOS'),
        T_TIPO_DATA('30026','1027','CHAD'),
        T_TIPO_DATA('30027','1028','TERRITORIOS AUSTRALES FRANCESES'),
        T_TIPO_DATA('30028','1029','ISLAS TOKELAU'),
        T_TIPO_DATA('30029','1030','TIMOR ORIENTAL'),
        T_TIPO_DATA('30030','1031','SAMOA AMERICANA')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_CIC_CODIGO_ISO_CIRBE_BKP ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_CIC_CODIGO_ISO_CIRBE_BKP WHERE DD_CIC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.DD_CIC_CODIGO_ISO_CIRBE_BKP '||
                    'SET   DD_CIC_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''''|| 
                        ', DD_CIC_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
                        ', USUARIOMODIFICAR = '''||TRIM(V_ITEM)||''' 
                         , FECHAMODIFICAR = SYSDATE '||
                    'WHERE DD_CIC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_CIC_CODIGO_ISO_CIRBE_BKP 
                      (' ||'
                            DD_CIC_ID
                          , DD_CIC_CODIGO
                          , DD_CIC_DESCRIPCION
                          , DD_CIC_DESCRIPCION_LARGA
                          , VERSION
                          , USUARIOCREAR
                          , FECHACREAR
                          , BORRADO) ' ||
                      'SELECT 
                           '''||TRIM(V_TMP_TIPO_DATA(1))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(3))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(3))||'''
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

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_CIC_CODIGO_ISO_CIRBE_BKP MODIFICADO CORRECTAMENTE ');
   

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

--/*
--##########################################
--## AUTOR=PABLO MESEGUER
--## FECHA_CREACION=20170109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1294
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_STA_SUBTIPO_TITULO_ACTIVO los datos añadidos en T_ARRAY_DATA
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
	V_TIPO_ID NUMBER(16); --Vle para el id DD_TTA_TIPO_TITULO_ACTIVO
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--			codigo STA	Descripcion								Descripcion Larga						codigo TTA (TIPO_TITULO)
    	T_TIPO_DATA('14'		,'Mandatos de venta'					,'Mandatos de venta'					,'03')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_STA_SUBTIPO_TITULO_ACTIVO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_STA_SUBTIPO_TITULO_ACTIVO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO WHERE DD_STA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        -- Recuperamos el id del Tipo Trabajo
        V_SQL := 'SELECT DD_TTA_ID FROM '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO WHERE DD_TTA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_TIPO_ID;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_STA_SUBTIPO_TITULO_ACTIVO '||
                    'SET DD_STA_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '|| 
					', DD_STA_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' '||
					', DD_TTA_ID = '|| V_TIPO_ID ||' '||
					', USUARIOMODIFICAR = ''HREOS-1294'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_STA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_STA_SUBTIPO_TITULO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_STA_SUBTIPO_TITULO_ACTIVO (' ||
                      ' DD_STA_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TTA_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      ' SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', '||
                      ' '|| V_TIPO_ID ||', 0, ''HREOS-1294'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_STA_SUBTIPO_TITULO_ACTIVO ACTUALIZADO CORRECTAMENTE ');
   

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



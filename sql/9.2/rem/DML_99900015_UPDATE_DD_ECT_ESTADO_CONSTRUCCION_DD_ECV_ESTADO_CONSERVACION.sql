--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20161110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1144
--## PRODUCTO=NO
--##
--## Finalidad: Script que intercambia los valores de los diccionarios DD_ECT_ESTADO_CONSTRUCCION y DD_ECV_ESTADO_CONSERVACION
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
	V_TIPO_ID NUMBER(16); --Vle para el id DD_ECT_ESTADO_CONSTRUCCION
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--			codigo real ECV		Descripcion	real ECV			codigo real ECT		Descripcion real ECT							
    	T_TIPO_DATA('01'				,'Muy bueno'					,'01'				,'Terminado nuevo'							),
    	T_TIPO_DATA('02'				,'Bueno'						,'02'				,'Terminado necesita reforma integral'		),
    	T_TIPO_DATA('03'				,'Regular'						,'03'				,'Terminado necesita reforma'				),
    	T_TIPO_DATA('04'				,'Malo'							,'04'				,'En construcción o reforma'				),
    	T_TIPO_DATA(''					,''								,'05'				,'Obra paralizada'							)
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en DD_ECV_ESTADO_CONSERVACION -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN  DD_ECV_ESTADO_CONSERVACION] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a actualizar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION WHERE DD_ECV_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_ECV_ESTADO_CONSERVACION '||
                    'SET DD_ECV_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '|| 
					', DD_ECV_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					', USUARIOMODIFICAR = ''HREOS-1144'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_ECV_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       END IF;
      END LOOP;
      
      
      
    -- LOOP para actualizar los valores en DD_ECT_ESTADO_CONSTRUCCION -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN  DD_ECT_ESTADO_CONSTRUCCION] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a actualizar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ECT_ESTADO_CONSTRUCCION WHERE DD_ECT_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' ');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_ECT_ESTADO_CONSTRUCCION '||
                    'SET DD_ECT_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||''' '|| 
					', DD_ECT_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(4))||''' '||
					', USUARIOMODIFICAR = ''HREOS-1144'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_ECT_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(3)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_ECT_ESTADO_CONSTRUCCION.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_ECT_ESTADO_CONSTRUCCION (' ||
                      ' DD_ECT_ID, DD_ECT_CODIGO, DD_ECT_DESCRIPCION, DD_ECT_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      ' SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(3)||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''', '||
                      ' 0, ''HREOS-1144'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
      
  
	  --Comprobamos el dato a borrar
	  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION WHERE DD_ECV_CODIGO = 05';
	  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		  
	  --Si existe lo borramos
	  IF V_NUM_TABLAS > 0 THEN	
       
	  	  DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAMOS EL REGISTRO "05 - Obra paralizada" DE DD_ECV_ESTADO_CONSERVACION ');
       	  V_MSQL := 'DELETE  FROM '|| V_ESQUEMA ||'.DD_ECV_ESTADO_CONSERVACION '||                   
					'WHERE DD_ECV_CODIGO = 05';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO BORRADO CORRECTAMENTE');
	  
	  END IF;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIOS DD_ECT_ESTADO_CONSTRUCCION Y DD_ECV_ESTADO_CONSERVACION ACTUALIZADOS CORRECTAMENTE ');
   

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



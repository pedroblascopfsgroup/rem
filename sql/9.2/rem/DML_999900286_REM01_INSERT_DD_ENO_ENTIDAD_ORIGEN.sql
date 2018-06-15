--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180604
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4184
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_ENO_ENTIDAD_ORIGEN los datos añadidos en T_ARRAY_DATA
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_ENO_ENTIDAD_ORIGEN'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
	
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('4003','','B39690516','VALLE DEL TEJO, S.L.U.','VALLE DEL TEJO, S.L.U.'),
		T_TIPO_DATA('1000','','A86201993','LIBERBANK','LIBERBANK'),
		T_TIPO_DATA('3000','','A15011489','BANCO CASTILLA LA MANCHA S.A.','BANCO CASTILLA LA MANCHA S.A.'),
		T_TIPO_DATA('3002','','A86486461','RETAMAR S.I., S.A.','RETAMAR S.I., S.A.'),
		T_TIPO_DATA('4000','','A78485752','BEYOS Y PONGA, S.A.','BEYOS Y PONGA, S.A.'),
		T_TIPO_DATA('3001','','B84921758','MOSACATA, S.L.','MOSACATA, S.L.')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	 
    -- LOOP para actualizar los valores en DD_ENO_ENTIDAD_ORIGEN -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN EN DD_ENO_ENTIDAD_ORIGEN] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a actualizar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN WHERE DD_ENO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_ENO_ENTIDAD_ORIGEN '||
                    'SET DD_ENO_PADRE_ID = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
                    ', DD_ENO_CIF = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
                    ', DD_ENO_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', DD_ENO_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(5))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_ENO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_ENO_ENTIDAD_ORIGEN.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_ENO_ENTIDAD_ORIGEN (' ||
                      'DD_ENO_ID, DD_ENO_CODIGO, DD_ENO_PADRE_ID, DD_ENO_CIF, DD_ENO_DESCRIPCION, DD_ENO_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''' , (SELECT DD_ENO_ID FROM DD_ENO_ENTIDAD_ORIGEN WHERE DD_ENO_CODIGO LIKE ('''||V_TMP_TIPO_DATA(2)||''')) ,'''||
                      V_TMP_TIPO_DATA(3)||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(5))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_ENO_ENTIDAD_ORIGEN ACTUALIZADO CORRECTAMENTE ');
   

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


--/*
--##########################################
--## AUTOR=RAMON LLINARES
--## FECHA_CREACION=20170526
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2058
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TPD_TIPOS_DOCUMENTO_GASTO los datos añadidos en T_ARRAY_DATA
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
    V_EVI_ID NUMBER(16);

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
         t_tipo_data('26','Factura / liquidación','Factura / liquidación'),
         t_tipo_data('27','Justificante de pago','Justificante de pago'),
         t_tipo_data('28','Otro documento asociado al gasto','Otro documento asociado al gasto')
        
        
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	 -- borramos los datos existentes
     V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPD_TIPOS_DOCUMENTO_GASTO ' ||
               'SET BORRADO = 1 WHERE DD_TPD_CODIGO IN (''01'',''02'',''03'',''04'',''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'',''13'',''14'',''15'',''16'',''17'',''18'',''19'',''20'',''21'',''22'',''23'',''24'',''25'') ';
     EXECUTE IMMEDIATE V_MSQL;

	 
    -- LOOP para insertar los valores en DD_TPD_TIPOS_DOCUMENTO_GASTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TPD_TIPOS_DOCUMENTO_GASTO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPD_TIPOS_DOCUMENTO_GASTO WHERE DD_TPD_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

         
       --Si no existe, lo insertamos   
        IF V_NUM_TABLAS = 0 THEN				
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TPD_TIPOS_DOCUMENTO_GASTO (' ||
                      'DD_TPD_ID,DD_TPD_CODIGO, DD_TPD_DESCRIPCION, DD_TPD_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT S_DD_TPD_TP_DTO_GASTO.NEXTVAL,'''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

         ELSE
        --Si existe lo modificamos
         DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATEAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   
         V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPD_TIPOS_DOCUMENTO_GASTO ' ||
                   'SET DD_TPD_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '  ||
                   ',   DD_TPD_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||'''  ' ||
	               ' WHERE DD_TPD_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ';
           EXECUTE IMMEDIATE V_MSQL;       
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_EAC_ESTADO_ACTIVO ACTUALIZADO CORRECTAMENTE ');
   

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



   

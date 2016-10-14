--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20161011
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TGA_TIPOS_GASTO los datos añadidos en T_ARRAY_DATA
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
    	T_TIPO_DATA('01'	,'Impuesto'	,'Impuesto'),
        T_TIPO_DATA('02'	,'Tasa'	,'Tasa'),
        T_TIPO_DATA('03'	,'Otros tributos'	,'Otros tributos'),          
        T_TIPO_DATA('04'	,'Sanción'	,'Sanción'),
        T_TIPO_DATA('05'	,'Comunidad de propietarios'	,'Comunidad de propietarios'),
        T_TIPO_DATA('06'	,'Complejo inmobiliario'	,'Complejo inmobiliario'),
        T_TIPO_DATA('07'	,'Junta de compensación / EUC'	,'Junta de compensación / EUC'),          
        T_TIPO_DATA('08'	,'Otras entidades en que se integra el activo'	,'Otras entidades en que se integra el activo'),
        T_TIPO_DATA('09'	,'Suministro'	,'Suministro'),
        T_TIPO_DATA('10'	,'Seguros'	,'Seguros'),
        T_TIPO_DATA('11'	,'Servicios profesionales independientes'	,'Servicios profesionales independientes'),          
        T_TIPO_DATA('12'	,'Gestoría'	,'Gestoría'),
        T_TIPO_DATA('13'	,'Comisiones'	,'Comisiones'),
        T_TIPO_DATA('14'	,'Informes técnicos y obtención documentos'	,'Informes técnicos y obtención documentos'),
        T_TIPO_DATA('15'	,'Actuación técnica y mantenimiento'	,'Actuación técnica y mantenimiento'),          
        T_TIPO_DATA('16'	,'Vigilancia y seguridad'	,'Vigilancia y seguridad'),
        T_TIPO_DATA('17'	,'Publicidad'	,'Publicidad'),
        T_TIPO_DATA('18'	,'Otros gastos'	,'Otros gastos')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TGA_TIPOS_GASTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TGA_TIPOS_GASTO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TGA_TIPOS_GASTO '||
                    'SET DD_TGA_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_TGA_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TGA_TIPOS_GASTO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TGA_TIPOS_GASTO (' ||
                      'DD_TGA_ID, DD_TGA_CODIGO, DD_TGA_DESCRIPCION, DD_TGA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TGA_TIPOS_GASTO ACTUALIZADO CORRECTAMENTE ');
   

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



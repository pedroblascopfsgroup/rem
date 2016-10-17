--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20161013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_COS_COMITES_SANCION los subtipos de trabajos de Precios
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
		T_TIPO_DATA('01','1','Haya','Haya'),
		T_TIPO_DATA('03','2','C.DGVIeR','C.DGVIeR'),
		T_TIPO_DATA('03','3','C.PLATAFORMA','C.PLATAFORMA'),
		T_TIPO_DATA('03','4','C.AREA ACTIVIDAD INMOBILIARIA','C.AREA ACTIVIDAD INMOBILIARIA'),
		T_TIPO_DATA('03','5','C.GESTION INMOBILIARIA','C.GESTION INMOBILIARIA'),
		T_TIPO_DATA('03','6','C.INMOBILIARIO','C.INMOBILIARIO'),
		T_TIPO_DATA('03','7','C.DIRECCION','C.DIRECCION'),										
		T_TIPO_DATA('03','8','CONSEJO ADMINISTRACION','CONSEJO ADMINISTRACION'),
		T_TIPO_DATA('03','9','C.FTAs','C.FTAs'),
		T_TIPO_DATA('01','10','Cajamar','Cajamar'),
		T_TIPO_DATA('02','11','Sareb','Sareb'),
		T_TIPO_DATA('02','12','Haya','Haya'),
		T_TIPO_DATA('04','13','Propietario','Propietario')
		
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_COS_COMITES_SANCION -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_COS_COMITES_SANCION] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(3)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_COS_COMITES_SANCION '||
                    'SET DD_COS_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''''|| 
					', DD_COS_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = ''REM_F2'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_COS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGICOSO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_COS_COMITES_SANCION.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_COS_COMITES_SANCION (' ||
                      'DD_COS_ID, DD_CRA_ID, DD_COS_CODIGO, DD_COS_DESCRIPCION, DD_COS_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES' ||
                      '('|| V_ID || ',
                      (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''),
                      '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                       0, ''REM_F2'',SYSDATE,0 )';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_COS_COMITES_SANCION ACTUALIZADO CORRECTAMENTE ');
   

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

EXIT;

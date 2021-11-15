--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210615
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14344
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en DD_SOR_SOCIEDAD_ORIGEN
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
                  --DD_SOR_CODIGO        	--DD_SOR_DESCRIPCION y DD_SOR_DESCRIPCION_LARGA
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('0001','CAIXABANK'),
        T_TIPO_DATA('0487','BMN'),
        T_TIPO_DATA('1487','BMN'),
        T_TIPO_DATA('2037','CAJA RIOJA'),
        T_TIPO_DATA('2038','BANKIA'),
        T_TIPO_DATA('2042','CAIXA LAIETANA'),
        T_TIPO_DATA('2052','CAJA INSULAR'),
        T_TIPO_DATA('2069','CAJA SEGOVIA'),
        T_TIPO_DATA('2077','BANCAJA'),
        T_TIPO_DATA('2094','CAJA AVILLA')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_SOR_SOCIEDAD_ORIGEN ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SOR_SOCIEDAD_ORIGEN WHERE DD_SOR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_SOR_SOCIEDAD_ORIGEN '||
                    'SET   DD_SOR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
                        ', DD_SOR_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
                        ', USUARIOMODIFICAR = '''||TRIM(V_ITEM)||''' 
                         , FECHAMODIFICAR = SYSDATE '||
                    'WHERE DD_SOR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SOR_SOCIEDAD_ORIGEN 
                      (' ||'
                            DD_SOR_ID
                          , DD_SOR_CODIGO
                          , DD_SOR_DESCRIPCION
                          , DD_SOR_DESCRIPCION_LARGA
                          , VERSION
                          , USUARIOCREAR
                          , FECHACREAR
                          , BORRADO) ' ||
                      'SELECT 
                           '|| V_ESQUEMA ||'.S_DD_SOR_SOCIEDAD_ORIGEN.NEXTVAL
                          ,'''||TRIM(V_TMP_TIPO_DATA(1))||'''
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

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SOR_SOCIEDAD_ORIGEN MODIFICADO CORRECTAMENTE ');
   

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

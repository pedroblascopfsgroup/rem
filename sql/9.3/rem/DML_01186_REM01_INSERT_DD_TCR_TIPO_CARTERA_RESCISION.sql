--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220926
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18735
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en DD_TCR_TIPO_CARTERA_RESCISION
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-18735';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
                  --DD_TCR_CODIGO        	--DD_TCR_DESCRIPCION y DD_TCR_DESCRIPCION_LARGA  --DD_TCR_CODIGO_C4C
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('01','Patrimonial','101'),
        T_TIPO_DATA('02','Concentrada','111')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TCR_TIPO_CARTERA_RESCISION ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TCR_TIPO_CARTERA_RESCISION WHERE DD_TCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TCR_TIPO_CARTERA_RESCISION '||
                    'SET   DD_TCR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
                        ', DD_TCR_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
                        ', DD_TCR_CODIGO_C4C = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
                        ', USUARIOMODIFICAR = '''||TRIM(V_ITEM)||''' 
                         , FECHAMODIFICAR = SYSDATE '||
                    'WHERE DD_TCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TCR_TIPO_CARTERA_RESCISION 
                      (' ||'
                            DD_TCR_ID
                          , DD_TCR_CODIGO
                          , DD_TCR_DESCRIPCION
                          , DD_TCR_DESCRIPCION_LARGA
                          , DD_TCR_CODIGO_C4C
                          , VERSION
                          , USUARIOCREAR
                          , FECHACREAR
                          , BORRADO) ' ||
                      'SELECT 
                           '|| V_ESQUEMA ||'.S_DD_TCR_TIPO_CARTERA_RESCISION.NEXTVAL
                          ,'''||TRIM(V_TMP_TIPO_DATA(1))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
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

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TCR_TIPO_CARTERA_RESCISION MODIFICADO CORRECTAMENTE ');
   

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

--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20170103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1325
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade honorarios para FVD's
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
	V_TIPO_ID NUMBER(16); --Vle para el id TRF_TRF_PRC_HONORARIOS
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--			    DD_TPR_CODIGO       TRF_PRC_COLAB      TRF_PRC_PRESC       DD_CLA_CODIGO
    	T_TIPO_DATA('18'                 ,'1'                ,'1'              ,'01'),
      T_TIPO_DATA('18'                 ,'1'                ,'1'              ,'02')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en TRF_TRF_PRC_HONORARIOS -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN TRF_TRF_PRC_HONORARIOS] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TRF_TRF_PRC_HONORARIOS WHERE DD_TPR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND DD_CLA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TRF_TRF_PRC_HONORARIOS '||
                    'SET TRF_PRC_COLAB = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '|| 
					', TRF_PRC_PRESC = '''||TRIM(V_TMP_TIPO_DATA(3))||''' '||
					' '||
					'WHERE DD_TPR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND DD_CLA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT MAX(TRF_ID)+1 FROM '|| V_ESQUEMA ||'.TRF_TRF_PRC_HONORARIOS ';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TRF_TRF_PRC_HONORARIOS (' ||
                      ' TRF_ID, DD_TPR_CODIGO, TRF_PRC_COLAB, TRF_PRC_PRESC, DD_CLA_CODIGO) ' ||
                      ' SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''' ,'''||TRIM(V_TMP_TIPO_DATA(4))||''' '||
                      ' FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO TRF_TRF_PRC_HONORARIOS ACTUALIZADO CORRECTAMENTE ');
   

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



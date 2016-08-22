--/*
--##########################################
--## AUTOR=ANAHECT DE VICENTE
--## FECHA_CREACION=20151102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CMP_COMAUTONOMA_PROVINCIA los datos añadidos en T_ARRAY_DATA
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
    	T_TIPO_DATA('011',	'01'		,'4'	),
    	T_TIPO_DATA('011',	'01'		,'14'	),
    	T_TIPO_DATA('011',	'01'		,'18'	),
    	T_TIPO_DATA('011',	'01'		,'21'	),
    	T_TIPO_DATA('011',	'01'		,'23'	),
    	T_TIPO_DATA('011',	'01'		,'29'	),
    	T_TIPO_DATA('011',	'01'		,'41'	),
    	T_TIPO_DATA('011',	'02'		,'22'	),
    	T_TIPO_DATA('011',	'02'		,'44'	),
    	T_TIPO_DATA('011',	'02'		,'50'	),    	
		T_TIPO_DATA('011',	'03'		,'33'	),
		T_TIPO_DATA('011',	'04'		,'7'	),
		T_TIPO_DATA('011',	'05'		,'35'	),
		T_TIPO_DATA('011',	'05'		,'38'	),
		T_TIPO_DATA('011',	'06'		,'39'	),	
		T_TIPO_DATA('011',	'07'		,'5'	),
		T_TIPO_DATA('011',	'07'		,'9'	),
		T_TIPO_DATA('011',	'07'		,'24'	),
		T_TIPO_DATA('011',	'07'		,'34'	),
		T_TIPO_DATA('011',	'07'		,'37'	),
		T_TIPO_DATA('011',	'07'		,'40'	),
		T_TIPO_DATA('011',	'07'		,'42'	),
		T_TIPO_DATA('011',	'07'		,'47'	),
		T_TIPO_DATA('011',	'07'		,'49'	),
		T_TIPO_DATA('011',	'08'		,'13'	),
		T_TIPO_DATA('011',	'08'		,'16'	),
		T_TIPO_DATA('011',	'08'		,'19'	),
		T_TIPO_DATA('011',	'08'		,'45'	),
		T_TIPO_DATA('011',	'08'		,'2'	),	
    	T_TIPO_DATA('011',	'09'		,'8'	),
    	T_TIPO_DATA('011',	'09'		,'17'	),
    	T_TIPO_DATA('011',	'09'		,'25'	),
    	T_TIPO_DATA('011',	'09'		,'43'	),
    	T_TIPO_DATA('011',	'10'		,'3'	),
    	T_TIPO_DATA('011',	'10'		,'12'	),
    	T_TIPO_DATA('011',	'10'		,'46'	),
    	T_TIPO_DATA('011',	'11'		,'6'	),
    	T_TIPO_DATA('011',	'11'		,'10'	),  
    	T_TIPO_DATA('011',	'12'		,'15'	),
    	T_TIPO_DATA('011',	'12'		,'27'	),
    	T_TIPO_DATA('011',	'12'		,'32'	),
    	T_TIPO_DATA('011',	'12'		,'36'	),
    	T_TIPO_DATA('011',	'13'		,'28'	),  
    	T_TIPO_DATA('011',	'14'		,'30'	),   
    	T_TIPO_DATA('011',	'15'		,'31'	),    
    	T_TIPO_DATA('011',	'16'		,'1'	),
    	T_TIPO_DATA('011',	'16'		,'20'	),
    	T_TIPO_DATA('011',	'16'		,'48'	),   
    	T_TIPO_DATA('011',	'17'		,'26'	), 
    	T_TIPO_DATA('011',	'18'		,'51'	),  
    	T_TIPO_DATA('011',	'19'		,'52'	)
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en ACT_CMP_COMAUTONOMA_PROVINCIA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_CMP_COMAUTONOMA_PROVINCIA] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
	    V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
	    --Comprobamos el dato a insertar
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_CMP_COMAUTONOMA_PROVINCIA WHERE DD_CIC_ID = (SELECT DD_CIC_ID FROM '||V_ESQUEMA_M||'.DD_CIC_CODIGO_ISO_CIRBE_BKP WHERE DD_CIC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') AND DD_CMA_ID = (SELECT DD_CMA_ID FROM '||V_ESQUEMA||'.DD_CMA_COMAUTONOMA WHERE DD_CMA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''') AND DD_PRV_ID = (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''')';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		--Si existe lo modificamos
		IF V_NUM_TABLAS > 0 THEN				
			DBMS_OUTPUT.PUT_LINE('[INFO]: EL REGISTRO YA EXISTE. NO SE HACE NADA.');
		  
		--Si no existe, lo insertamos   
		ELSE
       
	      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(3)) ||'''');     
	      V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ACT_CMP_COMAUTO_PROV.NEXTVAL FROM DUAL';
	      EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
	      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_CMP_COMAUTONOMA_PROVINCIA (' ||
	                'ACT_CMP_ID, DD_CIC_ID, DD_CMA_ID, DD_PRV_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
	                ' SELECT '||V_ESQUEMA||'.S_ACT_CMP_COMAUTO_PROV.NEXTVAL,' ||
					'(SELECT DD_CIC_ID FROM '||V_ESQUEMA_M||'.DD_CIC_CODIGO_ISO_CIRBE_BKP WHERE DD_CIC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),' ||			
					'(SELECT DD_CMA_ID FROM '||V_ESQUEMA||'.DD_CMA_COMAUTONOMA WHERE DD_CMA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),' ||
					'(SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''') ,0,''DML'',SYSDATE,0 FROM DUAL';
	      EXECUTE IMMEDIATE V_MSQL;
	      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
	      
		 END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO ACT_CMP_COMAUTONOMA_PROVINCIA ACTUALIZADO CORRECTAMENTE ');
   

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



   
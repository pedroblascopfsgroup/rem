--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200722
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7742
--## PRODUCTO=NO
--##
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

    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7742';

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(    
    --			1.COD_CAMPO		2.CAMPO									3.VALIDACION		4.TABLA											5.CAMPO_ID		6.TABLA_AUX		7.CAMPO_ID_TABLA_AUX		8.CLAVE_DICCIONARIO
T_TIPO_DATA('01',	'TIT_FECHA_INSC_REG',			    			   'F',		'ACT_TIT_TITULO',			    						'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('02',	'ADN_FECHA_TITULO',		    	   			   'F',		'ACT_ADN_ADJNOJUDICIAL',	    			'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('03',	'ADN_FECHA_TITULO',		    	   			   'F',		'ACT_ADN_ADJNOJUDICIAL',	    			'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('04',	'DD_TPA_ID',												   'DD',		'ACT_ACTIVO',				    							'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			'tiposActivo'),
T_TIPO_DATA('05',	'DD_SAC_ID',				    							   'DD',	   	'ACT_ACTIVO',				    							'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			'subtiposActivo'),
T_TIPO_DATA('06',	'DD_EAC_ID',				    							   'DD',	   	'ACT_ACTIVO',				    							'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			'estadosActivo'),
T_TIPO_DATA('07',	'DD_TUD_ID',											   'DD',	   	'ACT_ACTIVO',				   	 							'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			'tiposUsoDestino'),
T_TIPO_DATA('08',	'DD_PRV_ID',	         							 	   'DD',		'BIE_DATOS_REGISTRALES',	    				'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			'provincias'),
T_TIPO_DATA('09',	'DD_LOC_ID'             ,		 						   'DD',		'BIE_DATOS_REGISTRALES',	    				'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			'municipio'),
T_TIPO_DATA('10',	'BIE_DREG_NUM_REGISTRO',		   			'T',		'BIE_DATOS_REGISTRALES',	    				'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('11',	'BIE_DREG_NUM_FINCA',			   				'T',		'BIE_DATOS_REGISTRALES',	    				'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('12',	'REG_IDUFIR',											    'T',		'ACT_REG_INFO_REGISTRAL',	   	 			'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('13',	'BIE_DREG_TOMO',    			    					'T',		'BIE_DATOS_REGISTRALES',	    				'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('14',	'BIE_DREG_LIBRO',	    		   						'T',		'BIE_DATOS_REGISTRALES',	    				'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('15',	'BIE_DREG_FOLIO',		    	 						'T',		'BIE_DATOS_REGISTRALES',	    				'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('16',	'BIE_DREG_SUPERFICIE_CONSTRUIDA',	'N',		'BIE_DATOS_REGISTRALES',	    				'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('17',	'REG_SUPERFICIE_UTIL',								'N',		'ACT_REG_INFO_REGISTRAL',	    			'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('18',	'CAT_REF_CATASTRAL',           			 		'T',		'ACT_CAT_CATASTRO',	    						'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('19',	'DD_PRV_ID',	        	   							    'DD',	'BIE_LOCALIZACION',	            					'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			'provincias'),
T_TIPO_DATA('20',	'DD_LOC_ID',	        	        							'DD',	'BIE_LOCALIZACION',	            					'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			'municipio'),
T_TIPO_DATA('21',	'DD_TVI_ID',	        	        							'DD',	'BIE_LOCALIZACION',	            					'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			'tiposVia'),
T_TIPO_DATA('22',	'BIE_LOC_NOMBRE_VIA',		        			'T',		'BIE_LOCALIZACION',	            					'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('23',	'BIE_LOC_NUMERO_DOMICILIO',	        	'T',		'BIE_LOCALIZACION',	          						'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('24',	'BIE_LOC_COD_POST',			        			'T',		'BIE_LOCALIZACION',	            					'BIE_ID',			'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('25',	'LOC_LATITUD',					    						'N',		'ACT_LOC_LOCALIZACION',	       				'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('26',	'LOC_LONGITUD',					   						'N',		'ACT_LOC_LOCALIZACION', 	    				'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('27',	'DD_TCE_ID',					    							'DD',	'ACT_ADO_ADMISION_DOCUMENTO',	'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			'calificacionEnergetica'),
T_TIPO_DATA('28',	'ADO_FECHA_CADUCIDAD',			    		'F',		'ACT_ADO_ADMISION_DOCUMENTO',	'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('29',	'AGR_ID',	            		    							'N',		'ACT_AGA_AGRUPACION_ACTIVO',		'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			''),
T_TIPO_DATA('30',	'AGR_ID',		            	   			 					'N',		'ACT_AGA_AGRUPACION_ACTIVO',		'ACT_ID',		'ACT_ACTIVO',		'ACT_NUM_ACTIVO',   			'')
		);
		
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en CDC_CALIDAD_DATOS_CONFIG -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CDC_CALIDAD_DATOS_CONFIG] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.CDC_CALIDAD_DATOS_CONFIG WHERE COD_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
	
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO COD_CAMPO: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.CDC_CALIDAD_DATOS_CONFIG '||
                    'SET CAMPO = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', VALIDACION = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', TABLA = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', CAMPO_ID = '''||TRIM(V_TMP_TIPO_DATA(5))||''''||
					', TABLA_AUX = '''||TRIM(V_TMP_TIPO_DATA(6))||''''||
					', CAMPO_ID_TABLA_AUX = '''||TRIM(V_TMP_TIPO_DATA(7))||''''||	
					', CLAVE_DICCIONARIO = '''||TRIM(V_TMP_TIPO_DATA(8))||''''||					
					', USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE '||					
					'WHERE COD_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO COD_CAMPO: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CDC_CALIDAD_DATOS_CONFIG.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CDC_CALIDAD_DATOS_CONFIG (' ||
                      'CDC_ID, COD_CAMPO, CAMPO, VALIDACION, TABLA, CAMPO_ID, TABLA_AUX, CAMPO_ID_TABLA_AUX, CLAVE_DICCIONARIO, USUARIOCREAR, FECHACREAR, VERSION, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','||
                      ''''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(5))||''','''||TRIM(V_TMP_TIPO_DATA(6))||''','''||TRIM(V_TMP_TIPO_DATA(7))||''','''||TRIM(V_TMP_TIPO_DATA(8))||''','''||V_USUARIO||''',SYSDATE,0,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: Proceso finalizado correctamente ');
   

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

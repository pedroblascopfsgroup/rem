--/*
--#########################################
--## AUTOR=Lara Pablo
--## FECHA_CREACION=20190927
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7474
--## PRODUCTO=NO
--##
--## FINALIDAD: CREACIÓN DE UN DICCIONARIO DE PRUEBAS
--##
--## INSTRUCCIONES:
--##	1. Especificar el esquema de la tabla en la variable 'V_TABLE_SCHEME' apuntando a la variables 'V_SCHEME' o 'V_MASTER_SCHEME'.
--##	2. Especificar el nombre de la tabla a crear o modificar en la variable 'V_TABLE_NAME'.
--##	3. Especificar el comentario aclarativo de la tabla en la variable 'V_TABLE_COMMENT'.
--##
--##	** No modificar las zonas entre BEGIN -> EXIT, la lógica implementada lleva a cabo las operaciones necesarias con las variables en el DECLARE **
--##	Más información: http://bit.ly/pitertul-api
--##
--## VERSIONES:
--##	0.1 Versión inicial
--#########################################
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
    
    				--CODIGO			DESCRIPCION														DESCRIPCION LARGA										MATRICULAS		DD_TDT_VINCULABLE		CODIGO DD_TPD_TIPO_DOCUMENTO
        T_TIPO_DATA('RDDJP', 	'Recurso derivación de deuda (Justificante de pago)', 		'Recurso derivación de deuda (Justificante de pago)', 			'OP-32-CERA-DF',			'1',				'RDDJP'		),
        T_TIPO_DATA('RDDR', 	'Recurso derivación de deuda (Recibo)', 					'Recurso derivación de deuda (Recibo)', 						'OP-32-FACT-AX',			'1',				'RDDR'		),
        T_TIPO_DATA('RHLTJP', 	'Recurso hipoteca legal tácita (Justificante de pago)', 	'Recurso hipoteca legal tácita (Justificante de pago)', 		'OP-32-CERA-DG',			'1',				'RHLTJP'	),
        T_TIPO_DATA('RHLTR', 	'Recurso hipoteca legal tácita (Recibo)', 					'Recurso hipoteca legal tácita (Recibo)', 						'OP-32-FACT-AY',			'1',				'RHLTR'		),
        T_TIPO_DATA('RRDD', 	'Respuesta recurso derivación de deuda', 					'Respuesta recurso derivación de deuda', 						'OP-32-DOCA-60',			'1',				'RRDD'		),
        T_TIPO_DATA('RRHLT', 	'Respuesta recurso hipoteca legal tácita', 					'Respuesta recurso hipoteca legal tácita', 						'OP-32-DOCA-61',			'1',				'RRHLT'		),
        T_TIPO_DATA('RSJP', 	'Resto de sanciones (Justificante de pago)', 				'Resto de sanciones (Justificante de pago)', 					'OP-32-CERA-DH',			'0',				'RSJP'		),
        T_TIPO_DATA('RSR', 		'Resto de sanciones (Recibo)', 								'Resto de sanciones (Recibo)', 									'OP-32-FACT-AZ',			'0',				'RSR'		),
        T_TIPO_DATA('SMCJP',	'Sanción: Multa coercitiva (Justificante de pago)', 		'Sanción: Multa coercitiva (Justificante de pago)', 			'OP-32-CERA-AA',			'0',				'SMCJP'		),
        T_TIPO_DATA('SMCR', 	'Sanción: Multa coercitiva (Recibo)', 						'Sanción: Multa coercitiva (Recibo)', 							'OP-32-FACT-45',			'0',				'SMCR'		),
        T_TIPO_DATA('RST', 		'Recurso sanción tributaria', 								'Recurso sanción tributaria', 									'OP-32-DOCA-62',			'1',				'RST'		),
        T_TIPO_DATA('RMC', 		'Recurso multa coercitiva', 								'Recurso multa coercitiva', 									'OP-32-DOCA-63',			'1',				'RMC'		),
        T_TIPO_DATA('SBT', 		'Solicitud bonificación tributaria', 						'Solicitud bonificación tributaria', 							'OP-32-DOCA-64',			'1',				'SBT'		),
        T_TIPO_DATA('RSBT', 	'Recurso solicitud bonificación tributaria', 				'Recurso solicitud bonificación tributaria', 					'OP-32-DOCA-65',			'1',				'RSBT'		),
        T_TIPO_DATA('SSDR', 	'Solicitud suspensión de deudas recurridas', 				'Solicitud suspensión de deudas recurridas', 					'OP-32-DOCA-66',			'1',				'SSDR'		),
        T_TIPO_DATA('RSDR', 	'Recurso suspensión de deudas recurridas', 					'Recurso suspensión de deudas recurridas', 						'OP-32-DOCA-67',			'1',				'RSDR'		)
        
            
           
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_SCR_SUBCARTERA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TDT_TIPO_DOC_TRIBUTOS ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TDT_TIPO_DOC_TRIBUTOS WHERE DD_TDT_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS = 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TDT_TIPO_DOC_TRIBUTOS.NEXTVAL FROM DUAL';
         EXECUTE IMMEDIATE V_MSQL INTO V_ID;
         
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TDT_TIPO_DOC_TRIBUTOS (' ||
                     'DD_TDT_ID, DD_TDT_CODIGO, DD_TDT_DESCRIPCION, DD_TDT_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TDT_MATRICULA_GD, DD_TDT_VINCULABLE, DD_TDT_TPD_ID ) ' ||
                     'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''HREOS-7474'',SYSDATE,0, '''||TRIM(V_TMP_TIPO_DATA(4))||''', ' ||
					 ''''||TRIM(V_TMP_TIPO_DATA(5))||''', (SELECT DD_TPD_ID FROM DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') FROM DUAL';
         EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
        ELSE 
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO YA ESTÁ INSERTADO');
          
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TDT_TIPO_DOC_TRIBUTOS RELLENADO CORRECTAMENTE ');
   

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

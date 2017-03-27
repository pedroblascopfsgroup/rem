﻿--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20170319
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1727
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_MRF_MOTIVO_RECH_FACTURA_UR los datos añadidos de T_ARRAY_DATA
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

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_MRF_MOTIVO_RECH_FACT_UR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TRES_LETRAS_TABLA VARCHAR2(2400 CHAR) := 'MRF'; -- Vble. auxiliar para almacenar el sufijo de los campos de la tabla de ref.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(5012);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('000','Registro validado','0',' '),        
	T_TIPO_DATA('T01','Formato incorrecto: Error tamaño','0',' '),
        T_TIPO_DATA('T02','Formato incorrecto: Error tipo','0',' '),
        T_TIPO_DATA('F01','COACES no es un activo que exista en el aplicativo','1','WHERE NOT EXISTS (SELECT * FROM #TOKEN_Schema#.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO_UVEM = AUX.COACES)'),
        T_TIPO_DATA('F02','NUDNIR no es un comprador que exista en el aplicativo','1','WHERE NOT EXISTS (SELECT * FROM #TOKEN_Schema#.COM_COMPRADOR COM WHERE LPAD(COM.COM_DOCUMENTO, 10, ''''0'''') = AUX.NUDNIR)'),
        T_TIPO_DATA('F03','Expediente no existe para el par COACES (Activo) y NUDNIR (Comprador) en el aplicativo','1','WHERE NOT EXISTS (SELECT 1 FROM #TOKEN_Schema#.CEX_COMPRADOR_EXPEDIENTE CEX
JOIN #TOKEN_Schema#.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = CEX.ECO_ID JOIN #TOKEN_Schema#.ACT_OFR AO ON AO.OFR_ID = ECO.OFR_ID JOIN #TOKEN_Schema#.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID JOIN COM_COMPRADOR COM ON COM.COM_ID = CEX.COM_ID WHERE ACT.ACT_NUM_ACTIVO_UVEM = AUX.COACES AND LPAD(COM.COM_DOCUMENTO, 10, ''''0'''') = AUX.NUDNIR) AND AUX.NUDNIR is not null AND AUX.COACES is not null'),
	T_TIPO_DATA('F04','Valor de COSUFA no valido','1','WHERE AUX.COSUFA in (''''Q'''') ')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	

	--Comprobamos el dato a insertar
        V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET BORRADO = 1,  USUARIOBORRAR = ''DML'', FECHABORRAR = sysdate';
        EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO LOGICO A TODO LA TABLA: '||V_TEXT_TABLA||'] ');
        
	 
	-- LOOP para insertar los valores en la tabla indicada
    	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||'] ');
    	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      	LOOP
             	V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
	        --Comprobamos el dato a insertar
        	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TRES_LETRAS_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
	        --Si existe lo modificamos
        	IF V_NUM_TABLAS > 0 THEN				
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	       	  	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
		        		'SET DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION = '''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),0,100)||''''|| 
					', DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
					', PROCESO_VALIDAR = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', QUERY_ITER = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					', USUARIOBORRAR = null , FECHABORRAR = null, BORRADO = 0 '||
					'WHERE DD_'||V_TRES_LETRAS_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
			DBMS_OUTPUT.PUT_LINE(V_MSQL);
		  	EXECUTE IMMEDIATE V_MSQL;
		  	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          	--Si no existe, lo insertamos   
       		ELSE
       			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          		V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          		EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      		'DD_'||V_TRES_LETRAS_TABLA||'_ID, DD_'||V_TRES_LETRAS_TABLA||'_CODIGO, DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION,'||
				'DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER,' ||
				' VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      		'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),0,100)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','||
				''''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','||
                      		'0, ''DML'',SYSDATE,0 FROM DUAL';
				DBMS_OUTPUT.PUT_LINE(V_MSQL);
          		EXECUTE IMMEDIATE V_MSQL;
          		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        	END IF;
      	END LOOP;
    	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   
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


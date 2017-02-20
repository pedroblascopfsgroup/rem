--/*
--##########################################
--## AUTOR=Teresa Alonso
--## FECHA_CREACION=20161031
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-1086
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TEG_TIPO_ERROR_GASTO los datos añadidos de T_ARRAY_DATA
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

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TEG_TIPO_ERROR_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TRES_LETRAS_TABLA VARCHAR2(2400 CHAR) := 'TEG'; -- Vble. auxiliar para almacenar el sufijo de los campos de la tabla de ref.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('01' ,'Rechazo Formal REM'   ,'Rechazo REM: formal' ),
 	T_TIPO_DATA('02' ,'Rechazo HAYA'         ,'Rechazo Gestor Administración HAYA' ),
        T_TIPO_DATA('03' ,'Rechazo ASPRO SAREB'  ,'Rechazo ASPRO SAREB' ),
        T_TIPO_DATA('04' ,'Rechazo Formal BANKI' ,'Rechazo BANKIA: formal (COTERR) UVEM (BANKIA)' ),
        T_TIPO_DATA('05' ,'Rechazo GRM BANKIA'   ,'Rechazo BANKIA: Control presupuestario (COROLT) GRM BANKIA' ),
        T_TIPO_DATA('06' ,'Rechazo CONTAX BANKI' ,'Rechazo BANKIA: Contabilidad CONTAX BANKIA (COERPR)' )

    		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
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
		        		'SET DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_'||V_TRES_LETRAS_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		  	EXECUTE IMMEDIATE V_MSQL;
		  	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          	--Si no existe, lo insertamos   
       		ELSE
       			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          		V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          		EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      		'DD_'||V_TRES_LETRAS_TABLA||'_ID, DD_'||V_TRES_LETRAS_TABLA||'_CODIGO, DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION, DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION_LARGA,' ||
				' VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      		'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','||
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


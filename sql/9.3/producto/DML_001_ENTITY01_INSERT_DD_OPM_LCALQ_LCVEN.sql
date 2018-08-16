--/*
--##########################################
--## AUTOR=Angel Pastelero
--## FECHA_CREACION=20180813
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4399
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_OPM_OPERACION_MASIVA los datos añadidos en T_ARRAY_DATA
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_OPM_OPERACION_MASIVA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_FUN_DESC VARCHAR2(2400 CHAR) := 'MASIVO_LOTE_COMERCIAL'; -- Vble. auxiliar para almacenar la descripcion del registro en FUN_FUNCIONES.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		--  	CODIGO		DESCRIPCION						DESCRIPCION_LARGA					DD_OPM_VALIDACION_FORMATO
    		
		T_TIPO_DATA('AGAL'  ,'Agrupaciones: Agrupar activos (Lote com. Alquiler)'  	,'Agrupaciones: Agrupar activos (Lote comercial Alquiler)'	,'nT*,nD*')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE DD_OPM_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET USUARIOMODIFICAR = ''HREOS-4399'' , FECHAMODIFICAR = SYSDATE '||
					' , DD_OPM_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' , DD_OPM_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' '||
					' , DD_OPM_VALIDACION_FORMATO = '''||TRIM(V_TMP_TIPO_DATA(4))||''' '||
					' , FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||V_TEXT_FUN_DESC||''') '||
					' WHERE DD_OPM_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''  ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA CODIGO : '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          
       --Si no existe, lo insertamos   
       ELSE
  
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'DD_OPM_ID, DD_OPM_CODIGO, DD_OPM_DESCRIPCION, DD_OPM_DESCRIPCION_LARGA,FUN_ID,DD_OPM_VALIDACION_FORMATO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_OPM_RESULTADO) ' ||
                      	'VALUES ('|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						' , '''||V_TMP_TIPO_DATA(2)||''','''||V_TMP_TIPO_DATA(3)||''','''||V_TMP_TIPO_DATA(4)||''' ' ||
						' , (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||V_TEXT_FUN_DESC||''') '||
						' , 0, ''HREOS-4399'',SYSDATE,0,0)';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA CODIGO : '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

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

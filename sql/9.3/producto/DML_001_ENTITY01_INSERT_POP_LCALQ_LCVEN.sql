--/*
--##########################################
--## AUTOR=Angel Pastelero
--## FECHA_CREACION=20180813
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4399
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en POP_PLANTILLAS_OPERACION los datos añadidos en T_ARRAY_DATA
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'POP_PLANTILLAS_OPERACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		--  	CODIGO		DESCRIPCION		DESCRIPCION_LARGA
    		
		T_TIPO_DATA('AGRUPAR_ACTIVOS_LOTECOMERCIAL_ALQUILER'  ,'plantillas/plugin/masivo/AGRUPAR_ACTIVOS_LOTE_COMERCIAL_ALQUILER.xls'  ,'AGAL')
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
        			' WHERE POP_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET USUARIOMODIFICAR = ''HREOS-4399'' , FECHAMODIFICAR = SYSDATE '||
					' , POP_DIRECTORIO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' , DD_OPM_ID = (SELECT DD_OPM_ID FROM '|| V_ESQUEMA ||'.DD_OPM_OPERACION_MASIVA WHERE DD_OPM_CODIGO = '''||V_TMP_TIPO_DATA(3)||''' AND BORRADO = 0) '||
					' WHERE POP_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(1))||'''  AND BORRADO = 0';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA CODIGO : '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          
       --Si no existe, lo insertamos   
       ELSE
  
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'POP_ID, POP_NOMBRE, POP_DIRECTORIO, DD_OPM_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      	'VALUES ('|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' , '''||V_TMP_TIPO_DATA(2)||''' ' ||
						' , (SELECT DD_OPM_ID FROM '|| V_ESQUEMA ||'.DD_OPM_OPERACION_MASIVA WHERE DD_OPM_CODIGO = '''||V_TMP_TIPO_DATA(3)||''' AND BORRADO = 0) ' ||
						' , 0, ''HREOS-4399'',SYSDATE,0)';
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

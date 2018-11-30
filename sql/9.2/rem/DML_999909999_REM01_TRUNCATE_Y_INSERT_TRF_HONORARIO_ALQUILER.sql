--/*
--##########################################
--## AUTOR=JUAN RUIZ
--## FECHA_CREACION=20181129
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4859
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en TRF_HONORARIO_ALQUILER truncando y anyadiendo los datos añadidos en T_ARRAY_DATA para alquileres.
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
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TRF_HONORARIO_ALQUILER'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TRF'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--			        		TRF_LLAVES_HRE		DD_TPR_CODIGO		TRF_PRC_COLAB		TRF_PRC_PRESC
        T_TIPO_DATA(					'1',				'04',				'0',			    '10'),
        T_TIPO_DATA(					'0',				'04',				'4',			'0'),
        T_TIPO_DATA(					'0',				'28',				'4',			 '0'),
        T_TIPO_DATA(					'0',				'29',				'4',			 '0'),
        T_TIPO_DATA(					'0',				'18',				'4',			 '0')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- truncamos la tabla
    DBMS_OUTPUT.PUT_LINE('[INFO]: TRUNCATE '||V_TEXT_TABLA);
    
    V_SQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ';

        EXECUTE IMMEDIATE V_SQL;
        
        -- truncamos la tabla
    DBMS_OUTPUT.PUT_LINE('[INFO]: TABLA '||V_TEXT_TABLA||' VACIADA.');
        
    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
					WHERE TRF_LLAVES_HRE = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					' AND DD_TPR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' ';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe no hacemos nada
        IF V_NUM_TABLAS = 0 THEN
        
        -- Insertar datos.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR NUEVO REGISTRO');   
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'TRF_ID, TRF_LLAVES_HRE, DD_TPR_CODIGO, TRF_PRC_COLAB, TRF_PRC_PRESC, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||TRIM(V_TMP_TIPO_DATA(1))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''HREOS-4484'', to_timestamp(''29/10/18 12:46:17'',''DD/MM/RR HH24:MI:SSXFF''), ''HREOS-4859'', SYSDATE, 0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');  
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

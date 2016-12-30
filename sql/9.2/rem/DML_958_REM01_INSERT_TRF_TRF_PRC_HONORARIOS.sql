--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20161228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1325
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en TRF_TRF_PRC_HONORARIOS los datos añadidos en T_ARRAY_DATA.
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TRF_TRF_PRC_HONORARIOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TRF'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--			DD_CLA_CODIGO		DD_SCA_CODIGO		TRF_LLAVES_HRE		DD_TPR_CODIGO		TRF_PRC_COLAB		TRF_PRC_PRESC
-- Financiero.
        T_TIPO_DATA(	'01',				NULL,				'0',				'04',				'0,50',				'1,75'),
        T_TIPO_DATA(	'01',				NULL,				'0',				'28',				'0,50',				'1,75'),
        T_TIPO_DATA(	'01',				NULL,				'0',				'29',				'0,50',				'1,75'),
        T_TIPO_DATA(	'01',				NULL,				'0',				'30',				'0,50',				 NULL),
        T_TIPO_DATA(	'01',				NULL,				'0',				'31',				'0,50',				 NULL),
-- Inmobiliario, propio.
        T_TIPO_DATA(	'02',				'01',				'0',				'04',				'00000',			'00000'),
        T_TIPO_DATA(	'02',				'01',				'0',				'28',				'00000',		 	  '6'),
        T_TIPO_DATA(	'02',				'01',				'0',				'29',				'00000',			  '6'),
        T_TIPO_DATA(	'02',				'01',				'0',				'30',				'00000',			  NULL),
        T_TIPO_DATA(	'02',				'01',				'0',				'31',				'00000',			  NULL),
-- Inmobiliario, REO, NO LLAVES.
		T_TIPO_DATA(	'02',				'02',				'0',				'04',				'00000',			'00000'),
        T_TIPO_DATA(	'02',				'02',				'0',				'28',				'00000',		 	  '6'),
        T_TIPO_DATA(	'02',				'02',				'0',				'29',				'00000',			  '6'),
        T_TIPO_DATA(	'02',				'02',				'0',				'30',				'00000',			  NULL),
        T_TIPO_DATA(	'02',				'02',				'0',				'31',				'00000',			  NULL),
-- Inmobiliario, REO, LLAVES.
		T_TIPO_DATA(	'02',				'02',				'1',				'04',				  NULL,			    '00000'),
        T_TIPO_DATA(	'02',				'02',				'1',				'28',				'00000',		 	  '6'),
        T_TIPO_DATA(	'02',				'02',				'1',				'29',				'00000',			  '6'),
        T_TIPO_DATA(	'02',				'02',				'1',				'30',				  NULL,			 	  NULL),
        T_TIPO_DATA(	'02',				'02',				'1',				'31',				  NULL,				  NULL)
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

       	-- Insertar datos.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR NUEVO REGISTRO');   
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'TRF_ID, DD_CLA_CODIGO, DD_SCA_CODIGO, TRF_LLAVES_HRE, DD_TPR_CODIGO, TRF_PRC_COLAB, TRF_PRC_PRESC) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(5))||''','''||TRIM(V_TMP_TIPO_DATA(6))||''' FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

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
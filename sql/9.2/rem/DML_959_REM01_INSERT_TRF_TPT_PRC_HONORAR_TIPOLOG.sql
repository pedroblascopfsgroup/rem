--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20161228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1325
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en TRF_TPT_PRC_HONORAR_TIPOLOG los datos añadidos en T_ARRAY_DATA.
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TRF_TPT_PRC_HONORAR_TIPOLOG'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TPT'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--			DD_TPA_CODIGO		DD_SAC_CODIGO		TPT_PRC_COLAB		TPT_PRC_PRESC
        T_TIPO_DATA(	'03',				'13',				'0.75',				'2.25'),
        T_TIPO_DATA(	'03',				'14',				'00000',			'00000'),
        T_TIPO_DATA(	'03',				'15',				'00000',			'00000'),
        T_TIPO_DATA(	'05',				'19',				'00000',			'00000'),
        T_TIPO_DATA(	'05',				'20',				'00000',		    '00000'),
        T_TIPO_DATA(	'05',				'21',				'00000',			'00000'),
        T_TIPO_DATA(	'05',				'22',				'00000',		    '00000'),
        T_TIPO_DATA(	'04',				'17',				'00000',		    '00000'),
        T_TIPO_DATA(	'04',				'18',				'00000',			'00000'),
        T_TIPO_DATA(	'07',				'19',				'00000',			'00000'),
        T_TIPO_DATA(	'07',				'24',				'0.75',				'2.25'),
        T_TIPO_DATA(	'07',				'25',				'0.75',				'2.25'),
        T_TIPO_DATA(	'03',				'16',				'00000',			'00000'),
        T_TIPO_DATA(	'07',				'26',				'00000',			'00000'),
        T_TIPO_DATA(	'01',				'01',				'00000',			'00000'),
        T_TIPO_DATA(	'01',				'02',				'00000',			'00000'),
        T_TIPO_DATA(	'01',				'03',				'00000',			'00000'),
        T_TIPO_DATA(	'01',				'04',				'00000',			'00000'),
        T_TIPO_DATA(	'06',				'23',				'00000',			'00000'),
        T_TIPO_DATA(	'02',				'05',				'0.75',				'0.25'),
        T_TIPO_DATA(	'02',				'06',				'0.75',				'0.25'),
        T_TIPO_DATA(	'02',				'07',				'0.75',				'0.25'),
        T_TIPO_DATA(	'02',				'08',				'0.75',				'0.25'),
        T_TIPO_DATA(	'02',				'09',				'0.75',				'0.25'),
        T_TIPO_DATA(	'02',				'10',				'0.75',				'0.25'),
        T_TIPO_DATA(	'02',				'11',				'0.75',				'0.25'),
        T_TIPO_DATA(	'02',				'12',				'0.75',				'0.25')
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
                  'TPT_ID, DD_TPA_CODIGO, DD_SAC_CODIGO, TPT_PRC_COLAB, TPT_PRC_PRESC) ' ||
                  'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''' FROM DUAL';
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
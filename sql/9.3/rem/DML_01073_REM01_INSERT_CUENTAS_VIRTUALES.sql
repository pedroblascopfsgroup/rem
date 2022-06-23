--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20220530
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-18029
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade los datos del array en CVC_CUENTAS_VIRTUALES
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
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_ID NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'CVC_CUENTAS_VIRTUALES';
    V_CHARS VARCHAR2(3 CHAR):= 'CVC';
    V_TABLA_TIPO VARCHAR2(50 CHAR):= 'DD_SCR_SUBCARTERA';
    V_CHARS_TIPO VARCHAR2(50 CHAR):= 'SCR';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-18029';
    V_ID_SUP NUMBER(16);
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- CODIGO  			    DESCRIPCION                   DESCRIPCION_LARGA 
        T_TIPO_DATA('08', 'ES7301285312852836098685'),
        T_TIPO_DATA('09', 'ES7301285312852836098685'),
        T_TIPO_DATA('07', 'ES7301285312852836098685'),
        T_TIPO_DATA('19', 'ES7301285312852836098685'),
        T_TIPO_DATA('05', 'ES7301285312852836098685'),
        T_TIPO_DATA('14', 'ES7301285312852836098685'),
        T_TIPO_DATA('15', 'ES7301285312852836098685'),
        T_TIPO_DATA('06', 'ES7301285312852836098685'),
        T_TIPO_DATA('161', 'ES7301285312852836098685')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	 
      -- LOOP para insertar los valores -----------------------------------------------------------------

      FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_TIPO||' WHERE DD_'||V_CHARS_TIPO||'_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS2;

        IF V_NUM_TABLAS2 > 0 THEN

        V_SQL := 'SELECT DD_'||V_CHARS_TIPO||'_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TIPO||' WHERE DD_'||V_CHARS_TIPO||'_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_ID_SUP;

          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := '
            	INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
    				'||V_CHARS||'_ID, '||V_CHARS||'_CUENTA_VIRTUAL, DD_'||V_CHARS_TIPO||'_ID, VERSION, USUARIOCREAR, FECHACREAR)
            	SELECT 
    	            '|| V_ID || ',
    	            '''||V_TMP_TIPO_DATA(2)||''',
    	            '''||V_ID_SUP||''',
    	            0, '''||V_USUARIO||''', SYSDATE FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

        END IF;

      END LOOP;

  COMMIT;
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line(V_MSQL);
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20210923
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-15081
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade los datos del array en DD_RAT_RATING_SCORING_SERVICER
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
	
    V_ID NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'DD_RAT_RATING_SCORING_SERVICER';
    V_CHARS VARCHAR2(3 CHAR):= 'RAT';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-15081';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
              -- CODIGO  			CODIGO_C4C
      T_TIPO_DATA('01',			     '10'),
      T_TIPO_DATA('02',			     '20'),
      T_TIPO_DATA('03',			     '30'),
      T_TIPO_DATA('04',          '40'),
      T_TIPO_DATA('05',          '50'),
      T_TIPO_DATA('06',          '60'),
      T_TIPO_DATA('07',          '70'),
      T_TIPO_DATA('08',          '80'),
      T_TIPO_DATA('09',          '90')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	

	 
    -- LOOP para insertar los valores -----------------------------------------------------------------

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	
      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
        V_MSQL := '
          UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' 
          SET 
            DD_'||V_CHARS||'_CODIGO_C4C = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
	    USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE
			    WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
			    ';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

    END LOOP;
  COMMIT;
   

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

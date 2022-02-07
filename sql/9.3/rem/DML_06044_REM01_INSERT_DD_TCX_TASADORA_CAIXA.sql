--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211118
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16438
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TCX_TASADORA_CAIXA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('032','SOCIEDAD DE TASACION, S.A.','00001'),
      T_TIPO_DATA('012','VALTECNIC, S.A.','00002'),
      T_TIPO_DATA('011','TINSA, TASACIONES INMOBILIARIAS, S.A.','00003'),
      T_TIPO_DATA('027','TECNITASA','00004'),
      T_TIPO_DATA('037','VTH','00005'),
      T_TIPO_DATA('099','CBRE','00006'),
      T_TIPO_DATA('030','IBERTASA','00007'),
      T_TIPO_DATA('130','TASACIONES TH','00008'),
      T_TIPO_DATA('031','GESVALT','00009'),
      T_TIPO_DATA('043','KRATA','00010'),
      T_TIPO_DATA('403','UVE','00011'),
      T_TIPO_DATA('084','GLOVAL','00012'),
      T_TIPO_DATA('101','SAVILLS AGUIRRE NEWMAN','00013'),
      T_TIPO_DATA('008','JLL','00014'),
      T_TIPO_DATA('999','EUROTASA','90001'),
      T_TIPO_DATA('998','CIA.HISPANIA TASACIONES VALORACIONES,SA','90002'),
      T_TIPO_DATA('997','TASACIONES ANDALUZAS S.A.','90003'),
      T_TIPO_DATA('996','VALORACIO D ACTIUS, S.A.','90004'),
      T_TIPO_DATA('995','TASAHIPOTECARIA S.A.','90005'),
      T_TIPO_DATA('994','VALORACIONES FRASER, S.A.','90006'),
      T_TIPO_DATA('993','TABIMED, TASACIONES BIENES DEL MEDITERR','90007'),
      T_TIPO_DATA('992','ARCO VALORACIONES SA','90008'),
      T_TIPO_DATA('991','MURCIANA DE TASACIONES S.A','90009'),
      T_TIPO_DATA('990','GABINETE DE TASACIONES INMOBILIARIAS SA','90010'),
      T_TIPO_DATA('989','TASASUR, SOCIEDAD DE TASACIONES S.A','90011'),
      T_TIPO_DATA('988','EUROVALORACIONES S.A','90012'),
      T_TIPO_DATA('987','ALIA TASACIONES, S.A.','90013'),
      T_TIPO_DATA('986','SOCIEDAD INTEGRAL VALOR. AUTOMATIZADAS','90014'),
      T_TIPO_DATA('985','CAIXA LAIETANA-CAIXA D ESTALVIS LAIETANA','90015'),
      T_TIPO_DATA('984','VALMESA S.L','90016'),
      T_TIPO_DATA('983','TECGLEN TASACIONES, S.A.','90017'),
      T_TIPO_DATA('982','TASABALEAR S.A.','90018'),
      T_TIPO_DATA('981','TASACIONES HIPOTECARIAS RENTA, S.A.','90019'),
      T_TIPO_DATA('980','INTA S A SOCIEDAD DE TASACIONES','90020')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TCX_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN			
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CON CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' YA EXISTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
          (DD_TCX_ID
          , DD_TCX_CODIGO
          , DD_TCX_DESCRIPCION
          , DD_TCX_DESCRIPCION_LARGA 
          , DD_TCX_CODIGO_CAIXA
          , USUARIOCREAR
          , FECHACREAR) 
            SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
            , '''||V_TMP_TIPO_DATA(1)||'''
            , '''||TRIM(V_TMP_TIPO_DATA(2))||'''
            , '''||TRIM(V_TMP_TIPO_DATA(2))||'''
            , '''||TRIM(V_TMP_TIPO_DATA(3))||'''
            , ''HREOS-16438''
            , SYSDATE
            FROM DUAL';
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

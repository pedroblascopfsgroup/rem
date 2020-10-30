--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201028
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8293
--## PRODUCTO=NO
--##
--## Finalidad: Insertar tipos de documento al diccionario
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TPD_TIPO_DOCUMENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TPD'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8293';    

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('164',	'Impuesto sobre bienes inmuebles (IBI): recibo',	            'Impuesto sobre bienes inmuebles (IBI): recibo',              'AI-01-CERA-16'),
		  T_TIPO_DATA('165',	'Comunidad de propietarios: Certificado corriente de pago',	  'Comunidad de propietarios: Certificado corriente de pago',   'AI-01-CERA-DR'),
      T_TIPO_DATA('166',	'Usurpación: denuncia',	                                      'Usurpación: denuncia',                                       'AI-02-DOCJ-23')				
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
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
        -- Si existe se modifica.
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' SET
                      DD_'||V_TEXT_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                      DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                      DD_'||V_TEXT_CHARS||'_MATRICULA_GD = '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                      USUARIOMODIFICAR = '''||V_USUARIO||''',FECHAMODIFICAR = SYSDATE,
                      DD_'||V_TEXT_CHARS||'_VISIBLE = 0
					            WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;

          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_'||V_TEXT_CHARS||'_ID,DD_'||V_TEXT_CHARS||'_CODIGO,
					          DD_'||V_TEXT_CHARS||'_DESCRIPCION,DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA,DD_'||V_TEXT_CHARS||'_MATRICULA_GD,
					          USUARIOCREAR, FECHACREAR) 
                    SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,'''||V_TMP_TIPO_DATA(1)||''',
							      '''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''',
							      '''||TRIM(V_TMP_TIPO_DATA(4))||''','''||V_USUARIO||''', SYSDATE FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;

          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

       END IF;

      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

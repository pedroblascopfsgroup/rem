--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20221220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11424
--## PRODUCTO=NO
--##
--## Finalidad: Insertar tipos de documento al diccionario (activo y promocion)
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
    V_TEXT_TABLA_PROMOCION VARCHAR2(2400 CHAR) := 'DD_TDP_TIPO_DOC_PRO'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-11424';    

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('199','195',	'Carta de pago deuda acreditado','AI-01-CERA-DQ'),
		T_TIPO_DATA('200','196',	'Cédula / condiciones venta Vivienda de Protección Oficial (VPO)','AI-01-DOCA-39'),
        T_TIPO_DATA('201','197',	'Documentación concurso - check entrada','AI-01-DOCJ-DO'),
        T_TIPO_DATA('202','198',	'Documentación técnica entrada activo','AI-01-INTR-26'),
        T_TIPO_DATA('203','199',	'Escritura Obra Nueva / División Horizontal','AI-01-ESCR-13'),
        T_TIPO_DATA('204','200',	'Informe Admisibilidad: Detección de potencial Riesgo (BBVA)','AI-01-ESIN-DU'),
        T_TIPO_DATA('205','201',	'Informe Fiscal','AI-01-ESIN-86'),
        T_TIPO_DATA('206','202',	'Sanción - AN / Análisis de Recuperación','AI-01-ACUE-57')
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
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE (DD_TPD_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
                    OR DD_TPD_MATRICULA_GD = '''||TRIM(V_TMP_TIPO_DATA(4))||''') AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN

          DBMS_OUTPUT.PUT_LINE('[INFO]: EXISTE MATRICULA '''||TRIM(V_TMP_TIPO_DATA(4))||''' O CODIGO '''||TRIM(V_TMP_TIPO_DATA(1))||''' ('||V_TEXT_TABLA||')');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');
          
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_TPD_ID,DD_TPD_CODIGO,
					          DD_TPD_DESCRIPCION,DD_TPD_DESCRIPCION_LARGA,DD_TPD_MATRICULA_GD,
					          USUARIOCREAR, FECHACREAR,DD_TPD_VISIBLE)
                    SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,'''||V_TMP_TIPO_DATA(1)||''',
							      '''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''',
							      '''||TRIM(V_TMP_TIPO_DATA(4))||''','''||V_USUARIO||''', SYSDATE, 1 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;

          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE EN '||V_TEXT_TABLA||'');

       END IF;

       V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_PROMOCION||' WHERE (DD_TDP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
                    OR DD_TDP_MATRICULA_GD = '''||TRIM(V_TMP_TIPO_DATA(4))||''') AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN

          DBMS_OUTPUT.PUT_LINE('[INFO]: EXISTE MATRICULA '''||TRIM(V_TMP_TIPO_DATA(4))||''' O CODIGO '''||TRIM(V_TMP_TIPO_DATA(2))||''' ('||V_TEXT_TABLA_PROMOCION||')');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');
          
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_PROMOCION||' (DD_TDP_ID,DD_TDP_CODIGO,
					          DD_TDP_DESCRIPCION,DD_TDP_DESCRIPCION_LARGA,DD_TDP_MATRICULA_GD,
					          USUARIOCREAR, FECHACREAR) 
                    SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_PROMOCION||'.NEXTVAL,'''||V_TMP_TIPO_DATA(2)||''',
							      '''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''',
							      '''||TRIM(V_TMP_TIPO_DATA(4))||''','''||V_USUARIO||''', SYSDATE FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;

          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE EN '||V_TEXT_TABLA_PROMOCION||'');

       END IF;

      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' Y '||V_TEXT_TABLA_PROMOCION||' ACTUALIZADO CORRECTAMENTE ');

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

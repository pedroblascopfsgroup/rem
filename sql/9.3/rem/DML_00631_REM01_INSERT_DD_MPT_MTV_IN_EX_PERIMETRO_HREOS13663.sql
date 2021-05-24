--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210507
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13663
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_MPT_MTV_IN_EX_PERIMETRO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('23','Entrada/ salida de comercialización por Faseo comercial en la misma agrupación'),
      T_TIPO_DATA('24','0-Nivel Informativo - WIP CONS'),
      T_TIPO_DATA('25','30-Bloqueo Comercial - RSC Okupadas con Vulnerabilidad'),
      T_TIPO_DATA('26','10-Publicar sin precio. Venta tras aprobación - Canal Profesional - Okupadas sin Vulnerabilidad'),
      T_TIPO_DATA('27','20-No Publicación. Venta tras aprobacion - RSC Okupado en análisis vulnerabilidad'),
      T_TIPO_DATA('28','20-No Publicación. Venta tras aprobacion - Neo Esparta'),
      T_TIPO_DATA('29','0-Nivel Informativo - Resorts'),
      T_TIPO_DATA('30','10-Publicar sin precio. Venta tras aprobación - Suelos / WIP Gestión Valor'),
      T_TIPO_DATA('31','30-Bloqueo Comercial - RSC - Convenio AAPP Bloqueo'),
      T_TIPO_DATA('32','30-Bloqueo Comercial - RSC - Alquiler Social'),
      T_TIPO_DATA('33','20-No Publicación. Venta tras aprobacion - Darwin Esparta'),
      T_TIPO_DATA('34','0-Nivel Informativo - CONAPA'),
      T_TIPO_DATA('35','20-No Publicación. Venta tras aprobacion - Generalitat Valenciana'),
      T_TIPO_DATA('36','10-Publicar sin precio. Venta tras aprobación - Terciario Gestión Valor'),
      T_TIPO_DATA('37','10-Publicar sin precio. Venta tras aprobación - Rústicos en valor'),
      T_TIPO_DATA('38','20-No Publicación. Venta tras aprobacion - Gobierno Balear'),
      T_TIPO_DATA('39','30-Bloqueo Comercial - ROFO 4'),
      T_TIPO_DATA('40','30-Bloqueo Comercial - Esla'),
      T_TIPO_DATA('41','30-Bloqueo Comercial - Playa Macenas')
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
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
					WHERE DD_MPT_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE 
          -- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' no existe');

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_MPT_ID,
              DD_MPT_CODIGO,
              DD_MPT_DESCRIPCION,
              DD_MPT_DESCRIPCION_LARGA,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
               '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              0,
              ''HREOS-13663'',
              SYSDATE,
              0)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''');

        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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

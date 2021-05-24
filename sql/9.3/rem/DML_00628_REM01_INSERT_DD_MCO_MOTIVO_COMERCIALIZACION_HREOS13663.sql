--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210505
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_MCO_MOTIVO_COMERCIALIZACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('07','Precomercialización','05'),
      T_TIPO_DATA('08','Suelo/WIP Gestión Valor','06'),
      T_TIPO_DATA('09','Canal Profesional Okupadas sin Vulnerabilidad','07'),
      T_TIPO_DATA('10','Pndte información Suelo','08'),
      T_TIPO_DATA('11','Terciario Gestión Valor','09'),
      T_TIPO_DATA('12','PLAYA MACENAS','10'),
      T_TIPO_DATA('13','Proyecto Master No Publicable','11'),
      T_TIPO_DATA('14','RSC Okupado. En análisis vulnerabilidad','12'),
      T_TIPO_DATA('15','Bloqueo Total DPI Suelos','13'),
      T_TIPO_DATA('16','BLQ TOTAL DPI WIP/NNDD','14'),
      T_TIPO_DATA('17','ESLA','15'),
      T_TIPO_DATA('18','ROFO 4','16'),
      T_TIPO_DATA('19','RSC - Convenio AAPP Bloqueo','17'),
      T_TIPO_DATA('20','RSC Alquiler Social','18'),
      T_TIPO_DATA('21','RSC Okupadas con Vulnerabilidad','19')
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
					WHERE DD_MCO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE 
          -- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' no existe');

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_MCO_ID,
              DD_MCO_CODIGO,
              DD_MCO_DESCRIPCION,
              DD_MCO_DESCRIPCION_LARGA,
              DD_MPT_ID,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
               '||V_ESQUEMA||'.S_DD_MCO_MOT_COMERCIALIZACION.NEXTVAL,
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              (SELECT DD_MPT_ID FROM DD_MPT_MTV_IN_EX_PERIMETRO WHERE DD_MPT_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND BORRADO = 0),
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

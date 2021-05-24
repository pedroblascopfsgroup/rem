--/*
--##########################################
--## AUTOR=Héctor Crespo    
--## FECHA_CREACION=20210413
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13718
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
	  V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_EAS_ESTADO_ADECUACION_SAREB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                                                                                                --DD_EAC_ID
      T_TIPO_DATA('32','DESESTIMADA INVIABILIDAD COMERCIAL', 'DESESTIMADA INVIABILIDAD COMERCIAL', '21'),
      T_TIPO_DATA('33','DESESTIMADA INVIABILIDAD FINANCIERA', 'DESESTIMADA INVIABILIDAD FINANCIERA', '21'),
      T_TIPO_DATA('34','DESESTIMADA VENTA EN ESTADO ACTUAL', 'DESESTIMADA VENTA EN ESTADO ACTUAL', '21'),
      T_TIPO_DATA('35','RECLASIFICACION ALQUILER', 'RECLASIFICACION ALQUILER', ''),
      T_TIPO_DATA('36','RECLASIFICACION BLOQUEADA', 'RECLASIFICACION BLOQUEADA', ''),
      T_TIPO_DATA('37','RECLASIFICACION CCPP', 'RECLASIFICACION CCPP', ''),
      T_TIPO_DATA('38','RECLASIFICACION DDIIGP', 'RECLASIFICACION DDIIGP', ''),
      T_TIPO_DATA('39','RECLASIFICACION ESTRATEGIA COMERCIAL', 'RECLASIFICACION ESTRATEGIA COMERCIAL', ''),
      T_TIPO_DATA('40','RECLASIFICACION GESTION URBANISTICA', 'RECLASIFICACION GESTION URBANISTICA', ''),
      T_TIPO_DATA('41','RECLASIFICACION OCUPADA', 'RECLASIFICACION OCUPADA', ''),
      T_TIPO_DATA('42','RECLASIFICACION SIN POSESION', 'RECLASIFICACION SIN POSESION', '')
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
					WHERE DD_EAS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''' ya existe');
        ELSE
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_EAS_ID,
              DD_EAS_CODIGO,
              DD_EAS_DESCRIPCION,
              DD_EAS_DESCRIPCION_LARGA,
              DD_EAC_ID,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              '''||TRIM(V_TMP_TIPO_DATA(4))||''',
              0,
              ''HREOS-13718'',
              SYSDATE,
              0
                        )';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''.'''||TRIM(V_TMP_TIPO_DATA(2))||'''');
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

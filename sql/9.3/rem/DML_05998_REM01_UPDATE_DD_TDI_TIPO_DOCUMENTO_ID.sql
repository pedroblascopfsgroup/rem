--/*
--##########################################
--## AUTOR=Jesus JM
--## FECHA_CREACION=20210715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14607
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
	V_USUARIO VARCHAR2(50 CHAR):= 'HREOS-14607'; -- Configuracion Esquema Master
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TDI_TIPO_DOCUMENTO_ID'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('01','ES1'),
		T_TIPO_DATA('02','ES4'),
		T_TIPO_DATA('03','ZA4'),
		T_TIPO_DATA('04','ZA4'),
		T_TIPO_DATA('05','ZA4'),
		T_TIPO_DATA('06','ZA4'),
		T_TIPO_DATA('12','ES3'),
		T_TIPO_DATA('13','ES1'),
		T_TIPO_DATA('15','ES1')
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
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' TDI
					WHERE TDI.DD_TDI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND TDI.DD_TDI_CODIGO_C4C = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND TDI.BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(2))||''' para el campo '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' TDI SET
              TDI.DD_TDI_CODIGO_C4C = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
              , TDI.USUARIOMODIFICAR = '''||V_USUARIO||'''
              , TDI.FECHAMODIFICAR = SYSDATE
            WHERE TDI.DD_TDI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha actualizado el valor '''||TRIM(V_TMP_TIPO_DATA(2))||''' para '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
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

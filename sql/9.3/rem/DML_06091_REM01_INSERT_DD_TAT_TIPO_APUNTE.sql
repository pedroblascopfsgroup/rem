DD_TAT_TIPO_APUNTE--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20220329
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17187
--## PRODUCTO=NO
--##
--## Finalidad: INSERTAR DD_TAT_TIPO_APUNTE
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TAT_TIPO_APUNTE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CHARS VARCHAR2(6 CHAR) := 'TAT';
    V_USUARIO VARCHAR2(250 CHAR) := 'HREOS-17178';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --Codigo   Codigo Tbj   Descripcion Corta   Descripcion Larga
        T_TIPO_DATA('03','Visita al cliente','1','0'),
        T_TIPO_DATA('04','Llaves / acceso','1','0'),
        T_TIPO_DATA('05','Pte. Instrucciones ','1','0'),
        T_TIPO_DATA('06','Pte de aprobación presupuesto','1','0'),
        T_TIPO_DATA('07','Pte de material','1','0'),
        T_TIPO_DATA('08','Pte. de inquilino/tercero','1','0'),
        T_TIPO_DATA('09','Fecha previsto','1','0'),
        T_TIPO_DATA('10','Ilocalizable','1','0'),
        T_TIPO_DATA('11','Finalizado','1','0'),
        T_TIPO_DATA('12','Solicitud de información','0','1'),
        T_TIPO_DATA('13','Enviadas Instrucciones','0','1'),
        T_TIPO_DATA('14','Pto. Aprobado','0','1'),
        T_TIPO_DATA('15','Gestión llaves/acceso','0','1')
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
					WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          
          	DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE TIPO APUNTE CON CODIGO '''||TRIM(V_TMP_TIPO_DATA(1))||'''');

            -- Si existe se modifica.
            DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'
                    , DD_'||V_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
                    , DD_'||V_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
                    , DD_'||V_CHARS||'_PROVEEDOR = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
                    , DD_'||V_CHARS||'_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(4))||'''
                    , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                    , FECHAMODIFICAR = SYSDATE 
                    WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' / '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' MODIFICADO CORRECTAMENTE');

        ELSE 
          -- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' no existe en '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'');

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_'||V_CHARS||'_ID,
              DD_'||V_CHARS||'_CODIGO,
              DD_'||V_CHARS||'_DESCRIPCION,
              DD_'||V_CHARS||'_DESCRIPCION_LARGA,
              DD_'||V_CHARS||'_PROVEEDOR,
              DD_'||V_CHARS||'_GESTOR,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ESQUEMA||'.S_DD_'||V_CHARS||'_TIPO_APUNTE.NEXTVAL,
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              '''||TRIM(V_TMP_TIPO_DATA(4))||''',
              0,
              '''||V_USUARIO||''',
              SYSDATE,
              0)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''  /  '''||TRIM(V_TMP_TIPO_DATA(2))||''' /  '''||TRIM(V_TMP_TIPO_DATA(3))||''' ');

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
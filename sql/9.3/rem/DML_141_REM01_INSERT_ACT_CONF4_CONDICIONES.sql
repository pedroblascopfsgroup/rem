--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10515
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
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONF4_CONDICIONES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('001' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('002' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('003' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('004' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('001' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('002' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('003' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('004' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('005' , 'Cambia a alquilado o desde alquilado'),
      T_TIPO_DATA('005' , 'Cambia a reservado y el estado es anterior en REM'),
      T_TIPO_DATA('006' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('007' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('008' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('009' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('010' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('011' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('012' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('013' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('014' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('015' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('016' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('017' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('018' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('019' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('020' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('021' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('022' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('023' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('024' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('025' , 'Existen ofertas en vuelo'),
      T_TIPO_DATA('006' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('007' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('008' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('009' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('010' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('011' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('012' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('013' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('014' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('015' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('016' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('017' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('018' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('019' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('020' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('021' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('022' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('023' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('024' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('025' , 'Último cambio hecho por gestor HRE en últimos 30 días'),
      T_TIPO_DATA('026' , 'Valor en REM es Adjudicación judicial y recibido es distinto'),
      T_TIPO_DATA('027' , 'Valor en REM es Adjudicación judicial y recibido es distinto'),
      T_TIPO_DATA('026' , 'Valor en REM es Adjudicación no judicial y recibido es Liquidación de colateral o Adjudicación judicial'),
      T_TIPO_DATA('027' , 'Valor en REM es Adjudicación no judicial y recibido es Liquidación de colateral o Adjudicación judicial'),
      T_TIPO_DATA('028' , 'Se actualiza siempre que llegue S como Obtenido y en caso de N como vacío, en caso de no haber info en REM'),
      T_TIPO_DATA('029' , 'Se avisa si se recibe algo distinto de S y ya hay info en REM'),
      T_TIPO_DATA('030' , 'Último cambio hecho por gestor HRE en últimos 14 días'),
      T_TIPO_DATA('031' , 'Último cambio hecho por gestor HRE en últimos 14 días'),
      T_TIPO_DATA('032' , 'Último cambio hecho por gestor HRE en últimos 14 días'),
      T_TIPO_DATA('033' , 'Último cambio hecho por gestor HRE en últimos 14 días')
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
					WHERE AC2_ID = (SELECT AC2_ID FROM '||V_ESQUEMA||'.ACT_CONF2_ACCION WHERE AC2_ID = '''||TRIM(V_TMP_TIPO_DATA(1))||''') 
          AND AC4_CONDICION = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''.'''||TRIM(V_TMP_TIPO_DATA(2))||''' ya existe');
        ELSE
          -- Si no existe se inserta.
            V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              AC4_ID,
              AC2_ID,
              AC4_CONDICION,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ID||',
              (SELECT AC2_ID FROM '||V_ESQUEMA||'.ACT_CONF2_ACCION WHERE AC2_ID = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              0,
              ''HREOS-10515'',
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

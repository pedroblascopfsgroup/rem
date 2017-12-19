--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.8
--## INCIDENCIA_LINK=HREOS-3153
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en nuevos código a ciertos diccionarios
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
    V_USUARIOCREAR VARCHAR2(30 CHAR) := 'HREOS-3153';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --              DICCIONARIO                       CAMPO           CODIGO          DESCRIPCION                   DESCRIPCION_LARGA              PRV     LOC
        T_TIPO_DATA('DD_UPO_UNID_POBLACIONAL'         ,'DD_UPO'       ,'89990001'     ,'SANT PERE DE VILAMAJOR'     ,'SANT PERE DE VILAMAJOR'      ,'8'    ,'08234'),
        T_TIPO_DATA('DD_UPO_UNID_POBLACIONAL'         ,'DD_UPO'       ,'179990003'    ,'OIX'                        ,'OIX'                         ,'17'   ,'17114'),
        T_TIPO_DATA('DD_UPO_UNID_POBLACIONAL'         ,'DD_UPO'       ,'401550003'    ,'SAN CRISTOBAL DE SEGOVIA'   ,'SAN CRISTOBAL DE SEGOVIA'    ,'40'   ,'40155')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN 

  DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TMP_TIPO_DATA(1));
        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TMP_TIPO_DATA(1)||' WHERE '||V_TMP_TIPO_DATA(2)||'_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO EXISTENTE');
       ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| V_TMP_TIPO_DATA(3) ||'''');
          V_MSQL := 'SELECT '||V_ESQUEMA_M||'.S_'||V_TMP_TIPO_DATA(1)||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TMP_TIPO_DATA(1)||' (' ||
                      ''||V_TMP_TIPO_DATA(2)||'_ID, '||V_TMP_TIPO_DATA(2)||'_CODIGO, DD_LOC_ID, '||V_TMP_TIPO_DATA(2)||'_DESCRIPCION, '||V_TMP_TIPO_DATA(2)||'_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ', '''||V_TMP_TIPO_DATA(3)||''',(SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '''||V_TMP_TIPO_DATA(7)||'''), '''||V_TMP_TIPO_DATA(4)||''','''||V_TMP_TIPO_DATA(5)||''', 0, '''||V_USUARIOCREAR||''',SYSDATE,0 FROM DUAL';
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADO CORRECTAMENTE');
          DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TMP_TIPO_DATA(1)||' ACTUALIZADO CORRECTAMENTE ');
       END IF;
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

--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180625
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=REMVIP-916
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TTF_TIPO_TARIFA los datos añadidos en T_ARRAY_DATA
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
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-916';
  V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  V_ENTIDAD_ID NUMBER(16);
  V_ID NUMBER(16);
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    T_TIPO_DATA('BC01_1', 'Suministro y colocación de 1 cerradura en puerta de paso, tipo Fac''''s. Incluido descerraje.','37,19'),
    T_TIPO_DATA('BC01_2', 'Suministro y colocación de 2 cerraduras en puerta de paso, tipo Fac''''s. Incluido descerraje.','74,38'),
    T_TIPO_DATA('BC02_1', 'Suministro y colocación de cerradura de seguridad en puerta de paso. Incluido descerraje.','70,25'),
    T_TIPO_DATA('BC03_1', 'Suministro y colocación de 1 cadena entre 50-100 cm. de longitud y de mínimo 6mm de grosor, incluso candado de 60 mm arco normal acerado.','18'),
    T_TIPO_DATA('BC04_1', 'Suministro y colocación de cerradura de seguridad en puerta de paso especial. Incluido descerraje.','151,24'),
    T_TIPO_DATA('BC05_1', 'Modificar el cierre eléctrico de una puerta dejándolo como manual colocando una cerradura.','99,17'),
    T_TIPO_DATA('BC00', 'Cualquier obra que ocupe 1/2 día de dos operarios.','97,52'),
    T_TIPO_DATA('BC06', 'Intervención fallida (okupas, visitas infructuosas, informes).','25'),
    T_TIPO_DATA('BC07', 'Apertura de puerta (cuando no hay descerraje).','25')
  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN 

  DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  -- LOOP para insertar los valores en DD_TTF_TIPO_TARIFA -----------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TTF_TIPO_TARIFA] ');
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
  LOOP

    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

    --Comprobamos el dato a insertar
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    --Si existe lo modificamos
    IF V_NUM_TABLAS > 0 THEN        

      DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TTF_TIPO_TARIFA
        SET DD_TTF_DESCRIPCION = SUBSTR('''||TRIM(V_TMP_TIPO_DATA(2))||''',1,50)
          , DD_TTF_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
          , USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE 
        WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

    --Si no existe, lo insertamos   
    ELSE

      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
      V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TTF_TIPO_TARIFA.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ID; 
      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TTF_TIPO_TARIFA (DD_TTF_ID, DD_TTF_CODIGO, DD_TTF_DESCRIPCION, DD_TTF_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
        SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''',SUBSTR('''||TRIM(V_TMP_TIPO_DATA(2))||''',1,50),'''||TRIM(V_TMP_TIPO_DATA(2))||''', 0, '''||V_USUARIO||''',SYSDATE,0 FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

    END IF;

    --Insertamos o actualizamos en ACT_CFT_CONFIG_TARIFA
    V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_CFT_CONFIG_TARIFA T1
      USING (
          SELECT CFT.CFT_ID, TTF.DD_TTF_ID, TTR.DD_TTR_ID, STR.DD_STR_ID, CRA.DD_CRA_ID
              , '||V_TMP_TIPO_DATA(3)||' CFT_PRECIO_UNITARIO, ''€/un'' CFT_UNIDAD_MEDIDA
          FROM '|| V_ESQUEMA ||'.DD_TTF_TIPO_TARIFA TTF
          JOIN '|| V_ESQUEMA ||'.DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_CODIGO = ''03''
          JOIN '|| V_ESQUEMA ||'.DD_STR_SUBTIPO_TRABAJO STR ON STR.DD_TTR_ID = TTR.DD_TTR_ID AND STR.DD_STR_CODIGO = ''26''
          JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_CODIGO = ''02''
          LEFT JOIN '|| V_ESQUEMA ||'.ACT_CFT_CONFIG_TARIFA CFT ON CFT.DD_TTF_ID = TTF.DD_TTF_ID 
              AND CFT.DD_CRA_ID = CRA.DD_CRA_ID AND CFT.DD_TTR_ID = TTR.DD_TTR_ID 
              AND CFT.DD_STR_ID = STR.DD_STR_ID
          WHERE TTF.DD_TTF_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
          ) T2
      ON (T1.CFT_ID = T2.CFT_ID)
      WHEN MATCHED THEN UPDATE SET
          T1.CFT_PRECIO_UNITARIO = T2.CFT_PRECIO_UNITARIO,
          T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
      WHEN NOT MATCHED THEN INSERT 
          (T1.CFT_ID, T1.DD_TTF_ID, T1.DD_TTR_ID, T1.DD_STR_ID
          , T1.DD_CRA_ID, T1.CFT_PRECIO_UNITARIO, T1.CFT_UNIDAD_MEDIDA
          , T1.USUARIOCREAR, T1.FECHACREAR)
      VALUES ('|| V_ESQUEMA ||'.S_ACT_CFT_CONFIG_TARIFA.NEXTVAL, T2.DD_TTF_ID, T2.DD_TTR_ID, T2.DD_STR_ID
          , T2.DD_CRA_ID, T2.CFT_PRECIO_UNITARIO, T2.CFT_UNIDAD_MEDIDA
          , '''||V_USUARIO||''', SYSDATE)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTRO INSERTADO/ACTUALIZADO CORRECTAMENTE');

  END LOOP;

  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TTF_TIPO_TARIFA ACTUALIZADO CORRECTAMENTE ');

EXCEPTION
  WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(V_MSQL);
    DBMS_OUTPUT.put_line(err_msg);
    ROLLBACK;
    RAISE;          
END;
/
EXIT

--/*
--##########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20220512
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17803
--## PRODUCTO=NO
--## Finalidad:  Script que añade en PDE_PARAMETRIZACION_DEPOSITO los datos añadidos en T_ARRAY_DATA.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial (HREOS-17635) - Javier Esbri
--##        0.2 Cambio DD_EQG_ID por DD_TCR_ID (HREOS-17803) - Alejandro Valverde
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
    DD_TCR_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    DD_SCR_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    DD_EEC_ID NUMBER(16); -- Vble. para almacenar el id del estado del expediente
    V_TABLA VARCHAR2(2400 CHAR) := 'PDE_PARAMETRIZACION_DEPOSITO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(200 CHAR) := 'HREOS-17803';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    T_TIPO_DATA('01','05','3000',''),
    T_TIPO_DATA('01','06','3000',''),
    T_TIPO_DATA('01','07','3000',''),
    T_TIPO_DATA('01','08','3000',''),
    T_TIPO_DATA('01','09','3000',''),
    T_TIPO_DATA('01','14','3000',''),
    T_TIPO_DATA('01','15','3000',''),
    T_TIPO_DATA('01','19','3000',''),
    T_TIPO_DATA('01','160','3000',''),
    T_TIPO_DATA('01','161','3000',''),
    T_TIPO_DATA('02','05','1500','0'),
    T_TIPO_DATA('02','05','3000','60000'),
    T_TIPO_DATA('02','06','1500','0'),
    T_TIPO_DATA('02','06','3000','60000'),
    T_TIPO_DATA('02','07','1500','0'),
    T_TIPO_DATA('02','07','3000','60000'),
    T_TIPO_DATA('02','08','1500','0'),
    T_TIPO_DATA('02','08','3000','60000'),
    T_TIPO_DATA('02','09','1500','0'),
    T_TIPO_DATA('02','09','3000','60000'),
    T_TIPO_DATA('02','14','1500','0'),
    T_TIPO_DATA('02','14','3000','60000'),
    T_TIPO_DATA('02','15','1500','0'),
    T_TIPO_DATA('02','15','3000','60000'),
    T_TIPO_DATA('02','19','1500','0'),
    T_TIPO_DATA('02','19','3000','60000'),
    T_TIPO_DATA('02','160','1500','0'),
    T_TIPO_DATA('02','160','3000','60000'),
    T_TIPO_DATA('02','161','1500','0'),
    T_TIPO_DATA('02','161','3000','60000')


  ); 

    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        V_MSQL := 'SELECT DD_TCR_ID FROM '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR WHERE DD_TCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO DD_TCR_ID;
        V_MSQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO DD_SCR_ID;
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_TCR_ID = '''||DD_TCR_ID||'''
                AND DD_SCR_ID = '''||DD_SCR_ID||''' AND PDE_PRECIO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN				
 
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO YA EXISTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' - '''|| TRIM(V_TMP_TIPO_DATA(2))||'''');   
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (' ||
                      'PDE_ID ,DD_TCR_ID, DD_SCR_ID, PDE_IMPORTE, PDE_PRECIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||DD_TCR_ID||''','||DD_SCR_ID|| ','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''' ,0, '''||V_USUARIO||''',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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

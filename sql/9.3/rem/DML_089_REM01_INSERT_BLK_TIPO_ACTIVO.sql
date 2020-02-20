--/*
--##########################################
--## AUTOR=Mª José Ponce
--## FECHA_CREACION=20200115
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9210
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta los datos en la tabla BLK_TIPO_ACTIVO.
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de un registro.
    V_NUM_REGISTROS NUMBER(16); -- Vble. para validar la existencia de un registro.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'BLK_TIPO_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.    
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-9210'; -- Vble. auxiliar para almacenar el usuario crear    

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --T_TIPO_DATA(DD_TPA_CODIGO ,DD_SAC_CODIGO  ,BLK_TIPO_CODIGO ,'BLK_TIPO_DESCRIPCION')
        T_TIPO_DATA(  '02'          ,''             ,'01'            ,'HOUSING'),
        T_TIPO_DATA(  '07'          ,'24'           ,'02'            ,'PARKING & STORE ROOMS'),
        T_TIPO_DATA(  '07'          ,'25'           ,'03'            ,'PARKING & STORE ROOMS'),
        T_TIPO_DATA(  '03'          ,'13'           ,'04'            ,'PREMISES'),
        T_TIPO_DATA(  '03'          ,'14'           ,'05'            ,'COMMERCIAL'), --OFICINA/S PUEDE SER DEL DD_TAP/DD_SAC 03/14 Y 05/21
        T_TIPO_DATA(  '01'          ,''             ,'06'            ,'LAND'),
        T_TIPO_DATA(  '01'          ,'01'           ,'07'            ,'LAND'),
        T_TIPO_DATA(  '04'          ,''             ,'08'            ,'COMMERCIAL'),
        T_TIPO_DATA(  '03'          ,'15'           ,'09'            ,'COMMERCIAL'),
        T_TIPO_DATA(  '03'          ,'16'           ,'10'            ,'COMMERCIAL'),
        T_TIPO_DATA(  '05'          ,'22'           ,'11'            ,'COMMERCIAL'), --CENTRO COMERCIAL LO METO EN 05/22 EDIFICIO COMPLETO/COMERCIAL ¿ES CORRECTO?
        T_TIPO_DATA(  '07'          ,'26'           ,'12'            ,'WIP'), --WIP/OBRA PARADA LO METO EN 07/26 OTROS/OTROS ¿ES CORRECTO?
        T_TIPO_DATA(  '07'          ,''             ,'13'            ,'COMMERCIAL')
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
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE BLK_TIPO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;

        IF V_NUM_REGISTROS > 0 THEN		
          -- Si existe se modifica.
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(3)) ||'''');
          V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
          SET TIPO_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
          , DD_TPA_ID = (SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''');
          , DD_SAC_ID = (SELECT DD_SAC_ID FROM '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''');
          , BLK_TIPO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' 
          , BLK_TIPO_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||'''                     
          , USUARIOMODIFICAR = '''|| V_USUARIO ||''' 
          , FECHAMODIFICAR = SYSDATE 
          WHERE BLK_TIPO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
         
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

        ELSE		
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(3)) ||'''');          
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                      DD_TPA_ID, DD_SAC_ID, BLK_TIPO_CODIGO, BLK_TIPO_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                      SELECT  '''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(3))||''', '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''
                      , 0, '''|| V_USUARIO ||''', SYSDATE, 0 FROM DUAL';
          
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

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

EXIT
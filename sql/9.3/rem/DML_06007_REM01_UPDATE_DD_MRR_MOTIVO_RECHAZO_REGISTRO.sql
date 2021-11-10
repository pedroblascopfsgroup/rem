--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210922
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15254
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza los datos del array en DD_MRR_MOTIVO_RECHAZO_REGISTRO
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-15254] - Daniel Algaba
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
	
    V_ID NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'DD_MRR_MOTIVO_RECHAZO_REGISTRO';
    V_CHARS VARCHAR2(3 CHAR):= 'MRR';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-15254';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('F03','Activo sin estado posesorio','Activo sin estado posesorio',1,'WHERE AUX.FLAG_FICHEROS = ''''I'''' AND AUX.ESTADO_POSESORIO NOT IN (''''P01'''',''''P02'''',''''P03'''',''''P04'''',''''P05'''',''''P06'''')'),
        T_TIPO_DATA('F04','Activo sin estado titularidad','Activo sin estado titularidad',1,'LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV1 ON EQV1.DD_NOMBRE_CAIXA = ''''ESTADO_TITULARIDAD'''' AND EQV1.DD_CODIGO_CAIXA = AUX.ESTADO_TITULARIDAD AND EQV1.BORRADO = 0 LEFT JOIN '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO ETI ON ETI.DD_ETI_CODIGO = EQV1.DD_CODIGO_REM WHERE ETI.DD_ETI_ID IS NULL AND AUX.FLAG_FICHEROS = ''''I'''''),
        T_TIPO_DATA('F19','Formato de fecha del campo FEC_ESTADO_TITULARIDAD incorrecto','Formato de fecha del campo FEC_ESTADO_TITULARIDAD incorrecto',1,'WHERE AUX.FLAG_FICHEROS = ''''I'''' AND 0 = IS_VALIDATE_DATE(AUX.FEC_ESTADO_TITULARIDAD, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F20','Formato de fecha del campo FEC_ESTADO_POSESORIO incorrecto','Formato de fecha del campo FEC_ESTADO_POSESORIO incorrecto',1,'WHERE AUX.FLAG_FICHEROS = ''''I'''' AND 0 = IS_VALIDATE_DATE(AUX.FEC_ESTADO_POSESORIO, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F65','Activo sin fecha FEC_ESTADO_TITULARIDAD obligatoria','Activo sin fecha FEC_ESTADO_TITULARIDAD obligatoria',1,'WHERE AUX.FLAG_FICHEROS = ''''I'''' AND AUX.FEC_ESTADO_TITULARIDAD IS NULL'),
        T_TIPO_DATA('F66','Activo sin fecha FEC_ESTADO_POSESORIO obligatoria','Activo sin fecha FEC_ESTADO_POSESORIO obligatoria',1,'WHERE AUX.FLAG_FICHEROS = ''''I'''' AND AUX.FEC_ESTADO_POSESORIO IS NULL')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	

	 
    -- LOOP para insertar los valores -----------------------------------------------------------------

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	
      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN				
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
        V_MSQL := '
          UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' 
          SET 
            DD_'||V_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
            DD_'||V_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
            , PROCESO_VALIDAR = '||TRIM(V_TMP_TIPO_DATA(4))||'
            , QUERY_ITER = '''||TRIM(V_TMP_TIPO_DATA(5))||'''
            , USUARIOMODIFICAR = '''||V_USUARIO||'''
            , FECHAMODIFICAR = SYSDATE
			    WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
        
      --Si no existe, lo insertamos   
      ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := '
          	INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
				DD_'||V_CHARS||'_ID
        , DD_'||V_CHARS||'_CODIGO
        , DD_'||V_CHARS||'_DESCRIPCION
        , DD_'||V_CHARS||'_DESCRIPCION_LARGA
        , PROCESO_VALIDAR
        , QUERY_ITER
        ,	VERSION
        , USUARIOCREAR
        , FECHACREAR)
          	SELECT 
	            '|| V_ID || ',
	            '''||V_TMP_TIPO_DATA(1)||'''
              ,	'''||V_TMP_TIPO_DATA(2)||'''
              ,	'''||V_TMP_TIPO_DATA(3)||'''
              ,	'||V_TMP_TIPO_DATA(4)||'
              , '''||V_TMP_TIPO_DATA(5)||'''
              , 0
              , '''||V_USUARIO||'''
              , SYSDATE 
              FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
      
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

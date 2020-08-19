--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso Canovas
--## FECHA_CREACION=20200807
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7942
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_SQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7942'; --Vble. almacenar usuario
    V_TABLA VARCHAR2(50 CHAR) :='ACT_ACTIVO';--Vble. tabla modificar
    V_CRA_ID NUMBER(16); -- Vble. Almacenar id de la cartera
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('7025918'),
    	T_TIPO_DATA('7025919'),
    	T_TIPO_DATA('7025920'),
    	T_TIPO_DATA('7025921'),
    	T_TIPO_DATA('7025922'),
    	T_TIPO_DATA('7025923'),
    	T_TIPO_DATA('7025924'),
    	T_TIPO_DATA('7025925'),
    	T_TIPO_DATA('7025926'),
    	T_TIPO_DATA('7025927'),
    	T_TIPO_DATA('7025946'),
    	T_TIPO_DATA('7025957'),
    	T_TIPO_DATA('7025958'),
    	T_TIPO_DATA('7025959')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	
   DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN '||V_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_NUM_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS = 1 THEN
       	-- Si existe se actualiza.
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_DESCRIPCION = ''Cerberus''';

	EXECUTE IMMEDIATE V_SQL INTO V_CRA_ID;

		IF V_CRA_ID = 1 THEN

        		V_SQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_DESCRIPCION = ''Cerberus''),
				 USUARIOMODIFICAR = '''||V_USUARIO||''', 
				 FECHAMODIFICAR = SYSDATE 
				 WHERE ACT_NUM_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';

          	EXECUTE IMMEDIATE V_SQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado el registro con codigo '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO]: La cartera no existe');
		END IF;
	ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO NO EXISTE');

       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA||' ACTUALIZADA CORRECTAMENTE ');

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

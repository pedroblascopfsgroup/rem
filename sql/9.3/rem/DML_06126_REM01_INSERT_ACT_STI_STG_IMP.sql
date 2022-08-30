--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220726
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11782
--## PRODUCTO=NO
--## Finalidad:  Script que actualiza en DD_SEC_SUBEST_EXP_COMERCIAL los datos añadidos en T_ARRAY_DATA.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    DD_EEC_ID NUMBER(16); -- Vble. para almacenar el id del estado del expediente
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_STI_STG_IMP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(200 CHAR):='REMVIP-11782';
    V_COUNT NUMBER(16):=0;

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

        T_TIPO_DATA('319'),
        T_TIPO_DATA('320'),
        T_TIPO_DATA('321'),
        T_TIPO_DATA('322'),
        T_TIPO_DATA('323'),
        T_TIPO_DATA('324'),
        T_TIPO_DATA('325'),
        T_TIPO_DATA('326'),
        T_TIPO_DATA('327'),
        T_TIPO_DATA('328'),
        T_TIPO_DATA('329'),
        T_TIPO_DATA('330'),
        T_TIPO_DATA('331'),
        T_TIPO_DATA('332'),
        T_TIPO_DATA('333'),
        T_TIPO_DATA('334'),
        T_TIPO_DATA('335'),
        T_TIPO_DATA('336'),
        T_TIPO_DATA('337'),
        T_TIPO_DATA('338'),
        T_TIPO_DATA('339'),
        T_TIPO_DATA('340'),
        T_TIPO_DATA('341'),
        T_TIPO_DATA('342'),
        T_TIPO_DATA('343'),
        T_TIPO_DATA('344'),
        T_TIPO_DATA('345'),
        T_TIPO_DATA('346'),
        T_TIPO_DATA('347'),
        T_TIPO_DATA('348'),
        T_TIPO_DATA('114'),
        T_TIPO_DATA('115'),
        T_TIPO_DATA('116'),
        T_TIPO_DATA('117'),
        T_TIPO_DATA('118'),
        T_TIPO_DATA('119'),
        T_TIPO_DATA('120'),
        T_TIPO_DATA('121'),
        T_TIPO_DATA('122'),
        T_TIPO_DATA('123'),
        T_TIPO_DATA('124'),
        T_TIPO_DATA('125'),
        T_TIPO_DATA('126'),
        T_TIPO_DATA('127'),
        T_TIPO_DATA('128'),
        T_TIPO_DATA('129'),
        T_TIPO_DATA('130'),
        T_TIPO_DATA('131'),
        T_TIPO_DATA('132'),
        T_TIPO_DATA('133'),
        T_TIPO_DATA('134'),
        T_TIPO_DATA('135'),
        T_TIPO_DATA('136'),
        T_TIPO_DATA('137'),
        T_TIPO_DATA('138'),
        T_TIPO_DATA('139'),
        T_TIPO_DATA('140'),
        T_TIPO_DATA('141'),
        T_TIPO_DATA('142'),
        T_TIPO_DATA('143'),
        T_TIPO_DATA('144'),
        T_TIPO_DATA('145'),
        T_TIPO_DATA('146'),
        T_TIPO_DATA('147'),
        T_TIPO_DATA('148'),
        T_TIPO_DATA('149'),
        T_TIPO_DATA('150'),
        T_TIPO_DATA('151'),
        T_TIPO_DATA('152'),
        T_TIPO_DATA('153'),
        T_TIPO_DATA('154'),
        T_TIPO_DATA('155'),
        T_TIPO_DATA('156')

  ); 

    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        V_COUNT:=0;
        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG
        WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN	

            V_SQL :='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' STI
            JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID=STI.DD_STG_ID AND STG.BORRADO = 0
            WHERE STG.DD_STg_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 0 THEN

                V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (STI_ID, DD_STG_ID, DD_TIT_ID, STI_TIPO_IMPOSITIVO, VERSION, USUARIOCREAR, FECHACREAR) 
                    VALUES 
                    ('||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
                    (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_CODIGO='''||TRIM(V_TMP_TIPO_DATA(1))||'''),
                    (SELECT DD_TIT_ID FROM '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO WHERE DD_TIT_CODIGO=''01''), 21 , 0,'''||V_USUARIO||''', SYSDATE)';
                EXECUTE IMMEDIATE V_SQL;

                V_COUNT:= V_COUNT + SQL%ROWCOUNT;

                V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (STI_ID, DD_STG_ID, DD_TIT_ID, DD_CCA_ID, STI_TIPO_IMPOSITIVO, VERSION, USUARIOCREAR, FECHACREAR) 
                    VALUES 
                    ('||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
                    (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_CODIGO='''||TRIM(V_TMP_TIPO_DATA(1))||'''),
                    (SELECT DD_TIT_ID FROM '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO WHERE DD_TIT_CODIGO=''04''),
                    (SELECT DD_CCA_ID FROM '||V_ESQUEMA_M||'.DD_CCA_COMUNIDAD WHERE DD_CCA_CODIGO=''18''),
                    4 , 0,'''||V_USUARIO||''', SYSDATE)';
                EXECUTE IMMEDIATE V_SQL;

                V_COUNT:= V_COUNT + SQL%ROWCOUNT;

                V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (STI_ID, DD_STG_ID, DD_TIT_ID, DD_CCA_ID, STI_TIPO_IMPOSITIVO, VERSION, USUARIOCREAR, FECHACREAR) 
                    VALUES 
                    ('||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
                    (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_CODIGO='''||TRIM(V_TMP_TIPO_DATA(1))||'''),
                    (SELECT DD_TIT_ID FROM '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO WHERE DD_TIT_CODIGO=''04''),
                    (SELECT DD_CCA_ID FROM '||V_ESQUEMA_M||'.DD_CCA_COMUNIDAD WHERE DD_CCA_CODIGO=''19''),
                    4 , 0,'''||V_USUARIO||''', SYSDATE)';
                EXECUTE IMMEDIATE V_SQL;

                V_COUNT:= V_COUNT + SQL%ROWCOUNT;

                V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (STI_ID, DD_STG_ID, DD_TIT_ID, DD_CCA_ID, STI_TIPO_IMPOSITIVO, VERSION, USUARIOCREAR, FECHACREAR) 
                    VALUES 
                    ('||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
                    (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_CODIGO='''||TRIM(V_TMP_TIPO_DATA(1))||'''),
                    (SELECT DD_TIT_ID FROM '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO WHERE DD_TIT_CODIGO=''03''),
                    (SELECT DD_CCA_ID FROM '||V_ESQUEMA_M||'.DD_CCA_COMUNIDAD WHERE DD_CCA_CODIGO=''05''),
                    7 , 0,'''||V_USUARIO||''', SYSDATE)';
                EXECUTE IMMEDIATE V_SQL;

                V_COUNT:= V_COUNT + SQL%ROWCOUNT;

                IF V_COUNT < 4 THEN
                    DBMS_OUTPUT.PUT_LINE('[WARN]: SE HAN INSERTADO MENOS DE 4 PARA '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', CANTIDAD INSERTADA '''|| V_COUNT ||''' ');    
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
                END IF;

            ELSE
                DBMS_OUTPUT.PUT_LINE('[WARN]: YA EXISTE EN LA TABLA ALGUN REGISTRO PARA EL SUBTIPO DE GASTO: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
            END IF;

       ELSE
        DBMS_OUTPUT.PUT_LINE('[WARN]: NO EXISTE SUBTIPO DE GASTO: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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
--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210817
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10328
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade comentario en agenda
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'REMVIP-10328';

    V_TABLA_SAN VARCHAR2(2400 CHAR) := 'ACT_ASA_AGENDA_SANEAMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_OBS VARCHAR2(2400 CHAR) := 'ACT_AOB_ACTIVO_OBS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    V_OBS VARCHAR2(2400 CHAR):='Activos Recomprados. Se borran las fechas del trámite de inscripción, para que se completen con las de la nueva Recompra';
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- PRO_DOCIDENTIF   P20_PRORRATA
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
       T_TIPO_DATA('6880967'),
T_TIPO_DATA('6881953'),
T_TIPO_DATA('6880356'),
T_TIPO_DATA('6881954'),
T_TIPO_DATA('6884532'),
T_TIPO_DATA('6884533'),
T_TIPO_DATA('6882143'),
T_TIPO_DATA('6882270'),
T_TIPO_DATA('6882271'),
T_TIPO_DATA('6883536'),
T_TIPO_DATA('6882272'),
T_TIPO_DATA('6882976'),
T_TIPO_DATA('6882790'),
T_TIPO_DATA('6884534'),
T_TIPO_DATA('6882791'),
T_TIPO_DATA('6882977'),
T_TIPO_DATA('6883537'),
T_TIPO_DATA('6881361'),
T_TIPO_DATA('6884981'),
T_TIPO_DATA('6884535'),
T_TIPO_DATA('6883028'),
T_TIPO_DATA('6882306'),
T_TIPO_DATA('6883937'),
T_TIPO_DATA('6883401'),
T_TIPO_DATA('6883553'),
T_TIPO_DATA('6883029'),
T_TIPO_DATA('6883606'),
T_TIPO_DATA('6867777'),
T_TIPO_DATA('6865835'),
T_TIPO_DATA('6867778'),
T_TIPO_DATA('6867831'),
T_TIPO_DATA('6868290'),
T_TIPO_DATA('6867779'),
T_TIPO_DATA('6865839'),
T_TIPO_DATA('6865840'),
T_TIPO_DATA('6867268'),
T_TIPO_DATA('6867353'),
T_TIPO_DATA('6867780'),
T_TIPO_DATA('6865841'),
T_TIPO_DATA('6867781'),
T_TIPO_DATA('6867482'),
T_TIPO_DATA('6851783'),
T_TIPO_DATA('6852193'),
T_TIPO_DATA('6852194'),
T_TIPO_DATA('6850205'),
T_TIPO_DATA('6876380'),
T_TIPO_DATA('6875960'),
T_TIPO_DATA('6849949'),
T_TIPO_DATA('6880935'),
T_TIPO_DATA('6855684'),
T_TIPO_DATA('6854693'),
T_TIPO_DATA('6854928'),
T_TIPO_DATA('6856675'),
T_TIPO_DATA('6854929'),
T_TIPO_DATA('6854655'),
T_TIPO_DATA('6855570'),
T_TIPO_DATA('6855685'),
T_TIPO_DATA('6855571'),
T_TIPO_DATA('6854656'),
T_TIPO_DATA('6854728'),
T_TIPO_DATA('6856676'),
T_TIPO_DATA('6856677'),
T_TIPO_DATA('6854897'),
T_TIPO_DATA('6854175'),
T_TIPO_DATA('6854898'),
T_TIPO_DATA('6855572'),
T_TIPO_DATA('6855573'),
T_TIPO_DATA('6854760'),
T_TIPO_DATA('6855574'),
T_TIPO_DATA('6854657'),
T_TIPO_DATA('6854899'),
T_TIPO_DATA('6856678'),
T_TIPO_DATA('6854761'),
T_TIPO_DATA('6854900'),
T_TIPO_DATA('6854762'),
T_TIPO_DATA('6854658'),
T_TIPO_DATA('6854659'),
T_TIPO_DATA('6854901'),
T_TIPO_DATA('6854902'),
T_TIPO_DATA('6854729'),
T_TIPO_DATA('6856679'),
T_TIPO_DATA('6855376'),
T_TIPO_DATA('6854763'),
T_TIPO_DATA('6855377'),
T_TIPO_DATA('6855378'),
T_TIPO_DATA('6854799'),
T_TIPO_DATA('6854764'),
T_TIPO_DATA('6855379'),
T_TIPO_DATA('6854800'),
T_TIPO_DATA('6856680'),
T_TIPO_DATA('6855380'),
T_TIPO_DATA('6854801'),
T_TIPO_DATA('6854930'),
T_TIPO_DATA('6854931'),
T_TIPO_DATA('6854802'),
T_TIPO_DATA('6855277'),
T_TIPO_DATA('6855686'),
T_TIPO_DATA('6854803'),
T_TIPO_DATA('6854804'),
T_TIPO_DATA('6854903'),
T_TIPO_DATA('6855381'),
T_TIPO_DATA('6854805'),
T_TIPO_DATA('6854932'),
T_TIPO_DATA('6856681'),
T_TIPO_DATA('6854806'),
T_TIPO_DATA('6854904'),
T_TIPO_DATA('6857113'),
T_TIPO_DATA('6851835'),
T_TIPO_DATA('6947777'),
T_TIPO_DATA('6849476'),
T_TIPO_DATA('6850172'),
T_TIPO_DATA('6849477'),
T_TIPO_DATA('6848570'),
T_TIPO_DATA('6849061'),
T_TIPO_DATA('6850173'),
T_TIPO_DATA('6851173'),
T_TIPO_DATA('6851174'),
T_TIPO_DATA('6851175'),
T_TIPO_DATA('6850174'),
T_TIPO_DATA('6848572'),
T_TIPO_DATA('6849131'),
T_TIPO_DATA('6849496'),
T_TIPO_DATA('6849868'),
T_TIPO_DATA('6850177'),
T_TIPO_DATA('6849497'),
T_TIPO_DATA('6849498'),
T_TIPO_DATA('6849132'),
T_TIPO_DATA('6885320'),
T_TIPO_DATA('6966633')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

    -- LOOP para insertar los valores -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA_SAN||' ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_MSQL :='SELECT COUNT(1)
              FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
              WHERE ACT.BORRADO = 0 AND ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' ';

        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS>0 THEN

         V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_OBS||' (
                AOB_ID
                , ACT_ID
                , USU_ID
                , AOB_OBSERVACION
                , AOB_FECHA
                , USUARIOCREAR
                , FECHACREAR
                ,DD_TOB_ID
              )
              VALUES (
                '|| V_ESQUEMA ||'.S_'||V_TABLA_OBS||'.NEXTVAL
                , (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO= '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0)
                , (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME=''SUPER'')
                , '''||V_OBS||'''
                , TO_DATE(SYSDATE,''DD/MM/YYYY'')
                , '''||V_ITEM||'''
                , SYSDATE
                , (SELECT DD_TOB_ID FROM '||V_ESQUEMA||'.DD_TOB_TIPO_OBSERVACION WHERE BORRADO = 0 AND DD_TOB_CODIGO=''06'')
              )';

              EXECUTE IMMEDIATE V_MSQL;

               V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_SAN||' (
                ASA_ID
                , ACT_ID
                , DD_TAS_ID
                , DD_SAS_ID
                , ASA_OBSERVACIONES
                , ASA_FECHA_ALTA
                , USUARIOCREAR
                , FECHACREAR
                , AOB_ID
              )
              VALUES (
                '|| V_ESQUEMA ||'.S_'||V_TABLA_SAN||'.NEXTVAL
                , (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO= '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0)
                , (SELECT DD_TAS_ID FROM '||V_ESQUEMA||'.DD_TAS_TIPO_AGENDA_SAN WHERE DD_TAS_CODIGO=''PIN'')
                , (SELECT DD_SAS_ID FROM '||V_ESQUEMA||'.DD_SAS_SUBTIPO_AGENDA_SAN WHERE DD_SAS_CODIGO=''ETI'')
                , '''||V_OBS||'''
                , TO_DATE(SYSDATE,''DD/MM/YYYY'')
                , '''||V_ITEM||'''
                , SYSDATE
                , (SELECT AOB_ID FROM '||V_ESQUEMA||'.'||V_TABLA_OBS||' OBS
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=OBS.ACT_ID AND ACT.BORRADO = 0
                    WHERE OBS.BORRADO = 0 AND OBS.USUARIOCREAR='''||V_ITEM||''' AND ACT.ACT_NUM_ACTIVO='''||V_TMP_TIPO_DATA(1)||''')
              )';

              EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''||V_TMP_TIPO_DATA(1)||''' INSERTADO CORRECTAMENTE');
            

        ELSE
           DBMS_OUTPUT.PUT_LINE('[INFO]: No existe el activo '''||V_TMP_TIPO_DATA(1)||''' ');
        END IF;


        

      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TABLA_SAN||' MODIFICADA CORRECTAMENTE ');

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

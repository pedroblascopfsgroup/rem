--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210125
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8757
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar moratoria
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8757'; --Vble. auxiliar para almacenar el usuario

    V_TABLA VARCHAR2(100 CHAR) :='BIE_ADJ_ADJUDICACION'; --Vble. auxiliar para almacenar la tabla a insertar
    V_TABLA_ACTIVO VARCHAR2(100 CHAR) :='ACT_ACTIVO'; --Vble. auxiliar para almacenar la tabla de los activos a buscar
    V_TABLA_JUDICIAL VARCHAR2(100 CHAR) :='ACT_AJD_ADJJUDICIAL';

    V_ACT_ID NUMBER(16); --Vble para almacenar el id del activo
    V_BIE_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --ACT_NUM_ACTIVO
        T_TIPO_DATA('7234562'),
        T_TIPO_DATA('6810824'),
        T_TIPO_DATA('6079108'),
        T_TIPO_DATA('6076362'),
        T_TIPO_DATA('6811633'),
        T_TIPO_DATA('6525221'),
        T_TIPO_DATA('6079945'),
        T_TIPO_DATA('6079520'),
        T_TIPO_DATA('6078452'),
        T_TIPO_DATA('6711042'),
        T_TIPO_DATA('6081744'),
        T_TIPO_DATA('7032086'),
        T_TIPO_DATA('6077375'),
        T_TIPO_DATA('6077411'),
        T_TIPO_DATA('6811859'),
        T_TIPO_DATA('7292722'),
        T_TIPO_DATA('6798797'),
        T_TIPO_DATA('6076322'),
        T_TIPO_DATA('7293660'),
        T_TIPO_DATA('7300042'),
        T_TIPO_DATA('6078020'),
        T_TIPO_DATA('7300043'),
        T_TIPO_DATA('6076901'),
        T_TIPO_DATA('6934609'),
        T_TIPO_DATA('6079611'),
        T_TIPO_DATA('6711375'),
        T_TIPO_DATA('6791309'),
        T_TIPO_DATA('6711047'),
        T_TIPO_DATA('6788804'),
        T_TIPO_DATA('6081554'),
        T_TIPO_DATA('6076400'),
        T_TIPO_DATA('6078679'),
        T_TIPO_DATA('6135476'),
        T_TIPO_DATA('7071370'),
        T_TIPO_DATA('7224283'),
        T_TIPO_DATA('6889186'),
        T_TIPO_DATA('6782901'),
        T_TIPO_DATA('6346110'),
        T_TIPO_DATA('6346486'),
        T_TIPO_DATA('6133779'),
        T_TIPO_DATA('6083909'),
        T_TIPO_DATA('7007714'),
        T_TIPO_DATA('6886476'),
        T_TIPO_DATA('6885694'),
        T_TIPO_DATA('6843553'),
        T_TIPO_DATA('6780982'),
        T_TIPO_DATA('6780884'),
        T_TIPO_DATA('6134826'),
        T_TIPO_DATA('6135215'),
        T_TIPO_DATA('6134491'),
        T_TIPO_DATA('6078600'),
        T_TIPO_DATA('6076627'),
        T_TIPO_DATA('6080479'),
        T_TIPO_DATA('6075759'),
        T_TIPO_DATA('6134878'),
        T_TIPO_DATA('6076065'),
        T_TIPO_DATA('6076066'),
        T_TIPO_DATA('6134998'),
        T_TIPO_DATA('6079004'),
        T_TIPO_DATA('6083967'),
        T_TIPO_DATA('6029484'),
        T_TIPO_DATA('6819663'),
        T_TIPO_DATA('6032044'),
        T_TIPO_DATA('6824624'),
        T_TIPO_DATA('6827449'),
        T_TIPO_DATA('6827679'),
        T_TIPO_DATA('6076047'),
        T_TIPO_DATA('6953188'),
        T_TIPO_DATA('6959998'),
        T_TIPO_DATA('6029540'),
        T_TIPO_DATA('7303376'),
        T_TIPO_DATA('7100091'),
        T_TIPO_DATA('7089451'),
        T_TIPO_DATA('7075879'),
        T_TIPO_DATA('6965271'),
        T_TIPO_DATA('6780839'),
        T_TIPO_DATA('6076534'),
        T_TIPO_DATA('6080477'),
        T_TIPO_DATA('6077239'),
        T_TIPO_DATA('6964154'),
        T_TIPO_DATA('6831135'),
        T_TIPO_DATA('6745484'),
        T_TIPO_DATA('6745222'),
        T_TIPO_DATA('6136813')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;


BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EN '||V_TABLA);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLA_JUDICIAL||' WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||')';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        --Si existe el activoV_ACT_ID NUMBER(16);
        IF V_NUM_TABLAS = 1 THEN

            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;

            V_MSQL := 'SELECT BIE_ADJ_ID FROM '||V_ESQUEMA||'.'||V_TABLA_JUDICIAL||' WHERE ACT_ID = '||V_ACT_ID||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_BIE_ID;
               
            V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                        BIE_ADJ_F_RES_MORATORIA = TO_DATE(''15/05/2024'',''DD/MM/YYYY''),
                        DD_FAV_ID = (SELECT DD_FAV_ID FROM '||V_ESQUEMA||'.APR_AUX_DD_FAV_FAVORABLE WHERE DD_FAV_CODIGO = ''01''),
                        USUARIOMODIFICAR = '''||V_USUARIO||''',
                        FECHAMODIFICAR = SYSDATE                            
                        WHERE BIE_ADJ_ID = '||V_BIE_ID||'';

            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: SE HA MODIFICADO LA MORATORIA DEL ACTIVO: '''||V_TMP_TIPO_DATA(1)||''' ');

        ELSE

            --Si no existe activo
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL BIEN DEL ACTIVO:'''||V_TMP_TIPO_DATA(1)||''' ');

        END IF;

    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
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
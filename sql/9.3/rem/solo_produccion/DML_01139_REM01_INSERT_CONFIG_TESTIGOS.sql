--/*
--######################################### 
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11125
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES: INSERCION DATOS RECOMENDACIONES
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
    V_NUM_CRA NUMBER(16);
    V_NUM_SCR NUMBER(16);
    V_NUM_TCO NUMBER(16);
    V_NUM_EQG NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TOB_TESTIGOS_OBLIGATORIOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-11125';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                --  CRA  SCR  TCO  EQG  DESC
    	T_TIPO_DATA('01','01','01','01','1'),
        T_TIPO_DATA('01','02','01','01','1'),
        T_TIPO_DATA('02','03','01','01','1'),
        T_TIPO_DATA('02','04','01','01','1'),
        T_TIPO_DATA('04','10','01','01','1'),
        T_TIPO_DATA('04','20','01','01','1'),
        T_TIPO_DATA('05','12','01','01','1'),
        T_TIPO_DATA('06','16','01','01','1'),
        T_TIPO_DATA('07','134','01','01','1'),
        T_TIPO_DATA('07','133','01','01','1'),
        T_TIPO_DATA('07','152','01','01','1'),
        T_TIPO_DATA('07','151','01','01','1'),
        T_TIPO_DATA('07','138','01','01','1'),
        T_TIPO_DATA('07','37','01','01','1'),
        T_TIPO_DATA('07','38','01','01','1'),
        T_TIPO_DATA('07','39','01','01','1'),
        T_TIPO_DATA('07','17','01','01','1'),
        T_TIPO_DATA('07','135','01','01','1'),
        T_TIPO_DATA('07','137','01','01','1'),
        T_TIPO_DATA('07','70','01','01','1'),
        T_TIPO_DATA('08','64','01','01','1'),
        T_TIPO_DATA('08','136','01','01','1'),
        T_TIPO_DATA('08','60','01','01','1'),
        T_TIPO_DATA('08','59','01','01','1'),
        T_TIPO_DATA('08','58','01','01','1'),
        T_TIPO_DATA('08','57','01','01','1'),
        T_TIPO_DATA('08','18','01','01','1'),
        T_TIPO_DATA('08','56','01','01','1'),
        T_TIPO_DATA('10','23','01','01','1'),
        T_TIPO_DATA('10','24','01','01','1'),
        T_TIPO_DATA('11','61','01','01','1'),
        T_TIPO_DATA('11','62','01','01','1'),
        T_TIPO_DATA('11','63','01','01','1'),
        T_TIPO_DATA('11','25','01','01','1'),
        T_TIPO_DATA('11','27','01','01','1'),
        T_TIPO_DATA('11','28','01','01','1'),
        T_TIPO_DATA('11','29','01','01','1'),
        T_TIPO_DATA('11','30','01','01','1'),
        T_TIPO_DATA('11','31','01','01','1'),
        T_TIPO_DATA('11','032','01','01','1'),
        T_TIPO_DATA('11','139','01','01','1'),
        T_TIPO_DATA('11','140','01','01','1'),
        T_TIPO_DATA('11','65','01','01','1'),
        T_TIPO_DATA('11','68','01','01','1'),
        T_TIPO_DATA('12','32','01','01','1'),
        T_TIPO_DATA('12','33','01','01','1'),
        T_TIPO_DATA('12','34','01','01','1'),
        T_TIPO_DATA('12','35','01','01','1'),
        T_TIPO_DATA('12','36','01','01','1'),
        T_TIPO_DATA('13','41','01','01','1'),
        T_TIPO_DATA('14','','01','01','1'),
        T_TIPO_DATA('15','40','01','01','1'),
        T_TIPO_DATA('16','153','01','01','1'),
        T_TIPO_DATA('16','154','01','01','1'),
        T_TIPO_DATA('16','155','01','01','1'),
        T_TIPO_DATA('16','156','01','01','1'),
        T_TIPO_DATA('16','157','01','01','1'),
        T_TIPO_DATA('16','158','01','01','1'),
        T_TIPO_DATA('03','05','01','01','1'),
        T_TIPO_DATA('03','14','01','01','1'),
        T_TIPO_DATA('03','09','01','01','1'),
        T_TIPO_DATA('03','08','01','01','1'),
        T_TIPO_DATA('03','06','01','01','1'),
        T_TIPO_DATA('03','15','01','01','1'),
        T_TIPO_DATA('03','19','01','01','1'),
        T_TIPO_DATA('01','01','01','02','1'),
        T_TIPO_DATA('01','02','01','02','1'),
        T_TIPO_DATA('02','03','01','02','1'),
        T_TIPO_DATA('02','04','01','02','1'),
        T_TIPO_DATA('04','10','01','02','1'),
        T_TIPO_DATA('04','20','01','02','1'),
        T_TIPO_DATA('05','12','01','02','1'),
        T_TIPO_DATA('06','16','01','02','1'),
        T_TIPO_DATA('07','134','01','02','1'),
        T_TIPO_DATA('07','133','01','02','1'),
        T_TIPO_DATA('07','152','01','02','1'),
        T_TIPO_DATA('07','151','01','02','1'),
        T_TIPO_DATA('07','138','01','02','1'),
        T_TIPO_DATA('07','37','01','02','1'),
        T_TIPO_DATA('07','38','01','02','1'),
        T_TIPO_DATA('07','39','01','02','1'),
        T_TIPO_DATA('07','17','01','02','1'),
        T_TIPO_DATA('07','135','01','02','1'),
        T_TIPO_DATA('07','137','01','02','1'),
        T_TIPO_DATA('07','70','01','02','1'),
        T_TIPO_DATA('08','64','01','02','1'),
        T_TIPO_DATA('08','136','01','02','1'),
        T_TIPO_DATA('08','60','01','02','1'),
        T_TIPO_DATA('08','59','01','02','1'),
        T_TIPO_DATA('08','58','01','02','1'),
        T_TIPO_DATA('08','57','01','02','1'),
        T_TIPO_DATA('08','18','01','02','1'),
        T_TIPO_DATA('08','56','01','02','1'),
        T_TIPO_DATA('10','23','01','02','1'),
        T_TIPO_DATA('10','24','01','02','1'),
        T_TIPO_DATA('11','61','01','02','1'),
        T_TIPO_DATA('11','62','01','02','1'),
        T_TIPO_DATA('11','63','01','02','1'),
        T_TIPO_DATA('11','25','01','02','1'),
        T_TIPO_DATA('11','27','01','02','1'),
        T_TIPO_DATA('11','28','01','02','1'),
        T_TIPO_DATA('11','29','01','02','1'),
        T_TIPO_DATA('11','30','01','02','1'),
        T_TIPO_DATA('11','31','01','02','1'),
        T_TIPO_DATA('11','032','01','02','1'),
        T_TIPO_DATA('11','139','01','02','1'),
        T_TIPO_DATA('11','140','01','02','1'),
        T_TIPO_DATA('11','65','01','02','1'),
        T_TIPO_DATA('11','68','01','02','1'),
        T_TIPO_DATA('12','32','01','02','1'),
        T_TIPO_DATA('12','33','01','02','1'),
        T_TIPO_DATA('12','34','01','02','1'),
        T_TIPO_DATA('12','35','01','02','1'),
        T_TIPO_DATA('12','36','01','02','1'),
        T_TIPO_DATA('13','41','01','02','1'),
        T_TIPO_DATA('14','','01','02','1'),
        T_TIPO_DATA('15','40','01','02','1'),
        T_TIPO_DATA('16','153','01','02','1'),
        T_TIPO_DATA('16','154','01','02','1'),
        T_TIPO_DATA('16','155','01','02','1'),
        T_TIPO_DATA('16','156','01','02','1'),
        T_TIPO_DATA('16','157','01','02','1'),
        T_TIPO_DATA('16','158','01','02','1'),
        T_TIPO_DATA('03','05','01','02','1'),
        T_TIPO_DATA('03','14','01','02','1'),
        T_TIPO_DATA('03','09','01','02','1'),
        T_TIPO_DATA('03','08','01','02','1'),
        T_TIPO_DATA('03','06','01','02','1'),
        T_TIPO_DATA('03','15','01','02','1'),
        T_TIPO_DATA('03','19','01','02','1')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_CRA;

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(2)||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_SCR;

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||V_TMP_TIPO_DATA(3)||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TCO;

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EQG_EQUIPO_GESTION WHERE DD_EQG_CODIGO = '''||V_TMP_TIPO_DATA(4)||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_EQG;

        IF V_NUM_CRA = 1 AND V_NUM_SCR = 1 AND V_NUM_TCO = 1 AND V_NUM_EQG = 1 THEN	

            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' TOB
                            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = TOB.DD_CRA_ID AND CRA.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = TOB.DD_SCR_ID AND SCR.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = TOB.DD_TCO_ID AND TCO.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_EQG_EQUIPO_GESTION EQG ON EQG.DD_EQG_ID = TOB.DD_EQG_ID AND EQG.BORRADO = 0
                            WHERE TOB.BORRADO = 0 AND DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''
                            AND DD_TCO_CODIGO = '''||V_TMP_TIPO_DATA(3)||''' AND DD_EQG_CODIGO = '''||V_TMP_TIPO_DATA(4)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
            -- Si existe se modifica.
            IF V_NUM_TABLAS = 0 THEN				
            
                    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS REGISTRO');
                    V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (TOB_ID,DD_CRA_ID,DD_SCR_ID,DD_TCO_ID,DD_EQG_ID,TOB_PORCENTAJE_DESC,
                                        TOB_REQUIERE_TESTIGOS,USUARIOCREAR,FECHACREAR) VALUES (
                                        '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
                                        (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''),
                                        (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
                                        (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''),
                                        (SELECT DD_EQG_ID FROM '||V_ESQUEMA||'.DD_EQG_EQUIPO_GESTION WHERE DD_EQG_CODIGO = '''||V_TMP_TIPO_DATA(4)||'''),
                                        '''||V_TMP_TIPO_DATA(5)||''', 1, '''||V_USUARIO||''', SYSDATE)';
                    EXECUTE IMMEDIATE V_MSQL;
                    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE UNA CONFIGURACION:  CARTERA = '''||V_TMP_TIPO_DATA(1)||''',
                                    SUBCARTERA = '''||V_TMP_TIPO_DATA(2)||''' ,TIPO_COMERCIALIZACION = '''||V_TMP_TIPO_DATA(3)||''',
                                    EQUIPO_GESTION = '''||V_TMP_TIPO_DATA(4)||'''');

            END IF;

        ELSIF V_NUM_CRA = 1 AND V_NUM_SCR = 0 AND V_NUM_TCO = 1 AND V_NUM_EQG = 1 THEN	

            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO SIN SUBCARTERA PARA CARTERA = '''||V_TMP_TIPO_DATA(1)||'''');

            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' TOB
                            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = TOB.DD_CRA_ID AND CRA.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = TOB.DD_TCO_ID AND TCO.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_EQG_EQUIPO_GESTION EQG ON EQG.DD_EQG_ID = TOB.DD_EQG_ID AND EQG.BORRADO = 0
                            WHERE TOB.BORRADO = 0 AND DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND TOB.DD_SCR_ID IS NULL
                            AND DD_TCO_CODIGO = '''||V_TMP_TIPO_DATA(3)||''' AND DD_EQG_CODIGO = '''||V_TMP_TIPO_DATA(4)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
            -- Si existe se modifica.
            IF V_NUM_TABLAS = 0 THEN				
            
                    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS REGISTRO');
                    V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (TOB_ID,DD_CRA_ID,DD_TCO_ID,DD_EQG_ID,TOB_PORCENTAJE_DESC,
                                        TOB_REQUIERE_TESTIGOS,USUARIOCREAR,FECHACREAR) VALUES (
                                        '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
                                        (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''),
                                        (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''),
                                        (SELECT DD_EQG_ID FROM '||V_ESQUEMA||'.DD_EQG_EQUIPO_GESTION WHERE DD_EQG_CODIGO = '''||V_TMP_TIPO_DATA(4)||'''),
                                        '''||V_TMP_TIPO_DATA(5)||''', 1, '''||V_USUARIO||''', SYSDATE)';
                    EXECUTE IMMEDIATE V_MSQL;
                    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE UNA CONFIGURACION:  CARTERA = '''||V_TMP_TIPO_DATA(1)||''',
                                    TIPO_COMERCIALIZACION = '''||V_TMP_TIPO_DATA(3)||''',EQUIPO_GESTION = '''||V_TMP_TIPO_DATA(4)||'''');

            END IF;
        
        ELSE
            
            DBMS_OUTPUT.PUT_LINE('[INFO]: ALGUN DICCIONARIO ES INCORRECTO. CONFIG:  CARTERA = '''||V_TMP_TIPO_DATA(1)||''',
                                     SUBCARTERA = '''||V_TMP_TIPO_DATA(2)||''' ,TIPO_COMERCIALIZACION = '''||V_TMP_TIPO_DATA(3)||''',
                                     EQUIPO_GESTION = '''||V_TMP_TIPO_DATA(4)||'''');

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
EXIT;

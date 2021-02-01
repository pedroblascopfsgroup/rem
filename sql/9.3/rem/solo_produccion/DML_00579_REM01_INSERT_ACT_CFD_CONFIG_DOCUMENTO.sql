--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201216
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8402
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Insertar nueva configuración de lógica aplica/no aplica
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8402'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_CFD_CONFIG_DOCUMENTO'; --Vble. auxiliar para almacenar la tabla a insertar

    V_ID_TIPO NUMBER(16); 
    V_ID_SUBTIPO NUMBER(16); 
    V_ID_DOCUMENTO NUMBER(16); 

    V_COUNT NUMBER(16):=0; --Vble. para contar registros correctos
    V_COUNT_TOTAL NUMBER(16):=0; --Vble para contar registros totales
    
    	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		T_TIPO_DATA('03','13','11','1'),
            T_TIPO_DATA('03','13','25','1'),
            T_TIPO_DATA('03','13','13','1'),
            T_TIPO_DATA('03','14','11','0'),
            T_TIPO_DATA('03','14','25','0'),
            T_TIPO_DATA('03','14','13','0'),
            T_TIPO_DATA('03','15','11','0'),
            T_TIPO_DATA('03','15','25','0'),
            T_TIPO_DATA('03','15','13','0'),
            T_TIPO_DATA('03','16','11','1'),
            T_TIPO_DATA('03','16','25','1'),
            T_TIPO_DATA('03','16','13','1'),
            T_TIPO_DATA('03','28','11','0'),
            T_TIPO_DATA('03','28','25','0'),
            T_TIPO_DATA('03','28','13','0'),
            T_TIPO_DATA('03','29','11','0'),
            T_TIPO_DATA('03','29','25','0'),
            T_TIPO_DATA('03','29','13','0'),
            T_TIPO_DATA('09','33','11','0'),
            T_TIPO_DATA('09','33','25','0'),
            T_TIPO_DATA('09','33','13','0'),
            T_TIPO_DATA('08','30','11','0'),
            T_TIPO_DATA('08','30','25','0'),
            T_TIPO_DATA('08','30','13','0'),
            T_TIPO_DATA('08','31','11','0'),
            T_TIPO_DATA('08','31','25','0'),
            T_TIPO_DATA('08','31','13','0'),
            T_TIPO_DATA('08','32','11','0'),
            T_TIPO_DATA('08','32','25','0'),
            T_TIPO_DATA('08','32','13','0'),
            T_TIPO_DATA('08','34','11','0'),
            T_TIPO_DATA('08','34','25','0'),
            T_TIPO_DATA('08','34','13','0'),
            T_TIPO_DATA('08','39','11','0'),
            T_TIPO_DATA('08','39','25','0'),
            T_TIPO_DATA('08','39','13','0'),
            T_TIPO_DATA('05','19','11','0'),
            T_TIPO_DATA('05','19','25','0'),
            T_TIPO_DATA('05','19','13','0'),
            T_TIPO_DATA('05','20','11','1'),
            T_TIPO_DATA('05','20','25','1'),
            T_TIPO_DATA('05','20','13','1'),
            T_TIPO_DATA('05','21','11','0'),
            T_TIPO_DATA('05','21','25','0'),
            T_TIPO_DATA('05','21','13','0'),
            T_TIPO_DATA('05','22','11','1'),
            T_TIPO_DATA('05','22','25','1'),
            T_TIPO_DATA('05','22','13','1'),
            T_TIPO_DATA('06','23','11','0'),
            T_TIPO_DATA('06','23','25','0'),
            T_TIPO_DATA('06','23','13','0'),
            T_TIPO_DATA('04','17','11','0'),
            T_TIPO_DATA('04','17','25','0'),
            T_TIPO_DATA('04','17','13','0'),
            T_TIPO_DATA('04','18','11','0'),
            T_TIPO_DATA('04','18','25','0'),
            T_TIPO_DATA('04','18','13','0'),
            T_TIPO_DATA('04','37','11','0'),
            T_TIPO_DATA('04','37','25','0'),
            T_TIPO_DATA('04','37','13','0'),
            T_TIPO_DATA('07','24','11','0'),
            T_TIPO_DATA('07','24','25','0'),
            T_TIPO_DATA('07','24','13','0'),
            T_TIPO_DATA('07','25','11','0'),
            T_TIPO_DATA('07','25','25','0'),
            T_TIPO_DATA('07','25','13','0'),
            T_TIPO_DATA('07','26','11','0'),
            T_TIPO_DATA('07','26','25','0'),
            T_TIPO_DATA('07','26','13','0'),
            T_TIPO_DATA('07','35','11','0'),
            T_TIPO_DATA('07','35','25','0'),
            T_TIPO_DATA('07','35','13','0'),
            T_TIPO_DATA('07','36','11','0'),
            T_TIPO_DATA('07','36','25','0'),
            T_TIPO_DATA('07','36','13','0'),
            T_TIPO_DATA('07','38','11','1'),
            T_TIPO_DATA('07','38','25','1'),
            T_TIPO_DATA('07','38','13','1'),
            T_TIPO_DATA('01','01','11','0'),
            T_TIPO_DATA('01','01','25','0'),
            T_TIPO_DATA('01','01','13','0'),
            T_TIPO_DATA('01','02','11','0'),
            T_TIPO_DATA('01','02','25','0'),
            T_TIPO_DATA('01','02','13','0'),
            T_TIPO_DATA('01','03','11','0'),
            T_TIPO_DATA('01','03','25','0'),
            T_TIPO_DATA('01','03','13','0'),
            T_TIPO_DATA('01','04','11','0'),
            T_TIPO_DATA('01','04','25','0'),
            T_TIPO_DATA('01','04','13','0'),
            T_TIPO_DATA('01','27','11','0'),
            T_TIPO_DATA('01','27','25','0'),
            T_TIPO_DATA('01','27','13','0'),
            T_TIPO_DATA('02','05','11','1'),
            T_TIPO_DATA('02','05','25','1'),
            T_TIPO_DATA('02','05','13','1'),
            T_TIPO_DATA('02','06','11','1'),
            T_TIPO_DATA('02','06','25','1'),
            T_TIPO_DATA('02','06','13','1'),
            T_TIPO_DATA('02','07','11','1'),
            T_TIPO_DATA('02','07','25','1'),
            T_TIPO_DATA('02','07','13','1'),
            T_TIPO_DATA('02','08','11','1'),
            T_TIPO_DATA('02','08','25','1'),
            T_TIPO_DATA('02','08','13','1'),
            T_TIPO_DATA('02','09','11','1'),
            T_TIPO_DATA('02','09','25','1'),
            T_TIPO_DATA('02','09','13','1'),
            T_TIPO_DATA('02','10','11','1'),
            T_TIPO_DATA('02','10','25','1'),
            T_TIPO_DATA('02','10','13','1'),
            T_TIPO_DATA('02','11','11','1'),
            T_TIPO_DATA('02','11','25','1'),
            T_TIPO_DATA('02','11','13','1'),
            T_TIPO_DATA('02','12','11','1'),
            T_TIPO_DATA('02','12','25','1'),
            T_TIPO_DATA('02','12','13','1')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;


BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EN '||V_TABLA);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	    LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;
        

        --Obtenemos el id del tipo
        V_MSQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '||V_TMP_TIPO_DATA(1)||' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID_TIPO;

        --Obtenemos el id del subtipo
        V_MSQL := 'SELECT DD_SAC_ID FROM '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '||V_TMP_TIPO_DATA(2)||' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID_SUBTIPO;

        --Obtenemos el id del documento
        V_MSQL := 'SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = '||V_TMP_TIPO_DATA(3)||' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID_DOCUMENTO;

        --Insertamos el registro
        V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (CFD_ID, DD_TPA_ID, DD_TPD_ID, CFD_OBLIGATORIO, USUARIOCREAR, FECHACREAR, DD_SAC_ID) 
                    VALUES (
                    '|| V_ESQUEMA ||'.S_'|| V_TABLA ||'.NEXTVAL,    
                    '||V_ID_TIPO||',
                    '||V_ID_DOCUMENTO||',
                    '||V_TMP_TIPO_DATA(4)||',
                    '''||V_USUARIO||''',
                    SYSDATE,
                    '||V_ID_SUBTIPO||')';
        EXECUTE IMMEDIATE V_MSQL;


        V_COUNT:=V_COUNT+1;    	

    END LOOP;

    
    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN]: SE HAN INSERTADO '''||V_COUNT||''' CONFIGURACIONES ');
    
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
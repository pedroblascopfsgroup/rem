--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9069
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar precio cliente trabajo
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9069'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_ID_PROVEEDOR NUMBER(16); -- Vble. para el id del proveedor

    V_TABLA VARCHAR2(50 CHAR):= 'ACT_TBJ_TRABAJO'; --Vble. Tabla a modificar proveedores
   

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('916964335564','78,085'),
            T_TIPO_DATA('9000273714','1711,5795'),
            T_TIPO_DATA('916964371173','934,8005'),
            T_TIPO_DATA('9000254231','73,4275'),
            T_TIPO_DATA('916950106610','90,206'),
            T_TIPO_DATA('916950104244','530,587'),
            T_TIPO_DATA('916950101311','91,103'),
            T_TIPO_DATA('916950100861','331,2805'),
            T_TIPO_DATA('9000303126','287,5'),
            T_TIPO_DATA('9000273081','289,4435'),
            T_TIPO_DATA('9000286221','939,3775'),
            T_TIPO_DATA('9000289489','430,15175'),
            T_TIPO_DATA('9000282375','3063,0595'),
            T_TIPO_DATA('9000284109','358,018'),
            T_TIPO_DATA('9000295530','341,205'),
            T_TIPO_DATA('9000278338','2067,493'),
            T_TIPO_DATA('9000289467','761,76'),
            T_TIPO_DATA('9000293593','993,6575'),
            T_TIPO_DATA('9000277725','287,5'),
            T_TIPO_DATA('9000298663','111,044'),
            T_TIPO_DATA('9000267682','292,33'),
            T_TIPO_DATA('9000259852','380,88'),
            T_TIPO_DATA('9000264975','365,884'),
            T_TIPO_DATA('9000263862','1820,542'),
            T_TIPO_DATA('9000276279','122,9695'),
            T_TIPO_DATA('9000266657','1190,9975'),
            T_TIPO_DATA('9000278709','1033,4015'),
            T_TIPO_DATA('9000239368','31,05'),
            T_TIPO_DATA('9000243292','472,8455'),
            T_TIPO_DATA('9000244097','775,3185'),
            T_TIPO_DATA('9000255673','1997,872'),
            T_TIPO_DATA('9000223008','318,55'),
            T_TIPO_DATA('9000164948','33,8675'),
            T_TIPO_DATA('916964371579','69'),
            T_TIPO_DATA('916964372952','127,51'),
            T_TIPO_DATA('916964375884','66,125'),
            T_TIPO_DATA('916964375883','128,2825'),
            T_TIPO_DATA('916964349230','579,6'),
            T_TIPO_DATA('916964326937','576,01'),
            T_TIPO_DATA('916964326938','579,6'),
            T_TIPO_DATA('916964371439','208,66'),
            T_TIPO_DATA('916964353883','652,68'),
            T_TIPO_DATA('916964354717','476,33'),
            T_TIPO_DATA('916964354728','31,52'),
            T_TIPO_DATA('916964353906','429,5'),
            T_TIPO_DATA('916964353903','429,5'),
            T_TIPO_DATA('916964354653','476,33'),
            T_TIPO_DATA('9000212471','2438,2415'),
            T_TIPO_DATA('9000072829','2445,2795'),
            T_TIPO_DATA('9000306265','6159,883'),
            T_TIPO_DATA('916964326937','576,01'),
            T_TIPO_DATA('916964326938','579,6'),
            T_TIPO_DATA('916964371439','208,66'),
            T_TIPO_DATA('916964368443','331,2805'),
            T_TIPO_DATA('916964371211','414'),
            T_TIPO_DATA('916964371173','934,8005'),
            T_TIPO_DATA('916964375502','443,8655'),
            T_TIPO_DATA('916964370000','1818,288'),
            T_TIPO_DATA('916964378413','395,0825'),
            T_TIPO_DATA('916964378424','285,3955'),
            T_TIPO_DATA('916964378440','33,8675'),
            T_TIPO_DATA('916964378461','109,687'),
            T_TIPO_DATA('916964378464','82,5815'),
            T_TIPO_DATA('9000249691','33,8675'),
            T_TIPO_DATA('9000258164','43,7'),
            T_TIPO_DATA('9000254231','73,4275'),
            T_TIPO_DATA('9000273714','1711,5795'),
            T_TIPO_DATA('9000137754','207'),
            T_TIPO_DATA('916964371254','226,4005'),
            T_TIPO_DATA('916964389866','1020,6595'),
            T_TIPO_DATA('916964373857','225,3885'),
            T_TIPO_DATA('9000226164','253'),
            T_TIPO_DATA('916964352758','661,94'),
            T_TIPO_DATA('916964379549','144,9'),
            T_TIPO_DATA('924567806429','414'),
            T_TIPO_DATA('924567806384','1615,7615'),
            T_TIPO_DATA('924567806427','576,01'),
            T_TIPO_DATA('924567806431','208,66'),
            T_TIPO_DATA('924567806430','127,51'),
            T_TIPO_DATA('924567806350','62,53'),
            T_TIPO_DATA('924567806378','226,04'),
            T_TIPO_DATA('924567806348','1226,6475'),
            T_TIPO_DATA('924567806369','46,3'),
            T_TIPO_DATA('924567806386','579,6'),
            T_TIPO_DATA('924567806395','621'),
            T_TIPO_DATA('924567806393','460'),
            T_TIPO_DATA('924567806406','21,6775'),
            T_TIPO_DATA('924567806404','358,892'),
            T_TIPO_DATA('9000298663','111,044')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;


BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS PRECIO TRABAJO CLIENTE');
    
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
            LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

            --Comprobamos la existencia del trabajo
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO='||V_TMP_TIPO_DATA(1)||' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

            IF V_COUNT = 1 THEN

   		 --Actualizamos IMPORTE
                    V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                    TBJ_IMPORTE_TOTAL='''||V_TMP_TIPO_DATA(2)||''',
                    USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE TBJ_NUM_TRABAJO='||V_TMP_TIPO_DATA(1)||'';

                    EXECUTE IMMEDIATE V_MSQL;

                    DBMS_OUTPUT.PUT_LINE('[INFO]: TRABAJO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');

            ELSE 
                DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL TRABAJO '''||V_TMP_TIPO_DATA(1)||'''');
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
EXIT;

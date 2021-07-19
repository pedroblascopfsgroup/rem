--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210713
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10161
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10161'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ACT_ID NUMBER(16);
    V_TIT_ID NUMBER(16);
    V_ESP_ID NUMBER(16);
    V_ETI_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                T_TIPO_DATA('7005639'),
                T_TIPO_DATA('7006013'),
                T_TIPO_DATA('7006466'),
                T_TIPO_DATA('7006541'),
                T_TIPO_DATA('7006593'),
                T_TIPO_DATA('7006815'),
                T_TIPO_DATA('7006862'),
                T_TIPO_DATA('7006871'),
                T_TIPO_DATA('7006892'),
                T_TIPO_DATA('7006936'),
                T_TIPO_DATA('7006942'),
                T_TIPO_DATA('7006994'),
                T_TIPO_DATA('7007024'),
                T_TIPO_DATA('7007080'),
                T_TIPO_DATA('7007100'),
                T_TIPO_DATA('7007104'),
                T_TIPO_DATA('7007165'),
                T_TIPO_DATA('7007197'),
                T_TIPO_DATA('7007198'),
                T_TIPO_DATA('7007223'),
                T_TIPO_DATA('7007334'),
                T_TIPO_DATA('7007376'),
                T_TIPO_DATA('7007380'),
                T_TIPO_DATA('7007398'),
                T_TIPO_DATA('7007537'),
                T_TIPO_DATA('7008043'),
                T_TIPO_DATA('7008212'),
                T_TIPO_DATA('90223900'),
                T_TIPO_DATA('90256359'),
                T_TIPO_DATA('90260014'),
                T_TIPO_DATA('90260500'),
                T_TIPO_DATA('90263395'),
                T_TIPO_DATA('90264209'),
                T_TIPO_DATA('90266530'),
                T_TIPO_DATA('90267876'),
                T_TIPO_DATA('90269090'),
                T_TIPO_DATA('90269502'),
                T_TIPO_DATA('90270295'),
                T_TIPO_DATA('90272491'),
                T_TIPO_DATA('90273376'),
                T_TIPO_DATA('90273920'),
                T_TIPO_DATA('90274104'),
                T_TIPO_DATA('90274435'),
                T_TIPO_DATA('90274681'),
                T_TIPO_DATA('90275582'),
                T_TIPO_DATA('90275589'),
                T_TIPO_DATA('90275603'),
                T_TIPO_DATA('90276561'),
                T_TIPO_DATA('90276651'),
                T_TIPO_DATA('90276840'),
                T_TIPO_DATA('90277090'),
                T_TIPO_DATA('90277183'),
                T_TIPO_DATA('90277778'),
                T_TIPO_DATA('90278183'),
                T_TIPO_DATA('90278561'),
                T_TIPO_DATA('90278729'),
                T_TIPO_DATA('90279065'),
                T_TIPO_DATA('90279752'),
                T_TIPO_DATA('90279885'),
                T_TIPO_DATA('90280137'),
                T_TIPO_DATA('90280218'),
                T_TIPO_DATA('90280598'),
                T_TIPO_DATA('90280799'),
                T_TIPO_DATA('90280889'),
                T_TIPO_DATA('90281499'),
                T_TIPO_DATA('90281694'),
                T_TIPO_DATA('90282068'),
                T_TIPO_DATA('90282325'),
                T_TIPO_DATA('90282477'),
                T_TIPO_DATA('90282493'),
                T_TIPO_DATA('90282609'),
                T_TIPO_DATA('90282777'),
                T_TIPO_DATA('90283048'),
                T_TIPO_DATA('90283164'),
                T_TIPO_DATA('90283174'),
                T_TIPO_DATA('90283254'),
                T_TIPO_DATA('90283322'),
                T_TIPO_DATA('90283437'),
                T_TIPO_DATA('90283441'),
                T_TIPO_DATA('90283444'),
                T_TIPO_DATA('90283498'),
                T_TIPO_DATA('90283705'),
                T_TIPO_DATA('90284209'),
                T_TIPO_DATA('90284483'),
                T_TIPO_DATA('90284585'),
                T_TIPO_DATA('90284637'),
                T_TIPO_DATA('90284647'),
                T_TIPO_DATA('90284653'),
                T_TIPO_DATA('90284831'),
                T_TIPO_DATA('90284845'),
                T_TIPO_DATA('90285737'),
                T_TIPO_DATA('90285872'),
                T_TIPO_DATA('90286611'),
                T_TIPO_DATA('90286658'),
                T_TIPO_DATA('90286883'),
                T_TIPO_DATA('90287123'),
                T_TIPO_DATA('90287615'),
                T_TIPO_DATA('90288411'),
                T_TIPO_DATA('90289688'),
                T_TIPO_DATA('90289994'),
                T_TIPO_DATA('90290074'),
                T_TIPO_DATA('90290076'),
                T_TIPO_DATA('90290077'),
                T_TIPO_DATA('90290232'),
                T_TIPO_DATA('90290318'),
                T_TIPO_DATA('90290535'),
                T_TIPO_DATA('90290710'),
                T_TIPO_DATA('90290773'),
                T_TIPO_DATA('90290790'),
                T_TIPO_DATA('90290861'),
                T_TIPO_DATA('90290977'),
                T_TIPO_DATA('90291050'),
                T_TIPO_DATA('90291232'),
                T_TIPO_DATA('90291530'),
                T_TIPO_DATA('90291623'),
                T_TIPO_DATA('90291656'),
                T_TIPO_DATA('90291924'),
                T_TIPO_DATA('90291929'),
                T_TIPO_DATA('90291998'),
                T_TIPO_DATA('90292073'),
                T_TIPO_DATA('90292272'),
                T_TIPO_DATA('90292437'),
                T_TIPO_DATA('90293066'),
                T_TIPO_DATA('90293068'),
                T_TIPO_DATA('90293351'),
                T_TIPO_DATA('90293554'),
                T_TIPO_DATA('90293621'),
                T_TIPO_DATA('90293639'),
                T_TIPO_DATA('90293892'),
                T_TIPO_DATA('90294082'),
                T_TIPO_DATA('90294555'),
                T_TIPO_DATA('90294716'),
                T_TIPO_DATA('90294818'),
                T_TIPO_DATA('90294828'),
                T_TIPO_DATA('90294843'),
                T_TIPO_DATA('90295451'),
                T_TIPO_DATA('90295926'),
                T_TIPO_DATA('90295941'),
                T_TIPO_DATA('90296342'),
                T_TIPO_DATA('90296362'),
                T_TIPO_DATA('90296423'),
                T_TIPO_DATA('90296861'),
                T_TIPO_DATA('90297032'),
                T_TIPO_DATA('90297062'),
                T_TIPO_DATA('90297280'),
                T_TIPO_DATA('90297379'),
                T_TIPO_DATA('90297494'),
                T_TIPO_DATA('90297694'),
                T_TIPO_DATA('90297796'),
                T_TIPO_DATA('90297805'),
                T_TIPO_DATA('90297898'),
                T_TIPO_DATA('90298028'),
                T_TIPO_DATA('90298272'),
                T_TIPO_DATA('90298737'),
                T_TIPO_DATA('90299105'),
                T_TIPO_DATA('90299133'),
                T_TIPO_DATA('90299470'),
                T_TIPO_DATA('90300646'),
                T_TIPO_DATA('90300910'),
                T_TIPO_DATA('90300953'),
                T_TIPO_DATA('90301174'),
                T_TIPO_DATA('90301302'),
                T_TIPO_DATA('90301353'),
                T_TIPO_DATA('90301389'),
                T_TIPO_DATA('90301460'),
                T_TIPO_DATA('90301543'),
                T_TIPO_DATA('90301953'),
                T_TIPO_DATA('90302112'),
                T_TIPO_DATA('90302267'),
                T_TIPO_DATA('90302514'),
                T_TIPO_DATA('90302695'),
                T_TIPO_DATA('90302717'),
                T_TIPO_DATA('90303061'),
                T_TIPO_DATA('90303182'),
                T_TIPO_DATA('90303210'),
                T_TIPO_DATA('90303256'),
                T_TIPO_DATA('90303365'),
                T_TIPO_DATA('90303431'),
                T_TIPO_DATA('90303471'),
                T_TIPO_DATA('90303701'),
                T_TIPO_DATA('90303733'),
                T_TIPO_DATA('90303804'),
                T_TIPO_DATA('90303814'),
                T_TIPO_DATA('90303817'),
                T_TIPO_DATA('90304432'),
                T_TIPO_DATA('90304435'),
                T_TIPO_DATA('90304716'),
                T_TIPO_DATA('90305185'),
                T_TIPO_DATA('90306263'),
                T_TIPO_DATA('90306520'),
                T_TIPO_DATA('90306576'),
                T_TIPO_DATA('90306757'),
                T_TIPO_DATA('90307053'),
                T_TIPO_DATA('90307658'),
                T_TIPO_DATA('90307730'),
                T_TIPO_DATA('90307926'),
                T_TIPO_DATA('90308172'),
                T_TIPO_DATA('90308330'),
                T_TIPO_DATA('90308728'),
                T_TIPO_DATA('90308734'),
                T_TIPO_DATA('90309172'),
                T_TIPO_DATA('90309246'),
                T_TIPO_DATA('90309383'),
                T_TIPO_DATA('90309540'),
                T_TIPO_DATA('90309748'),
                T_TIPO_DATA('90310348'),
                T_TIPO_DATA('90310384'),
                T_TIPO_DATA('90310686'),
                T_TIPO_DATA('90310693'),
                T_TIPO_DATA('90310850'),
                T_TIPO_DATA('90311487'),
                T_TIPO_DATA('90311833'),
                T_TIPO_DATA('90311990'),
                T_TIPO_DATA('90312355'),
                T_TIPO_DATA('90312586'),
                T_TIPO_DATA('90312901'),
                T_TIPO_DATA('90313308'),
                T_TIPO_DATA('90314062'),
                T_TIPO_DATA('90314800'),
                T_TIPO_DATA('90314811'),
                T_TIPO_DATA('90315311'),
                T_TIPO_DATA('90315392'),
                T_TIPO_DATA('90315861'),
                T_TIPO_DATA('90316182'),
                T_TIPO_DATA('90318362'),
                T_TIPO_DATA('90319738'),
                T_TIPO_DATA('90286462'),
                T_TIPO_DATA('90285693'),
                T_TIPO_DATA('90285830'),
                T_TIPO_DATA('90279085'),
                T_TIPO_DATA('90283218'),
                T_TIPO_DATA('90282129'),
                T_TIPO_DATA('90287830'),
                T_TIPO_DATA('90286724'),
                T_TIPO_DATA('90295637'),
                T_TIPO_DATA('90292050'),
                T_TIPO_DATA('90291399'),
                T_TIPO_DATA('90303074'),
                T_TIPO_DATA('90303806'),
                T_TIPO_DATA('90291435'),
                T_TIPO_DATA('90309895'),
                T_TIPO_DATA('90298641'),
                T_TIPO_DATA('90301307'),
                T_TIPO_DATA('90293249'),
                T_TIPO_DATA('90306676'),
                T_TIPO_DATA('90304236'),
                T_TIPO_DATA('90312884'),
                T_TIPO_DATA('90311138'),
                T_TIPO_DATA('90311250'),
                T_TIPO_DATA('90311551'),
                T_TIPO_DATA('90299638'),
                T_TIPO_DATA('90295162'),
                T_TIPO_DATA('90294489'),
                T_TIPO_DATA('90305123'),
                T_TIPO_DATA('90304472'),
                T_TIPO_DATA('90306713'),
                T_TIPO_DATA('90307621'),
                T_TIPO_DATA('90296058'),
                T_TIPO_DATA('90302576'),
                T_TIPO_DATA('90310397'),
                T_TIPO_DATA('90320717'),
                T_TIPO_DATA('90310218'),
                T_TIPO_DATA('90315096'),
                T_TIPO_DATA('90317902'),
                T_TIPO_DATA('90294441'),
                T_TIPO_DATA('90321095'),
                T_TIPO_DATA('90315153'),
                T_TIPO_DATA('90317664'),
                T_TIPO_DATA('90320956'),
                T_TIPO_DATA('90307281'),
                T_TIPO_DATA('90310582'),
                T_TIPO_DATA('90310890'),
                T_TIPO_DATA('90321196'),
                T_TIPO_DATA('90328290'),
                T_TIPO_DATA('90304887'),
                T_TIPO_DATA('90318172'),
                T_TIPO_DATA('90306695'),
                T_TIPO_DATA('90306976'),
                T_TIPO_DATA('90315711'),
                T_TIPO_DATA('90310527'),
                T_TIPO_DATA('90312791'),
                T_TIPO_DATA('90272325'),
                T_TIPO_DATA('90304110'),
                T_TIPO_DATA('90309245'),
                T_TIPO_DATA('90316573'),
                T_TIPO_DATA('90316470'),
                T_TIPO_DATA('90307819'),
                T_TIPO_DATA('90296732'),
                T_TIPO_DATA('90303198'),
                T_TIPO_DATA('90320086'),
                T_TIPO_DATA('90308539'),
                T_TIPO_DATA('90276266'),
                T_TIPO_DATA('90310408'),
                T_TIPO_DATA('90317695'),
                T_TIPO_DATA('90308947'),
                T_TIPO_DATA('90316701'),
                T_TIPO_DATA('90312564'),
                T_TIPO_DATA('90320250'),
                T_TIPO_DATA('90324700'),
                T_TIPO_DATA('90317158'),
                T_TIPO_DATA('90317968'),
                T_TIPO_DATA('90311683'),
                T_TIPO_DATA('90326654'),
                T_TIPO_DATA('90315155'),
                T_TIPO_DATA('90316317'),
                T_TIPO_DATA('90309471')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia de la oferta
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||V_TMP_TIPO_DATA(1)||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            V_COUNT := 0;

            --Actualizamos el dato
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET           
            DD_ORC_ID =(SELECT DD_ORC_ID FROM DD_ORC_ORIGEN_COMPRADOR WHERE DD_ORC_CODIGO = ''02''),               
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE               
            WHERE OFR_NUM_OFERTA = '||V_TMP_TIPO_DATA(1)||'';
            EXECUTE IMMEDIATE V_MSQL;


            DBMS_OUTPUT.PUT_LINE('[INFO] OFERTA '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADA');
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA OFERTA '''||V_TMP_TIPO_DATA(1)||'''');

        END IF;

    END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

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
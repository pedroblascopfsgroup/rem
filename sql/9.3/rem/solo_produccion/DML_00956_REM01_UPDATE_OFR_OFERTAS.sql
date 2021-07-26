--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210719
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10197
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10197'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ACT_ID NUMBER(16);
    V_TIT_ID NUMBER(16);
    V_ESP_ID NUMBER(16);
    V_ETI_ID NUMBER(16);
    

    -- DD_ORC_ID             OFR_ID_PRES_ORI_LEAD
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                T_TIPO_DATA('7005639','10765'),
                T_TIPO_DATA('7006013','110161220'),
                T_TIPO_DATA('7006466','1106'),
                T_TIPO_DATA('7006541','11156'),
                T_TIPO_DATA('7006593','11762'),
                T_TIPO_DATA('7006815','3347'),
                T_TIPO_DATA('7006862','110159499'),
                T_TIPO_DATA('7006871','11093'),
                T_TIPO_DATA('7006892','3802'),
                T_TIPO_DATA('7006936','110162708'),
                T_TIPO_DATA('7006942','5743'),
                T_TIPO_DATA('7006994','11762'),
                T_TIPO_DATA('7007024','110159523'),
                T_TIPO_DATA('7007080','10006043'),
                T_TIPO_DATA('7007100','10006043'),
                T_TIPO_DATA('7007104','3347'),
                T_TIPO_DATA('7007165','110161298'),
                T_TIPO_DATA('7007197','12154'),
                T_TIPO_DATA('7007198','12154'),
                T_TIPO_DATA('7007223','110159517'),
                T_TIPO_DATA('7007334','2195'),
                T_TIPO_DATA('7007376','12272'),
                T_TIPO_DATA('7007380','110166888'),
                T_TIPO_DATA('7007398','110161218'),
                T_TIPO_DATA('7007537','110159499'),
                T_TIPO_DATA('7008043','110165753'),
                T_TIPO_DATA('7008212','110161219'),
                T_TIPO_DATA('90223900','2153'),
                T_TIPO_DATA('90256359','110188299'),
                T_TIPO_DATA('90260014','2303'),
                T_TIPO_DATA('90260500','1107'),
                T_TIPO_DATA('90263395','110166920'),
                T_TIPO_DATA('90264209','110159510'),
                T_TIPO_DATA('90266530','110082622'),
                T_TIPO_DATA('90267876','150'),
                T_TIPO_DATA('90269090','110159513'),
                T_TIPO_DATA('90269502','110159510'),
                T_TIPO_DATA('90270295','3574'),
                T_TIPO_DATA('90272491','397'),
                T_TIPO_DATA('90273376','154'),
                T_TIPO_DATA('90273920','11762'),
                T_TIPO_DATA('90274104','110162711'),
                T_TIPO_DATA('90274435','10005070'),
                T_TIPO_DATA('90274681','10005070'),
                T_TIPO_DATA('90275582','110159523'),
                T_TIPO_DATA('90275589','96'),
                T_TIPO_DATA('90275603','12854'),
                T_TIPO_DATA('90276561','2129'),
                T_TIPO_DATA('90276651','12599'),
                T_TIPO_DATA('90276840','110160863'),
                T_TIPO_DATA('90277090','96'),
                T_TIPO_DATA('90277183','110116483'),
                T_TIPO_DATA('90277778','110167956'),
                T_TIPO_DATA('90278183','13106'),
                T_TIPO_DATA('90278561','2137'),
                T_TIPO_DATA('90278729','13106'),
                T_TIPO_DATA('90279065','3107'),
                T_TIPO_DATA('90279752','2263'),
                T_TIPO_DATA('90279885','110162712'),
                T_TIPO_DATA('90280137','10696'),
                T_TIPO_DATA('90280218','110166015'),
                T_TIPO_DATA('90280598','2112'),
                T_TIPO_DATA('90280799','397'),
                T_TIPO_DATA('90280889','110160863'),
                T_TIPO_DATA('90281499','2129'),
                T_TIPO_DATA('90281694','1146'),
                T_TIPO_DATA('90282068','2137'),
                T_TIPO_DATA('90282325','4447'),
                T_TIPO_DATA('90282477','110168693'),
                T_TIPO_DATA('90282493','110080847'),
                T_TIPO_DATA('90282609','3344'),
                T_TIPO_DATA('90282777','110165228'),
                T_TIPO_DATA('90283048','10028830'),
                T_TIPO_DATA('90283164','1067'),
                T_TIPO_DATA('90283174','3258'),
                T_TIPO_DATA('90283254','110161220'),
                T_TIPO_DATA('90283322','672'),
                T_TIPO_DATA('90283437','110114991'),
                T_TIPO_DATA('90283441','672'),
                T_TIPO_DATA('90283444','672'),
                T_TIPO_DATA('90283498','397'),
                T_TIPO_DATA('90283705','110161215'),
                T_TIPO_DATA('90284209','110168210'),
                T_TIPO_DATA('90284483','2263'),
                T_TIPO_DATA('90284585','2137'),
                T_TIPO_DATA('90284637','110065064'),
                T_TIPO_DATA('90284647','2137'),
                T_TIPO_DATA('90284653','3347'),
                T_TIPO_DATA('90284831','1219'),
                T_TIPO_DATA('90284845','6389'),
                T_TIPO_DATA('90285737','110159513'),
                T_TIPO_DATA('90285872','6485'),
                T_TIPO_DATA('90286611','9990148'),
                T_TIPO_DATA('90286658','110161217'),
                T_TIPO_DATA('90286883','2395'),
                T_TIPO_DATA('90287123','662'),
                T_TIPO_DATA('90287615','3260'),
                T_TIPO_DATA('90288411','110159506'),
                T_TIPO_DATA('90289688','5456'),
                T_TIPO_DATA('90289994','10006043'),
                T_TIPO_DATA('90290074','1798'),
                T_TIPO_DATA('90290076','1798'),
                T_TIPO_DATA('90290077','1798'),
                T_TIPO_DATA('90290232','10817'),
                T_TIPO_DATA('90290318','973'),
                T_TIPO_DATA('90290535','12562'),
                T_TIPO_DATA('90290710','110159510'),
                T_TIPO_DATA('90290773','373'),
                T_TIPO_DATA('90290790','10005070'),
                T_TIPO_DATA('90290861','149'),
                T_TIPO_DATA('90290977','2012'),
                T_TIPO_DATA('90291050','2137'),
                T_TIPO_DATA('90291232','2137'),
                T_TIPO_DATA('90291530','3107'),
                T_TIPO_DATA('90291623','110080848'),
                T_TIPO_DATA('90291656','150'),
                T_TIPO_DATA('90291924','10033664'),
                T_TIPO_DATA('90291929','10033473'),
                T_TIPO_DATA('90291998','963'),
                T_TIPO_DATA('90292073','1798'),
                T_TIPO_DATA('90292272','1591'),
                T_TIPO_DATA('90292437','110165367'),
                T_TIPO_DATA('90293066','154'),
                T_TIPO_DATA('90293068','4262'),
                T_TIPO_DATA('90293351','110165753'),
                T_TIPO_DATA('90293554','2145'),
                T_TIPO_DATA('90293621','1798'),
                T_TIPO_DATA('90293639','984'),
                T_TIPO_DATA('90293892','110083389'),
                T_TIPO_DATA('90294082','110097633'),
                T_TIPO_DATA('90294555','2320'),
                T_TIPO_DATA('90294716','1093'),
                T_TIPO_DATA('90294818','110161215'),
                T_TIPO_DATA('90294828','662'),
                T_TIPO_DATA('90294843','110162712'),
                T_TIPO_DATA('90295451','890'),
                T_TIPO_DATA('90295926','96'),
                T_TIPO_DATA('90295941','2137'),
                T_TIPO_DATA('90296342','110168563'),
                T_TIPO_DATA('90296362','11230'),
                T_TIPO_DATA('90296423','2322'),
                T_TIPO_DATA('90296861','3258'),
                T_TIPO_DATA('90297032','110167734'),
                T_TIPO_DATA('90297062','110187645'),
                T_TIPO_DATA('90297280','2271'),
                T_TIPO_DATA('90297379','2577'),
                T_TIPO_DATA('90297494','110159516'),
                T_TIPO_DATA('90297694','110165979'),
                T_TIPO_DATA('90297796','662'),
                T_TIPO_DATA('90297805','3279'),
                T_TIPO_DATA('90297898','2264'),
                T_TIPO_DATA('90298028','110082630'),
                T_TIPO_DATA('90298272','110159510'),
                T_TIPO_DATA('90298737','110159522'),
                T_TIPO_DATA('90299105','110083389'),
                T_TIPO_DATA('90299133','110165544'),
                T_TIPO_DATA('90299470','3802'),
                T_TIPO_DATA('90300646','397'),
                T_TIPO_DATA('90300910','150'),
                T_TIPO_DATA('90300953','1628'),
                T_TIPO_DATA('90301174','662'),
                T_TIPO_DATA('90301302','12608'),
                T_TIPO_DATA('90301353','2137'),
                T_TIPO_DATA('90301389','96'),
                T_TIPO_DATA('90301460','1116'),
                T_TIPO_DATA('90301543','110191978'),
                T_TIPO_DATA('90301953','662'),
                T_TIPO_DATA('90302112','1798'),
                T_TIPO_DATA('90302267','10614'),
                T_TIPO_DATA('90302514','10553'),
                T_TIPO_DATA('90302695','110162752'),
                T_TIPO_DATA('90302717','110097633'),
                T_TIPO_DATA('90303061','110082778'),
                T_TIPO_DATA('90303182','10011333'),
                T_TIPO_DATA('90303210','110167977'),
                T_TIPO_DATA('90303256','9990168'),
                T_TIPO_DATA('90303365','2155'),
                T_TIPO_DATA('90303431','110082627'),
                T_TIPO_DATA('90303471','1798'),
                T_TIPO_DATA('90303701','110117348'),
                T_TIPO_DATA('90303733','2981'),
                T_TIPO_DATA('90303804','11508'),
                T_TIPO_DATA('90303814','110162751'),
                T_TIPO_DATA('90303817','110162751'),
                T_TIPO_DATA('90304432','13071'),
                T_TIPO_DATA('90304435','13071'),
                T_TIPO_DATA('90304716','110161215'),
                T_TIPO_DATA('90305185','11894'),
                T_TIPO_DATA('90306263','2137'),
                T_TIPO_DATA('90306520','2137'),
                T_TIPO_DATA('90306576','2137'),
                T_TIPO_DATA('90306757','3378'),
                T_TIPO_DATA('90307053','12154'),
                T_TIPO_DATA('90307658','10862'),
                T_TIPO_DATA('90307730','662'),
                T_TIPO_DATA('90307926','2140'),
                T_TIPO_DATA('90308172','1219'),
                T_TIPO_DATA('90308330','3393'),
                T_TIPO_DATA('90308728','2264'),
                T_TIPO_DATA('90308734','963'),
                T_TIPO_DATA('90309172','4456'),
                T_TIPO_DATA('90309246','110159522'),
                T_TIPO_DATA('90309383','12154'),
                T_TIPO_DATA('90309540','2129'),
                T_TIPO_DATA('90309748','110165746'),
                T_TIPO_DATA('90310348','12154'),
                T_TIPO_DATA('90310384','110082778'),
                T_TIPO_DATA('90310686','110112906'),
                T_TIPO_DATA('90310693','110167977'),
                T_TIPO_DATA('90310850','10472'),
                T_TIPO_DATA('90311487','110097633'),
                T_TIPO_DATA('90311833','110167956'),
                T_TIPO_DATA('90311990','149'),
                T_TIPO_DATA('90312355','12459'),
                T_TIPO_DATA('90312586','10479'),
                T_TIPO_DATA('90312901','2271'),
                T_TIPO_DATA('90313308','890'),
                T_TIPO_DATA('90314062','963'),
                T_TIPO_DATA('90314800','10614'),
                T_TIPO_DATA('90314811','10361'),
                T_TIPO_DATA('90315311','2705'),
                T_TIPO_DATA('90315392','397'),
                T_TIPO_DATA('90315861','110161765'),
                T_TIPO_DATA('90316182','2153'),
                T_TIPO_DATA('90318362','110156954'),
                T_TIPO_DATA('90319738','4430'),
                T_TIPO_DATA('90286462','2137'),
                T_TIPO_DATA('90285693','2137'),
                T_TIPO_DATA('90285830','2137'),
                T_TIPO_DATA('90279085','4434'),
                T_TIPO_DATA('90283218','110159513'),
                T_TIPO_DATA('90282129','110082778'),
                T_TIPO_DATA('90287830','110117726'),
                T_TIPO_DATA('90286724','662'),
                T_TIPO_DATA('90295637','2296'),
                T_TIPO_DATA('90292050','9990148'),
                T_TIPO_DATA('90291399','110169293'),
                T_TIPO_DATA('90303074','126'),
                T_TIPO_DATA('90303806','2241'),
                T_TIPO_DATA('90291435','13048'),
                T_TIPO_DATA('90309895','3378'),
                T_TIPO_DATA('90298641','2140'),
                T_TIPO_DATA('90301307','96'),
                T_TIPO_DATA('90293249','110161308'),
                T_TIPO_DATA('90306676','150'),
                T_TIPO_DATA('90304236','2260'),
                T_TIPO_DATA('90312884','3351'),
                T_TIPO_DATA('90311138','662'),
                T_TIPO_DATA('90311250','1272'),
                T_TIPO_DATA('90311551','3279'),
                T_TIPO_DATA('90299638','110166541'),
                T_TIPO_DATA('90295162','110159513'),
                T_TIPO_DATA('90294489','608'),
                T_TIPO_DATA('90305123','3219'),
                T_TIPO_DATA('90304472','110128071'),
                T_TIPO_DATA('90306713','2153'),
                T_TIPO_DATA('90307621','4430'),
                T_TIPO_DATA('90296058','110155397'),
                T_TIPO_DATA('90302576','110159520'),
                T_TIPO_DATA('90310397','2143'),
                T_TIPO_DATA('90320717','150'),
                T_TIPO_DATA('90310218','4040'),
                T_TIPO_DATA('90315096','4413'),
                T_TIPO_DATA('90317902','12567'),
                T_TIPO_DATA('90294441','4436'),
                T_TIPO_DATA('90321095','6602'),
                T_TIPO_DATA('90315153','110128071'),
                T_TIPO_DATA('90317664','13106'),
                T_TIPO_DATA('90320956','110211952'),
                T_TIPO_DATA('90307281','110164351'),
                T_TIPO_DATA('90310582','110165394'),
                T_TIPO_DATA('90310890','2153'),
                T_TIPO_DATA('90321196','12567'),
                T_TIPO_DATA('90328290','10033474'),
                T_TIPO_DATA('90304887','110167956'),
                T_TIPO_DATA('90318172','448'),
                T_TIPO_DATA('90306695','11762'),
                T_TIPO_DATA('90306976','6791'),
                T_TIPO_DATA('90315711','110128365'),
                T_TIPO_DATA('90310527','110159517'),
                T_TIPO_DATA('90312791','110161864'),
                T_TIPO_DATA('90272325','1106'),
                T_TIPO_DATA('90304110','110161105'),
                T_TIPO_DATA('90309245','2260'),
                T_TIPO_DATA('90316573','672'),
                T_TIPO_DATA('90316470','10011346'),
                T_TIPO_DATA('90307819','3378'),
                T_TIPO_DATA('90296732','96'),
                T_TIPO_DATA('90303198','10472'),
                T_TIPO_DATA('90320086','110159510'),
                T_TIPO_DATA('90308539','2112'),
                T_TIPO_DATA('90276266','110161299'),
                T_TIPO_DATA('90310408','2129'),
                T_TIPO_DATA('90308947','110117963'),
                T_TIPO_DATA('90316701','2012'),
                T_TIPO_DATA('90312564','110159516'),
                T_TIPO_DATA('90320250','2577'),
                T_TIPO_DATA('90324700','2577'),
                T_TIPO_DATA('90317158','2503'),
                T_TIPO_DATA('90317968','110117348'),
                T_TIPO_DATA('90311683','13169'),
                T_TIPO_DATA('90326654','11559'),
                T_TIPO_DATA('90315155','4413'),
                T_TIPO_DATA('90316317','10006043'),
                T_TIPO_DATA('90309471','6521'),
                T_TIPO_DATA('7010920','110167977'),
                T_TIPO_DATA('7012530','110166887'),
                T_TIPO_DATA('7012533','110166887'),
                T_TIPO_DATA('7012534','110166887'),
                T_TIPO_DATA('7012535','110166887'),
                T_TIPO_DATA('7012536','110166887'),
                T_TIPO_DATA('7012537','110166887'),
                T_TIPO_DATA('7012538','110166887'),
                T_TIPO_DATA('7013290','110166887'),
                T_TIPO_DATA('90313867','10033665'),
                T_TIPO_DATA('90306226','110159523'),
                T_TIPO_DATA('90301492','110168940'),
                T_TIPO_DATA('90324237','3258'),
                T_TIPO_DATA('90311520','110168319'),
                T_TIPO_DATA('90317204','963'),
                T_TIPO_DATA('90326404','110097652'),
                T_TIPO_DATA('90321118','2981'),
                T_TIPO_DATA('90299248','9990165'),
                T_TIPO_DATA('90292837','10033665'),
                T_TIPO_DATA('90323849','3258'),
                T_TIPO_DATA('90310873','110159499'),
                T_TIPO_DATA('90312804','110159517'),
                T_TIPO_DATA('90295164','890'),
                T_TIPO_DATA('90313729','110161226'),
                T_TIPO_DATA('90326146','110161299'),
                T_TIPO_DATA('90331726','10765'),
                T_TIPO_DATA('90327616','110162712'),
                T_TIPO_DATA('90327630','110162712'),
                T_TIPO_DATA('90312331','397'),
                T_TIPO_DATA('90331860','1093'),
                T_TIPO_DATA('90306164','4433'),
                T_TIPO_DATA('90320881','11663'),
                T_TIPO_DATA('90319698','3393'),
                T_TIPO_DATA('90329550','1106'),
                T_TIPO_DATA('90320849','110161264')



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
            OFR_ID_PRES_ORI_LEAD = (SELECT PVE_ID FROM ACT_PVE_PROVEEDOR WHERE PVE_COD_REM ='||V_TMP_TIPO_DATA(2)||'),
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
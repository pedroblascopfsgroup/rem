--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211006
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10564
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10564'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ACT_ID NUMBER(16);
    V_TIT_ID NUMBER(16);
    V_ESP_ID NUMBER(16);
    V_ETI_ID NUMBER(16);
    

    -- DD_ORC_ID             OFR_ID_PRES_ORI_LEAD
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(                
                T_TIPO_DATA('90304186','API Prescriptor','110155397'),
                T_TIPO_DATA('90318213','API Prescriptor','4040'),
                T_TIPO_DATA('90328065','API Prescriptor','110164357'),
                T_TIPO_DATA('90331506','API Prescriptor','110159517'),
                T_TIPO_DATA('90337651','API Prescriptor','2996'),
                T_TIPO_DATA('90332610','API Prescriptor','110156954'),
                T_TIPO_DATA('90334998','API Prescriptor','110159516'),
                T_TIPO_DATA('90326551','API Prescriptor','115'),
                T_TIPO_DATA('90328513','API Prescriptor','110159513'),
                T_TIPO_DATA('90335293','API Prescriptor','110191669'),
                T_TIPO_DATA('90330728','API Prescriptor','110191669'),
                T_TIPO_DATA('90318893','API Prescriptor','110168210'),
                T_TIPO_DATA('90327077','API Prescriptor','126'),
                T_TIPO_DATA('90332425','API Prescriptor','110191669'),
                T_TIPO_DATA('90320914','API Prescriptor','11093'),
                T_TIPO_DATA('7008297','API Prescriptor','6389'),
                T_TIPO_DATA('90304463','API Prescriptor','110159510'),
                T_TIPO_DATA('90313873','API Prescriptor','2076'),
                T_TIPO_DATA('90324680','API Prescriptor','9990082'),
                T_TIPO_DATA('90288190','API Prescriptor','2164'),
                T_TIPO_DATA('90326687','API Prescriptor','2264'),
                T_TIPO_DATA('90334597','API Prescriptor','662'),
                T_TIPO_DATA('90329980','API Prescriptor','110161218'),
                T_TIPO_DATA('90315330','API Prescriptor','115'),
                T_TIPO_DATA('90328627','API Prescriptor','1799'),
                T_TIPO_DATA('90311619','API Prescriptor','150'),
                T_TIPO_DATA('90328499','API Prescriptor','11894'),
                T_TIPO_DATA('90325091','API Prescriptor','2577'),
                T_TIPO_DATA('90324522','API Prescriptor','662'),
                T_TIPO_DATA('90326877','API Prescriptor','10361'),
                T_TIPO_DATA('90324125','API Prescriptor','427'),
                T_TIPO_DATA('90333685','API Prescriptor','110161219'),
                T_TIPO_DATA('90327513','API Prescriptor','3366'),
                T_TIPO_DATA('90334308','API Prescriptor','149'),
                T_TIPO_DATA('90332599','API Prescriptor','110117963'),
                T_TIPO_DATA('90334213','API Prescriptor','4517'),
                T_TIPO_DATA('90319754','API Prescriptor','110098564'),
                T_TIPO_DATA('90330007','API Prescriptor','3107'),
                T_TIPO_DATA('90327003','API Prescriptor','110128554'),
                T_TIPO_DATA('90334090','API Prescriptor','4767'),
                T_TIPO_DATA('90338946','API Prescriptor','110166026'),
                T_TIPO_DATA('90326134','API Prescriptor','10367'),
                T_TIPO_DATA('90320190','API Prescriptor','11762'),
                T_TIPO_DATA('90327391','API Prescriptor','110161225'),
                T_TIPO_DATA('90332652','API Prescriptor','2577'),
                T_TIPO_DATA('90335924','API Prescriptor','110112910'),
                T_TIPO_DATA('90327831','API Prescriptor','110166844'),
                T_TIPO_DATA('90342082','API Prescriptor','110114155'),
                T_TIPO_DATA('90328461','API Prescriptor','110159516'),
                T_TIPO_DATA('90335112','API Prescriptor','115'),
                T_TIPO_DATA('90319127','API Prescriptor','3355'),
                T_TIPO_DATA('90324752','API Prescriptor','12235'),
                T_TIPO_DATA('90312457','API Prescriptor','12608'),
                T_TIPO_DATA('90329812','API Prescriptor','12154'),
                T_TIPO_DATA('90319557','API Prescriptor','110159513'),
                T_TIPO_DATA('90325168','API Prescriptor','3355'),
                T_TIPO_DATA('90335393','API Prescriptor','9990148'),
                T_TIPO_DATA('90326522','API Prescriptor','150'),
                T_TIPO_DATA('90325255','API Prescriptor','149'),
                T_TIPO_DATA('90332131','API Prescriptor','110159513'),
                T_TIPO_DATA('90335934','API Prescriptor','6964'),
                T_TIPO_DATA('90337310','API Prescriptor','10586'),
                T_TIPO_DATA('90321670','API Prescriptor','2112'),
                T_TIPO_DATA('90323231','API Prescriptor','126'),
                T_TIPO_DATA('90345615','API Prescriptor','2145'),
                T_TIPO_DATA('90336769','API Prescriptor','6964'),
                T_TIPO_DATA('90331185','API Prescriptor','10033665'),
                T_TIPO_DATA('90334549','API Prescriptor','110128071'),
                T_TIPO_DATA('90334799','API Prescriptor','96'),
                T_TIPO_DATA('90342989','API Prescriptor','2705'),
                T_TIPO_DATA('90335067','API Prescriptor','110191669'),
                T_TIPO_DATA('90334543','API Prescriptor','110187725'),
                T_TIPO_DATA('90321795','API Prescriptor','2091'),
                T_TIPO_DATA('90334548','API Prescriptor','2688'),
                T_TIPO_DATA('90334882','API Prescriptor','149'),
                T_TIPO_DATA('90344390','API Prescriptor','2145'),
                T_TIPO_DATA('90326088','API Prescriptor','890'),
                T_TIPO_DATA('90330903','API Prescriptor','110167734'),
                T_TIPO_DATA('90321289','API Prescriptor','110165371'),
                T_TIPO_DATA('90337648','API Prescriptor','3240'),
                T_TIPO_DATA('90336224','API Prescriptor','10006043'),
                T_TIPO_DATA('90334552','API Prescriptor','110169293'),
                T_TIPO_DATA('90335613','API Prescriptor','13106'),
                T_TIPO_DATA('90329417','API Prescriptor','11762'),
                T_TIPO_DATA('90316500','API Prescriptor','1106'),
                T_TIPO_DATA('90342808','API Prescriptor','2125'),
                T_TIPO_DATA('90343908','API Prescriptor','3265'),
                T_TIPO_DATA('90334469','API Prescriptor','3232'),
                T_TIPO_DATA('90341677','API Prescriptor','11156'),
                T_TIPO_DATA('90316976','API Prescriptor','12154'),
                T_TIPO_DATA('90337437','API Prescriptor','4456'),
                T_TIPO_DATA('90335975','API Prescriptor','110097633'),
                T_TIPO_DATA('90335851','API Prescriptor','110159511'),
                T_TIPO_DATA('90333185','API Prescriptor','11508'),
                T_TIPO_DATA('90338950','API Prescriptor','2129'),
                T_TIPO_DATA('90336630','API Prescriptor','12594'),
                T_TIPO_DATA('90344365','API Prescriptor','110212517'),
                T_TIPO_DATA('90343984','API Prescriptor','5126'),
                T_TIPO_DATA('90343978','API Prescriptor','5126'),
                T_TIPO_DATA('90347586','API Prescriptor','110074952'),
                T_TIPO_DATA('90323029','API Prescriptor','110155318'),
                T_TIPO_DATA('90310342','API Prescriptor','110080847'),
                T_TIPO_DATA('90313047','API Prescriptor','150'),
                T_TIPO_DATA('90313733','API Prescriptor','1146'),
                T_TIPO_DATA('90339362','API Prescriptor','4413'),
                T_TIPO_DATA('90337206','API Prescriptor','11733'),
                T_TIPO_DATA('90338052','API Prescriptor','110191669'),
                T_TIPO_DATA('90327263','API Prescriptor','5743'),
                T_TIPO_DATA('90326605','API Prescriptor','4443'),
                T_TIPO_DATA('90336252','API Prescriptor','10817'),
                T_TIPO_DATA('90343881','API Prescriptor','2195'),
                T_TIPO_DATA('90316648','API Prescriptor','4443'),
                T_TIPO_DATA('90331139','API Prescriptor','110164358'),
                T_TIPO_DATA('90323601','HAYA','2321'),
                T_TIPO_DATA('90315088','HAYA','2321'),
                T_TIPO_DATA('90319048','HAYA','2321'),
                T_TIPO_DATA('90322685','HAYA','2321'),
                T_TIPO_DATA('90324626','HAYA','2321'),
                T_TIPO_DATA('90321641','HAYA','2321'),
                T_TIPO_DATA('90324197','HAYA','2321'),
                T_TIPO_DATA('90316289','HAYA','2321'),
                T_TIPO_DATA('90333796','HAYA','2321'),
                T_TIPO_DATA('90329769','HAYA','2321'),
                T_TIPO_DATA('90328132','HAYA','2321'),
                T_TIPO_DATA('90315262','HAYA','2321'),
                T_TIPO_DATA('90340487','HAYA','2321'),
                T_TIPO_DATA('90341021','HAYA','2321'),
                T_TIPO_DATA('90332403','HAYA','2321'),
                T_TIPO_DATA('90330050','HAYA','2321'),
                T_TIPO_DATA('90332152','HAYA','2321'),
                T_TIPO_DATA('90309101','HAYA','2321'),
                T_TIPO_DATA('90320091','HAYA','2321'),
                T_TIPO_DATA('90324793','HAYA','2321'),
                T_TIPO_DATA('90299377','HAYA','2321'),
                T_TIPO_DATA('90316893','HAYA','2321'),
                T_TIPO_DATA('90315409','HAYA','2321'),
                T_TIPO_DATA('90329223','HAYA','2321'),
                T_TIPO_DATA('90325167','HAYA','2321'),
                T_TIPO_DATA('90335923','HAYA','2321'),
                T_TIPO_DATA('90313818','HAYA','2321'),
                T_TIPO_DATA('90304004','HAYA','2321'),
                T_TIPO_DATA('90313199','HAYA','2321'),
                T_TIPO_DATA('90311747','HAYA','2321'),
                T_TIPO_DATA('90291817','HAYA','2321'),
                T_TIPO_DATA('90326268','HAYA','2321'),
                T_TIPO_DATA('90329069','HAYA','2321'),
                T_TIPO_DATA('90317082','HAYA','2321'),
                T_TIPO_DATA('90323033','HAYA','2321'),
                T_TIPO_DATA('90324017','HAYA','2321'),
                T_TIPO_DATA('90324352','HAYA','2321'),
                T_TIPO_DATA('90320778','HAYA','2321'),
                T_TIPO_DATA('90327848','HAYA','2321'),
                T_TIPO_DATA('90319242','HAYA','2321'),
                T_TIPO_DATA('90320651','HAYA','2321'),
                T_TIPO_DATA('90326244','HAYA','2321'),
                T_TIPO_DATA('90319415','HAYA','2321'),
                T_TIPO_DATA('90322766','HAYA','2321'),
                T_TIPO_DATA('90326502','HAYA','2321'),
                T_TIPO_DATA('90334800','HAYA','2321'),
                T_TIPO_DATA('90306691','HAYA','2321'),
                T_TIPO_DATA('90326178','HAYA','2321'),
                T_TIPO_DATA('90331354','HAYA','2321'),
                T_TIPO_DATA('90334094','HAYA','2321'),
                T_TIPO_DATA('90321257','HAYA','2321'),
                T_TIPO_DATA('90334890','HAYA','2321'),
                T_TIPO_DATA('90334512','HAYA','2321'),
                T_TIPO_DATA('90327491','HAYA','2321'),
                T_TIPO_DATA('90331631','HAYA','2321'),
                T_TIPO_DATA('90330076','HAYA','2321'),
                T_TIPO_DATA('90325193','HAYA','2321'),
                T_TIPO_DATA('90321416','HAYA','2321'),
                T_TIPO_DATA('90327453','HAYA','2321'),
                T_TIPO_DATA('90330246','HAYA','2321'),
                T_TIPO_DATA('90312890','HAYA','2321'),
                T_TIPO_DATA('90316435','HAYA','2321'),
                T_TIPO_DATA('90298661','HAYA','2321'),
                T_TIPO_DATA('90337864','HAYA','2321'),
                T_TIPO_DATA('90324973','HAYA','2321'),
                T_TIPO_DATA('90336152','HAYA','2321'),
                T_TIPO_DATA('90327932','HAYA','2321'),
                T_TIPO_DATA('90328547','HAYA','2321'),
                T_TIPO_DATA('90332194','HAYA','2321'),
                T_TIPO_DATA('90334627','HAYA','2321'),
                T_TIPO_DATA('90332824','HAYA','2321'),
                T_TIPO_DATA('90335493','HAYA','2321'),
                T_TIPO_DATA('90329103','HAYA','2321'),
                T_TIPO_DATA('90329581','HAYA','2321'),
                T_TIPO_DATA('90328794','HAYA','2321'),
                T_TIPO_DATA('90318496','HAYA','2321'),
                T_TIPO_DATA('90336979','HAYA','2321'),
                T_TIPO_DATA('90338484','HAYA','2321'),
                T_TIPO_DATA('90333999','HAYA','2321'),
                T_TIPO_DATA('6009246','HAYA','2321'),
                T_TIPO_DATA('90337202','HAYA','2321'),
                T_TIPO_DATA('90322032','HAYA','2321'),
                T_TIPO_DATA('90312598','HAYA','2321')
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
             DD_ORC_ID= (CASE
                            WHEN '''||V_TMP_TIPO_DATA(2)||''' = ''API Prescriptor'' THEN (SELECT DD_ORC_ID FROM '||V_ESQUEMA||'.DD_ORC_ORIGEN_COMPRADOR WHERE DD_ORC_CODIGO = ''02'')
                            WHEN '''||V_TMP_TIPO_DATA(2)||''' = ''HAYA'' THEN (SELECT DD_ORC_ID FROM '||V_ESQUEMA||'.DD_ORC_ORIGEN_COMPRADOR WHERE DD_ORC_CODIGO = ''01'')
                         END )       
            ,OFR_ID_PRES_ORI_LEAD = (SELECT PVE_ID FROM ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '''||V_TMP_TIPO_DATA(3)||''')
            ,OFR_ID_REALIZA_ORI_LEAD = (SELECT PVE_ID FROM ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '''||V_TMP_TIPO_DATA(3)||''')
            ,USUARIOMODIFICAR = '''||V_USUARIO||'''
            ,FECHAMODIFICAR = SYSDATE               
            WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||'''';
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
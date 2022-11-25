--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20221125
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8193
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva de aprobación del informe comercial
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-12640'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ACT_ID NUMBER(20);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA(7496359),
            T_TIPO_DATA(7496367),
            T_TIPO_DATA(7509628),
            T_TIPO_DATA(7509630),
            T_TIPO_DATA(7509631),
            T_TIPO_DATA(7509648),
            T_TIPO_DATA(7509686),
            T_TIPO_DATA(7509687),
            T_TIPO_DATA(7509971),
            T_TIPO_DATA(7509973),
            T_TIPO_DATA(7509974),
            T_TIPO_DATA(7509975),
            T_TIPO_DATA(7509978),
            T_TIPO_DATA(7509979),
            T_TIPO_DATA(7509985),
            T_TIPO_DATA(7510019),
            T_TIPO_DATA(7510021),
            T_TIPO_DATA(7510023),
            T_TIPO_DATA(7510025),
            T_TIPO_DATA(7510028),
            T_TIPO_DATA(7510030),
            T_TIPO_DATA(7510035),
            T_TIPO_DATA(7510044),
            T_TIPO_DATA(7510096),
            T_TIPO_DATA(7510102),
            T_TIPO_DATA(7510104),
            T_TIPO_DATA(7510109),
            T_TIPO_DATA(7510190),
            T_TIPO_DATA(7510197),
            T_TIPO_DATA(7510247),
            T_TIPO_DATA(7510258),
            T_TIPO_DATA(7510314),
            T_TIPO_DATA(7510316),
            T_TIPO_DATA(7510322),
            T_TIPO_DATA(7510351),
            T_TIPO_DATA(7510352),
            T_TIPO_DATA(7510356),
            T_TIPO_DATA(7510401),
            T_TIPO_DATA(7510402),
            T_TIPO_DATA(7510403),
            T_TIPO_DATA(7510406),
            T_TIPO_DATA(7510408),
            T_TIPO_DATA(7510421),
            T_TIPO_DATA(7510423),
            T_TIPO_DATA(7510425),
            T_TIPO_DATA(7510605),
            T_TIPO_DATA(7510609),
            T_TIPO_DATA(7510610),
            T_TIPO_DATA(7510613),
            T_TIPO_DATA(7510669),
            T_TIPO_DATA(7510671),
            T_TIPO_DATA(7510703),
            T_TIPO_DATA(7510704),
            T_TIPO_DATA(7510707),
            T_TIPO_DATA(7510714),
            T_TIPO_DATA(7510715),
            T_TIPO_DATA(7510723),
            T_TIPO_DATA(7510728),
            T_TIPO_DATA(7510729),
            T_TIPO_DATA(7510734),
            T_TIPO_DATA(7510735),
            T_TIPO_DATA(7512469),
            T_TIPO_DATA(7512475),
            T_TIPO_DATA(7512574),
            T_TIPO_DATA(7512579),
            T_TIPO_DATA(7512583),
            T_TIPO_DATA(7512601),
            T_TIPO_DATA(7512602),
            T_TIPO_DATA(7512604),
            T_TIPO_DATA(7512608),
            T_TIPO_DATA(7512616),
            T_TIPO_DATA(7512625),
            T_TIPO_DATA(7512627),
            T_TIPO_DATA(7512630),
            T_TIPO_DATA(7512633),
            T_TIPO_DATA(7512634),
            T_TIPO_DATA(7512639),
            T_TIPO_DATA(7512653),
            T_TIPO_DATA(7512655),
            T_TIPO_DATA(7512657),
            T_TIPO_DATA(7512663),
            T_TIPO_DATA(7512664),
            T_TIPO_DATA(7512666),
            T_TIPO_DATA(7512667),
            T_TIPO_DATA(7512668),
            T_TIPO_DATA(7512669),
            T_TIPO_DATA(7512670),
            T_TIPO_DATA(7512671),
            T_TIPO_DATA(7512672),
            T_TIPO_DATA(7512675),
            T_TIPO_DATA(7512676),
            T_TIPO_DATA(7512677),
            T_TIPO_DATA(7512679),
            T_TIPO_DATA(7512680),
            T_TIPO_DATA(7512682),
            T_TIPO_DATA(7512683),
            T_TIPO_DATA(7512684),
            T_TIPO_DATA(7512685),
            T_TIPO_DATA(7512686),
            T_TIPO_DATA(7512687),
            T_TIPO_DATA(7512690),
            T_TIPO_DATA(7512697),
            T_TIPO_DATA(7512700),
            T_TIPO_DATA(7512701),
            T_TIPO_DATA(7512702),
            T_TIPO_DATA(7512704),
            T_TIPO_DATA(7512708),
            T_TIPO_DATA(7512712),
            T_TIPO_DATA(7512713),
            T_TIPO_DATA(7512715),
            T_TIPO_DATA(7512716),
            T_TIPO_DATA(7512717),
            T_TIPO_DATA(7512719),
            T_TIPO_DATA(7512720),
            T_TIPO_DATA(7512723),
            T_TIPO_DATA(7512901),
            T_TIPO_DATA(7512904),
            T_TIPO_DATA(7512907),
            T_TIPO_DATA(7512908),
            T_TIPO_DATA(7512911),
            T_TIPO_DATA(7513361),
            T_TIPO_DATA(7513422),
            T_TIPO_DATA(7513425),
            T_TIPO_DATA(7513513),
            T_TIPO_DATA(7513521),
            T_TIPO_DATA(7513527),
            T_TIPO_DATA(7513559),
            T_TIPO_DATA(7513562),
            T_TIPO_DATA(7513564),
            T_TIPO_DATA(7513566),
            T_TIPO_DATA(7513772),
            T_TIPO_DATA(7513773),
            T_TIPO_DATA(7513774),
            T_TIPO_DATA(7513775),
            T_TIPO_DATA(7513776),
            T_TIPO_DATA(7513777),
            T_TIPO_DATA(7513778),
            T_TIPO_DATA(7513779),
            T_TIPO_DATA(7513780),
            T_TIPO_DATA(7513782),
            T_TIPO_DATA(7513788),
            T_TIPO_DATA(7513995),
            T_TIPO_DATA(7514065),
            T_TIPO_DATA(7514067),
            T_TIPO_DATA(7514068),
            T_TIPO_DATA(7514069),
            T_TIPO_DATA(7514076),
            T_TIPO_DATA(7514078),
            T_TIPO_DATA(7514081),
            T_TIPO_DATA(7514086),
            T_TIPO_DATA(7514087),
            T_TIPO_DATA(7514090),
            T_TIPO_DATA(7514094),
            T_TIPO_DATA(7514098),
            T_TIPO_DATA(7514179),
            T_TIPO_DATA(7514180),
            T_TIPO_DATA(7514182),
            T_TIPO_DATA(7514184),
            T_TIPO_DATA(7514185),
            T_TIPO_DATA(7514268),
            T_TIPO_DATA(7514270),
            T_TIPO_DATA(7514272),
            T_TIPO_DATA(7514275),
            T_TIPO_DATA(7514276),
            T_TIPO_DATA(7514279),
            T_TIPO_DATA(7514281),
            T_TIPO_DATA(7514487),
            T_TIPO_DATA(7514513),
            T_TIPO_DATA(7514515),
            T_TIPO_DATA(7514519),
            T_TIPO_DATA(7514520),
            T_TIPO_DATA(7514521),
            T_TIPO_DATA(7514523),
            T_TIPO_DATA(7514524),
            T_TIPO_DATA(7514527),
            T_TIPO_DATA(7514532),
            T_TIPO_DATA(7514533),
            T_TIPO_DATA(7514535),
            T_TIPO_DATA(7514574),
            T_TIPO_DATA(7514618),
            T_TIPO_DATA(7514619),
            T_TIPO_DATA(7514652),
            T_TIPO_DATA(7514706),
            T_TIPO_DATA(7514718),
            T_TIPO_DATA(7514778),
            T_TIPO_DATA(7514779),
            T_TIPO_DATA(7514781),
            T_TIPO_DATA(7514785),
            T_TIPO_DATA(7514796),
            T_TIPO_DATA(7514797),
            T_TIPO_DATA(7514831),
            T_TIPO_DATA(7514832),
            T_TIPO_DATA(7514833),
            T_TIPO_DATA(7514834),
            T_TIPO_DATA(7514835),
            T_TIPO_DATA(7515004),
            T_TIPO_DATA(7515034),
            T_TIPO_DATA(7515145),
            T_TIPO_DATA(7515148),
            T_TIPO_DATA(7515150),
            T_TIPO_DATA(7515151),
            T_TIPO_DATA(7515152),
            T_TIPO_DATA(7515153),
            T_TIPO_DATA(7515154),
            T_TIPO_DATA(7515155),
            T_TIPO_DATA(7515156),
            T_TIPO_DATA(7515157),
            T_TIPO_DATA(7515161),
            T_TIPO_DATA(7515209),
            T_TIPO_DATA(7515213),
            T_TIPO_DATA(7515215),
            T_TIPO_DATA(7515216),
            T_TIPO_DATA(7515217),
            T_TIPO_DATA(7515220),
            T_TIPO_DATA(7515383),
            T_TIPO_DATA(7515398),
            T_TIPO_DATA(7515401),
            T_TIPO_DATA(7515409),
            T_TIPO_DATA(7515497),
            T_TIPO_DATA(7515536),
            T_TIPO_DATA(7515543),
            T_TIPO_DATA(7515545),
            T_TIPO_DATA(7515560),
            T_TIPO_DATA(7515563),
            T_TIPO_DATA(7515570),
            T_TIPO_DATA(7515577),
            T_TIPO_DATA(7515582),
            T_TIPO_DATA(7515587),
            T_TIPO_DATA(7515596),
            T_TIPO_DATA(7515604),
            T_TIPO_DATA(7515606),
            T_TIPO_DATA(7515614),
            T_TIPO_DATA(7515623),
            T_TIPO_DATA(7515624),
            T_TIPO_DATA(7515628),
            T_TIPO_DATA(7515635),
            T_TIPO_DATA(7515653),
            T_TIPO_DATA(7515673),
            T_TIPO_DATA(7515676),
            T_TIPO_DATA(7515682),
            T_TIPO_DATA(7515688),
            T_TIPO_DATA(7515689),
            T_TIPO_DATA(7515690),
            T_TIPO_DATA(7515693),
            T_TIPO_DATA(7518572),
            T_TIPO_DATA(7518663),
            T_TIPO_DATA(7518668),
            T_TIPO_DATA(7518669),
            T_TIPO_DATA(7518675),
            T_TIPO_DATA(7518676),
            T_TIPO_DATA(7518680),
            T_TIPO_DATA(7518681),
            T_TIPO_DATA(7518684),
            T_TIPO_DATA(7518685),
            T_TIPO_DATA(7518690),
            T_TIPO_DATA(7518694),
            T_TIPO_DATA(7518792),
            T_TIPO_DATA(7518794),
            T_TIPO_DATA(7518796),
            T_TIPO_DATA(7518797),
            T_TIPO_DATA(7518800),
            T_TIPO_DATA(7518802),
            T_TIPO_DATA(7518804),
            T_TIPO_DATA(7518805),
            T_TIPO_DATA(7518810),
            T_TIPO_DATA(7518814),
            T_TIPO_DATA(7518819),
            T_TIPO_DATA(7518821),
            T_TIPO_DATA(7518824),
            T_TIPO_DATA(7518851),
            T_TIPO_DATA(7518856),
            T_TIPO_DATA(7518858),
            T_TIPO_DATA(7518939),
            T_TIPO_DATA(7518940),
            T_TIPO_DATA(7519007),
            T_TIPO_DATA(7519975),
            T_TIPO_DATA(7520137),
            T_TIPO_DATA(7520447),
            T_TIPO_DATA(7520449),
            T_TIPO_DATA(7520450),
            T_TIPO_DATA(7520451)
    	);
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZAR REFERENCIAS CATASTRALES INDICANDO LA INTERFAZ BANKIA');
	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_ACT_ID := 0;

        EXECUTE IMMEDIATE 'SELECT ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0' INTO V_ACT_ID;

        IF V_ACT_ID != 0 THEN

            EXECUTE IMMEDIATE 'UPDATE '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO SET
                        CAT_IND_INTERFAZ_BANKIA = 1,
                        FECHAMODIFICAR = SYSDATE,
                        USUARIOMODIFICAR = '''||V_USR||'''
                        WHERE ACT_ID = '||V_ACT_ID||' AND BORRADO = 0';

            DBMS_OUTPUT.PUT_LINE('[INFO] ACTIVO '||V_TMP_TIPO_DATA(1)||' ACTUALIZADO');

        ELSE

            DBMS_OUTPUT.PUT_LINE('[INFO] ACTIVO '||V_TMP_TIPO_DATA(1)||' NO EXISTE');

        END IF;

    END LOOP;

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO ACT_CAT_CATASTRO');

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

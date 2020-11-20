--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8370
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar estado de publicación de activos
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

    -- Ejecutar
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    -- Esquemas 
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USU VARCHAR2(50 CHAR) := 'REMVIP_8370';
    -- ID
    V_ACTIVO_ID NUMBER(16); -- Vble. para el id del activo
    -- Contador
	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('5925362'),
            T_TIPO_DATA('5926376'),
            T_TIPO_DATA('5927145'),
            T_TIPO_DATA('5927413'),
            T_TIPO_DATA('5927786'),
            T_TIPO_DATA('5927846'),
            T_TIPO_DATA('5928133'),
            T_TIPO_DATA('5928219'),
            T_TIPO_DATA('5928288'),
            T_TIPO_DATA('5929139'),
            T_TIPO_DATA('5929622'),
            T_TIPO_DATA('5929771'),
            T_TIPO_DATA('5929951'),
            T_TIPO_DATA('5930390'),
            T_TIPO_DATA('5931115'),
            T_TIPO_DATA('5931142'),
            T_TIPO_DATA('5931574'),
            T_TIPO_DATA('5932474'),
            T_TIPO_DATA('5932581'),
            T_TIPO_DATA('5933120'),
            T_TIPO_DATA('5934436'),
            T_TIPO_DATA('5934443'),
            T_TIPO_DATA('5934525'),
            T_TIPO_DATA('5935535'),
            T_TIPO_DATA('5935594'),
            T_TIPO_DATA('5936362'),
            T_TIPO_DATA('5936612'),
            T_TIPO_DATA('5936755'),
            T_TIPO_DATA('5937167'),
            T_TIPO_DATA('5937404'),
            T_TIPO_DATA('5937806'),
            T_TIPO_DATA('5938020'),
            --T_TIPO_DATA('5938076'),
            T_TIPO_DATA('5938217'),
            T_TIPO_DATA('5938317'),
            T_TIPO_DATA('5938724'),
            T_TIPO_DATA('5938954'),
            T_TIPO_DATA('5939697'),
            T_TIPO_DATA('5939917'),
            T_TIPO_DATA('5939978'),
            T_TIPO_DATA('5941889'),
            T_TIPO_DATA('5942379'),
            T_TIPO_DATA('5943385'),
            T_TIPO_DATA('5943451'),
            T_TIPO_DATA('5943788'),
            T_TIPO_DATA('5944315'),
            T_TIPO_DATA('5944385'),
            T_TIPO_DATA('5944711'),
            T_TIPO_DATA('5945236'),
            T_TIPO_DATA('5945250'),
            T_TIPO_DATA('5945289'),
            T_TIPO_DATA('5945584'),
            T_TIPO_DATA('5945760'),
            T_TIPO_DATA('5945879'),
            T_TIPO_DATA('5946030'),
            T_TIPO_DATA('5946434'),
            T_TIPO_DATA('5946515'),
            T_TIPO_DATA('5946575'),
            T_TIPO_DATA('5947749'),
            T_TIPO_DATA('5948341'),
            T_TIPO_DATA('5948599'),
            T_TIPO_DATA('5949177'),
            T_TIPO_DATA('5949481'),
            T_TIPO_DATA('5949498'),
            T_TIPO_DATA('5950684'),
            T_TIPO_DATA('5950944'),
            T_TIPO_DATA('5951348'),
            T_TIPO_DATA('5951959'),
            T_TIPO_DATA('5952479'),
            T_TIPO_DATA('5952676'),
            T_TIPO_DATA('5952835'),
            T_TIPO_DATA('5953104'),
            T_TIPO_DATA('5954085'),
            T_TIPO_DATA('5954953'),
            T_TIPO_DATA('5955465'),
            T_TIPO_DATA('5955495'),
            T_TIPO_DATA('5955728'),
            T_TIPO_DATA('5956233'),
            T_TIPO_DATA('5956431'),
            T_TIPO_DATA('5956432'),
            T_TIPO_DATA('5957639'),
            T_TIPO_DATA('5959284'),
            T_TIPO_DATA('5959845'),
            T_TIPO_DATA('5960014'),
            T_TIPO_DATA('5960083'),
            T_TIPO_DATA('5960244'),
            T_TIPO_DATA('5960708'),
            T_TIPO_DATA('5960782'),
            T_TIPO_DATA('5961085'),
            T_TIPO_DATA('5961490'),
            T_TIPO_DATA('5961543'),
            T_TIPO_DATA('5961922'),
            T_TIPO_DATA('5962165'),
            T_TIPO_DATA('5962408'),
            T_TIPO_DATA('5962409'),
            T_TIPO_DATA('5962422'),
            T_TIPO_DATA('5962440'),
            T_TIPO_DATA('5962443'),
            T_TIPO_DATA('5962716'),
            T_TIPO_DATA('5962773'),
            T_TIPO_DATA('5962943'),
            T_TIPO_DATA('5963024'),
            T_TIPO_DATA('5963303'),
            T_TIPO_DATA('5963357'),
            T_TIPO_DATA('5963459'),
            T_TIPO_DATA('5963547'),
            T_TIPO_DATA('5963851'),
            T_TIPO_DATA('5964001'),
            T_TIPO_DATA('5964127'),
            T_TIPO_DATA('5964379'),
            T_TIPO_DATA('5965360'),
            T_TIPO_DATA('5965426'),
            T_TIPO_DATA('5965598'),
            T_TIPO_DATA('5967207'),
            T_TIPO_DATA('5967301'),
            T_TIPO_DATA('5967839'),
            T_TIPO_DATA('5967942'),
            T_TIPO_DATA('5968297'),
            T_TIPO_DATA('5968523'),
            T_TIPO_DATA('5968770'),
            T_TIPO_DATA('5968943'),
            T_TIPO_DATA('5969307'),
            T_TIPO_DATA('5969308'),
            T_TIPO_DATA('5969666'),
            T_TIPO_DATA('5969790'),
            T_TIPO_DATA('5969938'),
            T_TIPO_DATA('5969950'),
            T_TIPO_DATA('6044890'),
            T_TIPO_DATA('6046393'),
            T_TIPO_DATA('6048460'),
            T_TIPO_DATA('6048893'),
            T_TIPO_DATA('6051060'),
            T_TIPO_DATA('6057911'),
            T_TIPO_DATA('6058451'),
            T_TIPO_DATA('6058684'),
            T_TIPO_DATA('6058734'),
            T_TIPO_DATA('6059921'),
            T_TIPO_DATA('6059972'),
            T_TIPO_DATA('6062747'),
            T_TIPO_DATA('6523216'),
            T_TIPO_DATA('6527579'),
            T_TIPO_DATA('6707080'),
            T_TIPO_DATA('6764622'),
            T_TIPO_DATA('6767965'),
            T_TIPO_DATA('6788109'),
            T_TIPO_DATA('6796297'),
            T_TIPO_DATA('6796828'),
            T_TIPO_DATA('6798755'),
            T_TIPO_DATA('6813888'),
            T_TIPO_DATA('6814529'),
            T_TIPO_DATA('6824787'),
            T_TIPO_DATA('6824831'),
            T_TIPO_DATA('6827391'),
            T_TIPO_DATA('6833037'),
            T_TIPO_DATA('6886575'),
            T_TIPO_DATA('6891818'),
            T_TIPO_DATA('6939932'),
            T_TIPO_DATA('6942622'),
            T_TIPO_DATA('6965225'),
            T_TIPO_DATA('6965227'),
            T_TIPO_DATA('6965232'),
            T_TIPO_DATA('6965239'),
            T_TIPO_DATA('6966978'),
            T_TIPO_DATA('6967335'),
            T_TIPO_DATA('6967345'),
            T_TIPO_DATA('6973977'),
            T_TIPO_DATA('6977719'),
            T_TIPO_DATA('6980210'),
            T_TIPO_DATA('6980211'),
            T_TIPO_DATA('6980521'),
            T_TIPO_DATA('6980700'),
            T_TIPO_DATA('6981049'),
            T_TIPO_DATA('6981207'),
            T_TIPO_DATA('6981666'),
            T_TIPO_DATA('6982140'),
            T_TIPO_DATA('6982262'),
            T_TIPO_DATA('6982537'),
            T_TIPO_DATA('6982539'),
            T_TIPO_DATA('6982566'),
            T_TIPO_DATA('6982741'),
            T_TIPO_DATA('6982800'),
            T_TIPO_DATA('6982919'),
            T_TIPO_DATA('6982948'),
            T_TIPO_DATA('6983034'),
            T_TIPO_DATA('6983079'),
            T_TIPO_DATA('6983084'),
            T_TIPO_DATA('6983099'),
            T_TIPO_DATA('6983112'),
            T_TIPO_DATA('6983115'),
            T_TIPO_DATA('6983141'),
            T_TIPO_DATA('6983143'),
            T_TIPO_DATA('6983174'),
            T_TIPO_DATA('6983176'),
            T_TIPO_DATA('6983180'),
            T_TIPO_DATA('6983555'),
            T_TIPO_DATA('6983870'),
            T_TIPO_DATA('6984587'),
            T_TIPO_DATA('6984937'),
            T_TIPO_DATA('6985157'),
            T_TIPO_DATA('6985354'),
            T_TIPO_DATA('6986589'),
            T_TIPO_DATA('6986619'),
            T_TIPO_DATA('6986621'),
            T_TIPO_DATA('6987078'),
            T_TIPO_DATA('6987144'),
            T_TIPO_DATA('6988088'),
            T_TIPO_DATA('6988107'),
            T_TIPO_DATA('6988108'),
            T_TIPO_DATA('6988109'),
            T_TIPO_DATA('6988110'),
            T_TIPO_DATA('6988146'),
            T_TIPO_DATA('6988339'),
            T_TIPO_DATA('6988340'),
            T_TIPO_DATA('6989063'),
            T_TIPO_DATA('6989070'),
            T_TIPO_DATA('6989245'),
            T_TIPO_DATA('6989408'),
            T_TIPO_DATA('6989486'),
            T_TIPO_DATA('6989610'),
            T_TIPO_DATA('6989640'),
            T_TIPO_DATA('6989802'),
            T_TIPO_DATA('6989803'),
            T_TIPO_DATA('6989805'),
            T_TIPO_DATA('6989806'),
            T_TIPO_DATA('6989946'),
            T_TIPO_DATA('6990530'),
            T_TIPO_DATA('6990912'),
            T_TIPO_DATA('6990933'),
            T_TIPO_DATA('6990951'),
            T_TIPO_DATA('6990965'),
            T_TIPO_DATA('6991139'),
            T_TIPO_DATA('6991146'),
            T_TIPO_DATA('6991511'),
            T_TIPO_DATA('6991675'),
            T_TIPO_DATA('6992054'),
            T_TIPO_DATA('6993108'),
            T_TIPO_DATA('6993153'),
            T_TIPO_DATA('6994708'),
            T_TIPO_DATA('6994820'),
            T_TIPO_DATA('6994936'),
            T_TIPO_DATA('6995338'),
            T_TIPO_DATA('6995448'),
            T_TIPO_DATA('6995612'),
            T_TIPO_DATA('6995984'),
            T_TIPO_DATA('6996096'),
            T_TIPO_DATA('6996766'),
            T_TIPO_DATA('6997155'),
            T_TIPO_DATA('6997204'),
            T_TIPO_DATA('6997511'),
            T_TIPO_DATA('6998080'),
            T_TIPO_DATA('6998116'),
            T_TIPO_DATA('6998906'),
            T_TIPO_DATA('6999325'),
            T_TIPO_DATA('6999353'),
            T_TIPO_DATA('6999536'),
            T_TIPO_DATA('6999546'),
            T_TIPO_DATA('6999556'),
            T_TIPO_DATA('6999563'),
            T_TIPO_DATA('6999564'),
            T_TIPO_DATA('6999568'),
            T_TIPO_DATA('6999572'),
            T_TIPO_DATA('6999579'),
            T_TIPO_DATA('6999586'),
            T_TIPO_DATA('6999592'),
            T_TIPO_DATA('6999593'),
            T_TIPO_DATA('6999598'),
            T_TIPO_DATA('6999608'),
            T_TIPO_DATA('6999626'),
            T_TIPO_DATA('6999632'),
            T_TIPO_DATA('6999651'),
            T_TIPO_DATA('6999654'),
            T_TIPO_DATA('6999777'),
            T_TIPO_DATA('7000102'),
            T_TIPO_DATA('7000552'),
            T_TIPO_DATA('7000555'),
            T_TIPO_DATA('7000733'),
            T_TIPO_DATA('7000846'),
            T_TIPO_DATA('7001152'),
            T_TIPO_DATA('7001183'),
            T_TIPO_DATA('7001284'),
            T_TIPO_DATA('7001339'),
            T_TIPO_DATA('7001424'),
            T_TIPO_DATA('7001538'),
            T_TIPO_DATA('7001551'),
            T_TIPO_DATA('7001854'),
            T_TIPO_DATA('7002174'),
            T_TIPO_DATA('7002226'),
            T_TIPO_DATA('7002235'),
            T_TIPO_DATA('7002238'),
            T_TIPO_DATA('7002306'),
            T_TIPO_DATA('5954992'),
            T_TIPO_DATA('6063276'),
            T_TIPO_DATA('6965229'),
            T_TIPO_DATA('6989900'),
            T_TIPO_DATA('6991082'),
            T_TIPO_DATA('7099499'),
            T_TIPO_DATA('7296556'),
            T_TIPO_DATA('5940310'),
            T_TIPO_DATA('5952273'),
            T_TIPO_DATA('5953655'),
            T_TIPO_DATA('5955441'),
            T_TIPO_DATA('5955757'),
            T_TIPO_DATA('5964572'),
            T_TIPO_DATA('5969304'),
            T_TIPO_DATA('5969341'),
            T_TIPO_DATA('6057699'),
            T_TIPO_DATA('6057834'),
            T_TIPO_DATA('6824854'),
            T_TIPO_DATA('6945069'),
            T_TIPO_DATA('6982515')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ESTADO DE PUBLICACIÓN DE LISTA DE ACTIVOS');

    -- Actualizamos el estado de publicación de los activos del array
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del activo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            --Obtenemos el ID del activo
            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ACTIVO_ID;

            -- Cambia el estado de publicación
            REM01.SP_CAMBIO_ESTADO_PUBLICACION(V_ACTIVO_ID, 1, 'REMVIP_8370');

        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '''||V_TMP_TIPO_DATA(1)||'''');

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
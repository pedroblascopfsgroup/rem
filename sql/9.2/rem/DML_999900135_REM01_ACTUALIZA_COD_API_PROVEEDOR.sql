--/*
--##########################################
--## AUTOR=DANIEL ALBERT PÉREZ
--## FECHA_CREACION=20170920
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.6
--## INCIDENCIA_LINK=HREOS-2837
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  Actualizar datos
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
  
  TYPE T_DRE IS TABLE OF VARCHAR2(4000 CHAR);
  TYPE T_ARRAY_DRE IS TABLE OF T_DRE;
  V_ESQUEMA             VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M           VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_TABLA               VARCHAR2(30 CHAR):= 'ACT_PVE_PROVEEDOR'; 
  TABLE_COUNT           number(3);-- Vble. para validar la existencia de las Tablas.
  err_num               NUMBER;-- Numero de errores
  err_msg               VARCHAR2(2048);-- Mensaje de error
  V_MSQL                VARCHAR2(4000 CHAR);
  V_EXIST               NUMBER(2);
  V_EXIST2              NUMBER(2);
  CANTIDAD_ACTUALIZADOS NUMBER(6) := 0;
  CANTIDAD_LEIDOS       NUMBER(6) := 0;
  CANTIDAD_RECHAZADOS   NUMBER(6) := 0;
  CANTIDAD_OK           NUMBER(6) := 0;

  V_DRE T_ARRAY_DRE := T_ARRAY_DRE(
      T_DRE('26059428','G016'),
      T_DRE('34234989','G116'),
      T_DRE('35579390','G555'),
      T_DRE('48977417','G653'),
      T_DRE('49316946','G669'),
      T_DRE('55996383','G569'),
      T_DRE('59030627','G015'),
      T_DRE('66721481','G680'),
      T_DRE('71492557','G636'),
      T_DRE('74285891','G640'),
      T_DRE('76225325','G637'),
      T_DRE('88304977','G519'),
      T_DRE('91357152','G103'),
      T_DRE('93117570','G599'),
      T_DRE('93604734','G670'),
      T_DRE('94198892','G115'),
      T_DRE('95711925','G656'),
      T_DRE('100869965','G586'),
      T_DRE('100942077','G539'),
      T_DRE('102364916','G141'),
      T_DRE('102705373','G527'),
      T_DRE('104585120','G109'),
      T_DRE('105327506','G024'),
      T_DRE('105671630','G002'),
      T_DRE('113257604','G602'),
      T_DRE('115628810','G632'),
      T_DRE('118236728','G536'),
      T_DRE('119613438','G609'),
      T_DRE('134421122','G621'),
      T_DRE('138316211','G634'),
      T_DRE('141207118','G570'),
      T_DRE('145081568','G583'),
      T_DRE('146437025','G606'),
      T_DRE('150766772','G515'),
      T_DRE('151962362','G597'),
      T_DRE('153634852','G548'),
      T_DRE('155940422','G652'),
      T_DRE('160520664','G528'),
      T_DRE('161117718','G566'),
      T_DRE('161667159','G568'),
      T_DRE('174388223','G594'),
      T_DRE('186430930','G551'),
      T_DRE('188588644','G588'),
      T_DRE('189433857','G520'),
      T_DRE('189677602','G664'),
      T_DRE('191503234','G616'),
      T_DRE('200240869','G534'),
      T_DRE('209353283','G102'),
      T_DRE('211560255','G571'),
      T_DRE('217854710','G605'),
      T_DRE('217856103','G572'),
      T_DRE('217890714','G587'),
      T_DRE('218544112','G668'),
      T_DRE('218980076','G642'),
      T_DRE('219482916','G105'),
      T_DRE('219751740','G593'),
      T_DRE('219791555','G573'),
      T_DRE('221623150','G614'),
      T_DRE('222136566','G110'),
      T_DRE('225181510','G615'),
      T_DRE('227326493','G546'),
      T_DRE('228997375','G661'),
      T_DRE('230331050','G631'),
      T_DRE('231512591','G595'),
      T_DRE('235190055','G638'),
      T_DRE('238275622','G535'),
      T_DRE('238357917','G641'),
      T_DRE('239214901','G559'),
      T_DRE('266095520','G580'),
      T_DRE('268661998','G112'),
      T_DRE('272459553','G675'),
      T_DRE('273986711','G020'),
      T_DRE('286456322','G537'),
      T_DRE('287273858','G625'),
      T_DRE('288653843','G104'),
      T_DRE('288656978','G108'),
      T_DRE('288661556','G001'),
      T_DRE('288689144','G011'),
      T_DRE('288787401','G013'),
      T_DRE('288791007','G660'),
      T_DRE('288989577','G111'),
      T_DRE('288990278','G100'),
      T_DRE('289251043','G113'),
      T_DRE('289777807','G585'),
      T_DRE('289831224','G584'),
      T_DRE('289884272','G505'),
      T_DRE('289884637','G500'),
      T_DRE('289893323','G503'),
      T_DRE('289898629','G021'),
      T_DRE('289949612','G504'),
      T_DRE('290155373','G509'),
      T_DRE('290155951','G512'),
      T_DRE('290156421','G524'),
      T_DRE('290156660','G517'),
      T_DRE('290157338','G502'),
      T_DRE('290157486','G516'),
      T_DRE('290159680','G514'),
      T_DRE('290159904','G508'),
      T_DRE('290175769','G510'),
      T_DRE('290176387','G521'),
      T_DRE('290177344','G529'),
      T_DRE('290218379','G507'),
      T_DRE('290393644','G014'),
      T_DRE('290551613','G530'),
      T_DRE('290894211','G531'),
      T_DRE('290900570','G027'),
      T_DRE('290907914','G023'),
      T_DRE('290917038','G025'),
      T_DRE('290917210','G028'),
      T_DRE('290924752','G029'),
      T_DRE('290934645','G030'),
      T_DRE('290938869','G022'),
      T_DRE('290987353','G533'),
      T_DRE('291020519','G532'),
      T_DRE('291148724','G538'),
      T_DRE('291186187','G541'),
      T_DRE('291212876','G543'),
      T_DRE('291223980','G542'),
      T_DRE('291296200','G545'),
      T_DRE('292335007','G547'),
      T_DRE('292381340','G549'),
      T_DRE('292447869','G550'),
      T_DRE('292618980','G552'),
      T_DRE('292833399','G553'),
      T_DRE('292939881','G655'),
      T_DRE('292950797','G554'),
      T_DRE('292999182','G556'),
      T_DRE('293025391','G557'),
      T_DRE('293082640','G565'),
      T_DRE('293089736','G558'),
      T_DRE('293091302','G561'),
      T_DRE('293091773','G562'),
      T_DRE('293092169','G564'),
      T_DRE('293092888','G563'),
      T_DRE('293098885','G560'),
      T_DRE('293590725','G567'),
      T_DRE('294035217','G581'),
      T_DRE('294060603','G600'),
      T_DRE('294060900','G574'),
      T_DRE('294070529','G575'),
      T_DRE('294071139','G576'),
      T_DRE('294071626','G577'),
      T_DRE('294095823','G579'),
      T_DRE('294097415','G578'),
      T_DRE('294143995','G582'),
      T_DRE('294397500','G589'),
      T_DRE('294466982','G591'),
      T_DRE('294467410','G590'),
      T_DRE('294471867','G592'),
      T_DRE('294490628','G651'),
      T_DRE('294535430','G596'),
      T_DRE('294593348','G598'),
      T_DRE('294625660','G601'),
      T_DRE('294730387','G603'),
      T_DRE('294769989','G604'),
      T_DRE('294781141','G619'),
      T_DRE('297121782','G607'),
      T_DRE('297122517','G608'),
      T_DRE('297153116','G611'),
      T_DRE('297154007','G610'),
      T_DRE('297181836','G612'),
      T_DRE('297187080','G613'),
      T_DRE('297233025','G617'),
      T_DRE('297260325','G618'),
      T_DRE('297302655','G620'),
      T_DRE('297320723','G622'),
      T_DRE('297349912','G623'),
      T_DRE('297372625','G624'),
      T_DRE('306685561','G644'),
      T_DRE('308510924','G626'),
      T_DRE('309415750','G627'),
      T_DRE('310082524','G628'),
      T_DRE('310262803','G629'),
      T_DRE('310359997','G630'),
      T_DRE('310633607','G633'),
      T_DRE('310739461','G635'),
      T_DRE('310864335','G639'),
      T_DRE('311116834','G643'),
      T_DRE('311210199','G645'),
      T_DRE('311401160','G646'),
      T_DRE('311967889','G647'),
      T_DRE('312093909','G648'),
      T_DRE('312111057','G649'),
      T_DRE('312929946','G657'),
      T_DRE('312947328','G650'),
      T_DRE('313070088','G654'),
      T_DRE('313240491','G658'),
      T_DRE('313309411','G659'),
      T_DRE('313402331','G678'),
      T_DRE('313448797','G662'),
      T_DRE('314366261','G663'),
      T_DRE('314401688','G665'),
      T_DRE('314517392','G666'),
      T_DRE('314580572','G667'),
      T_DRE('314938747','G671'),
      T_DRE('314946716','G672'),
      T_DRE('314976051','G673'),
      T_DRE('315006213','G674'),
      T_DRE('315012377','G679'),
      T_DRE('315027920','G676'),
      T_DRE('315150441','G677'),
      T_DRE('343114930','G681'));

  V_TMP_DRE T_DRE;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');

    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO TABLE_COUNT;

    IF TABLE_COUNT = 1 THEN
        FOR I IN V_DRE.FIRST .. V_DRE.LAST
            LOOP
                V_TMP_DRE := V_DRE(I);
                V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PVE_COD_UVEM = '''||V_TMP_DRE(1)||''' ';
                CANTIDAD_LEIDOS := CANTIDAD_LEIDOS + 1;
                EXECUTE IMMEDIATE V_MSQL INTO V_EXIST;
                V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PVE_COD_UVEM = '''||V_TMP_DRE(1)||''' AND PVE_COD_API_PROVEEDOR = '''||V_TMP_DRE(2)||''' ';
                EXECUTE IMMEDIATE V_MSQL INTO V_EXIST2;
                IF V_EXIST = 1 AND V_EXIST2 = 0 THEN
                  V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' T1 SET USUARIOMODIFICAR = ''HREOS-2837'', FECHAMODIFICAR = SYSDATE, PVE_COD_API_PROVEEDOR = '''||V_TMP_DRE(2)||''' WHERE PVE_COD_UVEM = '''||V_TMP_DRE(1)||''' ';
                  EXECUTE IMMEDIATE V_MSQL;
                  CANTIDAD_ACTUALIZADOS := CANTIDAD_ACTUALIZADOS + 1;
                ELSIF V_EXIST2 = 1 THEN
                  CANTIDAD_OK := CANTIDAD_OK + 1;
                ELSE
                  CANTIDAD_RECHAZADOS := CANTIDAD_RECHAZADOS + 1;
                  DBMS_OUTPUT.PUT_LINE('  [WARNING] No existe PVE_COD_UVEM = '''||V_TMP_DRE(1)||''' ');
                END IF;
            END LOOP;
        END IF;

        V_TMP_DRE := NULL;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('[FIN] Códigos actualizados.');
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('[RESUMEN]');
        DBMS_OUTPUT.PUT_LINE('  [INFO] Cantidad de códigos leídos                     : '||CANTIDAD_LEIDOS);
        DBMS_OUTPUT.PUT_LINE('  [INFO] Cantidad de códigos actualizados               : '||CANTIDAD_ACTUALIZADOS);
        DBMS_OUTPUT.PUT_LINE('  [INFO] Cantidad de códigos correctos con anterioridad : '||CANTIDAD_OK);
        DBMS_OUTPUT.PUT_LINE('  [INFO] Cantidad de códigos rechazados                 : '||CANTIDAD_RECHAZADOS);

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE;

END;
/
EXIT

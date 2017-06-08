--/*
--###########################################
--## AUTOR=Teresa Alonso
--## FECHA_CREACION=20170511
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2022
--## PRODUCTO=NO
--## 
--## Finalidad: Re-asignar gestores de activo (por numero activo) al gestor rdl
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] COMIENZA EL PROCESO PARA LA RE-ASIGNACIÓN DE GESTORES PARA ');
	DBMS_OUTPUT.PUT_LINE('         ACTIVOS ASIGNADOS POR DEFECTO A OTRO GESTOR'||CHR(10));
	
	EXECUTE IMMEDIATE '
	SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_GEST_ACT'' AND OWNER = '''||V_ESQUEMA||'''
	'
	INTO V_NUM
	;
	
	IF V_NUM > 0 THEN
  
    EXECUTE IMMEDIATE '
		TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GEST_ACT
		'
		;
	
		EXECUTE IMMEDIATE '
		DROP TABLE '||V_ESQUEMA||'.TMP_GEST_ACT
		'
		;
		
	END IF;

	EXECUTE IMMEDIATE '
	CREATE GLOBAL TEMPORARY TABLE '||V_ESQUEMA||'.TMP_GEST_ACT ON COMMIT PRESERVE ROWS AS (
	
	SELECT
	GEE_ID,
	GESTOR_CORRECTO,
	DD_TGE_ID,
	'||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL AS GEH_ID,
	ACT_ID
	FROM (
	
		SELECT DISTINCT
		GEE.GEE_ID,
		GEE.DD_TGE_ID,
		GES.USUARIO_GESTION_ACTIVOS AS GESTOR_CORRECTO,
		GAC.ACT_ID
		FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
		INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC
			ON GAC.GEE_ID = GEE.GEE_ID
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
			ON ACT.ACT_ID = GAC.ACT_ID
		INNER JOIN '||V_ESQUEMA||'.BIE_BIEN BIE
			ON BIE.BIE_ID = ACT.BIE_ID
		INNER JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION LOC
			ON LOC.BIE_ID = BIE.BIE_ID
		LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA PRV
			ON LOC.DD_PRV_ID = PRV.DD_PRV_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_GES_DISTRIBUCION GES
			ON GES.COD_PROVINCIA = PRV.DD_PRV_CODIGO
		LEFT JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU
			ON USU.USU_ID = GEE.USU_ID
		LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE
			ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
		LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_UPO_UNID_POBLACIONAL UPO
			ON UPO.DD_UPO_CODIGO = GES.COD_MUNICIPIO
		WHERE TGE.DD_TGE_CODIGO = ''GACT''

		AND ACT.ACT_NUM_ACTIVO_UVEM in (
			''25091402'',
			''21419987'',
			''15998403'',
			''25091636'',
			''24289063'',
			''22592489'',
			''20456285'',
			''19401008'',
			''24998865'',
			''24710717'',
			''24998748'',
			''24997350'',
			''28995485'',
			''28784964'',
			''28785390'',
			''28786068'',
			''15416612'',
			''15415682'',
			''15416594'',
			''15417992'',
			''15418553'',
			''15418805'',
			''15415565'',
			''15415700'',
			''15416126'',
			''24132330'',
			''24132816'',
			''24132933'',
			''24132447'',
			''24133476'',
			''15415196'',
			''15416009'',
			''15416963'',
			''15418436'',
			''15418670'',
			''15414653'',
			''15417038'',
			''15417524'',
			''15419096'',
			''15415214'',
			''15415934'',
			''15416477'',
			''15417155'',
			''15417641'',
			''28784361'',
			''28785525'',
			''15416360'',
			''15417407'',
			''15417758'',
			''15416243'',
			''15416729'',
			''15416846'',
			''15418067'',
			''28784730'',
			''28785156'',
			''28785273'',
			''28785642'',
			''21051985'',
			''28784847'',
			''28785408'',
			''28786554'',
			''15418319'',
			''15418787'',
			''28786320'',
			''15417272'',
			''28785039'',
			''24132564'',
			''24133125'',
			''28786185'',
			''28786203'',
			''17955311'',
			''17955662'',
			''24132681'',
			''28784613'',
			''28785876'',
			''28786437'',
			''28785759'',
			''28785993'',
			''21391377'',
			''24133008'',
			''21391494'',
			''15414887'',
			''15415331'',
			''16042129'',
			''15417389'',
			''15415079'',
			''15418922'',
			''15414770'',
			''15417875'',
			''15418184'',
			''15418202'',
			''20785103'',
			''20785688'',
			''20785454'',
			''15414905'',
			''15415448'',
			''20786969'',
			''20786483'',
			''20786735'',
			''21420235'',
			''26535583'',
			''25096934'',
			''25211866'',
			''25097126'',
			''25211263'',
			''25211983'',
			''25096700'',
			''25214737'',
			''25096448'',
			''25211749'',
			''25213087'',
			''15886975'',
			''28100606'',
			''28098698'',
			''28099493'',
			''28102313'',
			''28102898'',
			''28104137'',
			''28102547'',
			''28098833'',
			''28101752'',
			''15887167'',
			''28102178'',
			''28100957'',
			''28099376'',
			''28100588'',
			''28103225'',
			''28103108'',
			''25080441'',
			''25085253'',
			''24854548'',
			''24865140'',
			''25087194'',
			''25080189'',
			''25080558'',
			''25081470'',
			''25083429'',
			''20897719'',
			''17759867'',
			''17759984'',
			''15887050'',
			''28101986'',
			''28101518'',
			''28099745'',
			''28102781'',
			''28102664'',
			''28100840'',
			''28100723'',
			''28098716'',
			''28099511'',
			''28099142'',
			''20785571'',
			''20785706'',
			''20786501'',
			''26535349'',
			''26535718'',
			''17760349'',
			''20785823'',
			''20786132'',
			''20786366'',
			''20786618'',
			''17760115'',
			''20785940'',
			''20785220'',
			''20786015'',
			''20786852'',
			''20786249'',
			''20785337'',
			''28099979'',
			''28100120'',
			''28102916'',
			''28101032'',
			''28100471'',
			''15886741'',
			''28101401'',
			''28099628'',
			''13701062'',
			''13700870'',
			''13700987'',
			''17760097'',
			''17760232'',
			''26535466'',
			''26535601'',
			''26535952'',
			''26535835'',
			''17955428'',
			''15886624'',
			''15886858'',
			''28099025'',
			''17955293'',
			''28101869'',
			''28101149'',
			''28100354'',
			''28101383'',
			''28101266'',
			''28103090'',
			''28098950'',
			''28101635'',
			''28099862'',
			''28100003'',
			''28102061'',
			''28099259'',
			''28104254'',
			''17955545'',
			''28066394'',
			''28102430'',
			''28100237'',
			''28102295'',
			''25083177'',
			''25085973'',
			''25086534'',
			''25079356'',
			''25079842'',
			''25083294'',
			''25079005'',
			''25079473'',
			''25079725'',
			''23817960'',
			''20897602'',
			''25212913'',
			''21390834'',
			''21390951'',
			''21391260'',
			''21391629'',
			''21420469'',
			''24864948'',
			''24865023'',
			''25079239'',
			''25079590'',
			''25084827'',
			''25080810'',
			''25080927'',
			''25083312'',
			''25085622'',
			''25210837'',
			''25212661'',
			''25210468'',
			''25212175'',
			''25213825'',
			''25214134'',
			''25214503'',
			''24854431'',
			''25079608'',
			''25080675'',
			''25210603'',
			''25210720'',
			''25097243'',
			''25097963'',
			''25098272'',
			''25211497'',
			''25080207'',
			''25085136'',
			''20897836'',
			''25083060'',
			''20897584'',
			''25080072'',
			''25080792'',
			''25081353'',
			''25085856'',
			''25080324'',
			''25085370'',
			''25085505'',
			''25085739'',
			''20897467'',
			''21391143'',
			''21391026'',
			''21391512'',
			''25214971'',
			''25210585'',
			''25210954'',
			''25211380'',
			''25212544'',
			''25214620'',
			''25215046'',
			''25096682'',
			''25096817'',
			''25211029'',
			''25211515'',
			''25214485'',
			''25214854'',
			''25096079'',
			''25097009'',
			''25097594'',
			''25098407'',
			''21420352'',
			''25215163'',
			''25097360'',
			''25214017'',
			''25096214'',
			''25212427'',
			''25212895'',
			''24854314'',
			''23031241'',
			''23031124'',
			''24977387'',
			''24976961'',
			''20076741'',
			''21265026'',
			''21264582'',
			''21265377'',
			''21190284'',
			''21190536'',
			''21266541'',
			''21260817'',
			''21259966'',
			''21189100'',
			''21261963'',
			''21282955'',
			''21283030'',
			''21285943'',
			''21286855'',
			''21288445'',
			''21190653'',
			''21266172'',
			''21260682'',
			''21189334'',
			''21189568'',
			''21283867'',
			''21284428'',
			''21287398'',
			''21283984'',
			''21284293'',
			''21285457'',
			''21285826'',
			''21286972'',
			''21287047'',
			''21287416'',
			''21265260'',
			''21265494'',
			''21265629'',
			''21266289'',
			''21266424'',
			''21261360'',
			''21262875'',
			''21262992'',
			''21283264'',
			''21284662'',
			''21284779'',
			''21286252'',
			''21286486'',
			''25148725'',
			''25154505'',
			''27172430'',
			''27173342'',
			''27173945'',
			''27176564'',
			''27177728'',
			''27177962'',
			''25215280'',
			''27172547'',
			''27172898'',
			''27175535'',
			''27177611'',
			''27178523'',
			''27179201'',
			''27184537'',
			''27184771'',
			''27185197'',
			''27173225'',
			''27183256'',
			''27184168'',
			''27185449'',
			''27185935'',
			''27186478'',
			''27174254'',
			''27174740'',
			''27176330'',
			''27176933'',
			''27179435'',
			''27180637'',
			''27182947'',
			''27185215'',
			''27186010'',
			''27186595'',
			''25155300'',
			''27187273'',
			''25026177'',
			''21264951'',
			''21266307'',
			''21260196'',
			''21263319'',
			''21262758'',
			''21263787'',
			''21283147'',
			''16183224'',
			''21263922'',
			''21264096'',
			''21288679'',
			''21284176'',
			''21285106'',
			''21285709'',
			''16183341'',
			''21265980'',
			''21261846'',
			''21260079'',
			''21189685'',
			''21188773'',
			''21284545'',
			''21285340'',
			''21190302'',
			''21283750'',
			''25147444'',
			''25146883'',
			''25149754'',
			''25155048'',
			''25155534'',
			''19536809'',
			''25154856'',
			''25154973'',
			''25155417'',
			''25154487'',
			''19535879'',
			''25147075'',
			''19535528'',
			''19535762'',
			''19536323'',
			''19536071'',
			''21264465'',
			''21191817'',
			''21191448'',
			''21264231'',
			''21263553'',
			''21265143'',
			''21190887'',
			''21191565'',
			''21264600'',
			''21190419'',
			''21189937'',
			''21260448'',
			''21261477'',
			''21266658'',
			''21189082'',
			''21283633'',
			''21284896'',
			''21260934'',
			''21284311'',
			''21284914'',
			''21286738'',
			''21189703'',
			''20792497'',
			''21263202'',
			''21262155'',
			''21286369'',
			''21264114'',
			''21264348'',
			''21264717'',
			''21265512'',
			''21191934'',
			''21260565'',
			''21262272'',
			''21285088'',
			''21285691'',
			''21286504'',
			''13464320'',
			''27178271'',
			''27180385'',
			''27185683'',
			''27172664'',
			''27175886'',
			''27179183'',
			''27179786'',
			''27180034'',
			''27181180'',
			''27185080'',
			''27185332'',
			''25154739'',
			''27176681'',
			''27179804'',
			''27180988'',
			''27181297'',
			''25154253'',
			''25154622'',
			''25155282'',
			''27174371'',
			''27176447'',
			''27176816'',
			''27178154'',
			''27180871'',
			''27182830'',
			''27183139'',
			''27184285'',
			''27186127'',
			''27187390'',
			''27187525'',
			''25155165'',
			''27187156'',
			''27187408'',
			''25042591'',
			''27183976'',
			''27173108'',
			''27175418'',
			''27178640'',
			''27178874'',
			''27180151'',
			''27183022'',
			''27173459'',
			''27177359'',
			''27179921'',
			''27180520'',
			''27181315'',
			''27181549'',
			''27184051'',
			''27184654'',
			''27184906'',
			''27175904'',
			''27177008'',
			''27181801'',
			''27181918'',
			''27182713'',
			''27183490'',
			''27186361'',
			''27176213'',
			''27178406'',
			''27179066'',
			''27180754'',
			''27182461'',
			''27183373'',
			''27184888'',
			''27186244'',
			''27187642'',
			''27187759'',
			''27187039'',
			''19535996'',
			''19536557'',
			''19536791'',
			''19536674'',
			''21190050'',
			''21266055'',
			''21190167'',
			''21191331'',
			''21261126'',
			''21189217'',
			''21262524'',
			''21263067'',
			''21283381'',
			''21284059'',
			''21285574'',
			''21263805'',
			''21188908'',
			''21261729'',
			''21191196'',
			''21190770'',
			''21265746'',
			''21265863'',
			''21189820'',
			''21260700'',
			''21189451'',
			''11992081'',
			''21282838'',
			''21290325'',
			''21285223'',
			''21286018'',
			''21259849'',
			''21261612'',
			''21262389'',
			''16183107'',
			''21191682'',
			''21191214'',
			''21191700'',
			''21263184'',
			''21261594'',
			''21287281'',
			''21287533'',
			''16183458'',
			''25215397'',
			''25098389'',
			''25215415'',
			''25154370'',
			''25098038'',
			''25147192'',
			''25148842'',
			''25148239'',
			''27173090'',
			''27172178'',
			''27175166'',
			''27175283'',
			''27177242'',
			''27177593'',
			''27178037'',
			''27178757'',
			''27178991'',
			''27173711'',
			''27175652'',
			''27179552'',
			''27181666'',
			''27184420'',
			''27172781'',
			''27174020'',
			''27174857'',
			''27176195'',
			''27178388'',
			''27179669'',
			''27181063'',
			''27182092'',
			''27183742'',
			''27172313'',
			''27175301'',
			''27175769'',
			''27176798'',
			''27177125'',
			''27177476'',
			''27177845'',
			''27180268'',
			''27182578'',
			''27185566'',
			''19535645'',
			''25098155'',
			''19536440'',
			''19536188'',
			''19536206'',
			''28999034'',
			''28999151'',
			''28998959'',
			''28998590'',
			''28998608'',
			''28998842'',
			''28998473'',
			''25091384'',
			''25091519'',
			''28999403'',
			''29015931'',
			''17650529'',
			''28998725'',
			''20194534'',
			''27173828'',
			''27174506'',
			''22012306'',
			''27179318'',
			''27183625'',
			''27174488'',
			''27185818'',
			''27176078'',
			''23031358'',
			''24977153'',
			''23031007'',
			''24977639'',
			''17650412'',
			''24977405'',
			''24977036'',
			''24977522'',
			''24977270'',
			''27173576'',
			''27182695'',
			''27183508'',
			''27173693'',
			''27182344'',
			''27186730'',
			''27186847'',
			''27174623'',
			''27184303'',
			''27172295'',
			''27174974'',
			''27181432'',
			''27186964'',
			''27174137'',
			''27186613'',
			''27175049'',
			''27180403'',
			''27183859'',
			''27182110'',
			''27182227'',
			''27187876'',
			''21328966'',
			''20456303'',
			''21433974'',
			''15459373'',
			''15459742'',
			''19752315'',
			''19752918'',
			''19758390'',
			''19759068'',
			''19759437'',
			''15459256'',
			''15459508'',
			''15459625'',
			''15459859'',
			''15460089'',
			''15460692'',
			''15951724'',
			''15459976'',
			''15460107'',
			''15460944'',
			''15461019'',
			''15818060'',
			''19760153'',
			''13530197'',
			''19753830'',
			''19756197'',
			''19757361'',
			''19757478'',
			''19757595'',
			''15459490'',
			''15460224'',
			''15460458'',
			''15460575'',
			''15460341'',
			''15460710'',
			''15460827'',
			''15461136'',
			''15461253'',
			''19760036'',
			''19753461'',
			''19757127'',
			''19757244'',
			''19759320'',
			''19752432'',
			''19754373'',
			''19755168'',
			''19758156'',
			''19758993'',
			''15951607'',
			''15951841'',
			''21477548'',
			''20899291'',
			''20899309'',
			''20900152'',
			''20900269'',
			''20901298'',
			''20901316'',
			''20901784'',
			''20902093'',
			''23001967'',
			''23002159'',
			''23002276'',
			''23002762'',
			''23002879'',
			''23003206'',
			''23003323'',
			''23004118'',
			''20898865'',
			''20898982'',
			''20899057'',
			''20899660'',
			''20899894'',
			''20900035'',
			''20900404'',
			''20900755'',
			''20900872'',
			''20901802'',
			''20901919'',
			''23000686'',
			''23001850'',
			''23002528'',
			''23003071'',
			''23003926'',
			''23004001'',
			''23004235'',
			''20898514'',
			''20898748'',
			''20899426'',
			''20899543'',
			''20900386'',
			''20900521'',
			''20900638'',
			''20901064'',
			''20901433'',
			''20901550'',
			''23000704'',
			''23000821'',
			''23000938'',
			''23001013'',
			''23001247'',
			''23002996'',
			''23003809'',
			''20673675'',
			''20899174'',
			''20899777'',
			''20899912'',
			''20900989'',
			''20901181'',
			''20901667'',
			''23001130'',
			''23001364'',
			''23001481'',
			''23001598'',
			''23001616'',
			''23002042'',
			''23002393'',
			''23002411'',
			''23002645'',
			''23003188'',
			''23003440'',
			''23003557'',
			''23003674'',
			''23003791'',
			''23901625'',
			''14953412'',
			''14953763'',
			''14953529'',
			''14953646'',
			''20902111'',
			''17759750'',
			''23817843'',
			''23817726'',
			''15898596'',
			''24869040'',
			''25060847'',
			''22029576'',
			''22030661'',
			''22030058'',
			''22030310'',
			''22030175'',
			''22030292'',
			''24865626'',
			''24865743'',
			''22030778'',
			''24869643'',
			''22029342'',
			''22029828'',
			''22029459'',
			''22029945'',
			''22029225'',
			''22029693'',
			''25212778'',
			''26351231'',
			''26351348'',
			''26351114'',
			''21938820'',
			''21939363'',
			''21939597'',
			''21940331'',
			''21940448'',
			''21939966'',
			''26181881'',
			''21938082'',
			''21938334'',
			''21938568'',
			''21939480'',
			''21939732'',
			''21940079'',
			''21940214'',
			''21940700'',
			''21938937'',
			''21939615'',
			''21938451'',
			''21938100'',
			''21938217'',
			''21939012'',
			''21939246'',
			''21940682'',
			''21938703'',
			''21939129'',
			''21940196'',
			''21940565'',
			''21938685'',
			''21939849'',
			''25213942'',
			''25147795'',
			''24984682'',
			''24985009'',
			''24984700'',
			''24984934'',
			''24985243'',
			''24984817'',
			''24985126'',
			''27308316'',
			''27308433'',
			''23816679'',
			''23816814'',
			''23817006'',
			''23816931'',
			''23817123'',
			''24864831'',
			''29016006'',
			''29016123'',
			''29016240'',
			''29016357'',
			''29016474'',
			''29016591'',
			''29016609'',
			''29016726'',
			''29016843'',
			''29016960'',
			''29017035'',
			''29017152'',
			''29017269'',
			''29017386''
						)
		AND USU.USU_USERNAME not in (''rdl'') 
		AND GES.PROVINCIA IS NOT NULL
		AND GES.MUNICIPIO IS NULL
		AND GEE.BORRADO = 0
	)
	)
	'
	;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] SE VA A ACTUALIZAR EL GESTOR A '||V_NUM||' ACTIVOS.');
 
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO USU_ID EN GEE_GESTOR_ENTIDAD...');
	
	EXECUTE IMMEDIATE '
	MERGE INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE USING
	(
	SELECT 
	TMPGEST.GEE_ID,
	TMPGEST.ACT_ID,
	USU.USU_ID
	FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMPGEST
	LEFT JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU
		ON USU.USU_USERNAME = ''rdl'' 
	) TMP
	ON (GEE.GEE_ID = TMP.GEE_ID)
	WHEN MATCHED THEN UPDATE SET
	GEE.USU_ID = TMP.USU_ID,
	GEE.USUARIOMODIFICAR = ''HREOS-2022-5'',
	GEE.FECHAMODIFICAR = SYSDATE
	'
	;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] GEE_GESTOR_ENTIDAD ACTUALIZADA...'||V_NUM||' REGISTROS.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO GEH_FECHA_HASTA EN GEH_GESTOR_ENTIDAD_HIST PARA DAR DE BAJA EL ANTERIOR GESTOR...');
	
	EXECUTE IMMEDIATE '
	MERGE INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH USING
	(
	WITH ACT AS (
    SELECT DISTINCT
    TMP.ACT_ID,
    GAH.GEH_ID,
    TMP.DD_TGE_ID,
    (SELECT USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS WHERE USU_USERNAME =  ''rdl'' ) AS USU_ID 
    FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMP
    LEFT JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
      ON GAH.ACT_ID = TMP.ACT_ID
    LEFT JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC
      ON GAC.ACT_ID = TMP.ACT_ID
    LEFT JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
      ON GEE.GEE_ID = GAC.GEE_ID
    WHERE GAH.ACT_ID IS NOT NULL
    AND GEE.USUARIOMODIFICAR = ''HREOS-2022-5''
  )
  SELECT GEH.GEH_ID
  FROM ACT
  INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
    ON GEH.GEH_ID = ACT.GEH_ID
  WHERE GEH.USU_ID != ACT.USU_ID
  AND GEH.DD_TGE_ID = ACT.DD_TGE_ID
	) TMP
	ON (GEH.GEH_ID = TMP.GEH_ID)
	WHEN MATCHED THEN UPDATE SET
	GEH.GEH_FECHA_HASTA = SYSDATE,
	GEH.USUARIOMODIFICAR = ''HREOS-2022-5'',
	GEH.FECHAMODIFICAR = SYSDATE
	'
	;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] GEH_GESTOR_ENTIDAD_HIST ACTUALIZADA...'||V_NUM||' REGISTROS.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO NUEVOS REGISTROS EN GEH_GESTOR_ENTIDAD_HIST PARA DAR DE ALTA EL NUEVO GESTOR...');
	
	EXECUTE IMMEDIATE '
	INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
	(GEH_ID,
	USU_ID,
	DD_TGE_ID,
	GEH_FECHA_DESDE,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	SELECT
	GEH_ID,
	(SELECT USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS WHERE USU_USERNAME = ''rdl'' ) AS USU_ID, 
	DD_TGE_ID,
	SYSDATE AS GEH_FECHA_DESDE,
	''HREOS-2022-5'' AS USUARIOCREAR,
	SYSDATE AS FECHACREAR,
	0 AS BORRADO
	FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMP
	'
	;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '||V_NUM||' REGISTROS EN GEH_GESTOR_ENTIDAD_HIST.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO NUEVOS REGISTROS EN GAH_GESTOR_ACTIVO_HISTORICO PARA RELACIONAR LOS REGISTROS DE');
	DBMS_OUTPUT.PUT_LINE('       GEH_GESTOR_ENTIDAD_HIST CON LOS ACTIVOS...');
	
	EXECUTE IMMEDIATE '
	INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
	(GEH_ID,
	ACT_ID
	)
	SELECT 
	GEH_ID,
	ACT_ID
	FROM '||V_ESQUEMA||'.TMP_GEST_ACT
	'
	;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '||V_NUM||' REGISTROS EN GAH_GESTOR_ACTIVO_HISTORICO.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] GESTORES ACTUALIZADOS CORRECTAMENTE.'||CHR(10));

--      HREOS-2022-5:No asignar gestores a las tareas afectadas  	
--	DBMS_OUTPUT.PUT_LINE('[INFO] SE VAN A RE-ASIGNAR LOS GESTORES PARA LAS TAREAS AFECTADAS...');
	
--	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO USU_ID EN TAC_TAREAS_ACTIVO...');
	
--	EXECUTE IMMEDIATE '
--	MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC USING
--	(
--	SELECT
--	TAC.TAR_ID,
--	TAC.ACT_ID,
--	TAC.USU_ID,
--	GEE.GEE_ID,
--	GEE.DD_TGE_ID as GEE_DD_TGE_ID,
--	TAP.DD_TGE_ID as TAP_DD_TGE_ID,
--	GEE.USU_ID as USU_ID_NEW
--	FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC 
--	INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
--	  ON TAR.TAR_ID = TAC.TAR_ID
--	INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX
--	  ON TEX.TAR_ID = TAR.TAR_ID
--	INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
--	  ON TAP.TAP_ID = TEX.TAP_ID
--	INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC 
--	  ON GAC.ACT_ID = TAC.ACT_ID
--	INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE 
--	  ON GEE.GEE_ID = GAC.GEE_ID
--	WHERE GEE.DD_TGE_ID = (select dd_tge_id from remmaster.dd_tge_tipo_gestor where dd_tge_codigo = ''GACT'')
--	AND TAP.DD_TGE_ID = (select dd_tge_id from remmaster.dd_tge_tipo_gestor where dd_tge_codigo = ''GACT'') 
--	AND TAC.USU_ID != GEE.USU_ID
--	AND TAR.TAR_FECHA_FIN IS NULL
--	--AND TAC.BORRADO = 0
--	--AND TAR.BORRADO = 0
--	--AND TEX.BORRADO = 0
--	--AND TAP.BORRADO = 0
--	AND GEE.BORRADO = 0
--	AND GEE.USUARIOMODIFICAR = ''HREOS-2022-5''
--	) TMP
--	ON (TAC.TAR_ID = TMP.TAR_ID)
--	WHEN MATCHED THEN UPDATE SET
--	TAC.USU_ID = TMP.USU_ID_NEW,
--	TAC.USUARIOMODIFICAR = ''HREOS-2022-5'',
--	TAC.FECHAMODIFICAR = SYSDATE
--	'
--	;
--	
--	V_NUM := SQL%ROWCOUNT;
--	
--	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||V_NUM||' REGISTROS EN TAC_TAREAS_ACTIVOS.');
--	
--	DBMS_OUTPUT.PUT_LINE('[INFO] TAREAS ACTUALIZADAS.'||CHR(10));
--
	 
 	EXECUTE IMMEDIATE '
	SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_GEST_ACT'' AND OWNER = '''||V_ESQUEMA||'''
	'
	INTO V_NUM
	;

	IF V_NUM > 0 THEN
  
    EXECUTE IMMEDIATE '
		TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GEST_ACT
		'
		;
	
		EXECUTE IMMEDIATE '
		DROP TABLE '||V_ESQUEMA||'.TMP_GEST_ACT
		'
		;
		
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]  PROCESO FINALIZADO CORRECTAMENTE ');
 
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

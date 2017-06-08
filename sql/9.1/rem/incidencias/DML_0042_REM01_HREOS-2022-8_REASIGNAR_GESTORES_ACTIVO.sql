--/*
--###########################################
--## AUTOR=Teresa Alonso
--## FECHA_CREACION=20170511
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2022
--## PRODUCTO=NO
--## 
--## Finalidad: Re-asignar gestores de activo (por numero activo) al gestor rdura
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
			''15511220'',
			''15514208'',
			''15508428'',
			''15508914'',
			''15509943'',
			''15514073'',
			''15523813'',
			''15524239'',
			''15508545'',
			''15509826'',
			''15515471'',
			''15524005'',
			''15514793'',
			''15510893'',
			''15514325'',
			''24061506'',
			''20487191'',
			''20487326'',
			''20486531'',
			''20037745'',
			''20037862'',
			''25018222'',
			''20486900'',
			''25018708'',
			''25018339'',
			''12986572'',
			''12986707'',
			''12986941'',
			''19196066'',
			''24873347'',
			''24874142'',
			''26563150'',
			''26563753'',
			''26563987'',
			''26565343'',
			''26563402'',
			''26564314'',
			''24873464'',
			''24873716'',
			''24874376'',
			''24874493'',
			''24874628'',
			''24874862'',
			''24875423'',
			''24875540'',
			''24876083'',
			''23038732'',
			''26564179'',
			''26564296'',
			''26564431'',
			''26564800'',
			''26565694'',
			''26563519'',
			''26563033'',
			''26563636'',
			''26565091'',
			''25018690'',
			''25019017'',
			''25017895'',
			''20380397'',
			''20380883'',
			''23918175'',
			''12987250'',
			''23038849'',
			''25017778'',
			''25018456'',
			''25018942'',
			''24874979'',
			''24873581'',
			''24875054'',
			''24876101'',
			''24873698'',
			''24873833'',
			''24874025'',
			''24874745'',
			''24875171'',
			''24875774'',
			''20132236'',
			''26564062'',
			''26564917'',
			''26565109'',
			''26565577'',
			''19860428'',
			''25077280'',
			''26460742'',
			''23038615'',
			''17205643'',
			''25017661'',
			''25018087'',
			''25019134'',
			''25018105'',
			''25018573'',
			''25018825'',
			''24873230'',
			''24874511'',
			''24874259'',
			''12986689'',
			''12987016'',
			''26140944'',
			''23009902'',
			''25072837'',
			''25076971'',
			''15737808'',
			''21908340'',
			''20733925'',
			''26563870'',
			''20734585'',
			''26564548'',
			''23023151'',
			''22034210'',
			''27219605'',
			''27220924'',
			''27221098'',
			''27221350'',
			''27222145'',
			''27220555'',
			''27222028'',
			''27892707'',
			''27220672'',
			''27221467'',
			''27222748'',
			''20380766'',
			''27220186'',
			''27892824'',
			''20380415'',
			''27893016'',
			''20381075'',
			''20380532'',
			''27893367'',
			''27893484'',
			''13400315'',
			''14568496'',
			''15962784'',
			''27220807'',
			''27222514'',
			''27223291'',
			''14568748'',
			''21543560'',
			''21677594'',
			''26140827'',
			''21315227'',
			''21315110'',
			''20132470'',
			''25084944'',
			''20133985'',
			''20135944'',
			''20134177'',
			''21315344'',
			''25072351'',
			''25077163'',
			''25077649'',
			''25076620'',
			''25077766'',
			''25077901'',
			''26175264'',
			''26175498'',
			''26175633'',
			''25077532'',
			''25076503'',
			''25076854'',
			''26174586'',
			''26174721'',
			''26175030'',
			''26175750'',
			''19598504'',
			''20734234'',
			''20734468'',
			''23023268'',
			''20380901'',
			''20380649'',
			''27892941'',
			''27893133'',
			''27892689'',
			''27893250'',
			''15473360'',
			''15474407'',
			''27254332'',
			''26208373'',
			''26189933'',
			''15473846'',
			''15473477'',
			''15474155'',
			''26208022'',
			''26206180'',
			''26209420'',
			''26206783'',
			''26206549'',
			''26713509'',
			''26206918'',
			''26205385'',
			''26206063'',
			''26207830'',
			''20622824'',
			''26713257'',
			''26174352'',
			''25076485'',
			''22585797'',
			''25072585'',
			''25072720'',
			''22585680'',
			''26174604'',
			''15737439'',
			''22585815'',
			''22586241'',
			''20035183'',
			''20035066'',
			''15737556'',
			''20622941'',
			''20622689'',
			''20021738'',
			''27256876'',
			''20486765'',
			''24142595'',
			''19170514'',
			''20734351'',
			''27255361'',
			''20487074'',
			''20017548'',
			''27255478'',
			''20486648'',
			''20734117'',
			''27255127'',
			''20037979'',
			''25072000'',
			''25072117'',
			''17205877'',
			''12985660'',
			''12985777'',
			''15473594'',
			''26713491'',
			''15473729'',
			''15474389'',
			''26713626'',
			''15473963'',
			''13400666'',
			''20487209'',
			''27255595'',
			''27255244'',
			''20486882'',
			''15474038'',
			''15473612'',
			''26208490'',
			''26207092'',
			''26205988'',
			''26205637'',
			''26207713'',
			''26208859'',
			''26209285'',
			''26207461'',
			''15474272'',
			''26209051'',
			''26207227'',
			''26189816'',
			''26204959'',
			''26208256'',
			''26206315'',
			''26205034'',
			''26205268'',
			''26205754'',
			''26205871'',
			''26207344'',
			''26208976'',
			''26208742'',
			''26206801'',
			''26206666'',
			''26205520'',
			''26207578'',
			''26207695'',
			''26207110'',
			''26206297'',
			''26207947'',
			''26208508'',
			''26208625'',
			''26209303'',
			''26204725'',
			''13400783'',
			''13400549'',
			''13813795'',
			''16800734'',
			''27886675'',
			''25085019'',
			''26327195'',
			''20133400'',
			''14855798'',
			''14856359'',
			''14856593'',
			''14855564'',
			''14855816'',
			''14856728'',
			''14854418'',
			''14854886'',
			''14855213'',
			''19798316'',
			''19799831'',
			''19800071'',
			''19800206'',
			''14854769'',
			''14855195'',
			''19798550'',
			''19798667'',
			''19798802'',
			''19798919'',
			''19799093'',
			''19799228'',
			''19799696'',
			''19799714'',
			''19800323'',
			''14854301'',
			''14854904'',
			''14855078'',
			''14854535'',
			''14854652'',
			''14855681'',
			''14856008'',
			''14856962'',
			''14855933'',
			''14856125'',
			''14856242'',
			''14856476'',
			''14856611'',
			''14856845'',
			''19798784'',
			''19800188'',
			''19800440'',
			''14855447'',
			''19739474'',
			''19798298'',
			''19798433'',
			''19799111'',
			''19799345'',
			''19799462'',
			''19799579'',
			''19799948'',
			''19801001'',
			''19800557'',
			''19800674'',
			''19800791'',
			''19800809'',
			''19800926'',
			''19801118'',
			''19382181'',
			''21356884'',
			''20648259'',
			''20637550'',
			''20638093'',
			''20638579'',
			''20638714'',
			''20638948'',
			''20639374'',
			''20639509'',
			''20639626'',
			''20639860'',
			''20640225'',
			''20640711'',
			''20641020'',
			''20641371'',
			''20642166'',
			''20642652'',
			''20643213'',
			''20643798'',
			''20643933'',
			''20644008'',
			''20645388'',
			''20645640'',
			''20646318'',
			''20647347'',
			''20647464'',
			''22969025'',
			''20639977'',
			''20640108'',
			''20640342'',
			''20640693'',
			''20640828'',
			''20641137'',
			''20641857'',
			''20642283'',
			''20642535'',
			''20642886'',
			''20643564'',
			''20643816'',
			''20644125'',
			''20644359'',
			''20644962'',
			''20645037'',
			''20645154'',
			''20645406'',
			''20645757'',
			''20645991'',
			''20646066'',
			''20646804'',
			''20647095'',
			''20647113'',
			''20647698'',
			''20647716'',
			''20640090'',
			''20640459'',
			''20640576'',
			''20641254'',
			''20641488'',
			''20638111'',
			''20638345'',
			''20638831'',
			''20639023'',
			''20639140'',
			''20637667'',
			''20637802'',
			''20638696'',
			''20639491'',
			''21356416'',
			''21356533'',
			''21356650'',
			''21356767'',
			''20641623'',
			''20641740'',
			''20642301'',
			''20643078'',
			''20643330'',
			''20643447'',
			''20643681'',
			''20644242'',
			''20644611'',
			''20644728'',
			''20644845'',
			''20645271'',
			''20645523'',
			''20645874'',
			''20646201'',
			''20646435'',
			''20646669'',
			''20646921'',
			''20647833'',
			''20648376'',
			''20648628'',
			''20777616'',
			''21910823'',
			''21911483'',
			''21911501'',
			''21912161'',
			''21941846'',
			''21942389'',
			''21942875'',
			''21908457'',
			''21909369'',
			''21909621'',
			''21910220'',
			''21910337'',
			''21909252'',
			''21909972'',
			''21910085'',
			''21910454'',
			''21910571'',
			''21910940'',
			''21911132'',
			''21911618'',
			''21911852'',
			''21911969'',
			''21912044'',
			''21912278'',
			''21942155'',
			''21942524'',
			''20647950'',
			''20648025'',
			''20648745'',
			''21908223'',
			''21908691'',
			''21908709'',
			''21908826'',
			''21909018'',
			''21909486'',
			''21909504'',
			''21909738'',
			''21910688'',
			''20637784'',
			''20637919'',
			''20638228'',
			''20638462'',
			''20639257'',
			''21356902'',
			''23900947'',
			''23901256'',
			''24029380'',
			''24029749'',
			''23900461'',
			''23901022'',
			''23904730'',
			''24029632'',
			''24029866'',
			''21942407'',
			''21942758'',
			''20648142'',
			''20648493'',
			''20648511'',
			''20639743'',
			''20640945'',
			''23900830'',
			''23901373'',
			''24029263'',
			''24029497'',
			''20641506'',
			''20641974'',
			''20642049'',
			''20642418'',
			''20642769'',
			''20642904'',
			''20643195'',
			''20644476'',
			''20644593'',
			''20646183'',
			''20646552'',
			''20646786'',
			''20647230'',
			''20647581'',
			''21908574'',
			''21908943'',
			''21909135'',
			''21909855'',
			''21910103'',
			''21910706'',
			''21911015'',
			''21911249'',
			''21911366'',
			''21911735'',
			''21941729'',
			''21941963'',
			''21942038'',
			''21942272'',
			''21942641'',
			''23901139'',
			''23840715'',
			''22955211'',
			''23006914'',
			''23900695'',
			''23840832'',
			''23900344'',
			''26205151'',
			''23900227'',
			''26563267'',
			''23900713'',
			''23900578'',
			''21115397'',
			''21356281'',
			''22911637'',
			''19798181'',
			''10395011'',
			''12446900'',
			''24876335'',
			''24876452'',
			''24876569'',
			''24876686'',
			''24876704'',
			''24876821'',
			''24876938'',
			''24877013'',
			''24877364'',
			''28118185'',
			''28118806'',
			''28119952'',
			''28119349'',
			''28115683'',
			''28121949'',
			''28119232'',
			''28121112'',
			''28121094'',
			''28118203'',
			''28120920'',
			''28115818'',
			''28117759'',
			''28118068'',
			''28115449'',
			''28117039'',
			''28116595'',
			''28121697'',
			''28119835'',
			''28120785'',
			''28116010'',
			''28116964'',
			''28115935'',
			''28116478'',
			''28117876'',
			''28118437'',
			''28119097'',
			''28121832'',
			''28119601'',
			''28120317'',
			''28118671'',
			''28121463'',
			''28117993'',
			''28122141'',
			''28119466'',
			''28120182'',
			''28116613'',
			''28118554'',
			''28117525'',
			''28117273'',
			''28120200'',
			''28115215'',
			''28118320'',
			''28121346'',
			''28120065'',
			''28121715'',
			''28118923'',
			''28116127'',
			''28120668'',
			''28115566'',
			''28118788'',
			''28119718'',
			''28117642'',
			''28122375'',
			''28117408'',
			''28121580'',
			''28120434'',
			''28116730'',
			''28116244'',
			''28117156'',
			''28119583'',
			''28120803'',
			''28120551'',
			''28115332'',
			''28117390'',
			''28116361'',
			''28119115'',
			''28115701'',
			''28116847'',
			''25019485'',
			''25019368'',
			''25087932'',
			''25088241'',
			''25088358'',
			''25089153'',
			''25089270'',
			''25089990'',
			''25090238'',
			''25090355'',
			''25090472'',
			''25090589'',
			''25090841'',
			''25088124'',
			''25089036'',
			''25089756'',
			''25090724'',
			''25090958'',
			''25087680'',
			''25087815'',
			''25088007'',
			''25088961'',
			''25089387'',
			''25089522'',
			''25089873'',
			''25090607'',
			''25091267'',
			''25087797'',
			''25090004'',
			''25091033'',
			''25091150'',
			''26179533'',
			''25175128'',
			''25175596'',
			''25218268'',
			''25218637'',
			''26141253'',
			''26141370'',
			''26160169'',
			''26160286'',
			''26170083'',
			''26171247'',
			''25218871'',
			''26170101'',
			''26172276'',
			''26172393'',
			''26159939'',
			''26160052'',
			''25175362'',
			''25218988'',
			''26141019'',
			''26173440'',
			''26173674'',
			''26173791'',
			''25175011'',
			''25175245'',
			''25175479'',
			''25218403'',
			''25218754'',
			''26171364'',
			''26171481'',
			''26172159'',
			''26173926'',
			''26565829'',
			''26565712'',
			''26578011'',
			''26578128'',
			''26578245'',
			''26578362'',
			''26571474'',
			''26564665'',
			''16801394'',
			''16801412'',
			''16802189'',
			''16802927'',
			''16800851'',
			''16801529'',
			''16801646'',
			''16803002'',
			''16803119'',
			''16800968'',
			''16801043'',
			''16801763'',
			''16801880'',
			''18853465'',
			''18853717'',
			''16801160'',
			''16801277'',
			''16801997'',
			''16802072'',
			''26208139'',
			''28572793'',
			''20242776'',
			''27254566'',
			''27254701'',
			''27254935'',
			''27255613'',
			''27255730'',
			''27256759'',
			''20133634'',
			''20134312'',
			''20134546'',
			''20134663'',
			''20134780'',
			''20134897'',
			''20134915'',
			''20135089'',
			''20135224'',
			''20135458'',
			''20135692'',
			''20181866'',
			''20181983'',
			''20132605'',
			''20132839'',
			''20133868'',
			''20133382'',
			''24710465'',
			''24710582'',
			''27910235'',
			''24671108'',
			''24671711'',
			''25191308'',
			''25191542'',
			''25191425'',
			''28561616'',
			''28559250'',
			''28558338'',
			''28561733'',
			''28559853'',
			''28556262'',
			''28558707'',
			''28557174'',
			''28564352'',
			''28557777'',
			''28558104'',
			''28563440'',
			''28555953'',
			''28557291'',
			''28556514'',
			''28560569'',
			''28561598'',
			''28565498'',
			''28557894'',
			''28559736'',
			''28554186'',
			''28560821'',
			''28563674'',
			''28560452'',
			''28562762'',
			''28561130'',
			''28557543'',
			''28558086'',
			''28563188'',
			''28564118'',
			''28562645'',
			''28558455'',
			''28565381'',
			''28556865'',
			''28560083'',
			''28560686'',
			''28560101'',
			''28562879'',
			''28557660'',
			''28562042'',
			''28556145'',
			''28563206'',
			''28562276'',
			''28560704'',
			''28559502'',
			''28565264'',
			''28564604'',
			''28558689'',
			''28565030'',
			''28564469'',
			''28563926'',
			''28565147'',
			''28559133'',
			''28564721'',
			''28559484'',
			''28563071'',
			''28562996'',
			''28564235'',
			''28556028'',
			''28560335'',
			''28563791'',
			''28561013'',
			''28562159'',
			''28558221'',
			''28562528'',
			''28564586'',
			''28561481'',
			''28561247'',
			''28563809'',
			''28558941'',
			''28556748'',
			''28560938'',
			''28559619'',
			''28563557'',
			''28563323'',
			''28562411'',
			''28557309'',
			''28560218'',
			''28557912'',
			''28561364'',
			''28559970'',
			''28561850'',
			''28564001'',
			''28556982'',
			''28556631'',
			''28556496'',
			''28558824'',
			''28559016'',
			''28561967'',
			''28562393'',
			''28559367'',
			''28557057'',
			''28558572'',
			''28564955'',
			''28557426'',
			''28556379'',
			''28564838'',
			''28573957'',
			''28573840'',
			''28573606'',
			''28573588'',
			''28573471'',
			''28573723''
						)
		AND USU.USU_USERNAME not in (''rdura'') 
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
		ON USU.USU_USERNAME = ''rdura'' 
	) TMP
	ON (GEE.GEE_ID = TMP.GEE_ID)
	WHEN MATCHED THEN UPDATE SET
	GEE.USU_ID = TMP.USU_ID,
	GEE.USUARIOMODIFICAR = ''HREOS-2022-8'',
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
    (SELECT USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS WHERE USU_USERNAME =  ''rdura'' ) AS USU_ID 
    FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMP
    LEFT JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
      ON GAH.ACT_ID = TMP.ACT_ID
    LEFT JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC
      ON GAC.ACT_ID = TMP.ACT_ID
    LEFT JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
      ON GEE.GEE_ID = GAC.GEE_ID
    WHERE GAH.ACT_ID IS NOT NULL
    AND GEE.USUARIOMODIFICAR = ''HREOS-2022-8''
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
	GEH.USUARIOMODIFICAR = ''HREOS-2022-8'',
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
	(SELECT USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS WHERE USU_USERNAME = ''rdura'' ) AS USU_ID, 
	DD_TGE_ID,
	SYSDATE AS GEH_FECHA_DESDE,
	''HREOS-2022-8'' AS USUARIOCREAR,
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

--      HREOS-2022-8:No asignar gestores a las tareas afectadas  	
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
--	AND GEE.USUARIOMODIFICAR = ''HREOS-2022-8''
--	) TMP
--	ON (TAC.TAR_ID = TMP.TAR_ID)
--	WHEN MATCHED THEN UPDATE SET
--	TAC.USU_ID = TMP.USU_ID_NEW,
--	TAC.USUARIOMODIFICAR = ''HREOS-2022-8'',
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

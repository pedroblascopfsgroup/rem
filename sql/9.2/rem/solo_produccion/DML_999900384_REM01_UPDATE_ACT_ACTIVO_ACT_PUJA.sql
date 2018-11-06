--/*
--##########################################
--## AUTOR=PIER GOTTA 
--## FECHA_CREACION=20181030
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2410
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar el ACT_PUJA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_ACTIVO';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2410';
    
    ACT_NUM_ACTIVO NUMBER(16);
    ACT_RECOVERY_ID_MALO NUMBER(16);
    ACT_RECOVERY_ID_BUENO NUMBER(16);
    
    TYPE T_JBV IS TABLE OF VARCHAR2(4000);
 	TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

 	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV(6745674),
		T_JBV(6745670),
		T_JBV(101479),
		T_JBV(89497),
		T_JBV(6791701),
		T_JBV(6791702),
		T_JBV(6791703),
		T_JBV(6791699),
		T_JBV(6791704),
		T_JBV(6791707),
		T_JBV(6791705),
		T_JBV(150481),
		T_JBV(150482),
		T_JBV(153402),
		T_JBV(151099),
		T_JBV(6756919),
		T_JBV(6756918),
		T_JBV(6756914),
		T_JBV(6756913),
		T_JBV(6756917),
		T_JBV(6520523),
		T_JBV(6800990),
		T_JBV(6800991),
		T_JBV(6800992),
		T_JBV(6800993),
		T_JBV(6800994),
		T_JBV(6800995),
		T_JBV(122717),
		T_JBV(173353),
		T_JBV(91903),
		T_JBV(85534),
		T_JBV(83561),
		T_JBV(87387),
		T_JBV(92192),
		T_JBV(85690),
		T_JBV(87028),
		T_JBV(86028),
		T_JBV(85535),
		T_JBV(85536),
		T_JBV(87388),
		T_JBV(91756),
		T_JBV(82808),
		T_JBV(85537),
		T_JBV(85691),
		T_JBV(91757),
		T_JBV(85692),
		T_JBV(86840),
		T_JBV(91904),
		T_JBV(85917),
		T_JBV(82809),
		T_JBV(83562),
		T_JBV(83197),
		T_JBV(83414),
		T_JBV(87620),
		T_JBV(86030),
		T_JBV(82810),
		T_JBV(83198),
		T_JBV(85693),
		T_JBV(86841),
		T_JBV(83199),
		T_JBV(85918),
		T_JBV(92549),
		T_JBV(85919),
		T_JBV(87389),
		T_JBV(92406),
		T_JBV(87390),
		T_JBV(85920),
		T_JBV(85538),
		T_JBV(86029),
		T_JBV(83200),
		T_JBV(85694),
		T_JBV(83415),
		T_JBV(83563),
		T_JBV(85539),
		T_JBV(87391),
		T_JBV(82811),
		T_JBV(87392),
		T_JBV(85921),
		T_JBV(85695),
		T_JBV(85696),
		T_JBV(92550),
		T_JBV(86027),
		T_JBV(92407),
		T_JBV(6756915),
		T_JBV(126049),
		T_JBV(125892),
		T_JBV(130355),
		T_JBV(124395),
		T_JBV(107558),
		T_JBV(124396),
		T_JBV(122954),
		T_JBV(124397),
		T_JBV(124175),
		T_JBV(120829),
		T_JBV(120830),
		T_JBV(6809686),
		T_JBV(951543),
		T_JBV(202647),
		T_JBV(62926),
		T_JBV(171192),
		T_JBV(167146),
		T_JBV(171388),
		T_JBV(62821),
		T_JBV(144372),
		T_JBV(179274),
		T_JBV(175341),
		T_JBV(120930),
		T_JBV(119679),
		T_JBV(119943),
		T_JBV(184277),
		T_JBV(184363),
		T_JBV(177589),
		T_JBV(184549),
		T_JBV(177143),
		T_JBV(187541),
		T_JBV(6705536),
		T_JBV(6705523),
		T_JBV(6791709),
		T_JBV(6791708),
		T_JBV(69186),
		T_JBV(164483),
		T_JBV(170934),
		T_JBV(136989),
		T_JBV(168393),
		T_JBV(78733),
		T_JBV(5878550),
		T_JBV(5878548),
		T_JBV(6705361),
		T_JBV(6705414),
		T_JBV(6705401),
		T_JBV(6705402),
		T_JBV(6705403),
		T_JBV(6705404),
		T_JBV(6705406),
		T_JBV(6705405),
		T_JBV(6705409),
		T_JBV(6705395),
		T_JBV(6705394),
		T_JBV(6705396),
		T_JBV(6705398),
		T_JBV(6705360),
		T_JBV(6705379),
		T_JBV(6705381),
		T_JBV(6705380),
		T_JBV(6705383),
		T_JBV(6705382),
		T_JBV(6705384),
		T_JBV(6705373),
		T_JBV(6705372),
		T_JBV(6705376),
		T_JBV(6705374),
		T_JBV(6705375),
		T_JBV(6705378),
		T_JBV(6705377),
		T_JBV(6705365),
		T_JBV(6705364),
		T_JBV(6705368),
		T_JBV(6705367),
		T_JBV(6705370),
		T_JBV(6705369),
		T_JBV(6705359),
		T_JBV(6705292),
		T_JBV(6705279),
		T_JBV(6705389),
		T_JBV(6815915),
		T_JBV(6815913),
		T_JBV(6815914),
		T_JBV(160821),
		T_JBV(6705332),
		T_JBV(6705335),
		T_JBV(6705336),
		T_JBV(6705337),
		T_JBV(6705320),
		T_JBV(6705341),
		T_JBV(6705307),
		T_JBV(6705311),
		T_JBV(6705343),
		T_JBV(6705309),
		T_JBV(6705319),
		T_JBV(6705313),
		T_JBV(6705322),
		T_JBV(6705301),
		T_JBV(6705326),
		T_JBV(6705324),
		T_JBV(6705299),
		T_JBV(6705303),
		T_JBV(6705328),
		T_JBV(6705302),
		T_JBV(6705316),
		T_JBV(6705305),
		T_JBV(6705314),
		T_JBV(6705329),
		T_JBV(6705293),
		T_JBV(6705295),
		T_JBV(6705318),
		T_JBV(6705294),
		T_JBV(6705317),
		T_JBV(6705287),
		T_JBV(154968),
		T_JBV(112480),
		T_JBV(204600),
		T_JBV(204434),
		T_JBV(204435),
		T_JBV(204480),
		T_JBV(204061),
		T_JBV(204481),
		T_JBV(204437),
		T_JBV(204059),
		T_JBV(204060),
		T_JBV(204062),
		T_JBV(204438),
		T_JBV(204601),
		T_JBV(204436),
		T_JBV(204595),
		T_JBV(204056),
		T_JBV(204429),
		T_JBV(204596),
		T_JBV(204428),
		T_JBV(204473),
		T_JBV(204474),
		T_JBV(204475),
		T_JBV(204054),
		T_JBV(204055),
		T_JBV(204597),
		T_JBV(204598),
		T_JBV(204431),
		T_JBV(204432),
		T_JBV(204477),
		T_JBV(204057),
		T_JBV(204478),
		T_JBV(204058),
		T_JBV(204476),
		T_JBV(204430),
		T_JBV(204599),
		T_JBV(204433),
		T_JBV(174556),
		T_JBV(180021),
		T_JBV(180022),
		T_JBV(188660),
		T_JBV(189042),
		T_JBV(186905),
		T_JBV(184932),
		T_JBV(184992),
		T_JBV(186564),
		T_JBV(194727),
		T_JBV(188661),
		T_JBV(184933),
		T_JBV(186906),
		T_JBV(186505),
		T_JBV(185453),
		T_JBV(186698),
		T_JBV(189043),
		T_JBV(194330),
		T_JBV(186506),
		T_JBV(184934),
		T_JBV(194145),
		T_JBV(185454),
		T_JBV(184935),
		T_JBV(184993),
		T_JBV(184936),
		T_JBV(184937),
		T_JBV(188928),
		T_JBV(186507),
		T_JBV(193997),
		T_JBV(186907),
		T_JBV(186908),
		T_JBV(193998),
		T_JBV(185353),
		T_JBV(186729),
		T_JBV(194387),
		T_JBV(186909),
		T_JBV(189263),
		T_JBV(189044),
		T_JBV(194331),
		T_JBV(188662),
		T_JBV(185455),
		T_JBV(188929),
		T_JBV(194389),
		T_JBV(186910),
		T_JBV(186730),
		T_JBV(194146),
		T_JBV(82445),
		T_JBV(6767814),
		T_JBV(134590),
		T_JBV(147088),
		T_JBV(202563),
		T_JBV(67530),
		T_JBV(81478),
		T_JBV(118076),
		T_JBV(105738),
		T_JBV(120051),
		T_JBV(153950),
		T_JBV(101848),
		T_JBV(102198),
		T_JBV(102555),
		T_JBV(141591),
		T_JBV(120010),
		T_JBV(120511),
		T_JBV(136733),
		T_JBV(138525),
		T_JBV(6045028),
		T_JBV(6044663),
		T_JBV(6044768),
		T_JBV(6045014),
		T_JBV(6044771),
		T_JBV(6045032),
		T_JBV(6044785),
		T_JBV(6044808),
		T_JBV(6044784),
		T_JBV(6044764),
		T_JBV(6044770),
		T_JBV(6044777),
		T_JBV(6045009),
		T_JBV(6045011),
		T_JBV(6045012),
		T_JBV(6045019),
		T_JBV(6044809),
		T_JBV(6044661),
		T_JBV(6044811),
		T_JBV(6044817),
		T_JBV(6045013),
		T_JBV(6044814),
		T_JBV(6045030),
		T_JBV(6045016),
		T_JBV(6044782),
		T_JBV(6044774),
		T_JBV(6045015),
		T_JBV(6044786),
		T_JBV(6044772),
		T_JBV(6044806),
		T_JBV(6044804),
		T_JBV(6044767),
		T_JBV(6044766),
		T_JBV(6044765),
		T_JBV(6045017),
		T_JBV(6044780),
		T_JBV(6045026),
		T_JBV(6045024),
		T_JBV(6044779),
		T_JBV(6044810),
		T_JBV(6044813),
		T_JBV(6044659),
		T_JBV(6044660),
		T_JBV(6045031),
		T_JBV(6044763),
		T_JBV(6044807),
		T_JBV(6045021),
		T_JBV(6044762),
		T_JBV(6044805),
		T_JBV(6044812),
		T_JBV(6044816),
		T_JBV(6044783),
		T_JBV(6045020),
		T_JBV(6045033),
		T_JBV(6044815),
		T_JBV(6044781),
		T_JBV(6045027),
		T_JBV(6045029),
		T_JBV(6044662),
		T_JBV(6044778),
		T_JBV(6044775),
		T_JBV(6044773),
		T_JBV(6045022),
		T_JBV(6045023),
		T_JBV(6044769),
		T_JBV(6045018),
		T_JBV(6045010),
		T_JBV(6044776),
		T_JBV(6344362),
		T_JBV(6344361),
		T_JBV(5877499),
		T_JBV(5953051),
		T_JBV(5958880),
		T_JBV(5933850),
		T_JBV(5947252),
		T_JBV(5965332),
		T_JBV(5950148),
		T_JBV(169059),
		T_JBV(71869),
		T_JBV(72447),
		T_JBV(72448),
		T_JBV(175817),
		T_JBV(198304),
		T_JBV(137388),
		T_JBV(64067),
		T_JBV(71890),
		T_JBV(163201),
		T_JBV(162694),
		T_JBV(175838),
		T_JBV(117909),
		T_JBV(100662),
		T_JBV(119015),
		T_JBV(115174),
		T_JBV(942739),
		T_JBV(144517),
		T_JBV(144191),
		T_JBV(144315),
		T_JBV(6130509),
		T_JBV(193615),
		T_JBV(185889),
		T_JBV(194689),
		T_JBV(184359),
		T_JBV(194270),
		T_JBV(110377),
		T_JBV(175424),
		T_JBV(161794),
		T_JBV(69328),
		T_JBV(172634),
		T_JBV(6801022),
		T_JBV(66188),
		T_JBV(176730),
		T_JBV(176011),
		T_JBV(6791710),
		T_JBV(107113),
		T_JBV(6705448),
		T_JBV(6705445),
		T_JBV(98359),
		T_JBV(90060),
		T_JBV(161185),
		T_JBV(171414),
		T_JBV(195113),
		T_JBV(195311),
		T_JBV(188552),
		T_JBV(195003),
		T_JBV(195114),
		T_JBV(195145),
		T_JBV(195146),
		T_JBV(73159),
		T_JBV(74732),
		T_JBV(154545),
		T_JBV(135853),
		T_JBV(152053),
		T_JBV(152055),
		T_JBV(120425),
		T_JBV(105960),
		T_JBV(126010),
		T_JBV(93815),
		T_JBV(181541),
		T_JBV(64768),
		T_JBV(164349),
		T_JBV(176564),
		T_JBV(177067),
		T_JBV(177068),
		T_JBV(135944),
		T_JBV(69472),
		T_JBV(201628),
		T_JBV(173907),
		T_JBV(176278),
		T_JBV(200122),
		T_JBV(162274),
		T_JBV(201544),
		T_JBV(169190),
		T_JBV(132723),
		T_JBV(6128808),
		T_JBV(6128807),
		T_JBV(116671),
		T_JBV(129462),
		T_JBV(118545),
		T_JBV(118070),
		T_JBV(115400),
		T_JBV(115401),
		T_JBV(115828),
		T_JBV(115526),
		T_JBV(105935),
		T_JBV(115612),
		T_JBV(105936),
		T_JBV(115402),
		T_JBV(115527),
		T_JBV(118071),
		T_JBV(105837),
		T_JBV(118286),
		T_JBV(118287),
		T_JBV(115613),
		T_JBV(115528),
		T_JBV(105732),
		T_JBV(115529),
		T_JBV(115829),
		T_JBV(118285),
		T_JBV(6130457),
		T_JBV(6130466),
		T_JBV(6130442),
		T_JBV(6130470),
		T_JBV(6130462),
		T_JBV(6343936),
		T_JBV(6343937),
		T_JBV(6343930),
		T_JBV(6343915),
		T_JBV(6343916),
		T_JBV(6343939),
		T_JBV(6343917),
		T_JBV(6343940),
		T_JBV(6343924),
		T_JBV(6343931),
		T_JBV(6343932),
		T_JBV(6343918),
		T_JBV(6343919),
		T_JBV(6343928),
		T_JBV(6343929),
		T_JBV(6343920),
		T_JBV(6343921),
		T_JBV(6343925),
		T_JBV(6343923),
		T_JBV(6343941),
		T_JBV(6343942),
		T_JBV(6343943),
		T_JBV(6343926),
		T_JBV(6343927),
		T_JBV(6343933),
		T_JBV(6343934),
		T_JBV(6343935),
		T_JBV(6343944),
		T_JBV(100264),
		T_JBV(99759),
		T_JBV(115467),
		T_JBV(100265),
		T_JBV(99839),
		T_JBV(117107),
		T_JBV(99840),
		T_JBV(115496),
		T_JBV(117347),
		T_JBV(99760),
		T_JBV(117108),
		T_JBV(115497),
		T_JBV(100266),
		T_JBV(91294),
		T_JBV(91295),
		T_JBV(92483),
		T_JBV(92863),
		T_JBV(91291),
		T_JBV(92713),
		T_JBV(84137),
		T_JBV(92396),
		T_JBV(90830),
		T_JBV(92840),
		T_JBV(84156),
		T_JBV(92485),
		T_JBV(84707),
		T_JBV(84157),
		T_JBV(92714),
		T_JBV(6767815),
		T_JBV(6767816),
		T_JBV(6767818),
		T_JBV(6767817),
		T_JBV(6767821),
		T_JBV(141589),
		T_JBV(149126),
		T_JBV(149127),
		T_JBV(136730),
		T_JBV(141590),
		T_JBV(137400),
		T_JBV(143940),
		T_JBV(137660),
		T_JBV(137661),
		T_JBV(137404),
		T_JBV(154564),
		T_JBV(131906),
		T_JBV(126407),
		T_JBV(127301),
		T_JBV(105949),
		T_JBV(125949),
		T_JBV(105849),
		T_JBV(125950),
		T_JBV(105666),
		T_JBV(126408),
		T_JBV(105776),
		T_JBV(123593),
		T_JBV(127219),
		T_JBV(126409),
		T_JBV(123594),
		T_JBV(123595),
		T_JBV(121860),
		T_JBV(126410),
		T_JBV(123065),
		T_JBV(125831),
		T_JBV(123297),
		T_JBV(123298),
		T_JBV(123032),
		T_JBV(125832),
		T_JBV(125951),
		T_JBV(105777),
		T_JBV(125833),
		T_JBV(123646),
		T_JBV(125952),
		T_JBV(105950),
		T_JBV(105667),
		T_JBV(105778),
		T_JBV(123066),
		T_JBV(127302),
		T_JBV(125834),
		T_JBV(123033),
		T_JBV(6130439),
		T_JBV(127655),
		T_JBV(105951),
		T_JBV(123067),
		T_JBV(127220),
		T_JBV(123068),
		T_JBV(125953),
		T_JBV(123069),
		T_JBV(125835),
		T_JBV(105850),
		T_JBV(125954),
		T_JBV(125751),
		T_JBV(125836),
		T_JBV(127055),
		T_JBV(6345818),
		T_JBV(158959),
		T_JBV(162666),
		T_JBV(140738),
		T_JBV(158562),
		T_JBV(141361),
		T_JBV(158960),
		T_JBV(158961),
		T_JBV(135902),
		T_JBV(135901),
		T_JBV(158962),
		T_JBV(140740),
		T_JBV(148551),
		T_JBV(158792),
		T_JBV(141094),
		T_JBV(148552),
		T_JBV(148181),
		T_JBV(140893),
		T_JBV(140894),
		T_JBV(140741),
		T_JBV(148553),
		T_JBV(140895),
		T_JBV(140742),
		T_JBV(6345819),
		T_JBV(174671),
		T_JBV(69408),
		T_JBV(69086),
		T_JBV(160988),
		T_JBV(174553),
		T_JBV(179822),
		T_JBV(160989),
		T_JBV(152798),
		T_JBV(204470),
		T_JBV(204592),
		T_JBV(204582),
		T_JBV(204471),
		T_JBV(938249),
		T_JBV(933941),
		T_JBV(935870),
		T_JBV(938476),
		T_JBV(937987),
		T_JBV(945119),
		T_JBV(944278),
		T_JBV(203976),
		T_JBV(938797),
		T_JBV(203978),
		T_JBV(944444),
		T_JBV(203980),
		T_JBV(203981),
		T_JBV(203275),
		T_JBV(203276),
		T_JBV(203277),
		T_JBV(939303),
		T_JBV(203279),
		T_JBV(202814),
		T_JBV(204554),
		T_JBV(204555),
		T_JBV(204556),
		T_JBV(204557),
		T_JBV(940592),
		T_JBV(935817),
		T_JBV(204576),
		T_JBV(204336),
		T_JBV(943483),
		T_JBV(938523),
		T_JBV(202801),
		T_JBV(204571),
		T_JBV(204572),
		T_JBV(935105),
		T_JBV(934547),
		T_JBV(202802),
		T_JBV(204574),
		T_JBV(934503),
		T_JBV(204339),
		T_JBV(204575),
		T_JBV(140115),
		T_JBV(97398),
		T_JBV(102323),
		T_JBV(97860),
		T_JBV(98016),
		T_JBV(89478),
		T_JBV(98344),
		T_JBV(97861),
		T_JBV(97862),
		T_JBV(89479),
		T_JBV(98017),
		T_JBV(97399),
		T_JBV(97863),
		T_JBV(102743),
		T_JBV(102684),
		T_JBV(102744),
		T_JBV(89652),
		T_JBV(98760),
		T_JBV(98190),
		T_JBV(102685),
		T_JBV(98018)
	 	);   
    V_TMP_JBV T_JBV;
    
    
 BEGIN
 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
    V_TMP_JBV := V_JBV(I);
    
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
		 			  ACT_PUJA  		 = 1
		 			, USUARIOMODIFICAR 	 = '''||V_USUARIO||'''
		 			, FECHAMODIFICAR         = SYSDATE
					WHERE ACT_NUM_ACTIVO 	 = '||V_TMP_JBV(1)||'
				  ';
	
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] Se ha cambiado el activo '||ACT_NUM_ACTIVO||' su ACT_RECOVERY_ID_BUENO por '||ACT_RECOVERY_ID_BUENO);
  
  V_COUNT_INSERT := V_COUNT_INSERT + 1;
  
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('[INFO] Se han cambiado en total '||V_COUNT_INSERT||' registros en la tabla '||V_TABLA);
  
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

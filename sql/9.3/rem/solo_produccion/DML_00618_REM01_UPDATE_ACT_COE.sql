--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8680
--## PRODUCTO=NO
--## 
--## Finalidad: Eliminar condiciones específicas
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-8680'; -- USUARIOCREAR/USUARIOMODIFICAR.

    V_COUNT_TOTAL NUMBER(16):=0; --Vble para contar registros totales
    V_COUNT_TOTAL_FALLOS NUMBER(16):=0; --Vble para contar registros totales
    --TOTAL EN EL ARRAY: 859
    V_TEXTO VARCHAR2(300 CHAR):= 'El Inmueble se encuentra gravado con una carga, la cual se encuentra pendiente de cancelación. Consultar su situación actual, así como, sus posibles limitaciones y la asunción de su cancelación';


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA(6052508),            T_TIPO_DATA(6052818),            T_TIPO_DATA(6053265),
            T_TIPO_DATA(6053304),            T_TIPO_DATA(6053449),            T_TIPO_DATA(6053653),
            T_TIPO_DATA(6053785),            T_TIPO_DATA(6053870),            T_TIPO_DATA(6053906),
            T_TIPO_DATA(6055587),            T_TIPO_DATA(6055625),            T_TIPO_DATA(6057822),
            T_TIPO_DATA(6061337),            T_TIPO_DATA(6889861),            T_TIPO_DATA(6943742),
            T_TIPO_DATA(6983502),            T_TIPO_DATA(6985396),            T_TIPO_DATA(7072556),
            T_TIPO_DATA(7072963),            T_TIPO_DATA(7073179),            T_TIPO_DATA(7073182),
            T_TIPO_DATA(7073231),            T_TIPO_DATA(7073237),            T_TIPO_DATA(7073246),
            T_TIPO_DATA(7074292),            T_TIPO_DATA(7074347),            T_TIPO_DATA(7074454),
            T_TIPO_DATA(7074564),            T_TIPO_DATA(7074566),            T_TIPO_DATA(7074567),
            T_TIPO_DATA(7074592),            T_TIPO_DATA(7074593),            T_TIPO_DATA(7074620),
            T_TIPO_DATA(7074623),            T_TIPO_DATA(7074673),            T_TIPO_DATA(7074675),
            T_TIPO_DATA(7074678),            T_TIPO_DATA(7074679),            T_TIPO_DATA(7074682),
            T_TIPO_DATA(7074792),            T_TIPO_DATA(7074795),            T_TIPO_DATA(7074796),
            T_TIPO_DATA(7075090),            T_TIPO_DATA(7075094),            T_TIPO_DATA(7075111),
            T_TIPO_DATA(7075113),            T_TIPO_DATA(7075126),            T_TIPO_DATA(7075188),
            T_TIPO_DATA(7075218),            T_TIPO_DATA(7075223),            T_TIPO_DATA(7075224),
            T_TIPO_DATA(7075225),            T_TIPO_DATA(7075228),            T_TIPO_DATA(7075278),
            T_TIPO_DATA(7075296),            T_TIPO_DATA(7075313),            T_TIPO_DATA(7075344),
            T_TIPO_DATA(7075349),            T_TIPO_DATA(7075376),            T_TIPO_DATA(7075377),
            T_TIPO_DATA(7075466),            T_TIPO_DATA(7075491),            T_TIPO_DATA(7075493),
            T_TIPO_DATA(7075496),            T_TIPO_DATA(7075533),            T_TIPO_DATA(7075538),
            T_TIPO_DATA(7075633),            T_TIPO_DATA(7075747),            T_TIPO_DATA(7075776),
            T_TIPO_DATA(7075781),            T_TIPO_DATA(7075820),            T_TIPO_DATA(7075821),
            T_TIPO_DATA(7075936),            T_TIPO_DATA(7075985),            T_TIPO_DATA(7075986),
            T_TIPO_DATA(7075987),            T_TIPO_DATA(7075989),            T_TIPO_DATA(7076050),
            T_TIPO_DATA(7076061),            T_TIPO_DATA(7076077),            T_TIPO_DATA(7076078),
            T_TIPO_DATA(7076081),            T_TIPO_DATA(7076151),            T_TIPO_DATA(7076154),
            T_TIPO_DATA(7076155),            T_TIPO_DATA(7076198),            T_TIPO_DATA(7076199),
            T_TIPO_DATA(7076202),            T_TIPO_DATA(7076204),            T_TIPO_DATA(7076205),
            T_TIPO_DATA(7076207),            T_TIPO_DATA(7076209),            T_TIPO_DATA(7076210),
            T_TIPO_DATA(7076211),            T_TIPO_DATA(7076213),            T_TIPO_DATA(7076245),
            T_TIPO_DATA(7076247),            T_TIPO_DATA(7085368),            T_TIPO_DATA(7088775),
            T_TIPO_DATA(7088779),            T_TIPO_DATA(7088788),            T_TIPO_DATA(7089045),
            T_TIPO_DATA(7089061),            T_TIPO_DATA(7089063),            T_TIPO_DATA(7089074),
            T_TIPO_DATA(7089261),            T_TIPO_DATA(7089274),            T_TIPO_DATA(7089278),
            T_TIPO_DATA(7089283),            T_TIPO_DATA(7089285),            T_TIPO_DATA(7089288),
            T_TIPO_DATA(7089341),            T_TIPO_DATA(7089345),            T_TIPO_DATA(7089346),
            T_TIPO_DATA(7089351),            T_TIPO_DATA(7089353),            T_TIPO_DATA(7089356),
            T_TIPO_DATA(7089374),            T_TIPO_DATA(7089466),            T_TIPO_DATA(7089469),
            T_TIPO_DATA(7089476),            T_TIPO_DATA(7089510),            T_TIPO_DATA(7089560),
            T_TIPO_DATA(7089562),            T_TIPO_DATA(7089564),            T_TIPO_DATA(7089565),
            T_TIPO_DATA(7089568),            T_TIPO_DATA(7089569),            T_TIPO_DATA(7089571),
            T_TIPO_DATA(7089572),            T_TIPO_DATA(7090281),            T_TIPO_DATA(7090295),
            T_TIPO_DATA(7090430),            T_TIPO_DATA(7090489),            T_TIPO_DATA(7090509),
            T_TIPO_DATA(7090517),            T_TIPO_DATA(7090519),            T_TIPO_DATA(7090524),
            T_TIPO_DATA(7090534),            T_TIPO_DATA(7090535),            T_TIPO_DATA(7090552),
            T_TIPO_DATA(7090566),            T_TIPO_DATA(7090568),            T_TIPO_DATA(7090580),
            T_TIPO_DATA(7091179),            T_TIPO_DATA(7091302),            T_TIPO_DATA(7091413),
            T_TIPO_DATA(7091471),            T_TIPO_DATA(7091484),            T_TIPO_DATA(7091511),
            T_TIPO_DATA(7091535),            T_TIPO_DATA(7091545),            T_TIPO_DATA(7091547),
            T_TIPO_DATA(7092343),            T_TIPO_DATA(7092357),            T_TIPO_DATA(7092361),
            T_TIPO_DATA(7092369),            T_TIPO_DATA(7092370),            T_TIPO_DATA(7092383),
            T_TIPO_DATA(7092469),            T_TIPO_DATA(7092505),            T_TIPO_DATA(7092513),
            T_TIPO_DATA(7092531),            T_TIPO_DATA(7092545),            T_TIPO_DATA(7092592),
            T_TIPO_DATA(7092594),            T_TIPO_DATA(7093357),            T_TIPO_DATA(7093488),
            T_TIPO_DATA(7093497),            T_TIPO_DATA(7093936),            T_TIPO_DATA(7093948),
            T_TIPO_DATA(7094259),            T_TIPO_DATA(7094323),            T_TIPO_DATA(7094381),
            T_TIPO_DATA(7094463),            T_TIPO_DATA(7094476),            T_TIPO_DATA(7094509),
            T_TIPO_DATA(7094528),            T_TIPO_DATA(7094529),            T_TIPO_DATA(7094537),
            T_TIPO_DATA(7094541),            T_TIPO_DATA(7094546),            T_TIPO_DATA(7094567),
            T_TIPO_DATA(7094568),            T_TIPO_DATA(7094573),            T_TIPO_DATA(7095376),
            T_TIPO_DATA(7095470),            T_TIPO_DATA(7095568),            T_TIPO_DATA(7096197),
            T_TIPO_DATA(7096245),            T_TIPO_DATA(7096322),            T_TIPO_DATA(7096331),
            T_TIPO_DATA(7096350),            T_TIPO_DATA(7096383),            T_TIPO_DATA(7096443),
            T_TIPO_DATA(7096453),            T_TIPO_DATA(7096460),            T_TIPO_DATA(7096477),
            T_TIPO_DATA(7096488),            T_TIPO_DATA(7096503),            T_TIPO_DATA(7096537),
            T_TIPO_DATA(7096550),            T_TIPO_DATA(7096562),            T_TIPO_DATA(7096564),
            T_TIPO_DATA(7096565),            T_TIPO_DATA(7097116),            T_TIPO_DATA(7097453),
            T_TIPO_DATA(7097466),            T_TIPO_DATA(7097472),            T_TIPO_DATA(7097511),
            T_TIPO_DATA(7097512),            T_TIPO_DATA(7097513),            T_TIPO_DATA(7097527),
            T_TIPO_DATA(7097528),            T_TIPO_DATA(7097530),            T_TIPO_DATA(7097538),
            T_TIPO_DATA(7097555),            T_TIPO_DATA(7097943),            T_TIPO_DATA(7098218),
            T_TIPO_DATA(7098322),            T_TIPO_DATA(7098379),            T_TIPO_DATA(7098399),
            T_TIPO_DATA(7098410),            T_TIPO_DATA(7098425),            T_TIPO_DATA(7098441),
            T_TIPO_DATA(7098452),            T_TIPO_DATA(7098488),            T_TIPO_DATA(7098502),
            T_TIPO_DATA(7098507),            T_TIPO_DATA(7098519),            T_TIPO_DATA(7098552),
            T_TIPO_DATA(7098926),            T_TIPO_DATA(7099147),            T_TIPO_DATA(7099192),
            T_TIPO_DATA(7099222),            T_TIPO_DATA(7099238),            T_TIPO_DATA(7099248),
            T_TIPO_DATA(7099272),            T_TIPO_DATA(7099299),            T_TIPO_DATA(7099301),
            T_TIPO_DATA(7099302),            T_TIPO_DATA(7099336),            T_TIPO_DATA(7099346),
            T_TIPO_DATA(7099363),            T_TIPO_DATA(7099371),            T_TIPO_DATA(7099377),
            T_TIPO_DATA(7099381),            T_TIPO_DATA(7099397),            T_TIPO_DATA(7099404),
            T_TIPO_DATA(7099420),            T_TIPO_DATA(7099433),            T_TIPO_DATA(7099435),
            T_TIPO_DATA(7099444),            T_TIPO_DATA(7099451),            T_TIPO_DATA(7099461),
            T_TIPO_DATA(7099462),            T_TIPO_DATA(7099467),            T_TIPO_DATA(7099468),
            T_TIPO_DATA(7099469),            T_TIPO_DATA(7099471),            T_TIPO_DATA(7099473),
            T_TIPO_DATA(7099488),            T_TIPO_DATA(7099490),            T_TIPO_DATA(7099492),
            T_TIPO_DATA(7099495),            T_TIPO_DATA(7099518),            T_TIPO_DATA(7099524),
            T_TIPO_DATA(7099526),            T_TIPO_DATA(7099531),            T_TIPO_DATA(7099535),
            T_TIPO_DATA(7099543),            T_TIPO_DATA(7099544),            T_TIPO_DATA(7099547),
            T_TIPO_DATA(7099595),            T_TIPO_DATA(7099597),            T_TIPO_DATA(7099598),
            T_TIPO_DATA(7099605),            T_TIPO_DATA(7099641),            T_TIPO_DATA(7099655),
            T_TIPO_DATA(7099674),            T_TIPO_DATA(7099675),            T_TIPO_DATA(7099683),
            T_TIPO_DATA(7099685),            T_TIPO_DATA(7099689),            T_TIPO_DATA(7099695),
            T_TIPO_DATA(7099696),            T_TIPO_DATA(7099717),            T_TIPO_DATA(7099726),
            T_TIPO_DATA(7099738),            T_TIPO_DATA(7099739),            T_TIPO_DATA(7099755),
            T_TIPO_DATA(7099763),            T_TIPO_DATA(7099764),            T_TIPO_DATA(7099778),
            T_TIPO_DATA(7099790),            T_TIPO_DATA(7099804),            T_TIPO_DATA(7099806),
            T_TIPO_DATA(7099807),            T_TIPO_DATA(7099811),            T_TIPO_DATA(7099816),
            T_TIPO_DATA(7099824),            T_TIPO_DATA(7099857),            T_TIPO_DATA(7099868),
            T_TIPO_DATA(7099885),            T_TIPO_DATA(7099892),            T_TIPO_DATA(7099912),
            T_TIPO_DATA(7099914),            T_TIPO_DATA(7099927),            T_TIPO_DATA(7099936),
            T_TIPO_DATA(7099941),            T_TIPO_DATA(7099948),            T_TIPO_DATA(7099951),
            T_TIPO_DATA(7099954),            T_TIPO_DATA(7099956),            T_TIPO_DATA(7099957),
            T_TIPO_DATA(7099958),            T_TIPO_DATA(7099960),            T_TIPO_DATA(7099961),
            T_TIPO_DATA(7099963),            T_TIPO_DATA(7099965),            T_TIPO_DATA(7099966),
            T_TIPO_DATA(7099968),            T_TIPO_DATA(7099969),            T_TIPO_DATA(7099970),
            T_TIPO_DATA(7099971),            T_TIPO_DATA(7099972),            T_TIPO_DATA(7099976),
            T_TIPO_DATA(7099977),            T_TIPO_DATA(7099981),            T_TIPO_DATA(7099982),
            T_TIPO_DATA(7099989),            T_TIPO_DATA(7099990),            T_TIPO_DATA(7099992),
            T_TIPO_DATA(7099993),            T_TIPO_DATA(7099996),            T_TIPO_DATA(7099997),
            T_TIPO_DATA(7100006),            T_TIPO_DATA(7100009),            T_TIPO_DATA(7100017),
            T_TIPO_DATA(7100019),            T_TIPO_DATA(7100020),            T_TIPO_DATA(7100022),
            T_TIPO_DATA(7100026),            T_TIPO_DATA(7100029),            T_TIPO_DATA(7100030),
            T_TIPO_DATA(7100031),            T_TIPO_DATA(7100033),            T_TIPO_DATA(7100037),
            T_TIPO_DATA(7100046),            T_TIPO_DATA(7100051),            T_TIPO_DATA(7100053),
            T_TIPO_DATA(7100057),            T_TIPO_DATA(7100058),            T_TIPO_DATA(7100059),
            T_TIPO_DATA(7100061),            T_TIPO_DATA(7100111),            T_TIPO_DATA(7100120),
            T_TIPO_DATA(7100123),            T_TIPO_DATA(7100124),            T_TIPO_DATA(7100177),
            T_TIPO_DATA(7100195),            T_TIPO_DATA(7100202),            T_TIPO_DATA(7101256),
            T_TIPO_DATA(7101257),            T_TIPO_DATA(7101258),            T_TIPO_DATA(7101259),
            T_TIPO_DATA(7101261),            T_TIPO_DATA(7101274),            T_TIPO_DATA(7101281),
            T_TIPO_DATA(7101285),            T_TIPO_DATA(7101288),            T_TIPO_DATA(7101297),
            T_TIPO_DATA(7101301),            T_TIPO_DATA(7101313),            T_TIPO_DATA(7101324),
            T_TIPO_DATA(7101339),            T_TIPO_DATA(7101352),            T_TIPO_DATA(7101367),
            T_TIPO_DATA(7101377),            T_TIPO_DATA(7101378),            T_TIPO_DATA(7101383),
            T_TIPO_DATA(7101386),            T_TIPO_DATA(7101387),            T_TIPO_DATA(7101397),
            T_TIPO_DATA(7101398),            T_TIPO_DATA(7101402),            T_TIPO_DATA(7101417),
            T_TIPO_DATA(7101426),            T_TIPO_DATA(7101433),            T_TIPO_DATA(7101439),
            T_TIPO_DATA(7101447),            T_TIPO_DATA(7101450),            T_TIPO_DATA(7101455),
            T_TIPO_DATA(7101465),            T_TIPO_DATA(7101475),            T_TIPO_DATA(7101480),
            T_TIPO_DATA(7101486),            T_TIPO_DATA(7101488),            T_TIPO_DATA(7101489),
            T_TIPO_DATA(7101491),            T_TIPO_DATA(7101493),            T_TIPO_DATA(7101497),
            T_TIPO_DATA(7101514),            T_TIPO_DATA(7101519),            T_TIPO_DATA(7101525),
            T_TIPO_DATA(7101526),            T_TIPO_DATA(7101527),            T_TIPO_DATA(7101531),
            T_TIPO_DATA(7101535),            T_TIPO_DATA(7101542),            T_TIPO_DATA(7101545),
            T_TIPO_DATA(7101550),            T_TIPO_DATA(7101562),            T_TIPO_DATA(7101573),
            T_TIPO_DATA(7101576),            T_TIPO_DATA(7101580),            T_TIPO_DATA(7101597),
            T_TIPO_DATA(7101615),            T_TIPO_DATA(7101616),            T_TIPO_DATA(7101636),
            T_TIPO_DATA(7101645),            T_TIPO_DATA(7101647),            T_TIPO_DATA(7101648),
            T_TIPO_DATA(7101649),            T_TIPO_DATA(7101650),            T_TIPO_DATA(7101651),
            T_TIPO_DATA(7101653),            T_TIPO_DATA(7101654),            T_TIPO_DATA(7101764),
            T_TIPO_DATA(7101765),            T_TIPO_DATA(7101766),            T_TIPO_DATA(7101773),
            T_TIPO_DATA(7101775),            T_TIPO_DATA(7224412),            T_TIPO_DATA(7225483),
            T_TIPO_DATA(7225517),            T_TIPO_DATA(7225520),            T_TIPO_DATA(7225568),
            T_TIPO_DATA(7225822),            T_TIPO_DATA(7225838),            T_TIPO_DATA(7225975),
            T_TIPO_DATA(7225976),            T_TIPO_DATA(7225977),            T_TIPO_DATA(7225978),
            T_TIPO_DATA(7225980),            T_TIPO_DATA(7226025),            T_TIPO_DATA(7226028),
            T_TIPO_DATA(7226031),            T_TIPO_DATA(7226034),            T_TIPO_DATA(7226036),
            T_TIPO_DATA(7226038),            T_TIPO_DATA(7226039),            T_TIPO_DATA(7226046),
            T_TIPO_DATA(7226157),            T_TIPO_DATA(7226158),            T_TIPO_DATA(7226475),
            T_TIPO_DATA(7226478),            T_TIPO_DATA(7226479),            T_TIPO_DATA(7226493),
            T_TIPO_DATA(7226575),            T_TIPO_DATA(7226577),            T_TIPO_DATA(7226578),
            T_TIPO_DATA(7226619),            T_TIPO_DATA(7226621),            T_TIPO_DATA(7226625),
            T_TIPO_DATA(7226640),            T_TIPO_DATA(7226780),            T_TIPO_DATA(7226781),
            T_TIPO_DATA(7226782),            T_TIPO_DATA(7226783),            T_TIPO_DATA(7226788),
            T_TIPO_DATA(7226798),            T_TIPO_DATA(7226804),            T_TIPO_DATA(7226807),
            T_TIPO_DATA(7226808),            T_TIPO_DATA(7226825),            T_TIPO_DATA(7226828),
            T_TIPO_DATA(7226830),            T_TIPO_DATA(7226861),            T_TIPO_DATA(7226879),
            T_TIPO_DATA(7226880),            T_TIPO_DATA(7226883),            T_TIPO_DATA(7226899),
            T_TIPO_DATA(7226900),            T_TIPO_DATA(7226902),            T_TIPO_DATA(7226906),
            T_TIPO_DATA(7226907),            T_TIPO_DATA(7226909),            T_TIPO_DATA(7226910),
            T_TIPO_DATA(7226911),            T_TIPO_DATA(7226912),            T_TIPO_DATA(7226913),
            T_TIPO_DATA(7226915),            T_TIPO_DATA(7226916),            T_TIPO_DATA(7226917),
            T_TIPO_DATA(7226918),            T_TIPO_DATA(7226919),            T_TIPO_DATA(7226950),
            T_TIPO_DATA(7226953),            T_TIPO_DATA(7226954),            T_TIPO_DATA(7226956),
            T_TIPO_DATA(7226960),            T_TIPO_DATA(7226962),            T_TIPO_DATA(7226963),
            T_TIPO_DATA(7226965),            T_TIPO_DATA(7226966),            T_TIPO_DATA(7226970),
            T_TIPO_DATA(7226971),            T_TIPO_DATA(7226974),            T_TIPO_DATA(7226975),
            T_TIPO_DATA(7226977),            T_TIPO_DATA(7226979),            T_TIPO_DATA(7226980),
            T_TIPO_DATA(7226981),            T_TIPO_DATA(7226982),            T_TIPO_DATA(7226984),
            T_TIPO_DATA(7226985),            T_TIPO_DATA(7226986),            T_TIPO_DATA(7227004),
            T_TIPO_DATA(7227139),            T_TIPO_DATA(7228149),            T_TIPO_DATA(7228625),
            T_TIPO_DATA(7228626),            T_TIPO_DATA(7228674),            T_TIPO_DATA(7228830),
            T_TIPO_DATA(7228966),            T_TIPO_DATA(7228969),            T_TIPO_DATA(7228970),
            T_TIPO_DATA(7228971),            T_TIPO_DATA(7229260),            T_TIPO_DATA(7229285),
            T_TIPO_DATA(7229303),            T_TIPO_DATA(7229304),            T_TIPO_DATA(7229305),
            T_TIPO_DATA(7229306),            T_TIPO_DATA(7229308),            T_TIPO_DATA(7229352),
            T_TIPO_DATA(7229418),            T_TIPO_DATA(7229420),            T_TIPO_DATA(7229644),
            T_TIPO_DATA(7229645),            T_TIPO_DATA(7229647),            T_TIPO_DATA(7229648),
            T_TIPO_DATA(7229652),            T_TIPO_DATA(7229656),            T_TIPO_DATA(7229679),
            T_TIPO_DATA(7229681),            T_TIPO_DATA(7229683),            T_TIPO_DATA(7230114),
            T_TIPO_DATA(7230115),            T_TIPO_DATA(7230118),            T_TIPO_DATA(7230119),
            T_TIPO_DATA(7288587),            T_TIPO_DATA(7288599),            T_TIPO_DATA(7288602),
            T_TIPO_DATA(7292342),            T_TIPO_DATA(7292369),            T_TIPO_DATA(7292409),
            T_TIPO_DATA(7292410),            T_TIPO_DATA(7292487),            T_TIPO_DATA(7292502),
            T_TIPO_DATA(7292503),            T_TIPO_DATA(7292532),            T_TIPO_DATA(7292533),
            T_TIPO_DATA(7292534),            T_TIPO_DATA(7292535),            T_TIPO_DATA(7292536),
            T_TIPO_DATA(7292652),            T_TIPO_DATA(7292653),            T_TIPO_DATA(7292655),
            T_TIPO_DATA(7292659),            T_TIPO_DATA(7292775),            T_TIPO_DATA(7292822),
            T_TIPO_DATA(7292823),            T_TIPO_DATA(7292852),            T_TIPO_DATA(7292853),
            T_TIPO_DATA(7292855),            T_TIPO_DATA(7292857),            T_TIPO_DATA(7292859),
            T_TIPO_DATA(7292863),            T_TIPO_DATA(7292864),            T_TIPO_DATA(7292866),
            T_TIPO_DATA(7292867),            T_TIPO_DATA(7293110),            T_TIPO_DATA(7293112),
            T_TIPO_DATA(7293113),            T_TIPO_DATA(7293114),            T_TIPO_DATA(7293115),
            T_TIPO_DATA(7293116),            T_TIPO_DATA(7293120),            T_TIPO_DATA(7293121),
            T_TIPO_DATA(7293124),            T_TIPO_DATA(7293128),            T_TIPO_DATA(7293133),
            T_TIPO_DATA(7293135),            T_TIPO_DATA(7293139),            T_TIPO_DATA(7293142),
            T_TIPO_DATA(7293143),            T_TIPO_DATA(7293182),            T_TIPO_DATA(7293189),
            T_TIPO_DATA(7293192),            T_TIPO_DATA(7293262),            T_TIPO_DATA(7293264),
            T_TIPO_DATA(7293265),            T_TIPO_DATA(7293272),            T_TIPO_DATA(7293322),
            T_TIPO_DATA(7293324),            T_TIPO_DATA(7293361),            T_TIPO_DATA(7293362),
            T_TIPO_DATA(7293374),            T_TIPO_DATA(7293375),            T_TIPO_DATA(7293376),
            T_TIPO_DATA(7293410),            T_TIPO_DATA(7293411),            T_TIPO_DATA(7293439),
            T_TIPO_DATA(7293441),            T_TIPO_DATA(7293443),            T_TIPO_DATA(7293444),
            T_TIPO_DATA(7293445),            T_TIPO_DATA(7293755),            T_TIPO_DATA(7293760),
            T_TIPO_DATA(7293762),            T_TIPO_DATA(7293763),            T_TIPO_DATA(7293764),
            T_TIPO_DATA(7293766),            T_TIPO_DATA(7294042),            T_TIPO_DATA(7294044),
            T_TIPO_DATA(7294130),            T_TIPO_DATA(7294133),            T_TIPO_DATA(7294136),
            T_TIPO_DATA(7294137),            T_TIPO_DATA(7294166),            T_TIPO_DATA(7294168),
            T_TIPO_DATA(7294171),            T_TIPO_DATA(7294179),            T_TIPO_DATA(7294180),
            T_TIPO_DATA(7294182),            T_TIPO_DATA(7294183),            T_TIPO_DATA(7294203),
            T_TIPO_DATA(7294274),            T_TIPO_DATA(7294277),            T_TIPO_DATA(7294279),
            T_TIPO_DATA(7294355),            T_TIPO_DATA(7294363),            T_TIPO_DATA(7294364),
            T_TIPO_DATA(7294370),            T_TIPO_DATA(7294371),            T_TIPO_DATA(7294372),
            T_TIPO_DATA(7294376),            T_TIPO_DATA(7294381),            T_TIPO_DATA(7294385),
            T_TIPO_DATA(7294387),            T_TIPO_DATA(7294389),            T_TIPO_DATA(7294390),
            T_TIPO_DATA(7294399),            T_TIPO_DATA(7294407),            T_TIPO_DATA(7294410),
            T_TIPO_DATA(7294418),            T_TIPO_DATA(7294419),            T_TIPO_DATA(7294424),
            T_TIPO_DATA(7294433),            T_TIPO_DATA(7294437),            T_TIPO_DATA(7294507),
            T_TIPO_DATA(7294645),            T_TIPO_DATA(7294670),            T_TIPO_DATA(7294773),
            T_TIPO_DATA(7294799),            T_TIPO_DATA(7294920),            T_TIPO_DATA(7294921),
            T_TIPO_DATA(7294925),            T_TIPO_DATA(7295085),            T_TIPO_DATA(7295088),
            T_TIPO_DATA(7295090),            T_TIPO_DATA(7295104),            T_TIPO_DATA(7295109),
            T_TIPO_DATA(7295110),            T_TIPO_DATA(7295116),            T_TIPO_DATA(7295136),
            T_TIPO_DATA(7295140),            T_TIPO_DATA(7295141),            T_TIPO_DATA(7295143),
            T_TIPO_DATA(7295144),            T_TIPO_DATA(7295443),            T_TIPO_DATA(7295519),
            T_TIPO_DATA(7295521),            T_TIPO_DATA(7295525),            T_TIPO_DATA(7295531),
            T_TIPO_DATA(7295533),            T_TIPO_DATA(7295534),            T_TIPO_DATA(7295545),
            T_TIPO_DATA(7295546),            T_TIPO_DATA(7295549),            T_TIPO_DATA(7295817),
            T_TIPO_DATA(7295854),            T_TIPO_DATA(7295860),            T_TIPO_DATA(7295865),
            T_TIPO_DATA(7295945),            T_TIPO_DATA(7295969),            T_TIPO_DATA(7295975),
            T_TIPO_DATA(7296020),            T_TIPO_DATA(7296066),            T_TIPO_DATA(7296082),
            T_TIPO_DATA(7296094),            T_TIPO_DATA(7296180),            T_TIPO_DATA(7296190),
            T_TIPO_DATA(7296286),            T_TIPO_DATA(7296287),            T_TIPO_DATA(7296295),
            T_TIPO_DATA(7296314),            T_TIPO_DATA(7296318),            T_TIPO_DATA(7296325),
            T_TIPO_DATA(7296336),            T_TIPO_DATA(7296344),            T_TIPO_DATA(7296350),
            T_TIPO_DATA(7296352),            T_TIPO_DATA(7296355),            T_TIPO_DATA(7296362),
            T_TIPO_DATA(7296366),            T_TIPO_DATA(7296374),            T_TIPO_DATA(7296391),
            T_TIPO_DATA(7296405),            T_TIPO_DATA(7296415),            T_TIPO_DATA(7296454),
            T_TIPO_DATA(7296480),            T_TIPO_DATA(7296485),            T_TIPO_DATA(7296488),
            T_TIPO_DATA(7296489),            T_TIPO_DATA(7296491),            T_TIPO_DATA(7296498),
            T_TIPO_DATA(7296499),            T_TIPO_DATA(7296519),            T_TIPO_DATA(7296521),
            T_TIPO_DATA(7296534),            T_TIPO_DATA(7296536),            T_TIPO_DATA(7296538),
            T_TIPO_DATA(7296551),            T_TIPO_DATA(7296556),            T_TIPO_DATA(7296567),
            T_TIPO_DATA(7296835),            T_TIPO_DATA(7296861),            T_TIPO_DATA(7296873),
            T_TIPO_DATA(7296877),            T_TIPO_DATA(7296909),            T_TIPO_DATA(7296920),
            T_TIPO_DATA(7296924),            T_TIPO_DATA(7296930),            T_TIPO_DATA(7296968),
            T_TIPO_DATA(7297028),            T_TIPO_DATA(7297042),            T_TIPO_DATA(7297051),
            T_TIPO_DATA(7297055),            T_TIPO_DATA(7297064),            T_TIPO_DATA(7297075),
            T_TIPO_DATA(7297080),            T_TIPO_DATA(7297088),            T_TIPO_DATA(7297098),
            T_TIPO_DATA(7297136),            T_TIPO_DATA(7297139),            T_TIPO_DATA(7297144),
            T_TIPO_DATA(7297164),            T_TIPO_DATA(7297183),            T_TIPO_DATA(7297284),
            T_TIPO_DATA(7297321),            T_TIPO_DATA(7297376),            T_TIPO_DATA(7297378),
            T_TIPO_DATA(7297379),            T_TIPO_DATA(7297384),            T_TIPO_DATA(7297385),
            T_TIPO_DATA(7297388),            T_TIPO_DATA(7297389),            T_TIPO_DATA(7297390),
            T_TIPO_DATA(7297391),            T_TIPO_DATA(7297768),            T_TIPO_DATA(7298447),
            T_TIPO_DATA(7298455),            T_TIPO_DATA(7298462),            T_TIPO_DATA(7298463),
            T_TIPO_DATA(7298464),            T_TIPO_DATA(7298465),            T_TIPO_DATA(7298466),
            T_TIPO_DATA(7298468),            T_TIPO_DATA(7298469),            T_TIPO_DATA(7298470),
            T_TIPO_DATA(7298471),            T_TIPO_DATA(7298473),            T_TIPO_DATA(7298474),
            T_TIPO_DATA(7298475),            T_TIPO_DATA(7298477),            T_TIPO_DATA(7298479),
            T_TIPO_DATA(7298480),            T_TIPO_DATA(7298481),            T_TIPO_DATA(7298482),
            T_TIPO_DATA(7298484),            T_TIPO_DATA(7298485),            T_TIPO_DATA(7298488),
            T_TIPO_DATA(7298489),            T_TIPO_DATA(7298490),            T_TIPO_DATA(7298491),
            T_TIPO_DATA(7298492),            T_TIPO_DATA(7298493),            T_TIPO_DATA(7298494),
            T_TIPO_DATA(7298495),            T_TIPO_DATA(7298496),            T_TIPO_DATA(7298498),
            T_TIPO_DATA(7298503),            T_TIPO_DATA(7298504),            T_TIPO_DATA(7298505),
            T_TIPO_DATA(7298507),            T_TIPO_DATA(7298508),            T_TIPO_DATA(7298511),
            T_TIPO_DATA(7298513),            T_TIPO_DATA(7298514),            T_TIPO_DATA(7298515),
            T_TIPO_DATA(7298517),            T_TIPO_DATA(7298531),            T_TIPO_DATA(7298536),
            T_TIPO_DATA(7298551),            T_TIPO_DATA(7298553),            T_TIPO_DATA(7298566),
            T_TIPO_DATA(7298568),            T_TIPO_DATA(7298575),            T_TIPO_DATA(7298727),
            T_TIPO_DATA(7298729),            T_TIPO_DATA(7298746),            T_TIPO_DATA(7298750),
            T_TIPO_DATA(7298803),            T_TIPO_DATA(7298814),            T_TIPO_DATA(7298817),
            T_TIPO_DATA(7298834),            T_TIPO_DATA(7298844),            T_TIPO_DATA(7298874),
            T_TIPO_DATA(7298887),            T_TIPO_DATA(7298888),            T_TIPO_DATA(7299334),
            T_TIPO_DATA(7299350),            T_TIPO_DATA(7299506),            T_TIPO_DATA(7299507),
            T_TIPO_DATA(7299508),            T_TIPO_DATA(7299513),            T_TIPO_DATA(7299533),
            T_TIPO_DATA(7299574),            T_TIPO_DATA(7299579),            T_TIPO_DATA(7299627),
            T_TIPO_DATA(7300079),            T_TIPO_DATA(7300103),            T_TIPO_DATA(7300104),
            T_TIPO_DATA(7300131),            T_TIPO_DATA(7300135),            T_TIPO_DATA(7300137),
            T_TIPO_DATA(7300210),            T_TIPO_DATA(7300257),            T_TIPO_DATA(7300347),
            T_TIPO_DATA(7300353),            T_TIPO_DATA(7300355),            T_TIPO_DATA(7300357),
            T_TIPO_DATA(7300498),            T_TIPO_DATA(7300560),            T_TIPO_DATA(7300616),
            T_TIPO_DATA(7301067)
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN		

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

    DBMS_OUTPUT.PUT_LINE('[INFO] BUSCAMOS ACTIVO EN LA TABLA ACT_COE_CONDICION_ESPECIFICA');

    V_MSQL := 'SELECT COUNT(*) FROM '|| V_ESQUEMA ||'.ACT_COE_CONDICION_ESPECIFICA WHERE 
                ACT_ID = (SELECT ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0)
                AND COE_TEXTO LIKE ''%'||V_TEXTO||'%'' AND COE_FECHA_HASTA IS NULL AND BORRADO = 0' ;
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS != 0 THEN

        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_COE_CONDICION_ESPECIFICA SET
                    COE_FECHA_HASTA = SYSDATE,
                    USUARIOMODIFICAR = '''||V_USU||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID = (SELECT ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0)
                    AND COE_TEXTO LIKE ''%'||V_TEXTO||'%'' AND COE_FECHA_HASTA IS NULL AND BORRADO = 0' ;	
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] CONDICION ESPECIFICA MODIFICADA CORRECTAMENTE EN ACT_COE_CONDICION_ESPECIFICA');

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO] EL ACTIVO '||V_TMP_TIPO_DATA(1)||' NO TIENE CONDICION ESPECIFICA ACTIVA, NO EXISTE O ESTA BORRADO');

        V_COUNT_TOTAL_FALLOS:=V_COUNT_TOTAL_FALLOS+1;

    END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_COUNT_TOTAL||' ACTIVOS ITERADOS CORRECTAMENTE');
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_COUNT_TOTAL_FALLOS||' ACTIVOS HAN FALLADO');

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
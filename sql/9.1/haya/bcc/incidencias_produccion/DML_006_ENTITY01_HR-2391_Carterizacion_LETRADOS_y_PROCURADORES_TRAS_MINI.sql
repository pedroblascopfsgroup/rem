--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160504
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HRE-2391
--## PRODUCTO=NO
--## 
--## Finalidad: Carga de datos (letrados).
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 20151126 GMN Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        v_usuario_id HAYAMASTER.USU_USUARIOS.USU_ID%TYPE;
	v_letrado    HAYA02.MIG_PROCEDIMIENTOS_ACTORES.CD_ACTOR%TYPE;

        V_MSQL  VARCHAR2(2500);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'HAYA02';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';

        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
   
        V_EXISTE NUMBER (1):=null;

        
 TYPE T_GAA IS TABLE OF VARCHAR2(2000 CHAR);
 TYPE T_ARRAY_GAA IS TABLE OF T_GAA;
  
  
 V_GAA T_ARRAY_GAA := T_ARRAY_GAA(   
                                   T_GAA(000016490226165,'CARMESTEN')
                                 , T_GAA(001207200148308,'MANURUIZO')
                                 , T_GAA(001707200147393,'CARMESTEN')
                                 , T_GAA(002107200148166,'JESUALCOL')
                                 , T_GAA(002407200147573,'MANURUIZO')
                                 , T_GAA(002416490217286,'JESUALCOL')
                                 , T_GAA(003507200147407,'GUILZORND')
                                 , T_GAA(005216490218648,'MARIPEREA')
                                 , T_GAA(005216500074295,'MARIPEREA')
                                 , T_GAA(005607200148214,'MANURUIZO')
                                 , T_GAA(005607200148252,'MANURUIZO')
                                 , T_GAA(005607200148269,'MANURUIZO')
                                 , T_GAA(005607200148276,'MANURUIZO')
                                 , T_GAA(000016490226165,'CARMESTEN')
                                 , T_GAA(001207200148308,'MANURUIZO')
                                 , T_GAA(001707200147393,'CARMESTEN')
                                 , T_GAA(002107200148166,'JESUALCOL')
                                 , T_GAA(002407200147573,'MANURUIZO')
                                 , T_GAA(002416490217286,'JESUALCOL')
                                 , T_GAA(003507200147407,'GUILZORND')
                                 , T_GAA(005216490218648,'MARIPEREA')
                                 , T_GAA(005216500074295,'MARIPEREA')
                                 , T_GAA(005607200148214,'MANURUIZO')
                                 , T_GAA(005607200148252,'MANURUIZO')
                                 , T_GAA(005607200148269,'MANURUIZO')
                                 , T_GAA(005607200148276,'MANURUIZO')
                                 , T_GAA(005616490218347,'MANURUIZO')
                                 , T_GAA(006106890001607,'CARMESTEN')
                                 , T_GAA(006624590021379,'MARIPEREA')
                                 , T_GAA(007116490214025,'MARIPEREA')
                                 , T_GAA(007307200137237,'JORGCARDR')
                                 , T_GAA(007507200147607,'ANTOGOMEP')
                                 , T_GAA(008116490215960,'CARMESTEN')
                                 , T_GAA(008507200148238,'MARIPEREA')
                                 , T_GAA(008516490216570,'MARIPEREA')
                                 , T_GAA(009616490216459,'JORGCARDR')
                                 , T_GAA(009716520001236,'JESUALCOL')
                                 , T_GAA(010016490218635,'JESUALCOL')
                                 , T_GAA(010307200147681,'MARIPEREA')
                                 , T_GAA(011016490214674,'JORGCARDR')
                                 , T_GAA(011307180987261,'JORGCARDR')
                                 , T_GAA(011316490214619,'MANURUIZO')
                                 , T_GAA(012507180000110,'MARIPEREA')
                                 , T_GAA(013207180639255,'MARIHAROG')
                                 , T_GAA(015107200147329,'MARIPEREA')
                                 , T_GAA(016307200147474,'MARIHAROG')
                                 , T_GAA(017507180961999,'CARMESTEN')
                                 , T_GAA(017516490218723,'GUILAOLAO')
                                 , T_GAA(020507200146942,'JOAQORTEM')
                                 , T_GAA(020507200147426,'JOAQORTEM')
                                 , T_GAA(020516490225000,'LUISGARCA')
                                 , T_GAA(021116490215062,'JOAQORTEM')
                                 , T_GAA(022016490219716,'JOAQORTEM')
                                 , T_GAA(022107200148115,'LEXEAGOGA')
                                 , T_GAA(022207200114692,'LEXEAGOGA')
                                 , T_GAA(022607200139055,'LEXEAGOGA')
                                 , T_GAA(022706890004060,'JOAQORTEM')
                                 , T_GAA(023816490215634,'PROYFORMS')
                                 , T_GAA(023816490216293,'LEXEAGOGA')
                                 , T_GAA(023816490222687,'LEXEAGOGA')
                                 , T_GAA(023916490215909,'CARMESTEN')
                                 , T_GAA(024116500074143,'ENRIMONTF')
                                 , T_GAA(024116500074228,'ENRIMONTF')
                                 , T_GAA(024611320047345,'ENRIMONTF')
                                 , T_GAA(024616490221412,'LEXEAGOGA')
                                 , T_GAA(025807200146821,'LEXEAGOGA')
                                 , T_GAA(025916490219457,'LUISGARCA')
                                 , T_GAA(026216490215820,'LUISGARCA')
                                 , T_GAA(026916490213391,'LEXEAGOGA')
                                 , T_GAA(027016490212550,'JOAQORTEM')
                                 , T_GAA(027016490212642,'JOAQORTEM')
                                 , T_GAA(027116490212405,'LEXEAGOGA')
                                 , T_GAA(027116490218021,'LEXEAGOGA')
                                 , T_GAA(028707200147152,'LUISGARCA')
                                 , T_GAA(028816490217529,'JOAQORTEM')
                                 , T_GAA(028916490218019,'ENRIMONTF')
                                 , T_GAA(029007200147299,'ENRIMONTF')
                                 , T_GAA(029216490225468,'ENRIMONTF')
                                 , T_GAA(029516490212742,'PROYFORMS')
                                 , T_GAA(029607200147309,'LEXEAGOGA')
                                 , T_GAA(029707200147131,'LEXEAGOGA')
                                 , T_GAA(031607180003492,'ENRIMONTF')
                                 , T_GAA(032307200147063,'LUISGARCA')
                                 , T_GAA(032316490215954,'JOAQORTEM')
                                 , T_GAA(035407200146631,'PROYFORMS')
                                 , T_GAA(035407200146839,'PROYFORMS')
                                 , T_GAA(035407200146846,'JOAQORTEM')
                                 , T_GAA(035407200146938,'PROYFORMS')
                                 , T_GAA(037116480975065,'LEXEAGOGA')
                                 , T_GAA(037116490214941,'JOAQORTEM')
                                 , T_GAA(039507200147208,'LUISGARCA')
                                 , T_GAA(039816490214674,'LEXEAGOGA')
                                 , T_GAA(043216490219827,'ENRIMONTF')
                                 , T_GAA(050607200148139,'LUISMIRAG')
                                 , T_GAA(052316490214559,'LUISMIRAG')
                                 , T_GAA(052516490214960,'LUISMIRAG')
                                 , T_GAA(052616480000064,'LUISMIRAG')
                                 , T_GAA(053107200147680,'CONSABOGC')
                                 , T_GAA(053116490212992,'LUISMIRAG')
                                 , T_GAA(054416490216147,'LUISMIRAG')
                                 , T_GAA(055516490218350,'LUISMIRAG')
                                 , T_GAA(055616490214654,'LUISMIRAG')
                                 , T_GAA(057207200646638,'LUISMIRAG')
                                 , T_GAA(057216490214319,'LUISMIRAG')
                                 , T_GAA(057216490698740,'LUISMIRAG')
                                 , T_GAA(058316490212223,'LUISMIRAG')
                                 , T_GAA(058316520001089,'FRANLAOMO')
                                 , T_GAA(058416490215511,'LUISMIRAG')
                                 , T_GAA(059210210800172,'LUISMIRAG')
                                 , T_GAA(070716490216306,'FRANBARRB')
                                 , T_GAA(070916520001144,'FRANBARRB')
                                 , T_GAA(071716490221769,'ANDRVILAC')
                                 , T_GAA(071809510553040,'FRANBARRB')
                                 , T_GAA(072707200146811,'ANDRVILAC')
                                 , T_GAA(073016490214696,'FRANBARRB')
                                 , T_GAA(078216470000117,'FRANBARRB')
                                 , T_GAA(079307200147888,'MARILIROL')
                                 , T_GAA(083207180922185,'ANDRVILAC')
                                 , T_GAA(084207200146949,'FRANBARRB')
                                 , T_GAA(085116490214513,'FRANBARRB')
                                 , T_GAA(088316490216950,'ANDRVILAC')
                                 , T_GAA(088407200146727,'FRANBARRB')
                                 , T_GAA(130107180001558,'ALBECHAVA')
                                 , T_GAA(130907180000281,'LEONRUBIA')
                                 , T_GAA(160316490001296,'LUISMIRAG')
                                 , T_GAA(180116490217769,'FRANBARRB')
                                 , T_GAA(180516490214001,'MARILIROL')
                                 , T_GAA(190916490215212,'FRANBARRB')
                                 , T_GAA(191216490215595,'PROYFORMS')
                                 , T_GAA(192007200148190,'PROYFORMS')
                                 , T_GAA(192016490213167,'FRANBARRB')
                                 , T_GAA(200307200146962,'CARMESTEN')
                                 , T_GAA(200707200148605,'LEXEAGOGA')
                                 , T_GAA(200716490216923,'ABECSLP')
                                 , T_GAA(200816490214001,'CARMESTEN')
                                 , T_GAA(201007180008445,'LEXEAGOGA')
                                 , T_GAA(201007180009271,'LEXEAGOGA')
                                 , T_GAA(201007180009332,'LEXEAGOGA')
                                 , T_GAA(201107180000662,'VICERODRE')
                                 , T_GAA(201107180003586,'VICERODRE')
                                 , T_GAA(201107180013866,'LEXEAGOGA')
                                 , T_GAA(201107200146677,'FRANLAOMO')
                                 , T_GAA(201307180013789,'ABECSLP')
                                 , T_GAA(201307180015334,'LEXEAGOGA')
                                 , T_GAA(201307180019138,'LEXEAGOGA')
                                 , T_GAA(201316490218544,'LEXEAGOGA')
                                 , T_GAA(201607180017795,'PROYFORMS')
                                 , T_GAA(202316490000609,'LEXEAGOGA')
                                 , T_GAA(202407180018922,'JOSENINEG')
                                 , T_GAA(202407180018946,'JOSENINEG')
                                 , T_GAA(202507180008115,'LEXEAGOGA')
                                 , T_GAA(202707180007110,'JOSENINEG')
                                 , T_GAA(202906890000473,'CRTEXTERN')
                                 , T_GAA(202907180009541,'JOSENINEG')
                                 , T_GAA(202907180009565,'JOSENINEG')
                                 , T_GAA(203507180010517,'JOSENINEG')
                                 , T_GAA(203507180010890,'LEXEAGOGA')
                                 , T_GAA(203516490000853,'JOSENINEG')
                                 , T_GAA(203607180011823,'LEXEAGOGA')
                                 , T_GAA(203806890000163,'CRTEXTERN')
                                 , T_GAA(203807180007815,'LEXEAGOGA')
                                 , T_GAA(204007180010249,'LEXEAGOGA')
                                 , T_GAA(206107180004638,'LEXEAGOGA')
                                 , T_GAA(211607180016676,'VICERODRE')
                                 , T_GAA(211607180016683,'VICERODRE')
                                 , T_GAA(212107180020413,'PROYFORMS')
                                 , T_GAA(212207180009576,'PELLCAUDA')
                                 , T_GAA(212207180012220,'PELLCAUDA')
                                 , T_GAA(212207180012985,'JOSEBALLC')
                                 , T_GAA(212607180017801,'JOSEBALLC')
                                 , T_GAA(213007180006114,'JOSEBALLC')
                                 , T_GAA(213207180009128,'VICERODRE')
                                 , T_GAA(213316490001053,'JOSENINEG')
                                 , T_GAA(213507180013513,'NOVEABOGY')
                                 , T_GAA(213507180015809,'NOVEABOGY')
                                 , T_GAA(213507180015823,'NOVEABOGY')
                                 , T_GAA(213507180017058,'NOVEABOGY')
                                 , T_GAA(213507180018655,'NOVEABOGY')
                                 , T_GAA(213816490000277,'JOSEBALLC')
                                 , T_GAA(213907180008920,'LEXEAGOGA')
                                 , T_GAA(214507180003977,'LEXEAGOGA')
                                 , T_GAA(216607180016770,'JOSEBALLC')
                                 , T_GAA(217607180004183,'LEXEAGOGA')
                                 , T_GAA(217907180007578,'LEXEAGOGA')
                                 , T_GAA(217907180008793,'LEXEAGOGA')
                                 , T_GAA(217907180010383,'LEXEAGOGA')
                                 , T_GAA(217916490000247,'LEXEAGOGA')
                                 , T_GAA(218207180010505,'LEXEAGOGA')
                                 , T_GAA(218607180004254,'LEXEAGOGA')
                                 , T_GAA(219007180014465,'PROYFORMS')
                                 , T_GAA(220407180006200,'LEXEAGOGA')
                                 , T_GAA(220407180007296,'LEXEAGOGA')
                                 , T_GAA(220407180011776,'LEXEAGOGA')
                                 , T_GAA(221307180008880,'JOSENINEG')
                                 , T_GAA(221407180023406,'PROYFORMS')
                                 , T_GAA(221407180024409,'LEXEAGOGA')
                                 , T_GAA(221707180007456,'ABECSLP')
                                 , T_GAA(221707180008480,'ABECSLP')
                                 , T_GAA(222307180009145,'ABECSLP')
                                 , T_GAA(222416490000336,'ABECSLP')
                                 , T_GAA(222607180014724,'VICERODRE')
                                 , T_GAA(222607180020224,'PROYFORMS')
                                 , T_GAA(222807180004688,'LEXEAGOGA')
                                 , T_GAA(222816490000318,'ABECSLP')
                                 , T_GAA(222816490000387,'ABECSLP')
                                 , T_GAA(223007180005767,'ABECSLP')
                                 , T_GAA(223107180007540,'ABECSLP')
                                 , T_GAA(223107180010102,'JOSENINEG')
                                 , T_GAA(223407180011768,'LEXEAGOGA')
                                 , T_GAA(223407180019328,'LEXEAGOGA')
                                 , T_GAA(223516490000475,'LEXEAGOGA')
                                 , T_GAA(223907180010845,'LEXEAGOGA')
                                 , T_GAA(223907180012322,'LEXEAGOGA')
                                 , T_GAA(224107180013791,'ABECSLP')
                                 , T_GAA(224307180008728,'ABECSLP')
                                 , T_GAA(224607180009414,'LEXEAGOGA')
                                 , T_GAA(224607180009827,'LEXEAGOGA')
                                 , T_GAA(224607180009964,'LEXEAGOGA')
                                 , T_GAA(224607180011004,'LEXEAGOGA')
                                 , T_GAA(224807180004301,'LEXEAGOGA')
                                 , T_GAA(225207180008111,'LEXEAGOGA')
                                 , T_GAA(225407180006564,'LEXEAGOGA')
                                 , T_GAA(227607180011638,'JOSEBALLC')
                                 , T_GAA(227607180018356,'LEXEAGOGA')
                                 , T_GAA(228307180023149,'ABECSLP')
                                 , T_GAA(228807180013024,'ABECSLP')
                                 , T_GAA(229207180005398,'ABECSLP')
                                 , T_GAA(230707180002660,'ABECSLP')
                                 , T_GAA(232307180016768,'PELLCAUDA')
                                 , T_GAA(234207180002759,'LEXEAGOGA')
                                 , T_GAA(234216490000126,'CARMESTEN')
                                 , T_GAA(234807180009983,'LEXEAGOGA')
                                 , T_GAA(236407180015193,'JOSENINEG')
                                 , T_GAA(236427200005209,'VICERODRE')
                                 , T_GAA(236428100039626,'VICERODRE')
                                 , T_GAA(236528100001453,'VICERODRE')
                                 , T_GAA(237107180013827,'LEXEAGOGA')
                                 , T_GAA(237507180021886,'GENECIENA')
                                 , T_GAA(237507180022506,'GENECIENA')
                                 , T_GAA(237507180026683,'GENECIENA')
                                 , T_GAA(237527200002035,'FMS0')
                                 , T_GAA(237528100035879,'FMS0')
                                 , T_GAA(237540420500060,'FMS0')
                                 , T_GAA(237540420500077,'FMS0')
                                 , T_GAA(251407200146884,'CARMESTEN')
                                 , T_GAA(254316490000754,'GENECIENA')
                                 , T_GAA(255807200000030,'CARMESTEN')
                                 , T_GAA(259907180007435,'GENECIENA')
                                 , T_GAA(263628100009045,'MIGUMARTN')
                                 , T_GAA(263628100015293,'MIGUMARTN')
                                 , T_GAA(263710940000022,'MIGUMARTN')
                                 , T_GAA(263727200000159,'MIGUMARTN')
                                 , T_GAA(263806890100348,'MIGUMARTN')
                                 , T_GAA(263810940800108,'MIGUMARTN')
                                 , T_GAA(263810940800122,'MIGUMARTN')
                                 , T_GAA(263827200101167,'MIGUMARTN')
                                 , T_GAA(263828100102799,'MIGUMARTN')
                                 , T_GAA(264010990800326,'MIGUMARTN')
                                 , T_GAA(264028100002029,'MIGUMARTN')
                                 , T_GAA(264128100001254,'MIGUMARTN')
                                 , T_GAA(264427200001042,'MIGUMARTN')
                                 , T_GAA(265007180006924,'JOSEMANUG')
                                 , T_GAA(265328100001019,'JOSEMANUG')
                                 , T_GAA(266407180000925,'JOSEMANUG')
                                 , T_GAA(266407180000970,'JOSEMANUG')
                                 , T_GAA(281807180011975,'IGNALOPEZF')
                                 , T_GAA(281807180012213,'IGNALOPEZF')
                                 , T_GAA(281807180081196,'IGNALOPEZF')
                                 , T_GAA(282407180002602,'JOAQREMOV')
                                 , T_GAA(300116490218498,'JESUALCOL')
                                 , T_GAA(300607200147183,'GUILZORND')
                                 , T_GAA(300607200151229,'GUILZORND')
                                 , T_GAA(300607200151236,'GUILZORND')
                                 , T_GAA(300607200151250,'GUILZORND')
                                 , T_GAA(300707200147915,'JESUALCOL')
                                 , T_GAA(300707200150027,'BORJA')
                                 , T_GAA(300707200150379,'GUILZORND')
                                 , T_GAA(300807200146751,'GUILZORND')
                                 , T_GAA(320306890000186,'FRANBARRB')
                                 , T_GAA(350516490001790,'FRANBARRB')
                                 , T_GAA(350516490002502,'FRANBARRB')
                                 , T_GAA(400107180010497,'PROYFORMS')
                                 , T_GAA(400107180021558,'CONSABOGC')
                                 , T_GAA(400116490000764,'LUISMIRAG')
                                 , T_GAA(400116490006953,'LUISMIRAG')
                                 , T_GAA(400207180005173,'CONSABOGC')
                                 , T_GAA(400207180006978,'LUISMIRAG')
                                 , T_GAA(400216490002141,'LUISMIRAG')
                                 , T_GAA(400407180005171,'FRANLAOMO')
                                 , T_GAA(403416490000425,'LUISMIRAG')
                                 , T_GAA(403616490000652,'LUISMIRAG')
                                 , T_GAA(420107200000725,'LUISMIRAG')
                                 , T_GAA(420116490001426,'LUISMIRAG')
                                 , T_GAA(500807180004630,'IBERFORO')
                                 , T_GAA(501807200000191,'IBERFORO')
                                 , T_GAA(504907180006132,'IBERFORO')
                                 , T_GAA(505607180017725,'IBERFORO')
                                 , T_GAA(506007180002692,'PROYFORMS')
                                 , T_GAA(520107180006415,'IBERFORO')
                                 , T_GAA(520407200000059,'IBERFORO')
                                 , T_GAA(520411320000037,'IBERFORO')
                                 , T_GAA(520510940800132,'JJDAPENA')
                                 , T_GAA(530307180000757,'IBERFORO')
                                 , T_GAA(530707180005703,'FRANBARRB')
                                 , T_GAA(541116490000610,'IBERFORO')
                                 , T_GAA(610007180007138,'ROSARAMIR')
                                 , T_GAA(610207180018662,'MORAZAMEN')
                                 , T_GAA(611007180002372,'JANIAASOC')
                                 , T_GAA(611607180000431,'CRTEXTERN')
                                 , T_GAA(611707180001051,'MORAZAMEN')
                                 , T_GAA(612606890000509,'ROSAALVAB')
                                 , T_GAA(700407180020634,'JOSEBALLC')
                                 , T_GAA(701007180001616,'VICERODRE')
                                 , T_GAA(701107180025727,'JOSENINEG')
                                 , T_GAA(701307180013081,'JOSENINEG')
                                 , T_GAA(701516490001930,'JOSENINEG')
                                 , T_GAA(702407180001615,'PROYFORMS')
                                 , T_GAA(702507180024518,'LEXEAGOGA')
                                 , T_GAA(702807180018381,'LEXEAGOGA')
                                 , T_GAA(703516490004348,'LEXEAGOGA')
                                 , T_GAA(703910210001596,'VICERODRE')
                                 , T_GAA(704207180002128,'VICERODRE')
                                 , T_GAA(707307180090062,'VICERODRE')
                                 , T_GAA(709707180022658,'ABECSLP')
                                 , T_GAA(710007180007380,'PELLCAUDA')
                                 , T_GAA(710007180007892,'LEXEAGOGA')
                                 , T_GAA(711607180003125,'ABECSLP')
                                 , T_GAA(711907180005562,'LEXEAGOGA')
                                 , T_GAA(720007180105663,'VICERODRE')
                                 , T_GAA(722007180011221,'FRANMOLLF')
                                 , T_GAA(722016490001949,'FRANMOLLF')
                                 , T_GAA(724816490000647,'JOSESOLEV')
                                 , T_GAA(727107180016060,'ISABCRESG')
                                 , T_GAA(727116490004560,'JOSENINEG')
                                 , T_GAA(730007180015439,'JERICANOM')
                                 , T_GAA(730007180020493,'JERICANOM')
                                 , T_GAA(730007180020882,'JERICANOM')
                                 , T_GAA(730407180004732,'JERICANOM')
                                 , T_GAA(735007180007747,'VICERODRE')
                                 , T_GAA(742107180006048,'LEXEAGOGA')
                                 , T_GAA(742216490000429,'CONSABOGC')
                                 , T_GAA(742228100100100,'JERICANOM')
                                 , T_GAA(743528100211925,'JERICANOM')
                                 , T_GAA(745207180002679,'CONSABOGC')
                                 , T_GAA(745207180004248,'CONSABOGC')
                                 , T_GAA(745607180003685,'LEXEAGOGA')
                                 , T_GAA(745616490000448,'CONSABOGC')
                                 , T_GAA(745707180004984,'CONSABOGC')
                                 , T_GAA(747007180005034,'IGNALOPEZF')
                                 , T_GAA(747007180005119,'IGNALOPEZF')
                                 , T_GAA(747016490000365,'IGNALOPEZF')
                                 , T_GAA(747107180009851,'IGNALOPEZF')
                                 , T_GAA(747307180019771,'CONSABOGC')
                                 , T_GAA(747307180032392,'IGNALOPEZF')
                                 , T_GAA(747316490001389,'IGNALOPEZF')
                                 , T_GAA(747607180023364,'SANCVILAA')
                                 , T_GAA(747607180023814,'SANCVILAA')
                                 , T_GAA(747607180026301,'SANCVILAA')
                                 , T_GAA(747607180026530,'SANCVILAA')
                                 , T_GAA(747607180033446,'SANCVILAA')
                                 , T_GAA(747607180035473,'SANCVILAA')
                                 , T_GAA(747616490001768,'SANCVILAA')
                                 , T_GAA(748216490000434,'HISPIBERC')
                                 , T_GAA(748307180015192,'HISPIBERC')
                                 , T_GAA(748310210011073,'HISPIBERC')
                                 , T_GAA(748316500001074,'LEXEAGOGA')
                                 , T_GAA(748340920050420,'HISPIBERC')
                                 , T_GAA(748340920065309,'HISPIBERC')
                                 , T_GAA(748928100003453,'CONSABOGC')
                                 , T_GAA(748928100009543,'CONSABOGC')
                          );
        
         V_TMP_GAA T_GAA;        
  
BEGIN



/**************************************************************************************************/
/**********************************    LETRADOS                        ****************************/
/**************************************************************************************************/



 FOR I IN V_GAA.FIRST .. V_GAA.LAST
 LOOP
   V_TMP_GAA := V_GAA(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Insertando en GAA_GESTOR_ADICIONAL_ASUNTO el gestor: '||V_TMP_GAA(2));   
   

   -- LETRADOS EN LA GAA
    ------------------------------

   V_MSQL:= 'insert into HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select HAYA02.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), 
           ''HR-2391_2'', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
          select distinct asu.asu_id, usd.usd_id
          from (SELECT asu_id FROM HAYA02.asu_asuntos WHERE asu_id_externo = '|| V_TMP_GAA(1)||' ) asu  cross join 
               HAYA02.DD_LHC_LETR_HAYA_CAJAMAR    lhc  inner join              
               HAYAMASTER.usu_usuarios            usu  on usu.USU_EXTERNO = 1 and usu_username = lhc.dd_lhc_haya_codigo       inner join
               HAYAMASTER.GRU_GRUPOS_USUARIOS gru on gru.usu_id_usuario = usu.usu_id inner join
               HAYA02.usd_usuarios_despachos      usd  on gru.usu_id_grupo = usd.usu_id 
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
				and usd.USD_GESTOR_DEFECTO = 1 				
          where not exists (select 1 from HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id 
                                                                                           and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                  from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                  where dd_tge_codigo=''GEXT'')
                          )
         and lhc.dd_lhc_bcc_codigo = '''||V_TMP_GAA(2)||'''
     ) aux';
     
     EXECUTE IMMEDIATE V_MSQL;

     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Letrado '||V_TMP_GAA(2)||' carterizado a expediente '||V_TMP_GAA(1)||'. '||SQL%ROWCOUNT||' Filas.');

  --Insertamos carterizacion de grupos sin gestor particular
  
   V_MSQL:= 'insert into HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select HAYA02.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), 
           ''HR-2391_2'', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
 select distinct asu.asu_id, usd.usd_id
          from (SELECT asu_id FROM HAYA02.asu_asuntos WHERE asu_id_externo = '|| V_TMP_GAA(1)||' ) asu  cross join 
               HAYA02.des_despacho_externo   des   inner join 
               HAYA02.usd_usuarios_despachos      usd  on des.des_id= usd.des_id 	 and usd.USD_GESTOR_DEFECTO = 1  inner join 
               HAYAMASTER.usu_usuarios            usu  on usd.usu_id = usu.usu_id and usu.USU_EXTERNO = 1  and usu.usu_grupo = 1
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
          where not exists (select 1 from HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id 
                                                                                           and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                  from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                  where dd_tge_codigo=''GEXT'')
                          )
          and des.des_codigo = '''||V_TMP_GAA(2)||'''                          
     ) aux';    
     
      EXECUTE IMMEDIATE V_MSQL;

     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Grupo sin gestor particular '||V_TMP_GAA(2)||' carterizado a expediente '||V_TMP_GAA(1)||'. '||SQL%ROWCOUNT||' Filas.');

    
    
    -- letrados en GAH
    --------------------------
    
   V_MSQL:= 'insert into HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select HAYA02.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), 
           ''HR-2391_2'', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
            from (SELECT asu_id FROM HAYA02.asu_asuntos WHERE asu_id_externo = '|| V_TMP_GAA(1)||' ) asu  cross join 
               HAYA02.DD_LHC_LETR_HAYA_CAJAMAR    lhc                                                     inner join              
               HAYAMASTER.usu_usuarios            usu  on usu.USU_EXTERNO = 1 and usu_username = lhc.dd_lhc_haya_codigo       inner join
               HAYAMASTER.GRU_GRUPOS_USUARIOS gru on gru.usu_id_usuario = usu.usu_id inner join
               HAYA02.usd_usuarios_despachos      usd  on gru.usu_id_grupo = usd.usu_id  
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
				and usd.USD_GESTOR_DEFECTO = 1 
          where not exists (select 1 from HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah where gah.gah_asu_id = asu.asu_id 
                                                                                               and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                           from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                          where dd_tge_codigo=''GEXT'')
                            )
         and lhc.dd_lhc_bcc_codigo = '''||V_TMP_GAA(2)||'''                            
     ) aux';    
 
      EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Letrado '||V_TMP_GAA(2)||' carterizado a expediente '||V_TMP_GAA(1)||'. '||SQL%ROWCOUNT||' Filas.');
 
 --Insertamos carterizacion de grupos sin gestor particular
 
   V_MSQL:= 'insert into HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select HAYA02.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), 
           ''HR-2391_2'', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
          select distinct asu.asu_id, usd.usd_id
            from (SELECT asu_id FROM HAYA02.asu_asuntos WHERE asu_id_externo = '|| V_TMP_GAA(1)||' ) asu  cross join 
               HAYA02.des_despacho_externo   des                                                          inner join 
               HAYA02.usd_usuarios_despachos      usd  on des.des_id= usd.des_id  and usd.USD_GESTOR_DEFECTO = 1  inner join 
               HAYAMASTER.usu_usuarios            usu  on usd.usu_id = usu.usu_id and usu.USU_EXTERNO = 1  and usu.usu_grupo = 1
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
				and usd.USD_GESTOR_DEFECTO = 1 
          where not exists (select 1 from HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah where gah.gah_asu_id = asu.asu_id 
                                                                                               and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                           from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                          where dd_tge_codigo=''GEXT'')
                            )
            and des.des_codigo = '''||V_TMP_GAA(2)||'''                             
     ) aux';    
    
      EXECUTE IMMEDIATE V_MSQL;
  
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Grupo sin gestor particular '||V_TMP_GAA(2)||' carterizado a expediente '||V_TMP_GAA(1)||'. '||SQL%ROWCOUNT||' Filas.');

  END LOOP; 
 
    COMMIT;
    

    EXECUTE IMMEDIATE('ANALYZE TABLE HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_ASUNTO Analizada');



    EXECUTE IMMEDIATE('ANALYZE TABLE HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO Analizada');
 

 
--/***************************************
--*     FIN LETRADOS  *
--***************************************/

  DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_MSQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;


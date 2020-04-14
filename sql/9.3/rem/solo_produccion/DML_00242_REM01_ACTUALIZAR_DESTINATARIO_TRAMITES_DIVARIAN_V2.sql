--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200414
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6966
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_1 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_2 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_3 NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6966'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    TRA_ID NUMBER(16);
    TAR_ID NUMBER(16);
    TEX_ID NUMBER(16);
    ACT_ID NUMBER(16);
    USU_ID NUMBER(16);
    SUP_ID NUMBER(16);
    ECO_ID NUMBER(16);
    TEX_TOKEN NUMBER(16);

    SEQ_TAR_ID NUMBER(16);

    V_COUNT_UPDATE_1 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_2 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_3 NUMBER(16):= 0; -- Vble. para contar updates

    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--TRA_ID , TAR_ID, ACT_ID, USU_ID, SUP_ID, ECO_NUM_EXPEDIENTE

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
--CIERRE ECONOMICO
T_JBV(479950, 5070888,450432 ,88740 ,87742,201631 ),
T_JBV(476808, 5070851,453006 ,88740 ,87742,201641 ),
T_JBV(476757, 5071538,454561 ,88740 ,87742,202098 ),
T_JBV(474768, 5071826,466312 ,88740 ,87742,202259 ),
T_JBV(479946, 5071888,474286 ,88740 ,87742,202339 ),
T_JBV(478183, 5072158,465116 ,88740 ,87742,202415 ),
T_JBV(474016, 5072099,459034 ,88740 ,87742,202441 ),
T_JBV(479449, 5072176,460211 ,88740 ,87742,202513 ),
T_JBV(477479, 5072449,464822 ,88740 ,87742,202666 ),
T_JBV(480298, 5072789,497450 ,88740 ,87742,202935 ),
T_JBV(478425, 5073023,450787 ,88740 ,87742,202984 ),
T_JBV(475925, 5072972,495791 ,88740 ,87742,203112 ),
T_JBV(476613, 5073179,487915 ,88740 ,87742,203223 ),
T_JBV(474581, 5073358,448808 ,88740 ,87742,203378 ),
T_JBV(475230, 5073354,480650 ,88740 ,87742,203410 ),
T_JBV(479509, 5073417,462744 ,88740 ,87742,203433 ),
T_JBV(478587, 5073403,462741 ,88740 ,87742,203446 ),
T_JBV(478403, 5070304,455614 ,88740 ,87742,203600 ),
T_JBV(475420, 5073576,462736 ,88740 ,87742,203643 ),
T_JBV(474746, 5073759,469455 ,88740 ,87742,203924 ),
T_JBV(479121, 5074020,461320 ,88740 ,87742,204101 ),
T_JBV(480294, 5074039,478766 ,88740 ,87742,204139 ),
T_JBV(473770, 5074149,495398 ,88740 ,87742,204240 ),
T_JBV(479065, 5070317,457203 ,88740 ,87742,204400 ),
T_JBV(476343, 5074591,466060 ,88740 ,87742,204738 ),
T_JBV(476812, 5074589,457684 ,88740 ,87742,204808 ),
T_JBV(475300, 5074765,495584 ,88740 ,87742,204931 ),
T_JBV(478444, 5075404,499445 ,88740 ,87742,206452 ),
T_JBV(475527, 5075365,499459 ,88740 ,87742,206461 ),
T_JBV(478530, 5075402,499470 ,88740 ,87742,206462 ),
T_JBV(474415, 5075344,499461 ,88740 ,87742,206472 ),
T_JBV(477286, 5075387,478925 ,88740 ,87742,206552 ),
T_JBV(477101, 5075593,486266 ,88740 ,87742,206699 ),
T_JBV(475766, 5075773,466766 ,88740 ,87742,206972 ),
T_JBV(478383, 5076002,458805 ,88740 ,87742,207130 ),
T_JBV(477387, 5075984,480907 ,88740 ,87742,207175 ),
T_JBV(478170, 5075999,489594 ,88740 ,87742,207212 ),
T_JBV(480409, 5076230,465110 ,88740 ,87742,207218 ),
T_JBV(473679, 5076343,486397 ,88740 ,87742,207446 ),
T_JBV(473698, 5076545,500048 ,88740 ,87742,207610 ),
T_JBV(473632, 5076747,458634 ,88740 ,87742,207952 ),
T_JBV(476359, 5076958,478305 ,88740 ,87742,208352 ),
T_JBV(479936, 5070325,499468 ,88740 ,87742,201575 ),
T_JBV(476672, 5070282,449700 ,88740 ,87742,201621 ),
T_JBV(480116, 5070898,453396 ,88740 ,87742,201716 ),
T_JBV(474557, 5071218,449702 ,88740 ,87742,201755 ),
T_JBV(474823, 5071512,463738 ,88740 ,87742,202053 ),
T_JBV(477338, 5071556,452261 ,88740 ,87742,202058 ),
T_JBV(478326, 5071861,499138 ,88740 ,87742,202192 ),
T_JBV(475382, 5071814,466327 ,88740 ,87742,202237 ),
T_JBV(479221, 5071880,452672 ,88740 ,87742,202286 ),
T_JBV(475985, 5071830,497366 ,88740 ,87742,202344 ),
T_JBV(476515, 5072136,462750 ,88740 ,87742,202386 ),
T_JBV(478641, 5072464,495789 ,88740 ,87742,202651 ),
T_JBV(480378, 5072786,445734 ,88740 ,87742,202915 ),
T_JBV(474153, 5072700,475550 ,88740 ,87742,202970 ),
T_JBV(476644, 5072986,497458 ,88740 ,87742,203028 ),
T_JBV(480178, 5073031,490487 ,88740 ,87742,203197 ),
T_JBV(473923, 5073152,477538 ,88740 ,87742,203204 ),
T_JBV(479800, 5073232,496002 ,88740 ,87742,203209 ),
T_JBV(475883, 5073173,455615 ,88740 ,87742,203231 ),
T_JBV(478322, 5073218,498189 ,88740 ,87742,203331 ),
T_JBV(477363, 5073397,462751 ,88740 ,87742,203438 ),
T_JBV(477247, 5073392,484583 ,88740 ,87742,203463 ),
T_JBV(478176, 5073413,466079 ,88740 ,87742,203516 ),
T_JBV(476084, 5073969,489301 ,88740 ,87742,204022 ),
T_JBV(474522, 5073952,463685 ,88740 ,87742,204099 ),
T_JBV(477324, 5073999,470296 ,88740 ,87742,204131 ),
T_JBV(474828, 5074359,444427 ,88740 ,87742,204530 ),
T_JBV(478389, 5074413,448838 ,88740 ,87742,204593 ),
T_JBV(474794, 5074363,450339 ,88740 ,87742,204603 ),
T_JBV(478348, 5074619,454662 ,88740 ,87742,204638 ),
T_JBV(480186, 5074636,459397 ,88740 ,87742,204755 ),
T_JBV(475669, 5074576,484582 ,88740 ,87742,204817 ),
T_JBV(474429, 5074551,496426 ,88740 ,87742,204862 ),
T_JBV(474545, 5074761,448851 ,88740 ,87742,205084 ),
T_JBV(474110, 5074946,495585 ,88740 ,87742,205112 ),
T_JBV(480052, 5075041,450416 ,88740 ,87742,205142 ),
T_JBV(476333, 5074979,451426 ,88740 ,87742,205174 ),
T_JBV(478258, 5075202,494315 ,88740 ,87742,205877 ),
T_JBV(473681, 5075146,459558 ,88740 ,87742,206448 ),
T_JBV(474555, 5075356,499436 ,88740 ,87742,206457 ),
T_JBV(479446, 5075415,452627 ,88740 ,87742,206510 ),
T_JBV(478248, 5075398,479044 ,88740 ,87742,206547 ),
T_JBV(478434, 5075607,458690 ,88740 ,87742,206650 ),
T_JBV(475893, 5075567,500214 ,88740 ,87742,206693 ),
T_JBV(473666, 5075744,459465 ,88740 ,87742,206933 ),
T_JBV(475079, 5075759,499876 ,88740 ,87742,207015 ),
T_JBV(476709, 5075969,488919 ,88740 ,87742,207029 ),
T_JBV(474999, 5075952,450735 ,88740 ,87742,207088 ),
T_JBV(475486, 5075964,450348 ,88740 ,87742,207168 ),
T_JBV(476994, 5075976,477665 ,88740 ,87742,207198 ),
T_JBV(477698, 5075988,496422 ,88740 ,87742,207199 ),
T_JBV(478329, 5076203,450365 ,88740 ,87742,207276 ),
T_JBV(480316, 5076227,450342 ,88740 ,87742,207280 ),
T_JBV(480195, 5076224,491531 ,88740 ,87742,207298 ),
T_JBV(475830, 5076171,462727 ,88740 ,87742,207376 ),
T_JBV(479527, 5076420,481881 ,88740 ,87742,207548 ),
T_JBV(474708, 5076358,487924 ,88740 ,87742,207562 ),
T_JBV(476957, 5076387,489817 ,88740 ,87742,207569 ),
T_JBV(473708, 5076346,466057 ,88740 ,87742,207583 ),
T_JBV(475476, 5076575,450347 ,88740 ,87742,207618 ),
T_JBV(479024, 5076618,462936 ,88740 ,87742,207670 ),
T_JBV(479084, 5076826,459142 ,88740 ,87742,207911 ),
T_JBV(480287, 5070324,499471 ,88740 ,87742,201576 ),
T_JBV(476627, 5070280,494522 ,88740 ,87742,201629 ),
T_JBV(478317, 5070865,458795 ,88740 ,87742,201715 ),
T_JBV(479897, 5070883,486405 ,88740 ,87742,201721 ),
T_JBV(476581, 5071246,494721 ,88740 ,87742,201834 ),
T_JBV(475655, 5071524,453090 ,88740 ,87742,202097 ),
T_JBV(476688, 5072133,498837 ,88740 ,87742,202481 ),
T_JBV(476358, 5072747,499969 ,88740 ,87742,202955 ),
T_JBV(476629, 5072757,497032 ,88740 ,87742,202965 ),
T_JBV(478879, 5073011,486798 ,88740 ,87742,203106 ),
T_JBV(477653, 5072992,495794 ,88740 ,87742,203126 ),
T_JBV(476632, 5072980,470420 ,88740 ,87742,203142 ),
T_JBV(476902, 5073380,466065 ,88740 ,87742,203461 ),
T_JBV(475664, 5073373,459560 ,88740 ,87742,203530 ),
T_JBV(476022, 5073571,488147 ,88740 ,87742,203650 ),
T_JBV(476417, 5073978,453111 ,88740 ,87742,204021 ),
T_JBV(477660, 5074000,466793 ,88740 ,87742,204116 ),
T_JBV(474021, 5073943,492002 ,88740 ,87742,204152 ),
T_JBV(478538, 5074004,462243 ,88740 ,87742,204169 ),
T_JBV(476381, 5074189,467924 ,88740 ,87742,204347 ),
T_JBV(475235, 5074352,483896 ,88740 ,87742,204479 ),
T_JBV(477732, 5074403,484586 ,88740 ,87742,204560 ),
T_JBV(476374, 5074385,458997 ,88740 ,87742,204586 ),
T_JBV(478178, 5074617,496004 ,88740 ,87742,204647 ),
T_JBV(478038, 5074613,495792 ,88740 ,87742,204771 ),
T_JBV(478524, 5074615,465733 ,88740 ,87742,204815 ),
T_JBV(480033, 5074837,461350 ,88740 ,87742,204937 ),
T_JBV(478413, 5075011,499989 ,88740 ,87742,205201 ),
T_JBV(473823, 5074949,466066 ,88740 ,87742,205338 ),
T_JBV(475428, 5075171,486460 ,88740 ,87742,205566 ),
T_JBV(476684, 5075190,497930 ,88740 ,87742,205617 ),
T_JBV(475460, 5075364,452945 ,88740 ,87742,206464 ),
T_JBV(474810, 5075555,450738 ,88740 ,87742,206716 ),
T_JBV(475447, 5075770,457522 ,88740 ,87742,206898 ),
T_JBV(475736, 5075963,453496 ,88740 ,87742,207148 ),
T_JBV(477593, 5075985,462613 ,88740 ,87742,207205 ),
T_JBV(473785, 5076143,476083 ,88740 ,87742,207246 ),
T_JBV(477881, 5076191,462777 ,88740 ,87742,207291 ),
T_JBV(475468, 5076169,453523 ,88740 ,87742,207301 ),
T_JBV(476758, 5076184,497446 ,88740 ,87742,207352 ),
T_JBV(476893, 5076381,462730 ,88740 ,87742,207488 ),
T_JBV(476089, 5076374,483296 ,88740 ,87742,207564 ),
T_JBV(477868, 5076597,492139 ,88740 ,87742,207679 ),
T_JBV(474896, 5076557,450350 ,88740 ,87742,207697 ),
T_JBV(476382, 5076779,496794 ,88740 ,87742,207847 ),
T_JBV(478221, 5076805,491441 ,88740 ,87742,207857 ),
T_JBV(479063, 5070316,450419 ,88740 ,87742,201700 ),
T_JBV(478274, 5070866,449705 ,88740 ,87742,201706 ),
T_JBV(480238, 5071291,452617 ,88740 ,87742,201907 ),
T_JBV(478273, 5071865,452489 ,88740 ,87742,202143 ),
T_JBV(474558, 5071820,466292 ,88740 ,87742,202290 ),
T_JBV(476436, 5071838,459589 ,88740 ,87742,202299 ),
T_JBV(476347, 5072431,452654 ,88740 ,87742,202665 ),
T_JBV(473685, 5072704,462731 ,88740 ,87742,202802 ),
T_JBV(476736, 5072748,497463 ,88740 ,87742,202923 ),
T_JBV(476689, 5072756,466763 ,88740 ,87742,202924 ),
T_JBV(480472, 5072787,450786 ,88740 ,87742,202958 ),
T_JBV(480673, 5073033,497449 ,88740 ,87742,202990 ),
T_JBV(480068, 5073030,462723 ,88740 ,87742,203095 ),
T_JBV(476653, 5073187,499654 ,88740 ,87742,203255 ),
T_JBV(476058, 5073169,480033 ,88740 ,87742,203263 ),
T_JBV(475183, 5073362,462583 ,88740 ,87742,203387 ),
T_JBV(478798, 5070310,457020 ,88740 ,87742,203400 ),
T_JBV(476440, 5073388,466074 ,88740 ,87742,203455 ),
T_JBV(477700, 5073396,466076 ,88740 ,87742,203556 ),
T_JBV(475508, 5073776,466795 ,88740 ,87742,203945 ),
T_JBV(474930, 5073953,499263 ,88740 ,87742,204014 ),
T_JBV(477517, 5073993,466754 ,88740 ,87742,204045 ),
T_JBV(477695, 5074203,466316 ,88740 ,87742,204199 ),
T_JBV(474676, 5074169,477712 ,88740 ,87742,204230 ),
T_JBV(473904, 5074151,457305 ,88740 ,87742,204325 ),
T_JBV(476348, 5074388,462737 ,88740 ,87742,204498 ),
T_JBV(477911, 5074399,455004 ,88740 ,87742,204514 ),
T_JBV(479238, 5074627,466141 ,88740 ,87742,204747 ),
T_JBV(476398, 5074595,499208 ,88740 ,87742,204777 ),
T_JBV(474973, 5075157,456000 ,88740 ,87742,205491 ),
T_JBV(480082, 5075228,464993 ,88740 ,87742,205895 ),
T_JBV(475521, 5075372,499450 ,88740 ,87742,206471 ),
T_JBV(479935, 5075425,494498 ,88740 ,87742,206477 ),
T_JBV(477280, 5075389,492596 ,88740 ,87742,206523 ),
T_JBV(473732, 5075550,495767 ,88740 ,87742,206681 ),
T_JBV(479944, 5075631,457166 ,88740 ,87742,206707 ),
T_JBV(480105, 5075828,486264 ,88740 ,87742,206834 ),
T_JBV(477814, 5075793,466000 ,88740 ,87742,206866 ),
T_JBV(474919, 5075758,448446 ,88740 ,87742,206899 ),
T_JBV(475506, 5075769,460448 ,88740 ,87742,206940 ),
T_JBV(476531, 5075785,462958 ,88740 ,87742,206995 ),
T_JBV(473788, 5075743,471204 ,88740 ,87742,206997 ),
T_JBV(477706, 5075990,497687 ,88740 ,87742,207132 ),
T_JBV(478152, 5076198,498657 ,88740 ,87742,207286 ),
T_JBV(475493, 5076170,451522 ,88740 ,87742,207345 ),
T_JBV(474625, 5076352,450713 ,88740 ,87742,207418 ),
T_JBV(475138, 5076353,492609 ,88740 ,87742,207519 ),
T_JBV(475758, 5076370,498835 ,88740 ,87742,207533 ),
T_JBV(479986, 5076631,500559 ,88740 ,87742,207586 ),
T_JBV(473763, 5076550,485083 ,88740 ,87742,207641 ),
T_JBV(479553, 5076616,494272 ,88740 ,87742,207688 ),
T_JBV(474104, 5076544,468615 ,88740 ,87742,207715 ),
T_JBV(475770, 5076765,495479 ,88740 ,87742,207889 ),
T_JBV(475564, 5076772,450338 ,88740 ,87742,207914 ),
T_JBV(478253, 5076808,481009 ,88740 ,87742,207956 ),
T_JBV(476178, 5076769,491996 ,88740 ,87742,207973 ),
T_JBV(479507, 5076822,497767 ,88740 ,87742,207978 ),
T_JBV(475087, 5076759,450341 ,88740 ,87742,208021 ),
T_JBV(480268, 5076835,496536 ,88740 ,87742,208042 ),
T_JBV(476458, 5070279,492015 ,88740 ,87742,201568 ),
T_JBV(476367, 5070281,499456 ,88740 ,87742,201573 ),
T_JBV(479283, 5071883,469172 ,88740 ,87742,202282 ),
T_JBV(479117, 5071876,466318 ,88740 ,87742,202289 ),
T_JBV(479520, 5072171,450405 ,88740 ,87742,202380 ),
T_JBV(474774, 5072108,450523 ,88740 ,87742,202484 ),
T_JBV(477341, 5072146,469680 ,88740 ,87742,202536 ),
T_JBV(475742, 5072730,462740 ,88740 ,87742,202817 ),
T_JBV(477583, 5072765,462748 ,88740 ,87742,202872 ),
T_JBV(474789, 5072718,479001 ,88740 ,87742,202901 ),
T_JBV(475778, 5072978,462065 ,88740 ,87742,203016 ),
T_JBV(477718, 5072998,495793 ,88740 ,87742,203025 ),
T_JBV(478739, 5070307,450353 ,88740 ,87742,203200 ),
T_JBV(477355, 5073198,450681 ,88740 ,87742,203237 ),
T_JBV(474745, 5073352,473187 ,88740 ,87742,203397 ),
T_JBV(475289, 5073360,491289 ,88740 ,87742,203562 ),
T_JBV(478549, 5073404,462738 ,88740 ,87742,203578 ),
T_JBV(476716, 5073585,462725 ,88740 ,87742,203713 ),
T_JBV(477374, 5073796,447919 ,88740 ,87742,203824 ),
T_JBV(478410, 5073814,498763 ,88740 ,87742,203893 ),
T_JBV(478771, 5073806,485670 ,88740 ,87742,203906 ),
T_JBV(477624, 5074200,484289 ,88740 ,87742,204259 ),
T_JBV(476655, 5074187,461048 ,88740 ,87742,204352 ),
T_JBV(478719, 5074216,462732 ,88740 ,87742,204365 ),
T_JBV(477467, 5074401,456269 ,88740 ,87742,204509 ),
T_JBV(480102, 5074635,497276 ,88740 ,87742,204718 ),
T_JBV(476815, 5074592,463331 ,88740 ,87742,204811 ),
T_JBV(477621, 5075005,462724 ,88740 ,87742,205205 ),
T_JBV(476497, 5074981,450512 ,88740 ,87742,205374 ),
T_JBV(474089, 5075153,492040 ,88740 ,87742,205445 ),
T_JBV(476229, 5075166,499385 ,88740 ,87742,205584 ),
T_JBV(477430, 5075194,466049 ,88740 ,87742,205598 ),
T_JBV(479763, 5075825,497991 ,88740 ,87742,206817 ),
T_JBV(473706, 5075745,481658 ,88740 ,87742,206835 ),
T_JBV(479095, 5075823,489423 ,88740 ,87742,206836 ),
T_JBV(474611, 5075760,497473 ,88740 ,87742,206920 ),
T_JBV(478514, 5075810,486254 ,88740 ,87742,206984 ),
T_JBV(479931, 5075835,461021 ,88740 ,87742,206994 ),
T_JBV(478261, 5075806,487684 ,88740 ,87742,207020 ),
T_JBV(478210, 5076006,480540 ,88740 ,87742,207078 ),
T_JBV(476549, 5075974,477294 ,88740 ,87742,207118 ),
T_JBV(479647, 5076018,469691 ,88740 ,87742,207191 ),
T_JBV(479067, 5076014,485094 ,88740 ,87742,207204 ),
T_JBV(477405, 5076190,497351 ,88740 ,87742,207222 ),
T_JBV(480210, 5076223,463330 ,88740 ,87742,207331 ),
T_JBV(478249, 5076200,450734 ,88740 ,87742,207392 ),
T_JBV(480411, 5076434,477666 ,88740 ,87742,207472 ),
T_JBV(476648, 5076385,450737 ,88740 ,87742,207505 ),
T_JBV(480198, 5076440,481878 ,88740 ,87742,207528 ),
T_JBV(478207, 5076409,457435 ,88740 ,87742,207532 ),
T_JBV(475265, 5076354,479209 ,88740 ,87742,207551 ),
T_JBV(478374, 5076411,482704 ,88740 ,87742,207582 ),
T_JBV(480009, 5076634,497461 ,88740 ,87742,207592 ),
T_JBV(475557, 5076572,450358 ,88740 ,87742,207643 ),
T_JBV(479261, 5076627,450367 ,88740 ,87742,207696 ),
T_JBV(478215, 5076807,495054 ,88740 ,87742,207877 ),
T_JBV(477692, 5076793,494325 ,88740 ,87742,207997 ),
T_JBV(477271, 5076961,484355 ,88740 ,87742,208045 ),
T_JBV(474617, 5076944,480584 ,88740 ,87742,208063 ),
T_JBV(476537, 5070843,454742 ,88740 ,87742,201654 ),
T_JBV(475376, 5070820,465311 ,88740 ,87742,201701 ),
T_JBV(480025, 5070891,458798 ,88740 ,87742,201711 ),
T_JBV(477838, 5071255,498063 ,88740 ,87742,201795 ),
T_JBV(474646, 5070250,457533 ,88740 ,87742,201900 ),
T_JBV(479060, 5071875,459016 ,88740 ,87742,202314 ),
T_JBV(478392, 5072170,462735 ,88740 ,87742,202459 ),
T_JBV(479605, 5072173,455965 ,88740 ,87742,202512 ),
T_JBV(480286, 5072487,478975 ,88740 ,87742,202611 ),
T_JBV(475891, 5072414,471006 ,88740 ,87742,202748 ),
T_JBV(475551, 5072736,466797 ,88740 ,87742,202927 ),
T_JBV(473973, 5072944,483543 ,88740 ,87742,203138 ),
T_JBV(477565, 5072994,449081 ,88740 ,87742,203169 ),
T_JBV(477731, 5073200,499962 ,88740 ,87742,203218 ),
T_JBV(479951, 5073631,463730 ,88740 ,87742,203696 ),
T_JBV(476521, 5073584,465451 ,88740 ,87742,203776 ),
T_JBV(475483, 5073769,484585 ,88740 ,87742,203851 ),
T_JBV(476847, 5073785,451423 ,88740 ,87742,203910 ),
T_JBV(476831, 5073986,459552 ,88740 ,87742,204011 ),
T_JBV(477867, 5073996,476889 ,88740 ,87742,204122 ),
T_JBV(478897, 5074005,492334 ,88740 ,87742,204135 ),
T_JBV(475549, 5073965,460675 ,88740 ,87742,204145 ),
T_JBV(477290, 5073991,487663 ,88740 ,87742,204157 ),
T_JBV(479453, 5074222,495177 ,88740 ,87742,204239 ),
T_JBV(477352, 5074400,455055 ,88740 ,87742,204398 ),
T_JBV(474704, 5074362,495167 ,88740 ,87742,204438 ),
T_JBV(475491, 5074966,466069 ,88740 ,87742,205232 ),
T_JBV(479248, 5075221,461570 ,88740 ,87742,205423 ),
T_JBV(476506, 5075184,465525 ,88740 ,87742,205596 ),
T_JBV(479297, 5075212,487971 ,88740 ,87742,206441 ),
T_JBV(476364, 5075185,499473 ,88740 ,87742,206447 ),
T_JBV(478319, 5075403,499474 ,88740 ,87742,206450 ),
T_JBV(480193, 5075429,499469 ,88740 ,87742,206451 ),
T_JBV(477672, 5075384,450407 ,88740 ,87742,206480 ),
T_JBV(474903, 5075354,462471 ,88740 ,87742,206486 ),
T_JBV(474627, 5075355,463674 ,88740 ,87742,206605 ),
T_JBV(476365, 5075379,460242 ,88740 ,87742,206613 ),
T_JBV(479470, 5075619,459809 ,88740 ,87742,206663 ),
T_JBV(478270, 5076001,469981 ,88740 ,87742,207091 ),
T_JBV(475599, 5076167,491509 ,88740 ,87742,207277 ),
T_JBV(479768, 5076213,497457 ,88740 ,87742,207341 ),
T_JBV(479913, 5076222,500187 ,88740 ,87742,207347 ),
T_JBV(474948, 5076152,497439 ,88740 ,87742,207348 ),
T_JBV(473670, 5070243,453088 ,88740 ,87742,201554 ),
T_JBV(477673, 5076397,448157 ,88740 ,87742,207517 ),
T_JBV(479228, 5076422,481873 ,88740 ,87742,207568 ),
T_JBV(476836, 5076578,450359 ,88740 ,87742,207645 ),
T_JBV(473964, 5076547,450355 ,88740 ,87742,207648 ),
T_JBV(478741, 5076611,450364 ,88740 ,87742,207649 ),
T_JBV(477350, 5076593,477061 ,88740 ,87742,207654 ),
T_JBV(475584, 5076569,486849 ,88740 ,87742,207743 ),
T_JBV(476796, 5076785,472238 ,88740 ,87742,207852 ),
T_JBV(476578, 5076780,475188 ,88740 ,87742,207871 ),
T_JBV(477682, 5076795,450344 ,88740 ,87742,207981 ),
T_JBV(475208, 5076946,459480 ,88740 ,87742,208081 ),
T_JBV(475321, 5070257,499440 ,88740 ,87742,201579 ),
T_JBV(477446, 5071254,449699 ,88740 ,87742,201758 ),
T_JBV(477358, 5071252,465862 ,88740 ,87742,201891 ),
T_JBV(480288, 5071889,464583 ,88740 ,87742,202193 ),
T_JBV(475480, 5072123,463930 ,88740 ,87742,202369 ),
T_JBV(478204, 5072457,498549 ,88740 ,87742,202702 ),
T_JBV(477285, 5072761,485713 ,88740 ,87742,202891 ),
T_JBV(478160, 5072772,485717 ,88740 ,87742,202925 ),
T_JBV(479777, 5072781,450343 ,88740 ,87742,202962 ),
T_JBV(474115, 5072947,497472 ,88740 ,87742,203019 ),
T_JBV(480243, 5073234,485715 ,88740 ,87742,203207 ),
T_JBV(479967, 5073238,462745 ,88740 ,87742,203259 ),
T_JBV(478327, 5073217,462747 ,88740 ,87742,203303 ),
T_JBV(480090, 5073239,462746 ,88740 ,87742,203306 ),
T_JBV(475052, 5073364,462743 ,88740 ,87742,203474 ),
T_JBV(473917, 5073345,466078 ,88740 ,87742,203501 ),
T_JBV(475794, 5073772,462182 ,88740 ,87742,203828 ),
T_JBV(477128, 5073782,495005 ,88740 ,87742,203844 ),
T_JBV(478862, 5073808,478999 ,88740 ,87742,203977 ),
T_JBV(473986, 5073744,481153 ,88740 ,87742,203983 ),
T_JBV(480380, 5074032,462733 ,88740 ,87742,204114 ),
T_JBV(479144, 5074626,466053 ,88740 ,87742,204616 ),
T_JBV(473794, 5074546,465499 ,88740 ,87742,204635 ),
T_JBV(473832, 5074550,450412 ,88740 ,87742,204710 ),
T_JBV(473672, 5074756,461568 ,88740 ,87742,204936 ),
T_JBV(479383, 5074827,455850 ,88740 ,87742,205092 ),
T_JBV(475721, 5075175,487120 ,88740 ,87742,205521 ),
T_JBV(474157, 5075345,499435 ,88740 ,87742,206456 ),
T_JBV(478385, 5075400,499447 ,88740 ,87742,206469 ),
T_JBV(475889, 5075366,499463 ,88740 ,87742,206470 ),
T_JBV(477146, 5075375,499462 ,88740 ,87742,206475 ),
T_JBV(477544, 5075602,465763 ,88740 ,87742,206724 ),
T_JBV(478161, 5075815,494138 ,88740 ,87742,206963 ),
T_JBV(478241, 5076000,456718 ,88740 ,87742,207060 ),
T_JBV(479395, 5076013,494227 ,88740 ,87742,207209 ),
T_JBV(477303, 5076189,461989 ,88740 ,87742,207302 ),
T_JBV(479976, 5076232,489085 ,88740 ,87742,207370 ),
T_JBV(475472, 5076168,486706 ,88740 ,87742,207390 ),
T_JBV(480005, 5076431,499134 ,88740 ,87742,207556 ),
T_JBV(476823, 5076582,481875 ,88740 ,87742,207701 ),
T_JBV(476131, 5076567,474428 ,88740 ,87742,207734 ),
T_JBV(475710, 5070266,499475 ,88740 ,87742,201571 ),
T_JBV(477300, 5070857,477461 ,88740 ,87742,201672 ),
T_JBV(477447, 5071849,497290 ,88740 ,87742,202195 ),
T_JBV(474728, 5072117,480459 ,88740 ,87742,202390 ),
T_JBV(479303, 5072178,465055 ,88740 ,87742,202411 ),
T_JBV(478172, 5072165,450516 ,88740 ,87742,202468 ),
T_JBV(480084, 5072486,495790 ,88740 ,87742,202656 ),
T_JBV(475455, 5072415,471055 ,88740 ,87742,202668 ),
T_JBV(478191, 5072455,484298 ,88740 ,87742,202679 ),
T_JBV(476947, 5072746,468157 ,88740 ,87742,202903 ),
T_JBV(473815, 5073346,450495 ,88740 ,87742,203441 ),
T_JBV(474905, 5073357,453883 ,88740 ,87742,203472 ),
T_JBV(480592, 5073436,480281 ,88740 ,87742,203515 ),
T_JBV(479054, 5073612,447310 ,88740 ,87742,203594 ),
T_JBV(475501, 5073767,466648 ,88740 ,87742,203943 ),
T_JBV(475429, 5073765,466790 ,88740 ,87742,203947 ),
T_JBV(476625, 5073982,478287 ,88740 ,87742,203991 ),
T_JBV(480622, 5074038,466770 ,88740 ,87742,204142 ),
T_JBV(473949, 5074150,453912 ,88740 ,87742,204208 ),
T_JBV(474174, 5074752,463761 ,88740 ,87742,204921 ),
T_JBV(476402, 5074977,465972 ,88740 ,87742,205171 ),
T_JBV(476493, 5074978,466767 ,88740 ,87742,205216 ),
T_JBV(476452, 5075183,494310 ,88740 ,87742,205529 ),
T_JBV(476533, 5075182,486478 ,88740 ,87742,205727 ),
T_JBV(480066, 5075233,486500 ,88740 ,87742,205766 ),
T_JBV(475863, 5075169,466794 ,88740 ,87742,205859 ),
T_JBV(479198, 5075419,499458 ,88740 ,87742,206449 ),
T_JBV(480192, 5075426,499451 ,88740 ,87742,206454 ),
T_JBV(477837, 5075394,499472 ,88740 ,87742,206459 ),
T_JBV(477764, 5075386,499446 ,88740 ,87742,206466 ),
T_JBV(473735, 5075346,477651 ,88740 ,87742,206467 ),
T_JBV(480465, 5075431,452356 ,88740 ,87742,206565 ),
T_JBV(480373, 5075427,458985 ,88740 ,87742,206589 ),
T_JBV(478186, 5075611,478825 ,88740 ,87742,206752 ),
T_JBV(476167, 5075573,486267 ,88740 ,87742,206796 ),
T_JBV(480106, 5075827,483774 ,88740 ,87742,206852 ),
T_JBV(479531, 5075821,466332 ,88740 ,87742,206870 ),
T_JBV(480097, 5075841,479573 ,88740 ,87742,206873 ),
T_JBV(476693, 5075778,491688 ,88740 ,87742,207019 ),
T_JBV(474644, 5075954,462883 ,88740 ,87742,207077 ),
T_JBV(479314, 5076016,486259 ,88740 ,87742,207108 ),
T_JBV(473669, 5076347,455414 ,88740 ,87742,207433 ),
T_JBV(473860, 5076345,456213 ,88740 ,87742,207445 ),
T_JBV(474563, 5076355,498540 ,88740 ,87742,207484 ),
T_JBV(474899, 5076356,466062 ,88740 ,87742,207502 ),
T_JBV(475431, 5076367,479406 ,88740 ,87742,207525 ),
T_JBV(479720, 5076623,477659 ,88740 ,87742,207660 ),
T_JBV(477726, 5076598,497460 ,88740 ,87742,207692 ),
T_JBV(477331, 5076591,452582 ,88740 ,87742,207759 ),
T_JBV(480000, 5076833,444429 ,88740 ,87742,207897 ),
T_JBV(474526, 5076949,456795 ,88740 ,87742,208067 ),
T_JBV(476396, 5076957,480268 ,88740 ,87742,208144 ),
T_JBV(477454, 5076960,453535 ,88740 ,87742,208145 ),
--POSI Y FIRMA
T_JBV(475157, 5070621,499449 ,89382 ,87742,206468 ),
T_JBV(476199, 5070570,491475 ,89382 ,87742,205144 ),
T_JBV(474564, 5070562,499042 ,89382 ,87742,208301 ),
T_JBV(479492, 5070685,491473 ,89382 ,87742,205579 ),
--pbc venta
T_JBV(480039, 5158063,488024 ,87742 ,87742,208670 ),
T_JBV(480617, 5158056,476830 ,87742 ,87742,205385 ),
T_JBV(476732, 5157949,450508 ,87742 ,87742,204499 ),
--pbc reserva
T_JBV(480047, 5157802, 445077,87742 ,87742,208626 )

		); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TRAMITES Y TAREAS');

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	TRA_ID := TRIM(V_TMP_JBV(1));
  	
  	TAR_ID := TRIM(V_TMP_JBV(2));

	ACT_ID := TRIM(V_TMP_JBV(3));

	USU_ID := TRIM(V_TMP_JBV(4));

	SUP_ID := TRIM(V_TMP_JBV(5));
  	
  	ECO_ID := TRIM(V_TMP_JBV(6));


	--COMPROBAMOS SI EXISTE TRABAJO

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = '||ECO_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS > 0 THEN 
	
	--COMPROBAMOS SI EXISTE TAREA

		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS WHERE TRA_ID = '||TRA_ID||' AND TAR_ID = '||TAR_ID||' AND ACT_ID = '||ACT_ID||'';
	
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_1;
	
		IF V_NUM_FILAS_1 > 0 THEN
	
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS 
					   SET USU_ID = '||USU_ID||',
					   SUP_ID = '||SUP_ID||',
					   USUARIOMODIFICAR = '''||V_USR||''',
					   FECHAMODIFICAR = SYSDATE 
					   WHERE TRA_ID = '||TRA_ID||' AND TAR_ID = '||TAR_ID||' AND ACT_ID = '||ACT_ID||'';
	

			EXECUTE IMMEDIATE V_MSQL;
	    
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON TRA_ID: '||TRA_ID||' ACTUALIZADO');
		
			V_COUNT_UPDATE_1 := V_COUNT_UPDATE_1 + 1;
		
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
		END IF;
        
   	ELSE
		
	DBMS_OUTPUT.PUT_LINE('[INFO] EXPEDIENTE NO EXISTE');
		
	END IF; 

   	END LOOP;

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_1||' registros EN TAC_TAREAS_ACTIVOS');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] ');

	COMMIT;

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

--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso	
--## FECHA_CREACION=20211005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10452
--## PRODUCTO=NO
--##
--## Finalidad: Carga masiva
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial => Carga inicial del campo ACT_PAC_PERIMETRO_ACTIVO. 
--##		- Cada merge es una de las condiciones que debe de cumplir. Primero se lanzan todas las condiciones para agrupaciones y después para activos.
--##		- Tiene algunas reglas jerárquicas:
--##	 		- En caso de agrupaciones RESTRINGIDAS siempre el primer merge debe ser el de "aplicaComercial" seguido del de "publicado" el resto da igual el orden. El update al final.
--##	 		- En caso de activos siempre el primer merge debe ser el de "agrupaciones" seguido del de "aplicaComercial" y de "publicado" el resto da igual el orden. El update al final.
--##	 		- En caso de agrupaciones o activos, si se añadiese una nueva regla para marcar dependiendo de otro valor de forma directa: se debería de poner antes "publicados".
--##	 		- En caso de agrupaciones o activos, si se añadiese una nueva regla para marcar como "SI": se debería de poner entre "publicados" y la primera que haya que setee a "0" el campo.
--##	 		- En caso de agrupaciones o activos, si se añadiese una nueva regla para marcar como "NO": se debería de poner entre la primera que haya que setee a "0" el campo y el update final.
--##        0.2 Versión inicial => Carga inicial del campo ACT_PAC_PERIMETRO_ACTIVO. 
--##		- Añadida la regla jerárquica:  "Un activo que sea de la cartera sareb tendrá como estado de visibilidad comercial, su estado de comercialización"	
--##	    0.3 Arreglo: cuando comercializable = 0 -> Visible = 0, siempre y cuando esté publicado
--##		0.4 Modificaciones: Añadido Array de activos y realizados cambios en comprobaciones que no eran correctas
--##	
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10452'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_NUM_TABLAS NUMBER(16);
    V_ACTIVOS VARCHAR2(32000 CHAR):='7270963,
7293663,
7270250,
7277974,
6984272,
6967314,
6971946,
86542,
6060638,
7275037,
5941417,
102448,
5926048,
7433248,
195807,
5946358,
6991178,
124181,
7271684,
6992544,
6992148,
6523306,
6755567,
6967352,
5942048,
7042427,
5960563,
7294895,
5965320,
6936034,
6044831,
7270240,
5963069,
6965892,
6758720,
5956654,
7431602,
7265199,
5929865,
7230469,
6991983,
82129,
7476204,
6965876,
6981180,
6815809,
6755563,
5957256,
7049315,
6965243,
6949816,
6733303,
7270266,
6966971,
7270262,
193314,
5949541,
7277616,
7099695,
5957855,
7099778,
6966793,
7094568,
6965827,
7270243,
5943859,
6780525,
7461637,
5963971,
85990,
7270265,
5960058,
7296433,
6063552,
6965838,
6984366,
6868104,
5951400,
7048728,
7099544,
7258119,
6815775,
7270951,
7270252,
7280235,
7054242,
6965887,
6344513,
6755568,
6992409,
6945125,
7270254,
6059306,
7249926,
7046002,
6755564,
7432158,
6796284,
6791330,
6993119,
7236478,
7278741,
6993670,
7269919,
6965933,
5927409,
7270244,
7433222,
6943739,
189841,
7275161,
6983124,
7263475,
6982667,
6965779,
5943056,
6966874,
7270956,
5950572,
7090517,
7434718,
7035087,
5969597,
6824937,
7402873,
6965688,
6966890,
6877744,
5958504,
7303346,
6857977,
7270278,
6966956,
7319446,
135766,
6997461,
7053689,
7100177,
7277967,
6949804,
6803457,
6966841,
6991823,
6791862,
5943360,
6994323,
5950637,
5958505,
6999320,
7322178,
7270972,
7299643,
147940,
7325083,
6966767,
6966827,
5934958,
113453,
7278462,
6965741,
5935780,
5967717,
6053846,
85162,
7270270,
7230357,
7312196,
5945310,
5952597,
5928805,
6060214,
6967318,
6965924,
6965792,
5951964,
5933219,
7270952,
5966441,
150499,
7276338,
6989105,
7099992,
7403181,
6053785,
6886533,
7270507,
7270267,
5947439,
7001857,
5962375,
6965935,
7266520,
7461497,
6994952,
6994726,
7274864,
7304180,
7314740,
6991322,
7304314,
5960723,
6965860,
5938063,
6983119,
7319243,
6965748,
5926519,
7249730,
82431,
7250410,
6965708,
6762030,
5946310,
7071695,
5971478,
6966870,
7270242,
7004896,
7298460,
6994074,
6710293,
6999266,
6756428,
6965886,
7270970,
6984549,
6859075,
7030094,
7099855,
7316060,
6966925,
6789375,
6814663,
6992614,
7433227,
5966840,
7270255,
7250409,
6885720,
82131,
7270955,
7264565,
6965742,
6965771,
7074348,
6966866,
5933990,
6705599,
6966851,
7230493,
7316582,
6966831,
6966960,
6966882,
5936189,
6967333,
5951461,
159923,
6998198,
6862539,
5933176,
5963547,
5944274,
6965791,
6965718,
5955048,
154466,
6985312,
82724,
5937246,
5957002,
7403273,
6985301,
6868365,
7271323,
150740,
6999299,
6966787,
5948695,
6061021,
5943159,
7270954,
5956925,
7312364,
122963,
7403031,
7270269,
5926047,
6965817,
6346245,
7293668,
7433247,
5939274,
6996843,
6809831,
5926277,
7320826,
6994242,
7249137,
6063328,
5967676,
6965823,
5963022,
6982438,
6803445,
7050181,
7270245,
6966924,
6965898,
6755571,
6996774,
7386543,
6710253,
7473230,
111976,
111745,
6966846,
5933251,
6981249,
6965784,
7270273,
6991989,
7009018,
7224407,
6965772,
5925313,
6967334,
5956918,
91875,
6044853,
6980517,
6815769,
6966907,
6966820,
6966842,
6938794,
6985227,
7270238,
6965751,
7263137,
5951977,
6966786,
7274609,
7432775,
6965894,
117044,
6983323,
5969145,
7270268,
6965793,
6965854,
5950558,
6965812,
6804137,
7074412,
6128118,
107053,
6992407,
5950483,
6965929,
6990070,
6755570,
6965927,
6965692,
6736184,
6965797,
96873,
6801437,
6966957,
7075111,
7271938,
7075376,
7270239,
7048552,
6788375,
7257883,
7270957,
6965818,
6868014,
5941729,
6966836,
7303350,
7049128,
7031821,
6966826,
6052397,
6965826,
6966840,
7250407,
6980042,
5931327,
6868638,
5938747,
6058685,
7299683,
5970124,
7249140,
6965824,
6831748,
7303971,
6971937,
6965800,
6965847,
7006659,
7270274,
5936253,
7226974,
6965901,
7385825,
5931626,
6966844,
6994089,
7386573,
5937143,
6966881,
6966828,
7283131,
6965833,
6996238,
6796986,
7307842,
6967331,
7433253,
6980248,
7270277,
5969373,
6966913,
6803448,
82430,
6979259,
141496,
123996,
7271870,
5940661,
7270960,
7386632,
7270251,
6965788,
5928890,
5936909,
7460808,
6965759,
7296376,
6824903,
7101782,
6965900,
6965713,
6755573,
5929320,
6989208,
6775920,
5934865,
7270257,
6966868,
7433238,
6966850,
84891,
7270297,
6980953,
6984488,
6979879,
5951590,
6993763,
7101480,
5953383,
5934312,
7299115,
7433252,
6992981,
6987191,
91468,
6965806,
6990143,
6997466,
7294162,
117043,
7048477,
6997254,
5928887,
6815806,
7292533,
5960235,
6965926,
6966760,
7434759,
7270508,
6827376,
6999251,
7270276,
7062808,
136060,
6995262,
5931210,
6966855,
7271177,
6965861,
7270259,
5968587,
6965764,
5949804,
6966864,
5948451,
6965908,
7270241,
6965859,
6966824,
5930284,
6965732,
6063593,
7271871,
7270966,
6989106,
6981380,
85073,
6966771,
6830122,
6966999,
7074679,
6995653,
7270248,
147888,
5955010,
5938005,
6965932,
6060267,
5933044,
7048945,
6344612,
7433246,
7014309,
6971939,
7319447,
6984147,
5966119,
6965903,
7270237,
6989009,
6815796,
7310508,
6053293,
6992408,
6966867,
7068960,
7037538,
5965278,
5964247,
6868637,
7020502,
7270953,
6871264,
6998650,
6966778,
6966941,
7265792,
7270249,
6824921,
6993292,
7261151,
6782910,
7241182,
7293671,
6998153,
6980336,
7265779,
5964665,
6965734,
6997226,
6965707,
6965831,
6980135,
5964354,
5926411,
7270949,
6988496,
6980902,
5964004,
7270964,
7049144,
7293732,
7270256,
6946697,
6965746,
6999200,
7270971,
6803419,
7403011,
6936072,
5939357,
6994085,
5933321,
6355145,
111746,
7001663,
7309495,
7035216,
5956367,
7294469,
6965807,
6966900,
7270261,
7270961,
6965762,
7009993,
7396854,
6863627,
6945394,
6857424,
5951246,
6966773,
7460797,
6989588,
6830912,
7049200,
6967316,
6966845,
6966779,
6809735,
6058158,
6787726,
6966765,
6886515,
5925457,
7270263,
5947866,
6965844,
7270969,
6993908,
6991350,
7268108,
6965936,
6965813,
7292319,
6857871,
7293686,
6997301,
7270968,
6965796,
6967321,
7433257,
7226904,
6965825,
6993766,
159926,
6971944,
6055150,
5944477,
7270258,
6128876,
6045063,
7270967,
7250442,
6966972,
7274503,
6872544,
7301087,
7296537,
6973741,
5937158,
6965869,
6710285,
6966822,
7432779,
159925,
6989054,
178001,
7312853,
5938293,
6050507,
6965744,
5934059,
6965843,
5949240,
151073,
6966915,
5943558,
7270271,
7433239,
5931662,
193560,
6965808,
7039159,
6870630,
6991950,
91515,
180051,
6044864,
7314485,
7020503,
7074419,
7272249,
6981274,
5950703,
7230408,
6809793,
6966859,
7224000,
6999436,
6996326,
7270965,
6966973,
179737,
6044748,
7270973,
7308541,
5967133,
7270246,
5941713,
6938298,
6824930,
7049036,
7293710,
85072,
91516,
6965769,
6966780,
6842871,
7035449,
6965815,
6966790,
91517,
6985283,
6966992,
7319244,
6965760,
6052039,
6966893,
7270959,
6966857,
6990572,
6979753,
7001763,
6755569,
6876114,
6965702,
6128753,
5937043,
5966950,
113484,
7271079,
6966878,
6965803,
7062788,
6061020,
7302704,
6991984,
5938383,
6966833,
6999250,
6987011,
6994712,
6870633,
107052,
136377,
5934916,
6965776,
6966975,
6966883,
7270260,
6979257,
5960174,
91514,
5941702,
7270253,
7002222,
6061477,
7016568,
6965923,
135765,
6889282,
139703,
7100030,
6966835,
5929405,
5926345,
6965909,
7034581,
7249136,
7293690,
6981979,
198746,
7270958,
6971931,
6992908,
7270272,
7035326,
6966891,
7270247,
5941036,
6992367,
6994404,
6995159,
7293649,
6966403,
7266542,
5967479,
7266896,
6981236,
6966772,
7240561,
6966927,
6985216,
7276342,
7004938,
7009019,
7270962,
6782918,
6965914,
6809937,
7235255,
7307302,
6980246,
6966783,
6979301,
6869015,
7293707,
6054885,
6965868,
6755566,
5967850,
136106,
7234416,
6967344';

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	DBMS_OUTPUT.PUT_LINE('[Creación de tabla auxiliar de agrupaciones]');
	
	--####################		Creación de la tabla auxiliar de agrupaciones restringidas		###################### 	
	
	V_MSQL := 'SELECT COUNT(1) FROM all_all_tables WHERE TABLE_NAME = UPPER(''aux_vis_gestion_comercial_res'') and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
	IF V_NUM_TABLAS = 1 THEN
		V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.aux_vis_gestion_comercial_res PURGE';
		DBMS_OUTPUT.PUT_LINE('- Drop table auxiliar restringida');
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
	
	V_MSQL:= 'create table '||V_ESQUEMA||'.aux_vis_gestion_comercial_res(
			    act_id NUMBER(16,0),
			    CHECK_VISIBILIDAD  NUMBER(1,0),
			    PRIMARY KEY(act_id)
			)';
			
	DBMS_OUTPUT.PUT_LINE('- Create table auxiliar restringida');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[Inserción de tabla auxiliar de agrupaciones]');

    --JB - INSERTAR ACTIVOS ADICIONALES AL ACTIVO INDICADO
	
	V_MSQL:= 'insert into '||V_ESQUEMA||'.aux_vis_gestion_comercial_res AR (ar.act_id) 
				select DISTINCT A.ACT_ID from '||V_ESQUEMA||'.act_activo a
				join '||V_ESQUEMA||'.act_Aga_agrupacion_activo aga on a.act_id = aga.act_id and aga.borrado = 0
				join '||V_ESQUEMA||'.act_agr_agrupacion agr on agr.agr_id = aga.agr_id and agr.borrado = 0
				join '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tagg on agr.dd_tag_id = tagg.dd_Tag_id and tagg.borrado = 0
				where tagg.dd_tag_codigo = ''02'' and a.borrado = 0  AND agr.agr_fecha_baja is null and a.act_num_activo in ('||V_ACTIVOS||') ';
	
	DBMS_OUTPUT.PUT_LINE('- Actualizar de tabla auxiliar de agrupaciones');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo que sea de la cartera sareb tendrá como estado de visibilidad comercial, su estado de comercialización
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_vis_gestion_comercial_res AUX USING (
			        SELECT a.act_id, pac.PAC_CHECK_COMERCIALIZAR FROM '||V_ESQUEMA||'.ACT_ACTIVO a 
			        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra on  a.dd_Cra_id = cra.dd_Cra_id AND cra.BORRADO = 0
			        JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO pac on a.act_id = pac.act_id  and pac.borrado = 0
                    JOIN '||V_ESQUEMA||'.AUX_VIS_GESTION_COMERCIAL_RES AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
			        WHERE cra.dd_Cra_codigo = ''02''   
			    ) sarebComercializar
			ON (aux.act_id = sarebComercializar.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = sarebComercializar.PAC_CHECK_COMERCIALIZAR
			where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- sarebComercializar');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo que NO esté publicado según el destino comercial que tenga, estará marcado a NO
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_vis_gestion_comercial_res AUX USING (
			    SELECT A.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO a    
			        JOIN '||V_ESQUEMA||'.act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 
			        JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = apu.dd_tco_id and tco.borrado = 0  
                    JOIN '||V_ESQUEMA||'.AUX_VIS_GESTION_COMERCIAL_RES AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
			        LEFT JOIN '||V_ESQUEMA||'.dd_epv_estado_pub_venta epv ON apu.DD_EPV_ID = epv.DD_EPV_ID AND epv.borrado = 0
			        LEFT JOIN '||V_ESQUEMA||'.dd_epa_estado_pub_alquiler epa ON apu.DD_EPA_ID = epa.DD_EPA_ID AND epa.borrado = 0
			        WHERE (tco.dd_tco_codigo = ''01'' AND epv.DD_EPV_CODIGO <> ''03'')  OR (epa.DD_EPA_CODIGO <> ''03'' and  tco.dd_tco_codigo = ''03'') 
			            OR ((epa.DD_EPA_CODIGO <> ''03'' OR epv.DD_EPV_CODIGO <> ''03'') and  tco.dd_tco_codigo = ''02'')   AND a.borrado = 0
			    ) publicados
			ON (aux.act_id = publicados.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
			where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- publicados restringidas');
			
	EXECUTE IMMEDIATE V_MSQL;
	--#############

    --########### -OK-
	-- Un activo NO publicado destino comercial "solo alquiler" estará marcado a NO
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_vis_gestion_comercial_res AUX USING (
			    SELECT A.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO a    
			        JOIN '||V_ESQUEMA||'.act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 
			        JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = apu.dd_tco_id and tco.borrado = 0  
                    JOIN '||V_ESQUEMA||'.AUX_VIS_GESTION_COMERCIAL_RES AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
			        LEFT JOIN '||V_ESQUEMA||'.dd_epa_estado_pub_alquiler epa ON apu.DD_EPA_ID = epa.DD_EPA_ID AND epa.borrado = 0
			        WHERE epa.DD_EPA_CODIGO <>''03'' and  tco.dd_tco_codigo = ''03'' AND a.borrado = 0
			    ) noPublicadosAlquiler
			ON (aux.act_id = noPublicadosAlquiler.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
			where CHECK_VISIBILIDAD is null';
				
	DBMS_OUTPUT.PUT_LINE('- no publicados restringidas');
			
	EXECUTE IMMEDIATE V_MSQL;
	
    --REVISAR NO MIRA SI ESTA PUBLICADO O NO 

	-- Un activo NO publicado de BK estará marcado a NO
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_vis_gestion_comercial_res AUX USING (
			        SELECT a.act_id FROM '||V_ESQUEMA||'.ACT_ACTIVO a 
			        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra on  a.dd_Cra_id = cra.dd_Cra_id AND cra.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.AUX_VIS_GESTION_COMERCIAL_RES AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
                    JOIN '||V_ESQUEMA||'.act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 
                    JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = apu.dd_tco_id and tco.borrado = 0  
                    LEFT JOIN '||V_ESQUEMA||'.dd_epa_estado_pub_alquiler epa ON apu.DD_EPA_ID = epa.DD_EPA_ID AND epa.borrado = 0
                    LEFT JOIN '||V_ESQUEMA||'.dd_epv_estado_pub_venta epv ON apu.DD_EPV_ID = epv.DD_EPV_ID AND epv.borrado = 0
			        WHERE  cra.dd_Cra_codigo = ''03'' AND (tco.dd_tco_codigo = ''01'' AND epv.DD_EPV_CODIGO <> ''03'')  OR (epa.DD_EPA_CODIGO <> ''03'' and  tco.dd_tco_codigo = ''03'') 
			            OR ((epa.DD_EPA_CODIGO <> ''03'' OR epv.DD_EPV_CODIGO <> ''03'') and tco.dd_tco_codigo = ''02'') AND a.borrado = 0        
			    ) sarebBk
			ON (aux.act_id = sarebBk.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
			where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- sarebBk restringidas');
			
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo NO publicado de BBVA que pertenezca a una sociedad participada estará marcado a NO

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_vis_gestion_comercial_res AUX USING (
			        SELECT a.act_id FROM '||V_ESQUEMA||'.ACT_ACTIVO a  
			        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra on  a.dd_Cra_id = cra.dd_Cra_id and cra.BORRADO = 0
			        JOIN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO pac ON a.ACT_ID = pac.act_id  and pac.borrado = 0
			        JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = pac.PRO_ID and pro.borrado = 0
                    JOIN '||V_ESQUEMA||'.AUX_VIS_GESTION_COMERCIAL_RES AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
			        WHERE cra.dd_Cra_codigo = ''16'' AND PRO.PRO_DOCIDENTIF IN (''B63442974'',''B11819935'',''B39488549'')  AND a.BORRADO = 0	   
			    ) participadaBBVA
			ON (aux.act_id = participadaBBVA.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
			where CHECK_VISIBILIDAD is null';
			
	DBMS_OUTPUT.PUT_LINE('- participadaBBVA restringidas');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo NO publicado de Cajamar que esté comercializado estará marcado a NO
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_vis_gestion_comercial_res AUX USING (
			        SELECT a.act_id FROM '||V_ESQUEMA||'.ACT_ACTIVO a 
			        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra on  a.dd_Cra_id = cra.dd_Cra_id AND cra.BORRADO = 0
			        JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO pac on a.act_id = pac.act_id  and pac.borrado = 0
                    JOIN '||V_ESQUEMA||'.act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 
                    JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = apu.dd_tco_id and tco.borrado = 0
					JOIN '||V_ESQUEMA||'.AUX_VIS_GESTION_COMERCIAL_RES AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
			        WHERE cra.dd_Cra_codigo = ''01''  AND a.ACT_VPO = 1			        
			    ) checkCajamar
			ON (aux.act_id = checkCajamar.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
			where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- checkCajamar restringidas');
			
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo NO publicado que tenga fecha de venta externa o que esté comercializado estará marcado a NO
	--REVISAR NO MIRA SI ESTA PUBLICADO O NO, HACE LA VALIDACION PARA TODOS, NO ES CORRECTO, REVISAR SEGURAMENTE INCUMPLE REQUISITO SER COMERCIALIZABLE
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_vis_gestion_comercial_res AUX USING (
			        SELECT a.act_id FROM '||V_ESQUEMA||'.ACT_ACTIVO a 
			        JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO pac on a.act_id = pac.act_id  and pac.borrado = 0
					JOIN '||V_ESQUEMA||'.AUX_VIS_GESTION_COMERCIAL_RES AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
			        WHERE  (pac.PAC_CHECK_COMERCIALIZAR = 0 OR a.act_venta_externa_fecha is not null)    
			    ) ventaExternaNoComercializable
			ON (aux.act_id = ventaExternaNoComercializable.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
			where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- ventaExternaNoComercializable restringidas');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo NO publicado que tenga alquiler de tipo social estará marcado a NO
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_vis_gestion_comercial_res AUX USING (
		        SELECT act.act_id  FROM '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO pta  
		        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO act ON act.ACT_ID = pta.ACT_ID
		        INNER JOIN '||V_ESQUEMA||'.DD_TAL_TIPO_ALQUILER dd ON  dd.dd_tal_id = act.dd_tal_id 
				JOIN '||V_ESQUEMA||'.AUX_VIS_GESTION_COMERCIAL_RES AUX2 ON AUX2.ACT_ID=ACT.act_id and AUX2.CHECK_VISIBILIDAD is null
		        WHERE dd.dd_tal_codigo = ''03''  AND ACT.borrado = 0 AND pta.borrado = 0    
		    ) alquilerSocial
		ON (aux.act_id = alquilerSocial.act_id)
		WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
		where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- alquilerSocial restringidas');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo NO publicado que un expediente en los estados: Firmado, Reservado o Vendido, estará marcado a NO
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_vis_gestion_comercial_res AUX USING (
		        SELECT DISTINCT(a.act_id) FROM '||V_ESQUEMA||'.act_activo a
		        join '||V_ESQUEMA||'.act_ofr aof on a.act_id =aof.act_id
		        join '||V_ESQUEMA||'.ofr_ofertas ofr on aof.ofr_id = ofr.ofr_id AND OFR.BORRADO = 0
		        join '||V_ESQUEMA||'.eco_expediente_comercial eco on eco.ofr_id = ofr.ofr_id AND ECO.BORRADO = 0
		        join '||V_ESQUEMA||'.dd_eec_est_exp_comercial eec on eec.dd_eec_id = eco.dd_eec_id AND EEC.BORRADO = 0
				JOIN '||V_ESQUEMA||'.AUX_VIS_GESTION_COMERCIAL_RES AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
		        WHERE eec.dd_eec_codigo  in (''03'',''06'',''08'') AND A.BORRADO = 0		        
		    ) estadosExpediente
		ON (aux.act_id = estadosExpediente.act_id)
		WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
		where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- estadosExpediente restringidas');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo NO publicado tenga como subfase de publicación alguna de las siguientes: Errores datos,  Excluido publicación estrategia del cliente o Requerimiento legal o administrativo. Estará marcado a NO.
	-- Un activo NO publicado de Cerberus tenga como subfase de publicación alguna de las siguientes: Gestion APIs. Estará marcado a NO.
	-- Un activo NO publicado de Cerberus tenga como fase de publicación alguna de las siguientes: FaseIII. Estará marcado a NO.
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_vis_gestion_comercial_res AUX USING 
		( 
		    WITH ordenado AS
		        (
		            SELECT
		                hfp.dd_sfp_id, hfp.act_id, hfp.dd_fsp_id, ROW_NUMBER() OVER (PARTITION BY hfp.act_id ORDER BY hfp.hfp_id DESC) AS rn
		            FROM
		                '||V_ESQUEMA||'.act_hfp_hist_fases_pub hfp 
						JOIN '||V_ESQUEMA||'.AUX_VIS_GESTION_COMERCIAL_RES AUX2 ON AUX2.ACT_ID=HFP.act_id and AUX2.CHECK_VISIBILIDAD is null
						where hfp.borrado = 0
		        ), toFilter AS (
		            SELECT dd_sfp_id,act_id, dd_fsp_id
		            FROM ordenado
		            WHERE rn = 1
		        )
		        
		        SELECT tofil.act_id, sp.dd_sfp_codigo, fp.dd_fsp_codigo from toFilter tofil
		        left JOIN  '||V_ESQUEMA||'.dd_sfp_subfase_publicacion sp ON tofil.dd_sfp_id = sp.DD_SFP_ID  and sp.borrado = 0
		        left JOIN  '||V_ESQUEMA||'.dd_fsp_fase_publicacion fp ON tofil.dd_fsp_id = fp.dd_fsp_ID  and fp.borrado = 0
		        join '||V_ESQUEMA||'.act_activo a on tofil.act_id = a.act_id and a.borrado = 0
		        join '||V_ESQUEMA||'.dd_Cra_cartera cra on a.dd_Cra_id = cra.dd_cra_id and cra.borrado = 0
				JOIN '||V_ESQUEMA||'.AUX_VIS_GESTION_COMERCIAL_RES AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
		        where (sp.dd_sfp_codigo IN (''15'', ''14'', ''12'')) OR (cra.dd_Cra_codigo = 07 AND (sp.dd_sfp_codigo = ''28'' OR  fp.dd_fsp_codigo = ''05'')) 
		
		) faseOsubfase
		ON (aux.act_id = faseOsubfase.act_id)
		WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
		where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- faseOsubfase restringidas');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL:= 'Update '||V_ESQUEMA||'.aux_vis_gestion_comercial_res
				set check_visibilidad = 1
				where check_visibilidad is null';
				
	DBMS_OUTPUT.PUT_LINE('- Si restantes restringidas');
				
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Dada una agrupación, si alguno de sus activos está marcado como NO, se marcarán todos como NO.
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_vis_gestion_comercial_res AUX USING (
		      WITH agrupados AS
		        (
		            SELECT ares.act_id, ares.check_visibilidad, aga.agr_id FROM '||V_ESQUEMA||'.aux_vis_gestion_comercial_res ares
		            join '||V_ESQUEMA||'.act_aga_agrupacion_activo aga on ares.act_id = aga.act_id 
		            join '||V_ESQUEMA||'.act_agr_agrupacion agr on agr.agr_id = aga.agr_id and agr.borrado = 0
		            join '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tagg on agr.dd_tag_id = tagg.dd_Tag_id and tagg.borrado = 0
		            where tagg.dd_tag_codigo = ''02''   AND agr.agr_fecha_baja is null
		            group by ares.act_id, ares.check_visibilidad, aga.agr_id
		        ), 
		        
		        actagr as(select distinct agr_id from agrupados where check_visibilidad = 0)
		        
		        select a.act_id, 
		        NVL2(agr.agr_id, 0, AUX.check_visibilidad) as check_visibilidad
		        from act_activo a
		        join agrupados aga on a.act_id = aga.act_id
				JOIN '||V_ESQUEMA||'.aux_vis_gestion_comercial_res AUX ON AUX.ACT_ID=A.ACT_ID
		        left join actagr agr on aga.agr_id = agr.agr_id
				where a.borrado = 0
		    ) agrupaciones
		ON (aux.act_id = agrupaciones.act_id)
		WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = agrupaciones.check_visibilidad';
		
	DBMS_OUTPUT.PUT_LINE('- Actualización agrupaciones ');

	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('- Tabla auxiliar de agrupaciones actualizada ');
	
	--####################		Creación de la tabla auxiliar de todos los activos			###################### 	
	
	DBMS_OUTPUT.PUT_LINE('[Creación de tabla auxiliar]');
	
	V_MSQL := 'SELECT COUNT(1) FROM all_all_tables WHERE TABLE_NAME = UPPER(''aux_visibilidad_gestion_comercial'') and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial PURGE';
		DBMS_OUTPUT.PUT_LINE('- Drop tabla auxiliar');
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
			
	
	V_MSQL:= 'create table '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial(
			    act_id NUMBER(16,0),
			    CHECK_VISIBILIDAD  NUMBER(1,0),
			    PRIMARY KEY(act_id)
			)';
			
	DBMS_OUTPUT.PUT_LINE('- Create table auxiliar');	
	
	EXECUTE IMMEDIATE V_MSQL;
			
	V_MSQL:= 'insert into '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AR (ar.act_id) 
				select A.ACT_ID from '||V_ESQUEMA||'.act_activo a where a.borrado = 0 and a.act_num_activo in ('||V_ACTIVOS||')';
				
	DBMS_OUTPUT.PUT_LINE('- Inserción tabla auxiliar');	
	
	EXECUTE IMMEDIATE V_MSQL;
		
	-- Dadas las reglas de agrupaciones restringidas
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX USING (
			    SELECT act_id, CHECK_VISIBILIDAD FROM '||V_ESQUEMA||'.aux_vis_gestion_comercial_res 
			    ) agrupaciones
			ON (aux.act_id = agrupaciones.act_id)
			WHEN MATCHED THEN UPDATE SET aux.CHECK_VISIBILIDAD = agrupaciones.check_visibilidad
			where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- agrupaciones');
	
	EXECUTE IMMEDIATE V_MSQL;

	
	-- ##### A partir de aquí son las mismas restricciones que las de agrupaciones restringidas

	-- Un activo que sea de la cartera sareb tendrá como estado de visibilidad comercial, su estado de comercialización
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX USING (
			        SELECT a.act_id, pac.PAC_CHECK_COMERCIALIZAR FROM '||V_ESQUEMA||'.ACT_ACTIVO a 
			        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra on  a.dd_Cra_id = cra.dd_Cra_id AND cra.BORRADO = 0
			        JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO pac on a.act_id = pac.act_id  and pac.borrado = 0
                    JOIN '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
			        WHERE cra.dd_Cra_codigo = ''02''   
			    ) sarebComercializar
			ON (aux.act_id = sarebComercializar.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = sarebComercializar.PAC_CHECK_COMERCIALIZAR
			where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- sarebComercializar');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo que NO esté publicado según el destino comercial que tenga, estará marcado a NO
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX USING (
			    SELECT A.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO a    
			        JOIN '||V_ESQUEMA||'.act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 
			        JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = apu.dd_tco_id and tco.borrado = 0  
                    JOIN '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
			        LEFT JOIN '||V_ESQUEMA||'.dd_epv_estado_pub_venta epv ON apu.DD_EPV_ID = epv.DD_EPV_ID AND epv.borrado = 0
			        LEFT JOIN '||V_ESQUEMA||'.dd_epa_estado_pub_alquiler epa ON apu.DD_EPA_ID = epa.DD_EPA_ID AND epa.borrado = 0
			        WHERE (tco.dd_tco_codigo = ''01'' AND epv.DD_EPV_CODIGO <> ''03'')  OR (epa.DD_EPA_CODIGO <> ''03'' and  tco.dd_tco_codigo = ''03'') 
			            OR ((epa.DD_EPA_CODIGO <> ''03'' OR epv.DD_EPV_CODIGO <> ''03'') and  tco.dd_tco_codigo = ''02'')   AND a.borrado = 0
			    ) publicados
			ON (aux.act_id = publicados.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
			where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- publicados');
			
	EXECUTE IMMEDIATE V_MSQL;
	--#############

    --########### -OK-
	-- Un activo NO publicado destino comercial "solo alquiler" estará marcado a NO
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX USING (
			    SELECT A.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO a    
			        JOIN '||V_ESQUEMA||'.act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 
			        JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = apu.dd_tco_id and tco.borrado = 0  
                    JOIN '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
			        LEFT JOIN '||V_ESQUEMA||'.dd_epa_estado_pub_alquiler epa ON apu.DD_EPA_ID = epa.DD_EPA_ID AND epa.borrado = 0
			        WHERE epa.DD_EPA_CODIGO <>''03'' and  tco.dd_tco_codigo = ''03'' AND a.borrado = 0
			    ) noPublicadosAlquiler
			ON (aux.act_id = noPublicadosAlquiler.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
			where CHECK_VISIBILIDAD is null';
				
	DBMS_OUTPUT.PUT_LINE('- no publicados');
			
	EXECUTE IMMEDIATE V_MSQL;
	
    --REVISAR NO MIRA SI ESTA PUBLICADO O NO 

	-- Un activo NO publicado de BK estará marcado a NO
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX USING (
			        SELECT a.act_id FROM '||V_ESQUEMA||'.ACT_ACTIVO a 
			        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra on  a.dd_Cra_id = cra.dd_Cra_id AND cra.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
                    JOIN '||V_ESQUEMA||'.act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 
                    JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = apu.dd_tco_id and tco.borrado = 0  
                    LEFT JOIN '||V_ESQUEMA||'.dd_epa_estado_pub_alquiler epa ON apu.DD_EPA_ID = epa.DD_EPA_ID AND epa.borrado = 0
                    LEFT JOIN '||V_ESQUEMA||'.dd_epv_estado_pub_venta epv ON apu.DD_EPV_ID = epv.DD_EPV_ID AND epv.borrado = 0
			        WHERE  cra.dd_Cra_codigo = ''03'' AND (tco.dd_tco_codigo = ''01'' AND epv.DD_EPV_CODIGO <> ''03'')  OR (epa.DD_EPA_CODIGO <> ''03'' and  tco.dd_tco_codigo = ''03'') 
			            OR ((epa.DD_EPA_CODIGO <> ''03'' OR epv.DD_EPV_CODIGO <> ''03'') and tco.dd_tco_codigo = ''02'') AND a.borrado = 0        
			    ) sarebBk
			ON (aux.act_id = sarebBk.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
			where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- sarebBk');
			
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo NO publicado de BBVA que pertenezca a una sociedad participada estará marcado a NO

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX USING (
			        SELECT a.act_id FROM '||V_ESQUEMA||'.ACT_ACTIVO a  
			        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra on  a.dd_Cra_id = cra.dd_Cra_id and cra.BORRADO = 0
			        JOIN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO pac ON a.ACT_ID = pac.act_id  and pac.borrado = 0
			        JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = pac.PRO_ID and pro.borrado = 0
                    JOIN '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
			        WHERE cra.dd_Cra_codigo = ''16'' AND PRO.PRO_DOCIDENTIF IN (''B63442974'',''B11819935'',''B39488549'')  AND a.BORRADO = 0	   
			    ) participadaBBVA
			ON (aux.act_id = participadaBBVA.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
			where CHECK_VISIBILIDAD is null';
			
	DBMS_OUTPUT.PUT_LINE('- participadaBBVA');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo NO publicado de Cajamar que esté comercializado estará marcado a NO
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX USING (
			        SELECT a.act_id FROM '||V_ESQUEMA||'.ACT_ACTIVO a 
			        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra on  a.dd_Cra_id = cra.dd_Cra_id AND cra.BORRADO = 0
			        JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO pac on a.act_id = pac.act_id  and pac.borrado = 0
                    JOIN '||V_ESQUEMA||'.act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 
                    JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = apu.dd_tco_id and tco.borrado = 0
					JOIN '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
			        WHERE cra.dd_Cra_codigo = ''01''  AND a.ACT_VPO = 1			        
			    ) checkCajamar
			ON (aux.act_id = checkCajamar.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
			where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- checkCajamar');
			
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo NO publicado que tenga fecha de venta externa o que esté comercializado estará marcado a NO
	--REVISAR NO MIRA SI ESTA PUBLICADO O NO, HACE LA VALIDACION PARA TODOS, NO ES CORRECTO, REVISAR SEGURAMENTE INCUMPLE REQUISITO SER COMERCIALIZABLE
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX USING (
			        SELECT a.act_id FROM '||V_ESQUEMA||'.ACT_ACTIVO a 
			        JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO pac on a.act_id = pac.act_id  and pac.borrado = 0
					JOIN '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
			        WHERE  (pac.PAC_CHECK_COMERCIALIZAR = 0 OR a.act_venta_externa_fecha is not null)    
			    ) ventaExternaNoComercializable
			ON (aux.act_id = ventaExternaNoComercializable.act_id)
			WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
			where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- ventaExternaNoComercializable');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo NO publicado que tenga alquiler de tipo social estará marcado a NO
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX USING (
		        SELECT act.act_id  FROM '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO pta  
		        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO act ON act.ACT_ID = pta.ACT_ID
		        INNER JOIN '||V_ESQUEMA||'.DD_TAL_TIPO_ALQUILER dd ON  dd.dd_tal_id = act.dd_tal_id 
				JOIN '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX2 ON AUX2.ACT_ID=ACT.act_id and AUX2.CHECK_VISIBILIDAD is null
		        WHERE dd.dd_tal_codigo = ''03''  AND ACT.borrado = 0 AND pta.borrado = 0    
		    ) alquilerSocial
		ON (aux.act_id = alquilerSocial.act_id)
		WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
		where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- alquilerSocial');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo NO publicado que un expediente en los estados: Firmado, Reservado o Vendido, estará marcado a NO
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX USING (
		        SELECT DISTINCT(a.act_id) FROM '||V_ESQUEMA||'.act_activo a
		        join '||V_ESQUEMA||'.act_ofr aof on a.act_id =aof.act_id
		        join '||V_ESQUEMA||'.ofr_ofertas ofr on aof.ofr_id = ofr.ofr_id AND OFR.BORRADO = 0
		        join '||V_ESQUEMA||'.eco_expediente_comercial eco on eco.ofr_id = ofr.ofr_id AND ECO.BORRADO = 0
		        join '||V_ESQUEMA||'.dd_eec_est_exp_comercial eec on eec.dd_eec_id = eco.dd_eec_id AND EEC.BORRADO = 0
				JOIN '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
		        WHERE eec.dd_eec_codigo  in (''03'',''06'',''08'') AND A.BORRADO = 0		        
		    ) estadosExpediente
		ON (aux.act_id = estadosExpediente.act_id)
		WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
		where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- estadosExpediente');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	-- Un activo NO publicado tenga como subfase de publicación alguna de las siguientes: Errores datos,  Excluido publicación estrategia del cliente o Requerimiento legal o administrativo. Estará marcado a NO.
	-- Un activo NO publicado de Cerberus tenga como subfase de publicación alguna de las siguientes: Gestion APIs. Estará marcado a NO.
	-- Un activo NO publicado de Cerberus tenga como fase de publicación alguna de las siguientes: FaseIII. Estará marcado a NO.
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX USING 
		( 
		    WITH ordenado AS
		        (
		            SELECT
		                hfp.dd_sfp_id, hfp.act_id, hfp.dd_fsp_id, ROW_NUMBER() OVER (PARTITION BY hfp.act_id ORDER BY hfp.hfp_id DESC) AS rn
		            FROM
		                '||V_ESQUEMA||'.act_hfp_hist_fases_pub hfp 
						JOIN '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX2 ON AUX2.ACT_ID=HFP.act_id and AUX2.CHECK_VISIBILIDAD is null
						where hfp.borrado = 0
		        ), toFilter AS (
		            SELECT dd_sfp_id,act_id, dd_fsp_id
		            FROM ordenado
		            WHERE rn = 1
		        )
		        
		        SELECT tofil.act_id, sp.dd_sfp_codigo, fp.dd_fsp_codigo from toFilter tofil
		        left JOIN  '||V_ESQUEMA||'.dd_sfp_subfase_publicacion sp ON tofil.dd_sfp_id = sp.DD_SFP_ID  and sp.borrado = 0
		        left JOIN  '||V_ESQUEMA||'.dd_fsp_fase_publicacion fp ON tofil.dd_fsp_id = fp.dd_fsp_ID  and fp.borrado = 0
		        join '||V_ESQUEMA||'.act_activo a on tofil.act_id = a.act_id and a.borrado = 0
		        join '||V_ESQUEMA||'.dd_Cra_cartera cra on a.dd_Cra_id = cra.dd_cra_id and cra.borrado = 0
				JOIN '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial AUX2 ON AUX2.ACT_ID=a.act_id and AUX2.CHECK_VISIBILIDAD is null
		        where (sp.dd_sfp_codigo IN (''15'', ''14'', ''12'')) OR (cra.dd_Cra_codigo = 07 AND (sp.dd_sfp_codigo = ''28'' OR  fp.dd_fsp_codigo = ''05'')) 
		
		) faseOsubfase
		ON (aux.act_id = faseOsubfase.act_id)
		WHEN MATCHED THEN UPDATE SET CHECK_VISIBILIDAD = 0
		where CHECK_VISIBILIDAD is null';
	
	DBMS_OUTPUT.PUT_LINE('- faseOsubfase');
	
	EXECUTE IMMEDIATE V_MSQL;

	
	V_MSQL:= 'Update '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial
				set check_visibilidad = 1
				where check_visibilidad is null';
				
	DBMS_OUTPUT.PUT_LINE('- Si restantes');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	--####################		INSERCIÓN DEL PERÍMETRO			###################### 	
	
	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO pac USING (
		        SELECT aux1.act_id, aux1.CHECK_VISIBILIDAD 
                from '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial aux1 
                inner join '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO pac on pac.act_id = aux1.act_id 
                where pac.PAC_CHECK_GESTION_COMERCIAL <> aux1.CHECK_VISIBILIDAD
		    ) aux
		ON (pac.act_id = aux.act_id)
		WHEN MATCHED THEN UPDATE SET 
		pac.PAC_CHECK_GESTION_COMERCIAL = aux.CHECK_VISIBILIDAD,
		pac.PAC_FECHA_GESTION_COMERCIAL = SYSDATE,
		pac.USUARIOMODIFICAR = '''||V_USU||''',
		pac.FECHAMODIFICAR = SYSDATE
		where pac.borrado = 0';
		
	DBMS_OUTPUT.PUT_LINE('- Actualización de la pac');
	
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.aux_vis_gestion_comercial_res PURGE';
	DBMS_OUTPUT.PUT_LINE('- Borrar tabla aux restringidas');
	EXECUTE IMMEDIATE V_MSQL;
	V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial PURGE';
	DBMS_OUTPUT.PUT_LINE('- Borrar tabla aux');
	EXECUTE IMMEDIATE V_MSQL;
	
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

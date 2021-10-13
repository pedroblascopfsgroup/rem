--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso	
--## FECHA_CREACION=20211013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10585
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
--##        0.5 Modificado para que en el caso de que 1 activo de una agrupacion no tenga el check, no se le quite el check a toda la agrupacion
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10585'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_NUM_TABLAS NUMBER(16);
    V_ACTIVOS VARCHAR2(32000 CHAR):='5925489,
5925623,
5927180,
5928805,
5928887,
5929590,
5934416,
5938383,
5940653,
5942924,
5945584,
5946281,
5946310,
5950809,
5951025,
5951278,
5951530,
5951770,
5955010,
5955048,
5955632,
5958166,
5959644,
5960109,
5960259,
5961085,
5961829,
5962375,
5963773,
5963860,
5963916,
5963971,
5964777,
5965103,
5965853,
5967184,
5967479,
5967681,
5969022,
5969052,
5971501,
6028914,
6030299,
6031712,
6031879,
6034301,
6034665,
6034854,
6035012,
6035013,
6035014,
6035500,
6035758,
6036245,
6036326,
6036405,
6036414,
6036654,
6036655,
6037542,
6037566,
6037568,
6037591,
6037655,
6037773,
6037868,
6038673,
6040458,
6041565,
6041935,
6042125,
6042656,
6042657,
6042747,
6042749,
6042750,
6042759,
6042837,
6042839,
6042984,
6043002,
6043374,
6043452,
6043588,
6044864,
6047286,
6048623,
6058327,
6059306,
6059601,
6061020,
6061477,
6062157,
6062604,
6064467,
6075959,
6076359,
6078586,
6078624,
6078684,
6079039,
6080928,
6081077,
6081182,
6083624,
6353949,
6711118,
6711461,
6756931,
6780617,
6028536,
6031846,
6076010,
6076012,
6076013,
6077699,
6079125,
6079141,
6080406,
6080407,
6080408,
6080423,
6080424,
6080425,
6080426,
6080427,
6080428,
6080429,
6080430,
6080431,
6080432,
6080433,
6080435,
6080436,
6080437,
6080438,
6080439,
6080440,
6080558,
6080969,
6081038,
6081867,
6082179,
6083993,
5936876,
5937140,
5959520,
5968265,
6772890,
6774251,
6780536,
6786928,
6053229,
6803445,
6803498,
6133976,
6134746,
6136345,
6135528,
6136546,
6134280,
6525233,
6756921,
6134101,
6785772,
6789013,
6791277,
6833286,
6831167,
6853843,
6857236,
6856829,
6856551,
6856603,
6856825,
6854671,
6857329,
128628,
6830186,
6833609,
6934270,
6889242,
6818330,
6832616,
6934175,
6934674,
6936034,
6936072,
6938531,
6940472,
6943591,
6946606,
6941158,
6943742,
6946496,
6947569,
6962274,
6963513,
6965678,
6965679,
6965832,
6965842,
6879809,
6966768,
6966845,
6966850,
6966888,
6966968,
6878868,
6972095,
6863627,
6967218,
6986041,
6992741,
6868192,
6868193,
6868391,
6868102,
6869283,
6868404,
6869318,
6866524,
6869544,
6866528,
6867727,
6979879,
6980135,
6980477,
6980527,
6980649,
6980793,
6981040,
6981206,
6981213,
6981316,
6981581,
6983119,
6983124,
6983589,
6984272,
6984549,
6984733,
6985324,
6985920,
6985970,
6986408,
6987406,
6987409,
6988168,
6988259,
6989009,
6990572,
6991350,
6991466,
6991823,
6992243,
6992908,
6993640,
6994074,
6994573,
6994958,
6995216,
6995423,
6995715,
6996224,
6996326,
6996756,
6996895,
6998198,
6998650,
6998900,
6999251,
6999266,
7001641,
7001733,
7001763,
7002222,
7002384,
7007523,
6981236,
6991989,
6875957,
7009018,
7009019,
7234915,
7235321,
7235255,
7238266,
7274053,
7261151,
7263137,
7230357,
7278462,
7232816,
7266896,
7277616,
7230465,
7030121,
7031642,
7031730,
7074419,
7276338,
7074836,
7308282,
7276342,
7310508,
166591,
172672,
172991,
7271938,
7304180,
7304314,
7062807,
7046002,
7049758,
7049200,
7040873,
7042745,
7075726,
7090524,
7090555,
7091539,
7093306,
7230493,
7230408,
7266542,
7100199,
7312364,
7317303,
7100304,
7100545,
7100547,
7100549,
7100550,
7263475,
7101718,
7101731,
7263244,
7225483,
7280235,
7224516,
7224364,
7239967,
7239968,
7239969,
7239970,
7239971,
7239954,
7239955,
7239958,
7239962,
7239964,
7239963,
7239965,
7226629,
7309302,
7263903,
7250407,
7249926,
7234886,
7228683,
7230469,
7228930,
7323838,
7239950,
7239951,
109320,
7293649,
7293663,
7293668,
7293671,
7293686,
7293690,
7293707,
7293710,
7293732,
7294276,
7294533,
6787533,
7294799,
7269086,
7295546,
7296012,
7296364,
7296415,
7296648,
7297060,
7296986,
6053906,
7295329,
7297389,
7297769,
7297455,
7297659,
7297660,
7297663,
7297664,
7297666,
7297667,
7297670,
7297672,
7297674,
7297675,
7297679,
7297680,
7297683,
7297685,
7297686,
7297688,
7297689,
7297690,
7297692,
7297694,
7297695,
7297697,
7297698,
7297703,
7297705,
7297707,
7297709,
7297717,
7297721,
7297662,
7316128,
7316129,
7316130,
7316131,
7316132,
7316133,
7316145,
7316146,
7316147,
7316148,
7316149,
7316150,
7316151,
7316152,
7316153,
7316154,
7297804,
7298452,
7297914,
7297919,
7297922,
7297930,
7297933,
7297938,
7297939,
7297942,
7297944,
7297954,
7297956,
7297960,
7297962,
7297967,
7297969,
7297978,
7297989,
7297993,
7297996,
7297997,
7298006,
7298008,
7298012,
7298519,
7298543,
108139,
7234794,
7267444,
6734354,
6736302,
6734957,
6726209,
6741824,
6740179,
6730323,
6720125,
6731100,
6744335,
6743550,
6730965,
6730228,
6723856,
6721660,
6715226,
6742378,
6736184,
6728460,
6735634,
6733303,
6716081,
6729644,
6725757,
7300131,
7277967,
7277974,
7300298,
7300275,
7300286,
7300278,
7300291,
7300309,
7300287,
7300328,
7300279,
7300314,
7300292,
7300288,
7300300,
7300277,
7300289,
7300284,
7300295,
7300299,
7300325,
7300316,
7300281,
7300440,
7300676,
7300658,
7300646,
7300655,
7300667,
7300660,
7300640,
7300686,
7300657,
7300649,
7300639,
7300650,
7300670,
7300680,
7300662,
7300663,
7300672,
7300682,
7300690,
7300644,
7300664,
7300673,
7300689,
7301015,
7248703,
7250384,
7268108,
7278838,
7278836,
7278817,
7278834,
7278833,
7278832,
7278831,
7258119,
7303624,
7321957,
7307302,
7302450,
7302383,
7302466,
7303431,
7328479,
7330030,
7330042,
7330113,
6723965,
7387131,
7324621,
7396777,
7403200,
7423570,
7423849,
7424180,
99001,
7324029,
7323938,
7323887,
7323744,
7323745,
7323757,
7323762,
7323808,
7323823,
7323830,
7323837,
7323836,
7323840,
7312853,
7322178,
7455667,
7473752';

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
                where pac.PAC_CHECK_GESTION_COMERCIAL <> aux1.CHECK_VISIBILIDAD or PAC.PAC_CHECK_GESTION_COMERCIAL IS NULL
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
	
	/*V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.aux_vis_gestion_comercial_res PURGE';
	DBMS_OUTPUT.PUT_LINE('- Borrar tabla aux restringidas');
	EXECUTE IMMEDIATE V_MSQL;
	V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.aux_visibilidad_gestion_comercial PURGE';
	DBMS_OUTPUT.PUT_LINE('- Borrar tabla aux');
	EXECUTE IMMEDIATE V_MSQL;*/
	
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
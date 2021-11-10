--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso	
--## FECHA_CREACION=20211006
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10452_2'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_NUM_TABLAS NUMBER(16);
    V_ACTIVOS VARCHAR2(32000 CHAR):='107956,
5925581,
5928449,
5934354,
5934454,
5935814,
5938864,
5939018,
5939237,
5940151,
5942154,
5942735,
5942737,
5944848,
5947172,
5947707,
5948156,
5949241,
5950128,
5952215,
5952261,
5952694,
5953432,
5955612,
5956005,
5957637,
5961119,
5961328,
5962513,
5964521,
5964997,
5965123,
5965549,
5968020,
5968185,
5969834,
6042125,
6044711,
6044721,
6044728,
6044757,
6052654,
6052655,
6052695,
6052726,
6052999,
6053039,
6053075,
6053617,
6053618,
6063469,
6063470,
6064467,
6064468,
6079273,
6079459,
6079460,
6079461,
6743267,
6780522,
6780536,
6798779,
6800301,
6809999,
6831207,
6831211,
6865060,
6868093,
6875957,
6945115,
6945127,
6947569,
6947587,
6965780,
6965790,
6965889,
6965912,
6966837,
6966879,
6966908,
6966909,
6966921,
6966923,
6966929,
6972076,
6972095,
6993847,
6993848,
6997672,
6997697,
7012957,
7013320,
7039140,
7076247,
7089074,
7097472,
7097527,
7097530,
7097538,
7225475,
7225477,
7225478,
7225486,
7225487,
7225492,
7225495,
7226625,
7230465,
7234794,
7234822,
7234886,
7234915,
7234972,
7235056,
7235109,
7235111,
7235153,
7235237,
7235246,
7235249,
7235307,
7235321,
7235327,
7235791,
7238266,
7242731,
7243670,
7260925,
7263244,
7263903,
7264942,
7265325,
7270004,
7270912,
7270931,
7271046,
7271113,
7271183,
7271884,
7272588,
7274053,
7295023,
7296796,
7433222,
7433227,
7433238,
7433239,
7433246,
7433247,
7433248,
7433252,
7433253,
7433257,
7473707,
7473755';

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

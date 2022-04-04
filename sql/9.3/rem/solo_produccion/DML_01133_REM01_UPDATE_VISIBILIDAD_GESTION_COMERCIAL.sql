--/*
--##########################################
--## AUTOR=Cristian Montoya	
--## FECHA_CREACION=20220218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11185
--## PRODUCTO=NO
--##
--## Finalidad: Carga masiva
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial 
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-11185'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_NUM_TABLAS NUMBER(16);

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
                join '||V_ESQUEMA||'.AUX_REMVIP_11169 AUX ON AUX.ACTIVO=a.act_num_activo
				where tagg.dd_tag_codigo = ''02'' and a.borrado = 0  AND agr.agr_fecha_baja is null ';
	
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
			            OR ((epa.DD_EPA_CODIGO <> ''03'' AND epv.DD_EPV_CODIGO <> ''03'') and  tco.dd_tco_codigo = ''02'')   AND a.borrado = 0
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
			            OR ((epa.DD_EPA_CODIGO <> ''03'' AND epv.DD_EPV_CODIGO <> ''03'') and tco.dd_tco_codigo = ''02'') AND a.borrado = 0        
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
			        WHERE cra.dd_Cra_codigo = ''01'' AND a.ACT_VPO = 1			        
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
				JOIN '||V_ESQUEMA||'.act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 
				JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = apu.dd_tco_id and tco.borrado = 0  
		        WHERE eec.dd_eec_codigo  in (''03'',''06'',''08'') AND TCO.DD_TCO_CODIGO=''01''  AND A.BORRADO = 0	
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
				select A.ACT_ID from '||V_ESQUEMA||'.act_activo a
                join '||V_ESQUEMA||'.AUX_REMVIP_11169 AUX ON AUX.ACTIVO=A.ACT_NUM_ACTIVO
                where a.borrado = 0';
				
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
			            OR ((epa.DD_EPA_CODIGO <> ''03'' AND epv.DD_EPV_CODIGO <> ''03'') and  tco.dd_tco_codigo = ''02'')   AND a.borrado = 0
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
			            OR ((epa.DD_EPA_CODIGO <> ''03'' AND epv.DD_EPV_CODIGO <> ''03'') and tco.dd_tco_codigo = ''02'') AND a.borrado = 0        
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
				JOIN '||V_ESQUEMA||'.act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 
				JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = apu.dd_tco_id and tco.borrado = 0  
		        WHERE eec.dd_eec_codigo  in (''03'',''06'',''08'') AND TCO.DD_TCO_CODIGO=''01''  AND A.BORRADO = 0		        
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
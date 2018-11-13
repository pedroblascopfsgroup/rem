package es.pfsgroup.framework.paradise.bulkUpload.api.impl;


import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;

@Service
@Transactional(readOnly = false)
public class ParticularValidatorManager implements ParticularValidatorApi {

	@Autowired
	private MSVRawSQLDao rawDao;
	
	@Override
	public String getOneNumActivoAgrupacionRaw(String numAgrupacion){
		return rawDao.getExecuteSQL("SELECT TO_NUMBER(act.ACT_NUM_ACTIVO) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO aga, "
				+ "			    ACT_AGR_AGRUPACION agr, "
				+ "			    ACT_ACTIVO act "
				+ "			  WHERE aga.AGR_ID = agr.AGR_ID "
				+ "			    AND act.act_id   = aga.act_id "
				+ "			    AND agr.AGR_NUM_AGRUP_REM  = '"+numAgrupacion+"' "
				+ "			    AND DECODE(aga.BORRADO, null, 0, aga.BORRADO)  = 0 "
				+ "			    AND DECODE(agr.BORRADO, null, 0, agr.BORRADO)  = 0 "
				+ "			    AND DECODE(act.BORRADO, null, 0, act.BORRADO)  = 0 "
				+ "				AND ROWNUM = 1 ");
	}
	
	public String getCarteraLocationByNumAgr (String numAgr) {		
		String tagId = rawDao.getExecuteSQL("SELECT DD_TAG_ID "
				+ "		  FROM ACT_AGR_AGRUPACION WHERE"
				+ " 		AGR_NUM_AGRUP_REM = "+numAgr
				+ "			AND BORRADO = 0"				
				+ "         AND ROWNUM = 1 ");
		
		if (tagId == null) return null;
		
		String cartera = rawDao.getExecuteSQL("SELECT ACT.DD_CRA_ID "
				+ "		  FROM ACT_AGR_AGRUPACION AGR, ACT_AGA_AGRUPACION_ACTIVO AGA, ACT_ACTIVO ACT WHERE"
				+ " 		AGR.AGR_NUM_AGRUP_REM = "+numAgr+" AND AGR.AGR_ID = AGA.AGR_ID AND AGA.ACT_ID = ACT.ACT_ID "
				+ " 		AND ACT.BORRADO = 0"
				+ " 		AND AGR.BORRADO = 0"
				+ " 		AND AGA.BORRADO = 0"				
				+ "         AND ROWNUM = 1 ");
		
		if (cartera == null) cartera = "";
		
		if (tagId.equals("1")) {
			return rawDao.getExecuteSQL("SELECT '"+cartera+"-'||ONV.DD_PRV_ID||'-'||ONV.DD_LOC_ID||'-'||ONV.ONV_CP "
					+ "		  FROM ACT_ONV_OBRA_NUEVA ONV, ACT_AGR_AGRUPACION AGR WHERE"
					+ " 		AGR.AGR_NUM_AGRUP_REM = "+numAgr+" AND AGR.AGR_ID = ONV.AGR_ID"
					+ "         AND ROWNUM = 1 ");
		} else if (tagId.equals("2")) {
			return rawDao.getExecuteSQL("SELECT '"+cartera+"-'||RES.DD_PRV_ID||'-'||RES.DD_LOC_ID||'-'||RES.RES_CP||'-PROPIETARIO-'|| PAC.PRO_ID "
					+ "		  FROM ACT_RES_RESTRINGIDA RES, ACT_AGR_AGRUPACION AGR, ACT_AGA_AGRUPACION_ACTIVO AGA, ACT_ACTIVO ACT, ACT_PAC_PROPIETARIO_ACTIVO PAC WHERE"
					+ " 		AGR.AGR_NUM_AGRUP_REM = "+numAgr+" AND AGR.AGR_ID = RES.AGR_ID AND AGA.AGR_ID = AGR.AGR_ID AND"
					+ " 		AGA.ACT_ID = ACT.ACT_ID AND PAC.ACT_ID = ACT.ACT_ID"
					+ " 		AND ACT.BORRADO = 0"
					+ " 		AND AGR.BORRADO = 0"
					+ " 		AND AGA.BORRADO = 0"
					+ "         AND ROWNUM = 1 ");
		}
		return null;
	}
	
	public String getCarteraLocationByNumAct (String numActive) {
		return rawDao.getExecuteSQL("SELECT ACT.DD_CRA_ID||'-'||DD_PRV_ID||'-'||DD_LOC_ID||'-'||BIE_LOC_COD_POST "
							+ "		  FROM ACT_ACTIVO ACT, BIE_LOCALIZACION BIE WHERE"
							+ " 		ACT.ACT_NUM_ACTIVO = "+numActive+" "
							+ " 		AND ACT.BIE_ID=BIE.BIE_ID"
							+ " 		AND ACT.BORRADO = 0"
							+ " 		AND BIE.BORRADO = 0"							
							+ "         AND ROWNUM = 1 ");
	}
	
	public String getCarteraLocationTipPatrimByNumAct (String numActive) {
		return rawDao.getExecuteSQL("SELECT ACT.DD_CRA_ID||'-'||DD_PRV_ID||'-'||DD_LOC_ID||'-'||BIE_LOC_COD_POST||'-PROPIETARIO-'||PAC.PRO_ID "
							+ "		  FROM ACT_ACTIVO ACT, BIE_LOCALIZACION BIE, ACT_PAC_PROPIETARIO_ACTIVO PAC WHERE"
							+ " 		ACT.ACT_NUM_ACTIVO = "+numActive+" "
							+ " 		AND ACT.BIE_ID=BIE.BIE_ID"
							+ "			AND PAC.ACT_ID =  ACT.ACT_ID"
							+ " 		AND ACT.BORRADO = 0"
							+ " 		AND BIE.BORRADO = 0"
							+ "         AND ROWNUM = 1 ");
	}

	@Override
	public Boolean esMismaCarteraLocationByNumAgrupRem (String numAgrupRem){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.ACT_ID) " 
							+ "		  FROM ACT_AGA_AGRUPACION_ACTIVO aga, ACT_AGR_AGRUPACION agr, ACT_ACTIVO act, BIE_LOCALIZACION loc "
							+ "		  WHERE  "
							+ "		  aga.AGR_ID = agr.AGR_ID "
							+ "		  AND aga.ACT_ID = act.ACT_ID "
							+ "		  AND act.BIE_ID = loc.BIE_ID "
							+ "		  AND agr.AGR_NUM_AGRUP_REM = "+numAgrupRem+" "
							+ "		  GROUP BY act.DD_CRA_ID, loc.DD_PRV_ID, loc.DD_LOC_ID, loc.BIE_LOC_COD_POST ");
		if("1".equals(resultado))
			return true;
		else
			return false;
	}
	
	@Override
	public String existeActivoEnAgrupacion(Long idActivo, Long idAgrupacion) {
		return rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		  FROM ACT_AGA_AGRUPACION_ACTIVO WHERE"
				+ " 		ACT_ID = "+idActivo+" "
				+ " 		AND AGR_ID = "+idAgrupacion+" "
				+ "			AND BORRADO = 0");
	}
	
	@Override
	public Boolean activoEnAgrupacionRestringida(Long idActivo) {
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(aga.AGR_ID) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO aga, "
				+ "			    ACT_AGR_AGRUPACION agr, "
				+ "			    ACT_ACTIVO act, "
				+ "			    DD_TAG_TIPO_AGRUPACION tipoAgr "
				+ "			  WHERE aga.AGR_ID = agr.AGR_ID "
				+ "			    AND act.act_id   = aga.act_id "
				+ "			    AND tipoAgr.DD_TAG_ID = agr.DD_TAG_ID "
				+ "			    AND act.ACT_NUM_ACTIVO = "+idActivo+" "
				+ "			    AND tipoAgr.DD_TAG_CODIGO = '02' "
				+ "				AND agr.AGR_FECHA_BAJA is null"
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND agr.BORRADO  = 0 "
				+ "			    AND act.BORRADO  = 0 ");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}

	
	
	@Override
	public Boolean esActivoEnAgrupacion(Long numActivo, Long numAgrupacion) {
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(aga.AGR_ID) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO aga, "
				+ "			    ACT_AGR_AGRUPACION agr, "
				+ "			    ACT_ACTIVO act "
				+ "			  WHERE aga.AGR_ID = agr.AGR_ID "
				+ "			    AND act.act_id   = aga.act_id "
				+ "			    AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			    AND agr.AGR_NUM_AGRUP_REM  = "+numAgrupacion+" "
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND agr.BORRADO  = 0 "
				+ "			    AND act.BORRADO  = 0 ");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean esActivoEnAgrupacionPorTipo(Long numActivo, String codTipoAgrupacion) {
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(aga.AGR_ID) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO aga, "
				+ "			    ACT_AGR_AGRUPACION agr, "
				+ "			    DD_TAG_TIPO_AGRUPACION tag, "
				+ "			    ACT_ACTIVO act "
				+ "			  WHERE aga.AGR_ID = agr.AGR_ID "
				+ "			    AND agr.dd_tag_id = tag.dd_tag_id "
				+ "			    AND act.act_id   = aga.act_id "
				+ "			    AND tag.dd_tag_codigo = '"+codTipoAgrupacion+"' "
				+ "			    AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND agr.BORRADO  = 0 "
				+ "			    AND act.BORRADO  = 0 ");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esActivoEnOtraAgrupacion(Long numActivo, Long numAgrupacion) {
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(aga.AGR_ID) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO aga, "
				+ "			    ACT_AGR_AGRUPACION agr, "
				+ "			    ACT_ACTIVO act "
				+ "			  WHERE aga.AGR_ID = agr.AGR_ID "
				+ "			    AND act.act_id   = aga.act_id "
				+ "			    AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			    AND agr.AGR_NUM_AGRUP_REM  <> "+numAgrupacion+" "
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND agr.BORRADO  = 0 "
				+ "			    AND act.BORRADO  = 0 ");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean existeActivo(String numActivo){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_ACTIVO WHERE"
				+ "		 	ACT_NUM_ACTIVO ="+numActivo+" "
				+ "		 	AND BORRADO = 0");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}

	@Override
	public Boolean isActivoPrePublicable(String numActivo){
		if(isActivoGestionAdmision(numActivo) && isActivoUltimoInformeComercialAceptado(numActivo))
			return true;
		else
			return false;
	}

	private Boolean isActivoGestionAdmision(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		 FROM ACT_ACTIVO WHERE "
				+ "			ACT_ADMISION = 1 "
				+ "			AND ACT_ADMISION = 1 "
				+ "		 	AND ACT_NUM_ACTIVO ="+numActivo+" "
				+ "		 	AND BORRADO = 0");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	private Boolean isActivoUltimoInformeComercialAceptado(String numActivo){
		String resultado = rawDao.getExecuteSQL("select count(1) from ( "
				+ "		 	  select dd_aic_codigo from ( "
				+ "		 	    select aic.dd_aic_codigo "
				+ "		 	    from ACT_ACTIVO act, "
				+ "		 	         ACT_HIC_EST_INF_COMER_HIST hic, "
				+ "		 	         DD_AIC_ACCION_INF_COMERCIAL aic "
				+ "		 	    where act.act_id = hic.act_id "
				+ "		 	      and hic.dd_aic_id = aic.dd_aic_id "
				+ "		 	      AND ACT_NUM_ACTIVO = "+numActivo+" "
				+ "		 	      AND act.BORRADO = 0 "
				+ "		 	      AND hic.BORRADO = 0 "
				+ "		 	      AND aic.BORRADO = 0 "
				+ "		 	    order by hic.HIC_ID desc "
				+ "		 	  ) "
				+ "		 	  where rownum = 1 "
				+ "		 	) "
				+ "		 	where dd_aic_codigo = '02' "
				);
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean estadoNoPublicadoOrNull(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO ="+numActivo+" "
				+ "			AND BORRADO = 0 "
				+ "			AND ( DD_EPU_ID IS NULL "
				+ "			      OR DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				     FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				     WHERE DD_EPU_CODIGO IN ('06')) )");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean estadoOcultaractivo(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO ="+numActivo+" "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('01'))");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean estadoDesocultaractivo(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO ="+numActivo+" "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('03'))");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean estadoOcultarprecio(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO ="+numActivo+" "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('01','02'))");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean estadoDesocultarprecio(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO ="+numActivo+" "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('04','07'))");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean estadoDespublicar(String numActivo){
		//Despublicar Forzado solo admite activos en estado publicado (ordinario)
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO ="+numActivo+" "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('01'))");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean estadosValidosDespublicarForzado(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO ="+numActivo+" "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('02', '07'))");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	public Boolean estadosValidosDesDespublicarForzado(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO ="+numActivo+" "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('05'))");
		if("0".equals(resultado))
			return false;
		else
			return true;		
	}
	
	@Override
	public Boolean estadoAutorizaredicion(String numActivo){
		return true;
	}
	
	@Override
	public Boolean existeBloqueoPreciosActivo(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO ="+numActivo+" "
				+ "			AND BORRADO = 0"
				+ "			AND ACT_BLOQUEO_PRECIO_FECHA_INI IS NOT NULL");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean existeOfertaAprobadaActivo(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO ACT, ACT_OFR AO, OFR_OFERTAS OFR, DD_EOF_ESTADOS_OFERTA ESO WHERE"
				+ "         AO.ACT_ID = ACT.ACT_ID"
				+ "         AND AO.OFR_ID = OFR.OFR_ID"
				+ "         AND OFR.DD_EOF_ID = ESO.DD_EOF_ID"
				+ "			AND ACT.ACT_NUM_ACTIVO ="+numActivo+" "
				+ "         AND ESO.DD_EOF_CODIGO = '01'"
				+ "			AND ACT.BORRADO = 0"
				+ "			AND OFR.BORRADO = 0"
				+ "			AND ACT.ACT_BLOQUEO_PRECIO_FECHA_INI IS NOT NULL");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}

	@Override
	public Boolean esActivoConVentaOferta(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM DD_SCM_SITUACION_COMERCIAL scm, "
				+ "			  ACT_ACTIVO act "
				+ "			WHERE scm.dd_scm_id   = act.dd_scm_id "
				+ "			  AND scm.dd_scm_codigo = '03' "
				+ "			  AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			  AND act.borrado       = 0");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean esActivoVendido(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM DD_SCM_SITUACION_COMERCIAL scm, "
				+ "			  ACT_ACTIVO act "
				+ "			WHERE scm.dd_scm_id   = act.dd_scm_id "
				+ "			  AND scm.dd_scm_codigo = '05' "
				+ "			  AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			  AND act.borrado       = 0");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean esActivoIncluidoPerimetro(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT act.ACT_ID "
				+ "		FROM ACT_ACTIVO act "
				+ "		LEFT JOIN ACT_PAC_PERIMETRO_ACTIVO pac "
				+ "		ON act.ACT_ID            = pac.ACT_ID "
				+ "		WHERE " 
				+ "		(pac.PAC_INCLUIDO = 1 or pac.PAC_ID is null)"
				+ "		AND act.ACT_NUM_ACTIVO = "+numActivo+" ");
		if(Checks.esNulo(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean esActivoAsistido (String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		FROM ACT_ACTIVO act "
				+ "		INNER JOIN DD_SCR_SUBCARTERA scr "
				+ "		ON act.DD_SCR_ID            = scr.DD_SCR_ID "
				+ "		WHERE " 
				+ "		scr.DD_SCR_CODIGO IN ('01','02','03','38') "
				+ "		AND act.ACT_NUM_ACTIVO = "+numActivo+" ");
		
		String resultado2 = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		FROM ACT_ACTIVO act "
				+ "		INNER JOIN ACT_ABA_ACTIVO_BANCARIO aba "
				+ "		ON act.act_id            = aba.act_id "
				+ "		INNER JOIN DD_CLA_CLASE_ACTIVO cla "
				+ "		ON aba.dd_cla_id            = cla.dd_cla_id "
				+ "		WHERE " 
				+ "		cla.DD_CLA_CODIGO = '01' "
				+ "		AND act.ACT_NUM_ACTIVO = "+numActivo+" ");
		if("0".equals(resultado) && "0".equals(resultado2))
			return false;
		else
			return true;
	}

	@Override
	public Boolean esAgrupacionConBaja (String numAgrupacion){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		FROM ACT_AGR_AGRUPACION agr "
				+ "		WHERE " 
				+ "		agr.AGR_FECHA_BAJA IS NOT NULL "
				+ "		AND agr.AGR_NUM_AGRUP_REM = "+numAgrupacion+" ");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean esActivosMismaLocalizacion (String inSqlNumActivosRem){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(COUNT(1)) "
				+ "			  FROM ACT_ACTIVO act, BIE_LOCALIZACION loc "
				+ "			WHERE act.BIE_ID = loc.BIE_ID "
				+ "			  AND act.ACT_NUM_ACTIVO IN ("+inSqlNumActivosRem+") "
				+ "			  AND act.BORRADO = 0 "
				+ "			  AND loc.BORRADO = 0 "
				+ "			GROUP BY act.DD_CRA_ID, loc.DD_PRV_ID, loc.DD_LOC_ID, loc.BIE_LOC_COD_POST");
		if("1".equals(resultado))
			return true;
		else
			return false;
	}
	
	@Override
	public Boolean esActivosMismoPropietario (String inSqlNumActivosRem){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(COUNT(1)) "
				+ "			    FROM ACT_PAC_PROPIETARIO_ACTIVO pac, "
				+ "			      ACT_ACTIVO act "
				+ "			    WHERE act.act_id       = pac.act_id "
				+ "			      AND act.ACT_NUM_ACTIVO IN ("+inSqlNumActivosRem+") "
				+ "			      AND pac.BORRADO  = 0 "
				+ "			      AND act.BORRADO  = 0 "
				+ "			    GROUP BY pac.PRO_ID ");
		if("1".equals(resultado))
			return true;
		else
			return false;
	}
	
	@Override
	public Boolean esActivosMismaCartera (String inSqlNumActivosRem, String agrupacion){
		
		String[] lista = inSqlNumActivosRem.split(",");
		List<String> listaActivosAAnyadir = new ArrayList<String>();
		
		for(int i = 0; i<lista.length; i++){
			listaActivosAAnyadir.add(lista[i]);
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT DISTINCT act.dd_cra_id"
				+" FROM ACT_AGR_AGRUPACION aaa"
				+" JOIN ACT_AGA_AGRUPACION_ACTIVO aga ON aaa.AGR_ID = aga.AGR_ID AND aaa.AGR_NUM_AGRUP_REM = " + agrupacion
				+" JOIN ACT_ACTIVO act ON aga.act_id = act.act_id"
				+" JOIN DD_CRA_CARTERA cra ON cra.DD_CRA_ID = act.DD_CRA_ID"
				+" AND aaa.BORRADO  = 0  AND act.BORRADO  = 0");
		
		if(!Checks.esNulo(resultado)){
			for(String a: listaActivosAAnyadir){
				String carteraActivo = rawDao.getExecuteSQL("SELECT dd_cra_id"
						+" FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = " + a);
				
				if(!resultado.equals(carteraActivo)){
					return false;
				}
			}
		}else{
			Boolean esPrimero = true;
			String referencia = "";
			for(String a: listaActivosAAnyadir){
				String carteraActivo = rawDao.getExecuteSQL("SELECT dd_cra_id"
						+" FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = " + a);
				
				if(!esPrimero){
					if(!Checks.esNulo(resultado)){
						if(!resultado.equals(carteraActivo)){
							return false;
						}
					}else{
						carteraActivo = rawDao.getExecuteSQL("SELECT dd_cra_id"
						+" FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = " + a);
						
						if(!referencia.equals(carteraActivo)){
							return false;
						}
					}	
				}else{
					esPrimero = false;
					referencia = carteraActivo;
				}
			}
		}
		
		return true;
	}
	
	@Override
	public Boolean esActivosOfertasAceptadas (String inSqlNumActivosRem, String numAgrupRem){
		String sql =
				"SELECT "
				+ "  ( "
				+ "    SELECT COUNT(aof1.act_id) "
				+ "    FROM OFR_OFERTAS ofr1 "
				+ "    INNER JOIN ACT_OFR aof1 on ofr1.ofr_id = aof1.ofr_id "
				+ "    INNER JOIN ACT_ACTIVO act1 on aof1.act_id = act1.act_id "
				+ "    INNER JOIN DD_EOF_ESTADOS_OFERTA eof1 on ofr1.dd_eof_id = eof1.dd_eof_id "
				+ "    WHERE "
				+ "      eof1.dd_eof_codigo = '01' " // --Oferta Aceptada (en activos)
				+ "      AND act1.act_num_activo in ("+inSqlNumActivosRem+") "
				+ "      AND ofr1.borrado = 0 "
				+ "  )  + "
				+ "  ( "
				+ "    SELECT COUNT(aof1.act_id) "
				+ "    FROM OFR_OFERTAS ofr1 "
				+ "    INNER JOIN ACT_OFR aof1 on ofr1.ofr_id = aof1.ofr_id "
				+ "    INNER JOIN ACT_AGA_AGRUPACION_ACTIVO aga1 on aof1.act_id = aga1.act_id "
				+ "    INNER JOIN ACT_AGR_AGRUPACION agr1 on aga1.agr_id = agr1.agr_id "
				+ "    INNER JOIN DD_EOF_ESTADOS_OFERTA eof1 on ofr1.dd_eof_id = eof1.dd_eof_id "
				+ "    WHERE "
				+ "      eof1.dd_eof_codigo = '01' " // --Oferta Aceptada (en activos de la agrupacion)
				+ "      AND agr1.agr_num_agrup_rem = "+numAgrupRem+"  "
				+ "      AND ofr1.borrado = 0 "
				+ "      AND aga1.borrado = 0 "
				+ "      AND agr1.borrado = 0 "
				+ "  )  + "
				+ "  ( "
				+ "    SELECT COUNT(aga1.agr_id) "
				+ "    FROM OFR_OFERTAS ofr1 "
				+ "    INNER JOIN ACT_AGA_AGRUPACION_ACTIVO aga1 on ofr1.agr_id = aga1.agr_id "
				+ "    INNER JOIN ACT_AGR_AGRUPACION agr1 on aga1.agr_id = agr1.agr_id "
				+ "    INNER JOIN DD_EOF_ESTADOS_OFERTA eof1 on ofr1.dd_eof_id = eof1.dd_eof_id "
				+ "    WHERE "
				+ "      eof1.dd_eof_codigo = '01' " // --Oferta Aceptada (en agrupacion)
				+ "      AND agr1.agr_num_agrup_rem = "+numAgrupRem+"  "
				+ "      AND ofr1.borrado = 0 "
				+ "      AND aga1.borrado = 0 "
				+ "      AND agr1.borrado = 0 "
				+ "  )  + "
				+ "  ( "
				+ "    SELECT COUNT(aga1.agr_id) "
				+ "    FROM OFR_OFERTAS ofr1 "
				+ "    INNER JOIN ACT_AGA_AGRUPACION_ACTIVO aga1 on ofr1.agr_id = aga1.agr_id "
				+ "    INNER JOIN ACT_AGR_AGRUPACION agr1 on aga1.agr_id = agr1.agr_id "
				+ "    INNER JOIN ACT_ACTIVO act1 on aga1.act_id = act1.act_id "
				+ "    INNER JOIN DD_EOF_ESTADOS_OFERTA eof1 on ofr1.dd_eof_id = eof1.dd_eof_id "
				+ "    WHERE "
				+ "      eof1.dd_eof_codigo = '01' " // --Oferta Aceptada (en otras agrupaciones de los activos)
				+ "      AND act1.act_num_activo in ("+inSqlNumActivosRem+") "
				+ "      AND ofr1.borrado = 0 "
				+ "      AND aga1.borrado = 0 "
				+ "      AND agr1.borrado = 0 "
				+ "  ) as num_ofertas_aceptadas "
				+ "FROM DUAL ";
		
		String resultado = rawDao.getExecuteSQL(sql);
		
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean esActivoConPropietario (String sqlNumActivoRem){
		if(Checks.esNulo(sqlNumActivoRem))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			    FROM ACT_PAC_PROPIETARIO_ACTIVO pac, "
				+ "			      ACT_ACTIVO act "
				+ "			    WHERE act.act_id       = pac.act_id "
				+ "			      AND act.ACT_NUM_ACTIVO = "+sqlNumActivoRem+" "
				+ "			      AND pac.BORRADO  = 0 "
				+ "			      AND act.BORRADO  = 0 "
				+ "			    GROUP BY pac.PRO_ID ");
		if("1".equals(resultado))
			return true;
		else
			return false;
	}
	
	@Override
	public Boolean esActivoEnOtraAgrupacionNoCompatible(Long numActivo, Long numAgrupacion, String codTiposAgrNoCompatibles) {
		String cadenaCodigosSql = convertStringToGroupSql(codTiposAgrNoCompatibles);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(aga.AGR_ID) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO aga, "
				+ "			    ACT_AGR_AGRUPACION agr, "
				+ "			    ACT_ACTIVO act,"
				+ "				DD_TAG_TIPO_AGRUPACION tag "
				+ "			  WHERE aga.AGR_ID = agr.AGR_ID "
				+ "			    AND act.act_id   = aga.act_id "
				+ "			    AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "				AND agr.DD_TAG_ID = tag.DD_TAG_ID "
				+ "			    AND tag.DD_TAG_CODIGO in ("+cadenaCodigosSql+") "
				+ "			    AND agr.AGR_NUM_AGRUP_REM  <> "+numAgrupacion+" "
				+ "				AND agr.AGR_FECHA_BAJA IS NULL "
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND agr.BORRADO  = 0 "
				+ "			    AND act.BORRADO  = 0 "
				+ "				AND tag.BORRADO  = 0 ");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	private String convertStringToGroupSql(String cadena) {
		String resultado = "";
		String[] arrayCodigos = cadena.split(",");
		
		for(String codigo : arrayCodigos) {
			resultado = "'"+codigo+"',";
			
		}
		resultado = resultado.substring(0, resultado.length()-1);
		
		return resultado;
	}
	
	@Override
	public Boolean esActivoFinanciero(String numActivo) {
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		FROM ACT_ABA_ACTIVO_BANCARIO aba "
				+ "		INNER JOIN DD_CLA_CLASE_ACTIVO cla "
				+ "		ON cla.DD_CLA_ID = aba.DD_CLA_ID "
				+ "		WHERE " 
				+ "		cla.DD_CLA_CODIGO ='01' "
				+ "		AND aba.ACT_ID = (select act_id from act_activo where act_num_activo = '"+numActivo+"') ");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean esPropuestaYaCargada(Long numPropuesta) {
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		FROM PRP_PROPUESTAS_PRECIOS prp "
				+ "		INNER JOIN DD_EPP_ESTADO_PROP_PRECIO epp "
				+ " 	ON epp.DD_EPP_ID = prp.DD_EPP_ID "
				+ " 	WHERE "
				+ " 	epp.DD_EPP_CODIGO = '04'"
				+ " 	AND prp.PRP_NUM_PROPUESTA = "+ numPropuesta );
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean isActivoNoComercializable(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM DD_SCM_SITUACION_COMERCIAL scm, "
				+ "			  ACT_ACTIVO act "
				+ "			WHERE scm.dd_scm_id   = act.dd_scm_id "
				+ "			  AND scm.dd_scm_codigo = '01' "
				+ "			  AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			  AND act.borrado = 0");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}

	@Override
	public List<BigDecimal> getImportesActualesActivo(String numActivo) {
		Object[] resultados = rawDao.getExecuteSQLArray(
				"		SELECT (SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '02')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS IMPORTE_PAV,"
				+ "		(SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS IMPORTE_PMA,"
				+ "		(SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '03')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS IMPORTE_PAR,"
				+ "		(SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '07')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS IMPORTE_PDA,"
				+ "		(SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '13')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS IMPORTE_PDP"
				+ "		FROM DUAL ");

		List<BigDecimal> listaImportes = new ArrayList<BigDecimal>();

		for(Object o: resultados){
			listaImportes.add((BigDecimal) o);
		}

		return listaImportes;
	}
	
	public List<Date> getFechasImportesActualesActivo(String numActivo) {
		Object[] resultados = rawDao.getExecuteSQLArray(
				"		SELECT (SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '02')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS FECHA_INICIO_PAV,"
				+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '02')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS FECHA_FIN_PAV,"
				+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS FECHA_INICIO_PMA,"
				+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS FECHA_FIN_PMA,"
				+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '03')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS FECHA_INICIO_PAR,"
				+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '03')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS FECHA_FIN_PAR,"
				+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '07')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS FECHA_INICIO_PDA,"
				+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '07')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS FECHA_FIN_PDA,"
				+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '13')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS FECHA_INICIO_PDP,"
				+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '13')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS FECHA_FINE_PDP"
				+ "		FROM DUAL ");

		List<Date> listaFechasImportes = new ArrayList<Date>();

		for(Object o: resultados){
			listaFechasImportes.add((Date) o);
		}

		return listaFechasImportes;
	}
	
	@Override
	public Boolean existeActivoEnPropuesta(String numActivo, String numPropuesta) {
		if(Checks.esNulo(numActivo) || Checks.esNulo(numPropuesta))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO ACT "
				+ " 	JOIN ACT_PRP APR ON ACT.ACT_ID = APR.ACT_ID "
				+ " 	JOIN PRP_PROPUESTAS_PRECIOS PRP ON APR.PRP_ID=PRP.PRP_ID "
				+ "		WHERE ACT.ACT_NUM_ACTIVO ="+numActivo+" "
				+ " 	AND PRP.PRP_NUM_PROPUESTA ="+numPropuesta);
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public BigDecimal getPrecioMinimoAutorizadoActualActivo(String numActivo) {
		BigDecimal resultado = null;
		Object[] resultados = rawDao.getExecuteSQLArray(
				"		SELECT (SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")) AS IMPORTE_PMA"
				+ "		FROM DUAL ");

		for(Object o: resultados){
			resultado = ((BigDecimal) o);
		}

		return resultado;
	}
	
	@Override
	public Boolean existeActivoConOfertaViva(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO ACT "
				+ " 	JOIN ACT_OFR ACTOF ON ACT.ACT_ID = ACTOF.ACT_ID "
				+ " 	JOIN OFR_OFERTAS OFR ON ACTOF.OFR_ID = OFR.OFR_ID "
				+ " 	JOIN DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID "
				+ "		WHERE ACT.ACT_NUM_ACTIVO ="+numActivo+" "
				+ " 	AND EOF.DD_EOF_CODIGO IN ('01','03','04')");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean existeActivoConExpedienteComercialVivo(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;
		
		String query = "SELECT COUNT(1) "
				+ "	  	FROM VI_OFERTAS_ACTIVOS_AGRUPACION v "
				+ " 	INNER JOIN ECO_EXPEDIENTE_COMERCIAL eco ON v.ECO_ID = eco.ECO_ID "
				+ "  	INNER JOIN ACT_TBJ_TRABAJO tbj ON eco.TBJ_ID = tbj.TBJ_ID "
				+ "  	INNER JOIN ACT_TRA_TRAMITE tra ON tbj.TBJ_ID = tra.TBJ_ID "
				+ "  	INNER JOIN TAC_TAREAS_ACTIVOS tac ON tra.TRA_ID = tac.TRA_ID "
				+ "  	INNER JOIN TAR_TAREAS_NOTIFICACIONES tar ON tac.TAR_ID = TAR.TAR_ID "
				+ "		INNER JOIN ACT_ACTIVO act ON act.ACT_ID = v.ACT_ID "
				+ " 	WHERE act.ACT_NUM_ACTIVO LIKE '%''"+numActivo+"''%' "
				+ "    	AND tar.TAR_FECHA_FIN IS NULL "
				+ "     AND ROWNUM=1 ";
		
		String resultado = rawDao.getExecuteSQL(query);
		
		if("0".equals(resultado))
			return false;
		else
			return true;
	}

	@Override
	public Boolean existeSociedadAcreedora(String sociedadAcreedoraNIF) {
		if(Checks.esNulo(sociedadAcreedoraNIF)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PDV_PLAN_DIN_VENTAS WHERE"
				+ "		 	PDV_ACREEDOR_NIF = '"+sociedadAcreedoraNIF+"' "
				+ "		 	AND BORRADO = 0");
		
		if("0".equals(resultado)) {
			return false;
		} else {
			return true;
		}
	}

	@Override
	public Boolean existePropietario(String propietarioNIF) {
		if(Checks.esNulo(propietarioNIF)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PRO_PROPIETARIO WHERE"
				+ "		 	PRO_DOCIDENTIF = '"+propietarioNIF+"' "
				+ "		 	AND BORRADO = 0");
		
		if("0".equals(resultado)) {
			return false;
		} else {
			return true;
		}
	}

	@Override
	public Boolean existeProveedorMediadorByNIF(String proveedorMediadorNIF) {
		if(Checks.esNulo(proveedorMediadorNIF)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PVE_PROVEEDOR WHERE"
				+ "		 PVE_DOCIDENTIF = '" + proveedorMediadorNIF + "'"
				+ " 	 AND DD_TPR_ID = (SELECT DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '04')" // Mediador-Colaborador-API.
				+ "		 AND BORRADO = 0");
		
		if("0".equals(resultado)) {
			return false;
		} else {
			return true;
		}
	}
	
	@Override
	public Boolean existeProveedorMediadorByNIFConFVD(String proveedorMediadorNIF) {
		if(Checks.esNulo(proveedorMediadorNIF)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PVE_PROVEEDOR WHERE"
				+ "		 PVE_DOCIDENTIF = '" + proveedorMediadorNIF + "'"
				+ " 	 AND DD_TPR_ID = (SELECT DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '04')" // Mediador-Colaborador-API.
				+ " 	 OR DD_TPR_ID = (SELECT DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '18')"  // Fuerza de Venta Directa
				+ "		 AND BORRADO = 0");
		
		if("0".equals(resultado)) {
			return false;
		} else {
			return true;
		}
	}
	
	public boolean existeSubCarteraByCod(String codSubCartera){
		if (Checks.esNulo(codSubCartera)){
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM DD_SCR_SUBCARTERA WHERE"
				+"		DD_SCR_CODIGO = '" + codSubCartera + "'"
				+" 		AND BORRADO = 0");
		
		if("0".equals(resultado)){
			return false;
		} else {
			return true;
		}
	}
	
	public boolean existeTipoActivoByCod(String codTipoActivo){
		if (Checks.esNulo(codTipoActivo)){
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM DD_TPA_TIPO_ACTIVO WHERE"
				+"		DD_TPA_CODIGO = '" + codTipoActivo + "'"
				+"		AND BORRADO = 0");
		
		if("0".equals(resultado)){
			return false;
		} else {
			return true;
		}
	}
	
	public boolean existeSubtipoActivoByCod(String codSubtipoActivo){
		if (Checks.esNulo(codSubtipoActivo)){
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM DD_SAC_SUBTIPO_ACTIVO WHERE"
				+"		DD_SAC_CODIGO = '" + codSubtipoActivo + "'"
				+"		AND BORRADO = 0");
		
		if("0".equals(resultado)){
			return false;
		}else{
			return true;
		}
	}
	
	public boolean existeGestorComercialByUsername(String gestorUsername){
		if(Checks.esNulo(gestorUsername)){
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+"	FROM ZON_PEF_USU WHERE"
				+" 	USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '" + gestorUsername + "')"
				+"  AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION = 'Gestor comercial')");
		
		if("0".equals(resultado)){
			return false;
		}
		return true;
	}
	
	public boolean existeSupervisorComercialByUsername(String supervisorUsername){
		if(Checks.esNulo(supervisorUsername)){
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+"	FROM ZON_PEF_USU WHERE"
				+"	USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '" + supervisorUsername +"')"
				+"	AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION = 'Supervisor comercial')");
		
		if("0".equals(resultado)){
			return false;
		}else return true;
	}
	
	public boolean existeGestorFormalizacionByUsername(String gestorUsername){
		if(Checks.esNulo(gestorUsername)) return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '" + gestorUsername +"')"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION = 'Gestor formalización')");
		
		if("0".equals(resultado)){
			return false;
		}else return true;
	}
	
	public boolean existeSupervisorFormalizacionByUsername(String supervisorUsername){
		if(Checks.esNulo(supervisorUsername)) return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '" + supervisorUsername +"')"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION = 'Supervisor formalización')");
		
		if("0".equals(resultado)){
			return false;
		}else return true;
	}
	
	public boolean existeGestorAdmisionByUsername(String gestorUsername){
		if(Checks.esNulo(gestorUsername)) return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME ='" + gestorUsername +"')"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION = 'Gestor de admisión')");
		
		if("0".equals(resultado)){
			return false;
		}else return true;
	}
	
	public boolean existeGestorActivosByUsername(String gestorUsername){
		if(Checks.esNulo(gestorUsername)) return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '" + gestorUsername +"')"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION = 'Gestor de activos')");
		
		if("0".equals(resultado)){
			return false;
		}else return true;
		
	}
	
	public boolean existeGestoriaDeFormalizacionByUsername(String username){
		if(Checks.esNulo(username)) return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '" + username +"')"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION = 'Gestoría de formalización')");
		
		if("0".equals(resultado)){
			return false;
		}else return true;
	}

	@Override
	public Boolean existeProvinciaByCodigo(String codigoProvincia) {
		if(Checks.esNulo(codigoProvincia)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_PRV_PROVINCIA WHERE"
				+ "		 DD_PRV_CODIGO = '" + codigoProvincia + "'"
				+ "		 AND BORRADO = 0");
		
		if("0".equals(resultado)) {
			return false;
		} else {
			return true;
		}
	}

	@Override
	public Boolean existeMunicipioByCodigo(String codigoMunicipio) {
		if(Checks.esNulo(codigoMunicipio)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_LOC_LOCALIDAD WHERE"
				+ "		 DD_LOC_CODIGO = '" + codigoMunicipio + "'");
		
		if("0".equals(resultado)) {
			return false;
		} else {
			return true;
		}
	}

	@Override
	public Boolean existeUnidadInferiorMunicipioByCodigo(String codigoUnidadInferiorMunicipio) {
		if(Checks.esNulo(codigoUnidadInferiorMunicipio)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_UPO_UNID_POBLACIONAL WHERE"
				+ "		 DD_UPO_CODIGO = '" + codigoUnidadInferiorMunicipio + "'"
				+ "		 AND BORRADO = 0");
		
		if("0".equals(resultado)) {
			return false;
		} else {
			return true;
		}
	}
	
	@Override
	public Boolean existeGasto(String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR WHERE"
				+ "		 	GPV_NUM_GASTO_HAYA ="+numGasto+" "
				+ "		 	AND BORRADO = 0");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean esGastoDeLiberbank(String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR GPV "
				+ "      JOIN ACT_PRO_PROPIETARIO PRO ON GPV.PRO_ID = PRO.PRO_ID "
				+ "      JOIN DD_CRA_CARTERA CRA ON PRO.DD_CRA_ID = CRA.DD_CRA_ID "
				+ "		 WHERE GPV.GPV_NUM_GASTO_HAYA = "+numGasto+" "
				+ "         AND CRA.DD_CRA_CODIGO = '08' "
				+ "		 	AND GPV.BORRADO = 0");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean tienenRelacionActivoGasto(String numActivo, String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto) || Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM GPV_ACT "
				+ "		WHERE GPV_ID = (SELECT GPV_ID FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '"+numGasto+"')"
				+ "		AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '"+numActivo+"')");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public List<Long> getRelacionGastoActivo(String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return new ArrayList<Long>();
		List<Object> listaObj = rawDao.getExecuteSQLList("SELECT ACT_NUM_ACTIVO FROM ACT_ACTIVO "
				+ "WHERE ACT_ID IN (SELECT ACT_ID FROM GPV_ACT WHERE GPV_ID = "
				+ "(SELECT GPV_ID FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = "+numGasto+"))");
		List<Long> listaNumActivos = new ArrayList<Long>();
		for(Object o: listaObj){
			String objetoString = o.toString();
			listaNumActivos.add(Long.parseLong(objetoString));
		}
		return listaNumActivos;
	}
	
	@Override
	public Boolean propietarioGastoConDocumento(String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR gpv "
				+ "			INNER JOIN ACT_PRO_PROPIETARIO act_pro ON gpv.PRO_ID = act_pro.PRO_ID "
				+ "			WHERE act_pro.DD_TDI_ID IS NOT NULL "
				+ "			AND act_pro.PRO_DOCIDENTIF IS NOT NULL "
				+ "		 	AND gpv.GPV_NUM_GASTO_HAYA ="+numGasto+" "
				+ "		 	AND gpv.BORRADO = 0");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean propietarioGastoIgualActivo(String numActivo, String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultadoGasto = rawDao.getExecuteSQL("SELECT actpro.PRO_DOCIDENTIF "
				+ "		 FROM GPV_GASTOS_PROVEEDOR gpv "
				+ "			INNER JOIN ACT_PRO_PROPIETARIO actpro on gpv.PRO_ID = actpro.PRO_ID "
				+ "		 	where gpv.GPV_NUM_GASTO_HAYA ="+numGasto+" "
				+ "		 	AND actpro.BORRADO = 0");
		
		String resultadoActivo = rawDao.getExecuteSQL("SELECT actpro.PRO_DOCIDENTIF "
				+ "		 FROM ACT_PAC_PROPIETARIO_ACTIVO actpac "
				+ "			INNER JOIN ACT_PRO_PROPIETARIO actpro on actpac.PRO_ID = actpro.PRO_ID "
				+ "			INNER JOIN ACT_ACTIVO act on actpac.ACT_ID = act.ACT_ID "
				+ "		 	where act.ACT_NUM_ACTIVO ="+numActivo+" "
				+ "		 	AND actpro.BORRADO = 0 ORDER BY actpac.PAC_PORC_PROPIEDAD");
		
		
		if(!Checks.esNulo(resultadoGasto) && !Checks.esNulo(resultadoActivo) && !resultadoGasto.equals(resultadoActivo))
			return false;
		else
			return true;
	}
	
	
	@Override
	public Boolean activoNoAsignado(String numActivo, String numGasto){
		if((Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) || (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto)))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_ACT gasact "
				+ "			INNER JOIN GPV_GASTOS_PROVEEDOR gpv on gasact.GPV_ID = gpv.GPV_ID "
				+ "			INNER JOIN ACT_ACTIVO act on gasact.ACT_ID = act.ACT_ID "
				+ "			WHERE gpv.GPV_NUM_GASTO_HAYA ="+numGasto+" "
				+ "			AND act.ACT_NUM_ACTIVO ="+numActivo+" "
				+ "		 	AND gpv.BORRADO = 0 AND act.BORRADO = 0");
		if("0".equals(resultado))
			return true;
		else
			return false;
	}
	
	@Override
	public Boolean isGastoNoAutorizado(String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR gpv "
				+ "			INNER JOIN GGE_GASTOS_GESTION gge on gpv.GPV_ID = gge.GPV_ID "
				+ "			INNER JOIN DD_EAH_ESTADOS_AUTORIZ_HAYA eah on gge.DD_EAH_ID = eah.DD_EAH_ID "
				+ "			WHERE gpv.GPV_NUM_GASTO_HAYA ="+numGasto+" "
				+ "		 	AND eah.DD_EAH_CODIGO =" +"03"+ " AND gpv.BORRADO = 0");
		if("0".equals(resultado))
			return true;
		else
			return false;
	}
	
	@Override
	public Boolean isGastoNoAsociadoTrabajo(String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR gpv "
				+ "			INNER JOIN GPV_TBJ gpvtbj on gpv.GPV_ID = gpvtbj.GPV_ID "
				+ "			WHERE gpv.GPV_NUM_GASTO_HAYA ="+numGasto+" "
				+ "		 	AND gpv.BORRADO = 0 and gpvtbj.BORRADO = 0");
		if("0".equals(resultado))
			return true;
		else
			return false;
	}
	
	@Override
	public Boolean isGastoPermiteAnyadirActivo(String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR gpv "
				+ "			INNER JOIN DD_EGA_ESTADOS_GASTO ega on gpv.DD_EGA_ID = ega.DD_EGA_ID "
				+ "			WHERE gpv.GPV_NUM_GASTO_HAYA ="+numGasto+" "
				+ "		 	AND ega.DD_EGA_CODIGO IN (01,02,07,08,10,11,12) AND gpv.BORRADO = 0");
		if("0".equals(resultado))
			return true;
		else
			return false;
	}
	
	@Override
	public Boolean existeExpedienteComercial(String numExpediente){
		if(Checks.esNulo(numExpediente) || !StringUtils.isNumeric(numExpediente))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ECO_EXPEDIENTE_COMERCIAL WHERE"
				+ "		 	ECO_NUM_EXPEDIENTE ="+numExpediente+" "
				+ "		 	AND BORRADO = 0");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean existeAgrupacion(String numAgrupacion){
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_AGR_AGRUPACION WHERE"
				+ "		 	AGR_NUM_AGRUP_REM ="+numAgrupacion+" "
				+ "		 	AND BORRADO = 0");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean existeTipoGestor(String codigoTipoGestor){
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_TGE_TIPO_GESTOR WHERE"
				+ "		 DD_TGE_CODIGO = '" + codigoTipoGestor + "'");
		
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean existeUsuario(String username){

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.USU_USUARIOS WHERE"
				+ "		 USU_USERNAME = '" + username + "'");
		
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean usuarioEsTipoGestor(String username, String codigoTipoGestor){
		if(Checks.esNulo(username) || Checks.esNulo(codigoTipoGestor))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM TGP_TIPO_GESTOR_PROPIEDAD tgp "
				+ "			INNER JOIN REMMASTER.DD_TDE_TIPO_DESPACHO tde on tgp.TGP_VALOR = tde.DD_TDE_CODIGO "
				+ "			INNER JOIN REMMASTER.DD_TGE_TIPO_GESTOR tge on tde.DD_TDE_CODIGO = tge.DD_TGE_CODIGO "
				+ "			INNER JOIN DES_DESPACHO_EXTERNO des on tde.DD_TDE_ID = des.DD_TDE_ID "
				+ "			INNER JOIN USD_USUARIOS_DESPACHOS usd on usd.DES_ID = des.DES_ID "
				+ "			INNER JOIN REMMASTER.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID "
				+ "			WHERE tge.DD_TGE_CODIGO ='"+codigoTipoGestor+"' AND usu.USU_USERNAME ='"+username+"'");
		if(!"0".equals(resultado))
			return true;
		else
			return false;
		
		
	}
	
	@Override
	public Boolean combinacionGestorCarteraAcagexValida(String codigoGestor, String numActivo, String numAgrupacion,String numExpediente){
		String resultado= "0";
		String cartera=null;
		String query=null;
		
		if(!Checks.esNulo(numActivo) || !Checks.esNulo(numAgrupacion)){
			query= ("SELECT DISTINCT(act.DD_CRA_ID) "
				+ "		 FROM ACT_AGR_AGRUPACION agr "
				+ "			INNER JOIN ACT_AGA_AGRUPACION_ACTIVO aga on agr.AGR_ID = aga.AGR_ID "
				+ "			INNER JOIN ACT_ACTIVO act on aga.ACT_ID = act.ACT_ID ");
			
			if(!Checks.esNulo(numActivo)){
				query= query.concat(" WHERE act.ACT_NUM_ACTIVO_REM ="+numActivo+" ");
			}
			else if(!Checks.esNulo(numAgrupacion)){
				query= query.concat(" WHERE agr.AGR_NUM_AGRUP_REM ="+numAgrupacion+" ");
			}
			cartera= rawDao.getExecuteSQL(query);
		}
		
		else if(!Checks.esNulo(numExpediente)){
			cartera= rawDao.getExecuteSQL("SELECT DISTINCT(act.DD_CRA_ID) "
					+ "		 FROM ECO_EXPEDIENTE_COMERCIAL eco "
					+ "			INNER JOIN OFR_OFERTAS ofr on eco.OFR_ID = ofr.OFR_ID "
					+ "			INNER JOIN ACT_OFR actofr on ofr.OFR_ID = actofr.OFR_ID "
					+ "			INNER JOIN ACT_ACTIVO act on actofr.ACT_ID = act.ACT_ID "
					+ " 		WHERE eco.ECO_NUM_EXPEDIENTE= "+numExpediente+" ");
		}
		
		
		if(!Checks.esNulo(cartera)){
			query= ("SELECT COUNT(*) "
					+ "		 FROM DD_GCM_GESTOR_CARGA_MASIVA gcm "
					+ "			INNER JOIN ${master.schema}.DD_TGE_TIPO_GESTOR tge on gcm.DD_GCM_CODIGO = tge.DD_TGE_CODIGO "
					+ "			INNER JOIN DD_CRA_CARTERA cra on gcm.DD_CRA_ID = cra.DD_CRA_ID "
					+ "			WHERE gcm.DD_GCM_CODIGO ='"+codigoGestor+"' "
					+ "		 	AND cra.DD_CRA_ID = "+cartera+" ");
			
			if(!Checks.esNulo(numActivo)){
				query= query.concat(" AND gcm.DD_GCM_ACTIVO = 1");
				resultado = rawDao.getExecuteSQL(query);
			}
			else if(!Checks.esNulo(numExpediente)){
				query= query.concat(" AND gcm.DD_GCM_EXPEDIENTE = 1");
				resultado = rawDao.getExecuteSQL(query);
			}
			else if(!Checks.esNulo(numAgrupacion)){
				query= query.concat(" AND gcm.DD_GCM_AGRUPACION = 1");
				resultado = rawDao.getExecuteSQL(query);
			}
		}
		else{
			resultado= "0";
		}
	
		if("0".equals(resultado))
			return false;
		else
			return true;
		
	}	
	
	@Override
	public Boolean isFechaTraspasoPosteriorAFechaDevengo(String numActivo, String numGasto) {
		String resultado = "0";
		String enAgrupacion = null;
		
		if(Checks.esNulo(numActivo) || Checks.esNulo(numGasto))
			return false;
		
		else {
			enAgrupacion = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT "
						+ "						JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID "
						+ "						WHERE ACT_NUM_ACTIVO = '"+numActivo+"'");
		}
		
		//El activo NO pertenece a una agrupacion
		if("0".equals(enAgrupacion)){
			
			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM GPV_GASTOS_PROVEEDOR GPV "
							+ "						JOIN ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = '"+numActivo+"' "
							+ "						WHERE GPV.GPV_NUM_GASTO_HAYA = '"+numGasto+"' "
							+ "						AND GPV.GPV_FECHA_EMISION < ACT.ACT_VENTA_EXTERNA_FECHA "
							+ "						AND ACT.DD_SCR_ID IN (SELECT DD_SCR_ID FROM DD_SCR_SUBCARTERA WHERE "
							+ "							DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA WHERE DD_CRA_CODIGO = 3)"
							+ "							AND DD_SCR_CODIGO IN (14, 15, 19) ) ");
			
		}
		//El activo pertenece a una agrupacion
		else {
			
			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM GPV_GASTOS_PROVEEDOR GPV "
							+ "						JOIN ACT_ACTIVO ACT ON ACT_NUM_ACTIVO = '"+numActivo+"' "
							+ "						JOIN ACT_AGA_AGRUPACION_ACTIVO ACT_AGA ON ACT_AGA.ACT_ID = ACT.ACT_ID "
							+ "						JOIN OFR_OFERTAS OFR ON OFR.AGR_ID = ACT_AGA.AGR_ID "
							+ "						JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID "
							+ "						WHERE GPV.GPV_NUM_GASTO_HAYA = '"+numGasto+"' "
							+ "						AND GPV.GPV_FECHA_EMISION < ECO.ECO_FECHA_VENTA "
							+ "						AND ACT.DD_SCR_ID IN (SELECT DD_SCR_ID FROM DD_SCR_SUBCARTERA WHERE "
							+ "							DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA WHERE DD_CRA_CODIGO = 3)"
							+ "							AND DD_SCR_CODIGO IN (14, 15, 19) ) ");
			
		}
		
		if(!"0".equals(resultado))
			return true;
		else
			return false;
		
		
	}
	
	@Override
	public Boolean distintosTiposImpuesto(String numActivo, String numAgrupacion) {
		
		Boolean agrCanarias = false;
		Boolean actCanarias = false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_AGR_AGRUPACION AGR " + 
				"JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " + 
				"JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID " + 
				"JOIN BIE_BIEN BIE ON BIE.BIE_ID = ACT.BIE_ID " + 
				"JOIN BIE_LOCALIZACION LOC ON LOC.BIE_ID = BIE.BIE_ID " + 
				"JOIN REMMASTER.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID AND DD_PRV_CODIGO IN ('35', '38') " + 
				"WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" ");
		
		if(Integer.valueOf(resultado) > 0) agrCanarias = true;
		
		
		resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT " + 
				"JOIN BIE_BIEN BIE ON BIE.BIE_ID = ACT.BIE_ID " + 
				"JOIN BIE_LOCALIZACION LOC ON LOC.BIE_ID = BIE.BIE_ID " + 
				"JOIN REMMASTER.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID AND DD_PRV_CODIGO IN ('35', '38') " + 
				"WHERE ACT.ACT_NUM_ACTIVO = "+numActivo+" ");
		
		if(Integer.valueOf(resultado) > 0) actCanarias = true;

		
		if(actCanarias == agrCanarias) return false;
				else return true;
		
	}
	
	@Override
	public boolean comprobarDistintoPropietario(String numActivo, String numAgrupacion) {
				
		String agrPro = null;
		String actPro;
				
		agrPro = rawDao.getExecuteSQL("SELECT PRO_ID FROM ACT_PAC_PROPIETARIO_ACTIVO PAC " + 
				"JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID " + 
				"JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = PAC.ACT_ID " + 
				"JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID " + 
				"WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" AND PAC.ACT_ID = AGR.AGR_ACT_PRINCIPAL");
		
		if(Checks.esNulo(agrPro)) {
			agrPro = rawDao.getExecuteSQL("SELECT PRO_ID FROM ACT_PAC_PROPIETARIO_ACTIVO PAC " + 
					"JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID " + 
					"JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = PAC.ACT_ID " + 
					"JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID " + 
					"WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" AND ROWNUM = 1");
		}
		
		actPro = rawDao.getExecuteSQL("SELECT PRO_ID FROM ACT_PAC_PROPIETARIO_ACTIVO PAC " +
				"JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID AND ACT_NUM_ACTIVO = "+numActivo);
		
		if(Checks.esNulo(agrPro)) return false;
			
			
		if(actPro.equals(agrPro)) return false;
				else return true;
	}

	@Override
	public boolean comprobarDistintoPropietarioListaActivos(String[] activos) {

		String actPro = rawDao.getExecuteSQL("SELECT PRO_ID FROM ACT_PAC_PROPIETARIO_ACTIVO PAC "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID AND ACT_NUM_ACTIVO = " + activos[0]);

		for (int i = 1; i < activos.length; i++) {
			String actAComparar = rawDao.getExecuteSQL("SELECT PRO_ID FROM ACT_PAC_PROPIETARIO_ACTIVO PAC "
					+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID AND ACT_NUM_ACTIVO = " + activos[i]);
			if (actPro != actAComparar) return true;
		}

		return false;
	}
	
	@Override
	public boolean activoConOfertasTramitadas(String numActivo) {

		String actofr = rawDao.getExecuteSQL("    SELECT COUNT(aof1.act_id) "
				+ "    FROM OFR_OFERTAS ofr1 "
				+ "    INNER JOIN ACT_OFR aof1 on ofr1.ofr_id = aof1.ofr_id "
				+ "    INNER JOIN ACT_ACTIVO act1 on aof1.act_id = act1.act_id "
				+ "    INNER JOIN DD_EOF_ESTADOS_OFERTA eof1 on ofr1.dd_eof_id = eof1.dd_eof_id "
				+ "    WHERE "
				+ "      eof1.dd_eof_codigo = '01' "
				+ "      AND act1.act_num_activo = "+numActivo+" "
				+ "      AND ofr1.borrado = 0 ");
		
		return actofr.equals("0");

	}
	
	@Override
	public boolean existeComiteSancionador(String codComite){
		String res = rawDao.getExecuteSQL("		SELECT COUNT(1) "
				+ "		FROM DD_COS_COMITES_SANCION cos			"
				+ "     WHERE cos.BORRADO = 0					"
				+ "		AND cos.DD_COS_CODIGO = '"+codComite+"'   "
				);
		return !res.equals("0");
	}
	
	@Override
	public boolean existeTipoimpuesto(String codTipoImpuesto){
		String res = rawDao.getExecuteSQL("		SELECT COUNT(1) "
				+ "     FROM DD_TIT_TIPOS_IMPUESTO tit			"
				+ "		WHERE tit.BORRADO = 0					"
				+ "		AND tit.DD_TIT_CODIGO = '"+codTipoImpuesto+"' "
				);
				
		
		return !res.equals("0");
	}
	
	@Override
	public boolean existeCodigoPrescriptor(String codPrescriptor){
		boolean resultado = false;
		if(codPrescriptor != null && !codPrescriptor.isEmpty()){
			String res = rawDao.getExecuteSQL("		SELECT COUNT(1) "
					+ "     FROM ACT_PVE_PROVEEDOR act			"
					+ "		WHERE act.BORRADO = 0					"
					+ "		AND act.PVE_COD_REM = '"+codPrescriptor+"' "
					);
			resultado = !res.equals("0");
		}
		
		
		return resultado;
	}
	
	@Override
	public boolean existeTipoDocumentoByCod(String codDocumento){
		boolean resultado = false;
		if(codDocumento != null && !codDocumento.isEmpty()){
			String res = rawDao.getExecuteSQL("		SELECT COUNT(1) "
					+ "		FROM DD_TDI_TIPO_DOCUMENTO_ID tdi		"
					+ "		WHERE tdi.BORRADO = 0					"
					+ "		AND tdi.DD_TDI_CODIGO = '"+codDocumento+"' "
					);
			
			resultado = !res.equals("0");
			
		}
	
		return resultado;
	}
	
	@Override
	public Boolean existeAgrupacionByDescripcion(String descripcionAgrupacion){
		if(Checks.esNulo(descripcionAgrupacion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_AGR_AGRUPACION WHERE"
				+ "		 	AGR_DESCRIPCION ='"+descripcionAgrupacion+"' "
				+ "		 	AND BORRADO = 0");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}

	@Override
	public String getSubcartera(String numActivo) {
		String resultado = "";
		if(numActivo != null && !numActivo.isEmpty()){
			 resultado = rawDao.getExecuteSQL("SELECT scr.DD_SCR_CODIGO "
					+ "		FROM ACT_ACTIVO act "
					+ "		INNER JOIN DD_SCR_SUBCARTERA scr "
					+ "		ON act.DD_SCR_ID            = scr.DD_SCR_ID "
					+ "		WHERE act.ACT_NUM_ACTIVO = "+numActivo);
		}
		return resultado;
	}

	@Override
	public Boolean agrupacionEstaVacia(String numAgrupacion) {
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_AGR_AGRUPACION AGR " + 
				"JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " + 
				"WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" ");
		
		return resultado.equals("0");		
	}

	@Override
	public Boolean distintosTiposImpuestoAgrupacionVacia(List<String> listaActivos) {

		Boolean actCanarias;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID "
				+ "JOIN BIE_BIEN BIE ON BIE.BIE_ID = ACT.BIE_ID "
				+ "JOIN BIE_LOCALIZACION LOC ON LOC.BIE_ID = BIE.BIE_ID "
				+ "JOIN REMMASTER.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID AND DD_PRV_CODIGO IN ('35', '38') "
				+ "WHERE ACT.ACT_NUM_ACTIVO = " + listaActivos.get(0) + " ");

		if (Integer.valueOf(resultado) > 0)
			actCanarias = true;
		else
			actCanarias = false;

		for (String activo : listaActivos) {
			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT "
					+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID "
					+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID "
					+ "JOIN BIE_BIEN BIE ON BIE.BIE_ID = ACT.BIE_ID "
					+ "JOIN BIE_LOCALIZACION LOC ON LOC.BIE_ID = BIE.BIE_ID "
					+ "JOIN REMMASTER.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID AND DD_PRV_CODIGO IN ('35', '38') "
					+ "WHERE ACT.ACT_NUM_ACTIVO = " + activo + " ");

			if ((Integer.valueOf(resultado) > 0) != actCanarias) {
				return true;
			}
		}

		return false;

	}
	
	@Override
	public Boolean subcarteraPerteneceCartera(String subcartera, String cartera){
		
		if(!Checks.esNulo(cartera) && !Checks.esNulo(subcartera)){
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM REM01.DD_SCR_SUBCARTERA SCR "
					+ "JOIN REM01.DD_CRA_CARTERA CRA ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.DD_CRA_CODIGO = "+cartera+" "
					+ "WHERE DD_SCR_CODIGO = "+subcartera+"");
			
			if ((Integer.valueOf(resultado) > 0)) {
				return true;
			}
		}
		return false;
	}
	
	@Override
	public Boolean esParGastoActivo(String numGasto, String numActivo){
		if(!StringUtils.isNumeric(numGasto) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM GPV_ACT "
				+ "		WHERE GPV_ID = (SELECT GPV_ID FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '"+numGasto+"')"
				+ "		AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '"+numActivo+"')");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}
	
	@Override
	public Boolean agrupacionEsProyecto(String numAgrupacion) {
		
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion)) 
			return false;
		
		String resultado = rawDao.getExecuteSQL("	SELECT COUNT(1) FROM ACT_AGR_AGRUPACION             AGR "
				+ " JOIN DD_TAG_TIPO_AGRUPACION TAG "
				+ " ON TAG.DD_TAG_CODIGO = '04' "
				+ " AND TAG.DD_TAG_ID = AGR.DD_TAG_ID "
				+ " WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+"    "
				+ " AND AGR.BORRADO = 0 ");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}

	@Override
	public Boolean existePromocion(String promocion){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM ACT_ACTIVO "
				+ "WHERE ACT_COD_PROMOCION_PRINEX = '"+promocion+"'");
		if("0".equals(resultado))
			return false;
		else
			return true;
	}

	public Boolean mediadorExisteVigente(String codMediador){
		
		if(!Checks.esNulo(codMediador)){
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_PVE_PROVEEDOR "
					+ " WHERE PVE_COD_REM = "+ codMediador +" AND BORRADO = 0");
			
			if ((Integer.valueOf(resultado) > 0)) {
				
				resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_PVE_PROVEEDOR "
						+ " WHERE PVE_COD_REM = "+ codMediador +" AND PVE_FECHA_BAJA IS NULL OR PVE_FECHA_BAJA >= SYSDATE"
						+ " AND BORRADO = 0");
				
				if ((Integer.valueOf(resultado) > 0)) {
					return true;
				}
			}
		}
		return false;
	}
	
	@Override
    public Boolean activoTienePRV(String numActivo) {
		
    	String resultado = "0";
		if(numActivo != null && !numActivo.isEmpty()){
	    	 resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT "
					+ " JOIN BIE_BIEN BIE "
					+ " ON ACT.BIE_ID = BIE.BIE_ID "
					+ " JOIN BIE_LOCALIZACION   BIE_LOC "
					+ " ON BIE.BIE_ID = BIE_LOC.BIE_ID "
					+ " JOIN REMMASTER.DD_PRV_PROVINCIA PRV "
					+ " ON PRV.DD_PRV_ID = BIE_LOC.DD_PRV_ID "
					+ " WHERE ACT.ACT_NUM_ACTIVO = "+numActivo+" "
					+ " AND ACT.BORRADO=0 "
					+ " AND BIE.BORRADO=0 "
					+ " AND BIE_LOC.BORRADO=0 ");
		}
			
		if("0".equals(resultado))
			return false;
		else
			return true;		
	}
    
	@Override
    public Boolean activoTieneLOC(String numActivo) {
		
    	String resultado = "0";
		if(numActivo != null && !numActivo.isEmpty()){
			 resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT "
					+ " JOIN BIE_BIEN BIE "
					+ " ON ACT.BIE_ID = BIE.BIE_ID "
					+ " JOIN BIE_LOCALIZACION   BIE_LOC "
					+ " ON BIE.BIE_ID = BIE_LOC.BIE_ID "
					+ " JOIN REMMASTER.DD_LOC_LOCALIDAD LOC "
					+ " ON LOC.DD_LOC_ID = BIE_LOC.DD_LOC_ID "
					+ " WHERE ACT.ACT_NUM_ACTIVO = "+numActivo+" "
					+ " AND ACT.BORRADO=0 "
					+ " AND BIE.BORRADO=0 "
					+ " AND BIE_LOC.BORRADO=0 ");
		}
		if("0".equals(resultado))
			return false;
		else
			return true;		
	}
	
	@Override
	public Boolean esMismaProvincia(Long numActivo, Long numAgrupacion) {
		
		String prv_activo = "";
		prv_activo = rawDao.getExecuteSQL("SELECT PRV.DD_PRV_ID FROM ACT_ACTIVO ACT "
				+ " JOIN BIE_BIEN BIE "
				+ " ON ACT.BIE_ID = BIE.BIE_ID "
				+ " JOIN BIE_LOCALIZACION   BIE_LOC "
				+ " ON BIE.BIE_ID = BIE_LOC.BIE_ID "
				+ " JOIN REMMASTER.DD_PRV_PROVINCIA PRV "
				+ " ON PRV.DD_PRV_ID = BIE_LOC.DD_PRV_ID "
				+ " WHERE ACT.ACT_NUM_ACTIVO = "+numActivo+" "
				+ " AND ACT.BORRADO=0 "
				+ " AND BIE.BORRADO=0 "
				+ " AND BIE_LOC.BORRADO=0 ");
		
		String prv_agrupacion = "";
		prv_agrupacion = rawDao.getExecuteSQL("SELECT PRV.DD_PRV_ID FROM ACT_AGR_AGRUPACION AGR "
				+ " JOIN ACT_PRY_PROYECTO PRY "
				+ " ON AGR.AGR_ID = PRY.AGR_ID "
				+ " JOIN REMMASTER.DD_PRV_PROVINCIA PRV "
				+ " ON PRV.DD_PRV_ID = PRY.DD_PRV_ID "
				+ " WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" "
				+ " AND AGR.BORRADO = 0 ");

		if(!Checks.esNulo(prv_activo) && !Checks.esNulo(prv_agrupacion)){
			if (prv_activo.equals(prv_agrupacion)) {
	        	return true;
	        }
	        else {
	        	return false;
	        }
		}
		else {
			return false;
		}
	
	}
	
	@Override
	public Boolean esMismaLocalidad(Long numActivo, Long numAgrupacion) {
		
		String loc_activo = "";
		loc_activo = rawDao.getExecuteSQL("SELECT LOC.DD_LOC_ID FROM ACT_ACTIVO ACT "
				+ " JOIN BIE_BIEN BIE "
				+ " ON ACT.BIE_ID = BIE.BIE_ID "
				+ " JOIN BIE_LOCALIZACION   BIE_LOC "
				+ " ON BIE.BIE_ID = BIE_LOC.BIE_ID "
				+ " JOIN REMMASTER.DD_LOC_LOCALIDAD LOC "
				+ " ON LOC.DD_LOC_ID = BIE_LOC.DD_LOC_ID "
				+ " WHERE ACT.ACT_NUM_ACTIVO = "+numActivo+" "
				+ " AND ACT.BORRADO=0 "
				+ " AND BIE.BORRADO=0 "
				+ " AND BIE_LOC.BORRADO=0 ");
		
		String loc_agrupacion = "";
		loc_agrupacion = rawDao.getExecuteSQL("SELECT LOC.DD_LOC_ID FROM ACT_AGR_AGRUPACION AGR "
				+ " JOIN ACT_PRY_PROYECTO PRY "
				+ " ON AGR.AGR_ID = PRY.AGR_ID "
				+ " JOIN REMMASTER.DD_LOC_LOCALIDAD LOC "
				+ " ON LOC.DD_LOC_ID = PRY.DD_LOC_ID "
				+ " WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" "
				+ " AND AGR.BORRADO = 0 ");

		if(!Checks.esNulo(loc_activo) && !Checks.esNulo(loc_agrupacion)){
			if (loc_activo.equals(loc_agrupacion)) {
	        	return true;
	        }
	        else {
	        	return false;
	        }
		}
		else {
			return false;
		}
	
	}
}
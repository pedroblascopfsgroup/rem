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
			return rawDao.getExecuteSQL("SELECT '"+cartera+"-'||RES.DD_PRV_ID||'-'||RES.DD_LOC_ID||'-'||RES.RES_CP||'-TIPO-'||ACT.DD_ENO_ORIGEN_ANT_ID "
					+ "		  FROM ACT_RES_RESTRINGIDA RES, ACT_AGR_AGRUPACION AGR, ACT_AGA_AGRUPACION_ACTIVO AGA, ACT_ACTIVO ACT WHERE"
					+ " 		AGR.AGR_NUM_AGRUP_REM = "+numAgr+" AND AGR.AGR_ID = RES.AGR_ID AND AGA.AGR_ID = AGR.AGR_ID AND"
					+ " 		AGA.ACT_ID = ACT.ACT_ID "
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
		return rawDao.getExecuteSQL("SELECT ACT.DD_CRA_ID||'-'||DD_PRV_ID||'-'||DD_LOC_ID||'-'||BIE_LOC_COD_POST||'-TIPO-'||ACT.DD_ENO_ORIGEN_ANT_ID "
							+ "		  FROM ACT_ACTIVO ACT, BIE_LOCALIZACION BIE WHERE"
							+ " 		ACT.ACT_NUM_ACTIVO = "+numActive+" "
							+ " 		AND ACT.BIE_ID=BIE.BIE_ID"
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
				+ "		scr.DD_SCR_CODIGO IN ('01','02','03') "
				+ "		AND act.ACT_NUM_ACTIVO = "+numActivo+" ");
		if("0".equals(resultado))
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
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO act"
				+ "		INNER JOIN ACT_PAC_PERIMETRO_ACTIVO pac "
				+ " 	ON pac.ACT_ID = act.ACT_ID "
				+ "		WHERE " 
				+ "		act.ACT_NUM_ACTIVO ="+numActivo+" "
				+ "		and (pac.PAC_INCLUIDO = 0 OR pac.PAC_CHECK_COMERCIALIZAR = 0) "
				+ "		AND act.BORRADO = 0"
				+ "		AND pac.BORRADO = 0");
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
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "	  	FROM VI_OFERTAS_ACTIVOS_AGRUPACION v "
				+ " 	INNER JOIN ECO_EXPEDIENTE_COMERCIAL eco ON v.ECO_ID = eco.ECO_ID "
				+ "  	INNER JOIN ACT_TBJ_TRABAJO tbj ON eco.TBJ_ID = tbj.TBJ_ID "
				+ "  	INNER JOIN ACT_TRA_TRAMITE tra ON tbj.TBJ_ID = tra.TBJ_ID "
				+ "  	INNER JOIN TAC_TAREAS_ACTIVOS tac ON tra.TRA_ID = tac.TRA_ID "
				+ "  	INNER JOIN TAR_TAREAS_NOTIFICACIONES tar ON tac.TAR_ID = TAR.TAR_ID "
				+ " 	WHERE V.ACTIVOS LIKE '%''"+numActivo+"''%' "
				+ "    	AND tar.TAR_FECHA_FIN IS NULL "
				+ "     AND ROWNUM=1 ");
		
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
}
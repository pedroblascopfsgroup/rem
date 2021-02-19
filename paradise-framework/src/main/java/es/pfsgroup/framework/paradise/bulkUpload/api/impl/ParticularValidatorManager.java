package es.pfsgroup.framework.paradise.bulkUpload.api.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;
import java.util.zip.Checksum;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;

@Service
@Transactional()
public class ParticularValidatorManager implements ParticularValidatorApi {

	@Autowired
	private MSVRawSQLDao rawDao;
	
	public static final String COD_MEDIADOR = "04";
	public static final String COD_FUERZA_VENTA_DIRECTA="18";
	
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
		return "1".equals(resultado);
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
	public Boolean esActivoPrincipalEnAgrupacion(Long numActivo) {
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(AGR.AGR_ID) "
				+ "           FROM ACT_AGR_AGRUPACION AGR, ACT_ACTIVO ACT "
				+ "           WHERE ACT.ACT_ID  = AGR.AGR_ACT_PRINCIPAL "
				+ "           AND ACT.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "           AND AGR.BORRADO  = 0 "
				+ "           AND ACT.BORRADO  = 0");
		return !"0".equals(resultado);
	}
	@Override
	public Boolean esActivoPrincipalEnAgrupacion(Long numActivo, String tipoAgr) {
		String resultado = rawDao.getExecuteSQL("SELECT " +
				"Case " +
				"WHEN AGR.AGR_FECHA_BAJA is nuLL then (select COUNT(AGR.AGR_ID) FROM ACT_ACTIVO ACT " +
				"                                        INNER JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID " +
				"                                        INNER JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID and AGR.BORRADO  = 0 " +
				"                                        INNER join DD_TAG_TIPO_AGRUPACION TAG ON AGR.DD_TAG_ID = TAG.DD_TAG_ID " +
				"                                        WHERE ACT.ACT_NUM_ACTIVO = " + numActivo + " and (AGA.AGA_PRINCIPAL = 1 OR AGR.AGR_ACT_PRINCIPAL = ACT.ACT_ID)) " +
				"ELSE 1 " +
				"END as validacion " +
				"FROM ACT_ACTIVO ACT " +
				"INNER JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID " +
				"INNER JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID and AGR.BORRADO  = 0 " +
				"INNER join DD_TAG_TIPO_AGRUPACION TAG ON AGR.DD_TAG_ID = TAG.DD_TAG_ID " +
				"WHERE ACT.ACT_NUM_ACTIVO = " + numActivo + " " +
				"AND ACT.BORRADO = 0 " +
				"AND TAG.DD_TAG_CODIGO = " + tipoAgr);
		return !"0".equals(resultado);
	}

	@Override
	public Boolean activoEnAgrupacionRestringida(Long numActivo) {
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(aga.AGR_ID) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO aga, "
				+ "			    ACT_AGR_AGRUPACION agr, "
				+ "			    ACT_ACTIVO act, "
				+ "			    DD_TAG_TIPO_AGRUPACION tipoAgr "
				+ "			  WHERE aga.AGR_ID = agr.AGR_ID "
				+ "			    AND act.act_id   = aga.act_id "
				+ "			    AND tipoAgr.DD_TAG_ID = agr.DD_TAG_ID "
				+ "			    AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			    AND tipoAgr.DD_TAG_CODIGO = '02' "
				+ "				AND (agr.AGR_FECHA_BAJA is null OR agr.AGR_FECHA_BAJA  > SYSDATE)"
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND agr.BORRADO  = 0 "
				+ "			    AND act.BORRADO  = 0 ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esActivoEnAgrupacion(Long numActivo, Long numAgrupacion) {
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(AGA.AGR_ID) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO AGA, "
				+ "			    ACT_AGR_AGRUPACION AGR, "
				+ "			    ACT_ACTIVO ACT "
				+ "			  WHERE AGA.AGR_ID = AGR.AGR_ID "
				+ "			    AND ACT.ACT_ID   = AGA.ACT_ID "
				+ "			    AND ACT.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			    AND AGR.AGR_NUM_AGRUP_REM  = "+numAgrupacion+" "
				+ "				AND (agr.AGR_FECHA_BAJA is null OR agr.AGR_FECHA_BAJA  > SYSDATE)"
				+ "			    AND AGA.BORRADO  = 0 "
				+ "			    AND AGR.BORRADO  = 0 "
				+ "			    AND ACT.BORRADO  = 0 ");
		return !"0".equals(resultado);
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
				+ "			    AND act.BORRADO  = 0 "
				+ "				AND (agr.AGR_FECHA_BAJA is null OR agr.AGR_FECHA_BAJA  > SYSDATE)");
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
				+ "				AND (agr.AGR_FECHA_BAJA is null OR agr.AGR_FECHA_BAJA  > SYSDATE)"
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND agr.BORRADO  = 0 "
				+ "			    AND act.BORRADO  = 0 ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeActivo(String numActivo){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_ACTIVO WHERE"
				+ "		 	ACT_NUM_ACTIVO ="+numActivo+" "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeOferta(String numOferta){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS WHERE "
				+ "OFR_NUM_OFERTA = "+numOferta+" "
				+ "AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isOfferOfGiants(String numOferta){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS OFR "
				+ "JOIN ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID "
				+ "JOIN DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID "
				+ "WHERE OFR_NUM_OFERTA = "+numOferta+" "
				+ "AND DD_CRA_CODIGO = '12' "
				+ "AND OFR.BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esOfertaPendienteDeSancion(String numOferta){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ECO_EXPEDIENTE_COMERCIAL ECO "
				+ "JOIN OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID "
				+ "JOIN DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID "
				+ "WHERE OFR.OFR_NUM_OFERTA ="+numOferta+" "
				+ "AND (EEC.DD_EEC_CODIGO = '10' OR EEC.DD_EEC_CODIGO = '23') "
				+ "AND ECO.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isAgrupacionOfGiants(String numAgrupacion){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_AGR_AGRUPACION AGR "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AGR.AGR_ACT_PRINCIPAL "
				+ "JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" "
				+ "AND DD_CRA_CODIGO = '12' ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoOfGiants(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_ACTIVO ACT "
				+ "JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID "
				+ "WHERE CRA.DD_CRA_CODIGO = '12' "
				+ "AND ACT.ACT_NUM_ACTIVO = "+numActivo+" ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoVendido(String numActivo){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_ACTIVO ACT "
				+ " INNER JOIN DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID = SCM.DD_SCM_ID"
				+ "	WHERE"
				+ "		 	ACT.ACT_NUM_ACTIVO ="+numActivo+" "
				+ "		 	AND ACT.BORRADO = 0"
				+ " AND DD_SCM_DESCRIPCION LIKE 'Vendido'");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existePlusvalia(String numActivo){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM EPV_ECO_PLUSVALIAVENTA EPV"
				+ " INNER JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = EPV.ECO_ID"
				+ " INNER JOIN OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID "
				+ " INNER JOIN ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID"
				+ " INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID "
				+ " INNER JOIN DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID"
				+ "	WHERE ACT_NUM_ACTIVO ="+numActivo+" "
				+ " AND EOF.DD_EOF_CODIGO = '01'"
				+ " AND EPV.EPV_EXENTO IS NOT NULL"
				+ " AND EPV.EPV_AUTOLIQUIDACION IS NOT NULL"
				+ " AND EPV.EPV_FECHA_ESCRITO_AYTO IS NOT NULL"
				+ " AND EPV.EPV_OBSERVACIONES IS NOT NULL"
				+ "		 	AND EPV.BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeCatastro(String catastro){
		if(Checks.esNulo(catastro) || !StringUtils.isAlphanumeric(catastro))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_CAT_CATASTRO WHERE"
				+ "		 	CAT_REF_CATASTRAL ='"+catastro+"' "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeActivoEnPropietarios(String numActivo, String idPropietarios){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo) && Checks.esNulo(idPropietarios) || !StringUtils.isAlphanumeric(idPropietarios))
			return false;
		String cpr_id = rawDao.getExecuteSQL("SELECT CPR_ID "
				+ "		 FROM ACT_ACTIVO WHERE"
				+ "		 	ACT_NUM_ACTIVO ="+numActivo+" "
				+ "		 	AND BORRADO = 0");

		return !Checks.esNulo(cpr_id);
	}

	@Override
	public Boolean existeComunidadPropietarios(String idPropietarios){
		if(Checks.esNulo(idPropietarios) || !StringUtils.isAlphanumeric(idPropietarios))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_CPR_COM_PROPIETARIOS WHERE"
				+ "		 CPR_NIF = '"+idPropietarios+"' "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeEstadoLoc(String codEstadoLoc){
		if(Checks.esNulo(codEstadoLoc) || !StringUtils.isAlphanumeric(codEstadoLoc))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_ELO_ESTADO_LOCALIZACION WHERE"
				+ "		 DD_ELO_CODIGO ='"+codEstadoLoc+"' "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeSubestadoGestion(String codSubestadoGestion){
		if(Checks.esNulo(codSubestadoGestion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_SEG_SUBESTADO_GESTION WHERE"
				+ "		 DD_SEG_CODIGO ='"+codSubestadoGestion+"' "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean isActivoPrePublicable(String numActivo){
		return isActivoGestionAdmision(numActivo) && isActivoUltimoInformeComercialAceptado(numActivo);
	}

	private Boolean isActivoGestionAdmision(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		 FROM ACT_ACTIVO WHERE "
				+ "			ACT_ADMISION = 1 "
				+ "			AND ACT_ADMISION = 1 "
				+ "		 	AND ACT_NUM_ACTIVO ="+numActivo+" "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
	}

	public Boolean estadosValidosDesDespublicarForzado(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO ="+numActivo+" "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('05'))");
		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
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
		return !Checks.esNulo(resultado);
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
		return !"0".equals(resultado) || !"0".equals(resultado2);
	}

	@Override
	public Boolean esAgrupacionConBaja (String numAgrupacion){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		FROM ACT_AGR_AGRUPACION agr "
				+ "		WHERE "
				+ "		agr.AGR_FECHA_BAJA IS NOT NULL "
				+ "		AND agr.AGR_NUM_AGRUP_REM = "+numAgrupacion+" ");
		return !"0".equals(resultado);
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
		return "1".equals(resultado);
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
		return "1".equals(resultado);
	}

	@Override
	public Boolean esActivosMismaCartera (String inSqlNumActivosRem, String agrupacion){
		String[] lista = inSqlNumActivosRem.split(",");
		List<String> listaActivosAAnyadir = new ArrayList<String>();

		Collections.addAll(listaActivosAAnyadir, lista);

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
			boolean esPrimero = true;
			String referencia = "";

			for(String a: listaActivosAAnyadir){
				String carteraActivo = rawDao.getExecuteSQL("SELECT dd_cra_id"
						+" FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = " + a);

				if(!esPrimero){
					if(!Checks.esNulo(resultado)){
						if(!resultado.equals(carteraActivo)){
							return false;
						}
					}else {
						carteraActivo = rawDao.getExecuteSQL("SELECT dd_cra_id" + " FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = " + a);

						if (!referencia.equals(carteraActivo)) {
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

		return !"0".equals(resultado);
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

		return "1".equals(resultado);
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
				+ "				AND (agr.AGR_FECHA_BAJA is null OR agr.AGR_FECHA_BAJA  > SYSDATE)"
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND agr.BORRADO  = 0 "
				+ "			    AND act.BORRADO  = 0 "
				+ "				AND tag.BORRADO  = 0 ");

		return !"0".equals(resultado);
	}

	private String convertStringToGroupSql(String cadena) {
		String resultado = "";
		String[] arrayCodigos = cadena.split(",");

		for(String codigo : arrayCodigos) {
			resultado = "'"+codigo+"',";

		}

		return resultado.substring(0, resultado.length()-1);
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

		return !"0".equals(resultado);
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

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoNoComercializable(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM DD_SCM_SITUACION_COMERCIAL scm, "
				+ "			  ACT_ACTIVO act "
				+ "			  WHERE scm.dd_scm_id   = act.dd_scm_id "
				+ "			  AND scm.dd_scm_codigo = '01' "
				+ "			  AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			  AND act.borrado = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean destinoFinalNoVenta(String numActivo){
		if(Checks.esNulo(numActivo)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO act "
				+ "			INNER JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+ "			WHERE APU.dd_tco_id IN ( "
				+ "				SELECT tco.DD_TCO_ID "
				+ "				FROM DD_TCO_TIPO_COMERCIALIZACION tco"
				+ "				where tco.DD_TCO_CODIGO NOT IN ('01','02')) "
				+ "			AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			AND act.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean destinoFinalNoAlquiler(String numActivo){
		if(Checks.esNulo(numActivo)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO act "
				+ "			INNER JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+ "			WHERE apu.DD_TCO_ID IN ( "
				+ "				SELECT tco.DD_TCO_ID "
				+ "				FROM DD_TCO_TIPO_COMERCIALIZACION tco"
				+ "				where tco.DD_TCO_CODIGO NOT IN ('02','03')) "
				+ "			AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			AND act.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean activoNoPublicado(String numActivo){
		if(Checks.esNulo(numActivo)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO act "
				+ "			WHERE act.ACT_ID NOT IN ( "
				+ "				SELECT apu.ACT_ID FROM ACT_APU_ACTIVO_PUBLICACION apu WHERE apu.BORRADO = 0) "
				+ "			AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			AND act.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean activoOcultoVenta(String numActivo){
		if (Checks.esNulo(numActivo)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_APU_ACTIVO_PUBLICACION apu "
				+ "			WHERE apu.APU_CHECK_OCULTAR_V = 1 "
				+ "			AND apu.BORRADO = 0"
				+ "			AND apu.ACT_ID = (SELECT act.ACT_ID FROM ACT_ACTIVO act WHERE act.ACT_NUM_ACTIVO = "+numActivo+") ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean activoOcultoAlquiler(String numActivo){
		if (Checks.esNulo(numActivo)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_APU_ACTIVO_PUBLICACION apu "
				+ "			WHERE apu.APU_CHECK_OCULTAR_A = 1 "
				+ "			AND apu.BORRADO = 0"
				+ "			AND apu.ACT_ID = (SELECT act.ACT_ID FROM ACT_ACTIVO act WHERE act.ACT_NUM_ACTIVO = "+numActivo+") ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean motivoNotExistsByCod(String codigoMotivo){
		if (Checks.esNulo(codigoMotivo)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "				FROM DD_MTO_MOTIVOS_OCULTACION mto "
				+ "				WHERE mto.DD_MTO_CODIGO = '"+codigoMotivo+"' "
				+ "				AND mto.BORRADO = 0");

		return "0".equals(resultado);
	}

	@Override
	public Boolean isActivoNoPublicable(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_PAC_PERIMETRO_ACTIVO pac, ACT_ACTIVO act "
				+ "			WHERE pac.act_id = act.act_id "
				+ "			AND pac.PAC_CHECK_PUBLICAR <> 1 "
				+ "			AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			AND act.borrado = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoDestinoComercialNoVenta(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_ACTIVO act "
				+ "			JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+ "			WHERE APU.dd_tco_id IN (SELECT dd_tco_id FROM DD_TCO_TIPO_COMERCIALIZACION WHERE dd_tco_codigo in('01', '02')) "
				+ "			AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			AND act.borrado = 0");

		return "0".equals(resultado);
	}

	@Override
	public Boolean isActivoDestinoComercialNoAlquiler(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_ACTIVO act "
				+ "			JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+ "			WHERE APU.dd_tco_id IN (SELECT dd_tco_id FROM DD_TCO_TIPO_COMERCIALIZACION WHERE dd_tco_codigo in('03', '02')) "
				+ "			AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			AND act.borrado = 0");

		return "0".equals(resultado);
	}

	@Override
	public Boolean isActivoSinPrecioVentaWeb(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_ACTIVO act,  ACT_VAL_VALORACIONES val "
				+ "			WHERE act.act_id = val.act_id "
				+ "         AND val.DD_TPC_ID in (select DD_TPC_ID from DD_TPC_TIPO_PRECIO where dd_tpc_codigo in ('02')) "
				+ "			AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			AND act.borrado = 0");

		return "0".equals(resultado);
	}

	@Override
	public Boolean isActivoSinPrecioRentaWeb(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_ACTIVO act,  ACT_VAL_VALORACIONES val "
				+ "			WHERE act.act_id = val.act_id "
				+ "         AND val.DD_TPC_ID in (select DD_TPC_ID from DD_TPC_TIPO_PRECIO where dd_tpc_codigo in ('03')) "
				+ "			AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			AND act.borrado = 0");

		return "0".equals(resultado);
	}

	@Override
	public Boolean isActivoSinInformeAprobado(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_ACTIVO act,  V_COND_DISPONIBILIDAD cond "
				+ "			WHERE act.act_id = cond.act_id "
				+ "         AND cond.SIN_INFORME_APROBADO = 1 "
				+ "			AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			AND act.borrado = 0");

		return !"0".equals(resultado);
	}

	@Override
	public List<BigDecimal> getImportesActualesActivo(String numActivo) {
		Object[] resultados = rawDao.getExecuteSQLArray(
				"		SELECT (SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '02')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+")"
						+ "AND VAL_FECHA_FIN IS NULL) AS IMPORTE_PAV,"
				+ "		(SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS IMPORTE_PMA,"
				+ "		(SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '03')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS IMPORTE_PAR,"
				+ "		(SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '07')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS IMPORTE_PDA,"
				+ "		(SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '13')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS IMPORTE_PDP"
				+ "		FROM DUAL ");

		List<BigDecimal> listaImportes = new ArrayList<BigDecimal>();

		for(Object o: resultados){
			listaImportes.add((BigDecimal) o);
		}

		return listaImportes;
	}

	public List<Date> getFechasImportesActualesActivo(String numActivo) {
		Object[] resultados = rawDao.getExecuteSQLArray(
			"	SELECT "
			+ "		(SELECT VAL_FECHA_APROBACION FROM V_PRECIOS_VIGENTES" 
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '02')" 
			+ "		AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_APROB_PAV,"
			+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '02')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_INICIO_PAV,"
			+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '02')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_FIN_PAV,"

			+ "		(SELECT VAL_FECHA_APROBACION FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_APROB_PMA,"
			+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_INICIO_PMA,"
			+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_FIN_PMA,"

			+ "		(SELECT VAL_FECHA_APROBACION FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '03')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_APROB_PAR,"
			+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '03')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_INICIO_PAR,"
			+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '03')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_FIN_PAR,"

			+ "		(SELECT VAL_FECHA_APROBACION FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '07')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_APROBACION_PDA,"
			+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '07')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_INICIO_PDA,"
			+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '07')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_FIN_PDA,"

			+ "		(SELECT VAL_FECHA_APROBACION FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '13')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_APROBACION_PDP,"
			+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '13')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_INICIO_PDP,"
			+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '13')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = "+numActivo+") AND VAL_FECHA_FIN IS NULL ) AS FECHA_FIN_PDP"
			+ "	FROM DUAL ");

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

		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
	}
	@Override
	public Boolean existeActivoConOfertaVivaEstadoExpediente(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL( "SELECT COUNT(*) 	"
						+	"		        FROM ACT_ACTIVO ACT 	"
						+	"			  	JOIN ACT_OFR ACTOF ON ACT.ACT_ID = ACTOF.ACT_ID 	"
						+	"			  	JOIN OFR_OFERTAS OFR ON ACTOF.OFR_ID = OFR.OFR_ID 	"
						+	"			  	JOIN DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.DD_EOF_CODIGO = '01' 	"
						+	"		        JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON OFR.OFR_ID = ECO.OFR_ID 	"
						+	"		        JOIN DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.DD_EEC_CODIGO NOT IN ('02','08','03') 	"
						+	"		        WHERE ACT.ACT_NUM_ACTIVO = "+numActivo);

        		return !"0".equals(resultado);

		/*String resultado = rawDao.getExecuteSQL( " SELECT count(1)      "
				+			"				 FROM ACT_AGA_AGRUPACION_ACTIVO aga      "
				+			"				 INNER JOIN ACT_OFR  actOfr ON  aga.ACT_ID =  actOfr.ACT_ID      "
				+			"				 INNER JOIN OFR_OFERTAS ofr ON actOfr.OFR_ID = ofr.OFR_ID      "
				+			"				 INNER JOIN ECO_EXPEDIENTE_COMERCIAL eco ON ofr.OFR_ID = eco.OFR_ID      "
				+			"				 INNER JOIN ACT_ACTIVO act ON actOfr.ACT_ID = act.ACT_ID      "
				+			"				 WHERE actOfr.ACT_ID =   (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO ="	+numActivo+ ")"
				+			"                AND eco.DD_EEC_ID NOT IN (SELECT DD_EEC_ID FROM DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO IN ('02','03','08', '28')) "
				+			"				 AND ofr.DD_EOF_ID  IN  (SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '01')");

		return !"0".equals(resultado);*/
	}

	@Override
	public Boolean existeActivoConExpedienteComercialVivo(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String query = "SELECT COUNT(1) "
				+ "	  	FROM VI_OFERTAS_ACTIVOS_AGRUPACION v "
				+ " 	INNER JOIN ECO_EXPEDIENTE_COMERCIAL eco ON v.ECO_ID = eco.ECO_ID "
				+ " 	INNER JOIN OFR_OFERTAS ofr ON v.OFR_NUM_OFERTA = ofr.OFR_NUM_OFERTA "
				+ "  	INNER JOIN ACT_TBJ_TRABAJO tbj ON eco.TBJ_ID = tbj.TBJ_ID "
				+ "  	INNER JOIN ACT_TRA_TRAMITE tra ON tbj.TBJ_ID = tra.TBJ_ID "
				+ "  	INNER JOIN TAC_TAREAS_ACTIVOS tac ON tra.TRA_ID = tac.TRA_ID "
				+ "  	INNER JOIN TAR_TAREAS_NOTIFICACIONES tar ON tac.TAR_ID = TAR.TAR_ID "
				+ "		INNER JOIN ACT_ACTIVO act ON act.ACT_ID = v.ACT_ID "
				+ " 	WHERE act.ACT_NUM_ACTIVO ="+numActivo+" "
				+ "    	AND tar.TAR_FECHA_FIN IS NULL "
				+ "    	AND ofr.DD_EOF_ID <> 2 "
				+ "     FETCH FIRST 1 ROWS ONLY ";

		String resultado = rawDao.getExecuteSQL(query);

		return !"0".equals(resultado);
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

		return !"0".equals(resultado);
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

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeProveedorMediadorByNIF(String proveedorMediadorNIF) {
		if(Checks.esNulo(proveedorMediadorNIF)) {
			return true;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PVE_PROVEEDOR WHERE"
				+ "		 PVE_DOCIDENTIF = '" + proveedorMediadorNIF + "'"
				+ " 	 AND DD_TPR_ID = (SELECT DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '04')" // Mediador-Colaborador-API.
				+ "		 AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeProveedorMediadorByNIFConFVD(String proveedorMediadorNIF) {
		if(Checks.esNulo(proveedorMediadorNIF)) {
			return true;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PVE_PROVEEDOR WHERE"
				+ "		 PVE_DOCIDENTIF = '" + proveedorMediadorNIF + "'"
				+ " 	 AND DD_TPR_ID = (SELECT DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '04')" // Mediador-Colaborador-API.
				+ " 	 OR DD_TPR_ID = (SELECT DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '18')"  // Fuerza de Venta Directa
				+ "		 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeCalifEnergeticaByDesc(String califEnergeticaDesc) {
		if(Checks.esNulo(califEnergeticaDesc)) {
			return true;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TCE_TIPO_CALIF_ENERGETICA WHERE"
				+ "		 DD_TCE_DESCRIPCION = '" + califEnergeticaDesc + "'"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeGradoPropiedadByCod(String gradPropiedadCod) {
		if(Checks.esNulo(gradPropiedadCod)) {
			return true;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TGP_TIPO_GRADO_PROPIEDAD WHERE"
				+ "		 DD_TGP_CODIGO = '" + gradPropiedadCod + "'"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeDestComercialByCod(String destComercialCod) {
		if(Checks.esNulo(destComercialCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TCO_TIPO_COMERCIALIZACION WHERE"
				+ "		 DD_TCO_CODIGO = '" + destComercialCod + "'"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeTipoAlquilerByCod(String tipoAlquilerCod) {
		if(Checks.esNulo(tipoAlquilerCod)) {
			return true;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TAL_TIPO_ALQUILER WHERE"
				+ "		 DD_TAL_CODIGO = '" + tipoAlquilerCod + "'"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeTipoViaByCod(String tipoViaCod) {
		if(Checks.esNulo(tipoViaCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_TVI_TIPO_VIA WHERE"
				+ "		 DD_TVI_CODIGO = '" + tipoViaCod + "'"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeSubtipoTituloByCod(String subtipoTituloCod) {
		if(Checks.esNulo(subtipoTituloCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_STA_SUBTIPO_TITULO_ACTIVO WHERE"
				+ "		 DD_STA_CODIGO = '" + subtipoTituloCod + "'"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeUsoDominanteByCod(String usoDominanteCod) {
		if(Checks.esNulo(usoDominanteCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TUD_TIPO_USO_DESTINO WHERE"
				+ "		 DD_TUD_CODIGO = '" + usoDominanteCod + "'"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeEstadoExpRiesgoByCod(String estadoExpRiesgoCod) {
		if(Checks.esNulo(estadoExpRiesgoCod)) {
			return true;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_EER_EST_EXP_RIESGO WHERE"
				+ "		 DD_EER_CODIGO = '" + estadoExpRiesgoCod + "'"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeProvinciaByCod(String provCod) {
		if(Checks.esNulo(provCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_PRV_PROVINCIA WHERE"
				+ "		 DD_PRV_CODIGO = '" + provCod + "'"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeEstadoFisicoByCod(String estFisicoCod) {
		if(Checks.esNulo(estFisicoCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_EAC_ESTADO_ACTIVO WHERE"
				+ "		 DD_EAC_CODIGO = '" + estFisicoCod + "'"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeClaseActivoByDesc(String claseActivoDesc) {
		if(Checks.esNulo(claseActivoDesc)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_CLA_CLASE_ACTIVO WHERE"
				+ "		 DD_CLA_DESCRIPCION = '" + claseActivoDesc + "'"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean destComercialContieneAlquiler(String destComercialCod) {
		if(Checks.esNulo(destComercialCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TCO_TIPO_COMERCIALIZACION WHERE"
				+ "		 DD_TCO_CODIGO = '" + destComercialCod + "'"
				+ "		 AND LOWER(DD_TCO_DESCRIPCION) LIKE '%alquiler%'"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	public boolean existeSubCarteraByCod(String codSubCartera){
		if (Checks.esNulo(codSubCartera)){
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM DD_SCR_SUBCARTERA WHERE"
				+"		DD_SCR_CODIGO = '" + codSubCartera + "'"
				+" 		AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	public boolean existeTipoActivoByCod(String codTipoActivo){
		if (Checks.esNulo(codTipoActivo)){
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM DD_TPA_TIPO_ACTIVO WHERE"
				+"		DD_TPA_CODIGO = '" + codTipoActivo + "'"
				+"		AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	public boolean existeSubtipoActivoByCod(String codSubtipoActivo){
		if (Checks.esNulo(codSubtipoActivo)){
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM DD_SAC_SUBTIPO_ACTIVO WHERE"
				+"		DD_SAC_CODIGO = '" + codSubtipoActivo + "'"
				+"		AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	public boolean existeGestorComercialByUsername(String gestorUsername){
		if(Checks.esNulo(gestorUsername)){
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+"	FROM ZON_PEF_USU WHERE"
				+" 	USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '" + gestorUsername + "')"
				+"  AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'HAYAGESTCOM')");

		return !"0".equals(resultado);
	}

	public boolean existeSupervisorComercialByUsername(String supervisorUsername){
		if(Checks.esNulo(supervisorUsername)){
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+"	FROM ZON_PEF_USU WHERE"
				+"	USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '" + supervisorUsername +"')"
				+"	AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'HAYASUPCOM')");

		return !"0".equals(resultado);
	}

	public boolean existeGestorFormalizacionByUsername(String gestorUsername){
		if(Checks.esNulo(gestorUsername)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '" + gestorUsername +"')"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'HAYAGESTFORM')");

		return !"0".equals(resultado);
	}

	public boolean existeSupervisorFormalizacionByUsername(String supervisorUsername){
		if(Checks.esNulo(supervisorUsername)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '" + supervisorUsername +"')"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'HAYASUPFORM')");

		return !"0".equals(resultado);
	}

	public boolean existeGestorAdmisionByUsername(String gestorUsername){
		if(Checks.esNulo(gestorUsername)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME ='" + gestorUsername +"')"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'HAYAGESTADM')");

		return !"0".equals(resultado);
	}

	public boolean existeGestorActivosByUsername(String gestorUsername){
		if(Checks.esNulo(gestorUsername)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '" + gestorUsername +"')"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'HAYAGESACT')");

		return !"0".equals(resultado);

	}

	public boolean existeGestoriaDeFormalizacionByUsername(String username){
		if(Checks.esNulo(username)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '" + username +"')"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'GESTIAFORM')");

		return !"0".equals(resultado);
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

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeMunicipioByCodigo(String codigoMunicipio) {
		if(Checks.esNulo(codigoMunicipio)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_LOC_LOCALIDAD WHERE"
				+ "		 DD_LOC_CODIGO = '" + codigoMunicipio + "'");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeMunicipioDeProvinciaByCodigo(String codProvincia, String codigoMunicipio) {
		if(codigoMunicipio == null || codProvincia == null) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_LOC_LOCALIDAD LOC"
				+ "		 INNER JOIN ${master.schema}.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID"
				+ "		 WHERE PRV.DD_PRV_CODIGO = '"+codProvincia+"' AND"
				+ "		 LOC.DD_LOC_CODIGO = '" + codigoMunicipio + "'");

		return !"0".equals(resultado);
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

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeGasto(String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR WHERE"
				+ "		 	GPV_NUM_GASTO_HAYA = '"+numGasto+"' "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean gastoTieneLineaDetalle(String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM gld_gastos_linea_detalle "
				+ "where BORRADO = 0 AND  gpv_id = (SELECT gpv_id FROM "
				+ "gpv_gastos_proveedor where "
				+ "gpv_num_gasto_haya = '"+numGasto+"')");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean subtipoGastoCorrespondeGasto(String numGasto,String subtipoGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto) || Checks.esNulo(subtipoGasto) || !StringUtils.isNumeric(subtipoGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM gpv_gastos_proveedor "
				+" where gpv_num_gasto_haya = '" + numGasto + "' and "
				+" dd_tga_id = (select dd_tga_id from dd_stg_subtipos_gasto where dd_stg_codigo = '" + subtipoGasto + "')");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean lineaSubtipoDeGastoRepetida(String numGasto,String subtipoGasto, String tipoImpositivo, String tipoImpuesto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto) || Checks.esNulo(subtipoGasto))
			return false;
		String query = "SELECT COUNT(*) FROM gld_gastos_linea_detalle where " + 
				"gpv_id in (select gpv_id from gpv_gastos_proveedor where gpv_num_gasto_haya = '"+numGasto+"' and borrado = 0) and " +
				"DD_STG_ID in (select dd_stg_id from dd_stg_subtipos_gasto where dd_stg_codigo like '"+subtipoGasto+"' and borrado = 0)  and " +
				"BORRADO = 0 and ";
				if(Checks.esNulo(tipoImpositivo)) {
					query = query + "GLD_IMP_IND_TIPO_IMPOSITIVO is null and ";
				}else {
					query = query + "GLD_IMP_IND_TIPO_IMPOSITIVO = '"+tipoImpositivo+"' and ";
				}
				if(Checks.esNulo(tipoImpuesto)) {
					query = query + "dd_tit_id is null";
				}else {
					query = query + "dd_tit_id in (select dd_tit_id from dd_tit_tipos_impuesto where dd_tit_codigo = '"+tipoImpuesto+"' and borrado = 0) ";
				}
				
		
		String resultado = rawDao.getExecuteSQL(query);
				
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esGastoDeLiberbank(String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR GPV "
				+ "      JOIN ACT_PRO_PROPIETARIO PRO ON GPV.PRO_ID = PRO.PRO_ID "
				+ "      JOIN DD_CRA_CARTERA CRA ON PRO.DD_CRA_ID = CRA.DD_CRA_ID "
				+ "		 WHERE GPV.GPV_NUM_GASTO_HAYA = '"+numGasto+"' "
				+ "         AND CRA.DD_CRA_CODIGO = '08' "
				+ "		 	AND GPV.BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean tienenRelacionActivoGasto(String numActivo, String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto) || Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM GLD_ENT ENT"
				+ " INNER JOIN GLD_TBJ TBJ ON TBJ.GLD_ID = ENT.GLD_ID"
				+ "	INNER JOIN GLD_GASTOS_LINEA_DETALLE GLD ON TBJ.GLD_ID = GLD.GLD_ID"
				+ "	WHERE GLD.GPV_ID = (SELECT GPV_ID FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '"+numGasto+"')"
				+ " AND ENT.ENT_ID = (SELECT DD_ENT_ID FROM DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO ='ACT')"
				+ "	AND ENT.DD_ENT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '"+numActivo+"')");
		return !"0".equals(resultado);
	}

	@Override
	public List<Long> getRelacionGastoActivo(String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return new ArrayList<Long>();
		List<Object> listaObj = rawDao.getExecuteSQLList("SELECT DISTINCT ACT.ACT_NUM_ACTIVO FROM ACT_ACTIVO ACT "
				+ "INNER JOIN GLD_ENT ENT ON ENT.ENT_ID = ACT.ACT_ID AND ENT.DD_ENT_ID = (SELECT DD_ENT_ID FROM DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO ='ACT') "
				+ "INNER JOIN GLD_TBJ TBJ ON TBJ.GLD_ID = ENT.GLD_ID "
				+ "INNER JOIN GLD_GASTOS_LINEA_DETALLE GLD ON TBJ.GLD_ID = GLD.GLD_ID "
				+ "INNER JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GLD.GPV_ID "
				+ "WHERE GPV.GPV_NUM_GASTO_HAYA = " + numGasto);
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
		return !"0".equals(resultado);
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


		return Checks.esNulo(resultadoGasto) || Checks.esNulo(resultadoActivo) || resultadoGasto.equals(resultadoActivo);
	}


	@Override
	public Boolean activoNoAsignado(String numActivo, String numGasto){
		if((Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) || (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto)))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "	FROM gld_ent ent"
				+ "	INNER JOIN gld_tbj tbj ON tbj.gld_id = ent.gld_id"
				+ "	INNER JOIN gld_gastos_linea_detalle gld ON tbj.gld_id = gld.gld_id"
				+ " INNER JOIN gpv_gastos_proveedor gpv ON gld.gpv_id = gpv.gpv_id"
				+ " INNER JOIN act_activo act ON ent.ent_id = act.act_id"
				+ "	WHERE gpv.GPV_NUM_GASTO_HAYA ="+numGasto+" "
				+ "	AND act.ACT_NUM_ACTIVO ="+numActivo+" "
				+ " AND ENT.DD_ENT_ID = (SELECT DD_ENT_ID FROM DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO ='ACT')"
				+ "	AND gpv.BORRADO = 0 AND act.BORRADO = 0");
		return "0".equals(resultado);
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
		return "0".equals(resultado);
	}

	@Override
	public Boolean isGastoNoAsociadoTrabajo(String numGasto){
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR gpv "
				+ "		 INNER JOIN GLD_GASTOS_LINEA_DETALLE GLD ON GPV.GPV_ID = GLD.GPV_ID	"
				+ "		 INNER JOIN GLD_TBJ TBJ ON TBJ.GLD_ID = GLD.GLD_ID	"
				+ "			WHERE gpv.GPV_NUM_GASTO_HAYA ="+numGasto+" "
				+ "		 	AND gpv.BORRADO = 0 and TBJ.BORRADO = 0");
		return "0".equals(resultado);
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
		return "0".equals(resultado);
	}

	@Override
	public Boolean existeExpedienteComercial(String numExpediente){
		if(Checks.esNulo(numExpediente) || !StringUtils.isNumeric(numExpediente))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ECO_EXPEDIENTE_COMERCIAL WHERE"
				+ "		 	ECO_NUM_EXPEDIENTE ="+numExpediente+" "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeAgrupacion(String numAgrupacion){
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_AGR_AGRUPACION "
				+ "		 WHERE AGR_NUM_AGRUP_REM =" + numAgrupacion
				+ "      AND BORRADO = 0");
				//+ "      AND DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = '16')");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeAgrupacionPA(String numAgrupacion){
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_AGR_AGRUPACION "
				+ "		 WHERE AGR_NUM_AGRUP_REM =" + numAgrupacion
				+ "      AND DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = '16')");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeTipoGestor(String codigoTipoGestor){

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_TGE_TIPO_GESTOR WHERE"
				+ "		 DD_TGE_CODIGO = '" + codigoTipoGestor + "'");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeUsuario(String username){

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.USU_USUARIOS WHERE"
				+ "		 USU_USERNAME = '" + username + "'");

		return !"0".equals(resultado);
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
		return !"0".equals(resultado);


	}

	@Override
	public Boolean combinacionGestorCarteraAcagexValida(String codigoGestor, String numActivo, String numAgrupacion,String numExpediente){
		String resultado= "0";
		String cartera=null;
		String query;





		if(!Checks.esNulo(numActivo)){
			query= "SELECT DISTINCT(act.DD_CRA_ID) "
				+ "		 FROM ACT_ACTIVO act ";
			query= query.concat(" WHERE act.ACT_NUM_ACTIVO ="+numActivo+" ");
			cartera= rawDao.getExecuteSQL(query);
		}
		else if(!Checks.esNulo(numAgrupacion)){
			query= "SELECT DISTINCT(act.DD_CRA_ID) "
				+ "		 FROM ACT_AGR_AGRUPACION agr ";
			query= query.concat(" WHERE agr.AGR_NUM_AGRUP_REM ="+numAgrupacion+" ");
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
					+ "		 	AND cra.DD_CRA_ID = "+cartera+" "
					+ "			AND gcm.BORRADO = 0");

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

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isFechaTraspasoPosteriorAFechaDevengo(String numActivo, String numGasto) {
		String resultado;
		String enAgrupacion;

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

		return !"0".equals(resultado);


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


		return actCanarias != agrCanarias;

	}

	@Override
	public boolean comprobarDistintoPropietario(String numActivo, String numAgrupacion) {

		String agrPro;
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


		return !actPro.equals(agrPro);
	}

	@Override
	public boolean comprobarDistintoPropietarioListaActivos(String[] activos) {
		String actPro = rawDao.getExecuteSQL("SELECT PRO_ID FROM ACT_PAC_PROPIETARIO_ACTIVO PAC "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID AND ACT_NUM_ACTIVO = " + activos[0]);

		for (int i = 1; i < activos.length; i++) {
			String actAComparar = rawDao.getExecuteSQL("SELECT PRO_ID FROM ACT_PAC_PROPIETARIO_ACTIVO PAC "
					+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID AND ACT_NUM_ACTIVO = " + activos[i]);
			if (!actPro.equals(actAComparar)) return true;
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
	public boolean isMismoTipoComercializacionActivoPrincipalAgrupacion(String numActivo, String numAgrupacion) {
		String activoTCO = rawDao.getExecuteSQL("SELECT COUNT(1) "
		        + "        FROM ACT_APU_ACTIVO_PUBLICACION APU "
				+ "        JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = APU.ACT_ID "
		        + "        WHERE ACT.ACT_NUM_ACTIVO = "+numActivo+" AND APU.DD_TCO_ID = (SELECT APU.DD_TCO_ID "
				+ "                                   FROM ACT_APU_ACTIVO_PUBLICACION APU "
		        + "                                   JOIN ACT_ACTIVO ACT ON APU.ACT_ID = ACT.ACT_ID "
				+ "                                   JOIN ACT_AGR_AGRUPACION AGR ON ACT.ACT_ID = AGR.AGR_ACT_PRINCIPAL "
		        + "                                   AND AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+")");

		return activoTCO.equals("1");
	}

	@Override
	public boolean isMismoTipoComercializacionActivoPrincipalExcel(String numActivo, String numActivoPrincipalExcel) {
		String activoTCO = rawDao.getExecuteSQL("SELECT COUNT(1) "
		        + "        FROM ACT_APU_ACTIVO_PUBLICACION APU "
				+ "        JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = APU.ACT_ID "
		        + "        WHERE ACT.ACT_NUM_ACTIVO = "+numActivo+" AND APU.DD_TCO_ID = (SELECT APU.DD_TCO_ID "
				+ "                                   FROM ACT_APU_ACTIVO_PUBLICACION APU "
		        + "                                   JOIN ACT_ACTIVO ACT ON APU.ACT_ID = ACT.ACT_ID "
		        + "                                   AND ACT.ACT_NUM_ACTIVO_REM = "+numActivoPrincipalExcel+")");

		return activoTCO.equals("1");
	}

	@Override
	public boolean isMismoEpuActivoPrincipalAgrupacion(String numActivo, String numAgrupacion) {
		String activoEPU = rawDao.getExecuteSQL("SELECT COUNT(1) "
		        + "        FROM ACT_ACTIVO ACT "
				+ "        JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+ "        WHERE ACT.ACT_NUM_ACTIVO = "+numActivo
				+ "        AND (CASE"
		        + "        		WHEN APU.DD_TCO_ID IN (SELECT DD_TCO_ID FROM DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO IN ('01', '02')) THEN"
				+ "             	CASE WHEN APU.DD_EPV_ID = ("
				+ "                 	SELECT APU.DD_EPV_ID"
				+ "						FROM ACT_APU_ACTIVO_PUBLICACION APU"
				+ "						JOIN ACT_ACTIVO ACT ON APU.ACT_ID = ACT.ACT_ID"
				+ "            			JOIN ACT_AGR_AGRUPACION AGR ON ACT.ACT_ID = AGR.AGR_ACT_PRINCIPAL"
				+ "            			AND AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+") THEN 1"
				+ "					ELSE 0"
				+ "					END"
				+ "				ELSE 1"
				+ "				END = 1"
				+ "		   AND CASE"
				+ "        		WHEN APU.DD_TCO_ID IN (SELECT DD_TCO_ID FROM DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO IN ('02', '03')) THEN"
				+ "         			CASE WHEN APU.DD_EPA_ID = ("
				+ "            			SELECT APU.DD_EPA_ID"
				+ "            			FROM ACT_APU_ACTIVO_PUBLICACION APU"
				+ "            			JOIN ACT_ACTIVO ACT ON APU.ACT_ID = ACT.ACT_ID"
				+ "            			JOIN ACT_AGR_AGRUPACION AGR ON ACT.ACT_ID = AGR.AGR_ACT_PRINCIPAL"
				+ "            			AND AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+") THEN 1"
				+ "        			ELSE 0"
				+ "        			END"
				+ "    	   		ELSE 1"
				+ "    	   		END = 1)"
		);

		return activoEPU.equals("1");
	}
	
	@Override
	public boolean isMismoTcoActivoPrincipalAgrupacion(String numActivo, String numAgrupacion) {
		String activoTCO = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT "
				+"					JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+"					WHERE ACT.ACT_NUM_ACTIVO = "+numActivo 
				+"					AND APU.DD_TCO_ID = (SELECT APU.DD_TCO_ID FROM ACT_APU_ACTIVO_PUBLICACION APU" 
				+"					JOIN ACT_ACTIVO ACT ON APU.ACT_ID = ACT.ACT_ID" 
				+"	       			JOIN ACT_AGR_AGRUPACION AGR ON ACT.ACT_ID = AGR.AGR_ACT_PRINCIPAL" 
				+"	       			AND AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+")"
		);

		return activoTCO.equals("1");
	}

	@Override
	public boolean isMismoEpuActivoPrincipalExcel(String numActivo, String numActivoPrincipalExcel) {
		String activoEPU = rawDao.getExecuteSQL("SELECT COUNT(1) "
		        + "        FROM ACT_ACTIVO ACT "
				+ "        JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+ "        WHERE ACT.ACT_NUM_ACTIVO = "+numActivo
		        + "		   AND (CASE"
		        + "       		WHEN APU.DD_TCO_ID IN (SELECT DD_TCO_ID FROM DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO IN ('01', '02')) THEN"
		        + "             	CASE WHEN APU.DD_EPV_ID = ("
		        + "						SELECT APU.DD_EPV_ID"
				+ "                     FROM ACT_APU_ACTIVO_PUBLICACION APU"
		        + "                     JOIN ACT_ACTIVO ACT ON APU.ACT_ID = ACT.ACT_ID"
				+ "                     AND ACT.ACT_NUM_ACTIVO = "+numActivoPrincipalExcel+") THEN 1"
				+ "					ELSE 0"
				+ "					END"
				+ "				ELSE 1"
				+ "				END = 1"
				+ "		   AND CASE"
				+ "        		WHEN APU.DD_TCO_ID IN (SELECT DD_TCO_ID FROM DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO IN ('02', '03')) THEN"
				+ "         		CASE WHEN APU.DD_EPA_ID = ("
				+ "        				SELECT APU.DD_EPA_ID"
				+ "						FROM ACT_APU_ACTIVO_PUBLICACION APU"
				+ "                     JOIN ACT_ACTIVO ACT ON APU.ACT_ID = ACT.ACT_ID"
				+ "                     AND ACT.ACT_NUM_ACTIVO = "+numActivoPrincipalExcel+") THEN 1"
				+ "        			ELSE 0"
				+ "        			END"
				+ "    	   		ELSE 1"
				+ "    	   		END = 1)"
		);

		return activoEPU.equals("1");
	}

	public String idAgrupacionDelActivoPrincipal(String numActivo) {
		return rawDao.getExecuteSQL("SELECT AGA.AGR_ID"
				+ "		  FROM ACT_ACTIVO ACT"
				+ "		  JOIN  ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0"
				+ "       JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID"
				+"        LEFT JOIN DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID"	
				+ " 	  WHERE ACT.ACT_NUM_ACTIVO =" + numActivo + " "
				+ "       AND TAG.DD_TAG_CODIGO = '02'"
				+ "       AND AGR_FECHA_BAJA IS NULL");
	}

	@Override
	public Boolean esActivoVendidoAgrupacion(String numAgrupacion){
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM  ACT_ACTIVO ACT"
				+ "			JOIN  ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0"
				+ "			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0"
				+ "			JOIN  DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.BORRADO = 0  AND SCM.DD_SCM_CODIGO IN ('05')"
				+ "			AND   AGR.AGR_ID = " + numAgrupacion + " ");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esPerfilErroneo(String codPerfil, String codUsuario){
	    if(Checks.esNulo(codPerfil) || Checks.esNulo(codUsuario))
	        return false;
	    
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
	            +"         FROM REMMASTER.USU_USUARIOS U"  
	            +"         JOIN ZON_PEF_USU Z ON Z.USU_ID =  U.USU_ID" 
	            +"         JOIN PEF_PERFILES P ON P.PEF_ID = Z.PEF_ID"  
	            +"         WHERE LOWER(P.PEF_CODIGO) = LOWER('"+codPerfil+"')"  
	            +"         AND LOWER(U.USU_USERNAME) = LOWER('"+codUsuario+"')"
	            +"         AND P.BORRADO = 0 AND U.BORRADO = 0");
	    
        return "0".equals(resultado);
    }
	@Override
	public Boolean isActivoNoComercializableAgrupacion(String numAgrupacion) {
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM  ACT_ACTIVO ACT "
				+ "			JOIN  ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0 "
				+ "			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
				+ "			JOIN  DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.BORRADO = 0 AND SCM.DD_SCM_CODIGO IN ('01')"
				+ "			AND   AGR.AGR_ID = " + numAgrupacion + " ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoNoPublicableAgrupacion(String numAgrupacion) {
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "    		FROM  ACT_ACTIVO ACT"
				+ "			JOIN  ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0"
				+ "			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0"
				+ "			JOIN  ACT_PAC_PERIMETRO_ACTIVO PAC ON ACT.ACT_ID = PAC.ACT_ID AND PAC.BORRADO = 0 AND PAC.PAC_CHECK_PUBLICAR <> 1"
				+ "			AND   AGR.AGR_ID = " + numAgrupacion + " ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoDestinoComercialNoVentaAgrupacion(String numAgrupacion) {
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO ACT"
				+ "			JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID AND APU.BORRADO = 0"
				+ "			JOIN  ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0"
				+ "			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0"
				+ "			JOIN  DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID AND TCO.BORRADO = 0 AND TCO.DD_TCO_CODIGO NOT IN ('01', '02')"
				+ "			AND   AGR.AGR_ID = " + numAgrupacion + " ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoSinPrecioVentaWebAgrupacion(String numAgrupacion) {
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT NUM_ACT - NUM_VAL "
				+ "         FROM ( "
				+ "         	SELECT COUNT(DISTINCT AGA.ACT_ID) NUM_ACT"
				+ "				FROM  ACT_AGA_AGRUPACION_ACTIVO AGA"
				+ " 			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0"
				+ "				AND   AGR.AGR_ID = " + numAgrupacion + " "
				+ "         	WHERE AGA.BORRADO = 0),"
				+ " 				(SELECT COUNT(DISTINCT AGA.ACT_ID) NUM_VAL"
				+ "					FROM  ACT_AGA_AGRUPACION_ACTIVO AGA "
				+ "					JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
				+ "					JOIN  ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = AGA.ACT_ID AND VAL.BORRADO = 0"
				+ "					JOIN  DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.BORRADO = 0 AND TPC.DD_TPC_CODIGO = '02'"
				+ " 				AND   AGR.AGR_ID = " + numAgrupacion + " "
				+ " 				WHERE AGA.BORRADO = 0)");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoSinInformeAprobadoAgrupacion(String numAgrupacion) {
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT (1) "
				+ "			FROM ACT_ACTIVO ACT "
				+ "			JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0 "
				+ "         JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
				+ "			JOIN V_COND_DISPONIBILIDAD COND ON COND.ACT_ID = ACT.ACT_ID AND COND.SIN_INFORME_APROBADO = 1 "
				+ "			AND  AGR.AGR_ID = " + numAgrupacion + " ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoDestinoComercialNoAlquilerAgrupacion(String numAgrupacion) {
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO ACT"
				+ "			JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID AND APU.BORRADO = 0 "
				+ "			JOIN  ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0"
				+ "			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0"
				+ "			JOIN  DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID AND TCO.BORRADO = 0 AND TCO.DD_TCO_CODIGO NOT IN ('02', '03')"
				+ "			AND   AGR.AGR_ID = " + numAgrupacion + " ");
		return !"0".equals(resultado);
	}

	public Boolean activosNoOcultosVentaAgrupacion(String numAgrupacion){
		if (Checks.esNulo(numAgrupacion)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO ACT "
				+ "			JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0 "
				+ "			JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
				+ "         WHERE ACT.ACT_ID NOT IN ( "
				+ "         	SELECT APU.ACT_ID FROM ACT_APU_ACTIVO_PUBLICACION APU WHERE APU.APU_CHECK_OCULTAR_V = 1 AND APU.BORRADO = 0) "
				+ "			AND AGR.AGR_ID = " + numAgrupacion + " ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean activosNoOcultosAlquilerAgrupacion(String numAgrupacion){
		if (Checks.esNulo(numAgrupacion)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO ACT "
				+ "			JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0 "
				+ "			JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
				+ "         WHERE ACT.ACT_ID NOT IN ( "
				+ "         	SELECT APU.ACT_ID FROM ACT_APU_ACTIVO_PUBLICACION APU WHERE APU.APU_CHECK_OCULTAR_A = 1 AND APU.BORRADO = 0) "
				+ "			AND AGR.AGR_ID = " + numAgrupacion + " ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoSinPrecioRentaWebAgrupacion(String numAgrupacion) {
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT NUM_ACT - NUM_VAL "
				+ "         FROM ( "
				+ "         	SELECT COUNT(DISTINCT AGA.ACT_ID) NUM_ACT"
				+ "				FROM  ACT_AGA_AGRUPACION_ACTIVO AGA"
				+ " 			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0"
				+ "				AND   AGR.AGR_ID = " + numAgrupacion + " "
				+ "         	WHERE AGA.BORRADO = 0),"
				+ " 				(SELECT COUNT(DISTINCT AGA.ACT_ID) NUM_VAL"
				+ "					FROM  ACT_AGA_AGRUPACION_ACTIVO AGA "
				+ "					JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
				+ "					JOIN  ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = AGA.ACT_ID AND VAL.BORRADO = 0"
				+ "					JOIN  DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.BORRADO = 0 AND TPC.DD_TPC_CODIGO = '03'"
				+ " 				AND   AGR.AGR_ID = " + numAgrupacion + " "
				+ " 				WHERE AGA.BORRADO = 0)");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoOcultoVenta(String numActivo){
		if(Checks.esNulo(numActivo)){
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_EPV_ESTADO_PUB_VENTA EPV"
				+ "   		WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_EPV_ID = EPV.DD_EPV_ID"
				+ "			AND EPV.DD_EPV_CODIGO = '04'"
				+ "         AND ACT.ACT_NUM_ACTIVO = " + numActivo + " ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoNoPublicadoVenta(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_EPV_ESTADO_PUB_VENTA EPV"
				+ "   		WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_EPV_ID = EPV.DD_EPV_ID"
				+ "			AND EPV.DD_EPV_CODIGO = '01'"
				+ "         AND ACT.ACT_NUM_ACTIVO = " + numActivo + " ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoOcultoAlquiler(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_EPA_ESTADO_PUB_ALQUILER EPA"
				+ "   		WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_EPA_ID = EPA.DD_EPA_ID"
				+ "			AND EPA.DD_EPA_CODIGO = '04'"
				+ "         AND ACT.ACT_NUM_ACTIVO = " + numActivo + " ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoNoPublicadoAlquiler(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_EPA_ESTADO_PUB_ALQUILER EPA"
				+ "   		WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_EPA_ID = EPA.DD_EPA_ID"
				+ "			AND EPA.DD_EPA_CODIGO = '01'"
				+ "         AND ACT.ACT_NUM_ACTIVO = " + numActivo + " ");

		return !"0".equals(resultado);
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
	public boolean isProveedorSuministroVigente( String codRem ) {
		String sql = null;
		if ( codRem != null && codRem.length() > 0) {
			sql = "select count(1) from act_pve_proveedor pve "
		+		   "inner join dd_tpr_tipo_proveedor tpr on tpr.dd_tpr_id = pve.dd_tpr_id " 
		+		   "where pve.pve_cod_rem = "+ codRem
		+		   " and pve.borrado = 0  " 
		+		   " and pve.pve_fecha_baja is null " 
		+		   " and tpr.dd_tpr_codigo = 25 ";
			
		}
		
		return sql == null ? null : !"0".equals(rawDao.getExecuteSQL(sql));
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

		return !"0".equals(resultado);
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
		boolean actCanarias;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID "
				+ "JOIN BIE_BIEN BIE ON BIE.BIE_ID = ACT.BIE_ID "
				+ "JOIN BIE_LOCALIZACION LOC ON LOC.BIE_ID = BIE.BIE_ID "
				+ "JOIN REMMASTER.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID AND DD_PRV_CODIGO IN ('35', '38') "
				+ "WHERE ACT.ACT_NUM_ACTIVO = " + listaActivos.get(0) + " ");

		actCanarias = Integer.valueOf(resultado) > 0;

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
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM DD_SCR_SUBCARTERA SCR "
					+ "JOIN DD_CRA_CARTERA CRA ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.DD_CRA_CODIGO = '"+cartera+"' "
					+ "WHERE DD_SCR_CODIGO = '"+subcartera+"'");

			return (Integer.valueOf(resultado) > 0);
		}

		return false;
	}

	@Override
	public Boolean subtipoPerteneceTipoTitulo(String subtipo, String tipoTitulo){

		String resultado;

		if(!Checks.esNulo(tipoTitulo) && !Checks.esNulo(subtipo)){
			
			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM DD_STA_SUBTIPO_TITULO_ACTIVO STA "
				+ "JOIN DD_TTA_TIPO_TITULO_ACTIVO TTA ON STA.DD_TTA_ID = TTA.DD_TTA_ID AND TTA.DD_TTA_CODIGO = '"+tipoTitulo+"' "
				+ "WHERE STA.DD_STA_CODIGO = '"+subtipo+"'");

			return (Integer.valueOf(resultado) > 0);
		}
		return false;
	}


	@Override
	public Boolean esParGastoActivo(String numGasto, String numActivo){
		if(!StringUtils.isNumeric(numGasto) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM GLD_ENT ENT"
				+ " INNER JOIN GLD_TBJ TBJ ON TBJ.GLD_ID = ENT.GLD_ID" 
				+ " INNER JOIN GLD_GASTOS_LINEA_DETALLE GLD ON TBJ.GLD_ID = GLD.GLD_ID" 
				+ "	WHERE GLD.GPV_ID = (SELECT GPV_ID FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '"+numGasto+"')"
				+ " AND ENT.DD_ENT_ID = (SELECT DD_ENT_ID FROM DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO ='ACT') "
				+ "	AND ENT.ENT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '"+numActivo+"')");
		return !"0".equals(resultado);
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
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existePromocion(String promocion){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM ACT_ACTIVO "
				+ "WHERE ACT_COD_PROMOCION_PRINEX = '"+promocion+"'");
		return !"0".equals(resultado);
	}

	public Boolean mediadorExisteVigente(String codMediador){
		if(!Checks.esNulo(codMediador)){
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_PVE_PROVEEDOR "
					+ " WHERE PVE_COD_REM = "+ codMediador +" AND BORRADO = 0");

			if ((Integer.valueOf(resultado) > 0)) {
				resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_PVE_PROVEEDOR "
						+ " WHERE PVE_COD_REM = "+ codMediador +" AND PVE_FECHA_BAJA IS NULL OR PVE_FECHA_BAJA >= SYSDATE"
						+ " AND BORRADO = 0");

				return (Integer.valueOf(resultado) > 0);
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

		return !"0".equals(resultado);
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

		return !"0".equals(resultado);
	}

	@Override
	public Boolean esMismaProvincia(Long numActivo, Long numAgrupacion) {
		String prv_activo = rawDao.getExecuteSQL("SELECT PRV.DD_PRV_ID FROM ACT_ACTIVO ACT "
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

		String prv_agrupacion = rawDao.getExecuteSQL("SELECT PRV.DD_PRV_ID FROM ACT_AGR_AGRUPACION AGR "
				+ " JOIN ACT_PRY_PROYECTO PRY "
				+ " ON AGR.AGR_ID = PRY.AGR_ID "
				+ " JOIN REMMASTER.DD_PRV_PROVINCIA PRV "
				+ " ON PRV.DD_PRV_ID = PRY.DD_PRV_ID "
				+ " WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" "
				+ " AND AGR.BORRADO = 0 ");

		if(!Checks.esNulo(prv_activo) && !Checks.esNulo(prv_agrupacion)){
			return prv_activo.equals(prv_agrupacion);
		} else {
			return false;
		}
	}

	/**
	 *
	 * @param numActivo: número de activo haya
	 * @return devuelve true si un activo tiene un destino comercial de tipo venta (no confundir con venta y alquiler)
	 */
	@Override
	public Boolean activoConDestinoComercialVenta(String numActivo) {
		if(!Checks.esNulo(numActivo)){
			String resultado = rawDao.getExecuteSQL("select TCO.DD_TCO_CODIGO from ACT_ACTIVO act "
					 + " INNER JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
					 + " INNER JOIN DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID = TCO.DD_TCO_ID "
					 + " where act.ACT_NUM_ACTIVO = "+numActivo);

			return "01".equals(resultado);
		}

		return false;
	}

	/**
	 *
	 * @param numActivo: número de activo haya
	 * @return devuelve true si un activo tiene un destino comercial de tipo alquiler (no confundir con venta y alquiler)
	 */
	@Override
	public Boolean activoConDestinoComercialAlquiler(String numActivo) {

		if(!Checks.esNulo(numActivo)){
			String resultado = rawDao.getExecuteSQL("select TCO.DD_TCO_CODIGO from ACT_ACTIVO act "
					 + " INNER JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
					 + " INNER JOIN DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID = TCO.DD_TCO_ID "
					 + " where act.ACT_NUM_ACTIVO = "+numActivo);

			return "03".equals(resultado);
		}

		return false;
	}

	@Override
	public Boolean esActivoAlquilado(String numActivo) {

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_PTA_PATRIMONIO_ACTIVO pta, "
				+ "			  ACT_ACTIVO act, DD_EAL_ESTADO_ALQUILER eal "
				+ "			WHERE pta.act_id   = act.act_id "
				+ "			  AND pta.dd_eal_id = eal.dd_eal_id"
				+ "			  AND eal.dd_eal_codigo = '02' "
				+ "			  AND act.ACT_NUM_ACTIVO = "+numActivo+" "
				+ "			  AND act.borrado       = 0");

		return Integer.valueOf(resultado) > 0;

	}

	@Override
	public Boolean esAgrupacionTipoAlquiler(String numAgrupacion) {
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_AGR_AGRUPACION agr " +
				" INNER JOIN DD_TAG_TIPO_AGRUPACION tipo ON tipo.DD_TAG_ID = agr.DD_TAG_ID AND DD_TAG_CODIGO = '15'" +
				" WHERE agr.AGR_NUM_AGRUP_REM = '" + numAgrupacion + "'" +
				" AND agr.BORRADO = 0");

		return !"0".equals(resultado);
	}


	@Override
	public Boolean mismoTipoAlquilerActivoAgrupacion(String numAgrupacion, String numActivo) {
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;

		String tipoAlquilerAgrupacion = rawDao.getExecuteSQL("SELECT DD_TAL_ID FROM ACT_AGR_AGRUPACION agr WHERE agr.AGR_NUM_AGRUP_REM = '" + numAgrupacion + "'" +
				" AND agr.BORRADO = 0");

		String tipoAlquilerActivo = rawDao.getExecuteSQL("SELECT DD_TAL_ID FROM ACT_ACTIVO act WHERE act.ACT_NUM_ACTIVO = '" + numActivo + "'" +
				" AND act.BORRADO = 0");

		if (!Checks.esNulo(tipoAlquilerAgrupacion) && !tipoAlquilerAgrupacion.equals("")) {

			return tipoAlquilerAgrupacion.equals(tipoAlquilerActivo);

		} else {

			try {

				return tipoAlquilerActivo.equals(tipoAlquilerAgrupacion);

			} catch (Exception e) {
				return false;
			}

		}

	}


	@Override
	public Boolean esAgrupacionTipoComercialVenta(String numAgrupacion) {
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_AGR_AGRUPACION agr " +
				" INNER JOIN DD_TAG_TIPO_AGRUPACION tipo ON tipo.DD_TAG_ID = agr.DD_TAG_ID AND DD_TAG_CODIGO = '14'" +
				" WHERE agr.AGR_NUM_AGRUP_REM = '" + numAgrupacion + "'" +
				" AND agr.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public String getCodigoSubcarteraAgrupacion(String numAgrupacion) {
		String resultado = "";
		if(numAgrupacion != null && !numAgrupacion.isEmpty()){
			 resultado = rawDao.getExecuteSQL("SELECT scr.DD_SCR_CODIGO " +
			 		" FROM ACT_ACTIVO act  " +
			 		" INNER JOIN ACT_AGR_AGRUPACION agr ON agr.AGR_NUM_AGRUP_REM = '" + numAgrupacion + "'" +
			 		" INNER JOIN ACT_AGA_AGRUPACION_ACTIVO aga ON agr.AGR_ID = aga.AGR_ID AND aga.AGA_PRINCIPAL = 1 " +
			 		" INNER JOIN DD_SCR_SUBCARTERA scr ON act.DD_SCR_ID = scr.DD_SCR_ID  " +
			 		" WHERE act.ACT_ID = aga.ACT_ID");
		}
		return resultado;
	}

	@Override
	public Boolean esMismaLocalidad(Long numActivo, Long numAgrupacion) {
		String loc_activo = rawDao.getExecuteSQL("SELECT LOC.DD_LOC_ID FROM ACT_ACTIVO ACT "
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

		String loc_agrupacion = rawDao.getExecuteSQL("SELECT LOC.DD_LOC_ID FROM ACT_AGR_AGRUPACION AGR "
				+ " JOIN ACT_PRY_PROYECTO PRY "
				+ " ON AGR.AGR_ID = PRY.AGR_ID "
				+ " JOIN REMMASTER.DD_LOC_LOCALIDAD LOC "
				+ " ON LOC.DD_LOC_ID = PRY.DD_LOC_ID "
				+ " WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" "
				+ " AND AGR.BORRADO = 0 ");

		if(!Checks.esNulo(loc_activo) && !Checks.esNulo(loc_agrupacion)){
			return loc_activo.equals(loc_agrupacion);
		} else {
			return false;
		}
	}

	public Boolean existeActivoConOfertaVentaViva(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO ACT "
				+ " 	JOIN ACT_OFR ACTOF ON ACT.ACT_ID = ACTOF.ACT_ID "
				+ " 	JOIN OFR_OFERTAS OFR ON ACTOF.OFR_ID = OFR.OFR_ID "
				+ " 	JOIN DD_TOF_TIPOS_OFERTA TOF ON OFR.DD_TOF_ID = TOF.DD_TOF_ID "
				+ " 	JOIN DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID "
				+ "		WHERE ACT.ACT_NUM_ACTIVO ="+numActivo+" "
				+ " 	AND EOF.DD_EOF_CODIGO IN ('01','03','04')"
				+ "		AND TOF.DD_TOF_CODIGO = '01'");


		return !"0".equals(resultado);

	}

	public Boolean existeActivoConOfertaAlquilerViva(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO ACT "
				+ " 	JOIN ACT_OFR ACTOF ON ACT.ACT_ID = ACTOF.ACT_ID "
				+ " 	JOIN OFR_OFERTAS OFR ON ACTOF.OFR_ID = OFR.OFR_ID "
				+ " 	JOIN DD_TOF_TIPOS_OFERTA TOF ON OFR.DD_TOF_ID = TOF.DD_TOF_ID "
				+ " 	JOIN DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID "
				+ "		WHERE ACT.ACT_NUM_ACTIVO ="+numActivo+" "
				+ " 	AND EOF.DD_EOF_CODIGO IN ('01','03','04')"
				+ "		AND TOF.DD_TOF_CODIGO = '02'");


		return !"0".equals(resultado);

	}

	@Override
	public Boolean activoEnAgrupacionComercialViva(String numActivo) {

		String resultado = rawDao.getExecuteSQL("select count(agr.AGR_ID) from ACT_AGR_AGRUPACION agr " +
				" inner join DD_TAG_TIPO_AGRUPACION tag on tag.DD_TAG_ID = agr.DD_TAG_ID and (tag.DD_TAG_CODIGO = '14' or tag.DD_TAG_CODIGO = '15') " +
				" inner join ACT_AGA_AGRUPACION_ACTIVO aga on aga.AGR_ID = agr.AGR_ID " +
				" inner join ACT_ACTIVO act on act.ACT_ID = aga.ACT_ID and act.ACT_NUM_ACTIVO = " + numActivo +
				" where agr.AGR_FECHA_BAJA IS NULL AND agr.AGR_FIN_VIGENCIA >= sysdate " +
				" and act.borrado = 0" +
				" and agr.borrado = 0" +
				" and tag.borrado = 0" +
				" and aga.borrado = 0");

		return Integer.valueOf(resultado) > 0;

	}

	public String getCodigoDestinoComercialByNumActivo(String numActivo) {

		if(Checks.esNulo(numActivo))
			return null;

		return rawDao.getExecuteSQL("SELECT tco.DD_TCO_CODIGO FROM ACT_ACTIVO act "
				+ " INNER JOIN DD_TCO_TIPO_COMERCIALIZACION tco ON act.DD_TCO_ID = tco.DD_TCO_ID "
				+ " WHERE act.ACT_NUM_ACTIVO = "+numActivo+" AND act.BORRADO = 0");
	}

	@Override
	public Boolean isActivoPublicadoVenta(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_EPV_ESTADO_PUB_VENTA EPV"
				+ "   		WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_EPV_ID = EPV.DD_EPV_ID"
				+ "			AND EPV.DD_EPV_CODIGO = '03'"
				+ "         AND ACT.ACT_NUM_ACTIVO = " + numActivo + " ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoOcultoVentaPorMotivosManuales(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_MTO_MOTIVOS_OCULTACION MTO"
				+ "			WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_MTO_V_ID = MTO.DD_MTO_ID"
				+ "			AND MTO.DD_MTO_CODIGO IN ('09','10','11','12')"
				+ "			AND ACT.ACT_NUM_ACTIVO = " + numActivo + " ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoPublicadoAlquiler(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_EPA_ESTADO_PUB_ALQUILER EPA"
				+ "   		WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_EPA_ID = EPA.DD_EPA_ID"
				+ "			AND EPA.DD_EPA_CODIGO = '03'"
				+ "         AND ACT.ACT_NUM_ACTIVO = " + numActivo + " ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoOcultoAlquilerPorMotivosManuales(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_MTO_MOTIVOS_OCULTACION MTO"
				+ "			WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_MTO_A_ID = MTO.DD_MTO_ID"
				+ "			AND MTO.DD_MTO_CODIGO IN ('09','10','11','12')"
				+ "			AND ACT.ACT_NUM_ACTIVO = " + numActivo + " ");

		return !"0".equals(resultado);
	}


	@Override
	public Boolean esActivoConComunicacionComunicada(Long numActivoHaya) {
		String resultado = "0";
		if(numActivoHaya != null) {
			 resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_CMG_COMUNICACION_GENCAT com " +
			 		" WHERE com.ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '"+numActivoHaya+"') " +
			 		" AND com.DD_ECG_ID = ( " +
			 		" SELECT DD_ECG_ID FROM DD_ECG_ESTADO_COM_GENCAT WHERE DD_ECG_CODIGO = 'COMUNICADO')");
		}

		return !"0".equals(resultado);

	}

	public Boolean esActivoConComunicacionViva(Long numActivoHaya) {

		String resultado = "0";
		if(numActivoHaya != null) {
			resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_CMG_COMUNICACION_GENCAT com " +
			 		" WHERE com.ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '"+numActivoHaya+"') " +
			 		" AND com.DD_ECG_ID IN ( SELECT DD_ECG_ID FROM DD_ECG_ESTADO_COM_GENCAT WHERE DD_ECG_CODIGO IN ('CREADO','COMUNICADO'))");
		}

		return !"0".equals(resultado);

	}

	public Boolean esActivoSinComunicacionViva(Long numActivoHaya) {

		String resultado = "0";
		if(numActivoHaya != null) {
			resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_CMG_COMUNICACION_GENCAT com " +
			 		" WHERE com.ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '"+numActivoHaya+"') " +
			 		" AND com.DD_ECG_ID NOT IN ( SELECT DD_ECG_ID FROM DD_ECG_ESTADO_COM_GENCAT WHERE DD_ECG_CODIGO IN ('CREADO','COMUNICADO'))");
		}

		return "0".equals(resultado);

	}

	public Boolean esActivoConMultiplesComunicacionesVivas(Long numActivoHaya) {

		String resultado = "0";
		if(numActivoHaya != null) {
			resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_CMG_COMUNICACION_GENCAT com " +
			 		" WHERE com.ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '"+numActivoHaya+"') " +
			 		" AND com.DD_ECG_ID IN ( SELECT DD_ECG_ID FROM DD_ECG_ESTADO_COM_GENCAT WHERE DD_ECG_CODIGO IN ('CREADO','COMUNICADO'))");
		}

		return Integer.parseInt(resultado)>1;
	}

	public Boolean esNIFValido(String doc) {

		String[] asignacionLetraNIF = { "T", "R", "W", "A", "G", "M", "Y", "F", "P", "D", "X", "B", "N", "J", "Z", "S",
				"Q", "V", "H", "L", "C", "K", "E" };
		String[] asignacionLetraCIF = { "A", "B", "C", "D", "E", "F", "G", "H", "K", "L", "M", "N", "P", "Q", "S" , "U", "V", "W"};
		int resto;
		int numDoc;
		String letraDoc;
		String digitoFindoc;

		if (doc.length() != 9) {
			return false;
		} else {
			try {
				// NIF
				if (!Character.isLetter(doc.charAt(0))) {
					numDoc = Integer.parseInt(doc.substring(0, doc.length() - 1));
					letraDoc = String.valueOf(doc.charAt(8));
					resto = numDoc % 23;

					return letraDoc.equals(asignacionLetraNIF[resto]);

				// CIF
				} else {
					letraDoc = String.valueOf(doc.charAt(0)).toUpperCase();

					if (letraDoc.matches("^[KPQS]{1}")) {
						digitoFindoc = String.valueOf(doc.charAt(doc.length() - 1));
						return "ABCDEFGHIJ".contains(digitoFindoc);

					} else if (letraDoc.matches("^[ABEH]{1}")) {
						digitoFindoc = String.valueOf(doc.charAt(doc.length() - 1));
						Integer.parseInt(digitoFindoc);
						return true;
					} else {
						return Arrays.binarySearch(asignacionLetraCIF, letraDoc) >= 0;
					}
				}
			} catch (NumberFormatException ex) {
				return false;
			}
		}
	}

	@Override
	public boolean esActivoConComunicacionReclamada(Long numActivoHaya) {

		String resultado = "0";
		if(numActivoHaya != null) {
			resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_RCG_RECLAMACION_GENCAT rec " +
						" WHERE REC.CMG_ID = (SELECT CMG_ID FROM ACT_CMG_COMUNICACION_GENCAT com " +
						" WHERE com.ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO " +
						" WHERE ACT_NUM_ACTIVO = '"+numActivoHaya+"')) " +
						" AND RCG_FECHA_RECLAMACION IS NULL " +
						" AND RCG_FECHA_AVISO IS NOT NULL");
		}

		return !"0".equals(resultado);
	}

	@Override
	public Boolean esActivoConComunicacionGenerada(Long numActivoHaya) {

		String resultado = "0";
		if(numActivoHaya != null) {
			 resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_CMG_COMUNICACION_GENCAT cmg " +
			 		" JOIN   ACT_ADG_ADECUACION_GENCAT adg on cmg.cmg_id = adg.cmg_id" +
			 		" JOIN ACT_ACTIVO act on act.act_id = cmg.act_id"+
			 		" WHERE ACT_NUM_ACTIVO = '"+numActivoHaya+"' AND adg.BORRADO = 0");
		}

		return !"0".equals(resultado);

		}

	@Override
	public boolean esActivoConAdecuacionFinalizada(Long numActivoHaya) {
		String resultado = "0";
		if(numActivoHaya != null) {
			 resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " +
			 		"FROM ACT_ACTIVO ACT " +
			 	    "JOIN ACT_CMG_COMUNICACION_GENCAT CMG ON CMG.ACT_ID=ACT.ACT_ID " +
			 		"JOIN ACT_TRA_TRAMITE TRA ON ACT.ACT_ID=TRA.ACT_ID " +
			 		"JOIN DD_TPO_TIPO_PROCEDIMIENTO TPO ON TRA.DD_TPO_ID = TPO.DD_TPO_ID AND TPO.DD_TPO_CODIGO= 'T016' "+
			 		"JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TAP.DD_TPO_ID=TPO.DD_TPO_ID AND TAP.TAP_CODIGO = 'T016_ProcesoAdecuacion' " +
			 		"JOIN TAC_TAREAS_ACTIVOS TAC ON TRA.TRA_ID = TAC.TRA_ID " +
			 		"JOIN TAR_TAREAS_NOTIFICACIONES TAR ON TAC.TAR_ID = TAR.TAR_ID " +
			 		"JOIN TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID " +
			 		"WHERE ACT.ACT_NUM_ACTIVO='"+numActivoHaya+"' AND TAR.TAR_TAREA_FINALIZADA= 1");
		}

		return !"0".equals(resultado);
	}


	@Override
	public Boolean isAgrupacionSinActivoPrincipal(String mumAgrupacionRem) {
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_AGR_AGRUPACION agr "
				+ "			WHERE agr.AGR_NUM_AGRUP_REM = "+ mumAgrupacionRem
				+ "			AND agr.AGR_ACT_PRINCIPAL IS NOT NULL");

		return !"0".equals(resultado);
	}

	public Boolean isActivoFinanciero(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT"
				+ "			JOIN DD_TTA_TIPO_TITULO_ACTIVO TTA"
				+ "			ON ACT.DD_TTA_ID = TTA.DD_TTA_ID"
				+ "			WHERE TTA.DD_TTA_CODIGO IN ('03', '04')"
				+ "			AND ACT.ACT_NUM_ACTIVO = " + numActivo + " ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoIncluidoPerimetroAlquiler(String numActivo) {
			String resultado = rawDao.getExecuteSQL( "SELECT COUNT(1)"
				+"			FROM ACT_PTA_PATRIMONIO_ACTIVO acpt"
                +"			INNER JOIN ACT_ACTIVO act ON act.ACT_ID = acpt.ACT_ID AND act.ACT_NUM_ACTIVO = " + numActivo + ""
                +"			WHERE acpt.CHECK_HPM = 1"
			);

		return !"0".equals(resultado);
	}

	@Override
	public Boolean esAgrupacionVigente(String numAgrupacion){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_AGR_AGRUPACION WHERE "
				+ "		 	AGR_NUM_AGRUP_REM ="+numAgrupacion+" "
				+ "		 	AND BORRADO = 0 "
				+ "			AND AGR_FECHA_BAJA IS NULL");
		return !"0".equals(resultado);

	}
	@Override
	public Boolean existeCodImpuesto(String idImpuesto){
		if(Checks.esNulo(idImpuesto) || !StringUtils.isNumeric(idImpuesto))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_STG_SUBTIPOS_GASTO WHERE"
				+ "		 DD_STG_CODIGO ='"+idImpuesto+"'"
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean tieneActivoMatriz(String numAgrupacion){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_AGR_AGRUPACION AGR "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID "
				+ "WHERE AGR_NUM_AGRUP_REM ="+numAgrupacion+" "
				+ "AND AGR.BORRADO = 0 "
				+ "AND AGA.AGA_PRINCIPAL = 1"
				+ "AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = '16')");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoMatriz(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_AGR_AGRUPACION AGR "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID "
				+ "WHERE ACT.ACT_NUM_ACTIVO ="+numActivo+" "
				+ "AND AGR.BORRADO = 0 "
				+ "AND AGR.AGR_FECHA_BAJA IS NULL "
				+ "AND AGA.AGA_PRINCIPAL = 1"
				+ "AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = '16')");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isUA(String numActivo){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_AGR_AGRUPACION AGR "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID "
				+ "WHERE ACT.ACT_NUM_ACTIVO ="+numActivo+" "
				+ "AND AGR.BORRADO = 0"
				+ "AND AGR.AGR_FECHA_BAJA IS NULL "
				+ "AND AGA.AGA_PRINCIPAL = 0"
				+ "AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = '16')");
		return !"0".equals(resultado);
	}


	@Override
	public String getGestorComercialAlquilerByAgrupacion(String numAgrupacion){
		String username = rawDao.getExecuteSQL("SELECT USU.USU_USERNAME "
				+ "FROM GAC_GESTOR_ADD_ACTIVO GAC "
				+ "JOIN GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID "
				+ "JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID "
				+ "JOIN REMMASTER.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = GAC.ACT_ID "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = GAC.ACT_ID "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" "
				+ "AND AGA.AGA_PRINCIPAL = 1 "
				+ "AND TGE.DD_TGE_CODIGO = 'GESTCOMALQ' "
				+ "AND ROWNUM <= 1 ");
		return username;
	}

	@Override
	public String getSupervisorComercialAlquilerByAgrupacion(String numAgrupacion){
		String username = rawDao.getExecuteSQL("SELECT USU.USU_USERNAME "
				+ "FROM GAC_GESTOR_ADD_ACTIVO GAC "
				+ "JOIN GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID "
				+ "JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID "
				+ "JOIN REMMASTER.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = GAC.ACT_ID "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = GAC.ACT_ID "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" "
				+ "AND AGA.AGA_PRINCIPAL = 1 "
				+ "AND TGE.DD_TGE_CODIGO = 'SUPCOMALQ' "
				+ "AND ROWNUM <= 1");
		return username;
	}

	@Override
	public String getSuperficieConstruidaActivoMatrizByAgrupacion(String numAgrupacion){
		String superficie =rawDao.getExecuteSQL("SELECT BDR.BIE_DREG_SUPERFICIE_CONSTRUIDA "
				+ "FROM BIE_DATOS_REGISTRALES BDR "
				+ "JOIN ACT_ACTIVO ACT ON BDR.BIE_ID = ACT.BIE_ID "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID  "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" "
				+ "AND AGA.AGA_PRINCIPAL = 1");

		return superficie;
	}

	@Override
	public String getSuperficieConstruidaPromocionAlquilerByAgrupacion(String numAgrupacion){
		String superficie =rawDao.getExecuteSQL("SELECT SUM(BDR.BIE_DREG_SUPERFICIE_CONSTRUIDA) "
				+ "FROM BIE_DATOS_REGISTRALES BDR "
				+ "JOIN ACT_ACTIVO ACT ON BDR.BIE_ID = ACT.BIE_ID "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND AGA.BORRADO = 0"
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID  "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" "
				+ "AND AGA.AGA_PRINCIPAL <> 1");

		return superficie;
	}

	@Override
	public String getSuperficieUtilActivoMatrizByAgrupacion(String numAgrupacion){
		String superficie =rawDao.getExecuteSQL("SELECT REG.REG_SUPERFICIE_UTIL "
				+ "FROM ACT_REG_INFO_REGISTRAL REG "
				+ "JOIN ACT_ACTIVO ACT ON REG.ACT_ID = ACT.ACT_ID "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID  "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" "
				+ "AND AGA.AGA_PRINCIPAL = 1");

		return superficie;
	}

	@Override
	public String getSuperficieUtilPromocionAlquilerByAgrupacion(String numAgrupacion){
		String superficie =rawDao.getExecuteSQL("SELECT SUM(REG.REG_SUPERFICIE_UTIL) "
				+ "FROM ACT_REG_INFO_REGISTRAL REG "
				+ "JOIN ACT_ACTIVO ACT ON REG.ACT_ID = ACT.ACT_ID "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND AGA.BORRADO = 0"
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID  "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" "
				+ "AND AGA.AGA_PRINCIPAL <> 1");

		return superficie;
	}

	@Override
	public String getProcentajeTotalActualPromocionAlquiler(String numAgrupacion){
		String porcentaje =rawDao.getExecuteSQL("SELECT SUM(ACT_AGA_PARTICIPACION_UA) "
				+ "FROM ACT_AGA_AGRUPACION_ACTIVO AGA "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = "+numAgrupacion+" "
				+ "AND AGA.AGA_PRINCIPAL <> 1 AND AGA.BORRADO = 0");

		return porcentaje;
	}

	@Override
	public Boolean existePeriodicidad(String codPeriodicidad) {
		if(Checks.esNulo(codPeriodicidad))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM DD_TPE_TIPOS_PERIOCIDAD"
				+"		WHERE DD_TPE_CODIGO = '"+codPeriodicidad+"'"
				+"		AND BORRADO= 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeCalculo(String codCalculo) {
		if(Checks.esNulo(codCalculo))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM DD_CAI_CALCULO_IMPUESTO"
				+"		WHERE DD_CAI_CODIGO = '"+codCalculo+"'"
				+"		AND BORRADO= 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeTrabajo(String numTrabajo) {
		if(Checks.esNulo(numTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ACT_TBJ_TRABAJO"
				+"		WHERE TBJ_NUM_TRABAJO = "+numTrabajo+""
				+"		AND BORRADO= 0");

		return !"0".equals(resultado);

	}
	
	@Override
	public Boolean estadoPrevioTrabajo(String celdaTrabajo) {
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)  "
				+"		FROM ACT_TBJ_TRABAJO"
				+"		WHERE TBJ_NUM_TRABAJO = "+celdaTrabajo+""
				+"	AND dd_est_id in ('62','65') AND BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean estadoPrevioTrabajoFinalizado(String celdaTrabajo) {
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)  "
				+"		FROM ACT_TBJ_TRABAJO"
				+"		WHERE TBJ_NUM_TRABAJO = "+celdaTrabajo+""
				+"	AND dd_est_id = 61 AND BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean fechaEjecucionCumplimentada(String celdaTrabajo) {
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)  "
				+"		FROM ACT_TBJ_TRABAJO"
				+"		WHERE TBJ_NUM_TRABAJO = "+celdaTrabajo+""
				+"	AND tbj_fecha_ejecutado IS NOT NULL AND BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean resolucionComite(String celdaTrabajo) {
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)  "
				+"		FROM ACT_TBJ_TRABAJO tbj join DD_ACO_APROBACION_COMITE aco on tbj.dd_aco_id = aco.dd_aco_id and aco.borrado = 0"
				+"		WHERE tbj.TBJ_NUM_TRABAJO = "+celdaTrabajo+""
				+"	AND tbj.tbj_aplica_comite = '1' AND aco.dd_aco_codigo = 'APR' AND tbj.BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean checkComite(String celdaTrabajo) {
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)  "
				+"		FROM ACT_TBJ_TRABAJO"
				+"		WHERE TBJ_NUM_TRABAJO = "+celdaTrabajo+""
				+"	AND tbj_aplica_comite = '1' AND BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean tieneLlaves(String celdaTrabajo) {
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("Select count(1) from act_tbj_trabajo tbj  "
				+"		join cfg_visualizar_llaves cvl on tbj.dd_ttr_id = cvl.dd_ttr_id and tbj.dd_str_id = cvl.dd_str_id and cvl.visualizacion_llaves = 1 and cvl.BORRADO=0 "
				+"		where tbj.TBJ_NUM_TRABAJO ="+celdaTrabajo+""
				+"		AND tbj.BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean checkLlaves(String celdaTrabajo) {
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("Select count(1) from act_tbj_trabajo tbj  "
				+"		where tbj.TBJ_NUM_TRABAJO ="+celdaTrabajo+""
				+"		and tbj.TBJ_NO_APLICA_LLAVES=1	AND tbj.BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean checkProveedoresLlaves(String celdaTrabajo) {
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("Select count(1) from act_tbj_trabajo tbj  "
				+"		where tbj.TBJ_NUM_TRABAJO ="+celdaTrabajo+""
				+"		AND TBJ_FECHA_ENTREGA_LLAVES is not null and PVC_ID_LLAVES is not null	AND tbj.BORRADO= 0");

		return "1".equals(resultado);

	}

	@Override
	public Boolean existeSubtrabajo(String codSubtrabajo) {
		if(Checks.esNulo(codSubtrabajo))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM DD_STR_SUBTIPO_TRABAJO"
				+"		WHERE DD_STR_ID = "+codSubtrabajo+""
				+"		AND BORRADO= 0");

		return "0".equals(resultado);
	}

	@Override
	public Boolean existeGastoTrabajo(String numTrabajo) {
		if(Checks.esNulo(numTrabajo))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT"
				+ " CASE WHEN ( "
				+ "		SELECT COUNT(*)	"
				+ "		FROM ACT_TBJ_TRABAJO TBJ "
				+ "		INNER JOIN GLD_TBJ GTBJ ON GTBJ.TBJ_ID = TBJ.TBJ_ID AND GTBJ.BORRADO =0 "
				+ " 	WHERE TBJ.TBJ_NUM_TRABAJO = " + numTrabajo + " 	AND TBJ.BORRADO=0 "
				+ "		GROUP BY TBJ.TBJ_NUM_TRABAJO"
				+ "	) is null THEN 0"
				+ "	 ELSE 1 END AS RESULTADO "
				+ "	FROM DUAL");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoNotBankiaLiberbank(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM ACT_ACTIVO ACT "
					+"		WHERE ACT.DD_CRA_ID NOT IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
					+"								WHERE DD_CRA_CODIGO IN ('03','08')"
					+"								AND BORRADO = 0) "
					+"		AND ACT.ACT_NUM_ACTIVO = "+ numActivo +"");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean isActivoBankia(String numActivo) {
		if(Checks.esNulo(numActivo))
			return false;

			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM ACT_ACTIVO ACT "
					+"		WHERE ACT.DD_CRA_ID IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
					+"								WHERE DD_CRA_CODIGO IN ('03')"
					+"								AND BORRADO = 0) "
					+"		AND ACT.ACT_NUM_ACTIVO = "+ numActivo +"");

		return !"0".equals(resultado);
	}

	public Boolean validadorTipoOferta(Long numExpediente) {
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID"
				+"		AND OFR.DD_TOF_ID = (SELECT DD_TOF_ID FROM DD_TOF_TIPOS_OFERTA TOF"
				+"		WHERE TOF.DD_TOF_CODIGO = '01' AND TOF.BORRADO = 0)"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE =  "+numExpediente+""
				+"		AND ECO.BORRADO = 0 AND OFR.BORRADO = 0");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean esUnidadAlquilable(String numActivo) {
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_ACTIVO ACT "
				+ "LEFT JOIN DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID = ACT.DD_TTA_ID "
				+ "WHERE TTA.DD_TTA_CODIGO = '05' "
				+ "AND ACT.ACT_NUM_ACTIVO = '" + numActivo + "'");

		return !"0".equals(resultado);		
	}
	
	@Override
	public Boolean validadorTipoCartera(Long numExpediente) {
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID"
				+"		JOIN ACT_OFR AFR ON AFR.OFR_ID = OFR.OFR_ID"
				+"		JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AFR.ACT_ID"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0"
				+"		AND ACT.BORRADO = 0 AND OFR.BORRADO = 0"
				+"		AND EXISTS (SELECT 1 FROM ACT_ACTIVO ACT1"
				+"		JOIN DD_SCR_SUBCARTERA DD ON ACT1.DD_SCR_ID = DD.DD_SCR_ID"
				+"		WHERE DD.DD_SCR_CODIGO IN ('05','07','08','09','14','15','19','18','56','57','58','59','60','136','64')"
				+"		AND ACT.ACT_ID = ACT1.ACT_ID)");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean validadorCarteraBankia(Long numExpediente) {
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID"
				+"		JOIN ACT_OFR AFR ON AFR.OFR_ID = OFR.OFR_ID"
				+"		JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AFR.ACT_ID"
				+"		JOIN DD_CRA_CARTERA DD ON ACT.DD_CRA_ID = DD.DD_CRA_ID"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0"
				+"		AND ACT.BORRADO = 0 AND OFR.BORRADO = 0 AND DD.DD_CRA_CODIGO ='03'");
		if(!Checks.esNulo(resultado) && Integer.valueOf(resultado) > 0){
			return true;
		}else{
			return false;
		}
	}

	@Override
	public Boolean validadorCarteraLiberbank(Long numExpediente) {
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID"
				+"		JOIN ACT_OFR AFR ON AFR.OFR_ID = OFR.OFR_ID"
				+"		JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AFR.ACT_ID"
				+"		JOIN DD_CRA_CARTERA DD ON ACT.DD_CRA_ID = DD.DD_CRA_ID"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0"
				+"		AND ACT.BORRADO = 0 AND OFR.BORRADO = 0 AND DD.DD_CRA_CODIGO ='08'");

		if(!Checks.esNulo(resultado) && Integer.valueOf(resultado) > 0){
			return true;
		}else{
			return false;
		}

	}



	@Override
	public Boolean validadorEstadoOfertaTramitada(Long numExpediente) {
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0 AND OFR.BORRADO = 0"
				+"		AND OFR.DD_EOF_ID IN (SELECT EEO.DD_EOF_ID"
				+"		FROM DD_EOF_ESTADOS_OFERTA EEO"
				+"		WHERE EEO.DD_EOF_CODIGO <> '01')");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean validadorEstadoExpedienteSolicitado(Long numExpediente) {
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0"
				+"		AND ECO.DD_EEC_ID NOT IN (SELECT EEC.DD_EEC_ID"
				+"		FROM DD_EEC_EST_EXP_COMERCIAL EEC"
				+"		WHERE EEC.DD_EEC_CODIGO IN ('01','03','04','05','06','08','10','11','16'))");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean validadorFechaMayorIgualFechaAltaOferta(Long numExpediente, String fecha) {
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0 AND OFR.BORRADO = 0"
				+"		AND nvl(OFR.OFR_FECHA_ALTA, TO_DATE('01/01/1500','dd/MM/yy')) < TO_DATE('"+ fecha +"','dd/MM/yy')+1");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean validadorFechaMayorIgualFechaSancion(Long numExpediente, String fecha) {
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0"
				+"		AND nvl(ECO.ECO_FECHA_SANCION, TO_DATE('01/01/1500','dd/MM/yy')) < TO_DATE('"+ fecha +"','dd/MM/yy')+1");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean validadorFechaMayorIgualFechaAceptacion(Long numExpediente, String fecha) {
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0"
				+"		AND nvl(ECO.ECO_FECHA_ALTA, TO_DATE('01/01/1500','dd/MM/yy')) < TO_DATE('"+ fecha +"','dd/MM/yy')+1");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean validadorFechaMayorIgualFechaReserva(Long numExpediente, String fecha) {
		if(Checks.esNulo(numExpediente))
			return true;

		String existeReserva = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"  	FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+" 		JOIN RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID"
				+" 		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0 AND RES.BORRADO = 0");

		if("1".equals(existeReserva)) {
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*)  "
					+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
					+"		JOIN RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID"
					+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0 AND RES.BORRADO = 0"
					+"		AND nvl(RES.RES_FECHA_FIRMA, TO_DATE('01/01/1500','dd/MM/yy')) < TO_DATE('"+ fecha +"','dd/MM/yy')+1");

			return !"1".equals(resultado);
		} else {
			return false;
		}
	}

	@Override
	public Boolean validadorFechaMayorIgualFechaVenta(Long numExpediente, String fecha) {
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0"
				+"		AND nvl(ECO.ECO_FECHA_VENTA, TO_DATE('01/01/1500','dd/MM/yy')) < TO_DATE('"+ fecha +"','dd/MM/yy')+1");

		return !"1".equals(resultado);
	}

	@Override
	public List<BigDecimal> activosEnAgrupacion(String numOferta){
		if(Checks.esNulo(numOferta))
			return null;
		List<BigDecimal> numActius = new ArrayList<BigDecimal>();
		List<Object> resultat = rawDao.getExecuteSQLList("SELECT ACT.ACT_NUM_ACTIVO FROM OFR_OFERTAS OFR " +
				"INNER JOIN ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID " +
				"INNER JOIN ACT_ACTIVO ACT ON AO.ACT_ID = ACT.ACT_ID " +
				"WHERE OFR.OFR_NUM_OFERTA = '" + numOferta + "'");

		for(int i = 0; i < resultat.size(); i++) {
			numActius.add((BigDecimal) resultat.get(i));
		}
		return numActius;
	}


	@Override

	public Boolean compararNumeroFilasTrabajo(String numTrabajo, int numeroFilas) {
		if(Checks.esNulo(numTrabajo))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT CASE WHEN numeroTarifas = " + numeroFilas + " THEN 1"
				+"		ELSE 0 END"
				+"		FROM("
				+"		SELECT COUNT(*) numeroTarifas "
				+"		FROM REM01.ACT_TCT_TRABAJO_CFGTARIFA  TCT"
				+"		INNER JOIN REM01.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID=TCT.TBJ_ID AND TBJ.BORRADO=0 AND TBJ.TBJ_NUM_TRABAJO=  "+ numTrabajo
				+"		WHERE TCT.BORRADO=0"
				+"		GROUP BY TBJ.TBJ_NUM_TRABAJO)");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean existeTipoTarifa(String tipoTarifa) {
		if(Checks.esNulo(tipoTarifa))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*)"
				+"		FROM DD_TTF_TIPO_TARIFA"
				+"		WHERE BORRADO=0"
				+"		AND DD_TTF_CODIGO = "+ "'"+ tipoTarifa +"'"
				+"		GROUP BY DD_TTF_CODIGO");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean tipoTarifaValido(String tipoTarifa, String numTrabajo) {
		if(Checks.esNulo(tipoTarifa))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT"
				+"		CASE WHEN("
				+"		SELECT COUNT(*) cuentaTipos"
				+"		FROM ACT_TBJ_TRABAJO TBJ"
				+"		INNER JOIN ACT_TCT_TRABAJO_CFGTARIFA TCT ON TCT.TBJ_ID=TBJ.TBJ_ID AND TCT.BORRADO=0"
				+"		INNER JOIN ACT_CFT_CONFIG_TARIFA CFT ON CFT.CFT_ID=TCT.CFT_ID AND CFT.BORRADO=0"
				+"		INNER JOIN REM01.DD_TTF_TIPO_TARIFA TTF ON TTF.DD_TTF_ID=CFT.DD_TTF_ID AND TTF.BORRADO=0 AND TTF.DD_TTF_CODIGO = "+ "'"+ tipoTarifa +"'"
				+"		WHERE TBJ.TBJ_NUM_TRABAJO="+numTrabajo+""
				+"		GROUP BY TTF.DD_TTF_CODIGO)  IS NULL THEN 0"
				+"		ELSE 1"
				+"		END"
				+"		FROM dual");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean existeEntidadFinanciera(String entidadFinanciera){
		if(Checks.esNulo(entidadFinanciera))
			return true;
		if(!Checks.esNulo(entidadFinanciera) && !StringUtils.isNumeric(entidadFinanciera))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT (*) "
				+ "FROM DD_ETF_ENTIDAD_FINANCIERA DDETF WHERE "
				+ "DDETF.DD_ETF_CODIGO = '"+entidadFinanciera+"' "
				+" AND DDETF.BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeTipoDeFinanciacion(String tipoFinanciacion){
		if(Checks.esNulo(tipoFinanciacion))
			return true;
		if(!Checks.esNulo(tipoFinanciacion) && !StringUtils.isNumeric(tipoFinanciacion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT (*) "
				+ "FROM DD_TRC_TIPO_RIESGO_CLASE DDTRC WHERE "
				+ "DDTRC.DD_TRC_CODIGO = '"+tipoFinanciacion+"' "
				+" AND DDTRC.BORRADO = 0");
		return !"0".equals(resultado);
	}


	@Override
	public Boolean perteneceOfertaVenta(String numExpedienteComercial){
		if(Checks.esNulo(numExpedienteComercial) || !StringUtils.isNumeric(numExpedienteComercial))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM ECO_EXPEDIENTE_COMERCIAL ECO" +
				"	JOIN OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID AND OFR.BORRADO = 0" +
				"	LEFT JOIN DD_TOF_TIPOS_OFERTA TOF ON OFR.DD_TOF_ID = TOF.DD_TOF_ID AND TOF.BORRADO = 0" +
				"	WHERE ECO.ECO_NUM_EXPEDIENTE = '" +numExpedienteComercial +"' AND TOF.DD_TOF_CODIGO != '01' AND ECO.BORRADO = 0");
		return "0".equals(resultado);
	}


	@Override
	public Boolean activosVendidos(String numExpedienteComercial){
		if(Checks.esNulo(numExpedienteComercial) || !StringUtils.isNumeric(numExpedienteComercial))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM ECO_EXPEDIENTE_COMERCIAL ECO " +
				" JOIN ACT_OFR ACT_OFR ON ECO.OFR_ID = ACT_OFR.OFR_ID " +
				" JOIN ACT_ACTIVO ACT ON ACT_OFR.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0" +
				" LEFT JOIN DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID = SCM.DD_SCM_ID AND SCM.BORRADO = 0" +
				" WHERE ECO.ECO_NUM_EXPEDIENTE = '" +numExpedienteComercial +"' AND SCM.DD_SCM_CODIGO = '05' AND ECO.BORRADO = 0");
		return "0".equals(resultado);
	}

	public Boolean perteneceDDEstadoActivo(String codigoEstadoActivo) {
		if(!Checks.esNulo(codigoEstadoActivo)) {
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+ "FROM DD_EAC_ESTADO_ACTIVO "
					+ "WHERE DD_EAC_CODIGO = '" + codigoEstadoActivo +"'");

			return  !"0".equals(resultado);
		}
		return false;
	}

	@Override
	public Boolean perteneceDDTipoTituloTPA(String codigoTituloTPA) {
		if (!Checks.esNulo(codigoTituloTPA)) {
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+ "FROM DD_TPA_TIPO_TITULO_ACT "
					+ "WHERE DD_TPA_CODIGO ='" + codigoTituloTPA + "'");

			return !"0".equals(resultado);
		}
		return false;
	}

	@Override
	public Boolean existeActivoAsociado(String numActivo) {
		if(Checks.esNulo(numActivo)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PDV_PLAN_DIN_VENTAS WHERE"
				+ "		 	ACT_ID = (SELECT ACT.ACT_ID FROM ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = "+numActivo+") "
				+ "		 	AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeActivoPlusvalia(String numActivo) {
		if(Checks.esNulo(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_PLS_PLUSVALIA pls " +
				"JOIN ACT_ACTIVO act ON pls.act_id = act.act_id " +
				"WHERE pls.borrado = 0 " +
				"AND act.ACT_NUM_ACTIVO = '" + numActivo + "'");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esActivoUA(String numActivo) {
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_ACTIVO ACT "
				+ "LEFT JOIN DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID = ACT.DD_TTA_ID "
				+ "WHERE TTA.DD_TTA_CODIGO = '05' "
				+ "AND ACT.ACT_NUM_ACTIVO = '" + numActivo + "'");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean esAccionValido(String codAccion) {
		if(Checks.esNulo(codAccion)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM DD_ACM_ACCION_MASIVA ACM "
				+ "WHERE ACM.DD_ACM_CODIGO ='" + codAccion + "'");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isTotalOfertaDistintoSumaActivos(Double importe, String numExpedienteComercial ) {
		if (!Checks.esNulo(numExpedienteComercial) && !Checks.esNulo(importe)) {
			String resultado = rawDao.getExecuteSQL("SELECT COUNT (*) "
					+ "				FROM ECO_EXPEDIENTE_COMERCIAL EXP " 
					+ "				JOIN OFR_OFERTAS OFR " 
					+ "				ON OFR.OFR_ID = EXP.OFR_ID "
					+ "				WHERE EXP.ECO_NUM_EXPEDIENTE='" + numExpedienteComercial+"'"
					+ "				AND OFR.BORRADO = 0 "
					+ "				AND OFR.OFR_IMPORTE = "+importe);
			return "0".equals(resultado);
		}
		return true;
	}

	@Override
	public Boolean isNullImporteActivos(String numExpedienteComercial) {
		if (Checks.esNulo(numExpedienteComercial)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT	COUNT(*) "  
				+ "		FROM ECO_EXPEDIENTE_COMERCIAL EXP "  
				+ "		JOIN OFR_OFERTAS OFR "  
				+ "		ON OFR.OFR_ID = EXP.OFR_ID "  
				+ "		JOIN ACT_OFR AXO " 
				+ "		ON AXO.OFR_ID = OFR.OFR_ID " 
				+ "		JOIN ACT_ACTIVO ACT " 
				+ "		ON AXO.ACT_ID = ACT.ACT_ID "  
				+ "		WHERE EXP.ECO_NUM_EXPEDIENTE= '" + numExpedienteComercial +"'" 
				+ "		AND AXO.ACT_OFR_IMPORTE IS NULL"  
				+ "		AND OFR.BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isAllActivosEnOferta(String numExpedienteComercial, Hashtable <String, Integer> activos) {
		if (Checks.esNulo(numExpedienteComercial) || Checks.estaVacio(activos)) return false; 
		String sql = "	SELECT COUNT(*) "
					+"			FROM ECO_EXPEDIENTE_COMERCIAL EXP " 
					+"			JOIN OFR_OFERTAS OFR "
					+"			ON OFR.OFR_ID = EXP.OFR_ID "
					+"			JOIN ACT_OFR AXO "
					+"			ON AXO.OFR_ID = OFR.OFR_ID "
					+"			JOIN ACT_ACTIVO ACT "
					+"			ON AXO.ACT_ID = ACT.ACT_ID "
					+"			WHERE EXP.ECO_NUM_EXPEDIENTE='"+numExpedienteComercial+"'"
					+"			AND OFR.BORRADO = 0 ";
		String resultado = rawDao.getExecuteSQL(sql);
		Enumeration <String> claves = activos.keys();
		String condicion = "AND (";
		while (claves.hasMoreElements()) {
			sql += condicion + " ACT.ACT_NUM_ACTIVO='"+claves.nextElement()+"' ";
			condicion = " OR ";
		}
		if (condicion.equals(" OR ")) {
			sql += ")";
		}
		return resultado.equals(rawDao.getExecuteSQL(sql));
	}
	
	public Boolean esResultadoValido(String codResultado) {
		if(Checks.esNulo(codResultado)) {
			return true;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM DD_RES_RESULTADO_SOLICITUD RES "
				+ "WHERE RES.DD_RES_CODIGO ='" + codResultado + "'");

		return !"0".equals(resultado);
	}
	
	public Boolean esMotivoExento(String codResultado) {
		if(Checks.esNulo(codResultado)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "FROM DD_MOE_MOTIVO_EXENTO MOE "
				+ "WHERE MOE.DD_MOE_CODIGO ='" + codResultado + "'");

		return !"0".equals(resultado);
	}
	
	public Boolean esTipoTributoValido(String codTipoTributo) {
		if(Checks.esNulo(codTipoTributo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM DD_TPT_TIPO_TRIBUTO TPT "
				+ "WHERE TPT.DD_TPT_CODIGO = '" + codTipoTributo + "'");

		return !"0".equals(resultado);
	}
	

	@Override
	public Boolean esSolicitudValido(String codSolicitud){
		if(Checks.esNulo(codSolicitud)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM DD_TST_TIPO_SOLICITUD_TRIB TST "
				+ "WHERE TST.DD_TST_CODIGO ='" + codSolicitud + "'");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeActivoTributo(String numActivo, String fechaRecurso, String tipoSolicitud, String idTributo){
		if(Checks.esNulo(numActivo) || Checks.esNulo(tipoSolicitud) || !StringUtils.isNumeric(idTributo)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(*) "
				+ "FROM ACT_TRI_TRIBUTOS TRI "
				+ "JOIN DD_TST_TIPO_SOLICITUD_TRIB TST ON TST.DD_TST_ID = TRI.DD_TST_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = TRI.ACT_ID "
				+ "WHERE TST.DD_TST_CODIGO = '" + tipoSolicitud + "' "
				+ "AND TRI.BORRADO = 0 "
				+ "AND ACT.ACT_NUM_ACTIVO = '" + numActivo + "' "
				+ "AND TRI.ACT_TRI_FECHA_PRESENTACION_RECURSO = TO_DATE('"+ fechaRecurso + "','dd/MM/yy') "
				+ "AND TRI.ACT_NUM_TRIBUTO = '" + idTributo + "' "
				);

		return !"0".equals(resultado);
	}

	@Override
	public String getIdActivoTributo(String numActivo, String fechaRecurso, String tipoSolicitud, String idTributo){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo) || Checks.esNulo(tipoSolicitud) || !StringUtils.isNumeric(tipoSolicitud) || !StringUtils.isNumeric(idTributo)) {
			return null;
		}

		return rawDao.getExecuteSQL(
				"SELECT TRI.ACT_TRI_ID "
				+ "FROM ACT_TRI_TRIBUTOS TRI "
				+ "JOIN DD_TST_TIPO_SOLICITUD_TRIB TST ON TST.DD_TST_ID = TRI.DD_TST_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = TRI.ACT_ID "
				+ "WHERE TST.DD_TST_CODIGO = '" + tipoSolicitud + "' "
				+ "AND TRI.BORRADO = 0 "
				+ "AND ACT.ACT_NUM_ACTIVO = '" + numActivo + "' "
				+ "AND TRI.ACT_TRI_FECHA_PRESENTACION_RECURSO = TO_DATE('"+ fechaRecurso + "','dd/MM/yy') "
				+ "AND TRI.ACT_NUM_TRIBUTO = '" + idTributo + "' "
				);

	}

	@Override
	public Boolean esNumHayaVinculado(Long numGasto, String numActivo){
		if(Checks.esNulo(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM GPV_GASTOS_PROVEEDOR GPV "
				+ "INNER JOIN GLD_GASTOS_LINEA_DETALLE GLD ON GPV.GPV_ID = GLD.GPV_ID "
				+ "INNER JOIN GLD_TBJ TBJ ON TBJ.GLD_ID = GLD.GLD_ID "
				+ "INNER JOIN GLD_ENT ENT ON ENT.GLD_ID = TBJ.GLD_ID "
				+ "INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = ENT.ENT_ID "
				+ "WHERE GPV.GPV_NUM_GASTO_HAYA = " + numGasto
				+ " AND ENT.DD_ENT_ID = (SELECT DD_ENT_ID FROM DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO ='ACT') "
				+ " AND ACT.ACT_NUM_ACTIVO = '" + numActivo + "'"
				);

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esnNumExpedienteValido(Long expComercial){
		if(Checks.esNulo(expComercial)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ECO_EXPEDIENTE_COMERCIAL EX "
				+ "JOIN ACT_TRI_TRIBUTOS TRI ON TRI.ECO_ID = EX.ECO_ID "
				+ "WHERE TRI.ECO_ID = '" + expComercial + "'"
				);

		return !"0".equals(resultado);
	}


	@Override
	public Boolean existeJunta(String numActivo,  String fechaJunta) {
		if(Checks.esNulo(numActivo)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM ACT_JCM_JUNTA_COM_PROPIETARIOS pls " +
				"JOIN ACT_ACTIVO act ON pls.act_id = act.act_id " +
				"WHERE pls.borrado = 0 " +
				"AND act.ACT_NUM_ACTIVO = '"+numActivo+"' " +
				"AND TRUNC(pls.JCM_FECHA_JUNTA) = TRUNC(TO_DATE('"+fechaJunta+"','dd/MM/yy'))");

		return !"0".equals(resultado);

	}

	@Override
	public Boolean existeCodJGOJE(String codJunta) {
		if(Checks.esNulo(codJunta) || !StringUtils.isNumeric(codJunta)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_JCP_JUNTA_COMUNIDADES WHERE"
				+ "		 DD_JCP_CODIGO ='"+codJunta+"'"
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	

	@Override
	public Boolean conTituloOcupadoSi(String codigoTituloTPA) {
		if (!Checks.esNulo(codigoTituloTPA)) {
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+ "FROM DD_TPA_TIPO_TITULO_ACT "
					+ "WHERE DD_TPA_CODIGO IN ('01','02','03') "
					+ "AND DD_TPA_CODIGO ='" + codigoTituloTPA + "'");

			return !"0".equals(resultado);
		}
		return false;
	}
	
	@Override
	public Boolean tipoDeElemento(String tipoElemento) {
		if (!Checks.esNulo(tipoElemento)) {
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) from DD_ENT_ENTIDAD_GASTO  " + 
					"WHERE DD_ENT_CODIGO =" + 
					"'" + tipoElemento + "'");

			return !"0".equals(resultado);
		}
		return false;
	}

	@Override
	public Boolean conPosesion(String numActivo) {
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT Count(*) "
				+ "FROM ACT_SPS_SIT_POSESORIA SPS "
				+ "JOIN ACT_ACTIVO ACT ON SPS.ACT_ID = ACT.ACT_ID "
				+ "WHERE SPS_FECHA_TOMA_POSESION IS NOT NULL "
				+ "AND ACT.ACT_NUM_ACTIVO = '" + numActivo + "'");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean perteneceDDEstadoDivHorizontal(String codigoEstadoDivHorizontal) {
		if(Checks.esNulo(codigoEstadoDivHorizontal)) {
			return false;
		}
			String resultado = rawDao.getExecuteSQL("SELECT Count(*) "
					+ "FROM DD_EDH_ESTADO_DIV_HORIZONTAL "
					+ "WHERE DD_EDH_CODIGO ='" + codigoEstadoDivHorizontal + "'");

			return !"0".equals(resultado);
	}
	
	@Override
	public Boolean perteneceDDServicerActivo(String codigoServicer) {
		if(Checks.esNulo(codigoServicer)) {
			return false;
		}					
			String resultado = rawDao.getExecuteSQL("SELECT Count(*) " 
					+ "FROM DD_SRA_SERVICER_ACTIVO "
					+ "WHERE DD_SRA_CODIGO ='" + codigoServicer + "'");

			return !"0".equals(resultado);		
	}
	
	@Override
	public Boolean perteneceDDCesionComercial(String codigoCesion) {
		if(Checks.esNulo(codigoCesion)) {
			return false;
		}					
			String resultado = rawDao.getExecuteSQL("SELECT Count(*) " 
					+ "FROM DD_CMS_CESION_COM_SANEAMIENTO "
					+ "WHERE DD_CMS_CODIGO ='" + codigoCesion + "'");

			return !"0".equals(resultado);		
	}
	
	@Override
	public Boolean perteneceDDClasificacionApple(String codigoValorOrdinario) {
		if(Checks.esNulo(codigoValorOrdinario)) {
			return false;
		}					
			String resultado = rawDao.getExecuteSQL("SELECT Count(*) " 
					+ "FROM DD_CAP_CLASIFICACION_APPLE "
					+ "WHERE DD_CAP_CODIGO ='" + codigoValorOrdinario + "'");
			return !"0".equals(resultado);	
	}
	
	@Override
	public Boolean noExisteEstado(String numEstado) {
		if (Checks.esNulo(numEstado)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM DD_EDC_ESTADO_DOCUMENTO "
				+"			WHERE DD_EDC_CODIGO = '" + numEstado +"'");
		return "0".equals(resultado);
	}
	
	@Override
	public Boolean esActivoProductoTerminado(String numActivo) {
		if (Checks.esNulo(numActivo)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM ACT_ACTIVO ACT "
				+"			JOIN DD_EAC_ESTADO_ACTIVO EAC ON ACT.DD_EAC_ID = EAC.DD_EAC_ID"
				+"			WHERE EAC.DD_EAC_CODIGO IN ('03', '07','08','04','10','11')"
				+"			AND ACT.ACT_NUM_ACTIVO = " + numActivo);
		return !"0".equals(resultado);
	}

	public String getActivoJunta(String numActivo,  String fechaJunta) {
		if(Checks.esNulo(numActivo)) {
			return "";
		}

		String resultado = rawDao.getExecuteSQL("SELECT pls.JCM_ID FROM ACT_JCM_JUNTA_COM_PROPIETARIOS pls " + 
				"JOIN ACT_ACTIVO act ON pls.act_id = act.act_id " + 
				"WHERE pls.borrado = 0 " + 
				"AND act.ACT_NUM_ACTIVO = '"+numActivo+"' " + 
				"AND TRUNC(pls.JCM_FECHA_JUNTA) = TRUNC(TO_DATE('"+fechaJunta+"','dd/MM/yy'))");

		return resultado;
	}

	@Override
	public Boolean esActivoApple(String numActivo){
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}			
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_ACTIVO ACT "
				+ "JOIN DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID "
				+ "WHERE SCR.DD_SCR_CODIGO = '138' "
				+ "AND ACT.ACT_NUM_ACTIVO = "+numActivo+" ");
		return !"0".equals(resultado);
	}

	public Boolean esGastoRefacturado(String numGasto) {
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT GDE.GDE_GASTO_REFACTURABLE " 
						+ "FROM GDE_GASTOS_DETALLE_ECONOMICO GDE "
						+ "LEFT JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GDE.GPV_ID "
						+ "WHERE GPV.GPV_NUM_GASTO_HAYA ='" + numGasto + "'");

		return "1".equals(resultado);
	}

	public Boolean existeGastoRefacturable(String numGasto) {
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) " 
						+ "FROM GRG_REFACTURACION_GASTOS GRG "
						+ "LEFT JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GRG.GRG_GPV_ID_REFACTURADO "
						+ "WHERE GPV.GPV_NUM_GASTO_HAYA ='" + numGasto + "' AND GRG.BORRADO = 0");

		return "1".equals(resultado);
	}
	
	
	
	
	@Override
	public Boolean esGastoRefacturable(String numGasto) {
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) " 
						+ "FROM VGR_GASTOS_REFACTURABLES VGR "						
						+ "WHERE VGR.NUM_GASTO_HAYA = '" + numGasto + "'");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean perteneceGastoBankiaSareb(String numGasto) {
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) " 
						+ "FROM GDE_GASTOS_DETALLE_ECONOMICO GDE "
						+ "JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GDE.GPV_ID "
						+ "JOIN ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID " 
						+ "JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID " 
						+ "WHERE CRA.DD_CRA_CODIGO IN (02,03) " 
						+ "AND GPV.GPV_NUM_GASTO_HAYA ='" + numGasto + "'");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esGastoEmisorHaya(String numGasto) {
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) "
						+ "FROM GDE_GASTOS_DETALLE_ECONOMICO GDE "
						+ "JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GDE.GPV_ID "
						+ "JOIN ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = GPV.PVE_ID_EMISOR "
						+ "WHERE PVE.PVE_DOCIDENTIF IN ('A86744349') "
						+ "AND GPV.GPV_NUM_GASTO_HAYA = '" + numGasto + "'");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esGastoDestinatarioHaya(String numGasto) {
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) "
						+ "FROM GPV_GASTOS_PROVEEDOR GPV "
						+ "JOIN DD_DEG_DESTINATARIOS_GASTO DEG ON GPV.DD_DEG_ID = DEG.DD_DEG_ID "						
						+ "WHERE DEG.DD_DEG_CODIGO IN ('02') "
						+ "AND GPV.GPV_NUM_GASTO_HAYA = '" + numGasto + "'");						

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esGastoDestinatarioPropietario(String numGasto) {
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) "
						+ "FROM GPV_GASTOS_PROVEEDOR GPV "
						+ "JOIN DD_DEG_DESTINATARIOS_GASTO DEG ON GPV.DD_DEG_ID = DEG.DD_DEG_ID "						
						+ "WHERE DEG.DD_DEG_CODIGO IN ('01') "
						+ "AND GPV.GPV_NUM_GASTO_HAYA = '" + numGasto + "'");						

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esGastoMismaCartera(String numGasto, String numOtroGasto) {
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto) || Checks.esNulo(numOtroGasto)
				|| !StringUtils.isNumeric(numOtroGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) " + "FROM GDE_GASTOS_DETALLE_ECONOMICO GDE "
				+ "INNER JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GDE.GPV_ID "
				+ "INNER JOIN ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID "
				+ "WHERE GPV.GPV_NUM_GASTO_HAYA = '" + numGasto + "'" 
				+ "AND PRO.PRO_DOCIDENTIF = " 
				+ "(SELECT PRO.PRO_DOCIDENTIF "
				+ "FROM GDE_GASTOS_DETALLE_ECONOMICO GDE "
				+ "INNER JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GDE.GPV_ID "
				+ "INNER JOIN ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID "
				+ "WHERE GPV.GPV_NUM_GASTO_HAYA = '" + numOtroGasto + "')");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean mismaCarteraLineaDetalleGasto(String numGasto, String numElemento) {
		if(Checks.esNulo(numGasto) || !StringUtils.isAlphanumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT count(1) "
				+ " FROM gpv_gastos_proveedor gpv "
				+ " join act_pro_propietario pro on gpv.pro_id = pro.pro_id "
				+ " join act_activo act on pro.dd_cra_id = act.dd_cra_id "
				+ " where gpv.gpv_num_gasto_haya = '" + numGasto + "'");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean participaciones(String numGasto) {
		if(Checks.esNulo(numGasto) || !StringUtils.isAlphanumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT sum (gld_participacion_gasto) participaciones FROM GLD_ENT where gld_id in" + 
				"(select gld_id from gld_gastos_linea_detalle where gpv_id = " + 
				"(select gpv_id from gpv_gastos_proveedor where gpv_num_gasto_haya = '"+numGasto+"'))");
		if(resultado != null) {
			if(Integer.parseInt(resultado)>=100) {
				return false;
			}
		}else {
			return false;
		}
		return true;
	}
	
	
	@Override
	public Boolean existeFasePublicacion(String fasePublicacion) {
		if(Checks.esNulo(fasePublicacion) || !StringUtils.isAlphanumeric(fasePublicacion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_FSP_FASE_PUBLICACION WHERE"
				+ "		 	DD_FSP_CODIGO ='"+fasePublicacion+"' "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean activoEnAgrupacionProyecto(String numActivo) {
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(AGR.AGR_ID) FROM ACT_AGR_AGRUPACION AGR " +
				" INNER JOIN DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.DD_TAG_CODIGO = '04' " +
				" INNER JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " +
				" INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND ACT.ACT_NUM_ACTIVO = " + numActivo +
				" WHERE AGR.AGR_FECHA_BAJA IS NULL" +
				" AND ACT.BORRADO = 0" +
				" AND AGR.BORRADO = 0" +
				" AND TAG.BORRADO = 0" +
				" AND AGA.BORRADO = 0");

		return Integer.valueOf(resultado) > 0;
	}

	@Override
	public Boolean existeTipoDoc(String codTipoDoc) {
		if (Checks.esNulo(codTipoDoc)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM DD_TPD_TIPO_DOCUMENTO "
				+" WHERE DD_TPD_CODIGO = '" + codTipoDoc +"'"
				+ " AND DD_TPD_CODIGO IN('02','04','05','06','07','08','09','10','11','12','13','14','15','16','17','19','24','25','26','27','52','71','72','104','106','119')");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeSubfasePublicacion(String subfasePublicacion) {
		if(Checks.esNulo(subfasePublicacion) || !StringUtils.isAlphanumeric(subfasePublicacion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "	     FROM DD_SFP_SUBFASE_PUBLICACION WHERE"
				+ "	     DD_SFP_CODIGO ='"+subfasePublicacion+"' "
				+ "      AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	@Override
	public Boolean perteneceSubfaseAFasePublicacion(String codSubFasePublicacion, String codFasePublicacion) {
		if (Checks.esNulo(codSubFasePublicacion) || Checks.esNulo(codFasePublicacion)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM DD_FSP_FASE_PUBLICACION FSP "
				+ " JOIN DD_SFP_SUBFASE_PUBLICACION SFP ON SFP.DD_FSP_ID = FSP.DD_FSP_ID"
				+ " WHERE FSP.DD_FSP_CODIGO = '" + codFasePublicacion + "' "
				+ " AND SFP.DD_SFP_CODIGO = '" + codSubFasePublicacion + "'"
				+ " AND FSP.BORRADO = 0 AND SFP.BORRADO = 0");
		return !"0".equals(resultado);
	}
	@Override
	public Boolean existeEstadoDocumento(String codEstadoDoc) {
		if (Checks.esNulo(codEstadoDoc)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM DD_EDC_ESTADO_DOCUMENTO "
				+ " WHERE DD_EDC_CODIGO = '" + codEstadoDoc +"'");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeCalificacionEnergetica(String codCE) {
		if (Checks.esNulo(codCE)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM DD_TCE_TIPO_CALIF_ENERGETICA "
				+ " WHERE DD_TCE_CODIGO = '" + codCE +"'");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esDocumentoCEE(String codDocumento) {
		if (Checks.esNulo(codDocumento)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM DD_TPD_TIPO_DOCUMENTO "
				+ " WHERE DD_TPD_CODIGO =  '"+ codDocumento + "'"
				+ " AND DD_TPD_CODIGO IN ('25')");
		return !"0".equals(resultado);
	}
	
	@Override
	public Long obtenerNumAgrupacionRestringidaPorNumActivo(String numActivo){
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return null;
		}
		String sql = rawDao.getExecuteSQL("SELECT agr.AGR_NUM_AGRUP_REM "
				+ "FROM ACT_AGA_AGRUPACION_ACTIVO aga, " 
				+ "ACT_AGR_AGRUPACION agr, " 
				+ "DD_TAG_TIPO_AGRUPACION tag, "
				+ "ACT_ACTIVO act " 
				+ "WHERE aga.AGR_ID = agr.AGR_ID " 
				+ "AND agr.dd_tag_id = tag.dd_tag_id "
				+ "AND act.act_id   = aga.act_id " 
				+ "AND tag.dd_tag_codigo = '02' " 
				+ "AND act.ACT_NUM_ACTIVO = " + numActivo +" " 
				+ "AND agr.agr_fecha_baja is null "
				+ "AND aga.BORRADO  = 0 " 
				+ "AND agr.BORRADO  = 0 " 
				+ "AND act.BORRADO  = 0 ");
		
		return Checks.esNulo(sql)? null: Long.valueOf(sql);
	}
	
	@Override
	public Boolean esAgrupacionAlquilerConPrecio(String numAgrupacion){
		if (Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT NUM_ACT - NUM_VAL " 
				   +"FROM ( "
					    +"SELECT COUNT(DISTINCT AGA.ACT_ID) NUM_ACT "
						+"FROM ACT_AGA_AGRUPACION_ACTIVO AGA "
					 	+"JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID " 
			            +"WHERE AGA.BORRADO = 0 "
			            +"AND AGR.BORRADO = 0"  
			            +"AND AGR.AGR_NUM_AGRUP_REM = " + numAgrupacion + " "
			            +"),"
			            +"("
			            +"SELECT COUNT(DISTINCT AGA.ACT_ID) NUM_VAL "
						+"FROM ACT_AGA_AGRUPACION_ACTIVO AGA "
						+"JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
						+"JOIN ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = AGA.ACT_ID AND VAL.BORRADO = 0 " 
						+"JOIN DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.BORRADO = 0 " 			
						+"WHERE AGA.BORRADO = 0 "			            
			            +"AND TPC.DD_TPC_CODIGO = '03' "
			            +"AND AGR.AGR_NUM_AGRUP_REM = " + numAgrupacion + " "
			            +"AND (VAL.VAL_FECHA_FIN >= SYSDATE OR VAL.VAL_FECHA_FIN IS NULL) "
			            +")"								
				);
		return "0".equals(resultado);
	}
	
	@Override
	public String getCodigoMediadorPrimarioByActivo(String numActivo) {
		String resultado = "";
		if(!Checks.esNulo(numActivo)){
			 resultado = rawDao.getExecuteSQL("SELECT pve.PVE_COD_REM " +
			 		" FROM ACT_ICO_INFO_COMERCIAL ico  " +
			 		" INNER JOIN ACT_PVE_PROVEEDOR pve ON pve.PVE_ID = ico.ICO_MEDIADOR_ID " +
			 		" INNER JOIN ACT_ACTIVO act ON act.ACT_ID = ico.ACT_ID " +
			 		" WHERE ico.BORRADO = 0 AND act.ACT_NUM_ACTIVO = " + numActivo);
		}
		return resultado;
	}
	
	@Override
	public String getCodigoMediadorEspejoByActivo(String numActivo) {
		String resultado = "";
		if(!Checks.esNulo(numActivo)){
			 resultado = rawDao.getExecuteSQL("SELECT pve.PVE_COD_REM " +
			 		" FROM ACT_ICO_INFO_COMERCIAL ico  " +
			 		" INNER JOIN ACT_PVE_PROVEEDOR pve ON pve.PVE_ID = ico.ICO_MEDIADOR_ESPEJO_ID " +
			 		" INNER JOIN ACT_ACTIVO act ON act.ACT_ID = ico.ACT_ID " +
			 		" WHERE ico.BORRADO = 0 AND act.ACT_NUM_ACTIVO = " + numActivo);
		}
		return resultado;
	}
	
	@Override
	public Boolean esTipoMediadorCorrecto(String codMediador) {
		if (Checks.esNulo(codMediador)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT tpr.DD_TPR_CODIGO "
				+ "FROM ACT_PVE_PROVEEDOR pve "
				+ "JOIN DD_TPR_TIPO_PROVEEDOR tpr ON tpr.DD_TPR_ID = pve.DD_TPR_ID "
				+ "WHERE pve.PVE_COD_REM = " + codMediador);
		
		return COD_MEDIADOR.equals(resultado) || COD_FUERZA_VENTA_DIRECTA.equals(resultado);
	}
	
	public Boolean activoConRelacionExpedienteComercial(String numExpediente, String numActivo) {
		if(Checks.esNulo(numExpediente))
			return false;

		String query = "SELECT COUNT(1) "
				+ "	  	FROM REM01.ECO_EXPEDIENTE_COMERCIAL ECO "
				+ " 	JOIN REM01.ACT_OFR AO ON AO.OFR_ID = ECO.OFR_ID "
				+ "  	JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID "
				+ "  	WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" "
				+ "  	AND ACT.ACT_NUM_ACTIVO = "+ numActivo +" ";

		String resultado = rawDao.getExecuteSQL(query);

		return !"0".equals(resultado);
	}

	public Boolean existeActivoNoBankia(String numActivo){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(*) FROM ACT_ACTIVO ACT "
				+"JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID " 
				+"WHERE ACT.ACT_NUM_ACTIVO = '"+ numActivo +"' " 
				+"AND CRA.DD_CRA_CODIGO != '03' "
				);

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esExpedienteVenta(String numExpediente) {
		if(Checks.esNulo(numExpediente))
			return false;

		String query = "SELECT DD_TOF_CODIGO "
				+ "	  	FROM REM01.ECO_EXPEDIENTE_COMERCIAL ECO "
				+ " 	JOIN REM01.OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID "
				+ "  	JOIN REM01.DD_TOF_TIPOS_OFERTA TOF ON OFR.DD_TOF_ID = TOF.DD_TOF_ID "
				+ "  	WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" ";

		String resultado = rawDao.getExecuteSQL(query);

		return "01".equals(resultado);
	}
	
    @Override
    public Boolean isProveedorUnsuscribed(String pveCodRem) {
            if(Checks.esNulo(pveCodRem)) {
                    return false;
            }

            String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
                            + "              FROM ACT_PVE_PROVEEDOR WHERE"
                            + "              PVE_COD_REM = '" + pveCodRem + "'"
                            + "              AND PVE_FECHA_BAJA IS NOT NULL"
                            + "              AND BORRADO = 0"
                            );

            return !"0".equals(resultado);
    }
	
    @Override
    public Boolean existeProveedorByCodRem(String pveCodRem) {
            if(Checks.esNulo(pveCodRem)) {
                    return false;
            }

            String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
                            + "              FROM ACT_PVE_PROVEEDOR WHERE"
                            + "              PVE_COD_REM = '" + pveCodRem + "'"
                            + "      AND BORRADO = 0"
                            );
            return !"0".equals(resultado);
    }

	@Override
	public Boolean esExpedienteValidoAprobado(String numExpediente) {
		if(Checks.esNulo(numExpediente) || !StringUtils.isNumeric(numExpediente))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0"
				+"		AND ECO.DD_EEC_ID IN (SELECT EEC.DD_EEC_ID"
				+"		FROM DD_EEC_EST_EXP_COMERCIAL EEC"
				+"		WHERE EEC.DD_EEC_CODIGO IN ('11'))");

		return "1".equals(resultado);
	}
	
	
	//---------------------------------------------------------------------
	@Override
	public Boolean esExpedienteValidoFirmado(String numExpediente) {
		if(Checks.esNulo(numExpediente) || !StringUtils.isNumeric(numExpediente))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0"
				+"		AND ECO.DD_EEC_ID IN (SELECT EEC.DD_EEC_ID"
				+"		FROM DD_EEC_EST_EXP_COMERCIAL EEC"
				+"		WHERE EEC.DD_EEC_CODIGO IN ('03'))");

		return "1".equals(resultado);
	}
	@Override
	public Boolean esExpedienteValidoReservado(String numExpediente) {
		if(Checks.esNulo(numExpediente) || !StringUtils.isNumeric(numExpediente))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0"
				+"		AND ECO.DD_EEC_ID IN (SELECT EEC.DD_EEC_ID"
				+"		FROM DD_EEC_EST_EXP_COMERCIAL EEC"
				+"		WHERE EEC.DD_EEC_CODIGO IN ('06'))");

		return "1".equals(resultado);
	}

	public Boolean existeActivoTitulo(String numActivo){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(*) FROM ACT_TIT_TITULO TIT "
				+"JOIN ACT_ACTIVO ACT ON TIT.ACT_ID = ACT.ACT_ID "
				+"WHERE ACT.ACT_NUM_ACTIVO = '"+ numActivo +"' "
				);
	
		return !"0".equals(resultado);
	}
		
	public Boolean esActivoBankia(String numActivo) {
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM ACT_ACTIVO ACT "
					+"		WHERE ACT.DD_CRA_ID IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
					+"								WHERE DD_CRA_CODIGO = '03' "
					+"								AND BORRADO = 0) "
					+"		AND ACT.ACT_NUM_ACTIVO = "+ numActivo +"");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeEstadoTitulo(String situacionTitulo) {
		if(Checks.esNulo(situacionTitulo) || !StringUtils.isAlphanumeric(situacionTitulo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(*) FROM DD_ETI_ESTADO_TITULO " 
				+ "WHERE DD_ETI_CODIGO = '"+ situacionTitulo +"' "
				+ "AND DD_ETI_CODIGO IN ('01', '02', '06')"
		);
		
		return !"0".equals(resultado);
	}

	public Boolean existeEntidadHipotecaria(String codigo) {
		if (Checks.esNulo(codigo)) {
			return false;
		}
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM DD_EEJ_ENTIDAD_EJECUTANTE "
					+"		WHERE DD_EEJ_CODIGO = '"+ codigo +"'");

		return !"0".equals(resultado);
	}
	
	public Boolean existeTipoJuzgado(String codigo) {
		if (Checks.esNulo(codigo)) {
			return false;
		}
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM DD_JUZ_JUZGADOS_PLAZA "
					+"		WHERE DD_JUZ_CODIGO = '"+ codigo +"'");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existePoblacionJuzgado(String codigo) {
		if (Checks.esNulo(codigo)) {
			return false;
		}
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM DD_PLA_PLAZAS "
					+"		WHERE DD_PLA_CODIGO = '"+ codigo +"'");
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean verificaTipoDeAdjudicacion(String idActivo, String tipoAdjudicacion) {
		if (Checks.esNulo(idActivo) || Checks.esNulo(tipoAdjudicacion)) {
			return false;
		}
	
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM ACT_ACTIVO "
					+"		WHERE ACT_NUM_ACTIVO = "+ idActivo +" AND DD_TTA_ID = (SELECT DD_TTA_ID "
					+"                                                       FROM DD_TTA_TIPO_TITULO_ACTIVO "
					+"                                                       WHERE DD_TTA_CODIGO = '"+ tipoAdjudicacion +"')");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esAccionValidaInscripciones(String codAccion) {
		if(Checks.esNulo(codAccion) || !StringUtils.isNumeric(codAccion)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM DD_ACM_ACCION_MASIVA ACM "
				+ "WHERE ACM.DD_ACM_CODIGO ='" + codAccion + "'"
				+ "AND ACM.DD_ACM_CODIGO NOT IN('02')");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeTramiteTrabajo(String numTrabajo) {
	    if (Boolean.TRUE.equals(Checks.esNulo(numTrabajo))) return false;
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	            + "    FROM ACT_TBJ_TRABAJO TBJ " 
	            + "    JOIN ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID " 
	            + "    WHERE TBJ_NUM_TRABAJO = " + numTrabajo 
	            + "    AND TRA.BORRADO = 0 " 
	            + "    AND TBJ.BORRADO = 0 "
	            );
	    
	    return !"0".equals(resultado);
	}
	
	@Override
    public Boolean existenTareasEnTrabajo(String numTrabajo) {
        if (Boolean.TRUE.equals(Checks.esNulo(numTrabajo))) return false;
        String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
                + "     FROM ACT_TBJ_TRABAJO TBJ " 
                + "     JOIN ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID "
                + "     JOIN TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID " 
                + "     WHERE TBJ_NUM_TRABAJO = " + numTrabajo 
                + "     AND TRA.BORRADO = 0 "
                + "     AND TBJ.BORRADO = 0"
                );
        
        return !"0".equals(resultado);
    }
	
	@Override
	public Boolean esExpedienteValidoVendido(String numExpediente) {
		if(Checks.esNulo(numExpediente) || !StringUtils.isNumeric(numExpediente))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0"
				+"		AND ECO.DD_EEC_ID IN (SELECT EEC.DD_EEC_ID"
				+"		FROM DD_EEC_EST_EXP_COMERCIAL EEC"
				+"		WHERE EEC.DD_EEC_CODIGO IN ('08'))");

		return "1".equals(resultado);
	}
	
	@Override
	public Boolean esExpedienteValidoAnulado(String numExpediente) {
		if(Checks.esNulo(numExpediente) || !StringUtils.isNumeric(numExpediente))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = "+ numExpediente +" AND ECO.BORRADO = 0"
				+"		AND ECO.DD_EEC_ID IN (SELECT EEC.DD_EEC_ID"
				+"		FROM DD_EEC_EST_EXP_COMERCIAL EEC"
				+"		WHERE EEC.DD_EEC_CODIGO IN ('02'))");

		return "1".equals(resultado);
	}
	
	@Override
	public Boolean coincideTipoJuzgadoPoblacionJuzgado(String codigoTipoJuzgado, String codigoPoblacionJuzgado) {
		if(Checks.esNulo(codigoTipoJuzgado) || Checks.esNulo(codigoPoblacionJuzgado))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM DD_JUZ_JUZGADOS_PLAZA JUZ"
				+"		JOIN DD_PLA_PLAZAS PLA ON PLA.DD_PLA_ID = JUZ.DD_PLA_ID"
				+"		WHERE JUZ.DD_JUZ_CODIGO = '"+ codigoTipoJuzgado +"'"
				+"		AND PLA.DD_PLA_CODIGO = '"+ codigoPoblacionJuzgado +"'");

		return "1".equals(resultado);
	}
	
	@Override
	public Boolean direccionComercialExiste(String direccionComercial){
		if(Checks.esNulo(direccionComercial))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM DD_TDC_TERRITORIOS_DIR_COM "
				+ "		WHERE DD_TDC_CODIGO = '"+ direccionComercial +"'");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean isActivoEnCesionDeUso( String numActivo) {
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT count(1) " + 
				"FROM ACT_PTA_PATRIMONIO_ACTIVO pta " + 
				"JOIN DD_CDU_CESION_USO cdu ON pta.DD_CDU_ID = cdu.DD_CDU_ID " + 
				"AND DD_CDU_CODIGO IN ('01','02','03','04') " + 
				"JOIN ACT_ACTIVO act ON act.ACT_ID = pta.ACT_ID " + 
				"AND act.ACT_NUM_ACTIVO = " + numActivo
				);
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean isActivoEnAlquilerSocial( String numActivo) {
		
		String resultado = rawDao.getExecuteSQL(
				"  SELECT count(1)   "
				+" FROM ACT_PTA_PATRIMONIO_ACTIVO pta     " 
				+" JOIN ACT_ACTIVO act ON act.ACT_ID = pta.ACT_ID AND act.ACT_NUM_ACTIVO = " +  numActivo
				+" WHERE pta.PTA_TRAMITE_ALQ_SOCIAL = 1"
				);
		return !"0".equals(resultado); 
	}
	
	@Override
    public Boolean isProveedorInTipologias( String proveedor, String[] tipologias) {
        if (tipologias.length<1 || Checks.esNulo(proveedor)) return false;
        String tips= null;
        String resultado = "-1";
        tips = arrayToString(tipologias);
        if (!Checks.esNulo(tips)) {
            resultado = rawDao.getExecuteSQL("  SELECT COUNT(1) FROM ACT_PVE_PROVEEDOR"  
                + "                 WHERE DD_TPR_ID IN (SELECT DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR"
                + "                    WHERE DD_TPR_CODIGO IN ("+tips+"))"
                + "                 AND PVE_COD_REM = '" + proveedor+"'");
        }
        return "0".equals(resultado); 
    }
	
	@Override
	public Boolean isUserGestorType(String user, String codGestor) {
	    if (Checks.esNulo(user) || Checks.esNulo(codGestor)) return false;
	    String resultado;

	    resultado = rawDao.getExecuteSQL(" SELECT COUNT(1)" 
	            +"                  FROM REMMASTER.USU_USUARIOS USU" 
	            +"                 JOIN GEE_GESTOR_ENTIDAD GEE ON GEE.USU_ID = "
	            +"                (SELECT USU_ID FROM REMMASTER.USU_USUARIOS "
	            + "                    WHERE LOWER(USU_USERNAME) = LOWER('"+user+"'))"
	            +"                JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE "
	            +"                ON TGE.DD_TGE_ID = GEE.DD_TGE_ID "
	            + "               WHERE TGE.DD_TGE_CODIGO = '" +codGestor+"'");
	    
	    return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esTareaCompletadaTarificadaNoTarificada(String codTrabajo) {
	    if (Checks.esNulo(codTrabajo)) return false;
	    String resultado;
	    resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	            +"                 FROM ACT_TBJ_TRABAJO TBJ"
	            +"                 JOIN ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID"
	            +"                 JOIN TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID"
	            +"                 JOIN TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID"
	            +"                 JOIN TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID"
	            +"                 JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID"
	            +"                 WHERE TAP.TAP_CODIGO IN ('T004_ResultadoTarificada','T004_ResultadoNoTarificada')"
	            +"                 AND TAR.TAR_TAREA_FINALIZADA = 1 AND TAR.TAR_FECHA_FIN IS NOT NULL" 
	            +"                 AND TBJ.BORRADO = 0"
	            +"                 AND TBJ.TBJ_NUM_TRABAJO = "+ codTrabajo);
	                
	    return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esTrabajoMultiactivo(String codTrabajo) {
	    if (Checks.esNulo(codTrabajo)) return false;
	    String resultado;
	    resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	            +"                 FROM ACT_TBJ_TRABAJO TBJ"
	            +"                 JOIN ACT_TBJ ACTB ON ACTB.TBJ_ID = TBJ.TBJ_ID"
	            +"                 WHERE TBJ.TBJ_NUM_TRABAJO = " + codTrabajo);
	            
	    return Integer.valueOf(resultado) > 1;
	}
	

	private String arrayToString(String[] array) {
	    /* Retorna un string con los valores del array 
	     * entrecomillados y separados por comas
	     * si el array está vacío retorna null
	     */
	    String resp = "";
	    String comilla = "'";
	    String separador = "";
	    if (array.length > 0) 
	        for (String item : array) { 
	            resp += separador + comilla+item+comilla;
	            separador = ", ";
	        }
	    return resp;
	}
	//-------------------------------------------------------------------------

	@Override
	public Boolean esSegmentoValido(String codSegmento) {
		if (Checks.esNulo(codSegmento)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM DD_TS_TIPO_SEGMENTO "
				+ "WHERE DD_TS_CODIGO = '" + codSegmento +"' AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean perteneceSegmentoCraScr(String codSegmento , String numActivo) {
		if (Checks.esNulo(codSegmento) || Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) return false;
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) " +
				"FROM dd_scs_segmento_cra_scr scs " +
				"WHERE scs.dd_ts_id = (SELECT dd_ts_id FROM DD_TS_TIPO_SEGMENTO WHERE dd_ts_codigo = '" + codSegmento  + "') " +
				"AND scs.dd_cra_id = (SELECT dd_cra_id FROM ACT_ACTIVO WHERE act_num_activo = " + numActivo + ") " +
				"AND scs.dd_scr_id = (SELECT dd_scr_id FROM ACT_ACTIVO WHERE act_num_activo = " + numActivo + ") " +
				"AND scs.borrado = 0"
				);
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esSubcarteraDivarian(String numActivo) {
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) return false;
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) " + 
				"FROM act_activo act " + 
				"INNER JOIN dd_scr_subcartera scr ON scr.dd_scr_id = act.dd_scr_id AND dd_scr_codigo IN ('151','152') " + 
				"WHERE act.act_num_activo = " + numActivo + " AND act.borrado = 0"
				);
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esSubcarteraApple(String numActivo) {
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) return false;
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) " + 
				"FROM act_activo act " + 
				"INNER JOIN dd_scr_subcartera scr ON scr.dd_scr_id = act.dd_scr_id AND dd_scr_codigo IN ('138') " + 
				"WHERE act.act_num_activo = " + numActivo + " AND act.borrado = 0"
				);
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean aCambiadoDestinoComercial(String numActivo, String destinoComercial) {
		if((Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) 
				&& (Checks.esNulo(destinoComercial) || !!StringUtils.isNumeric(destinoComercial))
		  ) return false;
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1)"+ 
				"FROM ACT_ACTIVO ACT "+ 
				"INNER JOIN DD_TS_TIPO_SEGMENTO TIPO on TIPO.dd_ts_id = act.dd_ts_id and TIPO.dd_ts_codigo = 03 "+
				"WHERE ACT.DD_TCO_ID = " + destinoComercial +
				" AND act.act_num_activo = " + numActivo +
				" and act.ACT_PERIMETRO_MACC = 1" +
				" AND act.borrado = 0");
		return "1".equals(resultado);
	}
	
	@Override
	public Boolean existeCodigoPeticion(String codPeticion) {
		
		 if(codPeticion == null || codPeticion.isEmpty())
			 return true;// Si codigo peticion viene nula es porque se va a crear nueva peticion.
		 
		 if(Boolean.FALSE.equals(StringUtils.isNumeric(codPeticion)))
			 return false;
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) "+ 
				"FROM HPP_HISTORICO_PETICIONES_PRECIOS HPP "+ 
				"WHERE HPP.HPP_ID = " + codPeticion +
				" AND HPP.borrado = 0");
		return "1".equals(resultado);
	}
	
	@Override
	public Boolean existeCodigoPeticionActivo(String codPeticion, String numActivo) {
		
		 if(codPeticion == null || codPeticion.isEmpty())
			 return true;// Si codigo peticion viene nula es porque se va a crear nueva peticion.
		 
		 if(Boolean.FALSE.equals(StringUtils.isNumeric(codPeticion)) || numActivo == null 
				 ||  Boolean.FALSE.equals(StringUtils.isNumeric(numActivo)))
			 return false;
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) "+ 
				" FROM HPP_HISTORICO_PETICIONES_PRECIOS HPP "+
				" INNER JOIN ACT_ACTIVO ACT ON HPP.ACT_ID = ACT.ACT_ID "+ 
				" WHERE HPP.HPP_ID = " + codPeticion +
				" AND ACT.ACT_NUM_ACTIVO = "+ numActivo +
				" AND HPP.borrado = 0 AND ACT.BORRADO = 0");
		return "1".equals(resultado);
	}
	
	 @Override
	 public Boolean esPeticionEditable(String codPeticion, String numActivo) {
		 Boolean resultado = false;

		 if(codPeticion == null || codPeticion.isEmpty())
			 return true;// Si codigo peticion viene nula es porque se va a crear nueva peticion.
		 
		 List<Object> listaHistPeticiones = rawDao.getExecuteSQLList("SELECT HPP.HPP_ID FROM hpp_historico_peticiones_precios HPP " + 
		"INNER JOIN ACT_ACTIVO ACT ON HPP.ACT_ID = ACT.ACT_ID " + 
		" WHERE ACT.ACT_NUM_ACTIVO = "+numActivo+" AND ACT.BORRADO = 0 AND " + 
		" HPP.DD_TPP_ID = (select dd_tpp_id from dd_tpp_tipo_peticion_precio where dd_tpp_id = (" + 
		" SELECT DD_TPP_ID FROM hpp_historico_peticiones_precios where HPP_ID ="+codPeticion+" )) AND HPP.BORRADO = 0"
		+ " ORDER BY HPP.FECHACREAR DESC");
		
		 if(!listaHistPeticiones.isEmpty() && listaHistPeticiones.get(0).toString().equals(codPeticion)) {
			 resultado = true;
		 }
		 
		 return resultado;
	 }

	@Override
	public Boolean existeTipoPeticion(String codTpoPeticion) {
		 if((codTpoPeticion == null ||  Boolean.FALSE.equals(StringUtils.isNumeric(codTpoPeticion))))
			 return false;
			
		String resultado = rawDao.getExecuteSQL("SELECT  COUNT(1) FROM DD_TPP_TIPO_PETICION_PRECIO " + 
				"WHERE DD_TPP_CODIGO = '"+codTpoPeticion+"' AND BORRADO = 0");
		
		return "1".equals(resultado);
	}
	
	@Override
	public boolean existeContactoProveedorTipoUsuario(String usrContacto, String codProveedor) {
		String resultado = rawDao.getExecuteSQL("SELECT  COUNT(1) FROM ACT_PVC_PROVEEDOR_CONTACTO pvc " + 
				"JOIN ACT_PVE_PROVEEDOR pve ON pve.PVE_ID = pvc.PVE_ID AND PVE_COD_REM ='" +codProveedor+"' AND pve.BORRADO = 0" +
				"JOIN REMMASTER.USU_USUARIOS usu ON usu.USU_ID = pvc.USU_ID AND usu.USU_USERNAME ='" +usrContacto+"' AND usu.BORRADO = 0");
		
		return Integer.valueOf(resultado) > 0;
	}
	
	@Override
	public Boolean existeSituacionTitulo(String codigoSituacionTitulo) {
		if(Checks.esNulo(codigoSituacionTitulo) || !StringUtils.isAlphanumeric(codigoSituacionTitulo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_ETI_ESTADO_TITULO " 
				+ "WHERE DD_ETI_CODIGO = '"+ codigoSituacionTitulo +"' "
		);
		
		return !"0".equals(resultado);
	}
	
	public Boolean esActivoSareb(String numActivo) {
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
					+"		FROM ACT_ACTIVO ACT "
					+"		WHERE ACT.DD_CRA_ID IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
					+"								WHERE DD_CRA_CODIGO = '02' "
					+"								AND BORRADO = 0) "
					+"		AND ACT.ACT_NUM_ACTIVO = "+ numActivo +"");

		return !"0".equals(resultado);
	}
	

	@Override
	public Boolean perteneceADiccionarioConTitulo(String conTitulo) {
		if(Checks.esNulo(conTitulo) || !StringUtils.isAlphanumeric(conTitulo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_TPA_TIPO_TITULO_ACT " 
				+ "WHERE DD_TPA_CODIGO = '"+ conTitulo +"' "
		);
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean perteneceADiccionarioEquipoGestion(String codEquipoGestion) {
		if(Checks.esNulo(codEquipoGestion) || !StringUtils.isAlphanumeric(codEquipoGestion)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_EQG_EQUIPO_GESTION " 
				+ "WHERE DD_EQG_CODIGO = '"+ codEquipoGestion +"' "
				+ "AND BORRADO = 0"
		);
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esActivoBBVA(String numActivo) {
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) "
												+"		FROM ACT_ACTIVO ACT "
												+"		WHERE ACT.DD_CRA_ID IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
												+"								WHERE DD_CRA_CODIGO = '16' "
												+"								AND BORRADO = 0) "
											+"		AND ACT.ACT_NUM_ACTIVO = "+ numActivo +""
				);
		return !"0".equals(resultado);
	}
	
	@Override
    public Boolean existeTipoSuministroByCod(String codigo) {
            if(Checks.esNulo(codigo)) {
                    return false;
            }

            String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
                            + "              FROM DD_TSU_TIPO_SUMINISTRO WHERE"
                            + "              DD_TSU_CODIGO = '" + codigo + "'"
                            + "      AND BORRADO = 0"
                            );
            return !"0".equals(resultado);
    }
    
	@Override
    public Boolean existeSubtipoSuministroByCod(String codigo) {
        if(Checks.esNulo(codigo)) {
                return false;
        }

        String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
                        + "              FROM DD_SSU_SUBTIPO_SUMINISTRO WHERE"
                        + "              DD_SSU_CODIGO = '" + codigo + "'"
                        + "      AND BORRADO = 0"
                        );
        return !"0".equals(resultado);
    }
    
	@Override
    public Boolean existePeriodicidadByCod(String codigo) {
        if(Checks.esNulo(codigo)) {
                return false;
        }

        String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
                        + "              FROM DD_PRD_PERIODICIDAD WHERE"
                        + "              DD_PRD_CODIGO = '" + codigo + "'"
                        + "      AND BORRADO = 0"
                        );
        return !"0".equals(resultado);
    }
    
	@Override
    public Boolean existeMotivoAltaSuministroByCod(String codigo) {
        if(Checks.esNulo(codigo)) {
                return false;
        }

        String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
                        + "              FROM DD_MAS_MOTIVO_ALTA_SUM WHERE"
                        + "              DD_MAS_CODIGO = '" + codigo + "'"
                        + "      AND BORRADO = 0"
                        );
        return !"0".equals(resultado);
    }
    
	@Override
    public Boolean existeMotivoBajaSuministroByCod(String codigo) {
        if(Checks.esNulo(codigo)) {
                return false;
        }

        String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
                        + "              FROM DD_MBS_MOTIVO_BAJA_SUM WHERE"
                        + "              DD_MBS_CODIGO = '" + codigo + "'"
                        + "      AND BORRADO = 0"
                        );
        return !"0".equals(resultado);
    }
	
	@Override
    public Boolean esMismoTipoGestorActivo(String codigo, String numActivo) {
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo) || Checks.esNulo(codigo)) {
			return false;
		}

        String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
                        + "              FROM gah_gestor_activo_historico gah"
                        + "              join act_activo act on act.act_id = gah.act_id"
                        + "              join geh_gestor_entidad_hist geh on gah.geh_id = geh.geh_id and geh.borrado = 0"
                        + "              left join REMMASTER.dd_tge_tipo_gestor tge on tge.dd_tge_id = geh.dd_tge_id and tge.borrado = 0"
                        + "              where geh.geh_fecha_hasta is null "
                        + "              and tge.dd_tge_codigo like '" + codigo + "'"
                        + "              AND act.act_num_activo = " + numActivo +""
                        );
        return !"0".equals(resultado);
    }

	public Boolean esActivoIncluidoPerimetroAdmision(String numActivo) {
		if(numActivo == null) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT ACT.ACT_ID "
				+ "		FROM ACT_ACTIVO ACT "
				+ "		LEFT JOIN ACT_PAC_PERIMETRO_ACTIVO PAC "
				+ "		ON ACT.ACT_ID = PAC.ACT_ID "
				+ "		WHERE PAC.PAC_CHECK_ADMISION = 1"
				+ "		AND ACT.ACT_NUM_ACTIVO = "+numActivo+" ");
		
		return resultado!=null;
	}
	
	@Override
	public Boolean estadoAdmisionValido(String codEstadoAdmision) {
		if(codEstadoAdmision == null) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_EAA_ESTADO_ACT_ADMISION " 
				+ "WHERE DD_EAA_CODIGO = '"+ codEstadoAdmision +"' "
				+ "AND BORRADO = 0"
		);
		
		return "1".equals(resultado);
	}
	
	@Override
	public Boolean subestadoAdmisionValido(String codSubestadoAdmision) {
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_SAA_SUBESTADO_ACT_ADMISION " 
				+ "WHERE DD_SAA_CODIGO = '"+ codSubestadoAdmision +"' "
				+ "AND BORRADO = 0"
		);
		
		return "1".equals(resultado);

	}
	
	@Override
	public Boolean estadoConSubestadosAdmisionValido(String codEstadoAdmision) {
		if(codEstadoAdmision == null) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_SAA_SUBESTADO_ACT_ADMISION SAA "
				+ "JOIN DD_EAA_ESTADO_ACT_ADMISION EAA ON SAA.DD_EAA_ID = EAA.DD_EAA_ID " 
				+ "WHERE EAA.DD_EAA_CODIGO = '"+ codEstadoAdmision +"' "
				+ "AND EAA.BORRADO = 0 AND SAA.BORRADO = 0"
		);
		
		return !"0".equals(resultado);
		
	}

	@Override
	public Boolean relacionEstadoSubestadoAdmisionValido(String codEstadoAdmision, String codSubestadoAdmision) {
		if(codEstadoAdmision == null) {
			return false;
		}
		
		if(estadoConSubestadosAdmisionValido(codEstadoAdmision)) {
			String resultado = rawDao.getExecuteSQL(
					"SELECT COUNT(1) FROM DD_SAA_SUBESTADO_ACT_ADMISION SAA "
					+ "JOIN DD_EAA_ESTADO_ACT_ADMISION EAA ON SAA.DD_EAA_ID = EAA.DD_EAA_ID " 
					+ "WHERE SAA.DD_SAA_CODIGO = '"+ codSubestadoAdmision +"' "
					+ "AND EAA.DD_EAA_CODIGO = '"+ codEstadoAdmision +"' "
					+ "AND EAA.BORRADO = 0 AND SAA.BORRADO = 0"
			);
			
			return "1".equals(resultado);
		}
		
		return true;
	}
		
	@Override
	public String getValidacionCampoCDC(String codCampo) {
		if(Checks.esNulo(codCampo) || !StringUtils.isNumeric(codCampo)) {
			return null;
		}
		return rawDao.getExecuteSQL(
				"SELECT VALIDACION FROM CDC_CALIDAD_DATOS_CONFIG "
				+ "WHERE COD_CAMPO = '" + codCampo + "' AND BORRADO = 0");
	}
	
	@Override
	public boolean incluidoActivoIdOrigenBBVA (String numActivo) {
		if (numActivo == null || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_BBVA_ACTIVOS ABA " + 												 
												"WHERE ABA.BBVA_ID_ORIGEN_HRE =" + numActivo +"");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean relacionPoblacionLocalidad(String columnaPoblacion, String columnaMunicipio) {
		if(Checks.esNulo(columnaPoblacion) || Checks.esNulo(columnaMunicipio) ) {
			return false;
		}
		
		
			String resultado = rawDao.getExecuteSQL(
					"SELECT COUNT(1) FROM ${master.schema}.dd_loc_localidad loc "
					+ "JOIN ${master.schema}.dd_upo_unid_poblacional pob  ON pob.dd_loc_ID=loc.DD_LOC_ID " 
					+ "WHERE loc.DD_LOC_CODIGO = '"+ columnaPoblacion +"' "
					+ "AND pob.DD_UPO_CODIGO = '"+ columnaMunicipio +"' "
					+ "and pob.borrado=0 and loc.borrado=0"
			);
			
			
			return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeMunicipioByDescripcion(String codigoMunicipio) {
		if(Checks.esNulo(codigoMunicipio)) {
			return false;
		}

		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		 FROM ${master.schema}.DD_UPO_UNID_POBLACIONAL WHERE"
				+ "		 DD_UPO_CODIGO = '" + codigoMunicipio + "'"
				+ "		 AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existePais(String pais) {
		if(pais == null || pais.isEmpty()) return null;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM DD_PAI_PAISES WHERE DD_PAI_CODIGO = '"+pais+"'");
		return "1".equals(resultado);
	}

	@Override
	public boolean existeMismoProveedorContactoInformado(String codProveedor, String numTrabajo) {
		String resultado = null;
		String query = "SELECT COUNT(1) FROM ACT_TBJ_TRABAJO TBJ  "
		+				"INNER JOIN ACT_PVC_PROVEEDOR_CONTACTO PVC ON TBJ.PVC_ID  = PVC.PVC_ID  " 
		+ 				"INNER JOIN ACT_PVE_PROVEEDOR PVE ON PVC.PVE_ID = PVE.PVE_ID  "
		+				"WHERE PVE.PVE_COD_REM = "+codProveedor+" AND TBJ.TBJ_NUM_TRABAJO ="+ numTrabajo;
		
		
		resultado = rawDao.getExecuteSQL(query);
		return Boolean.TRUE.equals("1".equals(resultado));
	}
	
	@Override
	public boolean existeProveedor(String codProveedor) {
		String resultado = null;
		String query = "SELECT COUNT(1) FROM ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = "+codProveedor;
		
		
		resultado = rawDao.getExecuteSQL(query);
		return Boolean.TRUE.equals("1".equals(resultado));
	}
	

	@Override
	public boolean isTipoTarifaValidoEnConfiguracion(String codigoTarifa, String numTrabajo) {
		String queryForGetIds = "SELECT " + 
				"TBJ.DD_TTR_ID,   " + 
				"TBJ.DD_STR_ID,   " + 
				"ACT.DD_CRA_ID,   " +
				"ACT.DD_SCR_ID,   " +
				"pvc.pve_id   " +
				"FROM ACT_TBJ_TRABAJO TBJ   " + 
				"INNER JOIN ACT_TBJ ACTTBJ ON TBJ.TBJ_ID = ACTTBJ.TBJ_ID   " + 
				"INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = ACTTBJ.ACT_ID   " + 
				"INNER JOIN act_pvc_proveedor_contacto PVC on tbj.pvc_id = pvc.pvc_id " + 
				"WHERE TBJ.TBJ_NUM_TRABAJO = " + numTrabajo + " "+
				"GROUP BY TBJ.DD_TTR_ID, TBJ.DD_STR_ID, ACT.DD_CRA_ID, pvc.pve_id, act.dd_Scr_id";
		Object [] resultSet = rawDao.getExecuteSQLArray(queryForGetIds);
		
		if ( resultSet != null ) {
			String query = "SELECT DD_TTF_ID FROM DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '" + codigoTarifa+ "'";
			String tarifaId = rawDao.getExecuteSQL(query);
			if ( tarifaId != null) {
				 query = "SELECT COUNT(1) " + 
							"FROM ACT_CFT_CONFIG_TARIFA CONFIG_TARIFA " + 
							"WHERE DD_TTR_ID   = "   + resultSet[0]
							+ " AND DD_STR_ID   = "    + resultSet[1]
							+ " AND DD_CRA_ID   = "    + resultSet[2] 
							+ " AND DD_SCR_ID   = "    + resultSet[3] 
						    + " AND PVE_ID   = "    + resultSet[4] 
							+ " AND DD_TTF_ID   = "	  + tarifaId;
					String resultado = rawDao.getExecuteSQL(query);
					
				if("0".equals(resultado)) {
					 query = "SELECT COUNT(1) " + 
								"FROM ACT_CFT_CONFIG_TARIFA CONFIG_TARIFA " + 
								"WHERE DD_TTR_ID   = "   + resultSet[0]
								+ " AND DD_STR_ID   = "    + resultSet[1]
								+ " AND DD_CRA_ID   = "    + resultSet[2] 
								+ " AND DD_SCR_ID   = "    + resultSet[3] 
							    + " AND PVE_ID  IS  NULL" 
								+ " AND DD_TTF_ID   = "	  + tarifaId;
					 resultado = rawDao.getExecuteSQL(query);
					 
					 if("0".equals(resultado)) {
						 query = "SELECT COUNT(1) " + 
									"FROM ACT_CFT_CONFIG_TARIFA CONFIG_TARIFA " + 
									"WHERE DD_TTR_ID   = "   + resultSet[0]
									+ " AND DD_STR_ID   = "    + resultSet[1]
									+ " AND DD_CRA_ID   = "    + resultSet[2] 
									+ " AND DD_SCR_ID   IS NULL"  
								    + " AND PVE_ID   IS NULL" 
									+ " AND DD_TTF_ID   = "	  + tarifaId;
						 resultado = rawDao.getExecuteSQL(query);
					 }
				}
					return Boolean.TRUE.equals(!"0".equals(resultado));
			}
		}
		return false;
	}

	@Override
	public String getEstadoTrabajoByNumTrabajo(String numTrabajo) {
		return rawDao.getExecuteSQL("SELECT DD_EST_CODIGO  " 
								+"  FROM ACT_TBJ_TRABAJO TBJ " 
								+"  INNER JOIN DD_EST_ESTADO_TRABAJO ESTADO ON ESTADO.DD_EST_ID = TBJ.DD_EST_ID " 
								+"  WHERE TBJ_NUM_TRABAJO = " + numTrabajo);
	}
	
	@Override
	public Boolean existeSubtipoGasto(String codSubtipoGasto) {
		if(Checks.esNulo(codSubtipoGasto))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM DD_STG_SUBTIPOS_GASTO"
				+"		WHERE DD_STG_CODIGO = '"+codSubtipoGasto+"'"
				+"		AND BORRADO= 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean perteneceGastoBankia(String numGasto) {
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) " 
						+ "FROM GDE_GASTOS_DETALLE_ECONOMICO GDE "
						+ "JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GDE.GPV_ID "
						+ "JOIN ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID " 
						+ "JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID " 
						+ "WHERE CRA.DD_CRA_CODIGO IN (03) " 
						+ "AND GPV.GPV_NUM_GASTO_HAYA ='" + numGasto + "'");

		return !"0".equals(resultado);

	}

	@Override
	public Boolean esTipoRegimenProteccion(String codCampo) {
		if(Checks.esNulo(codCampo) || !StringUtils.isAlphanumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_TVP_TIPO_VPO "
						+ "WHERE DD_TVP_CODIGO = '" + codCampo + "' AND BORRADO = 0"
		);
		
		return !"0".equals(resultado);
	}
	
	
	@Override
	public Boolean esTipoAltaBBVAMenosAltaAutamatica(String codCampo) {
		if(Checks.esNulo(codCampo) || !StringUtils.isAlphanumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_TAL_TIPO_ALTA "
						+ "WHERE DD_TAL_CODIGO = '" + codCampo + "' AND BORRADO = 0 "
								+ "AND DD_TAL_CODIGO <> 'AUT' "
		);
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean agrupacionSinActivos(String numAgrupacion) {
		if (Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_AGR_AGRUPACION AGR "
				+"JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = '"+numAgrupacion +"'");
		
		return "0".equals(resultado);
	}
	
	@Override
	public Boolean esGastoYAgrupacionMismoPropietarioByNumGasto(String numAgrupacion, String numGastoHaya) {
		if (Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion) || Checks.esNulo(numGastoHaya) || !StringUtils.isNumeric(numGastoHaya))
			return false;
		
		String carteraGasto = rawDao.getExecuteSQL("SELECT APRO.PRO_ID FROM ACT_PRO_PROPIETARIO APRO " + 
				"         JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.PRO_ID = APRO.PRO_ID " + 
				"         WHERE GPV.GPV_NUM_GASTO_HAYA = '"+numGastoHaya+"' AND GPV.BORRADO = 0 AND APRO.BORRADO = 0 ");
					
			String carteraAgrupacion = null;
			String masDeUnaCartera = rawDao.getExecuteSQL("SELECT count(*) FROM (SELECT DISTINCT PACT.PRO_ID   " + 
					"		FROM ACT_PAC_PROPIETARIO_ACTIVO PACT " + 
					"		WHERE EXISTS ( " + 
					"		   SELECT 1 " + 
					"		   FROM ACT_AGR_AGRUPACION AGR " + 
					"		   JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " + 
					"		   WHERE AGR.AGR_NUM_AGRUP_REM = '"+numAgrupacion+"' " + 
					"		       AND AGA.ACT_ID  = PACT.ACT_ID " + 
					"		       AND AGR.BORRADO = 0 " + 
					"		       AND AGR.AGR_FECHA_BAJA IS NULL " + 
					"		))");
			
			if("1".equals(masDeUnaCartera)) {
				carteraAgrupacion = rawDao.getExecuteSQL("SELECT DISTINCT PACT.PRO_ID " + 
						"		FROM ACT_PAC_PROPIETARIO_ACTIVO PACT " + 
						"		WHERE EXISTS ( " + 
						"		   SELECT 1 " + 
						"		   FROM ACT_AGR_AGRUPACION AGR " + 
						"		   JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " + 
						"		   WHERE AGR.AGR_NUM_AGRUP_REM = '"+numAgrupacion+"' " + 
						"		       AND AGA.ACT_ID  = PACT.ACT_ID " + 
						"		       AND AGR.BORRADO = 0 " + 
						"		       AND AGR.AGR_FECHA_BAJA IS NULL " + 
						"		)");
			}
			if(Checks.esNulo(carteraGasto) || Checks.esNulo(carteraAgrupacion)) {
				return false;
			}
						
			return carteraGasto.equals(carteraAgrupacion);
	}

	@Override
	public Boolean esGastoYActivoMismoPropietarioByNumGasto(String numElemento, String numGastoHaya, String tipoElemento) {
		if (Checks.esNulo(numElemento) || !StringUtils.isNumeric(numElemento) || Checks.esNulo(numGastoHaya) || !StringUtils.isNumeric(numGastoHaya))
			return false;
		
		String resultado = rawDao.getExecuteSQL("WITH GENERICO AS (\n" + 
				"    SELECT COUNT(1) ES_GEN\n" + 
				"    FROM REM01.DD_ENT_ENTIDAD_GASTO\n" + 
				"    WHERE DD_ENT_CODIGO = 'GEN'\n" + 
				"        AND 'GEN' = '"+tipoElemento+"'\n" + 
				"), ACTIVO AS (\n" + 
				"    SELECT COUNT(1) ES_ACT\n" + 
				"    FROM REM01.DD_ENT_ENTIDAD_GASTO\n" + 
				"    WHERE DD_ENT_CODIGO = 'ACT'\n" + 
				"        AND 'ACT' = '"+tipoElemento+"'\n" + 
				"), PAC AS (\n" + 
				"    SELECT PAC.PRO_ID\n" + 
				"    FROM REM01.ACT_ACTIVO ACT\n" + 
				"    JOIN REM01.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID\n" + 
				"        AND PAC.BORRADO = 0\n" + 
				"    JOIN ACTIVO ON ACTIVO.ES_ACT = 1\n" + 
				"    WHERE ACT.BORRADO = 0\n" + 
				"        AND ACT.ACT_NUM_ACTIVO = '"+numElemento+"'\n" + 
				"), AGS AS (\n" + 
				"    SELECT AGS.PRO_ID\n" + 
				"    FROM REM01.ACT_AGS_ACTIVO_GENERICO_STG AGS\n" + 
				"    JOIN GENERICO ON GENERICO.ES_GEN = 1\n" + 
				"    WHERE AGS.BORRADO = 0\n" + 
				"        AND AGS.AGS_ACTIVO_GENERICO = '"+numElemento+"'\n" + 
				")\n" + 
				"SELECT COUNT(1) \n" + 
				"FROM REM01.GPV_GASTOS_PROVEEDOR GPV\n" + 
				"WHERE GPV.GPV_NUM_GASTO_HAYA = '"+numGastoHaya+"'\n" + 
				"    AND GPV.BORRADO = 0\n" + 
				"    AND (\n" + 
				"        EXISTS (\n" + 
				"        SELECT 1\n" + 
				"        FROM PAC\n" + 
				"        WHERE PAC.PRO_ID = GPV.PRO_ID\n" + 
				"        ) OR EXISTS (\n" + 
				"        SELECT 1\n" + 
				"        FROM AGS\n" + 
				"        WHERE AGS.PRO_ID = GPV.PRO_ID\n" + 
				"        )\n" + 
				"    )");

		return !"0".equals(resultado);
	}

	@Override
	public boolean existeTipoDeGastoAsociadoCMGA (String codTipoGasto) {
		if (codTipoGasto == null || !StringUtils.isAlphanumeric(codTipoGasto)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM  DD_TGA_TPO_GASTO_ASOCIADO TGA " 
				+ "WHERE TGA.DD_TGA_CODIGO = '"+ codTipoGasto +"' "
				+ "AND TGA.BORRADO = 0"
				);
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esTipoDeTransmisionBBVA(String codCampo) {
		if(Checks.esNulo(codCampo) || !StringUtils.isAlphanumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_TTR_TIPO_TRANSMISION "
						+ "WHERE DD_TTR_CODIGO = '" + codCampo + "' AND BORRADO = 0 "
		);

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeEntidadGasto(String entidad) {
		if (Checks.esNulo(entidad))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM DD_ENT_ENTIDAD_GASTO "
				+" WHERE DD_ENT_CODIGO = '"+entidad+"' ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esTipoDeTituloBBVA(String codCampo) {
		if(Checks.esNulo(codCampo) || !StringUtils.isAlphanumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_TTA_TIPO_TITULO_ACTIVO "
						+ "WHERE DD_TTA_CODIGO = '" + codCampo + "' AND BORRADO = 0 "
		);
		
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esGastoRefacturadoPadre(String numGasto) {
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM GRG_REFACTURACION_GASTOS "
				+" WHERE GRG_GPV_ID = (SELECT GPV_ID FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '"+numGasto+"') ");
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esGastoRefacturadoHijo(String numGasto) {
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM GRG_REFACTURACION_GASTOS "
				+" WHERE GRG_GPV_ID_REFACTURADO = (SELECT GPV_ID FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '"+numGasto+"') ");
		
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean estaPerimetroHaya(String activoId) {
		if (activoId == null || !StringUtils.isNumeric(activoId)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT act_pac_perimetro_activo.pac_incluido "
												+"from rem01.act_pac_perimetro_activo"
												+"		WHERE act_id = "+ activoId +""
				);
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeActivoPorId(String activoId) {
		if(Checks.esNulo(activoId) || !StringUtils.isNumeric(activoId))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_ACTIVO WHERE"
				+ "		 	ACT_ID ="+activoId+" "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean gastoEstadoIncompletoPendienteAutorizado(String numGasto) {
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '"+numGasto+"' "
				+ "AND DD_EGA_ID IN (SELECT DD_EGA_ID FROM DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO IN('01','12', '02','08'))");

		return !"0".equals(resultado);
	}
	
	@Override
    public Boolean existeTipoGastoByCod(String codigo) {
	    if(Checks.esNulo(codigo)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM DD_TGA_TIPOS_GASTO WHERE"
	                    + "              DD_TGA_CODIGO = '" + codigo + "'"
	                    + "      AND BORRADO = 0"
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean existeDestinatarioByCod(String codigo) {
	    if(Checks.esNulo(codigo)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM DD_DEG_DESTINATARIOS_GASTO WHERE"
	                    + "              DD_DEG_CODIGO = '" + codigo + "'"
	                    + "      AND BORRADO = 0"
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean existeTipoOperacionGastoByCod(String codigo) {
	    if(Checks.esNulo(codigo)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM DD_TOG_TIPO_OPERACION_GASTO WHERE"
	                    + "              DD_TOG_CODIGO = '" + codigo + "'"
	                    + "      AND BORRADO = 0"
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean existeTipoRecargoByCod(String codigo) {
	    if(Checks.esNulo(codigo)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM DD_TRG_TIPO_RECARGO_GASTO WHERE"
	                    + "              DD_TRG_CODIGO = '" + codigo + "'"
	                    + "      AND BORRADO = 0"
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean existeTipoElementoByCod(String codigo) {
	    if(Checks.esNulo(codigo)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM DD_ENT_ENTIDAD_GASTO WHERE"
	                    + "              DD_ENT_CODIGO = '" + codigo + "'"
	                    + "      AND BORRADO = 0"
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean subtipoPerteneceATipoGasto(String tipoGasto, String subtipoGasto) {
	    if(Checks.esNulo(tipoGasto) && Checks.esNulo(subtipoGasto)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM DD_TGA_TIPOS_GASTO TGA "
	                    + "				 JOIN DD_STG_SUBTIPOS_GASTO STG ON TGA.DD_TGA_ID = STG.DD_TGA_ID"
	                    + "				 WHERE TGA.DD_TGA_CODIGO like '" + tipoGasto + "' AND STG.DD_STG_CODIGO like '" + subtipoGasto + "'"
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean esPropietarioDeCarteraByCodigo(String docIdentificadorPropietario, String cartera) {
	    if(Checks.esNulo(docIdentificadorPropietario) && Checks.esNulo(cartera)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM ACT_PRO_PROPIETARIO PRO "
	                    + "				 JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID"
	                    + "				 WHERE PRO.PRO_DOCIDENTIF LIKE '" + docIdentificadorPropietario + "' AND CRA.DD_CRA_CODIGO LIKE '" + cartera + "'"
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean esGastoYActivoMismoPropietario(String docIdentificadorPropietario, String numElemento, String tipoElemento) {
	    if(Checks.esNulo(docIdentificadorPropietario) && Checks.esNulo(numElemento) && Checks.esNulo(tipoElemento)) {
            return false;
	    }
	    
	    String resultado = rawDao.getExecuteSQL("WITH GENERICO AS (\n" + 
	    		"    SELECT COUNT(1) ES_GEN\n" + 
	    		"    FROM REM01.DD_ENT_ENTIDAD_GASTO\n" + 
	    		"    WHERE DD_ENT_CODIGO = 'GEN'\n" + 
	    		"        AND 'GEN' = '" + tipoElemento + "'\n" + 
	    		"), ACTIVO AS (\n" + 
	    		"    SELECT COUNT(1) ES_ACT\n" + 
	    		"    FROM REM01.DD_ENT_ENTIDAD_GASTO\n" + 
	    		"    WHERE DD_ENT_CODIGO = 'ACT'\n" + 
	    		"        AND 'ACT' = '" + tipoElemento + "'\n" + 
	    		"), PAC AS (\n" + 
	    		"    SELECT PAC.PRO_ID\n" + 
	    		"    FROM REM01.ACT_ACTIVO ACT\n" + 
	    		"    JOIN REM01.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID\n" + 
	    		"        AND PAC.BORRADO = 0\n" + 
	    		"    JOIN ACTIVO ON ACTIVO.ES_ACT = 1\n" + 
	    		"    WHERE ACT.BORRADO = 0\n" + 
	    		"        AND ACT.ACT_NUM_ACTIVO = '" + numElemento + "'\n" + 
	    		"), AGS AS (\n" + 
	    		"    SELECT AGS.PRO_ID\n" + 
	    		"    FROM REM01.ACT_AGS_ACTIVO_GENERICO_STG AGS\n" + 
	    		"    JOIN GENERICO ON GENERICO.ES_GEN = 1\n" + 
	    		"    WHERE AGS.BORRADO = 0\n" + 
	    		"        AND AGS.AGS_ACTIVO_GENERICO = '" + numElemento + "'\n" + 
	    		")\n" + 
	    		"SELECT COUNT(DISTINCT PRO.PRO_ID)\n" + 
	    		"FROM REM01.ACT_PRO_PROPIETARIO PRO\n" + 
	    		"WHERE PRO.BORRADO = 0\n" + 
	    		"    AND PRO.PRO_DOCIDENTIF = '" + docIdentificadorPropietario + "'\n" + 
	    		"    AND (EXISTS (\n" + 
	    		"        SELECT 1\n" + 
	    		"        FROM PAC \n" + 
	    		"        WHERE PAC.PRO_ID = PRO.PRO_ID\n" + 
	    		"        ) OR EXISTS (\n" + 
	    		"        SELECT 1\n" + 
	    		"        FROM AGS \n" + 
	    		"        WHERE AGS.PRO_ID = PRO.PRO_ID\n" + 
	    		"        )\n" + 
	    		"    )");
	    
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean esGastoYAgrupacionMismoPropietario(String docIdentificadorPropietario, String numAgrupacion) {
	    if(Checks.esNulo(docIdentificadorPropietario) && Checks.esNulo(numAgrupacion)) {
            return false;
	    }
	
	    String carteraGasto = rawDao.getExecuteSQL("SELECT APRO.PRO_ID FROM ACT_PRO_PROPIETARIO APRO " + 
				"         WHERE APRO.pro_docidentif = '"+docIdentificadorPropietario+"' AND  APRO.BORRADO = 0 ");
		
		String carteraAgrupacion = null;
		String masDeUnaCartera = rawDao.getExecuteSQL("SELECT count(*) FROM (SELECT DISTINCT PACT.PRO_ID   " + 
				"		FROM ACT_PAC_PROPIETARIO_ACTIVO PACT " + 
				"		WHERE EXISTS ( " + 
				"		   SELECT 1 " + 
				"		   FROM ACT_AGR_AGRUPACION AGR " + 
				"		   JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " + 
				"		   WHERE AGR.AGR_NUM_AGRUP_REM = '"+numAgrupacion+"' " + 
				"		       AND AGA.ACT_ID  = PACT.ACT_ID " + 
				"		       AND AGR.BORRADO = 0 " + 
				"		       AND AGR.AGR_FECHA_BAJA IS NULL " + 
				"		))");
		
		if("1".equals(masDeUnaCartera)) {
			carteraAgrupacion = rawDao.getExecuteSQL("SELECT DISTINCT PACT.PRO_ID " + 
					"		FROM ACT_PAC_PROPIETARIO_ACTIVO PACT " + 
					"		WHERE EXISTS ( " + 
					"		   SELECT 1 " + 
					"		   FROM ACT_AGR_AGRUPACION AGR " + 
					"		   JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " + 
					"		   WHERE AGR.AGR_NUM_AGRUP_REM = '"+numAgrupacion+"' " + 
					"		       AND AGA.ACT_ID  = PACT.ACT_ID " + 
					"		       AND AGR.BORRADO = 0 " + 
					"		       AND AGR.AGR_FECHA_BAJA IS NULL " + 
					"		)");
		}
		if(Checks.esNulo(carteraGasto) || Checks.esNulo(carteraAgrupacion)) {
			return false;
		}
		
		
		
		return carteraGasto.equals(carteraAgrupacion);
    }
	
	@Override
	public Boolean existeEmisor(String emisorNIF) {
		if(Checks.esNulo(emisorNIF)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PVE_PROVEEDOR WHERE"
				+ "		 	PVE_DOCIDENTIF = '"+emisorNIF+"' "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	@Override
	public Boolean existePoblacionByDescripcion(String codigoPoblacion) {
		if(Checks.esNulo(codigoPoblacion)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		 FROM ${master.schema}.DD_LOC_localidad WHERE"
				+ "		 DD_LOC_CODIGO = '" + codigoPoblacion + "'"
				+ "		 AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean estaPerimetroAdmision(String activoId) {
		if (activoId == null || !StringUtils.isNumeric(activoId)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT act_pac_perimetro_activo.pac_check_admision "
												+"from rem01.act_pac_perimetro_activo"
												+"		WHERE act_id = "+ activoId +""
				);
		return !"0".equals(resultado);
	}

	@Override
	public Boolean comprobarCodigoTipoTitulo(String codTipoTitulo) {
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TTC_TIPO_TITULO_COMPLEM WHERE"
				+ "		 	DD_TTC_CODIGO = '"+codTipoTitulo+"' "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	
	
	
	@Override
	public Boolean existeActivoParaCMBBVA(String codCampo) {
		if(Checks.esNulo(codCampo) || !StringUtils.isNumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM REM01.ACT_ACTIVO "
						+ "WHERE ACT_NUM_ACTIVO = '" + codCampo + "' AND BORRADO = 0 "
		);
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean activoesDeCarteraCerberusBbvaCMBBVA(String codCampo) {
		if(Checks.esNulo(codCampo) || !StringUtils.isNumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM REM01.ACT_ACTIVO "
						+ "WHERE ACT_NUM_ACTIVO = '" + codCampo + "'AND DD_CRA_ID IN ('162','42') AND BORRADO = 0 "
		);
		
		return !"0".equals(resultado);
	}
	
	
	@Override
	public Boolean esActivoVendidoParaCMBBVA(String numActivo){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM rem01.DD_SCM_SITUACION_COMERCIAL scm, "
				+ "			  REM01.ACT_ACTIVO act "
				+ "			WHERE scm.dd_scm_id   = act.dd_scm_id "
				+ "			  AND scm.dd_scm_codigo = '05' "
				+ "			  AND act.ACT_NUM_ACTIVO = '"+numActivo+" '"
				+ "			  AND act.borrado       = 0");
		return !"0".equals(resultado);
	}

	
	@Override
	public Boolean esActivoIncluidoPerimetroParaCMBBVA(String numActivo){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT count(act.ACT_ID)"
				+ "		FROM REM01.ACT_ACTIVO act "
				+ "		LEFT JOIN REM01.ACT_PAC_PERIMETRO_ACTIVO pac "
				+ "		ON act.ACT_ID            = pac.ACT_ID "
				+ "		WHERE "
				+ "		(pac.PAC_INCLUIDO = 1 or pac.PAC_ID is null)"
				+ "		AND act.ACT_NUM_ACTIVO = '"+numActivo+"' ");
		return !Checks.esNulo(resultado);
	}
	
	@Override
	public Boolean esActivoRepetidoNumActivoBBVA(String numActivo){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM REM01.ACT_BBVA_ACTIVOS act "
				+ "			WHERE act.BBVA_NUM_ACTIVO = '"+numActivo+"' "
				+ "			  AND act.borrado       = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean codigoComercializacionIncorrecto(String codCampo) {
		if(Checks.esNulo(codCampo) || !StringUtils.isAlphanumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM REM01.DD_TCO_TIPO_COMERCIALIZACION "
						+ "WHERE DD_TCO_CODIGO = '" + codCampo + "'AND DD_TCO_CODIGO <> '04' AND BORRADO = 0 "
		);
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esOfertaBBVA(String numOferta) {
		if (Checks.esNulo(numOferta) || !StringUtils.isNumeric(numOferta)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS OFR "
				+ "JOIN ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID "
				+ "JOIN DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID "
				+ "WHERE OFR_NUM_OFERTA = "+numOferta+" "
				+ "AND DD_CRA_CODIGO = '16' "
				+ "AND OFR.BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esOfertaVendida(String numOferta) {
		if (Checks.esNulo(numOferta) || !StringUtils.isNumeric(numOferta)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS OFR "
				+ "JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID "
				+ "JOIN DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID "
				+ "WHERE OFR_NUM_OFERTA = "+numOferta+" "
				+ "AND EEC.DD_EEC_CODIGO = '08' "
				+ "AND OFR.BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esOfertaAnulada(String numOferta) {
		if (Checks.esNulo(numOferta) || !StringUtils.isNumeric(numOferta)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS OFR "
				+ "JOIN DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID "
				+ "WHERE OFR_NUM_OFERTA = "+numOferta+" "
				+ "AND EOF.DD_EOF_CODIGO = '02' "
				+ "AND OFR.BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esOfertaErronea(String numOferta) {
		if (Checks.esNulo(numOferta) || !StringUtils.isNumeric(numOferta)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS OFR "
				+ "JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID "
				+" JOIN DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID "
				+ "WHERE OFR_NUM_OFERTA = "+numOferta+" "
				+ "AND EEC.DD_EEC_CODIGO = '10' "
				+ "AND OFR.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeGastoConElIdLinea(String idGasto, String idLinea) {
		String resultado = rawDao.getExecuteSQL("SELECT count(1) " + 
				" FROM gld_gastos_linea_detalle linea " + 
				" JOIN gpv_gastos_proveedor gasto ON gasto.gpv_id = linea.gpv_id AND GASTO.GPV_NUM_GASTO_HAYA = " + idGasto + 
				" where GLD_ID = "+ idLinea +" AND gasto.borrado = 0 AND linea.borrado = 0");

		return !"0".equals(resultado);
	}		



	@Override
	public Boolean gastoRepetido(String factura, String fechaEmision, String nifEmisor, String nifPropietario) {
		String resultado = "0";
	
			if(factura == null || fechaEmision == null || nifEmisor == null || nifPropietario == null) {
				return false;
			}
		
			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
					+ "		 FROM GPV_GASTOS_PROVEEDOR WHERE "
					+ "		 GPV_REF_EMISOR = '" +factura+ "'"
					+ " 	 AND "
					+ "		 PVE_ID_EMISOR IN "
					+ "		 (SELECT PVE_ID FROM ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = '"+nifEmisor+"' AND BORRADO = 0 AND PVE_FECHA_BAJA IS NULL) AND "
					+ " 	 PRO_ID IN (SELECT PRO_ID FROM ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = '"+nifPropietario+"' AND BORRADO = 0) "
					+ "		 AND BORRADO = 0");

			return !"0".equals(resultado);
	}

	
	@Override
	public Boolean existeTrabajoByCodigo(String codTrabajo) {
		if (Checks.esNulo(codTrabajo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ "		FROM DD_TTR_TIPO_TRABAJO TTR " 
				+ "		WHERE ttr.dd_ttr_codigo = '"+codTrabajo+"'"
				+ "		AND TTR.BORRADO = 0");

		return !"0".equals(resultado);
	}

		

	@Override
	public Boolean existePromocionBBVA(String promocion){
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM ACT_BBVA_ACTIVOS "
				+ "WHERE bbva_cod_promocion = '"+promocion+"'");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean propietarioPerteneceCartera(String docIdent , List<String> listaCodigoCarteras) {
		if(Checks.estaVacio(listaCodigoCarteras) || Checks.esNulo(docIdent)) {
			return false;
		}
		String carteras = "";
		for (String string : listaCodigoCarteras) {
			carteras = carteras + " '" + string + "',";
		}
		
		carteras = carteras.substring(0, carteras.length() - 1);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PRO_PROPIETARIO PRO JOIN"
				+ "		 	DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID AND CRA.DD_CRA_CODIGO IN ("+carteras+") "
				+ "			WHERE PRO.PRO_DOCIDENTIF = '"+docIdent+"' "
				+ "		 	AND CRA.BORRADO = 0 AND PRO.BORRADO = 0");
		return !"0".equals(resultado);
		
	}


	@Override
	public boolean conEstadoGasto(String idGasto,String codigoEstado) {
		if(Checks.esNulo(idGasto) || Checks.esNulo(codigoEstado) || !StringUtils.isNumeric(idGasto) ) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM GPV_GASTOS_PROVEEDOR GASTOS "
				+ "JOIN DD_EGA_ESTADOS_GASTO DD on GASTOS.DD_EGA_ID = DD.DD_EGA_ID "
				+ "WHERE GASTOS.GPV_NUM_GASTO_HAYA = '"+idGasto+"' "
				+ "AND DD.DD_EGA_CODIGO = "+codigoEstado+" "
				+ "AND GASTOS.BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public String getDocIdentfPropietarioByNumGasto(String numGasto) {
		if(Checks.esNulo(numGasto)) {
			return null;
		}
	
		
		String resultado = rawDao.getExecuteSQL("SELECT pro_docidentif "
				+ "		 	FROM ACT_PRO_PROPIETARIO PRO JOIN"
				+ "		 	GPV_GASTOS_PROVEEDOR GPV ON GPV.PRO_ID = PRO.PRO_ID AND GPV.GPV_NUM_GASTO_HAYA = '"+numGasto+"'"
				+ "		 	AND GPV.BORRADO = 0 AND PRO.BORRADO = 0");

		return resultado;
	}
		
	
	@Override
	public String devolverEstadoGasto(String idGasto) {
		if(Checks.esNulo(idGasto)) {
			return null;
		}
		String resultado = rawDao.getExecuteSQL("SELECT DD.DD_EGA_CODIGO "
				+ "FROM GPV_GASTOS_PROVEEDOR GASTOS "
				+ "JOIN DD_EGA_ESTADOS_GASTO DD on GASTOS.DD_EGA_ID = DD.DD_EGA_ID "
				+ "WHERE GASTOS.GPV_NUM_GASTO_HAYA = '"+idGasto+"' "
				+ "AND GASTOS.BORRADO = 0 AND DD.BORRADO = 0");
		
		return resultado;
	}
	
	public String devolverEstadoGastoApartirDePrefactura(String idPrefactura) {
		if(Checks.esNulo(idPrefactura)) {
			return null;
		}
		String res = rawDao.getExecuteSQL("SELECT DD.DD_EGA_CODIGO "
				+ "FROM GPV_GASTOS_PROVEEDOR GASTO "
				+ "JOIN PFA_PREFACTURA PFA ON PFA.PFA_ID = GASTO.PFA_ID "
				+ "JOIN DD_EGA_ESTADOS_GASTO DD ON GASTO.DD_EGA_ID = DD.DD_EGA_ID "
				+ "WHERE PFA.PFA_NUM_PREFACTURA = '"+idPrefactura+"' "
				+ "AND PFA.BORRADO =0 AND DD.BORRADO = 0 AND GASTO.BORRADO = 0"
		);
		
		return res;
	}
	
	public String devolverEstadoGastoApartirDeAlbaran(String idAlbaran) {
		if(Checks.esNulo(idAlbaran)) {
			return null;
		}
		String res = rawDao.getExecuteSQL("SELECT DD.DD_EGA_CODIGO "
				+ "FROM GPV_GASTOS_PROVEEDOR GASTO "
				+ "JOIN PFA_PREFACTURA PFA ON PFA.PFA_ID = GASTO.PFA_ID "
				+ "JOIN ALB_ALBARAN ALB ON PFA.ALB_ID = ALB.ALB_ID "
				+ "JOIN DD_EGA_ESTADOS_GASTO DD ON GASTO.DD_EGA_ID = DD.DD_EGA_ID "
				+ "WHERE ALB.ALB_NUM_ALBARAN = '"+idAlbaran+"' "
				+ "AND ALB.BORRADO = 0 AND PFA.BORRADO =0 AND DD.BORRADO = 0 AND GASTO.BORRADO = 0"
		);
		
		return res;
	}
	
	@Override
	public boolean existeTipoRetencion(String tipoRetencion){
		String res = rawDao.getExecuteSQL("		SELECT COUNT(1) "
				+ "     FROM DD_TRE_TIPO_RETENCION tit			"
				+ "		WHERE tit.BORRADO = 0					"
				+ "		AND tit.DD_TRE_CODIGO = '"+tipoRetencion+"' "
				);

		return !res.equals("0");
	}

	@Override
	public boolean existeLineaEnGasto(String idLinea, String numGasto){
		
		String res = rawDao.getExecuteSQL("		SELECT COUNT(1) "
				+ "     FROM gld_gastos_linea_detalle GLD			"
				+ "		JOIN gpv_gastos_proveedor GPV  ON GLD.GPV_ID = GPV.GPV_ID AND GPV.GPV_NUM_GASTO_HAYA = '"+numGasto+"' "
				+ "		WHERE GPV.BORRADO = 0 AND GLD.BORRADO = 0 AND GLD.GLD_ID = '"+ idLinea+"' "
				);

		return !res.equals("0");
	}


	@Override
	public boolean tieneGastoFechaContabilizado(String idGasto) {
		if(Checks.esNulo(idGasto)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "FROM GPV_GASTOS_PROVEEDOR GPV "
				+ "JOIN GIC_GASTOS_INFO_CONTABILIDAD GIC on GPV.GPV_ID = GIC.GPV_ID AND GIC.GIC_FECHA_CONTABILIZACION IS NOT NULL "
				+ "WHERE GPV.GPV_NUM_GASTO_HAYA = '"+idGasto+"' "
				+ "AND GPV.BORRADO = 0 AND GIC.BORRADO = 0");
		
		return !"0".equals(resultado);
	}
	
	@Override
	public boolean tieneGastoFechaPagado(String idGasto) {
		if(Checks.esNulo(idGasto)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "FROM GPV_GASTOS_PROVEEDOR GPV "
				+ "JOIN GDE_GASTOS_DETALLE_ECONOMICO GDE on GPV.GPV_ID = GDE.GPV_ID AND GDE.GDE_FECHA_PAGO IS NOT NULL "
				+ "WHERE GPV.GPV_NUM_GASTO_HAYA = '"+idGasto+"' "
				+ "AND GPV.BORRADO = 0 AND GDE.BORRADO = 0");
		
		
		return !"0".equals(resultado);
	}

	@Override
	public String sacarCodigoSubtipoActivo(String descripcion) {

		if (descripcion == null) {
			return null;
		}
		String resultado = rawDao.getExecuteSQL("SELECT SAC.DD_SAC_CODIGO " 
				+ "		FROM REM01.DD_SAC_SUBTIPO_ACTIVO SAC" 
				+ "		WHERE SAC.DD_SAC_DESCRIPCION = '"+ descripcion + "'"
				+ "		AND SAC.BORRADO = 0");
		
		return resultado;
	}

	@Override	
	public Boolean existeSubtrabajoByCodigo(String codSubtrabajo) {
		if (Checks.esNulo(codSubtrabajo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ "		FROM DD_STR_SUBTIPO_TRABAJO STR " 
				+ "		WHERE STR.DD_STR_CODIGO = '"+codSubtrabajo+"'"
				+ "		AND STR.BORRADO = 0");

		return !"0".equals(resultado);
		
	}
	
	@Override
	public Boolean esSubtrabajoByCodTrabajoByCodSubtrabajo(String codTrabajo, String codSubtrabajo) {
		
		if (Checks.esNulo(codSubtrabajo) || Checks.esNulo(codTrabajo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ " FROM DD_STR_SUBTIPO_TRABAJO STR " 
				+ " INNER JOIN DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_ID = STR.DD_TTR_ID " 
				+ " WHERE TTR.DD_TTR_CODIGO = '"+codTrabajo+"'"
				+ " AND STR.DD_STR_CODIGO = '"+codSubtrabajo+"'"
				+ " AND STR.BORRADO= 0 AND TTR.BORRADO= 0");

		return !"0".equals(resultado);
		
	}
	
	@Override
	public Boolean existeProveedorAndProveedorContacto(String codProveedor, String proveedorContacto) {
		if (Checks.esNulo(codProveedor) || Checks.esNulo(proveedorContacto)) {
			return false;
		}
		
		try {
			Long codProveedorParse = Long.parseLong(codProveedor);
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ "FROM ACT_PVC_PROVEEDOR_CONTACTO PVC " 
				+ "JOIN ACT_PVE_PROVEEDOR PVE ON pve.pve_id = pvc.pve_id AND pve.pve_cod_rem = "+codProveedorParse+" " 
				+ "JOIN ${master.schema}.USU_USUARIOS USU ON pvc.usu_id = USU.USU_ID AND usu.usu_username = '"+proveedorContacto+"'");

			return !"0".equals(resultado);
		} catch (NumberFormatException e) {
			return false;

		}

	}
	@Override
	public Boolean esSubtipoTrabajoTomaPosesionPaquete(String subtrabajo) {
		if (subtrabajo == null) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ "		FROM DD_STR_SUBTIPO_TRABAJO STR " 
				+ "		WHERE STR.DD_STR_CODIGO = '"+subtrabajo+"'"
				+ "		AND STR.DD_STR_CODIGO IN ('PAQ','57')"
				+ "		AND STR.BORRADO = 0");

		return "0".equals(resultado);
	}
	@Override
	public Boolean esTarifaEnCarteradelActivo(String codTarifa, String idActivo) {
		if (codTarifa == null || idActivo == null) {
			return false;
		}
		Long numActivo = Long.parseLong(idActivo);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ " FROM ACT_CFT_CONFIG_TARIFA CFT " 
				+ " JOIN DD_TTF_TIPO_TARIFA TTF ON CFT.DD_TTF_ID = TTF.DD_TTF_ID AND ttf.dd_ttf_codigo ='"+codTarifa+"'" 
				+ " JOIN ACT_ACTIVO ACT ON ACT.DD_CRA_ID = CFT.DD_CRA_ID AND act.act_num_activo = "+numActivo+" ");

		return !"0".equals(resultado);
	}
	@Override
	public Boolean existeProveedorEnCarteraActivo(String proveedor, String idActivo) {
		if (proveedor == null || idActivo != null) {
			return false;
		}
		Long numProveedor = Long.parseLong(proveedor);
		Long numActivo= Long.parseLong(idActivo);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ " FROM ACT_ETP_ENTIDAD_PROVEEDOR ETP " 
				+ " JOIN ACT_ACTIVO ACT ON act.dd_cra_id = etp.dd_cra_id " 
				+ " JOIN ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = ETP.PVE_ID AND act.act_num_activo = "+numActivo+" " 
				+ " WHERE pve.pve_cod_rem = "+numProveedor+"");

		return "0".equals(resultado);
	}

	
	@Override
	public Boolean datosRegistralesRepetidos(String refCatastral,String finca, String folio, String libro, String tomo,  String numRegistro, String codigoLocalidad){
		String resultado;
		if(Checks.esNulo(refCatastral)) {
			resultado = rawDao.getExecuteSQL("SELECT count(1) FROM act_activo act "  
					+ "join BIE_DATOS_REGISTRALES bie on act.bie_id = bie.bie_id and bie.BIE_DREG_TOMO = '"+ tomo +"' "
					+ "and bie.BIE_DREG_LIBRO = '"+ libro +"' and bie.BIE_DREG_FOLIO = '"+ folio +"' and bie.BIE_DREG_NUM_FINCA = '"+ finca +"' and bie.bie_dreg_num_registro = '" +numRegistro +"'"  
					+ "join ${master.schema}.dd_loc_localidad loc on loc.dd_loc_id = bie.dd_loc_id and loc.dd_loc_codigo = '"+ codigoLocalidad +"'");
		}else {
			resultado = rawDao.getExecuteSQL("SELECT count(1) FROM act_activo act "  
				+ "join BIE_DATOS_REGISTRALES bie on act.bie_id = bie.bie_id and bie.BIE_DREG_TOMO = '"+ tomo +"' "
				+ "and bie.BIE_DREG_LIBRO = '"+ libro +"' and bie.BIE_DREG_FOLIO = '"+ folio +"' and bie.BIE_DREG_NUM_FINCA = '"+ finca +"' and bie.bie_dreg_num_registro = '" +numRegistro +"'"  
				+ "join ACT_CAT_CATASTRO cat on act.act_id = cat.act_id and cat.cat_ref_catastral = '"+ refCatastral + "'"  
				+ "join ${master.schema}.dd_loc_localidad loc on loc.dd_loc_id = bie.dd_loc_id and loc.dd_loc_codigo = '"+ codigoLocalidad +"'");
		
		}
		return !"0".equals(resultado);
	}

	
	@Override
	public Boolean subtipoPerteneceTipoActivo(String subtipo, String tipo){

		String resultado;

		if(!Checks.esNulo(tipo) && !Checks.esNulo(subtipo)){
			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM DD_SAC_SUBTIPO_ACTIVO sac "
			+ "JOIN dd_tpa_tipo_activo tpa ON sac.DD_TPA_ID = tpa.DD_TPA_ID AND TPA.DD_TPA_CODIGO = '"+tipo+"' "
			+ "WHERE sac.DD_SAC_CODIGO = '"+subtipo+"'");
	
			return (Integer.valueOf(resultado) > 0);
		}
		
		return false;
	}

	@Override
	public Boolean existeAlbaran(String idAlbaran) {
		if(Checks.esNulo(idAlbaran) || !StringUtils.isNumeric(idAlbaran))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ALB_ALBARAN WHERE"
				+ "		 	ALB_NUM_ALBARAN = '"+idAlbaran+"' "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existePrefactura(String idPrefactura) {
		if(Checks.esNulo(idPrefactura) || !StringUtils.isNumeric(idPrefactura))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM PFA_PREFACTURA WHERE"
				+ "		 	PFA_NUM_PREFACTURA = '"+idPrefactura+"' "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public List<String> getIdPrefacturasByNumAlbaran(String numAlbaran) {
		List<Object> resultados = rawDao.getExecuteSQLList("SELECT PFA.PFA_NUM_PREFACTURA FROM ALB_ALBARAN ALB "
				+ "JOIN PFA_PREFACTURA PFA ON PFA.ALB_ID = ALB.ALB_ID "
				+ "WHERE ALB.ALB_NUM_ALBARAN = '"+numAlbaran+"' "
				+ "AND ALB.BORRADO =0 AND PFA.BORRADO =0");
		
		List<String> listaString = new ArrayList<String>();
		
		for (Object valor : resultados) {
			listaString.add(valor.toString());
		}

		return listaString;
	}
	
	public Boolean getGastoSuplidoConFactura(String idGastoAfectado) {
		if(Checks.esNulo(idGastoAfectado)){
			return false;
			}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "FROM GPV_GASTOS_PROVEEDOR GPV WHERE "
				+ "GPV.gpv_num_gasto_haya = '"+idGastoAfectado+"' "
				+ "AND (GPV.gpv_suplidos_vinculados = '1' "
				+ "OR GPV.gpv_numero_factura_ppal IS NOT NULL) "
				+ "AND GPV.BORRADO = 0");
		return !"0".equals(resultado);
	}

	public Boolean isActivoGestionadoReam(String numActivo) {
		if(Checks.esNulo(numActivo)){
			return false;
			}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "FROM V_ACTIVOS_GESTIONADOS_REAM ream WHERE "
				+ "ream.ACT_ID IN "
				+ "(SELECT act.act_id FROM act_activo act WHERE act.act_num_activo = '"+numActivo+"' "
				+ "AND act.BORRADO = 0)");
		return "1".equals(resultado);
	}

}

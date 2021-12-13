package es.pfsgroup.framework.paradise.bulkUpload.api.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.zip.Checksum;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
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
	public static final String COD_DD_SRE_TASACION = "TASACION";
	public static final String COD_DD_SRE_CARGA = "CARGA";
	
	public static final String DD_TCO_VENTA = "01";
	public static final String DD_TCO_ALQUILER="03";
	public static final String DD_TCO_ALQUILER_VENTA="02";
	
	@Override
	public String getOneNumActivoAgrupacionRaw(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		
		rawDao.addParams(params);
		return rawDao.getExecuteSQL("SELECT TO_NUMBER(act.ACT_NUM_ACTIVO) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO aga, "
				+ "			    ACT_AGR_AGRUPACION agr, "
				+ "			    ACT_ACTIVO act "
				+ "			  WHERE aga.AGR_ID = agr.AGR_ID "
				+ "			    AND act.act_id   = aga.act_id "
				+ "			    AND agr.AGR_NUM_AGRUP_REM  = :numAgrupacion "
				+ "			    AND DECODE(aga.BORRADO, null, 0, aga.BORRADO)  = 0 "
				+ "			    AND DECODE(agr.BORRADO, null, 0, agr.BORRADO)  = 0 "
				+ "			    AND DECODE(act.BORRADO, null, 0, act.BORRADO)  = 0 "
				+ "				AND ROWNUM = 1 ");
	}

	public String getCarteraLocationByNumAgr (String numAgr) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgr", numAgr);
		
		rawDao.addParams(params);
		String tagId = rawDao.getExecuteSQL("SELECT DD_TAG_ID "
				+ "		  FROM ACT_AGR_AGRUPACION WHERE"
				+ " 		AGR_NUM_AGRUP_REM = :numAgr"
				+ "			AND BORRADO = 0"
				+ "         AND ROWNUM = 1 ");

		if (tagId == null) return null;

		String cartera = rawDao.getExecuteSQL("SELECT ACT.DD_CRA_ID "
				+ "		  FROM ACT_AGR_AGRUPACION AGR, ACT_AGA_AGRUPACION_ACTIVO AGA, ACT_ACTIVO ACT WHERE"
				+ " 		AGR.AGR_NUM_AGRUP_REM = :numAgr AND AGR.AGR_ID = AGA.AGR_ID AND AGA.ACT_ID = ACT.ACT_ID "
				+ " 		AND ACT.BORRADO = 0"
				+ " 		AND AGR.BORRADO = 0"
				+ " 		AND AGA.BORRADO = 0"
				+ "         AND ROWNUM = 1 ");

		if (cartera == null) cartera = "";

		if (tagId.equals("1")) {
			return rawDao.getExecuteSQL("SELECT '"+cartera+"-'||ONV.DD_PRV_ID||'-'||ONV.DD_LOC_ID||'-'||ONV.ONV_CP "
					+ "		  FROM ACT_ONV_OBRA_NUEVA ONV, ACT_AGR_AGRUPACION AGR WHERE"
					+ " 		AGR.AGR_NUM_AGRUP_REM = :numAgr AND AGR.AGR_ID = ONV.AGR_ID"
					+ "         AND ROWNUM = 1 ");
		} else if (tagId.equals("2")) {
			return rawDao.getExecuteSQL("SELECT '"+cartera+"-'||RES.DD_PRV_ID||'-'||RES.DD_LOC_ID||'-'||RES.RES_CP||'-PROPIETARIO-'|| PAC.PRO_ID "
					+ "		  FROM ACT_RES_RESTRINGIDA RES, ACT_AGR_AGRUPACION AGR, ACT_AGA_AGRUPACION_ACTIVO AGA, ACT_ACTIVO ACT, ACT_PAC_PROPIETARIO_ACTIVO PAC WHERE"
					+ " 		AGR.AGR_NUM_AGRUP_REM = :numAgr AND AGR.AGR_ID = RES.AGR_ID AND AGA.AGR_ID = AGR.AGR_ID AND"
					+ " 		AGA.ACT_ID = ACT.ACT_ID AND PAC.ACT_ID = ACT.ACT_ID"
					+ " 		AND ACT.BORRADO = 0"
					+ " 		AND AGR.BORRADO = 0"
					+ " 		AND AGA.BORRADO = 0"
					+ "         AND ROWNUM = 1 ");
		}
		return null;
	}

	public String getCarteraLocationByNumAct (String numActive) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActive", numActive);
		
		rawDao.addParams(params);
		return rawDao.getExecuteSQL("SELECT ACT.DD_CRA_ID||'-'||DD_PRV_ID||'-'||DD_LOC_ID||'-'||BIE_LOC_COD_POST "
							+ "		  FROM ACT_ACTIVO ACT, BIE_LOCALIZACION BIE WHERE"
							+ " 		ACT.ACT_NUM_ACTIVO = :numActive "
							+ " 		AND ACT.BIE_ID=BIE.BIE_ID"
							+ " 		AND ACT.BORRADO = 0"
							+ " 		AND BIE.BORRADO = 0"
							+ "         AND ROWNUM = 1 ");
	}

	public String getCarteraLocationTipPatrimByNumAct (String numActive) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActive", numActive);
		
		rawDao.addParams(params);
		return rawDao.getExecuteSQL("SELECT ACT.DD_CRA_ID||'-'||DD_PRV_ID||'-'||DD_LOC_ID||'-'||BIE_LOC_COD_POST||'-PROPIETARIO-'||PAC.PRO_ID "
							+ "		  FROM ACT_ACTIVO ACT, BIE_LOCALIZACION BIE, ACT_PAC_PROPIETARIO_ACTIVO PAC WHERE"
							+ " 		ACT.ACT_NUM_ACTIVO = :numActive "
							+ " 		AND ACT.BIE_ID=BIE.BIE_ID"
							+ "			AND PAC.ACT_ID =  ACT.ACT_ID"
							+ " 		AND ACT.BORRADO = 0"
							+ " 		AND BIE.BORRADO = 0"
							+ "         AND ROWNUM = 1 ");
	}

	@Override
	public Boolean esMismaCarteraLocationByNumAgrupRem (String numAgrupRem){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupRem", numAgrupRem);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.ACT_ID) "
							+ "		  FROM ACT_AGA_AGRUPACION_ACTIVO aga, ACT_AGR_AGRUPACION agr, ACT_ACTIVO act, BIE_LOCALIZACION loc "
							+ "		  WHERE  "
							+ "		  aga.AGR_ID = agr.AGR_ID "
							+ "		  AND aga.ACT_ID = act.ACT_ID "
							+ "		  AND act.BIE_ID = loc.BIE_ID "
							+ "		  AND agr.AGR_NUM_AGRUP_REM = :numAgrupRem "
							+ "		  GROUP BY act.DD_CRA_ID, loc.DD_PRV_ID, loc.DD_LOC_ID, loc.BIE_LOC_COD_POST ");
		return "1".equals(resultado);
	}

	@Override
	public String existeActivoEnAgrupacion(Long idActivo, Long idAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idActivo", idActivo);
		params.put("idAgrupacion", idAgrupacion);
		
		rawDao.addParams(params);
		return rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		  FROM ACT_AGA_AGRUPACION_ACTIVO WHERE"
				+ " 		ACT_ID = :idActivo "
				+ " 		AND AGR_ID = :idAgrupacion "
				+ "			AND BORRADO = 0");
	}

	@Override
	public Boolean esActivoPrincipalEnAgrupacion(Long numActivo) {
		return esActivoPrincipalEnAgrupacion(numActivo, null);
	}
	
	@Override
	public Boolean esActivoPrincipalEnAgrupacion(Long numActivo, String tipoAgr) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		String sql = "SELECT COUNT(AGR.AGR_ID) "
				+ "           FROM ACT_AGR_AGRUPACION AGR, ACT_ACTIVO ACT "
				+ "           WHERE ACT.ACT_ID  = AGR.AGR_ACT_PRINCIPAL " 
				+ "           AND ACT.ACT_NUM_ACTIVO = :numActivo "
				+ "           AND AGR.BORRADO  = 0 AND AGR.AGR_FECHA_BAJA IS NULL"
				+ "           AND ACT.BORRADO  = 0";
		if(tipoAgr != null) {
			params.put("tipoAgr", tipoAgr);
			sql += " AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = :tipoAgr)";
		}
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL(sql);
		return !"0".equals(resultado);
	}

	@Override
	public Boolean activoEnAgrupacionRestringida(Long numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(aga.AGR_ID) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO aga, "
				+ "			    ACT_AGR_AGRUPACION agr, "
				+ "			    ACT_ACTIVO act, "
				+ "			    DD_TAG_TIPO_AGRUPACION tipoAgr "
				+ "			  WHERE aga.AGR_ID = agr.AGR_ID "
				+ "			    AND act.act_id   = aga.act_id "
				+ "			    AND tipoAgr.DD_TAG_ID = agr.DD_TAG_ID "
				+ "			    AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			    AND tipoAgr.DD_TAG_CODIGO IN ('02','17','18') "
				+ "				AND (agr.AGR_FECHA_BAJA is null OR agr.AGR_FECHA_BAJA  > SYSDATE)"
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND agr.BORRADO  = 0 "
				+ "			    AND act.BORRADO  = 0 ");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean activoPrincipalEnAgrupacionRestringida(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT count(1)      \n" + 
				"FROM REM01.ACT_AGA_AGRUPACION_ACTIVO aga\n" + 
				"JOIN REM01.ACT_AGR_AGRUPACION agr on aga.agr_id = agr.agr_id and agr.borrado = 0 \n" + 
				"join REM01.DD_TAG_TIPO_AGRUPACION tagg on agr.dd_tag_id = tagg.dd_tag_id \n" + 
				"where tagg.dd_Tag_codigo =  '02' and aga.borrado = 0  and AGR.agr_act_principal = (SELECT ACT_ID FROM REM01.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = :numActivo ) " + 
				"and (agr.AGR_FECHA_BAJA is null OR agr.AGR_FECHA_BAJA  > SYSDATE) and rownum = 1");
		return "1".equals(resultado);
	}

	@Override
	public Boolean esActivoEnAgrupacion(Long numActivo, Long numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("numAgrupacion", numAgrupacion);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(AGA.AGR_ID) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO AGA, "
				+ "			    ACT_AGR_AGRUPACION AGR, "
				+ "			    ACT_ACTIVO ACT "
				+ "			  WHERE AGA.AGR_ID = AGR.AGR_ID "
				+ "			    AND ACT.ACT_ID   = AGA.ACT_ID "
				+ "			    AND ACT.ACT_NUM_ACTIVO = :numActivo "
				+ "			    AND AGR.AGR_NUM_AGRUP_REM  = :numAgrupacion "
				+ "				AND (agr.AGR_FECHA_BAJA is null OR agr.AGR_FECHA_BAJA  > SYSDATE)"
				+ "			    AND AGA.BORRADO  = 0 "
				+ "			    AND AGR.BORRADO  = 0 "
				+ "			    AND ACT.BORRADO  = 0 ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esActivoEnAgrupacionPorTipo(Long numActivo, String codTipoAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("codTipoAgrupacion", codTipoAgrupacion);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(aga.AGR_ID) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO aga, "
				+ "			    ACT_AGR_AGRUPACION agr, "
				+ "			    DD_TAG_TIPO_AGRUPACION tag, "
				+ "			    ACT_ACTIVO act "
				+ "			  WHERE aga.AGR_ID = agr.AGR_ID "
				+ "			    AND agr.dd_tag_id = tag.dd_tag_id "
				+ "			    AND act.act_id   = aga.act_id "
				+ "			    AND tag.dd_tag_codigo = :codTipoAgrupacion "
				+ "			    AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND agr.BORRADO  = 0 "
				+ "			    AND act.BORRADO  = 0 "
				+ "				AND (agr.AGR_FECHA_BAJA is null OR agr.AGR_FECHA_BAJA  > SYSDATE)");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esActivoEnOtraAgrupacion(Long numActivo, Long numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("numAgrupacion", numAgrupacion);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(aga.AGR_ID) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO aga, "
				+ "			    ACT_AGR_AGRUPACION agr, "
				+ "			    ACT_ACTIVO act "
				+ "			  WHERE aga.AGR_ID = agr.AGR_ID "
				+ "			    AND act.act_id   = aga.act_id "
				+ "			    AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			    AND agr.AGR_NUM_AGRUP_REM  <> :numAgrupacion "
				+ "				AND (agr.AGR_FECHA_BAJA is null OR agr.AGR_FECHA_BAJA  > SYSDATE)"
				+ "			    AND aga.BORRADO  = 0 "
				+ "			    AND agr.BORRADO  = 0 "
				+ "			    AND act.BORRADO  = 0 ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeActivo(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_ACTIVO WHERE"
				+ "		 	ACT_NUM_ACTIVO = :numActivo "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esActivoEnTramite(String numActivo){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_ACTIVO WHERE"
				+ "		 	ACT_NUM_ACTIVO = :numActivo "
				+ "		 	AND BORRADO = 0 AND ACT_EN_TRAMITE = 1");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeOferta(String numOferta){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numOferta", numOferta);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS WHERE "
				+ "OFR_NUM_OFERTA = :numOferta "
				+ "AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isOfferOfGiants(String numOferta){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numOferta", numOferta);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS OFR "
				+ "JOIN ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID "
				+ "JOIN DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID "
				+ "WHERE OFR_NUM_OFERTA = :numOferta "
				+ "AND DD_CRA_CODIGO = '12' "
				+ "AND OFR.BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esOfertaPendienteDeSancion(String numOferta){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numOferta", numOferta);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ECO_EXPEDIENTE_COMERCIAL ECO "
				+ "JOIN OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID "
				+ "JOIN DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID "
				+ "WHERE OFR.OFR_NUM_OFERTA = :numOferta "
				+ "AND (EEC.DD_EEC_CODIGO = '10' OR EEC.DD_EEC_CODIGO = '23') "
				+ "AND ECO.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isAgrupacionOfGiants(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_AGR_AGRUPACION AGR "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AGR.AGR_ACT_PRINCIPAL "
				+ "JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion "
				+ "AND DD_CRA_CODIGO = '12' ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoOfGiants(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_ACTIVO ACT "
				+ "JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID "
				+ "WHERE CRA.DD_CRA_CODIGO = '12' "
				+ "AND ACT.ACT_NUM_ACTIVO = :numActivo ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoVendido(String numActivo){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_ACTIVO ACT "
				+ " INNER JOIN DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID = SCM.DD_SCM_ID"
				+ "	WHERE"
				+ "		 	ACT.ACT_NUM_ACTIVO = :numActivo "
				+ "		 	AND ACT.BORRADO = 0"
				+ " AND DD_SCM_DESCRIPCION LIKE 'Vendido'");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existePlusvalia(String numActivo){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM EPV_ECO_PLUSVALIAVENTA EPV"
				+ " INNER JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = EPV.ECO_ID"
				+ " INNER JOIN OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID "
				+ " INNER JOIN ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID"
				+ " INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID "
				+ " INNER JOIN DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID"
				+ "	WHERE ACT_NUM_ACTIVO = :numActivo "
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
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("catastro", catastro);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_CAT_CATASTRO WHERE"
				+ "		 	CAT_REF_CATASTRAL =:catastro "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeActivoEnPropietarios(String numActivo, String idPropietarios){
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo) && Checks.esNulo(idPropietarios) || !StringUtils.isAlphanumeric(idPropietarios))
			return false;
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String cpr_id = rawDao.getExecuteSQL("SELECT CPR_ID "
				+ "		 FROM ACT_ACTIVO WHERE"
				+ "		 	ACT_NUM_ACTIVO = :numActivo "
				+ "		 	AND BORRADO = 0");

		return !Checks.esNulo(cpr_id);
	}

	@Override
	public Boolean existeComunidadPropietarios(String idPropietarios){
		if(Checks.esNulo(idPropietarios) || !StringUtils.isAlphanumeric(idPropietarios))
			return false;
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idPropietarios", idPropietarios);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_CPR_COM_PROPIETARIOS WHERE"
				+ "		 CPR_NIF = :idPropietarios "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeEstadoLoc(String codEstadoLoc){
		if(Checks.esNulo(codEstadoLoc) || !StringUtils.isAlphanumeric(codEstadoLoc))
			return false;

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codEstadoLoc", codEstadoLoc);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_ELO_ESTADO_LOCALIZACION WHERE"
				+ "		 DD_ELO_CODIGO = :codEstadoLoc "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeSubestadoGestion(String codSubestadoGestion){
		if(Checks.esNulo(codSubestadoGestion))
			return false;

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codSubestadoGestion", codSubestadoGestion);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_SEG_SUBESTADO_GESTION WHERE"
				+ "		 DD_SEG_CODIGO = :codSubestadoGestion "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean isActivoPrePublicable(String numActivo){
		return isActivoGestionAdmision(numActivo) && isActivoUltimoInformeComercialAceptado(numActivo);
	}

	private Boolean isActivoGestionAdmision(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		 FROM ACT_ACTIVO WHERE "
				+ "			ACT_ADMISION = 1 "
				+ "			AND ACT_ADMISION = 1 "
				+ "		 	AND ACT_NUM_ACTIVO =:numActivo "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	private Boolean isActivoUltimoInformeComercialAceptado(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("select count(1) from ( "
				+ "		 	  select dd_aic_codigo from ( "
				+ "		 	    select aic.dd_aic_codigo "
				+ "		 	    from ACT_ACTIVO act, "
				+ "		 	         ACT_HIC_EST_INF_COMER_HIST hic, "
				+ "		 	         DD_AIC_ACCION_INF_COMERCIAL aic "
				+ "		 	    where act.act_id = hic.act_id "
				+ "		 	      and hic.dd_aic_id = aic.dd_aic_id "
				+ "		 	      AND ACT_NUM_ACTIVO = :numActivo "
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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO = :numActivo "
				+ "			AND BORRADO = 0 "
				+ "			AND ( DD_EPU_ID IS NULL "
				+ "			      OR DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				     FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				     WHERE DD_EPU_CODIGO IN ('06')) )");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean estadoOcultaractivo(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO = :numActivo "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('01'))");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean estadoDesocultaractivo(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO = :numActivo "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('03'))");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean estadoOcultarprecio(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO = :numActivo "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('01','02'))");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean estadoDesocultarprecio(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO = :numActivo "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('04','07'))");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean estadoDespublicar(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		//Despublicar Forzado solo admite activos en estado publicado (ordinario)
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO = :numActivo "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('01'))");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean estadosValidosDespublicarForzado(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO = :numActivo "
				+ "			AND BORRADO = 0"
				+ "			AND DD_EPU_ID IN (SELECT DD_EPU_ID"
				+ "				FROM DD_EPU_ESTADO_PUBLICACION EPU"
				+ "				WHERE DD_EPU_CODIGO IN ('02', '07'))");
		return !"0".equals(resultado);
	}

	public Boolean estadosValidosDesDespublicarForzado(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO = :numActivo "
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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO WHERE"
				+ "			ACT_NUM_ACTIVO = :numActivo "
				+ "			AND BORRADO = 0"
				+ "			AND ACT_BLOQUEO_PRECIO_FECHA_INI IS NOT NULL");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeOfertaAprobadaActivo(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO ACT, ACT_OFR AO, OFR_OFERTAS OFR, DD_EOF_ESTADOS_OFERTA ESO WHERE"
				+ "         AO.ACT_ID = ACT.ACT_ID"
				+ "         AND AO.OFR_ID = OFR.OFR_ID"
				+ "         AND OFR.DD_EOF_ID = ESO.DD_EOF_ID"
				+ "			AND ACT.ACT_NUM_ACTIVO = :numActivo "
				+ "         AND ESO.DD_EOF_CODIGO = '01'"
				+ "			AND ACT.BORRADO = 0"
				+ "			AND OFR.BORRADO = 0"
				+ "			AND ACT.ACT_BLOQUEO_PRECIO_FECHA_INI IS NOT NULL");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esActivoConVentaOferta(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM DD_SCM_SITUACION_COMERCIAL scm, "
				+ "			  ACT_ACTIVO act "
				+ "			WHERE scm.dd_scm_id   = act.dd_scm_id "
				+ "			  AND scm.dd_scm_codigo = '03' "
				+ "			  AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			  AND act.borrado       = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esActivoVendido(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM DD_SCM_SITUACION_COMERCIAL scm, "
				+ "			  ACT_ACTIVO act "
				+ "			WHERE scm.dd_scm_id   = act.dd_scm_id "
				+ "			  AND scm.dd_scm_codigo = '05' "
				+ "			  AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			  AND act.borrado       = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esActivoIncluidoPerimetro(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT act.ACT_ID "
				+ "		FROM ACT_ACTIVO act "	
				+ "		LEFT JOIN ACT_PAC_PERIMETRO_ACTIVO pac "
				+ "		ON act.ACT_ID            = pac.ACT_ID "
				+ "		WHERE "
				+ "		(pac.PAC_INCLUIDO = 1 or pac.PAC_ID is null)"
				+ "		AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "		AND pac.BORRADO = 0 AND act.BORRADO = 0	");
		return !Checks.esNulo(resultado);
	}

	@Override
	public Boolean esActivoAsistido (String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		FROM ACT_ACTIVO act "
				+ "		INNER JOIN DD_SCR_SUBCARTERA scr "
				+ "		ON act.DD_SCR_ID            = scr.DD_SCR_ID "
				+ "		WHERE "
				+ "		scr.DD_SCR_CODIGO IN ('01','02','03','38') "
				+ "		AND act.ACT_NUM_ACTIVO =  :numActivo ");

		String resultado2 = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		FROM ACT_ACTIVO act "
				+ "		INNER JOIN ACT_ABA_ACTIVO_BANCARIO aba "
				+ "		ON act.act_id            = aba.act_id "
				+ "		INNER JOIN DD_CLA_CLASE_ACTIVO cla "
				+ "		ON aba.dd_cla_id            = cla.dd_cla_id "
				+ "		WHERE "
				+ "		cla.DD_CLA_CODIGO = '01' "
				+ "		AND act.ACT_NUM_ACTIVO = :numActivo ");
		return !"0".equals(resultado) || !"0".equals(resultado2);
	}

	@Override
	public Boolean esAgrupacionConBaja (String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		FROM ACT_AGR_AGRUPACION agr "
				+ "		WHERE "
				+ "		agr.AGR_FECHA_BAJA IS NOT NULL "
				+ "		AND agr.AGR_NUM_AGRUP_REM = :numAgrupacion ");
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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("agrupacion", agrupacion);

		String[] lista = inSqlNumActivosRem.split(",");
		List<String> listaActivosAAnyadir = new ArrayList<String>();

		Collections.addAll(listaActivosAAnyadir, lista);

		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT DISTINCT act.dd_cra_id"
				+" FROM ACT_AGR_AGRUPACION aaa"
				+" JOIN ACT_AGA_AGRUPACION_ACTIVO aga ON aaa.AGR_ID = aga.AGR_ID AND aaa.AGR_NUM_AGRUP_REM = :agrupacion "
				+" JOIN ACT_ACTIVO act ON aga.act_id = act.act_id"
				+" JOIN DD_CRA_CARTERA cra ON cra.DD_CRA_ID = act.DD_CRA_ID"
				+" AND aaa.BORRADO  = 0  AND act.BORRADO  = 0");
				
		params = new HashMap<String, Object>();

		if(!Checks.esNulo(resultado)){
			for(String a: listaActivosAAnyadir){
				params.put("a", a);
				
				rawDao.addParams(params);
				
				String carteraActivo = rawDao.getExecuteSQL("SELECT dd_cra_id"
						+" FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = :a");

				if(!resultado.equals(carteraActivo)){
					return false;
				}
			}

		}else{
			boolean esPrimero = true;
			String referencia = "";

			for(String a: listaActivosAAnyadir){
				params.put("a", a);
				
				rawDao.addParams(params);
				
				String carteraActivo = rawDao.getExecuteSQL("SELECT dd_cra_id"
						+" FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = :a");

				if(!esPrimero){
					if(!Checks.esNulo(resultado)){
						if(!resultado.equals(carteraActivo)){
							return false;
						}
					}else {						
						rawDao.addParams(params);
						
						carteraActivo = rawDao.getExecuteSQL("SELECT dd_cra_id" + " FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = :a");

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
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("numAgrupRem", numAgrupRem);

		rawDao.addParams(param);
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
				+ "      AND act1.act_num_activo in (" +inSqlNumActivosRem + ") "
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
				+ "      AND agr1.agr_num_agrup_rem = :numAgrupRem  "
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
				+ "      AND agr1.agr_num_agrup_rem = :numAgrupRem  "
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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sqlNumActivoRem", sqlNumActivoRem);

		if(Checks.esNulo(sqlNumActivoRem))
			return false;

		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			    FROM ACT_PAC_PROPIETARIO_ACTIVO pac, "
				+ "			      ACT_ACTIVO act "
				+ "			    WHERE act.act_id       = pac.act_id "
				+ "			      AND act.ACT_NUM_ACTIVO = :sqlNumActivoRem "
				+ "			      AND pac.BORRADO  = 0 "
				+ "			      AND act.BORRADO  = 0 "
				+ "			    GROUP BY pac.PRO_ID ");

		return "1".equals(resultado);
	}

	@Override
	public Boolean esActivoEnOtraAgrupacionNoCompatible(Long numActivo, Long numAgrupacion, String codTiposAgrNoCompatibles) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("numAgrupacion", numAgrupacion);
		String cadenaCodigosSql = convertStringToGroupSql(codTiposAgrNoCompatibles);

		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(aga.AGR_ID) "
				+ "			  FROM ACT_AGA_AGRUPACION_ACTIVO aga, "
				+ "			    ACT_AGR_AGRUPACION agr, "
				+ "			    ACT_ACTIVO act,"
				+ "				DD_TAG_TIPO_AGRUPACION tag "
				+ "			  WHERE aga.AGR_ID = agr.AGR_ID "
				+ "			    AND act.act_id   = aga.act_id "
				+ "			    AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "				AND agr.DD_TAG_ID = tag.DD_TAG_ID "
				+ "			    AND tag.DD_TAG_CODIGO in ("+cadenaCodigosSql+") "
				+ "			    AND agr.AGR_NUM_AGRUP_REM  <> :numAgrupacion "
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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		FROM ACT_ABA_ACTIVO_BANCARIO aba "
				+ "		INNER JOIN DD_CLA_CLASE_ACTIVO cla "
				+ "		ON cla.DD_CLA_ID = aba.DD_CLA_ID "
				+ "		WHERE "
				+ "		cla.DD_CLA_CODIGO ='01' "
				+ "		AND aba.ACT_ID = (select act_id from act_activo where act_num_activo = :numActivo) ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean esPropuestaYaCargada(Long numPropuesta) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numPropuesta", numPropuesta);
		
		rawDao.addParams(params);
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		FROM PRP_PROPUESTAS_PRECIOS prp "
				+ "		INNER JOIN DD_EPP_ESTADO_PROP_PRECIO epp "
				+ " 	ON epp.DD_EPP_ID = prp.DD_EPP_ID "
				+ " 	WHERE "
				+ " 	epp.DD_EPP_CODIGO = '04'"
				+ " 	AND prp.PRP_NUM_PROPUESTA = :numPropuesta ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoNoComercializable(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM DD_SCM_SITUACION_COMERCIAL scm, "
				+ "			  ACT_ACTIVO act "
				+ "			  WHERE scm.dd_scm_id   = act.dd_scm_id "
				+ "			  AND scm.dd_scm_codigo = '01' "
				+ "			  AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			  AND act.borrado = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean destinoFinalNoVenta(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO act "
				+ "			INNER JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+ "			WHERE APU.dd_tco_id IN ( "
				+ "				SELECT tco.DD_TCO_ID "
				+ "				FROM DD_TCO_TIPO_COMERCIALIZACION tco"
				+ "				where tco.DD_TCO_CODIGO NOT IN ('01','02')) "
				+ "			AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			AND act.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean destinoFinalNoAlquiler(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO act "
				+ "			INNER JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+ "			WHERE apu.DD_TCO_ID IN ( "
				+ "				SELECT tco.DD_TCO_ID "
				+ "				FROM DD_TCO_TIPO_COMERCIALIZACION tco"
				+ "				where tco.DD_TCO_CODIGO NOT IN ('02','03')) "
				+ "			AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			AND act.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean activoNoPublicado(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO act "
				+ "			WHERE act.ACT_ID NOT IN ( "
				+ "				SELECT apu.ACT_ID FROM ACT_APU_ACTIVO_PUBLICACION apu WHERE apu.BORRADO = 0) "
				+ "			AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			AND act.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean activoOcultoVenta(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numActivo)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_APU_ACTIVO_PUBLICACION apu "
				+ "			WHERE apu.APU_CHECK_OCULTAR_V = 1 "
				+ "			AND apu.BORRADO = 0"
				+ "			AND apu.ACT_ID = (SELECT act.ACT_ID FROM ACT_ACTIVO act WHERE act.ACT_NUM_ACTIVO = :numActivo) ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean activoOcultoAlquiler(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numActivo)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_APU_ACTIVO_PUBLICACION apu "
				+ "			WHERE apu.APU_CHECK_OCULTAR_A = 1 "
				+ "			AND apu.BORRADO = 0"
				+ "			AND apu.ACT_ID = (SELECT act.ACT_ID FROM ACT_ACTIVO act WHERE act.ACT_NUM_ACTIVO = :numActivo) ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean motivoNotExistsByCod(String codigoMotivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoMotivo", codigoMotivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codigoMotivo)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "				FROM DD_MTO_MOTIVOS_OCULTACION mto "
				+ "				WHERE mto.DD_MTO_CODIGO = :codigoMotivo "
				+ "				AND mto.BORRADO = 0");

		return "0".equals(resultado);
	}

	@Override
	public Boolean isActivoNoPublicable(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_PAC_PERIMETRO_ACTIVO pac, ACT_ACTIVO act "
				+ "			WHERE pac.act_id = act.act_id "
				+ "			AND pac.PAC_CHECK_PUBLICAR <> 1 "
				+ "			AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			AND act.borrado = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoDestinoComercialNoVenta(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_ACTIVO act "
				+ "			JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+ "			WHERE APU.dd_tco_id IN (SELECT dd_tco_id FROM DD_TCO_TIPO_COMERCIALIZACION WHERE dd_tco_codigo in('01', '02')) "
				+ "			AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			AND act.borrado = 0");

		return "0".equals(resultado);
	}

	@Override
	public Boolean isActivoDestinoComercialNoAlquiler(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_ACTIVO act "
				+ "			JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+ "			WHERE APU.dd_tco_id IN (SELECT dd_tco_id FROM DD_TCO_TIPO_COMERCIALIZACION WHERE dd_tco_codigo in('03', '02')) "
				+ "			AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			AND act.borrado = 0");

		return "0".equals(resultado);
	}

	@Override
	public Boolean isActivoSinPrecioVentaWeb(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_ACTIVO act,  ACT_VAL_VALORACIONES val "
				+ "			WHERE act.act_id = val.act_id "
				+ "         AND val.DD_TPC_ID in (select DD_TPC_ID from DD_TPC_TIPO_PRECIO where dd_tpc_codigo in ('02')) "
				+ "			AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			AND act.borrado = 0");

		return "0".equals(resultado);
	}

	@Override
	public Boolean isActivoSinPrecioRentaWeb(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_ACTIVO act,  ACT_VAL_VALORACIONES val "
				+ "			WHERE act.act_id = val.act_id "
				+ "         AND val.DD_TPC_ID in (select DD_TPC_ID from DD_TPC_TIPO_PRECIO where dd_tpc_codigo in ('03')) "
				+ "			AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			AND act.borrado = 0");

		return "0".equals(resultado);
	}

	@Override
	public Boolean isActivoSinInformeAprobado(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_ACTIVO act,  V_COND_DISPONIBILIDAD cond "
				+ "			WHERE act.act_id = cond.act_id "
				+ "         AND cond.SIN_INFORME_APROBADO = 1 "
				+ "			AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			AND act.borrado = 0");

		return !"0".equals(resultado);
	}

	@Override
	public List<BigDecimal> getImportesActualesActivo(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		Object[] resultados = rawDao.getExecuteSQLArray(
				"		SELECT (SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '02')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo)"
						+ "AND VAL_FECHA_FIN IS NULL) AS IMPORTE_PAV,"
				+ "		(SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS IMPORTE_PMA,"
				+ "		(SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '03')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS IMPORTE_PAR,"
				+ "		(SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '07')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS IMPORTE_PDA,"
				+ "		(SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '13')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS IMPORTE_PDP"
				+ "		FROM DUAL ");

		List<BigDecimal> listaImportes = new ArrayList<BigDecimal>();

		for(Object o: resultados){
			listaImportes.add((BigDecimal) o);
		}

		return listaImportes;
	}

	public List<Date> getFechasImportesActualesActivo(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		Object[] resultados = rawDao.getExecuteSQLArray(
			"	SELECT "
			+ "		(SELECT VAL_FECHA_APROBACION FROM V_PRECIOS_VIGENTES" 
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '02')" 
			+ "		AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_APROB_PAV,"
			+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '02')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_INICIO_PAV,"
			+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '02')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_FIN_PAV,"

			+ "		(SELECT VAL_FECHA_APROBACION FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_APROB_PMA,"
			+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_INICIO_PMA,"
			+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_FIN_PMA,"

			+ "		(SELECT VAL_FECHA_APROBACION FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '03')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_APROB_PAR,"
			+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '03')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_INICIO_PAR,"
			+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '03')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_FIN_PAR,"

			+ "		(SELECT VAL_FECHA_APROBACION FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '07')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_APROBACION_PDA,"
			+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '07')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_INICIO_PDA,"
			+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '07')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_FIN_PDA,"

			+ "		(SELECT VAL_FECHA_APROBACION FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '13')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_APROBACION_PDP,"
			+ "		(SELECT VAL_FECHA_INICIO FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '13')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_INICIO_PDP,"
			+ "		(SELECT VAL_FECHA_FIN FROM V_PRECIOS_VIGENTES"
			+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '13')"
			+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo) AND VAL_FECHA_FIN IS NULL ) AS FECHA_FIN_PDP"
			+ "	FROM DUAL ");

		List<Date> listaFechasImportes = new ArrayList<Date>();

		for(Object o: resultados){
			listaFechasImportes.add((Date) o);
		}

		return listaFechasImportes;
	}

	@Override
	public Boolean existeActivoEnPropuesta(String numActivo, String numPropuesta) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("numPropuesta", numPropuesta);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo) || Checks.esNulo(numPropuesta))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO ACT "
				+ " 	JOIN ACT_PRP APR ON ACT.ACT_ID = APR.ACT_ID "
				+ " 	JOIN PRP_PROPUESTAS_PRECIOS PRP ON APR.PRP_ID=PRP.PRP_ID "
				+ "		WHERE ACT.ACT_NUM_ACTIVO = :numActivo "
				+ " 	AND PRP.PRP_NUM_PROPUESTA = :numPropuesta ");

		return !"0".equals(resultado);
	}

	@Override
	public BigDecimal getPrecioMinimoAutorizadoActualActivo(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		BigDecimal resultado = null;

		rawDao.addParams(params);
		Object[] resultados = rawDao.getExecuteSQLArray(
				"		SELECT (SELECT VAL_IMPORTE FROM V_PRECIOS_VIGENTES"
				+ "		WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')"
				+ " 	AND ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ACTIVO.ACT_NUM_ACTIVO = :numActivo)) AS IMPORTE_PMA"
				+ "		FROM DUAL ");

		for(Object o: resultados){
			resultado = ((BigDecimal) o);
		}

		return resultado;
	}

	@Override
	public Boolean existeActivoConOfertaViva(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO ACT "
				+ " 	JOIN ACT_OFR ACTOF ON ACT.ACT_ID = ACTOF.ACT_ID "
				+ " 	JOIN OFR_OFERTAS OFR ON ACTOF.OFR_ID = OFR.OFR_ID "
				+ " 	JOIN DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID "
				+ "		WHERE ACT.ACT_NUM_ACTIVO =:numActivo "
				+ " 	AND EOF.DD_EOF_CODIGO IN ('01','03','04')"
				+ "		AND ACT.BORRADO = 0 AND OFR.BORRADO = 0 AND EOF.BORRADO = 0");
		return !"0".equals(resultado);
	}
	@Override
	public Boolean existeActivoConOfertaVivaEstadoExpediente(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL( "SELECT COUNT(*) 	"
						+	"		        FROM ACT_ACTIVO ACT 	"
						+	"			  	JOIN ACT_OFR ACTOF ON ACT.ACT_ID = ACTOF.ACT_ID 	"
						+	"			  	JOIN OFR_OFERTAS OFR ON ACTOF.OFR_ID = OFR.OFR_ID 	"
						+	"			  	JOIN DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.DD_EOF_CODIGO = '01' 	"
						+	"		        JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON OFR.OFR_ID = ECO.OFR_ID 	"
						+	"		        JOIN DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.DD_EEC_CODIGO NOT IN ('02','08','03') 	"
						+	"		        WHERE ACT.ACT_NUM_ACTIVO = :numActivo ");

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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String query = "SELECT COUNT(1) "
				+ "	  	FROM VI_OFERTAS_ACTIVOS_AGRUPACION v "
				+ " 	INNER JOIN ECO_EXPEDIENTE_COMERCIAL eco ON v.ECO_ID = eco.ECO_ID AND eco.BORRADO = 0 "
				+ " 	INNER JOIN OFR_OFERTAS ofr ON v.OFR_NUM_OFERTA = ofr.OFR_NUM_OFERTA AND ofr.BORRADO = 0 "
				+ "  	INNER JOIN ACT_TBJ_TRABAJO tbj ON eco.TBJ_ID = tbj.TBJ_ID AND tbj.BORRADO = 0 "
				+ "  	INNER JOIN ACT_TRA_TRAMITE tra ON tbj.TBJ_ID = tra.TBJ_ID AND tra.BORRADO = 0 "
				+ "  	INNER JOIN TAC_TAREAS_ACTIVOS tac ON tra.TRA_ID = tac.TRA_ID AND tac.BORRADO = 0 "
				+ "  	INNER JOIN TAR_TAREAS_NOTIFICACIONES tar ON tac.TAR_ID = TAR.TAR_ID AND tar.BORRADO = 0 "
				+ "		INNER JOIN ACT_ACTIVO act ON act.ACT_ID = v.ACT_ID AND act.BORRADO = 0 "
				+ " 	WHERE act.ACT_NUM_ACTIVO = :numActivo "
				+ "    	AND tar.TAR_FECHA_FIN IS NULL "
				+ "    	AND ofr.DD_EOF_ID <> 2 "
				+ "     FETCH FIRST 1 ROWS ONLY ";

		String resultado = rawDao.getExecuteSQL(query);

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeSociedadAcreedora(String sociedadAcreedoraNIF) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sociedadAcreedoraNIF", sociedadAcreedoraNIF);
		rawDao.addParams(params);
		
		if(Checks.esNulo(sociedadAcreedoraNIF)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PDV_PLAN_DIN_VENTAS WHERE"
				+ "		 	PDV_ACREEDOR_NIF = :sociedadAcreedoraNIF "
				+ "		 	AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existePropietario(String propietarioNIF) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("propietarioNIF", propietarioNIF);
		rawDao.addParams(params);
		
		if(Checks.esNulo(propietarioNIF)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PRO_PROPIETARIO WHERE"
				+ "		 	PRO_DOCIDENTIF = :propietarioNIF "
				+ "		 	AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeProveedorMediadorByNIF(String proveedorMediadorNIF) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("proveedorMediadorNIF", proveedorMediadorNIF);
		rawDao.addParams(params);
		
		if(Checks.esNulo(proveedorMediadorNIF)) {
			return true;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PVE_PROVEEDOR WHERE"
				+ "		 PVE_DOCIDENTIF = :proveedorMediadorNIF"
				+ " 	 AND DD_TPR_ID = (SELECT DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '04')" // Mediador-Colaborador-API.
				+ "		 AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeProveedorMediadorByNIFConFVD(String proveedorMediadorNIF) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("proveedorMediadorNIF", proveedorMediadorNIF);
		rawDao.addParams(params);
		
		if(Checks.esNulo(proveedorMediadorNIF)) {
			return true;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PVE_PROVEEDOR WHERE"
				+ "		 PVE_DOCIDENTIF =  :proveedorMediadorNIF "
				+ " 	 AND DD_TPR_ID = (SELECT DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '04')" // Mediador-Colaborador-API.
				+ " 	 OR DD_TPR_ID = (SELECT DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '18')"  // Fuerza de Venta Directa
				+ "		 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeCalifEnergeticaByDesc(String califEnergeticaDesc) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("califEnergeticaDesc", califEnergeticaDesc);
		rawDao.addParams(params);
		
		if(Checks.esNulo(califEnergeticaDesc)) {
			return true;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TCE_TIPO_CALIF_ENERGETICA WHERE"
				+ "		 DD_TCE_DESCRIPCION = :califEnergeticaDesc"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeGradoPropiedadByCod(String gradPropiedadCod) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gradPropiedadCod", gradPropiedadCod);
		rawDao.addParams(params);

		if(Checks.esNulo(gradPropiedadCod)) {
			return true;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TGP_TIPO_GRADO_PROPIEDAD WHERE"
				+ "		 DD_TGP_CODIGO =  :gradPropiedadCod"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeDestComercialByCod(String destComercialCod) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("destComercialCod", destComercialCod);
		rawDao.addParams(params);
		
		if(Checks.esNulo(destComercialCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TCO_TIPO_COMERCIALIZACION WHERE"
				+ "		 DD_TCO_CODIGO = :destComercialCod"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeTipoAlquilerByCod(String tipoAlquilerCod) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tipoAlquilerCod", tipoAlquilerCod);
		rawDao.addParams(params);
		
		if(Checks.esNulo(tipoAlquilerCod)) {
			return true;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TAL_TIPO_ALQUILER WHERE"
				+ "		 DD_TAL_CODIGO = :tipoAlquilerCod "
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeTipoViaByCod(String tipoViaCod) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tipoViaCod", tipoViaCod);
		rawDao.addParams(params);

		if(Checks.esNulo(tipoViaCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_TVI_TIPO_VIA WHERE"
				+ "		 DD_TVI_CODIGO = :tipoViaCod "
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeSubtipoTituloByCod(String subtipoTituloCod) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("subtipoTituloCod", subtipoTituloCod);
		rawDao.addParams(params);
		
		if(Checks.esNulo(subtipoTituloCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_STA_SUBTIPO_TITULO_ACTIVO WHERE"
				+ "		 DD_STA_CODIGO =  :subtipoTituloCod "
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeUsoDominanteByCod(String usoDominanteCod) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("usoDominanteCod", usoDominanteCod);
		rawDao.addParams(params);
		
		if(Checks.esNulo(usoDominanteCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TUD_TIPO_USO_DESTINO WHERE"
				+ "		 DD_TUD_CODIGO = :usoDominanteCod "
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeEstadoExpRiesgoByCod(String estadoExpRiesgoCod) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("estadoExpRiesgoCod", estadoExpRiesgoCod);
		rawDao.addParams(params);
		
		if(Checks.esNulo(estadoExpRiesgoCod)) {
			return true;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_EER_EST_EXP_RIESGO WHERE"
				+ "		 DD_EER_CODIGO =  :estadoExpRiesgoCod "
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeProvinciaByCod(String provCod) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("provCod", provCod);
		rawDao.addParams(params);
		
		if(Checks.esNulo(provCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_PRV_PROVINCIA WHERE"
				+ "		 DD_PRV_CODIGO = :provCod"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeEstadoFisicoByCod(String estFisicoCod) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("estFisicoCod", estFisicoCod);
		rawDao.addParams(params);

		if(Checks.esNulo(estFisicoCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_EAC_ESTADO_ACTIVO WHERE"
				+ "		 DD_EAC_CODIGO =  :estFisicoCod "
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeClaseActivoByDesc(String claseActivoDesc) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claseActivoDesc", claseActivoDesc);
		rawDao.addParams(params);
		
		if(Checks.esNulo(claseActivoDesc)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_CLA_CLASE_ACTIVO WHERE"
				+ "		 DD_CLA_DESCRIPCION =  :claseActivoDesc "
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean destComercialContieneAlquiler(String destComercialCod) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("destComercialCod", destComercialCod);
		rawDao.addParams(params);
		
		if(Checks.esNulo(destComercialCod)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TCO_TIPO_COMERCIALIZACION WHERE"
				+ "		 DD_TCO_CODIGO =  :destComercialCod "
				+ "		 AND LOWER(DD_TCO_DESCRIPCION) LIKE '%alquiler%'"
				+ " 	 AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	public boolean existeCarteraByCod(String codCartera){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codCartera", codCartera);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codCartera)){
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM DD_CRA_CARTERA WHERE"
				+"		DD_CRA_CODIGO =  :codCartera "
				+" 		AND BORRADO = 0");

		return !"0".equals(resultado);
	}
	
	public boolean existeSubCarteraByCod(String codSubCartera){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codSubCartera", codSubCartera);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codSubCartera)){
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM DD_SCR_SUBCARTERA WHERE"
				+"		DD_SCR_CODIGO =  :codSubCartera "
				+" 		AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	public boolean existeTipoActivoByCod(String codTipoActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codTipoActivo", codTipoActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codTipoActivo)){
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM DD_TPA_TIPO_ACTIVO WHERE"
				+"		DD_TPA_CODIGO = :codTipoActivo "
				+"		AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	public boolean existeSubtipoActivoByCod(String codSubtipoActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codSubtipoActivo", codSubtipoActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codSubtipoActivo)){
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM DD_SAC_SUBTIPO_ACTIVO WHERE"
				+"		DD_SAC_CODIGO = :codSubtipoActivo "
				+"		AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	public boolean existeGestorComercialByUsername(String gestorUsername){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gestorUsername", gestorUsername);
		rawDao.addParams(params);
		
		if(Checks.esNulo(gestorUsername)){
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+"	FROM ZON_PEF_USU WHERE"
				+" 	USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = :gestorUsername )"
				+"  AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'HAYAGESTCOM')");

		return !"0".equals(resultado);
	}

	public boolean existeSupervisorComercialByUsername(String supervisorUsername){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("supervisorUsername", supervisorUsername);
		rawDao.addParams(params);
		
		if(Checks.esNulo(supervisorUsername)){
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+"	FROM ZON_PEF_USU WHERE"
				+"	USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = :supervisorUsername)"
				+"	AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'HAYASUPCOM')");

		return !"0".equals(resultado);
	}

	public boolean existeGestorFormalizacionByUsername(String gestorUsername){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gestorUsername", gestorUsername);
		rawDao.addParams(params);
		
		if(Checks.esNulo(gestorUsername)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = :gestorUsername)"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'HAYAGESTFORM')");

		return !"0".equals(resultado);
	}

	public boolean existeSupervisorFormalizacionByUsername(String supervisorUsername){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("supervisorUsername", supervisorUsername);
		rawDao.addParams(params);
		
		if(Checks.esNulo(supervisorUsername)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = :supervisorUsername)"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'HAYASUPFORM')");

		return !"0".equals(resultado);
	}

	public boolean existeGestorAdmisionByUsername(String gestorUsername){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gestorUsername", gestorUsername);
		rawDao.addParams(params);
		
		if(Checks.esNulo(gestorUsername)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = :gestorUsername )"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'HAYAGESTADM')");

		return !"0".equals(resultado);
	}

	public boolean existeGestorActivosByUsername(String gestorUsername){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gestorUsername", gestorUsername);
		rawDao.addParams(params);
		
		if(Checks.esNulo(gestorUsername)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = :gestorUsername)"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'HAYAGESACT')");

		return !"0".equals(resultado);

	}

	public boolean existeGestoriaDeFormalizacionByUsername(String username){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("username", username);
		rawDao.addParams(params);
		
		if(Checks.esNulo(username)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = :username)"
				+" AND PEF_ID = (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = 'GESTIAFORM')");

		return !"0".equals(resultado);
	}
	
	public boolean esGestoriaDeFormalizacionCorrecta(String username){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("username", username);
		rawDao.addParams(params);
		
		if(Checks.esNulo(username)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM USD_USUARIOS_DESPACHOS USD"
				+ "			JOIN DES_DESPACHO_EXTERNO DES ON USD.DES_ID = DES.DES_ID"
				+ "			JOIN ${master.schema}.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID"
				+ "			WHERE USU.USU_USERNAME = :username AND DES.DES_DESPACHO = 'GESTORIAFORM' AND USD.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeProvinciaByCodigo(String codigoProvincia) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoProvincia", codigoProvincia);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codigoProvincia)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_PRV_PROVINCIA WHERE"
				+ "		 DD_PRV_CODIGO = :codigoProvincia "
				+ "		 AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeMunicipioByCodigo(String codigoMunicipio) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoMunicipio", codigoMunicipio);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codigoMunicipio)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_LOC_LOCALIDAD WHERE"
				+ "		 DD_LOC_CODIGO = :codigoMunicipio ");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeMunicipioDeProvinciaByCodigo(String codProvincia, String codigoMunicipio) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codProvincia", codProvincia);
		params.put("codigoMunicipio", codigoMunicipio);
		rawDao.addParams(params);
		
		if(codigoMunicipio == null || codProvincia == null) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_LOC_LOCALIDAD LOC"
				+ "		 INNER JOIN ${master.schema}.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID"
				+ "		 WHERE PRV.DD_PRV_CODIGO = :codProvincia AND"
				+ "		 LOC.DD_LOC_CODIGO = :codigoMunicipio");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeUnidadInferiorMunicipioByCodigo(String codigoUnidadInferiorMunicipio) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoUnidadInferiorMunicipio", codigoUnidadInferiorMunicipio);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codigoUnidadInferiorMunicipio)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_UPO_UNID_POBLACIONAL WHERE"
				+ "		 DD_UPO_CODIGO =  :codigoUnidadInferiorMunicipio"
				+ "		 AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeGasto(String numGasto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR WHERE"
				+ "		 	GPV_NUM_GASTO_HAYA = :numGasto "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean gastoTieneLineaDetalle(String numGasto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM gld_gastos_linea_detalle "
				+ "where BORRADO = 0 AND  gpv_id = (SELECT gpv_id FROM "
				+ "gpv_gastos_proveedor where "
				+ "gpv_num_gasto_haya = :numGasto )");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean subtipoGastoCorrespondeGasto(String numGasto,String subtipoGasto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		params.put("subtipoGasto", subtipoGasto);
		rawDao.addParams(params);

		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto) || Checks.esNulo(subtipoGasto) || !StringUtils.isNumeric(subtipoGasto))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM gpv_gastos_proveedor "
				+" where gpv_num_gasto_haya = :numGasto and "
				+" dd_tga_id = (select dd_tga_id from dd_stg_subtipos_gasto where dd_stg_codigo = :subtipoGasto)");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean lineaSubtipoDeGastoRepetida(String numGasto,String subtipoGasto, String tipoImpositivo, String tipoImpuesto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		params.put("subtipoGasto", subtipoGasto);
		
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto) || Checks.esNulo(subtipoGasto))
			return false;
		String query = "SELECT COUNT(*) FROM gld_gastos_linea_detalle where " + 
				"gpv_id in (select gpv_id from gpv_gastos_proveedor where gpv_num_gasto_haya = :numGasto  and borrado = 0) and " +
				"DD_STG_ID in (select dd_stg_id from dd_stg_subtipos_gasto where dd_stg_codigo like :subtipoGasto  and borrado = 0)  and " +
				"BORRADO = 0 and ";
				if(Checks.esNulo(tipoImpositivo)) {
					query = query + "GLD_IMP_IND_TIPO_IMPOSITIVO is null and ";
				}else {
					params.put("tipoImpositivo", tipoImpositivo);
					query = query + "GLD_IMP_IND_TIPO_IMPOSITIVO = :tipoImpositivo and ";
				}
				if(Checks.esNulo(tipoImpuesto)) {					
					query = query + "dd_tit_id is null";
				}else {
					params.put("tipoImpuesto", tipoImpuesto);
					query = query + "dd_tit_id in (select dd_tit_id from dd_tit_tipos_impuesto where dd_tit_codigo = :tipoImpuesto and borrado = 0) ";
				}
				
		rawDao.addParams(params);		
		
		String resultado = rawDao.getExecuteSQL(query);
				
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esGastoDeLiberbank(String numGasto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR GPV "
				+ "      JOIN ACT_PRO_PROPIETARIO PRO ON GPV.PRO_ID = PRO.PRO_ID "
				+ "      JOIN DD_CRA_CARTERA CRA ON PRO.DD_CRA_ID = CRA.DD_CRA_ID "
				+ "		 WHERE GPV.GPV_NUM_GASTO_HAYA = :numGasto  "
				+ "         AND CRA.DD_CRA_CODIGO = '08' "
				+ "		 	AND GPV.BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean tienenRelacionActivoGasto(String numActivo, String numGasto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto) || Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM GLD_ENT ENT"
				+ " INNER JOIN GLD_TBJ TBJ ON TBJ.GLD_ID = ENT.GLD_ID"
				+ "	INNER JOIN GLD_GASTOS_LINEA_DETALLE GLD ON TBJ.GLD_ID = GLD.GLD_ID"
				+ "	WHERE GLD.GPV_ID = (SELECT GPV_ID FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = :numGasto)"
				+ " AND ENT.ENT_ID = (SELECT DD_ENT_ID FROM DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO ='ACT')"
				+ "	AND ENT.DD_ENT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = :numActivo)");
		return !"0".equals(resultado);
	}

	@Override
	public List<Long> getRelacionGastoActivo(String numGasto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return new ArrayList<Long>();
		List<Object> listaObj = rawDao.getExecuteSQLList("SELECT DISTINCT ACT.ACT_NUM_ACTIVO FROM ACT_ACTIVO ACT "
				+ "INNER JOIN GLD_ENT ENT ON ENT.ENT_ID = ACT.ACT_ID AND ENT.DD_ENT_ID = (SELECT DD_ENT_ID FROM DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO ='ACT') "
				+ "INNER JOIN GLD_TBJ TBJ ON TBJ.GLD_ID = ENT.GLD_ID "
				+ "INNER JOIN GLD_GASTOS_LINEA_DETALLE GLD ON TBJ.GLD_ID = GLD.GLD_ID "
				+ "INNER JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GLD.GPV_ID "
				+ "WHERE GPV.GPV_NUM_GASTO_HAYA = :numGasto ");
		List<Long> listaNumActivos = new ArrayList<Long>();
		for(Object o: listaObj){
			String objetoString = o.toString();
			listaNumActivos.add(Long.parseLong(objetoString));
		}
		return listaNumActivos;
	}

	@Override
	public Boolean propietarioGastoConDocumento(String numGasto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR gpv "
				+ "			INNER JOIN ACT_PRO_PROPIETARIO act_pro ON gpv.PRO_ID = act_pro.PRO_ID "
				+ "			WHERE act_pro.DD_TDI_ID IS NOT NULL "
				+ "			AND act_pro.PRO_DOCIDENTIF IS NOT NULL "
				+ "		 	AND gpv.GPV_NUM_GASTO_HAYA = :numGasto "
				+ "		 	AND gpv.BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean propietarioGastoIgualActivo(String numActivo, String numGasto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultadoGasto = rawDao.getExecuteSQL("SELECT actpro.PRO_DOCIDENTIF "
				+ "		 FROM GPV_GASTOS_PROVEEDOR gpv "
				+ "			INNER JOIN ACT_PRO_PROPIETARIO actpro on gpv.PRO_ID = actpro.PRO_ID "
				+ "		 	where gpv.GPV_NUM_GASTO_HAYA = :numGasto "
				+ "		 	AND actpro.BORRADO = 0");
		
		params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		String resultadoActivo = rawDao.getExecuteSQL("SELECT actpro.PRO_DOCIDENTIF "
				+ "		 FROM ACT_PAC_PROPIETARIO_ACTIVO actpac "
				+ "			INNER JOIN ACT_PRO_PROPIETARIO actpro on actpac.PRO_ID = actpro.PRO_ID "
				+ "			INNER JOIN ACT_ACTIVO act on actpac.ACT_ID = act.ACT_ID "
				+ "		 	where act.ACT_NUM_ACTIVO = :numActivo "
				+ "		 	AND actpro.BORRADO = 0 ORDER BY actpac.PAC_PORC_PROPIEDAD");


		return Checks.esNulo(resultadoGasto) || Checks.esNulo(resultadoActivo) || resultadoGasto.equals(resultadoActivo);
	}


	@Override
	public Boolean activoNoAsignado(String numActivo, String numGasto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if((Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) || (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto)))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "	FROM gld_ent ent"
				+ "	INNER JOIN gld_tbj tbj ON tbj.gld_id = ent.gld_id"
				+ "	INNER JOIN gld_gastos_linea_detalle gld ON tbj.gld_id = gld.gld_id"
				+ " INNER JOIN gpv_gastos_proveedor gpv ON gld.gpv_id = gpv.gpv_id"
				+ " INNER JOIN act_activo act ON ent.ent_id = act.act_id"
				+ "	WHERE gpv.GPV_NUM_GASTO_HAYA = :numGasto "
				+ "	AND act.ACT_NUM_ACTIVO = :numActivo "
				+ " AND ENT.DD_ENT_ID = (SELECT DD_ENT_ID FROM DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO ='ACT')"
				+ "	AND gpv.BORRADO = 0 AND act.BORRADO = 0");
		return "0".equals(resultado);
	}

	@Override
	public Boolean isGastoNoAutorizado(String numGasto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR gpv "
				+ "			INNER JOIN GGE_GASTOS_GESTION gge on gpv.GPV_ID = gge.GPV_ID "
				+ "			INNER JOIN DD_EAH_ESTADOS_AUTORIZ_HAYA eah on gge.DD_EAH_ID = eah.DD_EAH_ID "
				+ "			WHERE gpv.GPV_NUM_GASTO_HAYA = :numGasto "
				+ "		 	AND eah.DD_EAH_CODIGO =" +"03"+ " AND gpv.BORRADO = 0");
		return "0".equals(resultado);
	}

	@Override
	public Boolean isGastoNoAsociadoTrabajo(String numGasto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR gpv "
				+ "		 INNER JOIN GLD_GASTOS_LINEA_DETALLE GLD ON GPV.GPV_ID = GLD.GPV_ID	"
				+ "		 INNER JOIN GLD_TBJ TBJ ON TBJ.GLD_ID = GLD.GLD_ID	"
				+ "			WHERE gpv.GPV_NUM_GASTO_HAYA = :numGasto "
				+ "		 	AND gpv.BORRADO = 0 and TBJ.BORRADO = 0");
		return "0".equals(resultado);
	}

	@Override
	public Boolean isGastoPermiteAnyadirActivo(String numGasto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM GPV_GASTOS_PROVEEDOR gpv "
				+ "			INNER JOIN DD_EGA_ESTADOS_GASTO ega on gpv.DD_EGA_ID = ega.DD_EGA_ID "
				+ "			WHERE gpv.GPV_NUM_GASTO_HAYA =:numGasto "
				+ "		 	AND ega.DD_EGA_CODIGO IN (01,02,07,08,10,11,12) AND gpv.BORRADO = 0");
		return "0".equals(resultado);
	}

	@Override
	public Boolean existeExpedienteComercial(String numExpediente){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente) || !StringUtils.isNumeric(numExpediente))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ECO_EXPEDIENTE_COMERCIAL WHERE"
				+ "		 	ECO_NUM_EXPEDIENTE = :numExpediente "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeAgrupacion(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_AGR_AGRUPACION "
				+ "		 WHERE AGR_NUM_AGRUP_REM = :numAgrupacion "
				+ "      AND BORRADO = 0");
				//+ "      AND DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = '16')");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean agrupacionActiva(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_AGR_AGRUPACION "
				+ "		 WHERE AGR_NUM_AGRUP_REM = :numAgrupacion"
				+ "      AND AGR_FECHA_BAJA IS NULL");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeAgrupacionPA(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_AGR_AGRUPACION "
				+ "		 WHERE AGR_NUM_AGRUP_REM =  :numAgrupacion "
				+ "      AND DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = '16')");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeTipoGestor(String codigoTipoGestor){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoTipoGestor", codigoTipoGestor);
		rawDao.addParams(params);

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.DD_TGE_TIPO_GESTOR WHERE"
				+ "		 DD_TGE_CODIGO = :codigoTipoGestor ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeUsuario(String username){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("username", username);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ${master.schema}.USU_USUARIOS WHERE"
				+ "		 USU_USERNAME =  :username  AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean usuarioEsTipoGestor(String username, String codigoTipoGestor){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("username", username);
		params.put("codigoTipoGestor", codigoTipoGestor);
		rawDao.addParams(params);
		
		if(Checks.esNulo(username) || Checks.esNulo(codigoTipoGestor))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM TGP_TIPO_GESTOR_PROPIEDAD tgp "
				+ "			INNER JOIN REMMASTER.DD_TDE_TIPO_DESPACHO tde on tgp.TGP_VALOR = tde.DD_TDE_CODIGO "
				+ "			INNER JOIN REMMASTER.DD_TGE_TIPO_GESTOR tge on tde.DD_TDE_CODIGO = tge.DD_TGE_CODIGO "
				+ "			INNER JOIN DES_DESPACHO_EXTERNO des on tde.DD_TDE_ID = des.DD_TDE_ID "
				+ "			INNER JOIN USD_USUARIOS_DESPACHOS usd on usd.DES_ID = des.DES_ID "
				+ "			INNER JOIN REMMASTER.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID "
				+ "			WHERE tge.DD_TGE_CODIGO = :codigoTipoGestor AND usu.USU_USERNAME = :username");
		return !"0".equals(resultado);


	}

	@Override
	public Boolean combinacionGestorCarteraAcagexValida(String codigoGestor, String numActivo, String numAgrupacion,String numExpediente){
		String resultado= "0";
		String cartera=null;
		String query;
		Map<String, Object> params = new HashMap<String, Object>();


		if(!Checks.esNulo(numActivo)){
			params.put("numActivo", numActivo);
			rawDao.addParams(params);
			query= "SELECT DISTINCT(ACT.DD_CRA_ID) "
				+ "		 FROM ACT_ACTIVO act ";
			query= query.concat(" WHERE act.ACT_NUM_ACTIVO = :numActivo ");
			cartera= rawDao.getExecuteSQL(query);
		}
		else if(!Checks.esNulo(numAgrupacion)){
			params.put("numAgrupacion", numAgrupacion);
			rawDao.addParams(params);
			cartera= rawDao.getExecuteSQL("SELECT DISTINCT(act.DD_CRA_ID) "
					+ "		 FROM ACT_AGR_AGRUPACION AGR "
					+ "		 INNER JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID "
					+ "		 INNER JOIN ACT_ACTIVO ACT ON AGA.ACT_ID = ACT.ACT_ID "
					+ "		 WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion ");
		}

		else if(!Checks.esNulo(numExpediente)){
			params.put("numExpediente", numExpediente);
			rawDao.addParams(params);
			cartera= rawDao.getExecuteSQL("SELECT DISTINCT(act.DD_CRA_ID) "
					+ "		 FROM ECO_EXPEDIENTE_COMERCIAL eco "
					+ "			INNER JOIN OFR_OFERTAS ofr on eco.OFR_ID = ofr.OFR_ID "
					+ "			INNER JOIN ACT_OFR actofr on ofr.OFR_ID = actofr.OFR_ID "
					+ "			INNER JOIN ACT_ACTIVO act on actofr.ACT_ID = act.ACT_ID "
					+ " 		WHERE eco.ECO_NUM_EXPEDIENTE=  :numExpediente ");
		}


		if(!Checks.esNulo(cartera)){
			params = new HashMap<String, Object>();
			params.put("codigoGestor", codigoGestor);
			params.put("cartera", cartera);
			rawDao.addParams(params);
			query= ("SELECT COUNT(*) "
					+ "		 FROM DD_GCM_GESTOR_CARGA_MASIVA gcm "
					+ "			INNER JOIN ${master.schema}.DD_TGE_TIPO_GESTOR tge on gcm.DD_GCM_CODIGO = tge.DD_TGE_CODIGO "
					+ "			INNER JOIN DD_CRA_CARTERA cra on gcm.DD_CRA_ID = cra.DD_CRA_ID "
					+ "			WHERE gcm.DD_GCM_CODIGO = :codigoGestor "
					+ "		 	AND cra.DD_CRA_ID = :cartera "
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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		if(Checks.esNulo(numActivo) || Checks.esNulo(numGasto))
			return false;

		else {
			enAgrupacion = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT "
						+ "						JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID "
						+ "						WHERE ACT_NUM_ACTIVO = :numActivo");
		}
		
		params.put("numGasto", numGasto);
		rawDao.addParams(params);

		//El activo NO pertenece a una agrupacion
		if("0".equals(enAgrupacion)){

			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM GPV_GASTOS_PROVEEDOR GPV "
							+ "						JOIN ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = :numActivo "
							+ "						WHERE GPV.GPV_NUM_GASTO_HAYA = :numGasto "
							+ "						AND GPV.GPV_FECHA_EMISION < ACT.ACT_VENTA_EXTERNA_FECHA "
							+ "						AND ACT.DD_SCR_ID IN (SELECT DD_SCR_ID FROM DD_SCR_SUBCARTERA WHERE "
							+ "							DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA WHERE DD_CRA_CODIGO = 3)"
							+ "							AND DD_SCR_CODIGO IN (14, 15, 19) ) ");

		}
		//El activo pertenece a una agrupacion
		else {

			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM GPV_GASTOS_PROVEEDOR GPV "
							+ "						JOIN ACT_ACTIVO ACT ON ACT_NUM_ACTIVO = :numActivo "
							+ "						JOIN ACT_AGA_AGRUPACION_ACTIVO ACT_AGA ON ACT_AGA.ACT_ID = ACT.ACT_ID "
							+ "						JOIN OFR_OFERTAS OFR ON OFR.AGR_ID = ACT_AGA.AGR_ID "
							+ "						JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID "
							+ "						WHERE GPV.GPV_NUM_GASTO_HAYA = :numGasto "
							+ "						AND GPV.GPV_FECHA_EMISION < ECO.ECO_FECHA_VENTA "
							+ "						AND ACT.DD_SCR_ID IN (SELECT DD_SCR_ID FROM DD_SCR_SUBCARTERA WHERE "
							+ "							DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA WHERE DD_CRA_CODIGO = 3)"
							+ "							AND DD_SCR_CODIGO IN (14, 15, 19) ) ");

		}

		return !"0".equals(resultado);


	}

	@Override
	public Boolean distintosTiposImpuesto(String numActivo, String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		Boolean agrCanarias = false;
		Boolean actCanarias = false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_AGR_AGRUPACION AGR " +
				"JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " +
				"JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID " +
				"JOIN BIE_BIEN BIE ON BIE.BIE_ID = ACT.BIE_ID " +
				"JOIN BIE_LOCALIZACION LOC ON LOC.BIE_ID = BIE.BIE_ID " +
				"JOIN REMMASTER.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID AND DD_PRV_CODIGO IN ('35', '38') " +
				"WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion ");

		if(Integer.valueOf(resultado) > 0) agrCanarias = true;
		params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT " +
				"JOIN BIE_BIEN BIE ON BIE.BIE_ID = ACT.BIE_ID " +
				"JOIN BIE_LOCALIZACION LOC ON LOC.BIE_ID = BIE.BIE_ID " +
				"JOIN REMMASTER.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID AND DD_PRV_CODIGO IN ('35', '38') " +
				"WHERE ACT.ACT_NUM_ACTIVO = :numActivo ");

		if(Integer.valueOf(resultado) > 0) actCanarias = true;


		return actCanarias != agrCanarias;

	}

	@Override
	public boolean comprobarDistintoPropietario(String numActivo, String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		String agrPro;
		String actPro;

		agrPro = rawDao.getExecuteSQL("SELECT PRO_ID FROM ACT_PAC_PROPIETARIO_ACTIVO PAC " +
				"JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID " +
				"JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = PAC.ACT_ID " +
				"JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID " +
				"WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion AND PAC.ACT_ID = AGR.AGR_ACT_PRINCIPAL");

		if(Checks.esNulo(agrPro)) {
			rawDao.addParams(params);
			agrPro = rawDao.getExecuteSQL("SELECT PRO_ID FROM ACT_PAC_PROPIETARIO_ACTIVO PAC " +
					"JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID " +
					"JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = PAC.ACT_ID " +
					"JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID " +
					"WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion AND ROWNUM = 1");
		}
		
		params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		actPro = rawDao.getExecuteSQL("SELECT PRO_ID FROM ACT_PAC_PROPIETARIO_ACTIVO PAC " +
				"JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID AND ACT_NUM_ACTIVO = :numActivo");

		if(Checks.esNulo(agrPro)) return false;


		return !actPro.equals(agrPro);
	}

	@Override
	public boolean comprobarDistintoPropietarioListaActivos(String[] activos) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activos", activos[0]);
		rawDao.addParams(params);
		
		String actPro = rawDao.getExecuteSQL("SELECT PRO_ID FROM ACT_PAC_PROPIETARIO_ACTIVO PAC "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID AND ACT_NUM_ACTIVO = :activos ");

		for (int i = 1; i < activos.length; i++) {
			params = new HashMap<String, Object>();
			params.put("activos", activos[i]);
			rawDao.addParams(params);
			String actAComparar = rawDao.getExecuteSQL("SELECT PRO_ID FROM ACT_PAC_PROPIETARIO_ACTIVO PAC "
					+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID AND ACT_NUM_ACTIVO = :activos ");
			if (!actPro.equals(actAComparar)) return true;
		}

		return false;
	}

	@Override
	public boolean activoConOfertasTramitadas(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		String actofr = rawDao.getExecuteSQL("    SELECT COUNT(aof1.act_id) "
				+ "    FROM OFR_OFERTAS ofr1 "
				+ "    INNER JOIN ACT_OFR aof1 on ofr1.ofr_id = aof1.ofr_id "
				+ "    INNER JOIN ACT_ACTIVO act1 on aof1.act_id = act1.act_id "
				+ "    INNER JOIN DD_EOF_ESTADOS_OFERTA eof1 on ofr1.dd_eof_id = eof1.dd_eof_id "
				+ "    WHERE "
				+ "      eof1.dd_eof_codigo = '01' "
				+ "      AND act1.act_num_activo = :numActivo "
				+ "      AND ofr1.borrado = 0 ");

		return actofr.equals("0");
	}

	@Override
	public boolean isMismoTipoComercializacionActivoPrincipalAgrupacion(String numActivo, String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);

		String activoTCO = rawDao.getExecuteSQL("SELECT COUNT(1) "
		        + "        FROM ACT_APU_ACTIVO_PUBLICACION APU "
				+ "        JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = APU.ACT_ID "
		        + "        WHERE ACT.ACT_NUM_ACTIVO = :numActivo AND APU.DD_TCO_ID = (SELECT APU.DD_TCO_ID "
				+ "                                   FROM ACT_APU_ACTIVO_PUBLICACION APU "
		        + "                                   JOIN ACT_ACTIVO ACT ON APU.ACT_ID = ACT.ACT_ID "
				+ "                                   JOIN ACT_AGR_AGRUPACION AGR ON ACT.ACT_ID = AGR.AGR_ACT_PRINCIPAL "
		        + "                                   AND AGR.AGR_NUM_AGRUP_REM = :numAgrupacion)");

		return activoTCO.equals("1");
	}

	@Override
	public boolean isMismoTipoComercializacionActivoPrincipalExcel(String numActivo, String numActivoPrincipalExcel) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("numActivoPrincipalExcel", numActivoPrincipalExcel);
		rawDao.addParams(params);
		
		String activoTCO = rawDao.getExecuteSQL("SELECT COUNT(1) "
		        + "        FROM ACT_APU_ACTIVO_PUBLICACION APU "
				+ "        JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = APU.ACT_ID "
		        + "        WHERE ACT.ACT_NUM_ACTIVO = :numActivo  AND APU.DD_TCO_ID = (SELECT APU.DD_TCO_ID "
				+ "                                   FROM ACT_APU_ACTIVO_PUBLICACION APU "
		        + "                                   JOIN ACT_ACTIVO ACT ON APU.ACT_ID = ACT.ACT_ID "
		        + "                                   AND ACT.ACT_NUM_ACTIVO_REM = :numActivoPrincipalExcel)");

		return activoTCO.equals("1");
	}

	@Override
	public boolean isMismoEpuActivoPrincipalAgrupacion(String numActivo, String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		String activoEPU = rawDao.getExecuteSQL("SELECT COUNT(1) "
		        + "        FROM ACT_ACTIVO ACT "
				+ "        JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+ "        WHERE ACT.ACT_NUM_ACTIVO = :numActivo "
				+ "        AND (CASE"
		        + "        		WHEN APU.DD_TCO_ID IN (SELECT DD_TCO_ID FROM DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO IN ('01', '02')) THEN"
				+ "             	CASE WHEN APU.DD_EPV_ID = ("
				+ "                 	SELECT APU.DD_EPV_ID"
				+ "						FROM ACT_APU_ACTIVO_PUBLICACION APU"
				+ "						JOIN ACT_ACTIVO ACT ON APU.ACT_ID = ACT.ACT_ID"
				+ "            			JOIN ACT_AGR_AGRUPACION AGR ON ACT.ACT_ID = AGR.AGR_ACT_PRINCIPAL"
				+ "            			AND AGR.AGR_NUM_AGRUP_REM = :numAgrupacion ) THEN 1"
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
				+ "            			AND AGR.AGR_NUM_AGRUP_REM = :numAgrupacion ) THEN 1"
				+ "        			ELSE 0"
				+ "        			END"
				+ "    	   		ELSE 1"
				+ "    	   		END = 1)"
		);

		return activoEPU.equals("1");
	}
	
	@Override
	public boolean isMismoTcoActivoPrincipalAgrupacion(String numActivo, String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		String activoTCO = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT "
				+"					JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+"					WHERE ACT.ACT_NUM_ACTIVO = :numActivo"
				+"					AND APU.DD_TCO_ID = (SELECT APU.DD_TCO_ID FROM ACT_APU_ACTIVO_PUBLICACION APU" 
				+"					JOIN ACT_ACTIVO ACT ON APU.ACT_ID = ACT.ACT_ID" 
				+"	       			JOIN ACT_AGR_AGRUPACION AGR ON ACT.ACT_ID = AGR.AGR_ACT_PRINCIPAL" 
				+"	       			AND AGR.AGR_NUM_AGRUP_REM = :numAgrupacion )"
		);

		return activoTCO.equals("1");
	}

	@Override
	public boolean isMismoEpuActivoPrincipalExcel(String numActivo, String numActivoPrincipalExcel) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("numActivoPrincipalExcel", numActivoPrincipalExcel);
		rawDao.addParams(params);
		
		String activoEPU = rawDao.getExecuteSQL("SELECT COUNT(1) "
		        + "        FROM ACT_ACTIVO ACT "
				+ "        JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
				+ "        WHERE ACT.ACT_NUM_ACTIVO = :numActivo "
		        + "		   AND (CASE"
		        + "       		WHEN APU.DD_TCO_ID IN (SELECT DD_TCO_ID FROM DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO IN ('01', '02')) THEN"
		        + "             	CASE WHEN APU.DD_EPV_ID = ("
		        + "						SELECT APU.DD_EPV_ID"
				+ "                     FROM ACT_APU_ACTIVO_PUBLICACION APU"
		        + "                     JOIN ACT_ACTIVO ACT ON APU.ACT_ID = ACT.ACT_ID"
				+ "                     AND ACT.ACT_NUM_ACTIVO = :numActivoPrincipalExcel ) THEN 1"
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
				+ "                     AND ACT.ACT_NUM_ACTIVO = :numActivoPrincipalExcel) THEN 1"
				+ "        			ELSE 0"
				+ "        			END"
				+ "    	   		ELSE 1"
				+ "    	   		END = 1)"
		);

		return activoEPU.equals("1");
	}

	public String idAgrupacionDelActivoPrincipal(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		return rawDao.getExecuteSQL("SELECT AGA.AGR_ID"
				+ "		  FROM ACT_ACTIVO ACT"
				+ "		  JOIN  ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0"
				+ "       JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID"
				+"        LEFT JOIN DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID"	
				+ " 	  WHERE ACT.ACT_NUM_ACTIVO = :numActivo  "
				+ "       AND TAG.DD_TAG_CODIGO = '02'"
				+ "       AND AGR_FECHA_BAJA IS NULL");
	}

	@Override
	public Boolean esActivoVendidoAgrupacion(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM  ACT_ACTIVO ACT"
				+ "			JOIN  ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0"
				+ "			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0"
				+ "			JOIN  DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.BORRADO = 0  AND SCM.DD_SCM_CODIGO IN ('05')"
				+ "			AND   AGR.AGR_ID =  :numAgrupacion ");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esPerfilErroneo(String codPerfil, String codUsuario){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codPerfil", codPerfil);
		params.put("codUsuario", codUsuario);
		rawDao.addParams(params);
		
	    if(Checks.esNulo(codPerfil) || Checks.esNulo(codUsuario))
	        return false;
	    
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
	            +"         FROM REMMASTER.USU_USUARIOS U"  
	            +"         JOIN ZON_PEF_USU Z ON Z.USU_ID =  U.USU_ID" 
	            +"         JOIN PEF_PERFILES P ON P.PEF_ID = Z.PEF_ID"  
	            +"         WHERE LOWER(P.PEF_CODIGO) = LOWER(:codPerfil)"  
	            +"         AND LOWER(U.USU_USERNAME) = LOWER(:codUsuario)"
	            +"         AND P.BORRADO = 0 AND U.BORRADO = 0");
	    
        return "0".equals(resultado);
    }
	@Override
	public Boolean isActivoNoComercializableAgrupacion(String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM  ACT_ACTIVO ACT "
				+ "			JOIN  ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0 "
				+ "			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
				+ "			JOIN  DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.BORRADO = 0 AND SCM.DD_SCM_CODIGO IN ('01')"
				+ "			AND   AGR.AGR_ID = :numAgrupacion ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoNoPublicableAgrupacion(String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "    		FROM  ACT_ACTIVO ACT"
				+ "			JOIN  ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0"
				+ "			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0"
				+ "			JOIN  ACT_PAC_PERIMETRO_ACTIVO PAC ON ACT.ACT_ID = PAC.ACT_ID AND PAC.BORRADO = 0 AND PAC.PAC_CHECK_PUBLICAR <> 1"
				+ "			AND   AGR.AGR_ID = :numAgrupacion ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoDestinoComercialNoVentaAgrupacion(String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO ACT"
				+ "			JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID AND APU.BORRADO = 0"
				+ "			JOIN  ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0"
				+ "			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0"
				+ "			JOIN  DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID AND TCO.BORRADO = 0 AND TCO.DD_TCO_CODIGO NOT IN ('01', '02')"
				+ "			AND   AGR.AGR_ID = :numAgrupacion ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoSinPrecioVentaWebAgrupacion(String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT NUM_ACT - NUM_VAL "
				+ "         FROM ( "
				+ "         	SELECT COUNT(DISTINCT AGA.ACT_ID) NUM_ACT"
				+ "				FROM  ACT_AGA_AGRUPACION_ACTIVO AGA"
				+ " 			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0"
				+ "				AND   AGR.AGR_ID = :numAgrupacion  "
				+ "         	WHERE AGA.BORRADO = 0),"
				+ " 				(SELECT COUNT(DISTINCT AGA.ACT_ID) NUM_VAL"
				+ "					FROM  ACT_AGA_AGRUPACION_ACTIVO AGA "
				+ "					JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
				+ "					JOIN  ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = AGA.ACT_ID AND VAL.BORRADO = 0"
				+ "					JOIN  DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.BORRADO = 0 AND TPC.DD_TPC_CODIGO = '02'"
				+ " 				AND   AGR.AGR_ID = :numAgrupacion  "
				+ " 				WHERE AGA.BORRADO = 0)");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoSinInformeAprobadoAgrupacion(String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT (1) "
				+ "			FROM ACT_ACTIVO ACT "
				+ "			JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0 "
				+ "         JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
				+ "			JOIN V_COND_DISPONIBILIDAD COND ON COND.ACT_ID = ACT.ACT_ID AND COND.SIN_INFORME_APROBADO = 1 "
				+ "			AND  AGR.AGR_ID = :numAgrupacion ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoDestinoComercialNoAlquilerAgrupacion(String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO ACT"
				+ "			JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID AND APU.BORRADO = 0 "
				+ "			JOIN  ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0"
				+ "			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0"
				+ "			JOIN  DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID AND TCO.BORRADO = 0 AND TCO.DD_TCO_CODIGO NOT IN ('02', '03')"
				+ "			AND   AGR.AGR_ID = :numAgrupacion ");
		return !"0".equals(resultado);
	}

	public Boolean activosNoOcultosVentaAgrupacion(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numAgrupacion)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO ACT "
				+ "			JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0 "
				+ "			JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
				+ "         WHERE ACT.ACT_ID NOT IN ( "
				+ "         	SELECT APU.ACT_ID FROM ACT_APU_ACTIVO_PUBLICACION APU WHERE APU.APU_CHECK_OCULTAR_V = 1 AND APU.BORRADO = 0) "
				+ "			AND AGR.AGR_ID = :numAgrupacion ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean activosNoOcultosAlquilerAgrupacion(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numAgrupacion)) return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM ACT_ACTIVO ACT "
				+ "			JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0 "
				+ "			JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
				+ "         WHERE ACT.ACT_ID NOT IN ( "
				+ "         	SELECT APU.ACT_ID FROM ACT_APU_ACTIVO_PUBLICACION APU WHERE APU.APU_CHECK_OCULTAR_A = 1 AND APU.BORRADO = 0) "
				+ "			AND AGR.AGR_ID = :numAgrupacion ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoSinPrecioRentaWebAgrupacion(String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT NUM_ACT - NUM_VAL "
				+ "         FROM ( "
				+ "         	SELECT COUNT(DISTINCT AGA.ACT_ID) NUM_ACT"
				+ "				FROM  ACT_AGA_AGRUPACION_ACTIVO AGA"
				+ " 			JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0"
				+ "				AND   AGR.AGR_ID = :numAgrupacion "
				+ "         	WHERE AGA.BORRADO = 0),"
				+ " 				(SELECT COUNT(DISTINCT AGA.ACT_ID) NUM_VAL"
				+ "					FROM  ACT_AGA_AGRUPACION_ACTIVO AGA "
				+ "					JOIN  ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
				+ "					JOIN  ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = AGA.ACT_ID AND VAL.BORRADO = 0"
				+ "					JOIN  DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.BORRADO = 0 AND TPC.DD_TPC_CODIGO = '03'"
				+ " 				AND   AGR.AGR_ID = :numAgrupacion "
				+ " 				WHERE AGA.BORRADO = 0)");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoOcultoVenta(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo)){
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_EPV_ESTADO_PUB_VENTA EPV"
				+ "   		WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_EPV_ID = EPV.DD_EPV_ID"
				+ "			AND EPV.DD_EPV_CODIGO = '04'"
				+ "         AND ACT.ACT_NUM_ACTIVO = :numActivo  ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoNoPublicadoVenta(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_EPV_ESTADO_PUB_VENTA EPV"
				+ "   		WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_EPV_ID = EPV.DD_EPV_ID"
				+ "			AND EPV.DD_EPV_CODIGO = '01'"
				+ "         AND ACT.ACT_NUM_ACTIVO = :numActivo ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoOcultoAlquiler(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_EPA_ESTADO_PUB_ALQUILER EPA"
				+ "   		WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_EPA_ID = EPA.DD_EPA_ID"
				+ "			AND EPA.DD_EPA_CODIGO = '04'"
				+ "         AND ACT.ACT_NUM_ACTIVO = :numActivo ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoNoPublicadoAlquiler(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_EPA_ESTADO_PUB_ALQUILER EPA"
				+ "   		WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_EPA_ID = EPA.DD_EPA_ID"
				+ "			AND EPA.DD_EPA_CODIGO = '01'"
				+ "         AND ACT.ACT_NUM_ACTIVO = :numActivo ");

		return !"0".equals(resultado);
	}

	@Override
	public boolean existeComiteSancionador(String codComite){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codComite", codComite);
		rawDao.addParams(params);
		
		String res = rawDao.getExecuteSQL("		SELECT COUNT(1) "
				+ "		FROM DD_COS_COMITES_SANCION cos			"
				+ "     WHERE cos.BORRADO = 0					"
				+ "		AND cos.DD_COS_CODIGO = :codComite   "
				);

		return !res.equals("0");
	}

	@Override
	public boolean existeTipoimpuesto(String codTipoImpuesto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codTipoImpuesto", codTipoImpuesto);
		rawDao.addParams(params);
		
		String res = rawDao.getExecuteSQL("		SELECT COUNT(1) "
				+ "     FROM DD_TIT_TIPOS_IMPUESTO tit			"
				+ "		WHERE tit.BORRADO = 0					"
				+ "		AND tit.DD_TIT_CODIGO = :codTipoImpuesto "
				);

		return !res.equals("0");
	}
	@Override
	public boolean isProveedorSuministroVigente( String codRem ) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codRem", codRem);
		rawDao.addParams(params);
		
		String sql = null;
		if ( codRem != null && codRem.length() > 0) {
			sql = "select count(1) from act_pve_proveedor pve "
		+		   "inner join dd_tpr_tipo_proveedor tpr on tpr.dd_tpr_id = pve.dd_tpr_id " 
		+		   "where pve.pve_cod_rem = :codRem "
		+		   " and pve.borrado = 0  " 
		+		   " and pve.pve_fecha_baja is null " 
		+		   " and tpr.dd_tpr_codigo = 25 ";
			
		}
		
		return sql == null ? null : !"0".equals(rawDao.getExecuteSQL(sql));
	}

	@Override
	public boolean existeCodigoPrescriptor(String codPrescriptor){
		boolean resultado = false;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codPrescriptor", codPrescriptor);
		rawDao.addParams(params);
		
		if(codPrescriptor != null && !codPrescriptor.isEmpty()){
			String res = rawDao.getExecuteSQL("		SELECT COUNT(1) "
					+ "     FROM ACT_PVE_PROVEEDOR act			"
					+ "		WHERE act.BORRADO = 0					"
					+ "		AND act.PVE_COD_REM = :codPrescriptor "
					);
			resultado = !res.equals("0");
		}

		return resultado;
	}

	@Override
	public boolean existeTipoDocumentoByCod(String codDocumento){
		boolean resultado = false;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codDocumento", codDocumento);
		rawDao.addParams(params);
		
		if(codDocumento != null && !codDocumento.isEmpty()){
			String res = rawDao.getExecuteSQL("		SELECT COUNT(1) "
					+ "		FROM DD_TDI_TIPO_DOCUMENTO_ID tdi		"
					+ "		WHERE tdi.BORRADO = 0					"
					+ "		AND tdi.DD_TDI_CODIGO = :codDocumento "
					);

			resultado = !res.equals("0");

		}

		return resultado;
	}

	@Override
	public Boolean existeAgrupacionByDescripcion(String descripcionAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("descripcionAgrupacion", descripcionAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(descripcionAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_AGR_AGRUPACION WHERE"
				+ "		 	AGR_DESCRIPCION = :descripcionAgrupacion "
				+ "		 	AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public String getSubcartera(String numActivo) {
		String resultado = "";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(numActivo != null && !numActivo.isEmpty()){
			 resultado = rawDao.getExecuteSQL("SELECT scr.DD_SCR_CODIGO "
					+ "		FROM ACT_ACTIVO act "
					+ "		INNER JOIN DD_SCR_SUBCARTERA scr "
					+ "		ON act.DD_SCR_ID            = scr.DD_SCR_ID "
					+ "		WHERE act.ACT_NUM_ACTIVO = :numActivo ");
		}

		return resultado;
	}

	@Override
	public Boolean agrupacionEstaVacia(String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_AGR_AGRUPACION AGR " +
				"JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " +
				"WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion ");

		return resultado.equals("0");
	}

	@Override
	public Boolean distintosTiposImpuestoAgrupacionVacia(List<String> listaActivos) {
		boolean actCanarias;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("listaActivos", listaActivos.get(0));
		rawDao.addParams(params);

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID "
				+ "JOIN BIE_BIEN BIE ON BIE.BIE_ID = ACT.BIE_ID "
				+ "JOIN BIE_LOCALIZACION LOC ON LOC.BIE_ID = BIE.BIE_ID "
				+ "JOIN REMMASTER.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID AND DD_PRV_CODIGO IN ('35', '38') "
				+ "WHERE ACT.ACT_NUM_ACTIVO =  :listaActivos ");

		actCanarias = Integer.valueOf(resultado) > 0;

		for (String activo : listaActivos) {
			params = new HashMap<String, Object>();
			params.put("activo", activo);
			rawDao.addParams(params);
			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT "
					+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID "
					+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID "
					+ "JOIN BIE_BIEN BIE ON BIE.BIE_ID = ACT.BIE_ID "
					+ "JOIN BIE_LOCALIZACION LOC ON LOC.BIE_ID = BIE.BIE_ID "
					+ "JOIN REMMASTER.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID AND DD_PRV_CODIGO IN ('35', '38') "
					+ "WHERE ACT.ACT_NUM_ACTIVO = :activo");

			if ((Integer.valueOf(resultado) > 0) != actCanarias) {
				return true;
			}
		}

		return false;
	}

	@Override
	public Boolean subcarteraPerteneceCartera(String subcartera, String cartera){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("subcartera", subcartera);
		params.put("cartera", cartera);
		rawDao.addParams(params);
		
		if(!Checks.esNulo(cartera) && !Checks.esNulo(subcartera)){
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM DD_SCR_SUBCARTERA SCR "
					+ "JOIN DD_CRA_CARTERA CRA ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.DD_CRA_CODIGO = :cartera "
					+ "WHERE DD_SCR_CODIGO = :subcartera ");

			return (Integer.valueOf(resultado) > 0);
		}

		return false;
	}

	@Override
	public Boolean subtipoPerteneceTipoTitulo(String subtipo, String tipoTitulo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("subtipo", subtipo);
		params.put("tipoTitulo", tipoTitulo);
		rawDao.addParams(params);
		
		String resultado;

		if(!Checks.esNulo(tipoTitulo) && !Checks.esNulo(subtipo)){
			
			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM DD_STA_SUBTIPO_TITULO_ACTIVO STA "
				+ "JOIN DD_TTA_TIPO_TITULO_ACTIVO TTA ON STA.DD_TTA_ID = TTA.DD_TTA_ID AND TTA.DD_TTA_CODIGO = :tipoTitulo "
				+ "WHERE STA.DD_STA_CODIGO = :subtipo");

			return (Integer.valueOf(resultado) > 0);
		}
		return false;
	}


	@Override
	public Boolean esParGastoActivo(String numGasto, String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(!StringUtils.isNumeric(numGasto) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM GLD_ENT ENT"
				+ " INNER JOIN GLD_TBJ TBJ ON TBJ.GLD_ID = ENT.GLD_ID" 
				+ " INNER JOIN GLD_GASTOS_LINEA_DETALLE GLD ON TBJ.GLD_ID = GLD.GLD_ID" 
				+ "	WHERE GLD.GPV_ID = (SELECT GPV_ID FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = :numGasto)"
				+ " AND ENT.DD_ENT_ID = (SELECT DD_ENT_ID FROM DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO ='ACT') "
				+ "	AND ENT.ENT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = :numActivo)");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean agrupacionEsProyecto(String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("	SELECT COUNT(1) FROM ACT_AGR_AGRUPACION             AGR "
				+ " JOIN DD_TAG_TIPO_AGRUPACION TAG "
				+ " ON TAG.DD_TAG_CODIGO = '04' "
				+ " AND TAG.DD_TAG_ID = AGR.DD_TAG_ID "
				+ " WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion    "
				+ " AND AGR.BORRADO = 0 ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existePromocion(String promocion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("promocion", promocion);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM ACT_ACTIVO "
				+ "WHERE ACT_COD_PROMOCION_PRINEX = :promocion");
		return !"0".equals(resultado);
	}

	public Boolean mediadorExisteVigente(String codMediador){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codMediador", codMediador);
		rawDao.addParams(params);
		
		if(!Checks.esNulo(codMediador)){
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_PVE_PROVEEDOR "
					+ " WHERE PVE_COD_REM =  :codMediador  AND BORRADO = 0");

			if ((Integer.valueOf(resultado) > 0)) {
				rawDao.addParams(params);
				resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_PVE_PROVEEDOR "
						+ " WHERE PVE_COD_REM = :codMediador  AND PVE_FECHA_BAJA IS NULL OR PVE_FECHA_BAJA >= SYSDATE"
						+ " AND BORRADO = 0");

				return (Integer.valueOf(resultado) > 0);
			}
		}

		return false;
	}

	@Override
    public Boolean activoTienePRV(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
    	String resultado = "0";
		if(numActivo != null && !numActivo.isEmpty()){
	    	 resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT "
					+ " JOIN BIE_BIEN BIE "
					+ " ON ACT.BIE_ID = BIE.BIE_ID "
					+ " JOIN BIE_LOCALIZACION   BIE_LOC "
					+ " ON BIE.BIE_ID = BIE_LOC.BIE_ID "
					+ " JOIN REMMASTER.DD_PRV_PROVINCIA PRV "
					+ " ON PRV.DD_PRV_ID = BIE_LOC.DD_PRV_ID "
					+ " WHERE ACT.ACT_NUM_ACTIVO = :numActivo "
					+ " AND ACT.BORRADO=0 "
					+ " AND BIE.BORRADO=0 "
					+ " AND BIE_LOC.BORRADO=0 ");
		}

		return !"0".equals(resultado);
	}

	@Override
    public Boolean activoTieneLOC(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
    	String resultado = "0";
		if(numActivo != null && !numActivo.isEmpty()){
			 resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_ACTIVO ACT "
					+ " JOIN BIE_BIEN BIE "
					+ " ON ACT.BIE_ID = BIE.BIE_ID "
					+ " JOIN BIE_LOCALIZACION   BIE_LOC "
					+ " ON BIE.BIE_ID = BIE_LOC.BIE_ID "
					+ " JOIN REMMASTER.DD_LOC_LOCALIDAD LOC "
					+ " ON LOC.DD_LOC_ID = BIE_LOC.DD_LOC_ID "
					+ " WHERE ACT.ACT_NUM_ACTIVO = :numActivo "
					+ " AND ACT.BORRADO=0 "
					+ " AND BIE.BORRADO=0 "
					+ " AND BIE_LOC.BORRADO=0 ");
		}

		return !"0".equals(resultado);
	}

	@Override
	public Boolean esMismaProvincia(Long numActivo, Long numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		String prv_activo = rawDao.getExecuteSQL("SELECT PRV.DD_PRV_ID FROM ACT_ACTIVO ACT "
				+ " JOIN BIE_BIEN BIE "
				+ " ON ACT.BIE_ID = BIE.BIE_ID "
				+ " JOIN BIE_LOCALIZACION   BIE_LOC "
				+ " ON BIE.BIE_ID = BIE_LOC.BIE_ID "
				+ " JOIN REMMASTER.DD_PRV_PROVINCIA PRV "
				+ " ON PRV.DD_PRV_ID = BIE_LOC.DD_PRV_ID "
				+ " WHERE ACT.ACT_NUM_ACTIVO = :numActivo "
				+ " AND ACT.BORRADO=0 "
				+ " AND BIE.BORRADO=0 "
				+ " AND BIE_LOC.BORRADO=0 ");
		
		params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);

		String prv_agrupacion = rawDao.getExecuteSQL("SELECT PRV.DD_PRV_ID FROM ACT_AGR_AGRUPACION AGR "
				+ " JOIN ACT_PRY_PROYECTO PRY "
				+ " ON AGR.AGR_ID = PRY.AGR_ID "
				+ " JOIN REMMASTER.DD_PRV_PROVINCIA PRV "
				+ " ON PRV.DD_PRV_ID = PRY.DD_PRV_ID "
				+ " WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion "
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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(!Checks.esNulo(numActivo)){
			String resultado = rawDao.getExecuteSQL("select TCO.DD_TCO_CODIGO from ACT_ACTIVO act "
					 + " INNER JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID "
					 + " INNER JOIN DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID = TCO.DD_TCO_ID "
					 + " where act.ACT_NUM_ACTIVO = :numActivo ");

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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(!Checks.esNulo(numActivo)){
			String resultado = rawDao.getExecuteSQL("select TCO.DD_TCO_CODIGO from ACT_ACTIVO act "
					 + " INNER JOIN ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID AND APU.BORRADO = 0 "
					 + " INNER JOIN DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID = TCO.DD_TCO_ID AND TCO.BORRADO = 0 "
					 + " where act.ACT_NUM_ACTIVO = :numActivo AND act.BORRADO = 0 ");

			return "03".equals(resultado);
		}

		return false;
	}

	@Override
	public Boolean esActivoAlquilado(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM ACT_PTA_PATRIMONIO_ACTIVO pta, "
				+ "			  ACT_ACTIVO act, DD_EAL_ESTADO_ALQUILER eal "
				+ "			WHERE pta.act_id   = act.act_id "
				+ "			  AND pta.dd_eal_id = eal.dd_eal_id"
				+ "			  AND eal.dd_eal_codigo = '02' "
				+ "			  AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			  AND act.borrado       = 0");

		return Integer.valueOf(resultado) > 0;

	}

	@Override
	public Boolean esAgrupacionTipoAlquiler(String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_AGR_AGRUPACION agr " +
				" INNER JOIN DD_TAG_TIPO_AGRUPACION tipo ON tipo.DD_TAG_ID = agr.DD_TAG_ID AND DD_TAG_CODIGO = '15'" +
				" WHERE agr.AGR_NUM_AGRUP_REM = :numAgrupacion " +
				" AND agr.BORRADO = 0");

		return !"0".equals(resultado);
	}


	@Override
	public Boolean mismoTipoAlquilerActivoAgrupacion(String numAgrupacion, String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;

		String tipoAlquilerAgrupacion = rawDao.getExecuteSQL("SELECT DD_TAL_ID FROM ACT_AGR_AGRUPACION agr WHERE agr.AGR_NUM_AGRUP_REM = :numAgrupacion" +
				" AND agr.BORRADO = 0");
		
		params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		String tipoAlquilerActivo = rawDao.getExecuteSQL("SELECT DD_TAL_ID FROM ACT_ACTIVO act WHERE act.ACT_NUM_ACTIVO =  :numActivo " +
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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_AGR_AGRUPACION agr " +
				" INNER JOIN DD_TAG_TIPO_AGRUPACION tipo ON tipo.DD_TAG_ID = agr.DD_TAG_ID AND DD_TAG_CODIGO = '14'" +
				" WHERE agr.AGR_NUM_AGRUP_REM = :numAgrupacion " +
				" AND agr.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public String getCodigoSubcarteraAgrupacion(String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		String resultado = "";
		if(numAgrupacion != null && !numAgrupacion.isEmpty()){
			 resultado = rawDao.getExecuteSQL("SELECT scr.DD_SCR_CODIGO " +
			 		" FROM ACT_ACTIVO act  " +
			 		" INNER JOIN ACT_AGR_AGRUPACION agr ON agr.AGR_NUM_AGRUP_REM =  :numAgrupacion " +
			 		" INNER JOIN ACT_AGA_AGRUPACION_ACTIVO aga ON agr.AGR_ID = aga.AGR_ID AND aga.AGA_PRINCIPAL = 1 " +
			 		" INNER JOIN DD_SCR_SUBCARTERA scr ON act.DD_SCR_ID = scr.DD_SCR_ID  " +
			 		" WHERE act.ACT_ID = aga.ACT_ID");
		}
		return resultado;
	}

	@Override
	public Boolean esMismaLocalidad(Long numActivo, Long numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		String loc_activo = rawDao.getExecuteSQL("SELECT LOC.DD_LOC_ID FROM ACT_ACTIVO ACT "
				+ " JOIN BIE_BIEN BIE "
				+ " ON ACT.BIE_ID = BIE.BIE_ID "
				+ " JOIN BIE_LOCALIZACION   BIE_LOC "
				+ " ON BIE.BIE_ID = BIE_LOC.BIE_ID "
				+ " JOIN REMMASTER.DD_LOC_LOCALIDAD LOC "
				+ " ON LOC.DD_LOC_ID = BIE_LOC.DD_LOC_ID "
				+ " WHERE ACT.ACT_NUM_ACTIVO = :numActivo "
				+ " AND ACT.BORRADO=0 "
				+ " AND BIE.BORRADO=0 "
				+ " AND BIE_LOC.BORRADO=0 ");
		
		params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);

		String loc_agrupacion = rawDao.getExecuteSQL("SELECT LOC.DD_LOC_ID FROM ACT_AGR_AGRUPACION AGR "
				+ " JOIN ACT_PRY_PROYECTO PRY "
				+ " ON AGR.AGR_ID = PRY.AGR_ID "
				+ " JOIN REMMASTER.DD_LOC_LOCALIDAD LOC "
				+ " ON LOC.DD_LOC_ID = PRY.DD_LOC_ID "
				+ " WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion "
				+ " AND AGR.BORRADO = 0 ");

		if(!Checks.esNulo(loc_activo) && !Checks.esNulo(loc_agrupacion)){
			return loc_activo.equals(loc_agrupacion);
		} else {
			return false;
		}
	}

	public Boolean existeActivoConOfertaVentaViva(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO ACT "
				+ " 	JOIN ACT_OFR ACTOF ON ACT.ACT_ID = ACTOF.ACT_ID "
				+ " 	JOIN OFR_OFERTAS OFR ON ACTOF.OFR_ID = OFR.OFR_ID "
				+ " 	JOIN DD_TOF_TIPOS_OFERTA TOF ON OFR.DD_TOF_ID = TOF.DD_TOF_ID "
				+ " 	JOIN DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID "
				+ "		WHERE ACT.ACT_NUM_ACTIVO = :numActivo "
				+ " 	AND EOF.DD_EOF_CODIGO IN ('01','03','04')"
				+ "		AND TOF.DD_TOF_CODIGO = '01'"
				+ "		AND ACT.BORRADO = 0 AND OFR.BORRADO = 0 "
				+ "		AND TOF.BORRADO = 0 AND EOF.BORRADO = 0");


		return !"0".equals(resultado);

	}

	public Boolean existeActivoConOfertaAlquilerViva(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM ACT_ACTIVO ACT "
				+ " 	JOIN ACT_OFR ACTOF ON ACT.ACT_ID = ACTOF.ACT_ID "
				+ " 	JOIN OFR_OFERTAS OFR ON ACTOF.OFR_ID = OFR.OFR_ID "
				+ " 	JOIN DD_TOF_TIPOS_OFERTA TOF ON OFR.DD_TOF_ID = TOF.DD_TOF_ID "
				+ " 	JOIN DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID "
				+ "		WHERE ACT.ACT_NUM_ACTIVO = :numActivo "
				+ " 	AND EOF.DD_EOF_CODIGO IN ('01','03','04')"
				+ "		AND TOF.DD_TOF_CODIGO = '02'"
				+ "		AND ACT.BORRADO = 0 AND OFR.BORRADO = 0 "
				+ "		AND TOF.BORRADO = 0 AND EOF.BORRADO = 0");


		return !"0".equals(resultado);

	}

	@Override
	public Boolean activoEnAgrupacionComercialViva(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		String resultado = rawDao.getExecuteSQL("select count(agr.AGR_ID) from ACT_AGR_AGRUPACION agr " +
				" inner join DD_TAG_TIPO_AGRUPACION tag on tag.DD_TAG_ID = agr.DD_TAG_ID and (tag.DD_TAG_CODIGO = '14' or tag.DD_TAG_CODIGO = '15') " +
				" inner join ACT_AGA_AGRUPACION_ACTIVO aga on aga.AGR_ID = agr.AGR_ID " +
				" inner join ACT_ACTIVO act on act.ACT_ID = aga.ACT_ID and act.ACT_NUM_ACTIVO =  :numActivo "+
				" where agr.AGR_FECHA_BAJA IS NULL AND agr.AGR_FIN_VIGENCIA >= sysdate " +
				" and act.borrado = 0" +
				" and agr.borrado = 0" +
				" and tag.borrado = 0" +
				" and aga.borrado = 0");

		return Integer.valueOf(resultado) > 0;

	}

	public String getCodigoDestinoComercialByNumActivo(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		if(Checks.esNulo(numActivo))
			return null;

		return rawDao.getExecuteSQL("SELECT tco.DD_TCO_CODIGO FROM ACT_ACTIVO act "
				+ " INNER JOIN DD_TCO_TIPO_COMERCIALIZACION tco ON act.DD_TCO_ID = tco.DD_TCO_ID "
				+ " WHERE act.ACT_NUM_ACTIVO = :numActivo AND act.BORRADO = 0 AND tco.BORRADO = 0");
	}

	@Override
	public Boolean isActivoPublicadoVenta(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_EPV_ESTADO_PUB_VENTA EPV"
				+ "   		WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_EPV_ID = EPV.DD_EPV_ID"
				+ "			AND EPV.DD_EPV_CODIGO = '03'"
				+ "         AND ACT.ACT_NUM_ACTIVO =  :numActivo ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoOcultoVentaPorMotivosManuales(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_MTO_MOTIVOS_OCULTACION MTO"
				+ "			WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_MTO_V_ID = MTO.DD_MTO_ID"
				+ "			AND MTO.DD_MTO_CODIGO IN ('09','10','11','12')"
				+ "			AND ACT.ACT_NUM_ACTIVO =  :numActivo  ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoPublicadoAlquiler(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_EPA_ESTADO_PUB_ALQUILER EPA"
				+ "   		WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_EPA_ID = EPA.DD_EPA_ID"
				+ "			AND EPA.DD_EPA_CODIGO = '03'"
				+ "         AND ACT.ACT_NUM_ACTIVO =  :numActivo ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoOcultoAlquilerPorMotivosManuales(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT, ACT_APU_ACTIVO_PUBLICACION APU, DD_MTO_MOTIVOS_OCULTACION MTO"
				+ "			WHERE ACT.ACT_ID = APU.ACT_ID"
				+ "			AND APU.DD_MTO_A_ID = MTO.DD_MTO_ID"
				+ "			AND MTO.DD_MTO_CODIGO IN ('09','10','11','12')"
				+ "			AND ACT.ACT_NUM_ACTIVO =  :numActivo  ");

		return !"0".equals(resultado);
	}


	@Override
	public Boolean esActivoConComunicacionComunicada(Long numActivoHaya) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivoHaya", numActivoHaya);
		rawDao.addParams(params);
		
		String resultado = "0";
		if(numActivoHaya != null) {
			 resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_CMG_COMUNICACION_GENCAT com " +
			 		" WHERE com.ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = :numActivoHaya) " +
			 		" AND com.DD_ECG_ID = ( " +
			 		" SELECT DD_ECG_ID FROM DD_ECG_ESTADO_COM_GENCAT WHERE DD_ECG_CODIGO = 'COMUNICADO')");
		}

		return !"0".equals(resultado);

	}

	public Boolean esActivoConComunicacionViva(Long numActivoHaya) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivoHaya", numActivoHaya);
		rawDao.addParams(params);
		
		String resultado = "0";
		if(numActivoHaya != null) {
			resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_CMG_COMUNICACION_GENCAT com " +
			 		" WHERE com.ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = :numActivoHaya) " +
			 		" AND com.DD_ECG_ID IN ( SELECT DD_ECG_ID FROM DD_ECG_ESTADO_COM_GENCAT WHERE DD_ECG_CODIGO IN ('CREADO','COMUNICADO'))");
		}

		return !"0".equals(resultado);

	}

	public Boolean esActivoSinComunicacionViva(Long numActivoHaya) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivoHaya", numActivoHaya);
		rawDao.addParams(params);

		String resultado = "0";
		if(numActivoHaya != null) {
			resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_CMG_COMUNICACION_GENCAT com " +
			 		" WHERE com.ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = :numActivoHaya) " +
			 		" AND com.DD_ECG_ID NOT IN ( SELECT DD_ECG_ID FROM DD_ECG_ESTADO_COM_GENCAT WHERE DD_ECG_CODIGO IN ('CREADO','COMUNICADO'))");
		}

		return "0".equals(resultado);

	}

	public Boolean esActivoConMultiplesComunicacionesVivas(Long numActivoHaya) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivoHaya", numActivoHaya);
		rawDao.addParams(params);

		String resultado = "0";
		if(numActivoHaya != null) {
			resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_CMG_COMUNICACION_GENCAT com " +
			 		" WHERE com.ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = :numActivoHaya) " +
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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivoHaya", numActivoHaya);
		rawDao.addParams(params);

		String resultado = "0";
		if(numActivoHaya != null) {
			resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_RCG_RECLAMACION_GENCAT rec " +
						" WHERE REC.CMG_ID = (SELECT CMG_ID FROM ACT_CMG_COMUNICACION_GENCAT com " +
						" WHERE com.ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO " +
						" WHERE ACT_NUM_ACTIVO =  :numActivoHaya )) " +
						" AND RCG_FECHA_RECLAMACION IS NULL " +
						" AND RCG_FECHA_AVISO IS NOT NULL");
		}

		return !"0".equals(resultado);
	}

	@Override
	public Boolean esActivoConComunicacionGenerada(Long numActivoHaya) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivoHaya", numActivoHaya);
		rawDao.addParams(params);

		String resultado = "0";
		if(numActivoHaya != null) {
			 resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_CMG_COMUNICACION_GENCAT cmg " +
			 		" JOIN   ACT_ADG_ADECUACION_GENCAT adg on cmg.cmg_id = adg.cmg_id" +
			 		" JOIN ACT_ACTIVO act on act.act_id = cmg.act_id"+
			 		" WHERE ACT_NUM_ACTIVO = :numActivoHaya AND adg.BORRADO = 0");
		}

		return !"0".equals(resultado);

		}

	@Override
	public boolean esActivoConAdecuacionFinalizada(Long numActivoHaya) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivoHaya", numActivoHaya);
		rawDao.addParams(params);
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
			 		"WHERE ACT.ACT_NUM_ACTIVO= :numActivoHaya  AND TAR.TAR_TAREA_FINALIZADA= 1");
		}

		return !"0".equals(resultado);
	}


	@Override
	public Boolean isAgrupacionSinActivoPrincipal(String mumAgrupacionRem) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("mumAgrupacionRem", mumAgrupacionRem);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_AGR_AGRUPACION agr "
				+ "			WHERE agr.AGR_NUM_AGRUP_REM =  :mumAgrupacionRem"
				+ "			AND agr.AGR_ACT_PRINCIPAL IS NOT NULL");

		return !"0".equals(resultado);
	}

	public Boolean isActivoFinanciero(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)"
				+ "			FROM ACT_ACTIVO ACT"
				+ "			JOIN DD_TTA_TIPO_TITULO_ACTIVO TTA"
				+ "			ON ACT.DD_TTA_ID = TTA.DD_TTA_ID"
				+ "			WHERE TTA.DD_TTA_CODIGO IN ('03', '04')"
				+ "			AND ACT.ACT_NUM_ACTIVO =  :numActivo  "
				+ "			AND ACT.BORRADO = 0 AND TTA.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoIncluidoPerimetroAlquiler(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
			String resultado = rawDao.getExecuteSQL( "SELECT COUNT(1)"
				+"			FROM ACT_PTA_PATRIMONIO_ACTIVO acpt"
                +"			INNER JOIN ACT_ACTIVO act ON act.ACT_ID = acpt.ACT_ID AND act.ACT_NUM_ACTIVO = :numActivo  "
                +"			WHERE acpt.CHECK_HPM = 1"
			);

		return !"0".equals(resultado);
	}

	@Override
	public Boolean esAgrupacionVigente(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_AGR_AGRUPACION WHERE "
				+ "		 	AGR_NUM_AGRUP_REM = :numAgrupacion "
				+ "		 	AND BORRADO = 0 "
				+ "			AND AGR_FECHA_BAJA IS NULL");
		return !"0".equals(resultado);

	}
	@Override
	public Boolean existeCodImpuesto(String idImpuesto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idImpuesto", idImpuesto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(idImpuesto) || !StringUtils.isNumeric(idImpuesto))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_STG_SUBTIPOS_GASTO WHERE"
				+ "		 DD_STG_CODIGO = :idImpuesto"
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean tieneActivoMatriz(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_AGR_AGRUPACION AGR "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID "
				+ "WHERE AGR_NUM_AGRUP_REM = :numAgrupacion "
				+ "AND AGR.BORRADO = 0 "
				+ "AND AGA.AGA_PRINCIPAL = 1"
				+ "AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = '16')");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoMatriz(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_AGR_AGRUPACION AGR "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0 "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND ACT.BORRADO = 0 "
				+ "WHERE ACT.ACT_NUM_ACTIVO = :numActivo "
				+ "AND AGR.BORRADO = 0 "
				+ "AND AGR.AGR_FECHA_BAJA IS NULL "
				+ "AND AGA.AGA_PRINCIPAL = 1"
				+ "AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = '16')");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isUA(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_AGR_AGRUPACION AGR "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0 "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND ACT.BORRADO = 0 "
				+ "WHERE ACT.ACT_NUM_ACTIVO = :numActivo "
				+ "AND AGR.BORRADO = 0"
				+ "AND AGR.AGR_FECHA_BAJA IS NULL "
				+ "AND AGA.AGA_PRINCIPAL = 0"
				+ "AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = '16')");
		return !"0".equals(resultado);
	}


	@Override
	public String getGestorComercialAlquilerByAgrupacion(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		String username = rawDao.getExecuteSQL("SELECT USU.USU_USERNAME "
				+ "FROM GAC_GESTOR_ADD_ACTIVO GAC "
				+ "JOIN GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID "
				+ "JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID "
				+ "JOIN REMMASTER.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = GAC.ACT_ID "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = GAC.ACT_ID "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion "
				+ "AND AGA.AGA_PRINCIPAL = 1 "
				+ "AND TGE.DD_TGE_CODIGO = 'GESTCOMALQ' "
				+ "AND ROWNUM <= 1 ");
		return username;
	}

	@Override
	public String getSupervisorComercialAlquilerByAgrupacion(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		String username = rawDao.getExecuteSQL("SELECT USU.USU_USERNAME "
				+ "FROM GAC_GESTOR_ADD_ACTIVO GAC "
				+ "JOIN GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID "
				+ "JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID "
				+ "JOIN REMMASTER.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = GAC.ACT_ID "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = GAC.ACT_ID "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion "
				+ "AND AGA.AGA_PRINCIPAL = 1 "
				+ "AND TGE.DD_TGE_CODIGO = 'SUPCOMALQ' "
				+ "AND ROWNUM <= 1");
		return username;
	}

	@Override
	public String getSuperficieConstruidaActivoMatrizByAgrupacion(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		String superficie =rawDao.getExecuteSQL("SELECT BDR.BIE_DREG_SUPERFICIE_CONSTRUIDA "
				+ "FROM BIE_DATOS_REGISTRALES BDR "
				+ "JOIN ACT_ACTIVO ACT ON BDR.BIE_ID = ACT.BIE_ID "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID  "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion "
				+ "AND AGA.AGA_PRINCIPAL = 1");

		return superficie;
	}

	@Override
	public String getSuperficieConstruidaPromocionAlquilerByAgrupacion(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		String superficie =rawDao.getExecuteSQL("SELECT SUM(BDR.BIE_DREG_SUPERFICIE_CONSTRUIDA) "
				+ "FROM BIE_DATOS_REGISTRALES BDR "
				+ "JOIN ACT_ACTIVO ACT ON BDR.BIE_ID = ACT.BIE_ID "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND AGA.BORRADO = 0"
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID  "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion "
				+ "AND AGA.AGA_PRINCIPAL <> 1");

		return superficie;
	}

	@Override
	public String getSuperficieUtilActivoMatrizByAgrupacion(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		String superficie =rawDao.getExecuteSQL("SELECT REG.REG_SUPERFICIE_UTIL "
				+ "FROM ACT_REG_INFO_REGISTRAL REG "
				+ "JOIN ACT_ACTIVO ACT ON REG.ACT_ID = ACT.ACT_ID "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID  "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion "
				+ "AND AGA.AGA_PRINCIPAL = 1");

		return superficie;
	}

	@Override
	public String getSuperficieUtilPromocionAlquilerByAgrupacion(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		String superficie =rawDao.getExecuteSQL("SELECT SUM(REG.REG_SUPERFICIE_UTIL) "
				+ "FROM ACT_REG_INFO_REGISTRAL REG "
				+ "JOIN ACT_ACTIVO ACT ON REG.ACT_ID = ACT.ACT_ID "
				+ "JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND AGA.BORRADO = 0"
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID  "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion "
				+ "AND AGA.AGA_PRINCIPAL <> 1");

		return superficie;
	}

	@Override
	public String getProcentajeTotalActualPromocionAlquiler(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		String porcentaje =rawDao.getExecuteSQL("SELECT SUM(ACT_AGA_PARTICIPACION_UA) "
				+ "FROM ACT_AGA_AGRUPACION_ACTIVO AGA "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion "
				+ "AND AGA.AGA_PRINCIPAL <> 1 AND AGA.BORRADO = 0");

		return porcentaje;
	}

	@Override
	public Boolean existePeriodicidad(String codPeriodicidad) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codPeriodicidad", codPeriodicidad);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codPeriodicidad))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM DD_TPE_TIPOS_PERIOCIDAD"
				+"		WHERE DD_TPE_CODIGO = :codPeriodicidad"
				+"		AND BORRADO= 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeCalculo(String codCalculo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codCalculo", codCalculo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codCalculo))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM DD_CAI_CALCULO_IMPUESTO"
				+"		WHERE DD_CAI_CODIGO = :codCalculo"
				+"		AND BORRADO= 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeTrabajo(String numTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numTrabajo", numTrabajo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ACT_TBJ_TRABAJO"
				+"		WHERE TBJ_NUM_TRABAJO = :numTrabajo "
				+"		AND BORRADO= 0");

		return !"0".equals(resultado);

	}
	
	@Override
	public Boolean estadoPrevioTrabajo(String celdaTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("celdaTrabajo", celdaTrabajo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)  "
				+"		FROM ACT_TBJ_TRABAJO"
				+"		WHERE TBJ_NUM_TRABAJO = :celdaTrabajo "
				+"	AND dd_est_id in ('62','65') AND BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean estadoPrevioTrabajoFinalizado(String celdaTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("celdaTrabajo", celdaTrabajo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)  "
				+"		FROM ACT_TBJ_TRABAJO"
				+"		WHERE TBJ_NUM_TRABAJO = :celdaTrabajo "
				+"	AND dd_est_id = 61 AND BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean fechaEjecucionCumplimentada(String celdaTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("celdaTrabajo", celdaTrabajo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)  "
				+"		FROM ACT_TBJ_TRABAJO"
				+"		WHERE TBJ_NUM_TRABAJO = :celdaTrabajo "
				+"	AND tbj_fecha_ejecutado IS NOT NULL AND BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean resolucionComite(String celdaTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("celdaTrabajo", celdaTrabajo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)  "
				+"		FROM ACT_TBJ_TRABAJO tbj join DD_ACO_APROBACION_COMITE aco on tbj.dd_aco_id = aco.dd_aco_id and aco.borrado = 0"
				+"		WHERE tbj.TBJ_NUM_TRABAJO = :celdaTrabajo "
				+"	AND tbj.tbj_aplica_comite = '1' AND aco.dd_aco_codigo = 'APR' AND tbj.BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean checkComite(String celdaTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("celdaTrabajo", celdaTrabajo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1)  "
				+"		FROM ACT_TBJ_TRABAJO"
				+"		WHERE TBJ_NUM_TRABAJO = :celdaTrabajo "
				+"	AND tbj_aplica_comite = '1' AND BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean tieneLlaves(String celdaTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("celdaTrabajo", celdaTrabajo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("Select count(1) from act_tbj_trabajo tbj  "
				+"		join cfg_visualizar_llaves cvl on tbj.dd_ttr_id = cvl.dd_ttr_id and tbj.dd_str_id = cvl.dd_str_id and cvl.visualizacion_llaves = 1 and cvl.BORRADO=0 "
				+"		where tbj.TBJ_NUM_TRABAJO = :celdaTrabajo "
				+"		AND tbj.BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean checkLlaves(String celdaTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("celdaTrabajo", celdaTrabajo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("Select count(1) from act_tbj_trabajo tbj  "
				+"		where tbj.TBJ_NUM_TRABAJO = :celdaTrabajo "
				+"		and tbj.TBJ_NO_APLICA_LLAVES=1	AND tbj.BORRADO= 0");

		return "1".equals(resultado);

	}
	
	@Override
	public Boolean checkProveedoresLlaves(String celdaTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("celdaTrabajo", celdaTrabajo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(celdaTrabajo))
			return false;

		String resultado = rawDao.getExecuteSQL("Select count(1) from act_tbj_trabajo tbj  "
				+"		where tbj.TBJ_NUM_TRABAJO = :celdaTrabajo "
				+"		AND TBJ_FECHA_ENTREGA_LLAVES is not null and PVC_ID_LLAVES is not null	AND tbj.BORRADO= 0");

		return "1".equals(resultado);

	}

	@Override
	public Boolean existeSubtrabajo(String codSubtrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codSubtrabajo", codSubtrabajo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codSubtrabajo))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM DD_STR_SUBTIPO_TRABAJO"
				+"		WHERE DD_STR_ID = :codSubtrabajo "
				+"		AND BORRADO= 0");

		return "0".equals(resultado);
	}

	@Override
	public Boolean existeGastoTrabajo(String numTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numTrabajo", numTrabajo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numTrabajo))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT"
				+ " CASE WHEN ( "
				+ "		SELECT COUNT(*)	"
				+ "		FROM ACT_TBJ_TRABAJO TBJ "
				+ "		INNER JOIN GLD_TBJ GTBJ ON GTBJ.TBJ_ID = TBJ.TBJ_ID AND GTBJ.BORRADO =0 "
				+ " 	WHERE TBJ.TBJ_NUM_TRABAJO = :numTrabajo	AND TBJ.BORRADO=0 "
				+ "		GROUP BY TBJ.TBJ_NUM_TRABAJO"
				+ "	) is null THEN 0"
				+ "	 ELSE 1 END AS RESULTADO "
				+ "	FROM DUAL");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isActivoNotBankiaLiberbank(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM ACT_ACTIVO ACT "
					+"		WHERE ACT.DD_CRA_ID NOT IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
					+"								WHERE DD_CRA_CODIGO IN ('03','08')"
					+"								AND BORRADO = 0) "
					+"		AND ACT.ACT_NUM_ACTIVO = :numActivo ");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean isActivoBankia(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM ACT_ACTIVO ACT "
					+"		WHERE ACT.DD_CRA_ID IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
					+"								WHERE DD_CRA_CODIGO IN ('03')"
					+"								AND BORRADO = 0) "
					+"		AND ACT.ACT_NUM_ACTIVO = :numActivo ");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean isActivoLiberbank(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM ACT_ACTIVO ACT "
					+"		WHERE ACT.DD_CRA_ID IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
					+"								WHERE DD_CRA_CODIGO IN ('08')"
					+"								AND BORRADO = 0) "
					+"		AND ACT.ACT_NUM_ACTIVO = :numActivo ");

		return !"0".equals(resultado);
	}

	public Boolean validadorTipoOferta(Long numExpediente) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID"
				+"		AND OFR.DD_TOF_ID = (SELECT DD_TOF_ID FROM DD_TOF_TIPOS_OFERTA TOF"
				+"		WHERE TOF.DD_TOF_CODIGO = '01' AND TOF.BORRADO = 0)"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE =  :numExpediente "
				+"		AND ECO.BORRADO = 0 AND OFR.BORRADO = 0");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean esUnidadAlquilable(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_ACTIVO ACT "
				+ "LEFT JOIN DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID = ACT.DD_TTA_ID "
				+ "WHERE TTA.DD_TTA_CODIGO = '05' "
				+ "AND ACT.ACT_NUM_ACTIVO = :numActivo ");

		return !"0".equals(resultado);		
	}
	
	@Override
	public Boolean validadorTipoCartera(Long numExpediente) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID"
				+"		JOIN ACT_OFR AFR ON AFR.OFR_ID = OFR.OFR_ID"
				+"		JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AFR.ACT_ID"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente AND ECO.BORRADO = 0"
				+"		AND ACT.BORRADO = 0 AND OFR.BORRADO = 0"
				+"		AND EXISTS (SELECT 1 FROM ACT_ACTIVO ACT1"
				+"		JOIN DD_SCR_SUBCARTERA DD ON ACT1.DD_SCR_ID = DD.DD_SCR_ID"
				+"		WHERE DD.DD_SCR_CODIGO IN ('05','07','08','09','14','15','19','18','56','57','58','59','60','136','64')"
				+"		AND ACT.ACT_ID = ACT1.ACT_ID)");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean validadorCarteraBankia(Long numExpediente) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID"
				+"		JOIN ACT_OFR AFR ON AFR.OFR_ID = OFR.OFR_ID"
				+"		JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AFR.ACT_ID"
				+"		JOIN DD_CRA_CARTERA DD ON ACT.DD_CRA_ID = DD.DD_CRA_ID"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente AND ECO.BORRADO = 0"
				+"		AND ACT.BORRADO = 0 AND OFR.BORRADO = 0 AND DD.DD_CRA_CODIGO ='03'");
		if(!Checks.esNulo(resultado) && Integer.valueOf(resultado) > 0){
			return true;
		}else{
			return false;
		}
	}

	@Override
	public Boolean validadorCarteraLiberbank(Long numExpediente) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID"
				+"		JOIN ACT_OFR AFR ON AFR.OFR_ID = OFR.OFR_ID"
				+"		JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AFR.ACT_ID"
				+"		JOIN DD_CRA_CARTERA DD ON ACT.DD_CRA_ID = DD.DD_CRA_ID"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente AND ECO.BORRADO = 0"
				+"		AND ACT.BORRADO = 0 AND OFR.BORRADO = 0 AND DD.DD_CRA_CODIGO ='08'");

		if(!Checks.esNulo(resultado) && Integer.valueOf(resultado) > 0){
			return true;
		}else{
			return false;
		}

	}



	@Override
	public Boolean validadorEstadoOfertaTramitada(Long numExpediente) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente AND ECO.BORRADO = 0 AND OFR.BORRADO = 0"
				+"		AND OFR.DD_EOF_ID IN (SELECT EEO.DD_EOF_ID"
				+"		FROM DD_EOF_ESTADOS_OFERTA EEO"
				+"		WHERE EEO.DD_EOF_CODIGO <> '01')");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean validadorEstadoExpedienteSolicitado(Long numExpediente) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente  AND ECO.BORRADO = 0"
				+"		AND ECO.DD_EEC_ID NOT IN (SELECT EEC.DD_EEC_ID"
				+"		FROM DD_EEC_EST_EXP_COMERCIAL EEC"
				+"		WHERE EEC.DD_EEC_CODIGO IN ('01','03','04','05','06','08','10','11','16'))");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean validadorFechaMayorIgualFechaAltaOferta(Long numExpediente, String fecha) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		params.put("fecha", fecha);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente AND ECO.BORRADO = 0 AND OFR.BORRADO = 0"
				+"		AND nvl(OFR.OFR_FECHA_ALTA, TO_DATE('01/01/1500','dd/MM/yy')) < TO_DATE( :fecha ,'dd/MM/yy')+1");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean validadorFechaMayorIgualFechaSancion(Long numExpediente, String fecha) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		params.put("fecha", fecha);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente AND ECO.BORRADO = 0"
				+"		AND nvl(ECO.ECO_FECHA_SANCION, TO_DATE('01/01/1500','dd/MM/yy')) < TO_DATE(:fecha ,'dd/MM/yy')+1");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean validadorFechaMayorIgualFechaAceptacion(Long numExpediente, String fecha) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		params.put("fecha", fecha);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente AND ECO.BORRADO = 0"
				+"		AND nvl(ECO.ECO_FECHA_ALTA, TO_DATE('01/01/1500','dd/MM/yy')) < TO_DATE(:fecha,'dd/MM/yy')+1");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean validadorFechaMayorIgualFechaReserva(Long numExpediente, String fecha) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		params.put("fecha", fecha);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente))
			return true;

		String existeReserva = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"  	FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+" 		JOIN RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID"
				+" 		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente AND ECO.BORRADO = 0 AND RES.BORRADO = 0");

		if("1".equals(existeReserva)) {
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*)  "
					+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
					+"		JOIN RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID"
					+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente AND ECO.BORRADO = 0 AND RES.BORRADO = 0"
					+"		AND nvl(RES.RES_FECHA_FIRMA, TO_DATE('01/01/1500','dd/MM/yy')) < TO_DATE( :fecha ,'dd/MM/yy')+1");

			return !"1".equals(resultado);
		} else {
			return false;
		}
	}

	@Override
	public Boolean validadorFechaMayorIgualFechaVenta(Long numExpediente, String fecha) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		params.put("fecha", fecha);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente AND ECO.BORRADO = 0"
				+"		AND nvl(ECO.ECO_FECHA_VENTA, TO_DATE('01/01/1500','dd/MM/yy')) < TO_DATE( :fecha,'dd/MM/yy')+1");

		return !"1".equals(resultado);
	}

	@Override
	public List<BigDecimal> activosEnAgrupacion(String numOferta){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numOferta", numOferta);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numOferta))
			return null;
		List<BigDecimal> numActius = new ArrayList<BigDecimal>();
		List<Object> resultat = rawDao.getExecuteSQLList("SELECT ACT.ACT_NUM_ACTIVO FROM OFR_OFERTAS OFR " +
				"INNER JOIN ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID " +
				"INNER JOIN ACT_ACTIVO ACT ON AO.ACT_ID = ACT.ACT_ID " +
				"WHERE OFR.OFR_NUM_OFERTA =  :numOferta ");

		for(int i = 0; i < resultat.size(); i++) {
			numActius.add((BigDecimal) resultat.get(i));
		}
		return numActius;
	}


	@Override

	public Boolean compararNumeroFilasTrabajo(String numTrabajo, int numeroFilas) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numTrabajo", numTrabajo);
		params.put("numeroFilas", numeroFilas);
		rawDao.addParams(params);

		if(Checks.esNulo(numTrabajo))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT CASE WHEN numeroTarifas = :numeroFilas THEN 1"
				+"		ELSE 0 END"
				+"		FROM("
				+"		SELECT COUNT(*) numeroTarifas "
				+"		FROM REM01.ACT_TCT_TRABAJO_CFGTARIFA  TCT"
				+"		INNER JOIN REM01.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID=TCT.TBJ_ID AND TBJ.BORRADO=0 AND TBJ.TBJ_NUM_TRABAJO= :numTrabajo "
				+"		WHERE TCT.BORRADO=0"
				+"		GROUP BY TBJ.TBJ_NUM_TRABAJO)");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean existeTipoTarifa(String tipoTarifa) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tipoTarifa", tipoTarifa);
		rawDao.addParams(params);
		
		if(Checks.esNulo(tipoTarifa))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*)"
				+"		FROM DD_TTF_TIPO_TARIFA"
				+"		WHERE BORRADO=0"
				+"		AND DD_TTF_CODIGO = :tipoTarifa "
				+"		GROUP BY DD_TTF_CODIGO");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean tipoTarifaValido(String tipoTarifa, String numTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tipoTarifa", tipoTarifa);
		params.put("numTrabajo", numTrabajo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(tipoTarifa))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT"
				+"		CASE WHEN("
				+"		SELECT COUNT(*) cuentaTipos"
				+"		FROM ACT_TBJ_TRABAJO TBJ"
				+"		INNER JOIN ACT_TCT_TRABAJO_CFGTARIFA TCT ON TCT.TBJ_ID=TBJ.TBJ_ID AND TCT.BORRADO=0"
				+"		INNER JOIN ACT_CFT_CONFIG_TARIFA CFT ON CFT.CFT_ID=TCT.CFT_ID AND CFT.BORRADO=0"
				+"		INNER JOIN REM01.DD_TTF_TIPO_TARIFA TTF ON TTF.DD_TTF_ID=CFT.DD_TTF_ID AND TTF.BORRADO=0 AND TTF.DD_TTF_CODIGO = :tipoTarifa"
				+"		WHERE TBJ.TBJ_NUM_TRABAJO= :numTrabajo "
				+"		GROUP BY TTF.DD_TTF_CODIGO)  IS NULL THEN 0"
				+"		ELSE 1"
				+"		END"
				+"		FROM dual");

		return !"1".equals(resultado);
	}

	@Override
	public Boolean existeEntidadFinanciera(String entidadFinanciera){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("entidadFinanciera", entidadFinanciera);
		rawDao.addParams(params);
		
		if(Checks.esNulo(entidadFinanciera))
			return true;
		if(!Checks.esNulo(entidadFinanciera) && !StringUtils.isNumeric(entidadFinanciera))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT (*) "
				+ "FROM DD_ETF_ENTIDAD_FINANCIERA DDETF WHERE "
				+ "DDETF.DD_ETF_CODIGO = :entidadFinanciera  "
				+" AND DDETF.BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeTipoDeFinanciacion(String tipoFinanciacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tipoFinanciacion", tipoFinanciacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(tipoFinanciacion))
			return true;
		if(!Checks.esNulo(tipoFinanciacion) && !StringUtils.isNumeric(tipoFinanciacion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT (*) "
				+ "FROM DD_TRC_TIPO_RIESGO_CLASE DDTRC WHERE "
				+ "DDTRC.DD_TRC_CODIGO =  :tipoFinanciacion  "
				+" AND DDTRC.BORRADO = 0");
		return !"0".equals(resultado);
	}


	@Override
	public Boolean perteneceOfertaVenta(String numExpedienteComercial){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpedienteComercial", numExpedienteComercial);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpedienteComercial) || !StringUtils.isNumeric(numExpedienteComercial))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM ECO_EXPEDIENTE_COMERCIAL ECO" +
				"	JOIN OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID AND OFR.BORRADO = 0" +
				"	LEFT JOIN DD_TOF_TIPOS_OFERTA TOF ON OFR.DD_TOF_ID = TOF.DD_TOF_ID AND TOF.BORRADO = 0" +
				"	WHERE ECO.ECO_NUM_EXPEDIENTE =  :numExpedienteComercial  AND TOF.DD_TOF_CODIGO != '01' AND ECO.BORRADO = 0");
		return "0".equals(resultado);
	}


	@Override
	public Boolean activosVendidos(String numExpedienteComercial){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpedienteComercial", numExpedienteComercial);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpedienteComercial) || !StringUtils.isNumeric(numExpedienteComercial))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM ECO_EXPEDIENTE_COMERCIAL ECO " +
				" JOIN ACT_OFR ACT_OFR ON ECO.OFR_ID = ACT_OFR.OFR_ID " +
				" JOIN ACT_ACTIVO ACT ON ACT_OFR.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0" +
				" LEFT JOIN DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID = SCM.DD_SCM_ID AND SCM.BORRADO = 0" +
				" WHERE ECO.ECO_NUM_EXPEDIENTE =  :numExpedienteComercial  AND SCM.DD_SCM_CODIGO = '05' AND ECO.BORRADO = 0");
		return "0".equals(resultado);
	}

	public Boolean perteneceDDEstadoActivo(String codigoEstadoActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoEstadoActivo", codigoEstadoActivo);
		rawDao.addParams(params);
		
		if(!Checks.esNulo(codigoEstadoActivo)) {
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+ "FROM DD_EAC_ESTADO_ACTIVO "
					+ "WHERE DD_EAC_CODIGO =  :codigoEstadoActivo ");

			return  !"0".equals(resultado);
		}
		return false;
	}

	@Override
	public Boolean perteneceDDTipoTituloTPA(String codigoTituloTPA) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoTituloTPA", codigoTituloTPA);
		rawDao.addParams(params);
		
		if (!Checks.esNulo(codigoTituloTPA)) {
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+ "FROM DD_TPA_TIPO_TITULO_ACT "
					+ "WHERE DD_TPA_CODIGO = :codigoTituloTPA ");

			return !"0".equals(resultado);
		}
		return false;
	}

	@Override
	public Boolean existeActivoAsociado(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PDV_PLAN_DIN_VENTAS WHERE"
				+ "		 	ACT_ID = (SELECT ACT.ACT_ID FROM ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = :numActivo)"
				+ "		 	AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeActivoPlusvalia(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_PLS_PLUSVALIA pls " +
				"JOIN ACT_ACTIVO act ON pls.act_id = act.act_id " +
				"WHERE pls.borrado = 0 " +
				"AND act.ACT_NUM_ACTIVO =  :numActivo ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esActivoUA(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_ACTIVO ACT "
				+ "LEFT JOIN DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID = ACT.DD_TTA_ID "
				+ "WHERE TTA.DD_TTA_CODIGO = '05' "
				+ "AND ACT.ACT_NUM_ACTIVO = :numActivo ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean esAccionValido(String codAccion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codAccion", codAccion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codAccion)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM DD_ACM_ACCION_MASIVA ACM "
				+ "WHERE ACM.DD_ACM_CODIGO = :codAccion ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean isTotalOfertaDistintoSumaActivos(Double importe, String numExpedienteComercial ) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("importe", importe);
		params.put("numExpedienteComercial", numExpedienteComercial);
		rawDao.addParams(params);
		
		if (!Checks.esNulo(numExpedienteComercial) && !Checks.esNulo(importe)) {
			String resultado = rawDao.getExecuteSQL("SELECT COUNT (*) "
					+ "				FROM ECO_EXPEDIENTE_COMERCIAL EXP " 
					+ "				JOIN OFR_OFERTAS OFR " 
					+ "				ON OFR.OFR_ID = EXP.OFR_ID "
					+ "				WHERE EXP.ECO_NUM_EXPEDIENTE=  :numExpedienteComercial "
					+ "				AND OFR.BORRADO = 0 "
					+ "				AND OFR.OFR_IMPORTE = :importe");
			return "0".equals(resultado);
		}
		return true;
	}

	@Override
	public Boolean isNullImporteActivos(String numExpedienteComercial) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpedienteComercial", numExpedienteComercial);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numExpedienteComercial)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT	COUNT(*) "  
				+ "		FROM ECO_EXPEDIENTE_COMERCIAL EXP "  
				+ "		JOIN OFR_OFERTAS OFR "  
				+ "		ON OFR.OFR_ID = EXP.OFR_ID "  
				+ "		JOIN ACT_OFR AXO " 
				+ "		ON AXO.OFR_ID = OFR.OFR_ID " 
				+ "		JOIN ACT_ACTIVO ACT " 
				+ "		ON AXO.ACT_ID = ACT.ACT_ID "  
				+ "		WHERE EXP.ECO_NUM_EXPEDIENTE=  :numExpedienteComercial " 
				+ "		AND AXO.ACT_OFR_IMPORTE IS NULL"  
				+ "		AND OFR.BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean isAllActivosEnOferta(String numExpedienteComercial, Hashtable <String, Integer> activos) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpedienteComercial", numExpedienteComercial);
		rawDao.addParams(params);

		if (Checks.esNulo(numExpedienteComercial) || Checks.estaVacio(activos)) return false; 
		String sql = "	SELECT COUNT(*) "
					+"			FROM ECO_EXPEDIENTE_COMERCIAL EXP " 
					+"			JOIN OFR_OFERTAS OFR "
					+"			ON OFR.OFR_ID = EXP.OFR_ID "
					+"			JOIN ACT_OFR AXO "
					+"			ON AXO.OFR_ID = OFR.OFR_ID "
					+"			JOIN ACT_ACTIVO ACT "
					+"			ON AXO.ACT_ID = ACT.ACT_ID "
					+"			WHERE EXP.ECO_NUM_EXPEDIENTE= :numExpedienteComercial "
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
		rawDao.addParams(params);
		return resultado.equals(rawDao.getExecuteSQL(sql));
	}
	
	public Boolean esResultadoValido(String codResultado) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codResultado", codResultado);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codResultado)) {
			return true;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM DD_RES_RESULTADO_SOLICITUD RES "
				+ "WHERE RES.DD_RES_CODIGO = :codResultado ");

		return !"0".equals(resultado);
	}
	
	public Boolean esMotivoExento(String codResultado) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codResultado", codResultado);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codResultado)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "FROM DD_MOE_MOTIVO_EXENTO MOE "
				+ "WHERE MOE.DD_MOE_CODIGO = :codResultado ");

		return !"0".equals(resultado);
	}
	
	public Boolean esTipoTributoValido(String codTipoTributo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codTipoTributo", codTipoTributo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codTipoTributo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM DD_TPT_TIPO_TRIBUTO TPT "
				+ "WHERE TPT.DD_TPT_CODIGO = :codTipoTributo ");

		return !"0".equals(resultado);
	}
	

	@Override
	public Boolean esSolicitudValido(String codSolicitud){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codSolicitud", codSolicitud);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codSolicitud)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM DD_TST_TIPO_SOLICITUD_TRIB TST "
				+ "WHERE TST.DD_TST_CODIGO = :codSolicitud");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeActivoTributo(String numActivo, String fechaRecurso, String tipoSolicitud, String idTributo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("fechaRecurso", fechaRecurso);
		params.put("tipoSolicitud", tipoSolicitud);
		params.put("idTributo", idTributo);
		rawDao.addParams(params);

		if(Checks.esNulo(numActivo) || Checks.esNulo(tipoSolicitud) || !StringUtils.isNumeric(idTributo)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(*) "
				+ "FROM ACT_TRI_TRIBUTOS TRI "
				+ "JOIN DD_TST_TIPO_SOLICITUD_TRIB TST ON TST.DD_TST_ID = TRI.DD_TST_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = TRI.ACT_ID "
				+ "WHERE TST.DD_TST_CODIGO =  :tipoSolicitud   "
				+ "AND TRI.BORRADO = 0 "
				+ "AND ACT.ACT_NUM_ACTIVO =  :numActivo "
				+ "AND TRI.ACT_TRI_FECHA_PRESENTACION_RECURSO = TO_DATE( :fechaRecurso,'dd/MM/yy') "
				+ "AND TRI.ACT_NUM_TRIBUTO = :idTributo "
				);

		return !"0".equals(resultado);
	}

	@Override
	public String getIdActivoTributo(String numActivo, String fechaRecurso, String tipoSolicitud, String idTributo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("fechaRecurso", fechaRecurso);
		params.put("tipoSolicitud", tipoSolicitud);
		params.put("idTributo", idTributo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo) || Checks.esNulo(tipoSolicitud) || !StringUtils.isNumeric(tipoSolicitud) || !StringUtils.isNumeric(idTributo)) {
			return null;
		}

		return rawDao.getExecuteSQL(
				"SELECT TRI.ACT_TRI_ID "
				+ "FROM ACT_TRI_TRIBUTOS TRI "
				+ "JOIN DD_TST_TIPO_SOLICITUD_TRIB TST ON TST.DD_TST_ID = TRI.DD_TST_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = TRI.ACT_ID "
				+ "WHERE TST.DD_TST_CODIGO =  :tipoSolicitud  "
				+ "AND TRI.BORRADO = 0 "
				+ "AND ACT.ACT_NUM_ACTIVO =  :numActivo  "
				+ "AND TRI.ACT_TRI_FECHA_PRESENTACION_RECURSO = TO_DATE( :fechaRecurso ,'dd/MM/yy') "
				+ "AND TRI.ACT_NUM_TRIBUTO =  :idTributo  "
				);

	}

	@Override
	public Boolean esNumHayaVinculado(Long numGasto, String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		if(Checks.esNulo(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM GPV_GASTOS_PROVEEDOR GPV "
				+ "INNER JOIN GLD_GASTOS_LINEA_DETALLE GLD ON GPV.GPV_ID = GLD.GPV_ID "
				+ "INNER JOIN GLD_TBJ TBJ ON TBJ.GLD_ID = GLD.GLD_ID "
				+ "INNER JOIN GLD_ENT ENT ON ENT.GLD_ID = TBJ.GLD_ID "
				+ "INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = ENT.ENT_ID "
				+ "WHERE GPV.GPV_NUM_GASTO_HAYA = :numGasto "
				+ " AND ENT.DD_ENT_ID = (SELECT DD_ENT_ID FROM DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO ='ACT') "
				+ " AND ACT.ACT_NUM_ACTIVO =  :numActivo "
				);

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esnNumExpedienteValido(Long expComercial){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("expComercial", expComercial);
		rawDao.addParams(params);
		
		if(Checks.esNulo(expComercial)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ECO_EXPEDIENTE_COMERCIAL EX "
				+ "JOIN ACT_TRI_TRIBUTOS TRI ON TRI.ECO_ID = EX.ECO_ID "
				+ "WHERE TRI.ECO_ID =  :expComercial "
				);

		return !"0".equals(resultado);
	}


	@Override
	public Boolean existeJunta(String numActivo,  String fechaJunta) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("fechaJunta", fechaJunta);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM ACT_JCM_JUNTA_COM_PROPIETARIOS pls " +
				"JOIN ACT_ACTIVO act ON pls.act_id = act.act_id " +
				"WHERE pls.borrado = 0 " +
				"AND act.ACT_NUM_ACTIVO = :numActivo " +
				"AND TRUNC(pls.JCM_FECHA_JUNTA) = TRUNC(TO_DATE(:fechaJunta,'dd/MM/yy'))");

		return !"0".equals(resultado);

	}

	@Override
	public Boolean existeCodJGOJE(String codJunta) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codJunta", codJunta);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codJunta) || !StringUtils.isNumeric(codJunta)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_JCP_JUNTA_COMUNIDADES WHERE"
				+ "		 DD_JCP_CODIGO = :codJunta "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	

	@Override
	public Boolean conTituloOcupadoSi(String codigoTituloTPA) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoTituloTPA", codigoTituloTPA);
		rawDao.addParams(params);
		
		if (!Checks.esNulo(codigoTituloTPA)) {
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+ "FROM DD_TPA_TIPO_TITULO_ACT "
					+ "WHERE DD_TPA_CODIGO IN ('01','02','03') "
					+ "AND DD_TPA_CODIGO = :codigoTituloTPA ");

			return !"0".equals(resultado);
		}
		return false;
	}
	
	@Override
	public Boolean tipoDeElemento(String tipoElemento) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tipoElemento", tipoElemento);
		rawDao.addParams(params);
		
		if (!Checks.esNulo(tipoElemento)) {
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) from DD_ENT_ENTIDAD_GASTO  " + 
					"WHERE DD_ENT_CODIGO = :tipoElemento ");

			return !"0".equals(resultado);
		}
		return false;
	}

	@Override
	public Boolean conPosesion(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT Count(*) "
				+ "FROM ACT_SPS_SIT_POSESORIA SPS "
				+ "JOIN ACT_ACTIVO ACT ON SPS.ACT_ID = ACT.ACT_ID "
				+ "WHERE SPS_FECHA_TOMA_POSESION IS NOT NULL "
				+ "AND ACT.ACT_NUM_ACTIVO =  :numActivo");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean perteneceDDEstadoDivHorizontal(String codigoEstadoDivHorizontal) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoEstadoDivHorizontal", codigoEstadoDivHorizontal);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codigoEstadoDivHorizontal)) {
			return false;
		}
			String resultado = rawDao.getExecuteSQL("SELECT Count(*) "
					+ "FROM DD_EDH_ESTADO_DIV_HORIZONTAL "
					+ "WHERE DD_EDH_CODIGO = :codigoEstadoDivHorizontal ");

			return !"0".equals(resultado);
	}
	
	@Override
	public Boolean perteneceDDServicerActivo(String codigoServicer) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoServicer", codigoServicer);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codigoServicer)) {
			return false;
		}					
			String resultado = rawDao.getExecuteSQL("SELECT Count(*) " 
					+ "FROM DD_SRA_SERVICER_ACTIVO "
					+ "WHERE DD_SRA_CODIGO = :codigoServicer ");

			return !"0".equals(resultado);		
	}
	
	@Override
	public Boolean perteneceDDCesionComercial(String codigoCesion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoCesion", codigoCesion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codigoCesion)) {
			return false;
		}					
			String resultado = rawDao.getExecuteSQL("SELECT Count(*) " 
					+ "FROM DD_CMS_CESION_COM_SANEAMIENTO "
					+ "WHERE DD_CMS_CODIGO = :codigoCesion ");

			return !"0".equals(resultado);		
	}
	
	@Override
	public Boolean perteneceDDClasificacionApple(String codigoValorOrdinario) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoValorOrdinario", codigoValorOrdinario);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codigoValorOrdinario)) {
			return false;
		}					
			String resultado = rawDao.getExecuteSQL("SELECT Count(*) " 
					+ "FROM DD_CAP_CLASIFICACION_APPLE "
					+ "WHERE DD_CAP_CODIGO = :codigoValorOrdinario ");
			return !"0".equals(resultado);	
	}
	
	@Override
	public Boolean noExisteEstado(String numEstado) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numEstado", numEstado);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numEstado)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM DD_EDC_ESTADO_DOCUMENTO "
				+"			WHERE DD_EDC_CODIGO =  :numEstado ");
		return "0".equals(resultado);
	}
	
	@Override
	public Boolean esActivoProductoTerminado(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numActivo)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM ACT_ACTIVO ACT "
				+"			JOIN DD_EAC_ESTADO_ACTIVO EAC ON ACT.DD_EAC_ID = EAC.DD_EAC_ID"
				+"			WHERE EAC.DD_EAC_CODIGO IN ('03', '07','08','04','10','11')"
				+"			AND ACT.ACT_NUM_ACTIVO = :numActivo ");
		return !"0".equals(resultado);
	}

	public String getActivoJunta(String numActivo,  String fechaJunta) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("fechaJunta", fechaJunta);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo)) {
			return "";
		}

		String resultado = rawDao.getExecuteSQL("SELECT pls.JCM_ID FROM ACT_JCM_JUNTA_COM_PROPIETARIOS pls " + 
				"JOIN ACT_ACTIVO act ON pls.act_id = act.act_id " + 
				"WHERE pls.borrado = 0 " + 
				"AND act.ACT_NUM_ACTIVO = :numActivo " + 
				"AND TRUNC(pls.JCM_FECHA_JUNTA) = TRUNC(TO_DATE(:fechaJunta,'dd/MM/yy'))");

		return resultado;
	}

	@Override
	public Boolean esActivoApple(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}			
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM ACT_ACTIVO ACT "
				+ "JOIN DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID "
				+ "WHERE SCR.DD_SCR_CODIGO = '138' "
				+ "AND ACT.ACT_NUM_ACTIVO = :numActivo ");
		return !"0".equals(resultado);
	}

	public Boolean esGastoRefacturado(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT GDE.GDE_GASTO_REFACTURABLE " 
						+ "FROM GDE_GASTOS_DETALLE_ECONOMICO GDE "
						+ "LEFT JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GDE.GPV_ID "
						+ "WHERE GPV.GPV_NUM_GASTO_HAYA = :numGasto ");

		return "1".equals(resultado);
	}

	public Boolean existeGastoRefacturable(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) " 
						+ "FROM GRG_REFACTURACION_GASTOS GRG "
						+ "LEFT JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GRG.GRG_GPV_ID_REFACTURADO "
						+ "WHERE GPV.GPV_NUM_GASTO_HAYA = :numGasto  AND GRG.BORRADO = 0");

		return "1".equals(resultado);
	}
	
	
	
	
	@Override
	public Boolean esGastoRefacturable(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) " 
						+ "FROM VGR_GASTOS_REFACTURABLES VGR "						
						+ "WHERE VGR.NUM_GASTO_HAYA = :numGasto ");

		return !"0".equals(resultado);
	}
	
	@Override
	public boolean gastoSarebAnyadeRefacturable(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		boolean enc=true;
		
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) " 						
						+ "FROM GPV_GASTOS_PROVEEDOR GPV "
						+ "JOIN GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID=GPV.GPV_ID "
						+ "JOIN ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID " 
						+ "JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID " 
						+ "WHERE CRA.DD_CRA_CODIGO = 02 AND GLD.BORRADO = 0 AND GPV.BORRADO = 0 " 
						+ "AND GPV.GPV_NUM_GASTO_HAYA = :numGasto");
		
		rawDao.addParams(params);
		
		String resultado2 = rawDao
				.getExecuteSQL("SELECT COUNT(*) " 						
						+ "FROM GPV_GASTOS_PROVEEDOR GPV "
						+ "JOIN GRG_REFACTURACION_GASTOS GRG ON GRG.GRG_GPV_ID = GPV.GPV_ID "						
						+ "WHERE GPV.BORRADO = 0 AND GRG.BORRADO = 0 " 
						+ "AND GPV.GPV_NUM_GASTO_HAYA = :numGasto");

		if (Integer.parseInt(resultado)>=1 && Integer.parseInt(resultado2)<=0) {
			enc=false;
		}
		
		return enc;

	}
	
	@Override
	public Boolean perteneceGastoBankiaSareb(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) " 
						+ "FROM GDE_GASTOS_DETALLE_ECONOMICO GDE "
						+ "JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GDE.GPV_ID "
						+ "JOIN ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID " 
						+ "JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID " 
						+ "WHERE CRA.DD_CRA_CODIGO IN (02,03) " 
						+ "AND GPV.GPV_NUM_GASTO_HAYA = :numGasto ");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esGastoEmisorHaya(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) "
						+ "FROM GDE_GASTOS_DETALLE_ECONOMICO GDE "
						+ "JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GDE.GPV_ID "
						+ "JOIN ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = GPV.PVE_ID_EMISOR "
						+ "WHERE PVE.PVE_DOCIDENTIF IN ('A86744349') "
						+ "AND GPV.GPV_NUM_GASTO_HAYA = :numGasto");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esGastoDestinatarioHaya(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) "
						+ "FROM GPV_GASTOS_PROVEEDOR GPV "
						+ "JOIN DD_DEG_DESTINATARIOS_GASTO DEG ON GPV.DD_DEG_ID = DEG.DD_DEG_ID "						
						+ "WHERE DEG.DD_DEG_CODIGO IN ('02') "
						+ "AND GPV.GPV_NUM_GASTO_HAYA = :numGasto ");						

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esGastoDestinatarioPropietario(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) "
						+ "FROM GPV_GASTOS_PROVEEDOR GPV "
						+ "JOIN DD_DEG_DESTINATARIOS_GASTO DEG ON GPV.DD_DEG_ID = DEG.DD_DEG_ID "						
						+ "WHERE DEG.DD_DEG_CODIGO IN ('01') "
						+ "AND GPV.GPV_NUM_GASTO_HAYA = :numGasto");						

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esGastoMismaCartera(String numGasto, String numOtroGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		params.put("numOtroGasto", numOtroGasto);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto) || Checks.esNulo(numOtroGasto)
				|| !StringUtils.isNumeric(numOtroGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) " + "FROM GDE_GASTOS_DETALLE_ECONOMICO GDE "
				+ "INNER JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GDE.GPV_ID "
				+ "INNER JOIN ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID "
				+ "WHERE GPV.GPV_NUM_GASTO_HAYA = :numGasto " 
				+ "AND PRO.PRO_DOCIDENTIF = " 
				+ "(SELECT PRO.PRO_DOCIDENTIF "
				+ "FROM GDE_GASTOS_DETALLE_ECONOMICO GDE "
				+ "INNER JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GDE.GPV_ID "
				+ "INNER JOIN ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID "
				+ "WHERE GPV.GPV_NUM_GASTO_HAYA = :numOtroGasto )");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean mismaCarteraLineaDetalleGasto(String numGasto, String numElemento) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numGasto) || !StringUtils.isAlphanumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT count(1) "
				+ " FROM gpv_gastos_proveedor gpv "
				+ " join act_pro_propietario pro on gpv.pro_id = pro.pro_id "
				+ " join act_activo act on pro.dd_cra_id = act.dd_cra_id "
				+ " where gpv.gpv_num_gasto_haya = :numGasto");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean participaciones(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numGasto) || !StringUtils.isAlphanumeric(numGasto))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT sum (gld_participacion_gasto) participaciones FROM GLD_ENT where gld_id in" + 
				"(select gld_id from gld_gastos_linea_detalle where gpv_id = " + 
				"(select gpv_id from gpv_gastos_proveedor where gpv_num_gasto_haya = :numGasto ))");
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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fasePublicacion", fasePublicacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(fasePublicacion) || !StringUtils.isAlphanumeric(fasePublicacion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_FSP_FASE_PUBLICACION WHERE"
				+ "		 	DD_FSP_CODIGO = :fasePublicacion  "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean activoEnAgrupacionProyecto(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(AGR.AGR_ID) FROM ACT_AGR_AGRUPACION AGR " +
				" INNER JOIN DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.DD_TAG_CODIGO = '04' " +
				" INNER JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " +
				" INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND ACT.ACT_NUM_ACTIVO = :numActivo "+
				" WHERE AGR.AGR_FECHA_BAJA IS NULL" +
				" AND ACT.BORRADO = 0" +
				" AND AGR.BORRADO = 0" +
				" AND TAG.BORRADO = 0" +
				" AND AGA.BORRADO = 0");

		return Integer.valueOf(resultado) > 0;
	}

	@Override
	public Boolean existeTipoDoc(String codTipoDoc) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codTipoDoc", codTipoDoc);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codTipoDoc)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM DD_TPD_TIPO_DOCUMENTO "
				+" WHERE DD_TPD_CODIGO = :codTipoDoc"
				+ " AND DD_TPD_CODIGO IN('02','04','05','06','07','08','09','10','11','12','13','14','15','16','17','19','24','25','26','27','52','71','72','104','106','119')");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeSubfasePublicacion(String subfasePublicacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("subfasePublicacion", subfasePublicacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(subfasePublicacion) || !StringUtils.isAlphanumeric(subfasePublicacion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "	     FROM DD_SFP_SUBFASE_PUBLICACION WHERE"
				+ "	     DD_SFP_CODIGO = :subfasePublicacion "
				+ "      AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	@Override
	public Boolean perteneceSubfaseAFasePublicacion(String codSubFasePublicacion, String codFasePublicacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codSubFasePublicacion", codSubFasePublicacion);
		params.put("codFasePublicacion", codFasePublicacion);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codSubFasePublicacion) || Checks.esNulo(codFasePublicacion)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM DD_FSP_FASE_PUBLICACION FSP "
				+ " JOIN DD_SFP_SUBFASE_PUBLICACION SFP ON SFP.DD_FSP_ID = FSP.DD_FSP_ID"
				+ " WHERE FSP.DD_FSP_CODIGO = :codFasePublicacion  "
				+ " AND SFP.DD_SFP_CODIGO = :codSubFasePublicacion"
				+ " AND FSP.BORRADO = 0 AND SFP.BORRADO = 0");
		return !"0".equals(resultado);
	}
	@Override
	public Boolean existeEstadoDocumento(String codEstadoDoc) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codEstadoDoc", codEstadoDoc);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codEstadoDoc)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM DD_EDC_ESTADO_DOCUMENTO "
				+ " WHERE DD_EDC_CODIGO = :codEstadoDoc");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeCalificacionEnergetica(String codCE) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codCE", codCE);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codCE)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM DD_TCE_TIPO_CALIF_ENERGETICA "
				+ " WHERE DD_TCE_CODIGO = :codCE");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esDocumentoCEE(String codDocumento) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codDocumento", codDocumento);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codDocumento)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM DD_TPD_TIPO_DOCUMENTO "
				+ " WHERE DD_TPD_CODIGO =  :codDocumento"
				+ " AND DD_TPD_CODIGO IN ('25')");
		return !"0".equals(resultado);
	}
	
	@Override
	public Long obtenerNumAgrupacionRestringidaPorNumActivo(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
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
				+ "AND tag.dd_tag_codigo IN ('02','17','18') " 
				+ "AND act.ACT_NUM_ACTIVO =  :numActivo " 
				+ "AND agr.agr_fecha_baja is null "
				+ "AND aga.BORRADO  = 0 " 
				+ "AND agr.BORRADO  = 0 " 
				+ "AND act.BORRADO  = 0 ");
		
		return Checks.esNulo(sql)? null: Long.valueOf(sql);
	}
	
	@Override
	public Boolean esAgrupacionAlquilerConPrecio(String numAgrupacion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
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
			            +"AND AGR.AGR_NUM_AGRUP_REM = :numAgrupacion "
			            +"),"
			            +"("
			            +"SELECT COUNT(DISTINCT AGA.ACT_ID) NUM_VAL "
						+"FROM ACT_AGA_AGRUPACION_ACTIVO AGA "
						+"JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 "
						+"JOIN ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = AGA.ACT_ID AND VAL.BORRADO = 0 " 
						+"JOIN DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.BORRADO = 0 " 			
						+"WHERE AGA.BORRADO = 0 "			            
			            +"AND TPC.DD_TPC_CODIGO = '03' "
			            +"AND AGR.AGR_NUM_AGRUP_REM = :numAgrupacion "
			            +"AND (VAL.VAL_FECHA_FIN >= SYSDATE OR VAL.VAL_FECHA_FIN IS NULL) "
			            +")"								
				);
		return "0".equals(resultado);
	}
	
	@Override
	public String getCodigoMediadorPrimarioByActivo(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		String resultado = "";
		if(!Checks.esNulo(numActivo)){
			 resultado = rawDao.getExecuteSQL("SELECT pve.PVE_COD_REM " +
			 		" FROM ACT_ICO_INFO_COMERCIAL ico  " +
			 		" INNER JOIN ACT_PVE_PROVEEDOR pve ON pve.PVE_ID = ico.ICO_MEDIADOR_ID " +
			 		" INNER JOIN ACT_ACTIVO act ON act.ACT_ID = ico.ACT_ID " +
			 		" WHERE ico.BORRADO = 0 AND act.ACT_NUM_ACTIVO = :numActivo");
		}
		return resultado;
	}
	
	@Override
	public String getCodigoMediadorEspejoByActivo(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		String resultado = "";
		if(!Checks.esNulo(numActivo)){
			 resultado = rawDao.getExecuteSQL("SELECT pve.PVE_COD_REM " +
			 		" FROM ACT_ICO_INFO_COMERCIAL ico  " +
			 		" INNER JOIN ACT_PVE_PROVEEDOR pve ON pve.PVE_ID = ico.ICO_MEDIADOR_ESPEJO_ID " +
			 		" INNER JOIN ACT_ACTIVO act ON act.ACT_ID = ico.ACT_ID " +
			 		" WHERE ico.BORRADO = 0 AND act.ACT_NUM_ACTIVO = :numActivo ");
		}
		return resultado;
	}
	
	@Override
	public Boolean esTipoMediadorCorrecto(String codMediador) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codMediador", codMediador);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codMediador)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT tpr.DD_TPR_CODIGO "
				+ "FROM ACT_PVE_PROVEEDOR pve "
				+ "JOIN DD_TPR_TIPO_PROVEEDOR tpr ON tpr.DD_TPR_ID = pve.DD_TPR_ID "
				+ "WHERE pve.PVE_COD_REM = :codMediador ");
		
		return COD_MEDIADOR.equals(resultado) || COD_FUERZA_VENTA_DIRECTA.equals(resultado);
	}
	
	public Boolean activoConRelacionExpedienteComercial(String numExpediente, String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);

		if(Checks.esNulo(numExpediente))
			return false;

		String query = "SELECT COUNT(1) "
				+ "	  	FROM REM01.ECO_EXPEDIENTE_COMERCIAL ECO "
				+ " 	JOIN REM01.ACT_OFR AO ON AO.OFR_ID = ECO.OFR_ID "
				+ "  	JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID "
				+ "  	WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente  "
				+ "  	AND ACT.ACT_NUM_ACTIVO =  :numActivo ";

		String resultado = rawDao.getExecuteSQL(query);

		return !"0".equals(resultado);
	}

	public Boolean existeActivoNoBankia(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(*) FROM ACT_ACTIVO ACT "
				+"JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID " 
				+"WHERE ACT.ACT_NUM_ACTIVO =  :numActivo  " 
				+"AND CRA.DD_CRA_CODIGO != '03' "
				);

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esExpedienteVenta(String numExpediente) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente))
			return false;

		String query = "SELECT DD_TOF_CODIGO "
				+ "	  	FROM REM01.ECO_EXPEDIENTE_COMERCIAL ECO "
				+ " 	JOIN REM01.OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID "
				+ "  	JOIN REM01.DD_TOF_TIPOS_OFERTA TOF ON OFR.DD_TOF_ID = TOF.DD_TOF_ID "
				+ "  	WHERE ECO.ECO_NUM_EXPEDIENTE =  :numExpediente  ";

		String resultado = rawDao.getExecuteSQL(query);

		return "01".equals(resultado);
	}
	
    @Override
    public Boolean isProveedorUnsuscribed(String pveCodRem) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("pveCodRem", pveCodRem);
		rawDao.addParams(params);

            if(Checks.esNulo(pveCodRem)) {
                    return false;
            }

            String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
                            + "              FROM ACT_PVE_PROVEEDOR WHERE"
                            + "              PVE_COD_REM = :pveCodRem "
                            + "              AND PVE_FECHA_BAJA IS NOT NULL"
                            + "              AND BORRADO = 0"
                            );

            return !"0".equals(resultado);
    }
	
    @Override
    public Boolean existeProveedorByCodRem(String pveCodRem) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("pveCodRem", pveCodRem);
		rawDao.addParams(params);
		
            if(Checks.esNulo(pveCodRem)) {
                    return false;
            }

            String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
                            + "              FROM ACT_PVE_PROVEEDOR WHERE"
                            + "              PVE_COD_REM =  :pveCodRem "
                            + "      AND BORRADO = 0"
                            );
            return !"0".equals(resultado);
    }

	@Override
	public Boolean esExpedienteValidoAprobado(String numExpediente) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente) || !StringUtils.isNumeric(numExpediente))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE =  :numExpediente AND ECO.BORRADO = 0"
				+"		AND ECO.DD_EEC_ID IN (SELECT EEC.DD_EEC_ID"
				+"		FROM DD_EEC_EST_EXP_COMERCIAL EEC"
				+"		WHERE EEC.DD_EEC_CODIGO IN ('11'))");

		return "1".equals(resultado);
	}
	
	
	//---------------------------------------------------------------------
	@Override
	public Boolean esExpedienteValidoFirmado(String numExpediente) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente) || !StringUtils.isNumeric(numExpediente))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente  AND ECO.BORRADO = 0"
				+"		AND ECO.DD_EEC_ID IN (SELECT EEC.DD_EEC_ID"
				+"		FROM DD_EEC_EST_EXP_COMERCIAL EEC"
				+"		WHERE EEC.DD_EEC_CODIGO IN ('03'))");

		return "1".equals(resultado);
	}
	@Override
	public Boolean esExpedienteValidoReservado(String numExpediente) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente) || !StringUtils.isNumeric(numExpediente))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente  AND ECO.BORRADO = 0"
				+"		AND ECO.DD_EEC_ID IN (SELECT EEC.DD_EEC_ID"
				+"		FROM DD_EEC_EST_EXP_COMERCIAL EEC"
				+"		WHERE EEC.DD_EEC_CODIGO IN ('06'))");

		return "1".equals(resultado);
	}

	public Boolean existeActivoTitulo(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(*) FROM ACT_TIT_TITULO TIT "
				+"JOIN ACT_ACTIVO ACT ON TIT.ACT_ID = ACT.ACT_ID "
				+"WHERE ACT.ACT_NUM_ACTIVO =  :numActivo  "
				);
	
		return !"0".equals(resultado);
	}
		
	public Boolean esActivoBankia(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM ACT_ACTIVO ACT "
					+"		WHERE ACT.DD_CRA_ID IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
					+"								WHERE DD_CRA_CODIGO = '03' "
					+"								AND BORRADO = 0) "
					+"		AND ACT.ACT_NUM_ACTIVO =  :numActivo ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeEstadoTitulo(String situacionTitulo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("situacionTitulo", situacionTitulo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(situacionTitulo) || !StringUtils.isAlphanumeric(situacionTitulo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(*) FROM DD_ETI_ESTADO_TITULO " 
				+ "WHERE DD_ETI_CODIGO = :situacionTitulo "
				+ "AND DD_ETI_CODIGO IN ('01', '02', '06')"
		);
		
		return !"0".equals(resultado);
	}

	public Boolean existeEntidadHipotecaria(String codigo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codigo)) {
			return false;
		}
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM DD_EEJ_ENTIDAD_EJECUTANTE "
					+"		WHERE DD_EEJ_CODIGO =  :codigo ");

		return !"0".equals(resultado);
	}
	
	public Boolean existeTipoJuzgado(String codigo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codigo)) {
			return false;
		}
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM DD_JUZ_JUZGADOS_PLAZA "
					+"		WHERE DD_JUZ_CODIGO =  :codigo ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existePoblacionJuzgado(String codigo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codigo)) {
			return false;
		}
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM DD_PLA_PLAZAS "
					+"		WHERE DD_PLA_CODIGO = :codigo");
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean verificaTipoDeAdjudicacion(String idActivo, String tipoAdjudicacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idActivo", idActivo);
		params.put("tipoAdjudicacion", tipoAdjudicacion);
		rawDao.addParams(params);

		if (Checks.esNulo(idActivo) || Checks.esNulo(tipoAdjudicacion)) {
			return false;
		}
	
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM ACT_ACTIVO "
					+"		WHERE ACT_NUM_ACTIVO =  :idActivo AND DD_TTA_ID = (SELECT DD_TTA_ID "
					+"                                                       FROM DD_TTA_TIPO_TITULO_ACTIVO "
					+"                                                       WHERE DD_TTA_CODIGO = :tipoAdjudicacion )");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esAccionValidaInscripciones(String codAccion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codAccion", codAccion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codAccion) || !StringUtils.isNumeric(codAccion)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM DD_ACM_ACCION_MASIVA ACM "
				+ "WHERE ACM.DD_ACM_CODIGO = :codAccion"
				+ "AND ACM.DD_ACM_CODIGO NOT IN('02')");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeTramiteTrabajo(String numTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numTrabajo", numTrabajo);
		rawDao.addParams(params);
		
	    if (Boolean.TRUE.equals(Checks.esNulo(numTrabajo))) return false;
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	            + "    FROM ACT_TBJ_TRABAJO TBJ " 
	            + "    JOIN ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID " 
	            + "    WHERE TBJ_NUM_TRABAJO = :numTrabajo " 
	            + "    AND TRA.BORRADO = 0 " 
	            + "    AND TBJ.BORRADO = 0 "
	            );
	    
	    return !"0".equals(resultado);
	}
	
	@Override
    public Boolean existenTareasEnTrabajo(String numTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numTrabajo", numTrabajo);
		rawDao.addParams(params);
		
        if (Boolean.TRUE.equals(Checks.esNulo(numTrabajo))) return false;
        String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
                + "     FROM ACT_TBJ_TRABAJO TBJ " 
                + "     JOIN ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID "
                + "     JOIN TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID " 
                + "     WHERE TBJ_NUM_TRABAJO = :numTrabajo "
                + "     AND TRA.BORRADO = 0 "
                + "     AND TBJ.BORRADO = 0"
                );
        
        return !"0".equals(resultado);
    }
	
	@Override
	public Boolean esExpedienteValidoVendido(String numExpediente) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente) || !StringUtils.isNumeric(numExpediente))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente  AND ECO.BORRADO = 0"
				+"		AND ECO.DD_EEC_ID IN (SELECT EEC.DD_EEC_ID"
				+"		FROM DD_EEC_EST_EXP_COMERCIAL EEC"
				+"		WHERE EEC.DD_EEC_CODIGO IN ('08'))");

		return "1".equals(resultado);
	}
	
	@Override
	public Boolean esExpedienteValidoAnulado(String numExpediente) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numExpediente", numExpediente);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numExpediente) || !StringUtils.isNumeric(numExpediente))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM ECO_EXPEDIENTE_COMERCIAL ECO"
				+"		WHERE ECO.ECO_NUM_EXPEDIENTE = :numExpediente  AND ECO.BORRADO = 0"
				+"		AND ECO.DD_EEC_ID IN (SELECT EEC.DD_EEC_ID"
				+"		FROM DD_EEC_EST_EXP_COMERCIAL EEC"
				+"		WHERE EEC.DD_EEC_CODIGO IN ('02'))");

		return "1".equals(resultado);
	}
	
	@Override
	public Boolean estadoExpedienteComercial(String activo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activo", activo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(activo) || !StringUtils.isNumeric(activo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT count(1) FROM eco_expediente_comercial where ofr_id in (SELECT ofr_id FROM ofr_ofertas where "
				+"		ofr_id in (SELECT ofr_id FROM act_ofr where act_id in (SELECT act_id from act_activo where "
				+"		act_num_activo = :activo))) and eco_expediente_comercial.dd_eec_id in (SELECT ddexp.DD_eec_id from dd_eec_est_exp_comercial ddexp WHERE ddexp.dd_eec_codigo  in ('03','06','08')) ");

		return "1".equals(resultado);
	}
	
	@Override
	public Boolean coincideTipoJuzgadoPoblacionJuzgado(String codigoTipoJuzgado, String codigoPoblacionJuzgado) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoTipoJuzgado", codigoTipoJuzgado);
		params.put("codigoPoblacionJuzgado", codigoPoblacionJuzgado);
		rawDao.addParams(params);

		if(Checks.esNulo(codigoTipoJuzgado) || Checks.esNulo(codigoPoblacionJuzgado))
			return false;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+"		FROM DD_JUZ_JUZGADOS_PLAZA JUZ"
				+"		JOIN DD_PLA_PLAZAS PLA ON PLA.DD_PLA_ID = JUZ.DD_PLA_ID"
				+"		WHERE JUZ.DD_JUZ_CODIGO = :codigoTipoJuzgado "
				+"		AND PLA.DD_PLA_CODIGO = :codigoPoblacionJuzgado");

		return "1".equals(resultado);
	}
	
	@Override
	public Boolean direccionComercialExiste(String direccionComercial){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("direccionComercial", direccionComercial);
		rawDao.addParams(params);
		
		if(Checks.esNulo(direccionComercial))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		FROM DD_TDC_TERRITORIOS_DIR_COM "
				+ "		WHERE DD_TDC_CODIGO =  :direccionComercial");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean isActivoEnCesionDeUso( String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		String resultado = rawDao.getExecuteSQL(
				"SELECT count(1) " + 
				"FROM ACT_PTA_PATRIMONIO_ACTIVO pta " + 
				"JOIN DD_CDU_CESION_USO cdu ON pta.DD_CDU_ID = cdu.DD_CDU_ID " + 
				"AND DD_CDU_CODIGO IN ('01','02','03','04') " + 
				"JOIN ACT_ACTIVO act ON act.ACT_ID = pta.ACT_ID " + 
				"AND act.ACT_NUM_ACTIVO = :numActivo " +
				"AND ACT.BORRADO = 0 AND pta.BORRADO = 0"
				);
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean isActivoEnAlquilerSocial( String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL(
				"  SELECT count(1)   "
				+" FROM ACT_PTA_PATRIMONIO_ACTIVO pta     " 
				+" JOIN ACT_ACTIVO act ON act.ACT_ID = pta.ACT_ID AND act.ACT_NUM_ACTIVO = :numActivo"
				+" WHERE pta.PTA_TRAMITE_ALQ_SOCIAL = 1"
				);
		return "1".equals(resultado); 
	}
	
	@Override
    public Boolean isProveedorInTipologias( String proveedor, String[] tipologias) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("proveedor", proveedor);
		rawDao.addParams(params);

        if (tipologias.length<1 || Checks.esNulo(proveedor)) return false;
        String tips= null;
        String resultado = "-1";
        tips = arrayToString(tipologias);
        if (!Checks.esNulo(tips)) {
            resultado = rawDao.getExecuteSQL("  SELECT COUNT(1) FROM ACT_PVE_PROVEEDOR"  
                + "                 WHERE DD_TPR_ID IN (SELECT DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR"
                + "                    WHERE DD_TPR_CODIGO IN ("+tips+"))"
                + "                 AND PVE_COD_REM = :proveedor");
        }
        return "0".equals(resultado); 
    }
	
	@Override
	public Boolean isUserGestorType(String user, String codGestor) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user", user);
		params.put("codGestor", codGestor);
		rawDao.addParams(params);
		
	    if (Checks.esNulo(user) || Checks.esNulo(codGestor)) return false;
	    String resultado;

	    resultado = rawDao.getExecuteSQL(" SELECT COUNT(1)" 
	            +"                  FROM REMMASTER.USU_USUARIOS USU" 
	            +"                 JOIN GEE_GESTOR_ENTIDAD GEE ON GEE.USU_ID = "
	            +"                (SELECT USU_ID FROM REMMASTER.USU_USUARIOS "
	            + "                    WHERE LOWER(USU_USERNAME) = LOWER(:user))"
	            +"                JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE "
	            +"                ON TGE.DD_TGE_ID = GEE.DD_TGE_ID "
	            + "               WHERE TGE.DD_TGE_CODIGO = :codGestor");
	    
	    return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esTareaCompletadaTarificadaNoTarificada(String codTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codTrabajo", codTrabajo);
		rawDao.addParams(params);
		
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
	            +"                 AND TBJ.TBJ_NUM_TRABAJO = :codTrabajo");
	                
	    return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esTrabajoMultiactivo(String codTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codTrabajo", codTrabajo);
		rawDao.addParams(params);

	    if (Checks.esNulo(codTrabajo)) return false;
	    String resultado;
	    resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	            +"                 FROM ACT_TBJ_TRABAJO TBJ"
	            +"                 JOIN ACT_TBJ ACTB ON ACTB.TBJ_ID = TBJ.TBJ_ID"
	            +"                 WHERE TBJ.TBJ_NUM_TRABAJO = :codTrabajo");
	            
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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codSegmento", codSegmento);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codSegmento)) return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM DD_TS_TIPO_SEGMENTO "
				+ "WHERE DD_TS_CODIGO = :codSegmento AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean perteneceSegmentoCraScr(String codSegmento , String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codSegmento", codSegmento);
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codSegmento) || Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) return false;
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) " +
				"FROM dd_scs_segmento_cra_scr scs " +
				"WHERE scs.dd_ts_id = (SELECT dd_ts_id FROM DD_TS_TIPO_SEGMENTO WHERE dd_ts_codigo = :codSegmento  ) " +
				"AND scs.dd_cra_id = (SELECT dd_cra_id FROM ACT_ACTIVO WHERE act_num_activo = :numActivo ) " +
				"AND scs.dd_scr_id = (SELECT dd_scr_id FROM ACT_ACTIVO WHERE act_num_activo = :numActivo ) " +
				"AND scs.borrado = 0"
				);
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esSubcarteraDivarian(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) return false;
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) " + 
				"FROM act_activo act " + 
				"INNER JOIN dd_scr_subcartera scr ON scr.dd_scr_id = act.dd_scr_id AND dd_scr_codigo IN ('151','152') " + 
				"WHERE act.act_num_activo = :numActivo AND act.borrado = 0"
				);
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esSubcarteraApple(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) return false;
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) " + 
				"FROM act_activo act " + 
				"INNER JOIN dd_scr_subcartera scr ON scr.dd_scr_id = act.dd_scr_id AND dd_scr_codigo IN ('138') " + 
				"WHERE act.act_num_activo =  :numActivo AND act.borrado = 0"
				);
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean aCambiadoDestinoComercial(String numActivo, String destinoComercial) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		params.put("destinoComercial", destinoComercial);
		rawDao.addParams(params);
		
		if((Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) 
				&& (Checks.esNulo(destinoComercial) || !!StringUtils.isNumeric(destinoComercial))
		  ) return false;
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1)"+ 
				"FROM ACT_ACTIVO ACT "+ 
				"INNER JOIN DD_TS_TIPO_SEGMENTO TIPO on TIPO.dd_ts_id = act.dd_ts_id and TIPO.dd_ts_codigo = 03 "+
				"WHERE ACT.DD_TCO_ID = :destinoComercial "+
				" AND act.act_num_activo = :numActivo "+
				" and act.ACT_PERIMETRO_MACC = 1" +
				" AND act.borrado = 0");
		return "1".equals(resultado);
	}
	
	@Override
	public Boolean existeCodigoPeticion(String codPeticion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codPeticion", codPeticion);
		rawDao.addParams(params);
		
		 if(codPeticion == null || codPeticion.isEmpty())
			 return true;// Si codigo peticion viene nula es porque se va a crear nueva peticion.
		 
		 if(Boolean.FALSE.equals(StringUtils.isNumeric(codPeticion)))
			 return false;
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) "+ 
				"FROM HPP_HISTORICO_PETICIONES_PRECIOS HPP "+ 
				"WHERE HPP.HPP_ID = :codPeticion " +
				" AND HPP.borrado = 0");
		return "1".equals(resultado);
	}
	
	@Override
	public Boolean existeCodigoMotivoAdmision(String codMotivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codMotivo", codMotivo);
		rawDao.addParams(params);
		
		 if(codMotivo == null || codMotivo.isEmpty())
			 return true;// Si codigo peticion viene nula es porque se va a crear nueva peticion.
		 
		 if(Boolean.FALSE.equals(StringUtils.isNumeric(codMotivo)))
			 return false;

		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) "+ 
				"FROM DD_MGC_MOTIVO_GEST_COMERCIAL MGC"+ 
				" WHERE MGC.DD_MGC_CODIGO = :codMotivo" +
				" AND MGC.borrado = 0");
		return "1".equals(resultado);
	}
	
	@Override
	public Boolean tieneFechaVentaExterna(String activo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activo", activo);
		rawDao.addParams(params);
		
		 if(activo == null || activo.isEmpty())
			 return true;// Si codigo peticion viene nula es porque se va a crear nueva peticion.
		 
		 if(Boolean.FALSE.equals(StringUtils.isNumeric(activo)))
			 return false;

		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) "+ 
				"FROM act_activo act"+ 
				" WHERE act.act_num_activo = :activo " +
				" AND act.act_venta_externa_fecha is null AND act.borrado = 0");
		return "1".equals(resultado);
	}
	
	@Override
	public Boolean activoNoComercializable(String activo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activo", activo);
		rawDao.addParams(params);
		
		 if(activo == null || activo.isEmpty())
			 return true;// Si codigo peticion viene nula es porque se va a crear nueva peticion.
		 
		 if(Boolean.FALSE.equals(StringUtils.isNumeric(activo)))
			 return false;

		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) "+ 
				"FROM act_pac_perimetro_activo pac"+ 
				" WHERE pac.pac_check_formalizar = '1'"+
				" AND pac.act_id = (select act_id from act_activo where act_num_activo = :activo) AND pac.borrado = 0");
		return "1".equals(resultado);
	}
	
	@Override
	public Boolean maccConCargas(String activo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activo", activo);
		rawDao.addParams(params);
		
		 if(activo == null || activo.isEmpty())
			 return true;// Si codigo peticion viene nula es porque se va a crear nueva peticion.
		 
		 if(Boolean.FALSE.equals(StringUtils.isNumeric(activo)))
			 return false;

		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) "+ 
				"FROM act_activo act"+ 
				" WHERE act.act_num_activo = :activo"+
				" AND act.act_con_cargas = '01'  AND act.borrado = 0");
		return "1".equals(resultado);
	}
	
	@Override
	public Boolean existeCodigoPeticionActivo(String codPeticion, String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codPeticion", codPeticion);
		params.put("numActivo", numActivo);
		rawDao.addParams(params);

		 if(codPeticion == null || codPeticion.isEmpty())
			 return true;// Si codigo peticion viene nula es porque se va a crear nueva peticion.
		 
		 if(Boolean.FALSE.equals(StringUtils.isNumeric(codPeticion)) || numActivo == null 
				 ||  Boolean.FALSE.equals(StringUtils.isNumeric(numActivo)))
			 return false;
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) "+ 
				" FROM HPP_HISTORICO_PETICIONES_PRECIOS HPP "+
				" INNER JOIN ACT_ACTIVO ACT ON HPP.ACT_ID = ACT.ACT_ID "+ 
				" WHERE HPP.HPP_ID = :codPeticion " +
				" AND ACT.ACT_NUM_ACTIVO =  :numActivo " +
				" AND HPP.borrado = 0 AND ACT.BORRADO = 0");
		return "1".equals(resultado);
	}
	
	 @Override
	 public Boolean esPeticionEditable(String codPeticion, String numActivo) {
		 Map<String, Object> params = new HashMap<String, Object>();
		 params.put("codPeticion", codPeticion);
		 params.put("numActivo", numActivo);
		 rawDao.addParams(params);
		 
		 Boolean resultado = false;

		 if(codPeticion == null || codPeticion.isEmpty())
			 return true;// Si codigo peticion viene nula es porque se va a crear nueva peticion.
		 
		 List<Object> listaHistPeticiones = rawDao.getExecuteSQLList("SELECT HPP.HPP_ID FROM hpp_historico_peticiones_precios HPP " + 
		"INNER JOIN ACT_ACTIVO ACT ON HPP.ACT_ID = ACT.ACT_ID " + 
		" WHERE ACT.ACT_NUM_ACTIVO = :numActivo AND ACT.BORRADO = 0 AND " + 
		" HPP.DD_TPP_ID = (select dd_tpp_id from dd_tpp_tipo_peticion_precio where dd_tpp_id = (" + 
		" SELECT DD_TPP_ID FROM hpp_historico_peticiones_precios where HPP_ID = :codPeticion )) AND HPP.BORRADO = 0"
		+ " ORDER BY HPP.FECHACREAR DESC");
		
		 if(!listaHistPeticiones.isEmpty() && listaHistPeticiones.get(0).toString().equals(codPeticion)) {
			 resultado = true;
		 }
		 
		 return resultado;
	 }

	@Override
	public Boolean existeTipoPeticion(String codTpoPeticion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codTpoPeticion", codTpoPeticion);
		rawDao.addParams(params);
		
		 if((codTpoPeticion == null ||  Boolean.FALSE.equals(StringUtils.isNumeric(codTpoPeticion))))
			 return false;
			
		String resultado = rawDao.getExecuteSQL("SELECT  COUNT(1) FROM DD_TPP_TIPO_PETICION_PRECIO " + 
				"WHERE DD_TPP_CODIGO = :codTpoPeticion AND BORRADO = 0");
		
		return "1".equals(resultado);
	}
	
	@Override
	public boolean existeContactoProveedorTipoUsuario(String usrContacto, String codProveedor) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("usrContacto", usrContacto);
		params.put("codProveedor", codProveedor);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT  COUNT(1) FROM ACT_PVC_PROVEEDOR_CONTACTO pvc " + 
				"JOIN ACT_PVE_PROVEEDOR pve ON pve.PVE_ID = pvc.PVE_ID AND PVE_COD_REM = :codProveedor AND pve.BORRADO = 0" +
				"JOIN REMMASTER.USU_USUARIOS usu ON usu.USU_ID = pvc.USU_ID AND usu.USU_USERNAME = :usrContacto AND usu.BORRADO = 0");
		
		return Integer.valueOf(resultado) > 0;
	}
	
	@Override
	public Boolean existeSituacionTitulo(String codigoSituacionTitulo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoSituacionTitulo", codigoSituacionTitulo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codigoSituacionTitulo) || !StringUtils.isAlphanumeric(codigoSituacionTitulo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_ETI_ESTADO_TITULO " 
				+ "WHERE DD_ETI_CODIGO = :codigoSituacionTitulo  "
		);
		
		return !"0".equals(resultado);
	}
	
	public Boolean esActivoSareb(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
					+"		FROM ACT_ACTIVO ACT "
					+"		WHERE ACT.DD_CRA_ID IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
					+"								WHERE DD_CRA_CODIGO = '02' "
					+"								AND BORRADO = 0) "
					+"		AND ACT.ACT_NUM_ACTIVO = :numActivo");

		return !"0".equals(resultado);
	}
	

	@Override
	public Boolean perteneceADiccionarioConTitulo(String conTitulo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("conTitulo", conTitulo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(conTitulo) || !StringUtils.isAlphanumeric(conTitulo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_TPA_TIPO_TITULO_ACT " 
				+ "WHERE DD_TPA_CODIGO = :conTitulo  "
		);
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean perteneceADiccionarioEquipoGestion(String codEquipoGestion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codEquipoGestion", codEquipoGestion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codEquipoGestion) || !StringUtils.isAlphanumeric(codEquipoGestion)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_EQG_EQUIPO_GESTION " 
				+ "WHERE DD_EQG_CODIGO = :codEquipoGestion "
				+ "AND BORRADO = 0"
		);
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esActivoBBVA(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) "
												+"		FROM ACT_ACTIVO ACT "
												+"		WHERE ACT.DD_CRA_ID IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
												+"								WHERE DD_CRA_CODIGO = '16' "
												+"								AND BORRADO = 0) "
											+"		AND ACT.ACT_NUM_ACTIVO = :numActivo"
				);
		return !"0".equals(resultado);
	}
	
	@Override
    public Boolean existeTipoSuministroByCod(String codigo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		rawDao.addParams(params);
		
            if(Checks.esNulo(codigo)) {
                    return false;
            }

            String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
                            + "              FROM DD_TSU_TIPO_SUMINISTRO WHERE"
                            + "              DD_TSU_CODIGO = :codigo"
                            + "      AND BORRADO = 0"
                            );
            return !"0".equals(resultado);
    }
    
	@Override
    public Boolean existeSubtipoSuministroByCod(String codigo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		rawDao.addParams(params);
		
        if(Checks.esNulo(codigo)) {
                return false;
        }

        String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
                        + "              FROM DD_SSU_SUBTIPO_SUMINISTRO WHERE"
                        + "              DD_SSU_CODIGO = :codigo"
                        + "      AND BORRADO = 0"
                        );
        return !"0".equals(resultado);
    }
    
	@Override
    public Boolean existePeriodicidadByCod(String codigo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		rawDao.addParams(params);
		
        if(Checks.esNulo(codigo)) {
                return false;
        }

        String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
                        + "              FROM DD_PRD_PERIODICIDAD WHERE"
                        + "              DD_PRD_CODIGO =  :codigo"
                        + "      AND BORRADO = 0"
                        );
        return !"0".equals(resultado);
    }
    
	@Override
    public Boolean existeMotivoAltaSuministroByCod(String codigo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		rawDao.addParams(params);
		
        if(Checks.esNulo(codigo)) {
                return false;
        }

        String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
                        + "              FROM DD_MAS_MOTIVO_ALTA_SUM WHERE"
                        + "              DD_MAS_CODIGO = :codigo "
                        + "      AND BORRADO = 0"
                        );
        return !"0".equals(resultado);
    }
    
	@Override
    public Boolean existeMotivoBajaSuministroByCod(String codigo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		rawDao.addParams(params);
		
        if(Checks.esNulo(codigo)) {
                return false;
        }

        String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
                        + "              FROM DD_MBS_MOTIVO_BAJA_SUM WHERE"
                        + "              DD_MBS_CODIGO = :codigo"
                        + "      AND BORRADO = 0"
                        );
        return !"0".equals(resultado);
    }
	
	@Override
    public Boolean esMismoTipoGestorActivo(String codigo, String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo) || Checks.esNulo(codigo)) {
			return false;
		}

        String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
                        + "              FROM gah_gestor_activo_historico gah"
                        + "              join act_activo act on act.act_id = gah.act_id"
                        + "              join geh_gestor_entidad_hist geh on gah.geh_id = geh.geh_id and geh.borrado = 0"
                        + "              left join REMMASTER.dd_tge_tipo_gestor tge on tge.dd_tge_id = geh.dd_tge_id and tge.borrado = 0"
                        + "              where geh.geh_fecha_hasta is null "
                        + "              and tge.dd_tge_codigo like :codigo"
                        + "              AND act.act_num_activo =  :numActivo"
                        );
        return !"0".equals(resultado);
    }

	public Boolean esActivoIncluidoPerimetroAdmision(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(numActivo == null) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT ACT.ACT_ID "
				+ "		FROM ACT_ACTIVO ACT "
				+ "		LEFT JOIN ACT_PAC_PERIMETRO_ACTIVO PAC "
				+ "		ON ACT.ACT_ID = PAC.ACT_ID "
				+ "		WHERE PAC.PAC_CHECK_ADMISION = 1"
				+ "		AND ACT.ACT_NUM_ACTIVO = :numActivo ");
		
		return resultado!=null;
	}
	
	@Override
	public Boolean estadoAdmisionValido(String codEstadoAdmision) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codEstadoAdmision", codEstadoAdmision);
		rawDao.addParams(params);
		
		if(codEstadoAdmision == null) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_EAA_ESTADO_ACT_ADMISION " 
				+ "WHERE DD_EAA_CODIGO = :codEstadoAdmision "
				+ "AND BORRADO = 0"
		);
		
		return "1".equals(resultado);
	}
	
	@Override
	public Boolean isCheckVisibleGestionComercial(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if( Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM ACT_PAC_PERIMETRO_ACTIVO " 
				+ "WHERE ACT_ID = (select act_id from act_activo where act_num_activo = :numActivo ) AND PAC_CHECK_GESTION_COMERCIAL = 1"
				+ "AND BORRADO = 0"
		);
		
		return !"0".equals(resultado);
	}
	
	
	@Override
	public Boolean subestadoAdmisionValido(String codSubestadoAdmision) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codSubestadoAdmision", codSubestadoAdmision);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_SAA_SUBESTADO_ACT_ADMISION " 
				+ "WHERE DD_SAA_CODIGO = :codSubestadoAdmision "
				+ "AND BORRADO = 0"
		);
		
		return "1".equals(resultado);

	}
	
	@Override
	public Boolean estadoConSubestadosAdmisionValido(String codEstadoAdmision) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codEstadoAdmision", codEstadoAdmision);
		rawDao.addParams(params);
		
		if(codEstadoAdmision == null) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_SAA_SUBESTADO_ACT_ADMISION SAA "
				+ "JOIN DD_EAA_ESTADO_ACT_ADMISION EAA ON SAA.DD_EAA_ID = EAA.DD_EAA_ID " 
				+ "WHERE EAA.DD_EAA_CODIGO = :codEstadoAdmision "
				+ "AND EAA.BORRADO = 0 AND SAA.BORRADO = 0"
		);
		
		return !"0".equals(resultado);
		
	}

	@Override
	public Boolean relacionEstadoSubestadoAdmisionValido(String codEstadoAdmision, String codSubestadoAdmision) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codEstadoAdmision", codEstadoAdmision);
		params.put("codSubestadoAdmision", codSubestadoAdmision);
		rawDao.addParams(params);
		
		if(codEstadoAdmision == null) {
			return false;
		}
		
		if(estadoConSubestadosAdmisionValido(codEstadoAdmision)) {
			String resultado = rawDao.getExecuteSQL(
					"SELECT COUNT(1) FROM DD_SAA_SUBESTADO_ACT_ADMISION SAA "
					+ "JOIN DD_EAA_ESTADO_ACT_ADMISION EAA ON SAA.DD_EAA_ID = EAA.DD_EAA_ID " 
					+ "WHERE SAA.DD_SAA_CODIGO =  :codSubestadoAdmision  "
					+ "AND EAA.DD_EAA_CODIGO = :codEstadoAdmision "
					+ "AND EAA.BORRADO = 0 AND SAA.BORRADO = 0"
			);
			
			return "1".equals(resultado);
		}
		
		return true;
	}
		
	@Override
	public String getValidacionCampoCDC(String codCampo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codCampo", codCampo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codCampo) || !StringUtils.isNumeric(codCampo)) {
			return null;
		}
		return rawDao.getExecuteSQL(
				"SELECT VALIDACION FROM CDC_CALIDAD_DATOS_CONFIG "
				+ "WHERE COD_CAMPO = :codCampo  AND BORRADO = 0");
	}
	
	@Override
	public boolean incluidoActivoIdOrigenBBVA (String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if (numActivo == null || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_BBVA_ACTIVOS ABA " + 												 
												"WHERE ABA.BBVA_ID_ORIGEN_HRE = :numActivo AND ABA.BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean relacionPoblacionLocalidad(String columnaPoblacion, String columnaMunicipio) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("columnaPoblacion", columnaPoblacion);
		params.put("columnaMunicipio", columnaMunicipio);
		rawDao.addParams(params);
		
		if(Checks.esNulo(columnaPoblacion) || Checks.esNulo(columnaMunicipio) ) {
			return false;
		}
		
		
			String resultado = rawDao.getExecuteSQL(
					"SELECT COUNT(1) FROM ${master.schema}.dd_loc_localidad loc "
					+ "JOIN ${master.schema}.dd_upo_unid_poblacional pob  ON pob.dd_loc_ID=loc.DD_LOC_ID " 
					+ "WHERE loc.DD_LOC_CODIGO = :columnaPoblacion "
					+ "AND pob.DD_UPO_CODIGO =  :columnaMunicipio "
					+ "and pob.borrado=0 and loc.borrado=0"
			);
			
			
			return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeMunicipioByDescripcion(String codigoMunicipio) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoMunicipio", codigoMunicipio);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codigoMunicipio)) {
			return false;
		}

		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		 FROM ${master.schema}.DD_UPO_UNID_POBLACIONAL WHERE"
				+ "		 DD_UPO_CODIGO =  :codigoMunicipio "
				+ "		 AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existePais(String pais) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("pais", pais);
		rawDao.addParams(params);
		
		if(pais == null || pais.isEmpty()) return null;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM DD_PAI_PAISES WHERE DD_PAI_CODIGO = :pais ");
		return "1".equals(resultado);
	}

	@Override
	public boolean existeMismoProveedorContactoInformado(String codProveedor, String numTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codProveedor", codProveedor);
		params.put("numTrabajo", numTrabajo);
		rawDao.addParams(params);

		String resultado = null;
		String query = "SELECT COUNT(1) FROM ACT_TBJ_TRABAJO TBJ  "
		+				"INNER JOIN ACT_PVC_PROVEEDOR_CONTACTO PVC ON TBJ.PVC_ID  = PVC.PVC_ID  " 
		+ 				"INNER JOIN ACT_PVE_PROVEEDOR PVE ON PVC.PVE_ID = PVE.PVE_ID  "
		+				"WHERE PVE.PVE_COD_REM = :codProveedor AND TBJ.TBJ_NUM_TRABAJO = :numTrabajo";
		
		
		resultado = rawDao.getExecuteSQL(query);
		return Boolean.TRUE.equals("1".equals(resultado));
	}
	
	@Override
	public boolean existeProveedor(String codProveedor) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codProveedor", codProveedor);
		rawDao.addParams(params);
		
		String resultado = null;
		String query = "SELECT COUNT(1) FROM ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = :codProveedor ";
		
		
		resultado = rawDao.getExecuteSQL(query);
		return Boolean.TRUE.equals("1".equals(resultado));
	}
	

	@Override
	public boolean isTipoTarifaValidoEnConfiguracion(String codigoTarifa, String numTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numTrabajo", numTrabajo);
		rawDao.addParams(params);
		
		String queryForGetIds = "SELECT " + 
				"TBJ.DD_TTR_ID,   " + 
				"TBJ.DD_STR_ID,   " + 
				"ACT.DD_CRA_ID   " + 
				"FROM ACT_TBJ_TRABAJO TBJ   " + 
				"INNER JOIN ACT_TBJ ACTTBJ ON TBJ.TBJ_ID = ACTTBJ.TBJ_ID   " + 
				"INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = ACTTBJ.ACT_ID   " + 
				"  WHERE TBJ.TBJ_NUM_TRABAJO = :numTrabajo "
				+" GROUP BY TBJ.DD_TTR_ID, TBJ.DD_STR_ID, ACT.DD_CRA_ID";
		Object [] resultSet = rawDao.getExecuteSQLArray(queryForGetIds);
		
		if ( resultSet != null ) {
			params = new HashMap<String, Object>();
			params.put("codigoTarifa", codigoTarifa);
			rawDao.addParams(params);
			
			String query = "SELECT DD_TTF_ID FROM DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = :codigoTarifa ";
			String tarifaId = rawDao.getExecuteSQL(query);
			if ( tarifaId != null) {
				 query = "SELECT COUNT(1) " + 
							"FROM ACT_CFT_CONFIG_TARIFA CONFIG_TARIFA " + 
							//"WHERE  DD_TTR_ID   = "   + resultSet[0]
							"WHERE DD_CRA_ID   = "    + resultSet[2] 
							+ " AND DD_TTF_ID   = "	  + tarifaId;
					String resultado = rawDao.getExecuteSQL(query);
					return Boolean.TRUE.equals(!"0".equals(resultado));
			}
		}
		return false;
	}

	@Override
	public Boolean existeCampo(String numCampo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numCampo", numCampo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numCampo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "FROM dd_cos_campos_origen_conv_sareb COS "
				+ "WHERE COS.dd_cos_codigo = :numCampo AND COS.BORRADO = 0"
				);
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean perteneceADiccionarioSubtipoRegistro(String subtipo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("subtipo", subtipo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(subtipo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_SRE_SUBTIPO_REGISTRO_ESPARTA " 
				+ "WHERE DD_SRE_CODIGO =  :subtipo  AND BORRADO = 0"
		);
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeIdentificadorSubregistro(String subtipo, String identificador){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("identificador", identificador);
		rawDao.addParams(params);
		
		if(Checks.esNulo(subtipo) || Checks.esNulo(identificador) || !StringUtils.isNumeric(identificador)) {
			return false;
		}			
		String resultado = "0";
		
		if (COD_DD_SRE_TASACION.equals(subtipo)) {
			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
					+ "		 FROM ACT_TAS_TASACION WHERE"
					+ "		 	TAS_ID_EXTERNO = :identificador "
					+ "		 	AND BORRADO = 0");
		} else if (COD_DD_SRE_CARGA.equals(subtipo)) {
			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
					+ "		 FROM BIE_CAR_CARGAS BIE_CAR "
					+ "		 JOIN ACT_CRG_CARGAS CRG ON CRG.BIE_CAR_ID = BIE_CAR.BIE_CAR_ID AND CRG.BORRADO = 0"
					+ "		 WHERE BIE_CAR.BORRADO = 0"
					+ "		 	AND BIE_CAR.BIE_CAR_ID_RECOVERY = :identificador");
		}
		return !"0".equals(resultado);
	}	

	@Override
	public String getEstadoTrabajoByNumTrabajo(String numTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numTrabajo", numTrabajo);
		rawDao.addParams(params);
		
		return rawDao.getExecuteSQL("SELECT DD_EST_CODIGO  " 
								+"  FROM ACT_TBJ_TRABAJO TBJ " 
								+"  INNER JOIN DD_EST_ESTADO_TRABAJO ESTADO ON ESTADO.DD_EST_ID = TBJ.DD_EST_ID " 
								+"  WHERE TBJ_NUM_TRABAJO = :numTrabajo ");
	}
	
	@Override
	public Boolean existeSubtipoGasto(String codSubtipoGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codSubtipoGasto", codSubtipoGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codSubtipoGasto))
			return true;

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+"		FROM DD_STG_SUBTIPOS_GASTO"
				+"		WHERE DD_STG_CODIGO = :codSubtipoGasto"
				+"		AND BORRADO= 0");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean perteneceGastoBankia(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao
				.getExecuteSQL("SELECT COUNT(*) " 
						+ "FROM GDE_GASTOS_DETALLE_ECONOMICO GDE "
						+ "JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GDE.GPV_ID "
						+ "JOIN ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID " 
						+ "JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID " 
						+ "WHERE CRA.DD_CRA_CODIGO IN (03) " 
						+ "AND GPV.GPV_NUM_GASTO_HAYA = :numGasto");

		return !"0".equals(resultado);

	}

	@Override
	public Boolean esTipoRegimenProteccion(String codCampo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codCampo", codCampo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codCampo) || !StringUtils.isAlphanumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_TVP_TIPO_VPO "
						+ "WHERE DD_TVP_CODIGO = :codCampo  AND BORRADO = 0"
		);
		
		return !"0".equals(resultado);
	}
	
	
	@Override
	public Boolean esTipoAltaBBVAMenosAltaAutamatica(String codCampo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codCampo", codCampo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codCampo) || !StringUtils.isAlphanumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_TAL_TIPO_ALTA "
						+ "WHERE DD_TAL_CODIGO = :codCampo AND BORRADO = 0 "
								+ "AND DD_TAL_CODIGO <> 'AUT' "
		);
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean agrupacionSinActivos(String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM ACT_AGR_AGRUPACION AGR "
				+"JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID "
				+ "WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion");
		
		return "0".equals(resultado);
	}
	
	@Override
	public Boolean esGastoYAgrupacionMismoPropietarioByNumGasto(String numAgrupacion, String numGastoHaya) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGastoHaya", numGastoHaya);
		rawDao.addParams(params);

		if (Checks.esNulo(numAgrupacion) || !StringUtils.isNumeric(numAgrupacion) || Checks.esNulo(numGastoHaya) || !StringUtils.isNumeric(numGastoHaya))
			return false;
		
		String carteraGasto = rawDao.getExecuteSQL("SELECT APRO.PRO_ID FROM ACT_PRO_PROPIETARIO APRO " + 
				"         JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.PRO_ID = APRO.PRO_ID " + 
				"         WHERE GPV.GPV_NUM_GASTO_HAYA = :numGastoHaya  AND GPV.BORRADO = 0 AND APRO.BORRADO = 0 ");
		
		params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
					
			String carteraAgrupacion = null;
			String masDeUnaCartera = rawDao.getExecuteSQL("SELECT count(*) FROM (SELECT DISTINCT PACT.PRO_ID   " + 
					"		FROM ACT_PAC_PROPIETARIO_ACTIVO PACT " + 
					"		WHERE EXISTS ( " + 
					"		   SELECT 1 " + 
					"		   FROM ACT_AGR_AGRUPACION AGR " + 
					"		   JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " + 
					"		   WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion  " + 
					"		       AND AGA.ACT_ID  = PACT.ACT_ID " + 
					"		       AND AGR.BORRADO = 0 " + 
					"		       AND AGR.AGR_FECHA_BAJA IS NULL " + 
					"		))");
			
			if("1".equals(masDeUnaCartera)) {
				rawDao.addParams(params);
				carteraAgrupacion = rawDao.getExecuteSQL("SELECT DISTINCT PACT.PRO_ID " + 
						"		FROM ACT_PAC_PROPIETARIO_ACTIVO PACT " + 
						"		WHERE EXISTS ( " + 
						"		   SELECT 1 " + 
						"		   FROM ACT_AGR_AGRUPACION AGR " + 
						"		   JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " + 
						"		   WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion " + 
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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numElemento", numElemento);
		params.put("numGastoHaya", numGastoHaya);
		params.put("tipoElemento", tipoElemento);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numElemento) || !StringUtils.isNumeric(numElemento) || Checks.esNulo(numGastoHaya) || !StringUtils.isNumeric(numGastoHaya))
			return false;
		
		String resultado = rawDao.getExecuteSQL("WITH GENERICO AS ( \n" + 
				"    SELECT COUNT(1) ES_GEN \n" + 
				"    FROM REM01.DD_ENT_ENTIDAD_GASTO \n" + 
				"    WHERE DD_ENT_CODIGO = 'GEN' \n" + 
				"        AND 'GEN' = :tipoElemento \n" + 
				"), ACTIVO AS ( \n" + 
				"    SELECT COUNT(1) ES_ACT \n" + 
				"    FROM REM01.DD_ENT_ENTIDAD_GASTO \n" + 
				"    WHERE DD_ENT_CODIGO = 'ACT' \n" + 
				"        AND 'ACT' = :tipoElemento \n" + 
				"), PAC AS ( \n" + 
				"    SELECT PAC.PRO_ID \n" + 
				"    FROM REM01.ACT_ACTIVO ACT \n" + 
				"    JOIN REM01.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID \n" + 
				"        AND PAC.BORRADO = 0 \n" + 
				"    JOIN ACTIVO ON ACTIVO.ES_ACT = 1 \n" + 
				"    WHERE ACT.BORRADO = 0 \n" + 
				"        AND ACT.ACT_NUM_ACTIVO = :numElemento \n" + 
				"), AGS AS ( \n" + 
				"    SELECT AGS.PRO_ID \n" + 
				"    FROM REM01.ACT_AGS_ACTIVO_GENERICO_STG AGS \n" + 
				"    JOIN GENERICO ON GENERICO.ES_GEN = 1 \n" + 
				"    WHERE AGS.BORRADO = 0 \n" + 
				"        AND AGS.AGS_ACTIVO_GENERICO = :numElemento \n" + 
				") \n" + 
				"SELECT COUNT(1) \n" + 
				"FROM REM01.GPV_GASTOS_PROVEEDOR GPV \n" + 
				"WHERE GPV.GPV_NUM_GASTO_HAYA = :numGastoHaya \n" + 
				"    AND GPV.BORRADO = 0 \n" + 
				"    AND ( \n" + 
				"        EXISTS ( \n" + 
				"        SELECT 1 \n" + 
				"        FROM PAC \n" + 
				"        WHERE PAC.PRO_ID = GPV.PRO_ID \n" + 
				"        ) OR EXISTS ( \n" + 
				"        SELECT 1 \n" + 
				"        FROM AGS \n" + 
				"        WHERE AGS.PRO_ID = GPV.PRO_ID \n" + 
				"        ) \n" + 
				"    )");

		return !"0".equals(resultado);
	}

	@Override
	public boolean existeTipoDeGastoAsociadoCMGA (String codTipoGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codTipoGasto", codTipoGasto);
		rawDao.addParams(params);
		
		if (codTipoGasto == null || !StringUtils.isAlphanumeric(codTipoGasto)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM  DD_TGA_TPO_GASTO_ASOCIADO TGA " 
				+ "WHERE TGA.DD_TGA_CODIGO = :codTipoGasto  "
				+ "AND TGA.BORRADO = 0"
				);
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esTipoDeTransmisionBBVA(String codCampo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codCampo", codCampo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codCampo) || !StringUtils.isAlphanumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_TTR_TIPO_TRANSMISION "
						+ "WHERE DD_TTR_CODIGO = :codCampo  AND BORRADO = 0 "
		);

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeEntidadGasto(String entidad) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("entidad", entidad);
		rawDao.addParams(params);
		
		if (Checks.esNulo(entidad))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM DD_ENT_ENTIDAD_GASTO "
				+" WHERE DD_ENT_CODIGO = :entidad  ");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esTipoDeTituloBBVA(String codCampo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codCampo", codCampo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codCampo) || !StringUtils.isAlphanumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM DD_TTA_TIPO_TITULO_ACTIVO "
						+ "WHERE DD_TTA_CODIGO = :codCampo AND BORRADO = 0 "
		);
		
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esGastoRefacturadoPadre(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM GRG_REFACTURACION_GASTOS GRG "
				+" JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GRG.GRG_GPV_ID AND GPV.BORRADO = 0 "
				+" JOIN ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID AND PRO.BORRADO = 0 "
				+" JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID AND CRA.BORRADO = 0 "
				+" WHERE GPV.GPV_NUM_GASTO_HAYA = :numGasto "
				+" AND GRG.BORRADO = 0 AND CRA.DD_CRA_CODIGO = '02' "
				);
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeDiccionarioByTipoCampo(String codigoCampo, String valorCampo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoCampo", codigoCampo);
		rawDao.addParams(params);
		String tabla = null;
		String campo = null;
		String resultado = "0";
		
		campo = rawDao.getExecuteSQL("SELECT CCS.DD_CCS_CAMPO "
					+ "		 FROM DD_CCS_CAMPOS_CONV_SAREB CCS"
					+ "      JOIN DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS "
					+ "      ON COS.DD_COS_ID = CCS.DD_COS_ID "
					+ "      WHERE COS.DD_COS_CODIGO = :codigoCampo"
					+ "		 AND CCS.BORRADO = 0 AND ROWNUM <=1");
		if (campo != null) 
		rawDao.addParams(params);
		tabla = rawDao.getExecuteSQL("SELECT CCS.DD_CCS_TABLA "
					+ "		 FROM DD_CCS_CAMPOS_CONV_SAREB CCS"
					+ "      JOIN DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS "
					+ "      ON COS.DD_COS_ID = CCS.DD_COS_ID "
					+ "      WHERE COS.DD_COS_CODIGO = :codigoCampo"
					+ "		 AND CCS.BORRADO = 0 AND ROWNUM <=1");
		
		if (tabla != null)
		params = new HashMap<String, Object>();
		params.put("valorCampo", valorCampo);
		rawDao.addParams(params);
		resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
					+ "		 FROM "+ tabla +" WHERE"
					+ "		 "+ campo +" = :valorCampo "
					+ "		 AND BORRADO = 0");
			


		return !"0".equals(resultado);
		 
	}
	
	@Override
	public String getCodigoTipoDato(String codigoCampo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoCampo", codigoCampo);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT CTD.DD_CTD_CODIGO "
				+ "		 FROM DD_CTD_CAMPO_TIPO_DATO CTD"
				+ "      JOIN DD_CCS_CAMPOS_CONV_SAREB CCS "
				+ "      ON CTD.DD_CTD_ID  = CCS.DD_CTD_ID  "
				+ "      JOIN DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS "
				+ "      ON COS.DD_COS_ID = CCS.DD_COS_ID "
				+ "      WHERE COS.DD_COS_CODIGO = :codigoCampo"
				+ "		 AND CTD.BORRADO = 0 AND ROWNUM <=1" );


		if (resultado == null)
			resultado = "";
	return resultado;
		
	}

	@Override
	public Boolean esGastoRefacturadoHijo(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM GRG_REFACTURACION_GASTOS "
				+" WHERE GRG_GPV_ID_REFACTURADO = (SELECT GPV_ID FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = :numGasto) ");
		
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean estaPerimetroHaya(String activoId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activoId", activoId);
		rawDao.addParams(params);
		
		if (activoId == null || !StringUtils.isNumeric(activoId)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT act_pac_perimetro_activo.pac_incluido "
												+"from rem01.act_pac_perimetro_activo"
												+"		WHERE act_id = :activoId"
				);
		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeActivoPorId(String activoId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activoId", activoId);
		rawDao.addParams(params);
		
		if(Checks.esNulo(activoId) || !StringUtils.isNumeric(activoId))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_ACTIVO WHERE"
				+ "		 	ACT_ID = :activoId "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean gastoEstadoIncompletoPendienteAutorizado(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numGasto) || !StringUtils.isNumeric(numGasto))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = :numGasto "
				+ "AND DD_EGA_ID IN (SELECT DD_EGA_ID FROM DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO IN('01','12', '02','08'))");

		return !"0".equals(resultado);
	}
	
	@Override
    public Boolean existeTipoGastoByCod(String codigo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		rawDao.addParams(params);
		
	    if(Checks.esNulo(codigo)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM DD_TGA_TIPOS_GASTO WHERE"
	                    + "              DD_TGA_CODIGO =  :codigo "
	                    + "      AND BORRADO = 0"
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean existeDestinatarioByCod(String codigo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		rawDao.addParams(params);
		
	    if(Checks.esNulo(codigo)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM DD_DEG_DESTINATARIOS_GASTO WHERE"
	                    + "              DD_DEG_CODIGO = :codigo"
	                    + "      AND BORRADO = 0"
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean existeTipoOperacionGastoByCod(String codigo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		rawDao.addParams(params);
		
	    if(Checks.esNulo(codigo)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM DD_TOG_TIPO_OPERACION_GASTO WHERE"
	                    + "              DD_TOG_CODIGO = :codigo "
	                    + "      AND BORRADO = 0"
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean existeTipoRecargoByCod(String codigo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		rawDao.addParams(params);
		
	    if(Checks.esNulo(codigo)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM DD_TRG_TIPO_RECARGO_GASTO WHERE"
	                    + "              DD_TRG_CODIGO = :codigo "
	                    + "      AND BORRADO = 0"
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean existeTipoElementoByCod(String codigo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigo", codigo);
		rawDao.addParams(params);
		
	    if(Checks.esNulo(codigo)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM DD_ENT_ENTIDAD_GASTO WHERE"
	                    + "              DD_ENT_CODIGO = :codigo"
	                    + "      AND BORRADO = 0"
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean subtipoPerteneceATipoGasto(String tipoGasto, String subtipoGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tipoGasto", tipoGasto);
		params.put("subtipoGasto", subtipoGasto);
		rawDao.addParams(params);

	    if(Checks.esNulo(tipoGasto) && Checks.esNulo(subtipoGasto)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM DD_TGA_TIPOS_GASTO TGA "
	                    + "				 JOIN DD_STG_SUBTIPOS_GASTO STG ON TGA.DD_TGA_ID = STG.DD_TGA_ID"
	                    + "				 WHERE TGA.DD_TGA_CODIGO like :tipoGasto AND STG.DD_STG_CODIGO like :subtipoGasto"
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean esPropietarioDeCarteraByCodigo(String docIdentificadorPropietario, String cartera) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("docIdentificadorPropietario", docIdentificadorPropietario);
		params.put("cartera", cartera);
		rawDao.addParams(params);
		
	    if(Checks.esNulo(docIdentificadorPropietario) && Checks.esNulo(cartera)) {
            return false;
	    }
	
	    String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
	                    + "              FROM ACT_PRO_PROPIETARIO PRO "
	                    + "				 JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID"
	                    + "				 WHERE PRO.PRO_DOCIDENTIF LIKE  :docIdentificadorPropietario  AND CRA.DD_CRA_CODIGO LIKE :cartera "
	                    );
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean esGastoYActivoMismoPropietario(String docIdentificadorPropietario, String numElemento, String tipoElemento) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("docIdentificadorPropietario", docIdentificadorPropietario);
		params.put("numElemento", numElemento);
		params.put("tipoElemento", tipoElemento);
		rawDao.addParams(params);
		
	    if(Checks.esNulo(docIdentificadorPropietario) && Checks.esNulo(numElemento) && Checks.esNulo(tipoElemento)) {
            return false;
	    }
	    
	    String resultado = rawDao.getExecuteSQL("WITH GENERICO AS ( \n" + 
	    		"    SELECT COUNT(1) ES_GEN \n" + 
	    		"    FROM REM01.DD_ENT_ENTIDAD_GASTO \n" + 
	    		"    WHERE DD_ENT_CODIGO = 'GEN' \n" + 
	    		"        AND 'GEN' = :tipoElemento \n" + 
	    		"), ACTIVO AS ( \n" + 
	    		"    SELECT COUNT(1) ES_ACT \n" + 
	    		"    FROM REM01.DD_ENT_ENTIDAD_GASTO \n" + 
	    		"    WHERE DD_ENT_CODIGO = 'ACT' \n" + 
	    		"        AND 'ACT' = :tipoElemento \n" + 
	    		"), PAC AS ( \n" + 
	    		"    SELECT PAC.PRO_ID \n" + 
	    		"    FROM REM01.ACT_ACTIVO ACT \n" + 
	    		"    JOIN REM01.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID \n" + 
	    		"        AND PAC.BORRADO = 0 \n" + 
	    		"    JOIN ACTIVO ON ACTIVO.ES_ACT = 1 \n" + 
	    		"    WHERE ACT.BORRADO = 0 \n" + 
	    		"        AND ACT.ACT_NUM_ACTIVO = :numElemento \n" + 
	    		"), AGS AS ( \n" + 
	    		"    SELECT AGS.PRO_ID\n" + 
	    		"    FROM REM01.ACT_AGS_ACTIVO_GENERICO_STG AGS \n" + 
	    		"    JOIN GENERICO ON GENERICO.ES_GEN = 1 \n" + 
	    		"    WHERE AGS.BORRADO = 0 \n" + 
	    		"        AND AGS.AGS_ACTIVO_GENERICO = :numElemento \n" + 
	    		") \n" + 
	    		"SELECT COUNT(DISTINCT PRO.PRO_ID) \n" + 
	    		"FROM REM01.ACT_PRO_PROPIETARIO PRO \n" + 
	    		"WHERE PRO.BORRADO = 0 \n" + 
	    		"    AND PRO.PRO_DOCIDENTIF = :docIdentificadorPropietario \n" + 
	    		"    AND (EXISTS ( \n" + 
	    		"        SELECT 1 \n" + 
	    		"        FROM PAC \n" + 
	    		"        WHERE PAC.PRO_ID = PRO.PRO_ID \n" + 
	    		"        ) OR EXISTS ( \n" + 
	    		"        SELECT 1 \n" + 
	    		"        FROM AGS \n" + 
	    		"        WHERE AGS.PRO_ID = PRO.PRO_ID \n" + 
	    		"        ) \n" + 
	    		"    )");
	    
	    return !"0".equals(resultado);
    }
	
	@Override
    public Boolean esGastoYAgrupacionMismoPropietario(String docIdentificadorPropietario, String numAgrupacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("docIdentificadorPropietario", docIdentificadorPropietario);
		rawDao.addParams(params);
		
	    if(Checks.esNulo(docIdentificadorPropietario) && Checks.esNulo(numAgrupacion)) {
            return false;
	    }
	
	    String carteraGasto = rawDao.getExecuteSQL("SELECT APRO.PRO_ID FROM ACT_PRO_PROPIETARIO APRO " + 
				"         WHERE APRO.pro_docidentif = :docIdentificadorPropietario AND  APRO.BORRADO = 0 ");
		
		String carteraAgrupacion = null;
		params = new HashMap<String, Object>();
		params.put("numAgrupacion", numAgrupacion);
		rawDao.addParams(params);
		String masDeUnaCartera = rawDao.getExecuteSQL("SELECT count(*) FROM (SELECT DISTINCT PACT.PRO_ID   " + 
				"		FROM ACT_PAC_PROPIETARIO_ACTIVO PACT " + 
				"		WHERE EXISTS ( " + 
				"		   SELECT 1 " + 
				"		   FROM ACT_AGR_AGRUPACION AGR " + 
				"		   JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " + 
				"		   WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion " + 
				"		       AND AGA.ACT_ID  = PACT.ACT_ID " + 
				"		       AND AGR.BORRADO = 0 " + 
				"		       AND AGR.AGR_FECHA_BAJA IS NULL " + 
				"		))");
		
		if("1".equals(masDeUnaCartera)) {
			rawDao.addParams(params);
			carteraAgrupacion = rawDao.getExecuteSQL("SELECT DISTINCT PACT.PRO_ID " + 
					"		FROM ACT_PAC_PROPIETARIO_ACTIVO PACT " + 
					"		WHERE EXISTS ( " + 
					"		   SELECT 1 " + 
					"		   FROM ACT_AGR_AGRUPACION AGR " + 
					"		   JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID " + 
					"		   WHERE AGR.AGR_NUM_AGRUP_REM = :numAgrupacion " + 
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
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("emisorNIF", emisorNIF);
		rawDao.addParams(params);
		
		if(Checks.esNulo(emisorNIF)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PVE_PROVEEDOR WHERE"
				+ "		 	PVE_DOCIDENTIF = :emisorNIF "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeCodProveedorRem(String codProveedorREM) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codProveedorREM", codProveedorREM);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codProveedorREM) || !StringUtils.isNumeric(codProveedorREM)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ACT_PVE_PROVEEDOR WHERE"
				+ "		 	PVE_COD_REM = :codProveedorREM "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existePoblacionByDescripcion(String codigoPoblacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codigoPoblacion", codigoPoblacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codigoPoblacion)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		 FROM ${master.schema}.DD_LOC_localidad WHERE"
				+ "		 DD_LOC_CODIGO = :codigoPoblacion "
				+ "		 AND BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean estaPerimetroAdmision(String activoId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activoId", activoId);
		rawDao.addParams(params);
		
		if (activoId == null || !StringUtils.isNumeric(activoId)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT act_pac_perimetro_activo.pac_check_admision "
												+"from rem01.act_pac_perimetro_activo"
												+"		WHERE act_id =  :activoId "
				);
		return !"0".equals(resultado);
	}

	@Override
	public Boolean comprobarCodigoTipoTitulo(String codTipoTitulo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codTipoTitulo", codTipoTitulo);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM DD_TTC_TIPO_TITULO_COMPLEM WHERE"
				+ "		 	DD_TTC_CODIGO = :codTipoTitulo  "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}

	
	
	
	@Override
	public Boolean existeActivoParaCMBBVA(String codCampo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codCampo", codCampo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codCampo) || !StringUtils.isNumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM REM01.ACT_ACTIVO "
						+ "WHERE ACT_NUM_ACTIVO = :codCampo AND BORRADO = 0 "
		);
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean activoesDeCarteraCerberusBbvaCMBBVA(String codCampo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codCampo", codCampo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codCampo) || !StringUtils.isNumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM REM01.ACT_ACTIVO "
						+ "WHERE ACT_NUM_ACTIVO = :codCampo AND DD_CRA_ID IN ('162','42') AND BORRADO = 0 "
		);
		
		return !"0".equals(resultado);
	}
	
	
	@Override
	public Boolean esActivoVendidoParaCMBBVA(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(act.act_id) "
				+ "			FROM rem01.DD_SCM_SITUACION_COMERCIAL scm, "
				+ "			  REM01.ACT_ACTIVO act "
				+ "			WHERE scm.dd_scm_id   = act.dd_scm_id "
				+ "			  AND scm.dd_scm_codigo = '05' "
				+ "			  AND act.ACT_NUM_ACTIVO = :numActivo "
				+ "			  AND act.borrado       = 0");
		return !"0".equals(resultado);
	}

	
	@Override
	public Boolean esActivoIncluidoPerimetroParaCMBBVA(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT count(act.ACT_ID)"
				+ "		FROM REM01.ACT_ACTIVO act "
				+ "		LEFT JOIN REM01.ACT_PAC_PERIMETRO_ACTIVO pac "
				+ "		ON act.ACT_ID            = pac.ACT_ID "
				+ "		WHERE "
				+ "		(pac.PAC_INCLUIDO = 1 or pac.PAC_ID is null)"
				+ "		AND act.ACT_NUM_ACTIVO = :numActivo ");
		return !Checks.esNulo(resultado);
	}
	
	@Override
	public Boolean esActivoRepetidoNumActivoBBVA(String numActivo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "			FROM REM01.ACT_BBVA_ACTIVOS act "
				+ "			WHERE act.BBVA_NUM_ACTIVO = :numActivo "
				+ "			  AND act.borrado       = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean codigoComercializacionIncorrecto(String codCampo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codCampo", codCampo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(codCampo) || !StringUtils.isAlphanumeric(codCampo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) FROM REM01.DD_TCO_TIPO_COMERCIALIZACION "
						+ "WHERE DD_TCO_CODIGO = :codCampo AND DD_TCO_CODIGO <> '04' AND BORRADO = 0 "
		);
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esOfertaBBVA(String numOferta) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numOferta", numOferta);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numOferta) || !StringUtils.isNumeric(numOferta)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS OFR "
				+ "JOIN ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID "
				+ "JOIN DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID "
				+ "WHERE OFR_NUM_OFERTA = :numOferta "
				+ "AND DD_CRA_CODIGO = '16' "
				+ "AND OFR.BORRADO = 0");
		return !"0".equals(resultado);
	}

	public Boolean esOfertaCaixa(String numOferta) {
		if (Checks.esNulo(numOferta) || !StringUtils.isNumeric(numOferta)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS OFR "
				+ "JOIN ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID "
				+ "JOIN DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID "
				+ "WHERE OFR_NUM_OFERTA = "+numOferta+" "
				+ "AND DD_CRA_CODIGO = '03' "
				+ "AND OFR.BORRADO = 0");
		return !"0".equals(resultado);
	}

	public boolean esClienteEnOfertaCaixa(String numCliente) {
		if (Checks.esNulo(numCliente) || !StringUtils.isNumeric(numCliente)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS OFR "
				+ "JOIN ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID "
				+ "JOIN DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID "
				+ "WHERE DD_CRA_CODIGO = '03' "
				+ "AND OFR.CLC_ID = "+numCliente+" "
				+ "AND OFR.BORRADO = 0");
		return !"0".equals(resultado);
	}

	public boolean esProveedorOfertaCaixa(String idProveedor) {
		if (Checks.esNulo(idProveedor) || !StringUtils.isNumeric(idProveedor)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("select COUNT(DISTINCT pve.pve_id) from ofr_ofertas OFR\n" +
				"join eco_expediente_comercial ECO ON ofr.ofr_id = eco.ofr_id\n" +
				"JOIN GCO_GESTOR_ADD_ECO GCO ON gco.eco_id = eco.eco_id\n" +
				"JOIN GEE_GESTOR_ENTIDAD GEE ON gee.gee_id = gco.gee_id\n" +
				"JOIN ACT_PVC_PROVEEDOR_CONTACTO PVC ON pvc.usu_id = gee.usu_id\n" +
				"JOIN ACT_PVE_PROVEEDOR PVE ON pve.pve_id = pvc.pve_id\n" +
				"JOIN ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID\n" +
				"JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID\n" +
				"JOIN DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID\n" +
				"WHERE DD_CRA_CODIGO = '03'\n" +
				"AND pve.pve_id = "+idProveedor+" ");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esOfertaVendida(String numOferta) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numOferta", numOferta);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numOferta) || !StringUtils.isNumeric(numOferta)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS OFR "
				+ "JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID "
				+ "JOIN DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID "
				+ "WHERE OFR_NUM_OFERTA = :numOferta "
				+ "AND EEC.DD_EEC_CODIGO = '08' "
				+ "AND OFR.BORRADO = 0");
		return !"0".equals(resultado);
	}

	@Override
	public Boolean esOfertaAnulada(String numOferta) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numOferta", numOferta);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numOferta) || !StringUtils.isNumeric(numOferta)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS OFR "
				+ "JOIN DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID "
				+ "WHERE OFR_NUM_OFERTA = :numOferta "
				+ "AND EOF.DD_EOF_CODIGO = '02' "
				+ "AND OFR.BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean esOfertaErronea(String numOferta) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numOferta", numOferta);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numOferta) || !StringUtils.isNumeric(numOferta)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM OFR_OFERTAS OFR "
				+ "JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID "
				+" JOIN DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID "
				+ "WHERE OFR_NUM_OFERTA = :numOferta "
				+ "AND EEC.DD_EEC_CODIGO = '10' "
				+ "AND OFR.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeGastoConElIdLinea(String idGasto, String idLinea) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idGasto", idGasto);
		params.put("idLinea", idLinea);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT count(1) " + 
				" FROM gld_gastos_linea_detalle linea " + 
				" JOIN gpv_gastos_proveedor gasto ON gasto.gpv_id = linea.gpv_id AND GASTO.GPV_NUM_GASTO_HAYA = :idGasto "+ 
				" where GLD_ID = :idLinea AND gasto.borrado = 0 AND linea.borrado = 0");

		return !"0".equals(resultado);
	}		



	@Override
	public Boolean gastoRepetido(String factura, String fechaEmision, String nifEmisor, String nifPropietario) {
		String resultado = "0";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("factura", factura);
		params.put("nifEmisor", nifEmisor);
		params.put("nifPropietario", nifPropietario);
		rawDao.addParams(params);
	
			if(factura == null || fechaEmision == null || nifEmisor == null || nifPropietario == null) {
				return false;
			}
		
			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
					+ "		 FROM GPV_GASTOS_PROVEEDOR WHERE "
					+ "		 GPV_REF_EMISOR = :factura"
					+ " 	 AND "
					+ "		 PVE_ID_EMISOR IN "
					+ "		 (SELECT PVE_ID FROM ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = :nifEmisor AND BORRADO = 0 AND PVE_FECHA_BAJA IS NULL) AND "
					+ " 	 PRO_ID IN (SELECT PRO_ID FROM ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = :nifPropietario AND BORRADO = 0) "
					+ "		 AND BORRADO = 0");

			return !"0".equals(resultado);
	}

	
	@Override
	public Boolean existeTrabajoByCodigo(String codTrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codTrabajo", codTrabajo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codTrabajo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ "		FROM DD_TTR_TIPO_TRABAJO TTR " 
				+ "		WHERE ttr.dd_ttr_codigo = :codTrabajo"
				+ "		AND TTR.BORRADO = 0");

		return !"0".equals(resultado);
	}

		

	@Override
	public Boolean existePromocionBBVA(String promocion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("promocion", promocion);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) FROM ACT_BBVA_ACTIVOS "
				+ "WHERE bbva_cod_promocion = :promocion");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean propietarioPerteneceCartera(String docIdent , List<String> listaCodigoCarteras) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("docIdent", docIdent);
		params.put("listaCodigoCarteras", listaCodigoCarteras);
		rawDao.addParams(params);
		
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
				+ "			WHERE PRO.PRO_DOCIDENTIF = :docIdent "
				+ "		 	AND CRA.BORRADO = 0 AND PRO.BORRADO = 0");
		return !"0".equals(resultado);
		
	}


	@Override
	public boolean conEstadoGasto(String idGasto,String codigoEstado) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idGasto", idGasto);
		params.put("codigoEstado", codigoEstado);
		rawDao.addParams(params);

		if(Checks.esNulo(idGasto) || Checks.esNulo(codigoEstado) || !StringUtils.isNumeric(idGasto) ) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "FROM GPV_GASTOS_PROVEEDOR GASTOS "
				+ "JOIN DD_EGA_ESTADOS_GASTO DD on GASTOS.DD_EGA_ID = DD.DD_EGA_ID "
				+ "WHERE GASTOS.GPV_NUM_GASTO_HAYA = :idGasto "
				+ "AND DD.DD_EGA_CODIGO = :codigoEstado "
				+ "AND GASTOS.BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public String getDocIdentfPropietarioByNumGasto(String numGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numGasto)) {
			return null;
		}
	
		
		String resultado = rawDao.getExecuteSQL("SELECT pro_docidentif "
				+ "		 	FROM ACT_PRO_PROPIETARIO PRO JOIN"
				+ "		 	GPV_GASTOS_PROVEEDOR GPV ON GPV.PRO_ID = PRO.PRO_ID AND GPV.GPV_NUM_GASTO_HAYA = :numGasto"
				+ "		 	AND GPV.BORRADO = 0 AND PRO.BORRADO = 0");

		return resultado;
	}
		
	
	@Override
	public String devolverEstadoGasto(String idGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idGasto", idGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(idGasto)) {
			return null;
		}
		String resultado = rawDao.getExecuteSQL("SELECT DD.DD_EGA_CODIGO "
				+ "FROM GPV_GASTOS_PROVEEDOR GASTOS "
				+ "JOIN DD_EGA_ESTADOS_GASTO DD on GASTOS.DD_EGA_ID = DD.DD_EGA_ID "
				+ "WHERE GASTOS.GPV_NUM_GASTO_HAYA = :idGasto "
				+ "AND GASTOS.BORRADO = 0 AND DD.BORRADO = 0");
		
		return resultado;
	}
	
	@Override
	public String devolverEstadoGastoApartirDePrefactura(String idPrefactura) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idPrefactura", idPrefactura);
		rawDao.addParams(params);
		
		if(Checks.esNulo(idPrefactura)) {
			return null;
		}
		String res = rawDao.getExecuteSQL("SELECT DD.DD_EGA_CODIGO "
				+ "FROM GPV_GASTOS_PROVEEDOR GASTO "
				+ "JOIN PFA_PREFACTURA PFA ON PFA.PFA_ID = GASTO.PFA_ID "
				+ "JOIN DD_EGA_ESTADOS_GASTO DD ON GASTO.DD_EGA_ID = DD.DD_EGA_ID "
				+ "WHERE PFA.PFA_NUM_PREFACTURA = :idPrefactura "
				+ "AND PFA.BORRADO =0 AND DD.BORRADO = 0 AND GASTO.BORRADO = 0"
		);
		
		return res;
	}
	
	@Override
	public String devolverEstadoGastoApartirDeAlbaran(String idAlbaran) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idAlbaran", idAlbaran);
		rawDao.addParams(params);
		
		if(Checks.esNulo(idAlbaran)) {
			return null;
		}
		String res = rawDao.getExecuteSQL("SELECT DD.DD_EGA_CODIGO "
				+ "FROM GPV_GASTOS_PROVEEDOR GASTO "
				+ "JOIN PFA_PREFACTURA PFA ON PFA.PFA_ID = GASTO.PFA_ID "
				+ "JOIN ALB_ALBARAN ALB ON PFA.ALB_ID = ALB.ALB_ID "
				+ "JOIN DD_EGA_ESTADOS_GASTO DD ON GASTO.DD_EGA_ID = DD.DD_EGA_ID "
				+ "WHERE ALB.ALB_NUM_ALBARAN = :idAlbaran "
				+ "AND ALB.BORRADO = 0 AND PFA.BORRADO =0 AND DD.BORRADO = 0 AND GASTO.BORRADO = 0"
		);
		
		return res;
	}
	
	@Override
	public boolean existeTipoRetencion(String tipoRetencion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tipoRetencion", tipoRetencion);
		rawDao.addParams(params);
		
		String res = rawDao.getExecuteSQL("		SELECT COUNT(1) "
				+ "     FROM DD_TRE_TIPO_RETENCION tit			"
				+ "		WHERE tit.BORRADO = 0					"
				+ "		AND tit.DD_TRE_CODIGO = :tipoRetencion "
				);

		return !res.equals("0");
	}

	@Override
	public boolean existeLineaEnGasto(String idLinea, String numGasto){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idLinea", idLinea);
		params.put("numGasto", numGasto);
		rawDao.addParams(params);
		
		String res = rawDao.getExecuteSQL("		SELECT COUNT(1) "
				+ "     FROM gld_gastos_linea_detalle GLD			"
				+ "		JOIN gpv_gastos_proveedor GPV  ON GLD.GPV_ID = GPV.GPV_ID AND GPV.GPV_NUM_GASTO_HAYA = :numGasto "
				+ "		WHERE GPV.BORRADO = 0 AND GLD.BORRADO = 0 AND GLD.GLD_ID = :idLinea "
				);

		return !res.equals("0");
	}


	@Override
	public boolean tieneGastoFechaContabilizado(String idGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idGasto", idGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(idGasto)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "FROM GPV_GASTOS_PROVEEDOR GPV "
				+ "JOIN GIC_GASTOS_INFO_CONTABILIDAD GIC on GPV.GPV_ID = GIC.GPV_ID AND GIC.GIC_FECHA_CONTABILIZACION IS NOT NULL "
				+ "WHERE GPV.GPV_NUM_GASTO_HAYA = :idGasto "
				+ "AND GPV.BORRADO = 0 AND GIC.BORRADO = 0");
		
		return !"0".equals(resultado);
	}
	
	@Override
	public boolean tieneGastoFechaPagado(String idGasto) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idGasto", idGasto);
		rawDao.addParams(params);
		
		if(Checks.esNulo(idGasto)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "FROM GPV_GASTOS_PROVEEDOR GPV "
				+ "JOIN GDE_GASTOS_DETALLE_ECONOMICO GDE on GPV.GPV_ID = GDE.GPV_ID AND GDE.GDE_FECHA_PAGO IS NOT NULL "
				+ "WHERE GPV.GPV_NUM_GASTO_HAYA = :idGasto "
				+ "AND GPV.BORRADO = 0 AND GDE.BORRADO = 0");
		
		
		return !"0".equals(resultado);
	}

	@Override
	public String sacarCodigoSubtipoActivo(String descripcion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("descripcion", descripcion);
		rawDao.addParams(params);

		if (descripcion == null) {
			return null;
		}
		String resultado = rawDao.getExecuteSQL("SELECT SAC.DD_SAC_CODIGO " 
				+ "		FROM REM01.DD_SAC_SUBTIPO_ACTIVO SAC" 
				+ "		WHERE SAC.DD_SAC_DESCRIPCION = :descripcion "
				+ "		AND SAC.BORRADO = 0");
		
		return resultado;
	}

	@Override	
	public Boolean existeSubtrabajoByCodigo(String codSubtrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codSubtrabajo", codSubtrabajo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codSubtrabajo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ "		FROM DD_STR_SUBTIPO_TRABAJO STR " 
				+ "		WHERE STR.DD_STR_CODIGO = :codSubtrabajo"
				+ "		AND STR.BORRADO = 0");

		return !"0".equals(resultado);
		
	}
	
	@Override
	public Boolean existeActivoConONMarcadoSi(String columnaActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("columnaActivo", columnaActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(columnaActivo)) {
			return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		 FROM REM01.ACT_ACTIVO ACT  "
				+ "      INNER JOIN REMMASTER.DD_SIN_SINO dd on act.act_ovn_comerc = dd.DD_SIN_ID"
				+"		 WHERE dd.dd_sin_codigo='01' "
				+ "		 AND act.act_num_activo = :columnaActivo "
				+ "		 AND act.BORRADO = 0");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existePorcentajeConstruccion(String porcentajeConstruccion){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("porcentajeConstruccion", porcentajeConstruccion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(porcentajeConstruccion))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "		 FROM ACT_ACTIVO WHERE"
				+ "		 ACT_PORCENTAJE_CONSTRUCCION = :porcentajeConstruccion "
				+ "		 AND BORRADO = 0");
		return "0".equals(resultado);
	}

	@Override
	public Boolean esSubtrabajoByCodTrabajoByCodSubtrabajo(String codTrabajo, String codSubtrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codTrabajo", codTrabajo);
		params.put("codSubtrabajo", codSubtrabajo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(codSubtrabajo) || Checks.esNulo(codTrabajo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ " FROM DD_STR_SUBTIPO_TRABAJO STR " 
				+ " INNER JOIN DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_ID = STR.DD_TTR_ID " 
				+ " WHERE TTR.DD_TTR_CODIGO = :codTrabajo"
				+ " AND STR.DD_STR_CODIGO = :codSubtrabajo"
				+ " AND STR.BORRADO= 0 AND TTR.BORRADO= 0");

		return !"0".equals(resultado);
		
	}
	
	@Override
	public Boolean existeProveedorAndProveedorContacto(String codProveedor, String proveedorContacto) {
		if (Checks.esNulo(codProveedor) || Checks.esNulo(proveedorContacto)) {
			return false;
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codProveedor", Long.parseLong(codProveedor));
		params.put("proveedorContacto", proveedorContacto);
		rawDao.addParams(params);
		
		try {
			String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ "FROM ACT_PVC_PROVEEDOR_CONTACTO PVC " 
				+ "JOIN ACT_PVE_PROVEEDOR PVE ON pve.pve_id = pvc.pve_id AND pve.pve_cod_rem = :codProveedor " 
				+ "JOIN ${master.schema}.USU_USUARIOS USU ON pvc.usu_id = USU.USU_ID AND usu.usu_username = :proveedorContacto");

			return !"0".equals(resultado);
		} catch (NumberFormatException e) {
			return false;

		}

	}

	@Override
	public Boolean esSubtipoTrabajoTomaPosesionPaquete(String subtrabajo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("subtrabajo", subtrabajo);
		rawDao.addParams(params);
		
		if (subtrabajo == null) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ "		FROM DD_STR_SUBTIPO_TRABAJO STR " 
				+ "		WHERE STR.DD_STR_CODIGO = :subtrabajo"
				+ "		AND STR.DD_STR_CODIGO IN ('PAQ','57')"
				+ "		AND STR.BORRADO = 0");

		return "0".equals(resultado);
	}

	@Override
	public Boolean esTarifaEnCarteradelActivo(String codTarifa, String idActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codTarifa", codTarifa);
		params.put("idActivo", idActivo);
		rawDao.addParams(params);

		if (codTarifa == null || idActivo == null) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ " FROM ACT_CFT_CONFIG_TARIFA CFT " 
				+ " JOIN DD_TTF_TIPO_TARIFA TTF ON CFT.DD_TTF_ID = TTF.DD_TTF_ID AND ttf.dd_ttf_codigo = :codTarifa" 
				+ " JOIN ACT_ACTIVO ACT ON ACT.DD_CRA_ID = CFT.DD_CRA_ID AND act.act_num_activo = :idActivo ");

		return !"0".equals(resultado);
	}

	@Override
	public Boolean existeProveedorEnCarteraActivo(String proveedor, String idActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("proveedor", proveedor);
		params.put("idActivo", idActivo);
		rawDao.addParams(params);
		
		if (proveedor == null || idActivo != null) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) " 
				+ " FROM ACT_ETP_ENTIDAD_PROVEEDOR ETP " 
				+ " JOIN ACT_ACTIVO ACT ON act.dd_cra_id = etp.dd_cra_id " 
				+ " JOIN ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = ETP.PVE_ID AND act.act_num_activo = :idActivo " 
				+ " WHERE pve.pve_cod_rem = :proveedor ");

		return "0".equals(resultado);
	}

	@Override
	public Boolean datosRegistralesRepetidos(String refCatastral,String finca, String folio, String libro, String tomo,  String numRegistro, String codigoLocalidad){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("finca", finca);
		params.put("folio", folio);
		params.put("libro", libro);
		params.put("tomo", tomo);
		params.put("numRegistro", numRegistro);
		params.put("codigoLocalidad", codigoLocalidad);
		
		String resultado;
		if(Checks.esNulo(refCatastral)) {
			rawDao.addParams(params);
			resultado = rawDao.getExecuteSQL("SELECT count(1) FROM act_activo act "  
					+ "join BIE_DATOS_REGISTRALES bie on act.bie_id = bie.bie_id and bie.BIE_DREG_TOMO =  :tomo  "
					+ "and bie.BIE_DREG_LIBRO = :libro  and bie.BIE_DREG_FOLIO =  :folio  and bie.BIE_DREG_NUM_FINCA = :finca and bie.bie_dreg_num_registro = :numRegistro "  
					+ "join ${master.schema}.dd_loc_localidad loc on loc.dd_loc_id = bie.dd_loc_id and loc.dd_loc_codigo = :codigoLocalidad");
		}else {
			params.put("refCatastral", refCatastral);
			rawDao.addParams(params);
			resultado = rawDao.getExecuteSQL("SELECT count(1) FROM act_activo act "  
				+ "join BIE_DATOS_REGISTRALES bie on act.bie_id = bie.bie_id and bie.BIE_DREG_TOMO =  :tomo  "
				+ "and bie.BIE_DREG_LIBRO =  :libro  and bie.BIE_DREG_FOLIO =  :folio  and bie.BIE_DREG_NUM_FINCA =  :finca  and bie.bie_dreg_num_registro = :numRegistro "  
				+ "join ACT_CAT_CATASTRO cat on act.act_id = cat.act_id and cat.cat_ref_catastral =  :refCatastral "  
				+ "join ${master.schema}.dd_loc_localidad loc on loc.dd_loc_id = bie.dd_loc_id and loc.dd_loc_codigo = :codigoLocalidad");
		
		}
		return !"0".equals(resultado);
	}

	@Override
	public Boolean subtipoPerteneceTipoActivo(String subtipo, String tipo){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("subtipo", subtipo);
		params.put("tipo", tipo);
		rawDao.addParams(params);

		String resultado;

		if(!Checks.esNulo(tipo) && !Checks.esNulo(subtipo)){
			resultado = rawDao.getExecuteSQL("SELECT COUNT(1) FROM DD_SAC_SUBTIPO_ACTIVO sac "
			+ "JOIN dd_tpa_tipo_activo tpa ON sac.DD_TPA_ID = tpa.DD_TPA_ID AND TPA.DD_TPA_CODIGO = :tipo "
			+ "WHERE sac.DD_SAC_CODIGO = :subtipo");
	
			return (Integer.valueOf(resultado) > 0);
		}
		
		return false;
	}
	
	public String getNumActivoPrincipal(String numAgr) {
		String resultado = null;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAgr", numAgr);
		rawDao.addParams(params);
		
		if(numAgr != null && !numAgr.isEmpty())
		resultado = rawDao.getExecuteSQL("SELECT ACT_NUM_ACTIVO FROM ACT_ACTIVO ACT "
				+ "JOIN ACT_AGR_AGRUPACION AGR ON AGR_ACT_PRINCIPAL = ACT_ID "
				+ "WHERE AGR_NUM_AGRUP_REM = :numAgr AND AGR.BORRADO = 0");
		
		
		if(resultado == null)
			return "";
		else
		return resultado;
	}
	
	public boolean getExcluirValidaciones(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		String resultado = null;
		
		if(numActivo != null && !numActivo.isEmpty())
		resultado = rawDao.getExecuteSQL("SELECT DD_SIN_CODIGO FROM ACT_PAC_PERIMETRO_ACTIVO PAC "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID "
				+ "JOIN ${master.schema}.DD_SIN_SINO DD ON DD.DD_SIN_ID = PAC.PAC_EXCLUIR_VALIDACIONES "
				+ "WHERE ACT_NUM_ACTIVO = :numActivo AND PAC.BORRADO = 0");
		
		if(resultado == null || DDSiNo.NO.equals(resultado) ) {
			return false;
		}
		return true;
			

	}
	
	public String getCheckGestorComercial(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		String resultado = null;
		
		if(numActivo != null && !numActivo.isEmpty())
		resultado = rawDao.getExecuteSQL("SELECT PAC_CHECK_GESTION_COMERCIAL FROM ACT_PAC_PERIMETRO_ACTIVO PAC "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID "
				+ "WHERE ACT_NUM_ACTIVO = :numActivo AND PAC.BORRADO = 0");
		
		if(resultado == null)
			return "0";
		else
		return resultado;
	}
	
	public String getMotivoGestionComercial(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		String resultado = null;
		
		if(numActivo != null && !numActivo.isEmpty())
		resultado = rawDao.getExecuteSQL("SELECT PAC_MOTIVO_GESTION_COMERCIAL FROM ACT_PAC_PERIMETRO_ACTIVO PAC "
				+ "JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID "
				+ "WHERE ACT_NUM_ACTIVO = :numActivo AND PAC.BORRADO = 0");
		
		if(resultado == null)
			return "";
		else
		return resultado;
	}
	
	

	@Override
	public Boolean existeAlbaran(String idAlbaran) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idAlbaran", idAlbaran);
		rawDao.addParams(params);
		
		if(Checks.esNulo(idAlbaran) || !StringUtils.isNumeric(idAlbaran))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM ALB_ALBARAN WHERE"
				+ "		 	ALB_NUM_ALBARAN =  :idAlbaran  "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existePrefactura(String idPrefactura) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idPrefactura", idPrefactura);
		rawDao.addParams(params);
		
		if(Checks.esNulo(idPrefactura) || !StringUtils.isNumeric(idPrefactura))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM PFA_PREFACTURA WHERE"
				+ "		 	PFA_NUM_PREFACTURA = :idPrefactura "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public List<String> getIdPrefacturasByNumAlbaran(String numAlbaran) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numAlbaran", numAlbaran);
		rawDao.addParams(params);
		
		List<Object> resultados = rawDao.getExecuteSQLList("SELECT PFA.PFA_NUM_PREFACTURA FROM ALB_ALBARAN ALB "
				+ "JOIN PFA_PREFACTURA PFA ON PFA.ALB_ID = ALB.ALB_ID "
				+ "WHERE ALB.ALB_NUM_ALBARAN = :numAlbaran "
				+ "AND ALB.BORRADO =0 AND PFA.BORRADO =0");
		
		List<String> listaString = new ArrayList<String>();
		
		for (Object valor : resultados) {
			listaString.add(valor.toString());
		}

		return listaString;
	}
	
	@Override
	public Boolean getGastoSuplidoConFactura(String idGastoAfectado) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idGastoAfectado", idGastoAfectado);
		rawDao.addParams(params);
		
		if(Checks.esNulo(idGastoAfectado)){
			return false;
			}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "FROM GPV_GASTOS_PROVEEDOR GPV WHERE "
				+ "GPV.gpv_num_gasto_haya = :idGastoAfectado "
				+ "AND (GPV.gpv_suplidos_vinculados = '1' "
				+ "OR GPV.gpv_numero_factura_ppal IS NOT NULL) "
				+ "AND GPV.BORRADO = 0");
		return !"0".equals(resultado);
	}
	@Override
	public Boolean esSubCarterasCerberusAppleDivarian (String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if (Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo)) return false;
		String resultado = rawDao.getExecuteSQL(
				"SELECT COUNT(1) " + 
				"FROM act_activo act " + 
				"INNER JOIN dd_scr_subcartera scr ON scr.dd_scr_id = act.dd_scr_id AND dd_scr_codigo IN ('138','151','152') " + 
				"WHERE act.act_num_activo =  :numActivo  AND act.borrado = 0"
				);
		return !"0".equals(resultado);
	}

	
	public Boolean isActivoEnPerimetroAlquilerSocial(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT count(1)   " + 
				"				 FROM ACT_PTA_PATRIMONIO_ACTIVO pta    " + 
				"				INNER JOIN ACT_ACTIVO act ON act.ACT_ID = pta.ACT_ID " + 
				"                INNER JOIN DD_TAL_TIPO_ALQUILER dd ON  dd.dd_tal_id = act.dd_tal_id " + 
				"				WHERE act.act_num_activo = :numActivo " + 
				"                AND dd.dd_tal_codigo = '03' " + 
				"                AND ACT.borrado = 0 " + 
				"                AND pta.borrado = 0");
		return !"0".equals(resultado); 
	}

	@Override
	public Boolean situacionComercialPublicadoAlquiler(String activo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activo", activo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(activo) || !StringUtils.isNumeric(activo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_ACTIVO a "
				+ "JOIN act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 "
				+ "JOIN dd_epa_estado_pub_alquiler epa ON apu.DD_EPA_ID = epa.DD_EPA_ID AND epa.borrado = 0 "
				+ "WHERE a.ACT_NUM_ACTIVO = :activo AND epa.DD_EPA_CODIGO = '03' AND a.borrado = 0 ");


		return "1".equals(resultado);
	}
	

	public Boolean estadoPublicacionCajamarPerteneceVPOYDistintoPublicado(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT COUNT (1) FROM ACT_ACTIVO ACT " + 
				" INNER JOIN ACT_APU_ACTIVO_PUBLICACION APU on act.act_id = apu.act_id " + 
				" INNER JOIN DD_EPA_ESTADO_PUB_ALQUILER  est on est.dd_epa_id = apu.dd_efuncionpa_id " + 
				" INNER JOIN dd_cra_cartera car on car.dd_cra_id = act.dd_cra_id " +
				" INNER JOIN dd_tco_tipo_comercializacion tpo on tpo.dd_tco_id = apu.dd_tco_id" +
				" WHERE act.act_num_activo = :numActivo" + 
				" and est.dd_epa_codigo <> '03' " +
				" and car.dd_cra_codigo = '01' " +
				" and act.act_vpo = '0' " + 
				" and tpo.dd_tco_codigo = '03' " +
				" and act.borrado = 0 ");

		return "1".equals(resultado);
	}

	@Override
	public Boolean situacionComercialAlquilado(String activo) {
		// TODO Auto-generated method stub
		return null;
	}

	public Boolean activoPerteneceAgrupacion (String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL (" SELECT COUNT(1) FROM  REM01.ACT_AGA_AGRUPACION_ACTIVO aga, "+ 
			    " REM01.ACT_AGR_AGRUPACION agr, "+
			    " REM01.ACT_ACTIVO act WHERE aga.AGR_ID = agr.AGR_ID "+
				   " AND act.act_id  = aga.act_id " +
                   " AND act.ACT_NUM_ACTIVO = :numActivo" + 
                   " AND (agr.AGR_FECHA_BAJA is null OR agr.AGR_FECHA_BAJA  > SYSDATE) "+
                   " AND aga.BORRADO  = 0 "+
                   " AND agr.BORRADO  = 0 "+
                   " AND act.BORRADO  = 0 ");
		return "1".equals(resultado);
	}
	
	public Boolean activoBBVAPerteneceSociedadParticipada (String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo) || !StringUtils.isNumeric(numActivo))
			return false;
		String resultado = rawDao.getExecuteSQL ("SELECT COUNT(1) FROM REM01.ACT_ACTIVO act " + 
				" JOIN REM01.ACT_PAC_PROPIETARIO_ACTIVO pac ON ACT.ACT_ID = pac.act_id " + 
				" JOIN REM01.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = pac.PRO_ID " + 
				" JOIN REM01.ACT_APU_ACTIVO_PUBLICACION PUBLI ON publi.act_id = act.act_id " + 
				" JOIN REM01.DD_EPA_ESTADO_PUB_ALQUILER ALQUILER ON alquiler.dd_epa_id = publi.dd_epa_id " + 
				" JOIN REM01.DD_EPV_ESTADO_PUB_VENTA VENTA ON venta.dd_epv_id = publi.dd_epv_id " + 
				" JOIN REM01.DD_CRA_CARTERA cra ON act.DD_CRA_ID = cra.DD_CRA_ID and cra.dd_cra_codigo = '16' " + 
				" WHERE (ALQUILER.DD_EPA_CODIGO = '01' OR VENTA.DD_EPV_CODIGO = '01') " + 
				" AND PRO.PRO_DOCIDENTIF IN ('B63442974','B11819935','B39488549','A83827907') " + 
				" AND act.ACT_NUM_ACTIVO = :numActivo");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean situacionComercialPublicadoAlquilerOVenta(String activo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activo", activo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(activo) || !StringUtils.isNumeric(activo))
			return false;
		String resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ACT_ACTIVO a "
				+ "JOIN act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 "
				+ "JOIN dd_epa_estado_pub_alquiler epa ON apu.DD_EPA_ID = epa.DD_EPA_ID AND epa.borrado = 0 "
				+ "JOIN dd_epv_estado_pub_venta epv ON apu.DD_EPV_ID = epv.DD_EPV_ID AND epv.borrado = 0 "
				+ "WHERE a.ACT_NUM_ACTIVO = :activo AND (epa.DD_EPA_CODIGO = '03' OR epv.DD_EPV_CODIGO = '03')AND a.borrado = 0 ");


		return "1".equals(resultado);
	}
	
	@Override
	public boolean userHasFunction (String funcion, Long idUsuario) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("funcion", funcion);
		params.put("idUsuario", idUsuario);
		rawDao.addParams(params);
		
		if(Checks.esNulo(idUsuario) || Checks.esNulo(funcion)  )
			return false;
		String resultado = rawDao.getExecuteSQL("select count(1) " + 
				" from remmaster.usu_usuarios usu " + 
				" inner join rem01.zon_pef_usu zonpefusu on usu.usu_id = zonpefusu.usu_id " + 
				" inner join rem01.pef_perfiles pef on pef.pef_id = zonpefusu.pef_id " + 
				" inner join fun_pef funpef on funpef.pef_id=pef.pef_id " + 
				" inner join REMMASTER.fun_funciones fun on fun.fun_id = funpef.fun_id " + 
				" where fun.fun_descripcion= :funcion" + 
				" and usu.borrado = 0 " + 
				" and pef.borrado = 0 " + 
				" and funpef.borrado = 0 " + 
				" and zonpefusu.borrado = 0 " + 
				" and usu.usu_id= :idUsuario");
		return "1".equals(resultado);
	}
	
	@Override
	public Boolean isActivoSareb (String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM ACT_ACTIVO ACT "
					+"		WHERE ACT.DD_CRA_ID IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
					+"								WHERE DD_CRA_CODIGO IN ('02')"
					+"								AND BORRADO = 0) "
					+"		AND ACT.ACT_NUM_ACTIVO = :numActivo ");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean isActivoCajamar(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM ACT_ACTIVO ACT "
					+"		WHERE ACT.DD_CRA_ID IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
					+"								WHERE DD_CRA_CODIGO IN ('01')"
					+"								AND BORRADO = 0) "
					+"		AND ACT.ACT_NUM_ACTIVO = :numActivo ");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean validacionSubfasePublicacion (String activo, List<String> codigos) { 
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activo", activo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(activo) || !StringUtils.isNumeric(activo))
			return false;
		
		String where = "";
		for (int i = 0; i < codigos.size(); i++) {
			if(i != 0) {
				where = where + "OR sp.DD_SFP_CODIGO = '"+codigos.get(i)+"' ";
			}else {
				where = where + "sp.DD_SFP_CODIGO = '"+codigos.get(i)+"' ";
			}
		}
		
		String resultado = rawDao.getExecuteSQL ("WITH ultimo AS (SELECT hfp_id,dd_sfp_id\n" + 
				"FROM (SELECT hfp_id,dd_sfp_id\n" + 
				"FROM act_hfp_hist_fases_pub hfp\n" + 
				"JOIN ACT_ACTIVO a ON a.act_id = hfp.act_id AND hfp.borrado = 0 \n" + 
				"WHERE  a.ACT_NUM_ACTIVO = :activo AND a.borrado = 0 \n" + 
				"ORDER BY hfp.hfp_id DESC)\n" + 
				"WHERE ROWNUM = 1)\n" + 
				"\n" + 
				"\n" + 
				"SELECT COUNT(1)\n" + 
				"FROM ultimo u\n" + 
				"JOIN  dd_sfp_subfase_publicacion sp ON u.DD_SFP_ID = sp.DD_SFP_ID \n" + 
				"WHERE sp.borrado = 0 AND( " + where + ")"
			);
		return "0".equals(resultado);
	}

	@Override
	public boolean isConCargasOrCargasEsparta(String activo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activo", activo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(activo) || !StringUtils.isNumeric(activo)) {
			return false;
		}
		String resultado = rawDao.getExecuteSQL ("SELECT count(1) FROM ACT_CRG_CARGAS crg \n" + 
				"join act_activo act on act.act_id = crg.act_id\n" + 
				"left join DD_ECG_ESTADO_CARGA ecg on crg.DD_ECG_ID = ecg.DD_ECG_ID \n" + 
				"where crg.borrado = 0 and act.borrado = 0 and ecg.borrado = 0 and act.act_num_activo = :activo and \n" + 
				"(crg.CRG_OCULTO_CARGA_MASIVA = 1 OR ecg.dd_ecg_codigo = '01' OR ecg.dd_ecg_codigo = '02')"
			);
		return !"0".equals(resultado);
	}
	
	@Override
	public boolean aplicaComercializar(String activo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activo", activo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(activo) || !StringUtils.isNumeric(activo)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL ("SELECT count(1) FROM act_pac_perimetro_activo pac\n" + 
				"join act_activo act on act.act_id = pac.act_id\n" + 
				"where act.act_num_activo = :activo and act.borrado = 0 and pac.borrado = 0 and pac.PAC_CHECK_COMERCIALIZAR = '1'"	
			);
		
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean isActivoAlquiladoSCM(String activo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activo", activo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(activo) || !StringUtils.isNumeric(activo)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL(
				"SELECT * FROM act_activo act \n" + 
				"JOIN dd_scm_situacion_comercial scm on act.dd_scm_id = scm.dd_scm_id \n" + 
				"WHERE act.act_num_activo = :activo AND scm.dd_scm_codigo = '10'");
		
		return !"0".equals(resultado); 
	}
	
	@Override
	public boolean isActivoPublicadoDependiendoSuTipoComercializacion(String activo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activo", activo);
		rawDao.addParams(params);
		
		String resultado = "0";
		
		if(Checks.esNulo(activo) || !StringUtils.isNumeric(activo)) {
			return false;
		}
		
		String tipoComercializacion = rawDao.getExecuteSQL("   SELECT tco.dd_tco_codigo FROM ACT_ACTIVO a \n" + 
				"    JOIN ACT_APU_ACTIVO_PUBLICACION apu ON apu.act_id = a.act_id and apu.borrado = 0 \n" + 
				"    JOIN DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = apu.dd_tco_id and tco.borrado = 0 \n" + 
				"     WHERE a.act_num_activo = :activo AND a.borrado = 0");


		rawDao.addParams(params);
		if(DD_TCO_VENTA.equals(tipoComercializacion)) {
		 resultado = rawDao.getExecuteSQL(
				"SELECT count(1) FROM ACT_ACTIVO a \n" + 
				"    JOIN act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 \n" + 
				"    JOIN dd_epv_estado_pub_venta epv ON apu.DD_EPV_ID = epv.DD_EPV_ID AND epv.borrado = 0\n" + 
				"    WHERE a.act_num_activo = :activo  AND  epv.DD_EPV_CODIGO = '03' AND a.borrado = 0");
		
		}else if(DD_TCO_ALQUILER.equals(tipoComercializacion)) {
		 resultado = rawDao.getExecuteSQL(
				"SELECT count(1) FROM ACT_ACTIVO a \n" + 
				"    JOIN act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 \n" + 
				"    JOIN dd_epa_estado_pub_alquiler epa ON apu.DD_EPA_ID = epa.DD_EPA_ID AND epa.borrado = 0 \n" + 
				"    WHERE a.act_num_activo = :activo  AND  epa.DD_EPA_CODIGO = '03' AND a.borrado = 0");
		
		}else if(DD_TCO_ALQUILER_VENTA.equals(tipoComercializacion)) {
		 resultado = rawDao.getExecuteSQL(
				"SELECT count(1) FROM ACT_ACTIVO a \n" + 
				"    JOIN act_apu_activo_publicacion apu ON a.act_id = apu.act_id AND apu.borrado = 0 \n" + 
				"    JOIN dd_epa_estado_pub_alquiler epa ON apu.DD_EPA_ID = epa.DD_EPA_ID AND epa.borrado = 0 \n" + 
				"    JOIN dd_epv_estado_pub_venta epv ON apu.DD_EPV_ID = epv.DD_EPV_ID AND epv.borrado = 0 \n" + 
				"    WHERE a.act_num_activo = :activo  AND  (epa.DD_EPA_CODIGO = '03' OR epv.DD_EPV_CODIGO = '03') AND a.borrado = 0");
		}
		
		return !"0".equals(resultado);
	}
	
	@Override
	public boolean isActivoDestinoComercialSoloAlquiler(String activo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activo", activo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(activo) || !StringUtils.isNumeric(activo)) {
			return false;
		}
		
		String resultado = rawDao.getExecuteSQL("   SELECT count(1) FROM ACT_ACTIVO a \n" + 
				"    JOIN ACT_APU_ACTIVO_PUBLICACION apu ON apu.act_id = a.act_id and apu.borrado = 0 \n" + 
				"    JOIN DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = apu.dd_tco_id and tco.borrado = 0\n" + 
				"     WHERE a.act_num_activo = :activo AND a.borrado = 0 and tco.dd_tco_codigo = '03'");
		
		return !"0".equals(resultado);
	}

	public Boolean isActivoGestionadoReam(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo)){
			return false;
			}
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
				+ "FROM V_ACTIVOS_GESTIONADOS_REAM ream WHERE "
				+ "ream.ACT_ID IN "
				+ "(SELECT act.act_id FROM act_activo act WHERE act.act_num_activo = :numActivo  "
				+ "AND act.BORRADO = 0)");
		return "1".equals(resultado);
	}
	
	@Override
	public Boolean isActivoCerberus(String numActivo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numActivo", numActivo);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numActivo))
			return false;

			String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
					+"		FROM ACT_ACTIVO ACT "
					+"		WHERE ACT.DD_CRA_ID IN (SELECT DD_CRA_ID FROM DD_CRA_CARTERA "
					+"								WHERE DD_CRA_CODIGO IN ('07')"
					+"								AND BORRADO = 0) "
					+"		AND ACT.ACT_NUM_ACTIVO = :numActivo ");

		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean tieneVigenteFasePublicacionIII(String activo) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("activo", activo);
		rawDao.addParams(params);
		
		String resultado = rawDao.getExecuteSQL("WITH ultimo AS (SELECT hfp_id,dd_fsp_id\n" + 
				"				FROM (SELECT hfp_id,dd_fsp_id\n" + 
				"				FROM act_hfp_hist_fases_pub hfp\n" + 
				"				JOIN ACT_ACTIVO a ON a.act_id = hfp.act_id AND hfp.borrado = 0 \n" + 
				"				WHERE a.act_num_Activo = :activo and  a.borrado = 0 \n" + 
				"				ORDER BY hfp.hfp_id DESC)\n" + 
				"				WHERE ROWNUM = 1)\n" + 
				"				\n" + 
				"				\n" + 
				"				SELECT count(*)\n" + 
				"				FROM ultimo u\n" + 
				"				JOIN  DD_FSP_FASE_PUBLICACION sp ON u.DD_FSP_ID = sp.DD_FSP_ID AND sp.borrado = 0\n" + 
				"				WHERE sp.DD_FSP_CODIGO = '05'");
		return !"0".equals(resultado);
	}
	
	@Override
	public Boolean existeProvision(String numProvision){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numProvision", numProvision);
		rawDao.addParams(params);
		
		if(Checks.esNulo(numProvision) || !StringUtils.isNumeric(numProvision))
			return false;
		
		String resultado = rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		 FROM PRG_PROVISION_GASTOS WHERE"
				+ "		 	PRG_NUM_PROVISION = :numProvision "
				+ "		 	AND BORRADO = 0");
		return !"0".equals(resultado);
	}
	
	@Override
	public List<String> getGastosByNumProvision(String numProvision) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numProvision", numProvision);
		rawDao.addParams(params);
		
		List<Object> resultados = rawDao.getExecuteSQLList("SELECT GPV.GPV_NUM_GASTO_HAYA FROM PRG_PROVISION_GASTOS PRG "
				+ "JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.PRG_ID = PRG.PRG_ID AND GPV.BORRADO = 0 "
				+ "WHERE PRG.PRG_NUM_PROVISION = :numProvision AND PRG.BORRADO = 0");
		
		List<String> listaString = new ArrayList<String>();
		
		for (Object valor : resultados) {
			listaString.add(valor.toString());
		}

		return listaString;
	}

	@Override
    public Boolean existeRecomendacionByCod(String recomendacion) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recomendacion", recomendacion);
		rawDao.addParams(params);
		
		if(Checks.esNulo(recomendacion)) {
				return false;
		}

		String resultado = rawDao.getExecuteSQL("SELECT COUNT(1) "
						+ "              FROM DD_REC_RECOMENDACION_RCDC WHERE"
						+ "              DD_REC_CODIGO = :recomendacion"
						+ "      AND BORRADO = 0"
						);
		return !"0".equals(resultado);
    }
}


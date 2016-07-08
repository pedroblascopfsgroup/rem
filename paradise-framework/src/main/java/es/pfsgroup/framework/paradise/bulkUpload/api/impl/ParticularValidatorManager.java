package es.pfsgroup.framework.paradise.bulkUpload.api.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;

@Service
@Transactional(readOnly = false)
public class ParticularValidatorManager implements ParticularValidatorApi {

	@Autowired
	private MSVRawSQLDao rawDao;
	
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
	public String existeActivoEnAgrupacion(Long idActivo, Long idAgrupacion) {
		return rawDao.getExecuteSQL("SELECT COUNT(*) "
				+ "		  FROM ACT_AGA_AGRUPACION_ACTIVO WHERE"
				+ " 		ACT_ID = "+idActivo+" "
				+ " 		AND AGR_ID = "+idAgrupacion+" "
				+ "			AND BORRADO = 0");
	}
	
	
}

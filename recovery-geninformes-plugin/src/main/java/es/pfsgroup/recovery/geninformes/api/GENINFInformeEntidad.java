package es.pfsgroup.recovery.geninformes.api;

import java.util.List;
import java.util.Map;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.geninformes.dao.GENINFInfoAuxiliarInformeDao;
import es.pfsgroup.recovery.geninformes.model.GENINFInformeConfig;
import es.pfsgroup.recovery.geninformes.model.GENINFParrafo;

public interface GENINFInformeEntidad{

	public final static String KEY_ERROR = "ERROR";

	public Map<String, Object> dameMapaValores(Object objeto,
			List<GENINFParrafo> listaParrafos,
			List<GENINFInformeConfig> listaValoresConfiguracion, 
			GenericABMDao genericDao, Procedimiento proc, GENINFInfoAuxiliarInformeDao infoAuxiliarInformeDao,
			Map<String, Object> mapaValoresPrec);

}

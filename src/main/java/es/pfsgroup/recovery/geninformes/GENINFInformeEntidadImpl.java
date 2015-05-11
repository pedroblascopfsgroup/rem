package es.pfsgroup.recovery.geninformes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.geninformes.api.GENINFInformeEntidad;
import es.pfsgroup.recovery.geninformes.dao.GENINFInfoAuxiliarInformeDao;
import es.pfsgroup.recovery.geninformes.model.GENINFInformeConfig;
import es.pfsgroup.recovery.geninformes.model.GENINFParrafo;

@Component
public class GENINFInformeEntidadImpl implements GENINFInformeEntidad{

	/* 
	 * Implementación vacía. Sólo devuelve los párrafos si existen.
	 */
	@Override
	public Map<String, Object> dameMapaValores(Object objeto,
			List<GENINFParrafo> listaParrafos,
			List<GENINFInformeConfig> listaValoresConfiguracion,
			GenericABMDao genericDao, Procedimiento proc, GENINFInfoAuxiliarInformeDao infoAuxiliarInformeDao,
			Map<String, Object> mapaValoresPrec) {

		Map<String, Object> mapaResultado = new HashMap<String, Object>();
		for (GENINFParrafo parrafo : listaParrafos) {
			mapaResultado.put(parrafo.getCodigo(), parrafo.getContenido());
		}
		return mapaResultado;
	}

}

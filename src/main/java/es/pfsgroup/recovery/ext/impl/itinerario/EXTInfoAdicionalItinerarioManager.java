package es.pfsgroup.recovery.ext.impl.itinerario;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.api.itinerario.EXTInfoAdicionalItinerarioApi;
import es.pfsgroup.recovery.ext.api.itinerario.model.EXTInfoAdicionalItinerarioInfo;
import es.pfsgroup.recovery.ext.impl.itinerario.model.EXTInfoAdicionalItinerario;

@Component
public class EXTInfoAdicionalItinerarioManager implements EXTInfoAdicionalItinerarioApi{
	
	@Autowired
	private GenericABMDao genericDao;

	/**
	 * @param id del itinerario y código del tipo de información que se desea obtener
	 * @return devuelve un objeto que contiene la información adicional encontrada para ese itinerario
	 */
	@Override
	@BusinessOperation(EXT_BO_ITI_GET_INFO_ADD_BYTIPO)
	@Transactional
	public EXTInfoAdicionalItinerarioInfo getInfoAdicionalItinerarioByTipo(
			Long idItinerario, String codigo) {
		EXTInfoAdicionalItinerarioInfo info = null;
		Filter filtroTipoInfo = genericDao.createFilter(FilterType.EQUALS, "tipoInfoAdicional.codigo", codigo);
		Filter filtroItinerario = genericDao.createFilter(FilterType.EQUALS, "itinerario.id", idItinerario);
		info = genericDao.get(EXTInfoAdicionalItinerario.class, filtroTipoInfo, filtroItinerario);
		
		return info;
	}

}

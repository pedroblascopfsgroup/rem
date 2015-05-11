package es.pfsgroup.recovery.recobroCommon.esquema.manager.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroSubCarteraDao;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroSubCarteraApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraAgencia;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonEsquemasConstants;

@Component
public class RecobroSubCarteraManager implements RecobroSubCarteraApi{
	
	@Autowired
	private RecobroSubCarteraDao recobroSubCarteraDao;


	@Autowired
	private GenericABMDao genericDao;
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_BUSCAR_SUBCATERA_BY_ITI_BO)
	public List<RecobroSubCartera> buscaSubCarteraPorItinerario(Long idItinerario){
		
		List listaSubCarteras = recobroSubCarteraDao.getSubCarteraByItinerario(idItinerario);
		
		return listaSubCarteras;
	}

	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_GET_SUBCATERA_BY_ID_BO)
	public RecobroSubCartera getRecobroSubCartera(Long id) {		
		return recobroSubCarteraDao.get(id);
	}

	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_BORRA_SUBCATERA_BO)
	@Transactional(readOnly=false)
	public void borrarSubCartera(Long id) {
		RecobroSubCartera subCartera = recobroSubCarteraDao.get(id);
		
		// Borrar todo el reparto de agencias de la subcartera			
		for (RecobroSubcarteraAgencia subCarAgencia: subCartera.getAgencias()) {
			genericDao.deleteById(RecobroSubcarteraAgencia.class, subCarAgencia.getId());
		}
		recobroSubCarteraDao.deleteById(id);
	}

}

package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.sidhiweb.api.SIDHIIterJudicialApi;
import es.pfsgroup.plugin.recovery.sidhiweb.api.model.SIDHIIterJudicialInfo;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dao.SIDHIAccionJudicialDao;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIDtoBuscarAcciones;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIIterJudicial;

@Component
public class SIDHIIterJudicialManager implements SIDHIIterJudicialApi{
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@Autowired
	SIDHIAccionJudicialDao accionJudicialDao;
	
	
	@Autowired
	Executor executor;

	@Override
	@BusinessOperation(SIDHI_BO_GET_INFO_JUCIAL_ASU)
	public Page getIterJudicialAsunto(
			SIDHIDtoBuscarAcciones dto) {
		EventFactory.onMethodStart(this.getClass());
		
		return accionJudicialDao.findAccionesByIdAsunto(dto);
		
	}

	@Override
	@BusinessOperation(SIDHI_BO_GET_INFO_JUCIAL_EXP)
	public Page getIterJudicialExpediente(
			SIDHIDtoBuscarAcciones dto) {
		EventFactory.onMethodStart(this.getClass());
		
		return accionJudicialDao.findAccionesByIdExpediente(dto);
	}

	@Override
	@BusinessOperation(SIDHI_BO_FIND_ITER_BY_IDEXPEXT)
	public SIDHIIterJudicialInfo findIterByIdExpExt(Long idExpedienteExterno) {
		EventFactory.onMethodStart(this.getClass());
		SIDHIIterJudicial iter = null;
		Filter filtroIdExpExt = genericDao.createFilter(FilterType.EQUALS, "idExpedienteExterno", idExpedienteExterno);
		List<SIDHIIterJudicial> iteres = genericDao.getList(SIDHIIterJudicial.class,filtroIdExpExt);
		if (Checks.estaVacio(iteres)){
			logger.warn("No se ha encontrado ningun iter para ese expediente externo" + idExpedienteExterno);
		}else{
			iter = iteres.get(0);
			if (iteres.size()>1){
				logger.warn("Se ha encontrado más de un iter con ese idExpedienteExterno"+ idExpedienteExterno);
			}
		}
		
		return iter;
		
	}

}

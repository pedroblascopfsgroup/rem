package es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.api.impl;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.HtmlUtils;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.api.AASAnalisisAsuntoApi;
import es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.dao.AASAnalisisAsuntoDao;
import es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.dto.AASDtoAnalisisAsunto;
import es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.model.AASAnalisisAsunto;
import es.pfsgroup.recovery.api.AsuntoApi;

@Service("plugin.analisisAsunto.manager.analisisAsuntoManager")
public class AASAnalisisAsuntoManager implements AASAnalisisAsuntoApi {
		
	@Autowired
	private Executor executor;
	
	@Autowired
	private AASAnalisisAsuntoDao analisisDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	/**
	 * Devuelve la información de analisis de un asunto
	 * @param id ID del asunto
	 * @return
	 */
	@BusinessOperation(BO_ANALISISASUNTO_GETANALISIS)
	public AASAnalisisAsunto getAnalisis(Long id){
		EventFactory.onMethodStart(this.getClass());
		Assertions.assertNotNull(id, "El ID no puede ser NULL");
		AASAnalisisAsunto ret = analisisDao.findByAsunto(id);
		if (!Checks.esNulo(ret)) {
			//ret.setObservacion(HtmlUtils.htmlEscape(ret.getObservacion()));
		}
		return ret;
	}
	
	/**
	 * Guarda la informaci�n de an�lisis de un asunto
	 * @param dto
	 */
	@BusinessOperation(BO_ANALISISASUNTO_GUARDARANALISIS)
	@Transactional(readOnly = false)
	public void guardarAnalisis(AASDtoAnalisisAsunto dto){
		AASAnalisisAsunto aas = getAnalisis(dto.getIdAsunto());
		boolean esnuevo = false;
		
		if (aas == null){
			Asunto asunto =  proxyFactory.proxy(AsuntoApi.class).get(dto.getIdAsunto());
//			(Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET,dto.getIdAsunto());
			
			aas = analisisDao.createNewObject();
			aas.setAsunto(asunto);
			esnuevo = true;
		}
		aas.setObservacion(HtmlUtils.htmlUnescape(dto.getObservaciones()));
		if (esnuevo){
			analisisDao.save(aas);
		}else{
			analisisDao.saveOrUpdate(aas);
		}	
	}	
	
}
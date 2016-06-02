package es.pfsgroup.plugin.recovery.procuradores.despachoExternoPro.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto;
import es.pfsgroup.plugin.recovery.procuradores.despachoExternoPro.api.DespachoExternoProApi;
import es.pfsgroup.plugin.recovery.procuradores.despachoExternoPro.dao.DespachoExternoProDao;

@Service("DespachoExternoPro")
@Transactional(readOnly = false)
public class DespachoExternoProManager implements DespachoExternoProApi {

	@Autowired
	private DespachoExternoProDao despachoExternoProDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_PAGE_DESPACHO_EXTERNO)
	public Page getPageDespachoExterno(CategorizacionDto dto, String nombre){
		return despachoExternoProDao.getPageDespachosExternos(dto, nombre);
	}
}

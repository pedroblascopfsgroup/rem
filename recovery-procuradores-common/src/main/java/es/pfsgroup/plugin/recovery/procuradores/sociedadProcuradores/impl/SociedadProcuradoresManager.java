package es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.Procurador;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.api.SociedadProcuradoresApi;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.dao.SociedadProcuradoresDao;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.dto.SociedadProcuradoresDto;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.model.SociedadProcuradores;

/**
 * Implementación de la api de {@link Procurador}
 * @author carlos
 *
 */
@Service("SociedadProcuradores")
@Transactional(readOnly = false)
public class SociedadProcuradoresManager  implements SociedadProcuradoresApi {

	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private SociedadProcuradoresDao sociedadProcuradoresDao;

	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_SOCIEDAD_PROCURADORES_GET_LISTA_SOCIEDADES)
	public Page getListaSociedadesProcuradores(SociedadProcuradoresDto dto) {
		// TODO Auto-generated method stub
		return sociedadProcuradoresDao.getListaSociedadesProcuradores(dto);
	}

	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_SOCIEDAD_PROCURADORES_GET_SOCIEDAD_PROCURADORES)
	public SociedadProcuradores getSociedadProcuradores(Long idSociedad) {
		// TODO Auto-generated method stub
		return sociedadProcuradoresDao.getSociedadProcuradores(idSociedad);
	}
	
	



	
	


	


}

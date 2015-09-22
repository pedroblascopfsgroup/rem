package es.pfsgroup.plugin.recovery.procuradores.busqueda.impl;

import java.util.Collection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.procuradores.busqueda.api.MSVAsuntoAllApi;
import es.pfsgroup.plugin.recovery.procuradores.busqueda.dao.api.MSVAsuntoAllDao;
import es.pfsgroup.plugin.recovery.procuradores.busqueda.model.MSVAsuntoAll;


@Service
@Transactional(readOnly = false)
public class MSVAsuntoAllManager implements MSVAsuntoAllApi {

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private MSVAsuntoAllDao msvAsuntoAllDao;

	
	@Override
	@BusinessOperation(MSV_BO_CONSULTAR_ASUNTOS_ALL)
	public Collection<? extends MSVAsuntoAll> getAsuntos(String query) {
			Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			Long idUsuarioLogado = usuarioLogado.getId();
			return msvAsuntoAllDao.getAsuntos(query, idUsuarioLogado);
	}

}

package es.pfsgroup.plugin.recovery.procuradores.busqueda.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.procuradores.busqueda.api.MSVAsuntoAllApi;
import es.pfsgroup.plugin.recovery.procuradores.busqueda.dao.api.MSVAsuntoAllDao;
import es.pfsgroup.plugin.recovery.procuradores.busqueda.model.MSVAsuntoAll;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;
import es.pfsgroup.recovery.ext.impl.multigestor.model.EXTGrupoUsuarios;


@Service
@Transactional(readOnly = false)
public class MSVAsuntoAllManager implements MSVAsuntoAllApi {

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private MSVAsuntoAllDao msvAsuntoAllDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private EXTGrupoUsuariosDao grupoUsuarioDao;

	
	@Override
	@BusinessOperation(MSV_BO_CONSULTAR_ASUNTOS_ALL)
	public Collection<? extends MSVAsuntoAll> getAsuntos(String query) {
			Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			Long idUsuarioLogado = usuarioLogado.getId();
			return msvAsuntoAllDao.getAsuntos(query, idUsuarioLogado);
	}
	
	@Override
	@BusinessOperation(MSV_BO_CONSULTAR_ASUNTOS_ALL_GRUPOS)
	public Collection<? extends MSVAsuntoAll> getAsuntosGrupoUsuarios(String query) {
			Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			Long idUsuarioLogado = usuarioLogado.getId();
			
			List<Long> listaUsuariosGrupo=new ArrayList<Long>();
			Filter filtro = genericDao.createFilter(FilterType.EQUALS,
					"usuario.id", idUsuarioLogado);
			EXTGrupoUsuarios grupoUsuarios=genericDao.get(EXTGrupoUsuarios.class,filtro);
			if(!Checks.esNulo(grupoUsuarios)){
				listaUsuariosGrupo=grupoUsuarioDao.getIdsUsuariosGrupoUsuario(grupoUsuarios.getGrupo());
			}
			else{
				listaUsuariosGrupo.add(idUsuarioLogado);
			}
			
			return msvAsuntoAllDao.getAsuntosGrupoUsuarios(query, listaUsuariosGrupo);
	}

}

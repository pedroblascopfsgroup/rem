package es.capgemini.pfs.multigestor;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.multigestor.api.GestorAdicionalAsuntoApi;
import es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Component
public class EXTGestorAdicionalAsuntoManager implements
		GestorAdicionalAsuntoApi {

	@Autowired
	private EXTGestorAdicionalAsuntoDao adicionalAsuntoDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	@BusinessOperation(BO_EXT_GESTOR_ADICIONAL_FIND_GESTORES_BY_ASUNTO)
	@Transactional
	public List<Usuario> findGestoresByAsunto(Long idAsunto, String tipoGestor) {

		return adicionalAsuntoDao.findGestoresByAsunto(idAsunto,
				tipoGestor);

	}

}

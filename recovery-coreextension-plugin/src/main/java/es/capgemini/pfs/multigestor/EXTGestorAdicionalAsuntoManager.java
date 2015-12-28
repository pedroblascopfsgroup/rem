package es.capgemini.pfs.multigestor;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.api.GestorAdicionalAsuntoApi;
import es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoDao;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

@Component
public class EXTGestorAdicionalAsuntoManager implements
		GestorAdicionalAsuntoApi {

	@Autowired
	private EXTGestorAdicionalAsuntoDao adicionalAsuntoDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	@BusinessOperation(BO_EXT_GESTOR_ADICIONAL_FIND_GESTORES_BY_ASUNTO)
	@Transactional
	public List<Usuario> findGestoresByAsunto(Long idAsunto, String tipoGestor) {

		return adicionalAsuntoDao.findGestoresByAsunto(idAsunto,
				tipoGestor);

	}

	@Override
	public EXTGestorAdicionalAsunto findGaaByIds(Long idTipoGestor, Long idAsunto, Long idUsuario, Long idDespacho) {

		if (Checks.esNulo(idAsunto) || Checks.esNulo(idUsuario) || Checks.esNulo(idDespacho) || Checks.esNulo(idTipoGestor)) {
			return null;
		}

		List<GestorDespacho> gestores = genericDao.getList(GestorDespacho.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", idUsuario),
		genericDao.createFilter(FilterType.EQUALS, "despachoExterno.id", idDespacho),
		genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));

		EXTGestorAdicionalAsunto gaa = null;

		if (!gestores.isEmpty()) {
			Filter filtroAsunto = genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto);
			Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", idTipoGestor);
			Filter filtroGestorDespacho = genericDao.createFilter(FilterType.EQUALS, "gestor.id", gestores.get(0).getId());
			gaa = genericDao.get(EXTGestorAdicionalAsunto.class, filtroAsunto, filtroTipoGestor, filtroGestorDespacho);
		}

		return gaa;
	}

}

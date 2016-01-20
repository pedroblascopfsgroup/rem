package es.capgemini.pfs.multigestor.api;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface GestorAdicionalAsuntoApi {

	public static final String BO_EXT_GESTOR_ADICIONAL_FIND_GESTORES_BY_ASUNTO = "plugin.coreextension.multigestor.findGestorByAsunto";

	/**
	 * Recupera el usuario logeado. Y si no hay el usuario por defecto.
	 * 
	 * @return usuario
	 */
	@BusinessOperationDefinition(BO_EXT_GESTOR_ADICIONAL_FIND_GESTORES_BY_ASUNTO)
	@Transactional
	public List<Usuario> findGestoresByAsunto(Long idAsunto, String tipoGestor);

	/**
	 * Busca un gestor adicional por los ids
	 * @param idTipoGestor
	 * @param idAsunto
	 * @param idUsuario
	 * @param idTipoDespacho
	 * @return
	 */
	public EXTGestorAdicionalAsunto findGaaByIds(Long idTipoGestor, Long idAsunto, Long idUsuario, Long idTipoDespacho);

	public Usuario obtenerLetradoDelAsunto(Long idAsunto);
}

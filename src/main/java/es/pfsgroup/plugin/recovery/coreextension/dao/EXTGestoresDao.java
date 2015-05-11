package es.pfsgroup.plugin.recovery.coreextension.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.coreextension.api.UsuarioDto;

public interface EXTGestoresDao extends AbstractDao<Usuario, Long>{

	/**
	 * Dao que obtiene una lista de {@link Usuario} para un tipo de despacho dado.
	 * 
	 * @param idTipoDespacho id del tipo de despacho.
	 * @return Lista de {@link Usuario}
	 */
	List<Usuario> getGestoresByDespacho(long idTipoDespacho);

	/**
	 * Dao que obtiene una lista de {@link Usuario} para un tipo de despacho dado.
	 * Paginado
	 * 
	 * @param usuarioDto usuarioDto dto con los datos de búsqueda. {@link UsuarioDto}
	 * @return página con el resultado de la búsqueda.
	 */
	Page getGestoresByDespacho(UsuarioDto usuarioDto);

}

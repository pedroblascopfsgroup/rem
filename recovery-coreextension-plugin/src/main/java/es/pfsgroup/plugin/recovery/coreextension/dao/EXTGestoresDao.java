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
	 * 
	 * @param idTipoDespacho id del tipo de despacho.
	 * @param incluirBorrados true or false 
	 * @return  Lista de {@link Usuario}
	 */
	List<Usuario> getGestoresByDespacho(long idTipoDespacho, boolean incluirBorrados);

	/**
	 * Dao que obtiene una lista de {@link Usuario} para un tipo de despacho dado.
	 * Paginado
	 * 
	 * @param usuarioDto usuarioDto dto con los datos de b�squeda. {@link UsuarioDto}
	 * @return p�gina con el resultado de la b�squeda.
	 */
	Page getGestoresByDespacho(UsuarioDto usuarioDto);
	
	/**
	 * Dao que obtiene una lista de {@link Usuario} para un tipo de despacho dado.
	 * Ordenado por el que tenga la marca gestor Defecto activa
	 * Paginado
	 * 
	 * @param usuarioDto usuarioDto dto con los datos de b�squeda. {@link UsuarioDto}
	 * @return p�gina con el resultado de la b�squeda.
	 */
	Page getGestoresByDespachoDefecto(UsuarioDto usuarioDto);

}

package es.pfsgroup.plugin.recovery.config.usuarios.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.config.usuarios.dto.ADMDtoBusquedaUsuario;

public interface ADMUsuarioDao extends AbstractDao<Usuario, Long> {

	public Usuario findByUsername(String username);

	/**
	 * Nos crea una nueva instancia de Usuario
	 * 
	 * @return
	 */
	public Usuario createNewUsuario();

	/**
	 * Busca usuarios según los criterios definidos en el DTO de búsqueda
	 * 
	 * @param dtoBusquedaUsuario
	 *            DTO de búsqueda. <strong>Es necesario setear el id de entidad
	 *            en el DTO</strong>. En caso contrario se lanzará una
	 *            excepción.
	 * @return Devuelve una lista de objetos Usuario paginada.
	 */
	public Page findUsuarios(ADMDtoBusquedaUsuario dtoBusquedaUsuario);

	/**
	 * Devuelve una lista de despachos supervisados por un determinado usuario.
	 * 
	 * @param idUsuario
	 *            ID del usuario.
	 * @param idEntidad
	 *            ID de la entidad. Debe coincidir con el ID de la entidad a la
	 *            que pertenece el usuario.
	 * @return
	 */
	public List<DespachoExterno> findDespachoSupervisor(Long idUsuario,
			Long idEntidad);

	/**
	 * devuelve todos los usuarios cuyo atributo usuarioExterno=false.
	 * 
	 * @param idEntidad
	 *            Es necesario especificar el ID de la ENTIDAD. En caso
	 *            contrario se lanza una excepción
	 * @return
	 */
	public List<Usuario> getUsuariosNoExternos(Long idEntidad);

	/**
	 * devuelve todos los usuarios cuyo atributo usuarioExterno=true
	 * 
	 * @param idEntidad
	 *            Es necesario especificar el ID de la ENTIDAD. En caso
	 *            contrario se lanza una excepción
	 */
	public List<Usuario> getUsuariosExternos(Long idEntidad);

	/**
	 * Devuelve la lista de usuarios de una determinada entidad.
	 * 
	 * @return
	 */
	public List<Usuario> getListByEntidad(Long idEntidad);

	/**
	 * Devuelve Un usuario según su ID y su ID de entidad. Deben ser coherentes los dos valores
	 * @param idUsuario
	 * @param idEntidad
	 * @return
	 */
	public Usuario getByEntidad(Long idUsuario, Long idEntidad);

	/**
	 * Devuelve un listado de usuarios externos filtrados por nombre o apellido1 o apellido2
	 * @param filtro
	 * @return
	 */
	public List<Usuario> getListByExternosAndNombre(String filtro);
}

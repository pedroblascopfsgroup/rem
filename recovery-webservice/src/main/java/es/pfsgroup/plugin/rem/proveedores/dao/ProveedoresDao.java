package es.pfsgroup.plugin.rem.proveedores.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.DtoMediador;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.VProveedores;

public interface ProveedoresDao extends AbstractDao<ActivoProveedor, Long>{

	public List<DtoProveedorFilter> getProveedoresList(DtoProveedorFilter dtoProveedorFiltro);

	public ActivoProveedor getProveedorById(Long id);

	public ActivoProveedor getProveedorByNIFTipoSubtipo(DtoProveedorFilter dtoProveedorFilter);

	public List<ActivoProveedor> getMediadorListFiltered(Activo activo, DtoMediador dto);

	public Long getNextNumCodigoProveedor();

	public List<ActivoProveedor> getProveedoresByNifList(String nif);
	
	/**
	 * Lista de proveedores filtrada por cartera y tipos de proveedor
	 * @param codigosTipoProveedores
	 * @param codCartera
	 * @return
	 */
	public List<VProveedores> getProveedoresFilteredByTiposTrabajo(String codigosTipoProveedores, String codCartera);
	
	/**
	 * Devuelve una lista de nombres de proveedores contacto asociados al idUsuario
	 * @param idUsuario
	 * @return
	 */
	public List<String> getNombreProveedorByIdUsuario(Long idUsuario);
	
	/**
	 * Devuelve una lista de id de proveedores asociados al idUsuario en proveedor contacto
	 * @param idUsuario
	 * @return
	 */
	public List<Long> getIdProveedoresByIdUsuario(Long idUsuario);

	/**
	 * Este método obtien un listado de proveedores contacto en base a una lista de IDs de usuario y una cartera.
	 * 
	 * @param idUsuarios: ID de contacto que han de coincidir con los proveedores contacto.
	 * @param idCartera: ID de la cartera.
	 * @return Devuelve una lista de proveedores contacto.
	 */
	public List<ActivoProveedorContacto> getActivoProveedorContactoPorIdsUsuarioYCartera(List<Long> idUsuarios, Long idCartera);

}

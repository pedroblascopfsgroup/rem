package es.pfsgroup.plugin.rem.proveedores.dao;

import java.math.BigDecimal;
import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.DtoMediador;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.VProveedores;
import es.pfsgroup.plugin.rem.model.dd.DDCodigoPostal;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;

public interface ProveedoresDao extends AbstractDao<ActivoProveedor, Long>{

	public List<DtoProveedorFilter> getProveedoresList(DtoProveedorFilter dtoProveedorFiltro, Usuario usuarioLogado, Boolean esProveedor, Boolean esGestoria, Boolean esExterno);

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
	 * Obtiene una lista de ids proveedor por idusuario
	 * @param idUsuario
	 * @return
	 */
	public List<Long> getIdsProveedorByIdUsuario(Long idUsuario);
	
	/**
	 * Devuelve una lista de id de proveedores asociados al idUsuario en proveedor contacto
	 * @param idUsuario
	 * @return
	 */
	public List<Long> getIdProveedoresByIdUsuario(Long idUsuario);

	/**
	 * Devuelve una lista de subtipos de proveedor filtrada por los codigos que recibe
	 * @param codigos
	 * @return
	 */
	public List<DDTipoProveedor> getSubtiposProveedorByCodigos(List<String> codigos);
	
	/** Este método obtien un listado de proveedores contacto en base a una lista de IDs de usuario y una cartera.
	 * 
	 * @param idUsuarios: ID de contacto que han de coincidir con los proveedores contacto.
	 * @param idCartera: ID de la cartera.
	 * @return Devuelve una lista de proveedores contacto.
	 */
	public List<ActivoProveedorContacto> getActivoProveedorContactoPorIdsUsuarioYCartera(List<Long> idUsuarios, Long idCartera);
	

	public Long activosAsignadosProveedorMediador(Long idProveedor);
	
	/**
	 * Este método devuelve el número de activos asignados no vendidos ni traspasados en base al proveedor
	 * técnico 
	 * 
	 * @param idProveedor: id del proveedor 
	 * */
	public BigDecimal activosAsignadosNoVendidosNoTraspasadoProveedorTecnico(Long idProveedor);

	/** Este método obtiene un proveedor contacto en base a un ID de usuario.
	 * 
	 * @param idUsuario: ID de contacto que han de coincidir con los proveedores contacto.
	 * @return Devuelve un proveedor contacto.
	 */
	public ActivoProveedorContacto getActivoProveedorContactoPorIdsUsuario(Long idUsuario);

	public ActivoProveedorContacto getActivoProveedorContactoPorUsernameUsuario(String username);
	
	List<ActivoProveedor> getMediadoresActivos();
	
	/** Este método cambia .el proveedor asociado a un activo por el recibido en pvrCodRem
	 * 
	 * @param numActivo: Número del activo ACT_NUM_ACTIVO (se gestiona histórico).
	 * @param pvrCodRem: Código de proveedor que sustituirá al actual
	 * @return Devuelve un Booleano.
	 */
	public Boolean cambiaMediador(Long nActivo, String pveCodRem, String userName);

	public List<VProveedores> getProveedoresCarterizados(String codCartera);
	
	public List<Localidad> getMunicipiosList(String codigoProvincia);
	
	public List<DDCodigoPostal> getCodigosPostalesList(String codigoMunicipio);
}

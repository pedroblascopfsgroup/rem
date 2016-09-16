package es.pfsgroup.plugin.rem.api;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.rem.model.DtoActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;

public interface ProveedoresApi {
	
	/**
	 * Devuelve una Page de proveedores aplicando el filtro que recibe.
	 * 
	 * @param dtoProveedorFiltro: dto con los filtros de busqueda a aplicar.
	 * @return Devuelve un objeto Page de Proveedor.
	 */
	public Page getProveedores(DtoProveedorFilter dtoProveedorFiltro);

	/**
	 * Este método devuelve un proveedor por el ID de proveedor.
	 * 
	 * @param dtoProveedorFiltro: dto con los filtros de busqueda a aplicar.
	 * @return Devuelve un dto con los datos de proveedor.
	 */
	public DtoActivoProveedor getProveedorById(Long id);

	/**
	 * Este método almacena en la DDBB los datos del proveedor que recibe por el ID
	 * del proveedor.
	 * 
	 * @param dto: dto con los datos del proveedor a almacenar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean saveProveedorById(DtoActivoProveedor dto);
	

}

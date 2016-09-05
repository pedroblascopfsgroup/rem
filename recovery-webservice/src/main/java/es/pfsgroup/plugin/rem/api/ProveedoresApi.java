package es.pfsgroup.plugin.rem.api;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;

public interface ProveedoresApi {
	
	/**
	 * Devuelve una Page de proveedores aplicando el filtro que recibe
	 * @param dtoProveedorFiltro
	 * @return Page de Proveedor
	 */
	public Page getProveedores(DtoProveedorFilter dtoProveedorFiltro);
	

}

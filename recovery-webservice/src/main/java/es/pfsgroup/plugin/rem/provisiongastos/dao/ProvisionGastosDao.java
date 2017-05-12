package es.pfsgroup.plugin.rem.provisiongastos.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastosFilter;
import es.pfsgroup.plugin.rem.model.ProvisionGastos;

public interface ProvisionGastosDao extends AbstractDao<ProvisionGastos, Long>{
	
/**
 * Devuelve una página filtrada de provisiones
 * @param dto
 * @return
 */
	Page findAll (DtoProvisionGastosFilter dto);
	
	/**
	 * Devuelve listado de provisiones filtrados también por el proveedor_gestoria pasado por parametro
	 * @param dto
	 * @param isGestoriaAdministracion
	 * @return
	 */
	public Page findAllFilteredByProveedor(DtoProvisionGastosFilter dto, Long idProveedor);
}

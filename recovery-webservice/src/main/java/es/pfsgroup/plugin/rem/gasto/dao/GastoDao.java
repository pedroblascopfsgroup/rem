package es.pfsgroup.plugin.rem.gasto.dao;


import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.GastoProveedor;


public interface GastoDao extends AbstractDao<GastoProveedor, Long>{
	
	/* Nombre que le damos al trabajo buscado en la HQL */
	public static final String NAME_OF_ENTITY = "gpv";

	
	public DtoPage getListGastos(DtoGastosFilter dtoGastosFilter);
	
	public Long getNextNumGasto();
	
	public void deleteGastoTrabajoById(Long id);

	/**
	 * Devuelve un listado de gastos filtras por el proveedor contacto asociado al usuario pasado por parametro
	 * @param dtoGastosFilter
	 * @param idUsuario
	 * @return
	 */
	public DtoPage getListGastosFilteredByProveedorContactoAndGestoriaAdm(DtoGastosFilter dtoGastosFilter, Long idUsuario, Boolean isGestoriaAdm);
}

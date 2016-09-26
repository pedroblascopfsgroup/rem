package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.GastoProveedor;

public interface GastoApi {
	
	

	
	/**
     * Devuelve un Gasto por id.
     * @param id de la Gasto a consultar
     * @return Oferta
     */
    public GastoProveedor getGastoById(Long id);
    
	public DtoPage getListGastos(DtoGastosFilter dtoGastosFilter);
	
	/**
	 * Devuelve una lista de gastos aplicando el filtro que recibe.
	 * @param dtoGastosFilter con los parametros de filtro
	 * @return DtoPage 
	 */
	
	

}

package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.GastosProveedor;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;

public interface GastoApi {
	
	

	
	/**
     * Devuelve un Gasto por id.
     * @param id de la Gasto a consultar
     * @return Oferta
     */
    public GastosProveedor getGastoById(Long id);
    
	public DtoPage getListGastos(DtoGastosFilter dtoGastosFilter);
	
	/**
	 * Devuelve una lista de gastos aplicando el filtro que recibe.
	 * @param dtoGastosFilter con los parametros de filtro
	 * @return DtoPage 
	 */
	
	

}

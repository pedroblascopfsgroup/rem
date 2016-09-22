package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.GastosProveedor;


public interface GastoProveedorApi {
    
		/**
	     * Recupera el GastosProveedor indicado.
	     * @param id Long
	     * @return ExpedienteComercial
	     */
	    public GastosProveedor findOne(Long id);
	    

		/**
		 * Método que recupera un conjunto de datos del gasto según su id 
		 * @param id
		 * @param tab
		 * @return Object
		 */
	    public Object getTabExpediente(Long id, String tab);
	    
	    
	    /**
		 * Método que guarda la información de la pestaña Datos generales del gasto
		 * @param dto
		 * @param idGasto
		 * @return
		 */
		boolean saveGastosProveedor(DtoFichaGastoProveedor dto, Long idGasto);
	   
}


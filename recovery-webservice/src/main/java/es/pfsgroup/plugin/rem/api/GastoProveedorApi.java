package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.DtoDetalleEconomicoGasto;
import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoProveedor;


public interface GastoProveedorApi {
    
		/**
	     * Recupera el GastosProveedor indicado.
	     * @param id Long
	     * @return ExpedienteComercial
	     */
	    public GastoProveedor findOne(Long id);
	    

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
		 * @return GastoProveedor
		 */
	    GastoProveedor saveGastosProveedor(DtoFichaGastoProveedor dto);

		/**
		 * Método que recupera un proveedor según su NIF
		 * @param nifProveedor
		 * @return Object
		 */
		public Object searchProveedorNif(String nifProveedor);
		
		/**
		 * Método que recupera un propietario según su NIF
		 * @param nifPropietario
		 * @return Object
		 */
		public Object searchPropietarioNif(String nifPropietario);
		
		/**
		 * Método que guarda la información de la pestaña Detalle económico del gasto
		 * @param dto
		 * @param idGasto
		 * @return
		 */
		boolean saveDetalleEconomico(DtoDetalleEconomicoGasto dto, Long idGasto);
		
	   
}


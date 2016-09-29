package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.DtoActivoGasto;
import es.pfsgroup.plugin.rem.model.DtoDetalleEconomicoGasto;
import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.DtoInfoContabilidadGasto;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;


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
	    public Object getTabGasto(Long id, String tab);
	    
	    
	    /**
		 * Método que guarda la información de la pestaña Datos generales del gasto
		 * @param dto
		 * @param idGasto
		 * @return
		 */
		boolean saveGastosProveedor(DtoFichaGastoProveedor dto, Long idGasto);

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
		
		/**
		 * Método que recupera los activos relacionados con un gasto
		 * @return
		 */
		public List<VBusquedaGastoActivo> getListActivosGastos(Long id);
		
		/**
		 * Método que crea la relación entre un gasto y un activo o activos de una agrupación
		 * @return
		 */
		boolean createGastoActivo(Long idGasto, Long numActivo, Long numAgrupacion);
		
		/**
		 * Método que actualiza la relación entre un gasto y un activo
		 * @return
		 */
		boolean updateGastoActivo(DtoActivoGasto dtoActivoGasto);
		
		/**
		 * Método que elimina la relación entre un gasto y un activo
		 * @return
		 */
		boolean deleteGastoActivo(DtoActivoGasto dtoActivoGasto);
		
		/**
		 * Método que actualiza la la contabilidad de un gasto
		 * @return
		 */
		boolean updateGastoContabilidad(DtoInfoContabilidadGasto dtoContabilidadGasto);
		
}


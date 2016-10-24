package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoActivoGasto;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoDetalleEconomicoGasto;
import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.DtoGestionGasto;
import es.pfsgroup.plugin.rem.model.DtoImpugnacionGasto;
import es.pfsgroup.plugin.rem.model.DtoInfoContabilidadGasto;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoTrabajos;


public interface GastoProveedorApi {
    
		/**
	     * Recupera el GastosProveedor indicado.
	     * @param id Long
	     * @return ExpedienteComercial
	     */
	    public GastoProveedor findOne(Long id);
	    
		
		/**
		 * Devuelve una lista de gastos aplicando el filtro que recibe.
		 * @param dtoGastosFilter con los parametros de filtro
		 * @return DtoPage 
		 */
		public DtoPage getListGastos(DtoGastosFilter dtoGastosFilter);
	    

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
		 * @return boolean
		 */
	    boolean saveGastosProveedor(DtoFichaGastoProveedor dto, Long id);

		/**
		 * Método que recupera un proveedor según su NIF
		 * @param codigoUnicoProveedor
		 * @return Object
		 */
		public Object searchProveedorCodigo(String codigoUnicoProveedor);
		
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
		boolean updateGastoContabilidad(DtoInfoContabilidadGasto dtoContabilidadGasto, Long idGasto);

		/**
		 * crea un gasto
		 * @param dto
		 * @return
		 */
		GastoProveedor createGastoProveedor(DtoFichaGastoProveedor dto);
		
		/**
		 * Método que actualiza la gestión de un gasto
		 * @return
		 */
		boolean updateGestionGasto(DtoGestionGasto dto, Long idGasto);
		
		/**
		 * Método que actualiza la impugnación de un gasto
		 * @return
		 */
		boolean updateImpugnacionGasto(DtoImpugnacionGasto dto, Long idGasto);

		/**
		 * Método que asigna los trabajos que recibe a un gasto
		 * @param trabajos
		 * @return
		 */
		public boolean asignarTrabajos(Long idGasto, Long[] trabajos);


		/**
		 * Devuelve los trabajos asociados a un gasto
		 * @param idGasto
		 * @return
		 */
		public List<VBusquedaGastoTrabajos> getListTrabajosGasto(Long idGasto);

		/**
		 * Método que desasigna los trabajos que recibe a un gasto
		 * @param trabajos
		 * @return
		 */
		public boolean desasignarTrabajos(Long idGasto, Long[] trabajos);

		
		/**
		 * Elimina un gasto por su id
		 * @param id
		 * @return
		 */
		public boolean deleteGastoProveedor(Long id);
		
		/**
    	 * 
    	 * @param id
    	 * @return
    	 */
	    @BusinessOperationDefinition("gastoProveedorManager.getAdjuntosGasto")
		public Object getAdjuntos(Long id);
	    
	    /**
		 * 
		 * @param fileItem
		 * @return
		 */
	    @BusinessOperationDefinition("gastoProveedorManager.upload")
		public String upload(WebFileItem fileItem) throws Exception;
	    
	    /**
	     * 
	     * @param dtoAdjunto
	     * @return
	     */
	    @BusinessOperationDefinition("gastoProveedorManager.deleteAdjunto")
		public boolean deleteAdjunto(DtoAdjunto dtoAdjunto);
	    
		/**
		 * 
		 * @param dtoAdjunto
		 * @return
		 */
	    @BusinessOperationDefinition("gastoProveedorManager.getFileItemAdjunto")
		public FileItem getFileItemAdjunto(DtoAdjunto dtoAdjunto);
}


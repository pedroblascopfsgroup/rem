package es.pfsgroup.plugin.rem.api;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoSubtipoGastoProveedorTrabajo;
import es.pfsgroup.plugin.rem.model.AdjuntoGasto;
import es.pfsgroup.plugin.rem.model.DtoActivoGasto;
import es.pfsgroup.plugin.rem.model.DtoActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoDetalleEconomicoGasto;
import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.DtoGestionGasto;
import es.pfsgroup.plugin.rem.model.DtoImpugnacionGasto;
import es.pfsgroup.plugin.rem.model.DtoInfoContabilidadGasto;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.DtoVImporteGastoLbk;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleEntidad;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoTrabajos;
import es.pfsgroup.plugin.rem.model.VFacturasProveedores;
import es.pfsgroup.plugin.rem.model.VGastosProveedor;
import es.pfsgroup.plugin.rem.model.VGridMotivosRechazoGastoCaixa;
import es.pfsgroup.plugin.rem.model.VTasacionesGastos;
import es.pfsgroup.plugin.rem.model.VTasasImpuestos;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;


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
	    public Object getTabGasto(Long id, String tab) throws Exception;
	    
	    
	    /**
		 * Método que guarda la información de la pestaña Datos generales del gasto
		 * @param dto
		 * @param idGasto
		 * @return boolean
		 */
	    boolean saveGastosProveedor(DtoFichaGastoProveedor dto, Long id);

		/**
		 * Método que recupera un proveedor según su código
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
		
		public boolean searchActivoCarteraAndGastoPrinex(String numGastoHaya);
		
		/**
		 * Método que recoge información de la pestaña Detalle económico del gasto
		 * @param dto
		 * @param idGasto
		 * @return
		 */
		boolean saveDetalleEconomico(DtoDetalleEconomicoGasto dto, Long idGasto);
		
		/**
		 * Método que updatea la información de la pestaña Detalle económico del gasto segun prinex
		 * @param dto
		 * @param idGasto
		 * @return
		 */
		boolean updateGastoByPrinexLBK(Long idGasto);
		
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
		public Object getAdjuntos(Long id) throws GestorDocumentalException;
	    
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
	    
	    /**
		 * Método que recupera un proveedor según su Código y su tipo
		 * @param codigoUnicoProveedor
		 * @param codigoTipoProveedor
		 * @return Object
		 */
		public Object searchProveedorCodigoByTipoEntidad(String codigoUnicoProveedor, String codigoTipoProveedor);
		
		/**
		 * Método que recupera un gasto según su número haya
		 * @param codigoUnicoProveedor
		 * @return Object
		 */
		public Object searchGastoNumHaya(String numeroGastoHaya, String proveedorEmisor, String destinatario);


		/**
		 * Método que autoriza los gastos recibidos 
		 * @param idsGastos
		 * @return
		 */
		public boolean autorizarGastos(Long[] idsGastos);

		/**
		 * Método que rechaza los gastos recibidos
		 * @param idsGastos
		 * @param motivoRechazo
		 * @return
		 */
		public boolean rechazarGastos(Long[] idsGastos, String motivoRechazo);

		/**
		 * Método que autoriza un gasto, validandolo antes si validarAutorizacion = true
		 * @param idGasto id del gasto
		 * @param validarAutorizacion A true para validar si el gasto se puede autorizar
		 */
		public boolean autorizarGasto(Long idGasto, boolean validarAutorización);

		
		/**
		 * 
		 * @param idGasto
		 * @param motivoRechazo
		 * @return
		 */
		public boolean rechazarGasto(Long idGasto, String motivoRechazo);
		
		
		/**
		 * Método para rechazar gastos contablidad recibidos
		 * @param idsGastos
		 * @param motivoRechazo
		 * @return
		 */
		public boolean rechazarGastosContabilidad (Long[] idsGastos, String motivoRechazo, Boolean individual);
		
		/**
		 * Devuelve si ya existe un gasto comparando la información de varios campos concretos.
		 * @param dto
		 * @return
		 */
		public boolean existeGasto(DtoFichaGastoProveedor dto);

		
		/**
		 * Busca los proveedores que existan con el nif que recibe
		 * @param DtoProveedorFilter dto
		 * @return
		 */
		public List<DtoActivoProveedor> searchProveedoresByNif(DtoProveedorFilter dto);
		
		/**
		 * Devuelve una lista de gastos para una provision.
		 * @param dtoGastosFilter con los parametros de filtro
		 * @return DtoPage 
		 */
		public DtoPage getListGastosProvision(DtoGastosFilter dtoGastosFilter);
		
		/**
		 * Método que valida la fecha devengo de un gasto
		 * 
		 * @param gasto: Gasto que se asociará con los activos.
		 * @param activo: El activo que se va a asociar con el gasto anterior.
		 * @param ActivoAgrupacion: La agrupación de activos que se quiere asociar con el gasto
		 */
		public boolean fechaDevengoPosteriorFechaTraspaso(Long idGasto, Long idActivo, Long idAgrupacion);

		/**
		 * Este método actualiza el porcentaje de participación de un activo en un gasto.
		 * 
		 * @param idActivo: ID del activo dentro del gasto.
		 * @param idGasto: ID del gasto que contiene el activo.
		 * @param porcentajeParticipacion: indica el porcentaje de participacion del activo en el gasto.
		 */
		public void actualizarPorcentajeParticipacionGastoProveedorActivo(Long idActivo, Long idGasto, Float porcentajeParticipacion);



		public GastoLineaDetalleEntidad buscarRelacionPorActivoYGasto(Activo activo, GastoProveedor gasto);
		
		/**
		 * Método que devuelve el porcenaje de participación del último gasto ajustado para corregir errores de redondeo.
		 * 
		 * @param  gastosActivosList: lista de GastoLineaDetalleEntidad
		 * @param ultimoPorcentaje: porcentaje de participación del último gasto
		 * 
		 * */
		public float regulaPorcentajeUltimoGasto(List<GastoLineaDetalleEntidad> gastosLineaDetalleEntidad, Float ultimoPorcentaje);


		DtoPage getListGastosExcel(DtoGastosFilter dtoGastosFilter);

		boolean autorizarGastosContabilidad(Long[] idsGastos, String fechaConta, String fechaPago, Boolean individual);

		boolean autorizarGastoContabilidad(Long idGasto, String fechaConta, String fechaPago, Boolean individual);

		boolean autorizarGastosContabilidadAgrupacion(Long[] idsGastos, Long idAgrupacion, String fechaConta, String fechaPago, Boolean individual);

		/**
		 * Método para rechazar agrupacion de gastos y los gastos de contablidad recibidos de dicha agrupacion 
		 * @param idAgrupGasto
		 * @param motivoRechazo
		 * @return
		 */
		public boolean rechazarGastosContabilidadAgrupGastos(Long idAgrupGasto,Long[] idsGasto,String motivoRechazo, Boolean individual);

		/**
		 * 
		 * @param idProvision
		 * @return
		 */
		List<VGastosProveedor> getListGastosProvisionAgrupGastos(Long idProvision);

		
		List<VFacturasProveedores> getListFacturas();


		List<VTasasImpuestos> getListTasasImpuestos();


		AdjuntoGasto createAdjuntoGasto(WebFileItem fileItem, GastoProveedor gasto, Long idDocRestClient)
				throws Exception;
		public List<String> getGastosRefacturados(String listaGastos, String nifPropietario, String tipoGasto);


		List<String> getGastosNoRefacturados(String listaGastos, List<String> gastosRefacturables);


		Boolean isCarteraPropietarioBankiaSareb(ActivoPropietario propietario);


		List<Long> getGastosRefacturablesGastoCreado(Long id);
		
		/**
		 * Devuelve los gastos refacturables asociados al Gasto
		 * @param id
		 * @return
		 */
		List<GastoProveedor> getGastosRefacturablesGasto(Long id);


		public void anyadirGastosRefacturadosAGastoExistente(String idGasto, List<String> gastosRefacturablesLista) throws IllegalAccessException, InvocationTargetException;


		public Boolean eliminarGastoRefacturado(Long idGasto, Long numGastoRefacturado);
		
		/*HREOS-7241*/
		public boolean esGastoRefacturable(GastoProveedor gasto);

		/**
		 * Devuelve si el gasto es posible refacturable, es decir, cumple las condiciones para serlo
		 * @param id
		 * @return
		 */
		public boolean isPosibleRefacturable(GastoProveedor gasto);

		void validarGastosARefacturar(String idGasto, String listaGastos);
		
		GastoProveedor calcularParticipacionActivosGasto(GastoProveedor gasto);

		Double recalcularImporteTotalGasto(GastoDetalleEconomico gasto);

		boolean isGastoSareb(GastoProveedor gastoProveedor);

		void anyadirGastosRefacturablesSiCumplenCondiciones(String idGasto, String gastosRefacturables, String nifPropietario) throws IllegalAccessException, InvocationTargetException, Exception;


		List<DtoVImporteGastoLbk> getVImporteGastoLbk(Long idGasto);
		
		List<DDTipoTrabajo> getTiposTrabajoByIdGasto(Long idGasto);
		
		List<DDSubtipoTrabajo> getSubTiposTrabajoByIdGasto(Long idGasto); 	

		boolean actualizarReparto(Long idLinea);
		
		boolean actualizarRepartoTrabajo(Long idLinea);

		boolean isEstadosGastosLiberbankParaLecturaDirectaDeTabla(GastoProveedor gasto);

		ActivoSubtipoGastoProveedorTrabajo getSubtipoGastoBySubtipoTrabajo(Trabajo trabajo);
		
		String validarAutorizacionSuplido(long idGasto);
		
		String validacionNifEmisorFactura(DtoFichaGastoProveedor dto, Long idGasto);

		String getCodigoCarteraGastoByIdGasto(Long idGasto);

		Double recalcularImporteRetencionGarantia(GastoDetalleEconomico gasto);

		Double recalcularCuotaRetencionGarantia(GastoDetalleEconomico detalleGasto, Double importeGarantiaBase);
		
		Long getIdByNumGasto(Long numGasto);


		public Long getIdGasto(Long numGasto);
		
		public List<VGridMotivosRechazoGastoCaixa> getMotivosRechazoGasto(Long idGasto) throws Exception;


    List<VTasacionesGastos> getListTasacionesGasto(Long idGasto);

    boolean deleteGastoTasacion(Long id);

	boolean isProveedorIncompleto(GastoProveedor gasto);
}


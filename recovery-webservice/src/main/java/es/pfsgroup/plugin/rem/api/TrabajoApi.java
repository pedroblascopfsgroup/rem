package es.pfsgroup.plugin.rem.api;


import java.text.ParseException;
import java.util.HashMap;
import java.util.List;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoActivoTrabajo;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoFichaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoGestionEconomicaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoPresupuestoTrabajo;
import es.pfsgroup.plugin.rem.model.DtoPresupuestosTrabajo;
import es.pfsgroup.plugin.rem.model.DtoProvisionSuplido;
import es.pfsgroup.plugin.rem.model.DtoRecargoProveedor;
import es.pfsgroup.plugin.rem.model.DtoTarifaTrabajo;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VProveedores;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.rest.dto.TrabajoDto;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoTrabajoFilter;


public interface TrabajoApi {
    
		/**
		 * 
		 * @param id
		 * @param pestana
		 * @return
		 */
	    @BusinessOperationDefinition("trabajoManager.getTrabajoById")
	    public Object getTrabajoById(Long id, String pestana);
	    
		/**
		 * Recupera el Trabajo relacionado con una Tarea
		 * @param TareaExterna
		 * @return Trabajo
		 */
		@BusinessOperation(overrides = "trabajoManager.getTrabajoByTareaExterna")
		public Trabajo getTrabajoByTareaExterna(TareaExterna tarea);

	    @BusinessOperationDefinition("trabajoManager.createTramiteTrabajo")
		public ActivoTramite createTramiteTrabajo(Trabajo trabajo);

	    /**
	     * Recupera la lista completa de Trabajos
	     * @return List<Trabajo>
	     */
	    @BusinessOperationDefinition("trabajoManager.findAll")
	    public Page findAll(DtoTrabajoFilter dto, Usuario usuarioLogado);

		/**
		 * 
		 * @param trabajo
		 * @param id
		 * @return
		 */
	    @BusinessOperationDefinition("trabajoManager.saveFichaTrabajo")
		public boolean saveFichaTrabajo(DtoFichaTrabajo trabajo, Long id);
	    
		/**
		 * 
		 * @param dtoGestionEconomica
		 * @param id
		 * @return
		 */
	    @BusinessOperationDefinition("trabajoManager.saveGestionEconomicaTrabajo")
		public boolean saveGestionEconomicaTrabajo(DtoGestionEconomicaTrabajo dtoGestionEconomica, Long id);

		/**
		 * 
		 * @param trabajo
		 * @return
		 */
	    @BusinessOperationDefinition("trabajoManager.actualizarImporteTotalTrabajo")
	    public Trabajo actualizarImporteTotalTrabajo(Long idTrabajo);
	    
	    /**
	     * Crear trabajo a partir de una lista de activos y un subtipo dados:
	     * - Nuevos trabajos del módulo de precios y marketing
	     * - Otros trabajos que no provengan de la pantalla "Crear trabajo", por esto no requiere el DtoFichaTrabajo
	     *   solo requiere una lista de activos y el subtipo de trabajo a generar. 
	     * - La propuesta ES OPCIONAL para crear el trabajo. Si se pasa la propuesta crea la relación, si no,
	     *   solo crea el trabajo-tramite.
	     * @param subtipoTrabajo
	     * @param listaActivos
	     * @param propuetaPrecio (Opcional) Si es un trabajo derivado de la propuesta, se le pasa la propuesta
	     * @return
	     */
	    public Trabajo create(DDSubtipoTrabajo subtipoTrabajo, List<Activo> listaActivos, PropuestaPrecio propuestaPrecio);
	    
		/**
		 * Crear trabajo desde la pantalla de crear trabajos:
		 * - Crea un trabajo desde el activo o desde la agrupación de activos (Nuevos trabajos Fase1)
		 *   o crea un trabajo introduciendo un listado de activos en excel (trabajos con tramite multiactivo Fase 2)
		 * - Son solo trabajos que provienen de la pantalla "Crear trabajo"
		 * @param dtoTrabajo
		 * @param id
		 * @return
		 */
	    @BusinessOperationDefinition("trabajoManager.create")
		public Long create(DtoFichaTrabajo dtoTrabajo);

    	/**
    	 * 
    	 * @param id
    	 * @return
    	 */
	    @BusinessOperationDefinition("trabajoManager.getAdjuntosTrabajo")
		public Object getAdjuntos(Long id);

	    /**
	     * 
	     * @param dtoAdjunto
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.deleteAdjunto")
		public boolean deleteAdjunto(DtoAdjunto dtoAdjunto);

		/**
		 * 
		 * @param dtoAdjunto
		 * @return
		 */
	    @BusinessOperationDefinition("trabajoManager.getFileItemAdjunto")
		public FileItem getFileItemAdjunto(DtoAdjunto dtoAdjunto);

		/**
		 * 
		 * @param fileItem
		 * @return
		 */
	    @BusinessOperationDefinition("trabajoManager.upload")
		public String upload(WebFileItem fileItem) throws Exception;

	    /**
	     * Devuelve la lista de activos de un trabajo
	     * @param id
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.getListActivosTrabajo")
		public Page getListActivos(DtoActivosTrabajoFilter dto);		    

	    @BusinessOperationDefinition("trabajoManager.findOne")
		Trabajo findOne(Long id);

	    /**
	     * Recupera las observaciones de un trabajo
	     * @param dto
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.getObservaciones")
		public DtoPage getObservaciones(DtoTrabajoFilter dto);	    

	    /**
	     * Actualiza una observacion
	     * @param dtoObservacion
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.saveObservacion")
		public boolean saveObservacion(DtoObservacion dtoObservacion);

	    /**
	     * Crea una observación
	     * @param dtoObservacion
	     * @param idTrabajo
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.createObservacion")
		public boolean createObservacion(DtoObservacion dtoObservacion, Long idTrabajo);

	    /**
	     * Elimina una observación
	     * @param idObservacion
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.deleteObservacion")
		public boolean deleteObservacion(Long idObservacion);


	    /**
	     * Modifica un ActivoTrabajo
	     * @param idObservacion
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.saveActivoTrabajo")
	    public boolean saveActivoTrabajo(DtoActivoTrabajo activoTrabajo);  

	    @BusinessOperationDefinition("trabajoManager.uploadFoto")
	    public String uploadFoto(WebFileItem fileItem);


	    /**
	     * Devuelve los activos de una agrupación con la información necesaria para crear un trabajo
	     * @param filtro
	     * @param id
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.getListActivosAgrupacion")
		public Page getListActivosAgrupacion(DtoAgrupacionFilter filtro, Long id);	    

	    /**
	     * Devuelve la selección de tarifas disponibles para aplicar a un trabajo determinado
	     * @param filtro
	     * @param cartera, tipoTrabajo, subtipoTrabajo
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.getSeleccionTarifasTrabajo")
		public DtoPage getSeleccionTarifasTrabajo(DtoGestionEconomicaTrabajo filtro, String cartera, String tipoTrabajo, String subtipoTrabajo);	 
	    
	    /**
	     * Devuelve las tarifas aplicadas a un trabajo determinado
	     * @param filtro
	     * @param idTrabajo
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.getTarifasTrabajo")
		public DtoPage getTarifasTrabajo(DtoGestionEconomicaTrabajo filtro, Long idTrabajo);	
	    
	    /**
	     * Devuelve los presupuestos aplicados a un trabajo determinado
	     * @param filtro
	     * @param idTrabajo
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.getPresupuestosTrabajo")
		public DtoPage getPresupuestosTrabajo(DtoGestionEconomicaTrabajo filtro, Long idTrabajo);
	    
	    /**
	     * Crea una tarifa asociada al trabajo
	     * @param tarifaDto
	     * @param idTrabajo
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.createTarifaTrabajo")
		public boolean createTarifaTrabajo(DtoTarifaTrabajo tarifaDto, Long idTrabajo);
	    
	    /**
	     * Crea un presupuesto asociado al trabajo
	     * @param presupuestoDto
	     * @param idTrabajo
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.createPresupuestoTrabajo")
		public boolean createPresupuestoTrabajo(DtoPresupuestosTrabajo tarifaDto, Long idTrabajo);
	    
	    /**
	     * Actualiza un presupuesto asociado al trabajo
	     * @param presupuestoDto
	     * @param idTrabajo
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.savePresupuestoTrabajo")
		public boolean savePresupuestoTrabajo(DtoPresupuestosTrabajo tarifaDto);
	    
	    /**
	     * Elimina un presupuesto asociado al trabajo
	     * @param idT
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.deletePresupuestoTrabajo")
		public boolean deletePresupuestoTrabajo(Long id);
	    
	    /**
	     * Actualiza una tarifa asociada al trabajo
	     * @param tarifaDto
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.saveTarifaTrabajo")
		public boolean saveTarifaTrabajo(DtoTarifaTrabajo tarifaDto);
	    
	    /**
	     * Elimina una tarifa asociada al trabajo
	     * @param id
	     * @return
	     */
	    @BusinessOperationDefinition("trabajoManager.deleteTarifaTrabajo")
		public boolean deleteTarifaTrabajo(Long id);

	    /**
	     * Evalúa para una tarea, si existe presupuesto(s) asociados al trabajo
	     * @param TareaExterna
	     * @return Boolean
	     */
	    @BusinessOperationDefinition("trabajoManager.existePresupuestoTrabajo")
	    public Boolean existePresupuestoTrabajo(TareaExterna tarea);

	    /**
	     * Evalúa para una tarea, si existe tarifa(s) asociados al trabajo
	     * @param TareaExterna
	     * @return Boolean
	     */
	    @BusinessOperationDefinition("trabajoManager.existeTarifaTrabajo")
	    public Boolean existeTarifaTrabajo(TareaExterna tarea);
	    
	    /**
	     * Evalúa para una tarea, si existe proveedor(es) asociados al trabajo
	     * @param TareaExterna
	     * @return Boolean
	     */
	    @BusinessOperationDefinition("trabajoManager.existeProveedorTrabajo")
	    public Boolean existeProveedorTrabajo(TareaExterna tarea);

	    /**
	     * Devuelve una lista de proveedores filtrando por cartera
	     * @param idTrabajo
	     * @return
	     */
		@BusinessOperationDefinition("trabajoManager.getComboSubtipoTrabajo")
		public List<VProveedores> getComboProveedor(Long idTrabajo);
		
		/**
		 * Devuelve un presupuesto
		 * @param id
		 * @return
		 */
		@BusinessOperationDefinition("trabajomanager.getPresupuestoById")
		public DtoPresupuestoTrabajo getPresupuestoById(Long id);

		/**
		 * Devuelve una lista con los recargos de un proveedor para un trabajo dado
		 * @param idTrabajo
		 * @return
		 */
		@BusinessOperationDefinition("trabajoManager.getRecargosProveedor")
		public List<DtoRecargoProveedor> getRecargosProveedor(Long idTrabajo);

		/**
		 * Crea un recargo para un proveedor y trabajo
		 * @param recargoDto
		 * @param idTrabajo
		 * @return
		 */
		@BusinessOperationDefinition("trabajoManager.createRecargoProveedor")
		public boolean createRecargoProveedor(DtoRecargoProveedor recargoDto,Long idTrabajo);
		
		/**
		 * Modifica un recargo para un proveedor y trabajo
		 * @param recargoDto
		 * @return
		 */
		@BusinessOperationDefinition("trabajoManager.saveRecargoProveedor")
		public boolean saveRecargoProveedor(DtoRecargoProveedor recargoDto);
		
		/**
		 * Elimina un recargo para un proveedor y trabajo
		 * @param id
		 * @return
		 */
	    @BusinessOperationDefinition("trabajoManager.deleteRecargoProveedor")
		public boolean deleteRecargoProveedor(Long id);

	    /**
		 * Devuelve una lista con las provisiones y suplidos para un trabajo dado
	     * @param idTrabajo
	     * @return
	     */
		@BusinessOperationDefinition("trabajoManager.getProvisionSuplidos")
		public List<DtoProvisionSuplido> getProvisionSuplidos(Long idTrabajo);

		/**
		 * Crea una Previsión/Suplido para un trabajo dado
		 * @param recargoDto
		 * @param idTrabajo
		 * @return
		 */
		@BusinessOperationDefinition("trabajoManager.createProvisionSuplido")
		public boolean createProvisionSuplido(DtoProvisionSuplido recargoDto,Long idTrabajo);
		
		/**
		 * Modifica una Previsión/Suplido para un trabajo dado
		 * @param recargoDto
		 * @return
		 */
		@BusinessOperationDefinition("trabajoManager.saveProvisionSuplido")
		public boolean saveProvisionSuplido(DtoProvisionSuplido recargoDto);
		
		/**
		 * Elimina una Previsión/Suplido para un trabajo dado
		 * @param id
		 * @return
		 */
	    @BusinessOperationDefinition("trabajoManager.deleteProvisionSuplido")
		public boolean deleteProvisionSuplido(Long id);
	    

		/**
		 * Devuelve TRUE si encuentra un documento en el trabajo, buscando por codigo documento 
		 * <p>
		 *
		 * @param  idTrabajo  identificador del Trabajo
		 * @param  codigoDocumento codigo del documento de DDTipoDocumentoActivo
		 * @return	boolean
		 */
	    @BusinessOperationDefinition("trabajoManager.comprobarExisteAdjuntoActivo")
		public Boolean comprobarExisteAdjuntoTrabajo(Long idTrabajo, String codigoDocumento);

		/**
		 * Devuelve la fecha de hoy() del servidor en formato valido groovy-bmp
		 * @return	String
		 */
	    @BusinessOperationDefinition("trabajoManager.hoyDate")
	    public String hoyDateServer();
	    
		/**
		 * Devuelve NUMERO, al comparar las 2 fechas de los parámetros
		 * = E Si las fechas son iguales
		 * < N Si la fecha1 es mayor que la fecha2
		 * > P Si la fecha1 es menor que la fecha2 
		 * <p>
		 *
		 * @param  String  Fecha1 de comparación con formato groovy-bpm
		 * @param  String  Fecha2 de comparación con formato groovy-bpm
		 * @return	String
		 */
	    @BusinessOperationDefinition("trabajoManager.diffDate")		
	    public String diffDate(String date1, String date2) throws ParseException;
	    
	    @BusinessOperationDefinition("trabajoManager.getFechaSolicitudTrabajo")
	    public String getFechaSolicitudTrabajo(TareaExterna tareaExterna);
	    
	    @BusinessOperationDefinition("trabajoManager.getFechaAprobacionTrabajo")
	    public String getFechaAprobacionTrabajo(TareaExterna tareaExterna);
	    
	    @BusinessOperationDefinition("trabajoManager.getFechaRechazoTrabajo")
	    public String getFechaRechazoTrabajo(TareaExterna tareaExterna);
	    
	    @BusinessOperationDefinition("trabajoManager.getFechaEleccionProveedorTrabajo")
	    public String getFechaEleccionProveedorTrabajo(TareaExterna tareaExterna);
	    
	    @BusinessOperationDefinition("trabajoManager.getFechaEjecutadoTrabajo")
	    public String getFechaEjecutadoTrabajo(TareaExterna tareaExterna);
	    
	    @BusinessOperationDefinition("trabajoManager.getFechaValidacionTrabajo")
	    public String getFechaValidacionTrabajo(TareaExterna tareaExterna);
	    
	    @BusinessOperationDefinition("trabajoManager.getFechaAnulacionTrabajo")
	    public String getFechaAnulacionTrabajo(TareaExterna tareaExterna);
	    
	    @BusinessOperationDefinition("trabajoManager.getFechaCierreEcoTrabajo")
	    public String getFechaCierreEcoTrabajo(TareaExterna tareaExterna);
	    
	    @BusinessOperationDefinition("trabajoManager.getFechaPagoTrabajo")
	    public String getFechaPagoTrabajo(TareaExterna tareaExterna);
	    
	    
	    /**
	     * Devuelve si existe un Trabajo por idTrabajoWebcom.
	     * @param idTrabajoWebcom a consultar
	     * @return Trabajo
	     */
	    public Boolean existsTrabajoByIdTrabajoWebcom(Long idTrabajoWebcom);
	    
	    /**
		 * Devuelve una lista de errores encontrados en los parámetros de entrada de las peticiones POST.
		 * @param TrabajoDto con los parametros de entrada
		 * @return List<String> 
		 */
	    public HashMap<String, List<String>> validateTrabajoPostRequestData(TrabajoDto trabajoDto);

	    /**
		 * Devuelve un DtoFichaTrabajo a partir del TrabajoDto pasado por parámetros
		 * @param TrabajoDto con los parametros de entrada
		 * @return DtoFichaTrabajo
		 */	    
	    public DtoFichaTrabajo convertTrabajoDto2DtoFichaTrabajo(TrabajoDto trabajoDto);

	    /**
	     * Devuelve el trabajo asociado a la tarea externa indicada.
	     * @param tareaExterna
	     * @return
	     */
	    public Trabajo tareaExternaToTrabajo(TareaExterna tareaExterna);
	    
		/**
		 * Método que comprueba si el activo tiene formalización
		 * @param tareaExterna
		 * @return true si tiene formalización, false si no la tiene
		 */
		public boolean checkFormalizacion(TareaExterna tareaExterna);
		
		/**
		 * Método que comprueba si el activo tiene atribuciones para sancionar el expediente
		 * @param tareaExterna
		 * @return true si tiene atribuciones, false si no las tiene
		 */
		public boolean checkAtribuciones(TareaExterna tareaExterna);
		
		/**
		 * Método que comprueba si el activo tiene atribuciones para sancionar el expediente
		 * @param trabajo
		 * @return true si tiene atribuciones, false si no las tiene
		 */
		public boolean checkAtribuciones(Trabajo trabajo);
		
		/**
		 * Método que comprueba si el activo pertenece a la cartera Sareb.
		 * @param tareaExterna
		 * @return true si pertenece a la cartera, false si no.
		 */
		public boolean checkSareb(TareaExterna tareaExterna);
		
		/**
		 * Método que comprueba si el activo pertenece a la cartera Sareb.
		 * @param trabajo
		 * @return true si pertenece a la cartera, false si no
		 */
		public boolean checkSareb(Trabajo trabajo);

		/**
		 * Comprueba la existencia de una propuesta en el tramite de Propuestas,
		 * en la tarea Generacion de propuesta, devolviendo mensaje en caso de que se haya creado.
		 * @param tareaExterna
		 * @return
		 */
		public String comprobarPropuestaPrecios(TareaExterna tareaExterna);

    }



package es.pfsgroup.plugin.rem.api;

import java.math.BigDecimal;
import java.util.List;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.VCondicionantesDisponibilidad;


public interface ActivoApi {
    
		/**
	     * Recupera el Activo indicado.
	     * @param id Long
	     * @return Activo
	     */
	    @BusinessOperationDefinition("activoManager.get")
	    public Activo get(Long id);
	    
	    @BusinessOperationDefinition("activoManager.saveOrUpdate")
	    public boolean saveOrUpdate(Activo activo);
	    
	    @BusinessOperationDefinition("activoManager.upload")
	    public String upload(WebFileItem fileItem) throws Exception;
	    
	    /**
	     * Recupera un adjunto
	     * @param parameter
	     * @return
	     */
	    @BusinessOperationDefinition("activoManager.download")
		public FileItem download(Long id) throws Exception;
	    
	    @BusinessOperationDefinition("activoManager.uploadFoto")
	    public String uploadFoto(WebFileItem fileItem);
	    
	    /**
	     * Recupera la lista completa de Activos
	     * @return List<Activo>
	     * 
	     */
	    @BusinessOperationDefinition("activoManager.getListActivos")
	    public Page getListActivos(DtoActivoFilter dto, Usuario usuarioLogado);
	    
	    @BusinessOperationDefinition("activoManager.isIntegradoAgrupacionRestringida")
	    public boolean isIntegradoAgrupacionRestringida(Long id, Usuario usuarioLogado);
	    
	    @BusinessOperationDefinition("activoManager.isIntegradoAgrupacionObraNueva")
	    public boolean isIntegradoAgrupacionObraNueva(Long id, Usuario usuarioLogado);

	    /**
	     * Elimina un adjunto
	     * @param activoId
	     * @param adjuntoId
	     * @return
	     */
	    @BusinessOperationDefinition("activoManager.deleteAdjunto")
		public boolean deleteAdjunto(DtoAdjunto dtoAdjunto);
	    
	    @BusinessOperationDefinition("activoManager.savePrecioVigente")
	    public boolean savePrecioVigente(DtoPrecioVigente precioVigenteDto);
	    
		/**
		 * saveActivoValoracion: Para un activo dado, actualiza o crea una valoracion por tipo de precio.
		 * Este mismo proceso tambien se encarga de mantener el historico de valoraciones, si hay cambios en las 
		 * valoraciones.
		 * Devuelve TRUE si el proceso se ha realizado correctamente
		 *
		 * @param  activo  Activo (necesario)
		 * @param  activoValoracion Si se indica esta, actualiza la valoracion existente. Si no se indica (null),
		 * 			crea una nueva valoracion.
		 * @param DtoPrecioVigente dto (necesario) los datos a modificar/crear
		 * @return	boolean
		 */
		@BusinessOperation(overrides = "activoManager.saveActivoValoracion")
	    public boolean saveActivoValoracion(Activo activo, ActivoValoraciones activoValoracion, DtoPrecioVigente dto);

	    @BusinessOperationDefinition("activoManager.getComboInferiorMunicipio")
	    public List<DDUnidadPoblacional> getComboInferiorMunicipio(String codigoMunicipio);

	    @BusinessOperationDefinition("activoManager.getMaxOrdenFotoById")
		Integer getMaxOrdenFotoById(Long id);
	    
	    @BusinessOperationDefinition("activoManager.getMaxOrdenFotoByIdSubdivision")
		Integer getMaxOrdenFotoByIdSubdivision(Long idEntidad, BigDecimal hashSdv);
	    
	    @BusinessOperationDefinition("activoManager.getUltimoPresupuesto")
		Long getUltimoPresupuesto(Long id);

	    @BusinessOperationDefinition("activoManager.getListHistoricoPresupuestos")
	    public Page getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto, Usuario usuarioLogado);
	
	    @BusinessOperationDefinition("activoManager.comprobarPestanaCheckingInformacion")
		public Boolean comprobarPestanaCheckingInformacion(Long idActivo);
	    
		/**
		 * Devuelve TRUE si encuentra un documento en el activo, buscando por codigo documento 
		 * <p>
		 * Esta versión del método de comprobación, es una versión mejorada respecto
		 * a la que se viene utilizando en Recovery. Realiza todo el trabajo de búsqueda
		 * mediante filtrados con la BBDD. Evita procesar listas completas de adjuntos.
		 *
		 * @param  idActivo  identificador del Activo
		 * @param  codigoDocumento codigo del documento de DDTipoDocumentoActivo
		 * @return	boolean
		 */
		@BusinessOperationDefinition("activoManager.comprobarExisteAdjuntoActivo")
		public Boolean comprobarExisteAdjuntoActivo(Long idActivo, String codigoDocumento);

		/**
		 * Depende del método anterior, pero primero se va a buscar los datos que 
		 * le hacen falta a partir del trabajo de la tarea.
		 * 
		 * @param tarea
		 * @return boolean
		 * @throws Exception
		 */
		@BusinessOperationDefinition("activoManager.comprobarExisteAdjuntoActivoTarea")
		public Boolean comprobarExisteAdjuntoActivoTarea(TareaExterna tarea);
		
		
		/**
		 * Devuelve TRUE si el activo tiene fecha de posesión
		 *
		 * @param  idActivo  identificador del Activo
		 * @return	boolean
		 */
		@BusinessOperationDefinition("activoManager.comprobarExisteFechaPosesionActivo")
		public Boolean comprobarExisteFechaPosesionActivo(Long idActivo) throws Exception;
		
	    /**
	     * Sirve para que después de guardar un fichero en el servicio de RestClient
	     * guarde el identificador obtenido en base de datos 
	     * 
	     * @param webFileItem
	     * @param idDocRestClient
	     * @return
	     * @throws Exception
	     */
	    @BusinessOperationDefinition("activoManager.upload2")
		String upload2(WebFileItem webFileItem, Long idDocRestClient) throws Exception;

		/**
		 * Sirva para saber si el activo está vendido
		 */
	    public Boolean isVendido(Long idActivo);
		
		/**
		 * Devuelve mensaje de validación indicando los campos obligatorios que no han sido informados
		 *
		 * @param  idActivo  identificador del Activo
		 * @return	String
		 */
		@BusinessOperationDefinition("activoManager.comprobarObligatoriosCheckingInfoActivo")
		public String comprobarObligatoriosCheckingInfoActivo(Long idActivo) throws Exception;

		/**
		 * Recupera una página del historico de valores precios de un activo 
		 * @param dto
		 * @return
		 */
		public DtoPage getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto);

		/**
		 * Borrado fisico de una valoración y paso al historico
		 * @param precioVigenteDto
		 * @return
		 */
		public boolean deleteValoracionPrecio(Long id);
		
		public VCondicionantesDisponibilidad getCondicionantesDisponibilidad(Long idActivo);
		
		public List<DtoCondicionEspecifica> getCondicionEspecificaByActivo(Long idActivo);
		public Boolean createCondicionEspecifica(Long idActivo, DtoCondicionEspecifica dtoCondicionEspecifica);
		public Boolean saveCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica);
		
		public List<DtoEstadoPublicacion> getEstadoPublicacionByActivo(Long idActivo);

		/**
		 * Recupera una página de propuestas según el filtro recibido
		 * @param dtoPropuestaFiltro
		 * @return
		 */
		public Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro);

		/**
		 * Este metodo obtiene una página de resultados de la búsqueda de Activos Publicación.
		 * @param dtoActivosPublicacion
		 * @return
		 */
		public Page getActivosPublicacion(DtoActivosPublicacion dtoActivosPublicacion);
		
		
    }



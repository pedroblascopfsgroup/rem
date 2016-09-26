package es.pfsgroup.plugin.rem.api;

import java.lang.reflect.InvocationTargetException;
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
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.DtoHistoricoMediador;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.plugin.rem.model.DtoPropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.VCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.Visita;


public interface ActivoApi {
    
		/**
	     * Recupera el Activo indicado.
	     * @param id Long
	     * @return Activo
	     */
	    @BusinessOperationDefinition("activoManager.get")
	    public Activo get(Long id);
	    
		public Activo getByNumActivo(Long id);
	    
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
	    
	    @BusinessOperationDefinition("activoManager.saveOfertaActivo")
	    public boolean saveOfertaActivo(DtoOfertaActivo precioVigenteDto);
	    
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
		
		/**
		 * Este método obtiene un objeto con los condicionantes del activo.
		 * 
		 * @param idActivo: ID del activo a filtrar los datos.
		 * @return Devuelve un objeto con los datos obtenidos.
		 */
		public VCondicionantesDisponibilidad getCondicionantesDisponibilidad(Long idActivo);
		
		public List<DtoCondicionEspecifica> getCondicionEspecificaByActivo(Long idActivo);
		
		public Boolean createCondicionEspecifica(Long idActivo, DtoCondicionEspecifica dtoCondicionEspecifica);
		
		public Boolean saveCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica);
		
		/**
		 * Este método obtiene los estados, el historial, de publicación de un activo.
		 * 
		 * @param idActivo: ID del activo a filtrar los datos.
		 * @return Devuleve un dto con los datos obtenidos.
		 */
		public List<DtoEstadoPublicacion> getEstadoPublicacionByActivo(Long idActivo);
		
		/**
		 * Este método obtiene los datos del apartado 'datos publicación' de la tab 'publicacion' de un activo.
		 * 
		 * @param idActivo: ID del activo a filtrar los datos.
		 * @return Devuelve un dto con los datos obtenidos.
		 */
		public DtoDatosPublicacion getDatosPublicacionByActivo(Long idActivo);

		/**
		 * Recupera una página de propuestas según el filtro recibido
		 * @param dtoPropuestaFiltro
		 * @return
		 */
		public Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro);

		/**
		 * Este método obtiene una página de resultados de la búsqueda de Activos Publicación.
		 * @param dtoActivosPublicacion
		 * @return Devuelve los resultados paginados del grid de la búsqueda de activos publicación.
		 */
		public Page getActivosPublicacion(DtoActivosPublicacion dtoActivosPublicacion);
		
		/**
		 * Este método obtiene el último HistoricoEstadoPublicacion por el ID de activo.
		 * @param activoID : ID del activo para buscar el HistoricoEstadoPublicacion.
		 * @return Devuelve el último histórico por ID para el ID del activo.
		 */
		public ActivoHistoricoEstadoPublicacion getUltimoHistoricoEstadoPublicacion(Long activoID);
		
		/**
		 * Inserta o actualiza una visita aun activo
		 * 
		 * @param vista
		 * @return
		 */
		public Visita insertOrUpdateVisitaActivo(Visita visita) throws IllegalAccessException, InvocationTargetException;

		/**
		 * Este método obtiene los estados, el historial, de acciones del informe comercial.
		 * 
		 * @param idActivo: ID del activo a filtrar los datos.
		 * @return Devuleve un dto con los datos obtenidos.
		 */
		public List<DtoEstadosInformeComercialHistorico> getEstadoInformeComercialByActivo(Long idActivo);

		/**
		 * Este método obtiene los estados, el historial, del mediador de la pestaña informe comercial.
		 * 
		 * @param idActivo: ID del activo a filtrar los datos.
		 * @return Devuleve un dto con los datos obtenidos.
		 */
		public List<DtoHistoricoMediador> getHistoricoMediadorByActivo(Long idActivo);

		/**
		 * Este método recibe un objeto con los condicionantes del activo y lo almacena en la DDBB.
		 * 
		 * @param id: ID del activo a filtrar los datos.
		 * @param dto: dto con los datos a insertar en la DDBB.
		 * @return Devuelve si se ha completado la operación con exito o no.
		 */
		public Boolean saveCondicionantesDisponibilidad(Long idActivo, DtoCondicionantesDisponibilidad dto);

		/**
		 * Este método recibe un ID de activo y obtiene los activos vinculados al mismo.
		 * 
		 * @param dto: dto con los datos a filtrar la busqueda para el page.
		 * @return Devuelve una lista con los datos obtenidos.
		 */
		public List<DtoPropuestaActivosVinculados> getPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto);

		/**
		 * Este método recibe un número de activo y el ID del activo de origen y crea un nuevo registro
		 * vinculando ambos.
		 * 
		 * @param dto: dto con los datos a insertar en la DDBB.
		 * @return Devuelve si se ha completado la operación con exito o no.
		 */
		public boolean createPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto);

		/**
		 * Este método borra de manera lógica la vinculación entre activos por el ID de la asociación.
		 * 
		 * @param dto: dto con los datos a borrar en la DDBB.
		 * @return Devuelve si se ha completado la operación con exito o no.
		 */
		public boolean deletePropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto);
		
		/**
		 * HREOS-846. Comprueba si el activo esta dentro del perímetro de Haya
		 * 
		 * @param idActivo Activo a comprobar
		 * @return true si esta dentro del perimetro Haya, false si esta fuera.
		 */
		public boolean isActivoIncluidoEnPerimetro(Long idActivo);
		
		/**
		 * Devuelve el perimetro del ID de un activo dado
		 * @param idActivo
		 * @return PerimetroActivo
		 */
		public PerimetroActivo getPerimetroByIdActivo(Long idActivo);
		
		/**
		 * Devuelve el perimetro de datos bancarios del ID de un activo dado
		 * @param idActivo
		 * @return ActivoBancario
		 */
		public ActivoBancario getActivoBancarioByIdActivo(Long idActivo);
		
		public PerimetroActivo saveOrUpdatePerimetroActivo(PerimetroActivo perimetroActivo);
		
		public ActivoBancario saveOrUpdateActivoBancario(ActivoBancario activoBancario);
		
		/**
		 * HREOS-843. Comrpueba si el activo tiene alguna oferta con el estado pasado por parámetro
		 * @param activo
		 * @param codEstado
		 * @return
		 */
		public boolean isActivoConOfertaByEstado(Activo activo, String codEstado);
		
		/**
		 * HREOS-843. Comprueba si el activo tiene alguna reserva con el estado pasado por parámetro
		 * @param activo
		 * @param codEstado
		 * @return
		 */
		public boolean isActivoConReservaByEstado(Activo activo, String codEstado);
		
		/**
		 * Devuelve una lista de reservas asociadas al activo pasado por parametro
		 * @param activo
		 * @return
		 */
		public List<Reserva> getReservasByActivo(Activo activo);
		
		/**
		 * HREOS-843. Comrpueba si el activo esta vendido, viendo si tiene fecha de escritura (en Formalizacion)
		 * @param activo
		 * @return
		 */
		public boolean isActivoVendido(Activo activo);
    }



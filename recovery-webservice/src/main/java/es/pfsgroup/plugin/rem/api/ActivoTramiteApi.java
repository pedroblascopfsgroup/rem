package es.pfsgroup.plugin.rem.api;

import java.util.List;
import java.util.Set;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.rem.model.DtoActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

/**
 * Interfaz para tratar los trámites de Activo.
 * 
 * @author Daniel Gutiérrez & Bender
 *
 */
public interface ActivoTramiteApi {

	
	
	public static final String CODIGO_TRAMITE_PREPARACION_EXP_JUD = "PCO";
	public static final String CODIGO_TRAMITE_NO_LITIGAR = "NOLIT";
	public static final String CODIGO_TRAMITE_ADMISION = "T001";
	public static final String CODIGO_TRAMITE_OBTENCION_DOC = "T002";
	public static final String CODIGO_TRAMITE_OBTENCION_DOC_CEE = "T003";
	public static final String CODIGO_TRAMITE_ACTUACION_TECNICA = "T004";
	public static final String CODIGO_TRAMITE_TASACION = "T005";
	public static final String CODIGO_TRAMITE_INFORME = "T006";
	public static final String CODIGO_TRAMITE_FACTURACION = "T007";
	public static final String CODIGO_TRAMITE_OBTENCION_DOC_CEDULA = "T008";
	public static final String CODIGO_TRAMITE_PROPUESTA_PRECIOS = "T009";
	public static final String CODIGO_TRAMITE_ACTUALIZA_PRECIOS = "T010";
	public static final String CODIGO_TRAMITE_APROBACION_INFORME_COMERCIAL = "T011";
	public static final String CODIGO_TRAMITE_ACTUALIZA_ESTADOS = "T012";
	public static final String CODIGO_TRAMITE_COMERCIAL_VENTA = "T013";
	public static final String CODIGO_TRAMITE_SANCION_OFERTA_ALQUILER = "T014";
	public static final String CODIGO_TRAMITE_COMUNICACION_GENCAT = "T016";
	public static final String CODIGO_TRAMITE_COMERCIAL_ALQUILER = "T015";
	public static final String CODIGO_TAREA_RESOLUCION_EXPEDIENTE = "T013_ResolucionExpediente";
	public static final String CODIGO_TRAMITE_COMERCIAL_VENTA_APPLE = "T017";
	public static final String CODIGO_TRAMITE_ALQUILER_NO_COMERCIAL = "T018";
	
	/**
	 * Recupera un trámite pasándole su id.
	 * @param idTramite
	 * @return
	 */
	public ActivoTramite get(Long idTramite);
	
	/**
	 * Devuelve el page de trámites asociados a un activo.
	 * @param idActivo
	 * @return Page
	 */
	public Page getTramitesActivo(Long idActivo, WebDto webDto);
	
	/**
	 * Devuelve la lista de trámites asociados a un activo.
	 * @param idActivo
	 * @return lista de activos
	 */
	public List<ActivoTramite> getListaTramitesActivo(Long idActivo);
	
	/**
	 * Devuelve los trámites de un trabajo
	 * @param idTrabajo
	 * @param webDto
	 * @return
	 */
	public Page getTramitesActivoTrabajo(Long idTrabajo,  WebDto webDto);
	
	/**
	 * Devuelve los trámites de un trabajo
	 * @param idTrabajo
	 * @param webDto
	 * @return
	 */
	public List<ActivoTramite>  getTramitesActivoTrabajoList(Long idTrabajo);
	

	/**
	 * Devuelve los activos relacionados con un tramite
	 * @param idTramite
	 * @return
	 */
	@BusinessOperationDefinition("activoTramiteManager.getActivosTramite")
	public List<Activo> getActivosTramite(Long idTramite);
	
	/**
	 * De una lista de activos, extrae los datos para el grid de Activos del Tramite
	 * @param listaActivos
	 * @return
	 */
	@BusinessOperationDefinition("activoTramiteManager.getDtoActivosTramite")
	public List<DtoActivoTramite> getDtoActivosTramite(List<Activo> listaActivos);
 
	
	/**
	 * Crea o actualiza un trámite en la base de datos.
	 * @param activoTramite
	 * @return
	 */
	public Long saveOrUpdateActivoTramite(ActivoTramite activoTramite);
	
	/**
	 * Devuelve el trámite de admisión del documento en caso de que lo tenga.
	 * @param idActivo
	 * @return activoTramite
	 */
	public ActivoTramite getTramiteAdmisionActivo(Long idActivo);
	
	/**
	 * Devuelve true si ya existe un trámite de admisión creado para el activo,
	 * false en caso contrario.
	 * @param idActivo
	 * @return
	 */
	public Boolean existeTramiteAdmision(Long idActivo);

	
	/**
	 * Método de validación de documento único, para tareas
	 * Devuelve TRUE si encuentra un documento en el activo, buscando por codigo documento 
	 * <p>
	 * @param  idActivo  identificador del Activo
	 * @param  codigoDocumento codigo del documento de DDTipoDocumentoActivo
	 * @param  uGestion Unidad de gestión a validar (A) Activo, (T) Trabajo
	 * @return	boolean
	 */
    @BusinessOperationDefinition("activoTramiteManager.existeAdjuntoUG")
	public Boolean existeAdjuntoUG(TareaExterna tareaExterna, String codigoDocAdjunto, String uGestion);
	
	/**
	 * Mensaje de validación para documento único.
	 * Obtiene un mensaje de validación estándar, para requerir un documento adjunto
	 * concreto, por unidad de gestión. El mensaje incluye la descripción del documento 
	 * y la unidad de gestión en la que debe adjuntarse
	 * <p>
	 * @param  tareaExterna tarea desde donde se invoca el método
	 * @param  codigoDocumento codigo del documento de DDTipoDocumentoActivo
	 * @param  uGestion Unidad de gestión a validar (A) Activo, (T) Trabajo
	 * @return String con el mensaje de validación
	 */
    @BusinessOperationDefinition("activoTramiteManager.existeAdjuntoUGValidacion")
	public String existeAdjuntoUGValidacion(TareaExterna tareaExterna, String codigoDocAdjunto, String uGestion);
	
    
	/**
	 * Mensaje que valida que el número de documentos de un tipo pasado por parámetro es igual o mayor al número de activos del expediente.
	 * @param  tareaExterna tarea desde donde se invoca el método
	 * @param  codigoDocumento codigo del documento de DDTipoDocumentoActivo
	 * @param  uGestion Unidad de gestión a validar (A) Activo, (T) Trabajo, (E Expediente)
	 * @return String con el mensaje de validación
	 */
    public String mismoNumeroAdjuntosComoActivosExpedienteUGValidacion(TareaExterna tareaExterna, String codigoDocAdjunto, String uGestion);
    	
    /**
	 * Método que valida si todos los activos del expediente tienen Fecha de emisión de informe jurídico
	 * @param  tareaExterna tarea desde donde se invoca el método
	 * @return Boolean true si todos los activos del expediente tienen Fecha de emisión de informe jurídico
	 */
    public Boolean checkFechaEmisionInformeJuridico(TareaExterna tareaExterna);
    
	/**
	 * Método de validación de documento múltiple, para tareas.
	 * Mediante una cadena codificada, realiza una validación de varios documentos
	 * a requerir, para una misma tarea. 
	 * <p>
	 * @param  tareaExterna codigo del documento de DDTipoDocumentoActivo
	 * @param  cadenaDAUG Cadena codificada en la que se indican los documentos y las
	 * 					unidades de gestión a validar para cada uno.
	 * @return boolean
	 */
    @BusinessOperationDefinition("activoTramiteManager.existeAdjuntoUGCadena")
	public Boolean existeAdjuntoUGCadena(TareaExterna tareaExterna, String cadenaDAUG);

	/**
	 * Mensaje de validación para documento múltiple, para tareas.
	 * Obtiene un mensaje de validación estándar, para requerir varios documentos adjuntos
	 * El mensaje incluye una lista con las descripciones de los documentos 
	 * y las unidades de gestión, en la que deben adjuntarse
	 * <p>
	 * @param  tareaExterna codigo del documento de DDTipoDocumentoActivo
	 * @param  cadenaDAUG Cadena codificada en la que se indican los documentos y las
	 * 					unidades de gestión a validar para cada uno.
	 * @return boolean
	 */
    @BusinessOperationDefinition("activoTramiteManager.existeAdjuntoUGValidacionCadena")
	public String existeAdjuntoUGValidacionCadena(TareaExterna tareaExterna, String cadenaDAUG);
	
    /**
     * Devuelve el número de tareas de fijación de plazo que existen para un trámite
     * @param tramite
     * @return
     */
	public int numeroFijacionPlazos(ActivoTramite tramite);
	
    /**
     * Devuelve el número de tareas de validacion trabajo que existen para un trámite
     * @param tramite
     * @return
     */
	public int numeroValidacionTrabajo(ActivoTramite tramite);
	/**
	 * Devuelve el último motivo de denegación del trámite de actuación técnica.
	 * @param tramite
	 * @return
	 */
	public String obtenerMotivoDenegacion(ActivoTramite tramite);
	
	/**
	 * Devuelve el valor de un campo de la tarea, a través del nombre del campo
	 * @param valores
	 * @param tevNombre
	 * @return
	 */
	public String getTareaValorByNombre(List<TareaExternaValor> valores, String tevNombre);
	
	/**
	 * Segun el campo pasado por parametro, buscara entre todas las tareas que hayan en el tramite
	 * y devolverá su valor, solo sirve para la primera coincidencia
	 * @param idToken
	 * @param tevNombre
	 * @return
	 */
	public String getValorTareasAnteriorByCampo(Long idToken, String tevNombre);
	
	
	/**
	 * Devuelve una lista de TareaProcedimiento abiertas del tramite pasado por parámetro
	 * @param idTramite
	 * @return List<TareaProcedimiento> lista de TareaProcedimiento con las tareas activas
	 */
	public List<TareaProcedimiento>  getTareasActivasByIdTramite(Long idTramite);
	
	
	/**
	 * Devuelve una lista de TareaExterna abiertas del tramite pasado por parámetro
	 * @param idTramite
	 * @return List<TareaExterna> lista de TareaExterna con las tareas activas
	 */
	public List<TareaExterna> getListaTareaExternaActivasByIdTramite(Long idTramite);
	
	/**
	 * Devuelve todas las tareas que hayan en el tramite abiertas y cerradas
	 * @param idTramite identificador del tramite	
	 * @return
	 */
	public List<TareaProcedimiento> getTareasByIdTramite(Long idTramite);

	/**
	 * Método de validación de documento único, para tareas teniendo en cuenta que dicha validacion se aplique solo para una determinada cartera pasada por parametro
	 * 
	 * @param tareaExterna
	 * @param codigoDocAdjunto
	 * @param uGestion
	 * @param cartera
	 * @return
	 */
	String existeAdjuntoUGCarteraValidacion(TareaExterna tareaExterna, String codigoDocAdjunto, String uGestion, String cartera);
	
	/**
	 * Devuelve true si el activo con el tipo de procedimiento tiene un tramite vigente
	 * @param idActivo
	 * @param codigoTipoProcedimiento
	 * @return 
	 */
	public Boolean tieneTramiteVigenteByActivoYProcedimiento(Long idActivo, String codigoTipoProcedimiento);
	
	/**
	 * Devuelve la TareaExterna anterior a la tarea con el código codigoTarea del tramite con id idTramite
	 * @param idTramite
	 * @param codigoTarea
	 * @return TareaExterna tarea anterior a la tarea con código codigoTarea del tramite con id idTramite
	 */
	public TareaExterna getTareaAnteriorByCodigoTarea(Long idTramite, String codigoTarea);
	
	/**
	 * Reactiva la tarea Resultado PBC
	 * @param tareaExterna
	 * @param expediente
	 * @return
	 */
	public void reactivarTareaResultadoPBC(TareaExterna tareaExterna, ExpedienteComercial expediente);

	List<TareaExterna> getListaTareaExternaByIdTramite(Long idTramite);
	
	/**
	 * Devuelve true si el activo afectado por GENCAT tiene un trámite de GENCAT vivo.
	 * @param idActivo
	 * @return 
	 */
	public boolean tieneTramiteGENCATVigenteByIdActivo(Long idExpediente);

	String mismoNumeroAdjuntosComoTareasTipoUGValidacion(TareaExterna tareaExterna, String codigoDocAdjunto,
			String uGestion, Long idTareaProcedimiento);

	ExpedienteComercial findOne(Long id);
	

	/*
	 * Devuelve true si la tarea viene de RatificacionComiteCES, en caso contrario False
	 * @param idTramite
	 * @return Boolean
	 */
	Boolean checkVieneDeRatificacionCES(Long idTramite);
	
	/*
	 * Devuelve true si el tramite tiene las tareas Informe Juridico y Resolución Pro Manzana completadas, en caso contrario False
	 * @param idTramite
	 * @return Boolean
	 */
	Boolean checkInformeJuridicoYResolucionManzanaCompletadas(Long idTramite);

	/*
	 * Devuelve false si la oferta es principal y no tiene ninguna dependiente adjuntada a ella
	 * @param tareaExterna
	 * @return Boolean
	 */
	Boolean esOfertaPrincipalSinDependientes(TareaExterna tareaExterna);

	boolean isTramiteVenta(TipoProcedimiento procedimiento);

	boolean isTramiteVentaApple(TipoProcedimiento procedimiento);

	TareaExterna getTareaActivaByCodigoAndTramite(Long idTramite, String codigoTarea);

	boolean isTramiteAlquilerNoComercial(TipoProcedimiento procedimiento);

	boolean isTramiteAlquiler(TipoProcedimiento procedimiento);
	
	Set<TareaExterna> getTareasActivasByExpediente(ExpedienteComercial eco);

	TipoProcedimiento getTipoTramiteByExpediente(ExpedienteComercial eco);
}


package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.rem.model.DtoActivoTramite;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

/**
 * Interfaz para tratar los trámites de Activo.
 * 
 * @author Daniel Gutiérrez & Bender
 *
 */
public interface ActivoTramiteApi {

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
	 * @param  codigoDocumento codigo del documento de DDTipoDocumentoActivo
	 * @param  uGestion Unidad de gestión a validar (A) Activo, (T) Trabajo
	 * @return boolean
	 */
    @BusinessOperationDefinition("activoTramiteManager.existeAdjuntoUGValidacion")
	public String existeAdjuntoUGValidacion(TareaExterna tareaExterna, String codigoDocAdjunto, String uGestion);
	
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
	 * Segun el campo pasado por parametro, buscara entre todas las tareas que hayan en el tramite
	 * y devolverá su valor, solo sirve para la primera coincidencia
	 * @param idToken
	 * @param tevNombre
	 * @return
	 */
	public List<TareaProcedimiento>  getTareasActivasByIdTramite(Long idTramite);
	
}

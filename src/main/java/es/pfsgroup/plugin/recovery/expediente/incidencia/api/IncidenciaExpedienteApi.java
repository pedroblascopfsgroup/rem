package es.pfsgroup.plugin.recovery.expediente.incidencia.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.expediente.incidencia.dto.DtoFiltroIncidenciaExpediente;
import es.pfsgroup.plugin.recovery.expediente.incidencia.dto.DtoIncidenciaExpediente;
import es.pfsgroup.plugin.recovery.expediente.incidencia.model.IncidenciaExpediente;
import es.pfsgroup.plugin.recovery.expediente.incidencia.model.SituacionIncidencia;
import es.pfsgroup.plugin.recovery.expediente.incidencia.model.TipoIncidencia;

/**
 * M�nager de la entidad incidencia.
 * 
 * @author �scar
 * 
 */
public interface IncidenciaExpedienteApi {

	public static final String BO_GET_LISTADO_INCIDENCIA_EXPEDIENTE = "es.pfsgroup.recovery.expediente.api.getListadoIncidenciaExpediente";
	public static final String BO_CREAR_INCINDENCIA = "es.pfsgroup.recovery.expediente.api.crearIncidencia";
	public static final String BO_BORRAR_INCIDENCIA = "es.pfsgroup.recovery.expediente.api.borrarIncidencia";
	public static final String BO_GET_INCIDENCIA_EXPEDIENTE = "es.pfsgroup.recovery.expediente.api.getIncidenciaExpediente";
	public static final String BO_GET_LISTADO_PERSONAS_EXPEDIENTE = "es.pfsgroup.recovery.expediente.api.getListadoPersonasExpediente";
	public static final String BO_GET_LISTADO_CONTRATOS_EXPEDIENTE = "es.pfsgroup.recovery.expediente.api.getListadoContratosExpediente";
	public static final String BO_GET_LISTADO_TIPOS_INCIDENCIAS = "es.pfsgroup.recovery.expediente.api.getListadoTiposIncidencias";
	public static final String BO_GET_LISTADO_PROVEEDORES = "es.pfsgroup.recovery.expediente.api.getListadoProveedores";
	public static final String BO_CREAR_NOTIFICACION = "es.pfsgroup.recovery.expediente.api.crearNotificacion";
	public static final String BO_ES_GESTOR_RECOBRO = "es.pfsgroup.recovery.expediente.api.esGestorRecobro";
	public static final String BO_GET_LISTADO_SITUACION_INCIDENCIA = "es.pfsgroup.recovery.expediente.api.getListadoSituacionIncidencia";
	public static final String BO_UPDATE_SITUACION_INCIDENCIA = "es.pfsgroup.recovery.expediente.api.updateSituacionIncidencia";
	public static final String BO_ES_GESTOR_RECOBRO_EXPEDIENTE = "es.pfsgroup.recovery.expediente.api.esGestorRecobroExpediente";
	public static final String BO_GET_LISTADO_PROVEEDORES_USU = "es.pfsgroup.recovery.expediente.api.getListadoProveedoresUsuario";
	public static final String BO_GET_LISTADO_INCIDENCIA_EXPEDIENTE_USU = "es.pfsgroup.recovery.expediente.api.getListadoIncidenciaExpedienteUsuario";
	
	
	@BusinessOperationDefinition(BO_GET_LISTADO_INCIDENCIA_EXPEDIENTE)
	public Page getListadoIncidenciaExpediente(DtoFiltroIncidenciaExpediente dto);

	@BusinessOperationDefinition(BO_CREAR_INCINDENCIA)
	public void crearIncidencia(DtoIncidenciaExpediente dto);

	@BusinessOperationDefinition(BO_BORRAR_INCIDENCIA)
	public void borrarIncidencia(Long id);

	@BusinessOperationDefinition(BO_GET_INCIDENCIA_EXPEDIENTE)
	public IncidenciaExpediente get(Long id);

	@BusinessOperationDefinition(BO_GET_LISTADO_PERSONAS_EXPEDIENTE)
	public List<Persona> getListadoPersonasExpediente(Long id);

	@BusinessOperationDefinition(BO_GET_LISTADO_CONTRATOS_EXPEDIENTE)
	public List<Contrato> getListadoContratosExpediente(Long id);

	@BusinessOperationDefinition(BO_GET_LISTADO_TIPOS_INCIDENCIAS)
	public List<TipoIncidencia> getListadoTiposIncidencia();

	@BusinessOperationDefinition(BO_GET_LISTADO_PROVEEDORES)
	public List<DespachoExterno> getListadoProveedores();

	@BusinessOperationDefinition(BO_CREAR_NOTIFICACION)
	@Deprecated
	public void creaNotificacion(IncidenciaExpediente iex);

	@BusinessOperationDefinition(BO_ES_GESTOR_RECOBRO)
	public Boolean esGestorRecobro(Usuario usu);

	@BusinessOperationDefinition(BO_GET_LISTADO_SITUACION_INCIDENCIA)
	public List<SituacionIncidencia> getListadoSituacionIncidencia();

	@BusinessOperationDefinition(BO_UPDATE_SITUACION_INCIDENCIA)
	public void updateIncidencia(Long id, Long situacion);

	/**
	 * Devuelve true si ese usuario es el gestor de recobro de ese expediente
	 * @param usu
	 * @param idExpediente
	 * @return
	 */
	@BusinessOperationDefinition(BO_ES_GESTOR_RECOBRO_EXPEDIENTE)
	public Boolean esGestorRecobroExpediente(Usuario usu, Long idExpediente);

	/**
	 * Devuelve la lista de despachos externos de tipo "Agencia de Recobro"
	 * en los que esté dado de alta el usuario logado si este es externo
	 * Si no es externo devuelve todos los despachos de ese tipo
	 * @return
	 */
	@BusinessOperationDefinition(BO_GET_LISTADO_PROVEEDORES_USU)
	public List<DespachoExterno> getListadoProveedoresUsuario();
	
	/**
	 * Devuelve la lista de incidencias que cumplen el criterio de búsqueda
	 * Si el usuario logado es interno o tiene visibilidad total busca entre todas las incidencias
	 * Si es externo y no tiene permiso de visibilidad total sólo busca entre las que ha dado de alta el
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(BO_GET_LISTADO_INCIDENCIA_EXPEDIENTE_USU)
	public Page getListadoIncidenciaExpedienteUsuario(
			DtoFiltroIncidenciaExpediente dto);
}
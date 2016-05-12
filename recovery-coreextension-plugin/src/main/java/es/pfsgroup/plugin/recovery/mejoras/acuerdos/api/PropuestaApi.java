package es.pfsgroup.plugin.recovery.mejoras.acuerdos.api;

import java.util.Date;
import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.acuerdo.CumplimientoAcuerdoDto;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.ext.impl.acuerdo.dto.DTOActuacionesExplorarExpediente;
import es.pfsgroup.recovery.ext.impl.acuerdo.dto.DTOActuacionesRealizadasExpediente;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTActuacionesAExplorarExpediente;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTActuacionesRealizadasExpediente;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

public interface PropuestaApi {

	public static final String BO_PROPUESTA_GET_LISTADO_PROPUESTAS = "mejacuerdo.listadoPropuestasByExpedienteId";
	public static final String BO_PROPUESTA_ES_GESTOR_SUPERVISOR_ACTUAL = "propuestaApi.usuarioLogadoEsGestorSupervisorActual";
	public static final String BO_PROPUESTA_GET_LISTADO_CONTRATOS_DEL_EXPEDIENTE = "mejacuerdo.listadoContratosByExpedienteId";
	public static final String BO_PROPUESTA_GET_LISTADO_PROPUESTAS_REALIZADAS_BY_EXPEDIENTE_ID = "propuestaApi.listadoPropuestasRealizadasByExpedienteId";
	public static final String BO_PROPUESTA_GET_LISTADO_PROPUESTAS_EXPLORAR_BY_EXPEDIENTE_ID = "propuestaApi.listadoPropuestasExplorarByExpedienteId";
	public static final String BO_PROPUESTA_SAVE_ACTUACION_REALIZADA_EXPEDIENTE = "propuestaApi.saveActuacionesRealizadasExpediente";
	public static final String BO_PROPUESTA_GET_ACTUACION_REALIZADAS_EXPEDIENTE = "propuestaApi.getActuacionRealizadasExpediente";
	public static final String BO_PROPUESTA_GET_ACTUACION_EXPLORAR_EXPEDIENTE = "propuestaApi.getActuacionExplorarExpediente";
	public static final String BO_PROPUESTA_SAVE_ACTUACION_EXPLORAR_EXPEDIENTE = "propuestaApi.saveActuacionesExplorarExpediente";
	public static final String BO_PROPUESTA_GET_EXPEDIENTES = "propuestaApi.getBienesDelExpedienteParaLaPropuesta";
	public static final String BO_PROPUESTA_CAMBIAR_ESTADO = "propuestaApi.cambiarEstadoPropuesta";
	

	@BusinessOperationDefinition(BO_PROPUESTA_GET_LISTADO_PROPUESTAS)
    @Transactional(readOnly = false)
    public List<EXTAcuerdo> listadoPropuestasByExpedienteId(Long idExpediente);

	@BusinessOperationDefinition(BO_PROPUESTA_GET_LISTADO_CONTRATOS_DEL_EXPEDIENTE)
    @Transactional(readOnly = false)
    public List<Contrato> listadoContratosByExpedienteId(Long idExpediente);

	/**
	 * El usuario logado es Gestor o Supervisor de la fase en que se encuentra el Expediente
	 * 
	 * @param idExpediente
	 * @return
	 */
	@BusinessOperationDefinition(BO_PROPUESTA_ES_GESTOR_SUPERVISOR_ACTUAL)
	public Boolean usuarioLogadoEsGestorSupervisorActual(Long idExpediente);

	/**
	 * 
	 * @param idPropuesta
	 */
	public void proponer(Long idPropuesta);
	
    @BusinessOperationDefinition(BO_PROPUESTA_GET_LISTADO_PROPUESTAS_REALIZADAS_BY_EXPEDIENTE_ID)
    public List<EXTActuacionesRealizadasExpediente> listadoPropuestasRealizadasByExpedienteId(Long id);
    
    @BusinessOperationDefinition(BO_PROPUESTA_GET_LISTADO_PROPUESTAS_EXPLORAR_BY_EXPEDIENTE_ID)
    public List<EXTActuacionesAExplorarExpediente> listadoActuacionesAExplorarExpediente(Long idExpediente);
    
    @BusinessOperationDefinition(BO_PROPUESTA_SAVE_ACTUACION_REALIZADA_EXPEDIENTE)
    public void saveActuacionesRealizadasExpediente(DTOActuacionesRealizadasExpediente dto);
    
    @BusinessOperationDefinition(BO_PROPUESTA_GET_ACTUACION_REALIZADAS_EXPEDIENTE)
    public EXTActuacionesRealizadasExpediente getActuacionRealizadasExpediente(Long idActuacion);
    
    @BusinessOperationDefinition(BO_PROPUESTA_GET_ACTUACION_EXPLORAR_EXPEDIENTE)
    public EXTActuacionesAExplorarExpediente getActuacionExplorarExpediente(Long idActuacion);
    
    @BusinessOperationDefinition(BO_PROPUESTA_SAVE_ACTUACION_EXPLORAR_EXPEDIENTE)
    public void saveActuacionesExplorarExpediente(DTOActuacionesExplorarExpediente dto);

	public void cancelar(Long idPropuesta);

	/**
	 * @param idAcuerdo
	 * @param fechaEstado
	 * @param cumplido
	 * @param observaciones
	 */
	public void finalizar(Long idAcuerdo, Date fechaPago, Boolean cumplido, String observaciones);
	
	/**
	 * 
	 * @param idPropuesta
	 * @param motivo
	 */
	public void rechazar(Long idPropuesta, String motivo, String observaciones);
	
    @BusinessOperationDefinition(BO_PROPUESTA_GET_EXPEDIENTES)
    public List<Bien> getBienesDelExpedienteParaLaPropuesta(Long idExpediente, List<Long> contratosIncluidos);

	
	/**
	 * Valida que TODAS las propuestas pasadas cumplan con alguno de los Estados validos pasados
	 * @param propuestas
	 * @param codigosEstadosValidos
	 * @return
	 */
	public Boolean estadoTodasPropuestas(List<EXTAcuerdo> propuestas, List<String> codigosEstadosValidos);
	
	/**
	 * Método público para cambiar de estado a una propuesta y generar si es requerido el correspondiente Evento
	 * @param propuesta
	 * @param nuevoCodigoEstado
	 * @param generarEvento
	 */
	@BusinessOperationDefinition(BO_PROPUESTA_CAMBIAR_ESTADO)
	@Transactional(readOnly = false)
	public void cambiarEstadoPropuesta(Acuerdo propuesta, String nuevoCodigoEstado, boolean generarEvento);
	
	/**
	 * Valida que AL MENOS UNA las propuestas pasadas cumplan con alguno de los Estados validos pasados
	 * @param propuestas
	 * @param codigosEstadosValidos
	 * @return
	 */	
	public Boolean estadoAlgunaPropuesta(List<EXTAcuerdo> propuestas, List<String> codigosEstadosValidos);	
	
	
    /**
     * @param id Long
     */
    public void cerrarPropuesta(Long id) ;
    
    
    /**
     * @param dto CumplimientoAcuerdoDto
     */
    public void registraCumplimientoPropuesta(CumplimientoAcuerdoDto dto);
    
    /**
     * @param Long idExpediente
     * @param String estadoAcuerdo
     */
    public List<EXTAcuerdo> listadoPropuestasDelExpediente(Long idExpediente, String estadoAcuerdo);
    
    /**
     * @param Long idPropuesta
     */
    public List<Contrato> contratosIncluidosEnLosTerminosDeLaPropuesta(Long idPropuesta);
    
    /**
     * 
     * @param idPropuesta
     * @param idAsunto
     */
    public void asignaPropuestaAlAsunto(Long idPropuesta, Long idAsunto);
}

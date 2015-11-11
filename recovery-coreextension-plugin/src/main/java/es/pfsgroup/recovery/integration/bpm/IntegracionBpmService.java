package es.pfsgroup.recovery.integration.bpm;

import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.integration.IntegrationClassCastException;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJFinalizarAsuntoDto;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;

public interface IntegracionBpmService {

	public static final String TIPO_TAREA_NOTIFICACION = "TAREA-NOTIF";
	
	public static final String TIPO_INICIO_TAREA = "BPM-TAREA-INICIO";
	public static final String TIPO_FINALIZACION_TAREA = "BPM-TAREA-FIN";
	public static final String TIPO_CANCELACION_TAREA = "BPM-TAREA-CANCEL";
	public static final String TIPO_PARALIZAR_TAREA = "BPM-TAREA-PARALIZAR";
	public static final String TIPO_ACTIVAR_TAREA = "BPM-TAREA-ACTIVAR";
	public static final String TIPO_FIN_BPM = "BPM-FIN";
	
	public static final String TIPO_ACTIVAR_BPM = "DO-ACTIVAR-BPM";
	public static final String TIPO_FIN_ASUNTO = "DO-FIN-ASUNTO";

	public final static String TIPO_DATOS_ACUERDO = "DATOS-ACUERDO";

	public final static String TIPO_DATOS_ACUERDO_ACT_REALIZAR = "DATOS-ACUERDO-ACT-REALIZAR";  
	public final static String TIPO_DATOS_ACUERDO_ACT_A_EXP = "DATOS-ACUERDO-ACT-AEXPL";  
	public final static String TIPO_DATOS_ACUERDO_TERMINO = "DATOS-ACUERDO-TERMINO";  
	
	public final static String TIPO_DATOS_RECURSO = "DATOS-RECURSO";  
	public final static String TIPO_DATOS_SUBASTA = "DATOS-SUBASTA";  
	
	public final static String TIPO_DATOS_DECISION_PROCEDIMIENTO = "DATOS-DECISION-PROCEDIMIENTO";
	
	
	/**
	 * Envia mensaje de notificación de tarea
	 * 
	 * @param tareaExterna
	 */
    void notificaTarea(TareaNotificacion tareaNotificacion);
	
	/**
	 * Envia mensaje de inicio de tarea
	 * 
	 * @param tareaExterna
	 */
    void notificaInicioTarea(TareaExterna tareaExterna);
    
	/**
	 * Envia mensaje de fin de tarea
	 * 
	 * @param tareaExterna
	 * @param transicion
	 * 
	 * @throws IntegrationClassCastException 
	 */
    void notificaFinTarea(TareaExterna tareaExterna, String transicion);

    /**
     * Cancela la tarea
     * 
     * @param tareaExterna
     */
	void notificaCancelarTarea(TareaExterna tareaExterna);

	/**
	 * Paraliza una tarea
	 * 
     * @param tareaExterna
	 */
	void notificaParalizarTarea(TareaExterna tareaExterna);

	/**
	 * ACtiva una tarea paralizada
	 * 
     * @param tareaExterna
	 */
	void notificaActivarTarea(TareaExterna tareaExterna);

	/**
	 * Notificar finalización de BPM
	 * 
	 * @param procedimiento
	 * @param nombre
	 */
	void notificaFinBPM(Procedimiento procedimiento, String tarGuidOrigen, String nombre);

	/**
	 * Genera una transicion de Activar un BPM
	 * 
	 * @param tipoProcedimiento
	 * @param procPadre
	 */
	void activarBPM(Procedimiento procedimiento);

	/**
	 * Genera una transicion para Finalizar un asunto.
	 * 
	 * @param asunto Asunto que vamos a finalizar.
	 */
	void finalizarAsunto(MEJFinalizarAsuntoDto finAsunto);
	
	/**
	 * Envía un mensaje de actualización de un recurso
	 * 
	 * @param recurso
	 */
    public void actualizar(MEJRecurso recurso);

    /**
     * Enviar datos de subasta
     * 
     * @param subasta
     */
	void enviarDatos(Subasta subasta);

	void enviarDatos(Acuerdo acuerdo);
	void notificaCambioEstado(Acuerdo acuerdo);
	
	void enviarDatos(ActuacionesRealizadasAcuerdo actuacionRealizada);
	void enviarDatos(ActuacionesAExplorarAcuerdo actuacionAExplorar);
	void enviarDatos(TerminoAcuerdo terminoAcuerdo);

	/**
	 * Envía una decisión sobre un procedimiento mediante mensajería.
	 * 
	 * @param decisionProcedimiento
	 */
	void enviarDatos(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento);


}

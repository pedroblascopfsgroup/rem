package es.pfsgroup.recovery.integration.bpm;

import java.util.Date;

import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;

public interface IntegracionBpmService {

	public static final String TIPO_TAREA_NOTIFICACION = "TAREA-NOTIF";
	
	public static final String TIPO_INICIO_TAREA = "BPM-TAREA-INICIO";
	public static final String TIPO_FINALIZACION_TAREA = "BPM-TAREA-FIN";
	public static final String TIPO_CANCELACION_TAREA = "BPM-TAREA-CANCEL";
	public static final String TIPO_PARALIZAR_TAREA = "BPM-TAREA-PARALIZAR";
	public static final String TIPO_ACTIVAR_TAREA = "BPM-TAREA-ACTIVAR";
	public static final String TIPO_PRORROGA_TAREA = "BPM-TAREA-PRORROGA";
	public static final String TIPO_FIN_BPM = "BPM-FIN";
	
	public static final String TIPO_FINALIZAR_BPM = "DO-FINALIZAR-BPM";
	public static final String TIPO_PARALIZAR_BPM = "DO-PARALIZAR-BPM";
	public static final String TIPO_ACTIVAR_BPM = "DO-ACTIVAR-BPM";

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
	 * Notificar crear tarea notificacion
	 * 
     * @param tareaExterna
	void notificaInicioRecurso(TareaNotificacion tarea);
	 */

	/**
	 * Notificar borrado de tarea notificacion
	 * 
     * @param tareaExterna
	void notificaFinRecurso(TareaNotificacion tarea);
	 */
	
	/**
	 * Notificar finalización de BPM
	 * 
	 * @param procedimiento
	 * @param nombre
	 */
	void notificaFinBPM(Procedimiento procedimiento, String tarGuidOrigen, String nombre);

	
	/**
	 * Genera una transicion de BPM
	 * 
	 * @param tipoProcedimiento
	 * @param procPadre
	 */
	//void transicionarBPM(Procedimiento procedimiento, String transicion);

	/**
	 * Genera una transición en una tarea de un BPM
	 * 
	 * @param tareaExterna
	 * @param transicion
	 */
	//void transicionarBPM(TareaExterna tareaExterna, String transicion);

	/**
	 * Genera una transicion de Paralizar un BPM
	 * 
	 * @param tipoProcedimiento
	 */
	void paralizarBPM(Procedimiento procedimiento, Date fechaActivacion);

	/**
	 * Genera una transicion de Activar un BPM
	 * 
	 * @param tipoProcedimiento
	 * @param procPadre
	 */
	void activarBPM(Procedimiento procedimiento);
	
	/**
	 * Genera una transicion de Fin a un BPM
	 * 
	 * @param tipoProcedimiento
	 * @param procPadre
	 */
	void finalizarBPM(Procedimiento procedimiento);
	
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

	void enviarDatos(DecisionProcedimiento decisionProcedimiento);


}

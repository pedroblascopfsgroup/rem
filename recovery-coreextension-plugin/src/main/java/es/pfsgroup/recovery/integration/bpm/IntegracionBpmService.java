package es.pfsgroup.recovery.integration.bpm;

import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;

public interface IntegracionBpmService {

	public static final String TIPO_INICIO_TAREA = "BPM-TAREA-INICIO";
	public static final String TIPO_FINALIZACION_TAREA = "BPM-TAREA-FIN";
	public static final String TIPO_CANCELACION_TAREA = "BPM-TAREA-CANCEL";
	public static final String TIPO_PARALIZAR_TAREA = "BPM-TAREA-PARALIZAR";
	public static final String TIPO_ACTIVAR_TAREA = "BPM-TAREA-ACTIVAR";
	public static final String TIPO_FIN_BPM = "BPM-FIN";
	
	public static final String TIPO_FINALIZAR_BPM = "DO-FINALIZAR-BPM";
	public static final String TIPO_PARALIZAR_BPM = "DO-PARALIZAR-BPM";
	public static final String TIPO_ACTIVAR_BPM = "DO-ACTIVAR-BPM";

	public static final String TIPO_CAB_ACUERDO_PROPUESTA = "UPD-ACUERDO-PROP";
	public static final String TIPO_CAB_ACUERDO_CIERRE = "UPD-ACUERDO-CIERRE";
	public static final String TIPO_CAB_ACUERDO_RECHAZAR = "UPD-ACUERDO-RECH";
	public static final String TIPO_CAB_ACUERDO_ACEPTAR = "UPD-ACUERDO-ACEP";
	public static final String TIPO_CAB_ACUERDO_FINALIZAR = "UPD-ACUERDO-FIN";

	public final static String TIPO_CAB_RECURSO = "CAB-UPD-RECURSO";  
	public final static String TIPO_CAB_SUBASTA = "CAB-UPD-SUBASTA";  
	
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
	 * @param procPadre
	 */
	void paralizarBPM(Procedimiento procedimiento);

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
     * Enviar cabecera de subasta
     * 
     * @param subasta
     */
	void enviarCabecera(Subasta subasta);
 
	void enviarPropuesta(Acuerdo acuerdo);

	void enviarRechazo(Acuerdo acuerdo);

	void enviarCierre(Acuerdo acuerdo);

	void enviarAceptar(Acuerdo acuerdo);

	void enviarFinalizar(Acuerdo acuerdo);

}

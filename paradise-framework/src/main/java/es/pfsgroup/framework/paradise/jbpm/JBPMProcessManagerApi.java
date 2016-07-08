package es.pfsgroup.framework.paradise.jbpm;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.jbpm.svc.Service;

public interface JBPMProcessManagerApi {

	public static final String BEAN_KEY = "jbpmTools";

	/**
	 * Crear un nuevo processo.
	 * @param instanceName nombre de la instancia
	 * @param param parametros
	 * @return id del proceso creado
	 */
	public abstract long crearNewProcess(String instanceName,
			Map<String, Object> param);

	/**
	 * Destruye un proceso de expediente activo.
	 * @param idProcess id de proceso
	 */
	public abstract void destroyProcess(Long idProcess);

	/**
	 * hace avanzar un proceso.
	 * @param idProcess id proceso
	 * @param transitionName nombre transicion
	 */
	public abstract void signalProcess(Long idProcess, String transitionName);

	/**
	 * Devuelve cierto o falso en funciÃ³n de si existe o no la transición en el token activo.
	 * @param idToken id del token
	 * @param transitionName nombre de la transicion
	 * @return tiene o no
	 */
	public abstract Boolean hasTransitionToken(Long idToken,
			String transitionName);

	/** Hace avanzar un token.
	 * @param idToken id del token
	 * @param transitionName nombre de la transicion
	 */
	public abstract void signalToken(Long idToken, String transitionName);

	/**
	 * Obteniene el nombre del nodo actual.
	 * @param idProcess id del proceso
	 * @return nombre del nodo actual
	 */
	public abstract String getActualNode(Long idProcess);

	/**
	 * Agrega una nueva variable dentro de la ejecucion.
	 * @param idProcess id del proceso
	 * @param variables variables a insertar en el proceso
	 */
	public abstract void addVariablesToProcess(Long idProcess,
			Map<String, Object> variables);

	/**
	 * Devuelve una nueva variable dentro de la ejecucion.
	 * @param idProcess id del proceso
	 * @param variableName nombre de la variable a obtener
	 * @return objecto
	 */
	public abstract Object getVariablesToProcess(Long idProcess,
			String variableName);

	/**
	 * devuelve la fecha de fin de un proceso.
	 * @param idProcess el proceso para el cual se busca la fecha de fin
	 * @param nameTimer el nombre del timer
	 * @return la fecha de fin.
	 */
	public abstract Date obtenerFechaFinProceso(Long idProcess, String nameTimer);

	/**
	 * Actualiza un timer si existe o lo crea de nuevo.
	 * @param idProcess Long
	 * @param nameTimer String
	 * @param newDueDate Date
	 * @param nameTransition String
	 */
	public abstract void creaORecalculaTimer(Long idProcess, String nameTimer,
			Date newDueDate, String nameTransition);

	/**
	 * Recalcula el timer con un nuevo plazo.
	 *
	 * @param idProcess idProceso
	 * @param nameTimer nombre del timer
	 * @param newDueDate nuevo plazo
	 */
	public abstract void recalculaTimer(Long idProcess, String nameTimer,
			Date newDueDate);

	/**
	 * determinarBBDD.
	 */
	public abstract void determinarBBDD();

	/**
	 * Aplaza las tareas del BPM hasta una determinada fecha que arrancarán.
	 * @param idProcess ID del Proceso BPM que se desea aplazar
	 * @param fechaActivacion Fecha en la que se activarán las tareas de nuevo
	 */
	public abstract void aplazarProcesosBPM(Long idProcess, Date fechaActivacion);

	/**
	 * Paraliza los procesos de un BPM. Lo único que hará este método es mandar una transición "TRANSICION_PARALIZAR_TAREAS" a los tokens activos
	 * @param idProcess id del proceso
	 */
	public abstract void paralizarProcesosBPM(Long idProcess);

	/**
	 * Activa los procesos de un BPM paralizados. Lo único que hará este método es mandar una transición "TRANSICION_ACTIVAR_TAREAS" a los tokens activos.
	 * @param idProcess id del proceso
	 */
	public abstract void activarProcesosBPM(Long idProcess);



	/**
	 * Señaliza una transición sobre un proceso o sobre sus tokens activos.
	 * El propio método buscará todos los tokens activos y lanzará un signal por cada uno de ellos
	 * @param idProcess ID del proceso BPM
	 * @param nombreTransicion Nombre de la transición que se desea lanzar
	 */
	public abstract void signalProcessOrTokens(Long idProcess,
			String nombreTransicion);


	/**
	 * Recupera una variable estática del contexto del BPM.
	 * @param idToken Id del token del que queremos recuperar
	 * @param variable Nombre de la variable
	 * @return Devuelve la variable del contexto BPM
	 */
	public abstract Object getProcessVariable(Long idToken, String variable);

	/**
	 * Stop job executor.
	 */
	public abstract void stopJobExecutor();

	/**
	 * Start job executor.
	 */
	public abstract void startJobExecutor();

	public abstract Service getJBPMServiceFactory(String serviceName);
	
	public void setContextScripts(List<String> contextScript);

}
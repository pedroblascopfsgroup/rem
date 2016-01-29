package es.pfsgroup.recovery.api;

import java.util.Date;
import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface JBPMProcessApi {
	
	 /**
     * Crear un nuevo processo.
     * @param instanceName nombre de la instancia
     * @param param parametros
     * @return id del proceso creado
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS)
    @Transactional(readOnly = false)
    public long crearNewProcess(String instanceName, Map<String, Object> param) ;
    
    
    /**
     * Finaliza el procedimiento. Detiene el proceso BPM, finaliza las tareas activas y las decisiones.
     * @param idProcedimiento id del proceso
     * @throws Exception e
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_FINALIZAR_PROC)
    public void finalizarProcedimiento(final Long idProcedimiento) throws Exception;
    
    /**
     * Aplaza las tareas del BPM hasta una determinada fecha que arrancarï¿½n.
     * @param idProcess ID del Proceso BPM que se desea aplazar
     * @param fechaActivacion Fecha en la que se activarï¿½n las tareas de nuevo
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_APLAZAR_PROCESOS_BPM)
    public void aplazarProcesosBPM(Long idProcess, Date fechaActivacion);
    
    /**
     * hace avanzar un proceso.
     * @param idProcess id proceso
     * @param transitionName nombre transicion
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS)
    public void signalProcess(final Long idProcess, final String transitionName);

	 /**
     * Crea un contexto propio para la evaluaciï¿½n en relaciï¿½n con el procedimiento, la tarea externa y el contexto original
     * y evalua el script que se le pasa como parï¿½metro.
     * @param idProcedimiento ID del procedimiento para crear el contexto
     * @param idTareaExterna ID de la tarea externa para crear el contexto
     * @param idTareaProcedimiento ID de la tarea del procedimimento
     * @param contextoOriginal Contexto Original para crear el contexto
     * @param script Script que se evaluarï¿½
     * @return Resultado de la evaluaciï¿½n en formato String
     * @throws Exception Exception
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_EVALUA_SCRIPT)
    public Object evaluaScript(Long idProcedimiento, Long idTareaExterna, Long idTareaProcedimiento, Map<String, Object> contextoOriginal,
            String script) throws Exception;
    
    /**
     * Lanza un BPM asociado a un procedimiento.
     * @param idProcedimiento El id del procedimiento del cual se va a lanzar su BPM
     * @param idTokenAviso Si es llamado desde otro BPM, el id del token al que debe avisar. (Este parï¿½metro puede ser null)
     * @return Devuelve el ID del process BPM que se ha creado
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_LANZAR_BPM_ASOC_PROC)
    public Long lanzaBPMAsociadoAProcedimiento(Long idProcedimiento, Long idTokenAviso);
    
    /**
     * Crea un nuevo procedimiento derivado de otro procedimiento padre.
     * @param tipoProcedimiento Tipo de procedimiento que se va a generar
     * @param procPadre Procedimiento padre para copiar sus valores
     * @return Devuelve el nuevo procedimiento creado
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_CREA_PROCEDIMIENTO_HIJO)
    public Procedimiento creaProcedimientoHijo(TipoProcedimiento tipoProcedimiento, Procedimiento procPadre);
    
    /**
     * Destruye un proceso de expediente activo.
     * @param idProcess id de proceso
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS)
    public void destroyProcess(final Long idProcess);
    
    /** Método de ayuda para obtener una variable tipo Boolean de JBPM. Hemos comprobado que no convierte bien cuando se
     * guardan objetos boolean. A veces los devuelve como String
     * @param executionContext ExecutionContext
     * @param key String
     * @return boolean
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_GET_FIXE_BOOLEAN_VALUE)
    public Boolean getFixeBooleanValue(ExecutionContext executionContext, String key);
    
    
    /**
     * Obteniene el nombre del nodo actual.
     * @param idProcess id del proceso
     * @return nombre del nodo actual
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_GET_ACTUAL_NODE)
    public String getActualNode(final Long idProcess);
    
    /**
     * Agrega una nueva variable dentro de la ejecucion.
     * @param idProcess id del proceso
     * @param variables variables a insertar en el proceso
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_ADD_VARIABLES_TO_PROCESS)
    public void addVariablesToProcess(final Long idProcess, final Map<String, Object> variables);
    
    /**
     * Actualiza un timer si existe o lo crea de nuevo.
     * @param idProcess Long
     * @param nameTimer String
     * @param newDueDate Date
     * @param nameTransition String
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_CREA_O_RECALCULA_TIMER)
    public void creaORecalculaTimer(final Long idProcess, String nameTimer, Date newDueDate, String nameTransition);
    
    /**
     * Devuelve una nueva variable dentro de la ejecucion.
     * @param idProcess id del proceso
     * @param variableName nombre de la variable a obtener
     * @return objecto
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS)
    public Object getVariablesToProcess(final Long idProcess, final String variableName);

    /**
     * devuelve la fecha de fin de un proceso.
     * @param idProcess el proceso para el cual se busca la fecha de fin
     * @param nameTimer el nombre del timer
     * @return la fecha de fin.
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_OBTENER_FECHA_FIN_PROCESO)
    public Date obtenerFechaFinProceso(final Long idProcess, String nameTimer);

    /**
     * Recalcula el timer con un nuevo plazo.
     *
     * @param idProcess idProceso
     * @param nameTimer nombre del timer
     * @param newDueDate nuevo plazo
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_RECALCULAR_TIMER)
    public void recalculaTimer(final Long idProcess, String nameTimer, Date newDueDate);
}

package es.capgemini.pfs.utils;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.jbpm.graph.exe.ExecutionContext;
import org.jbpm.svc.Service;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;

/**
 * Clase de utilidad que da soporte al procesos JBPM.
 * @author jbosnjak
 */
@org.springframework.stereotype.Service(JBPMProcessManager.BEAN_KEY)
@Scope(BeanDefinition.SCOPE_SINGLETON)
public class JBPMProcessManager implements BPMContants {

    public static final String BEAN_KEY = "jbpmUtil";

    

    /**
     * Crear un nuevo processo.
     * @param instanceName nombre de la instancia
     * @param param parametros
     * @return id del proceso creado
     */
   
    public long crearNewProcess(String instanceName, Map<String, Object> param) {
       
        return 0;
    }

   

    

    /**
     * Destruye un proceso de expediente activo.
     * @param idProcess id de proceso
     */
    
    public void destroyProcess(final Long idProcess) {
    }

    /**
     * hace avanzar un proceso.
     * @param idProcess id proceso
     * @param transitionName nombre transicion
     */
    public void signalProcess(final Long idProcess, final String transitionName) {
    }

    /**
     * Devuelve cierto o falso en función de si existe o no la transici�n en el token activo.
     * @param idToken id del token
     * @param transitionName nombre de la transicion
     * @return tiene o no
     */
    public Boolean hasTransitionToken(final Long idToken, final String transitionName) {
        return null;
    }

    /** Hace avanzar un token.
     * @param idToken id del token
     * @param transitionName nombre de la transicion
     */
    public void signalToken(final Long idToken, final String transitionName) {
        
    }

    /**
     * Obteniene el nombre del nodo actual.
     * @param idProcess id del proceso
     * @return nombre del nodo actual
     */
    public String getActualNode(final Long idProcess) {
        return null;
    }

    /**
     * Agrega una nueva variable dentro de la ejecucion.
     * @param idProcess id del proceso
     * @param variables variables a insertar en el proceso
     */
    public void addVariablesToProcess(final Long idProcess, final Map<String, Object> variables) {
        
    }

    /**
     * Devuelve una nueva variable dentro de la ejecucion.
     * @param idProcess id del proceso
     * @param variableName nombre de la variable a obtener
     * @return objecto
     */
    public Object getVariablesToProcess(final Long idProcess, final String variableName) {
        return null;
    }

   

    /**
     * devuelve la fecha de fin de un proceso.
     * @param idProcess el proceso para el cual se busca la fecha de fin
     * @param nameTimer el nombre del timer
     * @return la fecha de fin.
     */
    public Date obtenerFechaFinProceso(final Long idProcess, String nameTimer) {
        return null;
    }

    /**
     * Actualiza un timer si existe o lo crea de nuevo.
     * @param idProcess Long
     * @param nameTimer String
     * @param newDueDate Date
     * @param nameTransition String
     */
    public void creaORecalculaTimer(final Long idProcess, String nameTimer, Date newDueDate, String nameTransition) {
    }

    /**
     * Recalcula el timer con un nuevo plazo.
     *
     * @param idProcess idProceso
     * @param nameTimer nombre del timer
     * @param newDueDate nuevo plazo
     */
    public void recalculaTimer(final Long idProcess, String nameTimer, Date newDueDate) {
    }

    /**
     * determinarBBDD.
     */
    public void determinarBBDD() {
    }

    /**
     * Aplaza las tareas del BPM hasta una determinada fecha que arrancar�n.
     * @param idProcess ID del Proceso BPM que se desea aplazar
     * @param fechaActivacion Fecha en la que se activar�n las tareas de nuevo
     */
    public void aplazarProcesosBPM(Long idProcess, Date fechaActivacion) {
    }

    /**
     * Paraliza los procesos de un BPM. Lo �nico que har� este m�todo es mandar una transici�n "TRANSICION_PARALIZAR_TAREAS" a los tokens activos
     * @param idProcess id del proceso
     */
    public void paralizarProcesosBPM(final Long idProcess) {
    }

    /**
     * Activa los procesos de un BPM paralizados. Lo �nico que har� este m�todo es mandar una transici�n "TRANSICION_ACTIVAR_TAREAS" a los tokens activos.
     * @param idProcess id del proceso
     */
    public void activarProcesosBPM(final Long idProcess) {
    }

    /**
     * Finaliza el procedimiento. Detiene el proceso BPM, finaliza las tareas activas y las decisiones.
     * @param idProcedimiento id del proceso
     * @throws Exception e
     */
    public void finalizarProcedimiento(final Long idProcedimiento) throws Exception {

    }

    /**
     * Se�aliza una transici�n sobre un proceso o sobre sus tokens activos.
     * El propio m�todo buscar� todos los tokens activos y lanzar� un signal por cada uno de ellos
     * @param idProcess ID del proceso BPM
     * @param nombreTransicion Nombre de la transici�n que se desea lanzar
     */
    public void signalProcessOrTokens(final Long idProcess, final String nombreTransicion) {

    }


    /**
     * Crea un contexto propio para la evaluaci�n en relaci�n con el procedimiento, la tarea externa y el contexto original
     * y evalua el script que se le pasa como par�metro.
     * @param idProcedimiento ID del procedimiento para crear el contexto
     * @param idTareaExterna ID de la tarea externa para crear el contexto
     * @param idTareaProcedimiento ID de la tarea del procedimimento
     * @param contextoOriginal Contexto Original para crear el contexto
     * @param script Script que se evaluar�
     * @return Resultado de la evaluaci�n en formato String
     * @throws Exception Exception
     */
    public Object evaluaScript(Long idProcedimiento, Long idTareaExterna, Long idTareaProcedimiento, Map<String, Object> contextoOriginal,
            String script) throws Exception {

        return null;
    }
    
    public Object evaluaScriptPorContexto(Long idProcedimiento, Long idTareaExterna, Long idTareaProcedimiento, Map<String, Object> contextoOriginal,
            String script) throws Exception {

        return null;
    }

    private String getContextScriptsAsString() {
        StringBuffer sb = new StringBuffer();
        for (String script : getContextScripts()) {
            sb.append(script).append("\n");
        }
        return sb.toString();
    }

    /** Crea un Map de maps con los valores introducidos en las pantallas de las tareas de los procesos jbpm. Así podemos hacer referencia
     * a un valor de un control en el script con la siguiente nomenclatura.
     *
     * valores['TramiteIntereses']['fecha']
     *
     * @param idProcedimiento long
     * @return map
     */
    @BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_CREA_MAP_VALORES)
    public Map<String, Map<String, String>> creaMapValores(Long idProcedimiento) {

        return null;
    }

    

    /**
     * settter.
     * @param contextScript context
     */
    public void setContextScripts(List<String> contextScript) {
    }

    @BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_GET_CONTEXTO_SCRIPT)
    private Map<String, Object> creaContextoParaScript(Long idProcedimiento, Long idTareaExterna, Long idTareaProcedimiento)
            throws ClassNotFoundException {
    	return null;
    }
    
    public Map<String, Object> getContextoParaScript(Long idProcedimiento, Long idTareaExterna, Long idTareaProcedimiento) throws ClassNotFoundException {
    	return this.creaContextoParaScript(idProcedimiento, idTareaExterna, idTareaProcedimiento);
    }
    /**
     * getter.
     * @return context
     */
    public List<String> getContextScripts() {
        return null;
    }

    /**
     * Crea un nuevo procedimiento derivado de otro procedimiento padre.
     * @param tipoProcedimiento Tipo de procedimiento que se va a generar
     * @param procPadre Procedimiento padre para copiar sus valores
     * @return Devuelve el nuevo procedimiento creado
     */
    public Procedimiento creaProcedimientoHijo(TipoProcedimiento tipoProcedimiento, Procedimiento procPadre) {
        return null;
    }

    /**
     * Lanza un BPM asociado a un procedimiento.
     * @param idProcedimiento El id del procedimiento del cual se va a lanzar su BPM
     * @param idTokenAviso Si es llamado desde otro BPM, el id del token al que debe avisar. (Este par�metro puede ser null)
     * @return Devuelve el ID del process BPM que se ha creado
     */
    public Long lanzaBPMAsociadoAProcedimiento(Long idProcedimiento, Long idTokenAviso) {
        return null;
    }

    /** M�todo de ayuda para obtener una variable tipo Boolean de JBPM. Hemos comprobado que no convierte bien cuando se
     * guardan objetos boolean. A veces los devuelve como String
     * @param executionContext ExecutionContext
     * @param key String
     * @return boolean
     */
    public static Boolean getFixeBooleanValue(ExecutionContext executionContext, String key) {

       return null;
    }

    /**
     * Recupera una variable est�tica del contexto del BPM.
     * @param idToken Id del token del que queremos recuperar
     * @param variable Nombre de la variable
     * @return Devuelve la variable del contexto BPM
     */
    public Object getProcessVariable(final Long idToken, final String variable) {
        return null;

    }

    

    /**
     * Stop job executor.
     */
    @BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_STOP_JOB_EXECUTOR)
    public synchronized void stopJobExecutor() {
        

    }

    /**
     * Start job executor.
     */
    @BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_START_JOB_EXECUTOR)
    public synchronized void startJobExecutor() {
        
    }

    public Service getJBPMServiceFactory(final String serviceName) {
        return null;
    }
}

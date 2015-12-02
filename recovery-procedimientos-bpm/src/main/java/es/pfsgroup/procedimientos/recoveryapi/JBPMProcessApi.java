package es.pfsgroup.procedimientos.recoveryapi;

import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface JBPMProcessApi {

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
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_EVALUA_SCRIPT)
    public Object evaluaScript(Long idProcedimiento, Long idTareaExterna, Long idTareaProcedimiento, Map<String, Object> contextoOriginal,
            String script) throws Exception;

    /**
     * Crea un nuevo procedimiento derivado de otro procedimiento padre.
     * @param tipoProcedimiento Tipo de procedimiento que se va a generar
     * @param procPadre Procedimiento padre para copiar sus valores
     * @return Devuelve el nuevo procedimiento creado
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_CREA_PROCEDIMIENTO_HIJO)
    public Procedimiento creaProcedimientoHijo(TipoProcedimiento tipoProcedimiento, Procedimiento procPadre);

    /**
     * Lanza un BPM asociado a un procedimiento.
     * @param idProcedimiento El id del procedimiento del cual se va a lanzar su BPM
     * @param idTokenAviso Si es llamado desde otro BPM, el id del token al que debe avisar. (Este par�metro puede ser null)
     * @return Devuelve el ID del process BPM que se ha creado
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_LANZAR_BPM_ASOC_PROC)
    public Long lanzaBPMAsociadoAProcedimiento(Long idProcedimiento, Long idTokenAviso);

    /**
     * Destruye un proceso de expediente activo.
     * @param idProcess id de proceso
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS)
    public void destroyProcess(final Long idProcess);
    
    

    /** M�todo de ayuda para obtener una variable tipo Boolean de JBPM. Hemos comprobado que no convierte bien cuando se
     * guardan objetos boolean. A veces los devuelve como String
     * @param executionContext ExecutionContext
     * @param key String
     * @return boolean
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_GET_FIXE_BOOLEAN_VALUE)
    public Boolean getFixeBooleanValue(ExecutionContext executionContext, String key);
    
    /**
     * Devuelve una nueva variable dentro de la ejecucion.
     * @param idProcess id del proceso
     * @param variableName nombre de la variable a obtener
     * @return objecto
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS)
    public Object getVariablesToProcess(final Long idProcess, final String variableName);
    
    /**
     * Devuelve cierto o falso en función de si existe o no la transici�n en el token activo.
     * @param idToken id del token
     * @param transitionName nombre de la transicion
     * @return tiene o no
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_HAS_TRANSITION_TOKEN)
    public Boolean hasTransitionToken(final Long idToken, final String transitionName) ;
    
    /** Hace avanzar un token.
     * @param idToken id del token
     * @param transitionName nombre de la transicion
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN)
    public void signalToken(final Long idToken, final String transitionName);
}

package es.pfsgroup.plugin.rem.jbpm.handler;

import static es.capgemini.pfs.BPMContants.PROCEDIMIENTO_TAREA_EXTERNA;
import static es.capgemini.pfs.BPMContants.TRANSICION_ALERTA_TIMER;

import java.util.Date;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.def.ActionHandler;
import org.jbpm.graph.def.Node;
import org.jbpm.graph.def.Transition;
import org.jbpm.graph.exe.ExecutionContext;
import org.jbpm.graph.exe.Token;
import org.jbpm.job.Timer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.PlazoTareaExternaPlazaManager;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.TareaProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.PlazoTareaExternaPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;

import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTramiteManagerApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

/**
 * Clase abstracta de la cual heredan los métodos útiles
 * para la manipulación de los BPMs de procedimientos.
 * @author amarinso
 */
public abstract class BaseActionHandler implements ActionHandler {

    private static final long serialVersionUID = 1L;

	public static final String ACTIVO_TRAMITE_TAREA_EXTERNA = "activoTramiteTareaExterna";

    protected final Log logger = LogFactory.getLog(getClass());

    private ExecutionContext executionContext;

    @Autowired
    private ActivoTramiteApi activoTramiteManager;

    @Autowired
    private TareaProcedimientoManager tareaProcedimientoManager;

    @Autowired
    protected TareaExternaManager tareaExternaManager;

    @Autowired
    protected TareaNotificacionManager tareaNotificacionManager;

    @Autowired
    protected JBPMProcessManagerApi processUtils;

    @Autowired
    private PlazoTareaExternaPlazaManager plazoTareaExternaPlazaManager;

    @Autowired
    private JBPMActivoTramiteManagerApi jbpmActivoTramiteManagerApi;
    
    @Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
    
    

    /**
     * Método que recupera el ID del BPM asociado a la ejecución.
     * @return id del BPM en ejecución
     */
    protected Long getProcessId() {
        return executionContext.getContextInstance().getId();
    }

//    /**
//     * Devuelve el plazo (en milisegundos) de una tarea de un procedimiento.
//     * @param idTipoPlaza id de la plaza a la que pertenece
//     * @param idTipoTarea id del tipo de tarea
//     * @param idTipoJuzgado id del tipo de juzgado al que pertenece
//     * @param idProcedimiento id del procedimiento al que pertenece
//     * @return plazo de la tarea en milisegundos
//     */
//    protected Long getPlazoTarea(Long idTipoPlaza, Long idTipoTarea, Long idTipoJuzgado, Long idProcedimiento) {
//        PlazoTareaExternaPlaza plazoTareaExternaPlaza = plazoTareaExternaPlazaManager.getByTipoTareaTipoPlazaTipoJuzgado(idTipoTarea, idTipoPlaza,
//                idTipoJuzgado);
//
//        String script = "Sin determinar";
//        Long plazo;
//        try {
//            script = plazoTareaExternaPlaza.getScriptPlazo();
//            String result = contextScriptsUtils.evaluaScript(idProcedimiento, null, idTipoTarea, null, script).toString();
//            plazo = Long.parseLong(result.toString());
//        } catch (Exception e) {
//            logger.error("Error en el script de consulta de plazo [" + script + "]. Procedimiento [" + idProcedimiento + "], tipoTarea ["
//                    + idTipoTarea + "].", e);
//            throw new UserException("bpm.error.script");
//        }
//        return plazo;
//    }

//    /**
//     * Método que inicializa las fechas de una tarea.
//     * @param tarea Tarea del BPM para inicializar las fechas
//     */
//    protected void iniciaFechasTarea(TareaNotificacion tarea) {
//        Date fechaInicio = (Date) getVariable(BPMContants.FECHA_ACTIVACION_TAREAS);
//        if (fechaInicio == null) {
//            fechaInicio = new Date();
//        }
//
//        Long idProcedimiento = tarea.getProcedimiento().getId();
//
//        Long idTipoJuzgado = null;
//        Long idTipoPlaza = null;
//
//        try {
//            idTipoJuzgado = tarea.getProcedimiento().getJuzgado().getId();
//            idTipoPlaza = tarea.getProcedimiento().getJuzgado().getPlaza().getId();
//        } catch (NullPointerException e) {
//            ;//El procedimiento puede no tener ni plaza ni juzgado, no se hace nada
//        }
//
//        Long idTipoTarea = tarea.getTareaExterna().getTareaProcedimiento().getId();
//
//        Long plazo = getPlazoTarea(idTipoPlaza, idTipoTarea, idTipoJuzgado, idProcedimiento);
//        Date fechaVenc = new Date(fechaInicio.getTime() + plazo);
//
//        tarea.setFechaInicio(fechaInicio);
//        tarea.setFechaVenc(fechaVenc);
//        tarea.setAlerta(false);
//    }

    /**
     * Método que devuelve si el BPM está o no detenido.
     * @return boolean con el resultado de la consulta
     */
    protected boolean isBPMDetenido() {
        Long isDetenido = (Long) getVariable(BPMContants.BPM_DETENIDO);
        if (isDetenido == null) {
            setVariable(BPMContants.BPM_DETENIDO, 0L);
            isDetenido = 0L;
        }

        return (isDetenido == 1L);
    }

    /**
     * Método que genera un nuevo hijo derivado del procedimiento.
     */
    @Transactional(readOnly = false)
    protected void lanzaNuevoBpmHijo() {
        TipoProcedimiento tipoProcedimientoHijo = getTareaProcedimiento().getTipoProcedimientoBPMHijo();

        //Creamos un nuevo procedimiento hijo a partir del padre
        ActivoTramite activoTramitePadre = getActivoTramite();
        ActivoTramite activoTramiteHijo = jbpmActivoTramiteManagerApi.creaActivoTramiteHijo(tipoProcedimientoHijo, activoTramitePadre);
        jbpmActivoTramiteManagerApi.lanzaBPMAsociadoATramite(activoTramiteHijo.getId(), getTokenId());

        logger.debug("se ha lanzado un nuevo proceso hijo con Id=" + activoTramiteHijo.getId());
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    public boolean tieneProcesoBpmAsociado() {
        return getTareaProcedimiento().getTipoProcedimientoBPMHijo() != null;
    }

    /**
     * PONER JAVADOC FO.
     * @return t
     */
    protected Token getToken() {
        return getExecutionContext().getToken();
    }

    /**
     * PONER JAVADOC FO.
     * @return id
     */
    protected long getTokenId() {
        return getToken().getId();
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    protected boolean existeTransicionDeAlerta() {
        return getExecutionContext().getNode().getLeavingTransition(TRANSICION_ALERTA_TIMER) != null;
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    protected boolean existeTimerDeAlerta() {
        String nombreTimer = "timer" + getNombreNodo();
        return BPMUtils.getTimer(getExecutionContext().getJbpmContext(), getExecutionContext().getProcessInstance(), nombreTimer) != null;
    }

    /**
     * PONER JAVADOC FO.
     * @param tarea t
     */
    protected void creaTimerDeAlerta(TareaNotificacion tarea) {
        Date fechaVenc = tarea.getFechaVenc();
        String nombreTimer = "timer" + getNombreNodo();

        creaTimer(fechaVenc, nombreTimer, TRANSICION_ALERTA_TIMER);
    }

    /**
     * Mï¿½todo que crea un timer para el token actual con la duraciï¿½n y el nombre que se le indica.
     * @param fechaVenc Duraciï¿½n del timer
     * @param nombreTimer Nombre del timer
     * @param nombreTransicion nombreTransicion
     */
    protected void creaTimer(Date fechaVenc, String nombreTimer, String nombreTransicion) {
        BPMUtils.deleteTimer(getExecutionContext(), nombreTimer);
        Timer timer = BPMUtils.createTimer(getExecutionContext(), nombreTimer, fechaVenc, nombreTransicion);
        timer.setRetries(1);

        logger.debug("\tEl timer se ha creado : [" + getNombreNodo() + " ] " + fechaVenc);
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    public boolean debeDestruirTareaProcedimiento() {
        return !isTransicionMismoNodo() && tieneTareaExterna();
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    protected boolean tieneTareaExterna() {
        return getIdTareaExterna() != null;
    }

    /**
     * PONER JAVADOC FO.
     * @return t
     */
    protected TareaExterna getTareaExterna() {
        Long idTarea = getIdTareaExterna();
        if (idTarea != null) { return tareaExternaManager.get(getIdTareaExterna()); }
        return null;

    }

    private Long getIdTareaExterna() {
        String name = getExecutionContext().getNode().getName().replaceAll("Decision$", "");
        return (Long) getExecutionContext().getVariable("id" + name);
    }

    /**
     * Muestra la informaciï¿½n del nodo en el que se encuentra.
     * @param accion Texto con la acciï¿½n que se ejecuta en el nodo
     */
    protected void printInfoNode(String accion) {
        if (!logger.isDebugEnabled()) { return; }

        long idToken = getTokenId();
        String nombreProcedimiento = getNombreProceso();
        String nombreTransicion = "";
        try {
            nombreTransicion = getExecutionContext().getTransition().getName();
        } catch (Exception e) {
            logger.error(e);
        }

        logger.debug("Nodo Generico de " + nombreProcedimiento + " (" + getExecutionContext().getProcessInstance().getId() + ")");
        logger.debug("\tAcción realizada: " + accion);
        logger.debug("\tNombre nodo: " + getNombreNodo() + "(" + idToken + ")");
        logger.debug("\tNombre transicion: " + nombreTransicion);
    }

    /**
     * Devuelve la tarea asociada al nodo en ejecuciÃ³n y en el tipo de procedimiento que se le indica.
     * @param codigoTarea CÃ³digo de la tarea que se estÃ¡ ejecutando en el nodo
     * @return Devuelve una TareaProcedimiento asociada al nodo y al procedimiento
     */
    protected TareaProcedimiento getTareaProcedimiento(String codigoTarea) {

        Long idTipoProcedimiento = this.getActivoTramite().getTipoTramite().getId();
        TareaProcedimiento tareaProcedimiento = tareaProcedimientoManager.getByCodigoTareaIdTipoProcedimiento(idTipoProcedimiento, codigoTarea);

        //TODO :ï¿½En este caso que se deberï¿½a hacer? borrar las ï¿½tareas_notificaciones?
        if (tareaProcedimiento == null) {
            String nombreProcedimiento = getNombreProceso();
            //Destruimos el proceso BPM porque no podemos averiguar a que tarea se estÃ¡ refiriendo
            Long idProceso = getExecutionContext().getProcessInstance().getId();
            processUtils.destroyProcess(idProceso);

            String mensajeError = "La tarea para el nodo " + getNombreNodo() + " del procedimiento " + nombreProcedimiento
                    + " no está definida en la tabla TAP_TAREA_PROCEDIMIENTO, o no tiene el mismo código de tarea.";
            logger.fatal(mensajeError);

            throw new UserException("bpm.error.tareaNoDefinida");
        }

        return tareaProcedimiento;
    }

    /**
     * Mï¿½todo que devuelve el procedimiento al que estÃ¡ asociado el BPM en ejecuciÃ³n.
     * @return El procedimiento al que estÃ¡ asociado el BPM
     */
    //TODO: distinto para cada entidad.
    protected ActivoTramite getActivoTramite() {

    	ActivoTramite activoTramite = activoTramiteManager.get((Long) getVariable(ACTIVO_TRAMITE_TAREA_EXTERNA));

        //TODO :AquÃ­ podrÃ­a recuperarse de la BD en caso de que no estuviera en el contexto
        //Esto se podrÃ­a hacer consultando el executionContext.getProcessInstance().getId() y que coincidiera con un PRC_PROCEDIMIENTOS

        //Si el procedimiento es null no podemos saber a que PRC_PROCEDIMIENTO hace referencia este BPM y por tanto no podemos crear tareas
        if (activoTramite == null) {
            String nombreProcedimiento = getNombreProceso();

            //Destruimos el proceso BPM porque no podemos averiguar a que procedimiento pertenece
            processUtils.destroyProcess(getExecutionContext().getProcessInstance().getId());

            //Mostramos un mensaje de error
            String mensajeError = "El BPM en ejecución para el trámite " + nombreProcedimiento
                    + " no tiene asociado un ACT_ACTIVO y por tanto no puede continuar su ejecución";
            logger.error(mensajeError);

            throw new UserException("bpm.error.activoTramiteNoDefinido");
        }

        return activoTramite;
    }

    /**
     * PONER JAVADOC FO.
     * @param name name
     * @return b
     */
    protected boolean existeTransicion(String name) {
        Node node = getExecutionContext().getNode();
        return node.hasLeavingTransition(name);
    }

    /**
     * PONER JAVADOC FO.
     * @param name name
     */
    protected void nuevaTransicion(String name) {
        Node node = getExecutionContext().getNode();
        Transition transition = new Transition();
        transition.setFrom(node);
        transition.setTo(node);
        transition.setName(name);
        transition.setProcessDefinition(getExecutionContext().getProcessDefinition());
        node.addLeavingTransition(transition);
    }

    /**
     * PONER JAVADOC FO.
     * @param key key
     * @return o
     */
    protected Object getVariable(String key) {
        return getExecutionContext().getVariable(key);
    }

    /**
     * PONER JAVADOC FO.
     * @param key key
     * @param value value
     */
    protected void setVariable(String key, Object value) {
        getExecutionContext().setVariable(key, value);
    }

    /**
     * PONER JAVADOC FO.
     * @param key key
     * @return b
     */
    protected boolean hasVariable(String key) {
        return getExecutionContext().getVariable(key) != null;
    }

    /**
     * PONER JAVADOC FO.
     * @return s
     */
    protected String getTransitionName() {
        String nombreTransicion = null;
        try {
            nombreTransicion = getExecutionContext().getTransition().getName();
        } catch (Exception e) {
            return nombreTransicion;
        }
        return nombreTransicion;
    }

    /**
     * PONER JAVADOC FO.
     * @return s
     */
    protected String getNombreNodo() {
        return getExecutionContext().getNode().getName();
    }

    /**
     * PONER JAVADOC FO.
     * @return s
     */
    protected String getNombreProceso() {
        return getExecutionContext().getProcessDefinition().getName();
    }

    /**
     *  Este es el inicio de ejecución de nuestro código JBPM.
     *  Se inicia una nueva transacción con la conexión de la entidad que corresponde procesar este jbpm
     * (non-Javadoc)
     * @see org.jbpm.graph.def.ActionHandler#execute(org.jbpm.graph.exe.ExecutionContext)
     * @param executionContext ExecutionContext
     * @throws Exception e
     */
    public void execute(ExecutionContext executionContext) throws Exception {
        this.setExecutionContext(executionContext);
        DbIdContextHolder.setDbId((Long) executionContext.getVariable("DB_ID"));
        TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
        try {
            run();
            transactionManager.commit(transaction);
        } catch (Exception e) {
            logger.error(e);
            transactionManager.rollback(transaction);
            throw e;
        }
    }

    /**
     * PONER JAVADOC FO.
     * @throws Exception e
     */
    public void run() throws Exception {
    }

    /**
     * PONER JAVADOC FO.
     * @param executionContext e
     */
    public void setExecutionContext(ExecutionContext executionContext) {
        this.executionContext = executionContext;
    }

    /**
     * PONER JAVADOC FO.
     * @return e
     */
    public ExecutionContext getExecutionContext() {
        return executionContext;
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    public boolean debeCrearTareaProcedimiento() {
        return !isTransicionMismoNodo() && tieneTareaProcedimiento() && !isTareaDecision();
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    public boolean isTareaDecision() {
        return getNombreNodo().endsWith("Decision");
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    public boolean isTransicionMismoNodo() {
        Transition transicion = executionContext.getTransition();
        if (transicion != null) { return transicion.getTo().getName().equals(transicion.getFrom().getName()); }

        return false;
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    public boolean tieneTareaProcedimiento() {
        return getTareaProcedimiento() != null;
    }

    /**
     * PONER JAVADOC FO.
     * @return tp
     */
    public TareaProcedimiento getTareaProcedimiento() {
        return getTareaProcedimiento(getNombreNodo());
    }
}

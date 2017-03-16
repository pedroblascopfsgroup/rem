package es.pfsgroup.plugin.rem.jbpm.handler;

import static es.capgemini.pfs.BPMContants.TRANSICION_ALERTA_TIMER;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.def.ActionHandler;
import org.jbpm.graph.def.Node;
import org.jbpm.graph.def.Transition;
import org.jbpm.graph.exe.ExecutionContext;
import org.jbpm.graph.exe.ProcessInstance;
import org.jbpm.graph.exe.Token;
import org.jbpm.job.Timer;
import org.jbpm.scheduler.SchedulerService;
import org.jbpm.svc.Services;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.devon.bpm.ProcessManager;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.TareaProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bpm.ExtendedProcessManager;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoScriptExecutorApi;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTramiteManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.ActivoGenericActionHandler.ConstantesBPMPFS;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorServiceFactoryApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionServiceFactoryApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.TimerTareaActivo;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

/**
 * Clase abstracta de la cual heredan los métodos útiles
 * para la manipulación de los BPMs de activos.
 * @author manuel
 */
public abstract class ActivoBaseActionHandler implements ActionHandler {

    private static final long serialVersionUID = 1L;

    public static final String SALTO_CIERRE_ECONOMICO = "saltoCierreEconomico";
    
    protected final Log logger = LogFactory.getLog(getClass());

    private ExecutionContext executionContext;
    
    @Autowired
    private GenericABMDao genericDao;
    
	@Autowired
	private GenericAdapter adapter;

    @Autowired
    private ActivoTramiteApi activoTramiteManagerApi;

    @Autowired
    private TareaProcedimientoManager tareaProcedimientoManager;

    @Autowired
    private ActivoTareaExternaApi activoTareaExternaManagerApi;
    
    @Autowired
    protected TareaExternaManager tareaExternaManager;
    
    @Autowired
    TareaActivoApi tareaActivoApi;
    
    @Autowired
    UserAssigantionServiceFactoryApi userAssigantionServiceFactoryApi;
    
    @Autowired
    NotificatorServiceFactoryApi notificatorServiceFactoryApi;

    @Autowired
    protected JBPMProcessManagerApi processUtils;
    
    @Autowired
    protected JBPMActivoTramiteManagerApi jbpmActivoTramiteManagerApi;
    
    @Autowired
    protected JBPMActivoScriptExecutorApi jbpmMActivoScriptExecutorApi;

    @Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;

	@Autowired
	private ProcessManager processManager;
	
	@Autowired
	private ExtendedProcessManager extendedProcessManager;

	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	
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
    protected boolean isBPMDetenido(ExecutionContext executionContext) {
        Long isDetenido = (Long) getVariable(BPMContants.BPM_DETENIDO, executionContext);
        if (isDetenido == null) {
            setVariable(BPMContants.BPM_DETENIDO, 0L, executionContext);
            isDetenido = 0L;
        }

        return (isDetenido == 1L);
    }

    /**
     * Método que genera un nuevo hijo derivado del procedimiento.
     */
    @Transactional(readOnly = false)
    protected void lanzaNuevoBpmHijo(ExecutionContext executionContext) {
        TipoProcedimiento tipoProcedimientoHijo = getTareaProcedimiento(executionContext).getTipoProcedimientoBPMHijo();

        //Creamos un nuevo procedimiento hijo a partir del padre
        ActivoTramite activoTramitePadre = getActivoTramite(executionContext);
        ActivoTramite activoTramiteHijo = jbpmActivoTramiteManagerApi.creaActivoTramiteHijo(tipoProcedimientoHijo, activoTramitePadre);
        jbpmActivoTramiteManagerApi.lanzaBPMAsociadoATramite(activoTramiteHijo.getId(), getTokenId(executionContext));

        logger.debug("se ha lanzado un nuevo proceso hijo con Id=" + activoTramiteHijo.getId());
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    public boolean tieneProcesoBpmAsociado(ExecutionContext executionContext) {
        return getTareaProcedimiento(executionContext).getTipoProcedimientoBPMHijo() != null;
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @return t
     */
    protected Token getToken(ExecutionContext executionContext) {
        return executionContext.getToken();
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @return id
     */
    public long getTokenId(ExecutionContext executionContext) {
        return getToken(executionContext).getId();
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    protected boolean existeTransicionDeAlerta(ExecutionContext executionContext) {
        return executionContext.getNode().getLeavingTransition(TRANSICION_ALERTA_TIMER) != null;
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    protected boolean existeTimerDeAlerta(ExecutionContext executionContext) {
        String nombreTimer = "timer" + getNombreNodo(executionContext);
        return BPMUtils.getTimer(executionContext.getJbpmContext(), executionContext.getProcessInstance(), nombreTimer) != null;
    }

    /**
     * PONER JAVADOC FO.
     * @param tarea t
     */
    protected void creaTimerDeAlerta(TareaNotificacion tarea, ExecutionContext executionContext) {
        Date fechaVenc = tarea.getFechaVenc();
        String nombreTimer = "timer" + getNombreNodo(executionContext);

        creaTimer(fechaVenc, nombreTimer, TRANSICION_ALERTA_TIMER, executionContext);
    }
    
    /**
     * Método que crea un timer para el token actual con la duraciï¿½n y el nombre que se le indica.
     * @param fechaVenc Duración del timer
     * @param nombreTimer Nombre del timer
     * @param nombreTransicion nombreTransicion
     */
    protected void creaTimer(Date fechaVenc, String nombreTimer, String nombreTransicion, ExecutionContext executionContext) {
        BPMUtils.deleteTimer(executionContext, nombreTimer);
        Timer timer = BPMUtils.createTimer(executionContext, nombreTimer, fechaVenc, nombreTransicion);
        timer.setRetries(1);

        logger.debug("\tEl timer se ha creado : [" + getNombreNodo(executionContext) + " ] " + fechaVenc);
    }
    
    /**
     * 
	 * Método que le genera a la tarea tantos timers como tenga definidos en la tabla de configuracién de timers, TTM_TAP_TIMER.
	 * 
	 * 	Configuracién de un timer:
	 * 		TTM_TAP_TIMER.TTM_NOMBRE: nombre del timer.
	 * 		TTM_TAP_TIMER.TAP_ID: id de la tarea para la que se configura el timer. Tabla TAP_TAREA_PROCEDIMIENTO.
	 * 		TTM_TAP_TIMER.TTM_TRANSICION: transición por la que avanzará el BPM si se dispara el timer.
	 * 		TTM_TAP_TIMER.TTM_PLAZO_SCRIPT: tiempo de espera del timer antes de caducar. En milisegundos.
	 * 
	 * @param idTarea
	 * @param executionContext
	 * @throws Exception
	 * 
	 */
	protected void generarTimerTareaActivo(Long idTarea, ExecutionContext executionContext) throws Exception {
		Date fechaInicio = (Date) getVariable(BPMContants.FECHA_ACTIVACION_TAREAS, executionContext);
        Date fechaParalizacion = (Date) getVariable(PROBPMContants.FECHA_PARALIZACION_TAREAS, executionContext);
        if (fechaInicio == null) {
            fechaInicio = new Date();
        }
		TareaExterna tareaExterna = activoTareaExternaManagerApi.get(idTarea);
		TareaNotificacion tarea=tareaExterna.getTareaPadre();
		TareaActivo tareaActivo = (TareaActivo) tarea;
		
		Filter filtroTarea= genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.codigo", tareaExterna.getTareaProcedimiento().getCodigo());
		List<TimerTareaActivo> timers = genericDao.getList(TimerTareaActivo.class, filtroTarea);
		
		for (TimerTareaActivo t : timers){
			
			
			String result = jbpmMActivoScriptExecutorApi.evaluaScript(tareaActivo.getTramite().getId(), null, tareaExterna.getTareaProcedimiento().getId(), null, t.getScriptPlazo()).toString();
            Long plazo = Long.parseLong(result.toString());
			Date fechaVencimiento = new Date(System.currentTimeMillis() + plazo);
			if (Checks.esNulo(fechaParalizacion)) {
	            logger.warn("La fecha de paralización del trámite  [" + tareaActivo.getTramite().getId() + "], tipoTarea [" + tareaExterna.getTareaProcedimiento().getTipoProcedimiento().getId() + "]. no ha sido seteada");
	            fechaVencimiento = new Date(fechaInicio.getTime() + plazo);
	        } else {
	        	fechaVencimiento = new Date(fechaInicio.getTime() + (plazo - (fechaParalizacion.getTime() - tarea.getFechaInicio().getTime())));
	        }
			String nombreTimer=tareaExterna.getId()+"."+t.getNombreTimer();
			creaTimer(fechaVencimiento, nombreTimer, t.getNombreTransicion(), executionContext);
		}
		
		
	}    

    /**
     * Método que borrar un timer de una tarea externa.
     * @param id Id. de la tarea externa
     */
    public void borraTimersTarea(final Long idTareaExterna){
	        final TareaExterna tarea = tareaExternaManager.get(idTareaExterna);
	        if(tarea.getTareaPadre() instanceof TareaActivo){
	        	Long id = ((TareaActivo)tarea.getTareaPadre()).getTramite().getProcessBPM();
		        ProcessInstance processInstance = processManager.getProcessInstance(id);

		        SchedulerService schedulerService = (SchedulerService) processUtils.getJBPMServiceFactory(Services.SERVICENAME_SCHEDULER);
		        
		        List<Timer> timers = extendedProcessManager.getTimers(processInstance, idTareaExterna + ".%");
		        for (Timer t : timers){
		            schedulerService.deleteTimersByName(t.getName(), t.getToken());
		        }
	       }
	}
	
    /**
     * PONER JAVADOC FO.
     * @return b
     */
    public boolean debeDestruirTareaProcedimiento(ExecutionContext executionContext) {
        return !isTransicionMismoNodo(executionContext) && tieneTareaExterna(executionContext);
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    protected boolean tieneTareaExterna(ExecutionContext executionContext) {
        return getIdTareaExterna(executionContext) != null;
    }

    /**
     * PONER JAVADOC FO.
     * @return t
     */
    protected TareaExterna getTareaExterna(ExecutionContext executionContext) {
        Long idTarea = getIdTareaExterna(executionContext);
        if (idTarea != null) {
        	return activoTareaExternaManagerApi.get(getIdTareaExterna(executionContext)); 
        }
        return null;

    }

    private Long getIdTareaExterna(ExecutionContext executionContext) {
        final String name = executionContext.getNode().getName().replaceAll("Decision$", "");
        final Long idToken = executionContext.getToken().getId();

        // Esto permite tener asociación robusta para cada tarea en el contexto JBPM.
        // Manteniendo sólo el ID de tarea no funciona bien cuando una misma tarea la replicamos N veces en un contexto.
        // Ahora se almacenerá esa correspondencia de la siguiente forma: idTAREA_token = idtareaexterna
        // Se mantiene compatibilidad hacia atrás
        String shortTokenName = String.format("id%s", name);
        String uniqueTokenName = String.format("id%s.%d", name, idToken);
        Long tex_id = (Long)executionContext.getVariable(uniqueTokenName);
        if (tex_id == null) {
        	tex_id = (Long)executionContext.getVariable(shortTokenName);
        }
        return tex_id;
    }

    /**
     * Muestra la información del nodo en el que se encuentra.
     * @param accion Texto con la acción que se ejecuta en el nodo
     */
    protected void printInfoNode(String accion, ExecutionContext executionContext) {
        if (!logger.isDebugEnabled()) { return; }

        long idToken = getTokenId(executionContext);
        String nombreProcedimiento = getNombreProceso(executionContext);
        String nombreTransicion = "";
        try {
            nombreTransicion = getExecutionContext().getTransition().getName();
        } catch (Exception e) {
            logger.error(e);
        }

        logger.debug("Nodo Generico de " + nombreProcedimiento + " (" + getExecutionContext().getProcessInstance().getId() + ")");
        logger.debug("\tAcción realizada: " + accion);
        logger.debug("\tNombre nodo: " + getNombreNodo(executionContext) + "(" + idToken + ")");
        logger.debug("\tNombre transicion: " + nombreTransicion);
    }

    /**
     * Devuelve el tipo de tarea asociada al nodo en ejecución y en el tipo de procedimiento que se le indica.
     * @param codigoTarea Código de la tarea que se está ejecutando en el nodo
     * @return Devuelve una TareaProcedimiento asociada al nodo y al procedimiento
     */
    protected TareaProcedimiento getTareaProcedimiento(String codigoTarea, ExecutionContext executionContext) {

        Long idTipoProcedimiento = this.getActivoTramite(executionContext).getTipoTramite().getId();
        TareaProcedimiento tareaProcedimiento = tareaProcedimientoManager.getByCodigoTareaIdTipoProcedimiento(idTipoProcedimiento, codigoTarea);

        //TODO :¿En este caso que se debería hacer? borrar las ¿tareas_notificaciones?
        //TODO: Comentamos porque no tengo claro que haya que hacer esto.
//        if (tareaProcedimiento == null) {
//            String nombreProcedimiento = getNombreProceso(executionContext);
//            //Destruimos el proceso BPM porque no podemos averiguar a que tarea se está refiriendo
//            Long idProceso = getExecutionContext().getProcessInstance().getId();
//            processUtils.destroyProcess(idProceso);
//
//            String mensajeError = "La tarea para el nodo " + getNombreNodo(executionContext) + " del ActivoTramite " + nombreProcedimiento
//                    + " no está definida en la tabla TAP_TAREA_PROCEDIMIENTO, o no tiene el mismo código de tarea.";
//            logger.fatal(mensajeError);
//
//            throw new UserException("bpm.error.tareaNoDefinida");
//        }

        return tareaProcedimiento;
    }

    /**
     * Mï¿½todo que devuelve el procedimiento al que estÃ¡ asociado el BPM en ejecuciÃ³n.
     * @return El procedimiento al que estÃ¡ asociado el BPM
     */
    //TODO: distinto para cada entidad.
    protected ActivoTramite getActivoTramite(ExecutionContext executionContext) {

    	Long idTramite = (Long) getVariable(BaseActionHandler.ACTIVO_TRAMITE_TAREA_EXTERNA, executionContext);
    	ActivoTramite activoTramite = activoTramiteManagerApi.get(idTramite);

        //TODO :AquÃ­ podrÃ­a recuperarse de la BD en caso de que no estuviera en el contexto
        //Esto se podrÃ­a hacer consultando el executionContext.getProcessInstance().getId() y que coincidiera con un PRC_PROCEDIMIENTOS

        //Si el procedimiento es null no podemos saber a que PRC_PROCEDIMIENTO hace referencia este BPM y por tanto no podemos crear tareas
    	//TODO: ver si esto hay que hacerlo, borrar el proceso.
//        if (activoTramite == null) {
//            String nombreProcedimiento = getNombreProceso(executionContext);
//
//            //Destruimos el proceso BPM porque no podemos averiguar a que procedimiento pertenece
//            processUtils.destroyProcess(executionContext.getProcessInstance().getId());
//
//            //Mostramos un mensaje de error
//            String mensajeError = "El BPM en ejecución para el trámite " + nombreProcedimiento
//                    + " no tiene asociado un ACT_ACTIVO_TRAMITE y por tanto no puede continuar su ejecución";
//            logger.error(mensajeError);
//
//            throw new UserException("bpm.error.procedimientoNoDefinido");
//        }

        return activoTramite;
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @param name
     *            name
     * @return b
     */
    protected boolean existeTransicion(String name, ExecutionContext executionContext) {
        Node node = executionContext.getNode();
        return node.hasLeavingTransition(name);
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @param name
     *            name
     */
    protected void nuevaTransicion(String name, ExecutionContext executionContext) {
        Node node = executionContext.getNode();
        Transition transition = new Transition();
        transition.setFrom(node);
        transition.setTo(node);
        transition.setName(name);
        transition.setProcessDefinition(executionContext.getProcessDefinition());
        node.addLeavingTransition(transition);
    }

    protected void nuevaTransicionConDestino(String name, ExecutionContext executionContext, Node nodeDestino){
      	Node nodeOrigen = executionContext.getNode();
       	Transition transition = new Transition();
       	transition.setFrom(nodeOrigen);
       	transition.setTo(nodeDestino);
       	transition.setName(name);
       	transition.setProcessDefinition(executionContext.getProcessDefinition());
       	nodeOrigen.addLeavingTransition(transition);
    }
    
    /**
     * PONER JAVADOC FO.
     * @param key key
     * @return o
     */
    protected Object getVariable(String key, ExecutionContext executionContext) {
        return executionContext.getVariable(key);
    }

    /**
     * PONER JAVADOC FO.
     * @param key key
     * @param value value
     */
    protected void setVariable(String key, Object value, ExecutionContext executionContext) {
    	executionContext.setVariable(key, value);
    }

    /**
     * PONER JAVADOC FO.
     * @param key key
     * @return b
     */
    protected boolean hasVariable(String key, ExecutionContext executionContext) {
        return executionContext.getVariable(key) != null;
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
     * 
     * @return s
     */
    protected String getTransitionName(ExecutionContext executionContext) {
        String nombreTransicion = null;
        try {
            nombreTransicion = executionContext.getTransition().getName();
        } catch (Exception e) {
            return nombreTransicion;
        }
        return nombreTransicion;
    }
    
    /**
     * PONER JAVADOC FO.
     * @return s
     */
    protected String getNombreNodo(ExecutionContext executionContext) {
        return executionContext.getNode().getName();
    }
    
    protected String getNombreProceso(ExecutionContext executionContext) {
        return executionContext.getProcessDefinition().getName();
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
            run(executionContext);
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
    public void run(ExecutionContext executionContext) throws Exception {
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
    public boolean debeCrearTareaProcedimiento(ExecutionContext executionContext) {
        return !isTransicionMismoNodo(executionContext) && tieneTareaProcedimiento(executionContext) && !isTareaDecision(executionContext);
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    public boolean isTareaDecision(ExecutionContext executionContext) {
        return getNombreNodo(executionContext).endsWith("Decision");
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    public boolean isTransicionMismoNodo(ExecutionContext executionContext) {
        Transition transicion = executionContext.getTransition();
        if (transicion != null) { return transicion.getTo().getName().equals(transicion.getFrom().getName()); }

        return false;
    }

    /**
     * PONER JAVADOC FO.
     * @return b
     */
    public boolean tieneTareaProcedimiento(ExecutionContext executionContext) {
        return getTareaProcedimiento(executionContext) != null;
    }

    /**
     * PONER JAVADOC FO.
     * @return tp
     */
    public TareaProcedimiento getTareaProcedimiento(ExecutionContext executionContext) {
        return getTareaProcedimiento(getNombreNodo(executionContext), executionContext);
    }
    
    /**
     * Detecta una reentrada al nodo.
     * <p>
     * Las reentradas se producen, por ejemplo, cuando salta una alerta, se
     * cancela una tarea, se solicita una pr�rroga, etc ... Este m�todo
     * compara el nombre del nodo de entrada con el nombre del nodo de salida.
     * </p>
     * <p>
     * Para que esto funcione es necesario que el nombre del nodo de salida se
     * haya seteado en el <strong>PROGenericLeaveActionHandler</strong>
     * </p>
     * 
     * @param executionContext
     * @return
     */
    protected boolean detectaReentrada(ExecutionContext executionContext) {
        Object nombreNodoSaliente = getVariable(ConstantesBPMPFS.NOMBRE_NODO_SALIENTE, executionContext);
        if (!Checks.esNulo(nombreNodoSaliente) && getNombreNodo(executionContext).equals(nombreNodoSaliente)) {
            executionContext.getContextInstance().deleteVariable(ConstantesBPMPFS.NOMBRE_NODO_SALIENTE);
            return true;

        } else {
            return false;
        }
    } 
    
    /**
     * Asigna usuarios a las tareas de activo.
     * En caso de que el Activo no tenga ningún gestor del tipo de la tarea, se queda igual.
     * 
     * @param idTarea
     * @return
     */
    protected void asignaUsuario(Long idTarea){

    	//TareaActivo tareaActivo  = tareaActivoApi.getByIdTareaExterna(idTarea);
		TareaExterna tareaExterna = activoTareaExternaManagerApi.get(idTarea);
		TareaActivo tareaActivo = ((TareaActivo)tareaExterna.getTareaPadre());
		EXTTareaProcedimiento tareaProcedimiento = (EXTTareaProcedimiento) tareaExterna.getTareaProcedimiento();
		Usuario usuarioLogado = null;
		String nombreUsuarioWS = RestApi.REST_LOGGED_USER_USERNAME;
		
			
		// Factoria asignador gestores por tarea
    	UserAssigantionService userAssigantionService = userAssigantionServiceFactoryApi.getService(tareaProcedimiento.getCodigo());
		
		Usuario gestor = userAssigantionService.getUser(tareaExterna);
		Usuario supervisor = userAssigantionService.getSupervisor(tareaExterna);
		
		// Asignador de GESTOR por factoria - Gestores encontrados por tarea-Activo
		if(!Checks.esNulo(gestor)){
			tareaActivo.setUsuario(gestor);
		} else {
			// HREOS-1714 Si el asignador de usuarios NO encuentra el gestor correspondiente:
			// - Las tareas que se generen por usuario WS, deben asignarse al gestor y supervisor de activo
			// - Para este mismo caso, el resto de usuarios registraran al usuario logado
			usuarioLogado = adapter.getUsuarioLogado();
			if(!Checks.esNulo(usuarioLogado)){			
				if(nombreUsuarioWS.equals(usuarioLogado)){
					Usuario gestorWS = gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), GestorActivoApi.CODIGO_GESTOR_ACTIVO);
					if(!Checks.esNulo(gestorWS))
						tareaActivo.setUsuario(gestorWS);
				} else {
					tareaActivo.setUsuario(usuarioLogado);
				}
			}
		}
		
		// Asignador de SUPERVISOR por factoria - Supervisores encontrados por tarea-Activo
		if(!Checks.esNulo(supervisor)){
			tareaActivo.setSupervisorActivo(supervisor);
		} else {
			// HREOS-1714 Igual con supervisor
			usuarioLogado = adapter.getUsuarioLogado();
			if(!Checks.esNulo(usuarioLogado)){			
				if(nombreUsuarioWS.equals(usuarioLogado)){
					Usuario supervisorWS = gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), GestorActivoApi.CODIGO_SUPERVISOR_ACTIVOS);
					if(!Checks.esNulo(supervisorWS))
						tareaActivo.setUsuario(supervisorWS);
				} else {
					tareaActivo.setUsuario(usuarioLogado);
				}
			}
		}
			
    }
    
    /**
     * 
     */
    protected void enviaNotificacion(Long idTarea){

		NotificatorService notificatorUpdaterService = getNotificatorService(idTarea);
		ActivoTramite tramite = getActivoTramite(executionContext);
		
		if(!Checks.esNulo(notificatorUpdaterService))
			notificatorUpdaterService.notificator(tramite);
				
		logger.debug("\tEnviamos correo en la tarea: " + getNombreNodo(executionContext));
		
    }
    
    /**
     * HREOS-764
     * Envia notificación teniendo en cuenta los valores introducidos en la tarea realizada.
     * Esta notificación se envía al finalizar la tarea, y no al empezar. LLamada desde el LeaveHandler.
     * @param idTarea
     * @param valores
     */
    protected void enviaNotificacionFinTareaConValores(Long idTarea, List<TareaExternaValor> valores) {
    	
    	NotificatorService notificatorUpdaterService = getNotificatorService(idTarea);
		ActivoTramite tramite = getActivoTramite(executionContext);
		
		if(!Checks.esNulo(notificatorUpdaterService))
			notificatorUpdaterService.notificatorFinTareaConValores(tramite,valores);
				
		logger.debug("\tEnviamos correo en la tarea: " + getNombreNodo(executionContext));
    }
    
    private NotificatorService getNotificatorService(Long idTarea) {
    	TareaExterna tareaExterna = activoTareaExternaManagerApi.get(idTarea);
		EXTTareaProcedimiento tareaProcedimiento = (EXTTareaProcedimiento) tareaExterna.getTareaProcedimiento();
		NotificatorService notificatorUpdaterService = notificatorServiceFactoryApi.getService(tareaProcedimiento.getCodigo());
		
		return notificatorUpdaterService;
    }
}

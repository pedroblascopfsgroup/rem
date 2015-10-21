package es.pfsgroup.procedimientos;

import static es.capgemini.pfs.BPMContants.PROCEDIMIENTO_TAREA_EXTERNA;
import static es.capgemini.pfs.BPMContants.TRANSICION_ALERTA_TIMER;
import static es.pfsgroup.procedimientos.PROBPMContants.PROCEDIMIENTO_HIJO;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.WordUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.hibernate.proxy.HibernateProxy;
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

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.PlazoTareaExternaPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.procedimientos.PROGenericActionHandler.ConstantesBPMPFS;
import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;
import es.pfsgroup.procedimientos.recoveryapi.PlazoTareaExternaPlazaApi;
import es.pfsgroup.procedimientos.recoveryapi.ProcedimientoApi;
import es.pfsgroup.procedimientos.recoveryapi.TareaProcedimientoApi;
import es.pfsgroup.procedimientos.timerTarea.model.TimerTareaProcedimiento;

public class PROBaseActionHandler implements ActionHandler {

    @Autowired
    private Executor executor;

    @Autowired
    private GenericABMDao genericDao;
    
    /**
	 * 
	 */
    private static final long serialVersionUID = -4430292603621425023L;

    protected final Log logger = LogFactory.getLog(getClass());

    private ExecutionContext executionContext;

    @Autowired
    protected ApiProxyFactory proxyFactory;

    @Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;

    /**
     * M�todo que recupera el ID del BPM asociado a la ejecuci�n.
     * 
     * @return id del BPM en ejecuci�n
     */
    protected Long getProcessId(ExecutionContext executionContext) {
        return executionContext.getContextInstance().getId();
    }

    /**
     * Devuelve el plazo (en milisegundos) de una tarea de un procedimiento,
     * seg�n la configuraci�n de plazos correspondiente al tipo de tarea.
     * 
     * @param idTipoPlaza
     *            id de la plaza a la que pertenece
     * @param idTipoTarea
     *            id del tipo de tarea
     * @param idTipoJuzgado
     *            id del tipo de juzgado al que pertenece
     * @param idProcedimiento
     *            id del procedimiento al que pertenece
     * @return plazo de la tarea en milisegundos
     */
    @SuppressWarnings("unchecked")
    protected Long getPlazoTareaPorTipoTarea(Long idTipoPlaza, Long idTipoTarea, Long idTipoJuzgado, Long idProcedimiento, Long tokenIdBPM) {
        PlazoTareaExternaPlaza plazoTareaExternaPlaza = proxyFactory.proxy(PlazoTareaExternaPlazaApi.class).getByTipoTareaTipoPlazaTipoJuzgado(idTipoTarea, idTipoPlaza, idTipoJuzgado);

        String script = "Sin determinar";
        Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
        Long plazo;
        try {
            script = plazoTareaExternaPlaza.getScriptPlazo();
            try {
                String result = proxyFactory.proxy(JBPMProcessApi.class).evaluaScript(idProcedimiento, null, idTipoTarea, null, script).toString();
                plazo = Long.parseLong(result.toString());
            } catch (Exception ex) {
                // Miraemos si hemos pasado el plazo por defecto al BPM, si no
                // relanzamos la excepcion
                // FIXME Poner la constante PLAZO_TAREAS_DEFAULT en alg�n
                // sitio
                Object o = proxyFactory.proxy(JBPMProcessApi.class).getVariablesToProcess(prc.getProcessBPM(), "PLAZO_TAREA_DEFAULT");
                if ((o != null) && (o instanceof Long)) {
                    plazo = (Long) o;
                    proxyFactory.proxy(RecoveryExtendedJPBMManager.class).deleteVariableToProcess(prc.getProcessBPM(), "PLAZO_TAREA_DEFAULT");
                } else {
                    throw ex;
                }
            }

        } catch (Exception e) {
            logger.error("Error en el script de consulta de plazo [" + script + "]. Procedimiento [" + idProcedimiento + "], tipoTarea [" + idTipoTarea + "].", e);
            throw new UserException("bpm.error.script");

        }
        return plazo;
    }

    /**
     * M�todo que inicializa las fechas de una tarea.
     * 
     * @param tarea
     *            Tarea del BPM para inicializar las fechas
     */
    protected void iniciaFechasTarea(TareaNotificacion tarea, ExecutionContext executionContext) {
        Date fechaInicio = (Date) getVariable(BPMContants.FECHA_ACTIVACION_TAREAS, executionContext);
        Date fechaParalizacion = (Date) getVariable(PROBPMContants.FECHA_PARALIZACION_TAREAS, executionContext);
        if (fechaInicio == null) {
            fechaInicio = new Date();
        }

        Long idProcedimiento = tarea.getProcedimiento().getId();

        Long idTipoJuzgado = null;
        Long idTipoPlaza = null;

        try {
            idTipoJuzgado = tarea.getProcedimiento().getJuzgado().getId();
            idTipoPlaza = tarea.getProcedimiento().getJuzgado().getPlaza().getId();

        } catch (NullPointerException e) {
            ;// El procedimiento puede no tener ni plaza ni juzgado, no se hace
             // nada
        }

        Long idTipoTarea = tarea.getTareaExterna().getTareaProcedimiento().getId();

        Long plazo = getPlazoTareaPorFechas(tarea);

        if (Checks.esNulo(plazo)) {
            plazo = getPlazoTareaPorTipoTarea(idTipoPlaza, idTipoTarea, idTipoJuzgado, idProcedimiento, null);
        }

        Date fechaVenc = null;
        if (Checks.esNulo(fechaParalizacion)) {
            logger.warn("La fecha de paralizaci�n del procedimiento  [" + idProcedimiento + "], tipoTarea [" + idTipoTarea + "]. no ha sido seteada");
            fechaVenc = new Date(fechaInicio.getTime() + plazo);
        } else {
            fechaVenc = new Date(fechaInicio.getTime() + (plazo - (fechaParalizacion.getTime() - tarea.getFechaInicio().getTime())));
        }

        // tarea.setFechaInicio(fechaInicio);

        tarea.setFechaVenc(fechaVenc);

        MEJProcedimiento mejProcedimiento = genericDao.get(MEJProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento),
                genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
        if (mejProcedimiento != null && mejProcedimiento.isEstaParalizado()) {
            GregorianCalendar fechaVenci = new GregorianCalendar();
            GregorianCalendar ahora = new GregorianCalendar();
            GregorianCalendar fechaParal = new GregorianCalendar();
            fechaParal.setTime(mejProcedimiento.getFechaUltimaParalizacion());
            fechaVenci.setTime(tarea.getFechaVenc());

            int diferencia = restarFechas(fechaParal, fechaVenci);
            if (diferencia >= 0) {
                ahora.add(Calendar.DATE, diferencia);
                fechaVenci = ahora;
            } else {// es que ya hab�an vencido, les a�adimos un d�a a
                    // partir de
                    // hoy
                ahora.add(Calendar.DATE, 1);
                fechaVenci = ahora;
            }
            tarea.setFechaVenc(fechaVenci.getTime());
        }

        tarea.setAlerta(false);
    }

    private int restarFechas(GregorianCalendar fecha1, GregorianCalendar fecha2) {
        long milis1 = fecha1.getTimeInMillis();
        long milis2 = fecha2.getTimeInMillis();
        // calcular la diferencia en milisengundos
        long diff = milis2 - milis1;
        // calcular la diferencia en dias
        long diffDays = diff / (24 * 60 * 60 * 1000);
        return Long.valueOf(diffDays).intValue();

    }

    /**
     * M�todo que devuelve si el BPM est� o no detenido.
     * 
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
     * M�todo que genera un nuevo hijo derivado del procedimiento.
     */
    @Transactional(readOnly = false)
    public void lanzaNuevoBpmHijo(final ExecutionContext executionContext) {
        System.out.println("lanzaNuevoBpmHijo overrides");
        final TareaProcedimiento tareaProcedimiento = getTareaProcedimiento(executionContext);
        final TipoProcedimiento tipoProcedimientoHijo = tareaProcedimiento.getTipoProcedimientoBPMHijo();

        // Creamos un nuevo procedimiento hijo a partir del padre, o o varios si tenemos algo sobre lo que iterar.
        Procedimiento procPadre = getProcedimiento(executionContext);
        
        final String iterationProperty = getIterationProperty(tareaProcedimiento);
        final Collection<?> iterador = getIteradorTarea(procPadre, iterationProperty);
        
        if (Checks.estaVacio(iterador)) {
            creaProcedimientoHijo(executionContext, tipoProcedimientoHijo, procPadre, null, null);
        } else {
            for (Object item : iterador) {
                creaProcedimientoHijo(executionContext, tipoProcedimientoHijo, procPadre,iterationProperty, item);
            }
        }

    }


    /**
     * PONER JAVADOC FO.
     * 
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
     * 
     * @return b
     */
    protected boolean existeTransicionDeAlerta(ExecutionContext executionContext) {
        return executionContext.getNode().getLeavingTransition(TRANSICION_ALERTA_TIMER) != null;
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @return b
     */
    protected boolean existeTimerDeAlerta(ExecutionContext executionContext) {
        String nombreTimer = "timer" + getNombreNodo(executionContext);
        return BPMUtils.getTimer(executionContext.getJbpmContext(), executionContext.getProcessInstance(), nombreTimer) != null;
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @param tarea
     *            t
     */
    protected void creaTimerDeAlerta(TareaNotificacion tarea, ExecutionContext executionContext) {
        Date fechaVenc = tarea.getFechaVenc();
        String nombreTimer = "timer" + getNombreNodo(executionContext);

        creaTimer(fechaVenc, nombreTimer, TRANSICION_ALERTA_TIMER, executionContext);
    }

    /**
     * M�todo que crea un timer para el token actual con la duraci�n y el
     * nombre que se le indica.
     * 
     * @param fechaVenc
     *            Duraci�n del timer
     * @param nombreTimer
     *            Nombre del timer
     * @param nombreTransicion
     *            nombreTransicion
     */
    protected void creaTimer(Date fechaVenc, String nombreTimer, String nombreTransicion, ExecutionContext executionContext) {
        BPMUtils.deleteTimer(executionContext, nombreTimer);
        Timer timer = BPMUtils.createTimer(executionContext, nombreTimer, fechaVenc, nombreTransicion);
        timer.setRetries(1);

        logger.debug("\tEl timer se ha creado : [" + getNombreNodo(executionContext) + " ] " + fechaVenc);
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @return b
     */
    public boolean debeDestruirTareaProcedimiento(ExecutionContext executionContext) {
        return !isTransicionMismoNodo(executionContext) && tieneTareaExterna(executionContext);
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @return b
     */
    protected boolean tieneTareaExterna(ExecutionContext executionContext) {
        return getIdTareaExterna(executionContext) != null;
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @return t
     */
    protected TareaExterna getTareaExterna(ExecutionContext executionContext) {
        Long idTarea = getIdTareaExterna(executionContext);
        if (idTarea != null) {
            return proxyFactory.proxy(TareaExternaApi.class).get(getIdTareaExterna(executionContext));
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
    
    protected TareaExterna getTareaExternaByName(String name, ExecutionContext executionContext) {
        Long idTarea = getIdTareaExternaByName(name, executionContext);
        if (idTarea != null) {
            return proxyFactory.proxy(TareaExternaApi.class).get(idTarea);
        }
        return null;

    }

    private Long getIdTareaExternaByName(String name, ExecutionContext executionContext) {
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
     * Muestra la informaci�n del nodo en el que se encuentra.
     * 
     * @param accion
     *            Texto con la acci�n que se ejecuta en el nodo
     */
    protected void printInfoNode(String accion, ExecutionContext executionContext) {
        if (!logger.isDebugEnabled()) {
            return;
        }

        long idToken = getTokenId(executionContext);
        String nombreProcedimiento = getNombreProceso(executionContext);
        String nombreTransicion = "";
        try {
            nombreTransicion = executionContext.getTransition().getName();
        } catch (Exception e) {
            logger.error(e);
        }

        logger.debug("Nodo Generico de " + nombreProcedimiento + " (" + executionContext.getProcessInstance().getId() + ")");
        logger.debug("\tAcci�n realizada: " + accion);
        logger.debug("\tNombre nodo: " + getNombreNodo(executionContext) + "(" + idToken + ")");
        logger.debug("\tNombre transicion: " + nombreTransicion);
    }

    /**
     * Devuelve la tarea asociada al nodo en ejecución y en el tipo de
     * procedimiento que se le indica.
     * 
     * @param codigoTarea
     *            Código de la tarea que se está ejecutando en el nodo
     * @return Devuelve una TareaProcedimiento asociada al nodo y al
     *         procedimiento
     */
    protected TareaProcedimiento getTareaProcedimiento(String codigoTarea, ExecutionContext executionContext) {

        Long idTipoProcedimiento = getProcedimiento(executionContext).getTipoProcedimiento().getId();
        TareaProcedimiento tareaProcedimiento = proxyFactory.proxy(TareaProcedimientoApi.class).getByCodigoTareaIdTipoProcedimiento(idTipoProcedimiento, codigoTarea);

        // TODO :�En este caso que se deber�a hacer? borrar las
        // �tareas_notificaciones?
        if (tareaProcedimiento == null) {
            String nombreProcedimiento = getNombreProceso(executionContext);
            // Destruimos el proceso BPM porque no podemos averiguar a que tarea
            // se está refiriendo
            Long idProceso = executionContext.getProcessInstance().getId();
            proxyFactory.proxy(JBPMProcessApi.class).destroyProcess(idProceso);

            String mensajeError = "La tarea para el nodo " + getNombreNodo(executionContext) + " del procedimiento " + nombreProcedimiento
                    + " no est� definida en la tabla TAP_TAREA_PROCEDIMIENTO, o no tiene el mismo c�digo de tarea.";
            logger.fatal(mensajeError);

            throw new UserException("bpm.error.tareaNoDefinida");
        }

        return tareaProcedimiento;
    }

    /**
     * M�todo que devuelve el procedimiento al que está asociado el BPM en
     * ejecución.
     * 
     * @return El procedimiento al que está asociado el BPM
     */
    public Procedimiento getProcedimiento(ExecutionContext executionContext) {

        Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento((Long) getVariable(PROCEDIMIENTO_TAREA_EXTERNA, executionContext));

        // TODO :Aquí podría recuperarse de la BD en caso de que no estuviera
        // en el contexto
        // Esto se podría hacer consultando el
        // executionContext.getProcessInstance().getId() y que coincidiera con
        // un PRC_PROCEDIMIENTOS

        // Si el procedimiento es null no podemos saber a que PRC_PROCEDIMIENTO
        // hace referencia este BPM y por tanto no podemos crear tareas
        if (procedimiento == null) {
            String nombreProcedimiento = getNombreProceso(executionContext);

            // Destruimos el proceso BPM porque no podemos averiguar a que
            // procedimiento pertenece
            proxyFactory.proxy(JBPMProcessApi.class).destroyProcess(executionContext.getProcessInstance().getId());

            // Mostramos un mensaje de error
            String mensajeError = "El BPM en ejecuci�n para el procedimiento " + nombreProcedimiento + " no tiene asociado un PRC_PROCEDIMIENTO y por tanto no puede continuar su ejecuci�n";
            logger.error(mensajeError);

            throw new UserException("bpm.error.procedimientoNoDefinido");
        }

        return procedimiento;
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

    /**
     * PONER JAVADOC FO.
     * 
     * @param key
     *            key
     * @return o
     */
    protected Object getVariable(String key, ExecutionContext executionContext) {
        return executionContext.getVariable(key);
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @param key
     *            key
     * @param value
     *            value
     */
    public void setVariable(String key, Object value, ExecutionContext executionContext) {
        executionContext.setVariable(key, value);
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @param key
     *            key
     * @return b
     */
    protected boolean hasVariable(String key, ExecutionContext executionContext) {
        return executionContext.getVariable(key) != null;
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
     * 
     * @return s
     */
    protected String getNombreNodo(ExecutionContext executionContext) {
        return executionContext.getNode().getName();
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @return s
     */
    protected String getNombreProceso(ExecutionContext executionContext) {
        return executionContext.getProcessDefinition().getName();
    }

    /**
     * Este es el inicio de ejecuci�n de nuestro c�digo JBPM. Se inicia una
     * nueva transacci�n con la conexi�n de la entidad que corresponde
     * procesar este jbpm (non-Javadoc)
     * 
     * @see org.jbpm.graph.def.ActionHandler#execute(org.jbpm.graph.exe.ExecutionContext)
     * @param executionContext
     *            ExecutionContext
     * @throws Exception
     *             e
     */
    public void execute(ExecutionContext executionContext) throws Exception {
        // this.setExecutionContext(executionContext);
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
     * 
     * @throws Exception
     *             e
     */
    public void run(ExecutionContext executionContext) throws Exception {
    }

    // /**
    // * PONER JAVADOC FO.
    // * @throws Exception e
    // */
    // public void run() throws Exception {
    // }

    /**
     * PONER JAVADOC FO.
     * 
     * @param executionContext
     *            e
     */
    public void setExecutionContext(ExecutionContext executionContext) {
        this.executionContext = executionContext;
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @return e
     */
    public ExecutionContext getExecutionContext() {
        return executionContext;
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @return b
     */
    public boolean debeCrearTareaProcedimiento(ExecutionContext executionContext) {
        return !isTransicionMismoNodo(executionContext) && tieneTareaProcedimiento(executionContext) && !isTareaDecision(executionContext);
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @return b
     */
    public boolean isTareaDecision(ExecutionContext executionContext) {
        return getNombreNodo(executionContext).endsWith("Decision");
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @return b
     */
    public boolean isTransicionMismoNodo(ExecutionContext executionContext) {
        Transition transicion = executionContext.getTransition();
        if (transicion != null) {
            return transicion.getTo().getName().equals(transicion.getFrom().getName());
        }

        return false;
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @return b
     */
    public boolean tieneTareaProcedimiento(ExecutionContext executionContext) {
        return getTareaProcedimiento(executionContext) != null;
    }

    /**
     * PONER JAVADOC FO.
     * 
     * @return tp
     */
    public TareaProcedimiento getTareaProcedimiento(ExecutionContext executionContext) {
        return getTareaProcedimiento(getNombreNodo(executionContext), executionContext);
    }
    
    /**
     * PONER JAVADOC FO.
     * 
     * @return tp
     */
    public TareaProcedimiento getTareaProcedimientoBBDD(ExecutionContext executionContext) {
        return getTareaProcedimientoBBDD(getNombreNodo(executionContext), executionContext);
    }  
    
    /**
     * Devuelve la tarea asociada al nodo en ejecución y en el tipo de
     * procedimiento que se le indica de la BBDD
     * 
     * @param codigoTarea
     *            Código de la tarea que se está ejecutando en el nodo
     * @return Devuelve una TareaProcedimiento asociada al nodo y al
     *         procedimiento
     */
    protected TareaProcedimiento getTareaProcedimientoBBDD(String codigoTarea, ExecutionContext executionContext) {

        Long idTipoProcedimiento = getProcedimiento(executionContext).getTipoProcedimiento().getId();
        TareaProcedimiento tareaProcedimiento = proxyFactory.proxy(TareaProcedimientoApi.class).getByCodigoTareaIdTipoProcedimiento(idTipoProcedimiento, codigoTarea);    
        
        return tareaProcedimiento;
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
     * Devuelve el plazo de una tarea mirando la fecha de inicio y la fecha de
     * vencimiento original.
     * <p>
     * Para que se pueda calcular este plazo es necesario que la tarea sea de
     * tipo {@link EXTTareaNotifiacion}. En caso de no poder obtener el plazo
     * devolver� NULL
     * 
     * @param tarea
     * @return Devuelve el plazo (en milisegundos) o NULL si �ste no se puede
     *         obtener
     */
    private Long getPlazoTareaPorFechas(TareaNotificacion tarea) {
        if (tarea == null) {
            return null;
        }

        if (tarea instanceof EXTTareaNotificacion) {
            EXTTareaNotificacion exttarea = (EXTTareaNotificacion) tarea;
            Date fechaVenc = (exttarea.getFechaVencReal() != null) ? exttarea.getFechaVencReal() : exttarea.getFechaVenc();

            if ((exttarea.getFechaInicio() != null) && (fechaVenc != null)) {
                return fechaVenc.getTime() - exttarea.getFechaInicio().getTime();
            } else {
                return null;
            }
        } else {
            return null;
        }
    }

    protected Procedimiento creaProcedimientoHijo(final ExecutionContext executionContext, final TipoProcedimiento tipoProcedimientoHijo, Procedimiento procPadre, final String iterationProperty, final Object item) {
        Procedimiento procHijo = proxyFactory.proxy(JBPMProcessApi.class).creaProcedimientoHijo(tipoProcedimientoHijo, procPadre);
        
        if ((iterationProperty != null) && (item != null)){
            List l = new ArrayList();
            l.add(item);
            String setterName = "set" + WordUtils.capitalize(iterationProperty);
            setCollectionOfValues(procHijo, setterName, l);
        }
        
        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_LANZAR_BPM_ASOC_PROC, procHijo.getId(), getTokenId(executionContext));
        // proxyFactory.proxy(JBPMProcessApi.class).lanzaBPMAsociadoAProcedimiento(procHijo.getId(),
        // getTokenId(executionContext));

        // Seteamos la variable
        setVariable(PROCEDIMIENTO_HIJO, procHijo.getId(), executionContext);
        logger.debug("se ha lanzado un nuevo proceso hijo con Id=" + procHijo.getId());
        return procHijo;
    }

    private Collection<?> getIteradorTarea(final Procedimiento procPadre, final String iterationProperty) {
        
        if (! Checks.esNulo(iterationProperty)){
            final String getterName = "get" + WordUtils.capitalize(iterationProperty);
            return getCollectionOfValues(procPadre, getterName);
        }else{
            return null;
        }
    }

    private List<?> getCollectionOfValues(final Procedimiento procPadre, final String getterName) {
        try {
            final Method getter = Procedimiento.class.getDeclaredMethod(getterName, null);
            final Object value = getter.invoke(procPadre, null);
            
            if (value instanceof List){
                return (List) value;
            }else{
                logger.warn("El resultado de " + getterName + "() sobre el procedimiento " + procPadre.getId() + " no es una Collection.");
                return null;
            }
        } catch (Exception e) {
            logger.warn("No se ha podido acceder al m�todo " + getterName + " de " + procPadre);
            return null;
        }
    }
    
    private void setCollectionOfValues(final Procedimiento proc, final String setterName, final List value){
        try {
            final Method setter = Procedimiento.class.getDeclaredMethod(setterName, List.class);
            
            setter.invoke(proc, value);
        } catch (Exception e) {
            logger.warn("No se ha podido acceder al m�todo " + setterName + " de " + proc);
        }
    }
    
    private String getIterationProperty(final TareaProcedimiento tareaProcedimiento) {
        if (! (tareaProcedimiento instanceof EXTTareaProcedimiento)){
            return null;
        }
        
        final EXTTareaProcedimiento tap = (EXTTareaProcedimiento) tareaProcedimiento;
        
        final String property = tap.getExpresionBucleBPM();
        return property;
    }
    
    /**
     * Este es un m�tod merdoso para deshacer el proxy de hibernate y averiguar
     * si es o no un MEJProcedimiento, si lo es lo devuelve si no devuelve NULL
     * 
     * @param p
     * @return
     */
    protected MEJProcedimiento getRealMejProcedimientoFromHibernateProxyOrNull(final Procedimiento p) {
        try {
            if (p == null)
                return null;
            if (p instanceof MEJProcedimiento)
                return (MEJProcedimiento) p;
            Hibernate.initialize(p);
            final Procedimiento real = (Procedimiento) ((HibernateProxy) p).getHibernateLazyInitializer().getImplementation();
            if (real instanceof MEJProcedimiento) {
                return (MEJProcedimiento) real;
            } else {
                return null;
            }
        } catch (ClassCastException e) {
            return null;
        }
    }
    
    /**
     * 
	 * M�todo que le genera a la tarea tantos timers como tenga definidos en la tabla de configuraci�n de timers, TTM_TAP_TIMER.
	 * 
	 * 	Configuraci�n de un timer:
	 * 		TTM_TAP_TIMER.TTM_NOMBRE: nombre del timer.
	 * 		TTM_TAP_TIMER.TAP_ID: id de la tarea para la que se configura el timer. Tabla TAP_TAREA_PROCEDIMIENTO.
	 * 		TTM_TAP_TIMER.TTM_TRANSICION: transici�n por la que avanzar� el BPM si se dispara el timer.
	 * 		TTM_TAP_TIMER.TTM_PLAZO_SCRIPT: tiempo de espera del timer antes de caducar. En milisegundos.
	 * 
	 * @param idTarea
	 * @param executionContext
	 * @throws Exception
	 * 
	 */
	protected void generarTimerTareaProcedimiento(Long idTarea, ExecutionContext executionContext) throws Exception {
		Date fechaInicio = (Date) getVariable(BPMContants.FECHA_ACTIVACION_TAREAS, executionContext);
        Date fechaParalizacion = (Date) getVariable(PROBPMContants.FECHA_PARALIZACION_TAREAS, executionContext);
        if (fechaInicio == null) {
            fechaInicio = new Date();
        }
		TareaExterna tareaExterna=proxyFactory.proxy(TareaExternaApi.class).get(idTarea);
		TareaNotificacion tarea=tareaExterna.getTareaPadre();
		
		Filter filtroTarea= genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.codigo", tareaExterna.getTareaProcedimiento().getCodigo());
		List<TimerTareaProcedimiento> timers = genericDao.getList(TimerTareaProcedimiento.class, filtroTarea);
		
		for (TimerTareaProcedimiento t : timers){
			
			String result = proxyFactory.proxy(JBPMProcessApi.class).evaluaScript(tareaExterna.getTareaPadre().getProcedimiento().getId(), null, tareaExterna.getTareaProcedimiento().getId(), null, t.getScriptPlazo()).toString();
            Long plazo = Long.parseLong(result.toString());
			Date fechaVencimiento = new Date(System.currentTimeMillis() + plazo);
			if (Checks.esNulo(fechaParalizacion)) {
	            logger.warn("La fecha de paralizaci�n del procedimiento  [" + tarea.getProcedimiento().getId() + "], tipoTarea [" + tareaExterna.getTareaProcedimiento().getTipoProcedimiento().getId() + "]. no ha sido seteada");
	            fechaVencimiento = new Date(fechaInicio.getTime() + plazo);
	        } else {
	        	fechaVencimiento = new Date(fechaInicio.getTime() + (plazo - (fechaParalizacion.getTime() - tarea.getFechaInicio().getTime())));
	        }
			String nombreTimer=tareaExterna.getId()+"."+t.getNombreTimer();
			creaTimer(fechaVencimiento, nombreTimer, t.getNombreTransicion(), executionContext);
		}
		
		
	}
	
	/**
	 * Este metod cambia el estado de un procedimiento
	 * @param codigoEstado C�digo del estado al que se quiere cambiar
	 * @param p Procedimiento que se quiere cambiar
	 */
	protected void cambiaEstadoProcedimiento(String codigoEstado, Procedimiento p){
		DDEstadoProcedimiento estado=genericDao.get(DDEstadoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoEstado));
		if (!Checks.esNulo(estado)){
			p.setEstadoProcedimiento(estado);
			genericDao.save(Procedimiento.class, p);
		} else {
			logger.warn("El estado de procedimiento con c�digo ["+codigoEstado+ "]  no existe");
		}
	}
	
	/**
	 * Este metod cambia el estado de un Asunto
	 * @param codigoEstado C�digo del estado al que se quiere cambiar
	 * @param asu Asunto que se quiere cambiar
	 */	
	protected void cambiaEstadoAsunto(String codigoEstado, Asunto asu){
		DDEstadoAsunto estado=genericDao.get(DDEstadoAsunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoEstado));
		if (!Checks.esNulo(estado)){
			asu.setEstadoAsunto(estado);
			genericDao.save(Asunto.class, asu);
		} else {
			logger.warn("El estado de asunto con c�digo ["+codigoEstado+ "]  no existe");
		}
	}
	
	/**
	 * Cambia el estado de los procedimientos del asunto, pudiendo indicar si solo afecta a los aceptados y si finaliza sus tareas
	 * @param codigoEstado el c�digo del nuevo estado
	 * @param asu el asunto que contiene los procedimientos
	 * @param soloAceptados Si solo interactua con los procedimientos aceptados
	 * @param finalizarTareas finaliza las tareas de los procedimientos que cambia su estado y las borra
	 */
	protected void cambiaEstadoPrcsDelAsunto(String codigoEstado, Asunto asu, Boolean soloAceptados, Boolean finalizarTareas){
		DDEstadoProcedimiento estado=genericDao.get(DDEstadoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoEstado));

		if (!Checks.esNulo(estado)){
			for (Procedimiento p : asu.getProcedimientos()) {
				if ((soloAceptados) ? p.getEstaAceptado() : true) {
					if (finalizarTareas) {
						//Finalizo y borro las tareas 
						for (TareaNotificacion tar : p.getTareas()) {
							if (Checks.esNulo(tar.getTareaFinalizada()) || !tar.getTareaFinalizada()) {
									proxyFactory.proxy(TareaNotificacionApi.class).borrarNotificacionTarea(tar.getId());
									
									TareaExterna tex = tar.getTareaExterna();
									if (!Checks.esNulo(tex)) {
										proxyFactory.proxy(es.pfsgroup.recovery.api.TareaExternaApi.class).borrar(tex);
									}																	
							}
						}
					}
					p.setEstadoProcedimiento(estado);
					genericDao.save(Procedimiento.class, p);
				}
			}
			
		} else {
			logger.warn("El estado de procedimiento con c�digo ["+codigoEstado+ "]  no existe");
		}
	}

}

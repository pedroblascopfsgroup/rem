package es.pfsgroup.framework.paradise.jbpm;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.JbpmContext;
import org.jbpm.graph.def.Node;
import org.jbpm.graph.def.Transition;
import org.jbpm.graph.exe.ExecutionContext;
import org.jbpm.graph.exe.ProcessInstance;
import org.jbpm.graph.exe.Token;
import org.jbpm.graph.node.EndState;
import org.jbpm.job.Timer;
import org.jbpm.scheduler.SchedulerService;
import org.jbpm.svc.Service;
import org.jbpm.svc.Services;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.transaction.annotation.Transactional;
import org.springmodules.workflow.jbpm31.JbpmCallback;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.bpm.ProcessManager;
import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.dsm.DataSourceManager;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.pfsgroup.framework.paradise.genericlistener.GenerarTransicionSaltoListener;

/**
 * Refactorización de las clases de la api de ejecución de BPMs.
 * @author manuel
 */
@org.springframework.stereotype.Service(JBPMProcessManager.BEAN_KEY)
@Scope(BeanDefinition.SCOPE_SINGLETON)
//TODO: revisar esta clase. EXTJBPMProcessManager
public class JBPMProcessManager implements BPMContants, JBPMProcessManagerApi {

    private final Log logger = LogFactory.getLog(getClass());

//    @Autowired
//    private TareaExternaManager tareaExternaManager;
//
//    @Autowired
//    private ScriptEvaluator evaluator;

//    @Resource
//    private List<String> clasesDiccionarioAnotadas;
//
//    private Map<String, Object> clasesDiccionario;

    private List<String> contextScripts;

    @Autowired
    private ProcessManager processManager;

    @Autowired
    private GenerarTransicionSaltoListener activoGenerarSalto;
    
    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#crearNewProcess(java.lang.String, java.util.Map)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS)
    @Transactional(readOnly = false)
    public long crearNewProcess(String instanceName, Map<String, Object> param) {
        // Agregamos el parametro para indicar contra que BD corre el proceso
        // Esto es necesario cuando alguna de las tareas se ejecuta en una instancia JBPM distinta
        determinarBBDD();
        param.put(DbIdContextHolder.DB_ID, DbIdContextHolder.getDbId());
        ProcessInstance processInstance = processManager.newProcessInstance(instanceName, param);
        return processInstance.getId();
    }

    private boolean transicionAFin(Transition transition) {
        return transition.getTo() instanceof EndState;
    }

    // la transición que queremos es aquella que se llama "Fin" o si no existe,
    // cualquiera que nos lleve a un nodo de tipo EndState
    @SuppressWarnings("unchecked")
    private Transition transicionAFin(Node node) {
        Transition t = null;
        List<Transition> transitions = node.getLeavingTransitions();
        for (Transition transition : transitions) {
            if ((t == null && (transicionAFin(transition))) || "Fin".equals(transition.getName())) {
                t = transition;
            }
        }
        return t;
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#destroyProcess(java.lang.Long)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS)
    public void destroyProcess(final Long idProcess) {
        if (isProcesoActivo(idProcess)) { return; }

        if (logger.isDebugEnabled()) {
            logger.debug("destroyProcess idProcess=" + idProcess);
        }

        processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                // Obtener la última instancia conocida
                ProcessInstance processInstance = context.getGraphSession().getProcessInstance(idProcess);
                if (processInstance == null) return null;

                Node nodoActual = processInstance.getRootToken().getNode();
                Transition transition = transicionAFin(nodoActual);

                if (transition != null) {
                    processInstance.getRootToken().signal(transition);
                } else {
                    logger.warn("No hay transición de Fin en el nodo " + nodoActual.getName() + " token=" + processInstance.getRootToken().getId());
                    logger.warn("Ejecutamos processInstance.end()");
                    processInstance.end();
                }

                return null;
            }
        });
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#signalProcess(java.lang.Long, java.lang.String)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS)
    public void signalProcess(final Long idProcess, final String transitionName) {
        processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                // Obtener la última instancia conocida
                ProcessInstance processInstance = context.getGraphSession().getProcessInstance(idProcess);
                if (processInstance == null) return null;

                //Si el token estÃ¡ terminado
                if (processInstance.isTerminatedImplicitly()) { return null; }

                if (transitionName == null) {
                    processInstance.signal();
                } else {
                    processInstance.signal(transitionName);
                }
                return null;
            }
        });
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#hasTransitionToken(java.lang.Long, java.lang.String)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_HAS_TRANSITION_TOKEN)
    public Boolean hasTransitionToken(final Long idToken, final String transitionName) {
        return (Boolean) processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                // Obtener la última instancia conocida

                Boolean resultado = false;

                try {
                    Token token = context.getGraphSession().getToken(idToken);
                    resultado = (token.getNode().getLeavingTransition(transitionName) != null);
                } catch (Exception e) {
                    return resultado;
                }

                return resultado;
            }
        });
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#signalToken(java.lang.Long, java.lang.String)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN)
    public void signalToken(final Long idToken, final String transitionName) {
        processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                // Obtener la última instancia conocida
                Token token = context.getGraphSession().getToken(idToken);

                //Si el token estÃ¡ terminado
                if (token.isTerminatedImplicitly()) { return null; }

                if (transitionName == null) {
                    token.signal();
                } else {
                    token.signal(transitionName);
                }
                return null;
            }
        });
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#getActualNode(java.lang.Long)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_GET_ACTUAL_NODE)
    public String getActualNode(final Long idProcess) {
        return (String) processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                // Obtener la última instancia conocida
                ProcessInstance processInstance = context.getGraphSession().getProcessInstance(idProcess);
                if (processInstance == null) return null;

                // Asegurarse que está donde corresponde
                Token token = processInstance.getRootToken();
                return token.getNode().getName();
            }
        });
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#addVariablesToProcess(java.lang.Long, java.util.Map)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_ADD_VARIABLES_TO_PROCESS)
    public void addVariablesToProcess(final Long idProcess, final Map<String, Object> variables) {
        processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                // Obtener la última instancia conocida
                ProcessInstance processInstance = context.getGraphSession().getProcessInstance(idProcess);
                if (processInstance == null) return null;

                //Insertar las variables al proceso
                processInstance.getContextInstance().setVariables(variables);
                return null;
            }
        });
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#getVariablesToProcess(java.lang.Long, java.lang.String)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS)
    public Object getVariablesToProcess(final Long idProcess, final String variableName) {
        return processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                // Obtener la última instancia conocida
                ProcessInstance processInstance = context.getGraphSession().getProcessInstance(idProcess);
                if (processInstance == null) return null;

                //Insertar las variables al proceso
                return processInstance.getContextInstance().getVariable(variableName);
            }
        });
    }

    /**
     * Pregunta si el proceso Sigue Activo.
     * @param idProcess id Proceso
     * @return activo o no
     */
    private Boolean isProcesoActivo(final Long idProcess) {
        return (Boolean) processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                // Obtener la última instancia conocida
                ProcessInstance processInstance = context.getGraphSession().getProcessInstance(idProcess);
                if (processInstance == null) return false;

                return Boolean.valueOf(!processInstance.hasEnded());
            }
        });
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#obtenerFechaFinProceso(java.lang.Long, java.lang.String)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_OBTENER_FECHA_FIN_PROCESO)
    public Date obtenerFechaFinProceso(final Long idProcess, String nameTimer) {
        ProcessInstance processInstance = processManager.getProcessInstance(idProcess);
        if (processInstance == null) { return null; }
        Timer timer = processManager.getTimer(processInstance, nameTimer);
        if (timer == null) {
            logger.warn("Se ha intentado actualizar un timer que no existe. idProceso: " + idProcess + "\t nombre: " + nameTimer);
            return null;
        }

        return timer.getDueDate();
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#creaORecalculaTimer(java.lang.Long, java.lang.String, java.util.Date, java.lang.String)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_CREA_O_RECALCULA_TIMER)
    public void creaORecalculaTimer(final Long idProcess, String nameTimer, Date newDueDate, String nameTransition) {
        ProcessInstance processInstance = processManager.getProcessInstance(idProcess);
        if (processInstance == null) { return; }

        Timer timer = processManager.getTimer(processInstance, nameTimer);

        //Si existe lo actualizamos
        if (timer != null) {
            processManager.updateTimerDueDate(processInstance, nameTimer, newDueDate);
        } else {
            //Si no existe lo creamos

            createTimer(idProcess, nameTimer, nameTransition, newDueDate);
        }
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#recalculaTimer(java.lang.Long, java.lang.String, java.util.Date)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_RECALCULAR_TIMER)
    public void recalculaTimer(final Long idProcess, String nameTimer, Date newDueDate) {
        //Comprobamos que existe el processInstance
        ProcessInstance processInstance = processManager.getProcessInstance(idProcess);
        if (processInstance == null) { return; }

        //Comprobamos que existe el Timer
        Timer timer = processManager.getTimer(processInstance, nameTimer);
        if (timer == null) {
            logger.warn("Se ha intentado actualizar un timer que no existe. idProceso: " + idProcess + "\t nombre: " + nameTimer);
            return;
        }

        processManager.updateTimerDueDate(processInstance, nameTimer, newDueDate);
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#determinarBBDD()
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_DETERMINAR_BBDD)
    public void determinarBBDD() {
        Long dbId = DataSourceManager.NO_DATASOURCE_ID;
        UsuarioSecurity usuario = (UsuarioSecurity) SecurityUtils.getCurrentUser();
        if (usuario == null) {
            if (DbIdContextHolder.getDbId() == null) {
                dbId = DataSourceManager.NO_DATASOURCE_ID;
            } else {
                dbId = DbIdContextHolder.getDbId();
            }
        } else {
            if (usuario.getEntidad() != null) {
                dbId = usuario.getEntidad().getId();
            } else {
                dbId = DataSourceManager.MASTER_DATASOURCE_ID;
            }
        }
        DbIdContextHolder.setDbId(dbId);
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#aplazarProcesosBPM(java.lang.Long, java.util.Date)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_APLAZAR_PROCESOS_BPM)
    public void aplazarProcesosBPM(Long idProcess, Date fechaActivacion) {
        Map<String, Object> variables = new HashMap<String, Object>();
        variables.put(BPMContants.FECHA_APLAZAMIENTO_TAREAS, fechaActivacion);
        this.addVariablesToProcess(idProcess, variables);
        signalProcessOrTokens(idProcess, BPMContants.TRANSICION_APLAZAR_TAREAS);
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#paralizarProcesosBPM(java.lang.Long)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_PARALIZAR_PROCESOS_BPM)
    public void paralizarProcesosBPM(final Long idProcess) {
        signalProcessOrTokens(idProcess, BPMContants.TRANSICION_PARALIZAR_TAREAS);
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#activarProcesosBPM(java.lang.Long)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_ACTIVAR_PROCESOS_BPM)
    public void activarProcesosBPM(final Long idProcess) {
        signalProcessOrTokens(idProcess, BPMContants.TRANSICION_ACTIVAR_TAREAS);
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#finalizarProcedimiento(java.lang.Long)
	 */
//    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_FINALIZAR_PROC)
//    public void finalizarProcedimiento(final Long idProcedimiento) throws Exception {
//
//        Procedimiento procedimiento = procedimientoDao.get(idProcedimiento);
//
//        if (procedimiento == null) { throw new UserException("El procedimiento [" + idProcedimiento + "] no existe en la BD"); }
//
//        Long idProcess = procedimiento.getProcessBPM();
//        if (idProcess != null) {
//
//            //Destruimos el proceso
//            destroyProcess(idProcess);
//
//            //Eliminamos las tareas Externas del procedimiento que aun estÃ¡n activas
//            List<TareaExterna> vTareas = tareaExternaManager.getActivasByIdProcedimiento(idProcedimiento);
//            Iterator<TareaExterna> it = vTareas.iterator();
//
//            while (it.hasNext()) {
//                TareaExterna tareaExterna = it.next();
//                tareaExternaManager.borrar(tareaExterna);
//            }
//
//        }
//    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#signalProcessOrTokens(java.lang.Long, java.lang.String)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS_OR_TOKENS)
    public void signalProcessOrTokens(final Long idProcess, final String nombreTransicion) {
        processManager.execute(new JbpmCallback() {
            @SuppressWarnings("unchecked")
            @Override
            public Object doInJbpm(JbpmContext context) {
                // Obtener la última instancia conocida
                ProcessInstance processInstance = context.getGraphSession().getProcessInstance(idProcess);
                if (processInstance == null) return null;

                Token token = processInstance.getRootToken();
                Iterator<Token> it = token.getActiveChildren().values().iterator();
                //Si tiene tokens activos los recorremos para señalizarlos
                if (it.hasNext()) {
                    while (it.hasNext()) {
                        token = it.next();
                        try {
                            signalToken(token.getId(), nombreTransicion);
                        } catch (Exception e) {
                            //Pueden haber nodos (los del usuario) que no acepten este tipo de transiciones, no es un problema en el siguiente nodo tarea se dormirá el BPM
                            logger.warn("Error al generar la transición [" + nombreTransicion + "] para el token [" + token.getId() + "]", e);
                        }
                    }
                } else {
                    //Si no tiene tokens activos señalizamos el process
                    try {
                        signalProcess(idProcess, nombreTransicion);
                    } catch (Exception e) {
                        //Pueden haber nodos (los del usuario) que no acepten este tipo de transiciones, no es un problema en el siguiente nodo tarea se dormirá el BPM
                        logger.warn("Error al generar la transición [" + nombreTransicion + "] para el proceso [" + idProcess + "]", e);
                    }
                }

                return null;
            }
        });

    }
    
    /**
     * Crea el contexto de ejecuciÃ³n para un script groovy introduciendo variables útiles, funciones y managers.
     * @return mapa
     * @throws ClassNotFoundException e
     */
//    private Map<String, Object> creaContextoParaScript(Long idProcedimiento, Long idTareaExterna, Long idTareaProcedimiento)
//            throws ClassNotFoundException {
//        Map<String, Object> context = new HashMap<String, Object>();
//
//        //Añadimos los managers necesarios
//        context.put("procedimientoManager", procedimientoManager);
//        context.put("ctx", ApplicationContextUtil.getApplicationContext());
//
//        Procedimiento procedimientoPadre = procedimientoManager.getProcedimiento(idProcedimiento).getProcedimientoPadre();
//        if (procedimientoPadre != null) {
//            context.put("valoresBPMPadre", creaMapValores(procedimientoPadre.getId()));
//        }
//
//        //Añadimos las variables necesarias
//        context.put("valores", creaMapValores(idProcedimiento));
//        introduceDiccionarios(context);
//        context.put("idProcedimiento", idProcedimiento);
//
//        if (idTareaExterna != null) {
//            TareaExterna tareaExterna = tareaExternaManager.get(idTareaExterna);
//            context.put("tareaExterna", tareaExterna);
//        }
//
//        int nVeces = getNVecesTareaExterna(idProcedimiento, idTareaProcedimiento);
//        context.put("nVecesTareaExterna", nVeces);
//
//        return context;
//    }
    
    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#getContextoParaScript(java.lang.Long, java.lang.Long, java.lang.Long)
	 */
//    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_GET_CONTEXTO_SCRIPT)
//    public Map<String, Object> getContextoParaScript(Long idProcedimiento, Long idTareaExterna, Long idTareaProcedimiento) throws ClassNotFoundException {
//    	return this.creaContextoParaScript(idProcedimiento, idTareaExterna, idTareaProcedimiento);
//    }

//    /**
//     * Introduce los diccionarios definidos en el bean clasesDiccionariosAnotadas en el contexto de los
//     * script groovy para que tengamos acceso.
//     * @param context contexto
//     * @throws ClassNotFoundException e
//     */
//    private void introduceDiccionarios(Map<String, Object> context) throws ClassNotFoundException {
//        context.putAll(getClasesDiccionario());
//    }
//
//    /**
//     * Tan sÃ­lo haremos el cálculo de las clases diccionarios la primera vez para crear el contexto.
//     * @return
//     * @throws ClassNotFoundException
//     */
//    private Map<String, Object> getClasesDiccionario() throws ClassNotFoundException {
//        if (clasesDiccionario == null) {
//            clasesDiccionario = new HashMap<String, Object>();
//            for (String clazz : clasesDiccionarioAnotadas) {
//                String varName = StringUtils.substringAfterLast(clazz, ".");
//                clasesDiccionario.put(varName, Class.forName(clazz));
//            }
//        }
//        return clasesDiccionario;
//    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#evaluaScript(java.lang.Long, java.lang.Long, java.lang.Long, java.util.Map, java.lang.String)
	 */
//    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_EVALUA_SCRIPT)
//    public Object evaluaScript(Long idProcedimiento, Long idTareaExterna, Long idTareaProcedimiento, Map<String, Object> contextoOriginal,
//            String script) throws Exception {
//        if (!StringUtils.isBlank(script)) {
//            Map<String, Object> params = creaContextoParaScript(idProcedimiento, idTareaExterna, idTareaProcedimiento);
//            if (!Checks.esNulo(contextoOriginal)) {
//                params.putAll(contextoOriginal);
//            }
//            String scriptAmpliado = getContextScriptsAsString() + script;
//
//            return evaluator.evaluate(scriptAmpliado, params);
//        }
//
//        return null;
//    }
    
    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#evaluaScriptPorContexto(java.lang.Long, java.lang.Long, java.lang.Long, java.util.Map, java.lang.String)
	 */
//    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_EVALUA_SCRIPT_POR_CONTEXTO)
//    public Object evaluaScriptPorContexto(Long idProcedimiento, Long idTareaExterna, Long idTareaProcedimiento, Map<String, Object> contextoOriginal,
//            String script) throws Exception {
//        if (!StringUtils.isBlank(script)) {
//            Map<String, Object> params = new HashMap<String, Object>();
//            if (Checks.esNulo(contextoOriginal)) {
//            	params = creaContextoParaScript(idProcedimiento, idTareaExterna, idTareaProcedimiento);
//            } else {
//                params.putAll(contextoOriginal);
//            }
//            String scriptAmpliado = getContextScriptsAsString() + script;
//
//            return evaluator.evaluate(scriptAmpliado, params);
//        }
//
//        return null;
//    }
    
//    /* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#evaluaScriptRecobro(java.lang.Long, java.util.Map, java.lang.String)
//	 */
//    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_EVALUA_SCRIPT_RECOBRO)
//    public Object evaluaScriptRecobro(Long idExpediente, Map<String, Object> contextoOriginal, String script) throws Exception {
//        if (!StringUtils.isBlank(script)) {
//            Map<String, Object> params = new HashMap<String, Object>();
//            params.put("ctx", ApplicationContextUtil.getApplicationContext());
//            if (contextoOriginal != null) {params.putAll(contextoOriginal);}
//            String scriptAmpliado = getContextScriptsAsString() + script;
//            return evaluator.evaluate(scriptAmpliado, params);
//        }
//        return null;
//    }
//
//    private String getContextScriptsAsString() {
//        StringBuffer sb = new StringBuffer();
//        for (String script : getContextScripts()) {
//            sb.append(script).append("\n");
//        }
//        return sb.toString();
//    }

//    /* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#creaMapValores(java.lang.Long)
//	 */
//    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_CREA_MAP_VALORES)
//    public Map<String, Map<String, String>> creaMapValores(Long idProcedimiento) {
//        List<TareaExterna> tareas = tareaExternaManager.obtenerTareasPorProcedimiento(idProcedimiento);
//        Map<String, Map<String, String>> valores = new HashMap<String, Map<String, String>>();
//
//        if (tareas != null) {
//            for (TareaExterna tarea : tareas) {
//                String codigo = tarea.getTareaProcedimiento().getCodigo();
//
//                //Queremos meter todas las tareas aunque sean repetitivas. A las repetitivas le iremos incrementando un contador
//                String temp = codigo;
//                int contador = 0;
//
//                //Mientras el nombre ya esté en el map, vamos incrementando el contador
//                while (valores.containsKey(temp)) {
//                    contador++;
//                    temp = codigo + "_" + contador;
//                }
//
//                /*
//                 * Ya tenemos el nombre de la tarea único en el map, con esto tendremos:
//                 *
//                 * tarea[P11_Leer] = xxx <-- Esta es la última vez que se ejecutó la tarea
//                 * tarea[P11_Leer_1] = yyy <-- Esta es la segunda vez que se ejecutó la tarea
//                 * tarea[P11_Leer_2] = zzz <-- Esta es la primera vez que se ejecutó esta tarea
//                 * tarea[P11_Escribir] = xxx
//                 *
//                */
//                codigo = temp;
//
//                //Si el código no está en el Map lo introducimos (esto es para evitar que se pase dos veces por la misma tarea)
//                if (!valores.containsKey(codigo)) {
//                    Map<String, String> valoresTarea = new HashMap<String, String>();
//
//                    List<TareaExternaValor> vValores = tareaExternaManager.obtenerValoresTarea(tarea.getId());
//                    //List<TareaExternaValor> vValores = tarea.getValores();
//
//                    if (vValores != null) {
//                        for (TareaExternaValor valor : vValores) {
//                            valoresTarea.put(valor.getNombre(), valor.getValor());
//                        }
//                    }
//                    valores.put(codigo, valoresTarea);
//                }
//            }
//        }
//
//        return valores;
//    }

//    private int getNVecesTareaExterna(Long idProcedimiento, Long idTareaProcedimiento) {
//        if (idTareaProcedimiento == null || idProcedimiento == null) { return 0; }
//        int resultado = 0;
//        try {
//
//            List<TareaExterna> lista = tareaExternaManager.getByIdTareaProcedimientoIdProcedimiento(idProcedimiento, idTareaProcedimiento);
//
//            if (lista != null) {
//                resultado = lista.size();
//            }
//        } catch (Exception e) {
//            logger.warn("Error al extraer el NVecesTareaExterna", e);
//        }
//        return resultado;
//    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#setContextScripts(java.util.List)
	 */
    @Override
	public void setContextScripts(List<String> contextScript) {
        this.contextScripts = contextScript;
    }
//
//    /* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#getContextScripts()
//	 */
//    @Override
//	public List<String> getContextScripts() {
//        return contextScripts;
//    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#creaProcedimientoHijo(es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento, es.capgemini.pfs.asunto.model.Procedimiento)
	 */
//    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_CREA_PROCEDIMIENTO_HIJO)
//    public Procedimiento creaProcedimientoHijo(TipoProcedimiento tipoProcedimiento, Procedimiento procPadre) {
//        Procedimiento procHijo = new Procedimiento();
//
//        procHijo.setAsunto(procPadre.getAsunto());
//        //procHijo.setContrato(procPadre.getContrato());
//        procHijo.setDecidido(procPadre.getDecidido());
//        procHijo.setExpedienteContratos(procPadre.getExpedienteContratos());
//        procHijo.setFechaRecopilacion(procPadre.getFechaRecopilacion());
//        procHijo.setJuzgado(procPadre.getJuzgado());
//        procHijo.setCodigoProcedimientoEnJuzgado(procPadre.getCodigoProcedimientoEnJuzgado());
//        procHijo.setObservacionesRecopilacion(procPadre.getObservacionesRecopilacion());
//        procHijo.setPlazoRecuperacion(procPadre.getPlazoRecuperacion());
//        procHijo.setTipoActuacion(procPadre.getTipoActuacion());
//        procHijo.setPorcentajeRecuperacion(procPadre.getPorcentajeRecuperacion());
//        procHijo.setSaldoOriginalNoVencido(procPadre.getSaldoOriginalNoVencido());
//        procHijo.setSaldoOriginalVencido(procPadre.getSaldoOriginalVencido());
//        procHijo.setSaldoRecuperacion(procPadre.getSaldoRecuperacion());
//        procHijo.setTipoReclamacion(procPadre.getTipoReclamacion());
//        procHijo.setTipoProcedimiento(tipoProcedimiento);
//        procHijo.setProcedimientoPadre(procPadre);
//
//        List<Persona> personas = new ArrayList<Persona>();
//        for (Persona per : procPadre.getPersonasAfectadas()) {
//            Persona p = personaDao.get(per.getId());
//            personas.add(p);
//        }
//        procHijo.setPersonasAfectadas(personas);
//
//        DDEstadoProcedimiento estadoProcedimiento = estadoProcedimientoDao.buscarPorCodigo(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO);
//        procHijo.setEstadoProcedimiento(estadoProcedimiento);
//
//        Long idProcedimiento = procedimientoManager.saveProcedimiento(procHijo);
//
//        return procedimientoManager.getProcedimiento(idProcedimiento);
//    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#lanzaBPMAsociadoAProcedimiento(java.lang.Long, java.lang.Long)
	 */
//    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_LANZAR_BPM_ASOC_PROC)
//    public Long lanzaBPMAsociadoAProcedimiento(Long idProcedimiento, Long idTokenAviso) {
//        Procedimiento procedimiento = procedimientoManager.getProcedimiento(idProcedimiento);
//
//        //Lanzamos el BPM nuevo asociandolo al nuevo procedimiento
//        String procesoJBPM = procedimiento.getTipoProcedimiento().getXmlJbpm();
//        Map<String, Object> params = new HashMap<String, Object>();
//        params.put(BPMContants.PROCEDIMIENTO_TAREA_EXTERNA, idProcedimiento);
//        if (idTokenAviso != null) {
//            params.put(TOKEN_JBPM_PADRE, idTokenAviso);
//        }
//
//        long idProcessBPM = crearNewProcess(procesoJBPM, params);
//
//        //Escribimos el id de proceso BPM en el objeto procedimiento
//        procedimiento.setProcessBPM(idProcessBPM);
//        procedimientoManager.saveOrUpdateProcedimiento(procedimiento);
//
//        return idProcessBPM;
//    }

    /** Método de ayuda para obtener una variable tipo Boolean de JBPM. Hemos comprobado que no convierte bien cuando se
     * guardan objetos boolean. A veces los devuelve como String
     * @param executionContext ExecutionContext
     * @param key String
     * @return boolean
     */
//    @BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_GET_FIXE_BOOLEAN_VALUE)
    public static Boolean getFixeBooleanValue(ExecutionContext executionContext, String key) {

        Object value = executionContext.getVariable(key);
        if (value instanceof String) { return "T".equals(value); }
        return (Boolean) value;

    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#getProcessVariable(java.lang.Long, java.lang.String)
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_GET_PROCESS_VARIABLES)
    public Object getProcessVariable(final Long idToken, final String variable) {
        return processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                // Obtener la última instancia conocida
                ProcessInstance processInstance = context.getGraphSession().getToken(idToken).getProcessInstance();

                return processInstance.getContextInstance().getVariable(variable);
            }
        });

    }

    /**
     * Crea un timer sin acceder a su executionContext.
     * @param idProcessInstance
     * @param nombreTimer
     * @param nombreTransicion
     * @param dueDate
     * @return
     */
    private Timer createTimer(Long idProcessInstance, String nombreTimer, String nombreTransicion, Date dueDate) {
        ProcessInstance processInstance = processManager.getProcessInstance(idProcessInstance);

        Timer timer = new Timer(processInstance.getRootToken());
        timer.setName(nombreTimer);
        timer.setTransitionName(nombreTransicion);
        timer.setProcessInstance(processInstance);
        timer.setDueDate(dueDate);
        timer.setLockTime(new Date());
        timer.setExclusive(true);

        SchedulerService schedulerService = (SchedulerService) getJBPMServiceFactory(Services.SERVICENAME_SCHEDULER);
        schedulerService.createTimer(timer);

        return timer;
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#stopJobExecutor()
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_STOP_JOB_EXECUTOR)
    public synchronized void stopJobExecutor() {
        processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                try {
                    if (context.getJbpmConfiguration().getJobExecutor().isStarted()) {
                        logger.info("Stoping JobExecutor ....");
                        context.getJbpmConfiguration().getJobExecutor().stopAndJoin();
                        logger.info("JobExecutor stoped!");
                    }
                } catch (InterruptedException e) {
                    logger.error(e);
                }
                return null;
            }
        });

    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#startJobExecutor()
	 */
    @Override
//	@BusinessOperation(ComunBusinessOperation.BO_JBPM_MGR_START_JOB_EXECUTOR)
    public synchronized void startJobExecutor() {
        processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                try {
                    if (!context.getJbpmConfiguration().getJobExecutor().isStarted()) {
                        logger.info("Starting JobExecutor ....");
                        context.getJbpmConfiguration().getJobExecutor().start();
                        logger.info("JobExecutor started!");
                    }
                } catch (Exception e) {
                    logger.error(e);
                }
                return null;
            }
        });
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcessManagerApi#getJBPMServiceFactory(java.lang.String)
	 */
    @Override
	public Service getJBPMServiceFactory(final String serviceName) {
        return (org.jbpm.svc.Service) processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                return (org.jbpm.svc.Service) org.jbpm.svc.Services.getCurrentService(serviceName);
            }
        });
    }
    
    /**
     * Genera transiciones autom�ticamente de salto en los nodos, s�lo si no existen.
     * Para crear una transici�n implementar la interfaz {@link GenerarTransicionSaltoListener}
     * 
     * @param executionContext ExecutionContext
     */
    @Override
    public void generaTransicionesSalto(final Long idToken, final String tipoSalto) {		
          processManager.execute(new JbpmCallback() {
               @Override
               public Object doInJbpm(JbpmContext context) {
                   Token token = context.getGraphSession().getToken(idToken);
                   ExecutionContext executionContext = new ExecutionContext(token);
                    
                   Map<String, Object> map = new HashMap<String, Object>();
                   map.put(GenerarTransicionSaltoListener.CLAVE_EXECUTION_CONTEXT, executionContext);
                   activoGenerarSalto.fireEventGeneric(map, tipoSalto);
                   
                   return null;
               }
           });
       }
    
}

package es.pfsgroup.recovery.ext.impl.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.jbpm.JbpmContext;
import org.jbpm.graph.exe.ProcessInstance;
import org.jbpm.graph.exe.Token;
import org.jbpm.job.Timer;
import org.jbpm.scheduler.SchedulerService;
import org.jbpm.svc.Service;
import org.jbpm.svc.Services;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springmodules.workflow.jbpm31.JbpmCallback;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.bpm.ProcessManager;
import es.capgemini.devon.scripting.ScriptEvaluator;
import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.expediente.ExpedienteManager;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.EXTTareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.bpm.ExtendedProcessManager;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;

import org.apache.commons.lang.StringUtils;

@Component
public class EXTJBPMProcessManager extends EXTBaseJBPMProcessManager implements
		EXTJBPMProcessApi {

	@Autowired
	private ProcessManager processManager;

	@Autowired
	private ExtendedProcessManager extendedProcessManager;

	@Autowired
	private ScriptEvaluator evaluator;
	
	@Autowired
    private EXTProcedimientoManager procedimientoManager;
	
	@Autowired
	private EXTTareaExternaManager tareaExternaManager;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private ExpedienteManager expedienteManager;
	
	@Resource
    private List<String> clasesDiccionarioAnotadas;

    private Map<String, Object> clasesDiccionario;
    
    private List<String> contextScripts;
    
    private static final String TIMER_TAREA_CE = "TIMER_CE";
    private static final String TIMER_TAREA_RE = "TIMER_RE";
    private static final String TIMER_TAREA_DC = "TIMER_DC";
    
    
    public Service getJBPMServiceFactory(final String serviceName) {
        return (org.jbpm.svc.Service) processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                return (org.jbpm.svc.Service) org.jbpm.svc.Services.getCurrentService(serviceName);
            }
        });
    }
    @BusinessOperation(EXT_JBPMAPI_BORRAR_TIMERS_TAREA)
    @Transactional(readOnly = false)
    public void borraTimersTarea(final Long idTareaExterna){
        final TareaExterna tarea = tareaExternaManager.get(idTareaExterna);
        
        ProcessInstance processInstance = processManager.getProcessInstance(tarea.getTareaPadre().getProcedimiento().getProcessBPM());
        SchedulerService schedulerService = (SchedulerService) getJBPMServiceFactory(Services.SERVICENAME_SCHEDULER);
        
        List<Timer> timers = extendedProcessManager.getTimers(processInstance, idTareaExterna + ".%");
        for (Timer t : timers){
            schedulerService.deleteTimersByName(t.getName(), t.getToken());
        }
    }

	/**
	 * Obtiene los nodos actuales del proceso. Este m�todo es �til en los casos
	 * que se ha llegado a un Fork
	 * 
	 * @param idProcess
	 *            id del proceso
	 * @return Lista con los nombre de los nodos
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation(EXT_JBPMAPI_GET_CURRENT_NODES)
	@Override
	// FIXME: faltan los tests de este m�todo.
	public List<String> getCurrentNodes(final Long idProcess) {
		return (List<String>) processManager.execute(new JbpmCallback() {
			@Override
			public Object doInJbpm(JbpmContext context) {
				// Obtener la �ltima instancia conocida
				ProcessInstance processInstance = context.getGraphSession()
						.getProcessInstance(idProcess);
				if (processInstance == null)
					return null;
				
				// Asegurarse que est� donde corresponde
				Token rootToken = processInstance.getRootToken();
				return getNodeNames(rootToken);
			}

			private List<String> getNodeNames(Token rootToken) {
				ArrayList<String> nodeNames = new ArrayList<String>();
				if (rootToken != null){
					Map childTokens = rootToken.getActiveChildren();
					if (childTokens.size() > 0) {
						
				        for (Object childToken : childTokens.values())
				        {
							//Node node = ((Token)childToken).getNode();
							//nodeNames.add(node.getName());
				        	if (childToken != null){
				        		nodeNames.addAll(this.getNodeNames((Token)childToken));
				        	}
				        }
						
					} else {
						nodeNames.add(rootToken.getNode().getName());
					}
				}

				return nodeNames;
			}
		});
	}

	//@BusinessOperation(overrides = ComunBusinessOperation.BO_JBPM_MGR_EVALUA_SCRIPT)
	public Object evaluaScript(Long idProcedimiento, Long idTareaExterna,
			Long idTareaProcedimiento, Map<String, Object> contextoOriginal,
			String script) throws Exception {
		
		System.out.println("llega a evaluaScript overrides");
		if (!StringUtils.isEmpty(script)) {
			Map<String, Object> params = creaContextoParaScript(
					idProcedimiento, idTareaExterna, idTareaProcedimiento);
			if (contextoOriginal != null) {
				params.putAll(contextoOriginal);
			}

			String scriptAmpliado = getContextScriptsAsString() + script;
			System.out.println(scriptAmpliado);
			return evaluator.evaluate(scriptAmpliado, params);
		}

		return null;
	}

	private Map<String, Object> creaContextoParaScript(Long idProcedimiento,
			Long idTareaExterna, Long idTareaProcedimiento)
			throws ClassNotFoundException {
		Map<String, Object> context = new HashMap<String, Object>();

		// A�adimos los managers necesarios
		context.put("procedimientoManager", procedimientoManager);
		context.put("ctx", ApplicationContextUtil.getApplicationContext());

		Procedimiento procedimientoPadre = ((Procedimiento)executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,idProcedimiento)).getProcedimientoPadre();
		
		if (procedimientoPadre != null) {
			context.put("valoresBPMPadre", executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREA_MAP_VALORES,procedimientoPadre.getId()));
		}

		// A�adimos las variables necesarias
		context.put("valores", executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREA_MAP_VALORES,idProcedimiento));
		introduceDiccionarios(context);
		context.put("idProcedimiento", idProcedimiento);

		if (idTareaExterna != null) {
			TareaExterna tareaExterna = (TareaExterna) executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET,idTareaExterna);
			context.put("tareaExterna", tareaExterna);
		}

		int nVeces = getNVecesTareaExterna(idProcedimiento,
				idTareaProcedimiento);
		context.put("nVecesTareaExterna", nVeces);

		return context;
	}

	private String getContextScriptsAsString() {
		StringBuffer sb = new StringBuffer();
		for (String script : getContextScripts()) {
			sb.append(script).append("\n");
		}
		return sb.toString();
	}

	 private void introduceDiccionarios(Map<String, Object> context) throws ClassNotFoundException {
	        context.putAll(getClasesDiccionario());
	    }
	 private Map<String, Object> getClasesDiccionario() throws ClassNotFoundException {
	        if (clasesDiccionario == null) {
	            clasesDiccionario = new HashMap<String, Object>();
	            for (String clazz : clasesDiccionarioAnotadas) {
	                String varName = StringUtils.substringAfterLast(clazz, ".");
	                clasesDiccionario.put(varName, Class.forName(clazz));
	            }
	        }
	        return clasesDiccionario;
	    }
	 
	 public List<String> getContextScripts() {
	        return contextScripts;
	    }
	 
	 private int getNVecesTareaExterna(Long idProcedimiento, Long idTareaProcedimiento) {
	        if (idTareaProcedimiento == null || idProcedimiento == null) { return 0; }
	        int resultado = 0;
	        try {

	            List<TareaExterna> lista = (List<TareaExterna>) executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET_TARS_EXTERNA_BY_TAREA_PROC,idProcedimiento, idTareaProcedimiento);

	            if (lista != null) {
	                resultado = lista.size();
	            }
	        } catch (Exception e) {
	           System.out.println("Error al extraer el NVecesTareaExterna");
	        }
	        return resultado;
	    }
	 	
	 	@BusinessOperation(EXT_JBPMAPI_BORRAR_TIMERS_EXPEDIENTE)
	    @Transactional(readOnly = false)
	    public void borraTimersExpediente(final Long idExpediente){
	        
	 		Expediente expediente = expedienteManager.getExpediente(idExpediente); 
	 		
	        ProcessInstance processInstance = processManager.getProcessInstance(expediente.getProcessBpm());
	        SchedulerService schedulerService = (SchedulerService) getJBPMServiceFactory(Services.SERVICENAME_SCHEDULER);
	        
	        List<Timer> timers = null; 
	        
	        // Borramos los timers de Completar expediente
	        timers = extendedProcessManager.getTimers(processInstance, TIMER_TAREA_CE);
	        for (Timer t : timers){
	            schedulerService.deleteTimersByName(t.getName(), t.getToken());
	        }
	        
	        //Borramos los timers de Revisión Expediente 
	        timers = extendedProcessManager.getTimers(processInstance, TIMER_TAREA_RE);
	        for (Timer t : timers){
	            schedulerService.deleteTimersByName(t.getName(), t.getToken());
	        }
	        
	        //Borramos los timers de Decisión Comité
	        timers = extendedProcessManager.getTimers(processInstance, TIMER_TAREA_DC);
	        for (Timer t : timers){
	            schedulerService.deleteTimersByName(t.getName(), t.getToken());
	        }
	       
	    }
}

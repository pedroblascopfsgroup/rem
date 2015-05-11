package es.pfsgroup.procedimientos;

import static es.capgemini.pfs.BPMContants.PROCEDIMIENTO_TAREA_EXTERNA;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.def.ActionHandler;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;
import es.pfsgroup.procedimientos.recoveryapi.ProcedimientoApi;
import groovy.util.GroovyScriptEngine;


/**
 * Crea un timer a partir de un script de groovy (damePlazo....)
 */
@Component
public class GenericTimerDelayExtenderActionHandler extends PROBaseActionHandler implements ActionHandler {
			
    private static final long serialVersionUID = 1L;
    
    @Autowired
    protected JBPMProcessManager processUtils;
    
    private static final Log logger = LogFactory.getLog(GenericTimerDelayExtenderActionHandler.class);
    
    private String name;
    
    private String transicion;
    
    private String scriptGroovy;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTransicion() {
		return transicion;
	}

	public void setTransicion(String transicion) {
		this.transicion = transicion;
	}

	public String getScriptGroovy() {
		return scriptGroovy;
	}

	public void setScriptGroovy(String scriptGroovy) {
		this.scriptGroovy = scriptGroovy;
	}

	@Override
	public void execute(ExecutionContext executionContext) throws Exception {
		if (logger.isDebugEnabled()) {
            logger.debug("EsperaCarenciaActionHandlerExtended......");
            logger.debug("[name=" + name + ", scriptGroovy=" + scriptGroovy + ", transition=" + transicion + "]");
            logger.debug("Ceando timer");
        }
		
		  Procedimiento procedimiento = getProcedimiento(executionContext);
		  
		  TareaExterna tExterna = getTareaExterna(executionContext);
		  if (!Checks.esNulo(tExterna) && !Checks.esNulo(procedimiento)) {
			  
			  Long idTarea = tExterna.getTareaProcedimiento().getId();
			  
			  String result = proxyFactory.proxy(JBPMProcessApi.class).evaluaScript(procedimiento.getId(), null, idTarea , null, scriptGroovy).toString();
	          Long plazo = Long.parseLong(result.toString());
	          
	          String duration = result + " day";
	          
	          BPMUtils.createTimer (executionContext, name, duration, transicion);
		  }
	}
	
	
}


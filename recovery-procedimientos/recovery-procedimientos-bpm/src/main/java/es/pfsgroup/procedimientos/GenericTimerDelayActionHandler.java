package es.pfsgroup.procedimientos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.def.ActionHandler;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.BPMUtils;


/**
 * PONER JAVADOC FO.
 */
@Component
public class GenericTimerDelayActionHandler implements ActionHandler {
    private static final long serialVersionUID = 1L;
    
    private static final Log logger = LogFactory.getLog(GenericTimerDelayActionHandler.class);
    
    private String name;
    
    private String duration;
    
    private String transicion;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDuration() {
		return duration;
	}

	public void setDuration(String duration) {
		this.duration = duration;
	}

	public String getTransicion() {
		return transicion;
	}

	public void setTransicion(String transicion) {
		this.transicion = transicion;
	}

	@Override
	public void execute(ExecutionContext executionContext) throws Exception {
		if (logger.isDebugEnabled()) {
            logger.debug("EsperaCarenciaActionHandler......");
            logger.debug("[name=" + name + ", duration=" + duration + ", transition=" + transicion + "]");
            logger.debug("Ceando timer");
        }
		
		BPMUtils.createTimer (executionContext, name, duration, transicion);
	}
	
	
}


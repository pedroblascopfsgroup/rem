package es.pfsgroup.plugin.precontencioso.expedienteJudicial.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.utils.JBPMProcessManager;

public class JBPMProcessPrecontenciosoManager {
	
	@Autowired
	private JBPMProcessManager jbpmUtils;
	
    public void setContextScripts(List<String> contextScript) {
        jbpmUtils.getContextScripts().addAll(contextScript);
    }
}

package es.pfsgroup.plugin.recobro.bpm.utils;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.utils.JBPMProcessManager;

public class JBPMProcessRecobroManager {
	
	@Autowired
	private JBPMProcessManager jbpmUtils;
	
    public void setContextScripts(List<String> contextScript) {
        jbpmUtils.getContextScripts().addAll(contextScript);
    }
}

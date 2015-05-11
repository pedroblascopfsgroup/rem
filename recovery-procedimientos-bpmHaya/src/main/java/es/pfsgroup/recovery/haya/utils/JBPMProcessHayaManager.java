package es.pfsgroup.recovery.haya.utils;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.utils.JBPMProcessManager;

public class JBPMProcessHayaManager {
       
       @Autowired
       private JBPMProcessManager jbpmUtils;
       
        /**
    * settter.
    * @param contextScript context
    */
   public void setContextScripts(List<String> contextScript) {
       jbpmUtils.getContextScripts().addAll(contextScript);
   }

}

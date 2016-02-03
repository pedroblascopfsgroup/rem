package es.capgemini.devon.bpm;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.BeanFactory;

/**
 * @author Nicolás Cornaglia
 */
public class JbpmFactoryLocator extends org.springmodules.workflow.jbpm31.JbpmFactoryLocator {

    private static final Log logger = LogFactory.getLog(JbpmFactoryLocator.class);

    @Override
    protected void addToMap(String fName, BeanFactory factory) {
        if (logger.isDebugEnabled())
            logger.debug("adding key=" + fName + " w/ reference=" + factory);

        synchronized (beanFactories) {
            // override check
            if (!beanFactories.containsKey(fName)) {
                beanFactories.put(fName, factory);
            }

        }
    }

}

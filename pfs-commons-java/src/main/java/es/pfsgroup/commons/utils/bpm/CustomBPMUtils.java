package es.pfsgroup.commons.utils.bpm;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.jbpm.JbpmContext;
import org.jbpm.graph.exe.ProcessInstance;
import org.jbpm.job.Timer;

import es.capgemini.devon.utils.BPMUtils;

/**
 * Clase de utilidad para los procesos de JBPM que amplía lo que ofrece {@link BPMUtils}
 * 
 * @since 2.6.0
 * @author bruno
 *
 */
public class CustomBPMUtils {
    
    private static final String SELECT_TIMER = "select job from org.jbpm.job.Job as job where job.processInstance = :processInstance and name like :name";

    /**
     * Devuelve una lista de {@link Timer} asociados a una instancia y cuyo nombre coincida con una expresión
     * @param context
     * @param processInstance
     * @param expresssion
     * @return
     */
    public static List<Timer> getTimersByName(JbpmContext context, ProcessInstance processInstance, String expresssion) {
        Session session = context.getSession();
        Query query = session.createQuery(SELECT_TIMER);

        query.setParameter("processInstance", processInstance);
        query.setParameter("name", expresssion);

        List jobs = query.list();
        
        return jobs;
    }

}

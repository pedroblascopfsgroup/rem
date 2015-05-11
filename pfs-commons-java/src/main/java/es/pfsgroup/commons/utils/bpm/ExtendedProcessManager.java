package es.pfsgroup.commons.utils.bpm;

import java.util.List;

import org.jbpm.graph.exe.ProcessInstance;
import org.jbpm.job.Timer;

import es.capgemini.devon.bpm.ProcessManager;

/**
 * Esta interfaz (incluida en pfs-commons-java 2.6.0) extiende la funcionalidad del {@link ProcessManager} de Devon.
 * 
 * @since 2.6.0
 * @author bruno
 *
 */
public interface ExtendedProcessManager{
    
    /**
     * Devuelve una lista de {@link Timer} asociados con una instancia de JBPM y cuyo nombre coincida con una determinada expresión de HQL.
     * 
     * @since 2.6.0
     * 
     * @param processInstance Instancia a la que deben pertenecr los {@link Timer}
     * @param expression Expresión HQL con la que tienen que coincidir el nombre.
     * @return
     */
    List<Timer> getTimers(final ProcessInstance processInstance, final String expression);

}

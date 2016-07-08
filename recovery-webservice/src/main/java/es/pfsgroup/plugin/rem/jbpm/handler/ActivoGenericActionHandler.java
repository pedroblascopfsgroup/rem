package es.pfsgroup.plugin.rem.jbpm.handler;

import java.lang.reflect.Method;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Component
public abstract class ActivoGenericActionHandler extends ActivoBaseActionHandler implements ApplicationContextAware{
	
	
	protected interface ConstantesBPMPFS {
		public static final String NOMBRE_NODO_SALIENTE = "NOMBRE_NODO_SALIENTE";
	}
	
	private static final long serialVersionUID = 2678952054173019541L;
	
    @Autowired
    protected ApiProxyFactory proxyFactory;
    
	private ApplicationContext applicationContext;

    /**
     * {@inheritDoc}
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {

        logger.debug("Manejador del nodo " + this.getClass().getName());

        Object delegateTransitionClass = null;
        Object delegateSpecificClass = null;
        try {
            delegateTransitionClass = applicationContext.getBean(getTransitionName(executionContext));
            Method setEc = delegateTransitionClass.getClass().getMethod("setExecutionContext", ExecutionContext.class);
            setEc.invoke(delegateTransitionClass, executionContext);
        } catch (Exception e) {
            logger.debug("No existe bean para controlar la transición de entrada [" + getTransitionName(executionContext) + "]");
        }
        try {
            String nombreBeanEspecifico = getNombreProceso(executionContext) + "." + getNombreNodo(executionContext);
            delegateSpecificClass = applicationContext.getBean(nombreBeanEspecifico);
            Method setEc = delegateSpecificClass.getClass().getMethod("setExecutionContext", ExecutionContext.class);
            setEc.invoke(delegateSpecificClass, executionContext);
        } catch (Exception e) {
            logger.debug("No existe bean específico para este nodo [" + getNombreNodo(executionContext) + "]");
        }

        DbIdContextHolder.setDbId((Long) executionContext.getVariable("DB_ID"));
        process(delegateTransitionClass, delegateSpecificClass, executionContext);
    }
    /**
     * TODO documentar FO.
     * @param delegateTransitionClass Object
     * @param delegateSpecificClass Object
     * @throws Exception 
     */
    protected abstract void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) throws Exception;

    /**
     * {@inheritDoc}
     */
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
    }
}

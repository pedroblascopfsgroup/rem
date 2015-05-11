package es.capgemini.pfs.bpm.generic;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.DbIdContextHolder;

/**
 * Clase genérica para manejar los eventos de jbpm.
 *
 */
@Component
public abstract class GenericActionHandler extends BaseActionHandler implements ApplicationContextAware {
    private static final long serialVersionUID = 1L;
    private ApplicationContext applicationContext;

    /**
     * {@inheritDoc}
     */
    @Override
    public void run() throws Exception {

        logger.debug("Manejador del nodo " + this.getClass().getName());

        BaseActionHandler delegateTransitionClass = null;
        BaseActionHandler delegateSpecificClass = null;
        try {
            delegateTransitionClass = (BaseActionHandler) applicationContext.getBean(getTransitionName());
            delegateTransitionClass.setExecutionContext(getExecutionContext());
        } catch (Exception e) {
            logger.debug("No existe bean para controlar la transición de entrada [" + getTransitionName() + "]");
        }
        try {
            String nombreBeanEspecifico = getNombreProceso() + "." + getNombreNodo();
            delegateSpecificClass = (BaseActionHandler) applicationContext.getBean(nombreBeanEspecifico);
            delegateSpecificClass.setExecutionContext(getExecutionContext());
        } catch (Exception e) {
            logger.debug("No existe bean específico para este nodo [" + getNombreNodo() + "]");
        }

        DbIdContextHolder.setDbId((Long) getExecutionContext().getVariable("DB_ID"));
        process(delegateTransitionClass, delegateSpecificClass);
    }
    /**
     * TODO documentar FO.
     * @param delegateTransitionClass Object
     * @param delegateSpecificClass Object
     */
    protected abstract void process(Object delegateTransitionClass, Object delegateSpecificClass);

    /**
     * {@inheritDoc}
     */
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
    }

}

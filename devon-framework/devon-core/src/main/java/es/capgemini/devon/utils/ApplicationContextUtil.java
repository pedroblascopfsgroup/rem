package es.capgemini.devon.utils;

import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.startup.Initializable;

/**
 * @author lgiavedo
 *
 */
@Scope(BeanDefinition.SCOPE_SINGLETON)
@Component
public class ApplicationContextUtil implements ApplicationContextAware, Initializable{
    
    private static ApplicationContext appContext;
    
    /**
     * @param applicationContext the applicationContext to set
     */
    public void setApplicationContext(ApplicationContext applicationContext) {
        this.appContext = applicationContext;
    }
    

    /**
     * Return the applicationContext
     * 
     * @return ApplicationContext
     */
    public static ApplicationContext getApplicationContext() {
        return appContext;
    }
    
    /**
     * Return object from applicationContext
     * 
     * @param name
     * @return
     */
    public static Object getBean(String name){
        return appContext.getBean(name);
    }


    @Override
    public int getOrder() {
        return 1;
    }


    @Override
    public void initialize() throws FrameworkException {
    }
}

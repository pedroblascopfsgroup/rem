package es.pfsgroup.plugin.rem.genericService.api.impl;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.genericService.api.AbstractServiceFactoryApi;
import es.pfsgroup.plugin.rem.genericService.api.GenericService;

@Component
public abstract class AbstractServiceFactoryManager<T extends GenericService> implements AbstractServiceFactoryApi<T> {

    private static final Object DEFAULT_SERVICE_BEAN_KEY = "DEFAULT";
    
	private ApplicationContext mApplicationContext;
    
    private Class<T> clazz;
    
    private Map<String, List<String>> updaterBeansMap = new HashMap<String, List<String>>();
    
	@SuppressWarnings("unchecked")
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {

		clazz = this.getTypeParameterClass();
		
		mApplicationContext = applicationContext;
		Map<String, T> beansMap = mApplicationContext.getBeansOfType(clazz);
		
		if (beansMap.isEmpty()) 
		{
            Error noProcessorError = new Error("No existen beans configurados del tipo " + clazz);
            throw noProcessorError;
        }
		
		for(Map.Entry<String,T> entry : beansMap.entrySet()){
			String[] keys = entry.getValue().getKeys();
			for (String key : keys){
				List<String> lista = null;
				if(Checks.estaVacio(updaterBeansMap.get(key))) {
					lista = new ArrayList<String>();					
				} else {
					lista = updaterBeansMap.get(key);					
				}
				lista.add(entry.getKey());
				updaterBeansMap.put(key, lista);
			}
		}
	}

    @SuppressWarnings ("unchecked")
    public Class<T> getTypeParameterClass()
    {
        Type type = getClass().getGenericSuperclass();
        ParameterizedType paramType = (ParameterizedType) type;
        return (Class<T>) paramType.getActualTypeArguments()[0];
    }
    
	public T getService(final String key) {

		return this.getService(key, null);
	}


	@SuppressWarnings("unchecked")
	public T getService(final String key, final String defaultKey) {

		T beanClass = null;
		String beanName = null;
		if (!Checks.estaVacio(updaterBeansMap.get(key))){ 
			beanName = updaterBeansMap.get(key).get(0);
		}
		if(beanName == null){
		 	if(defaultKey != null){
		 		if (!Checks.estaVacio(updaterBeansMap.get(defaultKey))){ 
		 			beanName = updaterBeansMap.get(defaultKey).get(0);
		 		}
		 	}else{
		 		if (!Checks.estaVacio(updaterBeansMap.get(DEFAULT_SERVICE_BEAN_KEY))){ 
		 			beanName = updaterBeansMap.get(DEFAULT_SERVICE_BEAN_KEY).get(0);
		 		}
		 	}
		}
		
		
	 	if (beanName == null) {
		    throw new IllegalArgumentException("No se encuentra el servicio para la clave " + key);
	 	}

	    beanClass = (T) mApplicationContext.getBean(beanName);
		return beanClass;
	}
	
	public List<T> getServices(final String key) {

		return this.getServices(key, null);
	}
	
	@SuppressWarnings("unchecked")
	public List<T> getServices(final String key, final String defaultKey) {

		List<T> listBeanClass = new ArrayList<T>();
		List<String> listBeanName = null;
		
		listBeanName = updaterBeansMap.get(key);
		
		if(Checks.estaVacio(listBeanName)){
		 	if(defaultKey != null){
		 		listBeanName = updaterBeansMap.get(defaultKey);
		 		
		 	}else{
		 		listBeanName = updaterBeansMap.get(DEFAULT_SERVICE_BEAN_KEY);
		 		
		 	}
		}		
		
	 	if (Checks.estaVacio(listBeanName)) {
		    throw new IllegalArgumentException("No se encuentra la lista de servicios para la clave " + key);
	 	}
	 	
	 	for(String s : listBeanName) {

		    T beanClass = (T) mApplicationContext.getBean(s);
		    listBeanClass.add(beanClass);
	 	}

		return listBeanClass;
	}


}

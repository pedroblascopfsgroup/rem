package es.pfsgroup.plugin.rem.gestorDocumental.manager;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;

@Component
public class DownloaderFactory implements DownloaderFactoryApi, ApplicationContextAware {

    private static final Object DEFAULT_SERVICE_BEAN_KEY = "DEFAULT";
    
	private ApplicationContext mApplicationContext;
    
    private Map<String, String> updaterBeansMap = new HashMap<String, String>();
    
	@SuppressWarnings("unchecked")
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {

		this.mApplicationContext = applicationContext;
		
		Map<String, Downloader> beansMap = mApplicationContext.getBeansOfType(Downloader.class);
		
		if (beansMap.isEmpty()) 
		{
            Error noProcessorError = new Error("No existen beans configurados del tipo Downloader");
            throw noProcessorError;
        }
		
		for(Map.Entry<String,Downloader> entry : beansMap.entrySet()){
			String[] keys = entry.getValue().getKeys();
			for (String key : keys){
				updaterBeansMap.put(key, entry.getKey());
			}
		}
	}

    
	public Downloader getService(final String key) {

		return this.getService(key, null);
	}


	public Downloader getService(final String key, final String defaultKey) {

		Downloader beanClass = null;
		
		String beanName = updaterBeansMap.get(key);
 
		 	    
		if(beanName == null){
		 	if(defaultKey != null){
		 		beanName = updaterBeansMap.get(defaultKey);
		 	}else{
		 		beanName = updaterBeansMap.get(DEFAULT_SERVICE_BEAN_KEY);
		 	}
		 	if (beanName == null) {
			    throw new IllegalArgumentException("No se encuentra el servicio para la clave " + key);
		 	}
		}
		

	    beanClass = (Downloader) mApplicationContext.getBean(beanName);
		return beanClass;
	}


	@Override
	public Downloader getDownloader(final String key) {
		return this.getService(key, null);
	}

}

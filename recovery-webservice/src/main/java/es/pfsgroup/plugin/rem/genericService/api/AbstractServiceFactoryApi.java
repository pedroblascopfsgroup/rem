package es.pfsgroup.plugin.rem.genericService.api;

import java.util.List;

import org.springframework.context.ApplicationContextAware;

public abstract interface AbstractServiceFactoryApi<T extends GenericService> extends ApplicationContextAware{
	
	T getService(final String key, final String defaultKey);
	
	T getService(final String key);
	
	List<T> getServices(final String key, final String defaultKey);
	
	List<T> getServices(final String key);

}

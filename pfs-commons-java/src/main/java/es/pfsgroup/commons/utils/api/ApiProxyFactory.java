package es.pfsgroup.commons.utils.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;

@Component
public class ApiProxyFactory {
	
	@Autowired
	private Executor executor;
	
	public ApiProxyFactory(){
		
	}
	
	public ApiProxyFactory(Executor executor){
		this.executor = executor;
	}

	
	public <T> T proxy(Class<T> api){
		return ApiProxy.newInstance(executor, api);
	}
}

package es.pfsgroup.commons.utils.api;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;

public class ApiProxy implements InvocationHandler{
	
	public static final int EXECUTOR_MAX_ARGS = 5;
	
	 public static <T> T newInstance(Executor executor, Class<T> clazz){
		if (executor == null) {
			throw new IllegalArgumentException("'executor' IS NULL");
		}
		Class<T>[] interfaces = new Class[]{clazz};
		return (T) java.lang.reflect.Proxy.newProxyInstance(
			    clazz.getClassLoader(),
			    interfaces,
			    new ApiProxy(executor));

	}
	
	private Executor ex;
	
	private ApiProxy(Executor exec){
		this.ex = exec;
	}

	@Override
	public Object invoke(Object proxy, Method method, Object[] args)
			throws Throwable {
		BusinessOperationDefinition bo = method.getAnnotation(BusinessOperationDefinition.class);
		if (bo == null){
			throw new ApiException("pfs.commons.api.businessoperation.notdefined",method);
		}
		String name = bo.value();
		if (args == null){
			return ex.execute(name);
		}else{
			int n = args.length;
			switch (n) {
			case 1:
				return ex.execute(name,args[0]);
			case 2:
				return ex.execute(name,args[0],args[1]);
			case 3:
				return ex.execute(name,args[0],args[1],args[2]);
			case 4:
				return ex.execute(name,args[0],args[1],args[2],args[3]);
			case 5:
				return ex.execute(name,args[0],args[1],args[2],args[3],args[4]);
			default:
				throw new ApiException("pfs.commons.api.businessoperation.argumentslimitexceeded", name,n,EXECUTOR_MAX_ARGS);
			}
		}
	}

}

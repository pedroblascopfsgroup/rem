package es.pfsgroup.plugin.messagebroker.integration;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class HandlerInvocator {
	
	private Object bean;
	private Method method;
	public HandlerInvocator(Object bean, Method method) {
		super();
		this.bean = bean;
		this.method = method;
	}
	
	public Object invokeHandler(Object param) throws IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		return this.method.invoke(this.bean, param);
	}

	public String getMethodName() {
		return this.method.getName();
	}

	public Object getBean() {
		return this.bean;
	}

	@Override
	public String toString() {
		return "HandlerInvocator [" + method.toString() + "]";
	}
	
	

}

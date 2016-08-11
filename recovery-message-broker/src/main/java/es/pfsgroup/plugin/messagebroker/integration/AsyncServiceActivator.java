package es.pfsgroup.plugin.messagebroker.integration;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.integration.core.Message;

import es.pfsgroup.plugin.messagebroker.StandardHeaders;
import es.pfsgroup.plugin.messagebroker.exceptions.WrongMessage;

public class AsyncServiceActivator implements ApplicationContextAware {

	private ApplicationContext springContext;

	public Message<Object> processMessage(Message<Object> msg) {
		String typeOfMessage = (String) msg.getHeaders().get(StandardHeaders.TYPE_OF_MESSAGE);

		if (typeOfMessage == null) {
			throw new WrongMessage(msg, "Cannot found stardard header: " + StandardHeaders.TYPE_OF_MESSAGE);
		}

		String serviceBeanName = typeOfMessage + "Handler";
		String requestMethodName = typeOfMessage + "Request";
		String responseMethodName = typeOfMessage + "Response";

		Object service = springContext.getBean(serviceBeanName);

		if (service == null) {
			throw new WrongMessage(msg, "service not found for handling message: " + serviceBeanName);
		}

		Object payload = msg.getPayload();

		Object response = invoqueMethodAndManageExceptions(msg, service, requestMethodName, payload);
		if (response != null) {
			invoqueMethodAndManageExceptions(msg, service, responseMethodName, response);
		}

		return msg;
	}

	private Object invoqueMethodAndManageExceptions(Message<Object> msg, Object service, String methodName,
			Object parameter) {
		try {
			Method requestMethod = service.getClass().getDeclaredMethod(methodName, parameter.getClass());
			Object response = requestMethod.invoke(service, parameter);
			return response;

		} catch (SecurityException e) {
			throw new WrongMessage(msg, methodName + ": method cannot be accessed in " + service.getClass().getName(),
					e);
		} catch (NoSuchMethodException e) {
			throw new WrongMessage(msg, methodName + ": method doesn't exist in " + service.getClass().getName());
		} catch (IllegalArgumentException e) {
			throw new WrongMessage(msg, service.getClass().getName() + "." + methodName + ": unexpected argument type "
					+ parameter.getClass().getName(), e);
		} catch (IllegalAccessException e) {
			throw new WrongMessage(msg, methodName + ": method cannot be accessed in " + service.getClass().getName(),
					e);
		} catch (InvocationTargetException e) {
			throw new WrongMessage(msg, service.getClass().getName() + "." + methodName + ":: method execution error",
					e);
		}
	}

	@Override
	public void setApplicationContext(ApplicationContext arg0) throws BeansException {
		this.springContext = arg0;

	}
}

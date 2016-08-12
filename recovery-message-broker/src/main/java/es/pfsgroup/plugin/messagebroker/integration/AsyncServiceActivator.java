package es.pfsgroup.plugin.messagebroker.integration;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.integration.core.Message;
import org.springframework.integration.message.MessageBuilder;

import es.pfsgroup.plugin.messagebroker.exceptions.WrongMessage;

public class AsyncServiceActivator implements ApplicationContextAware {

	private ApplicationContext springContext;

	private MessageBrokerHandlerRegistry handlerRegistry;

	public Message<Object> messageRequest(Message<Object> msg) {
		String typeOfMessage = extractTypeOfMessage(msg);

		HandlerInvocator handlerInvocator = handlerRegistry.getRequestHandler(typeOfMessage);

		Object response;
		if (handlerInvocator != null) {
			response = invoqueMethodAndManageExceptions(msg, handlerInvocator);
		} else {
			String requestMethodName = typeOfMessage + "Request";
			Object service = getService(msg, typeOfMessage);
			response = invoqueMethodAndManageExceptions(msg, service, requestMethodName);
		}

		MessageBuilder<? extends Object> msgBuilder = null;
		if (response != null) {
			msgBuilder = MessageBuilder.withPayload(response);
		} else {
			msgBuilder = MessageBuilder.withPayload(EmptyPayload.getInstance());
		}
		msgBuilder.copyHeaders(msg.getHeaders());

		return (Message<Object>) msgBuilder.build();
	}

	public void messageResponse(Message<Object> msg) {

		if (EmptyPayload.checkEquals(msg.getPayload())) {
			return;
		}
		String typeOfMessage = extractTypeOfMessage(msg);
		
		HandlerInvocator handlerInvocator = handlerRegistry.getResponseHandler(typeOfMessage);
		if (handlerInvocator != null) {
			invoqueMethodAndManageExceptions(msg, handlerInvocator);
		}else{
			Object service = getService(msg, typeOfMessage);
			String responseMethodName = typeOfMessage + "Response";
			invoqueMethodAndManageExceptions(msg, service, responseMethodName);
		}

		

	}

	private Object getService(Message<Object> msg, String typeOfMessage) {
		String serviceBeanName = typeOfMessage + "Handler";
		Object service = springContext.getBean(serviceBeanName);
		if (service == null) {
			throw new WrongMessage(msg, "service not found for handling message: " + serviceBeanName);
		}
		return service;
	}

	private String extractTypeOfMessage(Message<Object> msg) {
		String typeOfMessage = (String) msg.getHeaders().get(StandardHeaders.TYPE_OF_MESSAGE);

		if (typeOfMessage == null) {
			throw new WrongMessage(msg, "Cannot found stardard header: " + StandardHeaders.TYPE_OF_MESSAGE);
		}
		return typeOfMessage;
	}

	private Object invoqueMethodAndManageExceptions(Message<Object> msg, Object service, String methodName) {
		Object parameter = msg.getPayload();

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

	private Object invoqueMethodAndManageExceptions(Message<Object> msg, HandlerInvocator invocator) {
		String methodName = invocator.getMethodName();
		Object service = invocator.getBean();
		return this.invoqueMethodAndManageExceptions(msg, service, methodName);
	}

	@Override
	public void setApplicationContext(ApplicationContext arg0) throws BeansException {
		this.springContext = arg0;

	}

	public void setHandlerRegistry(MessageBrokerHandlerRegistry handlerRegistry) {
		this.handlerRegistry = handlerRegistry;
	}
}

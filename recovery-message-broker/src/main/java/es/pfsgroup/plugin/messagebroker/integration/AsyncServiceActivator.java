package es.pfsgroup.plugin.messagebroker.integration;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.integration.annotation.Header;
import org.springframework.integration.core.Message;
import org.springframework.integration.message.MessageBuilder;

import com.sun.xml.internal.bind.api.impl.NameConverter.Standard;

import es.pfsgroup.plugin.messagebroker.exceptions.MessageBrokerControlledException;
import es.pfsgroup.plugin.messagebroker.exceptions.RetriesRequiredException;
import es.pfsgroup.plugin.messagebroker.exceptions.WrongMessage;

public class AsyncServiceActivator implements ApplicationContextAware {

	private ApplicationContext springContext;

	private MessageBrokerHandlerRegistry handlerRegistry;

	public Message<Object> messageRequest(Message<Object> msg) {
		String typeOfMessage = extractTypeOfMessage(msg);

		HandlerInvocator handlerInvocator = handlerRegistry.getRequestHandler(typeOfMessage);

		Object response = null;
		MessageBuilder<? extends Object> msgBuilder = null;
		Map<String, Object> additionalHeaders = new HashMap<String, Object>();
		try {
			if (handlerInvocator != null) {
				response = invoqueMethodAndManageExceptions(msg, handlerInvocator);
			} else {
				String requestMethodName = typeOfMessage + "Request";
				Object service = getService(msg, typeOfMessage);
				response = invoqueMethodAndManageExceptions(msg, service, requestMethodName);
			}
			if (response != null) {
				msgBuilder = MessageBuilder.withPayload(response);
			} else {
				msgBuilder = MessageBuilder.withPayload(EmptyPayload.getInstance());
			}
			additionalHeaders.put(StandardHeaders.ROUTER_CHANNEL, "async.output");

			

		} catch (RetriesRequiredException rre) {
			msgBuilder = MessageBuilder.withPayload(msg.getPayload());
			if (msg.getHeaders().containsKey(StandardHeaders.RETRIES)) {
				Integer retries = (Integer) msg.getHeaders().get(StandardHeaders.RETRIES);
				additionalHeaders.put(StandardHeaders.RETRIES, ++ retries);
			} else {
				additionalHeaders.put(StandardHeaders.RETRIES, 0);
			}
			
			if (rre.getMiliseconds() > 0){
				Date now = new Date();
				long timestamp = now.getTime() + rre.getMiliseconds();
				additionalHeaders.put(StandardHeaders.RETRY_TIMESTAMP, new Date(timestamp));
			}
			
			additionalHeaders.put(StandardHeaders.MAX_RETRIES, rre.getRetries());
			additionalHeaders.put(StandardHeaders.LAST_EXCEPTION, rre.getCause());
			additionalHeaders.put(StandardHeaders.ROUTER_CHANNEL, "retries-channel");

		}
		
		msgBuilder.copyHeaders(msg.getHeaders());
		msgBuilder.copyHeaders(additionalHeaders);

		Message<Object> outputMessage = (Message<Object>) msgBuilder.build();
		return outputMessage;
	}
	
	
	public String route(Message<Object> msg){
		return (String) msg.getHeaders().get(StandardHeaders.ROUTER_CHANNEL);
	}

	public String retryRequest(Message<Object> msg) {
		Integer retries = (Integer) msg.getHeaders().get(StandardHeaders.RETRIES);
		Integer maxRetries = (Integer) msg.getHeaders().get(StandardHeaders.MAX_RETRIES);

		if (retries < maxRetries) {
			if (msg.getHeaders().containsKey(StandardHeaders.RETRY_TIMESTAMP)){
				Date timestamp = (Date) msg.getHeaders().get(StandardHeaders.RETRY_TIMESTAMP);
				if (timestamp.before(new Date())){
					return "retries-channel";
				}
			}
			return "async.input";
		} else {
			// guardamos el mensaje en el log de errores
			return "nullChannel";
		}
	}

	public void messageResponse(Message<Object> msg) {

		if (EmptyPayload.checkEquals(msg.getPayload())) {
			return;
		}
		String typeOfMessage = extractTypeOfMessage(msg);

		HandlerInvocator handlerInvocator = handlerRegistry.getResponseHandler(typeOfMessage);
		if (handlerInvocator != null) {
			invoqueMethodAndManageExceptions(msg, handlerInvocator);
		} else {
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
			throw new WrongMessage(msg, "Cannot found standard header: " + StandardHeaders.TYPE_OF_MESSAGE);
		}
		return typeOfMessage;
	}

	private Object invoqueMethodAndManageExceptions(Message<Object> msg, Object service, String methodName)  {
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
			if (e.getCause() instanceof MessageBrokerControlledException){
				throw (MessageBrokerControlledException) e.getCause();
			}
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

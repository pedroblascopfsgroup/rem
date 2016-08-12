package es.pfsgroup.plugin.messagebroker.integration;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.util.ReflectionUtils;

import es.pfsgroup.plugin.messagebroker.MessageBrokerUtils;
import es.pfsgroup.plugin.messagebroker.annotations.AnnotationConstants;
import es.pfsgroup.plugin.messagebroker.annotations.AsyncRequestHandler;
import es.pfsgroup.plugin.messagebroker.annotations.AsyncResponseHandler;

public class MessageBrokerHandlerRegistry {

	private static class RegistryContainer {
		boolean initialized = false;
		private final Map<String, HandlerInvocator> requestHandlers = new HashMap<String, HandlerInvocator>();
		private final Map<String, HandlerInvocator> responseHandlers = new HashMap<String, HandlerInvocator>();

		public Map<String, HandlerInvocator> getRequestHandlers() {
			return requestHandlers;
		}

		public Map<String, HandlerInvocator> getResponseHandlers() {
			return responseHandlers;
		}

		public boolean isInitialized() {
			if (!initialized) {
				synchronized (this) {
					// Si el contexto no está inicializado esperamos (max 10s) a
					// ver si termina de inicializarse.
					try {
						this.wait(10000);
					} catch (InterruptedException e) {
						throw new RuntimeException(this.getClass().getSimpleName() + " Initialization problem.", e);
					}
				}
			}
			return initialized;
		}

		public synchronized void markAsInitialized() {
			this.initialized = true;
			this.notifyAll();
		}

	}

	@Autowired
	private DefaultListableBeanFactory beanFactory;

	private ClassLoader classLoader = DefaultResourceLoader.class.getClassLoader();

	private final RegistryContainer registryContainer = new RegistryContainer();

	@PostConstruct
	public void initialize() throws BeansException {
		Thread initializerThread = new Thread(new Runnable() {

			@Override
			public void run() {
				runInitialization();
				registryContainer.markAsInitialized();
			}
		});

		initializerThread.start();
	}

	public HandlerInvocator getRequestHandler(String typeOfMessage) {
		if (!registryContainer.isInitialized()) {
			throw new IllegalStateException("The Handler Registry is not yet initialized.");
		}
		return this.registryContainer.getRequestHandlers().get(typeOfMessage);
	}

	public HandlerInvocator getResponseHandler(String typeOfMessage) {
		if (!registryContainer.isInitialized()) {
			throw new IllegalStateException("The Handler Registry is not yet initialized.");
		}
		return this.registryContainer.getResponseHandlers().get(typeOfMessage);
	}

	private void runInitialization() {
		String[] beanNames = beanFactory.getBeanDefinitionNames();
		for (String name : beanNames) {
			final String beanName = name;
			BeanDefinition bd = null;
			try {
				bd = beanFactory.getBeanDefinition(beanName);
			} catch (BeansException e) {
				throw new RuntimeException(e);
			}
			if (bd != null && bd.getBeanClassName() != null) {
				Class<?> clazz = null;
				try {
					clazz = classLoader.loadClass(bd.getBeanClassName());
				} catch (ClassNotFoundException e) {
					throw new RuntimeException(e);
				}
				ReflectionUtils.doWithMethods(clazz, new ReflectionUtils.MethodCallback() {

					@Override
					public void doWith(Method method) throws IllegalArgumentException, IllegalAccessException {
						registerHandlerIfMatch(beanFactory.getBean(beanName), method);

					}

				});
			}
		}
	}

	private <T> void registerHandlerIfMatch(Object bean, Method method) {
		// Registramos los REQUEST handlers
		AsyncRequestHandler requestAnnotation = AnnotationUtils.findAnnotation(method, AsyncRequestHandler.class);
		if (requestAnnotation != null) {
			registerHandler(this.registryContainer.getRequestHandlers(), requestAnnotation.typeOfMessage(), bean,
					method);
		}

		// Registramos los RESPONSE handlers
		AsyncResponseHandler responseAnnotation = AnnotationUtils.findAnnotation(method, AsyncResponseHandler.class);
		if (responseAnnotation != null) {
			registerHandler(this.registryContainer.getResponseHandlers(), responseAnnotation.typeOfMessage(), bean,
					method);
		}
	}

	private void registerHandler(Map<String, HandlerInvocator> registry, String typeOfMessage, Object bean,
			Method method) {
		if ((typeOfMessage != null) && (!"".equals(typeOfMessage))) {
			String hanlderInvocatorId;
			if (AnnotationConstants.CLASS_AS_TYPE_OF_MESSAGE.equals(typeOfMessage)) {
				hanlderInvocatorId = MessageBrokerUtils.lowercaseFirstChar(bean.getClass().getSimpleName());
			} else {
				hanlderInvocatorId = typeOfMessage;
			}

			registry.put(hanlderInvocatorId, new HandlerInvocator(bean, method));
		}
	}

}

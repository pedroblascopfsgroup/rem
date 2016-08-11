package es.pfsgroup.plugin.messagebroker.integrationtest.webservice;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import es.pfsgroup.plugin.messagebroker.MessageBroker;
import junit.framework.Assert;

@RunWith(MockitoJUnitRunner.class)
public class WebServiceMessageBrokerTests {

	private MessageBroker messageBroker;

	@Test
	public void test() {
		RequestDto request = new RequestDto();

		/*
		 * Inicializamos el contexto de Spring
		 */
		String[] configLocations = new String[] { "optionalConfiguration/ac-recovery-message-broker.xml",
				"/webservices/spring-webservices-test-config.xml" };

		/*
		 * Obtenemos el bean messageBroker para invocar y el stub para validar
		 * el test.
		 */
		ApplicationContext ctx = new ClassPathXmlApplicationContext(configLocations);
		messageBroker = (MessageBroker) ctx.getBean("messageBroker");

		WebServcieCallHandler handler = (WebServcieCallHandler) ctx.getBean("webServiceCallHandler");
		// Validamos que el stub no esté inicializado
		Assert.assertNull("El handler no puede estar inicializado al empezar el test", handler.getResponse());

		/*
		 * Realizamos la llamada al message broker indicando el tipo de mensaje
		 * que enviamos. El sistema de mensajería debe encontrar el tipo de
		 * handler adecuado (el stub) e invocar los métodos adecuados
		 */
		messageBroker.sendAsync("webServiceCall", request);

		/*
		 * Validamos que se hayan hecho todas las llamadas
		 */
		ResponseDto response = handler.getResponse();
		Assert.assertNotNull("El handler debería haber registrado la respuesta tras finalizar la llamada al servicio",
				response);
		Assert.assertSame("La respuesta debría contener el request con el que hemos invocado al servicio", request,
				response.getRequest());

	}

}

package es.pfsgroup.plugin.messagebroker.integrationtest.webservice;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import es.pfsgroup.plugin.messagebroker.MessageBroker;
import es.pfsgroup.plugin.messagebroker.integration.MessageBrokerGateway;
import es.pfsgroup.plugin.messagebroker.integrationtest.webservice.stubs.AsyncCallMonitor;
import es.pfsgroup.plugin.messagebroker.integrationtest.webservice.stubs.HandlerFakeMessageHandler;
import es.pfsgroup.plugin.messagebroker.integrationtest.webservice.stubs.WebServiceCallAndResponseHandler;
import es.pfsgroup.plugin.messagebroker.integrationtest.webservice.stubs.WebServiceOnlyCallHandler;
import junit.framework.Assert;

@RunWith(MockitoJUnitRunner.class)
public class WebServiceMessageBrokerTests {

	private MessageBroker messageBroker;
	private AsyncCallMonitor asnyncMonitor;

	private ApplicationContext ctx;

	@Before
	public void setUp() {
		/*
		 * Inicializamos el contexto de Spring
		 */
		String[] configLocations = new String[] { "optionalConfiguration/ac-recovery-message-broker.xml",
				"/webservices/spring-webservices-test-config.xml" };
		ctx = new ClassPathXmlApplicationContext(configLocations);

		/*
		 * Obtenemos el bean messageBroker para invocar y el stub para validar
		 * el test.
		 */
		messageBroker = (MessageBroker) ctx.getBean("messageBroker");

		// Ese monitor nos ayudará a saber si la llamada se ejecuta de forma
		// asíncrona.
		asnyncMonitor = (AsyncCallMonitor) ctx.getBean("asyncCallMonitor");
	}

	/**
	 * Comprobamos el caso más complejo, La llamada que realizamos al WS
	 * devuelve un resultado que queremos procesar.
	 */
	@Test
	public void testLlamadaYRespuesta() {
		RequestDto request = new RequestDto();

		WebServiceCallAndResponseHandler handler = (WebServiceCallAndResponseHandler) ctx
				.getBean("webServiceCallAndResponseHandler");

		// Validamos que el stub no esté inicializado
		Assert.assertNull("El handler no puede estar inicializado al empezar el test", handler.getResponse());

		synchronized (asnyncMonitor) {

			// Llamada al servicio
			String typeOfMessage = "webServiceCallAndResponse";
			callMessageBroker(request, typeOfMessage);
			// Marcamos el monitor como que el message broker ha finalizado
			asnyncMonitor.setMessageBrokerFinished(true);

			try {
				// Como las operaciones son asíncronas, usamos el monitor para saber cuando ha terminado todo
				asnyncMonitor.wait(5000);
			} catch (InterruptedException e) {
			}

		}

		ResponseDto response = handler.getResponse();

		/*
		 * Validamos que se hayan hecho todas las llamadas
		 */
		Assert.assertNotNull("El handler debería haber registrado la respuesta tras finalizar la llamada al servicio",
				response);
		Assert.assertSame("La respuesta debría contener el request con el que hemos invocado al servicio", request,
				response.getRequest());
		// La confirmación de que la llamda es asíncrona se hace durante el
		// request-sel mensaje (lo hace el stub)
		Assert.assertTrue("Se debería haber confirmado que la llamda se ha realizado de forma asíncrona",
				asnyncMonitor.isAsyncCallConfirmed());
	}

	/**
	 * Testeamos el caso en el que, o bien la llamada al WS no devuelve ningún
	 * resultado, o bien el resultado no nos interesa procesarlo a parte.
	 */
	@Test
	public void testLlamadaYSinRespuesta() {

		RequestDto request = new RequestDto();

		WebServiceOnlyCallHandler handler = (WebServiceOnlyCallHandler) ctx.getBean("webServiceOnlyCallHandler");
		Assert.assertNull("El handler no puede estar inicializado al empezar el test", handler.getRequest());

		synchronized (asnyncMonitor) {
		// Llamada al servicio
		String typeOfMessage = "webServiceOnlyCall";
		callMessageBroker(request, typeOfMessage);
		
		
		try {
			// Como las operaciones son asíncronas, usamos el monitor para saber cuando ha terminado todo
			asnyncMonitor.wait(5000);
		} catch (InterruptedException e) {
		}
		
		}

		Assert.assertNotNull("El handler debería haber almacenado la petición al hacer la llamada",
				handler.getRequest());

	}

	/**
	 * Probamos el método de ayuda que permite evitar el uso de un String para
	 * el typeOfMessage y usar la Class que nos hará luego de Handler.
	 */
	@Test
	public void testLlamadaClaseComoTypeOfMessage() {
		MessageBrokerGateway gateway = Mockito.mock(MessageBrokerGateway.class);

		messageBroker = new MessageBroker();
		messageBroker.setMessageBrokerGateway(gateway);

		messageBroker.sendAsync(HandlerFakeMessageHandler.class, new RequestDto());

		Mockito.verify(gateway).sendAsyncMessage(Mockito.eq("handlerFakeMessage"), Mockito.any(RequestDto.class));
	}

	/**
	 * Realizamos la llamada al message broker indicando el tipo de mensaje que
	 * enviamos. El sistema de mensajería debe encontrar el tipo de handler
	 * adecuado (el stub) e invocar los métodos adecuados
	 */
	private void callMessageBroker(Object request, String typeOfMessage) {

		messageBroker.sendAsync(typeOfMessage, request);
	}

}

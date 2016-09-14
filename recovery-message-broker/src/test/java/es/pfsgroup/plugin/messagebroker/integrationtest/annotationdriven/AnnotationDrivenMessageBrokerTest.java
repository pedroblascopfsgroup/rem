package es.pfsgroup.plugin.messagebroker.integrationtest.annotationdriven;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import es.pfsgroup.plugin.messagebroker.MessageBroker;
import es.pfsgroup.plugin.messagebroker.integrationtest.RequestDto;
import es.pfsgroup.plugin.messagebroker.integrationtest.ResponseDto;
import es.pfsgroup.plugin.messagebroker.integrationtest.annotationdriven.stubs.AnnotatedHandlerMock;
import es.pfsgroup.plugin.messagebroker.integrationtest.annotationdriven.stubs.AnnotationDrivenStub;
import es.pfsgroup.plugin.messagebroker.integrationtest.annotationdriven.stubs.TestErrorsStub;
import es.pfsgroup.plugin.messagebroker.integrationtest.common.AsyncCallMonitor;
import junit.framework.Assert;

@RunWith(MockitoJUnitRunner.class)
public class AnnotationDrivenMessageBrokerTest {

	private MessageBroker messageBroker;
	private AsyncCallMonitor asnyncMonitor;
	private ApplicationContext ctx;

	@Before
	public void setUp() {
		/*
		 * Inicializamos el contexto de Spring
		 */
		if (ctx == null) {
			String[] configLocations = new String[] { "optionalConfiguration/ac-recovery-message-broker.xml",
					"/annotations/spring-annotation-test-config.xml" };
			ctx = new ClassPathXmlApplicationContext(configLocations);
		}

		/*
		 * Obtenemos el bean messageBroker para invocar y el stub para validar
		 * el test.
		 */
		messageBroker = (MessageBroker) ctx.getBean("messageBroker");

		// Ese monitor nos ayudará a saber si la llamada se ejecuta de forma
		// asíncrona.
		asnyncMonitor = (AsyncCallMonitor) ctx.getBean("asyncCallMonitor");
	}

	@After
	public void tearDown() {
		AnnotationDrivenStub handler = (AnnotationDrivenStub) ctx.getBean("annotationDrivenStub");
		handler.cleanStub();
	}

	@Test
	public void testLlamadaAsincronaConAnotaciones() {
		RequestDto request = new RequestDto();

		AnnotationDrivenStub handler = (AnnotationDrivenStub) ctx.getBean("annotationDrivenStub");

		Assert.assertNull("El handler no puede estar inicializado al empezar el test", handler.getResponse());

		synchronized (asnyncMonitor) {
			messageBroker.sendAsync("annotationTest", request);
			asnyncMonitor.setMessageBrokerFinished(true);

			try {
				// Como las operaciones son asíncronas, usamos el monitor para
				// saber cuando ha terminado todo
				asnyncMonitor.wait(5000);
			} catch (InterruptedException e) {
			}

			ResponseDto response = handler.getResponse();
			Assert.assertNotNull(
					"El handler debería haber registrado la respuesta tras finalizar la llamada al servicio", response);
			Assert.assertSame("La respuesta debría contener el request con el que hemos invocado al servicio", request,
					response.getRequest());
			// La confirmación de que la llamda es asíncrona se hace durante el
			// request-sel mensaje (lo hace el stub)
			Assert.assertTrue("Se debería haber confirmado que la llamda se ha realizado de forma asíncrona",
					asnyncMonitor.isAsyncCallConfirmed());
		}

	}

	@Test
	public void testLlamadaAsincronaConAnotacionesSoloRequest() {
		RequestDto request = new RequestDto();

		AnnotationDrivenStub handler = (AnnotationDrivenStub) ctx.getBean("annotationDrivenStub");

		Assert.assertNull("El handler no puede estar inicializado al empezar el test", handler.getResponse());

		synchronized (asnyncMonitor) {
			messageBroker.sendAsync("annotationTestOnlyRequest", request);
			asnyncMonitor.setMessageBrokerFinished(true);

			try {
				// Como las operaciones son asíncronas, usamos el monitor para
				// saber cuando ha terminado todo
				asnyncMonitor.wait(5000);
			} catch (InterruptedException e) {
			}

			Assert.assertNotNull("El handler debería haber almacenado la petición al hacer la llamada", handler.getRequest());
			Assert.assertTrue("Se debería haber confirmado que la llamda se ha realizado de forma asíncrona", asnyncMonitor.isAsyncCallConfirmed());
		}

	}

	@Test
	public void testClaseComoTypeOfMessage() {
		RequestDto request = new RequestDto();

		AnnotatedHandlerMock handler = (AnnotatedHandlerMock) ctx.getBean("annotatedHandlerMock");

		synchronized (asnyncMonitor) {
			messageBroker.sendAsync(AnnotatedHandlerMock.class, request);
			asnyncMonitor.setMessageBrokerFinished(true);

			try {
				// Como las operaciones son asíncronas, usamos el monitor para
				// saber cuando ha terminado todo
				asnyncMonitor.wait(5000);
			} catch (InterruptedException e) {
			}

			Assert.assertTrue("Verificamos que el mock se haya ejecutado", handler.isExecuted());
		}

	}

	@Test
	public void testReintentos() {
		RequestDto request = new RequestDto();
		TestErrorsStub handler = (TestErrorsStub) ctx.getBean("testErrorStub");

		messageBroker.sendAsync(TestErrorsStub.class, request);

		try {
			Thread.sleep(2000);
		} catch (InterruptedException e) {

		}

		Assert.assertEquals(6, handler.getNumRetries());
	}

}

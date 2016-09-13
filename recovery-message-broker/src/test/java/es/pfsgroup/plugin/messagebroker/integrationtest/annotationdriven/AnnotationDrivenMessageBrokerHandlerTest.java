package es.pfsgroup.plugin.messagebroker.integrationtest.annotationdriven;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import es.pfsgroup.plugin.messagebroker.integration.MessageBrokerHandlerRegistry;

@RunWith(MockitoJUnitRunner.class)
public class AnnotationDrivenMessageBrokerHandlerTest {

	@Test
	public void testDuplicateDeclarationHandler() throws InterruptedException {
		String[] configLocations = new String[] { "optionalConfiguration/ac-recovery-message-broker.xml", "/webservices/spring-context-test-duplicateHandlers-config.xml" };
		AbstractApplicationContext ctx = new ClassPathXmlApplicationContext(configLocations);

		MessageBrokerHandlerRegistry mbh = (MessageBrokerHandlerRegistry) ctx.getBean("handlerRegistry");

		// JODO: tipico que das un curso sobre testing, hablas de la importacia de hacer pruebas deterministas y semanas mas tarde, acabas haciendo esto por tu inuptitud con los threads....
		Thread.sleep(500); // Se espera a que se rellene la variable a comprobar

		// Se comprueba que efectivamente se han detectado varios handles para el mismo mensaje.
		Assert.assertFalse(mbh.getDuplicateHandlers().isEmpty());
	}
}

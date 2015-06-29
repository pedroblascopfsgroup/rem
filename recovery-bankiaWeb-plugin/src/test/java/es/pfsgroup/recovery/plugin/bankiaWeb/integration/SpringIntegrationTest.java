package es.pfsgroup.recovery.plugin.bankiaWeb.integration;

import org.junit.Before;
import org.junit.Test;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.core.MessageChannel;
import org.springframework.integration.message.GenericMessage;

import es.capgemini.pfs.integration.SyncFramework;

public class SpringIntegrationTest {

	SyncFramework framework;
	MessageChannel channel;
	
	@Before
	public void prepare() {
	
		AbstractApplicationContext context = new ClassPathXmlApplicationContext("/ac-integration.xml", SpringIntegrationTest.class);
		channel = (DirectChannel)context.getBean("recoveryRequest", DirectChannel.class);
	}
	
	@Test
	public void testSend() {
		Pojo p = new Pojo("valoressss");
		GenericMessage<Pojo> m = new GenericMessage<Pojo>(p);
		//channel.send(m);
	}
}

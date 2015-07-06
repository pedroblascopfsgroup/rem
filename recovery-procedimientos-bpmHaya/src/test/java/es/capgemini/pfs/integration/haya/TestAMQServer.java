package es.capgemini.pfs.integration.haya;

import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class TestAMQServer {
	
	@Test
	public void testServer() {
		ApplicationContext ac = new ClassPathXmlApplicationContext("/ac.xml", TestAMQServer.class);
	}
}

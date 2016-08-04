import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import es.pfsgroup.test.gateways.IGateway;
import es.pfsgroup.test.gateways.MensajeDto;

public class MensajeriaTest {

	@Test
	public void miTest() {
		try {
			ApplicationContext ctx = new ClassPathXmlApplicationContext("ac-mensajeria.xml");

			IGateway gateway = (IGateway) ctx.getBean("testGW");

			MensajeDto mensaje = new MensajeDto();
			// Tenemos que hacer un transformer
			// mensaje.setText("aaaa");

			gateway.testString("afalfjalfj", "prueba", "Prueba", "prueba");

			System.out.println("hola");
			
			
			Thread.sleep(3000);
			
		} catch (Throwable e) {
			e.printStackTrace();
		}

	}

}

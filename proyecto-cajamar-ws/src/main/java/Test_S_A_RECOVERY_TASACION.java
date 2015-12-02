import org.cajamar.PruebaWSCajamar;
import org.cajamar.ws.S_A_RECOVERY_TASACION.INPUT;
import org.cajamar.ws.S_A_RECOVERY_TASACION.OUTPUT;
import org.cajamar.ws.S_A_RECOVERY_TASACION.ObjectFactory;
import org.cajamar.ws.S_A_RECOVERY_TASACION.SARECOVERYTASACION;
import org.cajamar.ws.S_A_RECOVERY_TASACION.SARECOVERYTASACIONType;


public class Test_S_A_RECOVERY_TASACION extends PruebaWSCajamar {
	private static final String WS_NAME = "S_A_RECOVERY_TASACION";

	public static void main(String args[]) {

		configuraCertificados(args);

		try {
			String connectionUrl = "https://multidesa.larural.es:515/RECOVERY/services/"
					+ WS_NAME;
			testConnection(connectionUrl);
			
			// Testing Web Service...
			ObjectFactory objectFactory = new ObjectFactory();
			INPUT input = objectFactory.createINPUT();

			String fileName = WS_NAME + ".input";
			populateObject(input, fileName);
			
			SARECOVERYTASACION service = new SARECOVERYTASACION();
			SARECOVERYTASACIONType servicePort = service.getSARECOVERYTASACIONPort();
			OUTPUT output = servicePort.sARECOVERYTASACION(input);
			
			
			showResult(input, output);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}

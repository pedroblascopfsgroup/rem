package es.pfsgroup.recovery.tasacion;

import java.net.MalformedURLException;
import java.net.URL;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.cajamar.ws.S_C_RECOVERY_CUENTA_DAT_AV.INPUT;
import org.cajamar.ws.S_C_RECOVERY_CUENTA_DAT_AV.OUTPUT;
import org.cajamar.ws.S_C_RECOVERY_CUENTA_DAT_AV.ObjectFactory;
import org.cajamar.ws.S_C_RECOVERY_CUENTA_DAT_AV.SCRECOVERYCUENTADATAV;
import org.cajamar.ws.S_C_RECOVERY_CUENTA_DAT_AV.SCRECOVERYCUENTADATAVType;

import javax.xml.namespace.QName;

import es.pfsgroup.recovery.cajamar.serviciosonline.ConsultaDeSaldosWSApi;

public class ConsultaDeSaldosWS extends BaseWS implements ConsultaDeSaldosWSApi {

	private static final String WEB_SERVICE_NAME = "S_A_RECOVERY_TASACION";

	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public String getWSName() {
		return WEB_SERVICE_NAME;
	}

	
	private void ejecutaServicio(INPUT input) throws MalformedURLException {
		
		String urlWSDL = getWSURL();
		String targetNamespace = getWSNamespace();
		String name = getWSName();
		
		logger.info("LLamando al WS Consulta de saldo...");
		logger.info(String.format("LLamada [%s] [%s] [%s]", targetNamespace, name, urlWSDL));
		if(urlWSDL == null || targetNamespace == null || name == null) {
			logger.error("Error en la ejecución del WS de Alta Tasación: no se han configurado correctamente las propiedades para la llamada al WS");
			return;
		}

		URL wsdlLocation = new URL(urlWSDL);
		QName qName = new QName(targetNamespace, name);
		
		SCRECOVERYCUENTADATAV service = new SCRECOVERYCUENTADATAV(wsdlLocation, qName);
		SCRECOVERYCUENTADATAVType servicePort = service.getSCRECOVERYCUENTADATAVPort();
		OUTPUT output = servicePort.sCRECOVERYCUENTADATAV(input);
		logger.info("WS Consulta de saldo invocado! Valores de respuesta:");
		
		logger.info(String.format("CODERROR: %s", output.getCODERROR()));
		logger.info(String.format("TXTERROR: %s", output.getTXTERROR()));
		logger.info(String.format("CLASEAPP: %s", output.getCLASEPP()));
		logger.info(String.format("EXCEDIDO: %s", output.getEXCEDIDO()));
		logger.info(String.format("FECHAIMPAGO: %s", output.getFECHAIMPAGO()));
		logger.info(String.format("NUMCUENTA: %s", output.getNUMCUENTA()));
		logger.info(String.format("OFICINA: %s", output.getOFICINA()));
		logger.info(String.format("RIESGOGLOBAL: %s", output.getRIESGOGLOBAL()));
		logger.info(String.format("SALDOACT: %s", output.getSALDOACT()));
		logger.info(String.format("SALDOGASTOS: %s", output.getSALDOGASTOS()));
		logger.info(String.format("SALDORETENIDO: %s", output.getSALDORETENIDO()));
		
		if(output.getESTADO().equals("1")) {
			logger.error(String.format("Error en la ejecución del WS de Consulta de Saldos: [%s] - [%s]", output.getCODERROR(), output.getTXTERROR()));
		}
		else {
			// Prepara la respuesta
		}
		
	}

	@Override
	public void consultaDeSaldo(String numContrato) {
		logger.info("Inicio del método Consulta De Saldos en CAJAMAR...");
		
		try {
			ObjectFactory objectFactory = new ObjectFactory();
			INPUT input = objectFactory.createINPUT();
			
			logger.info(String.format("NUMCUENTA: %", numContrato));
			input.setNUMCUENTA(numContrato);
			
			ejecutaServicio(input);			
		} catch(Exception e) {
			logger.error("Error en el método altaSolicitud", e);
		}
		
		logger.info("Fin del método Consulta de Saldo!!");
		
		return;
	}

}
package es.pfsgroup.recovery.cajamar.ws.consultasaldo;

import java.net.MalformedURLException;
import java.net.URL;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.cajamar.ws.S_C_RECOVERY_CUENTA_DAT_CE.INPUT;
import org.cajamar.ws.S_C_RECOVERY_CUENTA_DAT_CE.OUTPUT;
import org.cajamar.ws.S_C_RECOVERY_CUENTA_DAT_CE.ObjectFactory;
import org.cajamar.ws.S_C_RECOVERY_CUENTA_DAT_CE.SCRECOVERYCUENTADATCE;
import org.cajamar.ws.S_C_RECOVERY_CUENTA_DAT_CE.SCRECOVERYCUENTADATCEType;
import org.springframework.stereotype.Component;

import javax.xml.namespace.QName;

import es.pfsgroup.recovery.cajamar.serviciosonline.ResultadoConsultaSaldo;
import es.pfsgroup.recovery.cajamar.ws.BaseWS;
import es.pfsgroup.recovery.cajamar.ws.WSConsultaSaldos;

@Component(value="wsCSCuentaCE")
public class WSCSComercioExterior extends BaseWS implements WSConsultaSaldos {

	private static final String WEB_SERVICE_NAME = "S_C_RECOVERY_CUENTA_DAT_CE";

	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public String getWSName() {
		return WEB_SERVICE_NAME;
	}

	private ResultadoConsultaSaldo ejecutaServicio(INPUT input) throws MalformedURLException {

		String urlWSDL = getWSURL();
		String targetNamespace = getWSNamespace();
		String name = getWSName();

		ResultadoConsultaSaldo resultado = new ResultadoConsultaSaldo();

		logger.info("LLamando al WS...");
		logger.info(String.format("LLamada [%s] [%s] [%s]", targetNamespace, name, urlWSDL));
		if(urlWSDL == null || targetNamespace == null || name == null) {
			logger.error("Error en la ejecución del WS: no se han configurado correctamente las propiedades");
			resultado.setError(true);
			return resultado;
		}

		URL wsdlLocation = new URL(urlWSDL);
		QName qName = new QName(targetNamespace, name);

		SCRECOVERYCUENTADATCE service = new SCRECOVERYCUENTADATCE(wsdlLocation, qName);
		SCRECOVERYCUENTADATCEType servicePort = service.getSCRECOVERYCUENTADATCEPort();
		OUTPUT output = servicePort.sCRECOVERYCUENTADATCE(input);
		logger.info("WS invocado! Valores de respuesta:");

		logger.info(String.format("ESTADO: %s", output.getESTADO()));
		resultado.setEstado(output.getESTADO());
		logger.info(String.format("CODERROR: %s", output.getCODERROR()));
		resultado.setCodigoError(output.getCODERROR());
		logger.info(String.format("TXTERROR: %s", output.getTXTERROR()));
		resultado.setMensajeError(output.getTXTERROR());
		logger.info(String.format("CLASEAPP: %s", output.getCLASEPP()));
		resultado.setClaseApp(output.getCLASEPP());
		logger.info(String.format("NUMCUENTA: %s", output.getNUMCUENTA()));
		resultado.setNumCuenta(output.getNUMCUENTA());
		logger.info(String.format("OFICINA: %s", output.getOFICINA()));
		resultado.setOficina(output.getOFICINA());
		logger.info(String.format("SALDOACT: %s", output.getSALDOACT()));
		resultado.setSaldoAct(output.getSALDOACT());
		logger.info(String.format("SALDOGASTOS: %s", output.getSALDOGASTOS()));
		resultado.setSaldoGastos(output.getSALDOGASTOS());
		logger.info(String.format("CAPITALNOVENCIDO: %s", output.getCAPITALNOVENCIDO()));
		resultado.setCapitalNoVencido(output.getCAPITALNOVENCIDO());
		logger.info(String.format("CAPITALVENCIDO: %s", output.getCAPITALVENCIDO()));
		resultado.setCapitalVencido(output.getCAPITALVENCIDO());
		logger.info(String.format("DEMORAS: %s", output.getDEMORAS()));
		resultado.setDemoras(output.getDEMORAS());
		logger.info(String.format("INTERESES: %s", output.getINTERESES()));
		resultado.setIntereses(output.getINTERESES());
		logger.info(String.format("RIESGOGLOBAL: %s", output.getRIESGOGLOBAL()));
		resultado.setRiesgoGlobal(output.getRIESGOGLOBAL());
		
		if(resultado.getEstado().equals(BaseWS.ESTADO_ERROR)) {
			String logMsg = String.format("Error en la ejecución del WS: [%s] - [%s]", output.getCODERROR(), output.getTXTERROR());
			resultado.setError(true);
			logger.error(logMsg);
		}

		return resultado;
	}

	@Override
	public ResultadoConsultaSaldo consultar(String numContrato) {
		logger.info("Llamada WS en CAJAMAR...");
		ResultadoConsultaSaldo resultado = new ResultadoConsultaSaldo();
		try {
			ObjectFactory objectFactory = new ObjectFactory();
			INPUT input = objectFactory.createINPUT();
			
			logger.info(String.format("NUMCUENTA: %s", numContrato));
			input.setNUMCUENTA(numContrato);
			
			resultado = ejecutaServicio(input);			
		} catch(Exception e) {
			logger.error("Error en el método al invocarServicio", e);
		}
		
		logger.info("Fin llamada WS!!");
		
		return resultado;
	}

}
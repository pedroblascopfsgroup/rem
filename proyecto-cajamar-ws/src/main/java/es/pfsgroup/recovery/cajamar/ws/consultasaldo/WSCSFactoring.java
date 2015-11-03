package es.pfsgroup.recovery.cajamar.ws.consultasaldo;

import java.net.MalformedURLException;
import java.net.URL;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.cajamar.ws.S_C_RECOVERY_DAT_FT.INPUT;
import org.cajamar.ws.S_C_RECOVERY_DAT_FT.OUTPUT;
import org.cajamar.ws.S_C_RECOVERY_DAT_FT.ObjectFactory;
import org.cajamar.ws.S_C_RECOVERY_DAT_FT.SCRECOVERYDATFT;
import org.cajamar.ws.S_C_RECOVERY_DAT_FT.SCRECOVERYDATFTType;
import org.springframework.stereotype.Component;

import javax.xml.namespace.QName;

import es.pfsgroup.recovery.cajamar.serviciosonline.ResultadoConsultaSaldo;
import es.pfsgroup.recovery.cajamar.ws.BaseWS;
import es.pfsgroup.recovery.cajamar.ws.WSConsultaSaldos;

@Component(value="wsCSCuentaFT")
public class WSCSFactoring extends BaseWS implements WSConsultaSaldos {

	private static final String WEB_SERVICE_NAME = "S_C_RECOVERY_DAT_FT";

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

		SCRECOVERYDATFT service = new SCRECOVERYDATFT(wsdlLocation, qName);
		SCRECOVERYDATFTType servicePort = service.getSCRECOVERYDATFTPort();
		OUTPUT output = servicePort.sCRECOVERYDATFT(input);
		logger.info("WS invocado! Valores de respuesta:");

		logger.info(String.format("ESTADO: %s", output.getESTADO()));
		resultado.setEstado(output.getESTADO());
		logger.info(String.format("CODERROR: %s", output.getCODERROR()));
		resultado.setCodigoError(output.getCODERROR());
		logger.info(String.format("TXTERROR: %s", output.getTXTERROR()));
		resultado.setMensajeError(output.getTXTERROR());
		logger.info(String.format("CLASEAPP: %s", output.getCLASEPP()));
		resultado.setClaseApp(output.getCLASEPP());
		logger.info(String.format("FECHAIMPAGO: %s", output.getFECHAIMPAGO()));
		resultado.setFechaImpago(output.getFECHAIMPAGO());
		logger.info(String.format("NUMCUENTA: %s", output.getNUMCUENTA()));
		resultado.setNumCuenta(output.getNUMCUENTA());
		logger.info(String.format("OFICINA: %s", output.getOFICINA()));
		resultado.setOficina(output.getOFICINA());
		logger.info(String.format("RIESGOGLOBAL: %s", output.getRIESGOGLOBAL()));
		resultado.setRiesgoGlobal(output.getRIESGOGLOBAL());
		logger.info(String.format("SALDOACT: %s", output.getSALDOACT()));
		resultado.setSaldoAct(output.getSALDOACT());
		logger.info(String.format("SALDOGASTOS: %s", output.getSALDOGASTOS()));
		resultado.setSaldoGastos(output.getSALDOGASTOS());
		logger.info(String.format("DEMORARECIBOS: %s", output.getDEMORARECIBOS()));
		resultado.setDemoraRecibos(output.getDEMORARECIBOS());
		logger.info(String.format("EXCEDIDO: %s", output.getEXCEDIDO()));
		resultado.setExcedido(output.getEXCEDIDO());
		logger.info(String.format("SALDORETENIDO: %s", output.getSALDORETENIDO()));
		resultado.setSaldoRetenido(output.getSALDORETENIDO());
		logger.info(String.format("DISPONIBLE: %s", output.getDISPONIBLE()));
		resultado.setDisponible(output.getDISPONIBLE());
		logger.info(String.format("INTERESRECIBOS: %s", output.getINTERESRECIBOS()));
		resultado.setInteresesRecibos(output.getINTERESRECIBOS());
		logger.info(String.format("MOVIMIENTOS3M: %s", output.getMOVIMIENTOS3M()));
		resultado.setMovimientos3M(output.getMOVIMIENTOS3M());
		logger.info(String.format("SALDOMED12M: %s", output.getSALDOMED12M()));
		resultado.setSaldoMedio12M(output.getSALDOMED12M());
		logger.info(String.format("SALDOMED3M: %s", output.getSALDOMED3M()));
		resultado.setSaldoMedio3M(output.getSALDOMED3M());
		logger.info(String.format("COMISIONDEVOLUCION: %s", output.getCOMISIONDEVOLUCION()));
		resultado.setComisionDevolucion(output.getCOMISIONDEVOLUCION());
		logger.info(String.format("DISPUESTO: %s", output.getDISPUESTO()));
		resultado.setDispuesto(output.getDISPUESTO());
		logger.info(String.format("FECHAMORA: %s", output.getFECHAMORA()));
		resultado.setFechaMora(output.getFECHAMORA());
		logger.info(String.format("FINANCIADO: %s", output.getFINANCIADO()));
		resultado.setFinanciado(output.getFINANCIADO());
		logger.info(String.format("IMPORTELIMITE: %s", output.getIMPORTELIMITE()));
		resultado.setImporteLimite(output.getIMPORTELIMITE());
		logger.info(String.format("IVA: %s", output.getIVA()));
		resultado.setIva(output.getIVA());
		
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
package es.pfsgroup.plugin.gestorDocumental.manager;

import java.net.MalformedURLException;
import java.net.URL;

import javax.xml.namespace.QName;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.gestorDocumental.api.BaseWS;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalMaestroActivosApi;
import es.pfsgroup.plugin.gestorDocumental.assembler.GestorDocumentalInputAssembler;
import es.pfsgroup.plugin.gestorDocumental.assembler.GestorDocumentalOutputAssembler;
import es.pfsgroup.plugin.gestorDocumental.dto.InputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.OutputDto;
import es.pfsgroup.plugin.gestorDocumental.ws.wsWS.ProcessEventRequestType;
import es.pfsgroup.plugin.gestorDocumental.ws.wsWS.ProcessEventResponseType;
import es.pfsgroup.plugin.gestorDocumental.ws.wsWS.WsPort;
import es.pfsgroup.plugin.gestorDocumental.ws.wsWS.WsWS;

@Component
public class GestorDocumentalMaestroActivosManager extends BaseWS implements GestorDocumentalMaestroActivosApi {

	private static final String WEB_SERVICE_NAME = "wsWS";

	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public String getWSName() {
		return WEB_SERVICE_NAME;
	}

	@Override
	public OutputDto ejecutar(InputDto inputDto) {
		OutputDto out = null;
		
		try {
		
			String urlWSDL = getWSURL();
			String targetNamespace = getWSNamespace();
			String name = getWSName();
			
			URL wsdlLocation = new URL(urlWSDL);
			
			QName qName = new QName(targetNamespace, name);
			
			ProcessEventRequestType input = GestorDocumentalInputAssembler.dtoToInput(inputDto); 
			logger.info("LLamando al WS...MAESTRO DE ACTIVOS");
	
			logger.info("Parametros de entrada...");
//			logger.info("ID_ACTIVO_ORIGEN: " + input.getIdActivoOrigen());
//			logger.info("ID_ORIGEN: " +input.getIdOrigen());
//			logger.info("ID_ACTIVO_HAYA: " + input.getIdActivoHaya());
			
			WsWS service = new WsWS(wsdlLocation, qName);
			
			WsPort servicePort = service.getWs();
			ProcessEventResponseType output = servicePort.processEvent(input);
			logger.info("WS invocado! Valores de respuesta del MAESTRO DE ACTIVOS: ");
			
//			logger.info("RESULTADO_COD_MAESTRO_ACTVO: " + output.getResultCode());
//			logger.info("RESULTADO_DESCRIPCION_MAESTRO_ACTVO: " + output.getResultDescription());

			out = GestorDocumentalOutputAssembler.outputToDto(output);

		} catch (MalformedURLException e) {
			logger.error("Error en el método al invocarServicio", e);
		}
		
		return out;
	}

}
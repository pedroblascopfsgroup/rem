package es.pfsgroup.plugin.gestorDocumental.manager;

import java.net.MalformedURLException;
import java.net.URL;

import javax.xml.namespace.QName;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.gestorDocumental.api.BaseWS;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalMaestroApi;
import es.pfsgroup.plugin.gestorDocumental.assembler.GDPersonaInputAssembler;
import es.pfsgroup.plugin.gestorDocumental.assembler.GDPersonaOutputAssembler;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoOutputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaOutputDto;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_PERSONAS.ProcessEventRequestType;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_PERSONAS.ProcessEventResponseType;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_PERSONAS.WsPort;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_PERSONAS.WsWS;

@Component
public class GestorDocumentalMaestroPersonaManager extends BaseWS implements GestorDocumentalMaestroApi {

	private static final String WEB_SERVICE_ACTIVOS = "MAESTRO_ACTIVOS";
	private static final String WEB_SERVICE_PERSONAS = "MAESTRO_PERSONAS";
	private static final String WEB_SERVICE_NAME = "wsWS";

	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public String getWSName() {
		return WEB_SERVICE_NAME;
	}

	@Override
	public ActivoOutputDto ejecutarActivo(ActivoInputDto dto) {
		return null;
	}

	@Override
	public PersonaOutputDto ejecutarPersona(PersonaInputDto dto) {
		ProcessEventRequestType input = GDPersonaInputAssembler.dtoToInputPersona(dto);
		logger.info("LLamando al WS MAESTRO_PERSONAS...Parametros de entrada...");
		ProcessEventResponseType output = null;
		try {	
			String urlWSDL = getWSURL(WEB_SERVICE_PERSONAS);
			String targetNamespace = getWSNamespace();
			String name = getWSName();
			
			URL wsdlLocation = new URL(urlWSDL);
			QName qName = new QName(targetNamespace, name);
			
			WsWS service = new es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_PERSONAS.WsWS(wsdlLocation, qName);
			WsPort servicePort = service.getWs();
			output = servicePort.processEvent(input);
			
			logger.info("WS invocado! Valores de respuesta del MAESTRO: ");
			logger.info("RESULTADO_COD_MAESTRO: " + output.getResultCode());
			logger.info("RESULTADO_DESCRIPCION_MAESTRO: " + output.getResultDescription());
//		logger.info("ID_ACTIVO_ORIGEN: " + dto.getIdActivoOrigen());
//		logger.info("ID_ORIGEN: " + dto.getIdOrigen());
//		logger.info("ID_ACTIVO_HAYA: " + dto.getIdActivoHaya());
		} catch (MalformedURLException e) {
			logger.error("Error en el método al invocarServicio", e);
		}
		return GDPersonaOutputAssembler.outputToDtoPersona(output);
	}

}
package es.pfsgroup.plugin.gestorDocumental.manager;

import java.net.MalformedURLException;
import java.net.URL;

import javax.xml.namespace.QName;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.gestorDocumental.api.BaseWS;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalMaestroApi;
import es.pfsgroup.plugin.gestorDocumental.assembler.GDActivoInputAssembler;
import es.pfsgroup.plugin.gestorDocumental.assembler.GDActivoOutputAssembler;
import es.pfsgroup.plugin.gestorDocumental.assembler.GDPersonaInputAssembler;
import es.pfsgroup.plugin.gestorDocumental.assembler.GDPersonaOutputAssembler;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoOutputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaOutputDto;

@Component
public class GestorDocumentalMaestroManager extends BaseWS implements GestorDocumentalMaestroApi {

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
		es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.ProcessEventResponseType output = null;
		es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.ProcessEventRequestType input = GDActivoInputAssembler.dtoToInputActivo(dto);
		logger.info("LLamando al WS MAESTRO_ACTIVOS...Parametros de entrada...");
		logger.info("ID_ACTIVO_ORIGEN: " + dto.getIdActivoOrigen());
		logger.info("ID_ORIGEN: " + dto.getIdOrigen());
		logger.info("ID_ACTIVO_HAYA: " + dto.getIdActivoHaya());
		try {	
			String urlWSDL = getWSURL(WEB_SERVICE_ACTIVOS);
			String targetNamespace = getWSNamespace();
			String name = getWSName();
			
			URL wsdlLocation = new URL(urlWSDL);
			QName qName = new QName(targetNamespace, name);
			es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.WsWS service = new es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.WsWS(wsdlLocation, qName);
			es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.WsPort servicePort = service.getWs();
			output = servicePort.processEvent(input);
			logger.info("WS invocado! Valores de respuesta del MAESTRO: ");
			logger.info("RESULTADO_COD_MAESTRO: " + output.getResultCode());
			logger.info("RESULTADO_DESCRIPCION_MAESTRO: " + output.getResultDescription());
		} catch (MalformedURLException e) {
			logger.error("Error en el método al invocarServicio", e);
		}
		return GDActivoOutputAssembler.outputToDtoActivo(output);
	}

	@Override
	public PersonaOutputDto ejecutarPersona(PersonaInputDto dto) {
		es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_PERSONAS.ProcessEventRequestType input = GDPersonaInputAssembler.dtoToInputPersona(dto);
		logger.info("LLamando al WS MAESTRO_PERSONAS...Parametros de entrada... " + dto.getEvent() + ", " + dto.getIdOrigen() + ", " + dto.getIdIntervinienteOrigen());
		es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_PERSONAS.ProcessEventResponseType output = null;
		try {	
			String urlWSDL = getWSURL(WEB_SERVICE_PERSONAS);
			String targetNamespace = getWSNamespace();
			String name = getWSName();
			//si es nulo no avanzar para no estropear los codigos en local
			if(!Checks.esNulo(urlWSDL)) {
				URL wsdlLocation = new URL(urlWSDL);
				QName qName = new QName(targetNamespace, name);
				
				es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_PERSONAS.WsWS service = new es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_PERSONAS.WsWS(wsdlLocation, qName);
				es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_PERSONAS.WsPort servicePort = service.getWs();
				output = servicePort.processEvent(input);
				
				logger.info("WS invocado! Valores de respuesta del MAESTRO: ");					
				if (!Checks.esNulo(output) 
						&& !Checks.esNulo(output.getParameters()) 
						&& !Checks.estaVacio(output.getParameters().getParameter()) 
						&& !Checks.esNulo(output.getParameters().getParameter().get(0)) 
						&& !Checks.esNulo(output.getParameters().getParameter().get(0).getCode())
						&& output.getParameters().getParameter().get(0).getCode().equals("ERROR")) {
					logger.info("RESULTADO_COD_MAESTRO: Servicio inactivo");
				} else {
					logger.info("RESULTADO_COD_MAESTRO: " + output.getResultCode());
					logger.info("RESULTADO_DESCRIPCION_MAESTRO: " + output.getResultDescription());
				}
				
				
			}else {
				return null;
			}
		} catch (MalformedURLException e) {
			logger.error("Error en el método al invocarServicio", e);
		}
		return GDPersonaOutputAssembler.outputToDtoPersona(output);
		}
		

}
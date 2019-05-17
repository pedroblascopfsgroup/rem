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
import es.pfsgroup.plugin.gestorDocumental.assembler.GDActivoOutputAssembler;
import es.pfsgroup.plugin.gestorDocumental.assembler.GDInputAssembler;
import es.pfsgroup.plugin.gestorDocumental.assembler.GDPersonaOutputAssembler;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoOutputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.GDInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaOutputDto;

@Component
public class GestorDocumentalMaestroManager extends BaseWS implements GestorDocumentalMaestroApi {

	private static final String WEB_SERVICE_UNIDADES = "MAESTRO_UNIDADES";
	private static final String WEB_SERVICE_NAME = "wsWS";
	private static final String SIMULACRO = "simulacion";
	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public String getWSName() {
		return WEB_SERVICE_NAME;
	}
	
	@Override
	public <T extends GDInputDto> Object ejecutar(T dto) {
		
		es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_UNIDADES.ProcessEventRequestType input = null;
		es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_UNIDADES.ProcessEventResponseType output = null;
		
		if (dto instanceof PersonaInputDto || dto instanceof ActivoInputDto) {
			 input = GDInputAssembler.dtoToInput(dto);
		}else {
			logger.error("[ERROR]--[GestorDocumentalMaestroManager] Instancia de entrada desconocida");
		}
		try {
			logger.info("Linea urlWSDL");
			String urlWSDL = getWSURL(WEB_SERVICE_UNIDADES);
			logger.info("Linea targetNamespace");
			String targetNamespace = getWSNamespace();
			logger.info("Linea name");
			String name = getWSName();
			//si es nulo no avanzar para no estropear los codigos en local
			if(!Checks.esNulo(urlWSDL)) {
				URL wsdlLocation = new URL(urlWSDL);
				QName qName = new QName(targetNamespace, name);
				logger.info(".MAESTRO_UNIDADES.WsWS");
				es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_UNIDADES.WsWS service = new es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_UNIDADES.WsWS(wsdlLocation, qName);
				logger.info(".MAESTRO_UNIDADES.WsPort");
				es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_UNIDADES.WsPort servicePort = service.getWs();
				logger.info("servicePort");
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
					logger.error("RESULTADO_COD_MAESTRO: " + output.getResultCode());
					logger.error("RESULTADO_DESCRIPCION_MAESTRO: " + output.getResultDescription());
				}
				
				if (dto instanceof PersonaInputDto)
					return GDPersonaOutputAssembler.outputToDtoPersona(output);
				
				else if (dto instanceof ActivoInputDto)
					
					return GDActivoOutputAssembler.outputToDtoActivo(output);
			}else {
				
				logger.info("Se generan valores de prueba");
				//Valores para entornos previos
				if (dto instanceof PersonaInputDto) {
					PersonaOutputDto outputSimulacion = new PersonaOutputDto();
					outputSimulacion.setResultDescription(SIMULACRO);
					return outputSimulacion;
				}else if (dto instanceof ActivoInputDto) {
					
					ActivoOutputDto outputSimulacion = new ActivoOutputDto();
					outputSimulacion.setResultDescription(SIMULACRO);
					return outputSimulacion;
				}else {
					logger.error("[ERROR]--[GestorDocumentalMaestroManager] Instancia de salida desconocida");
				}
			}
		}catch (MalformedURLException e) {
			logger.error("Error en el método al invocarServicio", e);
		}
	
		return output;
	}
}
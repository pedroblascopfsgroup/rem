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
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.INPUT;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.MAESTROACTIVOS;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.MAESTROACTIVOSType;
import es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_ACTIVOS.OUTPUT;

@Component
public class GestorDocumentalMaestroActivosManager extends BaseWS implements GestorDocumentalMaestroActivosApi {

	private static final String WEB_SERVICE_NAME = "MAESTROACTIVOS";

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
			
			INPUT input = GestorDocumentalInputAssembler.dtoToInput(inputDto); 
			logger.info("LLamando al WS...MAESTRO DE ACTIVOS");
	
			logger.info("Parametros de entrada..."+input.getIdActivoOrigen()+"...");
			logger.info(String.format("APLICACION_"+input.getIdOrigen()+": %s"));
			logger.info(String.format("CLAVEASOCIACION_"+input.getIdActivoHaya()+": %s"));
				
			MAESTROACTIVOS service = new MAESTROACTIVOS(wsdlLocation, qName);
			
			MAESTROACTIVOSType servicePort = service.getSMGESTIONDOCUMENTALPort();
			OUTPUT output = servicePort.mAESTROACTIVOS(input);
			logger.info("WS invocado! Valores de respuesta del MAESTRO DE ACTIVOS: ");
			
			logger.info(String.format("ESTADO_MAESTRO_ACTVO: %s", output.getResultCode()));
			logger.info(String.format("DESC_ESTADO_MAESTRO_ACTVO: %s", output.getResultDescription()));

			out = GestorDocumentalOutputAssembler.outputToDto(output);

		} catch (MalformedURLException e) {
			logger.error("Error en el método al invocarServicio", e);
		}
		
		return out;
	}

}
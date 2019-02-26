package es.pfsgroup.plugin.rem.rest.salesforce.api.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletContext;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.model.DtoAltaVisita;
import es.pfsgroup.plugin.rem.model.DtoLeadVisita;
import es.pfsgroup.plugin.rem.model.SalesforceRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.ResponseGestorDocumentalFotos;
import es.pfsgroup.plugin.rem.rest.dto.SalesforceAuthDto;
import es.pfsgroup.plugin.rem.rest.dto.SalesforceResponseDto;
import es.pfsgroup.plugin.rem.rest.salesforce.api.SalesforceApi;
import es.pfsgroup.plugin.rem.restclient.exception.AccesDeniedException;
import es.pfsgroup.plugin.rem.restclient.exception.FileErrorException;
import es.pfsgroup.plugin.rem.restclient.exception.InvalidJsonException;
import es.pfsgroup.plugin.rem.restclient.exception.MissingRequiredFieldsException;
import es.pfsgroup.plugin.rem.restclient.exception.RestClientException;
import es.pfsgroup.plugin.rem.restclient.exception.RestConfigurationException;
import es.pfsgroup.plugin.rem.restclient.exception.UnknownIdException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.salesforce.SalesforceRESTDevonProperties;
import es.pfsgroup.plugin.rem.restclient.salesforce.clients.ClienteSalesforceGenerico;
import es.pfsgroup.plugin.rem.restclient.salesforce.clients.SalesforceEndpoint;


/**
 * Este cliente de Saleforce sirve para invocar a todos los endpoints. El endpoint
 * al que queremos invocar se pasa como parámetro al método de invocación.
 * 
 * @author Isidro Sotoca
 *
 */
@Component
public class SalesforceManager implements SalesforceApi {
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private ServletContext servletContext;
	
	@Autowired
	private ClienteSalesforceGenerico cliente;
	
	private static String ID_AUTH_TOKEN = "idAuthToken";
	
	private static String ERROR_DESCONOCIDO = "Error desconocido en SalesForceManager";
	private static String ERROR_ENVIAR_VISITA = "No se puede enviar la visita porque no se ha podido obtener el token de acceso.";
	
	ObjectMapper mapper = new ObjectMapper();
	
	@Override
	public SalesforceAuthDto getAuthtoken() throws Exception {
		
		SalesforceEndpoint salesforceEndpoint = SalesforceEndpoint.getTokenEndPoint(appProperties);
		salesforceEndpoint.validateTokenEndpointCall();
		
		String jsonResponse = null;
		SalesforceAuthDto response = null;
		if (servletContext.getAttribute(ID_AUTH_TOKEN) != null) {

			jsonResponse = cliente.send(null, salesforceEndpoint, null).toString();
			response = mapper.readValue(jsonResponse, SalesforceAuthDto.class);
			if (response.getError() != null && !response.getError().isEmpty()) {
				servletContext.setAttribute(ID_AUTH_TOKEN, null);
				throw new UnknownError(ERROR_DESCONOCIDO);
			}

		} else {
			
			jsonResponse = cliente.send(null, salesforceEndpoint, null).toString();
			response = mapper.readValue(jsonResponse, SalesforceAuthDto.class);
			if (response.getError() != null && !response.getError().isEmpty()) {
				servletContext.setAttribute(ID_AUTH_TOKEN, null);
				throw new UnknownError(ERROR_DESCONOCIDO);
			}
			servletContext.setAttribute(ID_AUTH_TOKEN, response);

		}
		
		return response;
		
	}
	
	@Override
	public SalesforceResponseDto altaVisita(SalesforceAuthDto dto, DtoAltaVisita dtoAltaVisita) throws Exception {
		
		SalesforceEndpoint salesforceEndpoint = SalesforceEndpoint.getEndPoint(appProperties, SalesforceRESTDevonProperties.ALTA_VISITAS);
		salesforceEndpoint.setBaseUrl(dto.getInstance_url());
		salesforceEndpoint.validateEndpointCall();
		
		String jsonResponse = null;
		SalesforceResponseDto response = null;
		if (servletContext.getAttribute(ID_AUTH_TOKEN) != null) {
			
			DtoLeadVisita dtoLeadVisita = new DtoLeadVisita(dtoAltaVisita);
			
			SalesforceRequestDto<DtoLeadVisita> sfRequest = new SalesforceRequestDto<DtoLeadVisita>();
			
			List<DtoLeadVisita> dataList = new ArrayList<DtoLeadVisita>();
			dataList.add(dtoLeadVisita);
			
			sfRequest.setRecords(dataList);
			
			jsonResponse = cliente.send(dto.getFullToken(), salesforceEndpoint, sfRequest.toBodyString()).toString();

			response = mapper.readValue(jsonResponse, SalesforceResponseDto.class);

			if (response.getHasErrors() != null && response.getHasErrors()) {
				servletContext.setAttribute(ID_AUTH_TOKEN, null);
				throw new UnknownError(ERROR_DESCONOCIDO);
			}

		}
		else {
			throw new RestConfigurationException(ERROR_ENVIAR_VISITA);
		}
		
		/*System.out.println("hasErrors : " + response.getHasErrors());
		
		for (int i = 0; i < response.getResults().size(); i++) {
			
			System.out.println("Imprimiento results index (empieza en 0) : " + i);
			
			System.out.println("Reference id : " + response.getResults().get(i).getReferenceId());
			System.out.println("Id : " + response.getResults().get(i).getId());
			
		}*/
		
		return response;
		
	}
	
}

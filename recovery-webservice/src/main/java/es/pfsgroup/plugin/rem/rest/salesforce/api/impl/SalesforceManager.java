package es.pfsgroup.plugin.rem.rest.salesforce.api.impl;

import java.io.ByteArrayOutputStream;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.SOAPMessage;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.w3c.dom.Document;

import es.pfsgroup.plugin.rem.model.DtoAltaVisita;
import es.pfsgroup.plugin.rem.model.DtoLeadVisita;
import es.pfsgroup.plugin.rem.rest.dto.ResponseGestorDocumentalFotos;
import es.pfsgroup.plugin.rem.rest.dto.SalesforceAuthDto;
import es.pfsgroup.plugin.rem.rest.dto.SalesforceResponseDto;
import es.pfsgroup.plugin.rem.rest.salesforce.api.SalesforceApi;
import es.pfsgroup.plugin.rem.restclient.exception.AccesDeniedException;
import es.pfsgroup.plugin.rem.restclient.exception.FileErrorException;
import es.pfsgroup.plugin.rem.restclient.exception.InvalidJsonException;
import es.pfsgroup.plugin.rem.restclient.exception.MissingRequiredFieldsException;
import es.pfsgroup.plugin.rem.restclient.exception.RestClientException;
import es.pfsgroup.plugin.rem.restclient.exception.UnknownIdException;
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
//	private static String UPLOAD_ENDPOINT = "upload/";
//	private static String DELETE_ENDPOINT = "delete/";
//	private static String FILE_SEARCH_ENDPOINT = "get/";
	
	ObjectMapper mapper = new ObjectMapper();
	
	@Override
	public SalesforceAuthDto getAuthtoken() throws Exception {
		
		SalesforceEndpoint salesforceEndpoint = SalesforceEndpoint.getTokenEndPoint(appProperties);
		salesforceEndpoint.validateCallTokenEndpoint();
		
		String jsonResponse = null;
		SalesforceAuthDto response = null;
		if (servletContext.getAttribute(ID_AUTH_TOKEN) != null) {

			jsonResponse = cliente.send(null, salesforceEndpoint, null).toString();
			response = mapper.readValue(jsonResponse, SalesforceAuthDto.class);
			if (response.getError() != null && !response.getError().isEmpty()) {
				servletContext.setAttribute(ID_AUTH_TOKEN, null);
				throwException(response.getError());
			}

		} else {
			
			jsonResponse = cliente.send(null, salesforceEndpoint, null).toString();
			response = mapper.readValue(jsonResponse, SalesforceAuthDto.class);
			if (response.getError() != null && !response.getError().isEmpty()) {
				servletContext.setAttribute(ID_AUTH_TOKEN, null);
				throwException(response.getError());
			}
			servletContext.setAttribute(ID_AUTH_TOKEN, response);

		}
		return response;
		
	}
	
	@Override
	public SalesforceResponseDto altaVisita(SalesforceAuthDto dto, DtoAltaVisita dtoAltaVisita) throws Exception {
		
		SalesforceEndpoint salesforceEndpoint = SalesforceEndpoint.getTokenEndPoint(appProperties);
		salesforceEndpoint.validateCallTokenEndpoint();
		salesforceEndpoint.setFullUrl(dto.getInstance_url()+"/services/data/v34.0/composite/tree/HAY_LOAD_VISITAS__c/");
		salesforceEndpoint.setCookie(dto.getAccess_token());
		
		String jsonResponse = null;
		SalesforceResponseDto response = null;
		if (servletContext.getAttribute(ID_AUTH_TOKEN) != null) {
			System.out.println("Constructor XXX");
			
							System.out.println("Creando document");
			Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
			
							System.out.println("Creando Marshaller");
			Marshaller marshaller = JAXBContext.newInstance(DtoLeadVisita.class).createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
			
							System.out.println("Generando contenido");
			marshaller.marshal(new DtoLeadVisita(dtoAltaVisita), document);
			
							System.out.println("Generando soapMessage");
			SOAPMessage soapMessage = MessageFactory.newInstance().createMessage();
			
							System.out.println("Adding soapMessage to document, C103");
			soapMessage.getSOAPBody().addDocument(document);
			
							System.out.println("Pasando el este a bytearray para algo que no entiendo que hace");
			ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
			
							System.out.println("Pasanto el bytearray al soap o algo raro");
			soapMessage.writeTo(outputStream);
			
							System.out.println("Pasando la cosa a un string para que se pueda leer");
			String body = new String(outputStream.toByteArray());
			
							System.out.println("El string es : " + body);
			
			jsonResponse = cliente.send(dto.getFullToken(), salesforceEndpoint, body).toString();
			System.out.println("OBJECT MAPPER TODO AQUI PETARA");
			response = mapper.readValue(jsonResponse, SalesforceResponseDto.class);
			System.out.println("OBJECT MAPPER after readValue call");
			if (response.getHasErrors() != null && !response.getHasErrors()) {
				servletContext.setAttribute(ID_AUTH_TOKEN, null);
				throwException("UNKOWN_ERROR");
			}

		}
		System.out.println("Constructor YYY");
		return response;
		
	}
	
	private void throwException(String error) throws RestClientException {
		
		if (error.equals(ResponseGestorDocumentalFotos.ACCESS_DENIED)) {
			throw new AccesDeniedException();
		} 
		else if (error.equals(ResponseGestorDocumentalFotos.FILE_ERROR)) {
			throw new FileErrorException();
		} 
		else if (error.equals(ResponseGestorDocumentalFotos.INVALID_JSON)) {
			throw new InvalidJsonException();
		} 
		else if (error.equals(ResponseGestorDocumentalFotos.MISSING_REQUIRED_FIELDS)) {
			throw new MissingRequiredFieldsException();
		} 
		else if (error.equals(ResponseGestorDocumentalFotos.UNKNOWN_ID)) {
			throw new UnknownIdException();
		} else if (error.equals("UNKOWN_ERROR")) {
			throw new UnknownError("Error desconocido en SalesForceManager");
		}
		
	}
	
	/**
	 * Método genérico para enviar una petición REST a Saleforce.
	 * 
	 * @param endpoint
	 *            Endpoint al que nos vamos a conectar.
	 * @param paramsList
	 *            Colección de Map de parámetros (campos) a enviar en la
	 *            petición.
	 * 
	 * @param registroLlamada
	 *            Objeto en el que se irán registrando los detalles sobre la
	 *            invocación al servicio.
	 * 
	 * @return
	 * @throws ErrorServicioWebcom
	 */
	/**@SuppressWarnings("unchecked")
	public Map<String, Object> send(WebcomEndpoint endpoint, ParamsList paramsList, RestLlamada registroLlamada)
			throws ErrorServicioWebcom {
		
		HttpClient httpClient = new HttpClient();
		
		if (httpClient == null) {
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el httpClient.");
		}

		if (endpoint == null) {
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el endpoint.");
		}

		if (paramsList == null) {
			throw new IllegalArgumentException("'paramsList' no puede ser NULL");
		}

		if (registroLlamada == null) {
			throw new IllegalArgumentException("'registroLlamada' no puede ser NULL");
		}

		logger.trace("Llamada a servicio " + endpoint.toString() + " con parámetros " + paramsList);
		JSONObject response = null;
		JSONObject requestBody = null;
		try {
			// Llamada al servicio
			requestBody = WebcomRequestUtils.createRequestJson(paramsList);
			String jsonString = requestBody.toString();
			logger.debug("[DETECCIÓN CAMBIOS] Request:");
			logger.debug(jsonString);
			registroLlamada.logTiempPrepararJson();
			registroLlamada.setToken(requestBody.getString(WebcomRequestUtils.JSON_PROPERTY_ID));
			registroLlamada.setRequest(jsonString);

			String apiKey = endpoint.getApiKey();
			String publicAddress = getPublicAddress();
			registroLlamada.setApiKey(apiKey);
			registroLlamada.setIp(publicAddress);

			String signature = WebcomSignatureUtils.computeSignatue(apiKey, publicAddress, jsonString);
			registroLlamada.setSignature(signature);
			logger.trace("Cálculo del signature [apiKey=" + apiKey + ", ip=" + publicAddress + "] => " + signature);

			Map<String, String> headers = new HashMap<String, String>();
			headers.put("signature", signature);
			String httpMethod = endpoint.getHttpMethod();
			registroLlamada.setMetodo(httpMethod);
			String endpointUrl = endpoint.getEndpointUrl();
			registroLlamada.setEndpoint(endpointUrl);

			debugJsonFile(jsonString);

//			response = httpClient.processRequest(endpointUrl, httpMethod, headers, jsonString, endpoint.getTimeout(),
//					endpoint.getCharset());
			registroLlamada.setResponse(response.toString());

			logger.debug("[DETECCIÓN CAMBIOS] Response:");
			if (response != null && !response.isEmpty()) {
				logger.debug(response.toString());
			}

			// Gestión de errores si respuesta OK
			if (response.containsKey("error")) {
				String error = response.getString("error");
				registroLlamada.setErrorDesc(error);
				if ((error != null) && (!"".equals(error)) && (!"null".equals(error))) {
					logger.error("Webcom ha respondido con un código de error: " + error);
					throw new ErrorServicioWebcom(error);
				}
			}
			return response;
//		} catch (HttpClientException e) {
//			logger.fatal("No se ha podido establecer la conexión por un error en Http Client", e);
//			registroLlamada.setErrorDesc("HTTP:" + e.getResponseCode());
//			throw new ErrorServicioWebcom(e);
		} catch (UnsupportedEncodingException e) {
			throw new HttpClientFacadeInternalError("No se ha podido calcular el signature", e);
		} catch (NoSuchAlgorithmException e) {
			throw new HttpClientFacadeInternalError("No se ha podido calcular el signature", e);
		} finally {
			try {
				JSONArray data = obtenerDataResponse(response);
				if (data != null) {
					trazarObjetosRechazados(registroLlamada, data, false);
				} else {
					data = obtenerDataResponse(requestBody);
					if (data != null) {
						trazarObjetosRechazados(registroLlamada, data, true);
					}
				}
			} catch (Exception e) {
				logger.error("Error trazando datos rechazados", e);
			}
			registroLlamada.logTiempoPeticionRest();

		}
		
	}*/
	
}

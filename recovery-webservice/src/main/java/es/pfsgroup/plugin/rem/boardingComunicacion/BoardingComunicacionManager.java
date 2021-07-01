package es.pfsgroup.plugin.rem.boardingComunicacion;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.api.BoardingComunicacionApi;
import es.pfsgroup.plugin.rem.logTrust.LogTrustWebService;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import net.sf.json.JSONObject;

@Service("boardingManager")
public class BoardingComunicacionManager extends BusinessOperationOverrider<BoardingComunicacionApi> implements BoardingComunicacionApi {

    private final Log logger = LogFactory.getLog(getClass());

    private static final String POST_METHOD = "POST";
	private static final String NULL_STRING = "null";
	private static final String ERROR_ACTUALIZACION_OFERTA_BOARDING = "Error en el servicio de actualización de ofertas de Boarding.";
	private static final String REST_CLIENT_ACTIVAR_BOARDING = "rest.client.activar.boarding";

    @Autowired
    private HttpClientFacade httpClientFacade;

    @Autowired
    private RestLlamadaDao llamadaDao;

    @Autowired
    private LogTrustWebService trustMe;

    @Resource
    private Properties appProperties;

    @Override
    public String managerName() {
        return null;
    }

    public String obtenerToken() {
    	
        Map<String, String> headers = new HashMap<String, String>();
        headers.put("Content-Type", "application/json");
        headers.put("Accept", "application/json");
        
        JSONObject jsonResp = new JSONObject();
        JSONObject jwtToken = null;
        
        String email = !Checks.esNulo(appProperties.getProperty("rest.client.autenticacion.email.boarding"))
                ? appProperties.getProperty("rest.client.autenticacion.email.boarding") : "";
        String password = !Checks.esNulo(appProperties.getProperty("rest.client.autenticacion.password.boarding"))
                ? appProperties.getProperty("rest.client.autenticacion.password.boarding") : "";
        String urlBase = !Checks.esNulo(appProperties.getProperty("rest.client.url.base.boarding"))
                ? appProperties.getProperty("rest.client.url.base.boarding") : "";
        String urlLogin = !Checks.esNulo(appProperties.getProperty("rest.client.autenticacion.boarding"))
                ? appProperties.getProperty("rest.client.autenticacion.boarding") : "";
        
        StringBuilder urlLoginBoarding = new StringBuilder();
        urlLoginBoarding.append(urlBase);
        urlLoginBoarding.append(urlLogin);
        urlLoginBoarding.append("?email=").append(email);
        urlLoginBoarding.append("&password=").append(password);

        try {
            jwtToken = procesarPeticion(this.httpClientFacade, urlLoginBoarding.toString(), POST_METHOD, headers, jsonResp.toString(), 30, "UTF-8");
        } catch(Exception e) {
            e.printStackTrace();
        }
        return jwtToken != null ? jwtToken.get("token").toString() : "";
    }

    private JSONObject procesarPeticion(HttpClientFacade httpClientFacade, String serviceUrl, String sendMethod, Map<String, String> headers, String jsonString, int responseTimeOut, String charSet) throws HttpClientException {
        return httpClientFacade.processRequest(serviceUrl, sendMethod, headers, jsonString, responseTimeOut, charSet);
    }

    @SuppressWarnings("unchecked")
	public String actualizarOfertaBoarding(Long numExpediente, Long numOferta, ModelMap model) {
    	
        String json = null;
        JSONObject llamada = null;

        try {
            String token = obtenerToken();

            Map<String, String> headers = new HashMap<String, String>();
            headers.put("Content-Type", "application/json");
            headers.put("Authorization", token);

            model.put("numExpediente", numExpediente);
            model.put("numOferta", numOferta);

            ObjectMapper mapper = new ObjectMapper();
            json = mapper.writeValueAsString(model);
            
			System.out.println("ResultingJSONstring = " + json);
			
			String urlBase = !Checks.esNulo(appProperties.getProperty("rest.client.url.base.boarding"))
			        ? appProperties.getProperty("rest.client.url.base.boarding") : "";
			String urlUpdateOferta = !Checks.esNulo(appProperties.getProperty("rest.client.actualizar.ofertas.boarding"))
			        ? appProperties.getProperty("rest.client.actualizar.ofertas.boarding") : "";
			
			StringBuilder urlUpdateOfertaBoarding = new StringBuilder();
			urlUpdateOfertaBoarding.append(urlBase);
			urlUpdateOfertaBoarding.append(urlUpdateOferta);

			llamada = procesarPeticion(this.httpClientFacade, urlUpdateOfertaBoarding.toString(), POST_METHOD, headers, json.toString(), 30, "UTF-8");
			
			String mensaje = null;
			
			if(llamada != null && llamada.getInt("resultado") == 1 && NULL_STRING.equals(llamada.getString("mensaje"))) {
				mensaje = ERROR_ACTUALIZACION_OFERTA_BOARDING;
			} else if(llamada != null && (llamada.getInt("resultado") == 1 || llamada.getInt("resultado") == 0) && !NULL_STRING.equals(llamada.getString("mensaje"))) {
				mensaje = llamada.getString("mensaje");
			}

			registrarLlamada(urlUpdateOfertaBoarding.toString(), json.toString(), llamada.toString(), mensaje);
			
			return mensaje;

        } catch(Exception e) {
            e.printStackTrace();
            return ERROR_ACTUALIZACION_OFERTA_BOARDING;
        }

    }

    private void registrarLlamada(String endPoint, String request, String result, String errorDesc) {
        RestLlamada registro = new RestLlamada();
        registro.setMetodo("WEBSERVICE");
        registro.setEndpoint(endPoint);
        registro.setRequest(request);
        logger.debug(request);
        logger.debug("-------------------");
        logger.debug(result);
        if (!Checks.esNulo(errorDesc) && !NULL_STRING.equals(errorDesc)) {
            registro.setErrorDesc(errorDesc);
        }
        try {
            registro.setResponse(result);
            llamadaDao.guardaRegistro(registro);
            trustMe.registrarLlamadaServicioWeb(registro);
        } catch (Exception e) {
            logger.error("Error al trazar la llamada al WS", e);
        }
    }
    
	@Override
	public boolean modoRestClientBoardingActivado() {
		Boolean activado = Boolean.valueOf(appProperties.getProperty(REST_CLIENT_ACTIVAR_BOARDING));
		if (activado == null) {
			activado = false;
		}
		
		return activado;
	}

}

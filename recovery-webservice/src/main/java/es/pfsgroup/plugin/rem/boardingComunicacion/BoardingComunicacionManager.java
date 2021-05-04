package es.pfsgroup.plugin.rem.boardingComunicacion;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.BoardingComunicacionApi;
import es.pfsgroup.plugin.rem.logTrust.LogTrustWebService;
import es.pfsgroup.plugin.rem.model.PenParam;
import es.pfsgroup.plugin.rem.rest.dto.ComunicacionBoardingResponse;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import net.sf.json.JSONObject;

@Service("boardingManager")
public class BoardingComunicacionManager extends BusinessOperationOverrider<BoardingComunicacionApi> implements BoardingComunicacionApi {

    private final Log logger = LogFactory.getLog(getClass());

    private int tokenRequestTimeElapsed = 0;
    private static final int RESULTADO_OK =0;
    private static final int RESULTADO_KO =1;
    private static final String POST_METHOD = "POST";
	private static final String NULL_STRING = "null";
	private static final String REST_CLIENT_ACTIVAR_BOARDING = "rest.client.activar.boarding";

    @Autowired
    private HttpClientFacade httpClientFacade;

    @Autowired
    private RestLlamadaDao llamadaDao;

    @Autowired
    private LogTrustWebService trustMe;

    @Resource
    private Properties appProperties;
    
	@Autowired
	private GenericABMDao genericDao;
    

    @Override
    public String managerName() {
        return null;
    }

    public String obtenerToken(int segundosTimeout) {
        
    	Map<String, String> headers = new HashMap<String, String>();
        headers.put("Content-Type", "application/json");
        headers.put("Accept", "application/json");
        
        // Asignamos la mitad del tiempo de lo que se le asigna a la peticion para conseguir el token
        int timeoutToken = Math.round(segundosTimeout / 2);
        
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

        long timeStart = System.currentTimeMillis();
        try {
            jwtToken = procesarPeticion(this.httpClientFacade, urlLoginBoarding.toString(), POST_METHOD, headers, jsonResp.toString(), timeoutToken, "UTF-8");
        } catch(Exception e) {
            e.printStackTrace();
        }
        long timeEnd = System.currentTimeMillis();
        //tiempo que se tarda en conseguir el token (APROX)
        tokenRequestTimeElapsed = Math.round(TimeUnit.MILLISECONDS.toSeconds(timeEnd - timeStart));
        return jwtToken != null ? jwtToken.get("token").toString() : "";
        
    }

    private JSONObject procesarPeticion(HttpClientFacade httpClientFacade, String serviceUrl, String sendMethod, Map<String, String> headers, String jsonString, int responseTimeOut, String charSet) throws HttpClientException {
        return httpClientFacade.processRequest(serviceUrl, sendMethod, headers, jsonString, responseTimeOut, charSet);
    }

    @SuppressWarnings("unchecked")
	public ComunicacionBoardingResponse actualizarOfertaBoarding(Long numExpediente, Long numOferta, ModelMap model,int segundosTimeout) {
    	
    		 
    		String token = obtenerToken(segundosTimeout);
    		//el tiempo de peticion es el que queda despues de conseguir el token (APROX), si el tiempo es igual o mayor se asigna 1 segundo 
    		// para realizar la llamada y resgistrar en la RST error por authenticacion
    		int timeOut = tokenRequestTimeElapsed >= segundosTimeout ? 1 : segundosTimeout - tokenRequestTimeElapsed;
            Map<String, String> headers = new HashMap<String, String>();
            headers.put("Content-Type", "application/json");
            headers.put("Authorization", token);

            model.put("numExpediente", numExpediente);
            model.put("numOferta", numOferta);

            ObjectMapper mapper = new ObjectMapper();
            String json;
			try {
				json = mapper.writeValueAsString(model);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				json = "{}";
			}
            
			System.out.println("ResultingJSONstring = " + json);
			
			String urlBase = !Checks.esNulo(appProperties.getProperty("rest.client.url.base.boarding"))
			        ? appProperties.getProperty("rest.client.url.base.boarding") : "";
			String urlUpdateOferta = !Checks.esNulo(appProperties.getProperty("rest.client.actualizar.ofertas.boarding"))
			        ? appProperties.getProperty("rest.client.actualizar.ofertas.boarding") : "";
			
			StringBuilder urlUpdateOfertaBoarding = new StringBuilder();
			urlUpdateOfertaBoarding.append(urlBase);
			urlUpdateOfertaBoarding.append(urlUpdateOferta);

			JSONObject respuesta = null;
			String ex = null;		
	    	String mensaje = null;
	    	boolean resultadoOK;
			
			try{			
				respuesta = procesarPeticion(this.httpClientFacade, urlUpdateOfertaBoarding.toString(), POST_METHOD, headers, json, timeOut, "UTF-8");	
				mensaje = !NULL_STRING.equals(respuesta.getString("mensaje")) ? respuesta.getString("mensaje") : null;
				int resultado =  respuesta.optInt("resultado",RESULTADO_KO);
				resultadoOK = resultado == RESULTADO_OK;
			}catch (HttpClientException e1) {
				e1.printStackTrace();
				ex = e1.getMessage();
				resultadoOK = false;
			}
					
			registrarLlamada(urlUpdateOfertaBoarding.toString(), json.toString(), respuesta != null ? respuesta.toString() : null, ex);
			return new ComunicacionBoardingResponse(resultadoOK,mensaje);

    }

    private void registrarLlamada(String endPoint, String request, String result,String exception) {
        RestLlamada registro = new RestLlamada();
        registro.setMetodo("WEBSERVICE");
        registro.setEndpoint(endPoint);
        registro.setRequest(request);
        logger.debug(request);
        logger.debug("-------------------");
        logger.debug(result);
        registro.setException(exception);    
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
	
	public boolean comunicacionBoardingActivada () {
		
		PenParam penParam = genericDao.get(PenParam.class,
				genericDao.createFilter(FilterType.EQUALS, "param", "comunicacionBoardingActivada"));
		
		if (penParam == null) {
			logger.debug("El parametro comunicacionBoardingActivada no se encuentra en la tabla PEN_PARAM");
			return true;
		}else {
			return (Boolean.valueOf(penParam.getValor()) && modoRestClientBoardingActivado());
		}
		
		
	
	}

}

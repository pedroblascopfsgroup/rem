package es.pfsgroup.plugin.rem.altaAsuntos;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.api.AltaAsuntosLegalReoApi;
import es.pfsgroup.plugin.rem.logTrust.LogTrustWebService;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import net.sf.json.JSONObject;

@Transactional(readOnly = false)
@Service("altaAsuntosLegalReoManager")
public class AltaAsuntosLegalReoManager extends BusinessOperationOverrider<AltaAsuntosLegalReoApi> implements AltaAsuntosLegalReoApi {

	private final Log logger = LogFactory.getLog(getClass());
	 
    private int tokenRequestTimeElapsed = 0;
	private static final String POST_METHOD = "POST";
	private static final String REM3_BASE_URL = "rem3.base.url";
	private static final String REM3_ALTA_ASUNTOS_LEGAL_REO = "rem3.alta.asuntos.legal.reo";
	 
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

    private JSONObject procesarPeticion(HttpClientFacade httpClientFacade, String serviceUrl, String sendMethod, Map<String, String> headers, String jsonString, int responseTimeOut, String charSet) throws HttpClientException {
        return httpClientFacade.processRequest(serviceUrl, sendMethod, headers, jsonString, responseTimeOut, charSet);
    }

    @Override
    @SuppressWarnings("unchecked")
	public JSONObject altaAsuntosLegalReo(List<Long> numActivosList, String userName, int segundosTimeout, ModelMap model) {
    	
    	int timeOut = tokenRequestTimeElapsed >= segundosTimeout ? 1 : segundosTimeout - tokenRequestTimeElapsed;

    	Map<String, String> headers = new HashMap<String, String>();
        headers.put("Content-Type", "application/json");
        headers.put("Accept", "application/json");

        model.put("numActivosList", numActivosList);
        model.put("userName", userName);

        ObjectMapper mapper = new ObjectMapper();
        String json;
        
		try {
			json = mapper.writeValueAsString(model);
		} catch (Exception e) {
			e.printStackTrace();
			json = "{}";
		}

		String urlBase = appProperties.getProperty(REM3_BASE_URL) != null ? appProperties.getProperty(REM3_BASE_URL) : "";
		String endpointAltaAsuntoLegalReo = appProperties.getProperty(REM3_ALTA_ASUNTOS_LEGAL_REO) != null ? appProperties.getProperty(REM3_ALTA_ASUNTOS_LEGAL_REO) : "";
		
		StringBuilder urlAltaAsuntoLegalReo = new StringBuilder();
		urlAltaAsuntoLegalReo.append(urlBase);
		urlAltaAsuntoLegalReo.append(endpointAltaAsuntoLegalReo);

		JSONObject respuesta = null;
		String hcex = null;
	    	
        logger.debug("[ALTA ASUNTOS LEGAL REO] BODY: "+json.toString());
		
		try{			
			respuesta = procesarPeticion(this.httpClientFacade, urlAltaAsuntoLegalReo.toString(), POST_METHOD, headers, json, timeOut, "UTF-8");	
		} catch (HttpClientException hce) {
			hce.printStackTrace();
			hcex = hce.getMessage();
		} catch (Exception e) {
			logger.error("Error al procesar petición para el Alta Asuntos de Legal Reo", e);
			logger.error(e.getMessage());
		}		
				
		registrarLlamada(urlAltaAsuntoLegalReo.toString(), json.toString(), respuesta != null ? respuesta.toString() : null, hcex);
		return respuesta;

    }

    private void registrarLlamada(String endPoint, String request, String result, String exception) {
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

}

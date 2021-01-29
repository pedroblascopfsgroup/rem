package es.pfsgroup.plugin.rem.boardingComunicacion;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonProcessingException;
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

    public String obtenerTokenREM() { //autenticacion copiada de adrian, aqui hay que cambiar
        Map<String, String> headers = new HashMap<String, String>();
        headers.put("Content-Type", "application/json");
        headers.put("Accept", "application/json");
        JSONObject jsonResp = new JSONObject();
        JSONObject jwtToken = null;
        String usuario = "sdiaz";
        String contrasenya = "1234";
        String schema = "HAYA06";
        String urlLogin = !Checks.esNulo(appProperties.getProperty("rest.client.autenticacion.recovery"))
                ? appProperties.getProperty("rest.client.autenticacion.recovery") : "";
        jsonResp.put("username", usuario);
        jsonResp.put("password", contrasenya);
        jsonResp.put("schema", schema);

        try {
            jwtToken = procesarPeticion(this.httpClientFacade, urlLogin, POST_METHOD, headers, jsonResp.toString(), 30, "UTF-8");
        } catch(Exception e) {
            e.printStackTrace();
        }
        return jwtToken != null ? jwtToken.get("jwt").toString() : "";
    }

    private JSONObject procesarPeticion(HttpClientFacade httpClientFacade, String serviceUrl, String sendMethod, Map<String, String> headers, String jsonString, int responseTimeOut, String charSet) throws HttpClientException {
        return httpClientFacade.processRequest(serviceUrl, sendMethod, headers, jsonString, responseTimeOut, charSet);
    }

    public void datosCliente(Long numExpediente, Long numOferta, ModelMap model) {

        String urlEnvio = null;
        String json = null;
        JSONObject llamada = null;

        try {
            String token = obtenerTokenREM();

            Map<String, String> headers = new HashMap<String, String>();
            headers.put("Content-Type", "application/json");
            headers.put("Authorization", "Bearer "+token);

            model.put("numeroOferta", numOferta);
            model.put("numExpediente", numExpediente);

            ObjectMapper mapper = new ObjectMapper();
            try {
                json = mapper.writeValueAsString(model);
                System.out.println("ResultingJSONstring = " + json);
                urlEnvio = !Checks.esNulo(appProperties.getProperty("rest.client.convivencia.recovery"))
                        ? appProperties.getProperty("rest.client.convivencia.recovery") : "";

                llamada = procesarPeticion(this.httpClientFacade, urlEnvio, POST_METHOD, headers, json, 30, "UTF-8");

                registrarLlamada(urlEnvio, json, llamada.getString("success"), llamada.getString("data"));

            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }

        } catch(Exception e) {
            e.printStackTrace();
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
        if (!Checks.esNulo(errorDesc)) {
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

}

package es.pfsgroup.plugin.rem.restclient.caixabc;


import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.http.client.HttpSimplePostRequest;
import es.pfsgroup.plugin.gestorDocumental.api.RestClientApi;
import es.pfsgroup.plugin.rem.controller.ExpedienteComercialController;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

@Service
public class CaixaBcRestClient {

    @Resource
    private Properties appProperties;

    @Autowired
    private ParticularValidatorApi particularValidatorApi;


    protected static final Log logger = LogFactory.getLog(ExpedienteComercialController.class);
    private static final String REM3_URL = "rem3.base.url";
    private static final String REPLICACION_CLIENTES_ENDPOINT = "rem3.endpoint.hydra.replicacion.clientes";
    private static final String REPLICACION_OFERTAS_ENDPOINT = "rem3.endpoint.hydra.replicacion.ofertas";
    public static final String CLIENTE_TITULARES_DATA ="01";
    public static final String COMPRADORES_DATA ="02";
    public static final String KEY_FASE_UPDATE = "UPDATE";
    public static final String ERROR_REPLICACION_BC = "Error en el servicio de replicacion de clientes de BC";
    public static final String IS_CLIENT_ACTIVE = "caixa.bc.restclient.active";
    public static final String ID_CLIENTE = "idCliente";
    public static final String ID_COMPRADOR = "idCompradorExpediente";
    public static final String ID_PROVEEDOR = "idProveedor";


    public Boolean callReplicateClient(Long numOferta,String dataSourceCode){
            Boolean resp = false;

            try {
                if (this.isActive() && particularValidatorApi.esOfertaCaixa(numOferta != null ? numOferta.toString() : null)){
                    String endpoint = getRem3Endpoint(REM3_URL,REPLICACION_CLIENTES_ENDPOINT);
                    if (endpoint != null) {
                        Map<String, Object> params = new HashMap<String, Object>();
                        params.put("numOferta", numOferta.toString());
                        params.put("dataSourceCode", dataSourceCode);
                        HttpSimplePostRequest request = new HttpSimplePostRequest(endpoint, params);
                        resp = request.post(Boolean.class);
                    } else {
                        return false;
                    }
                }else{
                    return true;
                }

            } catch (Exception e) {
                logger.error("Error en " + this.getClass().toString(), e);
            }

            return resp != null ? resp : true;

    }

    public Boolean callReplicateClientUpdate(Long id,String tipoID){
        Boolean resp = false;

        try {
            if (this.isActive()){
                String endpoint = getRem3Endpoint(REM3_URL,REPLICACION_CLIENTES_ENDPOINT);
                if (endpoint != null) {
                    Map<String, Object> params = new HashMap<String, Object>();
                    if (ID_CLIENTE.equals(tipoID))
                        params.put(ID_CLIENTE, id);
                    else if (ID_PROVEEDOR.equals(tipoID))
                        params.put(ID_PROVEEDOR, id);
                    params.put("dataSourceCode", KEY_FASE_UPDATE);
                    HttpSimplePostRequest request = new HttpSimplePostRequest(endpoint, params);
                    resp = request.post(Boolean.class);
                } else {
                    return false;
                }
            }else{
                return true;
            }

        } catch (Exception e) {
            logger.error("Error en " + this.getClass().toString(), e);
        }

        return resp != null ? resp : true;

    }

    public Boolean callReplicateClientUpdateComprador(Long id,Long numOferta){
        Boolean resp = false;

        try {
            if (this.isActive()){
                String endpoint = getRem3Endpoint(REM3_URL,REPLICACION_CLIENTES_ENDPOINT);
                if (endpoint != null) {
                    Map<String, Object> params = new HashMap<String, Object>();
                        params.put(ID_COMPRADOR, id);
                        params.put("numOferta", numOferta.toString());
                    params.put("dataSourceCode", KEY_FASE_UPDATE);
                    HttpSimplePostRequest request = new HttpSimplePostRequest(endpoint, params);
                    resp = request.post(Boolean.class);
                } else {
                    return false;
                }
            }else{
                return true;
            }

        } catch (Exception e) {
            logger.error("Error en " + this.getClass().toString(), e);
        }

        return resp != null ? resp : true;

    }

    
    public Boolean callReplicateOferta(Long numOferta){
        Boolean resp = false;

        try {
            if (this.isActive() && particularValidatorApi.esOfertaCaixa(numOferta != null ? numOferta.toString() : null)){
                String endpoint = getRem3Endpoint(REM3_URL,REPLICACION_OFERTAS_ENDPOINT);
                if (endpoint != null) {
                    Map<String, Object> params = new HashMap<String, Object>();
                    params.put("numeroOferta", numOferta.toString());
                    HttpSimplePostRequest request = new HttpSimplePostRequest(endpoint, params);
                    resp = request.post(Boolean.class);
                } else {
                    return false;
                }
            }else{
                return true;
            }

        } catch (Exception e) {
            logger.error("Error en " + this.getClass().toString(), e);
        }

        return resp;

}

    public Object callReplicateOffer(){
        return null;
    }


    public String getRem3Endpoint(String baseURL,String endpoint) {
        String url = appProperties.getProperty(baseURL);
        String service = appProperties.getProperty(endpoint);
        if ( url != null && service != null ) {
            return String.format("%s%s",url,service);
        } else {
            logger.info("No se encuentra el endpoint para envio de datos a BC/C4C");
            return  null;
        }
    }

    public boolean isActive() {
        Boolean activado = Boolean.valueOf(appProperties.getProperty(IS_CLIENT_ACTIVE));
        if (activado == null) {
            activado = false;
        }
        return activado;
    }


}

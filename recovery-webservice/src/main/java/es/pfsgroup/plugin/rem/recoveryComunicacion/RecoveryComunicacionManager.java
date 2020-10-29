package es.pfsgroup.plugin.rem.recoveryComunicacion;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.RecoveryComunicacionApi;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoHistoricoDao;
import es.pfsgroup.plugin.rem.logTrust.LogTrustWebService;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import net.sf.json.JSONObject;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonProcessingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import javax.annotation.Resource;
import java.sql.Timestamp;
import java.util.*;

@Service("recoveryManager")
public class RecoveryComunicacionManager extends BusinessOperationOverrider<RecoveryComunicacionApi> implements RecoveryComunicacionApi {

    private final Log logger = LogFactory.getLog(getClass());

    private static final String POST_METHOD = "POST";

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private HttpClientFacade httpClientFacade;

    @Autowired
    private RestLlamadaDao llamadaDao;

    @Autowired
    private LogTrustWebService trustMe;

	@Autowired
	private GestorActivoHistoricoDao gestorActivoDao;

    @Resource
    private Properties appProperties;

    @Override
    public String managerName() {
        return null;
    }

    public String obtenerTokenREM() {
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

    public void datosCliente(Activo activo, ModelMap model) {

        String urlEnvio = null;
        String json = null;
        JSONObject llamada = null;

        try {
            String token = obtenerTokenREM();

            Map<String, String> headers = new HashMap<String, String>();
            headers.put("Content-Type", "application/json");
            headers.put("Authorization", "Bearer "+token);

            ActivoTitulo actTitulo = genericDao.get(ActivoTitulo.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"activo.id", activo.getId()));
            ActivoAdjudicacionJudicial activoAdjudicacionJudicial = genericDao.get(ActivoAdjudicacionJudicial.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"activo.id", activo.getId()));
            ArrayList<Map<String, Object>> listaDefectos = new ArrayList<Map<String, Object>>();
            ArrayList<Map<String, Object>> listaCargas = new ArrayList<Map<String, Object>>();

            listaDefectos = this.calificacionesNegativasInfo(activo);
            listaCargas = this.cargasInfo(activo);

            model.put("numActivo", activo.getNumActivo());
            model.put("idAsuntoRecovery", activoAdjudicacionJudicial.getIdAsunto());
            model.put("codigoCartera", activo.getCartera().getCodigo());
            if(activo.getTitulo() != null){
                if(activo.getTitulo().getEstado() != null){
                    model.put("situacionTitulo", activo.getTitulo().getEstado().getCodigo());
                }else{
                    model.put("situacionTitulo", null);
                }
                if(actTitulo.getFechaEntregaGestoria() != null){
                    model.put("fechaRecepcionTitulo", actTitulo.getFechaEntregaGestoria().getTime());
                }else{
                    model.put("fechaRecepcionTitulo", null);
                }
                if(actTitulo.getFechaPresHacienda() != null){
                    model.put("fechaPresentacionHacienda", actTitulo.getFechaPresHacienda().getTime());
                }else{
                    model.put("fechaPresentacionHacienda", null);
                }
                if(actTitulo.getFechaPres1Registro() != null){
                    model.put("fechaPresentacionReg", actTitulo.getFechaPres1Registro().getTime());
                }else{
                    model.put("fechaPresentacionReg", null);
                }
                if(actTitulo.getFechaEnvioAuto() != null){
                    model.put("fechaAutoAdicion", actTitulo.getFechaEnvioAuto().getTime());
                }else{
                    model.put("fechaAutoAdicion", null);
                }
                if(actTitulo.getFechaInscripcionReg() != null){
                    model.put("fechaInscripcionReg", actTitulo.getFechaInscripcionReg().getTime());
                }else{
                    model.put("fechaInscripcionReg", null);
                }
                if(actTitulo.getFechaPres2Registro() != null){
                    model.put("fechaUltimaPresentacionReg", actTitulo.getFechaPres2Registro().getTime());
                }else{
                    model.put("fechaUltimaPresentacionReg", null);
                }
            }
            model.put("defectos", listaDefectos);
            model.put("cargas", listaCargas);
            
            Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", "GGADM");
    		EXTDDTipoGestor ddTipoGestor = genericDao.get(EXTDDTipoGestor.class, filtro );
            
            List<Usuario> list = gestorActivoDao.getListUsuariosGestoresActivoByTipoYActivo(ddTipoGestor.getId(), activo);
            
            if(list != null && !list.isEmpty()) {
    			if(list.get(0).getUsername() != null) {
    				model.put("gestoria", list.get(0).getUsername());
    			}
    		}

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

    private ArrayList<Map<String, Object>> calificacionesNegativasInfo(Activo activo) {

        List<ActivoCalificacionNegativa> calificacionesList = genericDao.getList(ActivoCalificacionNegativa.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"activo.id", activo.getId()));

        ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();

        Map<String, Object> map = null;

        for(ActivoCalificacionNegativa calificaciones : calificacionesList){

            map = new HashMap<String, Object>();

            map.put("idDefecto", calificaciones.getId());
            map.put("estado", calificaciones.getEstadoMotivoCalificacionNegativa().getCodigo());
            map.put("responsable", calificaciones.getResponsableSubsanar().getCodigo());
            if(calificaciones.getFechaSubsanacion() != null){
                map.put("fechaSubsanacion", calificaciones.getFechaSubsanacion().getTime());
            }else{
                map.put("fechaSubsanacion", null);
            }
            if(calificaciones.getHistoricoTramitacionTitulo() != null && calificaciones.getHistoricoTramitacionTitulo().getFechaPresentacionRegistro() != null){
                map.put("fechaPresentacionRegDef", calificaciones.getHistoricoTramitacionTitulo().getFechaPresentacionRegistro().getTime());
            }else{
                map.put("fechaPresentacionRegDef", null);
            }
            if(calificaciones.getHistoricoTramitacionTitulo() != null && calificaciones.getHistoricoTramitacionTitulo().getFechaCalificacion() != null){
                map.put("fechaCalificacionNeg", calificaciones.getHistoricoTramitacionTitulo().getFechaCalificacion().getTime());
            }else{
                map.put("fechaCalificacionNeg", null);
            }
            if(calificaciones.getMotivoCalificacionNegativa() != null) {
            	map.put("tipoDefecto", calificaciones.getMotivoCalificacionNegativa().getCodigo());
            }
            map.put("descripcion", calificaciones.getDescripcion());

            listaRespuesta.add(map);

        }

        return listaRespuesta;

    }

    private ArrayList<Map<String, Object>> cargasInfo(Activo activo) {

        List<ActivoCargas> cargasList = genericDao.getList(ActivoCargas.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"activo.id", activo.getId()));

        ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();

        Map<String, Object> map = null;

        for(ActivoCargas cargas : cargasList){

            map = new HashMap<String, Object>();

            map.put("idCarga", cargas.getId());
            map.put("origenDato", cargas.getOrigenDato().getCodigo());
            map.put("tipoCarga", cargas.getTipoCargaActivo().getCodigo());
            map.put("subtipoCarga", cargas.getSubtipoCarga().getCodigo());
            if(cargas.getEstadoCarga()  != null){
                map.put("estadoCarga", cargas.getEstadoCarga().getCodigo());
            }else{
                map.put("estadoCarga", null);
            }
            if(cargas.getSubestadoCarga() != null){
                map.put("subestadoCarga", cargas.getSubestadoCarga().getCodigo());
            }else{
                map.put("subestadoCarga", null);
            }
            map.put("titular", cargas.getCargaBien().getTitular());
            map.put("importeEconomico", cargas.getCargaBien().getImporteEconomico());
            map.put("importeRegistral", cargas.getCargaBien().getImporteRegistral());
            map.put("cargasPropias", cargas.getCargasPropias());

            listaRespuesta.add(map);

        }

        return listaRespuesta;

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

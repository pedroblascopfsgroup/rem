package es.pfsgroup.plugin.rem.alaskaComunicacion;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.AlaskaComunicacionApi;
import es.pfsgroup.plugin.rem.expedienteComercial.ExpedienteComercialManager;
import es.pfsgroup.plugin.rem.logTrust.LogTrustWebService;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.rest.dto.ResponseGestorDocumentalFotos;
import es.pfsgroup.plugin.rem.restclient.exception.*;
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
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import javax.annotation.Resource;
import java.util.*;

@Service("alassManager")
public class AlaskaComunicacionManager extends BusinessOperationOverrider<AlaskaComunicacionApi> implements AlaskaComunicacionApi{

    private final Log logger = LogFactory.getLog(getClass());

    private static final String POST_METHOD = "POST";

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialManager expedienteComercialManager;

    @Autowired
    private RestLlamadaDao llamadaDao;

    @Autowired
    private LogTrustWebService trustMe;

    @Autowired
    private HttpClientFacade httpClientFacade;

    ObjectMapper mapper = new ObjectMapper();

    @Resource
    private Properties appProperties;

    @Override
    public String managerName() {
        return null;
    }

    @Transactional(readOnly = false)
    public void datosCliente(Long idActivo, ModelMap model) {

        String urlEnvio = null;
        String json = null;
        JSONObject llamada = null;
        Filter activoIdFilter = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, activoIdFilter);
        ActivoTitulo actTitulo = genericDao.get(ActivoTitulo.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"activo.id", activo.getId()));
        ExpedienteComercial expediente = expedienteComercialManager.getExpedientePorActivo(activo);
        ActivoCatastro activoCatastro = genericDao.get(ActivoCatastro.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "activo.id", activo.getId()));
        ActivoMaestroActivos activoMaestroActivos = genericDao.get(ActivoMaestroActivos.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "activo.id", activo.getId()));
        ActivoBbvaActivos activoBbvaActivos = genericDao.get(ActivoBbvaActivos.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"activo.id", activo.getId()));

        ArrayList<Map<String, Object>> listaTasaciones = new ArrayList<Map<String, Object>>();
        ArrayList<Map<String, Object>> listaValoraciones = new ArrayList<Map<String, Object>>();
        ArrayList<Map<String, Object>> listaCargas = new ArrayList<Map<String, Object>>();

        try {

            Map<String, String> headers = new HashMap<String, String>();
            headers.put("Content-Type", "application/json");

            listaCargas = this.cargasInfo(activo);
            listaTasaciones = this.tasacionesInfo(activo);
            listaValoraciones = this.valoracionesInfo(activo);

            model.put("cartera", "");
            model.put("idMaestroActivo", activoMaestroActivos.getId());
            model.put("expediente", "");
            model.put("idHaya", activo.getNumActivo());
            if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR) || activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_LIBERBANK)){
                model.put("idOrigen", activo.getIdProp());
            }
            if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)){
                model.put("idOrigen", activo.getNumActivoUvem());
            }
            if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_SAREB)){
                model.put("idOrigen", activo.getIdSareb());
            }
            if((activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CERBERUS))
            && (activo.getSubcartera().getCodigo().equals(DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB) || activo.getSubcartera().getCodigo().equals(DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB))){
                model.put("idOrigen", activo.getNumActivoDivarian());
            }
            if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA)){
                model.put("idOrigen", activoBbvaActivos.getNumActivoBbva());
            }
            if(expediente != null){
                model.put("numExpediente", expediente.getNumExpediente());
            }else{
                model.put("numExpediente", null);
            }
            model.put("numActivo", activo.getNumActivo());
            model.put("carteraRem", activo.getCartera().getCodigo());
            model.put("subcarteraRem", activo.getSubcartera().getCodigo());
            if(activo.getSubtipoActivo() != null){
                model.put("subtipoActivo", activo.getSubtipoActivo().getCodigo());
            }else{
                model.put("subtipoActivo", null);
            }
            model.put("estadoBien", "1");
            model.put("referenciaCatastral", activoCatastro.getRefCatastral());
            if(activo.getBien() != null && activo.getBien().getDatosRegistralesActivo() != null){
                model.put("finca", activo.getBien().getDatosRegistralesActivo().getNumFinca());
            }else{
                model.put("finca", null);
            }
            if(activo.getInfoComercial() != null && activo.getInfoComercial().getLocalidadRegistro() != null){
                model.put("localidadRegistro", activo.getInfoComercial().getLocalidadRegistro().getCodigo());
            }else{
                model.put("localidadRegistro", null);
            }
            if(activo.getBien() != null && activo.getBien().getBienEntidad() != null){
                model.put("tomo", activo.getBien().getBienEntidad().getTomo());
                model.put("libro", activo.getBien().getBienEntidad().getLibro());
                model.put("folio", activo.getBien().getBienEntidad().getFolio());
            }else{
                model.put("tomo", null);
                model.put("libro", null);
                model.put("folio", null);
            }
            model.put("fechaInscripcionReg", actTitulo.getFechaInscripcionReg());
            if(activo.getInfoComercial() != null){
                model.put("longitud", activo.getInfoComercial().getLongitud());
                model.put("latitud", activo.getInfoComercial().getLatitud());
            }else{
                model.put("longitud", null);
                model.put("latitud", null);
            }
            if(activo.getInfoRegistral() != null){
                model.put("idufir", activo.getInfoRegistral().getIdufir());
                model.put("superficieUtil", activo.getInfoRegistral().getSuperficieUtil());
            }else{
                model.put("idufir", null);
                model.put("superficieUtil", null);
            }
            model.put("tasaciones", listaTasaciones);
            model.put("valoraciones", listaValoraciones);
            if(activo.getInfoComercial() != null && activo.getInfoComercial().getTipoVia() != null){
                model.put("tipoVia", activo.getInfoComercial().getTipoVia().getCodigo());
            }else{
                model.put("tipoVia", null);
            }
            model.put("nombreVia", activo.getNombreVia());
            model.put("numeroDomicilio", activo.getNumeroDomicilio());
            model.put("portal", activo.getPortal());
            if(activo.getLocalizacion().getLocalizacionBien() != null){
                model.put("bloque", activo.getLocalizacion().getLocalizacionBien().getBloque());
            }else{
                model.put("bloque", null);
            }
            model.put("escalera", activo.getEscalera());
            model.put("piso", activo.getPiso());
            model.put("puerta", activo.getPuerta());
            model.put("municipio", activo.getMunicipio());
            if(activo.getLocalidad() != null){
                model.put("localidad", activo.getLocalidad().getCodigo());
            }else{
                model.put("localidad", null);
            }
            model.put("provincia", activo.getProvincia());
            model.put("comentarioDireccion", "");
            model.put("pais", activo.getPais());
            model.put("codigoPostal", activo.getCodPostal());
            if(activo.getTipoActivo() != null){
                model.put("tipoBienCatalogo", activo.getTipoActivo().getCodigo());
            }else{
                model.put("tipoBienCatalogo", null);
            }
            if(activo.getTipoBien() != null){
                model.put("tipoBien", activo.getTipoBien().getCodigo());
            }else{
                model.put("tipoBien", null);
            }
            if(activo.getSubtipoActivo() != null){
                model.put("subtipoBien", activo.getSubtipoActivo().getCodigo());
            }else{
                model.put("subtipoBien", null);
            }
            if(activo.getSituacionPosesoria().getOcupado() == 1 && activo.getSituacionPosesoria().getConTitulo().getCodigo().equals("01")){
                model.put("estadoOcupacion", "02");
            }else if(activo.getSituacionPosesoria().getOcupado() == 1 && (activo.getSituacionPosesoria().getConTitulo().getCodigo().equals("02") || activo.getSituacionPosesoria().getConTitulo().getCodigo().equals("03"))){
                model.put("estadoOcupacion", "01");
            }else if(activo.getSituacionPosesoria().getOcupado() == 0){
                model.put("estadoOcupacion", "03");
            }else{
                model.put("estadoOcupacion", "");
            }
            if(activo.getTipoUsoDestino() != null){
                model.put("usoActivo", activo.getTipoUsoDestino().getCodigo());
            }else{
                model.put("usoActivo", null);
            }
            if(activo.getInfoComercial() != null){
                model.put("anyoConstruccion", activo.getInfoComercial().getAnyoConstruccion());
            }else{
                model.put("anyoConstruccion", null);
            }
            if(activo.getBien().getBienEntidad() != null){
                model.put("superficieBien", activo.getBien().getBienEntidad().getSuperficie());
                model.put("superficieConstruida", activo.getBien().getBienEntidad().getSuperficieConstruida());
                model.put("numRegistro", activo.getBien().getBienEntidad().getNumRegistro());
            }else{
                model.put("superficieBien", null);
                model.put("superficieConstruida", null);
                model.put("numRegistro", null);
            }
            model.put("cargas", listaCargas);
            model.put("anejoGaraje", "");
            model.put("anejoTrastero", "");
            model.put("anejoOtros", "");
            model.put("notas1", "");
            model.put("notas2", "");


            json = mapper.writeValueAsString(model);
            System.out.println("ResultingJSONstring = " + json);
            
  //          urlEnvio = !Checks.esNulo(appProperties.getProperty("rest.client.convivencia.alaska"))
  //                  ? appProperties.getProperty("rest.client.convivencia.alaska") : "";

            urlEnvio = "http://192.168.80.3:9090/convivenciaAlaska";
            	
            llamada = procesarPeticion(this.httpClientFacade, urlEnvio, POST_METHOD, headers, json, 30, "UTF-8");

            registrarLlamada(urlEnvio, json, llamada.getString("success"), llamada.getString("data"), null);

        } catch (Exception e) {
            logger.error("error en RecoveryController", e);
            model.put("error", true);
            model.put("errorDesc", e.getMessage());
        }

    }

    private JSONObject procesarPeticion(HttpClientFacade httpClientFacade, String serviceUrl, String sendMethod, Map<String, String> headers, String jsonString, int responseTimeOut, String charSet) throws HttpClientException {
        return httpClientFacade.processRequest(serviceUrl, sendMethod, headers, jsonString, responseTimeOut, charSet);
    }

    private ArrayList<Map<String, Object>> tasacionesInfo(Activo activo) {

        List<ActivoTasacion> tasacionesList = genericDao.getList(ActivoTasacion.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"activo.id", activo.getId()));

        ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();

        Map<String, Object> map = null;

        for(ActivoTasacion tasaciones : tasacionesList){

            map = new HashMap<String, Object>();

            map.put("nombreTasadora", tasaciones.getNomTasador());
            if(tasaciones.getTipoTasacion() != null){
                map.put("tipoTasacion", tasaciones.getTipoTasacion().getCodigo());
            }else{
                map.put("tipoTasacion", null);
            }
            map.put("importe", tasaciones.getImporteTasacionFin());
            map.put("fecha", tasaciones.getFechaInicioTasacion());

            listaRespuesta.add(map);

        }

        return listaRespuesta;

    }

    private ArrayList<Map<String, Object>> valoracionesInfo(Activo activo) {

        List<ActivoValoraciones> valoracionesList = genericDao.getList(ActivoValoraciones.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"activo.id", activo.getId()));

        ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();

        Map<String, Object> map = null;

        for(ActivoValoraciones valoraciones : valoracionesList){

            map = new HashMap<String, Object>();

            if(valoraciones.getGestor() != null){
                map.put("valorador", valoraciones.getGestor().getNombre());
            }else{
                map.put("valorador", null);
            }
            if(valoraciones.getTipoPrecio() != null){
                map.put("tipoValoracion", valoraciones.getTipoPrecio().getCodigo());
            }else{
                map.put("tipoValoracion", null);
            }
            map.put("importe", valoraciones.getImporte());
            map.put("fecha", valoraciones.getFechaAprobacion());
            map.put("liquidez", valoraciones.getLiquidez());

            listaRespuesta.add(map);

        }

        return listaRespuesta;

    }

    private ArrayList<Map<String, Object>> cargasInfo(Activo activo) {

        List<ActivoCargas> cargasList = genericDao.getList(ActivoCargas.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"activo.id", activo.getId()));

        ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();

        Map<String, Object> map = null;

        Integer rangoCargas = 1;

        for(ActivoCargas cargas : cargasList){

            map = new HashMap<String, Object>();

            map.put("rango", rangoCargas);
            if(cargas.getTipoCargaActivo() != null){
                map.put("tipoCarga", cargas.getTipoCargaActivo().getCodigo());
            }else{
                map.put("tipoCarga", null);
            }
            if(cargas.getCargaBien() != null){
                map.put("importe", cargas.getCargaBien().getImporteRegistral());
            }else{
                map.put("importe", null);
            }
            map.put("incluidaOtrosColaterales", 0);
            map.put("fechaVencimiento", cargas.getFechaCancelacionRegistral());

            listaRespuesta.add(map);

            rangoCargas++;
        }

        return listaRespuesta;

    }

    private void throwException(String error) throws RestClientException {
        if (error.equals(ResponseGestorDocumentalFotos.ACCESS_DENIED)) {
            throw new AccesDeniedException();
        } else if (error.equals(ResponseGestorDocumentalFotos.FILE_ERROR)) {
            throw new FileErrorException();
        } else if (error.equals(ResponseGestorDocumentalFotos.INVALID_JSON)) {
            throw new InvalidJsonException();
        } else if (error.equals(ResponseGestorDocumentalFotos.MISSING_REQUIRED_FIELDS)) {
            throw new MissingRequiredFieldsException();
        } else if (error.equals(ResponseGestorDocumentalFotos.UNKNOWN_ID)) {
            throw new UnknownIdException();
        }
    }

    private void registrarLlamada(String endPoint, String request, String result, String errorDesc, String llamadaException) {
        RestLlamada registro = new RestLlamada();
        registro.setMetodo("POST");
        registro.setEndpoint(endPoint);
        registro.setRequest(request);
        logger.debug(request);
        logger.debug("-------------------");
        logger.debug(result);
        registro.setErrorDesc(errorDesc);
    	registro.setException(llamadaException);
        try {
        	
        registro.setResponse(result);
		llamadaDao.guardaRegistro(registro);
		trustMe.registrarLlamadaServicioWeb(registro);
    	
        } catch (Exception e) {
            logger.error("Error al trazar la llamada al WS", e);
        }
    }

}

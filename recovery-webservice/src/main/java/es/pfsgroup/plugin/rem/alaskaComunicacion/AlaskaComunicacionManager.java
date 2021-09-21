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
        JSONObject llamada = null;
        Filter activoIdFilter = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, activoIdFilter);
		Map<String, String> headers = new HashMap<String, String>();
        headers.put("Content-Type", "application/json");

        Map<String, Object> listaBien = bienInfo(activo);

        String json = null;

        try {
           
            model.put("bienes", listaBien);

            json = mapper.writeValueAsString(model);
            System.out.println("ResultingJSONstring = " + json);
            
            urlEnvio = !Checks.esNulo(appProperties.getProperty("rest.client.convivencia.alaska"))
                    ? appProperties.getProperty("rest.client.convivencia.alaska") : "";
            	
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
    
    private Map<String, Object> bienInfo(Activo activo) {
    	
        Filter cartera = genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"cartera.codigo", activo.getCartera().getCodigo());
        Filter subcartera = genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"subcartera.codigo", activo.getSubcartera().getCodigo());
        
        ActivoTitulo actTitulo = genericDao.get(ActivoTitulo.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"activo.id", activo.getId()));
        ExpedienteComercial expediente = expedienteComercialManager.getExpedientePorActivo(activo);
        ActivoCatastro activoCatastro = genericDao.get(ActivoCatastro.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "activo.id", activo.getId()));
        ActivoMaestroActivos activoMaestroActivos = genericDao.get(ActivoMaestroActivos.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "activo.id", activo.getId()));
        ActivoBbvaActivos activoBbvaActivos = genericDao.get(ActivoBbvaActivos.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"activo.id", activo.getId()));
        CarteraMaestro carteraMaestro = genericDao.get(CarteraMaestro.class, cartera, subcartera);

        ArrayList<Map<String, Object>> listaTasaciones = new ArrayList<Map<String, Object>>();
        ArrayList<Map<String, Object>> listaValoraciones = new ArrayList<Map<String, Object>>();
        ArrayList<Map<String, Object>> listaCargas = new ArrayList<Map<String, Object>>();

        Map<String, Object> map = new HashMap<String, Object>();;

        listaCargas = this.cargasInfo(activo);
        listaTasaciones = this.tasacionesInfo(activo);
        listaValoraciones = this.valoracionesInfo(activo);

        map.put("cartera", "");
        if(activoMaestroActivos != null) {
        	map.put("idMaestroActivo", activoMaestroActivos.getId());
        }
        map.put("expediente", "");
        map.put("idHaya", activo.getNumActivo());
        if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR) || activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_LIBERBANK)){
        	map.put("idOrigen", activo.getIdProp());
        }
        if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)){
        	map.put("idOrigen", activo.getNumActivoUvem());
        }
        if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_SAREB)){
        	map.put("idOrigen", activo.getIdSareb());
        }
        if((activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CERBERUS))
        && (activo.getSubcartera().getCodigo().equals(DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB) || activo.getSubcartera().getCodigo().equals(DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB))){
        	map.put("idOrigen", activo.getNumActivoDivarian());
        }
        if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA)){
        	map.put("idOrigen", activoBbvaActivos.getNumActivoBbva());
        }
        if(expediente != null){
        	map.put("numExpediente", expediente.getNumExpediente());
        }else{
        	map.put("numExpediente", null);
        }
        map.put("numActivo", activo.getNumActivo());
        if (!Checks.esNulo(carteraMaestro)) {
        	map.put("carteraRem", carteraMaestro.getDeCartera());
        } else {        	
        	map.put("carteraRem", "");
        }
        map.put("subcarteraRem", activo.getSubcartera().getCodigo());
        if(activo.getSubtipoActivo() != null){
        	map.put("subtipoActivo", activo.getSubtipoActivo().getCodigo());
        }else{
        	map.put("subtipoActivo", null);
        }
        map.put("estadoBien", "1");
        map.put("referenciaCatastral", activoCatastro.getRefCatastral());
        if(activo.getBien() != null && activo.getBien().getDatosRegistralesActivo() != null){
        	map.put("finca", activo.getBien().getDatosRegistralesActivo().getNumFinca());
        }else{
        	map.put("finca", null);
        }
        if(activo.getInfoComercial() != null && activo.getInfoComercial().getLocalidadRegistro() != null){
        	map.put("localidadRegistro", activo.getInfoComercial().getLocalidadRegistro().getCodigo());
        }else{
        	map.put("localidadRegistro", null);
        }
        if(activo.getBien() != null && activo.getBien().getBienEntidad() != null){
        	map.put("tomo", activo.getBien().getBienEntidad().getTomo());
        	map.put("libro", activo.getBien().getBienEntidad().getLibro());
        	map.put("folio", activo.getBien().getBienEntidad().getFolio());
        }else{
        	map.put("tomo", null);
        	map.put("libro", null);
        	map.put("folio", null);
        }
        map.put("fechaInscripcionReg", actTitulo.getFechaInscripcionReg());
        if(activo.getInfoComercial() != null){
        	map.put("longitud", activo.getInfoComercial().getLongitud());
        	map.put("latitud", activo.getInfoComercial().getLatitud());
        }else{
        	map.put("longitud", null);
            map.put("latitud", null);
        }
        if(activo.getInfoRegistral() != null){
        	map.put("idufir", activo.getInfoRegistral().getIdufir());
        	map.put("superficieUtil", activo.getInfoRegistral().getSuperficieUtil());
        }else{
        	map.put("idufir", null);
        	map.put("superficieUtil", null);
        }
        map.put("tasaciones", listaTasaciones);
        map.put("valoraciones", listaValoraciones);
        if(activo.getInfoComercial() != null && activo.getInfoComercial().getTipoVia() != null){
        	map.put("tipoVia", activo.getInfoComercial().getTipoVia().getCodigo());
        }else{
        	map.put("tipoVia", null);
        }
        map.put("nombreVia", activo.getNombreVia());
        map.put("numeroDomicilio", activo.getNumeroDomicilio());
        map.put("portal", activo.getPortal());
        if(activo.getLocalizacion().getLocalizacionBien() != null){
        	map.put("bloque", activo.getLocalizacion().getLocalizacionBien().getBloque());
        }else{
        	map.put("bloque", null);
        }
        map.put("escalera", activo.getEscalera());
        map.put("piso", activo.getPiso());
        map.put("puerta", activo.getPuerta());
        map.put("municipio", activo.getMunicipio());
        if(activo.getLocalidad() != null){
        	map.put("localidad", activo.getLocalidad().getCodigo());
        }else{
        	map.put("localidad", null);
        }
        map.put("provincia", activo.getProvincia());
        map.put("comentarioDireccion", "");
        map.put("pais", activo.getPais());
        map.put("codigoPostal", activo.getCodPostal());
        if(activo.getTipoActivo() != null){
        	map.put("tipoBienCatalogo", activo.getTipoActivo().getCodigo());
        }else{
        	map.put("tipoBienCatalogo", null);
        }
        if(activo.getTipoBien() != null){
        	map.put("tipoBien", activo.getTipoBien().getCodigo());
        }else{
        	map.put("tipoBien", null);
        }
        if(activo.getSubtipoActivo() != null){
        	map.put("subtipoBien", activo.getSubtipoActivo().getCodigo());
        }else{
        	map.put("subtipoBien", null);
        }
        if(activo.getSituacionPosesoria().getOcupado() == 1 && activo.getSituacionPosesoria().getConTitulo().getCodigo().equals("01")){
        	map.put("estadoOcupacion", "02");
        }else if(activo.getSituacionPosesoria().getOcupado() == 1 && (activo.getSituacionPosesoria().getConTitulo().getCodigo().equals("02") || activo.getSituacionPosesoria().getConTitulo().getCodigo().equals("03"))){
        	map.put("estadoOcupacion", "01");
        }else if(activo.getSituacionPosesoria().getOcupado() == 0){
        	map.put("estadoOcupacion", "03");
        }else{
        	map.put("estadoOcupacion", "");
        }
        if(activo.getTipoUsoDestino() != null){
        	map.put("usoActivo", activo.getTipoUsoDestino().getCodigo());
        }else{
        	map.put("usoActivo", null);
        }
        if(activo.getInfoComercial() != null){
        	map.put("anyoConstruccion", activo.getInfoComercial().getAnyoConstruccion());
        }else{
        	map.put("anyoConstruccion", null);
        }
        if(activo.getBien().getBienEntidad() != null){
        	map.put("superficieBien", activo.getBien().getBienEntidad().getSuperficie());
        	map.put("superficieConstruida", activo.getBien().getBienEntidad().getSuperficieConstruida());
        	map.put("numRegistro", activo.getBien().getBienEntidad().getNumRegistro());
        }else{
        	map.put("superficieBien", null);
        	map.put("superficieConstruida", null);
        	map.put("numRegistro", null);
        }
        map.put("cargas", listaCargas);
        map.put("anejoGaraje", "");
        map.put("anejoTrastero", "");
        map.put("anejoOtros", "");
        map.put("notas1", "");
        map.put("notas2", "");

        return map;

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

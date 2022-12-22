package es.pfsgroup.plugin.rem.concurrencia;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.BoardingComunicacionApi;
import es.pfsgroup.plugin.rem.api.ConcurrenciaApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.concurrencia.dao.ConcurrenciaDao;
import es.pfsgroup.plugin.rem.logTrust.LogTrustWebService;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.thread.CaducaOfertasAsync;
import net.sf.json.JSONObject;


@Service("concurrenciaManager")
public class ConcurrenciaManager  implements ConcurrenciaApi { 
	
	private final Log logger = LogFactory.getLog(getClass());
	
	private static final String REST_CLIENT_CONCURRENCIA_ENVIO_CORREO_SFMC = "rest.client.concurrencia.envio.correo.sfmc";
	private static final String REM3_URL = "rem3.base.url";
    private static final String POST_METHOD = "POST";
	
    @Resource
    private Properties appProperties;
    
    @Autowired
    private HttpClientFacade httpClientFacade;
    
    @Autowired
    private RestLlamadaDao llamadaDao;

    @Autowired
    private LogTrustWebService trustMe;
    
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ConcurrenciaDao concurrenciaDao;

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	public boolean bloquearEditarOfertasPorConcurrenciaActivo(Activo activo) {
		boolean bloquear = false;
		if(activo != null) {
			if(isActivoEnConcurrencia(activo)) {
				return true;
			}else {
				List<Oferta> listOfr = ofertaApi.getListaOfertasByActivo(activo);
				bloquear = isOfertaEnPlazoConcu(bloquear, listOfr);
			}	
		}
		return bloquear;
	}
	
	public boolean bloquearEditarOfertasPorConcurrenciaAgrupacion(ActivoAgrupacion agr) {
		boolean bloquear = false;
		if(agr != null) {
			if(isAgrupacionEnConcurrencia(agr) || tieneAgrupacionOfertasDeConcurrencia(agr)) {
				bloquear = true;
			}else {
				List<Oferta> listOfertas = genericDao.getList(Oferta.class,
						genericDao.createFilter(FilterType.EQUALS,"agrupacion.id",agr.getId())
						,genericDao.createFilter(FilterType.EQUALS,"isEnConcurrencia",true));
				bloquear = isOfertaEnPlazoConcu(bloquear, listOfertas);
			}
		}
		return bloquear;
	}

	@Override
	public boolean isOfertaEnPlazoConcu(boolean bloquear, List<Oferta> listOfertas) {
		if(listOfertas != null && !listOfertas.isEmpty()) {

			for (Oferta oferta : listOfertas) {
				if((this.entraEnTiempoDeposito(oferta) && DDEstadoOferta.isPendienteDeposito(oferta.getEstadoOferta())) || this.isOfertaEnEstadoBloqueadoParaTramitarConcurrencia(oferta.getEstadoOferta())) {
					bloquear =  true;
					break;
				}
			}
		}
		return bloquear;
	}

	@Override
	public Concurrencia getUltimaConcurrenciaByActivo(Activo activo) {
		Long idConcurrencia = concurrenciaDao.getIdConcurrenciaReciente(activo.getId(), null);
		Concurrencia concurrencia = null;
		if (idConcurrencia != null) {	
			 concurrencia = genericDao.get(Concurrencia.class, genericDao.createFilter(FilterType.EQUALS, "id", idConcurrencia));
		}
		return concurrencia;
		
	}

	//Mostramos la pestaña de concurrencia Siempre que un activo
	//haya estado en concurrencia (este en vigor o no la concurrencia)
	@Override
	public boolean getTabConcurrenciaByActivo(Activo activo) {
		List<Concurrencia> concurrenciaList = genericDao.getList(Concurrencia.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
		if(concurrenciaList != null && !concurrenciaList.isEmpty()) {
			return true;
		}
		return false;
	}
	
	@Override
	public Concurrencia getUltimaConcurrenciaByAgrupacion(ActivoAgrupacion agrupacion) {
		List<Concurrencia> concurrenciaList = genericDao.getList(Concurrencia.class, genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", agrupacion.getId()));
		Concurrencia concurrencia = null;
		if(concurrenciaList != null && !concurrenciaList.isEmpty()) {
			concurrencia = concurrenciaList.get(0);
		}
		
		return concurrencia;
	}
	
	@Override
	public boolean isActivoEnConcurrencia(Activo activo) {
		boolean isEnConcurrencia = false;
		Concurrencia concurrencia = this.getUltimaConcurrenciaByActivo(activo);
		
		if(concurrencia != null && concurrencia.getFechaInicio() != null && concurrencia.getFechaFin() != null) {
			Date hoy = new Date();
			if( hoy.after(concurrencia.getFechaInicio()) && hoy.before(concurrencia.getFechaFin())) {
				isEnConcurrencia = true;
			}
		}
		
		return isEnConcurrencia;
	}
		
	@Override
	public boolean tieneActivoOfertasDeConcurrencia(Activo activo) {
		boolean tieneOfertasDeConcurrencia = false;
		
		List<Oferta> ofertasList = ofertaApi.getListaOfertasByActivo(activo);
		
		for (Oferta oferta : ofertasList) {
			DDEstadoOferta eof = oferta.getEstadoOferta();
			if(oferta.getIsEnConcurrencia() != null && oferta.getIsEnConcurrencia() && DDEstadoOferta.isOfertaActiva(eof)) {
				tieneOfertasDeConcurrencia = true;
				break;
			}
		}
		
		return tieneOfertasDeConcurrencia;
	}
	
	@Override
	public boolean isAgrupacionEnConcurrencia(ActivoAgrupacion agr) {
		boolean isEnConcurrencia = false;
		
		if(agr != null) {
			isEnConcurrencia = concurrenciaDao.isAgrupacionEnConcurrencia(agr.getId());
		}
		
		return isEnConcurrencia;
	}
	
	@Override
	public boolean tieneAgrupacionOfertasDeConcurrencia(ActivoAgrupacion agr) {
		boolean isEnConcurrencia = false;
		
		if(agr != null) {
			isEnConcurrencia = concurrenciaDao.isAgrupacionConOfertasDeConcurrencia(agr.getId());
		}
		
		return isEnConcurrencia;
	}

	@Override
	public boolean isOfertaEnConcurrencia(Oferta ofr){

		if(ofr != null && ofr.getIsEnConcurrencia() != null && ofr.getIsEnConcurrencia()){
			return true;
		}

		return false;
	}
	
	@Override
	public boolean createPuja(Concurrencia concurrencia, Oferta oferta, Double importe) {
		try {
			Puja puja = new Puja();
			if(concurrencia != null) {
				puja.setConcurrencia(concurrencia);	
			}
			puja.setOferta(oferta);
			puja.setImporte(importe);
			genericDao.save(Puja.class, puja);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}		
		return true;
	}

	@Override
	public Oferta getOfertaGanadora(Activo activo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId());
		List<VGridOfertasActivosAgrupacionConcurrencia> ofertasConcurrencia = genericDao.getList(VGridOfertasActivosAgrupacionConcurrencia.class, filtro);
		Oferta ofertaGanadora = null;
		if(ofertasConcurrencia != null && !ofertasConcurrencia.isEmpty()) {
			ofertaGanadora = ofertaApi.getOfertaById(ofertasConcurrencia.get(0).getId());
		}
		
		return ofertaGanadora;
	}
	
	@Override
	public List<VGridOfertasActivosConcurrencia> getListOfertasVivasConcurrentes(Long idActivo, Long idConcurrencia) {
		return concurrenciaDao.getListOfertasVivasConcurrentes(idActivo,idConcurrencia);
	}
	
	@Override
	public List<VGridOfertasActivosAgrupacionConcurrencia> getListOfertasTerminadasConcurrentes(Long idActivo, Long idConcurrencia) {
		return concurrenciaDao.getListOfertasTerminadasConcurrentes(idActivo, idConcurrencia);
	}
	
	@Override
	public boolean isConcurrenciaOfertasEnProgresoActivo(Activo activo) {
		return this.isActivoEnConcurrencia(activo) || this.tieneActivoOfertasDeConcurrencia(activo);
	}
	
	@Override
	public boolean isConcurrenciaTerminadaOfertasEnProgresoActivo(Activo activo) {
		return !this.isActivoEnConcurrencia(activo) && this.tieneActivoOfertasDeConcurrencia(activo);
	}
	
	@Override
	public boolean isConcurrenciaOfertasEnProgresoAgrupacion(ActivoAgrupacion agrupacion) {
		return this.isAgrupacionEnConcurrencia(agrupacion) || this.tieneAgrupacionOfertasDeConcurrencia(agrupacion);
	}
	
	@Override
	public boolean isConcurrenciaTerminadaOfertasEnProgresoAgrupacion(ActivoAgrupacion agrupacion) {
		return !this.isAgrupacionEnConcurrencia(agrupacion) && this.tieneAgrupacionOfertasDeConcurrencia(agrupacion);
	}

	@Override
	@Transactional
	public void caducaOfertasRelacionadasConcurrencia(Long idActivo, Long idOferta, String codigoEnvioCorreo){
		try {
			Activo act = genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "id", idActivo));
			Oferta ofertaGanadora = ofertaApi.getOfertaById(idOferta);
			Concurrencia concurrencia = ofertaGanadora.getConcurrencia();
			
			if(act != null){
				List<ActivoOferta> ofertas = act.getOfertas();
				List<Long> idOfertaList = new ArrayList<Long>();
	
				if(ofertas != null && !ofertas.isEmpty()) {
					for(ActivoOferta actOfr: ofertas){
						if(actOfr != null && actOfr.getOferta() != null && !idOferta.toString().equals(actOfr.getOferta().toString())) {
							Oferta ofr = actOfr.getPrimaryKey().getOferta();
							if(!ofr.esOfertaAnulada() && !ofr.esOfertaCaducada()) {
								if(ConcurrenciaApi.COD_OFERTAS_PERDEDORAS.equals(codigoEnvioCorreo)) {
									if(concurrencia != null && ofr.getConcurrencia() != null && concurrencia.getId().equals(ofr.getConcurrencia().getId())) {
										idOfertaList.add(ofr.getId());
										ofertaApi.rechazoOfertaNew(ofr, null);
										genericDao.save(Oferta.class, ofr);
									}
								}else if(!this.entraEnTiempoDeposito(ofr)){
									idOfertaList.add(ofr.getId());
									ofertaApi.rechazoOfertaNew(ofr, null);
									genericDao.save(Oferta.class, ofr);
								}
							}
						}						
					}
				}
				
				for(Long id:idOfertaList){
	                ofertaApi.llamarCambioEstadoReplicarNoSession(id, DDEstadoOferta.CODIGO_RECHAZADA);
	            }
	
				if(!idOfertaList.isEmpty()) {
					comunicacionSFMC(idOfertaList, codigoEnvioCorreo, ConcurrenciaApi.TIPO_ENVIO_UNICO, new ModelMap());
				}
			}
		}catch (IOException ioex) {
			logger.error(ioex.getMessage());
			ioex.printStackTrace();
		}catch (Exception exc) {
			logger.error(exc.getMessage());
			exc.printStackTrace();
		}

	}

	@Override
	@Transactional
	public boolean caducaOfertaConcurrencia(Long idActivo, Long idOferta){
		HashMap<Long, List<Long>> noEntraDeposito = new HashMap<Long, List<Long>>();
		boolean principalCaducada = false;
		
		noEntraDeposito = this.caducaOfertaPrincipal(idOferta);
		if(!noEntraDeposito.isEmpty()) {
			principalCaducada = true;
		}

		Thread hilo = new Thread(new CaducaOfertasAsync(idActivo, idOferta, genericAdapter.getUsuarioLogado().getUsername(), ConcurrenciaApi.COD_ANULACION_OFERTA_FALTA_CONFIRMACION_DEPOSITO));
		hilo.start();
		
		return principalCaducada;
		
	}
	
	@Transactional
	private HashMap<Long, List<Long>> caducaOfertaPrincipal(Long idOferta){
		Oferta ofr = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id", idOferta));
		HashMap<Long, List<Long>> noEntraDeposito = new HashMap<Long, List<Long>>();
		List<Long> idOfertaList = new ArrayList<Long>();

		if(ofr != null){
			
			if(!this.entraEnTiempoDeposito(ofr)){
				noEntraDeposito.put(ofr.getId(), rellenaMapOfertaCorreos(ofr));
				ofertaApi.inicioRechazoDeOfertaSinLlamadaBC(ofr, null);
				idOfertaList.add(ofr.getId());
			}
		
			genericDao.save(Oferta.class, ofr);
			
			if(!idOfertaList.isEmpty()) {
				try {
					comunicacionSFMC(idOfertaList, ConcurrenciaApi.COD_ANULACION_OFERTA_FALTA_CONFIRMACION_DEPOSITO, ConcurrenciaApi.TIPO_ENVIO_UNICO, new ModelMap());		
				} catch (IOException ioex) {
					logger.error(ioex.getMessage());
					ioex.printStackTrace();
				} catch (Exception exc) {
					logger.error(exc.getMessage());
					exc.printStackTrace();
				}
			}
		}
		
		return noEntraDeposito;
	}

	private List<Long> rellenaMapOfertaCorreos(Oferta ofr) {
		List<Long> ids = new ArrayList<Long>();

		if(ofr != null){
			if(ofr.getCliente() != null && ofr.getCliente().getEmail() != null){
				ids.add(ofr.getCliente().getId());
			}

			List<TitularesAdicionalesOferta> titularesAdicionales = genericDao.getList(TitularesAdicionalesOferta.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofr.getId()));

			if(titularesAdicionales != null && !titularesAdicionales.isEmpty()){
				for(TitularesAdicionalesOferta tit: titularesAdicionales){
					ids.add(tit.getId());
				}
			}

		}
		return ids;
	}
	
	@Override
	@Transactional
	public List<DtoPujaDetalle> getPujasDetalleByIdOferta(Long idActivo, Long idOferta) {
		List<DtoPujaDetalle> dtoLista = new ArrayList<DtoPujaDetalle>();
		List<Puja> listaPujas = new ArrayList<Puja>();		
		Activo activo = activoAdapter.getActivoById(idActivo);

		Filter filtroOferta = genericDao.createFilter(FilterType.EQUALS, "oferta.id", idOferta);
		Order order = new Order(OrderType.DESC, "auditoria.fechaCrear");
		listaPujas = genericDao.getListOrdered(Puja.class, order, filtroOferta);
	
		if (listaPujas != null && !listaPujas.isEmpty()) {					
			
			for (Puja puja : listaPujas) {
				DtoPujaDetalle dto = new DtoPujaDetalle();
				if (puja.getId() != null) {
					dto.setId(puja.getId());
				}
				if (puja.getOferta() != null) {
					dto.setIdOferta(puja.getOferta().getId());
				}
				if (!Checks.isFechaNula(puja.getAuditoria().getFechaCrear())) {
					dto.setFechaCrear(puja.getAuditoria().getFechaCrear());
				}
		
				if(puja.getImporte() != null) {
					dto.setImportePuja(puja.getImporte());
				}
				boolean isConcurrencia = concurrenciaDao.isActivoEnConcurrencia(idActivo);
				if(isConcurrencia) {
					dto.setEnConcurrencia(isConcurrencia);
				}
				dtoLista.add(dto);
			}
		}
		return dtoLista;
	}
	
	@Override
	public List<DtoHistoricoConcurrencia> getHistoricoConcurrencia(Long idActivo) {
		List<DtoHistoricoConcurrencia> listaHistorico = new ArrayList<DtoHistoricoConcurrencia>();
		List<Concurrencia> listaConcurrencia = new ArrayList<Concurrencia>();
		if (idActivo != null) {
			Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
			listaConcurrencia = genericDao.getList(Concurrencia.class, filtroIdActivo);
			if(!listaConcurrencia.isEmpty()) {
				for (Concurrencia concurrencia : listaConcurrencia) {
					DtoHistoricoConcurrencia dto = new DtoHistoricoConcurrencia();
					dto.setId(concurrencia.getId());
					dto.setIdActivo(concurrencia.getActivo() != null ? concurrencia.getActivo().getId() : null);
					dto.setNumActivo(concurrencia.getActivo() != null ? concurrencia.getActivo().getNumActivo() : null);
					dto.setIdAgrupacion(concurrencia.getAgrupacion() != null ? concurrencia.getAgrupacion().getId() : null);
					dto.setNumAgrupacion(concurrencia.getAgrupacion() != null ? concurrencia.getAgrupacion().getNumAgrupRem() : null);
					dto.setImporteMinOferta(concurrencia.getImporteMinOferta());
					dto.setFechaInicio(concurrencia.getFechaInicio());
					dto.setFechaFin(concurrencia.getFechaFin());
					listaHistorico.add(dto);
				}
			}
		}
		return listaHistorico;
	}

	@Override
	public List<VGridCambiosPeriodoConcurrencia> getListCambiosPeriodoConcurenciaByIdConcurrencia(Long idConcurrencia) {
		return concurrenciaDao.getListCambiosPeriodoConcurenciaByIdConcurrencia(idConcurrencia);
	}
	
//	public boolean entraEnTiempoDocumentacion(Oferta oferta){
//		if(oferta != null && oferta.getConcurrencia() != null && oferta.getConcurrencia()){
//			Date fechaTopeOferta = this.sumarRestarHorasFecha(oferta.getAuditoria().getFechaCrear(), 72);
//			Date fechaHoy = new Date();
//
//			int fecha = (int) ((fechaTopeOferta.getTime()-fechaHoy.getTime())/86400000);
//
//			return fecha >= 0;
//		}
//		return true;
//	}

	public boolean entraEnTiempoDeposito(Oferta oferta){
		if (oferta != null) {
			Deposito deposito = oferta.getDeposito();
			if(oferta != null && oferta.getIsEnConcurrencia() != null && oferta.getIsEnConcurrencia() && deposito != null && deposito.getFechaInicio() != null){
				Date fechaTopeOferta = this.sumarRestarHorasFecha(deposito.getFechaInicio(), 120);
				Date fechaHoy = new Date();
	
				int fecha = (int) ((fechaTopeOferta.getTime()-fechaHoy.getTime())/86400000);
	
				return fecha >= 0;
			}
		}
		return true;
	}
	
	public Date sumarRestarHorasFecha(Date fecha, int horas){
		Calendar calendar = Calendar.getInstance();

		calendar.setTime(fecha); // Configuramos la fecha que se recibe
		calendar.add(Calendar.HOUR, horas);  // numero de horas a añadir, o restar en caso de horas<0

		return calendar.getTime(); // Devuelve el objeto Date con las nuevas horas añadidas
	}
	

	@SuppressWarnings("unchecked")
	@Override
	public void comunicacionSFMC(List<Long> idOfertaList, String codigoEnvio, String tipoEnvio, ModelMap model) throws IOException {
		
		Map<String, String> headers = new HashMap<String, String>();
        headers.put("Content-Type", "application/json");

        model.put("idOfertaList", idOfertaList);

        ObjectMapper mapper = new ObjectMapper();
        
        String json = mapper.writeValueAsString(model);
	
		String urlBase = !Checks.esNulo(appProperties.getProperty(REM3_URL)) 
				? appProperties.getProperty(REM3_URL) : "";
		String endpointComunicacionSFMC = !Checks.esNulo(appProperties.getProperty(REST_CLIENT_CONCURRENCIA_ENVIO_CORREO_SFMC))
		        ? appProperties.getProperty(REST_CLIENT_CONCURRENCIA_ENVIO_CORREO_SFMC) : "";
		
		StringBuilder urlComunicacionSFMC = new StringBuilder();
		urlComunicacionSFMC.append(urlBase);
		urlComunicacionSFMC.append(endpointComunicacionSFMC);
		urlComunicacionSFMC.append("/").append(codigoEnvio);
		urlComunicacionSFMC.append("/").append(tipoEnvio);
    	
		logger.debug("[ENVIO CORREO SFMC (CONCURRENCIA)] URL (REM-API): " + urlComunicacionSFMC.toString());
        logger.debug("[ENVIO CORREO SFMC (CONCURRENCIA)] BODY: " + json.toString());
		
		JSONObject respuesta = null;
		String ex = null;
		
		try {			
			respuesta = procesarPeticion(this.httpClientFacade, urlComunicacionSFMC.toString(), POST_METHOD, headers, json, BoardingComunicacionApi.TIMEOUT_2_MINUTOS, "UTF-8");	
		} catch (HttpClientException exHttpClient) {
			exHttpClient.printStackTrace();
			ex = exHttpClient.getMessage();
		} catch (Exception exc) {
			logger.error("Error al enviar correo SFMC (Concurrencia)", exc);
			logger.error(exc.getMessage());
			ex = exc.getMessage();
		}

		String response = mapper.writeValueAsString(respuesta);
		logger.debug("[ENVIO CORREO SFMC (CONCURRENCIA)] RESPONSE: " + mapper.writeValueAsString(respuesta));
	
		registrarLlamada(urlComunicacionSFMC.toString(), json.toString(), response != null && !response.isEmpty() ? response : null, ex);
		
	}
	
	private JSONObject procesarPeticion(HttpClientFacade httpClientFacade, String serviceUrl, String sendMethod, Map<String, String> headers, String jsonString, int responseTimeOut, String charSet) 
			throws HttpClientException {
        return httpClientFacade.processRequest(serviceUrl, sendMethod, headers, jsonString, responseTimeOut, charSet);
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
	
	private boolean isOfertaEnEstadoBloqueadoParaTramitarConcurrencia(DDEstadoOferta eof) {
		boolean is = false;
		if(DDEstadoOferta.isPteDoc(eof) || DDEstadoOferta.isPendienteConsentimiento(eof) || DDEstadoOferta.isPteTit(eof)){
			is = true;
		}
		
		return is;
	}

	@Override
	public boolean checkOfertaConcurrencia(TareaExterna tareaExterna) {
		Oferta oferta = ofertaApi.tareaExternaToOferta(tareaExterna);
		return isOfertaEnConcurrencia(oferta);
	}

}

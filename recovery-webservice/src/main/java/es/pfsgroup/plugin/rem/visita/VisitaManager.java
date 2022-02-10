package es.pfsgroup.plugin.rem.visita;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.GenericApi;
import es.pfsgroup.plugin.rem.api.VisitaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;
import es.pfsgroup.plugin.rem.model.InfoAdicionalPersona;
import es.pfsgroup.plugin.rem.model.VBusquedaVisitasDetalle;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisita;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenComprador;
import es.pfsgroup.plugin.rem.model.dd.DDSubEstadosVisita;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.VisitaDto;
import es.pfsgroup.plugin.rem.restclient.caixabc.CaixaBcRestClient;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.service.InterlocutorCaixaService;
import es.pfsgroup.plugin.rem.service.InterlocutorGenericService;
import es.pfsgroup.plugin.rem.thread.MaestroDePersonas;
import es.pfsgroup.plugin.rem.visita.dao.VisitaDao;

@Service("visitaManager")
public class VisitaManager extends BusinessOperationOverrider<VisitaApi> implements VisitaApi {

	private static final String REM3_URL = "rem3.base.url";
	private static final String CONTACTOS_ENDPOINT = "rem3.endpoint.comercial.visita"; 
	
	protected static final Log logger = LogFactory.getLog(VisitaManager.class);

	@Autowired
	private RestApi restApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private VisitaDao visitaDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GencatApi gencatApi;
	
	@Autowired
	private HttpClientFacade httpClient;
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private GenericApi genericApi;
	
	@Autowired
	private InterlocutorCaixaService interlocutorCaixaService;
	
	@Autowired
	private InterlocutorGenericService interlocutorGenericService;

	@Override
	public String managerName() {
		return "visitaManager";
	}

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	MaestroDePersonas maestroDePersonas = new MaestroDePersonas();

	@Override
	public Visita getVisitaById(Long id) {
		Visita visita = null;

		try {

			visita = visitaDao.get(id);

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return visita;
	}

	@Override
	public Visita getVisitaByIdVisitaWebcom(Long idVisitaWebcom) throws Exception {
		Visita visita = null;
		if (Checks.esNulo(idVisitaWebcom)) {
			throw new Exception("El parámetro idVisitaWebcom es obligatorio.");
		} else {
			visita = visitaDao.getVisitaByIdwebcom(idVisitaWebcom);
		}

		return visita;
	}

	@Override
	public Visita getVisitaByNumVisitaRem(Long numVisitaRem) {
		Visita visita = null;
		List<Visita> lista = null;
		VisitaDto visitaDto = null;

		try {

			if (Checks.esNulo(numVisitaRem)) {
				throw new Exception("El parámetro idVisitaRem es obligatorio.");

			} else {

				visitaDto = new VisitaDto();
				visitaDto.setIdVisitaRem(numVisitaRem);

				lista = visitaDao.getListaVisitas(visitaDto);
				if (!Checks.esNulo(lista) && lista.size() > 0) {
					visita = lista.get(0);
				}
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return visita;
	}

	@Override
	public Visita getVisitaByIdVisitaWebcomNumVisitaRem(Long idVisitaWebcom, Long numVisitaRem) throws Exception {
		Visita visita = null;
		List<Visita> lista = null;
		VisitaDto visitaDto = null;

		if (Checks.esNulo(idVisitaWebcom)) {
			throw new Exception("El parámetro idVisitaWebcom es obligatorio.");

		} else if (Checks.esNulo(numVisitaRem)) {
			throw new Exception("El parámetro idVisitaRem es obligatorio.");

		} else {

			visitaDto = new VisitaDto();
			visitaDto.setIdVisitaRem(numVisitaRem);
			visitaDto.setIdVisitaWebcom(idVisitaWebcom);

			lista = visitaDao.getListaVisitas(visitaDto);
			if (!Checks.esNulo(lista) && lista.size() > 0) {
				visita = lista.get(0);
			}
		}

		return visita;
	}

	@Override
	public DtoPage getListVisitas(DtoVisitasFilter dtoVisitasFilter) {

		return visitaDao.getListVisitas(dtoVisitasFilter);
	}

	@Override
	public List<Visita> getListaVisitas(VisitaDto visitaDto) {
		List<Visita> lista = null;

		try {

			lista = visitaDao.getListaVisitas(visitaDto);

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return lista;
	}

	@Override
	public HashMap<String, String> validateVisitaPostRequestData(VisitaDto visitaDto, Object jsonFields, Boolean alta)
			throws Exception {
		HashMap<String, String> hashErrores = null;

		if (alta) {
			hashErrores = restApi.validateRequestObject(visitaDto, TIPO_VALIDACION.INSERT);
		} else {
			hashErrores = restApi.validateRequestObject(visitaDto, TIPO_VALIDACION.UPDATE);
		}

		if (!Checks.esNulo(visitaDto.getIdUsuarioRemAccion())) {
			Usuario user = (Usuario) genericDao.get(Usuario.class,
					genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdUsuarioRemAccion()));
			if (Checks.esNulo(user)) {
				hashErrores.put("idUsuarioRemAccion", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}

		if (Checks.esNulo(visitaDto.getCodDetalleEstadoVisita()) && !Checks.esNulo(visitaDto.getCodEstadoVisita())
				&& (visitaDto.getCodEstadoVisita().equalsIgnoreCase(DDEstadosVisita.CODIGO_REALIZADA)
						|| visitaDto.getCodEstadoVisita().equalsIgnoreCase(DDEstadosVisita.CODIGO_NO_REALIZADA))) {
			// El codDetalleEstadoVisita solo es obligatorio si la visita está
			// completada, es decir, estados "Realizada" y "No realizada".
			hashErrores.put("codDetalleEstadoVisita", RestApi.REST_MSG_MISSING_REQUIRED);
		}

		if (!Checks.esNulo(visitaDto.getCodDetalleEstadoVisita())) {
			DDSubEstadosVisita subEstVis = (DDSubEstadosVisita) genericDao.get(DDSubEstadosVisita.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodDetalleEstadoVisita()));
			if (Checks.esNulo(subEstVis)) {
				hashErrores.put("codDetalleEstadoVisita", RestApi.REST_MSG_UNKNOWN_KEY);
			} else {
				if (Checks.esNulo(subEstVis.getEstadoVisita()) || (!Checks.esNulo(subEstVis.getEstadoVisita())
						&& !subEstVis.getEstadoVisita().getCodigo().equalsIgnoreCase(visitaDto.getCodEstadoVisita()))) {
					hashErrores.put("codDetalleEstadoVisita", RestApi.REST_MSG_UNKNOWN_KEY);
				}
			}
		}
		if (!Checks.esNulo(visitaDto.getIdProveedorRemFdv())) {
			ActivoProveedor fdv = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
					genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemFdv()));
			if (Checks.esNulo(fdv)) {
				hashErrores.put("idProveedorRemFdv", RestApi.REST_MSG_UNKNOWN_KEY);
			} else {
				if (fdv.getTipoProveedor() == null
						|| !fdv.getTipoProveedor().getCodigo().equals(DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA)) {
					hashErrores.put("idProveedorRemFdv", RestApi.REST_MSG_UNKNOWN_KEY);
				}
			}
		}
		if (!Checks.esNulo(visitaDto.getIdProveedorRemCustodio())) {
			ActivoProveedor cust = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao
					.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemCustodio()));
			if (Checks.esNulo(cust)) {
				hashErrores.put("idProveedorRemCustodio", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}

		return hashErrores;
	}

	@Override
	@Transactional(readOnly = false)
	public HashMap<String, String> saveVisita(VisitaDto visitaDto) throws Exception {
		Visita visita = null;
		HashMap<String, String> errorsList = null;

		// ValidateAlta
		errorsList = validateVisitaPostRequestData(visitaDto, null, true);
		if (errorsList.isEmpty()) {

			visita = new Visita();
			beanUtilNotNull.copyProperties(visita, visitaDto);
			visita.setNumVisitaRem(visitaDao.getNextNumVisitaRem());

			if (!Checks.esNulo(visitaDto.getIdClienteRem())) {
				ClienteComercial cliente = (ClienteComercial) genericDao.get(ClienteComercial.class,
						genericDao.createFilter(FilterType.EQUALS, "idClienteRem", visitaDto.getIdClienteRem()),
						genericDao.createFilter(FilterType.NOTNULL, "idClienteWebcom"));
				if (!Checks.esNulo(cliente)) {
					if (!Checks.esNulo(visitaDto.getIdActivoHaya())) {
						Activo activo = (Activo) genericDao.get(Activo.class,
								genericDao.createFilter(FilterType.EQUALS, "numActivo", visitaDto.getIdActivoHaya()));
						if(activo != null) {
							String idPersonaCaixa = interlocutorCaixaService.getIdPersonaHayaCaixaByCarteraAndDocumento(activo.getCartera(), activo.getSubcartera(), cliente.getDocumento());
							cliente.setIdPersonaHayaCaixa(idPersonaCaixa);
							genericDao.save(ClienteComercial.class,cliente);
							InfoAdicionalPersona iap = cliente.getInfoAdicionalPersona();
							iap.setIdPersonaHayaCaixa(idPersonaCaixa);
							genericDao.save(InfoAdicionalPersona.class, iap);
							errorsList.put("idCliente", cliente.getId().toString());
						}
					}
					visita.setCliente(cliente);
				}
			}
			if (!Checks.esNulo(visitaDto.getIdActivoHaya())) {
				Activo activo = (Activo) genericDao.get(Activo.class,
						genericDao.createFilter(FilterType.EQUALS, "numActivo", visitaDto.getIdActivoHaya()));
				if (!Checks.esNulo(activo)) {
					visita.setActivo(activo);
				}
			}
			if (!Checks.esNulo(visitaDto.getIdUsuarioRemAccion())) {
				Usuario user = (Usuario) genericDao.get(Usuario.class,
						genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdUsuarioRemAccion()));
				if (!Checks.esNulo(user)) {
					visita.setUsuarioAccion(user);
				}
			}
			if (!Checks.esNulo(visitaDto.getCodEstadoVisita())) {
				DDEstadosVisita estadoVis = (DDEstadosVisita) genericDao.get(DDEstadosVisita.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodEstadoVisita()));
				if (!Checks.esNulo(estadoVis)) {
					visita.setEstadoVisita(estadoVis);
				}
			}
			if (!Checks.esNulo(visitaDto.getCodDetalleEstadoVisita())) {
				DDSubEstadosVisita subEstVis = (DDSubEstadosVisita) genericDao.get(DDSubEstadosVisita.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodDetalleEstadoVisita()));
				if (!Checks.esNulo(subEstVis)) {
					visita.setSubEstadoVisita(subEstVis);
				}
			}
			if (!Checks.esNulo(visitaDto.getIdProveedorRemPrescriptor())) {
				ActivoProveedor prescriptor = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
								visitaDto.getIdProveedorRemPrescriptor()));
				if (!Checks.esNulo(prescriptor)) {
					visita.setPrescriptor(prescriptor);
				}
			}

			if (!Checks.esNulo(visitaDto.getIdProveedorRemResponsable())) {
				ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
								visitaDto.getIdProveedorRemResponsable()));
				if (!Checks.esNulo(apiResp)) {
					if (apiResp != null && apiResp.getIdPersonaHaya() == null){
						MaestroDePersonas maestroDePersonas = new MaestroDePersonas();
						apiResp.setIdPersonaHaya(maestroDePersonas.getIdPersonaHayaByDocumentoProveedor(apiResp.getDocIdentificativo(),apiResp.getCodigoProveedorRem()));
						genericDao.save(ActivoProveedor.class,apiResp);
						errorsList.put("idResponsable", apiResp.getId().toString());
					}
					visita.setApiResponsable(apiResp);
				}
			}

			if (!Checks.esNulo(visitaDto.getIdProveedorRemCustodio())) {
				ActivoProveedor apiCust = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao
						.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemCustodio()));
				if (!Checks.esNulo(apiCust)) {
					visita.setApiCustodio(apiCust);
				}
			}
			if (!Checks.esNulo(visitaDto.getIdProveedorRemFdv())) {
				ActivoProveedor fdv = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao
						.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemFdv()));
				if (!Checks.esNulo(fdv)) {
					visita.setFdv(fdv);
				}
			}
			if (!Checks.esNulo(visitaDto.getIdProveedorRemVisita())) {
				ActivoProveedor pveVisita = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao
						.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemVisita()));
				if (!Checks.esNulo(pveVisita)) {
					visita.setProveedorVisita(pveVisita);
				}
			}
			if (!Checks.esNulo(visitaDto.getIdProveedorPrescriptorOportunidadREM())) {
				ActivoProveedor pveOportunidad = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao
						.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorPrescriptorOportunidadREM()));
				if (!Checks.esNulo(pveOportunidad)) {
					visita.setProveedorPrescriptorOportunidad(pveOportunidad);
				}
			}
			if (!Checks.esNulo(visitaDto.getFechaAccion())) {
				visita.setFechaSolicitud(visitaDto.getFechaAccion());
			}

			if (!Checks.esNulo(visitaDto.getCodEstadoVisita()) && !Checks.esNulo(visitaDto.getFecha())) {
				if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_ALTA)) {
					visita.setFechaVisita(visitaDto.getFecha());
				} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_CONCERTADA)) {
					visita.setFechaConcertacion(visitaDto.getFecha());
				} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_CONTACTO)) {
					visita.setFechaContacto(visitaDto.getFecha());
				} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_REALIZADA)) {
					visita.setFechaVisita(visitaDto.getFecha());
				} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_NO_REALIZADA)) {
					visita.setFechaVisita(visitaDto.getFecha());
				}
			}
			
			if(!Checks.esNulo(visitaDto.getCodOrigenComprador())) {
				DDOrigenComprador origenComprador = genericDao.get(DDOrigenComprador.class, genericDao.createFilter(FilterType.EQUALS, "codigo",visitaDto.getCodOrigenComprador()));
				visita.setOrigenComprador(origenComprador);
			}
			
			if(!Checks.esNulo(visitaDto.getFechaReasignacionRealizadorOportunidad())) {
				visita.setFechaReasignacionRealizadorOportunidad(visitaDto.getFechaReasignacionRealizadorOportunidad());
			}
			
			if(!Checks.esNulo(visitaDto.getIdVisitaBC())) {
				visita.setIdVisitaBC(visitaDto.getIdVisitaBC());
			}
			
			visitaDao.save(visita);
			
			//Si Webcom nos envia el idSalesforce despues de crear la visita la asociaremos a su comunicacion de GENCAT
			if (!Checks.esNulo(visitaDto.getIdLeadSalesforce())) {
				gencatApi.updateVisitaComunicacion(visita.getActivo().getId(), visitaDto.getIdLeadSalesforce(), visita);
			}
			
		}

		return errorsList;
	}

	@Override
	@Transactional(readOnly = false)
	public HashMap<String, String> updateVisita(Visita visita, VisitaDto visitaDto, Object jsonFields)
			throws Exception {
		HashMap<String, String> errorsList = null;

		// ValidateUpdate
		errorsList = validateVisitaPostRequestData(visitaDto, jsonFields, false);
		if (errorsList.isEmpty()) {

			if (((JSONObject) jsonFields).containsKey("idClienteRem")) {
				if (!Checks.esNulo(visitaDto.getIdClienteRem())) {
					ClienteComercial cliente = (ClienteComercial) genericDao.get(ClienteComercial.class,
							genericDao.createFilter(FilterType.EQUALS, "idClienteRem", visitaDto.getIdClienteRem()),
							genericDao.createFilter(FilterType.NOTNULL, "idClienteWebcom"));
					if (!Checks.esNulo(cliente)) {
						if (cliente.getIdPersonaHayaCaixa() == null || cliente.getIdPersonaHayaCaixa().trim().isEmpty()) {
							if (!Checks.esNulo(visitaDto.getIdActivoHaya())) {
								Activo activo = (Activo) genericDao.get(Activo.class,
										genericDao.createFilter(FilterType.EQUALS, "numActivo", visitaDto.getIdActivoHaya()));
								if(activo != null) {
									cliente.setIdPersonaHayaCaixa(interlocutorCaixaService.getIdPersonaHayaCaixaByCarteraAndDocumento(activo.getCartera(), activo.getSubcartera(), cliente.getDocumento()));
									genericDao.save(ClienteComercial.class,cliente);
									errorsList.put("idCliente", cliente.getId().toString());
								}
							}
						}
						visita.setCliente(cliente);
					}
				}
			}

			if (((JSONObject) jsonFields).containsKey("idActivoHaya")) {
				if (!Checks.esNulo(visitaDto.getIdActivoHaya())) {
					Activo activo = (Activo) genericDao.get(Activo.class,
							genericDao.createFilter(FilterType.EQUALS, "numActivo", visitaDto.getIdActivoHaya()));
					if (!Checks.esNulo(activo)) {
						visita.setActivo(activo);
					}
				}
			}
			if (((JSONObject) jsonFields).containsKey("codEstadoVisita")) {
				if (!Checks.esNulo(visitaDto.getCodEstadoVisita())) {
					DDEstadosVisita estadoVis = (DDEstadosVisita) genericDao.get(DDEstadosVisita.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodEstadoVisita()));
					if (!Checks.esNulo(estadoVis)) {
						visita.setEstadoVisita(estadoVis);
					}
				} else {
					visita.setEstadoVisita(null);
				}
			}
			if (((JSONObject) jsonFields).containsKey("codDetalleEstadoVisita")) {
				if (!Checks.esNulo(visitaDto.getCodDetalleEstadoVisita())) {
					DDSubEstadosVisita subEstVis = (DDSubEstadosVisita) genericDao.get(DDSubEstadosVisita.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo",
									visitaDto.getCodDetalleEstadoVisita()));
					if (!Checks.esNulo(subEstVis)) {
						visita.setSubEstadoVisita(subEstVis);
					}
				} else {
					visita.setSubEstadoVisita(null);
				}
			}
			if (((JSONObject) jsonFields).containsKey("idUsuarioRemAccion")) {
				if (!Checks.esNulo(visitaDto.getIdUsuarioRemAccion())) {
					Usuario user = (Usuario) genericDao.get(Usuario.class,
							genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdUsuarioRemAccion()));
					if (!Checks.esNulo(user)) {
						visita.setUsuarioAccion(user);
					}
				} else {
					visita.setUsuarioAccion(null);
				}
			}
			if (((JSONObject) jsonFields).containsKey("idProveedorRemPrescriptor")) {
				if (!Checks.esNulo(visitaDto.getIdProveedorRemPrescriptor())) {
					ActivoProveedor prescriptor = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
							genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
									visitaDto.getIdProveedorRemPrescriptor()));
					if (!Checks.esNulo(prescriptor)) {
						visita.setPrescriptor(prescriptor);
					}
				} else {
					visita.setPrescriptor(null);
				}
			}

			if (((JSONObject) jsonFields).containsKey("idProveedorRemResponsable")) {
				if (!Checks.esNulo(visitaDto.getIdProveedorRemResponsable())) {
					ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
							genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
									visitaDto.getIdProveedorRemResponsable()));
					if (!Checks.esNulo(apiResp)) {
						if (apiResp != null && apiResp.getIdPersonaHaya() == null){
							MaestroDePersonas maestroDePersonas = new MaestroDePersonas();
							apiResp.setIdPersonaHaya(maestroDePersonas.getIdPersonaHayaByDocumentoProveedor(apiResp.getDocIdentificativo(),apiResp.getCodigoProveedorRem()));
							genericDao.save(ActivoProveedor.class,apiResp);
							errorsList.put("idResponsable", apiResp.getId().toString());
						}
						visita.setApiResponsable(apiResp);
					}
				} else {
					visita.setApiResponsable(null);
				}
			}

			if (((JSONObject) jsonFields).containsKey("idProveedorRemCustodio")) {
				if (!Checks.esNulo(visitaDto.getIdProveedorRemCustodio())) {
					ActivoProveedor apiCust = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
							genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
									visitaDto.getIdProveedorRemCustodio()));
					if (!Checks.esNulo(apiCust)) {
						visita.setApiCustodio(apiCust);
					}
				} else {
					visita.setApiCustodio(null);
				}
			}

			if (((JSONObject) jsonFields).containsKey("idProveedorRemFdv")) {
				if (!Checks.esNulo(visitaDto.getIdProveedorRemFdv())) {
					ActivoProveedor fdv = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao
							.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemFdv()));
					if (!Checks.esNulo(fdv)) {
						visita.setFdv(fdv);
					}
				} else {
					visita.setFdv(null);
				}
			}

			if (((JSONObject) jsonFields).containsKey("idProveedorRemVisita")) {
				if (!Checks.esNulo(visitaDto.getIdProveedorRemVisita())) {
					ActivoProveedor pveVisita = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
							genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
									visitaDto.getIdProveedorRemVisita()));
					if (!Checks.esNulo(pveVisita)) {
						visita.setProveedorVisita(pveVisita);
					}
				} else {
					visita.setProveedorVisita(null);
				}
			}

			if (((JSONObject) jsonFields).containsKey("observaciones")) {
				visita.setObservaciones(visitaDto.getObservaciones());
			}

			if (((JSONObject) jsonFields).containsKey("fecha")) {
				if (!Checks.esNulo(visitaDto.getCodEstadoVisita()) && !Checks.esNulo(visitaDto.getFecha())) {
					if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_ALTA)) {
						visita.setFechaVisita(visitaDto.getFecha());
					} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_CONCERTADA)) {
						visita.setFechaConcertacion(visitaDto.getFecha());
					} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_CONTACTO)) {
						visita.setFechaContacto(visitaDto.getFecha());
					} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_REALIZADA)) {
						visita.setFechaVisita(visitaDto.getFecha());
					} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_NO_REALIZADA)) {
						visita.setFechaVisita(visitaDto.getFecha());
					}
				}
			}

			if (((JSONObject) jsonFields).containsKey("telefonoContactoVisitas")) {
				visita.setTelefonoContactoVisitas(visitaDto.getTelefonoContactoVisitas());
			}
			
			if(!Checks.esNulo(visitaDto.getCodOrigenComprador())) {
				DDOrigenComprador origenComprador = genericDao.get(DDOrigenComprador.class, genericDao.createFilter(FilterType.EQUALS, "codigo",visitaDto.getCodOrigenComprador()));
				visita.setOrigenComprador(origenComprador);
			}
			
			if(!Checks.esNulo(visitaDto.getFechaReasignacionRealizadorOportunidad())) {
				visita.setFechaReasignacionRealizadorOportunidad(visitaDto.getFechaReasignacionRealizadorOportunidad());
			}
			
			if(!Checks.esNulo(visitaDto.getIdVisitaBC())) {
				visita.setIdVisitaBC(visitaDto.getIdVisitaBC());
			}
			
			visitaDao.saveOrUpdate(visita);
			
			//Si Webcom nos envia el idSalesforce despues de actualizar la visita la asociaremos a su comunicacion de GENCAT
			if (!Checks.esNulo(visitaDto.getIdLeadSalesforce())) {
				gencatApi.updateVisitaComunicacion(visita.getActivo().getId(), visitaDto.getIdLeadSalesforce(), visita);
			}
			
		}

		return errorsList;
	}

	@Override
	public List<String> validateVisitaDeleteRequestData(VisitaDto visitaDto) {
		List<String> listaErrores = new ArrayList<String>();
		Visita visita = null;

		try {

			if (Checks.esNulo(visitaDto.getIdVisitaWebcom())) {
				listaErrores.add("El campo IdVisitaWebcom es nulo y es obligatorio.");

			} else if (Checks.esNulo(visitaDto.getIdVisitaRem())) {
				listaErrores.add("El campo IdVisitaRem es nulo y es obligatorio.");

			} else {
				visita = getVisitaByIdVisitaWebcomNumVisitaRem(visitaDto.getIdVisitaWebcom(),
						visitaDto.getIdVisitaRem());
				if (Checks.esNulo(visita)) {
					listaErrores.add("No existe en REM la visita con idVisitaWebcom: " + visitaDto.getIdVisitaWebcom()
							+ " e idVisitaRem: " + visitaDto.getIdVisitaRem());
				}
			}

		} catch (Exception e) {
			logger.error("error en validateVisitaDeleteRequestData", e);
			listaErrores.add("Ha ocurrido un error al validar los parámetros de la visita idVisitaWebcom: "
					+ visitaDto.getIdVisitaWebcom() + ". Traza: " + e.getMessage());
			return listaErrores;
		}

		return listaErrores;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	@Transactional(readOnly = false)
	public List<String> deleteVisita(VisitaDto visitaDto) {
		List<String> errorsList = new ArrayList();
		Visita visita = null;

		try {

			// ValidateDelete
			errorsList = validateVisitaDeleteRequestData(visitaDto);
			if (errorsList.isEmpty()) {
				visita = getVisitaByIdVisitaWebcomNumVisitaRem(visitaDto.getIdVisitaWebcom(),
						visitaDto.getIdVisitaRem());
				if (!Checks.esNulo(visita)) {
					visitaDao.delete(visita);
				} else {
					errorsList.add("No existe en REM la visita con idVisitaWebcom: " + visitaDto.getIdVisitaWebcom()
							+ " e idVisitaRem: " + visitaDto.getIdVisitaRem());
				}
			}

		} catch (Exception e) {
			logger.error(e);
			errorsList.add("Ha ocurrido un error en base de datos al eliminar la visita idVisitaWebcom: "
					+ visitaDto.getIdVisitaWebcom() + " e idVisitaRem: " + visitaDto.getIdVisitaRem() + ". Traza: "
					+ e.getMessage());
			return errorsList;
		}

		return errorsList;
	}

	@Override
	public DtoPage getListVisitasDetalle(DtoVisitasFilter dtoVisitasFilter) {
		Usuario usuarioLogeado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		return visitaDao.getListVisitasDetalle(dtoVisitasFilter, usuarioLogeado);
	}

	@Override
	public List<Visita> getListaVisitasOrdenada(DtoVisitasFilter dtoVisitasFilter) {
		List<Visita> lvisita = null;

		lvisita = visitaDao.getListaVisitasOrdenada(dtoVisitasFilter);

		return lvisita;
	}

	@Override
	@Transactional(readOnly = false)
	public ArrayList<Map<String, Object>> saveOrUpdateVisitas(List<VisitaDto> listaVisitaDto, JSONObject jsonFields)
			throws Exception {
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		VisitaDto visitaDto = null;
		Map<String, Object> map = null;
		HashMap<String, String> errorsList = null;
		Visita visita = null;
		for (int i = 0; i < listaVisitaDto.size(); i++) {

			errorsList = new HashMap<String, String>();
			map = new HashMap<String, Object>();
			visitaDto = listaVisitaDto.get(i);
			
			visita = this.getVisitaByIdVisitaWebcom(visitaDto.getIdVisitaWebcom());
			if (Checks.esNulo(visita)) {
				errorsList = this.saveVisita(visitaDto);
			} 
			else {
				errorsList = this.updateVisita(visita, visitaDto, jsonFields.getJSONArray("data").get(i));
			}

			boolean checkErrores = checkErroresControladosVisitas(errorsList);
			if (checkErrores) {
				if (visita == null || visita.getId() == null) {
					visita = this.getVisitaByIdVisitaWebcom(visitaDto.getIdVisitaWebcom());
				}
				if (visita != null) {
					map.put("idVisitaWebcom", visita.getIdVisitaWebcom());
					map.put("idVisitaRem", visita.getNumVisitaRem());
					if(errorsList.get("idCliente") != null) {
						map.put("idCliente", errorsList.get("idCliente"));
					}
					if(errorsList.get("idResponsable") != null) {
						map.put("idResponsable", errorsList.get("idResponsable"));
					}
				} else {
					map.put("idVisitaWebcom", "");
					map.put("idVisitaRem", "");
				}

				map.put("success", true);
			} else {
				map.put("idVisitaWebcom", visitaDto.getIdVisitaWebcom());
				map.put("idVisitaRem", visitaDto.getIdVisitaRem());
				map.put("success", false);
				map.put("invalidFields", errorsList);
			}
			listaRespuesta.add(map);

		}
		return listaRespuesta;
	}

	@Override
	public VBusquedaVisitasDetalle getVisitaDetalle(DtoVisitasFilter dtoVisitasFilter) {

		return visitaDao.getVisitaDetalle(dtoVisitasFilter);
	}
	
	@Override
	public void llamarServicioContactos(List<VisitaDto> listaVisitaDto, JSONObject jsonFields) throws Exception {
		VisitaDto visitaDto = null;
		Visita visita = null;
		String urlBase = null;
		String endpoint = null;
		for (int i = 0; i < listaVisitaDto.size(); i++) {
			visitaDto = listaVisitaDto.get(i);
			visita = this.getVisitaByIdVisitaWebcom(visitaDto.getIdVisitaWebcom());
			boolean esVisitaCaixaConIdVisitaBc = esVisitaCaixaConIdVisitaBc(visita);
			boolean esVisitaOrigenSaleforce = esVisitaOrigenSaleforce(visita);
			if(esVisitaCaixaConIdVisitaBc || esVisitaOrigenSaleforce) {
				//a lo mejor aqui hay que checkear mas cosas
			
				JSONObject result = null;	
				
				urlBase = appProperties.getProperty(REM3_URL);
				endpoint = urlBase + appProperties.getProperty(CONTACTOS_ENDPOINT) + "/" + visita.getNumVisitaRem();
				result = httpClient.processRequest(endpoint, "POST",null,"",30000,"UTF-8");
			}
		}
	}

	private boolean esVisitaOrigenSaleforce(Visita visita) {
		if(visita != null 
				&& visita.getPrescriptor() != null
				&& visita.getPrescriptor().getTipoProveedor() != null 
				&& visita.getPrescriptor().getTipoProveedor().getCodigo() != null 
				&& DDTipoProveedor.COD_SALESFORCE.equals(visita.getPrescriptor().getTipoProveedor().getCodigo())) {
			return true;
		}
		return false;
	}

	private boolean esVisitaCaixaConIdVisitaBc(Visita visita) {
		if(visita != null 
				&& visita.getIdVisitaBC() != null
				&& visita.getPrescriptor() != null
				&& visita.getPrescriptor().getTipoProveedor() != null 
				&& visita.getPrescriptor().getTipoProveedor().getCodigo() != null 
				&& DDTipoProveedor.COD_OFICINA_BANKIA.equals(visita.getPrescriptor().getTipoProveedor().getCodigo())) {
			return true;
		}
		return false;
	}
	
	private boolean checkErroresControladosVisitas(HashMap<String, String> errorsList) {
		
		if(!Checks.esNulo(errorsList) && errorsList.size() == 2
				&& errorsList.containsKey("idCliente")
				&& errorsList.containsKey("idResponsable")) {
			return true;
		}
		else if(!Checks.esNulo(errorsList) && errorsList.size() == 1
				&& (errorsList.containsKey("idCliente")
				|| errorsList.containsKey("idResponsable"))) {
			return true;
		}
		else if(!Checks.esNulo(errorsList) && errorsList.isEmpty()) {
			return true;
		}
		return false;
	}
	
	@Override
	public void checkReplicarClienteProveedor(ArrayList<Map<String,Object>> errorList) {
		for(Map<String, Object> map : errorList) {
			if(map.get("idCliente") != null) {
				interlocutorCaixaService.callReplicateClientAsync(Long.parseLong(map.get("idCliente").toString()), CaixaBcRestClient.ID_CLIENTE);
			}
			if(map.get("idResponsable") != null) {
				interlocutorCaixaService.callReplicateClientAsync(Long.parseLong(map.get("idResponsable").toString()), CaixaBcRestClient.ID_PROVEEDOR);
			}
		}
	}
}
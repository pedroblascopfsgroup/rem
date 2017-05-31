package es.pfsgroup.plugin.rem.oferta;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.security.UsuarioSecurityManager;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.agenda.adapter.NotificacionAdapter;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoOferta.ActivoOfertaPk;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoDetalleOferta;
import es.pfsgroup.plugin.rem.model.DtoGastoExpediente;
import es.pfsgroup.plugin.rem.model.DtoHonorariosOferta;
import es.pfsgroup.plugin.rem.model.DtoOfertantesOferta;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.TitularesAdicionalesOferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.oferta.dao.VOfertaActivoDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaTitularAdicionalDto;
import es.pfsgroup.plugin.rem.rest.dto.ResultadoInstanciaDecisionDto;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Service("ofertaManager")
public class OfertaManager extends BusinessOperationOverrider<OfertaApi> implements OfertaApi {

	protected static final Log logger = LogFactory.getLog(OfertaManager.class);

	// private static final String HONORARIO_TIPO_COLABORACION = "C";
	// private static final String HONORARIO_TIPO_PRESCRIPCION = "P";

	private static final Map<String, String> TIPO_HONORARIOS = new HashMap<String, String>() {

		private static final long serialVersionUID = -7097784886920388173L;

		{
			put(DDAccionGastos.CODIGO_COLABORACION, "C");
			put(DDAccionGastos.CODIGO_PRESCRIPCION, "P");
		}
	};

	@Resource
	MessageService messageServices;

	@Autowired
	private RestApi restApi;

	@Autowired
	private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;

	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaDao ofertaDao;

	@Autowired
	private VOfertaActivoDao vOfertaActivoDao;

	@Autowired
	private UpdaterStateApi updaterState;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private UsuarioSecurityManager usuarioSecurityManager;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private UvemManagerApi uvemManagerApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private NotificacionAdapter notificacionAdapter;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Override
	public String managerName() {
		return "ofertaManager";
	}

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();


	private Oferta oferta;

	@Override
	public Oferta getOfertaById(Long id) {
		Oferta oferta = null;

		try {

			oferta = ofertaDao.get(id);

		} catch (Exception ex) {
			logger.error("error en OfertasManager", ex);
		}

		return oferta;
	}

	@Override
	public Oferta getOfertaByIdOfertaWebcom(Long idOfertaWebcom) {
		Oferta oferta = null;
		List<Oferta> lista = null;
		OfertaDto ofertaDto = null;

		try {

			if (Checks.esNulo(idOfertaWebcom)) {
				throw new Exception("El parámetro idOfertaWebcom es obligatorio.");

			} else {

				ofertaDto = new OfertaDto();
				ofertaDto.setIdOfertaWebcom(idOfertaWebcom);

				lista = ofertaDao.getListaOfertas(ofertaDto);
				if (!Checks.esNulo(lista) && lista.size() > 0) {
					oferta = lista.get(0);
				}
			}

		} catch (Exception ex) {
			logger.error("error en OfertasManager", ex);
		}

		return oferta;
	}

	@Override
	public Oferta getOfertaByNumOfertaRem(Long numOfertaRem) {
		Oferta oferta = null;
		List<Oferta> lista = null;
		OfertaDto ofertaDto = null;

		try {

			if (Checks.esNulo(numOfertaRem)) {
				throw new Exception("El parámetro idOfertaRem es obligatorio.");

			} else {

				ofertaDto = new OfertaDto();
				ofertaDto.setIdOfertaRem(numOfertaRem);

				lista = ofertaDao.getListaOfertas(ofertaDto);
				if (!Checks.esNulo(lista) && lista.size() > 0) {
					oferta = lista.get(0);
				}
			}

		} catch (Exception ex) {
			logger.error("error en OfertasManager", ex);
		}

		return oferta;
	}

	@Override
	public Oferta getOfertaByIdOfertaWebcomNumOfertaRem(Long idOfertaWebcom, Long numOfertaRem) throws Exception {
		Oferta oferta = null;
		List<Oferta> lista = null;
		OfertaDto ofertaDto = null;
		int param = 0;
		if (Checks.esNulo(idOfertaWebcom)) {
			param++;

		} else {
			param++;
		}

		if (param > 0) {
			ofertaDto = new OfertaDto();
			if (numOfertaRem != null) {
				ofertaDto.setIdOfertaRem(numOfertaRem);
			}

			if (idOfertaWebcom != null) {
				ofertaDto.setIdOfertaWebcom(idOfertaWebcom);
			}

			lista = ofertaDao.getListaOfertas(ofertaDto);
			if (!Checks.esNulo(lista) && lista.size() > 0) {
				oferta = lista.get(0);
			}

		} else {
			throw new Exception("Faltan datos para el filtro");
		}
		return oferta;
	}

	
	@Override
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter,Usuario usuario) {

		return ofertaDao.getListOfertas(dtoOfertasFilter,usuario);
	}
	
	@Override
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter) {

		return ofertaDao.getListOfertas(dtoOfertasFilter);
	}

	@Override
	public List<VOfertasActivosAgrupacion> getListOfertasFromView(DtoOfertasFilter dtoOfertasFilter) {

		return vOfertaActivoDao.getListOfertasFromView(dtoOfertasFilter);
	}

	@Override
	public List<Oferta> getListaOfertas(OfertaDto ofertaDto) {
		List<Oferta> lista = null;

		try {

			lista = ofertaDao.getListaOfertas(ofertaDto);

		} catch (Exception ex) {
			logger.error("error en OfertasManager", ex);
		}

		return lista;
	}

	@Override
	public HashMap<String, String> validateOfertaPostRequestData(OfertaDto ofertaDto, Object jsonFields, Boolean alta) throws Exception {
		HashMap<String, String> errorsList = null;
		Oferta oferta = null;

		/*
		 * oferta = getOfertaByIdOfertaWebcom(ofertaDto.getIdOfertaWebcom()); if
		 * (Checks.esNulo(oferta) && !Checks.esNulo(ofertaDto.getIdOfertaRem())) {
		 * restApi.obtenerMapaErrores(errorsList,
		 * "idOfertaWebcom").add(RestApi.REST_MSG_UNKNOWN_KEY); }
		 */

		if (alta) {
			// Validación para el alta de ofertas
			errorsList = restApi.validateRequestObject(ofertaDto, TIPO_VALIDACION.INSERT);
		} else {
			errorsList = restApi.validateRequestObject(ofertaDto, TIPO_VALIDACION.UPDATE);
			// Validación para la actualización de ofertas
			oferta = getOfertaByIdOfertaWebcomNumOfertaRem(ofertaDto.getIdOfertaWebcom(), ofertaDto.getIdOfertaRem());
			if (Checks.esNulo(oferta)) {
				errorsList.put("idOfertaWebcom", RestApi.REST_MSG_UNKNOWN_KEY);
			}

			// Mirar si hace falta validar que no se pueda modificar la
			// oferta si ha pasado al comité
			if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getEstadoOferta()) && !oferta.getEstadoOferta().getCodigo().equalsIgnoreCase(DDEstadoOferta.CODIGO_PENDIENTE)) {
				errorsList.put("idOfertaWebcom", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdVisitaRem())) {
			Visita visita = (Visita) genericDao.get(Visita.class, genericDao.createFilter(FilterType.EQUALS, "numVisitaRem", ofertaDto.getIdVisitaRem()));
			if (Checks.esNulo(visita)) {
				errorsList.put("idVisitaRem", RestApi.REST_MSG_UNKNOWN_KEY);
			}

		}
		if (!Checks.esNulo(ofertaDto.getIdClienteRem())) {
			ClienteComercial cliente = (ClienteComercial) genericDao.get(ClienteComercial.class,
					genericDao.createFilter(FilterType.EQUALS, "idClienteRem", ofertaDto.getIdClienteRem()));
			if (Checks.esNulo(cliente)) {
				errorsList.put("idClienteRem", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdActivoHaya())) {
			Activo activo = (Activo) genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "numActivo", ofertaDto.getIdActivoHaya()));
			if (Checks.esNulo(activo)) {
				errorsList.put("idActivoHaya", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdUsuarioRemAccion())) {
			Usuario user = (Usuario) genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdUsuarioRemAccion()));
			if (Checks.esNulo(user)) {
				errorsList.put("idUsuarioRem", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		// Por ws no se envía nunca el estado de la oferta.
		/*
		 * if (!Checks.esNulo(ofertaDto.getCodEstadoOferta())) { // Perimetros: NO se pueden ACEPTAR
		 * Ofertas en activos que no // tengan condicion comercial en el perimetro // Se valida lo
		 * primero pq debe hacerse aunque el diccionario // tenga borrado logico del estado aceptada
		 * if (DDEstadoOferta.CODIGO_ACEPTADA.equals(ofertaDto.getCodEstadoOferta() )) {
		 * errorsList.put("codEstadoOferta", messageServices.getMessage(
		 * "oferta.validacion.errorMensaje.perimetroSinComercial")); } DDEstadoOferta estadoOfr =
		 * (DDEstadoOferta) genericDao.get(DDEstadoOferta.class,
		 * genericDao.createFilter(FilterType.EQUALS, "codigo", ofertaDto.getCodEstadoOferta())); if
		 * (Checks.esNulo(estadoOfr)) { errorsList.put("codEstadoOferta",
		 * RestApi.REST_MSG_UNKNOWN_KEY); } else { if
		 * (!ofertaDto.getCodEstadoOferta().equals(DDEstadoOferta. CODIGO_PENDIENTE) &&
		 * !ofertaDto.getCodEstadoOferta().equals(DDEstadoOferta. CODIGO_RECHAZADA)) {
		 * errorsList.put("codEstadoOferta", "Código de estado no permitido. Valores permitidos: "
		 * .concat(DDEstadoOferta.CODIGO_PENDIENTE).concat(",")
		 * .concat(DDEstadoOferta.CODIGO_RECHAZADA)); } } }
		 */
		if (!Checks.esNulo(ofertaDto.getCodTipoOferta())) {
			DDTipoOferta tipoOfr = (DDTipoOferta) genericDao.get(DDTipoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", ofertaDto.getCodTipoOferta()));
			if (Checks.esNulo(tipoOfr)) {
				errorsList.put("codTipoOferta", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdProveedorRemPrescriptor())) {
			ActivoProveedor pres = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
					genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", ofertaDto.getIdProveedorRemPrescriptor()));
			if (Checks.esNulo(pres)) {
				errorsList.put("idProveedorRemPrescriptor", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdProveedorRemCustodio())) {
			ActivoProveedor cust = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
					genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", ofertaDto.getIdProveedorRemCustodio()));
			if (Checks.esNulo(cust)) {
				errorsList.put("IdProveedorRemCustodio", RestApi.REST_MSG_UNKNOWN_KEY);
			}
			/*
			 * else { //el proveedor tiene que ser custodio if ((cust.getCustodio() != null &&
			 * !cust.getCustodio().equals(new Integer(1))) || cust.getCustodio() == null) {
			 * errorsList.put("IdProveedorRemCustodio", RestApi.REST_MSG_UNKNOWN_KEY); } }
			 */
		}
		if (!Checks.esNulo(ofertaDto.getIdProveedorRemResponsable())) {
			ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
					genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", ofertaDto.getIdProveedorRemResponsable()));
			if (Checks.esNulo(apiResp)) {
				errorsList.put("idProveedorRemResponsable", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdProveedorRemFdv())) {
			ActivoProveedor fdv = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
					genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", ofertaDto.getIdProveedorRemFdv()));
			if (Checks.esNulo(fdv)) {
				errorsList.put("idProveedorRemFdv", RestApi.REST_MSG_UNKNOWN_KEY);
			} else {
				if (fdv.getTipoProveedor() == null || !fdv.getTipoProveedor().getCodigo().equals(DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA)) {
					errorsList.put("idProveedorRemFdv", RestApi.REST_MSG_UNKNOWN_KEY);
				}
			}
		}
		if (!Checks.esNulo(ofertaDto.getTitularesAdicionales())) {
			for (int i = 0; i < ofertaDto.getTitularesAdicionales().size(); i++) {
				OfertaTitularAdicionalDto titDto = ofertaDto.getTitularesAdicionales().get(i);
				if (!Checks.esNulo(titDto)) {
					DDTipoDocumento tpd = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodTipoDocumento()));
					if (Checks.esNulo(tpd)) {
						errorsList.put("codTipoDocumento", RestApi.REST_MSG_UNKNOWN_KEY);
					}
				}
			}
		}

		return errorsList;
	}

	@Override
	@Transactional(readOnly = false)
	public HashMap<String, String> saveOferta(OfertaDto ofertaDto) throws Exception {
		Oferta oferta = null;
		HashMap<String, String> errorsList = null;

		// ValidateAlta
		errorsList = validateOfertaPostRequestData(ofertaDto, null, true);
		if (errorsList.isEmpty()) {

			oferta = new Oferta();
			beanUtilNotNull.copyProperties(oferta, ofertaDto);
			if (!Checks.esNulo(ofertaDto.getIdOfertaWebcom())) {
				oferta.setIdWebCom(ofertaDto.getIdOfertaWebcom());
			}
			oferta.setNumOferta(ofertaDao.getNextNumOfertaRem());
			if (!Checks.esNulo(ofertaDto.getImporteContraoferta())) {
				oferta.setImporteContraOferta(ofertaDto.getImporteContraoferta());
			}
			if (!Checks.esNulo(ofertaDto.getIdVisitaRem())) {
				Visita visita = (Visita) genericDao.get(Visita.class, genericDao.createFilter(FilterType.EQUALS, "numVisitaRem", ofertaDto.getIdVisitaRem()));
				if (!Checks.esNulo(visita)) {
					oferta.setVisita(visita);
				}
			}
			if (!Checks.esNulo(ofertaDto.getIdClienteRem())) {
				ClienteComercial cliente = (ClienteComercial) genericDao.get(ClienteComercial.class,
						genericDao.createFilter(FilterType.EQUALS, "idClienteRem", ofertaDto.getIdClienteRem()));
				if (!Checks.esNulo(cliente)) {
					oferta.setCliente(cliente);
				}
			}
			if (!Checks.esNulo(ofertaDto.getImporte())) {
				oferta.setImporteOferta(ofertaDto.getImporte());
			}
			if (!Checks.esNulo(ofertaDto.getIdActivoHaya())) {
				ActivoAgrupacion agrupacion = null;
				List<ActivoOferta> listaActOfr = new ArrayList<ActivoOferta>();
				List<ActivoAgrupacionActivo> listaAgrups = null;

				Activo activo = (Activo) genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "numActivo", ofertaDto.getIdActivoHaya()));
				if (!Checks.esNulo(activo)) {

					// Verificamos si el activo pertenece a una agrupación restringida
					DtoAgrupacionFilter dtoAgrupActivo = new DtoAgrupacionFilter();
					dtoAgrupActivo.setActId(activo.getId());
					dtoAgrupActivo.setTipoAgrupacion(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA);
					listaAgrups = activoAgrupacionActivoApi.getListActivosAgrupacion(dtoAgrupActivo);
					if (!Checks.esNulo(listaAgrups) && listaAgrups.size() > 0) {
						ActivoAgrupacionActivo agrAct = listaAgrups.get(0);
						if (!Checks.esNulo(agrAct) && !Checks.esNulo(agrAct.getAgrupacion())) {
							// Seteamos la agrupación restringida a la oferta
							agrupacion = agrAct.getAgrupacion();
							oferta.setAgrupacion(agrupacion);
						}
					}

					if (!Checks.esNulo(agrupacion)) {
						// Oferta sobre 1 lote restringido de n activos
						listaActOfr = buildListaActivoOferta(null, agrupacion, oferta);
					} else {
						// Oferta sobre 1 único activo
						listaActOfr = buildListaActivoOferta(activo, null, oferta);
					}

					// Seteamos la lista de ActivosOferta
					oferta.setActivosOferta(listaActOfr);

				}
			}

			if (!Checks.esNulo(ofertaDto.getIdUsuarioRemAccion())) {
				Usuario user = (Usuario) genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdUsuarioRemAccion()));
				if (!Checks.esNulo(user)) {
					oferta.setUsuarioAccion(user);
				}
			}
			if (!Checks.esNulo(ofertaDto.getCodTipoOferta())) {
				DDTipoOferta tipoOfr = (DDTipoOferta) genericDao.get(DDTipoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", ofertaDto.getCodTipoOferta()));
				if (!Checks.esNulo(tipoOfr)) {
					oferta.setTipoOferta(tipoOfr);
				}
			}
			if (!Checks.esNulo(ofertaDto.getIdProveedorRemPrescriptor())) {
				ActivoProveedor prescriptor = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", ofertaDto.getIdProveedorRemPrescriptor()));
				if (!Checks.esNulo(prescriptor)) {
					oferta.setPrescriptor(prescriptor);
				}
			}
			if (!Checks.esNulo(ofertaDto.getIdProveedorRemCustodio())) {
				ActivoProveedor cust = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", ofertaDto.getIdProveedorRemCustodio()));
				if (!Checks.esNulo(cust)) {
					oferta.setCustodio(cust);
				}
			}
			if (!Checks.esNulo(ofertaDto.getIdProveedorRemResponsable())) {
				ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", ofertaDto.getIdProveedorRemResponsable()));
				if (!Checks.esNulo(apiResp)) {
					oferta.setApiResponsable(apiResp);
				}
			}
			if (!Checks.esNulo(ofertaDto.getIdProveedorRemFdv())) {
				ActivoProveedor fdv = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", ofertaDto.getIdProveedorRemFdv()));
				if (!Checks.esNulo(fdv)) {
					oferta.setFdv(fdv);
				}
			}
			if (!Checks.esNulo(ofertaDto.getTitularesAdicionales())) {
				List<TitularesAdicionalesOferta> listaTit = new ArrayList<TitularesAdicionalesOferta>();

				for (int i = 0; i < ofertaDto.getTitularesAdicionales().size(); i++) {
					OfertaTitularAdicionalDto titDto = ofertaDto.getTitularesAdicionales().get(i);
					if (!Checks.esNulo(titDto)) {
						TitularesAdicionalesOferta titAdi = new TitularesAdicionalesOferta();
						titAdi.setNombre(titDto.getNombre());
						titAdi.setDocumento(titDto.getDocumento());
						titAdi.setOferta(oferta);
						Auditoria auditoria = Auditoria.getNewInstance();
						titAdi.setAuditoria(auditoria);
						titAdi.setTipoDocumento(
								(DDTipoDocumento) genericDao.get(DDTipoDocumento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodTipoDocumento())));
						listaTit.add(titAdi);
					}
				}
				oferta.setTitularesAdicionales(listaTit);

			}

			Long idOferta = ofertaDao.save(oferta);
			oferta.setId(idOferta);
			updateEstadoOferta(oferta, ofertaDto.getFechaAccion());
			this.updateStateDispComercialActivosByOferta(oferta);

		}
		return errorsList;

	}

	@Override
	@Transactional(readOnly = false)
	public HashMap<String, String> updateOferta(Oferta oferta, OfertaDto ofertaDto, Object jsonFields) throws Exception {
		HashMap<String, String> errorsList = null;
		// ValidateUpdate
		errorsList = validateOfertaPostRequestData(ofertaDto, jsonFields, false);
		if (errorsList.isEmpty()) {

			if (((JSONObject) jsonFields).containsKey("importeContraoferta")) {
				oferta.setImporteContraOferta(ofertaDto.getImporteContraoferta());
				ofertaDao.saveOrUpdate(oferta);

				// Actualizar honorarios para el nuevo importe de contraoferta.
				ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
				if (!Checks.esNulo(expedienteComercial)) {
					expedienteComercialApi.actualizarHonorariosPorExpediente(expedienteComercial.getId());
				}
			}

			updateEstadoOferta(oferta, ofertaDto.getFechaAccion());
			this.updateStateDispComercialActivosByOferta(oferta);
		}

		return errorsList;
	}

	private void updateEstadoOferta(Oferta oferta, Date fechaAccion) {

		Oferta ofertaAcepted = null;
		Boolean inLoteComercial = false;
		Boolean incompatible = false;

		UsuarioSecurity usuarioSecurity = usuarioSecurityManager.getByUsername(RestApi.REM_LOGGED_USER_USERNAME);
		restApi.doLogin(usuarioSecurity);

		List<ActivoOferta> listaActivoOferta = oferta.getActivosOferta();

		if (listaActivoOferta != null && listaActivoOferta.size() > 0) {
			ActivoOferta actOfr = listaActivoOferta.get(0);
			if (!Checks.esNulo(actOfr) && !Checks.esNulo(actOfr.getPrimaryKey().getActivo())) {
				// ofertaAcepted = getOfertaAceptadaByActivo(actOfr.getPrimaryKey().getActivo());
				ofertaAcepted = getOfertaAceptadaExpdteAprobado(actOfr.getPrimaryKey().getActivo());
			}
		}

		if (listaActivoOferta != null && listaActivoOferta.size() > 0) {
			for (ActivoOferta activoOferta : listaActivoOferta) {
				Activo act = activoOferta.getPrimaryKey().getActivo();
				if (!Checks.esNulo(act)) {

					// HREOS-1674 - Si 1 activo pertenece a un lote comercial, ésta debe crearse
					// siempre congelada.
					if (activoAgrupacionActivoDao.activoEnAgrupacionLoteComercial(act.getId())) {
						inLoteComercial = true;
					}

					// HREOS-1669 - Validar el tipo destino comercial
					if (!Checks.esNulo(act.getTipoComercializacion()) && !Checks.esNulo(oferta.getTipoOferta())) {
						String comercializacion = act.getTipoComercializacion().getCodigo();

						if ((DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())
								&& (!DDTipoComercializacion.CODIGO_VENTA.equals(comercializacion) && !DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(comercializacion)))
								|| (DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())
										&& (!DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(comercializacion)
												&& !DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(comercializacion)))) {
							incompatible = true;
						}
					}
				}
			}
		}

		if (!Checks.esNulo(ofertaAcepted) || inLoteComercial) {
			oferta.setEstadoOferta(genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_CONGELADA)));
		} else {
			oferta.setEstadoOferta(genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_PENDIENTE)));

		}

		oferta.setFechaAlta(fechaAccion);

		// Si el activo de la oferta no comercializable, vendido, no publicado
		// rechazamos la oferta
		if (listaActivoOferta != null && listaActivoOferta.size() > 0) {
			for (ActivoOferta activoOferta : listaActivoOferta) {
				Activo activo = activoOferta.getPrimaryKey().getActivo();
				if (incompatible || (activo.getEstadoPublicacion() != null && activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_NO_PUBLICADO))
						|| (activo.getSituacionComercial() != null && activo.getSituacionComercial().getCodigo().equals(DDSituacionComercial.CODIGO_VENDIDO))
						|| (activo.getSituacionComercial() != null && activo.getSituacionComercial().getCodigo().equals(DDSituacionComercial.CODIGO_NO_COMERCIALIZABLE))
						|| (activo.getSituacionComercial() != null && activo.getSituacionComercial().getCodigo().equals(DDSituacionComercial.CODIGO_TRASPASADO))) {
					oferta.setEstadoOferta(genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_RECHAZADA)));
				}

			}
		}

		if (oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_RECHAZADA)) {
			oferta.setFechaRechazoOferta(fechaAccion);
		}
		ofertaDao.saveOrUpdate(oferta);
		usuarioSecurity = usuarioSecurityManager.getByUsername(RestApi.REST_LOGGED_USER_USERNAME);
		restApi.doLogin(usuarioSecurity);
	}

	@Override
	public List<ActivoOferta> buildListaActivoOferta(Activo activo, ActivoAgrupacion agrupacion, Oferta oferta) throws Exception {
		List<ActivoOferta> listaActOfr = new ArrayList<ActivoOferta>();

		if (Checks.esNulo(oferta)) {
			throw new Exception("Parámetros incorrectos. La oferta es nulo.");

		} else if ((Checks.esNulo(activo) && Checks.esNulo(agrupacion)) || (!Checks.esNulo(activo) && !Checks.esNulo(agrupacion))) {
			throw new Exception("Parámetros incorrectos. Enviar un activo o una agrupación.");

		} else if (!Checks.esNulo(activo)) {
			ActivoOfertaPk pk = new ActivoOfertaPk();
			ActivoOferta activoOferta = new ActivoOferta();
			pk.setActivo(activo);
			pk.setOferta(oferta);

			activoOferta.setPrimaryKey(pk);
			activoOferta.setImporteActivoOferta(oferta.getImporteOferta());
			activoOferta.setPorcentajeParticipacion(Double.valueOf(100.00));
			listaActOfr.add(activoOferta);

		} else {
			// Mapa con los valores Tasacion/Aprobado venta de cada activo
			Map<String, Double> valoresTasacion = new HashMap<String, Double>();
			valoresTasacion = activoAgrupacionApi.asignarValoresTasacionAprobadoVenta(agrupacion.getActivos());

			if (!Checks.estaVacio(valoresTasacion)) {
				// En cada activo de la agrupacion se añade una oferta en la tabla ACT_OFR
				for (ActivoAgrupacionActivo activos : agrupacion.getActivos()) {

					ActivoOferta activoOferta = new ActivoOferta();
					ActivoOfertaPk pk = new ActivoOfertaPk();

					pk.setActivo(activos.getActivo());
					pk.setOferta(oferta);
					activoOferta.setPrimaryKey(pk);

					if (!Checks.estaVacio(valoresTasacion)) {
						String participacion = String
								.valueOf(activoAgrupacionApi.asignarPorcentajeParticipacionEntreActivos(activos, valoresTasacion, valoresTasacion.get("total")));
						activoOferta.setPorcentajeParticipacion(Double.parseDouble(participacion));
						activoOferta.setImporteActivoOferta((oferta.getImporteOferta() * Double.parseDouble(participacion)) / 100);
					}
					listaActOfr.add(activoOferta);
				}
			}
		}

		return listaActOfr;
	}

	@Override
	public DDEstadoOferta getDDEstadosOfertaByCodigo(String codigo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
		return genericDao.get(DDEstadoOferta.class, filtro);
	}

	@Override
	@Transactional
	public void updateStateDispComercialActivosByOferta(Oferta oferta) {
		if (oferta.getActivosOferta() != null && oferta.getActivosOferta().size() > 0) {
			for (ActivoOferta activoOferta : oferta.getActivosOferta()) {
				Activo activo = activoOferta.getPrimaryKey().getActivo();
				updaterState.updaterStateDisponibilidadComercialAndSave(activo);
			}
		}
	}

	// @Override
	// public Oferta trabajoToOferta(Trabajo trabajo) {
	// Oferta ofertaAceptada = null;
	// Activo activo = trabajo.getActivo();
	// if (!Checks.esNulo(activo)) {
	// ofertaAceptada = getOfertaAceptadaByActivo(activo);
	// }
	// return ofertaAceptada;
	// }

	@Override
	public Oferta trabajoToOferta(Trabajo trabajo) {
		ExpedienteComercial expediente = expedienteComercialApi.findOneByTrabajo(trabajo);

		return expediente.getOferta();
	}

	@Override
	public List<Oferta> trabajoToOfertas(Trabajo trabajo) {
		List<Oferta> listaOfertas = new ArrayList<Oferta>();
		Activo activo = trabajo.getActivo();
		if (!Checks.esNulo(activo)) {
			for (ActivoOferta actofr : activo.getOfertas()) {
				listaOfertas.add(actofr.getPrimaryKey().getOferta());
			}
		}
		return listaOfertas;
	}

	@Override
	public Boolean rechazarOferta(Oferta oferta) {
		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_RECHAZADA);
			DDEstadoOferta estado = genericDao.get(DDEstadoOferta.class, filtro);
			oferta.setEstadoOferta(estado);
			genericDao.save(Oferta.class, oferta);

		} catch (Exception e) {
			logger.error("error en OfertasManager", e);
			return false;
		}
		return true;

	}

	
	@Transactional(readOnly = false)
	@Override
	public void descongelarOfertas(ExpedienteComercial expediente) throws Exception{
		DDEstadoOferta estado = null;
		Filter filtro = null;
		
		if(Checks.esNulo(expediente)){
			throw new Exception("Parámetros incorrectos. El expediente es nulo.");
		}else{
			
			// Descongela el resto de ofertas del activo
			List<Oferta> listaOfertas = this.trabajoToOfertas(expediente.getTrabajo());
			if (!Checks.esNulo(listaOfertas)) {

				for(Oferta oferta : listaOfertas){
					if((DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo()))){
		
						ExpedienteComercial exp = expedienteComercialApi.findOneByOferta(oferta);
						
						//HREOS-1937 - Si tiene expediente poner oferta ACEPTADA. Si no tiene poner oferta PENDIENTE
						if (!Checks.esNulo(exp)) {
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_ACEPTADA);
						}else{
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_PENDIENTE);
						}
						
						estado = genericDao.get(DDEstadoOferta.class, filtro);
						oferta.setEstadoOferta(estado);
						genericDao.save(Oferta.class, oferta);
						
						if (!Checks.esNulo(exp) && !Checks.esNulo(exp.getTrabajo())) {										
							List<ActivoTramite> tramites = activoTramiteApi.getTramitesActivoTrabajoList(exp.getTrabajo().getId());
							if (!Checks.estaVacio(tramites)) {
								Set<TareaActivo> tareasTramite = tramites.get(0).getTareas();
								for (TareaActivo tarea : tareasTramite) {
									// Si se ha borrado sin acabarse, al descongelar se vuelven a mostrar.
									if (tarea.getAuditoria().isBorrado() && Checks.esNulo(tarea.getFechaFin())) {
										tarea.getAuditoria().setBorrado(false);
									}
								}
							}	
						}
					}
				}
			}
		}
	}
	
	
	@Transactional(readOnly = false)
	@Override
	public void congelarOfertasPendientes(ExpedienteComercial expediente) throws Exception{
		DDEstadoOferta estado = null;
		Filter filtro = null;
		
		if(Checks.esNulo(expediente)){
			throw new Exception("Parámetros incorrectos. El expediente es nulo.");
		}else{
			
			// Congela el resto de ofertas del activo
			List<Oferta> listaOfertas = this.trabajoToOfertas(expediente.getTrabajo());
			if (!Checks.esNulo(listaOfertas)) {
				
				for (Oferta ofr : listaOfertas) {
					if(!ofr.getId().equals(expediente.getOferta().getId()) && !DDEstadoOferta.CODIGO_RECHAZADA.equals(ofr.getEstadoOferta().getCodigo())){
						
						ExpedienteComercial exp = expedienteComercialApi.findOneByOferta(ofr);
						
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",DDEstadoOferta.CODIGO_CONGELADA);
						estado = genericDao.get(DDEstadoOferta.class, filtro);
						ofr.setEstadoOferta(estado);
						genericDao.save(Oferta.class, ofr);
						
						
						if (!Checks.esNulo(exp) && !Checks.esNulo(exp.getTrabajo())) {
							List<ActivoTramite> tramites = activoTramiteApi.getTramitesActivoTrabajoList(exp.getTrabajo().getId());
							ActivoTramite tramite = tramites.get(0);

							Set<TareaActivo> tareasTramite = tramite.getTareas();
							// Al congelar, borramos las tareas que estuvieran pendientes para que no se muestren.
							for (TareaActivo tarea : tareasTramite) {
								tarea.getAuditoria().setBorrado(true);
							}
						}
					}
				}
			}
		}
	}
	
		

	@Override
	public Boolean congelarOferta(Oferta oferta) {
		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_CONGELADA);
			DDEstadoOferta estado = genericDao.get(DDEstadoOferta.class, filtro);
			oferta.setEstadoOferta(estado);
			genericDao.save(Oferta.class, oferta);

			ExpedienteComercial expediente = expedienteComercialApi.findOneByOferta(oferta);
			if (!Checks.esNulo(expediente)) {
				Trabajo trabajo = expediente.getTrabajo();
				List<ActivoTramite> tramites = activoTramiteApi.getTramitesActivoTrabajoList(trabajo.getId());
				ActivoTramite tramite = tramites.get(0);

				Set<TareaActivo> tareasTramite = tramite.getTareas();
				for (TareaActivo tarea : tareasTramite) {
					tarea.getAuditoria().setBorrado(true);
				}
			}

		} catch (Exception e) {
			logger.error("error en OfertasManager", e);
			return false;
		}
		return true;
	}

	@Override
	public Oferta tareaExternaToOferta(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = null;
		Trabajo trabajo = trabajoApi.tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			ExpedienteComercial expediente = expedienteComercialApi.findOneByTrabajo(trabajo);
			if (!Checks.esNulo(expediente)) {
				ofertaAceptada = expediente.getOferta();
			}
		}
		return ofertaAceptada;
	}

	@Override
	public Oferta getOfertaAceptadaByActivo(Activo activo) {
		List<ActivoOferta> listaOfertas = activo.getOfertas();

		for (ActivoOferta activoOferta : listaOfertas) {
			Oferta oferta = activoOferta.getPrimaryKey().getOferta();
			if (DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) return oferta;
		}
		return null;
	}

	@Override
	public Oferta getOfertaAceptadaExpdteAprobado(Activo activo) {
		List<ActivoOferta> listaOfertas = activo.getOfertas();

		if (!Checks.estaVacio(listaOfertas)) {
			for (ActivoOferta activoOferta : listaOfertas) {
				Oferta oferta = activoOferta.getPrimaryKey().getOferta();
				if (DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
					ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
					if (DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.ALQUILADO.equals(expediente.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.EN_DEVOLUCION.equals(expediente.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.BLOQUEO_ADM.equals(expediente.getEstado().getCodigo()))
						return oferta;
				}

			}
		}

		return null;
	}

	@Override
	public boolean checkDerechoTanteo(Trabajo trabajo) {
		Oferta ofertaAceptada = trabajoToOferta(trabajo);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			if (!Checks.esNulo(expediente))
				if (!Checks.esNulo(expediente.getCondicionante())) return (Integer.valueOf(1).equals(expediente.getCondicionante().getSujetoTanteoRetracto()));
		}
		return false;
	}

	@Override
	public boolean checkDerechoTanteo(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			if (!Checks.esNulo(expediente))
				if (!Checks.esNulo(expediente.getCondicionante())) return (Integer.valueOf(1).equals(expediente.getCondicionante().getSujetoTanteoRetracto()));
		}
		return false;
	}

	@Override
	public boolean checkDeDerechoTanteo(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			if (!Checks.esNulo(ofertaAceptada.getDesdeTanteo())) {
				return ofertaAceptada.getDesdeTanteo();
			}
		}
		return false;
	}

	@Override
	public boolean checkReserva(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			if (!Checks.esNulo(expediente))
				if (!Checks.esNulo(expediente.getCondicionante())) return (Integer.valueOf(1).equals(expediente.getCondicionante().getSolicitaReserva()));
		}
		return false;
	}

	@Override
	public boolean checkReserva(Oferta ofertaAceptada) {
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			if (!Checks.esNulo(expediente))
				if (!Checks.esNulo(expediente.getCondicionante())) return (Integer.valueOf(1).equals(expediente.getCondicionante().getSolicitaReserva()));
		}
		return false;
	}

	@Override
	public boolean checkRiesgoReputacional(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			return (Integer.valueOf(0).equals(expediente.getRiesgoReputacional()));
		}
		return false;
	}

	@Override
	public boolean checkImporte(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			return (!Checks.esNulo(ofertaAceptada.getImporteOferta()));
		}
		return false;
	}

	@Override
	public boolean checkCompradores(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			List<CompradorExpediente> listaCex = expediente.getCompradores();
			Double total = new Double(0);
			for (CompradorExpediente cex : listaCex) {
				total += cex.getPorcionCompra();
			}
			return total.equals(new Double(100));
			// return (!Checks.estaVacio(expediente.getCompradores()));
		}
		return false;
	}

	@Override
	public boolean checkConflictoIntereses(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			return (Integer.valueOf(0).equals(expediente.getConflictoIntereses()));
		}
		return false;
	}

	@Override
	@Transactional(readOnly = false)
	public ArrayList<Map<String, Object>> saveOrUpdateOfertas(List<OfertaDto> listaOfertaDto, JSONObject jsonFields) throws Exception {
		Map<String, Object> map = null;
		OfertaDto ofertaDto = null;
		Oferta oferta = null;
		HashMap<String, String> errorsList = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < listaOfertaDto.size(); i++) {

			Oferta ofr = null;
			map = new HashMap<String, Object>();
			ofertaDto = listaOfertaDto.get(i);

			oferta = this.getOfertaByIdOfertaWebcom(ofertaDto.getIdOfertaWebcom());
			if (Checks.esNulo(oferta)) {
				errorsList = this.saveOferta(ofertaDto);

			} else {
				errorsList = this.updateOferta(oferta, ofertaDto, jsonFields.getJSONArray("data").get(i));

			}

			if (!Checks.esNulo(errorsList) && errorsList.isEmpty()) {
				ofr = this.getOfertaByIdOfertaWebcom(ofertaDto.getIdOfertaWebcom());
				map.put("idOfertaWebcom", ofr.getIdWebCom());
				map.put("idOfertaRem", ofr.getNumOferta());
				map.put("success", true);
			} else {
				map.put("idOfertaWebcom", ofertaDto.getIdOfertaWebcom());
				map.put("idOfertaRem", ofertaDto.getIdOfertaRem());
				map.put("success", false);
				map.put("invalidFields", errorsList);
			}
			listaRespuesta.add(map);

		}
		return listaRespuesta;
	}

	@Override
	public boolean checkComiteSancionador(TareaExterna tareaExterna) {
		Oferta oferta = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(oferta)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
			if (!Checks.esNulo(expediente)) {
				if (!Checks.esNulo(expediente.getComiteSancion())) {
					return true;
				}
			}
		}
		return false;
	}

	@Override
	public boolean checkAtribuciones(TareaExterna tareaExterna) {
		Oferta oferta = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(oferta)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
			if (!Checks.esNulo(expediente)) {
				if (!Checks.esNulo(expediente.getComiteSancion())) {
					String codigoComiteSancion = expediente.getComiteSancion().getCodigo();
					if (DDComiteSancion.CODIGO_HAYA_CAJAMAR.equals(codigoComiteSancion) || DDComiteSancion.CODIGO_HAYA_SAREB.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_PLATAFORMA.equals(codigoComiteSancion))
						return true;
				} else {
					if (trabajoApi.checkBankia(tareaExterna)) {
						String codigoComite = null;
						try {
							codigoComite = expedienteComercialApi.consultarComiteSancionador(expediente.getId());
						} catch (Exception e) {
							e.printStackTrace();
						}
						if (DDComiteSancion.CODIGO_PLATAFORMA.equals(codigoComite)) return true;
					}
				}
			}
		}
		return false;
	}

	@Override
	public boolean checkAtribuciones(Trabajo trabajo) {
		Oferta oferta = trabajoToOferta(trabajo);
		if (!Checks.esNulo(oferta)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
			if (!Checks.esNulo(expediente)) {
				if (!Checks.esNulo(expediente.getComiteSancion())) {
					String codigoComiteSancion = expediente.getComiteSancion().getCodigo();
					if (DDComiteSancion.CODIGO_HAYA_CAJAMAR.equals(codigoComiteSancion) || DDComiteSancion.CODIGO_HAYA_SAREB.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_PLATAFORMA.equals(codigoComiteSancion))
						return true;
				} else {
					if (trabajoApi.checkBankia(trabajo)) {
						String codigoComite = null;
						try {
							codigoComite = expedienteComercialApi.consultarComiteSancionador(expediente.getId());
						} catch (Exception e) {
							logger.error("error en OfertasManager", e);
						}
						if (DDComiteSancion.CODIGO_PLATAFORMA.equals(codigoComite)) return true;
					}
				}
			}
		}
		return false;
	}

	@Override
	public boolean altaComite(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		Long porcentajeImpuesto = null;
		if (!Checks.esNulo(expediente.getCondicionante())) {
			if (!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
				// porcentajeImpuesto =
				// Long.parseLong(String.format("%.0f",expediente.getCondicionante().getTipoAplicable()));
				porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable().longValue();
			} else {
				return false;
			}
		}

		try {
			InstanciaDecisionDto instanciaDecisionDto = expedienteComercialApi.expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto);
			ResultadoInstanciaDecisionDto resultadoDto = uvemManagerApi.altaInstanciaDecision(instanciaDecisionDto);
			String codigoComite = resultadoDto.getCodigoComite();
			DDComiteSancion comite = expedienteComercialApi.comiteSancionadorByCodigo(codigoComite);
			expediente.setComiteSancion(comite);
			genericDao.save(ExpedienteComercial.class, expediente);

			return true;
		} catch (Exception e) {
			logger.error("Error en el alta de comite.", e);
			return false;
		}

	}

	@Override
	public boolean ratificacionComite(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		Long porcentajeImpuesto = null;
		if (!Checks.esNulo(expediente.getCondicionante())) {
			if (!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
				// porcentajeImpuesto =
				// Long.parseLong(String.format("%.0f",expediente.getCondicionante().getTipoAplicable()));
				porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable().longValue();
			} else {
				return false;
			}
		}

		try {
			InstanciaDecisionDto instanciaDecisionDto = expedienteComercialApi.expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto);
			uvemManagerApi.modificarInstanciaDecision(instanciaDecisionDto);
			return true;
		} catch (Exception e) {
			logger.error("error en OfertasManager", e);
			return false;
		}

	}

	@Override
	public String altaComiteProcess(TareaExterna tareaExterna) {

		try {

			Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			Long porcentajeImpuesto = null;
			if (!Checks.esNulo(expediente.getCondicionante())) {
				if (!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
					// porcentajeImpuesto =
					// Long.parseLong(String.format("%.0f",expediente.getCondicionante().getTipoAplicable()));
					porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable().longValue();
				} else {
					logger.debug("Datos insuficientes para dar de alta un comité");
					throw new JsonViewerException("No ha sido posible realizar la operación");
				}
			}

			InstanciaDecisionDto instanciaDecisionDto = expedienteComercialApi.expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto);
			ResultadoInstanciaDecisionDto resultadoDto = uvemManagerApi.altaInstanciaDecision(instanciaDecisionDto);
			String codigoComite = resultadoDto.getCodigoComite();
			DDComiteSancion comite = expedienteComercialApi.comiteSancionadorByCodigo(codigoComite);
			expediente.setComiteSancion(comite);
			genericDao.save(ExpedienteComercial.class, expediente);

			return null;
		} catch (JsonViewerException jve) {
			return "Error alta comité: " + jve.getMessage();
		} catch (Exception e) {
			logger.error("error en OfertasManager", e);
			return "No ha sido posible realizar la operación";
		}

	}

	@Override
	public String ratificacionComiteProcess(TareaExterna tareaExterna) {

		try {

			Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			Long porcentajeImpuesto = null;
			if (!Checks.esNulo(expediente.getCondicionante())) {
				if (!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
					// porcentajeImpuesto =
					// Long.parseLong(String.format("%.0f",expediente.getCondicionante().getTipoAplicable()));
					porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable().longValue();
				} else {
					logger.debug("Datos insuficientes para ratificar comité");
					throw new JsonViewerException("No ha sido posible realizar la operación");
				}
			}

			InstanciaDecisionDto instanciaDecisionDto = expedienteComercialApi.expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto);
			uvemManagerApi.modificarInstanciaDecision(instanciaDecisionDto);
			return null;
		} catch (JsonViewerException jve) {
			return "Error ratificación comité: " + jve.getMessage();
		} catch (Exception e) {
			logger.error("error en OfertasManager", e);
			return "No ha sido posible realizar la operación";
		}

	}

	@Override
	public boolean checkPoliticaCorporativa(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		if (Checks.esNulo(expediente.getConflictoIntereses()) || Checks.esNulo(expediente.getRiesgoReputacional()))
			return false;
		else if ((expediente.getConflictoIntereses() == 1) || (expediente.getRiesgoReputacional() == 1))
			return false;
		else
			return true;
	}

	@Override
	public boolean checkPosicionamiento(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		if (!Checks.estaVacio(expediente.getPosicionamientos()))
			return true;
		else
			return false;
	}

	@Override
	public DtoDetalleOferta getDetalleOfertaById(Long idOferta) {
		DtoDetalleOferta dtoResponse = new DtoDetalleOferta();
		
		if (!Checks.esNulo(idOferta)) {

			Oferta oferta = this.getOfertaById(idOferta);
	
			if (!Checks.esNulo(oferta)) {
				dtoResponse.setNumOferta(oferta.getNumOferta().toString());
				if (!Checks.esNulo(oferta.getVisita())) {
					dtoResponse.setNumVisitaRem(oferta.getVisita().getNumVisitaRem().toString());
				}
				if (!Checks.esNulo(oferta.getIntencionFinanciar())) {
					dtoResponse.setIntencionFinanciar(oferta.getIntencionFinanciar().equals(1) ? "Si" : "No");
				}
				if (!Checks.esNulo(oferta.getVisita())) {
					dtoResponse.setProcedenciaVisita(oferta.getVisita().getProcendencia());
				}
			}
		}

		return dtoResponse;
	}

	@Override
	public List<DtoOfertantesOferta> getOfertantesByOfertaId(Long idOferta) {
		List<DtoOfertantesOferta> listaOfertantes = new ArrayList<DtoOfertantesOferta>();

		if (!Checks.esNulo(idOferta)) {

			Filter filterOfertaID = genericDao.createFilter(FilterType.EQUALS, "id", idOferta);
			Oferta oferta = genericDao.get(Oferta.class, filterOfertaID);
			if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getCliente())) {
				DtoOfertantesOferta dto = new DtoOfertantesOferta();
				if (!Checks.esNulo(oferta.getCliente().getTipoDocumento())) {
					dto.setTipoDocumento(oferta.getCliente().getTipoDocumento().getCodigo());
				}
				dto.setNumDocumento(oferta.getCliente().getDocumento());
				dto.setNombre(oferta.getCliente().getNombreCompleto());
				dto.setOfertaID(String.valueOf(oferta.getId()));
				dto.setId(String.valueOf(oferta.getCliente().getId()+"c"));
				listaOfertantes.add(dto);
			}
	
			Filter filterTitularOfertaID = genericDao.createFilter(FilterType.EQUALS, "oferta.id", idOferta);
			List<TitularesAdicionalesOferta> titularesAdicionales = genericDao.getList(TitularesAdicionalesOferta.class, filterTitularOfertaID);
			if (!Checks.estaVacio(titularesAdicionales)) {
				for (TitularesAdicionalesOferta titularAdicional : titularesAdicionales) {
					DtoOfertantesOferta dto = new DtoOfertantesOferta();
					if (!Checks.esNulo(titularAdicional.getTipoDocumento())) {
						dto.setTipoDocumento(titularAdicional.getTipoDocumento().getCodigo());
					}
					dto.setNumDocumento(titularAdicional.getDocumento());
					dto.setNombre(titularAdicional.getNombre());
					dto.setOfertaID(String.valueOf(oferta.getId()));
					dto.setId(String.valueOf(titularAdicional.getId()+"t"));
					listaOfertantes.add(dto);
				}
			}
		}

		return listaOfertantes;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateOfertantesByOfertaId(DtoOfertantesOferta dtoOfertantesOferta) {

		if (Checks.esNulo(dtoOfertantesOferta.getId())) {
			return false;
		}

		if(dtoOfertantesOferta.getId().contains("c")) {
			dtoOfertantesOferta.setId(dtoOfertantesOferta.getId().replace("c",""));
			Filter filterClienteID = genericDao.createFilter(FilterType.EQUALS, "id",
					Long.parseLong(dtoOfertantesOferta.getId()));
			ClienteComercial cliente = genericDao.get(ClienteComercial.class, filterClienteID);
			if (!Checks.esNulo(cliente)) {
				if(!Checks.esNulo(dtoOfertantesOferta.getTipoDocumento())) {
					DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoDocumento.class, dtoOfertantesOferta.getTipoDocumento());
				
					cliente.setTipoDocumento(tipoDocumento);
				}
				if(!Checks.esNulo(dtoOfertantesOferta.getNumDocumento())) {
					cliente.setDocumento(dtoOfertantesOferta.getNumDocumento());
				}
				genericDao.save(ClienteComercial.class,cliente);
			}
		}
		else if(dtoOfertantesOferta.getId().contains("t")) {
			dtoOfertantesOferta.setId(dtoOfertantesOferta.getId().replace("t",""));
			Filter filterTitularOfertaID = genericDao.createFilter(FilterType.EQUALS, "id",
					Long.parseLong(dtoOfertantesOferta.getId()));
			TitularesAdicionalesOferta titular = genericDao.get(TitularesAdicionalesOferta.class, filterTitularOfertaID);
			if (!Checks.esNulo(titular)) {
				if(!Checks.esNulo(dtoOfertantesOferta.getTipoDocumento())) {
					DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoDocumento.class, dtoOfertantesOferta.getTipoDocumento());
				
					titular.setTipoDocumento(tipoDocumento);
				}
				if(!Checks.esNulo(dtoOfertantesOferta.getNumDocumento())) {
					titular.setDocumento(dtoOfertantesOferta.getNumDocumento());
				}
				genericDao.save(TitularesAdicionalesOferta.class,titular);
			}
		}
		return true;
	}
	
	@Override
	public List<DtoHonorariosOferta> getHonorariosByOfertaId(DtoHonorariosOferta dtoHonorariosOferta) {

		List<DtoHonorariosOferta> listaHonorarios = new ArrayList<DtoHonorariosOferta>();

		/*
		 * if (Checks.esNulo(dtoHonorariosOferta.getOfertaID())) { return listaHonorarios; } //
		 * Obtener la oferta y comprobar su estado, si el estado de la oferta es // aceptado obtener
		 * un listado de gastos expediente. Si no existen // expediente asociado a la oferta
		 * calcular los gastos. Filter filterOfertaID = genericDao.createFilter(FilterType.EQUALS,
		 * "id", Long.parseLong(dtoHonorariosOferta.getOfertaID())); Oferta oferta =
		 * genericDao.get(Oferta.class, filterOfertaID); if (!Checks.esNulo(oferta)) { if
		 * (!Checks.esNulo(oferta.getEstadoOferta()) &&
		 * oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_ACEPTADA)) {
		 * List<GastosExpediente> gastosExp = genericDao.getList(GastosExpediente.class,
		 * genericDao.createFilter(FilterType.EQUALS, "expediente.oferta.id", oferta.getId())); if
		 * (!Checks.estaVacio(gastosExp)) { for (GastosExpediente gastoExp : gastosExp) {
		 * DtoHonorariosOferta dto = new DtoHonorariosOferta();
		 * dto.setId(gastoExp.getId().toString()); if (!Checks.esNulo(gastoExp.getAccionGastos())) {
		 * dto.setTipoComision(gastoExp.getAccionGastos().getDescripcion()); } if
		 * (!Checks.esNulo(gastoExp.getTipoProveedor())) {
		 * dto.setTipoProveedor(gastoExp.getTipoProveedor().getDescripcion()); } if
		 * (!Checks.esNulo(gastoExp.getProveedor())) {
		 * dto.setNombre(gastoExp.getProveedor().getNombreComercial());
		 * dto.setIdProveedor(gastoExp.getProveedor().getCodigoProveedorRem().toString()); } if
		 * (!Checks.esNulo(gastoExp.getTipoCalculo())) {
		 * dto.setTipoCalculo(gastoExp.getTipoCalculo().getDescripcion()); } if
		 * (!Checks.esNulo(gastoExp.getImporteCalculo())) {
		 * dto.setImporteCalculo(gastoExp.getImporteCalculo().toString()); } if
		 * (!Checks.esNulo(gastoExp.getImporteFinal())) {
		 * dto.setHonorarios(gastoExp.getImporteFinal().toString()); } listaHonorarios.add(dto); } }
		 * } else { // Primera fila honorario de colaboracion. DtoHonorariosOferta dtoColaboracion =
		 * new DtoHonorariosOferta(); DDAccionGastos accionGastoC = (DDAccionGastos)
		 * utilDiccionarioApi .dameValorDiccionarioByCod(DDAccionGastos.class,
		 * DDAccionGastos.CODIGO_COLABORACION); if (!Checks.esNulo(accionGastoC)) {
		 * dtoColaboracion.setTipoComision(accionGastoC.getDescripcion()); } if
		 * (!Checks.esNulo(oferta.getFdv())) { if
		 * (!Checks.esNulo(oferta.getFdv().getTipoProveedor())) {
		 * dtoColaboracion.setTipoProveedor(oferta.getFdv().getTipoProveedor().getDescripcion()); }
		 * dtoColaboracion.setNombre(oferta.getFdv().getNombreComercial());
		 * dtoColaboracion.setIdProveedor(oferta.getFdv().getCodigoProveedorRem().toString()); }
		 * else if (!Checks.esNulo(oferta.getCustodio())) { if
		 * (!Checks.esNulo(oferta.getCustodio().getTipoProveedor())) {
		 * dtoColaboracion.setTipoProveedor(oferta.getCustodio().getTipoProveedor().getDescripcion()
		 * ); } dtoColaboracion.setNombre(oferta.getCustodio().getNombreComercial());
		 * dtoColaboracion.setIdProveedor(oferta.getCustodio().getCodigoProveedorRem().toString());
		 * } DDTipoCalculo tipoCalculoC = (DDTipoCalculo) utilDiccionarioApi
		 * .dameValorDiccionarioByCod(DDTipoCalculo.class, DDTipoCalculo.TIPO_CALCULO_PORCENTAJE);
		 * if (!Checks.esNulo(tipoCalculoC)) {
		 * dtoColaboracion.setTipoCalculo(tipoCalculoC.getDescripcion()); } BigDecimal resultadoC =
		 * ofertaDao.getImporteCalculo(oferta.getId(), OfertaManager.HONORARIO_TIPO_COLABORACION);
		 * if (!Checks.esNulo(resultadoC)) { Double calculoImporteC = resultadoC.doubleValue();
		 * dtoColaboracion.setImporteCalculo(calculoImporteC.toString()); Activo activo =
		 * genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "id",
		 * oferta.getActivoPrincipal().getId())); if (!Checks.esNulo(activo)) { ActivoTasacion
		 * tasacion = activoApi.getTasacionMasReciente(activo); if (!Checks.esNulo(tasacion)) {
		 * Double tasacionFin = tasacion.getImporteTasacionFin(); Double result = (tasacionFin *
		 * calculoImporteC / 100); dtoColaboracion.setHonorarios(String.format("%.2f", result)); } }
		 * } else { // Si el importe calculo está vacío mostrar 'Sin // Honorarios'.
		 * dtoColaboracion.setTipoCalculo("-"); dtoColaboracion.setHonorarios("Sin Honorarios"); }
		 * listaHonorarios.add(dtoColaboracion); // Segunda fila honorario de colaboracion.
		 * DtoHonorariosOferta dtoPrescripcion = new DtoHonorariosOferta(); DDAccionGastos
		 * accionGastoP = (DDAccionGastos) utilDiccionarioApi
		 * .dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_PRESCRIPCION); if
		 * (!Checks.esNulo(accionGastoP)) {
		 * dtoPrescripcion.setTipoComision(accionGastoP.getDescripcion()); } if
		 * (!Checks.esNulo(oferta.getPrescriptor())) { if
		 * (!Checks.esNulo(oferta.getPrescriptor().getTipoProveedor())) {
		 * dtoPrescripcion.setTipoProveedor(oferta.getPrescriptor().getTipoProveedor().
		 * getDescripcion()); }
		 * dtoPrescripcion.setNombre(oferta.getPrescriptor().getNombreComercial());
		 * dtoPrescripcion.setIdProveedor(oferta.getPrescriptor().getCodigoProveedorRem().toString()
		 * ); } DDTipoCalculo tipoCalculoP = (DDTipoCalculo) utilDiccionarioApi
		 * .dameValorDiccionarioByCod(DDTipoCalculo.class, DDTipoCalculo.TIPO_CALCULO_PORCENTAJE);
		 * if (!Checks.esNulo(tipoCalculoP)) {
		 * dtoPrescripcion.setTipoCalculo(tipoCalculoP.getDescripcion()); } BigDecimal resultadoP =
		 * ofertaDao.getImporteCalculo(oferta.getId(), OfertaManager.HONORARIO_TIPO_PRESCRIPCION);
		 * if (!Checks.esNulo(resultadoP)) { Double calculoImporteP = resultadoP.doubleValue();
		 * dtoPrescripcion.setImporteCalculo(calculoImporteP.toString()); Activo activo =
		 * genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "id",
		 * oferta.getActivoPrincipal().getId())); if (!Checks.esNulo(activo)) { ActivoTasacion
		 * tasacion = activoApi.getTasacionMasReciente(activo); if (!Checks.esNulo(tasacion)) {
		 * Double tasacionFin = tasacion.getImporteTasacionFin(); Double result = (tasacionFin *
		 * calculoImporteP / 100); dtoPrescripcion.setHonorarios(String.format("%.2f", result)); } }
		 * } else { // Si el importe calculo está vacío mostrar 'Sin // Honorarios'.
		 * dtoPrescripcion.setImporteCalculo("-"); dtoPrescripcion.setHonorarios("Sin Honorarios");
		 * } listaHonorarios.add(dtoPrescripcion); } }
		 */

		return listaHonorarios;
	}

	@Override
	public List<DtoGastoExpediente> getHonorariosActivoByOfertaId(Long idActivo, Long idOferta) {

		String[] acciones = { DDAccionGastos.CODIGO_COLABORACION, DDAccionGastos.CODIGO_PRESCRIPCION, DDAccionGastos.CODIGO_RESPONSABLE_CLIENTE };

		List<DtoGastoExpediente> listaHonorarios = new ArrayList<DtoGastoExpediente>();

		if (Checks.esNulo(idOferta) || Checks.esNulo(idActivo)) {
			return listaHonorarios;
		}

		// Obtener la oferta y comprobar su estado, si el estado de la oferta es
		// aceptado obtener un listado de gastos expediente. Si no existen
		// expediente asociado a la oferta calcular los gastos.
		Filter filterOfertaID = genericDao.createFilter(FilterType.EQUALS, "id", idOferta);
		Filter filterActivoID = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Oferta oferta = genericDao.get(Oferta.class, filterOfertaID);
		Activo activo = genericDao.get(Activo.class, filterActivoID);
		if (!Checks.esNulo(oferta)) {
			if (!Checks.esNulo(oferta.getEstadoOferta()) && oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_ACEPTADA)) {
				// Si la oferta está aceptada, tendremos expediente y los honorarios guardados....
				listaHonorarios = expedienteComercialApi.getHonorariosActivoByOfertaAceptada(oferta, activo);

			} else {
				for (int i = 0; i < acciones.length; i++) {
					listaHonorarios.add(calculaHonorario(oferta, acciones[i], activo));
				}

			}
		}

		return listaHonorarios;
	}

	@Override
	public DtoGastoExpediente calculaHonorario(Oferta oferta, String accion, Activo activo) {

		DtoGastoExpediente dto = new DtoGastoExpediente();
		ActivoProveedor proveedor = null;

		// Los honorarios de colaboración serán asignados al FDV de la oferta si existe,
		// sino al custodio de la oferta si existe,
		// sino al mediador del activo.
		if (accion.equals(DDAccionGastos.CODIGO_COLABORACION)) {

			if (!Checks.esNulo(oferta.getFdv())) {
				proveedor = oferta.getFdv();
			} else if (!Checks.esNulo(oferta.getCustodio())) {
				proveedor = oferta.getCustodio();
			} else if (!Checks.esNulo(activo.getInfoComercial())) {
				proveedor = activo.getInfoComercial().getMediadorInforme();
			}
			// Los gastos de prescripcion serán asignados al al prescriptor de la oferta
		} else if (accion.equals(DDAccionGastos.CODIGO_PRESCRIPCION)) {

			if (!Checks.esNulo(oferta.getPrescriptor())) {
				proveedor = oferta.getPrescriptor();
			}
		}
		// TODO: Falta definir a quien asignar los honorarios para CODIGO_RESPONSABLE_CLIENTE (Doble
		// prescripción)

		// Información del receptor del honorario
		if (!Checks.esNulo(proveedor)) {

			if (!Checks.esNulo(proveedor.getTipoProveedor())) {
				dto.setTipoProveedor(proveedor.getTipoProveedor().getDescripcion());
			}
			dto.setProveedor(proveedor.getNombre());
			dto.setIdProveedor(proveedor.getCodigoProveedorRem());
		}

		// Información del tipo de honorario
		DDAccionGastos accionGastoC = (DDAccionGastos) utilDiccionarioApi.dameValorDiccionarioByCod(DDAccionGastos.class, accion);
		if (!Checks.esNulo(accionGastoC)) {
			dto.setCodigoTipoComision(accionGastoC.getCodigo());
			dto.setDescripcionTipoComision(accionGastoC.getDescripcion());
		}

		// Información del tipo de cálculo. Por defecto siempre son porcentajes
		DDTipoCalculo tipoCalculoC = (DDTipoCalculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCalculo.class, DDTipoCalculo.TIPO_CALCULO_PORCENTAJE);

		if (!Checks.esNulo(tipoCalculoC)) {
			dto.setTipoCalculo(tipoCalculoC.getDescripcion());
			dto.setCodigoTipoCalculo(tipoCalculoC.getCodigo());
		}

		Long idProveedor = !Checks.esNulo(proveedor) ? proveedor.getId() : null;

		// Información del cálculo de la comisión
		BigDecimal calculoComision = ofertaDao.getImporteCalculo(oferta.getId(), TIPO_HONORARIOS.get(accion), activo.getId(), idProveedor);
		if (!Checks.esNulo(calculoComision)) {
			Double calculoImporteC = calculoComision.doubleValue();
			dto.setImporteCalculo(calculoImporteC);

			if (!Checks.esNulo(activo)) {
				ActivoTasacion tasacion = activoApi.getTasacionMasReciente(activo);
				if (!Checks.esNulo(tasacion)) {
					Double tasacionFin = tasacion.getImporteTasacionFin();
					Double result = (tasacionFin * calculoImporteC / 100);
					dto.setHonorarios(result);
				}
			}
		} /*
			 * else { // Si el importe calculo está vacío mostrar 'Sin // Honorarios'.
			 * dto.setTipoCalculo("-"); dto.setHonorarios("Sin Honorarios"); }
			 */

		return dto;
	}

	@Override
	public boolean checkEjerce(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);

		// Que esté relleno el resultado del tanteo y la oferta no venga desde
		// una aceptación de tanteo.
		if (!Checks.esNulo(ofertaAceptada.getDesdeTanteo())) {
			if (ofertaAceptada.getDesdeTanteo() || !checkDerechoTanteo(tareaExterna)) {
				return true;
			} else {
				if (!Checks.esNulo(ofertaAceptada.getResultadoTanteo()))
					return true;
				else
					return false;
			}
		} else {
			if (!checkDerechoTanteo(tareaExterna)) {
				return true;
			} else {
				if (!Checks.esNulo(ofertaAceptada.getResultadoTanteo()))
					return true;
				else
					return false;
			}
		}
	}

	@Override
	public List<Oferta> getOtrasOfertasTitularesOferta(Oferta oferta) {
		List<Oferta> listaOfertasTotales = null;
		List<Oferta> listaOfertas = null;
		Oferta ofr = null;
		ExpedienteComercial eco = null;
		OfertaDto ofertaDto = null;

		try {
			listaOfertasTotales = new ArrayList<Oferta>();

			eco = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
			List<CompradorExpediente> listaComp = eco.getCompradores();
			for (int i = 0; i < listaComp.size(); i++) {
				ClienteComercial cc = listaComp.get(i).getPrimaryKey().getComprador().getClienteComercial();
				ofertaDto = new OfertaDto();
				ofertaDto.setIdClienteComercial(cc.getId());
				listaOfertas = getListaOfertas(ofertaDto);

				listaOfertasTotales.addAll(listaOfertas);
			}

			for (int i = 0; i < listaOfertasTotales.size(); i++) {
				ofr = listaOfertasTotales.get(i);
				if (ofr.equals(oferta)) {
					listaOfertasTotales.remove(ofr);
				}

			}

			return listaOfertasTotales;

		} catch (Exception e) {
			logger.error("error en OfertasManager", e);
			return listaOfertasTotales;
		}
	}

	@Override
	public Boolean isActivoConOfertaYExpedienteBlocked(Activo activo) {

		// Si no se encuentra en una agrupación de tipo 'lote comercial'
		// examinar si el activo tuviese alguna oferta aceptada.
		for (ActivoOferta acof : activo.getOfertas()) {
			Oferta of = acof.getPrimaryKey().getOferta();
			if (this.isOfertaAceptadaConExpedienteBlocked(of)) {
				return true;
			}
		}
		return false;
	}

	@Override
	public Boolean isAgrupacionConOfertaYExpedienteBlocked(ActivoAgrupacion agrupacion) {

		// Comprobar si la grupación tiene ofertas aceptadas con expediente en
		// estado Aprobado, Reservado o En devolución
		for (Oferta of : agrupacion.getOfertas()) {
			if (this.isOfertaAceptadaConExpedienteBlocked(of)) {
				return true;
			}
		}

		return false;
	}

	@Override
	public Boolean isOfertaAceptadaConExpedienteBlocked(Oferta of) {
		if (!Checks.esNulo(of) && !Checks.esNulo(of.getEstadoOferta()) && DDEstadoOferta.CODIGO_ACEPTADA.equals(of.getEstadoOferta().getCodigo())) {
			// Si la oferta esta aceptada, se comprueba que el expediente esté
			// con alguno de los siguientes estados..., para pasar la nueva
			// oferta a Congelada.
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(of.getId());
			if (!Checks.esNulo(expediente.getEstado()) && (DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())
					|| DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())
					|| DDEstadosExpedienteComercial.EN_DEVOLUCION.equals(expediente.getEstado().getCodigo())
					|| DDEstadosExpedienteComercial.FIRMADO.equals(expediente.getEstado().getCodigo())
					|| DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())
					|| DDEstadosExpedienteComercial.BLOQUEO_ADM.equals(expediente.getEstado().getCodigo()))) {

				return true;
			}
		}
		return false;
	}

	@Override
	public boolean resetPBC(ExpedienteComercial expediente) {
		if (Checks.esNulo(expediente)) {
			return false;
		}

		// Reiniciar estado del PBC.
		expediente.setEstadoPbc(null);
		genericDao.update(ExpedienteComercial.class, expediente);

		// Avisar al gestor de formalización del activo.
		Notificacion notificacion = new Notificacion();

		if (!Checks.esNulo(expediente.getOferta()) && !Checks.esNulo(expediente.getOferta().getActivoPrincipal()) && !Checks.esNulo(expediente.getOferta().getActivoPrincipal())) {
			notificacion.setIdActivo(expediente.getOferta().getActivoPrincipal().getId());

			Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			EXTDDTipoGestor gestorActivo = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
			if (!Checks.esNulo(gestorActivo)) {
				Usuario usuario = gestorActivoApi.getGestorByActivoYTipo(expediente.getOferta().getActivoPrincipal(), gestorActivo.getId());
				if (!Checks.esNulo(usuario)) {
					notificacion.setDestinatario(usuario.getId());

					notificacion.setTitulo("Notificación PBC reiniciado");
					notificacion.setDescripcion("Se ha reiniciado el PBC de la oferta: " + expediente.getOferta().getNumOferta() + ".");
					notificacion.setFecha(new Date());

					try {
						notificacionAdapter.saveNotificacion(notificacion);
					} catch (ParseException e) {
						logger.error("error en OfertasManager", e);
					}
				}
			}
		}

		return true;
	}

	@Override
	public boolean checkImpuestos(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.findOneByOferta(ofertaAceptada);
			if (!Checks.esNulo(expediente)) {
				CondicionanteExpediente condicionante = expediente.getCondicionante();
				if (!Checks.esNulo(condicionante)) {
					if (!Checks.esNulo(expediente.getCondicionante().getTipoImpuesto()) && !Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) return true;
				}
			}

		}
		return false;
	}
}

package es.pfsgroup.plugin.rem.oferta;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.auditoria.model.Auditoria;
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
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoOferta.ActivoOfertaPk;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TitularesAdicionalesOferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.oferta.dao.VOfertaActivoDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaTitularAdicionalDto;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Service("ofertaManager")
public class OfertaManager extends BusinessOperationOverrider<OfertaApi> implements OfertaApi {

	protected static final Log logger = LogFactory.getLog(OfertaManager.class);

	@Resource
	MessageService messageServices;

	@Autowired
	private RestApi restApi;

	@Autowired
	private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;

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
	private UvemManagerApi uvemManagerApi;
	
	@Override
	public String managerName() {
		return "ofertaManager";
	}

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Override
	public Oferta getOfertaById(Long id) {
		Oferta oferta = null;

		try {

			oferta = ofertaDao.get(id);

		} catch (Exception ex) {
			ex.printStackTrace();
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
			ex.printStackTrace();
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
			ex.printStackTrace();
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
			ex.printStackTrace();
		}

		return lista;
	}

	@Override
	public HashMap<String, String> validateOfertaPostRequestData(OfertaDto ofertaDto, Object jsonFields, Boolean alta)
			throws Exception {
		HashMap<String, String> errorsList = null;
		Oferta oferta = null;

		/*
		 * oferta = getOfertaByIdOfertaWebcom(ofertaDto.getIdOfertaWebcom()); if
		 * (Checks.esNulo(oferta) && !Checks.esNulo(ofertaDto.getIdOfertaRem()))
		 * { restApi.obtenerMapaErrores(errorsList,
		 * "idOfertaWebcom").add(RestApi.REST_MSG_UNKNOWN_KEY);
		 * 
		 * }
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
			if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getEstadoOferta())
					&& !oferta.getEstadoOferta().getCodigo().equalsIgnoreCase(DDEstadoOferta.CODIGO_PENDIENTE)) {
				errorsList.put("idOfertaWebcom", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdVisitaRem())) {
			Visita visita = (Visita) genericDao.get(Visita.class,
					genericDao.createFilter(FilterType.EQUALS, "numVisitaRem", ofertaDto.getIdVisitaRem()));
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
			Activo activo = (Activo) genericDao.get(Activo.class,
					genericDao.createFilter(FilterType.EQUALS, "numActivo", ofertaDto.getIdActivoHaya()));
			if (Checks.esNulo(activo)) {
				errorsList.put("idActivoHaya", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdUsuarioRemAccion())) {
			Usuario user = (Usuario) genericDao.get(Usuario.class,
					genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdUsuarioRemAccion()));
			if (Checks.esNulo(user)) {
				errorsList.put("idUsuarioRem", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getCodEstadoOferta())) {
			// Perimetros: NO se pueden ACEPTAR Ofertas en activos que no
			// tengan condicion comercial en el perimetro
			// Se valida lo primero pq debe hacerse aunque el diccionario
			// tenga borrado logico del estado aceptada
			if (DDEstadoOferta.CODIGO_ACEPTADA.equals(ofertaDto.getCodEstadoOferta())) {
				errorsList.put("codEstadoOferta",
						messageServices.getMessage("oferta.validacion.errorMensaje.perimetroSinComercial"));
			}
			DDEstadoOferta estadoOfr = (DDEstadoOferta) genericDao.get(DDEstadoOferta.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", ofertaDto.getCodEstadoOferta()));
			if (Checks.esNulo(estadoOfr)) {
				errorsList.put("codEstadoOferta", RestApi.REST_MSG_UNKNOWN_KEY);
			} else {
				if (!ofertaDto.getCodEstadoOferta().equals(DDEstadoOferta.CODIGO_PENDIENTE)
						&& !ofertaDto.getCodEstadoOferta().equals(DDEstadoOferta.CODIGO_RECHAZADA)) {
					errorsList.put("codEstadoOferta",
							"Código de estado no permitido. Valores permitidos: "
									.concat(DDEstadoOferta.CODIGO_PENDIENTE).concat(",")
									.concat(DDEstadoOferta.CODIGO_RECHAZADA));
				}
			}
		}
		if (!Checks.esNulo(ofertaDto.getCodTipoOferta())) {
			DDTipoOferta tipoOfr = (DDTipoOferta) genericDao.get(DDTipoOferta.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", ofertaDto.getCodTipoOferta()));
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
			/*else {
				//el proveedor tiene que ser custodio
				if ((cust.getCustodio() != null && !cust.getCustodio().equals(new Integer(1)))
						|| cust.getCustodio() == null) {
					errorsList.put("IdProveedorRemCustodio", RestApi.REST_MSG_UNKNOWN_KEY);
				}
			}*/
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
			}else {
				if(fdv.getTipoProveedor()==null || !fdv.getTipoProveedor().getCodigo().equals(DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA)){
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
				Visita visita = (Visita) genericDao.get(Visita.class,
						genericDao.createFilter(FilterType.EQUALS, "numVisitaRem", ofertaDto.getIdVisitaRem()));
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
			if (!Checks.esNulo(ofertaDto.getIdActivoHaya())) {
				ActivoOferta actOfr = null;
				List<ActivoOferta> listaActOfr = new ArrayList<ActivoOferta>();
				List<ActivoAgrupacionActivo> listaAgrups = null;
				List<ActivoAgrupacionActivo> listaActivos = null;
				List<Activo> lact = new ArrayList<Activo>();

				Activo activo = (Activo) genericDao.get(Activo.class,
						genericDao.createFilter(FilterType.EQUALS, "numActivo", ofertaDto.getIdActivoHaya()));
				if (!Checks.esNulo(activo)) {
					// Añadimos el activo de la oferta
					lact.add(activo);
					actOfr = buildActivoOferta(activo, oferta, null);
					listaActOfr.add(actOfr);

					// Añadimos a la oferta el resto de activos de las
					// agupaciones restringidas a las que pertenece el
					// activo
					DtoAgrupacionFilter dtoAgrupActivo = new DtoAgrupacionFilter();
					dtoAgrupActivo.setActId(activo.getId());
					dtoAgrupActivo.setTipoAgrupacion(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA);
					listaAgrups = activoAgrupacionActivoApi.getListActivosAgrupacion(dtoAgrupActivo);
					if (!Checks.esNulo(listaAgrups) && listaAgrups.size() > 0) {
						// Recorremos las agrupaciones del activo
						for (int i = 0; i < listaAgrups.size(); i++) {
							ActivoAgrupacionActivo agrAct = listaAgrups.get(i);
							if (!Checks.esNulo(agrAct) && !Checks.esNulo(agrAct.getAgrupacion())) {
								oferta.setAgrupacion(agrAct.getAgrupacion());
								DtoAgrupacionFilter dtoAgrupActivo2 = new DtoAgrupacionFilter();
								dtoAgrupActivo2.setAgrId(agrAct.getAgrupacion().getId());
								listaActivos = activoAgrupacionActivoApi.getListActivosAgrupacion(dtoAgrupActivo2);

								if (!Checks.esNulo(listaActivos) && listaActivos.size() > 0) {
									// Para cada agrupacion obtenemos los
									// activos de la agrupacion para
									// añadirlos a la oferta.
									for (int j = 0; j < listaActivos.size(); j++) {
										agrAct = listaActivos.get(j);
										if (!Checks.esNulo(agrAct) && !Checks.esNulo(agrAct.getActivo())
												&& !Checks.esNulo(lact) && !lact.contains(agrAct.getActivo())) {
											lact.add(agrAct.getActivo());
											actOfr = buildActivoOferta(agrAct.getActivo(), oferta, null);
											listaActOfr.add(actOfr);
										}
									}
								}
							}
						}
					}
					if (!Checks.esNulo(listaActOfr) && listaActOfr.size() > 0) {
						oferta.setActivosOferta(listaActOfr);
					}
				}
			}
			if (!Checks.esNulo(ofertaDto.getIdUsuarioRemAccion())) {
				Usuario user = (Usuario) genericDao.get(Usuario.class,
						genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdUsuarioRemAccion()));
				if (!Checks.esNulo(user)) {
					oferta.setUsuarioAccion(user);
				}
			}
			if (!Checks.esNulo(ofertaDto.getCodTipoOferta())) {
				DDTipoOferta tipoOfr = (DDTipoOferta) genericDao.get(DDTipoOferta.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", ofertaDto.getCodTipoOferta()));
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
			if (!Checks.esNulo(ofertaDto.getImporte())) {
				oferta.setImporteOferta(ofertaDto.getImporte());
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
						titAdi.setTipoDocumento((DDTipoDocumento) genericDao.get(DDTipoDocumento.class,
								genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodTipoDocumento())));
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
	public HashMap<String, String> updateOferta(Oferta oferta, OfertaDto ofertaDto, Object jsonFields)
			throws Exception {
		HashMap<String, String> errorsList = null;
		// ValidateUpdate
		errorsList = validateOfertaPostRequestData(ofertaDto, jsonFields, false);
		if (errorsList.isEmpty()) {

			if (((JSONObject) jsonFields).containsKey("importeContraoferta")) {
				oferta.setImporteContraOferta(ofertaDto.getImporteContraoferta());
			}

			ofertaDao.saveOrUpdate(oferta);
			updateEstadoOferta(oferta, ofertaDto.getFechaAccion());
			this.updateStateDispComercialActivosByOferta(oferta);

		}

		return errorsList;
	}

	private void updateEstadoOferta(Oferta oferta, Date fechaAccion) {

		Oferta ofertaAcepted = null;

		UsuarioSecurity usuarioSecurity = usuarioSecurityManager.getByUsername(RestApi.REM_LOGGED_USER_USERNAME);
		restApi.doLogin(usuarioSecurity);

		List<ActivoOferta> listaActivoOferta = oferta.getActivosOferta();

		if (listaActivoOferta != null && listaActivoOferta.size() > 0) {
			ActivoOferta actOfr = listaActivoOferta.get(0);
			if (!Checks.esNulo(actOfr) && !Checks.esNulo(actOfr.getPrimaryKey().getActivo())) {
				ofertaAcepted = getOfertaAceptadaByActivo(actOfr.getPrimaryKey().getActivo());
			}
		}

		if (!Checks.esNulo(ofertaAcepted)) {
			oferta.setEstadoOferta(genericDao.get(DDEstadoOferta.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_CONGELADA)));
		} else {
			oferta.setEstadoOferta(genericDao.get(DDEstadoOferta.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_PENDIENTE)));
		}

		oferta.setFechaAlta(fechaAccion);

		if (oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_RECHAZADA)) {
			oferta.setFechaRechazoOferta(fechaAccion);
		}
		ofertaDao.saveOrUpdate(oferta);
		usuarioSecurity = usuarioSecurityManager.getByUsername(RestApi.REST_LOGGED_USER_USERNAME);
		restApi.doLogin(usuarioSecurity);
	}

	private ActivoOferta buildActivoOferta(Activo activo, Oferta oferta, Double importe) {
		ActivoOfertaPk pk = new ActivoOfertaPk();
		ActivoOferta activoOferta = new ActivoOferta();
		pk.setActivo(activo);
		pk.setOferta(oferta);

		activoOferta.setPrimaryKey(pk);
		activoOferta.setImporteActivoOferta(importe);
		return activoOferta;
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
				updaterState.updaterStateDisponibilidadComercial(activo);
			}
		}
	}

	@Override
	public Oferta trabajoToOferta(Trabajo trabajo) {
		Oferta ofertaAceptada = null;
		Activo activo = trabajo.getActivo();
		if (!Checks.esNulo(activo)) {
			ofertaAceptada = getOfertaAceptadaByActivo(activo);
		}
		return ofertaAceptada;
	}
	
	@Override
	public List<Oferta> trabajoToOfertas(Trabajo trabajo){
		List<Oferta> listaOfertas = new ArrayList<Oferta>();
		Activo activo = trabajo.getActivo();
		if(!Checks.esNulo(activo)) {
			for(ActivoOferta actofr : activo.getOfertas()){
				listaOfertas.add(actofr.getPrimaryKey().getOferta());
			}
		}
		return listaOfertas;
	}
	
	@Override
	public void rechazarOferta(Oferta oferta){
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_RECHAZADA);
		DDEstadoOferta estado =  genericDao.get(DDEstadoOferta.class, filtro);
		oferta.setEstadoOferta(estado);
		genericDao.save(Oferta.class, oferta);
	}
	
	@Override
	public void descongelarOferta(Oferta oferta){
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_PENDIENTE);
		DDEstadoOferta estado =  genericDao.get(DDEstadoOferta.class, filtro);
		oferta.setEstadoOferta(estado);
		genericDao.save(Oferta.class, oferta);
	}

	@Override
	public Oferta tareaExternaToOferta(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = null;
		Trabajo trabajo = trabajoApi.tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			Activo activo = trabajo.getActivo();
			if (!Checks.esNulo(activo)) {
				ofertaAceptada = getOfertaAceptadaByActivo(activo);
			}
		}
		return ofertaAceptada;
	}

	@Override
	public Oferta getOfertaAceptadaByActivo(Activo activo) {
		List<ActivoOferta> listaOfertas = activo.getOfertas();

		for (ActivoOferta activoOferta : listaOfertas) {
			Oferta oferta = activoOferta.getPrimaryKey().getOferta();
			if (DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo()))
				return oferta;
		}
		return null;
	}

	@Override
	public boolean checkDerechoTanteo(Trabajo trabajo) {
		Oferta ofertaAceptada = trabajoToOferta(trabajo);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());
			if (!Checks.esNulo(expediente))
				if (!Checks.esNulo(expediente.getCondicionante()))
					return (Integer.valueOf(1).equals(expediente.getCondicionante().getSujetoTanteoRetracto()));
		}
		return false;
	}

	@Override
	public boolean checkDerechoTanteo(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());
			if (!Checks.esNulo(expediente))
				if (!Checks.esNulo(expediente.getCondicionante()))
					return (Integer.valueOf(1).equals(expediente.getCondicionante().getSujetoTanteoRetracto()));
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
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());
			if (!Checks.esNulo(expediente))
				if (!Checks.esNulo(expediente.getCondicionante()))
					return (Integer.valueOf(1).equals(expediente.getCondicionante().getSolicitaReserva()));
		}
		return false;
	}

	@Override
	public boolean checkRiesgoReputacional(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());
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
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());
			return (!Checks.estaVacio(expediente.getCompradores()));
		}
		return false;
	}

	@Override
	public boolean checkConflictoIntereses(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());
			return (Integer.valueOf(0).equals(expediente.getConflictoIntereses()));
		}
		return false;
	}

	@Override
	@Transactional(readOnly = false)
	public ArrayList<Map<String, Object>> saveOrUpdateOfertas(List<OfertaDto> listaOfertaDto, JSONObject jsonFields)
			throws Exception {
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
		if(!Checks.esNulo(oferta)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
			if(!Checks.esNulo(expediente)){
				if(!Checks.esNulo(expediente.getComiteSancion())){
					return true;
				}
			}
		}
		return false;
	}
	
	@Override
	public boolean checkAtribuciones(TareaExterna tareaExterna) {
		Oferta oferta = tareaExternaToOferta(tareaExterna);
		if(!Checks.esNulo(oferta)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
			if(!Checks.esNulo(expediente)){
				if(!Checks.esNulo(expediente.getComiteSancion())){
					if(DDComiteSancion.CODIGO_HAYA_CAJAMAR.equals(expediente.getComiteSancion().getCodigo()) || DDComiteSancion.CODIGO_HAYA_SAREB.equals(expediente.getComiteSancion().getCodigo()))
						return true;
				}
			}
		}
		return false;
	}

	@Override
	public boolean checkAtribuciones(Trabajo trabajo) {
		Oferta oferta = trabajoToOferta(trabajo);
		if(!Checks.esNulo(oferta)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
			if(!Checks.esNulo(expediente)){
				if(!Checks.esNulo(expediente.getComiteSancion())){
					if(DDComiteSancion.CODIGO_HAYA_CAJAMAR.equals(expediente.getComiteSancion().getCodigo()) || DDComiteSancion.CODIGO_HAYA_SAREB.equals(expediente.getComiteSancion().getCodigo()))
						return true;
				}
			}
		}
		return false;
	}
	
	@Override
	public boolean altaComite(TareaExterna tareaExterna){
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		Long porcentajeImpuesto = null;
		if(!Checks.esNulo(expediente.getCondicionante())){
			if(!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())){
				//porcentajeImpuesto = Long.parseLong(String.format("%.0f",expediente.getCondicionante().getTipoAplicable()));
				porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable().longValue();
			}else{
				return false;
			}
		}

		try {
			InstanciaDecisionDto instanciaDecisionDto = expedienteComercialApi.expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto);
			uvemManagerApi.altaInstanciaDecision(instanciaDecisionDto);
			return true;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}

	}
	
	@Override
	public boolean checkPoliticaCorporativa(TareaExterna tareaExterna){
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		if(Checks.esNulo(expediente.getConflictoIntereses()) || Checks.esNulo(expediente.getRiesgoReputacional()))
			return false;
		else
			if((expediente.getConflictoIntereses() == 1) || (expediente.getRiesgoReputacional() == 1))
				return false;
			else
				return true;
	}
	
	@Override
	public boolean checkPosicionamiento(TareaExterna tareaExterna){
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		if(!Checks.estaVacio(expediente.getPosicionamientos()))
			return true;
		else
			return false;
	}
	
	@Override
	public boolean checkEjerce(TareaExterna tareaExterna){
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		
		//Que esté relleno el resultado del tanteo y la oferta no venga desde una aceptación de tanteo.
		if(!Checks.esNulo(ofertaAceptada.getDesdeTanteo())){
			 if(ofertaAceptada.getDesdeTanteo() || !checkDerechoTanteo(tareaExterna)){
				return true;
			 }else{
				 if(!Checks.esNulo(ofertaAceptada.getResultadoTanteo()))
					 return true;
				 else
					 return false;
			 }
		}else{
			if(!checkDerechoTanteo(tareaExterna)){
				return true;
			}else{
				if(!Checks.esNulo(ofertaAceptada.getResultadoTanteo()))
					return true;
				else
					return false;
			}
		}
	}
}

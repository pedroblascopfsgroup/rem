package es.pfsgroup.plugin.rem.oferta;

import java.lang.reflect.InvocationTargetException;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
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
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GastosExpedienteApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.comisionamiento.ComisionamientoApi;
import es.pfsgroup.plugin.rem.comisionamiento.dto.ConsultaComisionDto;
import es.pfsgroup.plugin.rem.comisionamiento.dto.RespuestaComisionResultDto;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.ListaOfertasCESExcelReport;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.gestor.GestorExpedienteComercialManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoInfoLiberbank;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoOferta.ActivoOfertaPk;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoActivosExpediente;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoClienteComercial;
import es.pfsgroup.plugin.rem.model.DtoDetalleOferta;
import es.pfsgroup.plugin.rem.model.DtoGastoExpediente;
import es.pfsgroup.plugin.rem.model.DtoHonorariosOferta;
import es.pfsgroup.plugin.rem.model.DtoOferta;
import es.pfsgroup.plugin.rem.model.DtoOfertantesOferta;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaAlqBankia;
import es.pfsgroup.plugin.rem.model.DtoTanteoActivoExpediente;
import es.pfsgroup.plugin.rem.model.DtoVListadoOfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.GestorActivo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.OfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.ProveedorGestorCajamar;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.TitularesAdicionalesOferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VListOfertasCES;
import es.pfsgroup.plugin.rem.model.VListadoOfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.VPreciosVigentes;
import es.pfsgroup.plugin.rem.model.VTasacionCalculoLBK;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCategoriaContable;
import es.pfsgroup.plugin.rem.model.dd.DDClaseOferta;
import es.pfsgroup.plugin.rem.model.dd.DDComiteAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEquipoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenComprador;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.oferta.dao.OfertasAgrupadasLbkDao;
import es.pfsgroup.plugin.rem.oferta.dao.VListadoOfertasAgrupadasLbkDao;
import es.pfsgroup.plugin.rem.oferta.dao.VOfertaActivoDao;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ActivosLoteOfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaTitularAdicionalDto;
import es.pfsgroup.plugin.rem.rest.dto.ResultadoInstanciaDecisionDto;
import es.pfsgroup.plugin.rem.tareasactivo.dao.ActivoTareaExternaDao;
import es.pfsgroup.plugin.rem.thread.MaestroDePersonas;
import es.pfsgroup.plugin.rem.tramitacionOfertas.TramitacionOfertasManager;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import net.sf.json.JSONObject;

@Service("ofertaManager")
public class OfertaManager extends BusinessOperationOverrider<OfertaApi> implements OfertaApi {

	private final Log logger = LogFactory.getLog(OfertaManager.class);
	SimpleDateFormat groovyft = new SimpleDateFormat("yyyy-MM-dd");

	private static final String T017 = "T017";

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

//	@Autowired
//	private OfertaApi ofertaApi;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private UvemManagerApi uvemManagerApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private NotificacionAdapter notificacionAdapter;

	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;

	@Autowired
	private ProveedoresDao proveedoresDao;

	@Autowired
	private NotificationOfertaManager notificationOfertaManager;
	
	@Autowired
	private TareaActivoApi tareaActivoApi;


	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	GastosExpedienteApi gastosExpedienteApi;
	
	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private AgendaAdapter adapter;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private AgrupacionAdapter agrupacionAdapter;

	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;

	@Autowired
	private ActivoAdapter activoAdapterApi;

	@Autowired
	private GencatApi gencatApi;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private ActivoTareaExternaDao activoTareaExternaDao;
	@Autowired
	private VListadoOfertasAgrupadasLbkDao vOfertasAgrupadasLbkDao;

	@Autowired
	private OfertasAgrupadasLbkDao ofertasAgrupadasLbkDao;
	
	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	@Autowired
	private TramitacionOfertasManager tramitacionOfertasManager;

	@Override
	public String managerName() {
		return "ofertaManager";
	}

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Autowired
	private GestorExpedienteComercialManager gestorExpedienteComercialManager;
	
	@Autowired
	private ComisionamientoApi comisionamientoApi;

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
	public Oferta getOfertaPrincipalById(Long id) {
		Oferta oferta = null;

		if (id != null) {
			try {
	
				oferta = ofertaDao.getOfertaPrincipal(id);
	
			} catch (Exception ex) {
				logger.error("error en OfertasManager", ex);
			}
		}

		return oferta;
	}
	 

	/**
	 * usa el metdodo ofertaDao.getOfertaByIdwebcom
	 */
	@Override
	@Deprecated
	public Oferta getOfertaByIdOfertaWebcom(Long idOfertaWebcom) throws Exception {
		Oferta oferta = null;
		List<Oferta> lista = null;
		OfertaDto ofertaDto = null;

		if (Checks.esNulo(idOfertaWebcom)) {
			throw new Exception("El parámetro idOfertaWebcom es obligatorio.");

		} else {

			ofertaDto = new OfertaDto();
			ofertaDto.setIdOfertaWebcom(idOfertaWebcom);

			lista = ofertaDao.getListaOfertas(ofertaDto);
			if (!Checks.esNulo(lista) && !lista.isEmpty()) {
				oferta = lista.get(0);
			}
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
				if (!Checks.esNulo(lista) && !lista.isEmpty()) {
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
			} else if (idOfertaWebcom != null) {
				ofertaDto.setIdOfertaWebcom(idOfertaWebcom);
			}

			lista = ofertaDao.getListaOfertas(ofertaDto);
			if (!Checks.esNulo(lista) && !lista.isEmpty()) {
				oferta = lista.get(0);
			}

		} else {
			throw new Exception("Faltan datos para el filtro");
		}
		return oferta;
	}

	@Override
	@Deprecated
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter) {

		return ofertaDao.getListOfertas(dtoOfertasFilter);
	}

	public DtoPage getListOfertasUsuario(DtoOfertasFilter dto) {
		Usuario usuarioGestor = null;
		Usuario usuarioGestoria = null;

		if (dto.getUsuarioGestor() != null) {
			usuarioGestor = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getUsuarioGestor()));
		}

		if (dto.getGestoria() != null) {
			usuarioGestoria = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getGestoria()));
		}

		// Carterización del buscador.
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		if (!Checks.esNulo(usuarioCartera)){
			if(!Checks.esNulo(usuarioCartera.getSubCartera())){
				dto.setCarteraCodigo(usuarioCartera.getCartera().getCodigo());
				dto.setSubcarteraCodigo(usuarioCartera.getSubCartera().getCodigo());
			}else{
				dto.setCarteraCodigo(usuarioCartera.getCartera().getCodigo());
			}
		}

		return ofertaDao.getListOfertas(dto, usuarioGestor, usuarioGestoria);
	}

	public DtoPage getListOfertasGestoria(DtoOfertasFilter dto) {
		return ofertaDao.getListOfertasGestoria(dto);
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
	public HashMap<String, String> validateOfertaPostRequestData(OfertaDto ofertaDto, Object jsonFields, Boolean alta)
			throws Exception {
		HashMap<String, String> errorsList = null;
		Oferta oferta = null;

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
					&& !oferta.getEstadoOferta().getCodigo().equalsIgnoreCase(DDEstadoOferta.CODIGO_PENDIENTE)
					&& Checks.esNulo(ofertaDto.getCodTarea())) {
				errorsList.put("idOfertaWebcom", RestApi.REST_MSG_UNKNOWN_KEY);
			}


			if (!Checks.esNulo(ofertaDto.getOfertaLote()) && ofertaDto.getOfertaLote()) {
				errorsList.put("idOfertaWebcom", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdVisitaRem())) {
			Visita visita = genericDao.get(Visita.class,
					genericDao.createFilter(FilterType.EQUALS, "numVisitaRem", ofertaDto.getIdVisitaRem()));
			if (Checks.esNulo(visita)) {
				errorsList.put("idVisitaRem", RestApi.REST_MSG_UNKNOWN_KEY);
			}

		}
		if (!Checks.esNulo(ofertaDto.getIdClienteRem())) {
			ClienteComercial cliente = genericDao.get(ClienteComercial.class,
					genericDao.createFilter(FilterType.EQUALS, "idClienteRem", ofertaDto.getIdClienteRem()));
			if (Checks.esNulo(cliente)) {
				errorsList.put("idClienteRem", RestApi.REST_MSG_UNKNOWN_KEY);
			}else {
				if (Checks.esNulo(cliente.getDocumento()) || Checks.esNulo(cliente.getTipoDocumento())) {
					errorsList.put("idClienteRem", RestApi.REST_MSG_UNKNOWN_KEY);
				}
			}
		}
		if (!Checks.esNulo(ofertaDto.getOfertaLote()) && ofertaDto.getOfertaLote()) {
			List<ActivosLoteOfertaDto> numActivos = ofertaDto.getActivosLote();
			DDCartera cartera = null;
			DDSubcartera subcartera = null;
			ActivoPropietario propietario = null;
			Integer geolocalizacion = 0;

			if (!Checks.esNulo(numActivos) && !numActivos.isEmpty()) {
				for (int i=0; i<numActivos.size(); i++) {
					Activo activo = activoApi.getByNumActivo(numActivos.get(i).getIdActivoHaya());

					if (Checks.esNulo(activo)) {
						errorsList.put("activosLote", RestApi.REST_MSG_UNKNOWN_KEY);
						break;

					} else {
						this.validacionesActivoOfertaLote(errorsList, activo);

						if (i==0) {
							cartera = activo.getCartera();
							subcartera = activo.getSubcartera();
							propietario = activo.getPropietarioPrincipal();
							geolocalizacion = activoApi.getGeolocalizacion(activo);
						} else {
							this.validacionesLote(errorsList, activo, cartera, subcartera, propietario, geolocalizacion);
						}
					}
				}
			} else {
				errorsList.put("activosLote", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		} else if (!Checks.esNulo(ofertaDto.getIdActivoHaya())) {
			Activo activo = genericDao.get(Activo.class,
					genericDao.createFilter(FilterType.EQUALS, "numActivo", ofertaDto.getIdActivoHaya()));
			if (Checks.esNulo(activo)) {
				errorsList.put("idActivoHaya", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdUsuarioRemAccion())) {
			Usuario user = genericDao.get(Usuario.class,
					genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdUsuarioRemAccion()));
			if (Checks.esNulo(user)) {
				errorsList.put("idUsuarioRem", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}

		if (!Checks.esNulo(ofertaDto.getCodTipoOferta())) {
			DDTipoOferta tipoOfr = genericDao.get(DDTipoOferta.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", ofertaDto.getCodTipoOferta()));
			if (Checks.esNulo(tipoOfr)) {
				errorsList.put("codTipoOferta", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdProveedorRemPrescriptor())) {
			ActivoProveedor pres = genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS,
					"codigoProveedorRem", ofertaDto.getIdProveedorRemPrescriptor()));
			if (Checks.esNulo(pres)) {
				errorsList.put("idProveedorRemPrescriptor", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdProveedorRemCustodio())) {
			ActivoProveedor cust = genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS,
					"codigoProveedorRem", ofertaDto.getIdProveedorRemCustodio()));
			if (Checks.esNulo(cust)) {
				errorsList.put("IdProveedorRemCustodio", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdProveedorRemResponsable())) {
			ActivoProveedor apiResp = genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS,
					"codigoProveedorRem", ofertaDto.getIdProveedorRemResponsable()));
			if (Checks.esNulo(apiResp)) {
				errorsList.put("idProveedorRemResponsable", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(ofertaDto.getIdProveedorRemFdv())) {
			ActivoProveedor fdv = genericDao.get(ActivoProveedor.class,
					genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", ofertaDto.getIdProveedorRemFdv()));
			if (Checks.esNulo(fdv)) {
				errorsList.put("idProveedorRemFdv", RestApi.REST_MSG_UNKNOWN_KEY);
			} else {
				if (fdv.getTipoProveedor() == null
						|| !fdv.getTipoProveedor().getCodigo().equals(DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA)) {
					errorsList.put("idProveedorRemFdv", RestApi.REST_MSG_UNKNOWN_KEY);
				}
			}
		}
		if (!Checks.esNulo(ofertaDto.getTitularesAdicionales())) {
			for (int i = 0; i < ofertaDto.getTitularesAdicionales().size(); i++) {
				OfertaTitularAdicionalDto titDto = ofertaDto.getTitularesAdicionales().get(i);
				if (!Checks.esNulo(titDto)) {
					DDTipoDocumento tpd = genericDao.get(DDTipoDocumento.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodTipoDocumento()));
					if (Checks.esNulo(tpd)) {
						errorsList.put("codTipoDocumento", RestApi.REST_MSG_UNKNOWN_KEY);
					}
				}
			}
		}
		if (!Checks.esNulo(ofertaDto.getCodTarea())) {
			if (alta) {
				errorsList.put("codTarea", RestApi.REST_MSG_UNKNOWN_KEY);
			} else {
				if (ofertaDto.getCodTarea().equals("01") && Checks.esNulo(ofertaDto.getAceptacionContraoferta())) {
					errorsList.put("aceptacionContraoferta", RestApi.REST_MSG_MISSING_REQUIRED);
				} else if (ofertaDto.getCodTarea().equals("02")) {
					if(Checks.esNulo(ofertaDto.getFechaPrevistaFirma())) {
						errorsList.put("fechaPrevistaFirma", RestApi.REST_MSG_MISSING_REQUIRED);
					}
					if(Checks.esNulo(ofertaDto.getLugarFirma())) {
						errorsList.put("lugarFirma", RestApi.REST_MSG_MISSING_REQUIRED);
					}
				} else if (ofertaDto.getCodTarea().equals("03") && Checks.esNulo(ofertaDto.getFechaFirma())) {
					errorsList.put("fechaFirma", RestApi.REST_MSG_MISSING_REQUIRED);
				}
			}
		}
		
		if (!Checks.esNulo(ofertaDto.getOrigenLeadProveedor())) {
			DDOrigenComprador origenComprador = genericDao.get(DDOrigenComprador.class, genericDao.createFilter(FilterType.EQUALS,
					"codigo", ofertaDto.getOrigenLeadProveedor()));
			if (Checks.esNulo(origenComprador)) {
				errorsList.put("origenLeadProveedor", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}

		return errorsList;
	}

	@Override
	@Transactional(readOnly = false)
	public HashMap<String, String> saveOferta(OfertaDto ofertaDto) throws Exception {
		Oferta oferta = null;
		HashMap<String, String> errorsList = null;
		ActivoAgrupacion agrup = null;

		// ValidateAlta
		errorsList = validateOfertaPostRequestData(ofertaDto, null, true);
		if (errorsList.isEmpty()) {
			if (!Checks.esNulo(ofertaDto.getOfertaLote())
						&& ofertaDto.getOfertaLote()
						&& !Checks.esNulo(ofertaDto.getActivosLote())
						&& !ofertaDto.getActivosLote().isEmpty()) {
				DtoAgrupacionesCreateDelete dtoAgrupacion = new DtoAgrupacionesCreateDelete();
				if(DDTipoOferta.CODIGO_VENTA.equals(ofertaDto.getCodTipoOferta())) {
					dtoAgrupacion.setTipoAgrupacion(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA);
				} else if(DDTipoOferta.CODIGO_ALQUILER.equals(ofertaDto.getCodTipoOferta())) {
					dtoAgrupacion.setTipoAgrupacion(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER);
				}
				dtoAgrupacion.setNombre("Agrupación creada desde CRM");
				ActivoProveedor prescriptor = genericDao.get(ActivoProveedor.class, genericDao.createFilter(
						FilterType.EQUALS, "codigoProveedorRem", ofertaDto.getIdProveedorRemPrescriptor()));
				if (!Checks.esNulo(prescriptor)) {
					dtoAgrupacion.setDescripcion("Agrupación creada desde CRM por " + prescriptor.getNombre());
				} else {
					dtoAgrupacion.setDescripcion("Agrupación creada desde CRM");
				}
				dtoAgrupacion.setGestorComercial(activoAgrupacionApi.getGestorComercialAgrupacion(ofertaDto.getActivosLote()));
				Long numAgrupacionRem = null;
				if(Checks.esNulo(dtoAgrupacion.getNumAgrupacionRem())){
					agrupacionAdapter.createAgrupacion(dtoAgrupacion);
					if(!Checks.esNulo(dtoAgrupacion.getNumAgrupacionRem())){
						numAgrupacionRem = dtoAgrupacion.getNumAgrupacionRem();
					}
				}else{
					numAgrupacionRem = agrupacionAdapter.createAgrupacion(dtoAgrupacion).getNumAgrupacionRem();
				}
				agrup = genericDao.get(ActivoAgrupacion.class, genericDao.createFilter(
						FilterType.EQUALS, "numAgrupRem", numAgrupacionRem));
				for (int i=0; i<ofertaDto.getActivosLote().size(); i++) {
					try {
						Activo activo = activoApi.getByNumActivo(ofertaDto.getActivosLote().get(i).getIdActivoHaya());
						agrup.setTipoAlquiler(activo.getTipoAlquiler());
						agrupacionAdapter.createActivoAgrupacion(ofertaDto.getActivosLote().get(i).getIdActivoHaya(), agrup.getId(), i+1, false);
					} catch (Exception e) {
						logger.error("Error en ofertaManager", e);
						errorsList.put("activosLote", RestApi.REST_MSG_UNKNOWN_KEY);
						return errorsList;
					}
				}
			}

			oferta = new Oferta();
			oferta.setOrigen(OfertaApi.ORIGEN_WEBCOM);
			beanUtilNotNull.copyProperties(oferta, ofertaDto);
			if (!Checks.esNulo(ofertaDto.getIdOfertaWebcom())) {
				oferta.setIdWebCom(ofertaDto.getIdOfertaWebcom());
			}
			oferta.setNumOferta(ofertaDao.getNextNumOfertaRem());
			if (!Checks.esNulo(ofertaDto.getImporteContraoferta())) {
				oferta.setImporteContraOferta(ofertaDto.getImporteContraoferta());
			}
			if (!Checks.esNulo(ofertaDto.getIdVisitaRem())) {
				Visita visita = genericDao.get(Visita.class,
						genericDao.createFilter(FilterType.EQUALS, "numVisitaRem", ofertaDto.getIdVisitaRem()));
				if (!Checks.esNulo(visita)) {
					oferta.setVisita(visita);
				}
			}
			if (!Checks.esNulo(ofertaDto.getIdClienteRem())) {
				ClienteComercial cliente = genericDao.get(ClienteComercial.class,
						genericDao.createFilter(FilterType.EQUALS, "idClienteRem", ofertaDto.getIdClienteRem()));
				if (!Checks.esNulo(cliente)) {
					oferta.setCliente(cliente);
				}
			}
			if (!Checks.esNulo(ofertaDto.getImporte())) {
				oferta.setImporteOferta(ofertaDto.getImporte());
			}
			if (!Checks.esNulo(ofertaDto.getOfertaLote()) && ofertaDto.getOfertaLote()) {
				List<ActivoOferta> listaActOfr = new ArrayList<ActivoOferta>();
				boolean esLoteComercial = false;

				for (ActivosLoteOfertaDto idActivo : ofertaDto.getActivosLote()) {
					ActivoAgrupacion agrupacion = null;
					List<ActivoOferta> buildListaActOfr = new ArrayList<ActivoOferta>();
					List<ActivoAgrupacionActivo> listaAgrups = null;

					Activo activo = genericDao.get(Activo.class,
							genericDao.createFilter(FilterType.EQUALS, "numActivo", idActivo.getIdActivoHaya()));
					if (!Checks.esNulo(activo)) {

						// Comprobamos si el activo pertenece a una agrupación
						// restringida o de lote comercial
						DtoAgrupacionFilter dtoAgrupActivo = new DtoAgrupacionFilter();
						dtoAgrupActivo.setActId(activo.getId());
						dtoAgrupActivo.setTipoAgrupacion(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA);
						listaAgrups = activoAgrupacionActivoApi.getListActivosAgrupacion(dtoAgrupActivo);

						if (Checks.esNulo(listaAgrups) || listaAgrups.isEmpty()) {
							dtoAgrupActivo.setTipoAgrupacion(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA);
							listaAgrups = activoAgrupacionActivoApi.getListActivosAgrupacion(dtoAgrupActivo);
							esLoteComercial = true;
						}

						if (Checks.esNulo(listaAgrups) || listaAgrups.isEmpty()) {
							dtoAgrupActivo.setTipoAgrupacion(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER);
							listaAgrups = activoAgrupacionActivoApi.getListActivosAgrupacion(dtoAgrupActivo);
							esLoteComercial = true;
						}

						if (!Checks.esNulo(listaAgrups) && !listaAgrups.isEmpty()) {
							ActivoAgrupacionActivo agrAct = listaAgrups.get(0);
							if (!Checks.esNulo(agrAct) && !Checks.esNulo(agrAct.getAgrupacion())) {
								// Seteamos la agrupación a la oferta
								agrupacion = agrAct.getAgrupacion();
								oferta.setAgrupacion(agrupacion);
							}
						}

						if (!Checks.esNulo(agrupacion)) {
							// Oferta sobre 1 lote restringido de n activos
							buildListaActOfr = buildListaActivoOferta(null, agrupacion, oferta);
							listaActOfr.addAll(buildListaActOfr);
							if(esLoteComercial) break;
						} else {
							// Oferta sobre 1 único activo
							buildListaActOfr = buildListaActivoOferta(activo, null, oferta);
							listaActOfr.addAll(buildListaActOfr);
							if(esLoteComercial) break;
						}
					}
				}

				// Seteamos la lista de ActivosOferta
				oferta.setActivosOferta(listaActOfr);
				// Seteamos la agrupación a la que pertenece la oferta
				oferta.setAgrupacion(agrup);

			} else if (!Checks.esNulo(ofertaDto.getIdActivoHaya())) {
				ActivoAgrupacion agrupacion = null;
				List<ActivoOferta> listaActOfr = new ArrayList<ActivoOferta>();
				List<ActivoAgrupacionActivo> listaAgrups = null;

				Activo activo = genericDao.get(Activo.class,
						genericDao.createFilter(FilterType.EQUALS, "numActivo", ofertaDto.getIdActivoHaya()));
				if (!Checks.esNulo(activo)) {

					// Verificamos si el activo pertenece a una agrupación
					// restringida
					DtoAgrupacionFilter dtoAgrupActivo = new DtoAgrupacionFilter();
					dtoAgrupActivo.setActId(activo.getId());
					dtoAgrupActivo.setTipoAgrupacion(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA);
					listaAgrups = activoAgrupacionActivoApi.getListActivosAgrupacion(dtoAgrupActivo);
					if (!Checks.esNulo(listaAgrups) && !listaAgrups.isEmpty()) {
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
				Usuario user = genericDao.get(Usuario.class,
						genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdUsuarioRemAccion()));
				if (!Checks.esNulo(user)) {
					oferta.setUsuarioAccion(user);
				}
			}
			if (!Checks.esNulo(ofertaDto.getCodTipoOferta())) {
				DDTipoOferta tipoOfr = genericDao.get(DDTipoOferta.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", ofertaDto.getCodTipoOferta()));
				if (!Checks.esNulo(tipoOfr)) {
					oferta.setTipoOferta(tipoOfr);
				}
			}
			if (!Checks.esNulo(ofertaDto.getIdProveedorRemPrescriptor())) {
				ActivoProveedor prescriptor = genericDao.get(ActivoProveedor.class, genericDao.createFilter(
						FilterType.EQUALS, "codigoProveedorRem", ofertaDto.getIdProveedorRemPrescriptor()));
				if (!Checks.esNulo(prescriptor)) {
					oferta.setPrescriptor(prescriptor);
				}
			}
			if (!Checks.esNulo(ofertaDto.getIdProveedorRemCustodio())) {
				ActivoProveedor cust = genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS,
						"codigoProveedorRem", ofertaDto.getIdProveedorRemCustodio()));
				if (!Checks.esNulo(cust)) {
					oferta.setCustodio(cust);
				}
			}
			if (!Checks.esNulo(ofertaDto.getIdProveedorRemResponsable())) {
				ActivoProveedor apiResp = genericDao.get(ActivoProveedor.class, genericDao.createFilter(
						FilterType.EQUALS, "codigoProveedorRem", ofertaDto.getIdProveedorRemResponsable()));
				if (!Checks.esNulo(apiResp)) {
					oferta.setApiResponsable(apiResp);
				}
			}
			if (!Checks.esNulo(ofertaDto.getIdProveedorRemFdv())) {
				ActivoProveedor fdv = genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS,
						"codigoProveedorRem", ofertaDto.getIdProveedorRemFdv()));
				if (!Checks.esNulo(fdv)) {
					oferta.setFdv(fdv);
				}
			}

			if (!Checks.esNulo(oferta.getTitularesAdicionales())) {
				oferta.setTitularesAdicionales(null);
			}

			if (!Checks.esNulo(ofertaDto.getObservaciones())) {
				oferta.setObservaciones(ofertaDto.getObservaciones());
			}

			if (!Checks.esNulo(ofertaDto.getFinanciacion())) {
				oferta.setNecesitaFinanciacion(ofertaDto.getFinanciacion());
			}

			if (!Checks.esNulo(ofertaDto.getIsExpress())) {
				oferta.setOfertaExpress(ofertaDto.getIsExpress());
			}
			
			if (!Checks.esNulo(ofertaDto.getOrigenLeadProveedor())) {
				DDOrigenComprador origenComprador = genericDao.get(DDOrigenComprador.class, genericDao.createFilter(FilterType.EQUALS,
						"codigo", ofertaDto.getOrigenLeadProveedor()));
				if (!Checks.esNulo(origenComprador)) {
					oferta.setOrigenComprador(origenComprador);
				}
			} else {
				DDOrigenComprador origenComprador = genericDao.get(DDOrigenComprador.class, genericDao.createFilter(FilterType.EQUALS,
						"codigo", DDOrigenComprador.CODIGO_ORC_HRE));
				oferta.setOrigenComprador(origenComprador);
			}

			Long idOferta = this.saveOferta(oferta);
			ofertaDao.flush();
			if (!Checks.esNulo(ofertaDto.getTitularesAdicionales()) && !Checks.estaVacio(ofertaDto.getTitularesAdicionales())) {
				oferta.setId(idOferta);
				oferta.setTitularesAdicionales(null);
				saveOrUpdateListaTitualesAdicionalesOferta(ofertaDto, oferta, false);
			}

			oferta = updateEstadoOferta(idOferta, ofertaDto.getFechaAccion());
			this.updateStateDispComercialActivosByOferta(oferta);

			if (ofertaDto.getIsExpress()) {
				congelarExpedientesPorOfertaExpress(oferta);
			}

			if (!Checks.esNulo(ofertaDto.getCodTarea())) {
				errorsList = avanzaTarea(oferta, ofertaDto, errorsList);
			}

			if(DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())) {
				notificationOfertaManager.enviarPropuestaOfertaTipoAlquiler(oferta);
			}else {
				notificationOfertaManager.sendNotification(oferta);
			}
			
			if (!Checks.esNulo(ofertaDto.getEsOfertaSingular())) {
				oferta.setOfertaSingular(ofertaDto.getEsOfertaSingular());
			}

		}

		return errorsList;
	}

	@Transactional(readOnly = false)
	private Long saveOferta(Oferta oferta){
		return ofertaDao.save(oferta);
	}

	@Transactional(readOnly = false)
	private void saveOrUpdateListaTitualesAdicionalesOferta(OfertaDto ofertaDto, Oferta oferta, Boolean update){
		List<TitularesAdicionalesOferta> listaTit = new ArrayList<TitularesAdicionalesOferta>();

		if (!Checks.esNulo(oferta) && update) {
			ofertaDao.deleteTitularesAdicionales(oferta);
		}

		for (int i = 0; i < ofertaDto.getTitularesAdicionales().size(); i++) {
			OfertaTitularAdicionalDto titDto = ofertaDto.getTitularesAdicionales().get(i);
			if (!Checks.esNulo(titDto) && !titDto.getDocumento().equals(oferta.getCliente().getDocumento())) {
				TitularesAdicionalesOferta titAdi = new TitularesAdicionalesOferta();
				titAdi.setNombre(titDto.getNombre());
				titAdi.setDocumento(titDto.getDocumento());
				titAdi.setOferta(oferta);
				Auditoria auditoria = Auditoria.getNewInstance();
				titAdi.setAuditoria(auditoria);
				titAdi.setTipoDocumento((DDTipoDocumento) genericDao.get(DDTipoDocumento.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodTipoDocumento())));
				titAdi.setApellidos(titDto.getApellidos());

				String dir = "";
				if (!Checks.esNulo(titDto.getCodTipoVia()))
					dir = titDto.getCodTipoVia()+" ";
				if (!Checks.esNulo(titDto.getNombreCalle()))
					dir = dir.concat(titDto.getNombreCalle());
				if (!Checks.esNulo(titDto.getNumeroCalle()))
					dir = dir.concat(" "+titDto.getNumeroCalle());
				if (!Checks.esNulo(titDto.getPuerta()))
					dir = dir.concat(", pta "+titDto.getPuerta());
				if (!Checks.esNulo(titDto.getPlanta()))
					dir = dir.concat(", plta "+titDto.getPlanta());
				if (!Checks.esNulo(titDto.getEscalera()))
					dir = dir.concat(", esc "+titDto.getEscalera());
				titAdi.setDireccion(dir);

				if (titDto.getCodMunicipio() != null) {
					titAdi.setLocalidad((Localidad) genericDao.get(Localidad.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodMunicipio())));
				}
				if (titDto.getCodProvincia() != null) {
					titAdi.setProvincia((DDProvincia) genericDao.get(DDProvincia.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodProvincia())));
				}
				titAdi.setCodPostal(titDto.getCodigoPostal());
				if (titDto.getCodEstadoCivil() != null) {
					titAdi.setEstadoCivil((DDEstadosCiviles) genericDao.get(DDEstadosCiviles.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodEstadoCivil())));
				}
				if (titDto.getCodRegimenMatrimonial() != null) {
					titAdi.setRegimenMatrimonial((DDRegimenesMatrimoniales) genericDao.get(
							DDRegimenesMatrimoniales.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodRegimenMatrimonial())));

				}
				if(titDto.getCesionDatos() != null){
					titAdi.setRechazarCesionDatosPropietario(!titDto.getCesionDatos());
				}
				if(titDto.getComunicacionTerceros() != null){
					titAdi.setRechazarCesionDatosProveedores(!titDto.getComunicacionTerceros());
				}
				if(titDto.getTransferenciasInternacionales() != null){
					titAdi.setRechazarCesionDatosPublicidad(!titDto.getTransferenciasInternacionales());
				}

				titAdi.setRazonSocial(titDto.getRazonSocial());
				titAdi.setTelefono1(titDto.getTelefono1());
				titAdi.setTelefono2(titDto.getTelefono2());
				titAdi.setEmail(titDto.getEmail());
				if (titDto.getConyugeTipoDocumento() != null) {
					titAdi.setTipoDocumentoConyuge(genericDao.get(DDTipoDocumento.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getConyugeTipoDocumento())));
				}
				titAdi.setDocumentoConyuge(titDto.getConyugeDocumento());
				if (titDto.getCodTipoPersona() != null) {
					titAdi.setTipoPersona(genericDao.get(DDTiposPersona.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodTipoPersona())));
				}
				if (!Checks.esNulo(titDto.getCodPais())) {
					titAdi.setPais(genericDao.get(DDPaises.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodPais())));
				}
				if (!Checks.esNulo(titDto.getCodTipoDocumentoRepresentante())) {
					titAdi.setTipoDocumentoRepresentante(genericDao.get(DDTipoDocumento.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodTipoDocumentoRepresentante())));
				}
				if (!Checks.esNulo(titDto.getDocumentoRepresentante())) {
					titAdi.setDocumentoRepresentante(titDto.getDocumentoRepresentante());
				}
				if (!Checks.esNulo(titDto.getDireccionRepresentante())) {
					titAdi.setDireccionRepresentante(titDto.getDireccionRepresentante());
				}
				if (!Checks.esNulo(titDto.getCodProvinciaRepresentante())) {
					titAdi.setProvinciaRepresentante(genericDao.get(DDProvincia.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodProvinciaRepresentante())));
				}

				if (!Checks.esNulo(titDto.getCodMunicipioRepresentante())) {
					titAdi.setMunicipioRepresentante(genericDao.get(Localidad.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodMunicipioRepresentante())));
				}

				if (!Checks.esNulo(titDto.getCodPaisRepresentante())) {
					titAdi.setPaisRepresentante(genericDao.get(DDPaises.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodPaisRepresentante())));
				}

				if (!Checks.esNulo(titDto.getCodigoPostalRepresentante())) {
					titAdi.setCodPostalRepresentante(titDto.getCodigoPostalRepresentante());
				}

				listaTit.add(titAdi);
				genericDao.save(TitularesAdicionalesOferta.class, titAdi);
			}
		}
		oferta.setTitularesAdicionales(listaTit);
	}

	@Override
	@Transactional(readOnly = false)
	public HashMap<String, String> updateOferta(Oferta oferta, OfertaDto ofertaDto, Object jsonFields)
			throws Exception {
		HashMap<String, String> errorsList = null;
		// ValidateUpdate
		errorsList = validateOfertaPostRequestData(ofertaDto, jsonFields, false);
		if (errorsList.isEmpty()) {
			boolean modificado = false;
			if (!Checks.esNulo(ofertaDto.getTitularesAdicionales())) {
				saveOrUpdateListaTitualesAdicionalesOferta(ofertaDto, oferta, true);
				modificado = true;
			}

			if (((JSONObject) jsonFields).containsKey("importeContraoferta")) {
				oferta.setImporteContraOferta(ofertaDto.getImporteContraoferta());
				modificado = true;
			}

			if (ofertaDto.getIdOfertaWebcom() != null && !ofertaDto.getIdOfertaWebcom().equals(oferta.getIdWebCom())) {
				oferta.setIdWebCom(ofertaDto.getIdOfertaWebcom());
				modificado = true;
			}

			if (!Checks.esNulo(ofertaDto.getObservaciones())
					&& !ofertaDto.getObservaciones().equals(oferta.getObservaciones())) {
				oferta.setObservaciones(ofertaDto.getObservaciones());
			}

			if (!Checks.esNulo(ofertaDto.getFinanciacion())
					&& ofertaDto.getFinanciacion().equals(oferta.getNecesitaFinanciacion())) {
				oferta.setNecesitaFinanciacion(ofertaDto.getFinanciacion());
			}

			if (!Checks.esNulo(ofertaDto.getIsExpress())
					&& ofertaDto.getIsExpress().equals(oferta.getOfertaExpress())) {
				oferta.setOfertaExpress(ofertaDto.getIsExpress());
			}
			
			if (!Checks.esNulo(ofertaDto.getOrigenLeadProveedor())) {
				DDOrigenComprador origenComprador = genericDao.get(DDOrigenComprador.class, genericDao.createFilter(FilterType.EQUALS,
						"codigo", ofertaDto.getOrigenLeadProveedor()));
				if (!Checks.esNulo(origenComprador)) {
					oferta.setOrigenComprador(origenComprador);
				}
			}

			if (modificado) {
				ofertaDao.saveOrUpdate(oferta);
			}

			if (((JSONObject) jsonFields).containsKey("importeContraoferta")) {
				// Actualizar honorarios para el nuevo importe de contraoferta.
				ExpedienteComercial expedienteComercial = expedienteComercialApi
						.expedienteComercialPorOferta(oferta.getId());
				if (!Checks.esNulo(expedienteComercial)) {
					expedienteComercialApi.actualizarHonorariosPorExpediente(expedienteComercial.getId());
				}
			}
			if(DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
				oferta = updateEstadoOferta(oferta.getId(), ofertaDto.getFechaAccion());
			}
			this.updateStateDispComercialActivosByOferta(oferta);

			if (!Checks.esNulo(ofertaDto.getCodTarea())) {
				errorsList = avanzaTarea(oferta, ofertaDto, errorsList);
			}
			
			if (!Checks.esNulo(ofertaDto.getEsOfertaSingular())
					&& ofertaDto.getEsOfertaSingular().equals(oferta.getOfertaSingular())) {
				oferta.setOfertaSingular(ofertaDto.getEsOfertaSingular());
			}

		}

		return errorsList;
	}

	@Transactional(readOnly = false)
	private Oferta updateEstadoOferta(Long idOferta, Date fechaAccion) throws Exception {

		Oferta ofertaAcepted = null;
		//Boolean inLoteComercial = false;
		Boolean incompatible = false;
		Oferta oferta = this.getOfertaById(idOferta);

		List<ActivoOferta> listaActivoOferta = oferta.getActivosOferta();

		if (listaActivoOferta != null && listaActivoOferta.size() > 0) {
			ActivoOferta actOfr = listaActivoOferta.get(0);
			if (!Checks.esNulo(actOfr) && !Checks.esNulo(actOfr.getPrimaryKey().getActivo())) {
				ofertaAcepted = getOfertaAceptadaExpdteAprobado(actOfr.getPrimaryKey().getActivo());
			}
		}

		if (listaActivoOferta != null && !listaActivoOferta.isEmpty()) {
			for (ActivoOferta activoOferta : listaActivoOferta) {
				Activo act = activoOferta.getPrimaryKey().getActivo();
				if (!Checks.esNulo(act)) {

					// HREOS-1674 - Si 1 activo pertenece a un lote comercial,
					// ésta debe crearse
					// siempre congelada.
					/* if (activoAgrupacionActivoDao.activoEnAgrupacionLoteComercial(act.getId())) {
						inLoteComercial = true;
					}*/

					// HREOS-1669 - Validar el tipo destino comercial
					if (!Checks.esNulo(act.getActivoPublicacion()) && !Checks.esNulo(act.getActivoPublicacion().getTipoComercializacion()) && !Checks.esNulo(oferta.getTipoOferta())) {
						String comercializacion = act.getActivoPublicacion().getTipoComercializacion().getCodigo();

						if ((DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())
								&& (!DDTipoComercializacion.CODIGO_VENTA.equals(comercializacion)
										&& !DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(comercializacion)))
								|| (DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())
										&& (!DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(comercializacion)
												&& !DDTipoComercializacion.CODIGO_ALQUILER_VENTA
														.equals(comercializacion)))) {
							incompatible = true;
						}
					}
				}
			}
		}

		if (!Checks.esNulo(ofertaAcepted)) {
			if (oferta.getAgrupacion() != null) {
				oferta.setEstadoOferta(genericDao.get(DDEstadoOferta.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_PENDIENTE)));
			} else {
				oferta.setEstadoOferta(genericDao.get(DDEstadoOferta.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_CONGELADA)));
			}
		} else {
			if (oferta.getOfertaExpress()) {
				oferta.setEstadoOferta(genericDao.get(DDEstadoOferta.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_ACEPTADA)));

				// Congelar resto de ofertas
				for (ActivoOferta actOfer : oferta.getActivoPrincipal().getOfertas()) {

					if (!Checks.esNulo(actOfer.getPrimaryKey().getOferta())
							&& !actOfer.getPrimaryKey().getOferta().equals(oferta) && DDEstadoOferta.CODIGO_PENDIENTE
									.equals(actOfer.getPrimaryKey().getOferta().getEstadoOferta().getCodigo())) {
						Oferta ofercongelada = actOfer.getPrimaryKey().getOferta();
						ofercongelada.setEstadoOferta(genericDao.get(DDEstadoOferta.class,
								genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_CONGELADA)));
						ofertaDao.saveOrUpdate(ofercongelada);
					}

				}

				// Se creará un expediente comercial asociado y se colocará el
				// trámite en la tarea Resultado PBC
				List<Activo> listaActivos = new ArrayList<Activo>();
				for (ActivoOferta activoOferta : oferta.getActivosOferta()) {
					listaActivos.add(activoOferta.getPrimaryKey().getActivo());
				}

				DDSubtipoTrabajo subtipoTrabajo = (DDSubtipoTrabajo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSubtipoTrabajo.class, tramitacionOfertasManager.getSubtipoTrabajoByOferta(oferta));

				Trabajo trabajo = trabajoApi.create(subtipoTrabajo, listaActivos, null, false);
				tramitacionOfertasManager.crearExpediente(oferta, trabajo, null);
				ActivoTramite activoTramite = trabajoApi.createTramiteTrabajo(trabajo);

				adapter.saltoInstruccionesReserva(activoTramite.getProcessBPM());

				// Se copiará el valor del campo necesita financiación al campo
				// asociado del expediente comercial
				ExpedienteComercial expComercial = genericDao.get(ExpedienteComercial.class,
						genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId()));
				CondicionanteExpediente coe = expComercial.getCondicionante();
				if (!Checks.esNulo(coe)) {
					coe.setSolicitaFinanciacion(oferta.getNecesitaFinanciacion() ? 1 : 0);
				}
				DDEstadosExpedienteComercial estadoExpCom = expedienteComercialApi
						.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.APROBADO);
				expComercial.setEstado(estadoExpCom);
				expComercial.setFechaSancion(new Date());

				genericDao.update(ExpedienteComercial.class, expComercial);

			}else{
				oferta.setEstadoOferta(genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_PENDIENTE)));
			}
		}

		oferta.setFechaAlta(fechaAccion);

		// Si el activo de la oferta no comercializable, vendido, no publicado
		// rechazamos la oferta
		if (listaActivoOferta != null && !listaActivoOferta.isEmpty()) {
			for (ActivoOferta activoOferta : listaActivoOferta) {
				Activo activo = activoOferta.getPrimaryKey().getActivo();
				if (incompatible
						|| (activo.getSituacionComercial() != null && activo.getSituacionComercial().getCodigo()
								.equals(DDSituacionComercial.CODIGO_VENDIDO))
						|| (activo.getSituacionComercial() != null && activo.getSituacionComercial().getCodigo()
								.equals(DDSituacionComercial.CODIGO_NO_COMERCIALIZABLE))
						|| (activo.getSituacionComercial() != null && activo.getSituacionComercial().getCodigo()
								.equals(DDSituacionComercial.CODIGO_TRASPASADO))) {
					oferta.setEstadoOferta(genericDao.get(DDEstadoOferta.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_RECHAZADA)));
				}

			}
		}

		if (oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_RECHAZADA)) {
			oferta.setFechaRechazoOferta(fechaAccion);
		}
		ofertaDao.saveOrUpdate(oferta);
		return oferta;
	}

	@Override
	public List<ActivoOferta> buildListaActivoOferta(Activo activo, ActivoAgrupacion agrupacion, Oferta oferta)
			throws Exception {
		List<ActivoOferta> listaActOfr = new ArrayList<ActivoOferta>();

		if (Checks.esNulo(oferta)) {
			throw new Exception("Parámetros incorrectos. La oferta es nulo.");

		} else if ((Checks.esNulo(activo) && Checks.esNulo(agrupacion))
				|| (!Checks.esNulo(activo) && !Checks.esNulo(agrupacion))) {
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
			List<ActivoAgrupacionActivo> listaActivos = new ArrayList<ActivoAgrupacionActivo>();
			if(Checks.esNulo(agrupacion.getActivos()) || Checks.estaVacio(agrupacion.getActivos())) {
				listaActivos = activoAgrupacionActivoDao.getListActivoAgrupacionActivoByAgrupacionID(agrupacion.getId());
			} else {
				listaActivos = agrupacion.getActivos();
			}
			valoresTasacion = activoAgrupacionApi.asignarValoresTasacionAprobadoVenta(listaActivos);

			if (!Checks.estaVacio(valoresTasacion)) {
				// En cada activo de la agrupacion se añade una oferta en la
				// tabla ACT_OFR
				Double sumatorioImporte = Double.valueOf(0);
				for (ActivoAgrupacionActivo activos : listaActivos) {

					ActivoOferta activoOferta = new ActivoOferta();
					ActivoOfertaPk pk = new ActivoOfertaPk();

					pk.setActivo(activos.getActivo());
					pk.setOferta(oferta);
					activoOferta.setPrimaryKey(pk);

					if (!Checks.estaVacio(valoresTasacion)) {
						String participacion = String
								.valueOf(activoAgrupacionApi.asignarPorcentajeParticipacionEntreActivos(activos,
										valoresTasacion, valoresTasacion.get("total")));
						activoOferta.setPorcentajeParticipacion(Double.parseDouble(participacion));
						Double importe = (oferta.getImporteOferta() * Double.parseDouble(participacion)) / 100;
						String importeString = new DecimalFormat("#.##").format(importe);
						try{
							importe =  Double.parseDouble(importeString);
						}catch(NumberFormatException e){
							importeString = importeString.replace(",", ".");
							importe =  Double.parseDouble(importeString);
						}
						sumatorioImporte = sumatorioImporte +importe;
						activoOferta.setImporteActivoOferta(importe);
					}
					listaActOfr.add(activoOferta);
				}
				//Pueden producirse pequeños errores de redondeo, en cuyo caso, aplicamos la diferencia al ultimo actv de la lista
				if(listaActOfr != null && listaActOfr.size()>0 && oferta.getImporteOferta().compareTo(sumatorioImporte)>0){
					ActivoOferta elUltimo = listaActOfr.get(listaActOfr.size()-1);
					elUltimo.setImporteActivoOferta(elUltimo.getImporteActivoOferta()+(oferta.getImporteOferta()-sumatorioImporte));
				}else if(listaActOfr != null && listaActOfr.size()>0 && oferta.getImporteOferta().compareTo(sumatorioImporte)<0){
					ActivoOferta elUltimo = listaActOfr.get(listaActOfr.size()-1);
					elUltimo.setImporteActivoOferta(elUltimo.getImporteActivoOferta()-(sumatorioImporte-oferta.getImporteOferta()));
				}
			}
		}

		return listaActOfr;
	}
	
	//TODO meter la las comprobaciones cuando el cliente lo tenga claro, a la espera de Pier
	@Override
	public List<OfertasAgrupadasLbk> buildListaOfertasAgrupadasLbk(Oferta principal, Oferta dependiente, String claseOferta)
			throws Exception {
		List<OfertasAgrupadasLbk> ofertasAgrupadas = new ArrayList<OfertasAgrupadasLbk>();

 		OfertasAgrupadasLbk oferAgrupa = new OfertasAgrupadasLbk();
 		if (claseOferta.equals(DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE)) {
			oferAgrupa.setOfertaPrincipal(principal);
			oferAgrupa.setOfertaDependiente(dependiente);

 			
			Auditoria auditoria = Auditoria.getNewInstance();
			oferAgrupa.setAuditoria(auditoria);
			ofertasAgrupadas.add(oferAgrupa);
 		}
		
		return ofertasAgrupadas;
	}
	
	public void actualizaPrincipalId (OfertasAgrupadasLbk ofertaAgrupada, Oferta nuevaOfertaPrincipal) {

		ofertaAgrupada.setOfertaPrincipal(nuevaOfertaPrincipal);
		genericDao.update(OfertasAgrupadasLbk.class, ofertaAgrupada);
	}

	/**
	 * nuevaOfertaPrincipal es el nuevo ID al que deben ir las ofertas agrupadas
	 * ofertasAgrupadas es el listado de ofertas al que hay que cambiarle el id principal
	 */
	public void actualizaListadoPrincipales (Oferta nuevaOfertaPrincipal, List<OfertasAgrupadasLbk> ofertasAgrupadas) {
		if (!Checks.esNulo(ofertasAgrupadas)) {
			for (OfertasAgrupadasLbk lisOf : ofertasAgrupadas) {
				lisOf.setOfertaPrincipal(nuevaOfertaPrincipal);
				genericDao.update(OfertasAgrupadasLbk.class, lisOf);
			}
		}
	}

	public void actualizaClaseOferta (Oferta oferta, String codigoOferta) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoOferta);
		DDClaseOferta claseOferta = genericDao.get(DDClaseOferta.class, filtro);

		oferta.setClaseOferta(claseOferta);
		genericDao.update(Oferta.class, oferta);
	}
	
	public void borradoOfertaAgrupadaDependiente(Oferta oferta) {
		try {
			Long idOfertaLBK = ofertasAgrupadasLbkDao.getIdOfertaAgrupadaLBK(oferta.getId());
			genericDao.deleteById(OfertasAgrupadasLbk.class, idOfertaLBK);
		}catch(Exception e) {
			logger.error(e.getMessage());
		}
	}
	
	@Override
	public DDEstadoOferta getDDEstadosOfertaByCodigo(String codigo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
		return genericDao.get(DDEstadoOferta.class, filtro);
	}

	@Override
	@Transactional(readOnly = false)
	public void updateStateDispComercialActivosByOferta(Oferta oferta) {
		if (oferta.getActivosOferta() != null && !oferta.getActivosOferta().isEmpty()) {
			ArrayList<Long> idActivoActualizarPublicacion = new ArrayList<Long>();
			for (ActivoOferta activoOferta : oferta.getActivosOferta()) {
				Activo activo = activoOferta.getPrimaryKey().getActivo();
				if(!Checks.esNulo(oferta.getOfertaExpress()) && oferta.getOfertaExpress() && DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())){
					updaterState.updaterStateDisponibilidadComercialAndSave(activo,true);
				}else{
					updaterState.updaterStateDisponibilidadComercialAndSave(activo,false);
				}
				idActivoActualizarPublicacion.add(activo.getId());
			}
			activoAdapterApi.actualizarEstadoPublicacionActivo(idActivoActualizarPublicacion,false);
		}
	}

	@Override
	public Oferta trabajoToOferta(Trabajo trabajo) {
		ExpedienteComercial expediente = expedienteComercialApi.findOneByTrabajo(trabajo);

		if(!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getOferta())) {
			return expediente.getOferta();
		}
		return null;
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
	@Transactional(readOnly = false)
	public Boolean rechazarOferta(Oferta oferta) {
		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_RECHAZADA);
			DDEstadoOferta estado = genericDao.get(DDEstadoOferta.class, filtro);
			oferta.setEstadoOferta(estado);
			Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			oferta.setUsuarioBaja(usu.getApellidoNombre());
			updateStateDispComercialActivosByOferta(oferta);
			darDebajaAgrSiOfertaEsLoteCrm(oferta);
			genericDao.save(Oferta.class, oferta);

		} catch (Exception e) {
			logger.error("error en OfertasManager", e);
			return false;
		}
		return true;

	}

	@Transactional(readOnly = false)
	@Override
	public void descongelarOfertas(ExpedienteComercial expediente) throws Exception {
		DDEstadoOferta estado = null;
		Filter filtro = null;
		boolean descongelar = false;

		if (Checks.esNulo(expediente)) {
			throw new Exception("Parámetros incorrectos. El expediente es nulo.");
		} else {

			// Descongela el resto de ofertas del activo
			List<Oferta> listaOfertas = this.trabajoToOfertas(expediente.getTrabajo());
			if (!Checks.esNulo(listaOfertas)) {
				for (Oferta oferta : listaOfertas) {
					ExpedienteComercial exp = expedienteComercialApi.findOneByOferta(oferta);
					descongelar = gencatApi.descongelaExpedienteGencat(exp);
					if ((DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo())) && descongelar) {
						// HREOS-1937 - Si tiene expediente poner oferta
						// ACEPTADA. Si no tiene poner oferta PENDIENTE
						if (!Checks.esNulo(exp)) {
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
									DDEstadoOferta.CODIGO_ACEPTADA);
						} else {
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
									DDEstadoOferta.CODIGO_PENDIENTE);
						}
							estado = genericDao.get(DDEstadoOferta.class, filtro);
							oferta.setEstadoOferta(estado);
							updateStateDispComercialActivosByOferta(oferta);
							genericDao.save(Oferta.class, oferta);

							if (!Checks.esNulo(exp) && !Checks.esNulo(exp.getTrabajo())) {
								List<ActivoTramite> tramites = activoTramiteApi
										.getTramitesActivoTrabajoList(exp.getTrabajo().getId());
								if (!Checks.estaVacio(tramites)) {
									Set<TareaActivo> tareasTramite = tramites.get(0).getTareas();
									for (TareaActivo tarea : tareasTramite) {
										// Si se ha borrado sin acabarse, al
										// descongelar se vuelven a mostrar.
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
	public void congelarOfertasPendientes(ExpedienteComercial expediente) throws Exception {
		DDEstadoOferta estado = null;
		Filter filtro = null;

		if (Checks.esNulo(expediente)) {
			throw new Exception("Parámetros incorrectos. El expediente es nulo.");
		} else {

			// Congela el resto de ofertas del activo
			List<Oferta> listaOfertas = this.trabajoToOfertas(expediente.getTrabajo());
			if (!Checks.esNulo(listaOfertas)) {

				for (Oferta ofr : listaOfertas) {
					if (!ofr.getId().equals(expediente.getOferta().getId())
							&& !DDEstadoOferta.CODIGO_RECHAZADA.equals(ofr.getEstadoOferta().getCodigo())) {

						ExpedienteComercial exp = expedienteComercialApi.findOneByOferta(ofr);

						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_CONGELADA);
						estado = genericDao.get(DDEstadoOferta.class, filtro);
						ofr.setEstadoOferta(estado);
						updateStateDispComercialActivosByOferta(ofr);
						genericDao.save(Oferta.class, ofr);

						if (!Checks.esNulo(exp) && !Checks.esNulo(exp.getTrabajo())) {
							List<ActivoTramite> tramites = activoTramiteApi
									.getTramitesActivoTrabajoList(exp.getTrabajo().getId());
							ActivoTramite tramite = tramites.get(0);

							Set<TareaActivo> tareasTramite = tramite.getTareas();
							// Al congelar, borramos las tareas que estuvieran
							// pendientes para que no se muestren.
							for (TareaActivo tarea : tareasTramite) {
								tarea.getAuditoria().setBorrado(true);
							}
						}
					}
				}
			}
		}
	}

	@Transactional(readOnly = false)
	@Override
	public Boolean congelarOferta(Oferta oferta) {
		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_CONGELADA);
			DDEstadoOferta estado = genericDao.get(DDEstadoOferta.class, filtro);
			oferta.setEstadoOferta(estado);
			updateStateDispComercialActivosByOferta(oferta);
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
	
	@Transactional(readOnly = false)
	@Override
	public Boolean finalizarOferta(Oferta oferta) {
		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_RECHAZADA);
			DDEstadoOferta estado = genericDao.get(DDEstadoOferta.class, filtro);
			oferta.setEstadoOferta(estado);
			updateStateDispComercialActivosByOferta(oferta);
			genericDao.save(Oferta.class, oferta);

			ExpedienteComercial expediente = expedienteComercialApi.findOneByOferta(oferta);
			if (!Checks.esNulo(expediente)) {
				Trabajo trabajo = expediente.getTrabajo();
				List<ActivoTramite> tramites = activoTramiteApi.getTramitesActivoTrabajoList(trabajo.getId());
				ActivoTramite tramite = tramites.get(0);

				Set<TareaActivo> tareasTramite = tramite.getTareas();
				for (TareaActivo tarea : tareasTramite) {
					if (Checks.esNulo(tarea.getFechaFin())) {
						tarea.setFechaFin(new Date());
						tarea.getAuditoria().setBorrado(true);
					}
				}
			}
			descongelarOfertas(expediente);
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
			if (DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo()))
				return oferta;
		}
		return null;
	}

	@Override
	public Oferta getOfertaAceptadaExpdteAprobado(Activo activo) {
		List<ActivoOferta> listaOfertas = activo.getOfertas();

		if (!Checks.estaVacio(listaOfertas)) {
			for (ActivoOferta activoOferta : listaOfertas) {
				Oferta oferta = activoOferta.getPrimaryKey().getOferta();
				if (oferta.getEstadoOferta() != null && DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
					ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
					if(!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getEstado())){
						if (DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.PTE_CIERRE.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.PTE_FIRMA.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.PTE_PBC.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.PTE_POSICIONAMIENTO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.FIRMADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.POSICIONADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.ALQUILADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.EN_DEVOLUCION.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.BLOQUEO_ADM.equals(expediente.getEstado().getCodigo()))

							return oferta;
						}
					}
			}
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
	public boolean checkReserva(Oferta ofertaAceptada) {
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
			List<CompradorExpediente> listaCex = expediente.getCompradores();
			Double total = new Double(0);
			for (CompradorExpediente cex : listaCex) {
				total += cex.getPorcionCompra();
			}
			return total.equals(new Double(100));
		}
		return false;
	}

	@Override
	public Boolean checkProvinciaCompradores(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());

			if(!Checks.esNulo(ofertaAceptada.getAgrupacion())){
				ActivoAgrupacion agrupacion = ofertaAceptada.getAgrupacion();

				ActivoAgrupacionActivo aga = agrupacion.getActivos().get(0);

				if(!Checks.esNulo(expediente) && !Checks.esNulo(aga) && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(aga.getActivo().getCartera().getCodigo())){
					List<CompradorExpediente> listaCex = expediente.getCompradores();
					Boolean tienenProvincia = true;

					for(CompradorExpediente cex: listaCex){
						Comprador com = cex.getPrimaryKey().getComprador();
						if(!Checks.esNulo(com) && Checks.esNulo(com.getProvincia())){
							tienenProvincia = false;
							break;
						}
					}

					return tienenProvincia;
				} else if (!Checks.esNulo(aga) && !DDCartera.CODIGO_CARTERA_LIBERBANK.equals(aga.getActivo().getCartera().getCodigo())){
					return true;
				}
			}else{
				List<ActivoOferta> activosOferta = genericDao.getList(ActivoOferta.class, genericDao.createFilter(FilterType.EQUALS, "oferta", ofertaAceptada.getId()));
				Activo activo = activosOferta.get(0).getPrimaryKey().getActivo();

				if(!Checks.esNulo(expediente) && !Checks.esNulo(activo) && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())){
					List<CompradorExpediente> listaCex = expediente.getCompradores();
					Boolean tienenProvincia = true;

					for(CompradorExpediente cex: listaCex){
						Comprador com = cex.getPrimaryKey().getComprador();
						if(!Checks.esNulo(com) && Checks.esNulo(com.getProvincia())){
							tienenProvincia = false;
							break;
						}
					}

					return tienenProvincia;
				} else if (!Checks.esNulo(activo) && !DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())){
					return true;
				}
			}

		}
		return false;
	}

	@Override
	public Boolean checkNifConyugueLBB(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);

		try {
			if (!Checks.esNulo(ofertaAceptada)) {
				ExpedienteComercial expediente = expedienteComercialApi
						.expedienteComercialPorOferta(ofertaAceptada.getId());

				if(!Checks.esNulo(ofertaAceptada.getAgrupacion())){
					ActivoAgrupacion agrupacion = ofertaAceptada.getAgrupacion();

					ActivoAgrupacionActivo aga = agrupacion.getActivos().get(0);

					if(!Checks.esNulo(expediente) && !Checks.esNulo(aga) && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(aga.getActivo().getCartera().getCodigo())){
						List<CompradorExpediente> listaCex = expediente.getCompradores();
						Boolean tieneNifConyugue = true;

						for(CompradorExpediente cex: listaCex){
							if(!Checks.esNulo(cex) && cex.getEstadoCivil() != null && DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO.equals(cex.getEstadoCivil().getCodigo()) && Checks.esNulo(cex.getDocumentoConyuge())
									&& DDRegimenesMatrimoniales.COD_GANANCIALES.equals(cex.getRegimenMatrimonial().getCodigo())){
								tieneNifConyugue = false;
								break;
							}
						}

						return tieneNifConyugue;
					} else if (!Checks.esNulo(aga) && !DDCartera.CODIGO_CARTERA_LIBERBANK.equals(aga.getActivo().getCartera().getCodigo())){
						return true;
					}
				}else{
					List<ActivoOferta> activosOferta = genericDao.getList(ActivoOferta.class, genericDao.createFilter(FilterType.EQUALS, "oferta", ofertaAceptada.getId()));
					Activo activo = activosOferta.get(0).getPrimaryKey().getActivo();

					if(!Checks.esNulo(expediente) && !Checks.esNulo(activo) && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())){
						List<CompradorExpediente> listaCex = expediente.getCompradores();
						Boolean tieneNifConyugue = true;

						for(CompradorExpediente cex: listaCex){
							if(!Checks.esNulo(cex) && !Checks.esNulo(cex.getEstadoCivil()) && !Checks.esNulo(cex.getRegimenMatrimonial())
									&& DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO.equals(cex.getEstadoCivil().getCodigo()) && Checks.esNulo(cex.getDocumentoConyuge())
									&& DDRegimenesMatrimoniales.COD_GANANCIALES.equals(cex.getRegimenMatrimonial().getCodigo())){
								tieneNifConyugue = false;
								break;
							}
						}

						return tieneNifConyugue;
					} else if (!Checks.esNulo(activo) && !DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())){
						return true;
					}
				}

			}
		} catch (NullPointerException e) {
			e.printStackTrace();
			return true;
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
	public void saveOrUpdateOfertas(List<OfertaDto> listaOfertaDto, JSONObject jsonFields, ArrayList<Map<String, Object>> listaRespuesta)
			throws Exception {
		Map<String, Object> map = null;
		OfertaDto ofertaDto = null;
		Oferta oferta = null;
		HashMap<String, String> errorsList = null;
		boolean error = false;

		for (int i = 0; i < listaOfertaDto.size(); i++) {

			map = new HashMap<String, Object>();
			ofertaDto = listaOfertaDto.get(i);

			// idrem puede venir o no, el idWebcom es obligatorio
			if (!Checks.esNulo(ofertaDto.getIdOfertaRem())) {
				oferta = ofertaDao.getOfertaByIdRem(ofertaDto.getIdOfertaRem());
			} else {
				oferta = ofertaDao.getOfertaByIdwebcom(ofertaDto.getIdOfertaWebcom());
			}

			if (Checks.esNulo(oferta)) {
				errorsList = this.saveOferta(ofertaDto);

			} else {
				errorsList = this.updateOferta(oferta, ofertaDto, jsonFields.getJSONArray("data").get(i));

			}

			if ((!Checks.esNulo(errorsList) && errorsList.isEmpty())
					|| (!Checks.esNulo(errorsList) && !Checks.esNulo(errorsList.get("codigoAgrupacionComercialRem")))) {
				if (oferta == null || oferta.getNumOferta() == null) {
					oferta = ofertaDao.getOfertaByIdwebcom(ofertaDto.getIdOfertaWebcom());
				}
				map.put("idOfertaWebcom", ofertaDto.getIdOfertaWebcom());
				if (oferta != null) {
					map.put("idOfertaRem", oferta.getNumOferta());
				} else {
					map.put("idOfertaRem", null);
				}
				if(!Checks.esNulo(errorsList.get("codigoAgrupacionComercialRem"))) {
					map.put("codigoAgrupacionComercialRem", errorsList.get("codigoAgrupacionComercialRem"));
				}

				if(!Checks.esNulo(oferta.getAgrupacion()) && !Checks.esNulo(oferta.getAgrupacion().getNumAgrupRem())
						&& (ofertaDto.getOfertaLote() != null  && ofertaDto.getOfertaLote())) {
					map.put("idAgrupacionComercialRem", oferta.getAgrupacion().getNumAgrupRem());
				}

				map.put("success", true);
			} else {
				map.put("idOfertaWebcom", ofertaDto.getIdOfertaWebcom());
				map.put("idOfertaRem", ofertaDto.getIdOfertaRem());
				map.put("success", false);

				map.put("invalidFields", errorsList);
			}
			listaRespuesta.add(map);
		}
		if (error) {
			throw new UserException(new Exception());
		}
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

			if (DDCartera.CODIGO_CARTERA_LIBERBANK.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
				List<ActivoOferta> actOfr = oferta.getActivosOferta();

				for (int i = 0; i < actOfr.size(); i++) {

					Activo activo = actOfr.get(i).getPrimaryKey().getActivo();

					List<ActivoValoraciones> activoValoraciones = genericDao.getList(ActivoValoraciones.class,
							genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));

					Double deudaBruta = null;
					Double valorNetoContable = null;

					for (ActivoValoraciones valoracion : activoValoraciones) {
						if (DDTipoPrecio.CODIGO_TPC_DEUDA_BRUTA_LIBERBANK.equals(valoracion.getTipoPrecio().getCodigo())) {
							deudaBruta = valoracion.getImporte();
						} else if (DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT_LIBERBANK
								.equals(valoracion.getTipoPrecio().getCodigo())) {
							valorNetoContable = valoracion.getImporte();
						}
					}

					if (!Checks.esNulo(deudaBruta) && !Checks.esNulo(valorNetoContable)) {
						if (deudaBruta > DDTipoPrecio.MAX_DEUDA_BRUTA_LIBERBANK) {
							if (DDTipoActivo.COD_SUELO.equals(activo.getTipoActivo().getCodigo())
									|| DDTipoActivo.COD_EN_COSTRUCCION.equals(activo.getTipoActivo().getCodigo())) {

								if (1D - valorNetoContable / deudaBruta > 0.6D) {
									return false;
								}
							} else if (1D - valorNetoContable / deudaBruta > 0.5D) {
								return false;
							}
						}
					}

				}
			}

			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
			if (!Checks.esNulo(expediente)) {
				if (!Checks.esNulo(expediente.getComiteSancion())) {
					String codigoComiteSancion = expediente.getComiteSancion().getCodigo();
					if (DDComiteSancion.CODIGO_HAYA_CAJAMAR.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_HAYA_SAREB.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_PLATAFORMA.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_HAYA_TANGO.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_TANGO_TANGO.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_HAYA_GIANTS.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_HAYA_LIBERBANK.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_THIRD_PARTIES_YUBAI.equals(codigoComiteSancion))
						return true;
				} else {
					if (trabajoApi.checkBankia(tareaExterna)) {
						String codigoComite = null;
						try {
							codigoComite = expedienteComercialApi.consultarComiteSancionador(expediente.getId());
						} catch (Exception e) {
							logger.error("error en OfertasManager", e);
						}
						if (DDComiteSancion.CODIGO_PLATAFORMA.equals(codigoComite))
							return true;
					}
				}
			}
		}

		return false;
	}


	@Override
	public boolean checkComiteSancionadorAlquilerHaya(TareaExterna tareaExterna) {
		Oferta oferta = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(oferta)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
			if (!Checks.esNulo(expediente)) {
				if (!Checks.esNulo(expediente.getComiteAlquiler())) {
					String codigoComiteSancionAlquiler = expediente.getComiteAlquiler().getCodigo();
					if (DDComiteAlquiler.CODIGO_HAYA_CAJAMAR.equals(codigoComiteSancionAlquiler)
							|| DDComiteAlquiler.CODIGO_HAYA_SAREB.equals(codigoComiteSancionAlquiler)
							|| DDComiteAlquiler.CODIGO_HAYA_TANGO.equals(codigoComiteSancionAlquiler)
							|| DDComiteAlquiler.CODIGO_HAYA_GIANTS.equals(codigoComiteSancionAlquiler)
							|| DDComiteAlquiler.CODIGO_HAYA_LIBERBANK.equals(codigoComiteSancionAlquiler)
							|| DDComiteAlquiler.CODIGO_HAYA_BANKIA.equals(codigoComiteSancionAlquiler)
							|| DDComiteAlquiler.CODIGO_HAYA_OTRAS.equals(codigoComiteSancionAlquiler)
							|| DDComiteAlquiler.CODIGO_HAYA_HyT.equals(codigoComiteSancionAlquiler)
							|| DDComiteAlquiler.CODIGO_HAYA_CERBERUS.equals(codigoComiteSancionAlquiler))
						return true;
				}
			}
		}
		return false;
	}

	@Override
	public boolean checkAtribuciones(Trabajo trabajo) {
		Oferta oferta = trabajoToOferta(trabajo);
		return checkAtribuciones(oferta);
	}
	@Override
	public boolean checkAtribuciones(Oferta oferta) {
		if (!Checks.esNulo(oferta)) {
			if (DDCartera.CODIGO_CARTERA_LIBERBANK.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
				List<ActivoOferta> actOfr = oferta.getActivosOferta();

				for (int i = 0; i < actOfr.size(); i++) {

					Activo activo = actOfr.get(i).getPrimaryKey().getActivo();

					List<ActivoValoraciones> activoValoraciones = genericDao.getList(ActivoValoraciones.class,
							genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));

					Double deudaBruta = null;
					Double valorNetoContable = null;

					for (ActivoValoraciones valoracion : activoValoraciones) {
						if (DDTipoPrecio.CODIGO_TPC_DEUDA_BRUTA_LIBERBANK.equals(valoracion.getTipoPrecio().getCodigo())) {
							deudaBruta = valoracion.getImporte();
						} else if (DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT_LIBERBANK
								.equals(valoracion.getTipoPrecio().getCodigo())) {
							valorNetoContable = valoracion.getImporte();
						}
					}

					if (!Checks.esNulo(deudaBruta) && !Checks.esNulo(valorNetoContable)) {
						if (deudaBruta > DDTipoPrecio.MAX_DEUDA_BRUTA_LIBERBANK) {
							if (DDTipoActivo.COD_SUELO.equals(activo.getTipoActivo().getCodigo())
									|| DDTipoActivo.COD_EN_COSTRUCCION.equals(activo.getTipoActivo().getCodigo())) {

								if (1D - valorNetoContable / deudaBruta > 0.6D) {
									return false;
								}
							} else if (1D - valorNetoContable / deudaBruta > 0.5D) {
								return false;
							}
						}
					}
				}
			}

			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
			if (!Checks.esNulo(expediente)) {
				if (!Checks.esNulo(expediente.getComiteSancion())) {
					String codigoComiteSancion = expediente.getComiteSancion().getCodigo();
					if (DDComiteSancion.CODIGO_HAYA_CAJAMAR.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_HAYA_SAREB.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_PLATAFORMA.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_HAYA_TANGO.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_TANGO_TANGO.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_HAYA_HYT.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_HAYA_THIRD_PARTIES.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_HAYA_GIANTS.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_HAYA_LIBERBANK.equals(codigoComiteSancion)
							|| DDComiteSancion.CODIGO_THIRD_PARTIES_YUBAI.equals(codigoComiteSancion))
						return true;
				} else {
					if (Checks.esNulo(oferta.getActivoPrincipal())
							&& Checks.esNulo(oferta.getActivoPrincipal().getCartera())
							&& DDCartera.CODIGO_CARTERA_BANKIA
									.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
						String codigoComite = null;
						try {
							codigoComite = expedienteComercialApi.consultarComiteSancionador(expediente.getId());
						} catch (Exception e) {
							logger.error("error en OfertasManager", e);
						}
						if (DDComiteSancion.CODIGO_PLATAFORMA.equals(codigoComite))
							return true;
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
		Double porcentajeImpuesto = null;
		if (!Checks.esNulo(expediente.getCondicionante())) {
			if (!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
				porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable();
			} else {
				return false;
			}
		}

		try {
			InstanciaDecisionDto instanciaDecisionDto = expedienteComercialApi
					.expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto, null);
			ResultadoInstanciaDecisionDto resultadoDto = uvemManagerApi.altaInstanciaDecision(instanciaDecisionDto);
			String codigoComite = resultadoDto.getCodigoComite();
			DDComiteSancion comite = expedienteComercialApi.comiteSancionadorByCodigo(codigoComite);
			expediente.setComiteSancion(comite);
			expediente.setComiteSuperior(comite);
			this.guardarUvemCodigoAgrupacionInmueble(expediente, resultadoDto);
			if(!Checks.esNulo(resultadoDto.getCodigoOfertaUvem())){
				if(!Checks.esNulo(expediente.getOferta())){
					expediente.getOferta().setIdUvem(resultadoDto.getCodigoOfertaUvem().longValue());
				}
			}
			genericDao.save(ExpedienteComercial.class, expediente);

			return true;
		} catch (Exception e) {
			logger.error("Error en el alta de comite.", e);
			return false;
		}

	}

	@Override
	public String altaComiteProcess(TareaExterna tareaExterna, String codComiteSuperior) {

		try {

			Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());

			Double porcentajeImpuesto = null;
			if (!Checks.esNulo(expediente.getCondicionante())) {
				if (!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
					porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable();
				} else {
					logger.debug("Datos insuficientes para dar de alta un comité");
					throw new JsonViewerException("No ha sido posible realizar la operación");
				}
			}

			InstanciaDecisionDto instanciaDecisionDto = expedienteComercialApi
					.expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto, codComiteSuperior);

			ResultadoInstanciaDecisionDto resultadoDto = uvemManagerApi.altaInstanciaDecision(instanciaDecisionDto);

			this.guardarUvemCodigoAgrupacionInmueble(expediente, resultadoDto);

			if(!Checks.esNulo(resultadoDto.getCodigoOfertaUvem())){
				if(!Checks.esNulo(expediente.getOferta())){
					expediente.getOferta().setIdUvem(resultadoDto.getCodigoOfertaUvem().longValue());
				}
			}
			genericDao.save(ExpedienteComercial.class, expediente);

			return null;
		} catch (JsonViewerException jve) {
			return jve.getMessage();
		} catch (Exception e) {
			logger.error("error en OfertasManager", e);
			return "No ha sido posible realizar la operación";
		}

	}

	/**
	 * Añadir código de la oferta en FFDD
	 *
	 * @param expediente
	 * @param resultadoDto
	 */
	private void guardarUvemCodigoAgrupacionInmueble(ExpedienteComercial expediente,
			ResultadoInstanciaDecisionDto resultadoDto) {
		if (expediente.getOferta().getAgrupacion() != null && resultadoDto.getCodigoAgrupacionInmueble() != null
				&& resultadoDto.getCodigoAgrupacionInmueble().compareTo(0) > 0) {
			expediente.getOferta().getAgrupacion().setUvemCodigoAgrupacionInmueble(resultadoDto.getCodigoAgrupacionInmueble());

		}
	}

	@Override
	public boolean ratificacionComite(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		Double porcentajeImpuesto = null;
		if (!Checks.esNulo(expediente.getCondicionante())) {
			if (!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
				porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable();
			} else {
				return false;
			}
		}

		try {
			InstanciaDecisionDto instanciaDecisionDto = expedienteComercialApi
					.expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto, null);
			uvemManagerApi.modificarInstanciaDecision(instanciaDecisionDto);
			return true;
		} catch (Exception e) {
			logger.error("error en OfertasManager", e);
			return false;
		}

	}

	@Override
	public String ratificacionComiteProcess(TareaExterna tareaExterna, String importeOfertante) {

		try {

			Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());
			Double porcentajeImpuesto = null;
			if (!Checks.esNulo(importeOfertante) && importeOfertante != "") {
				ofertaAceptada.setImporteContraOferta(Double.valueOf(importeOfertante.replace(',', '.')));
				genericDao.save(Oferta.class, ofertaAceptada);
				// Actualizar honorarios para el nuevo importe de contraoferta.
				expedienteComercialApi.actualizarHonorariosPorExpediente(expediente.getId());

				// Actualizamos la participación de los activos en la oferta;
				expedienteComercialApi.updateParticipacionActivosOferta(ofertaAceptada);
				expedienteComercialApi.actualizarImporteReservaPorExpediente(expediente);
				genericDao.save(ExpedienteComercial.class, expediente);
			}
			if (!Checks.esNulo(expediente.getCondicionante())) {
				if (!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
					porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable();
				} else {
					logger.debug("Datos insuficientes para ratificar comité");
					throw new JsonViewerException("No ha sido posible realizar la operación");
				}
			}

			InstanciaDecisionDto instanciaDecisionDto = expedienteComercialApi
					.expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto, null);
			uvemManagerApi.modificarInstanciaDecision(instanciaDecisionDto);
			return null;
		} catch (JsonViewerException jve) {
			return jve.getMessage();
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

	public String getFechaPosicionamiento(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		if (!Checks.estaVacio(expediente.getPosicionamientos())) {
			if (!Checks.esNulo(expediente.getUltimoPosicionamiento().getFechaPosicionamiento()))
				return groovyft.format(expediente.getUltimoPosicionamiento().getFechaPosicionamiento());
			else
				return null;
		} else {
			return null;
		}
	}

	@Override
	public DtoDetalleOferta getDetalleOfertaById(Long idOferta) {
		DtoDetalleOferta dtoResponse = new DtoDetalleOferta();

		if (!Checks.esNulo(idOferta)) {

			Oferta oferta = this.getOfertaById(idOferta);

			if (!Checks.esNulo(oferta)) {
				dtoResponse.setNumOferta(oferta.getNumOferta().toString());
				Filter filter = genericDao.createFilter(FilterType.EQUALS, "username",
						oferta.getAuditoria().getUsuarioCrear());
				Usuario usu = genericDao.get(Usuario.class, filter);
				if (usu != null) {
					dtoResponse.setUsuAlta(usu.getApellidoNombre());
				} else {
					dtoResponse.setUsuAlta(oferta.getAuditoria().getUsuarioCrear());
				}
				dtoResponse.setUsuBaja(oferta.getUsuarioBaja());
				if (!Checks.esNulo(oferta.getVisita())) {
					dtoResponse.setNumVisitaRem(oferta.getVisita().getNumVisitaRem().toString());
				}
				if (!Checks.esNulo(oferta.getIntencionFinanciar())) {
					dtoResponse.setIntencionFinanciar(oferta.getIntencionFinanciar().equals(1) ? "Si" : "No");
				}
				if (!Checks.esNulo(oferta.getVisita()) && !Checks.esNulo(oferta.getVisita().getPrescriptor())
						&& !Checks.esNulo(oferta.getVisita().getPrescriptor().getTipoProveedor())) {
					dtoResponse.setProcedenciaVisita(
							oferta.getVisita().getPrescriptor().getTipoProveedor().getDescripcion());
				}
				if (!Checks.esNulo(oferta.getSucursal())) {
					dtoResponse.setSucursal(oferta.getSucursal().getNombre() + " ("
							+ oferta.getSucursal().getTipoProveedor().getDescripcion() + ")");
				}
				if (!Checks.esNulo(oferta.getMotivoRechazo())) {
					dtoResponse.setMotivoRechazoDesc(oferta.getMotivoRechazo().getTipoRechazo().getDescripcion() + " - "
							+ oferta.getMotivoRechazo().getDescripcion());
				}
				if (!Checks.esNulo(oferta.getOfertaExpress())) {
					dtoResponse.setOfertaExpress(oferta.getOfertaExpress() ? "Si" : "No");
				}
				if (!Checks.esNulo(oferta.getNecesitaFinanciacion())) {
					dtoResponse.setNecesitaFinanciacion(oferta.getNecesitaFinanciacion() ? "Si" : "No");
				}
				dtoResponse.setObservaciones(oferta.getObservaciones());

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
				dto.setId(String.valueOf(oferta.getCliente().getId() + "c"));
				if (!Checks.esNulo(oferta.getCliente().getTipoPersona())) {
					dto.setTipoPersona(oferta.getCliente().getTipoPersona().getDescripcion());
				}
				if (!Checks.esNulo(oferta.getCliente().getRegimenMatrimonial())) {
					dto.setRegimenMatrimonial(oferta.getCliente().getRegimenMatrimonial().getDescripcion());
				}
				if (!Checks.esNulo(oferta.getCliente().getEstadoCivil())) {
					dto.setEstadoCivil(oferta.getCliente().getEstadoCivil().getDescripcion());
				}
				listaOfertantes.add(dto);
			}

			Filter filterTitularOfertaID = genericDao.createFilter(FilterType.EQUALS, "oferta.id", idOferta);
			List<TitularesAdicionalesOferta> titularesAdicionales = genericDao.getList(TitularesAdicionalesOferta.class,
					filterTitularOfertaID);
			if (!Checks.estaVacio(titularesAdicionales)) {
				for (TitularesAdicionalesOferta titularAdicional : titularesAdicionales) {
					DtoOfertantesOferta dto = new DtoOfertantesOferta();
					if (!Checks.esNulo(titularAdicional.getTipoDocumento())) {
						dto.setTipoDocumento(titularAdicional.getTipoDocumento().getCodigo());
					}
					dto.setNumDocumento(titularAdicional.getDocumento());
					dto.setNombre(titularAdicional.getNombreCompleto());
					dto.setOfertaID(String.valueOf(oferta.getId()));
					dto.setId(String.valueOf(titularAdicional.getId() + "t"));
					if (!Checks.esNulo(titularAdicional.getTipoPersona())) {
						dto.setTipoPersona(titularAdicional.getTipoPersona().getDescripcion());
					}
					if (!Checks.esNulo(titularAdicional.getRegimenMatrimonial())) {
						dto.setRegimenMatrimonial(titularAdicional.getRegimenMatrimonial().getDescripcion());
					}
					if (!Checks.esNulo(titularAdicional.getEstadoCivil())) {
						dto.setEstadoCivil(titularAdicional.getEstadoCivil().getDescripcion());
					}
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

		if (dtoOfertantesOferta.getId().contains("c")) {
			dtoOfertantesOferta.setId(dtoOfertantesOferta.getId().replace("c", ""));
			Filter filterClienteID = genericDao.createFilter(FilterType.EQUALS, "id",
					Long.parseLong(dtoOfertantesOferta.getId()));
			ClienteComercial cliente = genericDao.get(ClienteComercial.class, filterClienteID);
			if (!Checks.esNulo(cliente)) {
				if (!Checks.esNulo(dtoOfertantesOferta.getTipoDocumento())) {
					DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTipoDocumento.class, dtoOfertantesOferta.getTipoDocumento());

					cliente.setTipoDocumento(tipoDocumento);
				}
				if (!Checks.esNulo(dtoOfertantesOferta.getNumDocumento())) {
					cliente.setDocumento(dtoOfertantesOferta.getNumDocumento());
				}
				genericDao.save(ClienteComercial.class, cliente);
			}
		} else if (dtoOfertantesOferta.getId().contains("t")) {
			dtoOfertantesOferta.setId(dtoOfertantesOferta.getId().replace("t", ""));
			Filter filterTitularOfertaID = genericDao.createFilter(FilterType.EQUALS, "id",
					Long.parseLong(dtoOfertantesOferta.getId()));
			TitularesAdicionalesOferta titular = genericDao.get(TitularesAdicionalesOferta.class,
					filterTitularOfertaID);
			if (!Checks.esNulo(titular)) {
				if (!Checks.esNulo(dtoOfertantesOferta.getTipoDocumento())) {
					DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTipoDocumento.class, dtoOfertantesOferta.getTipoDocumento());

					titular.setTipoDocumento(tipoDocumento);
				}
				if (!Checks.esNulo(dtoOfertantesOferta.getNumDocumento())) {
					titular.setDocumento(dtoOfertantesOferta.getNumDocumento());
				}
				genericDao.save(TitularesAdicionalesOferta.class, titular);
			}
		}
		return true;
	}

	@Override
	public List<DtoHonorariosOferta> getHonorariosByOfertaId(DtoHonorariosOferta dtoHonorariosOferta) {

		List<DtoHonorariosOferta> listaHonorarios = new ArrayList<DtoHonorariosOferta>();

		/*
		 * if (Checks.esNulo(dtoHonorariosOferta.getOfertaID())) { return
		 * listaHonorarios; } // Obtener la oferta y comprobar su estado, si el
		 * estado de la oferta es // aceptado obtener un listado de gastos
		 * expediente. Si no existen // expediente asociado a la oferta calcular
		 * los gastos. Filter filterOfertaID =
		 * genericDao.createFilter(FilterType.EQUALS, "id",
		 * Long.parseLong(dtoHonorariosOferta.getOfertaID())); Oferta oferta =
		 * genericDao.get(Oferta.class, filterOfertaID); if
		 * (!Checks.esNulo(oferta)) { if
		 * (!Checks.esNulo(oferta.getEstadoOferta()) &&
		 * oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.
		 * CODIGO_ACEPTADA)) { List<GastosExpediente> gastosExp =
		 * genericDao.getList(GastosExpediente.class,
		 * genericDao.createFilter(FilterType.EQUALS, "expediente.oferta.id",
		 * oferta.getId())); if (!Checks.estaVacio(gastosExp)) { for
		 * (GastosExpediente gastoExp : gastosExp) { DtoHonorariosOferta dto =
		 * new DtoHonorariosOferta(); dto.setId(gastoExp.getId().toString()); if
		 * (!Checks.esNulo(gastoExp.getAccionGastos())) {
		 * dto.setTipoComision(gastoExp.getAccionGastos().getDescripcion()); }
		 * if (!Checks.esNulo(gastoExp.getTipoProveedor())) {
		 * dto.setTipoProveedor(gastoExp.getTipoProveedor().getDescripcion()); }
		 * if (!Checks.esNulo(gastoExp.getProveedor())) {
		 * dto.setNombre(gastoExp.getProveedor().getNombreComercial());
		 * dto.setIdProveedor(gastoExp.getProveedor().getCodigoProveedorRem().
		 * toString()); } if (!Checks.esNulo(gastoExp.getTipoCalculo())) {
		 * dto.setTipoCalculo(gastoExp.getTipoCalculo().getDescripcion()); } if
		 * (!Checks.esNulo(gastoExp.getImporteCalculo())) {
		 * dto.setImporteCalculo(gastoExp.getImporteCalculo().toString()); } if
		 * (!Checks.esNulo(gastoExp.getImporteFinal())) {
		 * dto.setHonorarios(gastoExp.getImporteFinal().toString()); }
		 * listaHonorarios.add(dto); } } } else { // Primera fila honorario de
		 * colaboracion. DtoHonorariosOferta dtoColaboracion = new
		 * DtoHonorariosOferta(); DDAccionGastos accionGastoC = (DDAccionGastos)
		 * utilDiccionarioApi .dameValorDiccionarioByCod(DDAccionGastos.class,
		 * DDAccionGastos.CODIGO_COLABORACION); if
		 * (!Checks.esNulo(accionGastoC)) {
		 * dtoColaboracion.setTipoComision(accionGastoC.getDescripcion()); } if
		 * (!Checks.esNulo(oferta.getFdv())) { if
		 * (!Checks.esNulo(oferta.getFdv().getTipoProveedor())) {
		 * dtoColaboracion.setTipoProveedor(oferta.getFdv().getTipoProveedor().
		 * getDescripcion()); }
		 * dtoColaboracion.setNombre(oferta.getFdv().getNombreComercial());
		 * dtoColaboracion.setIdProveedor(oferta.getFdv().getCodigoProveedorRem(
		 * ).toString()); } else if (!Checks.esNulo(oferta.getCustodio())) { if
		 * (!Checks.esNulo(oferta.getCustodio().getTipoProveedor())) {
		 * dtoColaboracion.setTipoProveedor(oferta.getCustodio().
		 * getTipoProveedor().getDescripcion() ); }
		 * dtoColaboracion.setNombre(oferta.getCustodio().getNombreComercial());
		 * dtoColaboracion.setIdProveedor(oferta.getCustodio().
		 * getCodigoProveedorRem().toString()); } DDTipoCalculo tipoCalculoC =
		 * (DDTipoCalculo) utilDiccionarioApi
		 * .dameValorDiccionarioByCod(DDTipoCalculo.class,
		 * DDTipoCalculo.TIPO_CALCULO_PORCENTAJE); if
		 * (!Checks.esNulo(tipoCalculoC)) {
		 * dtoColaboracion.setTipoCalculo(tipoCalculoC.getDescripcion()); }
		 * BigDecimal resultadoC = ofertaDao.getImporteCalculo(oferta.getId(),
		 * OfertaManager.HONORARIO_TIPO_COLABORACION); if
		 * (!Checks.esNulo(resultadoC)) { Double calculoImporteC =
		 * resultadoC.doubleValue();
		 * dtoColaboracion.setImporteCalculo(calculoImporteC.toString()); Activo
		 * activo = genericDao.get(Activo.class,
		 * genericDao.createFilter(FilterType.EQUALS, "id",
		 * oferta.getActivoPrincipal().getId())); if (!Checks.esNulo(activo)) {
		 * ActivoTasacion tasacion = activoApi.getTasacionMasReciente(activo);
		 * if (!Checks.esNulo(tasacion)) { Double tasacionFin =
		 * tasacion.getImporteTasacionFin(); Double result = (tasacionFin *
		 * calculoImporteC / 100);
		 * dtoColaboracion.setHonorarios(String.format("%.2f", result)); } } }
		 * else { // Si el importe calculo está vacío mostrar 'Sin //
		 * Honorarios'. dtoColaboracion.setTipoCalculo("-");
		 * dtoColaboracion.setHonorarios("Sin Honorarios"); }
		 * listaHonorarios.add(dtoColaboracion); // Segunda fila honorario de
		 * colaboracion. DtoHonorariosOferta dtoPrescripcion = new
		 * DtoHonorariosOferta(); DDAccionGastos accionGastoP = (DDAccionGastos)
		 * utilDiccionarioApi .dameValorDiccionarioByCod(DDAccionGastos.class,
		 * DDAccionGastos.CODIGO_PRESCRIPCION); if
		 * (!Checks.esNulo(accionGastoP)) {
		 * dtoPrescripcion.setTipoComision(accionGastoP.getDescripcion()); } if
		 * (!Checks.esNulo(oferta.getPrescriptor())) { if
		 * (!Checks.esNulo(oferta.getPrescriptor().getTipoProveedor())) {
		 * dtoPrescripcion.setTipoProveedor(oferta.getPrescriptor().
		 * getTipoProveedor(). getDescripcion()); }
		 * dtoPrescripcion.setNombre(oferta.getPrescriptor().getNombreComercial(
		 * )); dtoPrescripcion.setIdProveedor(oferta.getPrescriptor().
		 * getCodigoProveedorRem().toString() ); } DDTipoCalculo tipoCalculoP =
		 * (DDTipoCalculo) utilDiccionarioApi
		 * .dameValorDiccionarioByCod(DDTipoCalculo.class,
		 * DDTipoCalculo.TIPO_CALCULO_PORCENTAJE); if
		 * (!Checks.esNulo(tipoCalculoP)) {
		 * dtoPrescripcion.setTipoCalculo(tipoCalculoP.getDescripcion()); }
		 * BigDecimal resultadoP = ofertaDao.getImporteCalculo(oferta.getId(),
		 * OfertaManager.HONORARIO_TIPO_PRESCRIPCION); if
		 * (!Checks.esNulo(resultadoP)) { Double calculoImporteP =
		 * resultadoP.doubleValue();
		 * dtoPrescripcion.setImporteCalculo(calculoImporteP.toString()); Activo
		 * activo = genericDao.get(Activo.class,
		 * genericDao.createFilter(FilterType.EQUALS, "id",
		 * oferta.getActivoPrincipal().getId())); if (!Checks.esNulo(activo)) {
		 * ActivoTasacion tasacion = activoApi.getTasacionMasReciente(activo);
		 * if (!Checks.esNulo(tasacion)) { Double tasacionFin =
		 * tasacion.getImporteTasacionFin(); Double result = (tasacionFin *
		 * calculoImporteP / 100);
		 * dtoPrescripcion.setHonorarios(String.format("%.2f", result)); } } }
		 * else { // Si el importe calculo está vacío mostrar 'Sin //
		 * Honorarios'. dtoPrescripcion.setImporteCalculo("-");
		 * dtoPrescripcion.setHonorarios("Sin Honorarios"); }
		 * listaHonorarios.add(dtoPrescripcion); } }
		 */

		return listaHonorarios;
	}

	@Override
	public List<DtoGastoExpediente> getHonorariosActivoByOfertaId(Long idActivo, Long idOferta) {

		String[] acciones = { DDAccionGastos.CODIGO_COLABORACION, DDAccionGastos.CODIGO_PRESCRIPCION,
				DDAccionGastos.CODIGO_RESPONSABLE_CLIENTE };

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
			if (!Checks.esNulo(oferta.getEstadoOferta())
					&& oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_ACEPTADA)) {
				// Si la oferta está aceptada, tendremos expediente y los
				// honorarios guardados....
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
		String codigoOferta = null;
		ActivoBancario activoBancario = genericDao.get(ActivoBancario.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
		
		Double importe = null;
		if (!Checks.esNulo(oferta)) {
			if(!Checks.esNulo(oferta.getImporteContraOferta())) {
				importe = oferta.getImporteContraOferta();
			}else {
				importe = oferta.getImporteOferta();
			}
			if (!Checks.esNulo(oferta.getTipoOferta())) {
				codigoOferta = oferta.getTipoOferta().getCodigo();
			}
		}
		
		String codLeadOrigin = null;
		String codTipoActivo = null;
		String tipoComercializar = null;
		String codSubtipoActivo = null;
		String codPortfolio = null;
		String codSubportfolio = null;
		String classType = null;
		
		if (!Checks.esNulo(activo)) {
			if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getOrigenComprador())) {
				codLeadOrigin = oferta.getOrigenComprador().getCodigo();
			} else if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getVisita()) && !Checks.esNulo(oferta.getVisita().getOrigenComprador())) {
				codLeadOrigin = oferta.getVisita().getOrigenComprador().getCodigo();
			} else {
				codLeadOrigin = DDOrigenComprador.CODIGO_ORC_HRE;
			}
			
			if (!Checks.esNulo(activo.getTipoComercializar())) {
				tipoComercializar = activo.getTipoComercializar().getCodigo();
			}
			
			if(!Checks.esNulo(activo.getTipoActivo())) {
				codTipoActivo = activo.getTipoActivo().getCodigo();
			}
			
			
			if(!Checks.esNulo(activo.getSubtipoActivo())) {
				codSubtipoActivo = activo.getSubtipoActivo().getCodigo();
			}
			
			if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getCartera()) && !Checks.esNulo(activo.getCartera().getCodigo())) {
				codPortfolio = activo.getCartera().getCodigo();
			}
			
			if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getSubcartera()) && !Checks.esNulo(activo.getSubcartera().getCodigo())) {
				codSubportfolio = activo.getSubcartera().getCodigo();
			}
			
			if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getClaseActivo())) {
				classType = activoBancario.getClaseActivo().getCodigo();
			}
		} 

		ConsultaComisionDto consultaComisionDto = new ConsultaComisionDto();
		consultaComisionDto.setAmount(importe);
		consultaComisionDto.setLeadOrigin(codLeadOrigin);
		consultaComisionDto.setOfferType(codigoOferta);
		consultaComisionDto.setComercialType(tipoComercializar);
		consultaComisionDto.setAssetType(codTipoActivo);
		consultaComisionDto.setAssetSubtype(codSubtipoActivo);
		consultaComisionDto.setPortfolio(codPortfolio);
		consultaComisionDto.setSubPortfolio(codSubportfolio);
		consultaComisionDto.setClassType(classType);

		// Los honorarios de colaboración serán asignados al FDV de la oferta si
		// existe,
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
			// Los gastos de prescripcion serán asignados al al prescriptor de
			// la oferta
		} else if (accion.equals(DDAccionGastos.CODIGO_PRESCRIPCION)) {

			if (!Checks.esNulo(oferta.getPrescriptor())) {
				proveedor = oferta.getPrescriptor();
			}
		}
		// TODO: Falta definir a quien asignar los honorarios para
		// CODIGO_RESPONSABLE_CLIENTE (Doble
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
		DDAccionGastos accionGastoC = (DDAccionGastos) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDAccionGastos.class, accion);
		if (!Checks.esNulo(accionGastoC)) {
			dto.setCodigoTipoComision(accionGastoC.getCodigo());
			dto.setDescripcionTipoComision(accionGastoC.getDescripcion());
		}

		// Información del tipo de cálculo. Por defecto siempre son porcentajes
		DDTipoCalculo tipoCalculoC = (DDTipoCalculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCalculo.class,
				DDTipoCalculo.TIPO_CALCULO_PORCENTAJE);

		if (!Checks.esNulo(tipoCalculoC)) {
			dto.setTipoCalculo(tipoCalculoC.getDescripcion());
			dto.setCodigoTipoCalculo(tipoCalculoC.getCodigo());
		}

		// Información del cálculo de la comisión para venta
		RespuestaComisionResultDto calculoComision = null;
		try {
			calculoComision = comisionamientoApi.createCommission(consultaComisionDto);
		} catch (Exception e) {
			logger.error("Error en la llamada al comisionamiento: " + e);
		}
		
		if (!Checks.esNulo(calculoComision) && calculoComision.getCommissionAmount() != null && calculoComision.getMaxAmount() != null 
				&& calculoComision.getMinAmount() != null) {
			dto.setHonorarios(comisionamientoApi.calculaHonorario(calculoComision));
			dto.setImporteOriginal(calculoComision.getCommissionAmount());
			dto.setImporteCalculo(comisionamientoApi.calculaImporteCalculo(oferta.getImporteOferta(), dto.getHonorarios()));
		} else {
			dto.setImporteCalculo(0.00);
			dto.setImporteOriginal(0d);
			dto.setHonorarios(0.00);
		}

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
				if (!Checks.esNulo(cc)) {
					ofertaDto = new OfertaDto();
					ofertaDto.setIdClienteComercial(cc.getId());
					listaOfertas = getListaOfertas(ofertaDto);

					listaOfertasTotales.addAll(listaOfertas);
				}
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
		if (!Checks.esNulo(of) && !Checks.esNulo(of.getEstadoOferta())
				&& DDEstadoOferta.CODIGO_ACEPTADA.equals(of.getEstadoOferta().getCodigo())) {
			// Si la oferta esta aceptada, se comprueba que el expediente esté
			// con alguno de los siguientes estados..., para pasar la nueva
			// oferta a Congelada.
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(of.getId());
			if(!Checks.esNulo(of.getTipoOferta()) && DDTipoOferta.CODIGO_VENTA.equals(of.getTipoOferta().getCodigo())) {
				if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getEstado())
						&& (DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.EN_DEVOLUCION.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.FIRMADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.BLOQUEO_ADM.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.APROBADO_CES_PTE_PRO_MANZANA.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.APROBADO_PTE_PRO_MANZANA.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.RESERVADO_PTE_PRO_MANZANA.equals(expediente.getEstado().getCodigo()))) {

					return true;
				}
			}else {
				if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getEstado())
						&& (DDEstadosExpedienteComercial.PTE_PBC.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.PTE_POSICIONAMIENTO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.PTE_FIRMA.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.PTE_CIERRE.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.FIRMADO.equals(expediente.getEstado().getCodigo()))) {

					return true;
				}
			}

		}
		return false;
	}

	@Override
	public boolean resetPBC(ExpedienteComercial expediente, Boolean fullReset) {
		if (Checks.esNulo(expediente)) {
			return false;
		}

		if (!Checks.esNulo(expediente.getOferta()) && !expediente.getOferta().getVentaDirecta()) {
			// Reiniciar estado del PBC.
			if (fullReset) {
				// reseteamos responsabilidad corporativa
				expediente.setConflictoIntereses(null);
				expediente.setRiesgoReputacional(null);
				expediente.setEstadoPbc(null);
			} else {
				expediente.setEstadoPbc(null);
			}

			genericDao.update(ExpedienteComercial.class, expediente);

			// Avisar al gestor de formalización del activo.
			Notificacion notificacion = new Notificacion();

			if (!Checks.esNulo(expediente.getOferta()) && !Checks.esNulo(expediente.getOferta().getActivoPrincipal())) {

				notificacion.setIdActivo(expediente.getOferta().getActivoPrincipal().getId());

				Usuario gestoriaFormalizacion = gestorExpedienteComercialManager
						.getGestorByExpedienteComercialYTipo(expediente, "GFORM");

				if (!Checks.esNulo(gestoriaFormalizacion)) {

					notificacion.setDestinatario(gestoriaFormalizacion.getId());

					notificacion.setTitulo("Reseteo del PBC - Expediente " + expediente.getNumExpediente());
					notificacion.setDescripcion(String.format(
							"Se ha reseteado el PBC por modificación de algunos parámetros del expediente %s.",
							expediente.getNumExpediente().toString()));

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
					DDTiposImpuesto tipoImpuesto = condicionante.getTipoImpuesto();
					if (!Checks.esNulo(tipoImpuesto)) {
						if (DDTiposImpuesto.TIPO_IMPUESTO_ITP.equals(tipoImpuesto.getCodigo())) {
							return true;
						} else {
							if (!Checks.esNulo(condicionante.getTipoAplicable())) {
								return true;
							}
						}
					}
				}
			}
		}

		return false;
	}
	
	

	@Override
	public List<DDTipoProveedor> getDiccionarioSubtipoProveedorCanal() {

		List<String> codigos = new ArrayList<String>();

		codigos.add(DDTipoProveedor.COD_MEDIADOR);
		codigos.add(DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA);
		codigos.add(DDTipoProveedor.COD_OFICINA_BANKIA);
		codigos.add(DDTipoProveedor.COD_OFICINA_CAJAMAR);
		codigos.add(DDTipoProveedor.COD_WEB_HAYA);
		codigos.add(DDTipoProveedor.COD_PORTAL_WEB);
		codigos.add(DDTipoProveedor.COD_CAT);
		codigos.add(DDTipoProveedor.COD_HAYA);
		codigos.add(DDTipoProveedor.COD_GESTIONDIRECTA);
		codigos.add(DDTipoProveedor.COD_SALESFORCE);
		codigos.add(DDTipoProveedor.COD_OFICINA_LIBERBANK);

		List<DDTipoProveedor> listaTipoProveedor = proveedoresDao.getSubtiposProveedorByCodigos(codigos);

		return listaTipoProveedor;
	}

	@SuppressWarnings("unchecked")
	@Override
	public boolean checkRenunciaTanteo(TareaExterna tareaExterna) {
		boolean result = false;
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);

		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());
			if (!Checks.esNulo(expediente)) {
				DtoPage dtosActivosExpediente = expedienteComercialApi.getActivosExpediente(expediente.getId());
				List<DtoActivosExpediente> dtosActivos = (List<DtoActivosExpediente>) dtosActivosExpediente
						.getResults();
				for (DtoActivosExpediente dtoActExp : dtosActivos) {
					List<DtoTanteoActivoExpediente> dtosTanteos = expedienteComercialApi
							.getTanteosPorActivoExpediente(expediente.getId(), dtoActExp.getIdActivo());
					if (!Checks.estaVacio(dtosTanteos)) {
						for (DtoTanteoActivoExpediente dtoTanteo : dtosTanteos) {
							if (!DDResultadoTanteo.CODIGO_RENUNCIADO.equals(dtoTanteo.getCodigoTipoResolucion())) {
								return false;
							}
						}
						result = true;
					} else {
						// caso de que el activo del expediente no tenga ningun
						// tanteo
					}
				}
			}
		}

		return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public boolean checkEjercidoTanteo(TareaExterna tareaExterna) {
		boolean result = false;
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);

		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());
			if (!Checks.esNulo(expediente)) {
				DtoPage dtosActivosExpediente = expedienteComercialApi.getActivosExpediente(expediente.getId());
				List<DtoActivosExpediente> dtosActivos = (List<DtoActivosExpediente>) dtosActivosExpediente
						.getResults();
				for (DtoActivosExpediente dtoActExp : dtosActivos) {
					List<DtoTanteoActivoExpediente> dtosTanteos = expedienteComercialApi
							.getTanteosPorActivoExpediente(expediente.getId(), dtoActExp.getIdActivo());
					if (!Checks.estaVacio(dtosTanteos)) {
						for (DtoTanteoActivoExpediente dtoTanteo : dtosTanteos) {
							if (DDResultadoTanteo.CODIGO_EJERCIDO.equals(dtoTanteo.getCodigoTipoResolucion())) {
								return true;
							}
						}
					} else {
						// caso de que el activo del expediente no tenga ningun
						// tanteo
					}
				}
			}
		}

		return result;
	}

	@Override
	public Usuario getUsuarioPreescriptor(Oferta oferta) {
		ActivoProveedor proveedor = oferta.getPrescriptor();
		if (!Checks.esNulo(proveedor)) {
			List<ActivoProveedorContacto> proveedorContactoList = genericDao.getList(ActivoProveedorContacto.class,
					genericDao.createFilter(FilterType.EQUALS, "proveedor.id", proveedor.getId()));
			if (!Checks.estaVacio(proveedorContactoList)) {
				for (ActivoProveedorContacto proveedorContacto : proveedorContactoList)
					if (!Checks.esNulo(proveedorContacto.getUsuario()))
						return proveedorContacto.getUsuario();
			}
		}
		return null;
	}

	@Override
	public ActivoProveedor getPreescriptor(Oferta oferta) {
		return oferta.getPrescriptor();
	}

	@Override
	@Deprecated
	public void desocultarActivoOferta(Oferta oferta) throws Exception {
		ArrayList<Long> idActivoActualizarPublicacion = new ArrayList<Long>();
		if (oferta.getActivosOferta() != null && !oferta.getActivosOferta().isEmpty()) {
			for (ActivoOferta activoOferta : oferta.getActivosOferta()) {
				Activo activo = activoOferta.getPrimaryKey().getActivo();
				if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo()) && (DDSituacionComercial.CODIGO_DISPONIBLE_VENTA.equals(activo.getSituacionComercial().getCodigo())
						|| DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_OFERTA.equals(activo.getSituacionComercial().getCodigo())
						|| DDSituacionComercial.CODIGO_DISPONIBLE_CONDICIONADO.equals(activo.getSituacionComercial().getCodigo()))) {
					idActivoActualizarPublicacion.add(activo.getId());
					//activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
				}
			}
		}
		activoAdapter.actualizarEstadoPublicacionActivo(idActivoActualizarPublicacion,true);
	}

	@Override
	public boolean checkReservaFirmada(TareaExterna tareaExterna) {
		boolean result = true;
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

		if ((DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())
			&& !DDSubcartera.CODIGO_BAN_BH
			.equals(ofertaAceptada.getActivoPrincipal().getSubcartera().getCodigo()))
		||(DDCartera.CODIGO_CARTERA_CERBERUS.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())
			&& (DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(ofertaAceptada.getActivoPrincipal().getSubcartera().getCodigo()) 
					|| DDSubcartera.CODIGO_DIVARIAN.equals(ofertaAceptada.getActivoPrincipal().getSubcartera().getCodigo())))) {

			if (((!Checks.esNulo(expediente.getReserva()))
				&& !Checks.esNulo(expediente.getReserva().getEstadoReserva())
				&& !DDEstadosReserva.CODIGO_FIRMADA.equals(expediente.getReserva().getEstadoReserva().getCodigo()))
				|| Checks.esNulo(expediente.getReserva())
				|| !Checks.esNulo(expediente.getCondicionante().getSolicitaReserva()) && expediente.getCondicionante().getSolicitaReserva() == 0) {
				result = false;
			}
		}

		return result;
	}

	@Override
	public boolean checkEsExpress(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			if (!Checks.esNulo(expediente)){
				if(!Checks.esNulo(expediente.getOferta().getOfertaExpress())){
					return expediente.getOferta().getOfertaExpress();
				}
				else{
					return false;
				}
			}

		}
		return false;
	}

	@Transactional(readOnly = false)
	@Override
	public void congelarExpedientesPorOfertaExpress(Oferta ofertaExpress) throws Exception {

		Boolean tramitar = true;

		Activo activo = activoApi.getByNumActivo(ofertaExpress.getActivoPrincipal().getNumActivo());
		List<ActivoOferta> actofr = activo.getOfertas();

		for (int i = 0; i < actofr.size(); i++) {
			ActivoOferta activoOferta = actofr.get(i);
			Oferta ofr = activoOferta.getPrimaryKey().getOferta();

			if (!Checks.esNulo(ofr)) {
				ExpedienteComercial exp = expedienteComercialApi.findOneByOferta(ofr);

				if (!Checks.esNulo(exp)) {

					String estadoExpediente = exp.getEstado().getCodigo();

					if (DDEstadosExpedienteComercial.FIRMADO.equals(estadoExpediente)
							|| DDEstadosExpedienteComercial.CONTRAOFERTADO.equals(estadoExpediente)
							|| DDEstadosExpedienteComercial.BLOQUEO_ADM.equals(estadoExpediente)
							|| DDEstadosExpedienteComercial.RESERVADO.equals(estadoExpediente)
							|| DDEstadosExpedienteComercial.VENDIDO.equals(estadoExpediente)
							|| DDEstadosExpedienteComercial.APROBADO.equals(estadoExpediente)
							|| DDEstadosExpedienteComercial.ALQUILADO.equals(estadoExpediente)
							|| DDEstadosExpedienteComercial.EN_DEVOLUCION.equals(estadoExpediente)) {

						tramitar = false;
					}
				}
			}
		}

		if (tramitar) {
			for (int i = 0; i < actofr.size(); i++) {
				ActivoOferta activoOferta = actofr.get(i);
				Oferta ofr = activoOferta.getPrimaryKey().getOferta();

				if (!Checks.esNulo(ofr)) {
					ExpedienteComercial exp = expedienteComercialApi.findOneByOferta(ofr);

					if (!Checks.esNulo(exp)) {

						String estadoExpediente = exp.getEstado().getCodigo();

						if (DDEstadosExpedienteComercial.EN_TRAMITACION.equals(estadoExpediente)
								// || DDEstadosExpedienteComercial.CONTRAOFERTADO.equals(estadoExpediente)
								// || DDEstadosExpedienteComercial.RESUELTO.equals(estadoExpediente)
								|| DDEstadosExpedienteComercial.PTE_SANCION.equals(estadoExpediente)
								|| DDEstadosExpedienteComercial.RPTA_OFERTANTE.equals(estadoExpediente)) {

							congelarOferta(ofr);

						}
					} else if (DDEstadoOferta.CODIGO_PENDIENTE.equals(ofr.getEstadoOferta().getCodigo())) {
						congelarOferta(ofr);
					}

				}
			}
		}
	}

	@Override
	public Double getImporteOferta(Oferta oferta) {

		if (!Checks.esNulo(oferta.getImporteContraOferta())) {
			return oferta.getImporteContraOferta();
		}else {
			return oferta.getImporteOferta();
		}
	}

	@Override
	public boolean comprobarComiteLiberbankPlantillaPropuesta(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (DDCartera.CODIGO_CARTERA_LIBERBANK.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())) {
//			DDComiteSancion comite = this.calculoComiteLiberbank(ofertaAceptada, null);
			DDComiteSancion comite = this.calculoComiteLiberbank(ofertaAceptada);
			ActivoAgrupacion agrupacion = ofertaAceptada.getAgrupacion();
			Double importeOferta = (!Checks.esNulo(ofertaAceptada.getImporteContraOferta()))
					? ofertaAceptada.getImporteContraOferta() : ofertaAceptada.getImporteOferta();
			if (!Checks.esNulo(ofertaAceptada) && !Checks.esNulo(comite)) {
				if (!DDComiteSancion.CODIGO_HAYA_LIBERBANK.equals(comite.getCodigo())) {
					if (Checks.esNulo(agrupacion)) {
						Activo activo = ofertaAceptada.getActivoPrincipal();
						Double minimoAutorizado = activoApi.getImporteValoracionActivoByCodigo(activo,
								DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO);

						if (!Checks.esNulo(activo) && !Checks.esNulo(minimoAutorizado)) {
							if (importeOferta < (minimoAutorizado * 0.85)) {
								return true;
							}
						}
					} else {
						DtoAgrupacionFilter dtoAgrupActivo = new DtoAgrupacionFilter();
						dtoAgrupActivo.setAgrId(agrupacion.getId());
						List<ActivoAgrupacionActivo> activos = activoAgrupacionActivoApi
								.getListActivosAgrupacion(dtoAgrupActivo);
						Double minimoAutorizado = 0.0;
						if (!Checks.esNulo(dtoAgrupActivo)) {
							for (ActivoAgrupacionActivo activo : activos) {
								if(activo != null && activo.getActivo() != null){
									Double minimoAutorizadoAux = activoApi.getImporteValoracionActivoByCodigo(activo.getActivo(),
											DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO);
									if(minimoAutorizadoAux != null){
										minimoAutorizado += minimoAutorizadoAux;
									}
								}
							}
						}
						if (!Checks.esNulo(minimoAutorizado)) {
							if (importeOferta < (minimoAutorizado * 0.85)) {
								return true;
							}
						}
					}
				}

			}
		}
		return false;
	}
	
	@Override
	public DDComiteSancion calculoComiteLiberbank(Oferta ofertaAceptada) {
		if(!Checks.esNulo(ofertaAceptada)){
			ActivoAgrupacion agrupacion = ofertaAceptada.getAgrupacion();
			Double importeOferta = this.getImporteOferta(ofertaAceptada);
			Double importeUmbral = 500000.0;

			// Oferta sobre un solo activo
			if(Checks.esNulo(agrupacion)) {
				Activo activo = ofertaAceptada.getActivoPrincipal();

				// Si disponemos de un activo, recuperamos los datos a comprobar
				if(!Checks.esNulo(activo)) {
					ActivoTasacion tasacion = activoApi.getTasacionMasReciente(activo);
					Double importeTasacion = null;
					Double precioAprobadoVenta = null;
					Double precioMinimoAutorizado = null;
					Double precioDescuentoPublicado = null;

					importeTasacion = (!Checks.esNulo(tasacion)) ? tasacion.getImporteTasacionFin() : null;
					List<VPreciosVigentes> precios = activoApi.getPreciosVigentesById(activo.getId());
					for(VPreciosVigentes p : precios) {
						if(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(p.getCodigoTipoPrecio())) {
							precioAprobadoVenta = p.getImporte();
						} else if(DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO.equals(p.getCodigoTipoPrecio())) {
							precioMinimoAutorizado = p.getImporte();
						}  else if(DDTipoPrecio.CODIGO_TPC_DESC_APROBADO.equals(p.getCodigoTipoPrecio())) {
							precioDescuentoPublicado = p.getImporte();
						}
					}

					Filter filterInfLiber = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					ActivoInfoLiberbank activoInfoLiberbank = genericDao.get(ActivoInfoLiberbank.class, filterInfLiber);

					if(!Checks.esNulo(activoInfoLiberbank) && !Checks.esNulo(activoInfoLiberbank.getCategoriaContable())
							&& DDCategoriaContable.COD_INMOVILIZADO.equals(activoInfoLiberbank.getCategoriaContable().getCodigo())) {
						Filter filterComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_LIBERBANK_INVERSION_INMOBILIARIA);
						DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filterComite);

						return comiteSancion;
					}

					if (!Checks.esNulo(activoInfoLiberbank) && !Checks.esNulo(activoInfoLiberbank.getCodPromocion()) && !Checks.esNulo(activoInfoLiberbank.getCategoriaContable()) &&
							DDCategoriaContable.COD_INMOVILIZADO.equals(activoInfoLiberbank.getCategoriaContable().getCodigo())){

						Filter filterComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_LIBERBANK);
						DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filterComite);

						return comiteSancion;

					}else if(((!Checks.esNulo(importeTasacion) && importeTasacion < importeUmbral)
							&& (!Checks.esNulo(importeOferta) && !Checks.esNulo(precioMinimoAutorizado) && importeOferta >= precioMinimoAutorizado))
					|| ((!Checks.esNulo(importeTasacion) && importeTasacion < importeUmbral)
							&& (!Checks.esNulo(importeOferta) && !Checks.esNulo(precioDescuentoPublicado) && importeOferta >= precioDescuentoPublicado))
					|| ((!Checks.esNulo(precioAprobadoVenta) && precioAprobadoVenta < importeUmbral)
							&& (!Checks.esNulo(importeOferta) && !Checks.esNulo(precioMinimoAutorizado) && importeOferta >= precioMinimoAutorizado))) {
						Filter filterComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_LIBERBANK);
						DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filterComite);

						return comiteSancion;
					} else if((((!Checks.esNulo(importeTasacion) && importeTasacion < importeUmbral)
							&& (!Checks.esNulo(importeOferta) && !Checks.esNulo(precioMinimoAutorizado) && importeOferta < precioMinimoAutorizado))
							|| (!Checks.esNulo(importeTasacion) && importeTasacion >= importeUmbral))
					|| (((!Checks.esNulo(precioAprobadoVenta) && precioAprobadoVenta < importeUmbral)
							&& (!Checks.esNulo(importeOferta) && !Checks.esNulo(precioMinimoAutorizado) && importeOferta < precioMinimoAutorizado))
							|| (!Checks.esNulo(precioAprobadoVenta) && precioAprobadoVenta >= importeUmbral))) {

						DDTipoActivo tipoActivo = activo.getTipoActivo();
						DDSubtipoActivo subtipoActivo = activo.getSubtipoActivo();
						if(DDTipoActivo.COD_VIVIENDA.equals(tipoActivo.getCodigo())
								|| DDSubtipoActivo.COD_GARAJE.equals(subtipoActivo.getCodigo())
								|| DDSubtipoActivo.COD_TRASTERO.equals(subtipoActivo.getCodigo())) {

							Filter filterComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_LIBERBANK_RESIDENCIAL);
							DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filterComite);

							return comiteSancion;
						} else {
							Filter filterComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_LIBERBANK_SINGULAR_TERCIARIO);
							DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filterComite);

							return comiteSancion;
						}
					}
				}

			// Oferta sobre un lote
			} else {
				List<ActivoAgrupacionActivo> activos = agrupacion.getActivos();
				Double sumaTasaciones = 0.0;
				Double sumaPrecioActivos = 0.0;

				List<VTasacionCalculoLBK> vista = activoApi.getVistaTasacion(agrupacion.getId());

				for(VTasacionCalculoLBK reg: vista) {
					Double importeTasacion = reg.getImporteTasacion();
					Double precioAprobadoVenta = reg.getImportePrecioAprobado();
					Double precioMinimoAutorizado = reg.getImportePrecioMinimo();
					Double precioDescuentoPublicado = reg.getImportePrecioDescuento();
					Double precioMinimoActivo = CompareDoubles(precioAprobadoVenta, precioMinimoAutorizado, precioDescuentoPublicado);

					if(!Checks.esNulo(precioMinimoActivo)) {
						sumaPrecioActivos += precioMinimoActivo;
					}

					sumaTasaciones += (!Checks.esNulo(importeTasacion)) ? importeTasacion : precioAprobadoVenta;
				}

				Integer tipoResidencial = 0;
				Integer tipoSingularTerciario = 0;

				for(ActivoAgrupacionActivo aga : activos) {
					Activo activo = aga.getActivo();
					DDTipoActivo tipoActivo = activo.getTipoActivo();
					DDSubtipoActivo subtipoActivo = activo.getSubtipoActivo();

					Filter filterInfLiber = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					ActivoInfoLiberbank activoInfoLiberbank = genericDao.get(ActivoInfoLiberbank.class, filterInfLiber);

					if(!Checks.esNulo(activoInfoLiberbank) && !Checks.esNulo(activoInfoLiberbank.getCategoriaContable())
							&& DDCategoriaContable.COD_INMOVILIZADO.equals(activoInfoLiberbank.getCategoriaContable().getCodigo())) {
						Filter filterComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_LIBERBANK_INVERSION_INMOBILIARIA);
						DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filterComite);

						return comiteSancion;
					}

					if(DDTipoActivo.COD_VIVIENDA.equals(tipoActivo.getCodigo())
							|| DDSubtipoActivo.COD_GARAJE.equals(subtipoActivo.getCodigo())
							|| DDSubtipoActivo.COD_TRASTERO.equals(subtipoActivo.getCodigo())) {

						tipoResidencial++;
					} else {
						tipoSingularTerciario++;
					}
				}

				if(((!Checks.esNulo(sumaTasaciones) && sumaTasaciones < importeUmbral)
						&& (!Checks.esNulo(importeOferta) && importeOferta >= sumaPrecioActivos))) {
					Filter filterComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_LIBERBANK);
					DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filterComite);

					return comiteSancion;
				} else if((((!Checks.esNulo(sumaTasaciones) && sumaTasaciones < importeUmbral)
						&& (!Checks.esNulo(importeOferta) && importeOferta <= sumaPrecioActivos))
						|| (sumaTasaciones >= importeUmbral))) {

					if(tipoResidencial != 0 && tipoSingularTerciario != 0) {
						Filter filterComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_LIBERBANK_INVERSION_INMOBILIARIA);
						DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filterComite);

						return comiteSancion;
					} else if(tipoResidencial > 0) {
						Filter filterComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_LIBERBANK_RESIDENCIAL);
						DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filterComite);

						return comiteSancion;
					} else if(tipoSingularTerciario > 0) {
						Filter filterComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_LIBERBANK_SINGULAR_TERCIARIO);
						DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filterComite);

						return comiteSancion;
					}
				}

			}

			return null;

		}else{
			return null;
		}
	}
	
//	@Override
//	public DDComiteSancion calculoComiteLiberbank(Oferta ofertaAceptada, OfertasAgrupadasLbk nuevaOfertaAgrupadaLbk) {
//		if(!Checks.esNulo(ofertaAceptada)){
//			ActivoAgrupacion agrupacion = ofertaAceptada.getAgrupacion();
//			
//			// Oferta sobre un solo activo
//			if(Checks.esNulo(agrupacion)) {
//				List<GastosExpediente> gastosExpediente = new ArrayList<GastosExpediente>();
//				return calculoComiteLiberbankActivoSolo(ofertaAceptada, gastosExpediente, nuevaOfertaAgrupadaLbk);
//
//			// Oferta sobre un lote
//			} else {
//				List<GastosExpediente> gastosExpediente = new ArrayList<GastosExpediente>();
//				return calculoComiteLiberbankLoteActivos(ofertaAceptada, gastosExpediente, nuevaOfertaAgrupadaLbk);
//			}
//		}else{
//			return null;
//		}
//	}

	@Override
	public DDComiteSancion calculoComiteLBK(Oferta ofertaAceptada, List<GastosExpediente> gastosExpediente, OfertasAgrupadasLbk nuevaOfertaAgrupadaLbk) {
		if(!Checks.esNulo(ofertaAceptada)){
			ActivoAgrupacion agrupacion = ofertaAceptada.getAgrupacion();
			
			// Oferta sobre un solo activo
			if(Checks.esNulo(agrupacion)) {
				return calculoComiteLiberbankActivoSolo(ofertaAceptada, gastosExpediente, nuevaOfertaAgrupadaLbk);

			// Oferta sobre un lote
			} else {
				return calculoComiteLiberbankLoteActivos(ofertaAceptada, gastosExpediente, nuevaOfertaAgrupadaLbk);
			}
		}else{
			return null;
		}
	}
	
	private List<Double> getImportesAcumulados(Oferta ofertaAceptada, Double vta, Double pvb, Double cco, Double pvn, Double vnc, Double vr, OfertasAgrupadasLbk nuevafertaAgrupadaLbk){
		List<Double> listaImportesAcumulados = new ArrayList<Double>();
		//Acumular pvb, cco de las ofertas dependientes
		//A nivel de expediente
		if (!Checks.esNulo(ofertaAceptada) && !Checks.esNulo(ofertaAceptada.getClaseOferta()) && !Checks.esNulo(ofertaAceptada.getClaseOferta().getCodigo()) &&  DDClaseOferta.OFERTA_AGRUPADA_PRINCIPAL.equals(ofertaAceptada.getClaseOferta().getCodigo())) {
			List <OfertasAgrupadasLbk> listaOfertasAgrupadas = ofertaAceptada.getOfertasAgrupadas();
			if (!Checks.esNulo(nuevafertaAgrupadaLbk)) {
				if (nuevafertaAgrupadaLbk.getAuditoria().isBorrado() && listaOfertasAgrupadas.contains(nuevafertaAgrupadaLbk)) {
					listaOfertasAgrupadas.remove(nuevafertaAgrupadaLbk);
				}else if(!nuevafertaAgrupadaLbk.getAuditoria().isBorrado() && !listaOfertasAgrupadas.contains(nuevafertaAgrupadaLbk)) {
					listaOfertasAgrupadas.add(nuevafertaAgrupadaLbk);
				}
			}
			if(!Checks.estaVacio(listaOfertasAgrupadas)) {
				for (OfertasAgrupadasLbk ofertaAgrupada : listaOfertasAgrupadas) {
					if (!ofertaAgrupada.getAuditoria().isBorrado()) {
						Oferta ofertaDependiente = ofertaAgrupada.getOfertaDependiente();
						//Acumular pvb
						pvb += ofertaDependiente.getImporteOferta();
						//Acumular cco
						ExpedienteComercial eco = expedienteComercialDao.getExpedienteComercialByIdOferta(ofertaDependiente.getId());
						if(!Checks.esNulo(eco) && Checks.esNulo(eco.getHonorarios())){
							for ( GastosExpediente gex: eco.getHonorarios()) {
								if(!Checks.esNulo(gex.getImporteFinal()) && !Checks.esNulo(gex.getImporteCalculo())) {
									cco += gex.getImporteFinal() * gex.getImporteCalculo();
								}
							}
						} else {
							List<DtoGastoExpediente> honorarios = new ArrayList<DtoGastoExpediente>();
							Activo activo =  ofertaDependiente.getActivoPrincipal();
							String[] acciones = { DDAccionGastos.CODIGO_COLABORACION, DDAccionGastos.CODIGO_PRESCRIPCION, DDAccionGastos.CODIGO_RESPONSABLE_CLIENTE };
							for (int i = 0; i < acciones.length; i++) {
								honorarios.add(calculaHonorario(ofertaDependiente, acciones[i], activo));
							}
							for (DtoGastoExpediente gex: honorarios) {
								if(!Checks.esNulo(gex.getImporteFinal()) && !Checks.esNulo(gex.getImporteCalculo())) {
									cco += gex.getImporteFinal() * gex.getImporteCalculo();
								}
							}
						}
					}
				}
			}
		}
	
		//Acumular vta, vn, vr de las ofertas dependeintes
		//A nievl de activos
		if (!Checks.esNulo(ofertaAceptada) && !Checks.esNulo(ofertaAceptada.getClaseOferta()) && !Checks.esNulo(DDClaseOferta.OFERTA_AGRUPADA_PRINCIPAL.equals(ofertaAceptada.getClaseOferta().getCodigo())) && DDClaseOferta.OFERTA_AGRUPADA_PRINCIPAL.equals(ofertaAceptada.getClaseOferta().getCodigo())) {
			List <OfertasAgrupadasLbk> listaOfertasAgrupadas = ofertaAceptada.getOfertasAgrupadas();
			if(!Checks.estaVacio(listaOfertasAgrupadas)) {
				//Recorrer las fertas dependientes de la principal
				for (OfertasAgrupadasLbk ofertaAgrupada : listaOfertasAgrupadas) {
					if (!ofertaAgrupada.getAuditoria().isBorrado()) {
						ActivoAgrupacion activoAgrupacion = ofertaAgrupada.getOfertaDependiente().getAgrupacion();
						//Si la oferta dependiente es de una agrupacion, recorrer todos los activos de la agrupacion
						if (!Checks.esNulo(activoAgrupacion)) {
							List<ActivoAgrupacionActivo> listaActivos = activoAgrupacion.getActivos();
							if (!Checks.estaVacio(listaActivos)) {
								for(ActivoAgrupacionActivo aga : listaActivos) {
									Activo activo = aga.getActivo();
									//Acumular vta
									if(!Checks.estaVacio(activo.getTasacion())) {
										vta += activo.getTasacion().get(activo.getTasacion().size()-1).getImporteTasacionFin();
									}
									List<ActivoValoraciones> listaValoraciones = activo.getValoracion();
									//Acumular vn y vr
									for (ActivoValoraciones valoracion : listaValoraciones) {
										String codigoValoracion = valoracion.getTipoPrecio().getCodigo();
										if (DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT_LIBERBANK.equals(codigoValoracion)) {
											vnc += valoracion.getImporte();
										}else if (DDTipoPrecio.CODIGO_TPC_VALOR_RAZONABLE_LBK.equals(codigoValoracion)) {
											vr  += valoracion.getImporte();
										}
									}
								}
							}
						//Si la oferta dependiente es de un activo solo
						} else {
							Activo activo = ofertaAgrupada.getOfertaDependiente().getActivoPrincipal();
							//Acumular vta
							if(!Checks.estaVacio(activo.getTasacion())) {
								vta += activo.getTasacion().get(activo.getTasacion().size()-1).getImporteTasacionFin();
							}
							
							//Acumular vn y vr
							List<ActivoValoraciones> listaValoraciones = activo.getValoracion();
							for (ActivoValoraciones valoracion : listaValoraciones) {
								String codigoValoracion = valoracion.getTipoPrecio().getCodigo();
								if (DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT_LIBERBANK.equals(codigoValoracion)) {
									vnc += valoracion.getImporte();
								}else if (DDTipoPrecio.CODIGO_TPC_VALOR_RAZONABLE_LBK.equals(codigoValoracion)) {
									vr  += valoracion.getImporte();
								}
							}
						}
					}
				}
			}
		}
		
		pvn = pvb - cco;
		
		listaImportesAcumulados.add(vta);
		listaImportesAcumulados.add(pvb);
		listaImportesAcumulados.add(cco);
		listaImportesAcumulados.add(pvn);
		listaImportesAcumulados.add(vnc);
		listaImportesAcumulados.add(vr);
		
		return listaImportesAcumulados;
	}
	
	@Override
	public DDComiteSancion calculoComiteLiberbankActivoSolo(Oferta ofertaAceptada, List<GastosExpediente> gastosExpediente, OfertasAgrupadasLbk nuevaOfertaAgrupadaLbk) {
			
		Double vta= 0.0, pvb= 0.0, cco= 0.0, pvn= 0.0, vnc= 0.0, vr = 0.0;

		// Si son ofertas agrupadas el cálculo se hace del conjunto
		if (!Checks.esNulo(ofertaAceptada.getClaseOferta()) 
					&& DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE.equals(ofertaAceptada.getClaseOferta().getCodigo())) {
			return calculoComiteLiberbankOfertasDependientes(ofertaAceptada, gastosExpediente, false);
			
		// Si la oferta es individual o principal (aún no tiene dependientes) el cálculo se hace sobre si misma
		}else {
			if(!Checks.estaVacio(ofertaAceptada.getActivoPrincipal().getTasacion())) {
				vta += ofertaAceptada.getActivoPrincipal().getTasacion().get(ofertaAceptada.getActivoPrincipal().getTasacion().size()-1).getImporteTasacionFin();
			}
			
			pvb = ofertaAceptada.getImporteOferta();

			// Cuando es una oferta que se está creando nos tienen que pasar los honorarios
			if (!Checks.estaVacio(gastosExpediente)) {
				for (GastosExpediente gex : gastosExpediente) {
					cco += gex.getImporteFinal() * gex.getImporteCalculo();
				}
			// Cuando no nos pasan la lista de gastos es porque ya existe el expediente y lo recuperamos de ahí
			}else {
				ExpedienteComercial eco = expedienteComercialDao.getExpedienteComercialByIdOferta(ofertaAceptada.getId());
				if(!Checks.esNulo(eco.getHonorarios())){
					for ( GastosExpediente gex: eco.getHonorarios()) {
						if(!Checks.esNulo(gex.getImporteFinal()) && !Checks.esNulo(gex.getImporteCalculo())) {
							cco += gex.getImporteFinal() * gex.getImporteCalculo();
						}
					}
				}else {
				
					List<DtoGastoExpediente> honorarios = new ArrayList<DtoGastoExpediente>();
					
					Activo activo =  ofertaAceptada.getActivoPrincipal();
					String[] acciones = { DDAccionGastos.CODIGO_COLABORACION, DDAccionGastos.CODIGO_PRESCRIPCION, DDAccionGastos.CODIGO_RESPONSABLE_CLIENTE };
					for (int i = 0; i < acciones.length; i++) {
						honorarios.add(calculaHonorario(ofertaAceptada, acciones[i], activo));
					}
					
					for ( DtoGastoExpediente gex: honorarios) {
						if(!Checks.esNulo(gex.getImporteFinal()) && !Checks.esNulo(gex.getImporteCalculo())) {
							cco += gex.getImporteFinal() * gex.getImporteCalculo();
						}
					}
				}
			}
			
			pvn = pvb - cco;

			List<ActivoValoraciones> valoraciones = ofertaAceptada.getActivoPrincipal().getValoracion();
	
			for (ActivoValoraciones valoracion : valoraciones) {
				String codigoValoracion = valoracion.getTipoPrecio().getCodigo();
				if (DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT_LIBERBANK.equals(codigoValoracion)) {
					vnc += valoracion.getImporte();
				}else if (DDTipoPrecio.CODIGO_TPC_VALOR_RAZONABLE_LBK.equals(codigoValoracion)) {
					vr  += valoracion.getImporte();
				}
			}
			
			List<Double> importesAcumulados = getImportesAcumulados(ofertaAceptada, vta, pvb, cco, pvn, vnc, vr, nuevaOfertaAgrupadaLbk);
			
			vta = importesAcumulados.get(0);
			pvb = importesAcumulados.get(1);
			cco = importesAcumulados.get(2);
			pvn = importesAcumulados.get(3);
			vnc = importesAcumulados.get(4);
			vr = importesAcumulados.get(5);
			
			// Asignación del comité
			return devuelveComiteSancionador(vta, pvb, cco, pvn, vnc, vr);
		}
	}

	@Override
	public DDComiteSancion calculoComiteLiberbankLoteActivos(Oferta ofertaAceptada, List<GastosExpediente> gastosExpediente, OfertasAgrupadasLbk nuevaOfertaAgrupadaLbk) {
			
		Double vta= 0.0, pvb= 0.0, cco= 0.0, pvn= 0.0, vnc= 0.0, vr = 0.0;

		ActivoAgrupacion agrupacion = ofertaAceptada.getAgrupacion();
		List<ActivoAgrupacionActivo> activos = agrupacion.getActivos();

		// Cuando son ofertas agrupadas, las recorro
		if (!Checks.esNulo(ofertaAceptada.getClaseOferta()) && DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE.equals(ofertaAceptada.getClaseOferta().getCodigo())) {
			return calculoComiteLiberbankOfertasDependientes(ofertaAceptada, gastosExpediente, true);
		}else {
			for(ActivoAgrupacionActivo aga : activos) {
				Activo activo = aga.getActivo();
				
				if(!Checks.estaVacio(activo.getTasacion())) {
					vta += activo.getTasacion().get(activo.getTasacion().size()-1).getImporteTasacionFin();
				}
				
				List<ActivoValoraciones> valoraciones = activo.getValoracion();
				
				for (ActivoValoraciones valoracion : valoraciones) {
					String codigoValoracion = valoracion.getTipoPrecio().getCodigo();
					if (DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT_LIBERBANK.equals(codigoValoracion)) {
						vnc += valoracion.getImporte();
					}else if (DDTipoPrecio.CODIGO_TPC_VALOR_RAZONABLE_LBK.equals(codigoValoracion)) {
						vr  += valoracion.getImporte();
					}
				}
			}
			
			pvb += ofertaAceptada.getImporteOferta();

			// Cuando es una oferta que se está creando no tienen que pasar los honorarios
			if (!Checks.estaVacio(gastosExpediente)) {
				for (GastosExpediente gex : gastosExpediente) {
					cco += gex.getImporteFinal() * gex.getImporteCalculo();
				}
			// Cuando no nos pasan la lista de gastos es porque ya existe el expediente y lo recuperamos de ahí
			}else {
				ExpedienteComercial eco = expedienteComercialDao.getExpedienteComercialByIdOferta(ofertaAceptada.getId());
				if(!Checks.esNulo(eco) && !Checks.esNulo(eco.getHonorarios())){
					for ( GastosExpediente gex: eco.getHonorarios()) {
						if(!Checks.esNulo(gex.getImporteFinal()) && !Checks.esNulo(gex.getImporteCalculo())) {
							cco += gex.getImporteFinal() * gex.getImporteCalculo();
						}
					}
				}else {
				
					List<DtoGastoExpediente> honorarios = new ArrayList<DtoGastoExpediente>();
					
					Activo activo =  ofertaAceptada.getActivoPrincipal();
					String[] acciones = { DDAccionGastos.CODIGO_COLABORACION, DDAccionGastos.CODIGO_PRESCRIPCION,DDAccionGastos.CODIGO_RESPONSABLE_CLIENTE };
					for (int i = 0; i < acciones.length; i++) {
						honorarios.add(calculaHonorario(ofertaAceptada, acciones[i], activo));
					}
					
					for ( DtoGastoExpediente gex: honorarios) {
						if(!Checks.esNulo(gex.getImporteFinal()) && !Checks.esNulo(gex.getImporteCalculo())) {
							cco += gex.getImporteFinal() * gex.getImporteCalculo();
						}
					}
				}
	
			}
			
		
			
			pvn = pvb - cco;
			
			List<Double> importesAcumulados = getImportesAcumulados(ofertaAceptada, vta, pvb, cco, pvn, vnc, vr, nuevaOfertaAgrupadaLbk);
			
			vta = importesAcumulados.get(0);
			pvb = importesAcumulados.get(1);
			cco = importesAcumulados.get(2);
			pvn = importesAcumulados.get(3);
			vnc = importesAcumulados.get(4);
			vr = importesAcumulados.get(5);
			
			// Asignación del comité
			return devuelveComiteSancionador(vta, pvb, cco, pvn, vnc, vr);
		}
	}
	
	private DDComiteSancion devuelveComiteSancionador (Double vta, Double pvb, Double cco, Double pvn, Double vnc, Double vr) {
		Double importeUmbral = 500000.0;
		Double perdida = pvn-vnc;
		Double perdidaValorAbsoluto = Math.abs(perdida);
		Double porcentajevnc = vnc * 0.2;
		Double umbralPerdida = 100000.0;
		
		if (vta== 0.0 || pvb == 0.0 || cco == 0.0 || pvn == 0.0 || vnc == 0.0 || vr == 0.0) {
			return null;
		} else {
			Filter filtroGestion = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_GESTION_INMOBILIARIA);
			
			Filter filtroGestionDir = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_DIRECTOR_GESTION_INMOBILIARIA);
			
			Filter filtroInversion= genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_COMITE_INVERSION_INMOBILIARIA);
			
			Filter filtroDireccion = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_COMITE_DIRECCION);
			
			if(vta > (importeUmbral * 10)) {
				return genericDao.get(DDComiteSancion.class, filtroDireccion);
			}else if(vta <= (importeUmbral * 10) && vta >= importeUmbral) {
				if(perdida > 0 || (perdidaValorAbsoluto <= umbralPerdida && perdidaValorAbsoluto <= porcentajevnc)) {
					return genericDao.get(DDComiteSancion.class, filtroInversion);
				}else if(perdidaValorAbsoluto > umbralPerdida || perdidaValorAbsoluto > porcentajevnc) {
					return genericDao.get(DDComiteSancion.class, filtroDireccion);
				}
			}else if(vta < importeUmbral){
				if(pvn < vr) {
					if (perdida > 0 || perdidaValorAbsoluto <= (porcentajevnc / 2)) {
						return genericDao.get(DDComiteSancion.class, filtroGestionDir);
					}else if (perdidaValorAbsoluto <= umbralPerdida && perdidaValorAbsoluto > (porcentajevnc / 2)){
						return genericDao.get(DDComiteSancion.class, filtroInversion);
					}else if(perdidaValorAbsoluto > umbralPerdida && perdidaValorAbsoluto > (porcentajevnc / 2)) {
						return genericDao.get(DDComiteSancion.class, filtroDireccion);
					}
				}else if(pvn >= vr) {
					return genericDao.get(DDComiteSancion.class, filtroGestion);
				}
			}
		}
		return null;
	}

	public DDComiteSancion calculoComiteLiberbankOfertasDependientes(Oferta ofertaNueva, List<GastosExpediente> gastosExpediente, boolean esLote) {

		Double vta= 0.0, pvb= 0.0, cco= 0.0, pvn= 0.0, vnc= 0.0, vr = 0.0;
		List<Oferta> listaOfertas = new ArrayList<Oferta>();
		DDComiteSancion comiteSancionador = null;

		// La oferta actual que estamos creando la suma por separado a la agrupación
		
		if (esLote) {
			ActivoAgrupacion agrupacion = ofertaNueva.getAgrupacion();
			List<ActivoAgrupacionActivo> activos = agrupacion.getActivos();
			
			for(ActivoAgrupacionActivo aga : activos) {
				Activo activo = aga.getActivo();
				
				if(!Checks.estaVacio(activo.getTasacion())) {
					vta += activo.getTasacion().get(activo.getTasacion().size()-1).getImporteTasacionFin();
				}

				// Cálculo del VNC y VR
				List<ActivoValoraciones> valoraciones = activo.getValoracion();
				for (ActivoValoraciones valoracion : valoraciones) {
					String codigoValoracion = valoracion.getTipoPrecio().getCodigo();
					if (DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT_LIBERBANK.equals(codigoValoracion)) {
						vnc += valoracion.getImporte();
					}else if (DDTipoPrecio.CODIGO_TPC_VALOR_RAZONABLE_LBK.equals(codigoValoracion)) {
						vr  += valoracion.getImporte();
					}
				}
			}
		}else {
			if(!Checks.estaVacio(ofertaNueva.getActivoPrincipal().getTasacion())) {
				vta += ofertaNueva.getActivoPrincipal().getTasacion().get(ofertaNueva.getActivoPrincipal().getTasacion().size()-1).getImporteTasacionFin();
			}
			List<ActivoValoraciones> valoraciones = ofertaNueva.getActivoPrincipal().getValoracion();
			for (ActivoValoraciones valoracion : valoraciones) {
				String codigoValoracion = valoracion.getTipoPrecio().getCodigo();
				if (DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT_LIBERBANK.equals(codigoValoracion)) {
					vnc += valoracion.getImporte();
				}else if (DDTipoPrecio.CODIGO_TPC_VALOR_RAZONABLE_LBK.equals(codigoValoracion)) {
					vr  += valoracion.getImporte();
				}
			}
		}

		pvb += ofertaNueva.getImporteOferta();
		
		// Cuando es una oferta que se está creando nos tienen que pasar los honorarios
		if (!Checks.esNulo(gastosExpediente)) {
			for (GastosExpediente gex : gastosExpediente) {
				cco += gex.getImporteFinal() * gex.getImporteCalculo();
			}
		// Cuando no nos pasan la lista de gastos es porque ya existe el expediente y lo recuperamos de ahí
		}else {
			ExpedienteComercial eco = expedienteComercialDao.getExpedienteComercialByIdOferta(ofertaNueva.getId());
			for (GastosExpediente gex : eco.getHonorarios()) {
				cco += gex.getImporteFinal() * gex.getImporteCalculo();
			}
		}

		pvn += pvb - cco;
			
		
		// Calculamos el comité sancionador en función a los datos sumados de todas las ofertas que forman parte de la agrupación
		comiteSancionador = devuelveComiteSancionador(vta, pvb, cco, pvn, vnc, vr);
		
		// Recorremos todas las ofertas para ponerle el nuevo comité sancionador
		for (Oferta oferta : listaOfertas) {
			ExpedienteComercial expedienteComercial = expedienteComercialDao.getExpedienteComercialByIdOferta(oferta.getId()); 
			if(!Checks.esNulo(expedienteComercial)) {
				expedienteComercial.setComiteSancion(comiteSancionador);
				expedienteComercial.setComitePropuesto(comiteSancionador);
			}
		}
		
		return comiteSancionador;
	}

	private void validacionesActivoOfertaLote(HashMap<String, String> errorsList, Activo activo) {
		PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class,
				genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", activo.getNumActivo()));
		List<Oferta> ofertas = this.getListaOfertasByActivo(activo);
		List<ActivoAgrupacion> agrupaciones = new ArrayList<ActivoAgrupacion>();
		Boolean loteComercialVivo = false;

		for (ActivoAgrupacionActivo activoAgrupacionActivo : activo.getAgrupaciones()) {
			agrupaciones.add(activoAgrupacionActivo.getAgrupacion());
		}

		for (ActivoAgrupacion agr : agrupaciones) {
			if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agr.getTipoAgrupacion().getCodigo())) {
				for (Oferta oferta : agr.getOfertas()) {
					if (DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())
							|| DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo())
							|| DDEstadoOferta.CODIGO_PENDIENTE.equals(oferta.getEstadoOferta().getCodigo())) {
						loteComercialVivo = true;
					}
				}
			}
		}

		if (!Checks.esNulo(activo.getSituacionComercial()) && DDSituacionComercial.CODIGO_VENDIDO.equals(activo.getSituacionComercial().getCodigo())
				|| !Checks.esNulo(activo.getSituacionComercial()) && DDSituacionComercial.CODIGO_NO_COMERCIALIZABLE.equals(activo.getSituacionComercial().getCodigo())
				|| !Checks.esNulo(perimetroActivo) && perimetroActivo.getIncluidoEnPerimetro() == 0
				|| loteComercialVivo) {
			errorsList.put("activosLote", RestApi.REST_MSG_UNKNOWN_KEY);
		} else {
			for (Oferta oferta : ofertas) {
				if (DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())
						|| DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo())
						|| DDEstadoOferta.CODIGO_PENDIENTE.equals(oferta.getEstadoOferta().getCodigo())) {
					errorsList.put("activosLote", RestApi.REST_MSG_UNKNOWN_KEY);
				}
			}
		}
	}

	public boolean estaViva(Oferta oferta){
		if(DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo()) || DDEstadoOferta.CODIGO_PENDIENTE.equals(oferta.getEstadoOferta().getCodigo()))		{
			return true;
		}
		return false;
	}

	private HashMap<String, String> avanzaTarea(Oferta oferta, OfertaDto ofertaDto, HashMap<String, String> errorsList) {
		Map<String, String[]> valoresTarea = new HashMap<String, String[]>();
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);
		List<ActivoTramite> listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(expedienteComercial.getTrabajo().getId());
		List<TareaExterna> tareasTramite = activoTareaExternaApi.getActivasByIdTramiteTodas(listaTramites.get(0).getId());
		DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
		boolean avanzar = true;

		if (ofertaDto.getCodTarea().equals("01")  && DDEstadosExpedienteComercial.CONTRAOFERTADO.equals(expedienteComercial.getEstado().getCodigo())) {
			if (ofertaDto.getAceptacionContraoferta()) {
				valoresTarea.put("aceptacionContraoferta", new String[] { DDSiNo.SI });
			} else if (!ofertaDto.getAceptacionContraoferta()) {
				valoresTarea.put("aceptacionContraoferta", new String[] { DDSiNo.NO });
			} else {
				avanzar = false;
			}
		} else if (ofertaDto.getCodTarea().equals("02") && DDEstadosExpedienteComercial.PTE_POSICIONAMIENTO.equals(expedienteComercial.getEstado().getCodigo())) {
			valoresTarea.put("fechaFirmaContrato", new String[] { format.format(ofertaDto.getFechaPrevistaFirma()) });
			valoresTarea.put("lugarFirma", new String[] { ofertaDto.getLugarFirma() });
		} else if (ofertaDto.getCodTarea().equals("03") && DDEstadosExpedienteComercial.PTE_FIRMA.equals(expedienteComercial.getEstado().getCodigo())) {
			valoresTarea.put("fechaFirma", new String[] { format.format(ofertaDto.getFechaFirma()) });
		} else {
			avanzar = false;
		}

		valoresTarea.put("idTarea", new String[] { tareasTramite.get(0).getTareaPadre().getId().toString() });

		if (avanzar) {
			try {
				adapter.save(valoresTarea);
			} catch (Exception e) {
				errorsList.put("codTarea", RestApi.REST_MSG_UNKNOWN_KEY);
				logger.error("error en OfertasManager", e);
			}
		} else {
			errorsList.put("codTarea", RestApi.REST_MSG_UNKNOWN_KEY);
		}
		return errorsList;
	}

	@Override
	public List<Oferta> getListaOfertasByActivo(Activo activo) {
		List<Oferta> ofertas = new ArrayList<Oferta>();

		if (!Checks.esNulo(activo)) {
			for (ActivoOferta activoOferta : activo.getOfertas()) {
				Oferta o = activoOferta.getPrimaryKey().getOferta();
				if (!Checks.esNulo(o)) {
					ofertas.add(o);
				}
			}
		}
		return ofertas;
	}

	public Double CompareDoubles(Double...doubles) {
		Double minus = null;
		for(int i = 0; i < doubles.length; i++) {
			if(Checks.esNulo(minus) && !Checks.esNulo(doubles[i])) {
				minus = doubles[i];
			} else if(!Checks.esNulo(doubles[i])) {
				int val = Double.compare(doubles[i], minus);

				if(val < 0) {
					minus = doubles[i];
				}
			}
		}
		return minus;
	}


	@Override
	public List<DtoPropuestaAlqBankia> getListPropuestasAlqBankiaFromView(Long ecoId) {
		List<DtoPropuestaAlqBankia> listaDto = expedienteComercialApi.getListaDtoPropuestaAlqBankiaByExpId(ecoId);
		return listaDto;
	}

	@Override
	public boolean checkPedirDoc(Long idActivo, Long idAgrupacion, Long idExpediente, String dniComprador, String codtipoDoc) {
		List<ClienteGDPR> clienteGDPR = null; Comprador comprador = null;
		ClienteComercial clienteCom = null; ActivoAgrupacion agrupacion = null;
		Activo activo = null; ExpedienteComercial expedienteCom = null;
		boolean esCarteraInternacional = false;

		Filter filterComprador = null, filterCodigoTpoDoc = null;
		if (!Checks.esNulo(dniComprador) && !Checks.esNulo(codtipoDoc)) {
			filterCodigoTpoDoc = genericDao.createFilter(FilterType.EQUALS, "tipoDocumento.codigo", codtipoDoc);

			if ((!Checks.esNulo(idActivo) || !Checks.esNulo(idAgrupacion)) && Checks.esNulo(idExpediente)) {
				filterComprador = genericDao.createFilter(FilterType.EQUALS, "numDocumento", dniComprador);
				clienteGDPR = genericDao.getList(ClienteGDPR.class, filterComprador, filterCodigoTpoDoc);

				if (Checks.esNulo(idActivo) && !Checks.esNulo(idAgrupacion)) {
					agrupacion = genericDao.get(ActivoAgrupacion.class, genericDao.createFilter(FilterType.EQUALS, "id", idAgrupacion));
					if(!Checks.esNulo(agrupacion.getActivoPrincipal())) {
						activo = agrupacion.getActivoPrincipal();
					} else {
						activo = agrupacion.getActivos().get(0).getActivo();
					}
				} else if (!Checks.esNulo(idActivo)) {
					activo = genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "id", idActivo));
				}
			} else if (Checks.esNulo(idActivo) && Checks.esNulo(idAgrupacion) && !Checks.esNulo(idExpediente)) {
				filterComprador = genericDao.createFilter(FilterType.EQUALS, "documento", dniComprador);
				expedienteCom = expedienteComercialDao.get(idExpediente);
				comprador = genericDao.get(Comprador.class, filterComprador, filterCodigoTpoDoc);

				if (!Checks.esNulo(expedienteCom)) {
					activo = expedienteCom.getOferta().getActivoPrincipal();
				}
			}
		}

		if (!Checks.estaVacio(clienteGDPR)) {
			clienteCom = clienteGDPR.get(0).getCliente();
		}

		//Se comprueba si es una cartera internacional.
		if (DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo())
				|| DDCartera.CODIGO_CARTERA_GIANTS.equals(activo.getCartera().getCodigo())
				|| DDCartera.CODIGO_CARTERA_TANGO.equals(activo.getCartera().getCodigo())
				|| DDCartera.CODIGO_CARTERA_GALEON.equals(activo.getCartera().getCodigo())) {
			esCarteraInternacional = true;
		}

		//Si viene de oferta (Activo/Agrupacion) se comprueban los checks del Cliente Comercial.
		// para saber si tiene el documento
		// True = Tiene documento adjunto, por lo tanto NO hay que pedirlo.
		// False = NO tiene documento adjunto, por lo tanto hay que pedirlo.
		if (!Checks.esNulo(clienteGDPR) && !Checks.esNulo(clienteCom)) {
			if (!Checks.esNulo(clienteGDPR.get(0).getNumDocumento()) && !Checks.esNulo(clienteCom.getDocumento()) && clienteCom.getDocumento().equals(clienteGDPR.get(0).getNumDocumento())) {
				if (!Checks.esNulo(clienteCom.getCesionDatos()) && clienteCom.getCesionDatos()) {
					if ((esCarteraInternacional && !Checks.esNulo(clienteCom.getTransferenciasInternacionales()) && clienteCom.getTransferenciasInternacionales()) ||
							!esCarteraInternacional) {
						return true;
					} else return false;
				} else return false;
			} else return false;
		//Si viene de comprador (Expediente Comercial) se comprueban los checks del Comprador
		// para saber si tiene el documento.
		} else if (!Checks.esNulo(comprador)) {
			if (!Checks.esNulo(comprador.getDocumento())) {
				if (!Checks.esNulo(comprador.getCesionDatos()) && comprador.getCesionDatos()) {
					if ((esCarteraInternacional && !Checks.esNulo(comprador.getTransferenciasInternacionales()) && comprador.getTransferenciasInternacionales()) ||
						!esCarteraInternacional) {
						return true;
					} else return false;
				} else return false;
			} else return false;
		}

		return false;
	}

	@Override
	public DtoClienteComercial getClienteComercialByTipoDoc(String dniComprador, String codtipoDoc) {
		Comprador comprador = null;
		ClienteComercial clienteCom = null;
		DtoClienteComercial clienteComercialDto = new DtoClienteComercial();

		if(!Checks.esNulo(dniComprador) && !Checks.esNulo(codtipoDoc)) {
			Filter filterComprador = genericDao.createFilter(FilterType.EQUALS, "documento",
					dniComprador);

			Filter filterCodigoTpoDoc = genericDao.createFilter(FilterType.EQUALS, "tipoDocumento.codigo",
					codtipoDoc);

			comprador = genericDao.get(Comprador.class, filterComprador,filterCodigoTpoDoc);
		}
		if(!Checks.esNulo(comprador)) {
			clienteCom = comprador.getClienteComercial();
		}

		try {
			if(!Checks.esNulo(clienteCom)) {
				beanUtilNotNull.copyProperties(clienteCom,clienteComercialDto);
				clienteComercialDto.setApellidosCliente(clienteCom.getApellidos());
				clienteComercialDto.setNombreCliente(clienteCom.getNombre());
				clienteComercialDto.setId(clienteCom.getId());
				clienteComercialDto.setRazonSocial(clienteCom.getRazonSocial());
				clienteComercialDto.setCesionDatos(clienteCom.getCesionDatos());
				clienteComercialDto.setComunicacionTerceros(clienteCom.getComunicacionTerceros());
				clienteComercialDto.setTransferenciasInternacionales(clienteCom.getTransferenciasInternacionales());
				if(!Checks.esNulo(clienteCom.getEstadoCivil())) {
					clienteComercialDto.setEstadoCivilCodigo(clienteCom.getEstadoCivil().getCodigo());
					clienteComercialDto.setEstadoCivilDescripcion(clienteCom.getEstadoCivil().getDescripcion());
				}
				if(!Checks.esNulo(clienteCom.getRegimenMatrimonial())) {
					clienteComercialDto.setRegimenMatrimonialCodigo(clienteCom.getRegimenMatrimonial().getCodigo());
					clienteComercialDto.setRegimenMatrimonialDescripcion(clienteCom.getRegimenMatrimonial().getDescripcion());
				}

				if(!Checks.esNulo(comprador.getTipoPersona())) {
					clienteComercialDto.setTipoPersonaCodigo(comprador.getTipoPersona().getCodigo());
					clienteComercialDto.setTipoPersonaDescripcion(comprador.getTipoPersona().getDescripcion());
				}
			}


		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return clienteComercialDto;
	}

	@Override
	public DtoClienteComercial getClienteGDPRByTipoDoc(String dniComprador, String codtipoDoc) {
		ClienteGDPR clienteGDPR = null;
		ClienteComercial clienteCom = null;
		DtoClienteComercial clienteComercialDto = new DtoClienteComercial();


		if(!Checks.esNulo(dniComprador) && !Checks.esNulo(codtipoDoc)) {
			Filter filterComprador = genericDao.createFilter(FilterType.EQUALS, "numDocumento",
					dniComprador);

			Filter filterCodigoTpoDoc = genericDao.createFilter(FilterType.EQUALS, "tipoDocumento.codigo",
					codtipoDoc);

			List<ClienteGDPR> clientesGDPR = genericDao.getList(ClienteGDPR.class, filterComprador,filterCodigoTpoDoc);

			if(!clientesGDPR.isEmpty()) {
				for(ClienteGDPR cl : clientesGDPR){
					if(cl.getCliente() != null && !Checks.esNulo(cl.getCliente().getIdPersonaHaya())){
						clienteGDPR = cl;
						break;
					}
				}
				if(clienteGDPR == null){
					clienteGDPR = clientesGDPR.get(0);
				}

			}
		}
		if(!Checks.esNulo(clienteGDPR)) {
			clienteCom = clienteGDPR.getCliente();

			try {
				if(!Checks.esNulo(clienteCom)) {
					beanUtilNotNull.copyProperties(clienteCom,clienteComercialDto);
					clienteComercialDto.setApellidosCliente(clienteCom.getApellidos());
					clienteComercialDto.setNombreCliente(clienteCom.getNombre());
					clienteComercialDto.setId(clienteCom.getId());
					clienteComercialDto.setRazonSocial(clienteCom.getRazonSocial());
					clienteComercialDto.setDireccion(clienteCom.getDireccion());
					clienteComercialDto.setTelefono(clienteCom.getTelefono1());
					clienteComercialDto.setEmail(clienteCom.getEmail());
					clienteComercialDto.setCesionDatos(clienteGDPR.getCesionDatos());
					clienteComercialDto.setComunicacionTerceros(clienteGDPR.getComunicacionTerceros());
					clienteComercialDto.setTransferenciasInternacionales(clienteGDPR.getTransferenciasInternacionales());
					clienteComercialDto.setIdPersonaHaya(clienteCom.getIdPersonaHaya());
					if(!Checks.esNulo(clienteCom.getEstadoCivil())) {
						clienteComercialDto.setEstadoCivilCodigo(clienteCom.getEstadoCivil().getCodigo());
						clienteComercialDto.setEstadoCivilDescripcion(clienteCom.getEstadoCivil().getDescripcion());
					}
					if(!Checks.esNulo(clienteCom.getRegimenMatrimonial())) {
						clienteComercialDto.setRegimenMatrimonialCodigo(clienteCom.getRegimenMatrimonial().getCodigo());
						clienteComercialDto.setRegimenMatrimonialDescripcion(clienteCom.getRegimenMatrimonial().getDescripcion());
					}
					if(!Checks.esNulo(clienteCom.getTipoPersona())) {
						clienteComercialDto.setTipoPersonaCodigo(clienteCom.getTipoPersona().getCodigo());
						clienteComercialDto.setTipoPersonaDescripcion(clienteCom.getTipoPersona().getDescripcion());
					}
					if(!Checks.esNulo(clienteCom.getTipoDocumento())) {
						clienteComercialDto.setTipoDocumentoCodigo(clienteCom.getTipoDocumento().getCodigo());
						clienteComercialDto.setTipoDocumentoDescripcion(clienteCom.getTipoDocumento().getDescripcion());
					}
					if(!Checks.esNulo(clienteCom.getDocumento())) {
						clienteComercialDto.setDocumento(clienteCom.getDocumento());
					}
				}


			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
		}else {
			clienteComercialDto.setDocumento(dniComprador);
			clienteComercialDto.setTipoDocumentoCodigo(codtipoDoc);
		}

		return clienteComercialDto;
	}

	@Override
	public void llamadaMaestroPersonas(Long idExpediente, String cartera) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		Thread maestroPersona = new Thread( new MaestroDePersonas(idExpediente,usuarioLogado.getUsername(),cartera ));
	   	maestroPersona.start();
	}

	@Override
	public void llamadaMaestroPersonas(String numDocCliente, String cartera) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		Thread maestroPersona = new Thread( new MaestroDePersonas(numDocCliente, usuarioLogado.getUsername(), cartera));
	   	maestroPersona.start();
	}

	private void validacionesLote(HashMap<String, String> errorsList, Activo activo, DDCartera cartera,
			DDSubcartera subcartera, ActivoPropietario propietario, Integer geolocalizacion) {
		if (activo.getCartera() != cartera
				|| activo.getSubcartera() != subcartera
				|| activo.getPropietarioPrincipal() != propietario
				|| !activoApi.getGeolocalizacion(activo).equals(geolocalizacion)) {
			errorsList.put("activosLote", RestApi.REST_MSG_UNKNOWN_KEY);
		}
	}

	@Override
	public DtoOferta getOfertaOrigenByIdExpediente(Long numExpediente) {

		ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByNumExpediente(numExpediente);
		Oferta oferta = expediente.getOferta();
		DtoOferta dtoOferta = new DtoOferta();
		OfertaGencat ofertaGencat = genericDao.get(OfertaGencat.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId()));

		if(!Checks.esNulo(ofertaGencat) && !Checks.esNulo(ofertaGencat.getIdOfertaAnterior())) {
		  Oferta ofertaOrigen = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id", ofertaGencat.getIdOfertaAnterior()));
		  dtoOferta.setNumOferta(Long.toString(ofertaOrigen.getNumOferta()));
		}

	    return dtoOferta;
	}

	public String getDestinoComercialActivo(Long idActivo, Long idAgrupacion, Long idExpediente) {
		String destinoComercial = "";
		if (!Checks.esNulo(idActivo) && Checks.esNulo(idAgrupacion)) {
			destinoComercial = activoApi.get(idActivo).getActivoPublicacion().getTipoComercializacion().getDescripcion();
		} else if (Checks.esNulo(idActivo) && !Checks.esNulo(idAgrupacion)) {
			ActivoAgrupacion agr = activoAgrupacionApi.get(idAgrupacion);
			if(!Checks.esNulo(agr.getActivoPrincipal())) {
				destinoComercial = agr.getActivoPrincipal().getActivoPublicacion().getTipoComercializacion().getDescripcion();
			} else {
				destinoComercial = agr.getActivos().get(0).getActivo().getActivoPublicacion().getTipoComercializacion().getDescripcion();
			}
		} else {
			ExpedienteComercial exp = expedienteComercialApi.findOne(idExpediente);
			destinoComercial = exp.getOferta().getActivoPrincipal().getActivoPublicacion().getTipoComercializacion().getDescripcion();
		}

	return destinoComercial;

	}

	public boolean existeClienteOComprador(Long idActivo, Long idAgrupacion, Long idExpediente, String docCliente, String codtipoDoc) {
		ClienteGDPR clienteGDPR = null; Comprador comprador = null;

		Filter filterCodigoTpoDoc = genericDao.createFilter(FilterType.EQUALS, "tipoDocumento.codigo", codtipoDoc);
		Boolean existeCliOCom = false;
		if(!Checks.esNulo(idActivo) || !Checks.esNulo(idAgrupacion)) {
			clienteGDPR = genericDao.get(ClienteGDPR.class,
					genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente), filterCodigoTpoDoc);
			if(!Checks.esNulo(clienteGDPR)) existeCliOCom = true;
		} else if(!Checks.esNulo(idExpediente)) {
			comprador = genericDao.get(Comprador.class,
					genericDao.createFilter(FilterType.EQUALS, "documento", docCliente), filterCodigoTpoDoc);
			if(!Checks.esNulo(comprador)) existeCliOCom = true;
		}
		return existeCliOCom;
	}

	public boolean esCarteraInternacional(Long idActivo, Long idAgrupacion, Long idExpediente) {
		Boolean esCarteraInternacional = false;
		String codCartera = null;
		if (!Checks.esNulo(idActivo) && Checks.esNulo(idAgrupacion)) {
			codCartera = activoApi.get(idActivo).getCartera().getCodigo();
		} else if (Checks.esNulo(idActivo) && !Checks.esNulo(idAgrupacion)) {
			ActivoAgrupacion agr = activoAgrupacionApi.get(idAgrupacion);
			if(!Checks.esNulo(agr.getActivoPrincipal())) {
				codCartera = agr.getActivoPrincipal().getCartera().getCodigo();
			} else {
				codCartera = agr.getActivos().get(0).getActivo().getCartera().getCodigo();
			}
		} else {
			codCartera = expedienteComercialApi.findOne(idExpediente).getOferta().getActivoPrincipal().getCartera().getCodigo();
		}

		if(!Checks.esNulo(codCartera)) {
			if(codCartera.equals(DDCartera.CODIGO_CARTERA_CERBERUS)
					|| codCartera.equals(DDCartera.CODIGO_CARTERA_GIANTS)
					|| codCartera.equals(DDCartera.CODIGO_CARTERA_TANGO)
					|| codCartera.equals(DDCartera.CODIGO_CARTERA_GALEON)) {
				esCarteraInternacional = true;
			} else {
				esCarteraInternacional = false;
			}
		}

	return esCarteraInternacional;

	}

	public Long getIdTareaByNumOfertaAndCodTarea(Long ofrNumOferta, String codTarea) {
		Long idTarea =null;
		List<Long> tareasTramite = activoTareaExternaDao.getTareasByIdOfertaCodigoTarea(ofrNumOferta,codTarea);
        if(!Checks.esNulo(tareasTramite) && !tareasTramite.isEmpty()) {
        	idTarea = tareasTramite.get(0);
        }
		return idTarea;
	}

	public void darDebajaAgrSiOfertaEsLoteCrm(Oferta oferta) {
		if (OfertaApi.ORIGEN_WEBCOM.equals(oferta.getOrigen())) {
			ActivoAgrupacion agr = oferta.getAgrupacion();
			if (agr != null && agr.getTipoAgrupacion() != null
					&& DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA.equals(agr.getTipoAgrupacion().getCodigo())) {

				agr.setFechaBaja(new Date());
				activoAgrupacionApi.saveOrUpdate(agr);

			}
		}
	}

	@Override
	public GestorEntidad getGestorEntidad(Oferta oferta) {
		GestorActivo gestor = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", oferta.getGestorComercialPrescriptor());
		gestor = genericDao.get(GestorActivo.class, filtro);
 		return gestor;
	}

	@Override
	public Usuario calcularGestorComercialPrescriptorOferta(Oferta oferta) {

			ActivoProveedor activoProveedor = oferta.getPrescriptor();
			ProveedorGestorCajamar proveedorGestorCajamar = null;
			boolean isPreescriptorTipoOficina;
			boolean isMinoristaOResidencial = false;
			boolean isComprobarMultipleActivos = false;

			if(!DDCartera.CODIGO_CARTERA_CAJAMAR.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
				return null;
			}

			List<ActivoOferta> listaActivos=oferta.getActivosOferta();
			List<GestorEntidad> listaGestoresActivosOferta = new ArrayList<GestorEntidad>();

			if(!Checks.esNulo(listaActivos)
					&& !Checks.esNulo(listaActivos.get(0).getPrimaryKey().getActivo())) {
				if(!Checks.esNulo(activoProveedor.getTipoProveedor().getCodigo())) {
					
					if (!Checks.esNulo(listaActivos.get(0).getPrimaryKey().getActivo().getEquipoGestion())) {
						if(DDEquipoGestion.CODIGO_MINORISTA.equals(listaActivos.get(0).getPrimaryKey().getActivo().getEquipoGestion().getCodigo())) {
							isMinoristaOResidencial = true;
						}
					} else if (!Checks.esNulo(listaActivos.get(0).getPrimaryKey().getActivo().getTipoComercializar()) 
							&& DDTipoComercializar.DESCRIPCION_RETAIL.equals(listaActivos.get(0).getPrimaryKey().getActivo().getTipoComercializar().getCodigo())) {
						isMinoristaOResidencial = true;
					}
					
					isPreescriptorTipoOficina = DDTipoProveedor.COD_OFICINA_CAJAMAR.equals(activoProveedor.getTipoProveedor().getCodigo());

					if(isMinoristaOResidencial) {
						if(isPreescriptorTipoOficina) {
							Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activoProveedor.id", activoProveedor.getId());
							proveedorGestorCajamar = genericDao.get(ProveedorGestorCajamar.class, filtro);
							if(!Checks.esNulo(proveedorGestorCajamar)
									&& !Checks.esNulo(proveedorGestorCajamar.getUsuario())
									&& !Checks.esNulo(proveedorGestorCajamar.getUsuario().getId())) {
								return proveedorGestorCajamar.getUsuario();
							}
						}else {
							isComprobarMultipleActivos = true;
						}
					} else {
						isComprobarMultipleActivos = true;
					}
				}
				else {
					return null;
				}
			}

			if(isComprobarMultipleActivos) {
				for(ActivoOferta activoOferta: listaActivos) {
					GestorEntidad gestorEntidad = gestorActivoApi.getGestorEntidadByActivoYTipo(activoOferta.getPrimaryKey().getActivo(), GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
					if(Checks.estaVacio(listaGestoresActivosOferta)) {
						listaGestoresActivosOferta.add(gestorEntidad);
					}else if(gestorEntidad.getUsuario().getId() != listaGestoresActivosOferta.get(0).getUsuario().getId()) {
						return null;
					}
				}
				if(!Checks.estaVacio(listaGestoresActivosOferta) && listaGestoresActivosOferta.size() == 1) {
					return listaGestoresActivosOferta.get(0).getUsuario();
				}
			}
			return null;
		}

	@Override
	public Oferta getOfertaByIdExpediente(Long idExpediente) {
		return genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", idExpediente)).getOferta();
	}

	@Override
	public Boolean esTareaFinalizada(ActivoTramite tramite, String codigoTarea) {

		Boolean resultado = false;

		if(!Checks.esNulo(codigoTarea) && !Checks.esNulo(tramite)) {

			Filter filtroTRA = genericDao.createFilter(FilterType.EQUALS, "tramite", tramite);

			List<TareaActivo> listaTareas = genericDao.getList(TareaActivo.class, filtroTRA);

			if(!Checks.estaVacio(listaTareas)) {
				for(TareaActivo tarea : listaTareas) {
					if(codigoTarea.equals(tarea.getTareaExterna().getTareaProcedimiento().getCodigo())) {
						resultado = !Checks.esNulo(tarea.getTareaFinalizada()) ? tarea.getTareaFinalizada() : false;

						if(!resultado || (resultado && T017.equals(tramite.getTipoTramite().getCodigo()))) break;
					}
				}
			}
		}

		return resultado;
	}

	@Override
	public boolean checkEsYubai(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			Activo activo = ofertaAceptada.getActivoPrincipal();
			if (!Checks.esNulo(activo) && (!Checks.esNulo(activo.getCartera()) && !Checks.esNulo(activo.getSubcartera()))) {
				return (DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(activo.getCartera().getCodigo())
						&& DDSubcartera.CODIGO_YUBAI.equals(activo.getSubcartera().getCodigo()));
			}
		}
		return false;
	}
	
	@Override
	public boolean checkEsOmega(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			Activo activo = ofertaAceptada.getActivoPrincipal();
			if (!Checks.esNulo(activo) && (!Checks.esNulo(activo.getCartera()) && !Checks.esNulo(activo.getSubcartera()))) {
				return (DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(activo.getCartera().getCodigo())
						&& DDSubcartera.CODIGO_OMEGA.equals(activo.getSubcartera().getCodigo()));
			}
		}
		return false;
	}
	
	@Override
	public DtoPage getListOfertasAgrupadasLiberbank(DtoVListadoOfertasAgrupadasLbk dto) {
		
		DtoPage ofertasAgrupadasPage;
		
		Oferta oferta = genericDao.get(Oferta.class,
				genericDao.createFilter(FilterType.EQUALS, "numOferta",dto.getNumOfertaPrincipal()));
		
		if(!Checks.esNulo(oferta) && !Checks.estaVacio(oferta.getActivosOferta()) && 
				DDCartera.CODIGO_CARTERA_LIBERBANK.equals(oferta.getActivosOferta().get(0).getPrimaryKey().getActivo().getCartera().getCodigo())){
			ofertasAgrupadasPage = vOfertasAgrupadasLbkDao.getListOfertasAgrupadasLbk(dto);
		}else {
			ofertasAgrupadasPage = new DtoPage(new ArrayList<VListadoOfertasAgrupadasLbk>(),0);
		}
			
		return ofertasAgrupadasPage;
	}
	
	@Override
	public DtoPage getListActivosOfertasAgrupadasLiberbank(DtoVListadoOfertasAgrupadasLbk dto) {
		
		DtoPage ofertasAgrupadasPage;
		
		Oferta oferta = genericDao.get(Oferta.class,
				genericDao.createFilter(FilterType.EQUALS, "numOferta",dto.getNumOfertaPrincipal()));
		
		if(!Checks.esNulo(oferta) && !Checks.estaVacio(oferta.getActivosOferta()) && 
				DDCartera.CODIGO_CARTERA_LIBERBANK.equals(oferta.getActivosOferta().get(0).getPrimaryKey().getActivo().getCartera().getCodigo())){
			ofertasAgrupadasPage = vOfertasAgrupadasLbkDao.getListActivosOfertasAgrupadasLbk(dto);
		}else {
			ofertasAgrupadasPage = new DtoPage(new ArrayList<VListadoOfertasAgrupadasLbk>(),0);
		}
			
		return ofertasAgrupadasPage;
	}

	@Override
	public boolean isOfertaPrincipal(Oferta oferta) {
		if(!Checks.esNulo(oferta) && DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo()) 
				&& DDCartera.CODIGO_CARTERA_LIBERBANK.equals(oferta.getActivosOferta().get(0).getPrimaryKey().getActivo().getCartera().getCodigo()) 
				&& !Checks.esNulo(oferta.getClaseOferta()) && DDClaseOferta.CODIGO_OFERTA_PRINCIPAL.equals(oferta.getClaseOferta().getCodigo())){
			return true;	
		}
		return false;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public ExcelReport generarExcelOfertasCES(DtoOfertasFilter dtoOfertasFilter) {
		dtoOfertasFilter.setStart(excelReportGeneratorApi.getStart());
		dtoOfertasFilter.setLimit(excelReportGeneratorApi.getLimit());
		
		List<VListOfertasCES> listaOfertas = (List<VListOfertasCES>) ofertaDao.getListOfertasCES(dtoOfertasFilter).getResults();
		
		ExcelReport report = new ListaOfertasCESExcelReport(listaOfertas);
		return report;
	}
	
	public void actualizaOfertasDependientes (Long nuevoId, Long ofertaDependiente) {
		Oferta principal = getOfertaPrincipalById(ofertaDependiente);
		List<OfertasAgrupadasLbk> ofertasAgrupadas = principal.getOfertasAgrupadas();
		
		for (OfertasAgrupadasLbk lisOf : ofertasAgrupadas) {
			ofertasAgrupadasLbkDao.actualizaPrincipalId(nuevoId, lisOf.getOfertaDependiente().getId());
		} 
	}

	public boolean isOfertaDependiente(Oferta oferta) {
		if(!Checks.esNulo(oferta) && DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo()) 
				&& DDCartera.CODIGO_CARTERA_LIBERBANK.equals(oferta.getActivosOferta().get(0).getPrimaryKey().getActivo().getCartera().getCodigo()) 
				&& !Checks.esNulo(oferta.getClaseOferta()) && DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE.equals(oferta.getClaseOferta().getCodigo())){
				return true;	
		}
		return false;
	}
	
	@Override
	public List<Oferta> ofertasAgrupadasDependientes(Oferta oferta) {
		List<Oferta> listaOfertas = new ArrayList<Oferta>();
		if (!Checks.esNulo(oferta) && isOfertaPrincipal(oferta)) { 
			Filter ofertaPrincipal = genericDao.createFilter(FilterType.EQUALS, "ofertaPrincipal.id", oferta.getId());
			List<OfertasAgrupadasLbk> listaOfertasIndividuales = genericDao.getList(OfertasAgrupadasLbk.class, ofertaPrincipal);
			if (!Checks.estaVacio(listaOfertasIndividuales)) {
				for (OfertasAgrupadasLbk ofertaIndividual : listaOfertasIndividuales) {
					if (!Checks.esNulo(ofertaIndividual)) {
						listaOfertas.add(ofertaIndividual.getOfertaDependiente());
					}
				}
			}
		}
		return listaOfertas;
	}
	
	@Override
	public Oferta tareaOferta(Long idTarea) {
		Oferta oferta = null;
		Filter filtroTarea = genericDao.createFilter(FilterType.EQUALS, "tareaPadre.id", idTarea);
		TareaExterna tareaExterna = genericDao.get(TareaExterna.class, filtroTarea);
		if (!Checks.esNulo(tareaExterna)) {
			TareaActivo tareaActivo = tareaActivoApi.getByIdTareaExterna(tareaExterna.getId());
			if (!Checks.esNulo(tareaActivo)) {
				ActivoTramite tramite = tareaActivo.getTramite();
				if (!Checks.esNulo(tramite)) {
					Trabajo trabajo = tramite.getTrabajo();
					if (!Checks.esNulo(trabajo)) {
						Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());
						ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtroTrabajo);
						if (!Checks.esNulo(expediente)) {
							oferta = expediente.getOferta();
						}
					}
				}
			}
		}
		return oferta;
	}
	
	@Override
	public String isValidateOfertasDependientes(TareaExterna tareaExterna, Map<String, Map<String,String>> valores) {
		Oferta oferta = tareaOferta(tareaExterna.getTareaPadre().getId());
		if (!Checks.esNulo(oferta) && isOfertaPrincipal(oferta)) {
			try {
				return tareaActivoApi.validarTareaDependientes(tareaExterna, oferta, valores);
			} catch (Exception e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			}
		}
		
		return null;
	}
	
	@Override
	public boolean ofertaConActivoYaIncluidoEnOfertaAgrupadaLbk(Oferta ofertaDependiente, Oferta ofertaPrincipal) 
	{
		Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "ofertaPrincipal.id", ofertaPrincipal.getId());	
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);	
		List<OfertasAgrupadasLbk> ofertasAgrupadasLbk = genericDao.getList(OfertasAgrupadasLbk.class, filtroId, filtroBorrado);
		
		// En esta lista insertaré todos los activos que pertenecen a las ofertas dependientes.
		List<Activo> activosEnLaAgrupacion = new ArrayList<Activo>();		
		for(OfertasAgrupadasLbk ogrLbk : ofertasAgrupadasLbk) {
			List<ActivoOferta> actOfrDependList = ogrLbk.getOfertaDependiente().getActivosOferta();
			for(ActivoOferta actOfr : actOfrDependList) {
				activosEnLaAgrupacion.add(actOfr.getPrimaryKey().getActivo());
			}
		}
		// Tambien incluyo los activos relacionados con la oferta principal.
		List<ActivoOferta> actOfrPrincList = ofertaPrincipal.getActivosOferta();
		for(ActivoOferta actOfr : actOfrPrincList) {
			activosEnLaAgrupacion.add(actOfr.getPrimaryKey().getActivo());
		}
		
		List<ActivoOferta> actOfrNuevaDependList = ofertaDependiente.getActivosOferta();
		for(ActivoOferta actOfr : actOfrNuevaDependList) {
			for(Activo act : activosEnLaAgrupacion) {
				if(actOfr.getActivoId().equals(act.getId()))
					return true;
			}
		}
		return false;
	}
	
	@Override
	public boolean activoYaIncluidoEnOfertaAgrupadaLbk(Long idActivo, Oferta ofertaPrincipal) 
	{
		Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "ofertaPrincipal.id", ofertaPrincipal.getId());	
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);	
		List<OfertasAgrupadasLbk> ofertasAgrupadasLbk = genericDao.getList(OfertasAgrupadasLbk.class, filtroId, filtroBorrado);
		
		// En esta lista insertaré todos los activos que pertenecen a las ofertas dependientes.
		List<Activo> activosEnLaAgrupacion = new ArrayList<Activo>();		
		for(OfertasAgrupadasLbk ogrLbk : ofertasAgrupadasLbk) {
			List<ActivoOferta> actOfrDependList = ogrLbk.getOfertaDependiente().getActivosOferta();
			for(ActivoOferta actOfr : actOfrDependList) {
				activosEnLaAgrupacion.add(actOfr.getPrimaryKey().getActivo());
			}
		}
		// Tambien incluyo los activos relacionados con la oferta principal.
		List<ActivoOferta> actOfrPrincList = ofertaPrincipal.getActivosOferta();
		for(ActivoOferta actOfr : actOfrPrincList) {
			activosEnLaAgrupacion.add(actOfr.getPrimaryKey().getActivo());
		}
		
		for(Activo act : activosEnLaAgrupacion) {
			if(idActivo.equals(act.getId()))
				return true;
		}
		return false;
	}
	
	@Override
	public boolean agrupacionConActivoYaIncluidoEnOfertaAgrupadaLbk(Long idAgrupacion, Oferta ofertaPrincipal) 
	{
		Filter filtroIdOferta = genericDao.createFilter(FilterType.EQUALS, "ofertaPrincipal.id", ofertaPrincipal.getId());	
		Filter filtroBorradoOferta = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);	
		List<OfertasAgrupadasLbk> ofertasAgrupadasLbk = genericDao.getList(OfertasAgrupadasLbk.class, filtroIdOferta, filtroBorradoOferta);
		
		// En esta lista insertaré todos los activos que pertenecen a las ofertas dependientes.
		List<Activo> activosEnLaOfertaAgrupada = new ArrayList<Activo>();		
		for(OfertasAgrupadasLbk ogrLbk : ofertasAgrupadasLbk) {
			List<ActivoOferta> actOfrDependList = ogrLbk.getOfertaDependiente().getActivosOferta();
			for(ActivoOferta actOfr : actOfrDependList) {
				activosEnLaOfertaAgrupada.add(actOfr.getPrimaryKey().getActivo());
			}
		}
		// Tambien incluyo los activos relacionados con la oferta principal.
		List<ActivoOferta> actOfrPrincList = ofertaPrincipal.getActivosOferta();
		for(ActivoOferta actOfr : actOfrPrincList) {
			activosEnLaOfertaAgrupada.add(actOfr.getPrimaryKey().getActivo());
		}
		
		Filter filtroIdAgrupacion = genericDao.createFilter(FilterType.EQUALS, "id", idAgrupacion);	
		Filter filtroBorradoAgrupacion = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);	
		ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtroIdAgrupacion, filtroBorradoAgrupacion);
		
		List<Activo> activosEnAgrupacion = new ArrayList<Activo>();
		
		for (ActivoAgrupacionActivo aga : agrupacion.getActivos()) {
			activosEnAgrupacion.add(aga.getActivo());
		}
		
		for(Activo actOfr : activosEnLaOfertaAgrupada) {
			for(Activo actAgr : activosEnAgrupacion)
			{
				if(actAgr.getId().equals(actOfr.getId()))
					return true;
			}
		}
		return false;
	}
	
	@Override
	public boolean checkTipoImpuesto(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.findOneByOferta(ofertaAceptada);
			if (!Checks.esNulo(expediente)) {
				CondicionanteExpediente condicionante = expediente.getCondicionante();
				if (!Checks.esNulo(condicionante)) {
					DDTiposImpuesto tipoImpuesto = condicionante.getTipoImpuesto();
					if (!Checks.esNulo(tipoImpuesto)) {
						if (!Checks.esNulo(tipoImpuesto.getCodigo())) {
							return true;
						}
					}
				}
			}
		}

		return false;
	}
	
	@Override
	public boolean checkReservaInformada(TareaExterna tareaExterna) {
		Oferta ofertaAceptada = tareaExternaToOferta(tareaExterna);
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());
			if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getSolicitaReserva())) {
				return true;
			}

		}
		return false;
	}
}

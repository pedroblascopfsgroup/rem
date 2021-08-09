package es.pfsgroup.plugin.rem.tramitacionofertas;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import es.pfsgroup.plugin.rem.alaskaComunicacion.AlaskaComunicacionManager;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.ModelMap;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.manager.GestorDocumentalExpedientesManager;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.BoardingComunicacionApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.TramitacionOfertasApi;
import es.pfsgroup.plugin.rem.condiciontanteo.CondicionTanteoApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.gestor.dao.GestorExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceSancionOfertaAceptacionYRechazo;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoBbvaActivos;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoPublicacionHistorico;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonioContrato;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.ActivosAlquilados;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.ClienteCompradorGDPR;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.CompradorExpediente.CompradorExpedientePk;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Formalizacion;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.GestorActivo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.TanteoActivoExpediente;
import es.pfsgroup.plugin.rem.model.TitularesAdicionalesOferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VPreciosVigentes;
import es.pfsgroup.plugin.rem.model.dd.DDAdministracion;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDClaseOferta;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDRiesgoOperacion;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;
import es.pfsgroup.plugin.rem.oferta.OfertaManager;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.oferta.dao.OfertasAgrupadasLbkDao;
import es.pfsgroup.plugin.rem.thread.ContenedorExpComercial;
import es.pfsgroup.plugin.rem.thread.ConvivenciaAlaska;
import es.pfsgroup.plugin.rem.thread.MaestroDePersonas;
import es.pfsgroup.plugin.rem.thread.TramitacionOfertasAsync;
import org.springframework.ui.ModelMap;

@Service("tramitacionOfertasManager")
public class TramitacionOfertasManager implements TramitacionOfertasApi {

	protected static final Log logger = LogFactory.getLog(TramitacionOfertasManager.class);

	private static final String AVISO_MENSAJE_ACTIVO_EN_LOTE_COMERCIAL = "activo.aviso.aceptatar.oferta.activo.dentro.lote.comercial";
	private static final String AVISO_MENSAJE_TIPO_NUMERO_DOCUMENTO = "activo.motivo.oferta.tipo.numero.documento";
	private static final String AVISO_MENSAJE_CLIENTE_OBLIGATORIO = "activo.motivo.oferta.cliente";
	private static final String AVISO_MENSAJE_EXISTEN_OFERTAS_VENTA = "activo.motivo.oferta.existe.venta";
	private static final String AVISO_MENSAJE_ACITVO_ALQUILADO_O_OCUPADO = "activo.motivo.oferta.alquilado.ocupado";
	private static final String AVISO_MENSAJE_EXPEDIENTE_ANULADO_POR_GENCAT = "activo.motivo.oferta.anulado.gencat";
	private static final String EXISTEN_UNIDADES_ALQUILABLES_CON_OFERTAS_VIVAS = "activo.matriz.con.unidades.alquilables.ofertas.vivas";
	private static final String EXISTE_ACTIVO_MATRIZ_CON_OFERTAS_VIVAS = "activo.unidad.alquilable.con.activo.matriz.ofertas.vivas";
	private static final String AGRUPACION_SIN_FORMALIZACION = "agrupacion.sin.formalizacion";
	private static final String MAESTRO_ORIGEN_WCOM = "WCOM";
	private static final Integer ES_FORMALIZABLE = new Integer(1);

	@Resource
	private MessageService messageServices;

	@Autowired
	private OfertaManager ofertaManager;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private ActivoManager activoManager;

	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private GencatApi gencatApi;

	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private OfertaDao ofertaDao;

	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;

	@Autowired
	private NotificatorServiceSancionOfertaAceptacionYRechazo notificatorServiceSancionOfertaAceptacionYRechazo;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

	@Autowired
	private OfertaApi ofertaApi;

	@Resource
	private Properties appProperties;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private List<CondicionTanteoApi> condiciones;

	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteComercialApi;

	@Autowired
	private GestorExpedienteComercialDao gestorExpedienteComercialDao;

	@Autowired
	private AgrupacionAdapter agrupacionAdapter;

	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private OfertasAgrupadasLbkDao ofertasAgrupadasLbkDao;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

	@Autowired
	private AlaskaComunicacionManager alaskaComunicacionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Autowired
	private BoardingComunicacionApi boardingComunicacionApi;

	@Override
	@Transactional(readOnly = false)
	public boolean saveOferta(DtoOfertaActivo dto, Boolean esAgrupacion, Boolean asincrono)
			throws JsonViewerException, Exception, Error {

		Activo activo = null;
		ActivoAgrupacion agrupacion = null;

		if (esAgrupacion) {
			agrupacion = genericDao.get(ActivoAgrupacion.class,
					genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdAgrupacion()));
			activo = agrupacion.getActivoPrincipal() != null ? agrupacion.getActivoPrincipal()
					: agrupacion.getActivos().get(0).getActivo();
		} else {
			activo = activoAdapter.getActivoById(dto.getIdActivo());
		}

		Oferta oferta = saveOferta(dto, activo, esAgrupacion, agrupacion, asincrono);
		
		if(oferta != null) 
			return true;
		else 
			return false;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean doTramitacionOferta(Long idOferta, Long idActivo, Long idAgrupacion) throws JsonViewerException, Exception, Error {
		Activo activo = null;
		ActivoAgrupacion agrupacion = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idOferta);
		Oferta oferta = genericDao.get(Oferta.class, filtro);
		if (idAgrupacion != null) {
			agrupacion = genericDao.get(ActivoAgrupacion.class,
					genericDao.createFilter(FilterType.EQUALS, "id", idAgrupacion));
			activo = agrupacion.getActivoPrincipal() != null ? agrupacion.getActivoPrincipal()
					: agrupacion.getActivos().get(0).getActivo();
		} else {
			activo = activoAdapter.getActivoById(idActivo);
		}
		
		if(oferta != null) {
			return expedienteComercialApi.doTramitacionAsincrona(activo, oferta);			
		}
		return false;		
	}
	
	@Transactional(readOnly = false)
	public Oferta saveOferta(DtoOfertaActivo dto, Activo activo, Boolean esAgrupacion, ActivoAgrupacion agrupacion,
			Boolean asincrono) throws JsonViewerException, Exception {
		boolean resultado = true;
		ExpedienteComercial expediente = null;
		Boolean esAcepta = false;

		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdOferta());
		Oferta oferta = genericDao.get(Oferta.class, filtro);
		Boolean esAlquiler = DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo());

		DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadoOferta.class, dto.getCodigoEstadoOferta());

		oferta.setEstadoOferta(estadoOferta);

		validateSaveOferta(dto, oferta, estadoOferta, activo, esAlquiler, esAgrupacion, agrupacion);

		// Al aceptar la oferta, se crea el trabajo de sancion oferta y el
		// expediente comercial

		if (DDEstadoOferta.CODIGO_ACEPTADA.equals(estadoOferta.getCodigo())) {
			oferta = anyadirCamposOferta(oferta, dto);
			expediente = doAceptaOferta(oferta, activo);
			esAcepta = expediente != null;
			oferta.setExpedienteComercial(expediente);
		}

		// si la oferta ha sido rechazada guarda los motivos de rechazo y
		// enviamos un email/notificacion.
		if (DDEstadoOferta.CODIGO_RECHAZADA.equals(estadoOferta.getCodigo())) {
			resultado = doRechazaOferta(dto, oferta);
		}

		if (!resultado) {
			resultado = ofertaApi.persistOferta(oferta);
			
		}
		if(!asincrono && esAcepta) {
			ActivoTramite tramite = doTramitacion(activo, expediente.getOferta(), expediente.getTrabajo().getId(), expediente);
			if(tramite != null) {
				return oferta;
			}
		}
		transactionManager.commit(transaction);
		return oferta;
	}

	private void validateSaveOferta(DtoOfertaActivo dto, Oferta oferta, DDEstadoOferta estadoOferta, Activo activo,
			Boolean esAlquiler, Boolean esAgrupacion, ActivoAgrupacion agrupacion) throws Exception {

		if (esAgrupacion) {
			validarTramitacionAgrupacion(dto, estadoOferta, oferta, esAlquiler, agrupacion);
		} else {
			validartramitacionActivo(dto, oferta, estadoOferta, activo, esAlquiler);
		}

	}

	public boolean faltanDatosCalculo(Oferta oferta, Activo activo) {
		Double vta = 0.0, pvb = 0.0, cco = 0.0, pvn = 0.0, vnc = 0.0, vr = 0.0;

		if (oferta != null && !Checks.esNulo(activo)) {
			if (!Checks.estaVacio(activo.getTasacion()) && !Checks
					.esNulo(activo.getTasacion().get(activo.getTasacion().size() - 1).getImporteTasacionFin())) {
				vta += activo.getTasacion().get(activo.getTasacion().size() - 1).getImporteTasacionFin();
			}
			pvb = oferta.getImporteOferta();

			// Cuando son ofertas agrupadas, las recorro
			if (!Checks.esNulo(oferta.getClaseOferta())
					&& DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE.equals(oferta.getClaseOferta().getCodigo())) {

				Oferta principal = ofertaManager.getOfertaPrincipalById(oferta.getId());
				List<OfertasAgrupadasLbk> ofertasAgrupadas = principal.getOfertasAgrupadas();

				List<Oferta> listaOfertas = new ArrayList<Oferta>();

				// Se añade la oferta principal
				listaOfertas.add(principal);
				
				//Se añaden los honorarios de la oferta principal
				ExpedienteComercial expedienteComercial = expedienteComercialDao.getExpedienteComercialByIdOferta(principal.getId());
				List<GastosExpediente> listaHonorarios = expedienteComercial.getHonorarios();

				for (GastosExpediente gex : listaHonorarios) {
					cco += gex.getImporteFinal() * gex.getImporteCalculo();
				}

				// Se añaden las dependientes
				for (OfertasAgrupadasLbk lisOf : ofertasAgrupadas) {
					Oferta ofrDependiente = lisOf.getOfertaDependiente();

					expedienteComercial = expedienteComercialDao.getExpedienteComercialByIdOferta(ofrDependiente.getId());

					if (!Checks.esNulo(expedienteComercial)
							&& DDEstadoOferta.CODIGO_ACEPTADA.equals(ofrDependiente.getEstadoOferta().getCodigo())) {
						listaHonorarios = expedienteComercial.getHonorarios();

						for (GastosExpediente gex : listaHonorarios) {
							cco += gex.getImporteFinal() * gex.getImporteCalculo();
						}

					}
				}

				// Si son ofertas individuales o principales se calculan ellas solas
			} else {
				cco = 0.1;
			}
			
			List<ActivoValoraciones> valoraciones = activo.getValoracion();

			for (ActivoValoraciones valoracion : valoraciones) {
				String codigoValoracion = valoracion.getTipoPrecio().getCodigo();
				if (DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT_LIBERBANK.equals(codigoValoracion)
						&& valoracion.getImporte() != null) {
					vnc += valoracion.getImporte();
				} else if (DDTipoPrecio.CODIGO_TPC_VALOR_RAZONABLE_LBK.equals(codigoValoracion)
						&& valoracion.getImporte() != null) {
					vr += valoracion.getImporte();
				}
			}

			pvn = pvb - cco;

			if (vta == 0.0 || pvb == 0.0 || cco == 0.0 || pvn == 0.0 || vnc == 0.0 || vr == 0.0) {
				return true;
			}
		}

		return false;
	}

	private void comprobarTramitarOferta(Oferta oferta, Activo activo, Boolean esAlquiler, String numActivo) {

		if (activo != null) {
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			List<ActivoValoraciones> precios = null;
			ActivoValoraciones precio = null;
			Filter filtroTof = null;
			Filter filtroMin = null;
			String msg;

			if (esAlquiler) {
				if (Checks.esNulo(activo.getTipoAlquiler())) {
					throw new JsonViewerException("El valor de Tipo de Alquiler del activo " + activo.getNumActivo()
							+ " no permite la realización de una oferta");
				}
				filtroTof = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo",
						DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA);
				filtroMin = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo",
						DDTipoPrecio.CODIGO_TPC_MIN_AUT_PROP_RENTA);
			} else {
				filtroTof = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo",
						DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA);
				filtroMin = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo",
						DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO);
			}

			precios = genericDao.getList(ActivoValoraciones.class, filtroActivo, filtroTof);
			
			if (precios != null && !precios.isEmpty())
				precio = precios.get(0);

			if (activo.getCartera() != null
					&& DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())) {
				Date fechaHoy = new Date();
				
				if (Checks.esNulo(precio) || (!Checks.esNulo(precio) && (Checks.esNulo(precio.getImporte())
						|| (!Checks.esNulo(precio.getFechaFin()) && precio.getFechaFin().before(fechaHoy))))) {
					if (numActivo != null) {
						msg = "Activo " + numActivo + " sin precio";
					} else {
						msg = "Activo sin precio";
					}
					throw new JsonViewerException(msg);
				}
			}

			// Comprobar que el precio de la oferta es inferior al mínimo del activo
			if (numActivo == null && !Checks.esNulo(activo.getSubcartera())
					&& DDSubcartera.CODIGO_YUBAI.equals(activo.getSubcartera().getCodigo())) {

				ActivoValoraciones precioMin = genericDao.get(ActivoValoraciones.class, filtroActivo, filtroMin);

				if (!Checks.esNulo(precioMin) && !Checks.esNulo(precioMin.getImporte())
						&& !Checks.esNulo(oferta.getImporteOferta())
						&& oferta.getImporteOferta() < precioMin.getImporte()) {
					throw new JsonViewerException(
							"No se puede tramitar una oferta porque el precio es inferior al mínimo");
				}
			} else {
				if (esAlquiler && Checks.esNulo(activo.getTipoAlquiler())) {
					throw new JsonViewerException("El valor de Tipo de Alquiler del activo " + numActivo
							+ " no permite la realización de una oferta");
				}
			}

		}
	}

	private ExpedienteComercial doAceptaOferta(Oferta oferta, Activo activo) throws Exception {
		List<Activo> listaActivos = new ArrayList<Activo>();
		for (ActivoOferta activoOferta : oferta.getActivosOferta()) {
			listaActivos.add(activoOferta.getPrimaryKey().getActivo());
		}
		DDSubtipoTrabajo subtipoTrabajo = (DDSubtipoTrabajo) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDSubtipoTrabajo.class, getSubtipoTrabajoByOferta(oferta));
		Trabajo trabajo = trabajoApi.create(subtipoTrabajo, listaActivos, null, false);
		ExpedienteComercial expediente = crearExpediente(oferta, trabajo, null, activo);
		return expediente;
	}

	private boolean doRechazaOferta(DtoOfertaActivo dto, Oferta oferta) {
		boolean resultado = false;
		if (!Checks.esNulo(dto.getMotivoRechazoCodigo())) {
			DDMotivoRechazoOferta motivoRechazoOferta = (DDMotivoRechazoOferta) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDMotivoRechazoOferta.class, dto.getMotivoRechazoCodigo());
			oferta.setMotivoRechazo(motivoRechazoOferta);
			Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			oferta.setUsuarioBaja(usu.getApellidoNombre());
		}

		if (!Checks.esNulo(oferta.getAgrupacion())) {
			ActivoAgrupacion agrupacion = oferta.getAgrupacion();

			List<Oferta> ofertasVivasAgrupacion = ofertaDao.getListOtrasOfertasVivasAgr(oferta.getId(),
					agrupacion.getId());

			if ((agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA)
					|| agrupacion.getTipoAgrupacion().getCodigo()
							.equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER))
					&& !Checks.esNulo(ofertasVivasAgrupacion) && ofertasVivasAgrupacion.isEmpty()) {
				agrupacion.setFechaBaja(new Date());
				activoAgrupacionApi.saveOrUpdate(agrupacion);
			}
		}
		
		if(oferta.getClaseOferta() != null && DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE.equals(oferta.getClaseOferta().getCodigo())) {
			ofertasAgrupadasLbkDao.suprimeOfertaDependiente(oferta.getId());
		}

		notificatorServiceSancionOfertaAceptacionYRechazo.notificatorFinSinTramite(oferta.getId());
		return resultado;
	}

	@Override
	public String getSubtipoTrabajoByOferta(Oferta oferta) {
		if (oferta.getTipoOferta().getCodigo().equals(DDTipoOferta.CODIGO_VENTA)) {
			return DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_VENTA;
		} else
			return DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_ALQUILER;
	}

	@Override
	public ExpedienteComercial crearExpediente(Oferta oferta, Trabajo trabajo, Oferta ofertaOriginalGencatEjerce,
			Activo activo) throws Exception {
		TransactionStatus transaction = null;
		ExpedienteComercial expedienteComercial = null;
		boolean resultado = false;

		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			expedienteComercial = crearExpedienteGuardado(oferta, trabajo, ofertaOriginalGencatEjerce, activo);

			if (DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())
					&& MAESTRO_ORIGEN_WCOM.equals(oferta.getOrigen())) {
				Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
				Thread maestroPersona = new Thread(new MaestroDePersonas(expedienteComercial.getId(), usu.getUsername(),
						oferta.getActivoPrincipal().getCartera().getDescripcion()));
				maestroPersona.start();
			}

			transactionManager.commit(transaction);

			resultado = true;

		} catch (Exception ex) {
			// logger.error("Error en tramitacionOfertasManager", ex);
			transactionManager.rollback(transaction);
			throw ex;
		}

		// cuando creamos el expediente, si procede, creamos el repositorio
		// en el gestor documental
		if (resultado) {
			if (!Checks.esNulo(appProperties
					.getProperty(GestorDocumentalExpedientesManager.URL_REST_CLIENT_GESTOR_DOCUMENTAL_EXPEDIENTES))) {
				Thread hiloReactivar = new Thread(new ContenedorExpComercial(
						genericAdapter.getUsuarioLogado().getUsername(), expedienteComercial));
				hiloReactivar.start();

			}

		}

		return expedienteComercial;
	}

	@Transactional(readOnly = false)
	private ExpedienteComercial crearExpedienteGuardado(Oferta oferta, Trabajo trabajo,
			Oferta ofertaOriginalGencatEjerce, Activo activo) throws Exception {

		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

		ExpedienteComercial nuevoExpediente = new ExpedienteComercial();

		if (!Checks.esNulo(oferta.getVisita())) {
			DDEstadosVisitaOferta estadoVisitaOferta = (DDEstadosVisitaOferta) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDEstadosVisitaOferta.class,
							DDEstadosVisitaOferta.ESTADO_VISITA_OFERTA_REALIZADA);
			oferta.setEstadoVisitaOferta(estadoVisitaOferta);
		} else {
			DDEstadosVisitaOferta estadoVisitaOferta = (DDEstadosVisitaOferta) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDEstadosVisitaOferta.class,
							DDEstadosVisitaOferta.ESTADO_VISITA_OFERTA_PENDIENTE);
			oferta.setEstadoVisitaOferta(estadoVisitaOferta);
		}

		nuevoExpediente.setOferta(oferta);
		DDEstadosExpedienteComercial estadoExpediente = (DDEstadosExpedienteComercial) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class,
						DDEstadosExpedienteComercial.EN_TRAMITACION);
		nuevoExpediente.setEstado(estadoExpediente);
		recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(nuevoExpediente.getOferta(), estadoExpediente);

		nuevoExpediente.setNumExpediente(activoDao.getNextNumExpedienteComercial());
		nuevoExpediente.setTrabajo(trabajo);
		
		nuevoExpediente = this.crearCondicionanteYTanteo(activo, oferta, nuevoExpediente);

		// Establecer la fecha de aceptación/alta a ahora.
		nuevoExpediente.setFechaAlta(new Date());
		
		crearCompradores(oferta, nuevoExpediente);

		nuevoExpediente.setTipoAlquiler(oferta.getActivoPrincipal().getTipoAlquiler());

		nuevoExpediente = genericDao.save(ExpedienteComercial.class, nuevoExpediente);

		transactionManager.commit(transaction);

		if(activo != null){
			Thread llamadaAsincrona = new Thread(new ConvivenciaAlaska(activo.getId(), new ModelMap(), usuarioManager.getUsuarioLogado().getUsername()));
			llamadaAsincrona.start();
		}

		return nuevoExpediente;
	}

	private CondicionanteExpediente calculoCondicionantes(Activo activo, Double importeOferta) {

		CondicionanteExpediente condicionante = new CondicionanteExpediente();
		condicionante.setAuditoria(Auditoria.getNewInstance());

		DDCartera cartera = activo.getCartera();
		DDSubcartera subcartera = activo.getSubcartera();

		if (cartera != null && importeOferta != null) {
			// HREOS-2799
			// Activos de Cajamar, debe haber reserva necesaria con un importe
			// fijo de 2% o 100 euros y plazo 5 dias
			// Activos de Cajamar, deben copiar las condiciones informadas del
			// activo en las condiciones al comprador
			if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(cartera.getCodigo())) {
				condicionante.setSolicitaReserva(1);
				Double importeReserva = importeOferta * (new Double(2) / 100);
				if (importeReserva > 100) {
					DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTipoCalculo.class, DDTipoCalculo.TIPO_CALCULO_PORCENTAJE);
					condicionante.setTipoCalculoReserva(tipoCalculo);
					condicionante.setPorcentajeReserva(new Double(2));
					condicionante.setImporteReserva(importeReserva);
				} else {
					DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTipoCalculo.class, DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO);
					condicionante.setTipoCalculoReserva(tipoCalculo);
					condicionante.setImporteReserva(new Double(100));
				}
				condicionante.setPlazoFirmaReserva(5);
			}
			// HREOS-4450
			// Activos de Galeon, debe haber reserva necesaria con un importe
			// fijo del 5%
			else if (DDCartera.CODIGO_CARTERA_GALEON.equals(cartera.getCodigo())
					|| (DDCartera.CODIGO_CARTERA_EGEO.equals(cartera.getCodigo())
							&& DDSubcartera.CODIGO_ZEUS.equals(subcartera.getCodigo()))) {
				condicionante.setSolicitaReserva(1);
				DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoCalculo.class, DDTipoCalculo.TIPO_CALCULO_PORCENTAJE);
				condicionante.setTipoCalculoReserva(tipoCalculo);
				condicionante.setPorcentajeReserva(new Double(5));
				condicionante.setImporteReserva(importeOferta * (new Double(5) / 100));
			}

			// HREOS-5392
			// Activos de Cerberus->Agora(Financiero, Inmobiliario) debe haber reserva por
			// porcentaje del 10%
			else if (subcartera != null && DDCartera.CODIGO_CARTERA_CERBERUS.equals(cartera.getCodigo())
					&& ((DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(subcartera.getCodigo()))
							|| (DDSubcartera.CODIGO_AGORA_FINANCIERO.equals(subcartera.getCodigo()))
							|| DDSubcartera.CODIGO_ZEUS_INMOBILIARIO.equals(subcartera.getCodigo()))) {

				condicionante.setSolicitaReserva(1);
				DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoCalculo.class, DDTipoCalculo.TIPO_CALCULO_PORCENTAJE);
				condicionante.setTipoCalculoReserva(tipoCalculo);
				condicionante.setPorcentajeReserva(new Double(10));
				condicionante.setImporteReserva(importeOferta * (new Double(10) / 100));
			} else if (subcartera != null && DDCartera.CODIGO_CARTERA_CERBERUS.equals(cartera.getCodigo())
					&& (DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(subcartera.getCodigo()))) {
				if (importeOferta >= 6000) {
					condicionante.setSolicitaReserva(1);
					DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTipoCalculo.class, DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO);
					condicionante.setTipoCalculoReserva(tipoCalculo);
					if (importeOferta <= 50000) {
						condicionante.setImporteReserva((new Double(1000)));
					} else {
						condicionante.setImporteReserva((new Double(3000)));
					}
				} else {
					condicionante.setSolicitaReserva(0);
				}
			}
		}

		if (activo.getSituacionPosesoria() != null && activo.getSituacionPosesoria().getFechaTomaPosesion() != null) {
			condicionante.setPosesionInicial(1);
		} else {
			condicionante.setPosesionInicial(0);
		}

		if (activo.getTitulo() != null && activo.getTitulo().getEstado() != null) {
			condicionante.setEstadoTitulo(activo.getTitulo().getEstado());
		}

		if (activo.getSituacionPosesoria() != null) {
			if (activo.getSituacionPosesoria().getOcupado() != null
					&& activo.getSituacionPosesoria().getOcupado().equals(Integer.valueOf(0))) {
				DDSituacionesPosesoria situacionPosesoriaLibre = (DDSituacionesPosesoria) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSituacionesPosesoria.class,
								DDSituacionesPosesoria.SITUACION_POSESORIA_LIBRE);
				condicionante.setSituacionPosesoria(situacionPosesoriaLibre);
			} else if (activo.getSituacionPosesoria().getOcupado() != null
					&& activo.getSituacionPosesoria().getOcupado().equals(Integer.valueOf(1))
					&& !Checks.esNulo(activo.getSituacionPosesoria().getConTitulo()) && activo.getSituacionPosesoria()
							.getConTitulo().getCodigo().equals(DDTipoTituloActivoTPA.tipoTituloSi)) {
				DDSituacionesPosesoria situacionPosesoriaOcupadoTitulo = (DDSituacionesPosesoria) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSituacionesPosesoria.class,
								DDSituacionesPosesoria.SITUACION_POSESORIA_OCUPADO_CON_TITULO);
				condicionante.setSituacionPosesoria(situacionPosesoriaOcupadoTitulo);
			} else if (activo.getSituacionPosesoria().getOcupado() != null
					&& activo.getSituacionPosesoria().getOcupado().equals(Integer.valueOf(1))
					&& activo.getSituacionPosesoria().getConTitulo() != null
					&& (activo.getSituacionPosesoria().getConTitulo().getCodigo()
							.equals(DDTipoTituloActivoTPA.tipoTituloNo)
							|| activo.getSituacionPosesoria().getConTitulo().getCodigo()
									.equals(DDTipoTituloActivoTPA.tipoTituloNoConIndicios))) {
				DDSituacionesPosesoria situacionPosesoriaOcupadoSinTitulo = (DDSituacionesPosesoria) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSituacionesPosesoria.class,
								DDSituacionesPosesoria.SITUACION_POSESORIA_OCUPADO_SIN_TITULO);
				condicionante.setSituacionPosesoria(situacionPosesoriaOcupadoSinTitulo);
			}
		}

		return condicionante;
	}

	@Transactional
	public ExpedienteComercial crearCondicionanteYTanteo(Activo activo, Oferta oferta,
			ExpedienteComercial expedienteComercial) {
		boolean noCumple = false;
		CondicionanteExpediente condicionanteExpediente = expedienteComercial.getCondicionante();
		List<ActivoOferta> activoOfertaList = oferta.getActivosOferta();
		List<TanteoActivoExpediente> tanteosExpediente = new ArrayList<TanteoActivoExpediente>();

		if (!Checks.esNulo(activo)) {
			if (condicionanteExpediente == null) {
				condicionanteExpediente = calculoCondicionantes(activo, oferta.getImporteOferta());
				condicionanteExpediente.setExpediente(expedienteComercial);
			}

			for (ActivoOferta activoOferta : activoOfertaList) {
				noCumple = false;
				for (CondicionTanteoApi condicion : condiciones) {
					if (!condicion.checkCondicion(activo))
						noCumple = true;
				}
				if (!noCumple) {
					TanteoActivoExpediente tanteoActivo = new TanteoActivoExpediente();
					tanteoActivo.setActivo(activoOferta.getPrimaryKey().getActivo());
					tanteoActivo.setExpediente(expedienteComercial);
					tanteoActivo.setAuditoria(Auditoria.getNewInstance());
					DDAdministracion administracion = genericDao.get(DDAdministracion.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", DDAdministracion.CODIGO_CONSEJERIA));
					tanteoActivo.setAdminitracion(administracion);
					condicionanteExpediente.setSujetoTanteoRetracto(1);
					tanteosExpediente.add(tanteoActivo);
				}
			}

		}

		expedienteComercial.setTanteoActivoExpediente(tanteosExpediente);
		expedienteComercial.setCondicionante(condicionanteExpediente);
		
		return expedienteComercial;
	}

	@Transactional(readOnly = false)
	public ExpedienteComercial crearExpedienteReserva(ExpedienteComercial expedienteComercial) {
		// HREOS-2799
		// Activos de Cajamar, debe tener en Reserva - tipo de Arras por
		// defecto: Confirmatorias
		Oferta oferta = expedienteComercial.getOferta();
		DDTiposArras tipoArras = null;
		if (!Checks.esNulo(oferta.getActivoPrincipal()) && !Checks.esNulo(oferta.getActivoPrincipal().getCartera())) {
			if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
				tipoArras = (DDTiposArras) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposArras.class,
						DDTiposArras.CONFIRMATORIAS);
			}
			if (DDCartera.CODIGO_CARTERA_GALEON.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
					|| (DDCartera.CODIGO_CARTERA_EGEO.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
							&& DDSubcartera.CODIGO_ZEUS
									.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo()))) {
				tipoArras = (DDTiposArras) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposArras.class,
						DDTiposArras.PENITENCIALES);
			}

			if ((DDCartera.CODIGO_CARTERA_CERBERUS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
					&& DDSubcartera.CODIGO_APPLE_INMOBILIARIO
							.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo()))
					&& expedienteComercial.getCondicionante().getSolicitaReserva() == 1)
				tipoArras = (DDTiposArras) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposArras.class,
						DDTiposArras.CONFIRMATORIAS);
			if (tipoArras != null) {
				if (Checks.esNulo(expedienteComercial.getReserva())) {
					Reserva reservaExpediente = expedienteComercialApi.createReservaExpediente(expedienteComercial);
					if (!Checks.esNulo(reservaExpediente)) {
						reservaExpediente.setTipoArras(tipoArras);
						genericDao.save(Reserva.class, reservaExpediente);
					}

				} else {
					expedienteComercial.getReserva().setTipoArras(tipoArras);
				}
			}
		}

		return expedienteComercial;
	}

	@Override
	@Transactional
	public List<GastosExpediente> crearGastosExpediente(Long idOferta, ExpedienteComercial nuevoExpediente) throws IllegalAccessException, InvocationTargetException {
		return this.crearGastosExpediente(ofertaApi.getOfertaById(idOferta), nuevoExpediente);
	}

	@Override
	@Transactional
	public List<GastosExpediente> crearGastosExpediente(Oferta oferta, ExpedienteComercial nuevoExpediente) throws IllegalAccessException, InvocationTargetException {
		List<GastosExpediente> gastosExpediente = new ArrayList<GastosExpediente>();
		
		Activo activo = oferta.getActivoPrincipal();
			
		gastosExpediente = expedienteComercialApi.creaGastoExpediente(nuevoExpediente, oferta, activo);

		return gastosExpediente;
	}

	@Transactional
	public ExpedienteComercial crearCompradores(Long idOferta, ExpedienteComercial nuevoExpediente) {
		return this.crearCompradores(ofertaApi.getOfertaById(idOferta), nuevoExpediente);
	}

	@Transactional
	public ExpedienteComercial crearCompradores(Oferta oferta, ExpedienteComercial nuevoExpediente) {
		ClienteComercial cliente = oferta.getCliente();

		if (!Checks.esNulo(cliente)) {
			// Busca un comprador con el mismo dni que el cliente de la oferta
			Comprador compradorBusqueda = null;
			if (!Checks.esNulo(cliente.getDocumento())) {
				Filter filtroComprador = genericDao.createFilter(FilterType.EQUALS, "documento",
						cliente.getDocumento());
				compradorBusqueda = genericDao.get(Comprador.class, filtroComprador);
			}
			List<CompradorExpediente> listaCompradoresExpediente = new ArrayList<CompradorExpediente>();
			CompradorExpediente compradorExpedienteNuevo = new CompradorExpediente();
			List<TitularesAdicionalesOferta> listaTitularesAdicionalesSinRepetirDocumento = new ArrayList<TitularesAdicionalesOferta>();

			Double parteCompra = 0.00;
			Double parteCompraAdicionales = 0.00;
			Double totalParteCompraAdicional = 0.00;
			Double parteCompraPrincipal = 100.00;
			/*
			 * HREOS-3779 Problema al crear las relaciones entre comprador-expediente Desde
			 * webcom mandan clientes comerciales y titulares adiciones con el mismo
			 * documento para la misma oferta. Esto hace que en el listado de compradores se
			 * creen varios con la misma relacion comprador-expediente. Se ha añadido
			 * comprobacion en el metodo que crea la oferta desde webcom (webservice) pero
			 * hay muchos que ya estan creado, para estos creamos esta comprobacion. Quita
			 * del listado de titulares adicionales los que tengan el mismo documento que el
			 * cliente de la oferta
			 */
			if (!Checks.estaVacio(oferta.getTitularesAdicionales())) {
				for (TitularesAdicionalesOferta titularAdicional : oferta.getTitularesAdicionales()) {
					if (!titularAdicional.getDocumento().equals(cliente.getDocumento())) {
						listaTitularesAdicionalesSinRepetirDocumento.add(titularAdicional);
					}
				}
			}

			if (!Checks.estaVacio(listaTitularesAdicionalesSinRepetirDocumento)) {
				parteCompra = 100.00 / (listaTitularesAdicionalesSinRepetirDocumento.size() + 1);
				parteCompraAdicionales = (int) (parteCompra * 100.00) / 100.00;
				totalParteCompraAdicional = parteCompraAdicionales
						* listaTitularesAdicionalesSinRepetirDocumento.size();
				parteCompraPrincipal = 100 - totalParteCompraAdicional;
			}

			if (Checks.esNulo(compradorBusqueda)) {
				compradorBusqueda = new Comprador();
				compradorBusqueda.setClienteComercial(cliente);
				compradorBusqueda.setDocumento(cliente.getDocumento());
			}
			if (!Checks.esNulo(cliente.getTipoPersona())
					&& DDTipoPersona.CODIGO_TIPO_PERSONA_JURIDICA.equals(cliente.getTipoPersona().getCodigo())) {
				compradorBusqueda.setNombre(cliente.getRazonSocial());
				compradorExpedienteNuevo.setNombreRepresentante(cliente.getNombre());
				compradorExpedienteNuevo.setApellidosRepresentante(cliente.getApellidos());
				compradorExpedienteNuevo.setTipoDocumentoRepresentante(cliente.getTipoDocumentoRepresentante());
				compradorExpedienteNuevo.setDocumentoRepresentante(cliente.getDocumentoRepresentante());

			} else {
				compradorBusqueda.setNombre(cliente.getNombre());
				compradorBusqueda.setApellidos(cliente.getApellidos());
			}

			if (!Checks.esNulo(cliente.getTipoDocumento())) {
				compradorBusqueda.setTipoDocumento(cliente.getTipoDocumento());
			}
			if (!Checks.esNulo(cliente.getTelefono1())) {
				compradorBusqueda.setTelefono1(cliente.getTelefono1());
			}
			if (!Checks.esNulo(cliente.getTelefono2())) {
				compradorBusqueda.setTelefono2(cliente.getTelefono2());
			}
			if (!Checks.esNulo(cliente.getEmail())) {
				compradorBusqueda.setEmail(cliente.getEmail());
			}

			String dir = "";
			if (!Checks.esNulo(cliente.getTipoVia()))
				dir = cliente.getTipoVia().getCodigo() + " ";
			if (!Checks.esNulo(cliente.getDireccion()))
				dir = dir.concat(cliente.getDireccion());
			if (!Checks.esNulo(cliente.getNumeroCalle()))
				dir = dir.concat(" " + cliente.getNumeroCalle());
			if (!Checks.esNulo(cliente.getPuerta()))
				dir = dir.concat(", pta " + cliente.getPuerta());
			if (!Checks.esNulo(cliente.getPlanta()))
				dir = dir.concat(", plta " + cliente.getPlanta());
			if (!Checks.esNulo(cliente.getEscalera()))
				dir = dir.concat(", esc " + cliente.getEscalera());
			compradorBusqueda.setDireccion(dir);

			if (!Checks.esNulo(cliente.getMunicipio())) {
				compradorBusqueda.setLocalidad(cliente.getMunicipio());
			}
			if (!Checks.esNulo(cliente.getProvincia())) {
				compradorBusqueda.setProvincia(cliente.getProvincia());
			}

			if (!Checks.esNulo(cliente.getCodigoPostal())) {
				compradorBusqueda.setCodigoPostal(cliente.getCodigoPostal());
			}

			if (!Checks.esNulo(cliente.getTipoPersona())) {
				compradorBusqueda.setTipoPersona(cliente.getTipoPersona());
			}

			// CHECKS GDPR
			if (!Checks.esNulo(cliente.getCesionDatos())) {
				compradorBusqueda.setCesionDatos(cliente.getCesionDatos());
			}
			if (!Checks.esNulo(cliente.getComunicacionTerceros())) {
				compradorBusqueda.setComunicacionTerceros(cliente.getComunicacionTerceros());
			}
			if (!Checks.esNulo(cliente.getTransferenciasInternacionales())) {
				compradorBusqueda.setTransferenciasInternacionales(cliente.getTransferenciasInternacionales());
			}
			if (!Checks.esNulo(cliente.getIdPersonaHaya())) {
				compradorBusqueda.setIdPersonaHaya(new Long(cliente.getIdPersonaHaya()));
			}
			
			if (!Checks.esNulo(compradorBusqueda.getIdCompradorUrsus())) {
				compradorBusqueda.setIdCompradorUrsus(null);
			}
			
			if (!Checks.esNulo(compradorBusqueda.getIdCompradorUrsusBh())) {
				compradorBusqueda.setIdCompradorUrsusBh(null);
			}

			CompradorExpediente.CompradorExpedientePk pk = new CompradorExpediente.CompradorExpedientePk();
			pk.setComprador(compradorBusqueda);
			pk.setExpediente(nuevoExpediente);
			compradorExpedienteNuevo.setPrimaryKey(pk);
			compradorExpedienteNuevo.setTitularReserva(0);
			compradorExpedienteNuevo.setTitularContratacion(1);
			compradorExpedienteNuevo.setPorcionCompra(parteCompraPrincipal);
			//compradorExpedienteNuevo.setBorrado(false);
			compradorExpedienteNuevo.setEstadoCivil(cliente.getEstadoCivil());
			compradorExpedienteNuevo.setRegimenMatrimonial(cliente.getRegimenMatrimonial());
			compradorExpedienteNuevo.setTipoDocumentoConyuge(cliente.getTipoDocumentoConyuge());
			compradorExpedienteNuevo.setDocumentoConyuge(cliente.getDocumentoConyuge());
			compradorExpedienteNuevo.setPais(cliente.getPais());
			compradorExpedienteNuevo.setDireccionRepresentante(cliente.getDireccionRepresentante());
			compradorExpedienteNuevo.setProvinciaRepresentante(cliente.getProvinciaRepresentante());
			compradorExpedienteNuevo.setLocalidadRepresentante(cliente.getMunicipioRepresentante());
			compradorExpedienteNuevo.setPaisRte(cliente.getPaisRepresentante());
			compradorExpedienteNuevo.setCodigoPostalRepresentante(cliente.getCodigoPostalRepresentante());

			List<ClienteGDPR> clienteGDPR = genericDao.getList(ClienteGDPR.class,
					genericDao.createFilter(FilterType.EQUALS, "numDocumento", cliente.getDocumento()),
					genericDao.createFilter(FilterType.EQUALS, "tipoDocumento.codigo",
							cliente.getTipoDocumento().getCodigo()));

			if (clienteGDPR != null && !clienteGDPR.isEmpty()) {
				compradorExpedienteNuevo.setDocumentoAdjunto(clienteGDPR.get(0).getAdjuntoComprador());
				compradorBusqueda.setAdjunto(clienteGDPR.get(0).getAdjuntoComprador());
			}

			genericDao.save(Comprador.class, compradorBusqueda);
			listaCompradoresExpediente.add(compradorExpedienteNuevo);

			// HREOS - 4937 - Historificando
			ClienteCompradorGDPR clienteCompradorGDPR = new ClienteCompradorGDPR();
			clienteCompradorGDPR.setTipoDocumento(compradorBusqueda.getTipoDocumento());
			clienteCompradorGDPR.setNumDocumento(compradorBusqueda.getDocumento());
			if (!Checks.esNulo(clienteGDPR) && !clienteGDPR.isEmpty()) {
				if (!Checks.esNulo(clienteGDPR.get(0).getCesionDatos())) {
					clienteCompradorGDPR.setCesionDatos(clienteGDPR.get(0).getCesionDatos());
				}
				if (!Checks.esNulo(clienteGDPR.get(0).getComunicacionTerceros())) {
					clienteCompradorGDPR.setComunicacionTerceros(clienteGDPR.get(0).getComunicacionTerceros());
				}
				if (!Checks.esNulo(clienteGDPR.get(0).getTransferenciasInternacionales())) {
					clienteCompradorGDPR
							.setTransferenciasInternacionales(clienteGDPR.get(0).getTransferenciasInternacionales());
				}
				if (!Checks.esNulo(clienteGDPR.get(0).getAdjuntoComprador())) {
					clienteCompradorGDPR.setAdjuntoComprador(clienteGDPR.get(0).getAdjuntoComprador());
				}
			}
			genericDao.save(ClienteCompradorGDPR.class, clienteCompradorGDPR);

			// Se recorre todos los titulares adicionales, estos tambien se
			// crean como compradores y su relacion Comprador-Expediente con la
			// diferencia de que los campos
			// TitularReserva y TitularContratacion estan al contrario. Por
			// decirlo de alguna forma son "Compradores secundarios"
			for (TitularesAdicionalesOferta titularAdicional : listaTitularesAdicionalesSinRepetirDocumento) {

				if (!Checks.esNulo(titularAdicional.getDocumento())) {
					Filter filtroCompradorAdicional = genericDao.createFilter(FilterType.EQUALS, "documento",
							titularAdicional.getDocumento());
					Comprador compradorBusquedaAdicional = genericDao.get(Comprador.class, filtroCompradorAdicional);
					compradorExpedienteNuevo = new CompradorExpediente();

					if (Checks.esNulo(compradorBusquedaAdicional)) {
						compradorBusquedaAdicional = new Comprador();
						compradorBusquedaAdicional.setDocumento(titularAdicional.getDocumento());
					}

					if (!Checks.esNulo(titularAdicional.getTipoPersona()) && DDTipoPersona.CODIGO_TIPO_PERSONA_JURIDICA
							.equals(titularAdicional.getTipoPersona().getCodigo())) {
						compradorBusquedaAdicional.setNombre(titularAdicional.getRazonSocial());
						compradorExpedienteNuevo.setNombreRepresentante(titularAdicional.getNombre());
						compradorExpedienteNuevo.setApellidosRepresentante(titularAdicional.getApellidos());
						compradorExpedienteNuevo
								.setTipoDocumentoRepresentante(titularAdicional.getTipoDocumentoRepresentante());
						compradorExpedienteNuevo
								.setDocumentoRepresentante(titularAdicional.getDocumentoRepresentante());

					} else {
						compradorBusquedaAdicional.setNombre(titularAdicional.getNombre());
						compradorBusquedaAdicional.setApellidos(titularAdicional.getApellidos());
					}

					if (!Checks.esNulo(titularAdicional.getTipoDocumento())) {
						compradorBusquedaAdicional.setTipoDocumento(titularAdicional.getTipoDocumento());
					}
					if (!Checks.esNulo(titularAdicional.getTelefono1())) {
						compradorBusquedaAdicional.setTelefono1(titularAdicional.getTelefono1());
					}
					if (!Checks.esNulo(titularAdicional.getTelefono2())) {
						compradorBusquedaAdicional.setTelefono2(titularAdicional.getTelefono2());
					}
					if (!Checks.esNulo(titularAdicional.getEmail())) {
						compradorBusquedaAdicional.setEmail(titularAdicional.getEmail());
					}
					if (!Checks.esNulo(titularAdicional.getDireccion())) {
						compradorBusquedaAdicional.setDireccion(titularAdicional.getDireccion());
					}

					if (!Checks.esNulo(titularAdicional.getLocalidad())) {
						compradorBusquedaAdicional.setLocalidad(titularAdicional.getLocalidad());
					}
					if (!Checks.esNulo(titularAdicional.getProvincia())) {
						compradorBusquedaAdicional.setProvincia(titularAdicional.getProvincia());
					}

					if (!Checks.esNulo(titularAdicional.getCodPostal())) {
						compradorBusquedaAdicional.setCodigoPostal(titularAdicional.getCodPostal());
					}

					if (!Checks.esNulo(titularAdicional.getTipoPersona())) {
						compradorBusquedaAdicional.setTipoPersona(titularAdicional.getTipoPersona());
					}
					
					if (!Checks.esNulo(compradorBusquedaAdicional.getIdCompradorUrsus())) {
						compradorBusquedaAdicional.setIdCompradorUrsus(null);
					}
					
					if (!Checks.esNulo(compradorBusquedaAdicional.getIdCompradorUrsusBh())) {
						compradorBusquedaAdicional.setIdCompradorUrsusBh(null);
					}

					// AGREGAR CHECKS DE TITULARES ADICIONALES
					if (!Checks.esNulo(titularAdicional)) {
						if (!Checks.esNulo(titularAdicional.getRechazarCesionDatosPropietario())) {
							compradorBusquedaAdicional
									.setCesionDatos(!titularAdicional.getRechazarCesionDatosPropietario());
						}
						if (!Checks.esNulo(titularAdicional.getRechazarCesionDatosProveedores())) {
							compradorBusquedaAdicional
									.setComunicacionTerceros(!titularAdicional.getRechazarCesionDatosProveedores());
						}
						if (!Checks.esNulo(titularAdicional.getRechazarCesionDatosPublicidad())) {
							compradorBusquedaAdicional.setTransferenciasInternacionales(
									!titularAdicional.getRechazarCesionDatosPublicidad());
						}
					}
					genericDao.save(Comprador.class, compradorBusquedaAdicional);

					CompradorExpediente compradorExpedienteAdicionalNuevo = new CompradorExpediente();
					pk = new CompradorExpedientePk();

					pk.setComprador(compradorBusquedaAdicional);
					pk.setExpediente(nuevoExpediente);
					compradorExpedienteAdicionalNuevo.setPrimaryKey(pk);
					//compradorExpedienteAdicionalNuevo.getAuditoria().setBorrado(false);
					compradorExpedienteAdicionalNuevo.setTitularReserva(1);
					compradorExpedienteAdicionalNuevo.setTitularContratacion(0);
					compradorExpedienteAdicionalNuevo.setPorcionCompra(parteCompraAdicionales);
					compradorExpedienteAdicionalNuevo.setEstadoCivil(titularAdicional.getEstadoCivil());
					compradorExpedienteAdicionalNuevo.setRegimenMatrimonial(titularAdicional.getRegimenMatrimonial());
					compradorExpedienteAdicionalNuevo
							.setTipoDocumentoConyuge(titularAdicional.getTipoDocumentoConyuge());
					compradorExpedienteAdicionalNuevo.setDocumentoConyuge(titularAdicional.getDocumentoConyuge());
					compradorExpedienteAdicionalNuevo.setPais(titularAdicional.getPais());
					compradorExpedienteAdicionalNuevo
							.setDireccionRepresentante(titularAdicional.getDireccionRepresentante());
					compradorExpedienteAdicionalNuevo
							.setProvinciaRepresentante(titularAdicional.getProvinciaRepresentante());
					compradorExpedienteAdicionalNuevo
							.setLocalidadRepresentante(titularAdicional.getMunicipioRepresentante());
					compradorExpedienteAdicionalNuevo.setPaisRte(titularAdicional.getPaisRepresentante());
					compradorExpedienteAdicionalNuevo
							.setCodigoPostalRepresentante(titularAdicional.getCodPostalRepresentante());

					clienteGDPR = genericDao.getList(ClienteGDPR.class,
							genericDao.createFilter(FilterType.EQUALS, "numDocumento", titularAdicional.getDocumento()),
							genericDao.createFilter(FilterType.EQUALS, "tipoDocumento.codigo",
									titularAdicional.getTipoDocumento().getCodigo()));

					if (!Checks.esNulo(clienteGDPR) && !clienteGDPR.isEmpty()) {
						compradorExpedienteNuevo.setDocumentoAdjunto(clienteGDPR.get(0).getAdjuntoComprador());
					}

					listaCompradoresExpediente.add(compradorExpedienteAdicionalNuevo);

					// HREOS - 4937 - Historificando
					clienteCompradorGDPR = new ClienteCompradorGDPR();
					clienteCompradorGDPR.setTipoDocumento(compradorBusquedaAdicional.getTipoDocumento());
					clienteCompradorGDPR.setNumDocumento(compradorBusquedaAdicional.getDocumento());
					if (!Checks.esNulo(clienteGDPR) && !clienteGDPR.isEmpty()) {
						if (!Checks.esNulo(clienteGDPR.get(0).getCesionDatos())) {
							clienteCompradorGDPR.setCesionDatos(clienteGDPR.get(0).getCesionDatos());
						}
						if (!Checks.esNulo(clienteGDPR.get(0).getComunicacionTerceros())) {
							clienteCompradorGDPR.setComunicacionTerceros(clienteGDPR.get(0).getComunicacionTerceros());
						}
						if (!Checks.esNulo(clienteGDPR.get(0).getTransferenciasInternacionales())) {
							clienteCompradorGDPR.setTransferenciasInternacionales(
									clienteGDPR.get(0).getTransferenciasInternacionales());
						}
						if (!Checks.esNulo(clienteGDPR.get(0).getAdjuntoComprador())) {
							clienteCompradorGDPR.setAdjuntoComprador(clienteGDPR.get(0).getAdjuntoComprador());
						}
					}
					genericDao.save(ClienteCompradorGDPR.class, clienteCompradorGDPR);
				}
			}

			// Una vez creadas las relaciones Comprador-Expediente se añaden al
			// nuevo expediente
			nuevoExpediente.setCompradores(listaCompradoresExpediente);

			return nuevoExpediente;
		}

		return nuevoExpediente;
	}

	@SuppressWarnings("static-access")
	@Transactional
	public void asignarGestorYSupervisorFormalizacionToExpediente(ExpedienteComercial expediente) {
		GestorEntidadDto dto = new GestorEntidadDto();
		dto.setIdEntidad(expediente.getId());
		dto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);

		Oferta oferta = expediente.getOferta();
		Usuario usuarioGestorFormalizacion = null;
		Usuario usuarioGestoriaFormalizacion = null;
		Usuario usuarioGestorComercial = null;
		Usuario usuarioSupervisorComercial = null;
		Usuario usuarioSupervisorFormalizacion = null;
		Usuario usuarioGestorReserva = null;
		Usuario usuarioSupervisorReserva = null;
		Usuario usuarioGestorMinuta = null;
		Usuario usuarioSupervisorMinuta = null;
		Usuario usuarioCierreVenta = null;
		Usuario usuarioGestorController = null;
		ActivoAgrupacion agrupacion = null;
		Activo activo = null;

		if (!Checks.esNulo(oferta)) {
			/*
			 * Antes se diferenciaba entre agrupacion lote comercial y lote restringido
			 * Comercial: Asignaba los gestores que hubiese en la ficha del activo
			 * Restringida: Llama al procedimiento de balanceo (como si fuera un activo
			 * individual Ahora se quieren todos iguales, la unica diferencia es que el lote
			 * comercial no tiene activo principal y el resto si (restringida y activo
			 * unico)
			 */
			agrupacion = oferta.getAgrupacion();
			if (!Checks.esNulo(agrupacion)) {
				if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
					if (!Checks.estaVacio(oferta.getActivosOferta())) {
						activo = oferta.getActivosOferta().get(0).getPrimaryKey().getActivo();
					}

				} else {
					activo = oferta.getActivoPrincipal();
				}

			} else {
				activo = oferta.getActivoPrincipal();
			}

			if (!Checks.esNulo(activo)) {
				Long idUsuarioGestorFormalizacion = null;
				if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_THIRD_PARTY)) {
					Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", "GFORM");
					EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, f1);
					Filter f2 = genericDao.createFilter(FilterType.EQUALS, "activo", activo);
					Filter f3 = genericDao.createFilter(FilterType.EQUALS, "tipoGestor", tipoGestor);
					GestorActivo nuevoGestorF = genericDao.get(GestorActivo.class, f2, f3);
					if (!Checks.esNulo(nuevoGestorF) && !Checks.esNulo(nuevoGestorF.getUsuario())) {
						idUsuarioGestorFormalizacion = nuevoGestorF.getUsuario().getId();// flag
					}
					f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", "GCOM");
					tipoGestor = genericDao.get(EXTDDTipoGestor.class, f1);
					f3 = genericDao.createFilter(FilterType.EQUALS, "tipoGestor", tipoGestor);
					GestorActivo nuevoGestorC = genericDao.get(GestorActivo.class, f2, f3);
					if (!Checks.esNulo(nuevoGestorC) && !Checks.esNulo(nuevoGestorC.getUsuario())) {
						usuarioGestorComercial = nuevoGestorC.getUsuario();
					}

				} else if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)
						|| activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_LIBERBANK) || 
						(activo.getSubcartera().getCodigo().equals(DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB)
						|| activo.getSubcartera().getCodigo().equals(DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB)
						|| activo.getSubcartera().getCodigo().equals(DDSubcartera.CODIGO_APPLE_INMOBILIARIO)) 
						|| DDCartera.CODIGO_CARTERA_BBVA.equals(activo.getCartera().getCodigo())
						) {
					idUsuarioGestorFormalizacion = gestorExpedienteComercialDao
							.getUsuarioGestorFormalizacion(activo.getId(),oferta.getId());
				} else {
					idUsuarioGestorFormalizacion = gestorExpedienteComercialDao
							.getUsuarioGestorFormalizacionBasico(activo.getId());
				}

				if (!Checks.esNulo(idUsuarioGestorFormalizacion))
					usuarioGestorFormalizacion = genericDao.get(Usuario.class,
							genericDao.createFilter(FilterType.EQUALS, "id", idUsuarioGestorFormalizacion));

				Long idUsuarioGestoriaFormalizacion = gestorExpedienteComercialDao
						.getUsuarioGestoriaFormalizacion(activo.getId());
				if (!Checks.esNulo(idUsuarioGestoriaFormalizacion))
					usuarioGestoriaFormalizacion = genericDao.get(Usuario.class,
							genericDao.createFilter(FilterType.EQUALS, "id", idUsuarioGestoriaFormalizacion));

				if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)) {
					String usernameGestorReservaGrupo = gestorExpedienteComercialDao.getUsuarioGestor(activo.getId(),
							GestorExpedienteComercialApi.CODIGO_GESTOR_RESERVA_CAJAMAR);
					String usernameSupervisorReservaGrupo = gestorExpedienteComercialDao.getUsuarioGestor(
							activo.getId(), GestorExpedienteComercialApi.CODIGO_SUPERVISOR_RESERVA_CAJAMAR);
					String usernameGestorMinutaGrupo = gestorExpedienteComercialDao.getUsuarioGestor(activo.getId(),
							GestorExpedienteComercialApi.CODIGO_GESTOR_MINUTA_CAJAMAR);
					String usernameSupervisorMinutaGrupo = gestorExpedienteComercialDao.getUsuarioGestor(activo.getId(),
							GestorExpedienteComercialApi.CODIGO_SUPERVISOR_MINUTA_CAJAMAR);
					String usernameSupervisorFormalizacion = gestorExpedienteComercialDao.getUsuarioGestor(
							activo.getId(), GestorExpedienteComercialApi.CODIGO_SUPERVISOR_FORMALIZACION);

					if (!Checks.esNulo(usernameGestorReservaGrupo)) {
						usuarioGestorReserva = genericDao.get(Usuario.class,
								genericDao.createFilter(FilterType.EQUALS, "username", usernameGestorReservaGrupo));
					}

					if (!Checks.esNulo(usernameSupervisorReservaGrupo)) {
						usuarioSupervisorReserva = genericDao.get(Usuario.class,
								genericDao.createFilter(FilterType.EQUALS, "username", usernameSupervisorReservaGrupo));
					}

					if (!Checks.esNulo(usernameGestorMinutaGrupo)) {
						usuarioGestorMinuta = genericDao.get(Usuario.class,
								genericDao.createFilter(FilterType.EQUALS, "username", usernameGestorMinutaGrupo));
					}

					if (!Checks.esNulo(usernameSupervisorMinutaGrupo)) {
						usuarioSupervisorMinuta = genericDao.get(Usuario.class,
								genericDao.createFilter(FilterType.EQUALS, "username", usernameSupervisorMinutaGrupo));
					}

					if (!Checks.esNulo(usernameSupervisorFormalizacion)) {
						usuarioSupervisorFormalizacion = genericDao.get(Usuario.class, genericDao
								.createFilter(FilterType.EQUALS, "username", usernameSupervisorFormalizacion));
					}
					
				}
				
				if (DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo()) 
						&& (DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(activo.getSubcartera().getCodigo())
								|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo()))) {
					String usernameCierreVenta = gestorExpedienteComercialDao.getUsuarioGestor(
							activo.getId(), GestorExpedienteComercialApi.CODIGO_GESTOR_CIERRE_VENTA);
					if (!Checks.esNulo(usernameCierreVenta)) {
						usuarioCierreVenta = genericDao.get(Usuario.class, genericDao
								.createFilter(FilterType.EQUALS, "username", usernameCierreVenta));
					}					
				}
			}
		}

		PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(activo.getId());

		if (!Checks.esNulo(perimetro) && !Checks.esNulo(perimetro.getAplicaFormalizar())
				&& BooleanUtils.toBoolean(perimetro.getAplicaFormalizar())) {
			if (!Checks.esNulo(usuarioGestorFormalizacion)) {
				this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_GESTOR_FORMALIZACION,
						usuarioGestorFormalizacion.getUsername(), dto);
			} else {
				this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_GESTOR_FORMALIZACION,
						"GESTFORM", dto);
			}

			if (!activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_THIRD_PARTY)) {
				if (DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo())
						&& (DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(activo.getSubcartera().getCodigo())
								|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo())
								|| DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))) {
					this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_SUPERVISOR_FORMALIZACION,
							"nesteban", dto);
				} else if (!activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)) {
					this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_SUPERVISOR_FORMALIZACION,
							"SUPFORM", dto);
				}

			} else {
				Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", "SFORM");
				EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, f1);

				Filter f2 = genericDao.createFilter(FilterType.EQUALS, "activo", activo);
				Filter f3 = genericDao.createFilter(FilterType.EQUALS, "tipoGestor", tipoGestor);
				GestorActivo supervisorFormalzacion = genericDao.get(GestorActivo.class, f2, f3);

				f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", "SCOM");
				tipoGestor = genericDao.get(EXTDDTipoGestor.class, f1);

				f3 = genericDao.createFilter(FilterType.EQUALS, "tipoGestor", tipoGestor);
				GestorActivo nuevoSupervisorC = genericDao.get(GestorActivo.class, f2, f3);
				if (!Checks.esNulo(nuevoSupervisorC) && !Checks.esNulo(nuevoSupervisorC.getUsuario())) {
					usuarioSupervisorComercial = nuevoSupervisorC.getUsuario();// flag
				}
				if (!Checks.esNulo(supervisorFormalzacion) && !Checks.esNulo(supervisorFormalzacion.getUsuario())) {
					this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_SUPERVISOR_FORMALIZACION,
							supervisorFormalzacion.getUsuario().getUsername(), dto);
				}
				if (!Checks.esNulo(usuarioSupervisorComercial)) {
					this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_SUPERVISOR_COMERCIAL,
							usuarioSupervisorComercial.getUsername(), dto);
				}
			}

			if (DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo()) 
					&& (DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(activo.getSubcartera().getCodigo())
							|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo()))) {
				if (!Checks.esNulo(usuarioCierreVenta)) {
					this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_GESTOR_CIERRE_VENTA, 
							usuarioCierreVenta.getUsername(), dto);
				}
			} else {
				if (!Checks.esNulo(usuarioGestoriaFormalizacion))
					this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_GESTORIA_FORMALIZACION,
							usuarioGestoriaFormalizacion.getUsername(), dto);
			}

		}

		if (!Checks.esNulo(usuarioGestorComercial))
			this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_GESTOR_COMERCIAL,
					usuarioGestorComercial.getUsername(), dto);

		if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())) {
			if (!Checks.esNulo(usuarioGestorReserva))
				this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_GESTOR_RESERVA_CAJAMAR,
						usuarioGestorReserva.getUsername(), dto);
			if (!Checks.esNulo(usuarioSupervisorReserva))
				this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_SUPERVISOR_RESERVA_CAJAMAR,
						usuarioSupervisorReserva.getUsername(), dto);
			if (!Checks.esNulo(usuarioGestorMinuta))
				this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_GESTOR_MINUTA_CAJAMAR,
						usuarioGestorMinuta.getUsername(), dto);
			if (!Checks.esNulo(usuarioSupervisorMinuta))
				this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_SUPERVISOR_MINUTA_CAJAMAR,
						usuarioSupervisorMinuta.getUsername(), dto);
			if (!Checks.esNulo(usuarioSupervisorFormalizacion))
				this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_SUPERVISOR_FORMALIZACION,
						usuarioSupervisorFormalizacion.getUsername(), dto);
			if (DDTipoTituloActivo.tipoTituloNoJudicial.equals(activo.getTipoTitulo().getCodigo()) && 
					(DDSubtipoTituloActivo.subtipoNotarialCompra.equals(activo.getSubtipoTitulo().getCodigo()) ||
					 DDSubtipoTituloActivo.subtipoNotarialDacion.equals(activo.getSubtipoTitulo().getCodigo()))) {				
				this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_GESTORIA_ADMISION, 
						"diagonal01", dto);
			}
		}
		
		if(activo != null) {
			String usernameGestorController = gestorExpedienteComercialDao.getUsuarioGestor(activo.getId(),
					GestorExpedienteComercialApi.CODIGO_GESTOR_CONTROLLER);
			if(usernameGestorController != null) {
				usuarioGestorController = genericDao.get(Usuario.class,
						genericDao.createFilter(FilterType.EQUALS, "username", usernameGestorController));
			}
			
			if(usuarioGestorController != null) {
				this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_GESTOR_CONTROLLER, 
						usuarioGestorController.getUsername(), dto);
			}
		}
	}

	private void agregarTipoGestorYUsuarioEnDto(String codTipoGestor, String username, GestorEntidadDto dto) {
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", codTipoGestor));
		Usuario usu = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", username));

		if (!Checks.esNulo(tipoGestor) && !Checks.esNulo(usu)) {
			dto.setIdTipoGestor(tipoGestor.getId());
			dto.setIdUsuario(usu.getId());
			gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(dto);
		}
	}

	/**
	 * Este método comprueba la entidad de la oferta para evaluar que gestores deben
	 * estar asignados. Si la entidad es Cajamar deben estar asignados todos los
	 * gestores, cualquier otra pueden obviar el gestore de tipo 'Backoffice'.
	 * Dependiendo de los requerimientos por entidad devuelve True si se encuentran
	 * los gestores necesarios asignados o False si no lo están.
	 * 
	 * @param agr : agrupación de tipo 'lote comercial'.
	 * @return True si todos los gestores de la agrupación están asignados según
	 *         requerimientos. False si no lo están.
	 */
	private boolean agrupacionLoteComercialGestoresAsignados(ActivoAgrupacion agr) {
		ActivoLoteComercial loteComercial = genericDao.get(ActivoLoteComercial.class,
				genericDao.createFilter(FilterType.EQUALS, "id", agr.getId()));

		// Comprobar entidad de la oferta.
		if (!Checks.estaVacio(agr.getActivos()) && !Checks.esNulo(agr.getActivos().get(0))
				&& !Checks.esNulo(agr.getActivos().get(0).getActivo())
				&& !Checks.esNulo(agr.getActivos().get(0).getActivo().getCartera())
				&& !Checks.esNulo(agr.getActivos().get(0).getActivo().getCartera().getCodigo())
				&& (agr.getActivos().get(0).getActivo().getCartera().getCodigo()
						.equals(DDCartera.CODIGO_CARTERA_CAJAMAR)
						|| agr.getActivos().get(0).getActivo().getCartera().getCodigo()
								.equals(DDCartera.CODIGO_CARTERA_LIBERBANK))) {
			if (Checks.esNulo(loteComercial.getUsuarioGestorComercial()) && !agr.getActivos().get(0).getActivo()
					.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_LIBERBANK)) {
				return false;
			} else if (Checks.esNulo(loteComercial.getUsuarioGestorComercialBackOffice()) && agr.getActivos().get(0)
					.getActivo().getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_LIBERBANK)) {
				return false;
			}
		} else {
			if ((DDCartera.CODIGO_CARTERA_BANKIA.equals(agr.getActivos().get(0).getActivo().getCartera().getCodigo())
					|| (DDCartera.CODIGO_CARTERA_EGEO
							.equals(agr.getActivos().get(0).getActivo().getCartera().getCodigo())
							&& (DDSubcartera.CODIGO_ZEUS
									.equals(agr.getActivos().get(0).getActivo().getSubcartera().getCodigo())))
					|| DDCartera.CODIGO_CARTERA_GALEON
							.equals(agr.getActivos().get(0).getActivo().getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_GIANTS
							.equals(agr.getActivos().get(0).getActivo().getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_HYT.equals(agr.getActivos().get(0).getActivo().getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_SAREB
							.equals(agr.getActivos().get(0).getActivo().getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_TANGO
							.equals(agr.getActivos().get(0).getActivo().getCartera().getCodigo())
					|| (DDCartera.CODIGO_CARTERA_THIRD_PARTY
							.equals(agr.getActivos().get(0).getActivo().getCartera().getCodigo())
							&& (DDSubcartera.CODIGO_THIRD_PARTIES_QUITAS_ING
									.equals(agr.getActivos().get(0).getActivo().getSubcartera().getCodigo())
									|| DDSubcartera.CODIGO_THIRD_PARTIES_COMERCIAL_ING
											.equals(agr.getActivos().get(0).getActivo().getSubcartera().getCodigo()))))
					&& agrupacionAdapter.isRetail(agr)) {
				if (Checks.esNulo(loteComercial.getUsuarioGestorComercial())
						|| Checks.esNulo(loteComercial.getUsuarioGestorComercialBackOffice())) {
					return false;
				}

			} else if (Checks.esNulo(loteComercial.getUsuarioGestorComercial())) {
				return false;
			}
		}
		return true;
	}

	@Transactional
	public DDComiteSancion devuelveComiteByCartera(Long idActivo, Long idOferta, Long idExpediente) {
		return this.devuelveComiteByCartera(activoAdapter.getActivoById(idActivo).getCartera().getCodigo(),
				ofertaApi.getOfertaById(idOferta), expedienteComercialApi.findOne(idExpediente));
	}

	@Transactional
	public DDComiteSancion devuelveComiteByCartera(String carteraCodigo, Oferta oferta, ExpedienteComercial expediente) {

		Filter filtroComite = null;

		// HREOS-2511 El combo "Comité seleccionado" vendrá informado para
		// cartera Sareb
		if (DDCartera.CODIGO_CARTERA_SAREB.equals(carteraCodigo) || DDCartera.CODIGO_CARTERA_TANGO.equals(carteraCodigo)
				|| DDCartera.CODIGO_CARTERA_GIANTS.equals(carteraCodigo)
				|| DDCartera.CODIGO_CARTERA_CERBERUS.equals(carteraCodigo)) {
			Double precioMinimoAutorizado = 0.0;
			ActivoBancario activoBancario = activoApi.getActivoBancarioByIdActivo(oferta.getActivoPrincipal().getId());
			if (Checks.esNulo(oferta.getAgrupacion())) {
				if (!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getActivo())) {
					List<VPreciosVigentes> vPreciosVigentes = activoAdapter
							.getPreciosVigentesByIdAndNotFecha(activoBancario.getActivo().getId());
					if (!Checks.estaVacio(vPreciosVigentes)) {
						for (VPreciosVigentes precio : vPreciosVigentes) {
							if (DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO.equals(precio.getCodigoTipoPrecio())
									&& !Checks.esNulo(precio.getImporte())) {
								precioMinimoAutorizado = precio.getImporte();
							}
						}
					}
				}
			} else {
				ActivoAgrupacion agrupacion = oferta.getAgrupacion();
				List<ActivoAgrupacionActivo> activos = agrupacion.getActivos();
				if (!Checks.estaVacio(activos)) {
					for (ActivoAgrupacionActivo activoOferta : activos) {
						List<VPreciosVigentes> vPreciosVigentes = activoAdapter
								.getPreciosVigentesByIdAndNotFecha(activoOferta.getId());
						if (!Checks.estaVacio(vPreciosVigentes)) {
							for (VPreciosVigentes precio : vPreciosVigentes) {
								if (DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO.equals(precio.getCodigoTipoPrecio())
										&& !Checks.esNulo(precio.getImporte())) {
									precioMinimoAutorizado += precio.getImporte();
								}
							}
						}
					}
				}
			}
			
			ActivoValoraciones precioAprVenta =getValoracionAprobadoVenta(oferta.getActivoPrincipal());
			boolean esFinanciero = false;
			if (!Checks.esNulo(activoBancario)) {
				if (!Checks.esNulo(activoBancario.getClaseActivo()) && activoBancario.getClaseActivo().getCodigo()
						.equals(DDClaseActivoBancario.CODIGO_FINANCIERO)) {
					esFinanciero = true;
				}
				
				String codSubcartera = Checks.esNulo(oferta.getActivoPrincipal().getSubcartera()) ? null : oferta.getActivoPrincipal().getSubcartera().getCodigo();
				
				if (DDCartera.CODIGO_CARTERA_TANGO.equals(carteraCodigo)) {
					filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_TANGO);
				} else if (DDCartera.CODIGO_CARTERA_GIANTS.equals(carteraCodigo)) {
					filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_GIANTS);
				} else if (DDCartera.CODIGO_CARTERA_CERBERUS.equals(carteraCodigo)) {
					
					if (DDSubcartera.CODIGO_AGORA_FINANCIERO.equals(codSubcartera)	|| DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(codSubcartera)) {
						filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_CERBERUS);
					} else if (DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(codSubcartera) || DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(codSubcartera)) {
						ActivoAgrupacion agrupacion = oferta.getAgrupacion();
						Double umbralAskingPrice=200000.0;
						String codComiteHaya = DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(codSubcartera)? DDComiteSancion.CODIGO_HAYA_APPLE : DDComiteSancion.CODIGO_HAYA_REMAINING;
						String codComiteCes = DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(codSubcartera)? DDComiteSancion.CODIGO_CES_APPLE : DDComiteSancion.CODIGO_CES_REMAINING;
						Double importeOferta = Checks.esNulo(oferta.getImporteOferta()) ? 0d : oferta.getImporteOferta();
						
						if(Checks.esNulo(agrupacion)) {
							if (precioAprVenta != null && importeOferta <= umbralAskingPrice && (importeOferta >= precioAprVenta.getImporte() * 0.95)) {
								filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo", codComiteHaya);
							} else {
								filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo",codComiteCes);
							} 
						}else {
							Double askingPrice =  calcularAskingPriceAgrupacion(agrupacion);  							
							if (importeOferta <= umbralAskingPrice && (importeOferta >= askingPrice * 0.95)) {
								filtroComite =  genericDao.createFilter(FilterType.EQUALS, "codigo", codComiteHaya);
							} else {
								filtroComite =  genericDao.createFilter(FilterType.EQUALS, "codigo", codComiteCes);
							} 
						}				
							
					}else if(DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())){
						filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_ARROW);
							
					}else {
						filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_CERBERUS);
					}				
					
				} else {
					// 1º Clase de activo (financiero/inmobiliario) y sin
					// formalización.
					if (esFinanciero && !Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getActivo())
							&& activoApi.getPerimetroByIdActivo(activoBancario.getActivo().getId())
									.getAplicaFormalizar() == 0) {
						filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDComiteSancion.CODIGO_HAYA_SAREB);
						// 2º Si es inmobiliario: Tipo de comercialización
						// (singular/retail).
					} else if (!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getActivo())
							&& activoBancario.getActivo().getTipoComercializar() != null && activoBancario.getActivo()
									.getTipoComercializar().getCodigo().equals(DDTipoComercializar.CODIGO_SINGULAR)) {
						filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDComiteSancion.CODIGO_SAREB);
						// 3º Si es retail: Comparamos precio mínimo e importe
						// oferta.
					} else if (!Checks.esNulo(precioMinimoAutorizado)
							&& precioMinimoAutorizado > oferta.getImporteOferta()) {
						filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDComiteSancion.CODIGO_SAREB);
					} else {
						filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDComiteSancion.CODIGO_HAYA_SAREB);
					}
				}
			}
		}

		// El combo "Comité seleccionado" vendrá informado para cartera
		// Liberbank
		else if (!Checks.esNulo(oferta.getActivoPrincipal()) && !Checks.esNulo(oferta.getActivoPrincipal().getCartera())
				&& DDCartera.CODIGO_CARTERA_LIBERBANK.equals(carteraCodigo)) {
			return ofertaApi.calculoComiteLBK(oferta.getId(), expediente);
		}
		// El combo "Comité seleccionado" vendrá informado para cartera Cajamar
		else if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(carteraCodigo)) {
			filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_CAJAMAR);
		}
		// El combo "Comité seleccionado" vendrá informado para cartera Galeon
		else if (DDCartera.CODIGO_CARTERA_GALEON.equals(carteraCodigo)) {
			filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_GALEON);
		}
		// El combo "Comité seleccionado" vendrá informado para subcartera Zeus
		else if (DDCartera.CODIGO_CARTERA_EGEO.equals(carteraCodigo)
				&& DDSubcartera.CODIGO_ZEUS.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())) {
			filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_EGEO);
		} else if (DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(carteraCodigo)
				&& DDSubcartera.CODIGO_YUBAI.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())) {
			filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo",
					DDComiteSancion.CODIGO_THIRD_PARTIES_YUBAI);
		} else if (DDCartera.CODIGO_CARTERA_BBVA.equals(carteraCodigo)) {
			filtroComite = genericDao.createFilter(FilterType.EQUALS, "codigo",	calcularComiteBBVA(oferta));
		}

		if (filtroComite != null) {
			return genericDao.get(DDComiteSancion.class, filtroComite);
		} else {
			return null;
		}
	}

	@Override
	public String calcularComiteBBVA(Oferta oferta) {
		String comite = DDComiteSancion.CODIGO_HAYA_BBVA;
		if (oferta.getAgrupacion() != null) {
			List<ActivoAgrupacionActivo> activos = oferta.getAgrupacion().getActivos();
			for (ActivoAgrupacionActivo aga : activos) {
				if (DDComiteSancion.CODIGO_BBVA.equals(calcularComiteBBVAporActivo(aga.getActivo(), oferta))) {
					comite = DDComiteSancion.CODIGO_BBVA;
					return comite;
				}
			}
		} else if (DDComiteSancion.CODIGO_BBVA.equals(calcularComiteBBVAporActivo(oferta.getActivoPrincipal(), oferta))) {
			comite = DDComiteSancion.CODIGO_BBVA;
		}

		return comite;
	}
	
	private String calcularComiteBBVAporActivo(Activo activo, Oferta oferta) {
		String comite = DDComiteSancion.CODIGO_HAYA_BBVA;
		ActivoPatrimonio patrimonio = null;
		patrimonio = genericDao.get(ActivoPatrimonio.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
		
		if(patrimonio != null && patrimonio.getTipoEstadoAlquiler() != null 
				&& DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO.equals(patrimonio.getTipoEstadoAlquiler().getCodigo())) {
			comite = DDComiteSancion.CODIGO_BBVA;
		}

		if (!DDComiteSancion.CODIGO_BBVA.equals(comite)
				&& DDCartera.CODIGO_CARTERA_BBVA.equals(activo.getCartera().getCodigo())) {
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoBbvaActivos activoBbva = genericDao.get(ActivoBbvaActivos.class, filtroActivo);	
			
			if (activoBbva != null && activoBbva.getActivoEpa() != null && DDSinSiNo.CODIGO_SI.equals(activoBbva.getActivoEpa().getCodigo())) {
				comite = DDComiteSancion.CODIGO_BBVA;
			}

		}

		if (!DDComiteSancion.CODIGO_BBVA.equals(comite)) {
			Filter filtroActivoPublicacion = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			Filter filtroFechaHastaNull = genericDao.createFilter(FilterType.NULL, "fechaFinVenta");
			ActivoPublicacion activoPublicacion = genericDao.get(ActivoPublicacion.class, filtroActivoPublicacion);
			ActivoPublicacionHistorico activoPublicacionHist = null;
			List<ActivoPublicacionHistorico> activoPublicacionList = genericDao.getListOrdered(ActivoPublicacionHistorico.class,
					new Order(OrderType.DESC, "id"), filtroActivoPublicacion,filtroFechaHastaNull);
			if(activoPublicacionList != null && !activoPublicacionList.isEmpty()) 
				activoPublicacionHist = activoPublicacionList.get(0);
	
			if (activoPublicacion.getCheckOcultarPrecioVenta() || (activoPublicacion.getEstadoPublicacionVenta() != null
					&& !DDEstadoPublicacionVenta.CODIGO_PUBLICADO_VENTA.equals(activoPublicacion.getEstadoPublicacionVenta().getCodigo()))) {
				comite = DDComiteSancion.CODIGO_BBVA;
				
			}else {	
				Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo", activo.getId());
				Filter filtroOferta = genericDao.createFilter(FilterType.EQUALS, "oferta", oferta.getId());
				ActivoOferta activoOferta = genericDao.get(ActivoOferta.class, filtroActivo, filtroOferta);				
				ActivoValoraciones valoracion = getValoracionAprobadoVenta(activo);

				Double importeActivoOferta = activoOferta.getImporteActivoOferta();
				Double importePublicado = valoracion.getImporte();

				if (importeActivoOferta < importePublicado) {
					Date fechaPublicacionVenta = activoPublicacionHist != null ? 
													activoPublicacionHist.getFechaInicioVenta() != null ? 
														activoPublicacionHist.getFechaInicioVenta() 
															: activoPublicacion.getFechaCambioPubVenta() != null ? 
																	activoPublicacion.getFechaCambioPubVenta() 
																	: activoPublicacion.getFechaInicioVenta()
													: activoPublicacion.getFechaCambioPubVenta() != null ? 
															activoPublicacion.getFechaCambioPubVenta() 
															: activoPublicacion.getFechaInicioVenta();

					Calendar calendar = Calendar.getInstance();
					calendar.setTime(new Date());
					calendar.add(Calendar.DAY_OF_MONTH, -15);

					Date diasPublicacion = calendar.getTime();

					if (diasPublicacion.compareTo(fechaPublicacionVenta) <= 0) {
						comite = DDComiteSancion.CODIGO_BBVA;
					} else {	
						Date fechaPrecioVenta = valoracion.getFechaAprobacion() == null ? new Date() : valoracion.getFechaAprobacion();
						if (diasPublicacion.compareTo(fechaPrecioVenta) <= 0) {
							comite = DDComiteSancion.CODIGO_BBVA;
						} else {
							comite = validarImporteDescuentoBBVA(oferta);
						}
					}
				}
			}
			
		}

		return comite;
	}
	
	
	private String validarImporteDescuentoBBVA(Oferta oferta) {
		String comite = DDComiteSancion.CODIGO_HAYA_BBVA;
		final Double UMBRAL_IMPORTE = 150000d;
		Double importeOferta = oferta.getImporteOferta();
		Double importePublicacion = 0d;
		Double dto = 0d;

		if (oferta.getAgrupacion() != null) {
			importePublicacion = calcularAskingPriceAgrupacion(oferta.getAgrupacion());
		} else {
			ActivoValoraciones valoracionAprobadoVenta = getValoracionAprobadoVenta(oferta.getActivoPrincipal());			
			importePublicacion = valoracionAprobadoVenta != null ? valoracionAprobadoVenta.getImporte() : 0;			
		}
		
		dto = importePublicacion != null && importePublicacion > 0 ? ((importePublicacion - importeOferta)*100) / importePublicacion : 0;
		
		if(UMBRAL_IMPORTE >= importeOferta && dto > 10 || UMBRAL_IMPORTE < importeOferta && dto > 5) {
			comite =  DDComiteSancion.CODIGO_BBVA;
		}

		return comite;
	}

	public void validartramitacionActivo(DtoOfertaActivo dto, Oferta oferta, DDEstadoOferta estadoOferta, Activo activo,
			Boolean esAlquiler) {

		if (DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
			comprobarTramitarOferta(oferta, activo, esAlquiler, null);
		}

		// Si el activo pertenece a un lote comercial, no se pueden aceptar
		// ofertas de forma individual en el activo
		if ((activoAgrupacionActivoDao.activoEnAgrupacionLoteComercial(dto.getIdActivo())
				|| activoAgrupacionActivoDao.activoEnAgrupacionLoteComercialAlquiler(dto.getIdActivo()))
				&& (Checks.esNulo(dto.getEsAnulacion()) || !dto.getEsAnulacion())) {
			throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_ACTIVO_EN_LOTE_COMERCIAL));
		}
		if (!Checks.esNulo(oferta.getCliente())) {
			if (Checks.esNulo(oferta.getCliente().getDocumento())
					|| Checks.esNulo(oferta.getCliente().getTipoDocumento())) {
				throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_TIPO_NUMERO_DOCUMENTO));
			}
		} else {
			throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_CLIENTE_OBLIGATORIO));
		}
		// Si el activo esta marcado como alquilado
		// o si el activo esta marcado como ocupado sin titulo
		// no permitiremos tramitar ofertas de alquiler
		if (!Checks.esNulo(oferta) && !Checks.esNulo(activo) && !Checks.esNulo(estadoOferta)
				&& DDEstadoOferta.CODIGO_ACEPTADA.equals(estadoOferta.getCodigo()) && esAlquiler
				&& ((!Checks.esNulo(activo.getSituacionComercial())
						&& !Checks.esNulo(activo.getSituacionComercial().getCodigo())
						&& DDSituacionComercial.CODIGO_ALQUILADO.equals(activo.getSituacionComercial().getCodigo()))
						|| (activo.getSituacionPosesoria().getOcupado() != null
								&& activo.getSituacionPosesoria().getOcupado() == 1
								&& (Checks.esNulo(activo.getSituacionPosesoria().getConTitulo())
										|| (!Checks.esNulo(activo.getSituacionPosesoria().getConTitulo())
												&& activo.getSituacionPosesoria().getConTitulo().getCodigo()
														.equals(DDTipoTituloActivoTPA.tipoTituloNo)))))) {

			throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_ACITVO_ALQUILADO_O_OCUPADO));

		}

		// Si el estado de la oferta es tramitada y tipo oferta es alquiler
		// Sole se podrá realizar el cambio si no existe para el mismo activo
		// una oferta de tipo venta
		if (!Checks.esNulo(estadoOferta) && !Checks.esNulo(oferta.getTipoOferta())
				&& DDEstadoOferta.CODIGO_ACEPTADA.equals(estadoOferta.getCodigo()) && esAlquiler) {

			// Consultar ofertas activo
			List<ActivoOferta> ofertasActivo = activo.getOfertas();

			if (!Checks.estaVacio(ofertasActivo)) {
				for (ActivoOferta activoOferta : ofertasActivo) {
					Oferta ofr = activoOferta.getPrimaryKey().getOferta();
					// Si existe oferta de venta lanzar error
					if (!Checks.esNulo(ofr) && !Checks.esNulo(ofr.getTipoOferta())
							&& DDTipoOferta.CODIGO_VENTA.equals(ofr.getTipoOferta().getCodigo())
							&& !DDEstadoOferta.CODIGO_RECHAZADA.equals(ofr.getEstadoOferta().getCodigo())) {

						throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_EXISTEN_OFERTAS_VENTA));
					}
				}
			}

		}

		if (!Checks.esNulo(dto.getIdActivo()) && activoDao.isIntegradoEnAgrupacionPA(dto.getIdActivo())) {
			ActivoAgrupacion agrupacion = activoDao.getAgrupacionPAByIdActivo(dto.getIdActivo());
			if (activoDao.isActivoMatriz(dto.getIdActivo())
					&& activoDao.existenUAsconOfertasVivas(agrupacion.getId())) {
				throw new JsonViewerException(
						messageServices.getMessage(EXISTEN_UNIDADES_ALQUILABLES_CON_OFERTAS_VIVAS));
			} else if (activoDao.isUnidadAlquilable(dto.getIdActivo())
					&& activoDao.existeAMconOfertasVivas(agrupacion.getId())) {
				throw new JsonViewerException(messageServices.getMessage(EXISTE_ACTIVO_MATRIZ_CON_OFERTAS_VIVAS));
			}
		}

		ExpedienteComercial expediente = expedienteComercialApi.findOneByOferta(oferta);
		if (!Checks.esNulo(expediente)) {
			List<ComunicacionGencat> comunicacionesGencat = gencatApi.comunicacionesVivas(expediente);
			if (!Checks.estaVacio(comunicacionesGencat) && !Checks.esNulo(estadoOferta)
					&& (DDEstadoOferta.CODIGO_ACEPTADA.equals(estadoOferta.getCodigo())
							|| DDEstadoOferta.CODIGO_PENDIENTE.equals(estadoOferta.getCodigo()))
					&& gencatApi.comprobarExpedienteAnuladoGencat(comunicacionesGencat)) {
				throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_EXPEDIENTE_ANULADO_POR_GENCAT));
			}
		}
	}

	public void validarTramitacionAgrupacion(DtoOfertaActivo dto, DDEstadoOferta estadoOferta, Oferta oferta,
			Boolean esAlquiler, ActivoAgrupacion agrupacion) throws Exception {

		if (!Checks.esNulo(agrupacion)) {
			List<ActivoAgrupacionActivo> agaList = agrupacion.getActivos();

			for (ActivoAgrupacionActivo aga : agaList) {
				Activo activo = aga.getActivo();
				Long numActivo = activo.getNumActivo();

				comprobarTramitarOferta(oferta, activo, esAlquiler, numActivo.toString());

				if (DDEstadoOferta.CODIGO_ACEPTADA.equals(estadoOferta.getCodigo()) && esAlquiler
						&& Checks.esNulo(activo.getTipoAlquiler())) {
					throw new JsonViewerException("El valor de Tipo de Alquiler del activo " + numActivo
							+ " no permite la realización de una oferta");
				}
			}
		}

		if (DDEstadoOferta.CODIGO_ACEPTADA.equals(estadoOferta.getCodigo())) {
			if (!Checks.esNulo(oferta.getCliente())) {
				if (Checks.esNulo(oferta.getCliente().getDocumento())
						|| Checks.esNulo(oferta.getCliente().getTipoDocumento())) {
					throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_TIPO_NUMERO_DOCUMENTO));
				}
			} else {
				throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_CLIENTE_OBLIGATORIO));
			}
		}

		// Si se pretende aceptar la oferta, comprobar primero si la agrupación
		// de la oferta es de tipo 'Lote comercial'.
		if (DDEstadoOferta.CODIGO_ACEPTADA.equals(estadoOferta.getCodigo())) {
			if (!Checks.esNulo(oferta.getAgrupacion()) && oferta.getAgrupacion().getTipoAgrupacion().getCodigo()
					.equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
				// En caso que la agrupación sea formalizable comprobamos tenga
				// todos los gestores
				if (ES_FORMALIZABLE.equals(oferta.getAgrupacion().getIsFormalizacion())) {
					// // Comprobar si la agrupación tiene todos los gestores
					// // asignados.
					if (!agrupacionLoteComercialGestoresAsignados(oferta.getAgrupacion())
							&& !Checks.esNulo(oferta.getVentaDirecta()) && !oferta.getVentaDirecta()) {
						throw new JsonViewerException(AgrupacionAdapter.OFERTA_AGR_LOTE_COMERCIAL_GESTORES_NULL_MSG);
					}
				} else {
					throw new JsonViewerException(messageServices.getMessage(AGRUPACION_SIN_FORMALIZACION));
				}
			}
		}

		// Si el estado de la oferta cambia a Aceptada cambiamos el resto de
		// estados a Congelada excepto los que ya estuvieran en Rechazada
		if (DDEstadoOferta.CODIGO_ACEPTADA.equals(estadoOferta.getCodigo())) {
			// Comprobar si la agrupación de la oferta es de tipo 'Lote
			// comercial'.
			if (!Checks.esNulo(oferta.getAgrupacion()) && oferta.getAgrupacion().getTipoAgrupacion().getCodigo()
					.equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
				// En caso que la agrupación sea formalizable comprobamos tenga
				// todos los gestores
				if (ES_FORMALIZABLE.equals(oferta.getAgrupacion().getIsFormalizacion())) {
					// Comprobar si la agrupación tiene todos los gestores
					// asignados.
					if (!agrupacionLoteComercialGestoresAsignados(oferta.getAgrupacion())
							&& !Checks.esNulo(oferta.getVentaDirecta()) && !oferta.getVentaDirecta()) {
						throw new JsonViewerException(AgrupacionAdapter.OFERTA_AGR_LOTE_COMERCIAL_GESTORES_NULL_MSG);
					}
				}
			}
		}
	}

	public Formalizacion crearFormalizacion(ExpedienteComercial expedienteComercial) {
		Formalizacion nuevaFormalizacion = new Formalizacion();
		nuevaFormalizacion.setAuditoria(Auditoria.getNewInstance());
		nuevaFormalizacion.setExpediente(expedienteComercial);
		return nuevaFormalizacion;
	}

	@Transactional(readOnly = false)
	public ActivoTramite doTramitacion(Activo activo, Oferta oferta, Long idTrabajo, ExpedienteComercial expedienteComercial) 
			throws IllegalAccessException, InvocationTargetException {
		ActivoTramite activoTramite = trabajoApi.createTramiteTrabajo(idTrabajo,expedienteComercial);
		expedienteComercial = this.crearExpedienteReserva(expedienteComercial);
		expedienteComercialApi.crearCondicionesActivoExpediente(activo, expedienteComercial);
		DDComiteSancion comite = this.devuelveComiteByCartera(activo.getCartera().getCodigo(), oferta, expedienteComercial);
		expedienteComercial.setComiteSancion(comite);

		if (comite != null && comite.getCartera() != null
				&& DDCartera.CODIGO_CARTERA_LIBERBANK.equals(comite.getCartera().getCodigo())) {
			expedienteComercial.setComitePropuesto(comite);
		}
		this.crearGastosExpediente(oferta, expedienteComercial);

		// Se asigna un gestor de Formalización al crear un nuevo expediente.
		this.asignarGestorYSupervisorFormalizacionToExpediente(expedienteComercial);
		
		// Se debe establecer setFormalizacion al final del método. La vista comprobará que ha terminado el proceso mediante el registro creado de formalizacion
		expedienteComercial.setFormalizacion(this.crearFormalizacion(expedienteComercial));
		
		activoManager.actualizarOfertasTrabajosVivos(activo.getId());
		
		if(oferta != null && oferta.getOfertaEspecial() != null && oferta.getOfertaEspecial() && ofertaManager.esOfertaValidaCFVByCarteraSubcartera(oferta)  && boardingComunicacionApi.modoRestClientBoardingActivado()) {
			boardingComunicacionApi.actualizarOfertaBoarding(expedienteComercial.getNumExpediente(), oferta.getNumOferta(), new ModelMap(),BoardingComunicacionApi.TIMEOUT_1_MINUTO);
		}
		
		ofertaApi.updateStateDispComercialActivosByOferta(oferta);
		return activoTramite;
	}

	@Override
	@Transactional
	public void doTramitacionAsincrona(Long idActivo, Long idTrabajo, Long idOferta, Long idExpedienteComercial) {
		// Creación de formalización y condicionantes. Evita errores en los
		// trámites al preguntar por datos de algunos de estos objetos y aún
		// no esten creados. Para ello creamos los objetos vacios con el
		// unico fin que se cree la fila.
		
		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

		Activo activo = activoManager.get(idActivo);
		Oferta oferta = ofertaApi.getOfertaById(idOferta);
		ExpedienteComercial expedienteComercial = oferta.getExpedienteComercial();

		try {
			if(expedienteComercial == null) {
				expedienteComercial = expedienteComercialApi.findOne(idExpedienteComercial);
			}
			expedienteComercial = this.crearCondicionanteYTanteo(activo, oferta, expedienteComercial);
			expedienteComercial = this.crearExpedienteReserva(expedienteComercial);
			expedienteComercialApi.crearCondicionesActivoExpediente(activo, expedienteComercial);

			DDComiteSancion comite = this.devuelveComiteByCartera(activo.getCartera().getCodigo(), oferta, expedienteComercial);
			expedienteComercial.setComiteSancion(comite);

			if (comite != null && comite.getCartera() != null
					&& DDCartera.CODIGO_CARTERA_LIBERBANK.equals(comite.getCartera().getCodigo())) {
				expedienteComercial.setComitePropuesto(comite);
			}
			this.crearGastosExpediente(oferta, expedienteComercial);

			// Se asigna un gestor de Formalización al crear un nuevo expediente.
			this.asignarGestorYSupervisorFormalizacionToExpediente(expedienteComercial);
		
			// Se debe establecer setFormalizacion al final del método. La vista comprobará que ha terminado el proceso mediante el registro creado de formalizacion
			expedienteComercial.setFormalizacion(this.crearFormalizacion(expedienteComercial));
			
			//Creacion del tramite
			trabajoApi.createTramiteTrabajo(idTrabajo,expedienteComercial);
			transactionManager.commit(transaction);
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

			if (idActivo != null) {
				activoManager.actualizarOfertasTrabajosVivos(idActivo);
			}
			
			if(oferta != null && ofertaManager.esOfertaValidaCFVByCarteraSubcartera(oferta) && oferta.getOfertaEspecial() != null && oferta.getOfertaEspecial() && boardingComunicacionApi.modoRestClientBoardingActivado()) {
				boardingComunicacionApi.actualizarOfertaBoarding(expedienteComercial.getNumExpediente(), oferta.getNumOferta(), new ModelMap(),BoardingComunicacionApi.TIMEOUT_1_MINUTO);
			}
		
			ofertaApi.updateStateDispComercialActivosByOferta(oferta);
			transactionManager.commit(transaction);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			transactionManager.rollback(transaction);
		}
	}
	
	@Override
	public Boolean tieneFormalizacion(Long idExpediente) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		return !Checks.estaVacio(genericDao.getList(Formalizacion.class, filtro));		
	}
	
	private Double calcularAskingPriceAgrupacion(ActivoAgrupacion agrupacion) {
		Double askingPrice = 0d;
		if (Checks.esNulo(agrupacion)) {
			return askingPrice;
		}
		List<ActivoAgrupacionActivo> activos = agrupacion.getActivos();
		for (ActivoAgrupacionActivo activoAgrupacionActivo : activos) {
			List<ActivoValoraciones> valoracion = activoAgrupacionActivo.getActivo().getValoracion();
			if (!Checks.estaVacio(valoracion)) {
				for (ActivoValoraciones valor : valoracion) {
					if (DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(valor.getTipoPrecio().getCodigo())) {
						askingPrice += valor.getImporte();
					}
				}
			}
		}
		return askingPrice;
	}
	
	public ActivoValoraciones getValoracionAprobadoVenta(Activo activo) {
		List<ActivoValoraciones> listActivoValoracion = activo.getValoracion();
		if (!Checks.estaVacio(listActivoValoracion)) {
			for (ActivoValoraciones valoracion : listActivoValoracion) {
				if (DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(valoracion.getTipoPrecio().getCodigo())) {
					return valoracion;
				}
			}
		}

		return null;
	}
	
	@Transactional(readOnly = false)
	private void crearActivoAlquilado(Activo activo) {
		ActivosAlquilados activoAlquilado = new ActivosAlquilados();
		activoAlquilado.setActivoAlq(activo);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoPatrimonioContrato activoPatrimonioContrato = genericDao.get(ActivoPatrimonioContrato.class, filtro);
		if(activoPatrimonioContrato != null) {
			activoAlquilado.setAlqRentaMensual(activoPatrimonioContrato.getCuota());
			if (activoPatrimonioContrato.getCuota() != null && activoPatrimonioContrato.getCuota() > 0) {
				activoAlquilado.setAlqDeudas(1);
			} else {
				activoAlquilado.setAlqDeudas(0);
			}
			if(activoPatrimonioContrato.getInquilino() != null) {
				activoAlquilado.setAlqInquilino(1);
				activoAlquilado.setAlqOfertante(1);
			} else {
				activoAlquilado.setAlqInquilino(0);
				activoAlquilado.setAlqOfertante(0);
			}
			if (activoPatrimonioContrato.getFechaFinContrato() !=  null) {
				activoAlquilado.setAlqFechaFin(activoPatrimonioContrato.getFechaFinContrato());
			}
			if (activoPatrimonioContrato.getDeudaPendiente() != null) {
				activoAlquilado.setAlqDeudaActual(activoPatrimonioContrato.getDeudaPendiente());
			}
		}
		
		genericDao.save(ActivosAlquilados.class, activoAlquilado);
	}
	


	private Oferta anyadirCamposOferta(Oferta oferta, DtoOfertaActivo dto) {
		
		oferta.setOfertaEspecial(dto.getOfertaEspecial());
		oferta.setVentaCartera(dto.getVentaCartera());
		oferta.setVentaSobrePlano(dto.getVentaSobrePlano());
		
		if(dto.getCodRiesgoOperacion() != null){
			DDRiesgoOperacion riesgoOperacion = genericDao.get(DDRiesgoOperacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodRiesgoOperacion()));
			if(riesgoOperacion != null) {
				oferta.setRiesgoOperacion(riesgoOperacion);
			}
		}
		
		return oferta;
	}

}

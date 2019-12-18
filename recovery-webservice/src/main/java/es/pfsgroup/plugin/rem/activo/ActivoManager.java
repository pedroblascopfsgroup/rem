package es.pfsgroup.plugin.rem.activo;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.security.MessageDigest;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.glassfish.jersey.jackson.JacksonFeature;
import org.glassfish.jersey.media.multipart.FormDataMultiPart;
import org.glassfish.jersey.media.multipart.MultiPartFeature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.manager.GestorDocumentalExpedientesManager;
import es.pfsgroup.plugin.gestorDocumental.manager.RestClientManager;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;
import es.pfsgroup.plugin.gestorDocumental.model.ServerRequest;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDescargarDocumento;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoCargasDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoHistoricoPatrimonioDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.activo.exception.HistoricoTramitacionException;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.ActivoPublicacionDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoCargasApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.api.ActivoPropagacionApi;
import es.pfsgroup.plugin.rem.api.ActivoTributoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GastosExpedienteApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.condiciontanteo.CondicionTanteoApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.factory.TabActivoFactoryApi;
import es.pfsgroup.plugin.rem.gestor.GestorActivoManager;
import es.pfsgroup.plugin.rem.gestor.dao.GestorExpedienteComercialDao;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.gestorDocumental.dto.documentos.GestorDocToRecoveryAssembler;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceSancionOfertaAceptacionYRechazo;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.CompradorExpediente.CompradorExpedientePk;
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
import es.pfsgroup.plugin.rem.model.dd.DDAdministracion;
import es.pfsgroup.plugin.rem.model.dd.DDCalculoImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCesionSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoMotivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPresentacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
import es.pfsgroup.plugin.rem.model.dd.DDFasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDIdentificacionGestoria;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAutorizacionTramitacion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRetencion;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenDato;
import es.pfsgroup.plugin.rem.model.dd.DDResponsableSubsanar;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCargaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocPlusvalias;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFoto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSolicitudTributo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PRINCIPAL;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PROPIEDAD;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.SITUACION;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.TIPO;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ActivoDto;
import es.pfsgroup.plugin.rem.rest.dto.ComisionDto;
import es.pfsgroup.plugin.rem.rest.dto.File;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.rest.dto.PortalesDto;
import es.pfsgroup.plugin.rem.service.TabActivoService;
import es.pfsgroup.plugin.rem.tareasactivo.TareaActivoManager;
import es.pfsgroup.plugin.rem.thread.ContenedorExpComercial;
import es.pfsgroup.plugin.rem.thread.MaestroDePersonas;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;
import es.pfsgroup.plugin.rem.visita.dao.VisitaDao;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGrupoUsuariosApi;

@Service("activoManager")
public class ActivoManager extends BusinessOperationOverrider<ActivoApi> implements ActivoApi {

	protected static final Log logger = LogFactory.getLog(ActivoManager.class);
	private static final String AVISO_MENSAJE_ACTIVO_EN_LOTE_COMERCIAL = "activo.aviso.aceptatar.oferta.activo.dentro.lote.comercial";
	private static final String AVISO_MENSAJE_TIPO_NUMERO_DOCUMENTO = "activo.motivo.oferta.tipo.numero.documento";
	private static final String AVISO_MENSAJE_CLIENTE_OBLIGATORIO = "activo.motivo.oferta.cliente";
	private static final String AVISO_MEDIADOR_NO_EXISTE = "activo.aviso.mediador.no.existe";
	private static final String AVISO_MEDIADOR_BAJA = "activo.aviso.mediador.baja";
	private static final String EMAIL_OCUPACIONES = "emailOcupaciones";
	private static final String AVISO_MENSAJE_EXISTEN_OFERTAS_VENTA = "activo.motivo.oferta.existe.venta";
	private static final String AVISO_MENSAJE_ACITVO_ALQUILADO_O_OCUPADO = "activo.motivo.oferta.alquilado.ocupado";
	private static final String AVISO_MENSAJE_EXPEDIENTE_ANULADO_POR_GENCAT = "activo.motivo.oferta.anulado.gencat";
	private static final String MAESTRO_ORIGEN_WCOM="WCOM";
	private static final String EXISTEN_UNIDADES_ALQUILABLES_CON_OFERTAS_VIVAS ="activo.matriz.con.unidades.alquilables.ofertas.vivas";
	private static final String EXISTE_ACTIVO_MATRIZ_CON_OFERTAS_VIVAS ="activo.unidad.alquilable.con.activo.matriz.ofertas.vivas";
	private static final String EXISTEN_UNIDADES_ALQUILABLES_ALQUILADAS ="activo.matriz.con.unidades.alquilables.alquiladas";
	private static final String EXISTE_ACTIVO_MATRIZ_ALQUILADO ="activo.unidad.alquilable.con.activo.matriz.alquilado";
	private static final String KEY_GDPR="gdpr.data.key";
	private static final String URL_GDPR="gdpr.data.url";
	private static final String AVISO_MENSAJE_MOTIVO_CALIFICACION = "activo.aviso.motivo.calificacion.duplicado";
	private static final String RELACION_TIPO_DOCUMENTO_EXPEDIENTE = "d-e";	
	private static final String OPERACION_ALTA = "Alta";
	public static final String ERROR_ANYADIR_PRESTACIONES_EN_REGISTRO = "Ya existe un registro 'Presentación en registro', y está activo";
	public static final String ERROR_ANYADIR_EN_REGISTRO = "Ya existe un registro '%s', y está activo";
	
	private SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	

	@Resource
	private MessageService messageServices;
	
	@Autowired
	private GestorDocumentalFotosApi gestorDocumentalFotos;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private GenericAdapter adapter;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private UpdaterStateApi updaterState;

	@Autowired
	private TabActivoFactoryApi tabActivoFactory;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private VisitaDao visitasDao;

	@Autowired
	private ActivoHistoricoPatrimonioDao activoHistoricoPatrimonioDao;

	@Autowired
	private ActivoPropagacionApi activoPropagacionApi;

	@Autowired
	private UvemManagerApi uvemManagerApi;

	@Autowired
	private ActivoCargasApi activoCargasApi;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private GestorExpedienteComercialDao gestorExpedienteComercialDao;

	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private DiccionarioTargetClassMap diccionarioTargetClassMap;

	@Autowired
	private UsuarioManager usuarioApi;

	@Autowired
	private RestApi restApi;

	@Autowired
	private TareaActivoManager tareaActivoManager;

	@Autowired
	private GencatApi gencatApi;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Autowired
	private List<CondicionTanteoApi> condiciones;

	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteComercialApi;

	@Autowired
	private NotificatorServiceSancionOfertaAceptacionYRechazo notificatorServiceSancionOfertaAceptacionYRechazo;

	@Autowired
	private EXTGrupoUsuariosApi eXTGrupoUsuariosApi;

	@Autowired
	private GenericAdapter genericAdapter;

	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;

	@Resource
	private Properties appProperties;

	@Autowired
	private MSVRawSQLDao rawDao;
	
	@Autowired
	private OfertaDao ofertaDao;

	@Autowired
	private AgrupacionAdapter agrupacionAdapter;

	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;

	@Autowired
	private ActivoPublicacionDao activoPublicacionDao;
	

	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;

	@Autowired
	private ActivoPatrimonioDao activoPatrimonioDao;
	
	@Autowired
	private ParticularValidatorApi particularValidator;
	
	@Autowired
	private ActivoTributoApi activoTributoApi;
	
	@Autowired
	private ActivoCargasDao activoCargasDao;
	
	@Autowired
	private GastosExpedienteApi gastosExpedienteApi;

	@Autowired
	private GestorActivoManager gestorActivoManager;

	@Override
	public String managerName() {
		return "activoManager";
	}
	
	@Override
	@BusinessOperation(overrides = "activoManager.get")
	public Activo get(Long id) {
		return activoDao.get(id);
	}

	@Override
	public Activo getByNumActivo(Long id) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numActivo", id);
		return genericDao.get(Activo.class, filter);
	}

	@Override
	public Activo getByNumActivoUvem(Long id) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numActivoUvem", id);
		return genericDao.get(Activo.class, filter);
	}

	@Override
	@BusinessOperation(overrides = "activoManager.saveOrUpdate")
	@Transactional
	public boolean saveOrUpdate(Activo activo) {
		activoDao.saveOrUpdate(activo);

		// Actualiza los check de Admisión, Gestión y Situacion Comercial del
		// activo
		updaterState.updaterStates(activo);

		return true;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.getListActivos")
	public Object getListActivos(DtoActivoFilter dto, Usuario usuarioLogado) {
		return activoDao.getListActivos(dto, usuarioLogado);
	}

	@Override
	@BusinessOperation(overrides = "activoManager.isIntegradoAgrupacionRestringida")
	public boolean isIntegradoAgrupacionRestringida(Long id, Usuario usuarioLogado) {
		Integer contador = activoDao.isIntegradoAgrupacionRestringida(id, usuarioLogado);
		return contador > 0;
	}

	@Override
	public boolean isActivoIntegradoAgrupacionRestringida(Long idActivo) {
		return activoDao.isIntegradoAgrupacionRestringida(idActivo, null) >= 1;
	}
	@Override
	public boolean isActivoIntegradoAgrupacionComercial(Long idActivo) {
		return activoDao.isIntegradoAgrupacionComercial(idActivo) >= 1;
	}

	@Override
	public ActivoAgrupacionActivo getActivoAgrupacionActivoAgrRestringidaPorActivoID(Long id) {
		return activoDao.getActivoAgrupacionActivoAgrRestringidaPorActivoID(id);
	}

	@Override
	public boolean isActivoPrincipalAgrupacionRestringida(Long id) {
		Integer contador = activoDao.isActivoPrincipalAgrupacionRestringida(id);
		return contador > 0;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.isIntegradoAgrupacionObraNueva")
	public boolean isIntegradoAgrupacionObraNueva(Long id, Usuario usuarioLogado) {
		Integer contador = activoDao.isIntegradoAgrupacionObraNueva(id, usuarioLogado);
		return contador > 0;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.deleteAdjunto")
	@Transactional(readOnly = false)
	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		Activo activo = get(dtoAdjunto.getIdEntidad());
		ActivoAdjuntoActivo adjunto = activo.getAdjunto(dtoAdjunto.getId());

		if (adjunto == null) {
			return false;
		}
		activo.getAdjuntos().remove(adjunto);
		activoDao.save(activo);

		return true;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.savePrecioVigente")
	@Transactional(readOnly = false)
	public boolean savePrecioVigente(DtoPrecioVigente dto) {
		Activo activo = get(dto.getIdActivo());

		// Si no hay idPrecioVigente creamos precio
		if (Checks.esNulo(dto.getIdPrecioVigente())) {
			saveActivoValoracion(activo, null, dto);

		} else {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdPrecioVigente());
			ActivoValoraciones activoValoracion = genericDao.get(ActivoValoraciones.class, filtro);
			saveActivoValoracion(activo, activoValoracion, dto);
		}

		ExpedienteComercial expediente = expedienteComercialApi.getExpedienteComercialResetPBC(activo);
		if (!Checks.esNulo(expediente)) {
			ofertaApi.resetPBC(expediente, false);
		}

		ActivoPublicacion actPubli = activoPublicacionDao.get(dto.getIdActivo());


		updateActivoPublicacion(dto, actPubli);

		activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());

		return true;
	}

	/**
	 * Actualiza el estado del check publicar sin precio segun el precio vigente
	 * que se guarda.
	 *
	 * @param dto
	 * @param actPubli
	 */
	@Transactional(readOnly = false)
	public void updateActivoPublicacion(DtoPrecioVigente dto, ActivoPublicacion actPubli) {

		if (!Checks.esNulo(actPubli)) {

			if (DDTipoComercializacion.CODIGO_VENTA.equals(actPubli.getTipoComercializacion().getCodigo())) {
				actPubli.setCheckSinPrecioVenta(false);
			}

			if (DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(actPubli.getTipoComercializacion().getCodigo())) {
				actPubli.setCheckSinPrecioAlquiler(false);
			}

			if (DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(actPubli.getTipoComercializacion().getCodigo())) {

				if (DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(dto.getCodigoTipoPrecio())) {
					actPubli.setCheckSinPrecioVenta(false);
				}

				if (DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA.equals(dto.getCodigoTipoPrecio())) {
					actPubli.setCheckSinPrecioAlquiler(false);
				}

			}
			
			activoPublicacionDao.save(actPubli);
		}
	}
	
	private void validateSaveOferta(DtoOfertaActivo dto, Oferta oferta, DDEstadoOferta estadoOferta) {

		// Si el activo pertenece a un lote comercial, no se pueden aceptar
		// ofertas de forma individual en el activo
		if (activoAgrupacionActivoDao.activoEnAgrupacionLoteComercial(dto.getIdActivo())
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
		// Si el activo esta marcado como alquilado no permitiremos tramitar
		// ofertas de alquiler
		if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getActivoPrincipal())
				&& DDEstadoOferta.CODIGO_ACEPTADA.equals(estadoOferta.getCodigo())
				&& DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())
				&& !Checks.esNulo(oferta.getActivoPrincipal().getSituacionComercial())
				&& !Checks.esNulo(oferta.getActivoPrincipal().getSituacionComercial().getCodigo())
				&& DDSituacionComercial.CODIGO_ALQUILADO
						.equals(oferta.getActivoPrincipal().getSituacionComercial().getCodigo())) {

			throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_ACITVO_ALQUILADO_O_OCUPADO));

		}

		// Si el activo esta marcado como ocupado sin titulo no permitiremos
		// tramitar ofertas de alquiler
		if (!Checks.esNulo(estadoOferta) && !Checks.esNulo(oferta.getActivoPrincipal())
				&& DDEstadoOferta.CODIGO_ACEPTADA.equals(estadoOferta.getCodigo())
				&& DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())
				&& !Checks.esNulo(oferta.getActivoPrincipal().getSituacionPosesoria())
				&& !Checks.esNulo(oferta.getActivoPrincipal().getSituacionPosesoria().getOcupado())
				&& oferta.getActivoPrincipal().getSituacionPosesoria().getOcupado() == 1
				&& (Checks.esNulo(oferta.getActivoPrincipal().getSituacionPosesoria().getConTitulo())
						|| (!Checks.esNulo(oferta.getActivoPrincipal().getSituacionPosesoria().getConTitulo())
								&& oferta.getActivoPrincipal().getSituacionPosesoria().getConTitulo().getCodigo().equals(DDTipoTituloActivoTPA.tipoTituloNo)))) {

			throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_ACITVO_ALQUILADO_O_OCUPADO));

		}

		// Si el estado de la oferta es tramitada y tipo oferta es alquiler
		// Sole se podrá realizar el cambio si no existe para el mismo activo
		// una oferta de tipo venta
		if (!Checks.esNulo(estadoOferta) && !Checks.esNulo(oferta.getTipoOferta())
				&& DDEstadoOferta.CODIGO_ACEPTADA.equals(estadoOferta.getCodigo())
				&& DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())) {

			// Consultar ofertas activo
			List<ActivoOferta> ofertasActivo = oferta.getActivoPrincipal().getOfertas();

			for (ActivoOferta acivoOferta : ofertasActivo) {
				// Si existe oferta de venta lanzar error
				if (!Checks.esNulo(acivoOferta.getPrimaryKey()) && !Checks.esNulo(acivoOferta.getPrimaryKey().getOferta()) 
						&& !Checks.esNulo(acivoOferta.getPrimaryKey().getOferta().getTipoOferta()) && DDTipoOferta.CODIGO_VENTA
						.equals(acivoOferta.getPrimaryKey().getOferta().getTipoOferta().getCodigo())
						&& !DDEstadoOferta.CODIGO_RECHAZADA
								.equals(acivoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo())) {

					throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_EXISTEN_OFERTAS_VENTA));
				}
			}
			
		}
		
		if (!Checks.esNulo(dto.getIdActivo()) && activoDao.isIntegradoEnAgrupacionPA(dto.getIdActivo()) && activoDao.isActivoMatriz(dto.getIdActivo())) {
			ActivoAgrupacion agrupacion = activoDao.getAgrupacionPAByIdActivo(dto.getIdActivo()); 
			if (activoDao.existenUAsAlquiladas(agrupacion.getId())) {
				throw new JsonViewerException(messageServices.getMessage(EXISTEN_UNIDADES_ALQUILABLES_ALQUILADAS));
			}else if (activoDao.existenUAsconOfertasVivas(agrupacion.getId())) {
				throw new JsonViewerException(messageServices.getMessage(EXISTEN_UNIDADES_ALQUILABLES_CON_OFERTAS_VIVAS));
			}
		}else if (!Checks.esNulo(dto.getIdActivo()) && activoDao.isIntegradoEnAgrupacionPA(dto.getIdActivo()) && activoDao.isUnidadAlquilable(dto.getIdActivo())) {
			ActivoAgrupacion agrupacion = activoDao.getAgrupacionPAByIdActivo(dto.getIdActivo()); 
			if (activoDao.existeAMalquilado(agrupacion.getId())) {
				throw new JsonViewerException(messageServices.getMessage(EXISTE_ACTIVO_MATRIZ_ALQUILADO ));
			}else if (activoDao.existeAMconOfertasVivas(agrupacion.getId())) {
				throw new JsonViewerException(messageServices.getMessage(EXISTE_ACTIVO_MATRIZ_CON_OFERTAS_VIVAS ));
			}
		}
		
		ExpedienteComercial expediente = expedienteComercialApi.findOneByOferta(oferta);
		boolean anuladoGencat = false;
		List<ComunicacionGencat> comunicacionesGencat = gencatApi.comunicacionesVivas(expediente);
		if (!Checks.esNulo(expediente) && !Checks.estaVacio(comunicacionesGencat)) {
			anuladoGencat = gencatApi.comprobarExpedienteAnuladoGencat(comunicacionesGencat);
		}
		if (!Checks.esNulo(estadoOferta) && (DDEstadoOferta.CODIGO_ACEPTADA.equals(estadoOferta.getCodigo()) || DDEstadoOferta.CODIGO_PENDIENTE.equals(estadoOferta.getCodigo())) && anuladoGencat) {
			throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_EXPEDIENTE_ANULADO_POR_GENCAT));
		}

	}
	
	private boolean doRechazaOferta(DtoOfertaActivo dto,Oferta oferta){
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

		notificatorServiceSancionOfertaAceptacionYRechazo.notificatorFinSinTramite(oferta.getId());
		return resultado;
	}
	
	private boolean doAceptaOferta(Oferta oferta) throws Exception{
		boolean resultado = false;
		List<Activo> listaActivos = new ArrayList<Activo>();
		for (ActivoOferta activoOferta : oferta.getActivosOferta()) {
			listaActivos.add(activoOferta.getPrimaryKey().getActivo());
		}
		DDSubtipoTrabajo subtipoTrabajo = (DDSubtipoTrabajo) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDSubtipoTrabajo.class, this.getSubtipoTrabajoByOferta(oferta));
		Trabajo trabajo = trabajoApi.create(subtipoTrabajo, listaActivos, null, false);
		crearExpediente(oferta, trabajo,null);
		trabajoApi.createTramiteTrabajo(trabajo);
		return resultado;
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(overrides = "activoManager.saveOfertaActivo")
	public boolean saveOfertaActivo(DtoOfertaActivo dto) throws Exception {
		boolean resultado = true;
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdOferta());
		Oferta oferta = genericDao.get(Oferta.class, filtro);
		

		DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadoOferta.class, dto.getCodigoEstadoOferta());	

		validateSaveOferta(dto, oferta, estadoOferta);
		
		oferta.setEstadoOferta(estadoOferta);

		// Al aceptar la oferta, se crea el trabajo de sancion oferta y el
		// expediente comercial

		if (DDEstadoOferta.CODIGO_ACEPTADA.equals(estadoOferta.getCodigo())) {
			comprobarTramitarOferta(oferta, dto);
			resultado = doAceptaOferta(oferta);
		}

		// si la oferta ha sido rechazada guarda los motivos de rechazo y
		// enviamos un email/notificacion.
		if (DDEstadoOferta.CODIGO_RECHAZADA.equals(estadoOferta.getCodigo())) {
			resultado = doRechazaOferta(dto, oferta);
		}
		
		if(!resultado){
			resultado = this.persistOferta(oferta);
		}
		
		if(!Checks.esNulo(dto.getIdActivo())) {
			this.actualizarOfertasTrabajosVivos(activoAdapter.getActivoById(dto.getIdActivo()));
		}

		return resultado;
	}
	
	private void comprobarTramitarOferta(Oferta oferta, DtoOfertaActivo dto) {
		String tipoOferta = oferta.getTipoOferta().getCodigo();

		if (!Checks.esNulo(dto.getIdActivo())) {
			Activo activo = activoAdapter.getActivoById(dto.getIdActivo());
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			Filter filtroTofVenta = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo",
					DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA);
			Filter filtroTofAlquiler = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo",
					DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA);
			ActivoValoraciones precioVenta = genericDao.get(ActivoValoraciones.class, filtroActivo, filtroTofVenta);
			ActivoValoraciones precioRenta = genericDao.get(ActivoValoraciones.class, filtroActivo, filtroTofAlquiler);

			if (activo != null && activo.getCartera() != null
					&& DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())){
				if (DDTipoOferta.CODIGO_VENTA.equals(tipoOferta)) {
					if (Checks.esNulo(precioVenta)
							|| (!Checks.esNulo(precioVenta) && Checks.esNulo(precioVenta.getImporte()))) {
						throw new JsonViewerException("Activo sin precio");
					}
				} else if (DDTipoOferta.CODIGO_ALQUILER.equals(tipoOferta)) {
					if (Checks.esNulo(precioRenta)
							|| (!Checks.esNulo(precioRenta) && Checks.esNulo(precioRenta.getImporte()))) {
						throw new JsonViewerException("Activo sin precio");
					}
				}
			}
			
			// Comprobar que el precio de la oferta es inferior al mínimo del activo
			if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getSubcartera())
					&& DDSubcartera.CODIGO_YUBAI.equals(activo.getSubcartera().getCodigo())) {

				if (DDTipoOferta.CODIGO_VENTA.equals(tipoOferta)) {
					Filter filtroMinVenta = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo",
							DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO);
					ActivoValoraciones precioMinVenta = genericDao.get(ActivoValoraciones.class, filtroActivo,
							filtroMinVenta);
					if (!Checks.esNulo(precioMinVenta) && !Checks.esNulo(precioMinVenta.getImporte()) 
							&& !Checks.esNulo(oferta.getImporteOferta()) && oferta.getImporteOferta() < precioMinVenta.getImporte()) {
						throw new JsonViewerException("No se puede tramitar una oferta porque el precio es inferior al mínimo");
					}
					
				} else if (DDTipoOferta.CODIGO_ALQUILER.equals(tipoOferta)) {
					Filter filtroMinAlquiler = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo",
							DDTipoPrecio.CODIGO_TPC_MIN_AUT_PROP_RENTA);
					ActivoValoraciones precioMinRenta = genericDao.get(ActivoValoraciones.class, filtroActivo,
							filtroMinAlquiler);
					if (!Checks.esNulo(precioMinRenta) && Checks.esNulo(precioMinRenta.getImporte()) 
							&& !Checks.esNulo(oferta.getImporteOferta()) && oferta.getImporteOferta() < precioMinRenta.getImporte()) {
						throw new JsonViewerException("No se puede tramitar una oferta porque el precio es inferior al mínimo");
					}
				}
			}
			
			if(DDTipoOferta.CODIGO_ALQUILER.equals(tipoOferta) && Checks.esNulo(activo.getTipoAlquiler())){
				throw new JsonViewerException("El valor de Tipo de Alquiler del activo "+activo.getNumActivo()+" no permite la realización de una oferta");
			}
				
		}
	}

	private boolean persistOferta(Oferta oferta) {
		TransactionStatus transaction = null;
		boolean resultado = false;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			ofertaApi.updateStateDispComercialActivosByOferta(oferta);
			genericDao.update(Oferta.class, oferta);
			transactionManager.commit(transaction);
			resultado = true;
		} catch (Exception e) {
			logger.error("Error en activoManager", e);
			transactionManager.rollback(transaction);

		}
		return resultado;
	}

	@Override
	@Transactional(readOnly = false)
	public ExpedienteComercial crearExpediente(Oferta oferta, Trabajo trabajo, Oferta ofertaOriginalGencatEjerce) throws Exception {
		TransactionStatus transaction = null;
		ExpedienteComercial expedienteComercial = null;
		boolean resultado = false;

		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			expedienteComercial = crearExpedienteGuardado(oferta, trabajo);

			if(DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo()) && MAESTRO_ORIGEN_WCOM.equals(oferta.getOrigen())){
				Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
				Thread maestroPersona = new Thread( new MaestroDePersonas(expedienteComercial.getId(),usu.getUsername(),oferta.getActivoPrincipal().getCartera().getDescripcion()));
				maestroPersona.start();
			}

			expedienteComercial = crearExpedienteReserva(expedienteComercial);
			expedienteComercialApi.crearCondicionesActivoExpediente(oferta.getActivoPrincipal(), expedienteComercial);

			transactionManager.commit(transaction);
			
		} catch (Exception ex) {
			logger.error("Error en activoManager", ex);
			transactionManager.rollback(transaction);
			throw ex;
		}

		// cuando creamos el expediente, si procede, creamos el repositorio
		// en el gestor documental
		if (resultado) {
			if (resultado && !Checks.esNulo(appProperties
					.getProperty(GestorDocumentalExpedientesManager.URL_REST_CLIENT_GESTOR_DOCUMENTAL_EXPEDIENTES))) {
				Thread hiloReactivar = new Thread(new ContenedorExpComercial(
						genericAdapter.getUsuarioLogado().getUsername(), expedienteComercial.getId()));
				hiloReactivar.start();

			}

		}

		return expedienteComercial;
	}

	private ExpedienteComercial crearExpedienteReserva(ExpedienteComercial expedienteComercial) {
		// HREOS-2799
		// Activos de Cajamar, debe tener en Reserva - tipo de Arras por
		// defecto: Confirmatorias
		Oferta oferta = expedienteComercial.getOferta();
		DDTiposArras tipoArras = null;
		if(!Checks.esNulo(oferta.getActivoPrincipal()) && !Checks.esNulo(oferta.getActivoPrincipal().getCartera())){
			if(DDCartera.CODIGO_CARTERA_CAJAMAR.equals(oferta.getActivoPrincipal().getCartera().getCodigo())){
				tipoArras = (DDTiposArras) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposArras.class, DDTiposArras.CONFIRMATORIAS);
			}
			if(DDCartera.CODIGO_CARTERA_GALEON.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
				|| DDCartera.CODIGO_CARTERA_ZEUS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
	            
			}
			
			if ( (DDCartera.CODIGO_CARTERA_CERBERUS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
					&& DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo()))
					&& expedienteComercial.getCondicionante().getSolicitaReserva() == 1)
				tipoArras = (DDTiposArras) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposArras.class, DDTiposArras.CONFIRMATORIAS);
			if(tipoArras != null){
				if (Checks.esNulo(expedienteComercial.getReserva()) ) {
					Reserva reservaExpediente = expedienteComercialApi.createReservaExpediente(expedienteComercial);
					if(!Checks.esNulo(reservaExpediente)) {
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

	private ExpedienteComercial crearExpedienteGuardado(Oferta oferta, Trabajo trabajo){

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
		nuevoExpediente.setNumExpediente(activoDao.getNextNumExpedienteComercial());
		nuevoExpediente.setTrabajo(trabajo);

		// Creación de formalización y condicionantes. Evita errores en los
		// trámites al preguntar por datos de algunos de estos objetos y aún
		// no esten creados. Para ello creamos los objetos vacios con el
		// unico fin que se cree la fila.
		Formalizacion nuevaFormalizacion = new Formalizacion();
		nuevaFormalizacion.setAuditoria(Auditoria.getNewInstance());
		nuevaFormalizacion.setExpediente(nuevoExpediente);
		nuevoExpediente.setFormalizacion(nuevaFormalizacion);

		CondicionanteExpediente nuevoCondicionante = new CondicionanteExpediente();
		nuevoCondicionante.setAuditoria(Auditoria.getNewInstance());
		nuevoCondicionante.setExpediente(nuevoExpediente);

		if (!Checks.esNulo(oferta.getActivoPrincipal()) && !Checks.esNulo(oferta.getActivoPrincipal().getCartera())) {
			// HREOS-2799
			// Activos de Cajamar, debe haber reserva necesaria con un importe
			// fijo de 1.000 euros y plazo 5 dias
			// Activos de Cajamar, deben copiar las condiciones informadas del
			// activo en las condiciones al comprador
			if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
				nuevoCondicionante.setSolicitaReserva(1);
				DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoCalculo.class, DDTipoCalculo.TIPO_CALCULO_PORCENTAJE);
				nuevoCondicionante.setTipoCalculoReserva(tipoCalculo);
				nuevoCondicionante.setPorcentajeReserva(Double.valueOf(3));
				nuevoCondicionante.setImporteReserva(oferta.getImporteOferta() * (Double.valueOf(3) / 100));
				nuevoCondicionante.setPlazoFirmaReserva(5);
			}
			// HREOS-4450
			// Activos de Galeon, debe haber reserva necesaria con un importe
			// fijo del 5%
			if (DDCartera.CODIGO_CARTERA_GALEON.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_ZEUS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
				nuevoCondicionante.setSolicitaReserva(1);
				DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoCalculo.class, DDTipoCalculo.TIPO_CALCULO_PORCENTAJE);
				nuevoCondicionante.setTipoCalculoReserva(tipoCalculo);
				nuevoCondicionante.setPorcentajeReserva(Double.valueOf(5));
				nuevoCondicionante.setImporteReserva(oferta.getImporteOferta() * (Double.valueOf(5) / 100));
			}

			if (!Checks.esNulo(oferta.getActivoPrincipal()) && !Checks.esNulo(oferta.getActivoPrincipal().getCartera())
					&& DDCartera.CODIGO_CARTERA_CAJAMAR.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
				nuevoCondicionante.setSolicitaReserva(1);
				DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoCalculo.class, DDTipoCalculo.TIPO_CALCULO_PORCENTAJE);
				nuevoCondicionante.setTipoCalculoReserva(tipoCalculo);
				nuevoCondicionante.setPorcentajeReserva(Double.valueOf(3));
				nuevoCondicionante.setImporteReserva(oferta.getImporteOferta() * (Double.valueOf(3) / 100));
				nuevoCondicionante.setPlazoFirmaReserva(5);
			}

			// HREOS-5392
			// Activos de Cerberus->Agora(Financiero, Inmobiliario) debe haber reserva por porcentaje del 10%
			if (DDCartera.CODIGO_CARTERA_CERBERUS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
				&& (DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())) ||
					(DDSubcartera.CODIGO_AGORA_FINANCIERO.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo()))
			&& (DDCartera.CODIGO_CARTERA_CERBERUS.equals(oferta.getActivoPrincipal().getCartera().getCodigo()) 
					&& DDSubcartera.CODIGO_ZEUS_INMOBILIARIO.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo()))){

				nuevoCondicionante.setSolicitaReserva(1);
				DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoCalculo.class, DDTipoCalculo.TIPO_CALCULO_PORCENTAJE);
				nuevoCondicionante.setTipoCalculoReserva(tipoCalculo);
				nuevoCondicionante.setPorcentajeReserva(new Double(10));
				nuevoCondicionante.setImporteReserva(oferta.getImporteOferta() * (Double.valueOf(10) / 100));
			}

			if(DDCartera.CODIGO_CARTERA_CERBERUS.equals(oferta.getActivoPrincipal().getCartera().getCodigo()) 
				&& (DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo()))) {
				if(oferta.getImporteOferta() >= 6000) {
					nuevoCondicionante.setSolicitaReserva(1);
					DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTipoCalculo.class, DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO);
					nuevoCondicionante.setTipoCalculoReserva(tipoCalculo);
					if (oferta.getImporteOferta() <= 50000) {
						nuevoCondicionante.setImporteReserva((Double.valueOf(1000)));
					} else {
						nuevoCondicionante.setImporteReserva((Double.valueOf(3000)));
					}
				} else {
					nuevoCondicionante.setSolicitaReserva(0);
				}
			}
		}

		Activo activo = oferta.getActivoPrincipal();

		if (activo.getSituacionPosesoria() != null && activo.getSituacionPosesoria().getFechaTomaPosesion() != null) {
			nuevoCondicionante.setPosesionInicial(1);
		} else {
			nuevoCondicionante.setPosesionInicial(0);
		}

		if (activo.getTitulo() != null && activo.getTitulo().getEstado() != null) {
			nuevoCondicionante.setEstadoTitulo(activo.getTitulo().getEstado());
		}

		if (activo.getSituacionPosesoria() != null) {
			if (activo.getSituacionPosesoria().getOcupado() != null
					&& activo.getSituacionPosesoria().getOcupado().equals(Integer.valueOf(0))) {
				DDSituacionesPosesoria situacionPosesoriaLibre = (DDSituacionesPosesoria) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSituacionesPosesoria.class,
								DDSituacionesPosesoria.SITUACION_POSESORIA_LIBRE);
				nuevoCondicionante.setSituacionPosesoria(situacionPosesoriaLibre);
			} else if (activo.getSituacionPosesoria().getOcupado() != null
					&& activo.getSituacionPosesoria().getOcupado().equals(Integer.valueOf(1))
					&& !Checks.esNulo(activo.getSituacionPosesoria().getConTitulo())
					&& activo.getSituacionPosesoria().getConTitulo().getCodigo().equals(DDTipoTituloActivoTPA.tipoTituloSi)) {
				DDSituacionesPosesoria situacionPosesoriaOcupadoTitulo = (DDSituacionesPosesoria) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSituacionesPosesoria.class,
								DDSituacionesPosesoria.SITUACION_POSESORIA_OCUPADO_CON_TITULO);
				nuevoCondicionante.setSituacionPosesoria(situacionPosesoriaOcupadoTitulo);
			} else if (activo.getSituacionPosesoria().getOcupado() != null
					&& activo.getSituacionPosesoria().getOcupado().equals(Integer.valueOf(1))
					&& activo.getSituacionPosesoria().getConTitulo() != null
					&& (activo.getSituacionPosesoria().getConTitulo().getCodigo().equals(DDTipoTituloActivoTPA.tipoTituloNo)
						|| activo.getSituacionPosesoria().getConTitulo().getCodigo().equals(DDTipoTituloActivoTPA.tipoTituloNoConIndicios))) {
				DDSituacionesPosesoria situacionPosesoriaOcupadoSinTitulo = (DDSituacionesPosesoria) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSituacionesPosesoria.class,
								DDSituacionesPosesoria.SITUACION_POSESORIA_OCUPADO_SIN_TITULO);
				nuevoCondicionante.setSituacionPosesoria(situacionPosesoriaOcupadoSinTitulo);
			}
		}

		boolean noCumple = false;
		List<ActivoOferta> activoOfertaList = oferta.getActivosOferta();
		List<TanteoActivoExpediente> tanteosExpediente = new ArrayList<TanteoActivoExpediente>();
		for (ActivoOferta activoOferta : activoOfertaList) {
			noCumple = false;
			for (CondicionTanteoApi condicion : condiciones) {
				if (!condicion.checkCondicion(activo))
					noCumple = true;
			}
			if (!noCumple) {
				TanteoActivoExpediente tanteoActivo = new TanteoActivoExpediente();
				tanteoActivo.setActivo(activoOferta.getPrimaryKey().getActivo());
				tanteoActivo.setExpediente(nuevoExpediente);

				Auditoria auditoria = new Auditoria();
				auditoria.setFechaCrear(new Date());
				auditoria.setUsuarioCrear(usuarioApi.getUsuarioLogado().getUsername());
				auditoria.setBorrado(false);

				tanteoActivo.setAuditoria(auditoria);
				DDAdministracion administracion = genericDao.get(DDAdministracion.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", "02"));
				tanteoActivo.setAdminitracion(administracion);
				nuevoCondicionante.setSujetoTanteoRetracto(1);
				tanteosExpediente.add(tanteoActivo);
			}
		}

		nuevoExpediente.setTanteoActivoExpediente(tanteosExpediente);
		nuevoExpediente.setCondicionante(nuevoCondicionante);

		// Establecer la fecha de aceptación/alta a ahora.
		nuevoExpediente.setFechaAlta(new Date());

		// HREOS-2511 El combo "Comité seleccionado" vendrá informado para
		// cartera Sareb
		if (DDCartera.CODIGO_CARTERA_SAREB.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
				|| DDCartera.CODIGO_CARTERA_TANGO.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
				|| DDCartera.CODIGO_CARTERA_GIANTS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
				|| DDCartera.CODIGO_CARTERA_CERBERUS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
			Double precioMinimoAutorizado = 0.0;
			ActivoBancario activoBancario = getActivoBancarioByIdActivo(oferta.getActivoPrincipal().getId());
			if (Checks.esNulo(oferta.getAgrupacion())) {
				if (!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getActivo())) {
					List<VPreciosVigentes> vPreciosVigentes = activoAdapter
							.getPreciosVigentesById(activoBancario.getActivo().getId());
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
								.getPreciosVigentesById(activoOferta.getId());
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

			boolean esFinanciero = false;
			if (!Checks.esNulo(activoBancario)) {
				if (!Checks.esNulo(activoBancario.getClaseActivo()) && activoBancario.getClaseActivo().getCodigo()
						.equals(DDClaseActivoBancario.CODIGO_FINANCIERO)) {
					esFinanciero = true;
				}

				if (DDCartera.CODIGO_CARTERA_TANGO.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
					nuevoExpediente.setComiteSancion(genericDao.get(DDComiteSancion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_TANGO)));
				} else if (DDCartera.CODIGO_CARTERA_GIANTS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
					nuevoExpediente.setComiteSancion(genericDao.get(DDComiteSancion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_GIANTS)));
				} else if (DDCartera.CODIGO_CARTERA_CERBERUS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
					if(DDSubcartera.CODIGO_AGORA_FINANCIERO.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())||
					DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo()))
					{
						nuevoExpediente.setComiteSancion(genericDao.get(DDComiteSancion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_CERBERUS)));
					}else if(DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())){
						nuevoExpediente.setComiteSancion(genericDao.get(DDComiteSancion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_APPLE_CERBERUS)));
					}else {
						nuevoExpediente.setComiteSancion(genericDao.get(DDComiteSancion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_CERBERUS)));
					}
				} else {
					// 1º Clase de activo (financiero/inmobiliario) y sin
					// formalización.
					if (esFinanciero && !Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getActivo())
							&& getPerimetroByIdActivo(activoBancario.getActivo().getId()).getAplicaFormalizar() == 0) {
						nuevoExpediente.setComiteSancion(genericDao.get(DDComiteSancion.class, genericDao
								.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_SAREB)));
						// 2º Si es inmobiliario: Tipo de comercialización
						// (singular/retail).
					} else if (!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getActivo())
							&& activoBancario.getActivo().getTipoComercializar() != null
							&& activoBancario.getActivo().getTipoComercializar().getCodigo()
									.equals(DDTipoComercializar.CODIGO_SINGULAR)) {
						nuevoExpediente.setComiteSancion(genericDao.get(DDComiteSancion.class,
								genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_SAREB)));
						// 3º Si es retail: Comparamos precio mínimo e importe
						// oferta.
					} else if (!Checks.esNulo(precioMinimoAutorizado)
							&& precioMinimoAutorizado > oferta.getImporteOferta()) {
						nuevoExpediente.setComiteSancion(genericDao.get(DDComiteSancion.class,
								genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_SAREB)));
					} else {
						nuevoExpediente.setComiteSancion(genericDao.get(DDComiteSancion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_SAREB)));
					}
				}
			}
		}

		// El combo "Comité seleccionado" vendrá informado para cartera
		// Liberbank
		else if (!Checks.esNulo(oferta.getActivoPrincipal()) && !Checks.esNulo(oferta.getActivoPrincipal().getCartera())
				&& DDCartera.CODIGO_CARTERA_LIBERBANK.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
				nuevoExpediente.setComiteSancion(ofertaApi.calculoComiteLiberbank(oferta));
				nuevoExpediente.setComitePropuesto(ofertaApi.calculoComiteLiberbank(oferta));
		}
		// El combo "Comité seleccionado" vendrá informado para cartera Cajamar
		else if (oferta.getActivoPrincipal().getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)) {
			nuevoExpediente.setComiteSancion(genericDao.get(DDComiteSancion.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_CAJAMAR)));
		}
		// El combo "Comité seleccionado" vendrá informado para cartera Galeon
		else if (oferta.getActivoPrincipal().getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_GALEON)) {
			nuevoExpediente.setComiteSancion(genericDao.get(DDComiteSancion.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_GALEON)));
		}
		// El combo "Comité seleccionado" vendrá informado para subcartera Zeus
		else if (oferta.getActivoPrincipal().getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_EGEO) 
				&& DDSubcartera.CODIGO_ZEUS.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())) {
			nuevoExpediente.setComiteSancion(genericDao.get(DDComiteSancion.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_HAYA_EGEO)));
		}
		else if (DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(oferta.getActivoPrincipal().getCartera().getCodigo()) 
				&& DDSubcartera.CODIGO_YUBAI.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())) {
			nuevoExpediente.setComiteSancion(genericDao.get(DDComiteSancion.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_THIRD_PARTIES_YUBAI)));
		}
		
		
		crearCompradores(oferta, nuevoExpediente);

		nuevoExpediente.setTipoAlquiler(oferta.getActivoPrincipal().getTipoAlquiler());

		nuevoExpediente = genericDao.save(ExpedienteComercial.class, nuevoExpediente);
		
		crearGastosExpediente(nuevoExpediente);

		// Se asigna un gestor de Formalización al crear un nuevo expediente.
		asignarGestorYSupervisorFormalizacionToExpediente(nuevoExpediente);

		return nuevoExpediente;
	}

	public boolean crearCompradores(Oferta oferta, ExpedienteComercial nuevoExpediente) {
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
			 * HREOS-3779 Problema al crear las relaciones entre
			 * comprador-expediente Desde webcom mandan clientes comerciales y
			 * titulares adiciones con el mismo documento para la misma oferta.
			 * Esto hace que en el listado de compradores se creen varios con la
			 * misma relacion comprador-expediente. Se ha añadido comprobacion
			 * en el metodo que crea la oferta desde webcom (webservice) pero
			 * hay muchos que ya estan creado, para estos creamos esta
			 * comprobacion. Quita del listado de titulares adicionales los que
			 * tengan el mismo documento que el cliente de la oferta
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
			if (!Checks.esNulo(cliente.getTipoPersona()) && DDTipoPersona.CODIGO_TIPO_PERSONA_JURIDICA
					.equals(cliente.getTipoPersona().getCodigo())) {
				compradorBusqueda.setNombre(cliente.getRazonSocial());
				compradorExpedienteNuevo.setNombreRepresentante(cliente.getNombre());
				compradorExpedienteNuevo.setApellidosRepresentante(cliente.getApellidos());
				compradorExpedienteNuevo
						.setTipoDocumentoRepresentante(cliente.getTipoDocumentoRepresentante());
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
				dir = cliente.getTipoVia().getCodigo()+" ";
			if (!Checks.esNulo(cliente.getDireccion()))
				dir = dir.concat(cliente.getDireccion());
			if (!Checks.esNulo(cliente.getNumeroCalle()))
				dir = dir.concat(" "+cliente.getNumeroCalle());
			if (!Checks.esNulo(cliente.getPuerta()))
				dir = dir.concat(", pta "+cliente.getPuerta());
			if (!Checks.esNulo(cliente.getPlanta()))
				dir = dir.concat(", plta "+cliente.getPlanta());
			if (!Checks.esNulo(cliente.getEscalera()))
				dir = dir.concat(", esc "+cliente.getEscalera());
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
			
			//CHECKS GDPR
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

			
			
			CompradorExpediente.CompradorExpedientePk pk = new CompradorExpediente.CompradorExpedientePk();
			pk.setComprador(compradorBusqueda);
			pk.setExpediente(nuevoExpediente);
			compradorExpedienteNuevo.setPrimaryKey(pk);
			compradorExpedienteNuevo.setTitularReserva(0);
			compradorExpedienteNuevo.setTitularContratacion(1);
			compradorExpedienteNuevo.setPorcionCompra(parteCompraPrincipal);
			compradorExpedienteNuevo.setBorrado(false);
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
					genericDao.createFilter(FilterType.EQUALS, "numDocumento", cliente.getDocumento())
					,genericDao.createFilter(FilterType.EQUALS, "tipoDocumento.codigo", cliente.getTipoDocumento().getCodigo()));
			
			if (clienteGDPR != null && !clienteGDPR.isEmpty()){
				compradorExpedienteNuevo.setDocumentoAdjunto(clienteGDPR.get(0).getAdjuntoComprador());
				compradorBusqueda.setAdjunto(clienteGDPR.get(0).getAdjuntoComprador());
			}
			
			genericDao.save(Comprador.class, compradorBusqueda);
			listaCompradoresExpediente.add(compradorExpedienteNuevo);
			
			// HREOS - 4937 - Historificando				
			ClienteCompradorGDPR clienteCompradorGDPR = new ClienteCompradorGDPR();
			clienteCompradorGDPR.setTipoDocumento(compradorBusqueda.getTipoDocumento());
			clienteCompradorGDPR.setNumDocumento(compradorBusqueda.getDocumento());
			if(!Checks.esNulo(clienteGDPR) && !clienteGDPR.isEmpty()){
				if (!Checks.esNulo(clienteGDPR.get(0).getCesionDatos())) {
					clienteCompradorGDPR.setCesionDatos(clienteGDPR.get(0).getCesionDatos());
				}
				if (!Checks.esNulo(clienteGDPR.get(0).getComunicacionTerceros())) {
					clienteCompradorGDPR.setComunicacionTerceros(clienteGDPR.get(0).getComunicacionTerceros());
				}
				if (!Checks.esNulo(clienteGDPR.get(0).getTransferenciasInternacionales())) {
					clienteCompradorGDPR.setTransferenciasInternacionales(clienteGDPR.get(0).getTransferenciasInternacionales());								
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
						compradorExpedienteNuevo.setDocumentoRepresentante(titularAdicional.getDocumentoRepresentante());

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
									
					//AGREGAR CHECKS DE TITULARES ADICIONALES
					if (!Checks.esNulo(titularAdicional)) {
						if (!Checks.esNulo(titularAdicional.getRechazarCesionDatosPropietario())) {
							compradorBusquedaAdicional.setCesionDatos(!titularAdicional.getRechazarCesionDatosPropietario());
						}
						if (!Checks.esNulo(titularAdicional.getRechazarCesionDatosProveedores())) {
							compradorBusquedaAdicional.setComunicacionTerceros(!titularAdicional.getRechazarCesionDatosProveedores());
						}
						if (!Checks.esNulo(titularAdicional.getRechazarCesionDatosPublicidad())) {
							compradorBusquedaAdicional.setTransferenciasInternacionales(!titularAdicional.getRechazarCesionDatosPublicidad());
						}
					}
					genericDao.save(Comprador.class, compradorBusquedaAdicional);
					
					CompradorExpediente compradorExpedienteAdicionalNuevo = new CompradorExpediente();
					pk = new CompradorExpedientePk();

					pk.setComprador(compradorBusquedaAdicional);
					pk.setExpediente(nuevoExpediente);
					compradorExpedienteAdicionalNuevo.setPrimaryKey(pk);
					compradorExpedienteAdicionalNuevo.setBorrado(false);
					compradorExpedienteAdicionalNuevo.setTitularReserva(1);
					compradorExpedienteAdicionalNuevo.setTitularContratacion(0);
					compradorExpedienteAdicionalNuevo.setPorcionCompra(parteCompraAdicionales);
					compradorExpedienteAdicionalNuevo.setEstadoCivil(titularAdicional.getEstadoCivil());
					compradorExpedienteAdicionalNuevo.setRegimenMatrimonial(titularAdicional.getRegimenMatrimonial());
					compradorExpedienteAdicionalNuevo.setTipoDocumentoConyuge(titularAdicional.getTipoDocumentoConyuge());
					compradorExpedienteAdicionalNuevo.setDocumentoConyuge(titularAdicional.getDocumentoConyuge());
					compradorExpedienteAdicionalNuevo.setPais(titularAdicional.getPais());
					compradorExpedienteAdicionalNuevo.setDireccionRepresentante(titularAdicional.getDireccionRepresentante());
					compradorExpedienteAdicionalNuevo.setProvinciaRepresentante(titularAdicional.getProvinciaRepresentante());
					compradorExpedienteAdicionalNuevo.setLocalidadRepresentante(titularAdicional.getMunicipioRepresentante());
					compradorExpedienteAdicionalNuevo.setPaisRte(titularAdicional.getPaisRepresentante());
					compradorExpedienteAdicionalNuevo.setCodigoPostalRepresentante(titularAdicional.getCodPostalRepresentante());
					
					clienteGDPR = genericDao.getList(ClienteGDPR.class,
							genericDao.createFilter(FilterType.EQUALS, "numDocumento", titularAdicional.getDocumento())
							,genericDao.createFilter(FilterType.EQUALS, "tipoDocumento.codigo", titularAdicional.getTipoDocumento().getCodigo()));
					
					if (!Checks.esNulo(clienteGDPR) && !clienteGDPR.isEmpty()){
						compradorExpedienteNuevo.setDocumentoAdjunto(clienteGDPR.get(0).getAdjuntoComprador());
					}
					
					listaCompradoresExpediente.add(compradorExpedienteAdicionalNuevo);
					
					// HREOS - 4937 - Historificando				
					clienteCompradorGDPR = new ClienteCompradorGDPR();
					clienteCompradorGDPR.setTipoDocumento(compradorBusquedaAdicional.getTipoDocumento());
					clienteCompradorGDPR.setNumDocumento(compradorBusquedaAdicional.getDocumento());
					if(!Checks.esNulo(clienteGDPR) && !clienteGDPR.isEmpty()){
						if (!Checks.esNulo(clienteGDPR.get(0).getCesionDatos())) {
							clienteCompradorGDPR.setCesionDatos(clienteGDPR.get(0).getCesionDatos());
						}
						if (!Checks.esNulo(clienteGDPR.get(0).getComunicacionTerceros())) {
							clienteCompradorGDPR.setComunicacionTerceros(clienteGDPR.get(0).getComunicacionTerceros());
						}
						if (!Checks.esNulo(clienteGDPR.get(0).getTransferenciasInternacionales())) {
							clienteCompradorGDPR.setTransferenciasInternacionales(clienteGDPR.get(0).getTransferenciasInternacionales());								
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

			return true;
		}

		return false;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.saveActivoValoracion")
	@Transactional(readOnly = false)
	public boolean saveActivoValoracion(Activo activo, ActivoValoraciones activoValoracion, DtoPrecioVigente dto) {
		try {
			// Actualizacion Valoracion existente
			if (!Checks.esNulo(activoValoracion)) {
				// Si ya existia una valoracion, actualizamos los datos
				// Pero antes, pasa la valoracion anterior al historico si se ha
				// modificado el precio o las fechas.

				if ((!Checks.esNulo(dto.getFechaFin()) && !dto.getFechaFin().equals(activoValoracion.getFechaFin()))
						|| (!Checks.esNulo(activoValoracion.getFechaFin()) && Checks.esNulo(dto.getFechaFin()))
						|| (!Checks.esNulo(dto.getFechaInicio())
								&& !dto.getFechaInicio().equals(activoValoracion.getFechaInicio()))
						|| (!Checks.esNulo(dto.getImporte())
								&& !dto.getImporte().equals(activoValoracion.getImporte()))) {
					saveActivoValoracionHistorico(activoValoracion);
				}

				beanUtilNotNull.copyProperties(activoValoracion, dto);

				activoValoracion.setFechaCarga(new Date());

				// Si los nuevos datos no traen observaciones (null), debe
				// quitar las escritas para el precio o valoracion anterior

				activoValoracion.setGestor(adapter.getUsuarioLogado());
				
				
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoValoracion.getActivo().getId());
				ActivoPublicacion activoPublicacion = genericDao.get(ActivoPublicacion.class,filtro);
				
				if(dto.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA) 
						|| dto.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO) 
						||dto.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_DESC_APROBADO) 
						||dto.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO)){
					activoPublicacion.setFechaCambioValorVenta(new Date());
					
				}
				
				if(dto.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA)){
					activoPublicacion.setFechaCambioValorAlq(new Date());
				}

				genericDao.update(ActivoValoraciones.class, activoValoracion);
				genericDao.update(ActivoPublicacion.class,activoPublicacion);

			} else {
				// Si no existia una valoracion del tipo indicado, crea una
				// nueva valoracion de este tipo (para un activo)
				activoValoracion = new ActivoValoraciones();
				beanUtilNotNull.copyProperties(activoValoracion, dto);
				activoValoracion.setFechaCarga(new Date());

				DDTipoPrecio tipoPrecio = (DDTipoPrecio) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoPrecio.class, dto.getCodigoTipoPrecio());

				activoValoracion.setActivo(activo);
				activoValoracion.setTipoPrecio(tipoPrecio);
				activoValoracion.setGestor(adapter.getUsuarioLogado());
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoValoracion.getActivo().getId());
				ActivoPublicacion activoPublicacion = genericDao.get(ActivoPublicacion.class,filtro);
				if(dto.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA) 
						|| dto.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO) 
						||dto.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_DESC_APROBADO) 
						||dto.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO)){
					activoPublicacion.setFechaCambioValorVenta(new Date());
					
				}
				if(dto.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA)){
					activoPublicacion.setFechaCambioValorAlq(new Date());
				}

				genericDao.save(ActivoValoraciones.class, activoValoracion);
				genericDao.update(ActivoPublicacion.class,activoPublicacion);
			}

			if (DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(dto.getCodigoTipoPrecio())) {
				// Actualizar el tipoComercialización del activo
				updaterState.updaterStateTipoComercializacion(activo);
			}			

		} catch (Exception ex) {
			logger.error("Error en activoManager", ex);
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	private boolean saveActivoValoracionHistorico(ActivoValoraciones activoValoracion) {
		ActivoHistoricoValoraciones historicoValoracion = new ActivoHistoricoValoraciones();

		historicoValoracion.setActivo(activoValoracion.getActivo());
		historicoValoracion.setTipoPrecio(activoValoracion.getTipoPrecio());
		historicoValoracion.setImporte(activoValoracion.getImporte());
		historicoValoracion.setFechaInicio(activoValoracion.getFechaInicio());
		historicoValoracion.setFechaFin(activoValoracion.getFechaFin());
		historicoValoracion.setFechaAprobacion(activoValoracion.getFechaAprobacion());
		historicoValoracion.setFechaCarga(
				(!Checks.esNulo(activoValoracion.getFechaCarga()) ? activoValoracion.getFechaCarga() : new Date()));
		historicoValoracion.setGestor(activoValoracion.getGestor());
		historicoValoracion.setObservaciones(activoValoracion.getObservaciones());

		genericDao.save(ActivoHistoricoValoraciones.class, historicoValoracion);
		
		return true;
	}
	@Transactional(readOnly = false)
	public boolean saveActValFechaUltCambioPrecio(ActivoValoraciones actVal) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", actVal.getActivo().getId());
		ActivoPublicacion activoPublicacion = genericDao.get(ActivoPublicacion.class, filtro);
		
		if(actVal.getTipoPrecio().getCodigo().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA) 
				|| actVal.getTipoPrecio().getCodigo().equals(DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO) 
				||actVal.getTipoPrecio().getCodigo().equals(DDTipoPrecio.CODIGO_TPC_DESC_APROBADO) 
				||actVal.getTipoPrecio().getCodigo().equals(DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO)){
			activoPublicacion.setFechaCambioValorVenta(new Date());
			
		}
		if(actVal.getTipoPrecio().getCodigo().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA)){
			activoPublicacion.setFechaCambioValorAlq(new Date());
		}

		return true;
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public boolean deleteValoracionPrecioConGuardadoEnHistorico(Long id, Boolean guardadoEnHistorico,  Boolean comprobarGestor) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoValoraciones activoValoracion = genericDao.get(ActivoValoraciones.class, filtro);

		Filter filtroUsuarioGrupoPrecio = genericDao.createFilter(FilterType.EQUALS, "username", "usugrupre");
		Filter filtroUsuarioGrupoPrecioBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Usuario grupoPrecio = genericDao.get(Usuario.class, filtroUsuarioGrupoPrecio, filtroUsuarioGrupoPrecioBorrado);

		Filter filtroUsuarioGrupoPublicacion = genericDao.createFilter(FilterType.EQUALS, "username", "usugrupub");
		Filter filtroUsuarioGrupoPublicacionBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado",
				false);
		Usuario grupoPublicacion = genericDao.get(Usuario.class, filtroUsuarioGrupoPublicacion,
				filtroUsuarioGrupoPublicacionBorrado);

		if (guardadoEnHistorico && activoDao.deleteValoracionSinDuplicarById(id)) {
			saveActivoValoracionHistorico(activoValoracion);
			saveActValFechaUltCambioPrecio(activoValoracion);

		} else if (!Checks.esNulo(activoValoracion.getGestor())
				&& !adapter.getUsuarioLogado().getUsername().equals(activoValoracion.getGestor().getUsername())
				&& !eXTGrupoUsuariosApi.usuarioPerteneceAGrupo(adapter.getUsuarioLogado(), grupoPrecio)
				&& !eXTGrupoUsuariosApi.usuarioPerteneceAGrupo(adapter.getUsuarioLogado(), grupoPublicacion)) {
			// Si el usuario de la sesión es distinto al que ha creado la
			// valoración, no puede borrarla sin histórico.
			return false;
		} else {
			// Al anular el precio vigente, se hace un borrado lógico, y no se
			// inserta en el histórico.
			genericDao.deleteById(ActivoValoraciones.class, id);
			saveActValFechaUltCambioPrecio(activoValoracion);
		}

		if (activoValoracion != null && activoValoracion.getActivo() != null) {
			activoAdapter.actualizarEstadoPublicacionActivo(activoValoracion.getActivo().getId());
		}

		return true;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.upload")
	@Transactional(readOnly = false)
	public String upload(WebFileItem webFileItem) throws Exception {
		return upload2(webFileItem, null);
	}

	@Override
	@BusinessOperation(overrides = "activoManager.uploadDocumento")
	@Transactional(readOnly = false)
	public String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, Activo activoEntrada, String matricula)
			throws UserException {
		Activo activo;
		DDTipoDocumentoActivo tipoDocumento = null;
		if (Checks.esNulo(activoEntrada)) {
			activo = get(Long.parseLong(webFileItem.getParameter("idEntidad")));

			if (webFileItem.getParameter("tipo") == null)
				throw new UserException("Tipo no valido");

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
			tipoDocumento = genericDao.get(DDTipoDocumentoActivo.class, filtro);

		} else {
			activo = activoEntrada;
			if (!Checks.esNulo(matricula)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
				tipoDocumento = genericDao.get(DDTipoDocumentoActivo.class, filtro);
			}
			if (tipoDocumento == null) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
				tipoDocumento = genericDao.get(DDTipoDocumentoActivo.class, filtro);
			}
		}

		try {
			if (!Checks.esNulo(activo) && !Checks.esNulo(tipoDocumento)) {

				Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());

				ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo();
				adjuntoActivo.setAdjunto(adj);
				adjuntoActivo.setActivo(activo);
				adjuntoActivo.setIdDocRestClient(idDocRestClient);
				adjuntoActivo.setTipoDocumentoActivo(tipoDocumento);
				adjuntoActivo.setContentType(webFileItem.getFileItem().getContentType());
				adjuntoActivo.setTamanyo(webFileItem.getFileItem().getLength());
				adjuntoActivo.setNombre(webFileItem.getFileItem().getFileName());
				adjuntoActivo.setDescripcion(webFileItem.getParameter("descripcion"));
				adjuntoActivo.setFechaDocumento(new Date());

				Auditoria.save(adjuntoActivo);

				activo.getAdjuntos().add(adjuntoActivo);

				activoDao.save(activo);
			} else {
				throw new UserException("No se ha encontrado activo o tipo para relacionar adjunto");
			}

		} catch (Exception e) {
			logger.error("Error en activoManager", e);
		}

		return null;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.upload2")
	@Transactional(readOnly = false)
	public String upload2(WebFileItem webFileItem, Long idDocRestClient) throws Exception {
		return uploadDocumento(webFileItem, idDocRestClient, null, null);
	}

	@Override
	@Transactional(readOnly = false)
	public String uploadFoto(File fileItem) throws Exception {
		try {
			if (fileItem.getMetadata().get("id_activo_haya") == null) {
				throw new Exception("La foto no tiene activo");
			}

			if (fileItem.getMetadata().get("tipo") == null) {
				throw new Exception("La foto no tiene tipo");
			}

			Long numActivo = Long.valueOf(fileItem.getMetadata().get("id_activo_haya"));
			Activo activo = this.getByNumActivo(numActivo);

			if (activo != null) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
						fileItem.getMetadata().get("tipo"));
				DDTipoFoto tipoFoto = genericDao.get(DDTipoFoto.class, filtro);
				if (tipoFoto == null) {
					throw new Exception("El tipo no existe");
				}
				Integer orden = null;
				ActivoFoto activoFoto = activoAdapter.getFotoActivoByRemoteId(fileItem.getId());
				if (activoFoto == null) {
					activoFoto = new ActivoFoto(fileItem);
				}

				if (activoFoto.getOrden() == null) {
					orden = activoDao.getMaxOrdenFotoById(activo.getId()) + 1;

				} else {
					orden = activoFoto.getOrden();
				}

				activoFoto.setActivo(activo);
				activoFoto.setTipoFoto(tipoFoto);
				activoFoto.setNombre(fileItem.getBasename());

				if (fileItem.getMetadata().containsKey("descripcion")) {
					activoFoto.setDescripcion(fileItem.getMetadata().get("descripcion"));
				}

				if (fileItem.getMetadata().containsKey("principal") && fileItem.getMetadata().get("principal") != null
						&& fileItem.getMetadata().get("principal").equals("1")) {
					activoFoto.setPrincipal(true);
				} else {
					activoFoto.setPrincipal(false);
				}

				Date fechaSubida = new Date();
				if (fileItem.getMetadata().containsKey("fecha_subida")) {
					try {
						fechaSubida = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
								.parse(fileItem.getMetadata().get("fecha_subida"));

					} catch (Exception e) {
						logger.error("El webservice del Gestor documental ha enviado una fecha sin formato");
					}
				}

				activoFoto.setFechaDocumento(fechaSubida);

				if (fileItem.getMetadata().containsKey("interior_exterior")
						&& fileItem.getMetadata().get("interior_exterior") != null) {
					if (fileItem.getMetadata().get("interior_exterior").equals("1")) {
						activoFoto.setInteriorExterior(Boolean.TRUE);
					} else {
						activoFoto.setInteriorExterior(Boolean.FALSE);
					}
				}

				activoFoto.setOrden(orden);
				genericDao.save(ActivoFoto.class, activoFoto);

				logger.debug("Foto procesada para el activo " + activo.getNumActivo());

			} else {
				logger.debug("No existe la unidad organizativa");
			}

		} catch (Exception e) {
			logger.error("Error insertando/actualizando foto", e);
			throw e;
		}

		return null;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.uploadFoto")
	@Transactional(readOnly = false)
	public String uploadFoto(WebFileItem fileItem) {
		Activo activo = this.get(Long.parseLong(fileItem.getParameter("idEntidad")));
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
		DDTipoFoto tipoFoto = genericDao.get(DDTipoFoto.class, filtro);
		TIPO tipo = null;
		FileResponse fileReponse;
		ActivoFoto activoFoto;
		SITUACION situacion;
		PRINCIPAL principal;
		Integer orden = activoDao.getMaxOrdenFotoById(Long.parseLong(fileItem.getParameter("idEntidad")));
		orden++;

		try {
			if (gestorDocumentalFotos.isActive()) {
				if (tipoFoto.getCodigo().equals("01")) {
					tipo = TIPO.WEB;

				} else if (tipoFoto.getCodigo().equals("02")) {
					tipo = TIPO.TECNICA;

				} else if (tipoFoto.getCodigo().equals("03")) {
					tipo = TIPO.TESTIGO;
				}

				if (Boolean.valueOf(fileItem.getParameter("principal"))) {
					principal = PRINCIPAL.SI;

				} else {
					principal = PRINCIPAL.NO;
				}

				if (Boolean.valueOf(fileItem.getParameter("interiorExterior"))) {
					situacion = SITUACION.INTERIOR;

				} else {
					situacion = SITUACION.EXTERIOR;
				}

				fileReponse = gestorDocumentalFotos.upload(fileItem.getFileItem().getFile(),
						fileItem.getFileItem().getFileName(), PROPIEDAD.ACTIVO, activo.getNumActivo(), tipo,
						fileItem.getParameter("descripcion"), principal, situacion, orden);
				activoFoto = new ActivoFoto(fileReponse.getData());

			} else {
				activoFoto = new ActivoFoto(fileItem.getFileItem());
			}

			activoFoto.setActivo(activo);
			activoFoto.setTipoFoto(tipoFoto);
			activoFoto.setTamanyo(fileItem.getFileItem().getLength());
			activoFoto.setNombre(fileItem.getFileItem().getFileName());
			activoFoto.setDescripcion(fileItem.getParameter("descripcion"));
			activoFoto.setPrincipal(Boolean.valueOf(fileItem.getParameter("principal")));
			activoFoto.setFechaDocumento(new Date());
			activoFoto.setInteriorExterior(Boolean.valueOf(fileItem.getParameter("interiorExterior")));
			activoFoto.setOrden(orden);

			Auditoria.save(activoFoto);

			activo.getFotos().add(activoFoto);

			activoDao.save(activo);

		} catch (Exception e) {
			logger.error("Error en activoManager", e);
		}

		return null;
	}

	@Override
	@BusinessOperationDefinition("activoManager.download")
	public FileItem download(Long id) throws Exception {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoAdjuntoActivo adjuntoActivo = genericDao.get(ActivoAdjuntoActivo.class, filter);

		return adjuntoActivo.getAdjunto().getFileItem();
	}

	@Override
	@BusinessOperationDefinition("activoManager.getComboInferiorMunicipio")
	public List<DDUnidadPoblacional> getComboInferiorMunicipio(String codigoMunicipio) {
		return activoDao.getComboInferiorMunicipio(codigoMunicipio);
	}

	@Override
	@BusinessOperationDefinition("activoManager.getMaxOrdenFotoById")
	public Integer getMaxOrdenFotoById(Long id) {
		return activoDao.getMaxOrdenFotoById(id);
	}

	@Override
	@BusinessOperationDefinition("activoManager.getMaxOrdenFotoByIdSubdivision")
	public Integer getMaxOrdenFotoByIdSubdivision(Long idEntidad, BigDecimal hashSdv) {
		return activoDao.getMaxOrdenFotoByIdSubdivision(idEntidad, hashSdv);
	}

	@Override
	@BusinessOperationDefinition("activoManager.getUltimoPresupuesto")
	public Long getPresupuestoActual(Long id) {
		return activoDao.getPresupuestoActual(id);
	}

	@BusinessOperationDefinition("activoManager.getUltimoHistoricoPresupuesto")
	public Long getUltimoHistoricoPresupuesto(Long id) {
		return activoDao.getUltimoHistoricoPresupuesto(id);
	}

	@BusinessOperationDefinition("activoManager.checkHayPresupuestoEjercicioActual")
	public boolean checkHayPresupuestoEjercicioActual(Long idActivo) {
		if(activoDao.isUnidadAlquilable(idActivo)) {
			ActivoAgrupacion actagr = activoDao.getAgrupacionPAByIdActivo(idActivo);
			idActivo = activoDao.getIdActivoMatriz(actagr.getId());
			
		}
		return !Checks.esNulo(activoDao.getPresupuestoActual(idActivo));
	}

	@SuppressWarnings("deprecation")
	@BusinessOperationDefinition("activoManager.comprobarPestanaCheckingInformacion")
	public Boolean comprobarPestanaCheckingInformacion(Long idActivo) {
		Activo activo = this.get(idActivo);
		return !Checks.esNulo(activo.getTipoActivo()) && !Checks.esNulo(activo.getSubtipoActivo()) && !Checks.esNulo(activo.getDivHorizontal()) && !Checks.esNulo(activo.getGestionHre()) && !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getTipoVia()) && !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getNombreVia()) && !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getCodPostal()) && !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getLocalidad()) && !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getPoblacion()) && !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getPais()) && !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getLocalidad()) && !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro()) && !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getNumFinca()) && !Checks.esNulo(activo.getVpo()) && !Checks.esNulo(activo.getOrigen()) && !Checks.esNulo(activo.getPropietariosActivo()) && comprobarPropietario(activo.getPropietariosActivo()) && !Checks.esNulo(activo.getCatastro()) && comprobarCatastro(activo.getCatastro());
	}

	@Override
	@BusinessOperationDefinition("activoManager.comprobarExisteAdjuntoActivo")
	public Boolean comprobarExisteAdjuntoActivo(Long idActivo, String codigoDocumento) {
		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter codigoDocumentoFilter = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo.codigo",
				codigoDocumento);

		List<ActivoAdjuntoActivo> adjuntosActivo = genericDao.getList(ActivoAdjuntoActivo.class, idActivoFilter,
				codigoDocumentoFilter);

		return !Checks.estaVacio(adjuntosActivo);
	}

	@Override
	@BusinessOperationDefinition("activoManager.comprobarExisteAdjuntoActivoTarea")
	public Boolean comprobarExisteAdjuntoActivoTarea(TareaExterna tarea) {
		Trabajo trabajo = trabajoApi.getTrabajoByTareaExterna(tarea);

		return comprobarExisteAdjuntoActivo(trabajo.getActivo().getId(),
				diccionarioTargetClassMap.getTipoDocumento(trabajo.getSubtipoTrabajo().getCodigo()));
	}

	private Boolean comprobarPropietario(List<ActivoPropietarioActivo> listadoPropietario) {
		for (ActivoPropietarioActivo propietario : listadoPropietario) {
			if (Checks.esNulo(propietario.getPropietario()) || Checks.esNulo(propietario.getPorcPropiedad())
					|| Checks.esNulo(propietario.getTipoGradoPropiedad()))
				return false;
		}

		return true;
	}

	private Boolean comprobarCatastro(List<ActivoCatastro> listadoCatastro) {
		for (ActivoCatastro catastro : listadoCatastro) {
			if (Checks.esNulo(catastro.getRefCatastral()))
				return false;
		}

		return true;
	}

	/**
	 * Devuelve TRUE si el activo tiene fecha de posesión
	 *
	 * @param idActivo
	 *            identificador del Activo
	 * @return boolean
	 */
	@Override
	@BusinessOperationDefinition("activoManager.comprobarExisteFechaPosesionActivo")
	public Boolean comprobarExisteFechaPosesionActivo(Long idActivo) throws Exception {
		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);

		ActivoSituacionPosesoria situacionPosesoriaActivo = genericDao
				.get(ActivoSituacionPosesoria.class, idActivoFilter);

		return !Checks.esNulo(situacionPosesoriaActivo) && !Checks.esNulo(situacionPosesoriaActivo.getFechaTomaPosesion());

	}

	/**
	 * Sirve para comprobar si el activo está vendido
	 */
	public Boolean isVendido(Long idActivo) {
		Activo activo = get(idActivo);

		return DDSituacionComercial.CODIGO_VENDIDO.equals(activo.getSituacionComercial().getCodigo());
	}

	/**
	 * Devuelve mensaje de validación indicando los campos obligatorios que no
	 * han sido informados en la pestaña "Checking Información"
	 *
	 * @param idActivo
	 *            identificador del Activo
	 * @return String
	 */
	@SuppressWarnings("unused")
	@Override
	@BusinessOperationDefinition("activoManager.comprobarObligatoriosCheckingInfoActivo")
	public String comprobarObligatoriosCheckingInfoActivo(Long idActivo) throws Exception {

		String mensaje = "";
		final Integer CODIGO_INSCRITA = 1;
		final Integer CODIGO_NO_INSCRITA = 0;

		Activo activo = get(idActivo);

		DtoActivoDatosRegistrales activoDatosRegistrales = (DtoActivoDatosRegistrales) tabActivoFactory
				.getService(TabActivoService.TAB_DATOS_REGISTRALES).getTabData(activo);
		DtoActivoFichaCabecera activoCabecera = (DtoActivoFichaCabecera) tabActivoFactory
				.getService(TabActivoService.TAB_DATOS_BASICOS).getTabData(activo);

		// Validaciones datos obligatorios correspondientes a datos registrales
		// del activo
		if (!Checks.esNulo(activoDatosRegistrales)) {
			if (DDTipoTituloActivo.tipoTituloJudicial.equals(activoDatosRegistrales.getTipoTituloCodigo())) {
				// Solo para Activos que tengan una titulación de tipo judicial,
				// se valida
				// Valida obligatorio: Tipo Juzgado
				if (Checks.esNulo(activoDatosRegistrales.getTipoJuzgadoCodigo())) {
					mensaje = mensaje.concat(messageServices
							.getMessage("tramite.admision.CheckingInformacion.validacionPre.tipoJuzgado"));
				}

				// Valida obligatorio: Poblacion Juzgado
				if (Checks.esNulo(activoDatosRegistrales.getTipoPlazaCodigo())) {
					mensaje = mensaje.concat(messageServices
							.getMessage("tramite.admision.CheckingInformacion.validacionPre.poblacionJuzgado"));
				}
			}

			if (CODIGO_NO_INSCRITA.equals(activoDatosRegistrales.getDivHorInscrito())) {
				// EstadoDivHorizonal no inscrita: Estado si no inscrita
				if (Checks.esNulo(activoDatosRegistrales.getEstadoDivHorizontalCodigo())) {
					mensaje = mensaje.concat(messageServices
							.getMessage("tramite.admision.CheckingInformacion.validacionPre.estadoNoInscrito"));
				}
			}
		}

		// Validaciones datos obligatorios correspondientes a cabecera del
		// activo
		if (!Checks.esNulo(activoCabecera)) {
			// Validación longitud Codigo Postal
			if (!Checks.esNulo(activoCabecera.getCodPostal()) && activoCabecera.getCodPostal().length() < 5) {
				mensaje = mensaje.concat(
						messageServices.getMessage("tramite.admision.CheckingInformacion.validacionPre.codPostal"));
			}
		}

		if (!Checks.esNulo(mensaje)) {
			mensaje = messageServices.getMessage("tramite.admision.CheckingInformacion.validacionPre.debeInformar")
					.concat(mensaje);
		}

		return mensaje;
	}

	private Activo tareaExternaToActivo(TareaExterna tareaExterna) {
		Activo activo = null;
		Trabajo trabajo = trabajoApi.tareaExternaToTrabajo(tareaExterna);

		if (!Checks.esNulo(trabajo)) {
			activo = trabajo.getActivo();

		} else {
			TareaActivo tareaActivo = tareaActivoManager.getByIdTareaExterna(tareaExterna.getId());
			activo = tareaActivo.getTramite().getActivo();
		}

		return activo;
	}

	public Boolean checkAdmisionAndGestion(TareaExterna tareaExterna) {
		Boolean resultado = false;
		Activo activo = tareaExternaToActivo(tareaExterna);
		if (activo != null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", activo.getId());
			VBusquedaPublicacionActivo publicacionActivo = genericDao.get(VBusquedaPublicacionActivo.class, filtro);
			if (publicacionActivo != null) {
				resultado = (publicacionActivo.getAdmision() && publicacionActivo.getGestion());
			}
		}
		return resultado;
	}

	@Override
	public VCondicionantesDisponibilidad getCondicionantesDisponibilidad(Long idActivo) {
		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo);
		return genericDao.get(VCondicionantesDisponibilidad.class, idActivoFilter);
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean saveCondicionantesDisponibilidad(Long idActivo,
			DtoCondicionantesDisponibilidad dtoCondicionanteDisponibilidad) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		ActivoSituacionPosesoria condicionantesDisponibilidad = genericDao.get(ActivoSituacionPosesoria.class, filtro);

		condicionantesDisponibilidad.setOtro(dtoCondicionanteDisponibilidad.getOtro());
		condicionantesDisponibilidad.setComboOtro(dtoCondicionanteDisponibilidad.getComboOtro());
		
		genericDao.save(ActivoSituacionPosesoria.class, condicionantesDisponibilidad);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean updateCondicionantesDisponibilidad(Long idActivo) {
		// Actualizar estado disponibilidad comercial. Se realiza despues de
		// haber guardado el cambio en los estados condicionantes.
		Activo activo = activoDao.get(idActivo);
		updaterState.updaterStateDisponibilidadComercial(activo);

		return true;
	}

	@Override
	public List<DtoCondicionEspecifica> getCondicionEspecificaByActivo(Long idActivo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.DESC, "id");
		List<ActivoCondicionEspecifica> listaCondicionesEspecificas = genericDao
				.getListOrdered(ActivoCondicionEspecifica.class, order, filtro);

		List<DtoCondicionEspecifica> listaDtoCondicionesEspecificas = new ArrayList<DtoCondicionEspecifica>();

		for (ActivoCondicionEspecifica condicion : listaCondicionesEspecificas) {
			DtoCondicionEspecifica dtoCondicionEspecifica = new DtoCondicionEspecifica();
			try {
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "id", condicion.getId());
				if (!Checks.esNulo(condicion.getActivo())) {
					beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "idActivo", condicion.getActivo().getId());
				}
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "texto", condicion.getTexto());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "fechaDesde", condicion.getFechaDesde());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "fechaHasta", condicion.getFechaHasta());
				if (!Checks.esNulo(condicion.getUsuarioAlta())) {
					beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "usuarioAlta",
							condicion.getUsuarioAlta().getUsername());
				}
				if (!Checks.esNulo(condicion.getUsuarioBaja())) {
					beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "usuarioBaja",
							condicion.getUsuarioBaja().getUsername());
				}
				if(!Checks.esNulo(condicion.getCodigo())){
					beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "codigo", condicion.getCodigo());
				}

			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager", e);

			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager", e);
			}

			listaDtoCondicionesEspecificas.add(dtoCondicionEspecifica);
		}

		return listaDtoCondicionesEspecificas;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean createCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica) {
		ActivoCondicionEspecifica condicionEspecifica = new ActivoCondicionEspecifica();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoCondicionEspecifica.getIdActivo());
		
		SimpleDateFormat sdf = new SimpleDateFormat("YYYYMMddhhmmss");
		
		int i = 0;
		
		String codigo = null;
		
		Filter filtro2 = null;
		
		if(!Checks.esNulo(dtoCondicionEspecifica.getCodigo())) {
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "activo.id", dtoCondicionEspecifica.getIdActivo());
			Order order = new Order(OrderType.DESC, "id");
			List<ActivoCondicionEspecifica> listaCondicionesEspecificas = genericDao
					.getListOrdered(ActivoCondicionEspecifica.class, order, filter);
			
			
			int coincidencia = 0;
			
			for (ActivoCondicionEspecifica condicion : listaCondicionesEspecificas) {
				
				if(dtoCondicionEspecifica.getCodigo().equals(condicion.getCodigo())) {
					if(!Checks.esNulo(dtoCondicionEspecifica.getTexto())) {
						condicion.setTexto(dtoCondicionEspecifica.getTexto());
					}
					if(!Checks.esNulo(dtoCondicionEspecifica.getFechaDesde())) {
						condicion.setFechaDesde(dtoCondicionEspecifica.getFechaDesde());
					}
					if(!Checks.esNulo(dtoCondicionEspecifica.getFechaHasta())) {
						condicion.setFechaHasta(dtoCondicionEspecifica.getFechaHasta());
					}
					condicion.setUsuarioAlta(adapter.getUsuarioLogado());
					condicion.setUsuarioBaja(adapter.getUsuarioLogado());
					
					coincidencia = 1;
					
					genericDao.save(ActivoCondicionEspecifica.class, condicion);
					
					return true;
				}
			}
			
			if(coincidencia == 0) {
				Activo activo = genericDao.get(Activo.class, filtro);
				
				try {
					beanUtilNotNull.copyProperty(condicionEspecifica, "texto", dtoCondicionEspecifica.getTexto());
					beanUtilNotNull.copyProperty(condicionEspecifica, "fechaDesde", new Date());
					beanUtilNotNull.copyProperty(condicionEspecifica, "usuarioAlta", adapter.getUsuarioLogado());
					beanUtilNotNull.copyProperty(condicionEspecifica, "codigo", dtoCondicionEspecifica.getCodigo());
					beanUtilNotNull.copyProperty(condicionEspecifica, "activo", activo);
					
					// Actualizar la fehca de la anterior condición.
					ActivoCondicionEspecifica condicionAnterior = activoDao
							.getUltimaCondicion(dtoCondicionEspecifica.getIdActivo());
					if (!Checks.esNulo(condicionAnterior)) {
						beanUtilNotNull.copyProperty(condicionAnterior, "fechaHasta", new Date());
						condicionAnterior.setUsuarioBaja(adapter.getUsuarioLogado());
						genericDao.save(ActivoCondicionEspecifica.class, condicionAnterior);
					}
					
				} catch (IllegalAccessException e) {
					logger.error("Error en activoManager", e);
					
				} catch (InvocationTargetException e) {
					logger.error("Error en activoManager", e);
				}
				
				genericDao.save(ActivoCondicionEspecifica.class, condicionEspecifica);
				
				return true;
			}
		}
		
		do {
			codigo = dtoCondicionEspecifica.getIdActivo().toString() + sdf.format(new Date())+i;
			filtro2 = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
			condicionEspecifica = genericDao.get(ActivoCondicionEspecifica.class, filtro2);
			i++;
		}while(!Checks.esNulo(condicionEspecifica));
		
		Activo activo = genericDao.get(Activo.class, filtro);
		
		condicionEspecifica = new ActivoCondicionEspecifica();

		try {
			beanUtilNotNull.copyProperty(condicionEspecifica, "texto", dtoCondicionEspecifica.getTexto());
			beanUtilNotNull.copyProperty(condicionEspecifica, "fechaDesde", new Date());
			beanUtilNotNull.copyProperty(condicionEspecifica, "usuarioAlta", adapter.getUsuarioLogado());
			beanUtilNotNull.copyProperty(condicionEspecifica, "codigo", codigo);
			beanUtilNotNull.copyProperty(condicionEspecifica, "activo", activo);

			// Actualizar la fehca de la anterior condición.
			ActivoCondicionEspecifica condicionAnterior = activoDao
					.getUltimaCondicion(dtoCondicionEspecifica.getIdActivo());
			if (!Checks.esNulo(condicionAnterior)) {
				beanUtilNotNull.copyProperty(condicionAnterior, "fechaHasta", new Date());
				condicionAnterior.setUsuarioBaja(adapter.getUsuarioLogado());
				genericDao.save(ActivoCondicionEspecifica.class, condicionAnterior);
			}

		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
		}

		genericDao.save(ActivoCondicionEspecifica.class, condicionEspecifica);
		
		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean saveCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", dtoCondicionEspecifica.getIdActivo());
		Order order = new Order(OrderType.DESC, "id");
		ActivoCondicionEspecifica condicionEspecifica = genericDao
				.getListOrdered(ActivoCondicionEspecifica.class, order, filtro).get(0);

		if (!Checks.esNulo(condicionEspecifica)) {
			try {
				String texto = dtoCondicionEspecifica.getTexto().replace("<", "");
				texto = texto.replace(">", "");
				beanUtilNotNull.copyProperty(condicionEspecifica, "texto", texto);
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager", e);
			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager", e);
			}

			genericDao.save(ActivoCondicionEspecifica.class, condicionEspecifica);
			
			return true;

		} else {
			return false;
		}
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean darDeBajaCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoCondicionEspecifica.getId()));
		ActivoCondicionEspecifica condicionEspecifica = genericDao.get(ActivoCondicionEspecifica.class, filtro);

		if (!Checks.esNulo(condicionEspecifica)) {
			try {
				beanUtilNotNull.copyProperty(condicionEspecifica, "fechaHasta", new Date());
				beanUtilNotNull.copyProperty(condicionEspecifica, "usuarioBaja", adapter.getUsuarioLogado());

			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager", e);

			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager", e);
			}

			genericDao.save(ActivoCondicionEspecifica.class, condicionEspecifica);
			
			return true;

		} else {
			return false;
		}
	}

	@Override
	public DtoPage getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto) {
		Page page = activoDao.getHistoricoValoresPrecios(dto);

		@SuppressWarnings("unchecked")
		List<ActivoHistoricoValoraciones> lista = (List<ActivoHistoricoValoraciones>) page.getResults();
		List<DtoHistoricoPrecios> historicos = new ArrayList<DtoHistoricoPrecios>();

		for (ActivoHistoricoValoraciones historico : lista) {

			DtoHistoricoPrecios dtoHistorico = new DtoHistoricoPrecios(historico);
			historicos.add(dtoHistorico);
		}

		return new DtoPage(historicos, page.getTotalCount());
	}

	@Override
	public List<DtoEstadosInformeComercialHistorico> getEstadoInformeComercialByActivo(Long idActivo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.DESC, "fecha");
		List<ActivoEstadosInformeComercialHistorico> listaEstadoInfoComercial = genericDao
				.getListOrdered(ActivoEstadosInformeComercialHistorico.class, order, filtro);

		List<DtoEstadosInformeComercialHistorico> listaDtoEstadosInfoComercial = new ArrayList<DtoEstadosInformeComercialHistorico>();

		for (ActivoEstadosInformeComercialHistorico estado : listaEstadoInfoComercial) {
			DtoEstadosInformeComercialHistorico dtoEstadosInfoComercial = new DtoEstadosInformeComercialHistorico();
			try {
				beanUtilNotNull.copyProperty(dtoEstadosInfoComercial, "id", idActivo);
				if (!Checks.esNulo(estado.getEstadoInformeComercial())) {
					beanUtilNotNull.copyProperty(dtoEstadosInfoComercial, "estadoInfoComercial",
							estado.getEstadoInformeComercial().getDescripcion());
				}
				beanUtilNotNull.copyProperty(dtoEstadosInfoComercial, "motivo", estado.getMotivo());
				beanUtilNotNull.copyProperty(dtoEstadosInfoComercial, "fecha", estado.getFecha());

			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager", e);

			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager", e);
			}

			listaDtoEstadosInfoComercial.add(dtoEstadosInfoComercial);
		}

		return listaDtoEstadosInfoComercial;
	}

	public boolean isInformeComercialAceptado(Activo activo) {
		if (!Checks.esNulo(activo)) {
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			Order order = new Order(OrderType.DESC, "fecha");
			List<ActivoEstadosInformeComercialHistorico> activoEstadoInfComercialHistoricoList = genericDao
					.getListOrdered(ActivoEstadosInformeComercialHistorico.class, order, filter);

			if (!Checks.estaVacio(activoEstadoInfComercialHistoricoList)) {
				ActivoEstadosInformeComercialHistorico historico = null;
				int i = 0;
				do {
					historico = activoEstadoInfComercialHistoricoList.get(i);
					if (historico.getEstadoInformeComercial().getCodigo()
							.equals(DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_ACEPTACION))
						return true;
					i++;
				} while (i < activoEstadoInfComercialHistoricoList.size());

			}
		}

		return false;
	}

	@Override
	public List<DtoHistoricoMediador> getHistoricoMediadorByActivo(Long idActivo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.DESC, "id");
		List<ActivoInformeComercialHistoricoMediador> listaHistoricoMediador = genericDao.getListOrdered(ActivoInformeComercialHistoricoMediador.class, order, filtro);

		List<DtoHistoricoMediador> listaDtoHistoricoMediador = new ArrayList<DtoHistoricoMediador>();
		
		for (ActivoInformeComercialHistoricoMediador historico : listaHistoricoMediador) {
			DtoHistoricoMediador dtoHistoricoMediador = new DtoHistoricoMediador();

			try {
				beanUtilNotNull.copyProperty(dtoHistoricoMediador, "id", historico.getId());
				beanUtilNotNull.copyProperty(dtoHistoricoMediador, "idActivo", idActivo);
				beanUtilNotNull.copyProperty(dtoHistoricoMediador, "fechaDesde", historico.getFechaDesde());
				beanUtilNotNull.copyProperty(dtoHistoricoMediador, "fechaHasta", historico.getFechaHasta());
				if (!Checks.esNulo(historico.getMediadorInforme())) {
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "codigo", historico.getMediadorInforme().getCodigoProveedorRem());
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "mediador", historico.getMediadorInforme().getNombre());
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "telefono", historico.getMediadorInforme().getTelefono1());
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "email", historico.getMediadorInforme().getEmail());
				}
				if (historico.getAuditoria() != null) {
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "responsableCambio", historico.getAuditoria().getUsuarioCrear());
				}
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager", e);

			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager", e);
			}

			listaDtoHistoricoMediador.add(dtoHistoricoMediador);
		}

		return listaDtoHistoricoMediador;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean createHistoricoMediador(DtoHistoricoMediador dto) throws JsonViewerException {
		ActivoInformeComercialHistoricoMediador historicoMediador = new ActivoInformeComercialHistoricoMediador();
		ActivoInformeComercialHistoricoMediador historicoMediadorPrimero = new ActivoInformeComercialHistoricoMediador();
		Activo activo = null;
		Date fechaHoy = new Date();

		if (!Checks.esNulo(dto.getIdActivo())) {
			activo = activoDao.get(dto.getIdActivo());
		}

		if (activo == null)
			return false;

		if (Checks.esNulo(activo.getInfoComercial())) {
			ActivoInfoComercial infoComercial = new ActivoInfoComercial();
			infoComercial.setActivo(activo);
			Auditoria auditoria = new Auditoria();
			auditoria.setUsuarioCrear(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado().getUsername());
			auditoria.setFechaCrear(new Date());
			auditoria.setBorrado(false);
			infoComercial.setAuditoria(auditoria);
			genericDao.save(ActivoInfoComercial.class, infoComercial);
			activo.setInfoComercial(infoComercial);
		}

		try {
			// Terminar periodo de vigencia del último proveedor (fecha hasta).
			if (!Checks.esNulo(activo)) {
				Filter activoIDFiltro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				Order order = new Order(OrderType.DESC, "id");
				List<ActivoInformeComercialHistoricoMediador> historicoMediadorlist = genericDao.getListOrdered(ActivoInformeComercialHistoricoMediador.class, order, activoIDFiltro);
				if (!Checks.estaVacio(historicoMediadorlist)) {
					ActivoInformeComercialHistoricoMediador historicoAnteriorMediador = historicoMediadorlist.get(0); // El primero es el de ID más alto (el último).
					beanUtilNotNull.copyProperty(historicoAnteriorMediador, "fechaHasta", fechaHoy);
					genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoAnteriorMediador);

				} else {
					// Si la lista esta vacia es porque es la primera vez que se modifica el historico de mediadores, por lo que tenemos que introducir el que
					// habia antes. La fecha desde se deja vacia por ahora.
					if (!Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
						beanUtilNotNull.copyProperty(historicoMediadorPrimero, "fechaHasta", fechaHoy);
						beanUtilNotNull.copyProperty(historicoMediadorPrimero, "activo", activo);
						beanUtilNotNull.copyProperty(historicoMediadorPrimero, "mediadorInforme", activo.getInfoComercial().getMediadorInforme());
						genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediadorPrimero);
					}
				}
			}

			// Generar la nueva entrada de HistoricoMediador.
			beanUtilNotNull.copyProperty(historicoMediador, "fechaDesde", fechaHoy);
			beanUtilNotNull.copyProperty(historicoMediador, "activo", activo);

			if (!Checks.esNulo(dto.getCodigo()) || !dto.getCodigo().equals("")) { // si no se selecciona mediador en el combo, se devuelve mediador "", no null.
				Filter proveedorFiltro = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", Long.parseLong(dto.getCodigo()));
				ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, proveedorFiltro);

				if (Checks.esNulo(proveedor)) {
					// mandar mensaje
					throw new JsonViewerException(messageServices.getMessage(AVISO_MEDIADOR_NO_EXISTE));
				}

				if (!Checks.esNulo(proveedor.getFechaBaja()) || (!Checks.esNulo(proveedor.getEstadoProveedor()) && DDEstadoProveedor.ESTADO_BAJA_PROVEEDOR.equals(proveedor.getEstadoProveedor().getCodigo()))) {
					throw new JsonViewerException(messageServices.getMessage(AVISO_MEDIADOR_BAJA));
				}

				beanUtilNotNull.copyProperty(historicoMediador, "mediadorInforme", proveedor);

				// Asignar el nuevo proveedor de tipo mediador al activo, informacion comercial.
				if (!Checks.esNulo(activo.getInfoComercial())) {
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "mediadorInforme", proveedor);
					genericDao.save(Activo.class, activo);
				}

			} else {
				return false; // si el mediador esta vacio se devuelve false
			}

			genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediador);
		
			if(activoDao.isActivoMatriz(activo.getId())) {
				ActivoAgrupacion agr = activoDao.getAgrupacionPAByIdActivo(activo.getId());
				if(!Checks.esNulo(agr)) {
					List <ActivoAgrupacionActivo> activosList = agr.getActivos();
					for(ActivoAgrupacionActivo act : activosList) {
						//Creamos el registro de Mediador en cada una de las UAs, pero no en el AM, ya que venimos de crearlo.
						if(activoDao.isUnidadAlquilable(act.getActivo().getId())){
							dto.setIdActivo(act.getActivo().getId());
							createHistoricoMediador(dto);
						}
					}
					dto.setIdActivo(activo.getId()); //Necesario cuando se realiza la carga masiva, para que no de error por modificar el dto
				}
			}
			
		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);
			return false;

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
			return false;
		}

		return true;
	}

	@Override
	public Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro) {
		return activoDao.getPropuestas(dtoPropuestaFiltro);
	}

	@Override
	public Page getActivosPublicacion(DtoActivosPublicacion dtoActivosPublicacion) {
		// Búsqueda carterizada
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class
				,genericDao.createFilter(FilterType.EQUALS, "usuario.id", adapter.getUsuarioLogado().getId()));
		if (!Checks.esNulo(usuarioCartera)) {
			if(!Checks.esNulo(usuarioCartera.getSubCartera())){
				dtoActivosPublicacion.setCartera(usuarioCartera.getCartera().getCodigo());
				dtoActivosPublicacion.setSubCartera(usuarioCartera.getSubCartera().getCodigo());
			}else{
				dtoActivosPublicacion.setCartera(usuarioCartera.getCartera().getCodigo());
			}
		}
		
		// Filtro por alquiler y venta
		String filtroEstadoPublicacionAlquiler = dtoActivosPublicacion.getEstadoPublicacionAlquilerCodigo();
		String filtroEstadoPublicacionVenta = dtoActivosPublicacion.getEstadoPublicacionCodigo();

		if (!Checks.esNulo(filtroEstadoPublicacionAlquiler) && !Checks.esNulo(filtroEstadoPublicacionVenta)) {
			String estadoAlquilerYVenta = filtroEstadoPublicacionAlquiler.concat("/")
					.concat(filtroEstadoPublicacionVenta);
			dtoActivosPublicacion.setEstadoPublicacionCodigo(estadoAlquilerYVenta);

		} else if (Checks.esNulo(filtroEstadoPublicacionVenta) && !Checks.esNulo(filtroEstadoPublicacionAlquiler)) {
			dtoActivosPublicacion.setTipoComercializacionCodigo(DDTipoComercializacion.CODIGOS_ALQUILER);
			dtoActivosPublicacion.setEstadoPublicacionCodigo(filtroEstadoPublicacionAlquiler);

		} else if (!Checks.esNulo(filtroEstadoPublicacionVenta) && Checks.esNulo(filtroEstadoPublicacionAlquiler)) {
			dtoActivosPublicacion.setTipoComercializacionCodigo(DDTipoComercializacion.CODIGOS_VENTA);
		}

		return activoDao.getActivosPublicacion(dtoActivosPublicacion);
	}

	@Override
	public Visita insertOrUpdateVisitaActivo(Visita visita) throws IllegalAccessException, InvocationTargetException {
		if (visita.getId() != null) {
			// insert
			Long newId = visitasDao.save(visita);
			visita.setId(newId);

		} else {
			// update
			Visita toUpdate = visitasDao.get(visita.getId());
			BeanUtils.copyProperties(toUpdate, visita);
			visitasDao.update(toUpdate);
		}

		return visita;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoPropuestaActivosVinculados> getPropuestaActivosVinculadosByActivo(
			DtoPropuestaActivosVinculados dto) {
		Page p = activoDao.getPropuestaActivosVinculadosByActivo(dto);
		List<PropuestaActivosVinculados> activosVinculados = (List<PropuestaActivosVinculados>) p.getResults();
		List<DtoPropuestaActivosVinculados> dtoActivosVinculados = new ArrayList<DtoPropuestaActivosVinculados>();

		for (PropuestaActivosVinculados vinculado : activosVinculados) {
			DtoPropuestaActivosVinculados nuevoDto = new DtoPropuestaActivosVinculados();
			try {
				beanUtilNotNull.copyProperty(nuevoDto, "id", vinculado.getId());
				beanUtilNotNull.copyProperty(nuevoDto, "activoVinculadoNumero",
						vinculado.getActivoVinculado().getNumActivo());
				beanUtilNotNull.copyProperty(nuevoDto, "activoVinculadoID", vinculado.getActivoVinculado().getId());
				beanUtilNotNull.copyProperty(nuevoDto, "totalCount", p.getTotalCount());

			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager", e);

			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager", e);
			}

			if (!Checks.esNulo(nuevoDto)) {
				dtoActivosVinculados.add(nuevoDto);
			}
		}

		return dtoActivosVinculados;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto) {
		PropuestaActivosVinculados propuestaActivosVinculados = new PropuestaActivosVinculados();
		Activo activoOrigen = activoDao.get(dto.getActivoOrigenID());
		Activo activoVinculado = activoDao.getActivoByNumActivo(dto.getActivoVinculadoNumero());

		if (Checks.esNulo(activoVinculado) || Checks.esNulo(activoOrigen)) {
			// No se ha encontrado algún activo. El activo origen por ID. El
			// activo vinculado por numero de activo.
			return false;
		}

		try {
			beanUtilNotNull.copyProperty(propuestaActivosVinculados, "activoOrigen", activoOrigen);
			beanUtilNotNull.copyProperty(propuestaActivosVinculados, "activoVinculado", activoVinculado);

		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
		}

		genericDao.save(PropuestaActivosVinculados.class, propuestaActivosVinculados);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deletePropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto) {
		Long id;

		try {
			id = Long.parseLong(dto.getId());
		} catch (NumberFormatException e) {
			logger.error("Error en activoManager", e);
			return false;
		}

		PropuestaActivosVinculados activoVinculado = activoDao.getPropuestaActivosVinculadosByID(id);

		if (!Checks.esNulo(activoVinculado)) {
			activoVinculado.getAuditoria().setBorrado(true);
			activoVinculado.getAuditoria().setFechaBorrar(new Date());
			activoVinculado.getAuditoria().setUsuarioBorrar(adapter.getUsuarioLogado().getUsername());
			genericDao.update(PropuestaActivosVinculados.class, activoVinculado);
			return true;
		}

		return false;
	}

	@Override
	public boolean isActivoIncluidoEnPerimetro(Long idActivo) {
		List<PerimetroActivo> perimetros = new ArrayList<PerimetroActivo>();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.DESC, "auditoria.fechaCrear");
		perimetros = genericDao.getListOrdered(PerimetroActivo.class, order, filtro);

		return Checks.estaVacio(perimetros) || perimetros.get(0).getIncluidoEnPerimetro() == 1;
	}

	@Override
	public PerimetroActivo getPerimetroByIdActivo(Long idActivo) {
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtroActivo);

		// Si no existia un registro de activo bancario, crea un nuevo
		if (Checks.esNulo(perimetroActivo)) {
			perimetroActivo = new PerimetroActivo();
			Auditoria auditoria = new Auditoria();
			auditoria.setUsuarioCrear("REM");
			auditoria.setFechaCrear(new Date());
			perimetroActivo.setAuditoria(auditoria);
			Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
			Activo activo = genericDao.get(Activo.class, filterActivo);
			if (!Checks.esNulo(activo))
				perimetroActivo.setActivo(activo);
			// Si no existia perimetro en BBDD, por defecto esta INCLUIDO en
			// perímetro y se deben tomar todas las condiciones como marcadas
			perimetroActivo.setIncluidoEnPerimetro(1);
			perimetroActivo.setAplicaTramiteAdmision(1);
			perimetroActivo.setAplicaGestion(1);
			perimetroActivo.setAplicaAsignarMediador(1);
			perimetroActivo.setAplicaComercializar(1);
			perimetroActivo.setAplicaFormalizar(1);
			perimetroActivo.setAplicaPublicar(true);
			perimetroActivo.setOfertasVivas(false);
			perimetroActivo.setTrabajosVivos(false);
		}

		return perimetroActivo;
	}

	@Override
	public ActivoBancario getActivoBancarioByIdActivo(Long idActivo) {
		// Obtiene el registro de ActivoBancario para el activo dado
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		ActivoBancario activoBancario = genericDao.get(ActivoBancario.class, filtroActivo);

		// Si no existia un registro de activo bancario, crea un nuevo
		if (Checks.esNulo(activoBancario)) {
			activoBancario = new ActivoBancario();
			activoBancario.setAuditoria(new Auditoria());
		}

		return activoBancario;
	}
	
	@Override
	public List<ActivoCalificacionNegativa> getActivoCalificacionNegativaByIdActivo(Long idActivo){
		// Obtiene el registro de ActivoCalificacionNegativa para el activo dado
		return activoDao.getListActivoCalificacionNegativaByIdActivo(idActivo);
	}

	@Override
	public List<DtoActivoDatosRegistrales> getActivoCalificacionNegativa(Long idActivo){		
		List<ActivoCalificacionNegativa> activoCNList = activoDao.getListActivoCalificacionNegativaByIdActivo(idActivo);
		List<DtoActivoDatosRegistrales> activoCNListDto = new ArrayList<DtoActivoDatosRegistrales>();
			
		try {
			
			for (ActivoCalificacionNegativa activo : activoCNList) {
				DtoActivoDatosRegistrales dto = new DtoActivoDatosRegistrales();

				beanUtilNotNull.copyProperty(dto, "idActivo", idActivo);
				beanUtilNotNull.copyProperty(dto, "idMotivo", String.valueOf(activo.getId()));
				if(!Checks.esNulo(activo.getMotivoCalificacionNegativa())) {
					beanUtilNotNull.copyProperty(dto, "motivoCalificacionNegativa", activo.getMotivoCalificacionNegativa().getDescripcion());
					beanUtilNotNull.copyProperty(dto, "codigoMotivoCalificacionNegativa", activo.getMotivoCalificacionNegativa().getCodigo());
				}
				if(!Checks.esNulo(activo.getEstadoMotivoCalificacionNegativa())) {
					beanUtilNotNull.copyProperty(dto, "estadoMotivoCalificacionNegativa", activo.getEstadoMotivoCalificacionNegativa().getDescripcion());
					beanUtilNotNull.copyProperty(dto, "codigoEstadoMotivoCalificacionNegativa", activo.getEstadoMotivoCalificacionNegativa().getCodigo());
				}
				if(!Checks.esNulo(activo.getResponsableSubsanar())){
					beanUtilNotNull.copyProperty(dto, "responsableSubsanar", activo.getResponsableSubsanar().getDescripcion());
					beanUtilNotNull.copyProperty(dto, "codigoResponsableSubsanar", activo.getResponsableSubsanar().getCodigo());
				}
				beanUtilNotNull.copyProperty(dto, "fechaSubsanacion", activo.getFechaSubsanacion());
				beanUtilNotNull.copyProperty(dto, "descripcionCalificacionNegativa", activo.getDescripcion());	
				
				if(!Checks.esNulo(activo.getHistoricoTramitacionTitulo())) {
					dto.setFechaCalificacionNegativa(activo.getHistoricoTramitacionTitulo().getFechaCalificacion());
					dto.setFechaPresentacionRegistroCN(activo.getHistoricoTramitacionTitulo().getFechaPresentacionRegistro());
				}
		
				
				activoCNListDto.add(dto);
			}
			
		} catch (Exception ex) {
			logger.error("Error en activoManager", ex);
		}


		return activoCNListDto;
	}
	
	
	@Override
	public List<DtoActivoDatosRegistrales> getActivoCalificacionNegativaCodigos(Long idActivo){		
		List<ActivoCalificacionNegativa> activoCNList = activoDao.getListActivoCalificacionNegativaByIdActivo(idActivo);
		List<DtoActivoDatosRegistrales> activoCNListDto = new ArrayList<DtoActivoDatosRegistrales>();
			
		try {
			
			for (ActivoCalificacionNegativa activo : activoCNList) {
				DtoActivoDatosRegistrales dto = new DtoActivoDatosRegistrales();

				beanUtilNotNull.copyProperty(dto, "idActivo", idActivo);
				beanUtilNotNull.copyProperty(dto, "idMotivo", String.valueOf(activo.getId()));
				if(!Checks.esNulo(activo.getMotivoCalificacionNegativa())) {
					beanUtilNotNull.copyProperty(dto, "motivoCalificacionNegativa", activo.getMotivoCalificacionNegativa().getCodigo());
				}
				if(!Checks.esNulo(activo.getEstadoMotivoCalificacionNegativa())) {
					beanUtilNotNull.copyProperty(dto, "estadoMotivoCalificacionNegativa", activo.getEstadoMotivoCalificacionNegativa().getCodigo());
				}
				if(!Checks.esNulo(activo.getResponsableSubsanar())){
					beanUtilNotNull.copyProperty(dto, "responsableSubsanar", activo.getResponsableSubsanar().getCodigo());
				}
				beanUtilNotNull.copyProperty(dto, "fechaSubsanacion", activo.getFechaSubsanacion());
				beanUtilNotNull.copyProperty(dto, "descripcionCalificacionNegativa", activo.getDescripcion());
				
				activoCNListDto.add(dto);
			}
			
		} catch (Exception ex) {
			logger.error("Error en activoManager", ex);
		}


		return activoCNListDto;
	}

	@Override
	@Transactional(readOnly = false)
	public PerimetroActivo saveOrUpdatePerimetroActivo(PerimetroActivo perimetroActivo) {
		try {
			if (!Checks.esNulo(perimetroActivo.getId())) {
				// update
				perimetroActivo.getAuditoria().setFechaModificar(new Date());
				perimetroActivo.getAuditoria().setUsuarioModificar(adapter.getUsuarioLogado().getUsername());
				genericDao.update(PerimetroActivo.class, perimetroActivo);

			} else {
				// insert
				perimetroActivo.getAuditoria().setFechaCrear(new Date());
				perimetroActivo.getAuditoria().setUsuarioCrear(adapter.getUsuarioLogado().getUsername());
				genericDao.save(PerimetroActivo.class, perimetroActivo);
			}
	
		} catch (Exception ex) {
			logger.error("Error en activoManager", ex);
		}

		return perimetroActivo;
	}

	@Override
	@Transactional(readOnly = false)
	public Activo updateActivoAsistida(Activo activo) {
		// Actualizamos el perímetro
		PerimetroActivo perimetro = getPerimetroByIdActivo(activo.getId());

		if (Checks.esNulo(perimetro.getActivo()))
			perimetro.setActivo(activo);

		updatePerimetroAsistida(perimetro);

		// Bloqueamos los precios para que el activo no salga en los procesos
		// automáticos. Esto podría ir en un proceso al dar de alta el activo.
		activo.setBloqueoPrecioFechaIni(new Date());
		activo.setGestorBloqueoPrecio(adapter.getUsuarioLogado());

		DDTipoComercializar tipoComercializar = (DDTipoComercializar) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDTipoComercializar.class, DDTipoComercializar.CODIGO_RETAIL);
		if (!Checks.esNulo(tipoComercializar)) {
			activo.setTipoComercializar(tipoComercializar);
		}

		DDTipoComercializacion tipoComercializacion = (DDTipoComercializacion) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDTipoComercializacion.class, DDTipoComercializacion.CODIGO_VENTA);
		if (!Checks.esNulo(tipoComercializacion) && !Checks.esNulo(activo.getActivoPublicacion())) {
			activo.getActivoPublicacion().setTipoComercializacion(tipoComercializacion);
		}

		saveOrUpdate(activo);

		return activo;
	}

	@Override
	@Transactional(readOnly = false)
	public PerimetroActivo updatePerimetroAsistida(PerimetroActivo perimetroActivo) {
		perimetroActivo.setIncluidoEnPerimetro(1);
		perimetroActivo.setAplicaAsignarMediador(0);
		perimetroActivo.setAplicaComercializar(1);
		perimetroActivo.setAplicaFormalizar(0);
		perimetroActivo.setAplicaGestion(0);
		perimetroActivo.setAplicaTramiteAdmision(0);
		perimetroActivo.setFechaAplicaComercializar(new Date());
		perimetroActivo.setAplicaPublicar(true);
		perimetroActivo.setFechaAplicaPublicar(new Date());

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivoComercializacion.CODIGO_ASISTIDA);
		DDMotivoComercializacion motivoComercializacion = genericDao.get(DDMotivoComercializacion.class, filtro);
		perimetroActivo.setMotivoAplicaComercializar(motivoComercializacion);
		perimetroActivo.setMotivoAplicaPublicar(motivoComercializacion.getDescripcion());

		saveOrUpdatePerimetroActivo(perimetroActivo);

		return perimetroActivo;
	}

	@Override
	@Transactional(readOnly = false)
	public ActivoBancario saveOrUpdateActivoBancario(ActivoBancario activoBancario) {
		try {
			if (!Checks.esNulo(activoBancario.getId())) {
				// update
				activoBancario.getAuditoria().setFechaModificar(new Date());
				activoBancario.getAuditoria().setUsuarioModificar(adapter.getUsuarioLogado().getUsername());
				genericDao.update(ActivoBancario.class, activoBancario);

			} else {
				// insert
				activoBancario.getAuditoria().setFechaCrear(new Date());
				activoBancario.getAuditoria().setUsuarioCrear(adapter.getUsuarioLogado().getUsername());
				genericDao.save(ActivoBancario.class, activoBancario);
			}

		} catch (Exception ex) {
			logger.error("Error en activoManager", ex);
		}

		return activoBancario;
	}

	@Override
	public boolean isActivoConOfertaByEstado(Activo activo, String codEstado) {
		if (!Checks.estaVacio(activo.getOfertas())) {
			for (ActivoOferta activoOferta : activo.getOfertas()) {
				if (activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals(codEstado)) {
					return true;
				}
			}
		}

		return false;
	}

	@Override
	public boolean isActivoConReservaByEstado(Activo activo, String codEstado) {
		for (Reserva reserva : this.getReservasByActivoOfertaAceptada(activo)) {
			if (!Checks.esNulo(reserva.getEstadoReserva())
					&& reserva.getEstadoReserva().getCodigo().equals(codEstado)) {
				return true;
			}
		}

		return false;
	}

	@Override
	public List<Reserva> getReservasByActivoOfertaAceptada(Activo activo) {
		List<Reserva> reservas = new ArrayList<Reserva>();

		if (!Checks.estaVacio(activo.getOfertas())) {
			for (ActivoOferta activoOferta : activo.getOfertas()) {
				if (!Checks.esNulo(activoOferta.getPrimaryKey().getOferta()) && DDEstadoOferta.CODIGO_ACEPTADA
						.equals(activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id",
							activoOferta.getPrimaryKey().getOferta().getId());
					ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);

					if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getReserva())) {
						reservas.add(expediente.getReserva());
					}
				}
			}
		}

		return reservas;
	}

	@Override
	public boolean isActivoVendido(Activo activo) {
		if (!Checks.esNulo(activo.getFechaVentaExterna()))
			return true;
		else {
			if (!Checks.estaVacio(activo.getOfertas())) {
				for (ActivoOferta activoOferta : activo.getOfertas()) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id",
							activoOferta.getPrimaryKey().getOferta().getId());
					ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);

					if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getFechaVenta()) && DDTipoOferta.CODIGO_VENTA.equals(activoOferta.getPrimaryKey().getOferta().getTipoOferta().getCodigo())) {
							return true;
					}
					
				}
			}
		}

		return false;
	}

	@Override
	public boolean isActivoAlquilado(Activo activo) {
		if (!Checks.estaVacio(activo.getOfertas())) {
			for (ActivoOferta activoOferta : activo.getOfertas()) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id",
						activoOferta.getPrimaryKey().getOferta().getId());
				ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);
				if (!Checks.esNulo(expediente)) {
					if (!Checks.esNulo(expediente.getFechaInicioAlquiler()) && Checks.esNulo(expediente.getFechaFinAlquiler()) && DDTipoOferta.CODIGO_ALQUILER.equals(activoOferta.getPrimaryKey().getOferta().getTipoOferta().getCodigo()))
						return true;
				}
			}
		}
		return false;
	}
	
	@Override
	public boolean isOcupadoConTituloOrEstadoAlquilado(Activo activo) {
		ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class,
				genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
		ActivoSituacionPosesoria activoSituacionPosesoria = activo.getSituacionPosesoria();
		if ((!Checks.esNulo(activoPatrimonio) && activoPatrimonio.getTipoEstadoAlquiler() != null
				&& DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO
						.equals(activoPatrimonio.getTipoEstadoAlquiler().getCodigo()))
				|| (!Checks.esNulo(activoSituacionPosesoria) && !Checks.esNulo(activoSituacionPosesoria.getOcupado())
						&& activoSituacionPosesoria.getConTitulo() != null
						&& activoSituacionPosesoria.getOcupado() != null && activoSituacionPosesoria.getOcupado() == 1
						&& DDTipoTituloActivoTPA.tipoTituloSi
								.equals(activoSituacionPosesoria.getConTitulo().getCodigo()))) {
			return true;
		}
		return false;
	}
	
	@Transactional(readOnly = false)
	public List<GastosExpediente> crearGastosExpediente(ExpedienteComercial nuevoExpediente) {
		
		List<GastosExpediente> gastosExpediente = new ArrayList<GastosExpediente>();
		
		ComisionDto filtroDto = new ComisionDto();
		
		filtroDto.setIdOfertaRem(nuevoExpediente.getOferta().getNumOferta());
		List<GastosExpediente> listaGastos = gastosExpedienteApi.getListaGastosExpediente(filtroDto);
		
		if(listaGastos == null || listaGastos.isEmpty()) {
		
			List<String> acciones = new ArrayList<String>();
			String codigoOferta = nuevoExpediente.getOferta().getTipoOferta().getCodigo();
	
			acciones.add(DDAccionGastos.CODIGO_COLABORACION);
			acciones.add(DDAccionGastos.CODIGO_PRESCRIPCION); 
	
			if(DDTipoOferta.CODIGO_VENTA.equals(codigoOferta)) {
				acciones.add(DDAccionGastos.CODIGO_RESPONSABLE_CLIENTE);
			}
			
			for(ActivoOferta activoOferta : nuevoExpediente.getOferta().getActivosOferta()) {
				Activo activo = activoOferta.getPrimaryKey().getActivo();
	
				for (String accion : acciones) {
					GastosExpediente gex = expedienteComercialApi.creaGastoExpediente(nuevoExpediente, nuevoExpediente.getOferta(), activo, accion);
					gastosExpediente.add(gex);
				}
			}
		}

		return gastosExpediente;
	}

	@Override
	public boolean isIntegradoAgrupacionAsistida(Activo activo) {
		for (ActivoAgrupacionActivo agrupacionActivo : activo.getAgrupaciones()) {
			Date fechaFinVigencia = agrupacionActivo.getAgrupacion().getFechaFinVigencia();
			fechaFinVigencia = !Checks.esNulo(fechaFinVigencia) ? new Date(fechaFinVigencia.getTime()) : null;

			if (!Checks.esNulo(agrupacionActivo.getAgrupacion().getTipoAgrupacion())
					&& agrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo()
							.equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)
					&& !Checks.esNulo(fechaFinVigencia) && fechaFinVigencia.after(new Date())) {
				return true;
			}
		}

		return false;
	}

	@Override
	public boolean isIntegradoAgrupacionComercial(Activo activo) {
		for (ActivoAgrupacionActivo agrupacionActivo : activo.getAgrupaciones()) {
			Date fechaBaja = agrupacionActivo.getAgrupacion().getFechaBaja();
			fechaBaja = !Checks.esNulo(fechaBaja) ? new Date(fechaBaja.getTime()) : null;

			if (!Checks.esNulo(agrupacionActivo.getAgrupacion().getTipoAgrupacion())
					&& (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA.equals(agrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())
							|| DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER.equals(agrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo()))
					&& (fechaBaja == null || fechaBaja.after(new Date()))) {
				return true;
			}
		}

		return false;
	}

	@Override
	public boolean isAfectoGencat(Activo activo) {
		boolean afecto = false;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId());
		VActivosAfectosGencat activoAfecto = genericDao.get(VActivosAfectosGencat.class, filtro);

		if(!Checks.esNulo(activoAfecto)) {
			afecto = true;
		}

		return afecto;
	}

	@Override
	public boolean isActivoBloqueadoGencat(Activo activo) {
		boolean bloqueado = false;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId());
		VActivosAfectosGencatBloqueados activoBloqueado = genericDao.get(VActivosAfectosGencatBloqueados.class, filtro);

		if(!Checks.esNulo(activoBloqueado)) {
			bloqueado = true;
		}

		return bloqueado;
	}

	@Override
	public boolean isPisoPiloto(Activo activo) {
		boolean pisoPiloto = false;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activoId", activo.getId());
		List<VActivosAgrupacion> agrupacionesActivo = genericDao.getList(VActivosAgrupacion.class, filtro);
		
		for(VActivosAgrupacion activoPisoPiloto: agrupacionesActivo) {
			if(!Checks.esNulo(activoPisoPiloto) && !Checks.esNulo(activoPisoPiloto.getEsPisoPiloto()) && activoPisoPiloto.getEsPisoPiloto()) {
				pisoPiloto = true;
				break;
			}
		}

		return pisoPiloto;
	}

	@Override
	public boolean necesitaDocumentoInformeOcupacion(Activo activo)
	{
		ActivoSituacionPosesoria activoSitPos = activo.getSituacionPosesoria();
		boolean tieneAdjunto = false;
		if(!Checks.esNulo(activoSitPos) && (!Checks.esNulo(activoSitPos.getOcupado()) && !Checks.esNulo(activoSitPos.getConTitulo()) && (1 == activoSitPos.getOcupado() && DDTipoTituloActivoTPA.tipoTituloNo.equals(activoSitPos.getConTitulo().getCodigo()))))
		{
			
			List<DtoAdjunto> listAdjuntos;
			try {
				listAdjuntos = activoAdapter.getAdjuntosActivo(activo.getId());
				if(!Checks.estaVacio(listAdjuntos))
				{
					// Buscamos el adjunto de tipo ocupacionDesocupacion mas reciente
					DtoAdjunto adjuntoAux = null;
					for (DtoAdjunto adjunto : listAdjuntos) {

						boolean esOcupacionDesocupacion = DDTipoDocumentoActivo.MATRICULA_INFORME_OCUPACION_DESOCUPACION.equals(adjunto.getMatricula());
						Date adjuntoFecha = adjunto.getFechaDocumento();

						if ((Checks.esNulo(adjuntoAux) && esOcupacionDesocupacion) 
								|| (!Checks.esNulo(adjuntoAux) && !Checks.esNulo(adjuntoAux.getFechaDocumento()) && !Checks.esNulo(adjuntoFecha) && adjuntoFecha.after(adjuntoAux.getFechaDocumento()))) {
							adjuntoAux = adjunto;
						}
					}

					long diffInMillies = 0;
					int diff = 0;

					// Si no existe ningun adjunto de tipo ocupacionDesocupacion o si lo hay y tiene una fecha superior a los 30 dias se ha de mostrar el disclaimer
					if (adjuntoAux == null  || adjuntoAux.getFechaDocumento()==null) {
						tieneAdjunto = true;
					} else {
						diffInMillies = Math.abs(System.currentTimeMillis() - adjuntoAux.getFechaDocumento().getTime());
					    diff = (int)TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
						tieneAdjunto = diff >= 30;
					}

				}
				else
				{
					tieneAdjunto = true;
				}
			} catch (IllegalAccessException e) {
				logger.error(e.getMessage(), e);
			} catch (InvocationTargetException e) {
				logger.error(e.getMessage(), e);
			} catch (GestorDocumentalException e) {
				logger.error(e.getMessage(), e);
			}


			
		}
		return tieneAdjunto;
	}

	@Override
	public boolean isActivoAsistido(Activo activo) {
		ActivoBancario activoBancario = getActivoBancarioByIdActivo(activo.getId());
		if (!Checks.esNulo(activo.getSubcartera()))
			return DDSubcartera.CODIGO_CAJ_ASISTIDA.equals(activo.getSubcartera().getCodigo())
					|| DDSubcartera.CODIGO_SAR_ASISTIDA.equals(activo.getSubcartera().getCodigo())
					|| DDSubcartera.CODIGO_BAN_ASISTIDA.equals(activo.getSubcartera().getCodigo())
					|| DDSubcartera.CODIGO_JAIPUR_FINANCIERO.equals(activo.getSubcartera().getCodigo())
					|| (activoBancario != null && activoBancario.getClaseActivo() != null && DDClaseActivoBancario.CODIGO_FINANCIERO.equals(activoBancario.getClaseActivo().getCodigo()));
		return false;
	}

	@Override
	public boolean isActivoEnPuja(Activo activo) {
		if (!Checks.esNulo(activo.getEstaEnPuja())) {
			return activo.getEstaEnPuja();
		} else {
			return false;
		}
	}

	@Override
	public Integer getNumActivosPublicadosByAgrupacion(List<ActivoAgrupacionActivo> activos) {
		Integer contador = 0;

		for (ActivoAgrupacionActivo activoAgrupacion : activos) {
			Long idActivo = activoAgrupacion.getActivo().getId();
			if (activoEstadoPublicacionApi.isPublicadoVentaByIdActivo(idActivo)
					|| activoEstadoPublicacionApi.isPublicadoAlquilerByIdActivo(idActivo)) {
				contador++;
			}
		}

		return contador;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean solicitarTasacion(Long idActivo) throws Exception {
		int tasacionID;
		Activo activo = activoDao.get(idActivo);

		if (!Checks.esNulo(activo)) {
			// Se especifica bankia por que tan solo se va a poder demandar la
			// tasación desde bankia.
			tasacionID = uvemManagerApi.ejecutarSolicitarTasacion(activo.getNumActivoUvem(),
					adapter.getUsuarioLogado());

		} else {
			return false;
		}

		if (!Checks.esNulo(tasacionID)) {
			try {
				// Generar un 'BIE_VALORACION' con el 'BIEN_ID' del activo.
				NMBValoracionesBien valoracionBien = new NMBValoracionesBien();
				valoracionBien.setBien(activo.getBien());
				valoracionBien = genericDao.save(NMBValoracionesBien.class, valoracionBien);

				if (!Checks.esNulo(valoracionBien)) {
					// Generar una tasacion con el ID de activo y el ID de la
					// valoracion del bien.
					ActivoTasacion tasacion = new ActivoTasacion();

					beanUtilNotNull.copyProperty(tasacion, "idExterno", tasacionID);
					beanUtilNotNull.copyProperty(tasacion, "activo", activo);
					beanUtilNotNull.copyProperty(tasacion, "valoracionBien", valoracionBien);
					genericDao.save(ActivoTasacion.class, tasacion);

					// Actualizar el tipoComercialización del activo
					updaterState.updaterStateTipoComercializacion(activo);
				}

			} catch (Exception e) {
				logger.error("Error en activoManager", e);
				throw new JsonViewerException("Error al procesar su solicitud");
			}

		} else {
			throw new JsonViewerException(
					"El servicio de solicitud de tasaciones no está disponible en estos momentos");
		}

		return true;
	}

	@Override
	public DtoTasacion getSolicitudTasacionBankia(Long id) {
		ActivoTasacion activoTasacion = activoDao.getActivoTasacion(id);
		DtoTasacion dtoTasacion = new DtoTasacion();

		if (!Checks.esNulo(activoTasacion)) {
			try {
				beanUtilNotNull.copyProperty(dtoTasacion, "idSolicitudREM", activoTasacion.getId());
				beanUtilNotNull.copyProperty(dtoTasacion, "fechaSolicitudTasacion",
						activoTasacion.getAuditoria().getFechaCrear());
				beanUtilNotNull.copyProperty(dtoTasacion, "gestorSolicitud",
						activoTasacion.getAuditoria().getUsuarioCrear());
				beanUtilNotNull.copyProperty(dtoTasacion, "externoID", activoTasacion.getIdExterno());

			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager", e);

			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager", e);
			}
		}

		return dtoTasacion;
	}

	@Override
	@BusinessOperationDefinition("activoManager.comprobarActivoComercializable")
	public Boolean comprobarActivoComercializable(Long idActivo) {
		PerimetroActivo perimetro = this.getPerimetroByIdActivo(idActivo);

		return perimetro.getAplicaComercializar() == 1;
	}

	@Override
	@BusinessOperationDefinition("activoManager.comprobarActivoFormalizable")
	public boolean esActivoFormalizable(Long numActivo) {
		boolean esActivoFormalizable = false;
		PerimetroActivo perimetro = this.getPerimetroByNumActivo(numActivo);

		if (perimetro != null) {
			esActivoFormalizable = perimetro.getAplicaFormalizar() == 1;
		}

		return esActivoFormalizable;
	}

	@Override
	@BusinessOperationDefinition("activoManager.comprobarObligatoriosDesignarMediador")
	public String comprobarObligatoriosDesignarMediador(Long idActivo) throws Exception {
		Activo activo = this.get(idActivo);
		String mensaje = "";

		// Validaciones datos obligatorios correspondientes a Publicacion /
		// Informe comercial del activo
		// Validación mediador
		if (Checks.esNulo(activo.getInfoComercial()) || Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
			mensaje = mensaje
					.concat(messageServices.getMessage("tramite.admision.DesignarMediador.validacionPre.mediador"));
		}

		if (!Checks.esNulo(mensaje)) {
			mensaje = messageServices.getMessage("tramite.admision.DesignarMediador.validacionPre.debeInformar")
					.concat(mensaje);
		}

		return mensaje;
	}

	@Override
	@Transactional(readOnly = false)
	public ArrayList<Map<String, Object>> saveOrUpdate(List<PortalesDto> listaPortalesDto) {
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		HashMap<String, String> errorsList;
		ActivoSituacionPosesoria activoSituacionPosesoria;
		Map<String, Object> map;
		Activo activo;

		for (PortalesDto portalesDto : listaPortalesDto) {
			errorsList = restApi.validateRequestObject(portalesDto, TIPO_VALIDACION.INSERT);
			map = new HashMap<String, Object>();

			if (errorsList.size() == 0) {
				activo = this.getByNumActivo(portalesDto.getIdActivoHaya());
				Usuario user = usuarioApi.get(portalesDto.getIdUsuarioRemAccion());

				if (activo.getSituacionPosesoria() == null) {
					Date fechaCrear = new Date();
					activoSituacionPosesoria = new ActivoSituacionPosesoria();
					activoSituacionPosesoria.getAuditoria().setUsuarioCrear(user.getUsername());
					activoSituacionPosesoria.getAuditoria().setFechaCrear(fechaCrear);
					activoSituacionPosesoria.setActivo(activo);
					activo.setSituacionPosesoria(activoSituacionPosesoria);
				}

				activoSituacionPosesoria = activo.getSituacionPosesoria();
				activoSituacionPosesoria.setPublicadoPortalExterno(portalesDto.getPublicado());

				Date fechaMod = new Date();
				activoSituacionPosesoria.getAuditoria().setUsuarioModificar(user.getUsername());
				activoSituacionPosesoria.getAuditoria().setFechaModificar(fechaMod);

				if (this.saveOrUpdate(activo)) {
					map.put("idActivoHaya", portalesDto.getIdActivoHaya());
					map.put("idUsuarioRemAccion", portalesDto.getIdUsuarioRemAccion());
					map.put("success", true);

				} else {
					map.put("idActivoHaya", portalesDto.getIdActivoHaya());
					map.put("idUsuarioRemAccion", portalesDto.getIdUsuarioRemAccion());
					map.put("success", false);
				}

			} else {
				map.put("idActivoHaya", portalesDto.getIdActivoHaya());
				map.put("idUsuarioRemAccion", portalesDto.getIdUsuarioRemAccion());
				map.put("success", false);
				map.put("invalidFields", errorsList);
			}

			listaRespuesta.add(map);
		}

		return listaRespuesta;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoReglasPublicacionAutomatica> getReglasPublicacionAutomatica(DtoReglasPublicacionAutomatica dto) {
		Page p = genericDao.getPage(ActivoReglasPublicacionAutomatica.class, dto);
		List<ActivoReglasPublicacionAutomatica> reglas = (List<ActivoReglasPublicacionAutomatica>) p.getResults();
		List<DtoReglasPublicacionAutomatica> reglasDto = new ArrayList<DtoReglasPublicacionAutomatica>();

		for (ActivoReglasPublicacionAutomatica regla : reglas) {
			DtoReglasPublicacionAutomatica nuevoDto = new DtoReglasPublicacionAutomatica();
			try {
				beanUtilNotNull.copyProperty(nuevoDto, "idRegla", regla.getId());
				beanUtilNotNull.copyProperty(nuevoDto, "incluidoAgrupacionAsistida",
						regla.getIncluidoAgrupacionAsistida());
				if (!Checks.esNulo(regla.getCartera())) {
					beanUtilNotNull.copyProperty(nuevoDto, "carteraCodigo", regla.getCartera().getCodigo());
				}
				if (!Checks.esNulo(regla.getTipoActivo())) {
					beanUtilNotNull.copyProperty(nuevoDto, "tipoActivoCodigo", regla.getTipoActivo().getCodigo());
				}
				if (!Checks.esNulo(regla.getSubtipoActivo())) {
					beanUtilNotNull.copyProperty(nuevoDto, "subtipoActivoCodigo", regla.getSubtipoActivo().getCodigo());
				}

				nuevoDto.setTotalCount(p.getTotalCount());

				reglasDto.add(nuevoDto);

			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager", e);

			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager", e);
			}
		}

		return reglasDto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createReglaPublicacionAutomatica(DtoReglasPublicacionAutomatica dto) {
		ActivoReglasPublicacionAutomatica arpa = new ActivoReglasPublicacionAutomatica();

		try {
			beanUtilNotNull.copyProperty(arpa, "incluidoAgrupacionAsistida", dto.getIncluidoAgrupacionAsistida());

			if (!Checks.esNulo(dto.getCarteraCodigo())) {
				DDCartera cartera = (DDCartera) utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class,
						dto.getCarteraCodigo());
				beanUtilNotNull.copyProperty(arpa, "cartera", cartera);
			}

			if (!Checks.esNulo(dto.getTipoActivoCodigo())) {
				DDTipoActivo tipo = (DDTipoActivo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoActivo.class,
						dto.getTipoActivoCodigo());
				beanUtilNotNull.copyProperty(arpa, "tipoActivo", tipo);
			}

			if (!Checks.esNulo(dto.getSubtipoActivoCodigo())) {
				DDSubtipoActivo subtipo = (DDSubtipoActivo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSubtipoActivo.class, dto.getSubtipoActivoCodigo());
				beanUtilNotNull.copyProperty(arpa, "subtipoActivo", subtipo);
			}

		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);
			return false;

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
			return false;
		}

		genericDao.save(ActivoReglasPublicacionAutomatica.class, arpa);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteReglaPublicacionAutomatica(DtoReglasPublicacionAutomatica dto) {
		if (Checks.esNulo(dto.getIdRegla())) {
			return false;
		}

		Filter reglaIDFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdRegla()));
		ActivoReglasPublicacionAutomatica arpa = genericDao.get(ActivoReglasPublicacionAutomatica.class, reglaIDFilter);

		if (Checks.esNulo(arpa)) {
			return false;
		}

		try {
			beanUtilNotNull.copyProperty(arpa, "auditoria.borrado", "1");
			beanUtilNotNull.copyProperty(arpa, "auditoria.fechaBorrar", new Date());
			beanUtilNotNull.copyProperty(arpa, "auditoria.usuarioBorrar", adapter.getUsuarioLogado().getUsername());

		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);
			return false;

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
			return false;
		}

		genericDao.save(ActivoReglasPublicacionAutomatica.class, arpa);

		return true;
	}

	public List<VBusquedaProveedoresActivo> getProveedorByActivo(Long idActivo) {
		
		List<VBusquedaProveedoresActivo> listadoProveedores = null;
		//si es activo matriz, hay que devolver los datos de todas sus UAS
		if(activoDao.isActivoMatriz(idActivo)) {
			ActivoAgrupacion agr = activoDao.getAgrupacionPAByIdActivo(idActivo);
			if(!Checks.esNulo(agr)) {
				List<Activo> listaUAs = activoAgrupacionActivoDao.getListUAsByIdAgrupacion(agr.getId());
				List<String> listaIds = new ArrayList<String>(); 
				listaIds.add(idActivo.toString());
				for (Activo activo : listaUAs) {
					listaIds.add(activo.getId().toString());
				}
				listadoProveedores = activoDao.getListProveedor(listaIds);
			}else {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idFalso.idActivo", idActivo.toString());
				listadoProveedores = genericDao.getList(VBusquedaProveedoresActivo.class,filtro);
			}
		}else {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idFalso.idActivo", idActivo.toString());
			listadoProveedores = genericDao.getList(VBusquedaProveedoresActivo.class,filtro);
		}
		
		return listadoProveedores;
	}

	@Override
	public Page getGastoByActivo(Long idActivo, Long idProveedor, WebDto dto) {
		Page gastosActivos = null;

		dto.setSort(" idGasto ");
		dto.setDir("ASC");

		if (!Checks.esNulo(idActivo) && !Checks.esNulo(idProveedor)) {
			Filter filtroGastoActivo = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo);
			Filter filtroGastoProveedor = genericDao.createFilter(FilterType.EQUALS, "idProveedor", idProveedor);
			gastosActivos = genericDao.getPage(VBusquedaGastoActivo.class, dto, filtroGastoActivo,
					filtroGastoProveedor);
		}

		return gastosActivos;
	}
	
	@Override
	public List<DtoActivoTributos> getActivoTributosByActivo(Long idActivo, WebDto dto) throws GestorDocumentalException {
		List<DtoActivoTributos> tributos = new ArrayList<DtoActivoTributos>();
		List<ActivoTributos> listTributos = new ArrayList<ActivoTributos>();

		if (!Checks.esNulo(idActivo)) {
			Filter filterTributo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
			Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			listTributos = genericDao.getList(ActivoTributos.class, filterTributo, filtroAuditoria);
		}
		
		if(!Checks.estaVacio(listTributos)){
			Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);	
			for(ActivoTributos tributo : listTributos){
				DtoActivoTributos dtoTributo = new DtoActivoTributos();
				dtoTributo.setIdTributo(tributo.getId());
				dtoTributo.setFechaPresentacion(tributo.getFechaPresentacionRecurso());
				dtoTributo.setFechaRecPropietario(tributo.getFechaRecepcionPropietario());
				dtoTributo.setFechaRecGestoria(tributo.getFechaRecepcionGestoria());
				if(!Checks.esNulo(tributo.getTipoSolicitudTributo())){
					dtoTributo.setTipoSolicitud(tributo.getTipoSolicitudTributo().getCodigo());
				}
				dtoTributo.setObservaciones(tributo.getObservaciones());
				dtoTributo.setFechaRecRecursoPropietario(tributo.getFechaRecepcionRecursoPropietario());
				dtoTributo.setFechaRecRecursoGestoria(tributo.getFechaRecepcionRecursoGestoria());
				dtoTributo.setFechaRespRecurso(tributo.getFechaRespuestaRecurso());
				if(!Checks.esNulo(tributo.getFavorable())){
					dtoTributo.setResultadoSolicitud(tributo.getFavorable().getCodigo());
				}
				if(!Checks.esNulo(tributo.getGastoProveedor())){
					dtoTributo.setNumGastoHaya(tributo.getGastoProveedor().getNumGastoHaya());
				}
				
				Filter filterAdjuntoTributo = genericDao.createFilter(FilterType.EQUALS, "activoTributo.id", tributo.getId());
				Filter filtroRest = null;
				ActivoAdjuntoTributo adjuntoTributo = null;
				
				if (gestorDocumentalAdapterApi.modoRestClientActivado()) {

					try {
						DtoAdjunto adjuntoTributoDto = gestorDocumentalAdapterApi.getAdjuntoTributo(tributo);
						filterAdjuntoTributo = genericDao.createFilter(FilterType.EQUALS, "activoTributo.id",
								tributo.getId());
						filtroRest = genericDao.createFilter(FilterType.NOTNULL, "idDocRestClient");
						adjuntoTributo = genericDao.get(ActivoAdjuntoTributo.class, filterAdjuntoTributo, filtroRest,
								filtroAuditoria);

					} catch (GestorDocumentalException gex) {
						try {
							Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
							if (GestorDocumentalException.CODIGO_ERROR_CONTENEDOR_NO_EXISTE
									.equals(gex.getCodigoError())) {
								Thread hilo = new Thread(
										gestorDocumentalAdapterApi.crearTributo(tributo, usuarioLogado.getUsername(),
												GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES));
								hilo.start();
							}
						} catch (Exception e) {
							e.printStackTrace();
							dtoTributo.setExisteDocumentoTributo("false");
							dtoTributo.setDocumentoTributoNombre("No existe acceso al Gestor Documental");
						}

					}
				} else {

					filtroRest = genericDao.createFilter(FilterType.NULL, "idDocRestClient");
					adjuntoTributo = genericDao.get(ActivoAdjuntoTributo.class, filterAdjuntoTributo, filtroRest,
							filtroAuditoria);

				}

				if (!Checks.esNulo(adjuntoTributo)) {
					dtoTributo.setExisteDocumentoTributo("true");
					dtoTributo.setDocumentoTributoNombre(adjuntoTributo.getNombre());
					dtoTributo.setDocumentoTributoId(adjuntoTributo.getId());

				} else if (Checks.esNulo(dtoTributo.getExisteDocumentoTributo())) {
					dtoTributo.setExisteDocumentoTributo("false");
					dtoTributo.setDocumentoTributoNombre(null);
					dtoTributo.setDocumentoTributoId(null);
				}

				tributos.add(dtoTributo);
			}
		}
		
		return tributos;
	}

	@Override
	public Oferta tieneOfertaAceptada(Activo activo) {
		List<ActivoOferta> listaActivoOferta = activo.getOfertas();
		int i = 0;
		Oferta ofertaAux = null;
		Oferta ofertaAceptada = null;

		if (!Checks.estaVacio(listaActivoOferta)) {
			while (i < listaActivoOferta.size() && ofertaAceptada == null) {
				ActivoOferta tmp = listaActivoOferta.get(i);
				i++;
				ofertaAux = tmp.getPrimaryKey().getOferta();
				if (DDEstadoOferta.CODIGO_ACEPTADA.equals(ofertaAux.getEstadoOferta().getCodigo())) {
					ExpedienteComercial expediente = expedienteComercialApi
							.expedienteComercialPorOferta(ofertaAux.getId());
					if (!Checks.esNulo(expediente)) { // Si el expediente está
														// aprobado (o estados
														// posteriores).
						if (DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.ALQUILADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.EN_DEVOLUCION.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.BLOQUEO_ADM.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.FIRMADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.EN_TRAMITACION
										.equals(expediente.getEstado().getCodigo()))
							ofertaAceptada = ofertaAux;
					}
				}
			}
		}

		return ofertaAceptada;
	}

	@Override
	public Oferta tieneOfertaTramitadaOCongeladaConReserva(Activo activo) {
		List<ActivoOferta> listaActivoOferta = activo.getOfertas();
		int i = 0;
		Oferta ofertaAux = null;
		Oferta oferta = null;

		if (!Checks.estaVacio(listaActivoOferta)) {
			while (i < listaActivoOferta.size() && oferta == null) {
				ActivoOferta tmp = listaActivoOferta.get(i);
				i++;
				ofertaAux = tmp.getPrimaryKey().getOferta();
				if (DDEstadoOferta.CODIGO_CONGELADA.equals(ofertaAux.getEstadoOferta().getCodigo())) {
					ExpedienteComercial expediente = expedienteComercialApi
							.expedienteComercialPorOferta(ofertaAux.getId());
					if (!Checks.esNulo(expediente)) { 
						Reserva reserva = genericDao.get(Reserva.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId()));
						if(!Checks.esNulo(reserva) && !Checks.esNulo(reserva.getFechaFirma())) {
							List<ComunicacionGencat> comunicacionesVivas = gencatApi.comunicacionesVivas(expediente);
							boolean provieneOfertaGencat = gencatApi.esOfertaGencat(expediente);
							if (!Checks.estaVacio(comunicacionesVivas) && !provieneOfertaGencat && 
									!DDEstadosExpedienteComercial.EN_TRAMITACION.equals(expediente.getEstado().getCodigo()) &&
									!DDEstadosExpedienteComercial.PTE_SANCION.equals(expediente.getEstado().getCodigo()) &&
									((!Checks.esNulo(expediente.getReserva()) && !DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo()))
										|| (Checks.esNulo(expediente.getReserva()) && DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo()))
										|| DDEstadosExpedienteComercial.ANULADO.equals(expediente.getEstado().getCodigo())
										|| DDEstadosExpedienteComercial.ANULADO_PDTE_DEVOLUCION.equals(expediente.getEstado().getCodigo())
										|| DDEstadosExpedienteComercial.EN_DEVOLUCION.equals(expediente.getEstado().getCodigo()))) {
								if (gencatApi.comprobarExpedienteAnuladoGencat(comunicacionesVivas)) {
									oferta = ofertaAux;
								}
							}
							
						}
							
					}
				}else if (DDEstadoOferta.CODIGO_ACEPTADA.equals(ofertaAux.getEstadoOferta().getCodigo())) {
					ExpedienteComercial expediente = expedienteComercialApi
							.expedienteComercialPorOferta(ofertaAux.getId());
					if (!Checks.esNulo(expediente)) { // Si el expediente está
														// aprobado (o estados
														// posteriores).
						if (DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.ALQUILADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.EN_DEVOLUCION.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.BLOQUEO_ADM.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.FIRMADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.EN_TRAMITACION
										.equals(expediente.getEstado().getCodigo()))
							oferta = ofertaAux;
					}
				}
			}
		}

		return oferta;
	}
	private Trabajo tareaExternaToTrabajo(TareaExterna tareaExterna) {
		Trabajo trabajo = null;
		TareaActivo tareaActivo = tareaActivoManager.getByIdTareaExterna(tareaExterna.getId());

		if (!Checks.esNulo(tareaActivo)) {
			ActivoTramite tramite = tareaActivo.getTramite();
			if (!Checks.esNulo(tramite)) {
				trabajo = tramite.getTrabajo();
			}
		}

		return trabajo;
	}

	@Override
	public Boolean checkTiposDistintos(TareaExterna tareaExterna) {
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		Activo activo;
		if (!Checks.esNulo(trabajo))
			activo = trabajo.getActivo();
		else
			activo = ((TareaActivo) tareaExterna.getTareaPadre()).getActivo();

		if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoActivo())) {
			if (!Checks.esNulo(activo.getInfoComercial())) {
				if (!Checks.esNulo(activo.getInfoComercial().getTipoActivo()))
					return (!activo.getTipoActivo().getCodigo()
							.equals(activo.getInfoComercial().getTipoActivo().getCodigo()));
			}
		}

		return true;
	}

	@Override
	public Boolean checkTiposDistintos(Activo activo) {
		if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoActivo())) {
			if (!Checks.esNulo(activo.getInfoComercial())) {
				if (!Checks.esNulo(activo.getInfoComercial().getTipoActivo()))
					return (!activo.getTipoActivo().getCodigo()
							.equals(activo.getInfoComercial().getTipoActivo().getCodigo()));
			}
		}

		return true;
	}

	public GastosExpediente anyadirGastoExpediente(Oferta oferta, DDAccionGastos accionGasto,
			ExpedienteComercial nuevoExpediente) {
		GastosExpediente gastoExpediente = new GastosExpediente();
		if (!Checks.esNulo(oferta.getCustodio())) {
			gastoExpediente.setNombre(oferta.getCustodio().getNombre());
			gastoExpediente.setCodigo(oferta.getCustodio().getCodProveedorUvem());
			gastoExpediente.setProveedor(oferta.getCustodio());
		}

		gastoExpediente.setAccionGastos(accionGasto);
		gastoExpediente.setExpediente(nuevoExpediente);

		return gastoExpediente;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoActivoIntegrado> getProveedoresByActivoIntegrado(DtoActivoIntegrado dtoActivoIntegrado) throws IllegalAccessException, InvocationTargetException {
		boolean esUA = activoDao.isUnidadAlquilable(Long.parseLong(dtoActivoIntegrado.getIdActivo()));
		ActivoAgrupacion agrupacion = activoDao.getAgrupacionPAByIdActivo(Long.parseLong(dtoActivoIntegrado.getIdActivo()));
		Activo activoMatriz = null;
		if (!Checks.esNulo(agrupacion)) {
			activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agrupacion.getId());
		}
		if (esUA) {
			BeanUtils.copyProperties(dtoActivoIntegrado, activoMatriz);
			dtoActivoIntegrado.setIdActivo(activoMatriz.getId().toString());
		}
		
		Filter activoIDFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id",
				Long.parseLong(dtoActivoIntegrado.getIdActivo()));
		Page page = genericDao.getPage(ActivoIntegrado.class, dtoActivoIntegrado, activoIDFilter);
		List<ActivoIntegrado> activosIntegrados = (List<ActivoIntegrado>) page.getResults();
		List<DtoActivoIntegrado> dtoList = new ArrayList<DtoActivoIntegrado>();

		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id",
				Long.parseLong(dtoActivoIntegrado.getIdActivo()));
		Activo activo = genericDao.get(Activo.class, filterAct);
		
		ActivoComunidadPropietarios comunidadPropietarios = activo.getComunidadPropietarios();

		for (ActivoIntegrado activoIntegrado : activosIntegrados) {
			DtoActivoIntegrado dto = new DtoActivoIntegrado();

			try {
				beanUtilNotNull.copyProperty(dto, "id", activoIntegrado.getId());

				if (!Checks.esNulo(activoIntegrado.getProveedor())) {
					beanUtilNotNull.copyProperty(dto, "idProveedor", activoIntegrado.getProveedor().getId());
					beanUtilNotNull.copyProperty(dto, "pagosRetenidos", activoIntegrado.getRetenerPago());
					beanUtilNotNull.copyProperty(dto, "codigoProveedorRem",
							activoIntegrado.getProveedor().getCodigoProveedorRem());
					beanUtilNotNull.copyProperty(dto, "nifProveedor",
							activoIntegrado.getProveedor().getDocIdentificativo());
					beanUtilNotNull.copyProperty(dto, "nombreProveedor", activoIntegrado.getProveedor().getNombre());

					if (!Checks.esNulo(activoIntegrado.getProveedor().getEstadoProveedor())) {
						beanUtilNotNull.copyProperty(dto, "estadoProveedorDescripcion",
								activoIntegrado.getProveedor().getEstadoProveedor().getDescripcion());
					}

					if (!Checks.esNulo(activoIntegrado.getProveedor().getTipoProveedor())) {
						beanUtilNotNull.copyProperty(dto, "subtipoProveedorDescripcion",
								activoIntegrado.getProveedor().getTipoProveedor().getDescripcion());
					}
				}

				beanUtilNotNull.copyProperty(dto, "participacion", activoIntegrado.getParticipacion());
				beanUtilNotNull.copyProperty(dto, "fechaInclusion", activoIntegrado.getFechaInclusion());
				beanUtilNotNull.copyProperty(dto, "fechaExclusion", activoIntegrado.getFechaExclusion());
				beanUtilNotNull.copyProperty(dto, "observaciones", activoIntegrado.getObservaciones());

				if (!Checks.esNulo(comunidadPropietarios)) {
					beanUtilNotNull.copyProperty(dto, "fechaComunicacionComunidad",
							comunidadPropietarios.getFechaComunicacionComunidad());
					beanUtilNotNull.copyProperty(dto, "envioCartas", comunidadPropietarios.getEnvioCartas());
					beanUtilNotNull.copyProperty(dto, "numCartas", comunidadPropietarios.getNumCartas());
					beanUtilNotNull.copyProperty(dto, "contactoTel", comunidadPropietarios.getContactoTel());
					beanUtilNotNull.copyProperty(dto, "visita", comunidadPropietarios.getVisita());
					beanUtilNotNull.copyProperty(dto, "burofax", comunidadPropietarios.getBurofax());
				}

				beanUtilNotNull.copyProperty(dto, "totalCount", page.getTotalCount());
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager", e);

			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager", e);
			}

			dtoList.add(dto);
		}

		return dtoList;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createActivoIntegrado(DtoActivoIntegrado dto) {
		try {
			if (!Checks.esNulo(dto.getCodigoProveedorRem())) {
				ActivoIntegrado activoIntegrado = new ActivoIntegrado();

				if (!Checks.esNulo(dto.getCodigoProveedorRem())) {
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
							Long.parseLong(dto.getCodigoProveedorRem()));
					ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filter);
					activoIntegrado.setProveedor(proveedor);
				}

				if (!Checks.esNulo(dto.getIdActivo())) {
					Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "id",
							Long.parseLong(dto.getIdActivo()));
					Activo activo = genericDao.get(Activo.class, filterActivo);
					activoIntegrado.setActivo(activo);
				}

				activoIntegrado.setObservaciones(dto.getObservaciones());
				if (!Checks.esNulo(dto.getParticipacion())) {
					activoIntegrado.setParticipacion(Double.parseDouble(dto.getParticipacion()));
				}

				activoIntegrado.setFechaInclusion(dto.getFechaInclusion());
				activoIntegrado.setFechaExclusion(dto.getFechaExclusion());

				if (!Checks.esNulo(dto.getRetenerPagos())) {
					if (dto.getRetenerPagos()) {
						activoIntegrado.setRetenerPago(1);
					} else {
						activoIntegrado.setRetenerPago(0);
					}
				}

				if (!Checks.esNulo(dto.getMotivoRetencionPago())) {
					DDMotivoRetencion motivoRetencion = (DDMotivoRetencion) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDMotivoRetencion.class, dto.getMotivoRetencionPago());
					activoIntegrado.setMotivoRetencion(motivoRetencion);
				}

				activoIntegrado.setFechaRetencionPago(dto.getFechaRetencionPago());
				genericDao.save(ActivoIntegrado.class, activoIntegrado);
				return true;
			}

		} catch (Exception e) {
			logger.error("Error en activoManager", e);
			return false;
		}

		return false;
	}

	public DtoActivoIntegrado getActivoIntegrado(String id) {
		DtoActivoIntegrado dto = new DtoActivoIntegrado();

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(id));
		ActivoIntegrado activoIntegrado = genericDao.get(ActivoIntegrado.class, filter);

		if (!Checks.esNulo(activoIntegrado)) {
			if (!Checks.esNulo(activoIntegrado.getActivo())) {
				dto.setIdActivo(activoIntegrado.getActivo().getId().toString());
			}

			if (!Checks.esNulo(activoIntegrado.getProveedor())) {
				if (!Checks.esNulo(activoIntegrado.getProveedor().getCodigoProveedorRem())) {
					dto.setCodigoProveedorRem(activoIntegrado.getProveedor().getCodigoProveedorRem().toString());
				}
				dto.setNombreProveedor(activoIntegrado.getProveedor().getNombre());
				dto.setNifProveedor(activoIntegrado.getProveedor().getDocIdentificativo());
				if (!Checks.esNulo(activoIntegrado.getProveedor().getTipoProveedor()) && !Checks
						.esNulo(activoIntegrado.getProveedor().getTipoProveedor().getTipoEntidadProveedor())) {
					dto.setSubtipoProveedorDescripcion(activoIntegrado.getProveedor().getTipoProveedor()
							.getTipoEntidadProveedor().getDescripcion());
				}
			}

			dto.setObservaciones(activoIntegrado.getObservaciones());
			if (!Checks.esNulo(activoIntegrado.getParticipacion())) {
				dto.setParticipacion(activoIntegrado.getParticipacion().toString());
			}
			dto.setFechaInclusion(activoIntegrado.getFechaInclusion());
			dto.setFechaExclusion(activoIntegrado.getFechaExclusion());
			if (!Checks.esNulo(activoIntegrado.getRetenerPago())) {
				if (activoIntegrado.getRetenerPago() == 1) {
					dto.setRetenerPagos(true);
				} else {
					dto.setRetenerPagos(false);
				}
			}

			if (!Checks.esNulo(activoIntegrado.getMotivoRetencion())) {
				dto.setMotivoRetencionPago(activoIntegrado.getMotivoRetencion().getCodigo());
			}
			dto.setFechaRetencionPago(activoIntegrado.getFechaRetencionPago());
		}

		return dto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateActivoIntegrado(DtoActivoIntegrado dto) {
		try {
			Filter filterActivoIntegrado = genericDao.createFilter(FilterType.EQUALS, "id",
					Long.parseLong(dto.getId()));
			ActivoIntegrado activoIntegrado = genericDao.get(ActivoIntegrado.class, filterActivoIntegrado);

			beanUtilNotNull.copyProperties(activoIntegrado, dto);

			if (!Checks.esNulo(dto.getCodigoProveedorRem())) {
				Filter filterProveedor = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
						Long.parseLong(dto.getCodigoProveedorRem()));
				ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filterProveedor);
				activoIntegrado.setProveedor(proveedor);
			}

			if (!Checks.esNulo(dto.getIdActivo())) {
				Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "id",
						Long.parseLong(dto.getIdActivo()));
				Activo activo = genericDao.get(Activo.class, filterActivo);
				activoIntegrado.setActivo(activo);
			}

			if (!Checks.esNulo(dto.getObservaciones())) {
				activoIntegrado.setObservaciones(dto.getObservaciones());
			}

			if (!Checks.esNulo(dto.getParticipacion())) {
				activoIntegrado.setParticipacion(Double.parseDouble(dto.getParticipacion()));
			}

			if (!Checks.esNulo(dto.getRetenerPagos())) {
				if (dto.getRetenerPagos()) {
					activoIntegrado.setRetenerPago(1);

				} else {
					activoIntegrado.setRetenerPago(0);
					activoIntegrado.setMotivoRetencion(null);
					activoIntegrado.setFechaRetencionPago(null);
				}
			}

			if (!Checks.esNulo(dto.getMotivoRetencionPago())) {
				DDMotivoRetencion motivoRetencion = (DDMotivoRetencion) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDMotivoRetencion.class, dto.getMotivoRetencionPago());
				activoIntegrado.setMotivoRetencion(motivoRetencion);
			}

			genericDao.update(ActivoIntegrado.class, activoIntegrado);
			
			return true;

		} catch (Exception e) {
			logger.error(e);
			return false;
		}
	}

	@Override
	public int cantidadOfertas(Activo activo) {
		int res = 0;

		for (ActivoOferta activoOferta : activo.getOfertas()) {
			if (activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals("01")
					|| activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals("04")) {
				res++;
			}
		}

		return res;
	}

	@Override
	public Double mayorOfertaRecibida(Activo activo) {
		Double importeMax = 0D;

		for (ActivoOferta activoOferta : activo.getOfertas()) {
			if (activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals("01")
					|| activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals("04")) {
				if (Double.compare(activoOferta.getPrimaryKey().getOferta().getImporteOferta(), importeMax) > 0) {
					importeMax = activoOferta.getPrimaryKey().getOferta().getImporteOferta();
				}
			}
		}

		return importeMax;
	}

	@Override
	public boolean checkVPO(TareaExterna tareaExterna) {
		Activo activo = tareaExternaToActivo(tareaExterna);
		return (1 == activo.getVpo());
	}

	@Override
	@SuppressWarnings("unchecked")
	public DtoPage getListHistoricoOcupacionesIlegales(WebDto dto, Long idActivo) {

		Page page;

		page = activoDao.getListHistoricoOcupacionesIlegalesByActivo(dto, idActivo);

		List<DtoOcupacionIlegal> listaOcupacionesIlegales = new ArrayList<DtoOcupacionIlegal>();

		for (ActivoOcupacionIlegal ocupacionIlegal : (List<ActivoOcupacionIlegal>) page.getResults()) {

			DtoOcupacionIlegal dtoOcu = this.ocupacionToDto(ocupacionIlegal);

			listaOcupacionesIlegales.add(dtoOcu);
		}

		return new DtoPage(listaOcupacionesIlegales, page.getTotalCount());
	}

	private DtoOcupacionIlegal ocupacionToDto(ActivoOcupacionIlegal ocupacion) {

		DtoOcupacionIlegal dtoOcu = new DtoOcupacionIlegal();

		try {
			BeanUtils.copyProperties(dtoOcu, ocupacion);

			if (!Checks.esNulo(ocupacion.getTipoAsunto())) {
				BeanUtils.copyProperty(dtoOcu, "tipoAsunto", ocupacion.getTipoAsunto().getDescripcion());
			}

			if (!Checks.esNulo(ocupacion.getTipoActuacion())) {
				BeanUtils.copyProperty(dtoOcu, "tipoActuacion", ocupacion.getTipoActuacion().getDescripcion());
			}

		} catch (IllegalAccessException ex) {
			logger.error("Error en activoManager", ex);
		} catch (InvocationTargetException ex) {
			logger.error("Error en activoManager", ex);
		}

		return dtoOcu;
	}

	@Override
	@SuppressWarnings("unchecked")
	public DtoPage getListLlavesByActivo(DtoLlaves dto) {
		Page page = activoDao.getLlavesByActivo(dto);

		List<DtoLlaves> llaves = new ArrayList<DtoLlaves>();

		for (ActivoLlave llave : (List<ActivoLlave>) page.getResults()) {
			DtoLlaves dtoLlave = this.llavesToDto(llave);
			llaves.add(dtoLlave);
		}

		return new DtoPage(llaves, page.getTotalCount());
	}

	private DtoLlaves llavesToDto(ActivoLlave llave) {
		DtoLlaves dtoLLave = new DtoLlaves();

		try {
			BeanUtils.copyProperties(dtoLLave, llave);

			if (!Checks.esNulo(llave.getActivo())) {
				BeanUtils.copyProperty(dtoLLave, "idActivo", llave.getActivo().getId().toString());
			}

		} catch (IllegalAccessException ex) {
			logger.error("Error en activoManager", ex);

		} catch (InvocationTargetException ex) {
			logger.error("Error en activoManager", ex);
		}

		return dtoLLave;
	}

	@Override
	@SuppressWarnings("unchecked")
	public DtoPage getListMovimientosLlaveByLlave(WebDto dto, Long idLlave, Long idActivo) {
		Page page;
		if (!Checks.esNulo(idLlave))
			page = activoDao.getListMovimientosLlaveByLlave(dto, idLlave);
		else
			page = activoDao.getListMovimientosLlaveByActivo(dto, idActivo);

		List<DtoMovimientoLlave> movimientos = new ArrayList<DtoMovimientoLlave>();

		for (ActivoMovimientoLlave movimiento : (List<ActivoMovimientoLlave>) page.getResults()) {
			DtoMovimientoLlave dtoMov = this.movimientoToDto(movimiento);
			movimientos.add(dtoMov);
		}

		return new DtoPage(movimientos, page.getTotalCount());
	}

	private DtoMovimientoLlave movimientoToDto(ActivoMovimientoLlave movimiento) {
		DtoMovimientoLlave dtoMov = new DtoMovimientoLlave();

		try {
			BeanUtils.copyProperties(dtoMov, movimiento);

			if (!Checks.esNulo(movimiento.getActivoLlave())) {
				BeanUtils.copyProperty(dtoMov, "idLlave", movimiento.getActivoLlave().getId().toString());
				BeanUtils.copyProperty(dtoMov, "numLlave", movimiento.getActivoLlave().getNumLlave());
			}

			if (!Checks.esNulo(movimiento.getTipoTenedor())) {
				BeanUtils.copyProperty(dtoMov, "codigoTipoTenedor", movimiento.getTipoTenedor().getCodigo());
				BeanUtils.copyProperty(dtoMov, "descripcionTipoTenedor", movimiento.getTipoTenedor().getDescripcion());
			}

		} catch (IllegalAccessException ex) {
			logger.error("Error en activoManager", ex);

		} catch (InvocationTargetException ex) {
			logger.error("Error en activoManager", ex);
		}

		return dtoMov;
	}

	@Override
	@Transactional(readOnly = false)
	public void actualizarFechaYEstadoCargaPropuesta(Long idPropuesta) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numPropuesta", idPropuesta);
		PropuestaPrecio propuesta = genericDao.get(PropuestaPrecio.class, filtro);

		if (!Checks.esNulo(propuesta)) {
			propuesta.setFechaCarga(new Date());

			DDEstadoPropuestaPrecio estado = (DDEstadoPropuestaPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(
					DDEstadoPropuestaPrecio.class, DDEstadoPropuestaPrecio.ESTADO_SANCIONADA);
			propuesta.setEstado(estado);

			genericDao.update(PropuestaPrecio.class, propuesta);
		}
	}

	@Override
	public ActivoTasacion getTasacionMasReciente(Activo activo) {
		ActivoTasacion tasacionMasReciente = null;
		List<ActivoTasacion> tasacionesActivo = activo.getTasacion();

		if (!Checks.estaVacio(tasacionesActivo)) {
			tasacionMasReciente = tasacionesActivo.get(0);
			if (tasacionMasReciente != null) {
				Date fechaValorTasacionMasReciente = new Date();

				if (!Checks.esNulo(tasacionMasReciente.getValoracionBien())
						&& !Checks.esNulo(tasacionMasReciente.getValoracionBien().getFechaValorTasacion())) {
					fechaValorTasacionMasReciente = tasacionMasReciente.getValoracionBien().getFechaValorTasacion();
				}

				for (ActivoTasacion tas : tasacionesActivo) {
					if (tas.getValoracionBien().getFechaValorTasacion() != null) {
						if (!Checks.esNulo(tas) && !Checks.esNulo(tas.getValoracionBien())
								&& !Checks.esNulo(tas.getValoracionBien().getFechaValorTasacion())
								&& tas.getValoracionBien().getFechaValorTasacion()
										.after(fechaValorTasacionMasReciente)) {
							fechaValorTasacionMasReciente = tas.getValoracionBien().getFechaValorTasacion();
							tasacionMasReciente = tas;
						}
					}
				}
			}
		}

		return tasacionMasReciente;
	}

	@Override
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

	@Override
	public Boolean getDptoPrecio(Activo activo) {
		return activoDao.getDptoPrecio(activo);
	}

	@Override
	public DtoComercialActivo getComercialActivo(DtoComercialActivo dto) {
		// Date fechaVenta = null;
		Date fechaVentaExterna = null;
		Double importeVentaExterna = null;
		
		
		if (Checks.esNulo(dto.getId())) {
			return dto;
		}
		
		Activo activo = activoDao.get(Long.parseLong(dto.getId()));
		dto.setExpedienteComercialVivo(false);
		

		try {
			if (!Checks.esNulo(activo.getSituacionComercial())) {
				beanUtilNotNull.copyProperty(dto, "situacionComercialCodigo",
						activo.getSituacionComercial().getCodigo());
			}
			

			// Obtener oferta aceptada. Si tiene, establecer expediente
			// comercial vivo a true.Qué se solicita
			Oferta oferta = this.tieneOfertaAceptada(activo);
			if (!Checks.esNulo(oferta)) {
				dto.setExpedienteComercialVivo(true);
				// Obtener expediente comercial de la oferta aprobado.
				ExpedienteComercial exp = genericDao.get(ExpedienteComercial.class,
						genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId()));
				// Obtener datos de venta en REM.
				if (!Checks.esNulo(exp)) {
					beanUtilNotNull.copyProperty(dto, "fechaVenta", exp.getFechaVenta());
					// fechaVenta = exp.getFechaVenta();
					Double importe = null;

					if (!Checks.esNulo(activo.getSituacionComercial())
							&& (DDSituacionComercial.CODIGO_VENDIDO.equals(activo.getSituacionComercial().getCodigo())
									|| DDSituacionComercial.CODIGO_TRASPASADO
											.equals(activo.getSituacionComercial().getCodigo()))) {

						if (!Checks.esNulo(oferta.getImporteContraOferta())) {
							importe = oferta.getImporteContraOferta();
						} else {
							importe = oferta.getImporteOferta();
						}
						for (ActivoOferta activoOferta : oferta.getActivosOferta()) {
							if (activo.getId().equals(activoOferta.getPrimaryKey().getActivo().getId())) {
								importe = activoOferta.getImporteActivoOferta();
							}
						}
					}

					beanUtilNotNull.copyProperty(dto, "importeVenta", importe);
				}

			} else {
				beanUtilNotNull.copyProperty(dto, "importeVenta", null);
			}

			fechaVentaExterna = activo.getFechaVentaExterna();
			importeVentaExterna = activo.getImporteVentaExterna();

			// Si no existe oferta aceptada con expediente obtener datos de
			// posible venta externa a REM.
			if (!dto.getExpedienteComercialVivo()) {
				beanUtilNotNull.copyProperty(dto, "expedienteComercialVivo", false);
				if (!Checks.esNulo(fechaVentaExterna)) {
					beanUtilNotNull.copyProperty(dto, "fechaVenta", fechaVentaExterna);
				}
				if (!Checks.esNulo(importeVentaExterna)) {
					beanUtilNotNull.copyProperty(dto, "importeVenta", importeVentaExterna);
				}
			}

			if (!Checks.esNulo(fechaVentaExterna) && !Checks.esNulo(importeVentaExterna)) {
				beanUtilNotNull.copyProperty(dto, "ventaExterna", true);
			} else {
				beanUtilNotNull.copyProperty(dto, "ventaExterna", !Checks.esNulo(fechaVentaExterna));
			}

			if (!Checks.esNulo(activo.getObservacionesVentaExterna())) {
				beanUtilNotNull.copyProperty(dto, "observaciones", activo.getObservacionesVentaExterna());
			}
			if (!Checks.esNulo(activo.getEstaEnPuja())) {
				beanUtilNotNull.copyProperty(dto, "puja", activo.getEstaEnPuja());
			}
			if (!Checks.esNulo(activo.getActivoAutorizacionTramitacionOfertas())) {
				beanUtilNotNull.copyProperty(dto, "motivoAutorizacionTramitacionCodigo", activo.getActivoAutorizacionTramitacionOfertas().getMotivoAutorizacionTramitacion().getCodigo());
				beanUtilNotNull.copyProperty(dto, "observacionesAutoTram", activo.getActivoAutorizacionTramitacionOfertas().getObservacionesAutoTram());
			}

		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
		}

		if(!Checks.esNulo(activo) && activoDao.isActivoMatriz(activo.getId())) {	
			dto.setCamposPropagablesUas(TabActivoService.TAB_COMERCIAL);
		}else {
			// Buscamos los campos que pueden ser propagados para esta pestaña
			dto.setCamposPropagables(TabActivoService.TAB_COMERCIAL);
		}
		dto.setTramitable(this.isTramitable(activo));
		
		return dto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveComercialActivo(DtoComercialActivo dto) throws JsonViewerException {
		if (Checks.esNulo(dto.getId())) {
			return false;
		}

		Activo activo = activoDao.get(Long.parseLong(dto.getId()));

		try {
			beanUtilNotNull.copyProperty(activo, "fechaVentaExterna", dto.getFechaVenta());
			beanUtilNotNull.copyProperty(activo, "importeVentaExterna", dto.getImporteVenta());
			if(!Checks.esNulo(dto.getObservaciones())) {
				beanUtilNotNull.copyProperty(activo, "observacionesVentaExterna", dto.getObservaciones().replaceAll("(\n|\r)", " "));
			}else {
				beanUtilNotNull.copyProperty(activo, "observacionesVentaExterna", null);
			}
			dto.setVentaExterna(Checks.esNulo(activo.getFechaVentaExterna()));

			// Si se ha introducido valores en fecha o importe de venta, se
			// actualiza la situación comercial y estado publicación del activo.
			// También son rechazadas las ofertas pendientes.
			if (!Checks.esNulo(dto.getFechaVenta()) || !Checks.esNulo(dto.getImporteVenta())) {
				this.setSituacionComercialAndEstadoPublicacion(activo);
				if (DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())) {
					activo.setVentaDirectaBankia(true);
				}

				List<ActivoOferta> listaActivoOfertas = activo.getOfertas();
				if (listaActivoOfertas != null && listaActivoOfertas.size() > 0) {
					DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_RECHAZADA);

					for (ActivoOferta actOfr : listaActivoOfertas) {
						Oferta oferta = actOfr.getPrimaryKey().getOferta();
						if (oferta.getEstadoOferta() != null
								&& !DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())) {
							oferta.setEstadoOferta(estadoOferta);
							Auditoria auditoriaOferta = oferta.getAuditoria();
							if (auditoriaOferta != null) {
								auditoriaOferta.setFechaModificar(new Date());
								auditoriaOferta.setUsuarioModificar(usuarioApi.getUsuarioLogado().getUsername());
							}

							genericDao.save(Oferta.class, oferta);
						}
					}
				}
			}
			
		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);
			return false;

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
			return false;
		}

		activo.setEstaEnPuja(dto.getPuja());
		activoDao.save(activo);

		return true;
	}

	/**
	 * Cambia la situacion Comercial a 'Vendido' y el estado Publicación a 'No
	 * Publicado', al vender el activo (insertar valor en fecha venta o importe
	 * venta del activo)
	 *
	 * @param activo
	 * @throws JsonViewerException
	 */
	private void setSituacionComercialAndEstadoPublicacion(Activo activo) throws JsonViewerException {
		if (!Checks.esNulo(activo.getFechaVentaExterna()) || !Checks.esNulo(activo.getImporteVentaExterna())) {
			// Situación comercial --------
			DDSituacionComercial situacionComercial = (DDSituacionComercial) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDSituacionComercial.class, DDSituacionComercial.CODIGO_VENDIDO);

			if (!Checks.esNulo(situacionComercial))
				activo.setSituacionComercial(situacionComercial);

			// Estado publicación ----------
			activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
		}
	}

	public boolean isIntegradoAgrupacionObraNuevaOrAsistida(Activo activo) {
		Integer contador = activoDao.isIntegradoAgrupacionObraNuevaOrAsistida(activo.getId());
		return contador > 0;
	}

	@Override
	public Double getImporteValoracionActivoByCodigo(Activo activo, String codTipoPrecio) {
		List<ActivoValoraciones> listActivoValoracion = activo.getValoracion();
		if (!Checks.estaVacio(listActivoValoracion)) {
			for (ActivoValoraciones valoracion : listActivoValoracion) {
				if (codTipoPrecio.equals(valoracion.getTipoPrecio().getCodigo())
						&& (Checks.esNulo(valoracion.getFechaFin()) || valoracion.getFechaFin().after(new Date()))) {
					return valoracion.getImporte();
				}
			}
		}

		return null;
	}

	@Override
	public String getSubtipoTrabajoByOferta(Oferta oferta) {
		if (oferta.getTipoOferta().getCodigo().equals(DDTipoOferta.CODIGO_VENTA)) {
			return DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_VENTA;
		} else {
			return DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_ALQUILER;
		}
			
	}

	@Transactional(readOnly = false)
	public Boolean saveActivoCarga(DtoActivoCargas cargaDto) {
		ActivoCargas cargaSeleccionada = null;

		if (!Checks.esNulo(cargaDto.getIdActivoCarga())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", cargaDto.getIdActivoCarga());
			cargaSeleccionada = genericDao.get(ActivoCargas.class, filtro);

		} else {
			cargaSeleccionada = new ActivoCargas();

			Activo activo = get(cargaDto.getIdActivo());
			cargaSeleccionada.setActivo(activo);
			NMBBienCargas cargaBien = new NMBBienCargas();
			DDTipoCarga tipoCargaBien = (DDTipoCarga) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCarga.class,
					"0");
			cargaBien.setTipoCarga(tipoCargaBien);
			cargaBien.setBien(activo.getBien());
			cargaBien.setEconomica(false);
			genericDao.save(NMBBienCargas.class, cargaBien);
			cargaSeleccionada.setCargaBien(cargaBien);
			cargaSeleccionada.setOrigenDato((DDOrigenDato) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDOrigenDato.class, DDOrigenDato.CODIGO_REM));
		}

		try {
			beanUtilNotNull.copyProperties(cargaSeleccionada, cargaDto);
			beanUtilNotNull.copyProperties(cargaSeleccionada.getCargaBien(), cargaDto);

			if (!Checks.esNulo(cargaDto.getEstadoCodigo())) {
				DDEstadoCarga estadoCarga = (DDEstadoCarga) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDEstadoCarga.class, cargaDto.getEstadoCodigo());
				cargaSeleccionada.setEstadoCarga(estadoCarga);
			}
			
			if(!Checks.esNulo(cargaDto.getCodigoImpideVenta())) {
				DDSiNo dd = genericDao.get(DDSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", cargaDto.getCodigoImpideVenta()));
				cargaSeleccionada.setImpideVenta(dd);
			}

			if (!Checks.esNulo(cargaDto.getEstadoEconomicaCodigo())) {
				DDSituacionCarga situacionCarga = (DDSituacionCarga) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSituacionCarga.class, cargaDto.getEstadoEconomicaCodigo());
				cargaSeleccionada.getCargaBien().setSituacionCargaEconomica(situacionCarga);
			}

			if (!Checks.esNulo(cargaDto.getTipoCargaCodigo())) {
				DDTipoCargaActivo tipoCarga = (DDTipoCargaActivo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoCargaActivo.class, cargaDto.getTipoCargaCodigo());
				cargaSeleccionada.setTipoCargaActivo(tipoCarga);
			}

			if (!Checks.esNulo(cargaDto.getSubtipoCargaCodigo())) {
				DDSubtipoCarga subtipoCarga = (DDSubtipoCarga) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSubtipoCarga.class, cargaDto.getSubtipoCargaCodigo());
				cargaSeleccionada.setSubtipoCarga(subtipoCarga);
			}
			
			if (!Checks.esNulo(cargaDto.getSubestadoCodigo())) {
				DDSubestadoCarga subestadoCarga = (DDSubestadoCarga) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSubestadoCarga.class, cargaDto.getSubestadoCodigo());
				cargaSeleccionada.setSubestadoCarga(subestadoCarga);
			}

			// HREOS-2733
			if (!Checks.esNulo(cargaDto.getOrigenDatoCodigo())) {
				DDOrigenDato origenDato = (DDOrigenDato) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDOrigenDato.class, cargaDto.getOrigenDatoCodigo());
				cargaSeleccionada.setOrigenDato(origenDato);
			}

		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
		}

		activoCargasApi.saveOrUpdate(cargaSeleccionada);
		
		if (!Checks.esNulo(cargaSeleccionada) && !Checks.esNulo(cargaSeleccionada.getActivo()) && !Checks.esNulo(cargaSeleccionada.getActivo().getId())) {
			activoCargasDao.calcularEstadoCargaActivo(cargaSeleccionada.getActivo().getId(), genericAdapter.getUsuarioLogado().getUsername(), true);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public Boolean saveActivoCargaTab(DtoActivoCargasTab cargaDto) {
		if (!Checks.esNulo(cargaDto.getIdActivo())) {
			Activo activo = get(cargaDto.getIdActivo());
			if (!Checks.esNulo(cargaDto.getFechaRevisionCarga())) {
				activo.setFechaRevisionCarga(cargaDto.getFechaRevisionCarga());
				genericDao.update(Activo.class, activo);
				return true;
			}
		}

		return false;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean updateActivoPropietarioTab(DtoPropietario propietario) {
		Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id",
				Long.parseLong(propietario.getIdActivo()));
		Filter proFilter = genericDao.createFilter(FilterType.EQUALS, "propietario.id",
				Long.parseLong(propietario.getIdPropietario()));
		if (propietario.getTipoPropietario().equals("Principal")) {

			ActivoPropietarioActivo propietarioActivo = genericDao.get(ActivoPropietarioActivo.class, activoFilter,
					proFilter);

			propietarioActivo.setPorcPropiedad(propietario.getPorcPropiedad());

			Filter propiedadFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
					propietario.getTipoGradoPropiedadCodigo());
			DDTipoGradoPropiedad tipoGrado = genericDao.get(DDTipoGradoPropiedad.class, propiedadFilter);
			propietarioActivo.setTipoGradoPropiedad(tipoGrado);

			genericDao.update(ActivoPropietarioActivo.class, propietarioActivo);
			return true;

		} else if (propietario.getTipoPropietario().equals("Copropietario")) {
			Filter cproFilter = genericDao.createFilter(FilterType.EQUALS, "coPropietario.id",
					Long.parseLong(propietario.getIdPropietario()));
			Filter idProFilter = genericDao.createFilter(FilterType.EQUALS, "id",
					Long.parseLong(propietario.getIdPropietario()));
			ActivoCopropietarioActivo copropietarioActivo = genericDao.get(ActivoCopropietarioActivo.class,
					activoFilter, cproFilter);
			ActivoCopropietario copropietario = genericDao.get(ActivoCopropietario.class, idProFilter);

			if (!Checks.esNulo(propietario.getPorcPropiedad())) {
				copropietarioActivo.setPorcPropiedad(propietario.getPorcPropiedad());

			} else {
				return false;
			}

			if (!Checks.esNulo(propietario.getTipoGradoPropiedadCodigo())) {
				Filter propiedadFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getTipoGradoPropiedadCodigo());
				DDTipoGradoPropiedad tipoGrado = genericDao.get(DDTipoGradoPropiedad.class, propiedadFilter);
				copropietarioActivo.setTipoGradoPropiedad(tipoGrado);

			} else {
				return false;
			}

			if (!Checks.esNulo(propietario.getTipoPersonaCodigo())) {
				Filter personaFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getTipoPersonaCodigo());
				DDTipoPersona tipoPersona = genericDao.get(DDTipoPersona.class, personaFilter);
				copropietario.setTipoPersona(tipoPersona);
			}

			if (!Checks.esNulo(propietario.getNombre())) {
				copropietario.setNombre(propietario.getNombre());

			} else {
				return false;
			}

			if (!Checks.esNulo(propietario.getTipoDocIdentificativoCodigo())) {
				Filter docFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getTipoDocIdentificativoCodigo());
				DDTipoDocumento tipoDocumento = genericDao.get(DDTipoDocumento.class, docFilter);
				copropietario.setTipoDocIdentificativo(tipoDocumento);
			}

			if (!Checks.esNulo(propietario.getDocIdentificativo())) {
				copropietario.setDocIdentificativo(propietario.getDocIdentificativo());
			}

			if (!Checks.esNulo(propietario.getDireccion())) {
				copropietario.setDireccion(propietario.getDireccion());
			}

			if (!Checks.esNulo(propietario.getProvinciaCodigo())) {
				Filter provFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getProvinciaCodigo());
				DDProvincia provincia = genericDao.get(DDProvincia.class, provFilter);
				copropietario.setProvincia(provincia);
			}

			if (!Checks.esNulo(propietario.getLocalidadCodigo())) {
				Filter locFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getLocalidadCodigo());
				Localidad localidad = genericDao.get(Localidad.class, locFilter);
				copropietario.setLocalidad(localidad);
			}

			if (!Checks.esNulo(propietario.getCodigoPostal())) {
				copropietario.setCodigoPostal(Integer.parseInt(propietario.getCodigoPostal()));
			}

			if (!Checks.esNulo(propietario.getTelefono())) {
				copropietario.setTelefono(propietario.getTelefono());
			}

			if (!Checks.esNulo(propietario.getEmail())) {
				copropietario.setEmail(propietario.getEmail());
			}

			if (!Checks.esNulo(propietario.getNombreContacto())) {
				copropietario.setNombreContacto(propietario.getNombreContacto());
			}

			if (!Checks.esNulo(propietario.getTelefono1Contacto())) {
				copropietario.setTelefono1Contacto(propietario.getTelefono1Contacto());
			}

			if (!Checks.esNulo(propietario.getTelefono2Contacto())) {
				copropietario.setTelefono2Contacto(propietario.getTelefono2Contacto());
			}

			if (!Checks.esNulo(propietario.getEmailContacto())) {
				copropietario.setEmailContacto(propietario.getEmailContacto());
			}

			if (!Checks.esNulo(propietario.getDireccionContacto())) {
				copropietario.setDireccionContacto(propietario.getDireccionContacto());
			}

			if (!Checks.esNulo(propietario.getProvinciaContactoCodigo())) {
				Filter provFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getProvinciaContactoCodigo());
				DDProvincia provincia = genericDao.get(DDProvincia.class, provFilter);
				copropietario.setProvinciaContacto(provincia);
			}

			if (!Checks.esNulo(propietario.getLocalidadContactoCodigo())) {
				Filter locFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getLocalidadContactoCodigo());
				Localidad localidad = genericDao.get(Localidad.class, locFilter);
				copropietario.setLocalidadContacto(localidad);
			}

			if (!Checks.esNulo(propietario.getCodigoPostalContacto())) {
				copropietario.setCodigoPostalContacto(Integer.parseInt(propietario.getCodigoPostalContacto()));
			}

			if (!Checks.esNulo(propietario.getObservaciones())) {
				copropietario.setObservaciones(propietario.getObservaciones());
			}

			genericDao.update(ActivoCopropietario.class, copropietario);
			genericDao.update(ActivoCopropietarioActivo.class, copropietarioActivo);

			return true;
		}

		return false;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean createActivoPropietarioTab(DtoPropietario propietario) {
		if (!Checks.esNulo(propietario.getIdActivo())) {
			ActivoCopropietarioActivo copropietarioActivo = new ActivoCopropietarioActivo();
			ActivoCopropietario copropietario = new ActivoCopropietario();

			Filter actFilter = genericDao.createFilter(FilterType.EQUALS, "id",
					Long.parseLong(propietario.getIdActivo()));
			Activo activo = genericDao.get(Activo.class, actFilter);
			copropietarioActivo.setActivo(activo);

			if (!Checks.esNulo(propietario.getPorcPropiedad())) {
				copropietarioActivo.setPorcPropiedad(propietario.getPorcPropiedad());
			} else {
				return false;
			}

			if (!Checks.esNulo(propietario.getTipoGradoPropiedadCodigo())) {
				Filter propiedadFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getTipoGradoPropiedadCodigo());
				DDTipoGradoPropiedad tipoGrado = genericDao.get(DDTipoGradoPropiedad.class, propiedadFilter);
				copropietarioActivo.setTipoGradoPropiedad(tipoGrado);

			} else {
				return false;
			}

			if (!Checks.esNulo(propietario.getTipoPersonaCodigo())) {
				Filter personaFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getTipoPersonaCodigo());
				DDTipoPersona tipoPersona = genericDao.get(DDTipoPersona.class, personaFilter);
				copropietario.setTipoPersona(tipoPersona);
			}

			if (!Checks.esNulo(propietario.getNombre())) {
				copropietario.setNombre(propietario.getNombre());

			} else {
				return false;
			}

			if (!Checks.esNulo(propietario.getTipoDocIdentificativoCodigo())) {
				Filter docFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getTipoDocIdentificativoCodigo());
				DDTipoDocumento tipoDocumento = genericDao.get(DDTipoDocumento.class, docFilter);
				copropietario.setTipoDocIdentificativo(tipoDocumento);
			}

			if (!Checks.esNulo(propietario.getDocIdentificativo())) {
				copropietario.setDocIdentificativo(propietario.getDocIdentificativo());
			}

			if (!Checks.esNulo(propietario.getDireccion())) {
				copropietario.setDireccion(propietario.getDireccion());
			}

			if (!Checks.esNulo(propietario.getProvinciaCodigo())) {
				Filter provFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getProvinciaCodigo());
				DDProvincia provincia = genericDao.get(DDProvincia.class, provFilter);
				copropietario.setProvincia(provincia);
			}

			if (!Checks.esNulo(propietario.getLocalidadCodigo())) {
				Filter locFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getLocalidadCodigo());
				Localidad localidad = genericDao.get(Localidad.class, locFilter);
				copropietario.setLocalidad(localidad);
			}

			if (!Checks.esNulo(propietario.getCodigoPostal())) {
				copropietario.setCodigoPostal(Integer.parseInt(propietario.getCodigoPostal()));
			}

			if (!Checks.esNulo(propietario.getTelefono())) {
				copropietario.setTelefono(propietario.getTelefono());
			}

			if (!Checks.esNulo(propietario.getEmail())) {
				copropietario.setEmail(propietario.getEmail());
			}

			if (!Checks.esNulo(propietario.getNombreContacto())) {
				copropietario.setNombreContacto(propietario.getNombreContacto());
			}

			if (!Checks.esNulo(propietario.getTelefono1Contacto())) {
				copropietario.setTelefono1Contacto(propietario.getTelefono1Contacto());
			}

			if (!Checks.esNulo(propietario.getTelefono2Contacto())) {
				copropietario.setTelefono2Contacto(propietario.getTelefono2Contacto());
			}

			if (!Checks.esNulo(propietario.getEmailContacto())) {
				copropietario.setEmailContacto(propietario.getEmailContacto());
			}

			if (!Checks.esNulo(propietario.getDireccionContacto())) {
				copropietario.setDireccionContacto(propietario.getDireccionContacto());
			}

			if (!Checks.esNulo(propietario.getProvinciaContactoCodigo())) {
				Filter provFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getProvinciaContactoCodigo());
				DDProvincia provincia = genericDao.get(DDProvincia.class, provFilter);
				copropietario.setProvinciaContacto(provincia);
			}

			if (!Checks.esNulo(propietario.getLocalidadContactoCodigo())) {
				Filter locFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						propietario.getLocalidadContactoCodigo());
				Localidad localidad = genericDao.get(Localidad.class, locFilter);
				copropietario.setLocalidadContacto(localidad);
			}

			if (!Checks.esNulo(propietario.getCodigoPostalContacto())) {
				copropietario.setCodigoPostalContacto(Integer.parseInt(propietario.getCodigoPostalContacto()));
			}

			if (!Checks.esNulo(propietario.getObservaciones())) {
				copropietario.setObservaciones(propietario.getObservaciones());
			}

			genericDao.save(ActivoCopropietario.class, copropietario);
			copropietarioActivo.setCoPropietario(copropietario);

			genericDao.save(ActivoCopropietarioActivo.class, copropietarioActivo);

			return true;

		} else {
			return false;
		}
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean deleteActivoPropietarioTab(DtoPropietario propietario) {
		if (!Checks.esNulo(propietario.getIdActivo()) && !Checks.esNulo(propietario.getIdPropietario())) {
			Filter actFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id",
					Long.parseLong(propietario.getIdActivo()));
			Filter cprFilter = genericDao.createFilter(FilterType.EQUALS, "coPropietario.id",
					Long.parseLong(propietario.getIdPropietario()));
			Filter coproFilter = genericDao.createFilter(FilterType.EQUALS, "id",
					Long.parseLong(propietario.getIdPropietario()));

			ActivoCopropietarioActivo copropietarioActivo = genericDao.get(ActivoCopropietarioActivo.class, actFilter,
					cprFilter);
			ActivoCopropietario copropietario = genericDao.get(ActivoCopropietario.class, coproFilter);

			genericDao.deleteById(ActivoCopropietarioActivo.class, copropietarioActivo.getId());

			genericDao.deleteById(ActivoCopropietario.class, copropietario.getId());

			return true;

		} else {
			return false;
		}
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean deleteCarga(DtoActivoCargas dto) {
		ActivoCargas carga = null;
		if (!Checks.esNulo(dto.getIdActivoCarga())) {
			carga = genericDao.get(ActivoCargas.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdActivoCarga()));
			if (!Checks.esNulo(carga)) {
				genericDao.deleteById(ActivoCargas.class, carga.getId());
				if (!Checks.esNulo(carga.getActivo()) && !Checks.esNulo(carga.getActivo().getId())) {
					activoCargasDao.calcularEstadoCargaActivo(carga.getActivo().getId(), genericAdapter.getUsuarioLogado().getUsername(), true);
				}
			} else {
				return false;
			}
		}

		return true;
	}

	@Override
	public void calcularRatingActivo(Long idActivo) {
		activoDao.actualizarRatingActivo(idActivo, usuarioApi.getUsuarioLogado().getUsername());
	}

	@SuppressWarnings("static-access")
	private void asignarGestorYSupervisorFormalizacionToExpediente(ExpedienteComercial expediente) {
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
		ActivoAgrupacion agrupacion = null;
		Activo activo = null;

		if (!Checks.esNulo(oferta)) {
			/*
			 * Antes se diferenciaba entre agrupacion lote comercial y lote
			 * restringido Comercial: Asignaba los gestores que hubiese en la
			 * ficha del activo Restringida: Llama al procedimiento de balanceo
			 * (como si fuera un activo individual Ahora se quieren tod..os
			 * iguales, la unica diferencia es que el lote comercial no tiene
			 * activo principal y el resto si (restringida y activo unico)
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
					if(!Checks.esNulo(nuevoGestorF) && !Checks.esNulo(nuevoGestorF.getUsuario())) {
						idUsuarioGestorFormalizacion = nuevoGestorF.getUsuario().getId();// flag
					}
					f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", "GCOM");
					tipoGestor = genericDao.get(EXTDDTipoGestor.class, f1);
					f3 = genericDao.createFilter(FilterType.EQUALS, "tipoGestor", tipoGestor);
					GestorActivo nuevoGestorC = genericDao.get(GestorActivo.class, f2, f3);
					if(!Checks.esNulo(nuevoGestorC) && !Checks.esNulo(nuevoGestorC.getUsuario())) {
						usuarioGestorComercial = nuevoGestorC.getUsuario();
					}					

				} else if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR) || activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_LIBERBANK)){
					idUsuarioGestorFormalizacion = gestorExpedienteComercialDao
							.getUsuarioGestorFormalizacion(activo.getId());
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
			}
		}

		PerimetroActivo perimetro = getPerimetroByIdActivo(activo.getId());

		if (!Checks.esNulo(perimetro) && !Checks.esNulo(perimetro.getAplicaFormalizar())
				&& BooleanUtils.toBoolean(perimetro.getAplicaFormalizar())) {
			if (!Checks.esNulo(usuarioGestorFormalizacion)) {
				this.agregarTipoGestorYUsuarioEnDto(GestorExpedienteComercialApi.CODIGO_GESTOR_FORMALIZACION,
						usuarioGestorFormalizacion.getUsername(), dto);
			} else {
				this.agregarTipoGestorYUsuarioEnDto(GestorExpedienteComercialApi.CODIGO_GESTOR_FORMALIZACION,
						"GESTFORM", dto);
			}

			if (!activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_THIRD_PARTY)) {
				if (!activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)) {
					this.agregarTipoGestorYUsuarioEnDto(GestorExpedienteComercialApi.CODIGO_SUPERVISOR_FORMALIZACION,
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
				if(!Checks.esNulo(nuevoSupervisorC) && !Checks.esNulo(nuevoSupervisorC.getUsuario())) {
					usuarioSupervisorComercial = nuevoSupervisorC.getUsuario();// flag
				}
				if (!Checks.esNulo(supervisorFormalzacion)) {
					this.agregarTipoGestorYUsuarioEnDto(GestorExpedienteComercialApi.CODIGO_SUPERVISOR_FORMALIZACION,
							supervisorFormalzacion.getUsuario().getUsername(), dto);
				}
				if (!Checks.esNulo(usuarioSupervisorComercial)) {
					this.agregarTipoGestorYUsuarioEnDto(GestorExpedienteComercialApi.CODIGO_SUPERVISOR_COMERCIAL,
							usuarioSupervisorComercial.getUsername(), dto);
				}
			}

			if (!Checks.esNulo(usuarioGestoriaFormalizacion))
				this.agregarTipoGestorYUsuarioEnDto(GestorExpedienteComercialApi.CODIGO_GESTORIA_FORMALIZACION,
						usuarioGestoriaFormalizacion.getUsername(), dto);
		}

		if (!Checks.esNulo(usuarioGestorComercial))
			this.agregarTipoGestorYUsuarioEnDto(GestorExpedienteComercialApi.CODIGO_GESTOR_COMERCIAL,
					usuarioGestorComercial.getUsername(), dto);


		if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)) {
			if (!Checks.esNulo(usuarioGestorReserva))
				this.agregarTipoGestorYUsuarioEnDto(GestorExpedienteComercialApi.CODIGO_GESTOR_RESERVA_CAJAMAR,
						usuarioGestorReserva.getUsername(), dto);
			if (!Checks.esNulo(usuarioSupervisorReserva))
				this.agregarTipoGestorYUsuarioEnDto(GestorExpedienteComercialApi.CODIGO_SUPERVISOR_RESERVA_CAJAMAR,
						usuarioSupervisorReserva.getUsername(), dto);
			if (!Checks.esNulo(usuarioGestorMinuta))
				this.agregarTipoGestorYUsuarioEnDto(GestorExpedienteComercialApi.CODIGO_GESTOR_MINUTA_CAJAMAR,
						usuarioGestorMinuta.getUsername(), dto);
			if (!Checks.esNulo(usuarioSupervisorMinuta))
				this.agregarTipoGestorYUsuarioEnDto(GestorExpedienteComercialApi.CODIGO_SUPERVISOR_MINUTA_CAJAMAR,
						usuarioSupervisorMinuta.getUsername(), dto);
			if (!Checks.esNulo(usuarioSupervisorFormalizacion))
				this.agregarTipoGestorYUsuarioEnDto(GestorExpedienteComercialApi.CODIGO_SUPERVISOR_FORMALIZACION,
						usuarioSupervisorFormalizacion.getUsername(), dto);
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

	@Override
	public void calcularSingularRetailActivo(Long idActivo) {
		activoDao.actualizarSingularRetailActivo(idActivo, usuarioApi.getUsuarioLogado().getUsername(), 0, 0);
	}

	@Override
	public String getCodigoTipoComercializarByActivo(Long idActivo) {
		return activoDao.getCodigoTipoComercializarByActivo(idActivo);
	}

	@Override
	public boolean checkComercializable(Long idActivo) {
		PerimetroActivo perimetroActivo = this.getPerimetroByIdActivo(idActivo);
		return perimetroActivo.getAplicaComercializar() == 1;
	}

	@Override
	public boolean checkVendido(Long idActivo) {
		Activo activo = this.get(idActivo);
		return this.isActivoVendido(activo);
	}

	@Override
	public boolean isActivoConOfertasVivas(Activo activo) {
		List<ActivoOferta> listaActivoOferta = activo.getOfertas();

		for (ActivoOferta actOfr : listaActivoOferta) {
			Oferta oferta = actOfr.getPrimaryKey().getOferta();
			if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getEstadoOferta())
					&& !DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())) {
				return true;
			}
		}

		return false;
	}

	@Override
	public List<Oferta> getOfertasPendientesOTramitadasByActivo(Activo activo) {
		List<Oferta> listaOfertasVivas = new ArrayList<Oferta>();

		if (!Checks.estaVacio(activo.getOfertas())) {
			for (ActivoOferta actOfr : activo.getOfertas()) {
				Oferta oferta = actOfr.getPrimaryKey().getOferta();
				if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getEstadoOferta())
						&& (DDEstadoOferta.CODIGO_PENDIENTE.equals(oferta.getEstadoOferta().getCodigo())
						|| DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo()))) {
					listaOfertasVivas.add(oferta);
				}
			}
		}

		return listaOfertasVivas;
	}

	@Override
	public List<Oferta> getOfertasPendientesOTramitadasByActivoAgrupacion(ActivoAgrupacion activoAgrupacion) {
		List<Oferta> listaOfertasVivas = new ArrayList<Oferta>();

		if (!Checks.estaVacio(activoAgrupacion.getOfertas())) {
			for (Oferta ofr : activoAgrupacion.getOfertas()) {
				if (!Checks.esNulo(ofr) && !Checks.esNulo(ofr.getEstadoOferta())
						&& (DDEstadoOferta.CODIGO_PENDIENTE.equals(ofr.getEstadoOferta().getCodigo())
						|| DDEstadoOferta.CODIGO_ACEPTADA.equals(ofr.getEstadoOferta().getCodigo()))) {
					listaOfertasVivas.add(ofr);
				}
			}
		}

		return listaOfertasVivas;
	}
	
	@Override
	public List<Oferta> getOfertasTramitadasByActivo(Activo activo) {
		List<Oferta> listaOfertasTramitadas = new ArrayList<Oferta>();

		if (!Checks.estaVacio(activo.getOfertas())) {
			for (ActivoOferta actOfr : activo.getOfertas()) {
				Oferta oferta = actOfr.getPrimaryKey().getOferta();
				if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getEstadoOferta())
						&& DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
					listaOfertasTramitadas.add(oferta);
				}
			}
		}

		return listaOfertasTramitadas;
	}

	@Override
	public Long getNextNumActivoRem() {
		return activoDao.getNextNumActivoRem();
	}

	@Override
	public List<Activo> getListActivosPorID(List<Long> activosID) {
		return activoDao.getListActivosPorID(activosID);
	}

	@Override
	public PerimetroActivo getPerimetroByNumActivo(Long numActivo) {
		PerimetroActivo perimetro = null;
		Activo activo = this.getByNumActivo(numActivo);
		if (activo != null) {
			perimetro = this.getPerimetroByIdActivo(activo.getId());
		}

		return perimetro;
	}

	public String getCodigoTipoComercializacionFromActivo(Activo activo) {
		String codigoTipoComercializacion = null;

		if (this.isIntegradoAgrupacionObraNuevaOrAsistida(activo))
			codigoTipoComercializacion = DDTipoComercializar.CODIGO_RETAIL;
		else if (activo.getTipoUsoDestino() != null && (DDTipoUsoDestino.TIPO_USO_PRIMERA_RESIDENCIA.equals(activo.getTipoUsoDestino().getCodigo())
				|| DDTipoUsoDestino.TIPO_USO_SEGUNDA_RESIDENCIA.equals(activo.getTipoUsoDestino().getCodigo())))
			codigoTipoComercializacion = DDTipoComercializar.CODIGO_RETAIL;
		else {
			Double importeLimite = (double) 500000;

			if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())) {
				Double valorVNC = this.getImporteValoracionActivoByCodigo(activo,
						DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT);
				if (!Checks.esNulo(valorVNC)) {
					if (valorVNC <= importeLimite)
						codigoTipoComercializacion = DDTipoComercializar.CODIGO_RETAIL;
					else
						codigoTipoComercializacion = DDTipoComercializar.CODIGO_SINGULAR;
				}
			} else if (DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_TANGO.equals(activo.getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_GIANTS.equals(activo.getCartera().getCodigo())) {
				importeLimite += 100000;
				Double valorActivo = this.getImporteValoracionActivoByCodigo(activo,
						DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA);

				if (Checks.esNulo(valorActivo) && !Checks.esNulo(this.getTasacionMasReciente(activo))
						&& !Checks.esNulo(this.getTasacionMasReciente(activo).getImporteTasacionFin()))
					valorActivo = this.getTasacionMasReciente(activo).getImporteTasacionFin().doubleValue();

				if (!Checks.esNulo(valorActivo)) {
					if (valorActivo <= importeLimite)
						codigoTipoComercializacion = DDTipoComercializar.CODIGO_RETAIL;
					else
						codigoTipoComercializacion = DDTipoComercializar.CODIGO_SINGULAR;
				} else {
					codigoTipoComercializacion = DDTipoComercializar.CODIGO_RETAIL;
				}
			}
		}

		return codigoTipoComercializacion;
	}

	@Override
	public Usuario getUsuarioMediador(Activo activo) {
		ActivoInfoComercial infoComercial = activo.getInfoComercial();
		if (!Checks.esNulo(infoComercial)) {
			ActivoProveedor proveedor = infoComercial.getMediadorInforme();
			if (!Checks.esNulo(proveedor)) {
				List<ActivoProveedorContacto> proveedorContactoList = genericDao.getList(ActivoProveedorContacto.class,
						genericDao.createFilter(FilterType.EQUALS, "proveedor.id", proveedor.getId()));
				if (!Checks.estaVacio(proveedorContactoList)) {
					for (ActivoProveedorContacto proveedorContacto : proveedorContactoList)
						if (!Checks.esNulo(proveedorContacto.getUsuario()))
							return proveedorContacto.getUsuario();
				}
			}
		}

		return null;
	}

	@Override
	public ActivoProveedor getMediador(Activo activo) {
		ActivoInfoComercial infoComercial = activo.getInfoComercial();
		if (!Checks.esNulo(infoComercial)) {
			return infoComercial.getMediadorInforme();
		}

		return null;
	}

	@Override
	public List<VPreciosVigentes> getPreciosVigentesById(Long id) {
		return activoAdapter.getPreciosVigentesById(id);
	}

	@Override
	public void deleteActivoDistribucion(Long idActivoInfoComercial) {
		activoDao.deleteActivoDistribucion(idActivoInfoComercial);
	}

	@Override
	@Transactional(readOnly = false)
	public void calcularFechaTomaPosesion(Activo activo) {

		ActivoSituacionPosesoria situacionActual = activo.getSituacionPosesoria();

		if (!Checks.esNulo(activo.getTipoTitulo())) {
			if (DDTipoTituloActivo.tipoTituloJudicial.equals(activo.getTipoTitulo().getCodigo())) {

				if (!Checks.esNulo(activo.getAdjJudicial())
						&& !Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien())) {
					if (!Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien().getLanzamientoNecesario())) {
						if (activo.getAdjJudicial().getAdjudicacionBien().getLanzamientoNecesario()) {
							activo.getSituacionPosesoria().setFechaTomaPosesion(
									activo.getAdjJudicial().getAdjudicacionBien().getFechaRealizacionLanzamiento());
						} else {
							if (!Checks.esNulo(
									activo.getAdjJudicial().getAdjudicacionBien().getFechaRealizacionPosesion())) {
								activo.getSituacionPosesoria().setFechaTomaPosesion(
										activo.getAdjJudicial().getAdjudicacionBien().getFechaRealizacionPosesion());
							} else {
								activo.getSituacionPosesoria().setFechaTomaPosesion(null);
							}
						}

					} else {
						if (!Checks
								.esNulo(activo.getAdjJudicial().getAdjudicacionBien().getFechaRealizacionPosesion())) {
							activo.getSituacionPosesoria().setFechaTomaPosesion(
									activo.getAdjJudicial().getAdjudicacionBien().getFechaRealizacionPosesion());
						} else {
							activo.getSituacionPosesoria().setFechaTomaPosesion(null);
						}
					}
				}

			} else if (DDTipoTituloActivo.tipoTituloNoJudicial.equals(activo.getTipoTitulo().getCodigo())
					&& !Checks.esNulo(activo.getAdjNoJudicial()) && !Checks.esNulo(activo.getSituacionPosesoria())) {
				activo.getSituacionPosesoria().setFechaTomaPosesion(activo.getAdjNoJudicial().getFechaTitulo());

			}
		}

		if ((Checks.esNulo(situacionActual) && !Checks.esNulo(activo.getSituacionPosesoria()))
				|| !situacionActual.equals(activo.getSituacionPosesoria())) {
			genericDao.save(ActivoSituacionPosesoria.class, activo.getSituacionPosesoria());
		}

	}

	@Override
	@Transactional
	public void reactivarActivosPorAgrupacion(Long idAgrupacion) {
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(idAgrupacion);

		for (ActivoAgrupacionActivo activo : agrupacion.getActivos()) {
			if (activo.getActivo().getSituacionComercial() != null && !DDSituacionComercial.CODIGO_VENDIDO
					.equals(activo.getActivo().getSituacionComercial().getCodigo())) {
				this.updateActivoAsistida(activo.getActivo());
				updaterState.updaterStateDisponibilidadComercial(activo.getActivo());
				this.saveOrUpdate(activo.getActivo());
			}
		}
	}

	@Override
	public List<DtoActivoPatrimonio> getHistoricoAdecuacionesAlquilerByActivo(Long idActivo) {
		List<ActivoHistoricoPatrimonio> listActHistPatrimonio = activoHistoricoPatrimonioDao
				.getHistoricoAdecuacionesAlquilerByActivo(idActivo);
		List<DtoActivoPatrimonio> listActPatrimonioDto = new ArrayList<DtoActivoPatrimonio>();

		if (!Checks.esNulo(listActHistPatrimonio)) {
			for (ActivoHistoricoPatrimonio activoHistPatrimonio : listActHistPatrimonio) {
				try {
					DtoActivoPatrimonio actPatrimonioDto = new DtoActivoPatrimonio();
					BeanUtils.copyProperties(actPatrimonioDto, activoHistPatrimonio);
					actPatrimonioDto.setIdPatrimonio(!Checks.esNulo(activoHistPatrimonio.getId())
							? activoHistPatrimonio.getId().toString() : null);
					actPatrimonioDto.setIdActivo(!Checks.esNulo(activoHistPatrimonio.getActivo())
							? activoHistPatrimonio.getActivo().getId().toString() : null);
					actPatrimonioDto.setCodigoAdecuacion(!Checks.esNulo(activoHistPatrimonio.getAdecuacionAlquiler())
							? activoHistPatrimonio.getAdecuacionAlquiler().getCodigo() : null);
					actPatrimonioDto
							.setDescripcionAdecuacion(!Checks.esNulo(activoHistPatrimonio.getAdecuacionAlquiler())
									? activoHistPatrimonio.getAdecuacionAlquiler().getDescripcion() : null);
					actPatrimonioDto
							.setDescripcionAdecuacionLarga(!Checks.esNulo(activoHistPatrimonio.getAdecuacionAlquiler())
									? activoHistPatrimonio.getAdecuacionAlquiler().getDescripcionLarga() : null);
					actPatrimonioDto.setCheckPerimetroAlquiler(activoHistPatrimonio.getCheckHPM());
					actPatrimonioDto.setFechaInicioAdecuacion(activoHistPatrimonio.getFechaInicioAdecuacionAlquiler());
					actPatrimonioDto.setFechaFinAdecuacion(activoHistPatrimonio.getFechaFinAdecuacionAlquiler());
					actPatrimonioDto.setFechaInicioPerimetroAlquiler(activoHistPatrimonio.getFechaInicioHPM());
					actPatrimonioDto.setFechaFinPerimetroAlquiler(activoHistPatrimonio.getFechaFinHPM());

					listActPatrimonioDto.add(actPatrimonioDto);

				} catch (IllegalAccessException e) {
					logger.error(e);

				} catch (InvocationTargetException e) {
					logger.error(e);
				}
			}
		}

		return listActPatrimonioDto;
	}

	@Override
	public List<DtoImpuestosActivo> getImpuestosByActivo(Long idActivo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		List<ImpuestosActivo> lista = genericDao.getList(ImpuestosActivo.class, filtro);
		List<DtoImpuestosActivo> listaDto = new ArrayList<DtoImpuestosActivo>();

		if (Checks.esNulo(lista)) {
			return new ArrayList<DtoImpuestosActivo>();

		} else {
			for (ImpuestosActivo impuesto : lista) {
				DtoImpuestosActivo dto = new DtoImpuestosActivo();
				if (!Checks.esNulo(impuesto.getId())) {
					dto.setId(impuesto.getId());
				}
				if (!Checks.esNulo(impuesto.getActivo())) {
					dto.setIdActivo(impuesto.getActivo().getId());
				}
				if (!Checks.esNulo(impuesto.getSubtipoGasto())) {
					dto.setTipoImpuesto(impuesto.getSubtipoGasto().getDescripcion());
				}
				if (!Checks.esNulo(impuesto.getFechaInicio())) {
					dto.setFechaInicio(impuesto.getFechaInicio().toString());
				}
				if (!Checks.esNulo(impuesto.getFechaFin())) {
					dto.setFechaFin(impuesto.getFechaFin().toString());
				}
				if (!Checks.esNulo(impuesto.getPeriodicidad())) {
					dto.setPeriodicidad(impuesto.getPeriodicidad().getDescripcion());
				}
				if (!Checks.esNulo(impuesto.getCalculoImpuesto())) {
					dto.setCalculo(impuesto.getCalculoImpuesto().getDescripcion());
				}
				if (!Checks.esNulo(dto.getIdActivo())) {
					listaDto.add(dto);
				}
			}
		}

		return listaDto;
	}

	@Override
	@Transactional
	public boolean createImpuestos(DtoImpuestosActivo dto) throws ParseException {
		if (!Checks.esNulo(dto)) {

			ImpuestosActivo impuesto = new ImpuestosActivo();

			if (!Checks.esNulo(dto.getIdActivo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdActivo());
				impuesto.setActivo(genericDao.get(Activo.class, filtro));
			}

			if (!Checks.esNulo(dto.getTipoImpuesto())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoImpuesto());
				impuesto.setSubtipoGasto(genericDao.get(DDSubtipoGasto.class, filtro));
			}

			if (!Checks.esNulo(dto.getFechaInicio())) {
				impuesto.setFechaInicio(ft.parse(dto.getFechaInicio()));
			}

			if (!Checks.esNulo(dto.getFechaFin())) {
				impuesto.setFechaFin(ft.parse(dto.getFechaFin()));
			}

			if (!Checks.esNulo(dto.getPeriodicidad())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getPeriodicidad());
				impuesto.setPeriodicidad(genericDao.get(DDTipoPeriocidad.class, filtro));
			}

			Date fechaActual = new Date();
	        SimpleDateFormat formateador = new SimpleDateFormat("dd/MM/yyyy");
	        String fechaAFormat=formateador.format(fechaActual);

	    	if(!Checks.esNulo(dto.getCalculo())){
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCalculo());
				impuesto.setCalculoImpuesto(genericDao.get(DDCalculoImpuesto.class, filtro));
			} else {
				if (!Checks.esNulo(impuesto.getFechaFin())) {
					Date fechaFinImpuesto = impuesto.getFechaFin();
					String fechaFormat = formateador.format(fechaFinImpuesto);

					if (fechaAFormat.equals(fechaFormat) || fechaActual.before(fechaFinImpuesto)){
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDCalculoImpuesto.CODIGO_VENCIDO);
						impuesto.setCalculoImpuesto(genericDao.get(DDCalculoImpuesto.class, filtro));

					} else {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDCalculoImpuesto.CODIGO_EN_VOLUNTARIA);
						impuesto.setCalculoImpuesto(genericDao.get(DDCalculoImpuesto.class, filtro));
					}
				}
			}

			genericDao.save(ImpuestosActivo.class, impuesto);

			return true;
		}

		return false;
	}

	@Override
	@Transactional
	public boolean deleteImpuestos(DtoImpuestosActivo dto) {
		if (!Checks.esNulo(dto.getId())) {
			genericDao.deleteById(ImpuestosActivo.class, dto.getId());

			return true;
		}

		return false;
	}

	@Override
	@Transactional
	public boolean updateImpuestos(DtoImpuestosActivo dto) throws ParseException {
		if (!Checks.esNulo(dto)) {
			ImpuestosActivo impuesto = genericDao.get(ImpuestosActivo.class,
					genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));

			if (!Checks.esNulo(dto.getTipoImpuesto())
					&& !dto.getTipoImpuesto().equals(impuesto.getSubtipoGasto().getCodigo())) {
				impuesto.setSubtipoGasto(genericDao.get(DDSubtipoGasto.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoImpuesto())));
			}

			if (!Checks.esNulo(dto.getFechaInicio())) {
				impuesto.setFechaInicio(ft.parse(dto.getFechaInicio()));
			}

			if (!Checks.esNulo(dto.getFechaFin())) {
				impuesto.setFechaFin(ft.parse(dto.getFechaFin()));
			}

			if (!Checks.esNulo(dto.getPeriodicidad())
					&& !dto.getPeriodicidad().equals(impuesto.getPeriodicidad().getCodigo())) {
				impuesto.setPeriodicidad(genericDao.get(DDTipoPeriocidad.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getPeriodicidad())));
			}

			if (!Checks.esNulo(dto.getCalculo())
					&& !dto.getCalculo().equals(impuesto.getCalculoImpuesto().getCodigo())) {
				impuesto.setCalculoImpuesto(genericDao.get(DDCalculoImpuesto.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCalculo())));
			}

			genericDao.update(ImpuestosActivo.class, impuesto);

			return true;
		}

		return false;
	}
	
	@Override
	@Transactional
	public boolean updateCalificacionNegativa(DtoActivoDatosRegistrales dto) {
		try {
			
			if (!Checks.esNulo(dto)) {
				ActivoCalificacionNegativa activoCalificacionNegativa = genericDao.get(ActivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdMotivo())));
				
				//comprobamos el motivo
				List<ActivoCalificacionNegativa> activoCalificacionNegativaList = genericDao.getList(ActivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id",activoCalificacionNegativa.getActivo().getId()));
				if(!Checks.estaVacio(activoCalificacionNegativaList)){
					if(!Checks.esNulo(dto.getMotivoCalificacionNegativa())){
						for (ActivoCalificacionNegativa actCal : activoCalificacionNegativaList) {
							if(dto.getMotivoCalificacionNegativa().equalsIgnoreCase(actCal.getMotivoCalificacionNegativa().getCodigo())){
								throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_MOTIVO_CALIFICACION));
							}
						}
					}
				}
				
				String codigoMotivoCalificacionNegativa = dto.getMotivoCalificacionNegativa();
				if (!Checks.esNulo(codigoMotivoCalificacionNegativa)) {
					beanUtilNotNull.copyProperty(activoCalificacionNegativa, "motivoCalificacionNegativa",
							genericDao.get(DDMotivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoMotivoCalificacionNegativa)));
				}
				
				String codigoEstadoMotivoCalificacionNegativa = dto.getEstadoMotivoCalificacionNegativa();		
				if (!Checks.esNulo(codigoEstadoMotivoCalificacionNegativa)) {
					activoCalificacionNegativa.setEstadoMotivoCalificacionNegativa(genericDao.get(DDEstadoMotivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoEstadoMotivoCalificacionNegativa)));
				}
				
				String codigoResponsableSubsanar = dto.getResponsableSubsanar();
				if (!Checks.esNulo(codigoResponsableSubsanar)) {
					beanUtilNotNull.copyProperty(activoCalificacionNegativa, "responsableSubsanar",
							genericDao.get(DDResponsableSubsanar.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoResponsableSubsanar)));
				}
				
				beanUtilNotNull.copyProperty(activoCalificacionNegativa, "fechaSubsanacion", dto.getFechaSubsanacion());
				
				String descripcionCalificacionNegativa = dto.getDescripcionCalificacionNegativa();
				if(!Checks.esNulo(descripcionCalificacionNegativa)) {
					beanUtilNotNull.copyProperty(activoCalificacionNegativa, "descripcion", descripcionCalificacionNegativa);
				}
				
				
				
				genericDao.update(ActivoCalificacionNegativa.class, activoCalificacionNegativa);
				return true;
			}
			
			
		} catch (Exception ex) {
			logger.error("Error en updateCalificacionNegativa", ex);
			throw new JsonViewerException(ex.getMessage());
		}
		
		return false;
		
	}
	
	@Override
	@Transactional
	public boolean createCalificacionNegativa(DtoActivoDatosRegistrales dto) throws Exception{
		try {
			
			if (!Checks.esNulo(dto)) {
				
				Activo activo = null;
				ActivoCalificacionNegativa activoCalificacionNegativa = new ActivoCalificacionNegativa();
				if (!Checks.esNulo(dto.getIdActivo())) {
					activo = genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdActivo()));
					if (!Checks.esNulo(activo.getTitulo()) && !Checks.esNulo(activo.getTitulo().getEstado())
							&& DDEstadoTitulo.ESTADO_INSCRITO.equals(activo.getTitulo().getEstado().getCodigo())) {
						return false;

					}
					activoCalificacionNegativa.setActivo(activo);
				} else {
					return false;
				}

				List<ActivoCalificacionNegativa> activoCalificacionNegativaList = genericDao.getList(ActivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id",activo.getId()));
				if(!Checks.estaVacio(activoCalificacionNegativaList)){
					for (ActivoCalificacionNegativa actCal : activoCalificacionNegativaList) { 
						if(dto.getMotivoCalificacionNegativa().equalsIgnoreCase(actCal.getMotivoCalificacionNegativa().getCodigo())){
							//HREOS-6156 Al propagar, si tiene el mismo motivo, actualiza los datos de la calificación negativa.
							activoCalificacionNegativa = actCal;
						}
					}
				}
				activoCalificacionNegativa.setActivo(activo);
				
				
				if (!Checks.esNulo(dto.getMotivoCalificacionNegativa())) {
					activoCalificacionNegativa.setMotivoCalificacionNegativa(genericDao.get(DDMotivoCalificacionNegativa.class, 
							genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMotivoCalificacionNegativa())));
				}
				
				if (!Checks.esNulo(dto.getDescripcionCalificacionNegativa())) {
					activoCalificacionNegativa.setDescripcion(dto.getDescripcionCalificacionNegativa());
				}
				
				if (!Checks.esNulo(dto.getEstadoMotivoCalificacionNegativa())) {
					activoCalificacionNegativa.setEstadoMotivoCalificacionNegativa(genericDao.get(DDEstadoMotivoCalificacionNegativa.class, 
							genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoMotivoCalificacionNegativa())));
				}
				
				if (!Checks.esNulo(dto.getResponsableSubsanar())) {
					activoCalificacionNegativa.setResponsableSubsanar(genericDao.get(DDResponsableSubsanar.class, 
							genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getResponsableSubsanar())));
				}
				
				if (!Checks.esNulo(dto.getDescripcionCalificacionNegativa())) {
					activoCalificacionNegativa.setDescripcion(dto.getDescripcionCalificacionNegativa());
				}
				
				DDCalificacionNegativa calificacionNegativa = genericDao.get(DDCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo","02"));
				activoCalificacionNegativa.setCalificacionNegativa(calificacionNegativa);
				
				if(!Checks.esNulo(activoCalificacionNegativa.getEstadoMotivoCalificacionNegativa()) 
						&& DDEstadoMotivoCalificacionNegativa.DD_SUBSANADO_CODIGO.equals(activoCalificacionNegativa.getEstadoMotivoCalificacionNegativa().getCodigo())) {
					if (!Checks.esNulo(dto.getFechaSubsanacion())) {
						beanUtilNotNull.copyProperty(activoCalificacionNegativa, "fechaSubsanacion", dto.getFechaSubsanacion());
					}
				}
				

				Filter filter = genericDao.createFilter(FilterType.EQUALS, "titulo.id", activo.getTitulo().getId());
			
				Order order = new Order(OrderType.DESC, "id");
				List<HistoricoTramitacionTitulo> historicoTramitacionTituloList = genericDao.getListOrdered(HistoricoTramitacionTitulo.class, order, filter);
			
				if(!Checks.estaVacio(historicoTramitacionTituloList)) {
					activoCalificacionNegativa.setHistoricoTramitacionTitulo(historicoTramitacionTituloList.get(0));
				}
				genericDao.save(ActivoCalificacionNegativa.class, activoCalificacionNegativa);
			
				
				return true;
			}
			
			
		} catch (Exception ex) {
			logger.error("Error en updateCalificacionNegativa", ex);
			throw new JsonViewerException(ex.getMessage());
		}
		
		return false;
		
	}
	
	@Override
	@Transactional
	public boolean destroyCalificacionNegativa(DtoActivoDatosRegistrales dto) {
		if (!Checks.esNulo(dto.getIdMotivo())) {
			genericDao.deleteById(ActivoCalificacionNegativa.class, Long.valueOf(dto.getIdMotivo()));

			return true;
		}

		return false;
	}

	@Override
	public DtoComunidadpropietariosActivo getComunidadPropietariosActivo(Long idActivo) {
		DtoComunidadpropietariosActivo comPropietarios = new DtoComunidadpropietariosActivo();
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);

		if (!Checks.esNulo(activo)) {
			ActivoComunidadPropietarios actCom = activo.getComunidadPropietarios();

			if (!Checks.esNulo(actCom)) {
				comPropietarios.setFechaComunicacionComunidad(actCom.getFechaComunicacionComunidad());
				comPropietarios.setEnvioCartas(actCom.getEnvioCartas());
				comPropietarios.setNumCartas(actCom.getNumCartas());
				comPropietarios.setContactoTel(actCom.getContactoTel());
				comPropietarios.setVisita(actCom.getVisita());
				comPropietarios.setBurofax(actCom.getBurofax());
			}
		}

		return comPropietarios;
	}

	@Override
	public boolean esLiberBank(Long idActivo) {
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);

		return DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo());
	}

	@Override
	public boolean esCajamar(Long idActivo) {
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);

		return DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo());
	}
	
	@Override
	public boolean esCerberus(Long idActivo){
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);
		
		return DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo());
	}
	
	@Override
	public boolean esSubcarteraJaipurInmobiliario(Long idActivo){
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);
		
		return DDSubcartera.CODIGO_JAIPUR_INMOBILIARIO.equals(activo.getSubcartera().getCodigo());
	}
	
	@Override
	public boolean esSubcarteraAgoraInmobiliario(Long idActivo){
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);
		
		return DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(activo.getSubcartera().getCodigo());
	}
	
	@Override
	public boolean esSubcarteraEgeo(Long idActivo){
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);
		
		return DDSubcartera.CODIGO_EGEO.equals(activo.getSubcartera().getCodigo());
	}
	
	@Override
	public boolean esEgeo(Long idActivo){
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);
		
		return DDCartera.CODIGO_CARTERA_EGEO.equals(activo.getCartera().getCodigo());
	}
	
	@Override
	public boolean esSubcarteraZeus(Long idActivo){
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);
		
		return DDSubcartera.CODIGO_ZEUS.equals(activo.getSubcartera().getCodigo());
	}
	
	@Override
	public boolean esSubcarteraPromontoria(Long idActivo){
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);
		
		return DDSubcartera.CODIGO_PROMONTORIA.equals(activo.getSubcartera().getCodigo());
	}
	
	@Override
	public boolean esSubcarteraApple(Long idActivo){
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);
		
		return DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo());
	}

	@Override
	public DtoActivoFichaCabecera getActivosPropagables(Long idActivo) {
		if (!Checks.esNulo(idActivo)) {
			DtoActivoFichaCabecera activoDto = new DtoActivoFichaCabecera();

			Activo activo = activoAdapter.getActivoById(idActivo);

			if (!Checks.esNulo(activo)) {
				try {
					BeanUtils.copyProperties(activoDto, activo);
					activoDto.setActivosPropagables(activoPropagacionApi.getAllActivosAgrupacionPorActivo(activo));
					return activoDto;
				} catch (IllegalAccessException e) {
					logger.error(e.getMessage(),e);
				} catch (InvocationTargetException e) {
					logger.error(e.getMessage(),e);
				}
			}
		}
		return null;
	}
	
	
	public List<DtoHistoricoDestinoComercial> getListDtoHistoricoDestinoComercialByBeanList(List<HistoricoDestinoComercial> hdc) {

		List<DtoHistoricoDestinoComercial> dtoList = new ArrayList<DtoHistoricoDestinoComercial>();

		if (!Checks.esNulo(hdc) && !Checks.estaVacio(hdc)) {

			DtoHistoricoDestinoComercial dto;

			for (HistoricoDestinoComercial historicoDestinoComercial : hdc) {

				dto = new DtoHistoricoDestinoComercial();

				if (!Checks.esNulo(historicoDestinoComercial.getTipoComercializacion())
						&& !Checks.esNulo(historicoDestinoComercial.getTipoComercializacion().getDescripcion())) {

					dto.setTipoComercializacion(historicoDestinoComercial.getTipoComercializacion().getDescripcion());

				}

				if (!Checks.esNulo(historicoDestinoComercial.getFechaInicio())) {
					dto.setFechaInicio(historicoDestinoComercial.getFechaInicio());
				}

				if (!Checks.esNulo(historicoDestinoComercial.getFechaFin())) {
					dto.setFechaFin(historicoDestinoComercial.getFechaFin());
				}

				if (!Checks.esNulo(historicoDestinoComercial.getGestorActualizacion())) {
					dto.setGestorActualizacion(historicoDestinoComercial.getGestorActualizacion());
				}

				dtoList.add(dto);

			}

		}

		return dtoList;

	}

	public DtoHistoricoDestinoComercial getDtoHistoricoDestinoComercialByBean(HistoricoDestinoComercial hdc) {

		List<HistoricoDestinoComercial> hdcList = new ArrayList<HistoricoDestinoComercial>();

		hdcList.add(hdc);

		return getListDtoHistoricoDestinoComercialByBeanList(hdcList).get(0);

	}


	public List<DtoHistoricoDestinoComercial> getDtoHistoricoDestinoComercialByActivo(Long id) {

		List<DtoHistoricoDestinoComercial> dto = new ArrayList<DtoHistoricoDestinoComercial>();

		if (!Checks.esNulo(id)) {

			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", id);
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);

			Order order = new Order(OrderType.DESC,"fechaInicio");

			List<HistoricoDestinoComercial> historico = genericDao.getListOrdered(HistoricoDestinoComercial.class, order, filtroActivo, filtroBorrado);

			dto = getListDtoHistoricoDestinoComercialByBeanList(historico);

		}


		return dto;

	}

	public void updateHistoricoDestinoComercial(Activo activo, Object[] extraArgs) {

		// Pasamos la fecha fin a null para todos los registros del historico del activo

		activoDao.finHistoricoDestinoComercial(activo, extraArgs);

		// Creamos el nuevo registro en el historico

		activoDao.crearHistoricoDestinoComercial(activo, extraArgs);

	}

	public List<Long> getIdAgrupacionesActivo(Long idActivo) {
		if (Checks.esNulo(idActivo))
			return null;

		List<Object> listaObj = rawDao.getExecuteSQLList(
				"SELECT AGR_ID FROM ACT_AGA_AGRUPACION_ACTIVO WHERE ACT_ID = " + idActivo.toString() + "AND BORRADO = 0");

		List<Long> listaAgr = new ArrayList<Long>();

		for (Object o : listaObj) {
			listaAgr.add(Long.parseLong(o.toString()));
		}

		return listaAgr;
	}

	@Override
	public List<VTasacionCalculoLBK> getVistaTasacion(Long idAgrupacion) {

		return genericDao.getList(VTasacionCalculoLBK.class,
				genericDao.createFilter(FilterType.EQUALS, "idAgrupacion", idAgrupacion));
	}

	@Override
	public DtoActivoFichaCabecera getActivosAgrupacionRestringida(Long idActivo) {
		if (!Checks.esNulo(idActivo)) {
			DtoActivoFichaCabecera activoDto = new DtoActivoFichaCabecera();

			Activo activo = activoAdapter.getActivoById(idActivo);

			if (!Checks.esNulo(activo)) {
				try {
					BeanUtils.copyProperties(activoDto, activo);
					activoDto.setActivosAgrupacionRestringida(getAllActivosAgrupacionRestringida(activo));
					return activoDto;
				} catch (IllegalAccessException e) {
					logger.error(e.getMessage(),e);
				} catch (InvocationTargetException e) {
					logger.error(e.getMessage(),e);
				}
			}
		}
		return null;
	}

	public List<?> getAllActivosAgrupacionRestringida(Activo activo) {
		if (activo != null) {
			for (ActivoAgrupacionActivo activoAgrupacionActivo : activo.getAgrupaciones()) {
				if (activoAgrupacionActivo.getAgrupacion() != null
						&& isActivoAgrupacionTipo(activoAgrupacionActivo, DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
					DtoAgrupacionFilter filter = new DtoAgrupacionFilter();
					filter.setLimit(1000);
					filter.setStart(0);
					Page page = agrupacionAdapter.getListActivosAgrupacionById(filter,
							activoAgrupacionActivo.getAgrupacion().getId(),true);
					return page.getResults();
				}
			}
		}
		return new ArrayList<String>();
	}

	private boolean isActivoAgrupacionTipo(ActivoAgrupacionActivo activoAgrupacionActivo,
			String... codigosTipoAgrupacion) {
		for (String codigo : codigosTipoAgrupacion) {
			if (activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion() != null
					&& codigo.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())) {
				return true;
			}
		}
		return false;
	}

	public Long getActivoExists(Long numActivo) {

		String idActivo = null;
		String idCartera = null;
		Boolean esGestoria = false;
		Boolean esGestoriaDelActivo = false;
		
		try {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			DDIdentificacionGestoria ige = gestorActivoManager.isGestoria(usuarioLogado);
			esGestoria = !Checks.esNulo(ige);
			Filter numActivoFilter = genericDao.createFilter(FilterType.EQUALS, "numActivo", numActivo);
			Activo activo = genericDao.get(Activo.class, numActivoFilter);
			
			if (esGestoria) {
				esGestoriaDelActivo = Long.parseLong(rawDao.getExecuteSQL("SELECT COUNT(*) "
						 + "FROM V_BUSQUEDA_ACTIVOS_GESTORIAS "
						 + "WHERE DD_IGE_ID = "+ige.getId()+ " AND ACT_ID = "+activo.getId())) >= 1;
						 
				if (esGestoriaDelActivo) {
					idCartera = rawDao.getExecuteSQL(
							"SELECT DD_CRA_ID FROM UCA_USUARIO_CARTERA WHERE USU_ID = " + genericAdapter.getUsuarioLogado().getId());
					
					if(!Checks.esNulo(idCartera)) {
						idActivo = rawDao.getExecuteSQL(
								"SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = " + numActivo + " AND DD_CRA_ID = " + idCartera + " AND BORRADO = 0");
					} else {
						idActivo = rawDao.getExecuteSQL(
								"SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = " + numActivo + " AND BORRADO = 0");
					}
					
					return Long.parseLong(idActivo);
				} else {
					return null;
				}
			} else {
				idCartera = rawDao.getExecuteSQL(
						"SELECT DD_CRA_ID FROM UCA_USUARIO_CARTERA WHERE USU_ID = " + genericAdapter.getUsuarioLogado().getId());
				
				if(!Checks.esNulo(idCartera)) {
					idActivo = rawDao.getExecuteSQL(
							"SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = " + numActivo + " AND DD_CRA_ID = " + idCartera + " AND BORRADO = 0");
				} else {
					idActivo = rawDao.getExecuteSQL(
							"SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = " + numActivo + " AND BORRADO = 0");
				}
				
				return Long.parseLong(idActivo);
			}
		} catch (Exception e) {
			return null;
		}
	}

	@Override
	public Integer getGeolocalizacion(Activo activo) {
		if(activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null
					&& activo.getLocalizacion().getLocalizacionBien().getProvincia() != null) {
			String codigo = activo.getLocalizacion().getLocalizacionBien().getProvincia().getCodigo();
			if (codigo.equals("0")
					|| codigo.equals("98")
					|| codigo.equals("99")) {
				return 0;
			} else if (codigo.equals("35")
					|| codigo.equals("38")) {
				return 1; // Islas Canarias
			} else {
				return 2; // Península
			}
		} else {
			return 0;
		}
	}

	@Override
	public boolean compruebaParaEnviarEmailAvisoOcupacion(DtoActivoSituacionPosesoria activoDto, Long id)
	{
		Activo activo= this.get(id);
		ActivoSituacionPosesoria posesoria=activo.getSituacionPosesoria();
		Integer ocupado;
		String conTitulo = "";
		if(activoDto.getConTitulo() != null) {
			conTitulo=activoDto.getConTitulo();
		}
		if(activoDto.getOcupado() != null) {
			ocupado=activoDto.getOcupado();
		}else ocupado=posesoria.getOcupado();

			if (!Checks.esNulo(id)) {
				if ((DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())
						&& (1 == activo.getSituacionPosesoria().getSitaucionJuridica().getIndicaPosesion()))
						|| (!DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())
								&& (!Checks.esNulo(posesoria) && (!Checks.esNulo(posesoria.getFechaRevisionEstado())
										|| !Checks.esNulo(posesoria.getFechaTomaPosesion()))))) {
					if (!Checks.esNulo(ocupado) && (1 == ocupado && DDTipoTituloActivoTPA.tipoTituloNo.equals(conTitulo))) {
						boolean val = compruebaSiExisteActivoBienPorMatricula(id,
								DDTipoDocumentoActivo.CODIGO_INFORME_OCUPACION_DESOCUPACION);
						if (val) {
							
							List<DtoAdjunto> listAdjuntos;
							DtoAdjunto adjuntoAux = null;
							try {
								listAdjuntos = activoAdapter.getAdjuntosActivo(activo.getId());
								if(!Checks.estaVacio(listAdjuntos))
								{
									// Buscamos el adjunto de tipo ocupacionDesocupacion mas reciente
									
									for (DtoAdjunto adjunto : listAdjuntos) {

										boolean esOcupacionDesocupacion = DDTipoDocumentoActivo.MATRICULA_INFORME_OCUPACION_DESOCUPACION.equals(adjunto.getMatricula());
										if ((Checks.esNulo(adjuntoAux) && esOcupacionDesocupacion)) {
											adjuntoAux = adjunto;
										}

									}
								}
								List<DtoAdjuntoMail> sendAdj = new ArrayList<DtoAdjuntoMail>();
								
								if (!Checks.esNulo(adjuntoAux)) {
									DtoAdjuntoMail adj = new DtoAdjuntoMail();
									adj.setNombre(adjuntoAux.getNombre());
									FileItem fileItem = null;
									try {
										if(!Checks.esNulo(adjuntoAux.getId())) {
											fileItem = activoAdapter.download(adjuntoAux.getId(), adjuntoAux.getNombre());
										}
									} catch (UserException e) {
										logger.error(e.getMessage(),e);
									} catch (Exception e) {
										logger.error(e.getMessage(),e);
									}
									if(!Checks.esNulo(fileItem)) {
										adj.setAdjunto(new Adjunto(fileItem));
									}
									
									sendAdj.add(adj);
								}

								Usuario usu = usuarioApi.getByUsername(EMAIL_OCUPACIONES);
								if (!Checks.esNulo(usu) && !Checks.esNulo(usu.getEmail())) {
									List<String> para = new ArrayList<String>();
									para.add(usu.getEmail());
									String activoS = activo.getNumActivo() + "";
									String carteraS = activo.getCartera().getDescripcion();
									StringBuilder cuerpo = new StringBuilder(
											"<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'><html><head><META http-equiv='Content-Type' content='text/html; charset=utf-8'></head><body>");
									cuerpo.append("<div><p>Se ha marcado en REM una ocupación ilegal del activo ");
									cuerpo.append(activoS);
									cuerpo.append(" de la cartera ");
									cuerpo.append(carteraS);
									cuerpo.append(
											"</p><p>Se anexa el informe de ocupación remitido por el API custodio</p><p>Un saludo</p></div></body></html>");
									genericAdapter.sendMail(para, null,
											"Ocupación ilegal del activo: " + activoS + ", de la cartera " + carteraS,
											cuerpo.toString(), sendAdj);
								}
								// se envia un true, por que ya hemos mandado el
								// correo
								// y tiene que guardar los cambios
								return true;
								
							} catch (IllegalAccessException e) {
								logger.error(e.getMessage(),e);
							} catch (InvocationTargetException e) {
								logger.error(e.getMessage(),e);
							} catch (GestorDocumentalException e) {
								logger.error(e.getMessage(),e);
							}
							
						} else {
							return false;
						}
							
						// devolvemos un false por que no esta adjuntado el
						// archivo
						// y no se pueden guardar los cambios
					}
					// se envia un true, por que tiene que guardar los datos
					// modificados del activo, ya que no se cumple la condicion
					else
						return true;
				}
			}

		return true;
	}

	@Override
	public boolean compruebaSiExisteActivoBienPorMatricula(Long idActivo, String matriculaActivo) {
		DDTipoDocumentoActivo tipoDocu=null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", matriculaActivo);
		tipoDocu = genericDao.get(DDTipoDocumentoActivo.class, filtro);
		List<DtoAdjunto> listaAdjuntos = null;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Activo activo= this.get(idActivo);
			try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosActivo(activo);
				if(!Checks.esNulo(listaAdjuntos)) {
					for (DtoAdjunto adj : listaAdjuntos) {
						String matricula =adj.getMatricula();
						if (!Checks.esNulo(matricula) && matricula.equals(tipoDocu.getMatricula())) {
							return true;

						}
					}
				}
			}catch (GestorDocumentalException e) {
				logger.error("Error comprobando el documento de okupación " + e.getMessage());
			}
		}
		return false;
	}
	
	@SuppressWarnings("resource")
	public FileItem generarUrlGDPR(DtoGenerarDocGDPR dtoGenerarDocGDPR) throws GestorDocumentalException, IOException {
		
		String fecha = new SimpleDateFormat("yyyyMMdd").format(new Date());
		String documento = "";
		if(!Checks.esNulo(dtoGenerarDocGDPR.getDocumento()))
			documento = dtoGenerarDocGDPR.getDocumento();
		
		String reservationKey = appProperties.getProperty(KEY_GDPR)+documento+fecha;
		String signature = computeKey(reservationKey);
		
		String url=appProperties.getProperty(URL_GDPR);
		String gdpr1 = "0";
		String gdpr2 = "0";
		String gdpr3 = "0";
		if(!Checks.esNulo(dtoGenerarDocGDPR.getCesionDatos()) && dtoGenerarDocGDPR.getCesionDatos().equals(true)){
			gdpr1 = "1";
		}
		if(!Checks.esNulo(dtoGenerarDocGDPR.getComTerceros()) && dtoGenerarDocGDPR.getComTerceros().equals(true)){
			gdpr2 = "1";
		}
		if(!Checks.esNulo(dtoGenerarDocGDPR.getTransIntern()) && dtoGenerarDocGDPR.getTransIntern().equals(true)){
			gdpr3 = "1";
		}
		
		byte[] bytes = null;
		FormDataMultiPart multipart = new FormDataMultiPart();
		RespuestaDescargarDocumento respuesta2 = null;
		try {
			multipart.field("nombre", dtoGenerarDocGDPR.getNombre())
					.field("documento", dtoGenerarDocGDPR.getDocumento()).field("gdpr1", gdpr1).field("gdpr2", gdpr2)
					.field("gdpr3", gdpr3)
					.field("codRemPresciptor", String.valueOf(getCodRemPrescriptor(dtoGenerarDocGDPR)))
					.field("signature", signature);

			ServerRequest serverRequest = new ServerRequest();
			serverRequest.setMethod(RestClientManager.METHOD_POST);
			serverRequest.setRestClientUrl(url);
			serverRequest.setMultipart(multipart);
			serverRequest.setResponseClass(RespuestaDescargarDocumento.class);
			Object respuesta = this.getBinaryResponse(serverRequest, "", dtoGenerarDocGDPR, signature);

			if (respuesta instanceof byte[]) {
				bytes = (byte[]) respuesta;
			} else {
				throw new GestorDocumentalException("Error al descargar documento");
			}
			respuesta2 = this.rellenarRespuestaDescarga(dtoGenerarDocGDPR.getDocumento());
		} finally {
			multipart.close();
		}
		return GestorDocToRecoveryAssembler.getFileItem(bytes, respuesta2);
	}
	
	private RespuestaDescargarDocumento rellenarRespuestaDescarga(String nombreDocumento){
		
		RespuestaDescargarDocumento respuesta = new RespuestaDescargarDocumento();
		respuesta.setNombreDocumento(nombreDocumento+".pdf");
		
		return respuesta;
	}
	
	public Object getBinaryResponse(ServerRequest serverRequest, String fileName, DtoGenerarDocGDPR dtoGenerarDocGDPR, String signature) {
		
		String restClientUrl = serverRequest.getRestClientUrl();

		final Client client = ClientBuilder.newBuilder().register(MultiPartFeature.class).register(JacksonFeature.class).build();
		String url = restClientUrl;
		WebTarget webTarget = client.target(url);
		logger.info("URL: " + url);
		Object response = webTarget.request().post(Entity.entity(serverRequest.getMultipart(), serverRequest.getMultipart().getMediaType()));
		
		if (response == null) return null;
		Response res = (Response) response;
		InputStream is = (InputStream)res.getEntity();
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();
		int nRead;
	    byte[] data = new byte[1024];
	    try {
		    while ((nRead = is.read(data, 0, data.length)) != -1) {
		        buffer.write(data, 0, nRead);
		    }
		 
		    buffer.flush();
			byte[] bytes = buffer.toByteArray();
			buffer.close();
			is.close();
			return bytes;
		} catch (IOException e) {
			logger.error("RestClientManager : Error al recoger bytes del archivo - " +e);
			return null;
		}
	}
	
	private String computeKey(String key) {

		String result = "";
		try {
			byte[] bytesOfMessage = key.getBytes("UTF-8");

			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(bytesOfMessage);
			byte[] thedigest = md.digest();
			StringBuffer hexString = new StringBuffer();
			for (int i = 0; i < thedigest.length; i++) {
				if ((0xff & thedigest[i]) < 0x10) {
					hexString.append("0" + Integer.toHexString((0xFF & thedigest[i])));
				} else {
					hexString.append(Integer.toHexString(0xFF & thedigest[i]));
				}
			}
			result  = hexString.toString();
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
		}
		return result;
	}

	private Long getCodRemPrescriptor(DtoGenerarDocGDPR dtoGenerarDocGDPR) {
		Long codRemPrescriptor = null;
		if(!Checks.esNulo(dtoGenerarDocGDPR.getIdExpediente())) {
			ExpedienteComercial expCom = expedienteComercialDao.get(dtoGenerarDocGDPR.getIdExpediente());
			codRemPrescriptor= expCom.getOferta().getPrescriptor().getCodigoProveedorRem();
		}else {
			codRemPrescriptor= dtoGenerarDocGDPR.getCodPrescriptor();
		}

		return codRemPrescriptor;
	}

	@Override
	public ActivoPatrimonio getActivoPatrimonio(Long idActivo) {
		return activoPatrimonioDao.getActivoPatrimonioByActivo(idActivo);
	}

	@Override
	public List<DtoMotivoAnulacionExpediente> getMotivoAnulacionExpediente() {
		
		List <DtoMotivoAnulacionExpediente> listDtoMotivoAnulacionExpediente = new ArrayList <DtoMotivoAnulacionExpediente>();
		List <DDMotivoAnulacionExpediente> listaDDMotivoAnulacionExpediente= new ArrayList <DDMotivoAnulacionExpediente>();		
		
		Filter filtroMotivoAlquiler = genericDao.createFilter(FilterType.EQUALS, "alquiler", true);
		listaDDMotivoAnulacionExpediente  = genericDao.getList(DDMotivoAnulacionExpediente.class, filtroMotivoAlquiler);
		
		for (DDMotivoAnulacionExpediente tipDocExp : listaDDMotivoAnulacionExpediente) {
			DtoMotivoAnulacionExpediente aux= new DtoMotivoAnulacionExpediente();
			aux.setId(tipDocExp.getId());
			aux.setCodigo(tipDocExp.getCodigo());
			aux.setDescripcion(tipDocExp.getDescripcion());
			aux.setDescripcionLarga(tipDocExp.getDescripcionLarga());
			aux.setVenta(tipDocExp.getVenta());
			aux.setAlquiler(tipDocExp.getAlquiler());
			listDtoMotivoAnulacionExpediente.add(aux);
		}	
		
		return listDtoMotivoAnulacionExpediente;
	}


	@Override
	public Activo getActivoByIdProveedor(Long idProveedor) {
		Filter filterPVE = genericDao.createFilter(FilterType.EQUALS, "id", String.valueOf(idProveedor));
		VBusquedaProveedoresActivo proveedorActivo = genericDao.get(VBusquedaProveedoresActivo.class, filterPVE);

		if(!Checks.esNulo(proveedorActivo.getIdFalso().getIdActivo())) {
			return get(Long.parseLong(proveedorActivo.getIdFalso().getIdActivo()));
		} else {
			return null;
		}
	}

	@Override
	public Activo getActivoByIdGastoProveedor(Long idGastoProveedor) {
		Filter filterGPV = genericDao.createFilter(FilterType.EQUALS, "id", idGastoProveedor);
		GastoProveedor gastoProveedor = genericDao.get(GastoProveedor.class, filterGPV);

		return getActivoByIdProveedor(gastoProveedor.getProveedor().getId());
	}

	@Override
	public Boolean tieneComunicacionGencat(Activo activo) {
		List<ComunicacionGencat> listaComunicacionGencat = genericDao.getList(ComunicacionGencat.class,genericDao.createFilter(FilterType.EQUALS, "activo.id",activo.getId()));
		if (!Checks.estaVacio(listaComunicacionGencat)){
			return true;
		} else {
			return false;
		}
	}

	

	@Override
	public DtoActivoDatosRegistrales getCalificacionNegativoByidActivoIdMotivo(Long idActivo, String idMotivo) {
		
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id",idActivo);
		Filter filtroMotivo = genericDao.createFilter(FilterType.EQUALS, "motivoCalificacionNegativa.codigo",idMotivo);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado",false);
		
		DtoActivoDatosRegistrales dto = new DtoActivoDatosRegistrales();
		ActivoCalificacionNegativa actCalNeg = genericDao.get(ActivoCalificacionNegativa.class, filtroActivo,filtroMotivo,filtroBorrado);
		DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaFormateada = null;
		if(!Checks.esNulo(actCalNeg)) {
			try {
				if(!Checks.esNulo(actCalNeg.getFechaSubsanacion())) {
					fechaFormateada = formatter.parse(formatter.format(actCalNeg.getFechaSubsanacion()));
				}
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
			}
			dto.setFechaSubsanacion(fechaFormateada);
			dto.setEstadoMotivoCalificacionNegativa(actCalNeg.getEstadoMotivoCalificacionNegativa().getDescripcion());
			dto.setCodigoEstadoMotivoCalificacionNegativa(actCalNeg.getEstadoMotivoCalificacionNegativa().getCodigo());
			dto.setDescripcionCalificacionNegativa(actCalNeg.getDescripcion());
			dto.setCodigoResponsableSubsanar(actCalNeg.getResponsableSubsanar().getCodigo());
			dto.setResponsableSubsanar(actCalNeg.getResponsableSubsanar().getDescripcion());
			dto.setCodigoMotivoCalificacionNegativa(actCalNeg.getMotivoCalificacionNegativa().getCodigo());
			
		}
		return dto;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean saveCalificacionNegativoMotivo(DtoActivoDatosRegistrales dto) {

		boolean resultado = false;
		if (!Checks.esNulo(dto.getCalificacionNegativa()) && !Checks.esNulo(dto.getMotivoCalificacionNegativa())) {

			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id",
					Long.parseLong(dto.getNumeroActivo()));
			Filter filtroMotivo = genericDao.createFilter(FilterType.EQUALS, "motivoCalificacionNegativa.id",
					Long.parseLong(dto.getMotivoCalificacionNegativa()));
			ActivoCalificacionNegativa actCalNeg = genericDao.get(ActivoCalificacionNegativa.class, filtroActivo,
					filtroMotivo);
			DDEstadoMotivoCalificacionNegativa estMotCalNegativa = genericDao.get(
					DDEstadoMotivoCalificacionNegativa.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoMotivoCalificacionNegativa()));
			DDResponsableSubsanar responSubsanar = genericDao.get(DDResponsableSubsanar.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getResponsableSubsanar()));

			if (!Checks.esNulo(actCalNeg)) {
				if (!Checks.esNulo(estMotCalNegativa)) {
					actCalNeg.setEstadoMotivoCalificacionNegativa(estMotCalNegativa);
				} else {
					actCalNeg.setEstadoMotivoCalificacionNegativa(null);
				}

				if (!Checks.esNulo(responSubsanar)) {
					actCalNeg.setResponsableSubsanar(responSubsanar);
				} else {
					actCalNeg.setResponsableSubsanar(null);
				}

				if (!Checks.esNulo(dto.getFechaSubsanacion())) {
					actCalNeg.setFechaSubsanacion(dto.getFechaSubsanacion());
				} else {
					actCalNeg.setFechaSubsanacion(null);
				}

				if (DDMotivoCalificacionNegativa.CODIGO_OTROS
						.equals(actCalNeg.getMotivoCalificacionNegativa().getCodigo())) {
					actCalNeg.setDescripcion(dto.getDescripcionCalificacionNegativa());
				}

				if (actCalNeg.getAuditoria().isBorrado()) {
					actCalNeg.getAuditoria().setFechaBorrar(null);
					actCalNeg.getAuditoria().setUsuarioBorrar(null);
					actCalNeg.getAuditoria().setBorrado(false);
				}

				genericDao.save(ActivoCalificacionNegativa.class, actCalNeg);

				resultado = true;
			} else {
				actCalNeg = new ActivoCalificacionNegativa();

				if (!Checks.esNulo(estMotCalNegativa)) {
					actCalNeg.setEstadoMotivoCalificacionNegativa(estMotCalNegativa);
				}

				if (!Checks.esNulo(responSubsanar)) {
					actCalNeg.setResponsableSubsanar(responSubsanar);
				}

				if (!Checks.esNulo(dto.getFechaSubsanacion())) {
					actCalNeg.setFechaSubsanacion(dto.getFechaSubsanacion());
				} else {
					actCalNeg.setFechaSubsanacion(null);
				}
				DDMotivoCalificacionNegativa motivoCN = (DDMotivoCalificacionNegativa) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDMotivoCalificacionNegativa.class,
								dto.getCodigoMotivoCalificacionNegativa());

				actCalNeg.setMotivoCalificacionNegativa(motivoCN);
				actCalNeg.setActivo(activoDao.get(Long.parseLong(dto.getNumeroActivo())));
				actCalNeg.setCalificacionNegativa((DDCalificacionNegativa) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDCalificacionNegativa.class, dto.getCalificacionNegativa()));

				if (DDMotivoCalificacionNegativa.CODIGO_OTROS.equals(motivoCN.getCodigo())) {
					actCalNeg.setDescripcion(dto.getDescripcionCalificacionNegativa());
				}

				genericDao.save(ActivoCalificacionNegativa.class, actCalNeg);

				resultado = true;
			}

		}

		return resultado;
	}
	
	@Override
	public boolean getMotivosCalificacionNegativaSubsanados( Long idActivo, String idMotivo) {
		
		int subsanado = 0;
		boolean resultado = false;
		
		List<ActivoCalificacionNegativa> motivosCalificacionNegativa = activoDao.getListActivoCalificacionNegativaByIdActivoBorradoFalse(idActivo);
		for (ActivoCalificacionNegativa activoCN : motivosCalificacionNegativa){
			if (!activoCN.getAuditoria().isBorrado()){
				
				if(DDEstadoMotivoCalificacionNegativa.DD_SUBSANADO_CODIGO.equals(activoCN.getEstadoMotivoCalificacionNegativa().getCodigo()) || idMotivo.equals(activoCN.getMotivoCalificacionNegativa().getCodigo())){
					subsanado=subsanado+1;
				}
			}
		}
		
		if(subsanado == motivosCalificacionNegativa.size()) {
			resultado = true;
		}

		return resultado;
	}

	@Override
	public void actualizarMotivoOcultacionUAs(DtoActivoPatrimonio patrimonioDto, Long id) {
		
		if(DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO.equals(patrimonioDto.getEstadoAlquiler()) 
				|| DDTipoEstadoAlquiler.ESTADO_ALQUILER_LIBRE.equals(patrimonioDto.getEstadoAlquiler())) {
			if(activoDao.isActivoMatriz(id)) {
				ActivoAgrupacion agrupacionPA = activoDao.getAgrupacionPAByIdActivo(id);
				if(Checks.esNulo(agrupacionPA.getFechaBaja())) {
					List<ActivoAgrupacionActivo> activosAgrupacionActivo = agrupacionPA.getActivos();
					for (ActivoAgrupacionActivo activoAgrupacionActivo : activosAgrupacionActivo) {
						Long idUa = activoAgrupacionActivo.getActivo().getId();
						activoAdapter.actualizarEstadoPublicacionActivo(idUa);
					}
					
				}
			}
		}
	}


	@Override
	@Transactional(readOnly = false)	
	public void actualizarOfertasTrabajosVivos(Activo activo) {
		Boolean tieneOfertasVivas = false;
		Boolean tieneTrabajosVivos = false;
		List<ActivoTrabajo> trabajosDelActivo = activo.getActivoTrabajos();
		
		tieneOfertasVivas = particularValidator.existeActivoConOfertaVivaEstadoExpediente(Long.toString(activo.getNumActivo()));
		
		for (ActivoTrabajo activoTrabajo : trabajosDelActivo) {
			if (activoTrabajo.getTrabajo().getEstado() != null
					&& activoTrabajo.getTrabajo().getSubtipoTrabajo() != null) {
				if (!DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_VENTA
						.equals(activoTrabajo.getTrabajo().getSubtipoTrabajo().getCodigo())
						&& !DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_ALQUILER
								.equals(activoTrabajo.getTrabajo().getSubtipoTrabajo().getCodigo())
						&& (DDEstadoTrabajo.ESTADO_EN_TRAMITE.equals(activoTrabajo.getTrabajo().getEstado().getCodigo())
								|| DDEstadoTrabajo.ESTADO_CEE_PENDIENTE_ETIQUETA
										.equals(activoTrabajo.getTrabajo().getEstado().getCodigo())
								|| DDEstadoTrabajo.ESTADO_PENDIENTE_CIERRE_ECONOMICO
										.equals(activoTrabajo.getTrabajo().getEstado().getCodigo())
								|| DDEstadoTrabajo.ESTADO_PAGADO
										.equals(activoTrabajo.getTrabajo().getEstado().getCodigo())
								|| DDEstadoTrabajo.ESTADO_VALIDADO
										.equals(activoTrabajo.getTrabajo().getEstado().getCodigo()))) {

					tieneTrabajosVivos = true;

					break;
				}
			}
		}
		PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class,genericDao.createFilter(FilterType.EQUALS,"activo.id", activo.getId()));	
			
		if(!Checks.esNulo(perimetroActivo)) {
		
			perimetroActivo.setTrabajosVivos(tieneTrabajosVivos);
			perimetroActivo.setOfertasVivas(tieneOfertasVivas);
		
			genericDao.save(PerimetroActivo.class, perimetroActivo);
		}
		
		if(activoDao.isUnidadAlquilable(activo.getId())) {
			Boolean uaConTrabajosVivos = false;
			ActivoAgrupacion agrupacionPa = activoDao.getAgrupacionPAByIdActivo(activo.getId());
		
			Long idAM = activoDao.getIdActivoMatriz(agrupacionPa.getId());
			
			List<Object[]>  listaTrabajosUA = activoDao.getTrabajosUa(idAM, activo.getId());
			if(!Checks.estaVacio(listaTrabajosUA)) {
				for (Object[] trabajoObjeto: listaTrabajosUA) {	
					Trabajo trabajoUA = (Trabajo) trabajoObjeto[0];
					if(!Checks.esNulo(trabajoUA)) {
						if(!DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_VENTA.equals(trabajoUA.getSubtipoTrabajo().getCodigo())
								&& !DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_ALQUILER.equals(trabajoUA.getSubtipoTrabajo().getCodigo())
								&& (DDEstadoTrabajo.ESTADO_EN_TRAMITE.equals(trabajoUA.getEstado().getCodigo())
								|| DDEstadoTrabajo.ESTADO_CEE_PENDIENTE_ETIQUETA.equals(trabajoUA.getEstado().getCodigo())
								|| DDEstadoTrabajo.ESTADO_PENDIENTE_CIERRE_ECONOMICO.equals(trabajoUA.getEstado().getCodigo())
								|| DDEstadoTrabajo.ESTADO_PAGADO.equals(trabajoUA.getEstado().getCodigo()))
						) {
							uaConTrabajosVivos = true;
							break;
						}
					}
				}
				
				if(!Checks.esNulo(perimetroActivo)) {
					perimetroActivo.setTrabajosVivos(uaConTrabajosVivos);
				}
				genericDao.save(PerimetroActivo.class, perimetroActivo);
			}
			
			PerimetroActivo perimetroActivoAM = genericDao.get(PerimetroActivo.class,genericDao.createFilter(FilterType.EQUALS,"activo.id", activoDao.getIdActivoMatriz(agrupacionPa.getId())));
			tieneOfertasVivas = activoDao.checkOfertasVivasAgrupacion(agrupacionPa.getId());
			tieneTrabajosVivos = activoDao.checkOTrabajosVivosAgrupacion(agrupacionPa.getId());
			
			if(!tieneOfertasVivas) {
				tieneOfertasVivas = particularValidator.existeActivoConOfertaVivaEstadoExpediente(Long.toString(activoDao.getActivoById(activoDao.getIdActivoMatriz(agrupacionPa.getId())).getNumActivo()));
			}
			if(!tieneTrabajosVivos) {
				List<ActivoTrabajo> trabajosDelActivoAM = activo.getActivoTrabajos();
				for (ActivoTrabajo activoTrabajoAM: trabajosDelActivoAM) {	
					if(!DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_VENTA.equals(activoTrabajoAM.getTrabajo().getSubtipoTrabajo().getCodigo())
							&& !DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_ALQUILER.equals(activoTrabajoAM.getTrabajo().getSubtipoTrabajo().getCodigo())
							&& (DDEstadoTrabajo.ESTADO_EN_TRAMITE.equals(activoTrabajoAM.getTrabajo().getEstado().getCodigo())
							|| DDEstadoTrabajo.ESTADO_CEE_PENDIENTE_ETIQUETA.equals(activoTrabajoAM.getTrabajo().getEstado().getCodigo())
							|| DDEstadoTrabajo.ESTADO_PENDIENTE_CIERRE_ECONOMICO.equals(activoTrabajoAM.getTrabajo().getEstado().getCodigo())
							|| DDEstadoTrabajo.ESTADO_PAGADO.equals(activoTrabajoAM.getTrabajo().getEstado().getCodigo()))
					) {
						
						tieneTrabajosVivos = true;
						break;
					}
				}
			}
			if(!Checks.esNulo(perimetroActivoAM)) {
				perimetroActivoAM.setOfertasVivas(tieneOfertasVivas);
				perimetroActivoAM.setTrabajosVivos(tieneTrabajosVivos);
				
				genericDao.save(PerimetroActivo.class, perimetroActivoAM);
			}
			
		}
	}
	
	@Override
	public void bloquearChecksComercializacionActivo(ActivoAgrupacionActivo aga, DtoActivoFichaCabecera activoDto) {
		if(aga.getPrincipal() == 1) {			
			Boolean ofertasVivas = activoDao.existenUAsconOfertasVivas(aga.getAgrupacion().getId());
			Boolean trabajosVivos = activoDao.existenUAsconTrabajos(aga.getAgrupacion().getId());
			if(!Checks.esNulo(ofertasVivas) && ofertasVivas) {
				activoDto.setCheckComercializarReadOnly(false);					
			}
			if(!Checks.esNulo(trabajosVivos) && trabajosVivos) {
				activoDto.setCheckGestionarReadOnly(false);
			}			
		}else {
			Long idAM = activoDao.getIdActivoMatriz(aga.getAgrupacion().getId());
			PerimetroActivo perimetroActivoAM = genericDao.get(PerimetroActivo.class,genericDao.createFilter(FilterType.EQUALS,"activo.id",idAM));			
			if(!Checks.esNulo(perimetroActivoAM)) {
				if(!Checks.esNulo(perimetroActivoAM.getAplicaGestion()) && perimetroActivoAM.getAplicaGestion() == 0 ) {
					activoDto.setCheckGestionarReadOnly(false);
				}
				if(!Checks.esNulo(perimetroActivoAM.getAplicaPublicar()) && !perimetroActivoAM.getAplicaPublicar()){
					activoDto.setCheckPublicacionReadOnly(false);
				} 
				if(!Checks.esNulo(perimetroActivoAM.getAplicaComercializar()) && perimetroActivoAM.getAplicaComercializar() == 0) {
					activoDto.setCheckComercializarReadOnly(false);
				}
				if(!Checks.esNulo(perimetroActivoAM.getAplicaFormalizar()) && perimetroActivoAM.getAplicaFormalizar() == 0) {
					activoDto.setCheckFormalizarReadOnly(false);
				}				
			}
		}
	}
	
	@Override
	public boolean isActivoMatriz(Long idActivo){
		return activoDao.isActivoMatriz(idActivo);
	}
	
	@Override
	public void cambiarSituacionComercialActivoMatriz(Long uA) {
		Activo activoMatriz = null;
		ActivoAgrupacion agr = activoDao.getAgrupacionPAByIdActivo(uA);
		if (!Checks.esNulo(agr)) {
			activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agr.getId());
		}
		
		updaterState.updaterStateDisponibilidadComercialAndSave(activoMatriz, false);
	}
	
	@Override
	public boolean isAlquiladoParcialmente(Long idActivoMatriz) {
		boolean uAsAlquiladas = false;
		ActivoAgrupacion agr = activoDao.getAgrupacionPAByIdActivo(idActivoMatriz);
		
		List<ActivoAgrupacionActivo> activos = agr.getActivos();
		
		if (!Checks.estaVacio(activos)) {
			for (ActivoAgrupacionActivo activo : activos) {
				if (!isActivoMatriz(activo.getActivo().getId()) && (isActivoAlquilado(activo.getActivo()) || isOcupadoConTituloOrEstadoAlquilado(activo.getActivo()))) {
					uAsAlquiladas = true;
				}
			}
		}
		
		return uAsAlquiladas;
	}

	@Override
	public List<DDCesionSaneamiento> getPerimetroAppleCesion(String codigoServicer) {
		
		List<DDCesionSaneamiento> listaPerimetros = new ArrayList<DDCesionSaneamiento>();
		
		if(!Checks.esNulo(codigoServicer)) {
			listaPerimetros = genericDao.getList(DDCesionSaneamiento.class, genericDao.createFilter(FilterType.EQUALS, "servicer.codigo", codigoServicer));
		}
		
		return listaPerimetros;
	}
	
	@Transactional(readOnly = false)
	public boolean saveOrUpdateActivoTributo(DtoActivoTributos dto, Long idActivo) {
		ActivoTributos tributo = new ActivoTributos();
		
		if(!Checks.esNulo(dto.getIdTributo())){
			Filter filtroTributo = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTributo());
			tributo = genericDao.get(ActivoTributos.class, filtroTributo);
		}
		
		if(!Checks.esNulo(dto)){
				if(!Checks.esNulo(idActivo)){
					Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
					Activo activo = genericDao.get(Activo.class, filtroActivo);
					
					if(!Checks.esNulo(activo)){
						tributo.setActivo(activo);
					}
				}
				if(!Checks.esNulo(dto.getFechaPresentacion())){
					tributo.setFechaPresentacionRecurso(dto.getFechaPresentacion());
				}
				if(!Checks.esNulo(dto.getFechaRecPropietario())){
					tributo.setFechaRecepcionPropietario(dto.getFechaRecPropietario());
				}
				if(!Checks.esNulo(dto.getFechaRecGestoria())){
					tributo.setFechaRecepcionGestoria(dto.getFechaRecGestoria());
				}
				if(!Checks.esNulo(dto.getTipoSolicitud())){
					Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoSolicitud());
					DDTipoSolicitudTributo tipoSolicitud = genericDao.get(DDTipoSolicitudTributo.class, filtroTipo);
					
					if(!Checks.esNulo(tipoSolicitud)){
						tributo.setTipoSolicitudTributo(tipoSolicitud);
					}
				}
				if(!Checks.esNulo(dto.getObservaciones())){
					tributo.setObservaciones(dto.getObservaciones());
				}
				if(!Checks.esNulo(dto.getFechaRecRecursoPropietario())){
					tributo.setFechaRecepcionRecursoPropietario(dto.getFechaRecRecursoPropietario());
				}
				if(!Checks.esNulo(dto.getFechaRecRecursoGestoria())){
					tributo.setFechaRecepcionRecursoGestoria(dto.getFechaRecRecursoGestoria());
				}
				if(!Checks.esNulo(dto.getFechaRespRecurso())){
					tributo.setFechaRespuestaRecurso(dto.getFechaRespRecurso());
				}
				if(!Checks.esNulo(dto.getResultadoSolicitud())){
					Filter filtroResultado = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getResultadoSolicitud());
					DDFavorable favorable = genericDao.get(DDFavorable.class, filtroResultado);
					
					if(!Checks.esNulo(favorable)){
						tributo.setFavorable(favorable);
					}
				}
				if(!Checks.esNulo(dto.getNumGastoHaya())){
					Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", dto.getNumGastoHaya());
					GastoProveedor gasto = genericDao.get(GastoProveedor.class, filtroGasto);
					
					if(!Checks.esNulo(gasto)){
						tributo.setGastoProveedor(gasto);
					}
				}
								
				if(!Checks.esNulo(tributo.getId())){
					genericDao.update(ActivoTributos.class, tributo);
				}else {
					tributo.setAuditoria(Auditoria.getNewInstance());
					genericDao.save(ActivoTributos.class, tributo);
				}				
				return true;
		} else {
			return false;
		}
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteActivoTributo(DtoActivoTributos dto) {
		
		if(!Checks.esNulo(dto.getIdTributo())){
			Filter filtroTributo = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTributo());
			ActivoTributos tributo = genericDao.get(ActivoTributos.class, filtroTributo);
			
			tributo.getAuditoria().setBorrado(true);
			genericDao.update(ActivoTributos.class, tributo);
			
			activoTributoApi.deleteAdjuntoDeTributo(tributo.getId());
			
			return true;
		}else {
			return false;
		}
	}
	
	@Override
	public DtoPage getListPlusvalia(DtoPlusvaliaFilter dtoPlusvaliaFilter) {

		return activoDao.getListPlusvalia(dtoPlusvaliaFilter);

	}
	
	@Override
	public boolean isTramitable(Activo activo) {
		boolean tramitable = true;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId());
		VTramitacionOfertaActivo activoNoTramitable = genericDao.get(VTramitacionOfertaActivo.class, filtro);

		if(!Checks.esNulo(activoNoTramitable)) {
			tramitable = false;
		}

		return tramitable;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.deleteAdjuntoPlusvalia")
	@Transactional(readOnly = false)
	public boolean deleteAdjuntoPlusvalia(DtoAdjunto dtoAdjunto) {
		boolean borrado = false;
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS,"activo.id", dtoAdjunto.getIdEntidad());
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS,"auditoria.borrado", false);
		ActivoPlusvalia activoPlusvalia = genericDao.get(ActivoPlusvalia.class, filtroActivo, filtroBorrado);
		
		try {
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());
				
				AdjuntoPlusvalias adjuntoPlusvaliasGD = activoPlusvalia.getAdjuntoGD(dtoAdjunto.getId());
				if (adjuntoPlusvaliasGD == null) {
					borrado = false;
				}
				activoPlusvalia.getAdjuntos().remove(adjuntoPlusvaliasGD);
				genericDao.save(ActivoPlusvalia.class, activoPlusvalia);


			}else {
				AdjuntoPlusvalias adjuntoPlusvalias = activoPlusvalia.getAdjunto(dtoAdjunto.getId());
				activoPlusvalia.getAdjuntos().remove(adjuntoPlusvalias);
				genericDao.save(ActivoPlusvalia.class, activoPlusvalia);
			}
		}catch(Exception ex) {
			logger.debug(ex.getMessage());
			borrado = false;
		}
		return borrado;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.uploadDocumentoPlusvalia")
	@Transactional(readOnly = false)
	public String uploadDocumentoPlusvalia(WebFileItem webFileItem, ActivoPlusvalia activoPlusvaliaEntrada,
			String matricula) throws Exception {
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS,"activo.id", Long.parseLong(webFileItem.getParameter("idEntidad")));
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS,"auditoria.borrado", false);
		ActivoPlusvalia activoPlusvalia = genericDao.get(ActivoPlusvalia.class, filtroActivo, filtroBorrado);
		
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
		DDTipoDocPlusvalias tipoDocumento = genericDao.get(DDTipoDocPlusvalias.class, filtro);
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				Long idDocRestClient = gestorDocumentalAdapterApi.UploadDocumentoPlusvalia(activoPlusvalia, webFileItem,
						usuarioLogado.getUsername(), tipoDocumento.getMatricula());
				CrearRelacionExpedienteDto crearRelacionExpedienteDto = new CrearRelacionExpedienteDto();
				crearRelacionExpedienteDto.setTipoRelacion(RELACION_TIPO_DOCUMENTO_EXPEDIENTE);
				String mat = tipoDocumento.getMatricula();
				if (!Checks.esNulo(mat)) {
					String[] matSplit = mat.split("-");
					crearRelacionExpedienteDto.setCodTipoDestino(matSplit[0]);
					crearRelacionExpedienteDto.setCodClaseDestino(matSplit[1]);
				}
				crearRelacionExpedienteDto.setOperacion(OPERACION_ALTA);
				gestorDocumentalAdapterApi.crearRelacionPlusvalia(activoPlusvalia, idDocRestClient, activoPlusvalia.getActivo().getNumActivo().toString(),
						usuarioLogado.getUsername(), crearRelacionExpedienteDto);
				
				AdjuntoPlusvalias adjuntoPlusvalia = new AdjuntoPlusvalias();
				adjuntoPlusvalia.setPlusvalia(activoPlusvalia);
				adjuntoPlusvalia.setTipoDocPlusvalias(tipoDocumento);
				adjuntoPlusvalia.setContentType(webFileItem.getFileItem().getContentType());
				adjuntoPlusvalia.setTamanyo(webFileItem.getFileItem().getLength());
				adjuntoPlusvalia.setNombre(webFileItem.getFileItem().getFileName());
				adjuntoPlusvalia.setDescripcion(webFileItem.getParameter("descripcion"));
				adjuntoPlusvalia.setFechaDocumento(new Date());
				adjuntoPlusvalia.setDocumentoRest(idDocRestClient);
				Auditoria.save(adjuntoPlusvalia);
				activoPlusvalia.getAdjuntos().add(adjuntoPlusvalia);
				genericDao.save(ActivoPlusvalia.class, activoPlusvalia);
			} catch (GestorDocumentalException gex) {
				logger.error(gex.getMessage());
				return gex.getMessage();
			}
		}else {
			
			AdjuntoPlusvalias adjuntoPlusvalia = new AdjuntoPlusvalias();
			
			Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());
			adjuntoPlusvalia.setAdjunto(adj);
			
			adjuntoPlusvalia.setPlusvalia(activoPlusvalia);
			adjuntoPlusvalia.setTipoDocPlusvalias(tipoDocumento);
			adjuntoPlusvalia.setContentType(webFileItem.getFileItem().getContentType());
			adjuntoPlusvalia.setTamanyo(webFileItem.getFileItem().getLength());
			adjuntoPlusvalia.setNombre(webFileItem.getFileItem().getFileName());
			adjuntoPlusvalia.setDescripcion(webFileItem.getParameter("descripcion"));
			adjuntoPlusvalia.setFechaDocumento(new Date());
			
			Auditoria.save(adjuntoPlusvalia);
			activoPlusvalia.getAdjuntos().add(adjuntoPlusvalia);
			genericDao.save(ActivoPlusvalia.class, activoPlusvalia);
		}
		return null;
	}

	@Override
	@BusinessOperationDefinition("activoManager.getFileItemPlusvalia")
	public FileItem getFileItemPlusvalia(DtoAdjunto dtoAdjunto) {
		
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS,"activo.id", dtoAdjunto.getIdEntidad());
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS,"auditoria.borrado", false);
		ActivoPlusvalia activoPlusvalia = genericDao.get(ActivoPlusvalia.class, filtroActivo, filtroBorrado);
		AdjuntoPlusvalias adjunto = null;
		FileItem fileItem = null;
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				fileItem = gestorDocumentalAdapterApi.getFileItem(dtoAdjunto.getId(),dtoAdjunto.getNombre());
			} catch (Exception e) {
				logger.error(e.getMessage());
			}
		} else {
			adjunto = activoPlusvalia.getAdjunto(dtoAdjunto.getId());
			fileItem = adjunto.getAdjunto().getFileItem();
			fileItem.setContentType(adjunto.getContentType());
			fileItem.setFileName(adjunto.getNombre());
		}
		return fileItem;
	}
	
	@Override
	public Date getFechaInicioBloqueo(Activo activo) {
		Date fechaBloqueo = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId());
		VTramitacionOfertaActivo activoNoTramitable = genericDao.get(VTramitacionOfertaActivo.class, filtro);
		if(!Checks.esNulo(activoNoTramitable)) {
			fechaBloqueo = activoNoTramitable.getFechaPublicacion();
		}
		return fechaBloqueo;
	}
	
	@Override
	@Transactional
	public boolean insertarActAutoTram(DtoComercialActivo dto) {
		
		Usuario usuario = usuarioApi.getUsuarioLogado();
		if (Checks.esNulo(dto.getId())) {
			return false;
		}
		
		Activo activo = activoDao.get(Long.parseLong(dto.getId()));
		
		try {
			DDMotivoAutorizacionTramitacion motivoTramitacion = genericDao.get(DDMotivoAutorizacionTramitacion.class,genericDao.createFilter(FilterType.EQUALS,"codigo", dto.getMotivoAutorizacionTramitacionCodigo()));	
			ActivoAutorizacionTramitacionOfertas activoAuto =  activo.getActivoAutorizacionTramitacionOfertas();
			if(Checks.esNulo(activoAuto)) {
				activoAuto = new ActivoAutorizacionTramitacionOfertas();
				beanUtilNotNull.copyProperty(activoAuto, "activo", activo);
			}
			beanUtilNotNull.copyProperty(activoAuto, "observacionesAutoTram", dto.getObservacionesAutoTram());
			beanUtilNotNull.copyProperty(activoAuto, "motivoAutorizacionTramitacion", motivoTramitacion);
			activoAuto.setUsuario(usuario);
			beanUtilNotNull.copyProperty(activoAuto, "fechIniBloq", this.getFechaInicioBloqueo(activo));
			beanUtilNotNull.copyProperty(activoAuto, "fechAutoTram", new Date());
			
			Auditoria auditoriaActivoAuto = activoAuto.getAuditoria();
			if (auditoriaActivoAuto != null) {
				auditoriaActivoAuto.setFechaModificar(new Date());
				auditoriaActivoAuto.setUsuarioModificar(usuarioApi.getUsuarioLogado().getUsername());
			}
			
			genericDao.save(ActivoAutorizacionTramitacionOfertas.class, activoAuto);
			
		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);
			return false;

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
			return false;
		}
		
		return true;
	}

	@Override
	public List<DtoHistoricoTramitacionTitulo> getHistoricoTramitacionTitulo(Long id){
		List<DtoHistoricoTramitacionTitulo> listaDto = new ArrayList<DtoHistoricoTramitacionTitulo>();
		try {
			ActivoTitulo titulo = activoAdapter.getActivoById(id).getTitulo();
			if(!Checks.esNulo(titulo)) {
				Order order  = new Order(OrderType.DESC, "id");
				List<HistoricoTramitacionTitulo> listaObjeto = genericDao.getListOrdered(HistoricoTramitacionTitulo.class, order, genericDao.createFilter(FilterType.EQUALS, "titulo", titulo));
				if(!Checks.esNulo(listaObjeto) && !Checks.estaVacio(listaObjeto)) {
					for(HistoricoTramitacionTitulo htt: listaObjeto) {
						
						DtoHistoricoTramitacionTitulo aux = new DtoHistoricoTramitacionTitulo();
						beanUtilNotNull.copyProperty(aux, "idActivo", id);
						beanUtilNotNull.copyProperty(aux, "titulo", htt.getTitulo().getId());
						
						beanUtilNotNull.copyProperty(aux, "estadoPresentacion", htt.getEstadoPresentacion().getDescripcion());
						beanUtilNotNull.copyProperty(aux, "codigoEstadoPresentacion", htt.getEstadoPresentacion().getCodigo());
						beanUtilNotNull.copyProperty(aux, "fechaPresentacionRegistro", htt.getFechaPresentacionRegistro());
						beanUtilNotNull.copyProperty(aux, "idHistorico", htt.getId());
						if(!Checks.esNulo(htt.getFechaCalificacion())){
							beanUtilNotNull.copyProperty(aux, "fechaCalificacion", htt.getFechaCalificacion());
						}
						if(!Checks.esNulo(htt.getFechaInscripcion())){
							beanUtilNotNull.copyProperty(aux, "fechaInscripcion", htt.getFechaInscripcion());
						}
						if(!Checks.esNulo(htt.getObservaciones())){
							beanUtilNotNull.copyProperty(aux, "observaciones", htt.getObservaciones());
						}
						
						Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", id);
						List<ActivoCalificacionNegativa> ActivoTieneCalificacionNegativa = genericDao.getList(ActivoCalificacionNegativa.class, filtroActivo);
						if(ActivoTieneCalificacionNegativa.isEmpty()) {
							beanUtilNotNull.copyProperty(aux, "tieneCalificacionNoSubsanada",1);
						}else {
							Filter filtroMotivo = genericDao.createFilter(FilterType.EQUALS, "estadoMotivoCalificacioNegativa.codigo",DDEstadoMotivoCalificacionNegativa.DD_PENDIENTE_CODIGO);
							List<ActivoCalificacionNegativa> actCalNeg = genericDao.getList(ActivoCalificacionNegativa.class, filtroActivo,filtroMotivo);
						
							beanUtilNotNull.copyProperty(aux, "tieneCalificacionNoSubsanada", actCalNeg.isEmpty() ? 0 : 1);
						}
						
						listaDto.add(aux);
					}
				}
			}
		} catch (Exception ex) {
			logger.error("Error en getHistoricoTramitacionTitulo", ex);
		}
		return listaDto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createHistoricoTramtitacionTitulo(DtoHistoricoTramitacionTitulo tramitacionDto,Long idActivo) throws HistoricoTramitacionException {
		
		HistoricoTramitacionTitulo htt = new HistoricoTramitacionTitulo();
		ActivoTitulo titulo = activoAdapter.getActivoById(idActivo).getTitulo();
		Order order = new Order(OrderType.DESC, "id");
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "titulo.activo.id", idActivo);
		List<HistoricoTramitacionTitulo> listasTramitacion = genericDao.getListOrdered(HistoricoTramitacionTitulo.class, order, filtro);
		String estadoTitulo = null;
			try {
				if(!Checks.estaVacio(listasTramitacion)) {
					if(!Checks.esNulo(listasTramitacion.get(0).getFechaCalificacion()) && listasTramitacion.get(0).getFechaCalificacion().after(tramitacionDto.getFechaPresentacionRegistro())) {
						throw new HistoricoTramitacionException("La fecha de presentación no puede ser menor que la fecha de calificación negativa anterior.");
					}else if(!Checks.esNulo(listasTramitacion.get(0).getEstadoPresentacion()) && listasTramitacion.get(0).getFechaCalificacion().after(tramitacionDto.getFechaPresentacionRegistro())){
						throw new HistoricoTramitacionException("La fecha de presentación no puede ser menor que la fecha de presentación anterior.");
					}
					
				}
				beanUtilNotNull.copyProperty(htt, "titulo", titulo);
				if(!Checks.esNulo(tramitacionDto.getFechaPresentacionRegistro())) {
					beanUtilNotNull.copyProperty(htt, "fechaPresentacionRegistro", tramitacionDto.getFechaPresentacionRegistro());
				}
				if(!Checks.esNulo(tramitacionDto.getEstadoPresentacion())) {
					DDEstadoPresentacion estadoPresentacion = (DDEstadoPresentacion) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDEstadoPresentacion.class, tramitacionDto.getEstadoPresentacion());
					this.doCheckEstadoTramitacionTitulo(titulo, estadoPresentacion);
					beanUtilNotNull.copyProperty(htt, "estadoPresentacion", estadoPresentacion);
					if (DDEstadoPresentacion.PRESENTACION_EN_REGISTRO.equals(estadoPresentacion.getCodigo())) {
						estadoTitulo = DDEstadoTitulo.ESTADO_EN_TRAMITACION;
					}
					
					if (DDEstadoPresentacion.INSCRITO.equals(estadoPresentacion.getCodigo()) && !Checks.esNulo(tramitacionDto.getFechaInscripcion())) {
						htt.getTitulo().setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
						estadoTitulo = DDEstadoTitulo.ESTADO_INSCRITO;
					}
					
					if (DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE.equals(estadoPresentacion.getCodigo())) {
						estadoTitulo = DDEstadoTitulo.ESTADO_SUBSANAR;
					}
				}
				if(!Checks.esNulo(tramitacionDto.getFechaCalificacion())) {
					beanUtilNotNull.copyProperty(htt, "fechaCalificacion", tramitacionDto.getFechaCalificacion());
				}
				if(!Checks.esNulo(tramitacionDto.getFechaInscripcion())) {
					beanUtilNotNull.copyProperty(htt, "fechaInscripcion", tramitacionDto.getFechaInscripcion());
				}
				if(!Checks.esNulo(tramitacionDto.getObservaciones())) {
					beanUtilNotNull.copyProperty(htt, "observaciones", tramitacionDto.getObservaciones());
				}
				
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager", e);
				return false;

			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager", e);
				return false;
			}
			
			DDEstadoTitulo ddEstadoTitulo = genericDao.get(DDEstadoTitulo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoTitulo));
			if (!Checks.esNulo(ddEstadoTitulo)) {
				htt.getTitulo().setEstado(ddEstadoTitulo);
			}
			
		genericDao.save(HistoricoTramitacionTitulo.class, htt);
		return true;
	}


	@Override
	@Transactional(readOnly = false)
	public boolean updateHistoricoTramtitacionTitulo(DtoHistoricoTramitacionTitulo tramitacionDto) throws Exception, HistoricoTramitacionException{
		
		HistoricoTramitacionTitulo htt = genericDao.get(HistoricoTramitacionTitulo.class,genericDao.createFilter(FilterType.EQUALS, "id", tramitacionDto.getIdHistorico()));
		String estadoTitulo = null;
		ActivoTitulo activoTitulo = htt.getTitulo();
		Order order = new Order(OrderType.DESC, "id");
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "titulo.activo.id", tramitacionDto.getIdActivo());
		List<HistoricoTramitacionTitulo> listasTramitacion = genericDao.getListOrdered(HistoricoTramitacionTitulo.class, order, filtro);
		try {
				
				if(!Checks.esNulo(tramitacionDto.getFechaPresentacionRegistro())) {
					//Comprobar que la fecha de presentación de una segunda presentación no es inferiór a la de primera calificación o en su defecto de primera presentación
					if(!Checks.estaVacio(listasTramitacion) && listasTramitacion.size() > 1) {
						if(!Checks.esNulo(listasTramitacion.get(1).getFechaCalificacion()) && listasTramitacion.get(1).getFechaCalificacion().after(tramitacionDto.getFechaPresentacionRegistro())) {
							throw new HistoricoTramitacionException("La fecha de presentación no puede ser menor que la fecha de calificación negativa anterior.");
						}else if(!Checks.esNulo(listasTramitacion.get(1).getEstadoPresentacion()) && listasTramitacion.get(1).getFechaCalificacion().after(tramitacionDto.getFechaPresentacionRegistro())){
							throw new HistoricoTramitacionException("La fecha de presentación no puede ser menor que la fecha de presentación anterior.");
						}
					}
					//Comprobar que no se edite la fecha de presentación no sea menor que la fecha de calificación
					if(!Checks.estaVacio(listasTramitacion) && !Checks.esNulo(tramitacionDto.getFechaPresentacionRegistro()) && !Checks.esNulo(listasTramitacion.get(0).getFechaCalificacion()) 
							&& Checks.esNulo(tramitacionDto.getFechaCalificacion()) && tramitacionDto.getFechaPresentacionRegistro().after(listasTramitacion.get(0).getFechaCalificacion())){
						throw new HistoricoTramitacionException("La fecha de calificación negativa no puede ser menor a la fecha de presentación.");
					}
					//Comprobar que no se edite la fecha de presentación para que sea después de la fecha de inscripción.
					if(!Checks.estaVacio(listasTramitacion) && !Checks.esNulo(tramitacionDto.getFechaPresentacionRegistro()) && !Checks.esNulo(listasTramitacion.get(0).getFechaInscripcion()) &&
							Checks.esNulo(tramitacionDto.getFechaInscripcion()) && tramitacionDto.getFechaPresentacionRegistro().after(listasTramitacion.get(0).getFechaInscripcion())){
						throw new HistoricoTramitacionException("La fecha de inscripción no puede ser menor a la fecha de presentación.");
					}
				}
				if(!Checks.esNulo(tramitacionDto.getFechaPresentacionRegistro())) {
					beanUtilNotNull.copyProperty(htt, "fechaPresentacionRegistro", tramitacionDto.getFechaPresentacionRegistro());
				}
				if(!Checks.esNulo(tramitacionDto.getEstadoPresentacion())) {
					DDEstadoPresentacion estadoPresentacion = (DDEstadoPresentacion) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDEstadoPresentacion.class, tramitacionDto.getEstadoPresentacion());
					beanUtilNotNull.copyProperty(htt, "estadoPresentacion", estadoPresentacion);
					if (DDEstadoPresentacion.PRESENTACION_EN_REGISTRO.equals(estadoPresentacion.getCodigo())) {
						estadoTitulo = DDEstadoTitulo.ESTADO_EN_TRAMITACION;
						htt.setFechaInscripcion(null);
						htt.setFechaCalificacion(null);
						activoTitulo.setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
					}
					if (DDEstadoPresentacion.INSCRITO.equals(estadoPresentacion.getCodigo()) && !Checks.esNulo(tramitacionDto.getFechaInscripcion())) {
						activoTitulo.setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
						estadoTitulo = DDEstadoTitulo.ESTADO_INSCRITO;
						htt.setFechaCalificacion(null);
					}
					if (DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE.equals(estadoPresentacion.getCodigo())) {
						estadoTitulo = DDEstadoTitulo.ESTADO_SUBSANAR;
						htt.setFechaInscripcion(null);
						activoTitulo.setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
					}
				}
				if(!Checks.esNulo(tramitacionDto.getFechaCalificacion())) {
					beanUtilNotNull.copyProperty(htt, "fechaCalificacion", tramitacionDto.getFechaCalificacion());
				}
				if(!Checks.esNulo(tramitacionDto.getFechaInscripcion())) {
					beanUtilNotNull.copyProperty(htt, "fechaInscripcion", tramitacionDto.getFechaInscripcion());
					activoTitulo.setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
				}
				if(!Checks.esNulo(tramitacionDto.getObservaciones())) {
					beanUtilNotNull.copyProperty(htt, "observaciones", tramitacionDto.getObservaciones());
				}
				
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager", e);
				return false;

			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager", e);
				return false;
			}
		if (!Checks.esNulo(estadoTitulo)) {
			DDEstadoTitulo ddEstadoTitulo = genericDao.get(DDEstadoTitulo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoTitulo));
			if (!Checks.esNulo(ddEstadoTitulo)) {
				activoTitulo.setEstado(ddEstadoTitulo);
			}
		}
		
		if (!Checks.esNulo(activoTitulo)) {
			genericDao.save(ActivoTitulo.class, activoTitulo);
		}
		genericDao.save(HistoricoTramitacionTitulo.class, htt);
		return true;
	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean destroyHistoricoTramtitacionTitulo(DtoHistoricoTramitacionTitulo tramitacionDto) {
		HistoricoTramitacionTitulo htt = genericDao.get(HistoricoTramitacionTitulo.class,
				genericDao.createFilter(FilterType.EQUALS, "id", tramitacionDto.getIdHistorico()));
		if (htt != null) {
			if (htt.getTitulo() != null) {
				ActivoTitulo titulo = htt.getTitulo();
				if (titulo != null) {
					boolean gridConDatos = getHistoricoTramitacionTitulo(titulo.getActivo().getId()).isEmpty();
					String nuevoEstado = gridConDatos ? DDEstadoTitulo.ESTADO_SUBSANAR : DDEstadoTitulo.ESTADO_EN_TRAMITACION;
					
					DDEstadoTitulo estadoTitulo = (DDEstadoTitulo) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDEstadoTitulo.class, nuevoEstado);
					titulo.setEstado(estadoTitulo);
					genericDao.save(ActivoTitulo.class, titulo);
					
					List<ActivoCalificacionNegativa> calNegList = genericDao.getList(ActivoCalificacionNegativa.class,
							genericDao.createFilter(FilterType.EQUALS, "historicoTramitacionTitulo.id", htt.getId()));
					for(ActivoCalificacionNegativa calNeg : calNegList ) {
						calNeg.getAuditoria().setBorrado(true);
						calNeg.getAuditoria().setFechaBorrar(new Date());
						calNeg.getAuditoria().setUsuarioBorrar(usuarioApi.getUsuarioLogado().getUsername());
						
						genericDao.save(ActivoCalificacionNegativa.class, calNeg);
					}
				}
			}
			genericDao.deleteById(HistoricoTramitacionTitulo.class, htt.getId());
			return true;
		}
		return false;
	}
	
	public void existeCalificacionNegativa(List<DtoHistoricoTramitacionTitulo> listaDto, DtoActivoDatosRegistrales dto) {
		try {
			if (!listaDto.isEmpty()) {
				for(DtoHistoricoTramitacionTitulo item: listaDto) {
					if (item.getCodigoEstadoPresentacion().equals(DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE)) {
						beanUtilNotNull.copyProperty(dto, "fechaPresentacionRegistroCN", item.getFechaPresentacionRegistro());
						if (item.getFechaInscripcion()!=null) {
							beanUtilNotNull.copyProperty(dto, "fechaCalificacionNegativa", item.getFechaInscripcion());
						}else if (item.getFechaCalificacion()!=null) {
							beanUtilNotNull.copyProperty(dto, "fechaCalificacionNegativa", item.getFechaCalificacion());
						}
						break;
					}
				}
			}
		}catch (Exception e) {
			logger.error("Error en Activo Manager (existeCalificacionNegativa)", e);
		}
	}
	

	@Override
	public List<DtoProveedorMediador> getComboApiPrimario() {
		
		List<ActivoProveedor> comboApiPrimario = activoDao.getComboApiPrimario();
		
		List<DtoProveedorMediador> listaDto = new ArrayList<DtoProveedorMediador>();
		
		for (ActivoProveedor activoProveedor : comboApiPrimario) {
			DtoProveedorMediador dto = new DtoProveedorMediador();
			dto.setNombre(activoProveedor.getNombre());
			dto.setId(activoProveedor.getId());
			listaDto.add(dto);
		}
		
		return listaDto;
	}
	public boolean isActivoPerteneceAgrupacionRestringida(Activo activo) {
		for(ActivoAgrupacionActivo agrupacion: activo.getAgrupaciones()){
			if(Checks.esNulo(agrupacion.getAgrupacion().getFechaBaja())) {
				if(!Checks.esNulo(agrupacion.getAgrupacion().getTipoAgrupacion())
						&& DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupacion.getAgrupacion().getTipoAgrupacion().getCodigo())){
					return true;
				}
			}
		}
		return false;
	}
	
	@Override
	public ActivoDto getDatosActivo(Long activoId) {
		ActivoDto activoDto = new ActivoDto();
		
		Activo activo = activoAdapter.getActivoById(activoId);
		
		try {
			beanUtilNotNull.copyProperty(activoDto, "activoId", activo.getId());
			beanUtilNotNull.copyProperty(activoDto, "numActivo", activo.getNumActivo());
			if(!Checks.esNulo(activo.getInfoRegistral()) &&  !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien())) {
				beanUtilNotNull.copyProperty(activoDto, "fincaRegistral", activo.getInfoRegistral().getInfoRegistralBien().getNumFinca());
			}
			if(!Checks.esNulo(activo.getTipoActivo())) {
				beanUtilNotNull.copyProperty(activoDto, "tipoActivo", activo.getTipoActivo().getDescripcion());
			}
			if(!Checks.esNulo(activo.getSubtipoActivo())){
				beanUtilNotNull.copyProperty(activoDto, "subtipoActivo", activo.getSubtipoActivo().getDescripcion());
			}
			
			
			if(!Checks.esNulo(activo.getMunicipio())){
				Localidad municipio = genericDao.get(Localidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", activo.getMunicipio()));
				if(!Checks.esNulo(municipio)) {
					beanUtilNotNull.copyProperty(activoDto, "municipio", municipio.getDescripcion());
					if(!Checks.esNulo(municipio.getProvincia())){
						beanUtilNotNull.copyProperty(activoDto, "provincia", municipio.getProvincia().getDescripcion());
					}
				}
			}
			
			
			
			
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage(),e);
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage(),e);
		}
		
		
		return activoDto;
	}

	public void deleteActOfr(Long idActivo, Long idOferta) {
		activoDao.deleteActOfr(idActivo, idOferta);
	}
	
	@Override
	public List<DDFasePublicacion> getDiccionarioFasePublicacion() throws Exception {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC, "codigo");
		return genericDao.getListOrdered(DDFasePublicacion.class, order, filtro);
	}
	
	
	private void doCheckEstadoTramitacionTitulo(ActivoTitulo titulo, DDEstadoPresentacion estado) throws HistoricoTramitacionException {
		List<DtoHistoricoTramitacionTitulo> listaTramitacionTitulo = getHistoricoTramitacionTitulo(
				titulo.getActivo().getId());
		if (!listaTramitacionTitulo.isEmpty()) {
			String estadoPresentacion = listaTramitacionTitulo.get(0) != null ? listaTramitacionTitulo.get(0).getCodigoEstadoPresentacion() : "";
			if (!DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE.equals(estadoPresentacion)) {
				throw new HistoricoTramitacionException(HistoricoTramitacionException.getErrorAlAnyadirRegistroAlTitulo(estado.getDescripcion()));
				
			}
				
		}
	}
}

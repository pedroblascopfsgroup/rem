package es.pfsgroup.plugin.rem.activo;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.security.MessageDigest;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
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
import org.springframework.ui.ModelMap;

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
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.persona.model.DDTipoPersona;
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
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.manager.RestClientManager;
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
import es.pfsgroup.plugin.rem.activo.dao.impl.ActivoTributoDaoImpl;
import es.pfsgroup.plugin.rem.activo.exception.HistoricoTramitacionException;
import es.pfsgroup.plugin.rem.activo.exception.PlusvaliaActivoException;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.ActivoPublicacionDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.alaskaComunicacion.AlaskaComunicacionManager;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoCargasApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.api.ActivoPropagacionApi;
import es.pfsgroup.plugin.rem.api.ActivoTributoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.factory.TabActivoFactoryApi;
import es.pfsgroup.plugin.rem.gestor.GestorActivoManager;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.gestorDocumental.dto.documentos.GestorDocToRecoveryAssembler;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
import es.pfsgroup.plugin.rem.model.dd.DDCalculoImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCesionSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDDescripcionFotoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDDistritoCaixa;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGestionPlusv;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoLocalizacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoMotivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPresentacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDFasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDIdentificacionGestoria;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAltaSuministro;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAutorizacionTramitacion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoBajaSuministro;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoExento;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRetencion;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenDato;
import es.pfsgroup.plugin.rem.model.dd.DDPeriodicidad;
import es.pfsgroup.plugin.rem.model.dd.DDResponsableSubsanar;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoSolicitud;
import es.pfsgroup.plugin.rem.model.dd.DDSegmentoCarteraSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoAgendaSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoSuministro;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTerritorio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgendaSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCargaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCorrectivoSareb;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCuotaComunidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDeDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocPlusvalias;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGastoAsociado;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFoto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGastoAsociado;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoObservacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeticionPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRolMediador;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSegmento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSolicitudTributo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSuministro;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloComplemento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloPosesorio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTransmision;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTributo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;
import es.pfsgroup.plugin.rem.model.dd.DDTributacionPropuestaClienteExentoIva;
import es.pfsgroup.plugin.rem.model.dd.DDTributacionPropuestaVenta;
import es.pfsgroup.plugin.rem.recoveryComunicacion.RecoveryComunicacionManager;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PRINCIPAL;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PROPIEDAD;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.SITUACION;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.TIPO;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ActivoCrearPeticionTrabajoDto;
import es.pfsgroup.plugin.rem.rest.dto.ActivoDto;
import es.pfsgroup.plugin.rem.rest.dto.File;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.rest.dto.HistoricoPropuestasPreciosDto;
import es.pfsgroup.plugin.rem.rest.dto.PortalesDto;
import es.pfsgroup.plugin.rem.rest.dto.ReqFaseVentaDto;
import es.pfsgroup.plugin.rem.rest.dto.SaneamientoAgendaDto;
import es.pfsgroup.plugin.rem.service.TabActivoService;
import es.pfsgroup.plugin.rem.tareasactivo.TareaActivoManager;
import es.pfsgroup.plugin.rem.thread.ConvivenciaAlaska;
import es.pfsgroup.plugin.rem.thread.ConvivenciaRecovery;
import es.pfsgroup.plugin.rem.thread.GuardarActivosRestringidasAsync;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;
import es.pfsgroup.plugin.rem.visita.dao.VisitaDao;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGrupoUsuariosApi;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;
import org.springframework.ui.ModelMap;

@Service("activoManager")
public class ActivoManager extends BusinessOperationOverrider<ActivoApi> implements ActivoApi {

	protected static final Log logger = LogFactory.getLog(ActivoManager.class);
	private static final String AVISO_MEDIADOR_NO_EXISTE = "activo.aviso.mediador.no.existe";
	private static final String ERROR_NIF_CIF_INVALIDO = "msg.error.documento.identificativo";
	private static final String AVISO_MEDIADOR_BAJA = "activo.aviso.mediador.baja";
	private static final String EMAIL_OCUPACIONES = "emailOcupaciones";
	private static final String KEY_GDPR = "gdpr.data.key";
	private static final String URL_GDPR = "gdpr.data.url";
	private static final String AVISO_MENSAJE_MOTIVO_CALIFICACION = "activo.aviso.motivo.calificacion.duplicado";
	private static final String RELACION_TIPO_DOCUMENTO_EXPEDIENTE = "d-e";
	private static final String OPERACION_ALTA = "Alta";
	public static final String ERROR_ANYADIR_PRESTACIONES_EN_REGISTRO = "Ya existe un registro 'Presentación en registro', y está activo";
	public static final String ERROR_ANYADIR_EN_REGISTRO = "Ya existe un registro '%s', y está activo";
	public static final String GRUPO_OFICIONA_KAM = "gruofikam";
	private static final String DESC_SI = "Sí";
	private static final String DESC_NO = "No";
	private static final String DESC_NO_CON_INDICIOS = "No, con indicios";

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
	private ActivoCargasDao activoCargasDao;

	@Autowired
	private ActivoTributoApi activoTributoApi;

	@Autowired
	private ActivoTributoDaoImpl tributoDaoImpl;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private GestorActivoManager gestorActivoManager;

	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
    private UsuarioManager usuarioManager;
	
	@Autowired
	private EXTGrupoUsuariosDao extGrupoUsuariosDao;

	@Autowired
	private RecoveryComunicacionManager recoveryComunicacionManager;

	@Autowired
	private AlaskaComunicacionManager alaskaComunicacionManager;

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
	public boolean esPopietarioRemaining(TareaExterna tareaExterna) {
		Activo activo = tareaExternaToActivo(tareaExterna);
		ActivoPropietario propietario = activo.getPropietarioPrincipal();
		if (!Checks.esNulo(propietario) && ("Remaining").equals(propietario.getNombre())) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public boolean esPopietarioArrow(TareaExterna tareaExterna) {
		Activo activo = tareaExternaToActivo(tareaExterna);
		ActivoPropietario propietario = activo.getPropietarioPrincipal();
		if (!Checks.esNulo(propietario) && ("Arrow").equals(propietario.getNombre())) {
			return true;
		} else {
			return false;
		}
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
	 * Actualiza el estado del check publicar sin precio segun el precio vigente que
	 * se guarda.
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

	@Override
	@BusinessOperation(overrides = "activoManager.saveActivoValoracion")
	@Transactional(readOnly = false)
	public boolean saveActivoValoracion(Activo activo, ActivoValoraciones activoValoracion, DtoPrecioVigente dto) {
		String codigoTipoPrecio = dto.getCodigoTipoPrecio();

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
				if(activoPublicacion != null){
					
					if(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(codigoTipoPrecio)
							|| DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO.equals(codigoTipoPrecio)
							|| DDTipoPrecio.CODIGO_TPC_DESC_APROBADO.equals(codigoTipoPrecio)
							|| DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO.equals(codigoTipoPrecio)) {
						activoPublicacion.setFechaCambioValorVenta(new Date());
					}
					
					if(DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA.equals(codigoTipoPrecio)){
						activoPublicacion.setFechaCambioValorAlq(new Date());
					}
					
					genericDao.update(ActivoPublicacion.class,activoPublicacion);
				}
				genericDao.update(ActivoValoraciones.class, activoValoracion);

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
				activoValoracion.setImporte(dto.getImporte());
				activoValoracion.setGestor(adapter.getUsuarioLogado());

				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoValoracion.getActivo().getId());
				ActivoPublicacion activoPublicacion = genericDao.get(ActivoPublicacion.class,filtro);
				
				if(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(codigoTipoPrecio)
						|| DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO.equals(codigoTipoPrecio)
						|| DDTipoPrecio.CODIGO_TPC_DESC_APROBADO.equals(codigoTipoPrecio)
						|| DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO.equals(codigoTipoPrecio)) {
					activoPublicacion.setFechaCambioValorVenta(new Date());
				}
				
				if(DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA.equals(codigoTipoPrecio)){
					activoPublicacion.setFechaCambioValorAlq(new Date());
				}	
				
				genericDao.save(ActivoValoraciones.class, activoValoracion);
				genericDao.update(ActivoPublicacion.class, activoPublicacion);
			}

			if (DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(dto.getCodigoTipoPrecio())) {
				// Actualizar el tipoComercialización del activo
				updaterState.updaterStateTipoComercializacion(activo);
			}

			if (!Checks.esNulo(dto.getLiquidez())) {
				activo.setValorLiquidez(dto.getLiquidez());
			}

			genericDao.update(Activo.class, activo);

		} catch (Exception ex) {
			logger.error("Error en activoManager", ex);
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean saveActivoValoracionHistorico(ActivoValoraciones activoValoracion) {
		ActivoHistoricoValoraciones historicoValoracion = new ActivoHistoricoValoraciones();

		historicoValoracion.setActivo(activoValoracion.getActivo());
		historicoValoracion.setTipoPrecio(activoValoracion.getTipoPrecio());
		historicoValoracion.setImporte(activoValoracion.getImporte());
		historicoValoracion.setFechaInicio(activoValoracion.getFechaInicio());
		historicoValoracion.setFechaFin(
				(!Checks.esNulo(activoValoracion.getFechaFin()) ? activoValoracion.getFechaFin() : new Date()));
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

		if (actVal.getTipoPrecio().getCodigo().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA)
				|| actVal.getTipoPrecio().getCodigo().equals(DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO)
				|| actVal.getTipoPrecio().getCodigo().equals(DDTipoPrecio.CODIGO_TPC_DESC_APROBADO)
				|| actVal.getTipoPrecio().getCodigo().equals(DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO)) {
			activoPublicacion.setFechaCambioValorVenta(new Date());

		}
		if (actVal.getTipoPrecio().getCodigo().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA)) {
			activoPublicacion.setFechaCambioValorAlq(new Date());
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteValoracionPrecioConGuardadoEnHistorico(Long id, Boolean guardadoEnHistorico,
			Boolean comprobarGestor) {
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
	@Transactional(readOnly = false)
	public String uploadFactura(WebFileItem webFileItem, Long idDocRestClient, GastoAsociadoAdquisicion gas, DDTipoDocumentoGastoAsociado tipoDocGastoAsociado)
			throws UserException {

		try {
			if (!Checks.esNulo(gas)) {

				Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());

				AdjuntoGastoAsociado adjuntoGas = new AdjuntoGastoAsociado();
				adjuntoGas.setAdjunto(adj);
				adjuntoGas.setTipoDocumentoGastoAsociado(tipoDocGastoAsociado);
				adjuntoGas.setGastoAsociadoAdquisicion(gas);
				adjuntoGas.setIdentificadorGestorDocumental(idDocRestClient);
				adjuntoGas.setTipoContenidoDocumento(webFileItem.getFileItem().getContentType());
				adjuntoGas.setTamanyoDocumento(webFileItem.getFileItem().getLength());
				adjuntoGas.setNombreAdjuntoGastoAsociado(webFileItem.getFileItem().getFileName());
				adjuntoGas.setDescripcionDocumento(webFileItem.getParameter("descripcion"));
				adjuntoGas.setFechaSubidaDocumento(new Date());

				Auditoria.save(adjuntoGas);

				gas.setFactura(adjuntoGas);

				genericDao.save(GastoAsociadoAdquisicion.class, gas);
			} else {
				throw new UserException("No se ha encontrado gasto asociado para relacionar con la factura");
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

				if (fileItem.getMetadata().containsKey("orden") && fileItem.getMetadata().get("orden") != null) {
					String ordenCadena = fileItem.getMetadata().get("orden");
					if (ordenCadena.matches("^[-+]?[0-9]+$")) {
						try {
							orden = Integer.valueOf(ordenCadena);
						} catch (NumberFormatException ex) {
							orden = null;
						}

					}
				}
				if (orden == null) {
					orden = activoDao.getMaxOrdenFotoById(activo.getId()) + 1;
				}

				activoFoto.setOrden(orden);
				activoFoto.setActivo(activo);
				activoFoto.setTipoFoto(tipoFoto);
				activoFoto.setNombre(fileItem.getBasename());
				
				String descripcion = null;
				String codigoSubtipoActivo = activo.getSubtipoActivo().getCodigo();
				DDDescripcionFotoActivo descripcionFoto = null;

				if (fileItem.getMetadata().containsKey("descripcion")) {
					descripcion = fileItem.getMetadata().get("descripcion");
					if (descripcion != null && codigoSubtipoActivo != null) {
						descripcionFoto = genericDao.get(DDDescripcionFotoActivo.class, genericDao.createFilter(FilterType.EQUALS, "descripcion", descripcion), 
							genericDao.createFilter(FilterType.EQUALS, "subtipoActivo.codigo", codigoSubtipoActivo));
					}
					if (descripcionFoto != null) {
						activoFoto.setDescripcion(descripcionFoto.getDescripcion());
						activoFoto.setDescripcionFoto(descripcionFoto);
					}
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
	@BusinessOperation(overrides = "activoManager.uploadFotos")
	@Transactional(readOnly = false)
	public String uploadFotos(List<WebFileItem> fileItemList) {
		if (fileItemList == null || fileItemList.isEmpty())
			throw new JsonViewerException("Error al subir la/s foto/s");
		
		for (WebFileItem fileItem : fileItemList) {
			Activo activo = this.get(Long.parseLong(fileItem.getParameter("idEntidad")));
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
			DDTipoFoto tipoFoto = genericDao.get(DDTipoFoto.class, filtro);
			TIPO tipo = null;
			FileResponse fileReponse = null;
			ActivoFoto activoFoto = null;
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
	
					if (fileItem.getParameter("codigoDescripcionFoto") != null) {
						
						fileReponse = gestorDocumentalFotos.upload(fileItem.getFileItem().getFile(),
								fileItem.getFileItem().getFileName(), PROPIEDAD.ACTIVO, activo.getNumActivo(), tipo,
								genericDao.get(DDDescripcionFotoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("codigoDescripcionFoto"))).getDescripcion(),
								principal, situacion, orden);
						
					}
					activoFoto = new ActivoFoto(fileReponse.getData());
	
				} else {
					activoFoto = new ActivoFoto(fileItem.getFileItem());
				}
	
				activoFoto.setActivo(activo);
				activoFoto.setTipoFoto(tipoFoto);
				activoFoto.setTamanyo(fileItem.getFileItem().getLength());
				activoFoto.setNombre(fileItem.getFileItem().getFileName());
				activoFoto.setDescripcion(genericDao.get(DDDescripcionFotoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("codigoDescripcionFoto"))).getDescripcion());
				activoFoto.setDescripcionFoto(genericDao.get(DDDescripcionFotoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("codigoDescripcionFoto"))));
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
	public Integer getMaxOrdenFotoByIdSubdivision(Long idEntidad, Long hashSdv) {
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
		if (activoDao.isUnidadAlquilable(idActivo)) {
			ActivoAgrupacion actagr = activoDao.getAgrupacionPAByIdActivo(idActivo);
			idActivo = activoDao.getIdActivoMatriz(actagr.getId());

		}
		return !Checks.esNulo(activoDao.getPresupuestoActual(idActivo));
	}

	@SuppressWarnings("deprecation")
	@BusinessOperationDefinition("activoManager.comprobarPestanaCheckingInformacion")
	public Boolean comprobarPestanaCheckingInformacion(Long idActivo) {
		Activo activo = this.get(idActivo);
		return !Checks.esNulo(activo.getTipoActivo()) && !Checks.esNulo(activo.getSubtipoActivo())
				&& !Checks.esNulo(activo.getDivHorizontal()) && !Checks.esNulo(activo.getGestionHre())
				&& !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getTipoVia())
				&& !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getNombreVia())
				&& !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getCodPostal())
				&& !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getLocalidad())
				&& !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getPoblacion())
				&& !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getPais())
				&& !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getLocalidad())
				&& !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro())
				&& !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getNumFinca())
				&& !Checks.esNulo(activo.getVpo()) && !Checks.esNulo(activo.getOrigen())
				&& !Checks.esNulo(activo.getPropietariosActivo())
				&& comprobarPropietario(activo.getPropietariosActivo()) && !Checks.esNulo(activo.getCatastro())
				&& comprobarCatastro(activo.getCatastro());
	}

	@Override
	@BusinessOperationDefinition("activoManager.comprobarExisteAdjuntoActivo")
	public Boolean comprobarExisteAdjuntoActivo(Long idActivo, String codigoDocumento) {
		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter codigoDocumentoFilter = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo.codigo", codigoDocumento);
		
		List<ActivoAdjuntoActivo> adjuntosActivo = genericDao.getList(ActivoAdjuntoActivo.class, idActivoFilter, codigoDocumentoFilter);
		
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
	 * @param idActivo identificador del Activo
	 * @return boolean
	 */
	@Override
	@BusinessOperationDefinition("activoManager.comprobarExisteFechaPosesionActivo")
	public Boolean comprobarExisteFechaPosesionActivo(Long idActivo) throws Exception {
		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);

		ActivoSituacionPosesoria situacionPosesoriaActivo = genericDao.get(ActivoSituacionPosesoria.class,
				idActivoFilter);

		return !Checks.esNulo(situacionPosesoriaActivo)
				&& !Checks.esNulo(situacionPosesoriaActivo.getFechaTomaPosesion());

	}

	/**
	 * Sirve para comprobar si el activo está vendido
	 */
	public Boolean isVendido(Long idActivo) {
		Activo activo = get(idActivo);

		return DDSituacionComercial.CODIGO_VENDIDO.equals(activo.getSituacionComercial().getCodigo());
	}

	/**
	 * Devuelve mensaje de validación indicando los campos obligatorios que no han
	 * sido informados en la pestaña "Checking Información"
	 *
	 * @param idActivo identificador del Activo
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
			mensaje = messageServices.getMessage("tramite.CheckingInformacion.validacionPre.debeInformar")
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
	public VEsCondicionado getCondicionantesDisponibilidad(Long idActivo) {
		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo);
		return genericDao.get(VEsCondicionado.class, idActivoFilter);
	}
	
	@Override
	public VSinInformeAprobadoRem getSinInformeAprobadoREM(Long idActivo) {
		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo);
		return genericDao.get(VSinInformeAprobadoRem.class, idActivoFilter);
	}


	@Override
	@Transactional(readOnly = false)
	public Boolean saveCondicionantesDisponibilidad(Long idActivo,
			DtoCondicionantesDisponibilidad dtoCondicionanteDisponibilidad) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		ActivoSituacionPosesoria condicionantesDisponibilidad = genericDao.get(ActivoSituacionPosesoria.class, filtro);

		if (dtoCondicionanteDisponibilidad.getOtro() != null) {
			condicionantesDisponibilidad.setOtro(dtoCondicionanteDisponibilidad.getOtro());
		}

		if (dtoCondicionanteDisponibilidad.getComboOtro() != null) {
			condicionantesDisponibilidad.setComboOtro(dtoCondicionanteDisponibilidad.getComboOtro());

			if (dtoCondicionanteDisponibilidad.getComboOtro() == 0)
				condicionantesDisponibilidad.setOtro(null);
		}

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
				if (!Checks.esNulo(condicion.getCodigo())) {
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

		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");

		int i = 0;

		String codigo = null;

		Filter filtro2 = null;

		if (!Checks.esNulo(dtoCondicionEspecifica.getCodigo())) {
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "activo.id",
					dtoCondicionEspecifica.getIdActivo());
			Order order = new Order(OrderType.DESC, "id");
			List<ActivoCondicionEspecifica> listaCondicionesEspecificas = genericDao
					.getListOrdered(ActivoCondicionEspecifica.class, order, filter);

			int coincidencia = 0;

			for (ActivoCondicionEspecifica condicion : listaCondicionesEspecificas) {

				if (dtoCondicionEspecifica.getCodigo().equals(condicion.getCodigo())) {
					if (!Checks.esNulo(dtoCondicionEspecifica.getTexto())) {
						condicion.setTexto(dtoCondicionEspecifica.getTexto());
					}
					if (!Checks.esNulo(dtoCondicionEspecifica.getFechaDesde())) {
						condicion.setFechaDesde(dtoCondicionEspecifica.getFechaDesde());
					}
					if (!Checks.esNulo(dtoCondicionEspecifica.getFechaHasta())) {
						condicion.setFechaHasta(dtoCondicionEspecifica.getFechaHasta());
					}
					condicion.setUsuarioAlta(adapter.getUsuarioLogado());
					condicion.setUsuarioBaja(adapter.getUsuarioLogado());

					coincidencia = 1;

					genericDao.save(ActivoCondicionEspecifica.class, condicion);

					return true;
				}
			}

			if (coincidencia == 0) {
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
					return false;

				} catch (InvocationTargetException e) {
					logger.error("Error en activoManager", e);
					return false;
				}

				genericDao.save(ActivoCondicionEspecifica.class, condicionEspecifica);

				return true;
			}
		}

		do {
			codigo = dtoCondicionEspecifica.getIdActivo().toString() + sdf.format(new Date()) + i;
			filtro2 = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
			condicionEspecifica = genericDao.get(ActivoCondicionEspecifica.class, filtro2);
			i++;
		} while (!Checks.esNulo(condicionEspecifica));

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
			return false;

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
			return false;
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
		List<ActivoInformeComercialHistoricoMediador> listaHistoricoMediador = genericDao
				.getListOrdered(ActivoInformeComercialHistoricoMediador.class, order, filtro);

		List<DtoHistoricoMediador> listaDtoHistoricoMediador = new ArrayList<DtoHistoricoMediador>();

		for (ActivoInformeComercialHistoricoMediador historico : listaHistoricoMediador) {
			DtoHistoricoMediador dtoHistoricoMediador = new DtoHistoricoMediador();

			try {
				beanUtilNotNull.copyProperty(dtoHistoricoMediador, "id", historico.getId());
				beanUtilNotNull.copyProperty(dtoHistoricoMediador, "idActivo", idActivo);
				beanUtilNotNull.copyProperty(dtoHistoricoMediador, "fechaDesde", historico.getFechaDesde());
				beanUtilNotNull.copyProperty(dtoHistoricoMediador, "fechaHasta", historico.getFechaHasta());
				if (!Checks.esNulo(historico.getMediadorInforme())) {
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "codigo",
							historico.getMediadorInforme().getCodigoProveedorRem());
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "mediador",
							historico.getMediadorInforme().getNombre());
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "telefono",
							historico.getMediadorInforme().getTelefono1());
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "email",
							historico.getMediadorInforme().getEmail());
					if(historico.getTipoRolMediador() != null) {
						beanUtilNotNull.copyProperty(dtoHistoricoMediador, "rol",
							historico.getTipoRolMediador().getDescripcion());
					}
				}
				if (historico.getAuditoria() != null) {
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "responsableCambio",
							historico.getAuditoria().getUsuarioCrear());
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
		if(dto.getRol() == null) {
			throw new JsonViewerException("No existe el rol.");
		}
		DDTipoRolMediador tipoRol = genericDao.get(DDTipoRolMediador.class,genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getRol()));

		if(tipoRol == null) {
			tipoRol = genericDao.get(DDTipoRolMediador.class,genericDao.createFilter(FilterType.EQUALS, "descripcion", dto.getRol()));
		}
		
		if(tipoRol == null) {
			throw new JsonViewerException("El tipo de rol no es válido.");
		}
		
		if (!Checks.esNulo(dto.getIdActivo())) {
			activo = activoDao.get(dto.getIdActivo());
		}

		if (activo == null)
			return false;

		// Primero hacemos las validaciones de nuevo mediador
		validateNewMediador(activo, dto.getMediador(), tipoRol);

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

				// Buscamos la lista ordenada por id y recogemos el ultimo mediador para ese rol
				Filter activoIDFiltro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				Filter tipoRolFiltro = genericDao.createFilter(FilterType.EQUALS, "tipoRolMediador", tipoRol);
				Order order = new Order(OrderType.DESC, "id");
				List<ActivoInformeComercialHistoricoMediador> listadoHistoricoMediadorRol = genericDao.getListOrdered(
						ActivoInformeComercialHistoricoMediador.class, order, activoIDFiltro, tipoRolFiltro);
				ActivoInformeComercialHistoricoMediador historicoMediadorRol = null;

				if (listadoHistoricoMediadorRol != null && !listadoHistoricoMediadorRol.isEmpty())
					historicoMediadorRol = listadoHistoricoMediadorRol.get(0);

				// si no tiene fecha hasta, se la ponemos. Si la tiene, no hacemos nada ya que
				// es el mismo caso que si no hubiese mediador.
				if (historicoMediadorRol != null && historicoMediadorRol.getFechaHasta() == null) {
					beanUtilNotNull.copyProperty(historicoMediadorRol, "fechaHasta", fechaHoy);
					genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediadorRol);

				} else {
					// Si la lista esta vacia es porque es la primera vez que se modifica el
					// historico de mediadores, por lo que tenemos que introducir el que
					// habia antes. La fecha desde se deja vacia por ahora.
					if (!Checks.esNulo(activo.getInfoComercial().getMediadorInforme())
							&& !DDTipoRolMediador.CODIGO_TIPO_ESPEJO.equals(tipoRol.getCodigo())) {
						beanUtilNotNull.copyProperty(historicoMediadorPrimero, "fechaHasta", fechaHoy);
						beanUtilNotNull.copyProperty(historicoMediadorPrimero, "activo", activo);
						beanUtilNotNull.copyProperty(historicoMediadorPrimero, "mediadorInforme",
								activo.getInfoComercial().getMediadorInforme());

						historicoMediadorPrimero.setTipoRolMediador(tipoRol);

						genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediadorPrimero);
					}
				}
			}

			// Generar la nueva entrada de HistoricoMediador.
			beanUtilNotNull.copyProperty(historicoMediador, "fechaDesde", fechaHoy);
			beanUtilNotNull.copyProperty(historicoMediador, "activo", activo);
			historicoMediador.setTipoRolMediador(tipoRol);

			if (!Checks.esNulo(dto.getMediador()) && !dto.getMediador().isEmpty()) { // si no se selecciona mediador en
																						// el combo, se devuelve
																						// mediador "", no null.
				Filter proveedorFiltro = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",Long.parseLong(dto.getMediador()));
				ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, proveedorFiltro);

				if (Checks.esNulo(proveedor)) {
					// mandar mensaje
					throw new JsonViewerException(messageServices.getMessage(AVISO_MEDIADOR_NO_EXISTE));
				}

				if (!Checks.esNulo(proveedor.getFechaBaja())
						|| (!Checks.esNulo(proveedor.getEstadoProveedor()) && DDEstadoProveedor.ESTADO_BAJA_PROVEEDOR
								.equals(proveedor.getEstadoProveedor().getCodigo()))) {
					throw new JsonViewerException(messageServices.getMessage(AVISO_MEDIADOR_BAJA));
				}

				beanUtilNotNull.copyProperty(historicoMediador, "mediadorInforme", proveedor);

				// Asignar el nuevo proveedor de tipo mediador al activo, informacion comercial.
				if (!Checks.esNulo(activo.getInfoComercial())
						&& DDTipoRolMediador.CODIGO_TIPO_PRIMARIO.equals(tipoRol.getCodigo())) {
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "mediadorInforme", proveedor);
					genericDao.save(Activo.class, activo);
				} else {
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "mediadorEspejo", proveedor);
					genericDao.save(Activo.class, activo);
				}

			} else {
				return false; // si el mediador esta vacio se devuelve false
			}

			genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediador);

			if (activoDao.isActivoMatriz(activo.getId())) {
				ActivoAgrupacion agr = activoDao.getAgrupacionPAByIdActivo(activo.getId());
				if (!Checks.esNulo(agr)) {
					List<ActivoAgrupacionActivo> activosList = agr.getActivos();
					for (ActivoAgrupacionActivo act : activosList) {
						// Creamos el registro de Mediador en cada una de las UAs, pero no en el AM, ya
						// que venimos de crearlo.
						if (activoDao.isUnidadAlquilable(act.getActivo().getId())) {
							dto.setIdActivo(act.getActivo().getId());
							createHistoricoMediador(dto);
						}
					}
					dto.setIdActivo(activo.getId()); // Necesario cuando se realiza la carga masiva, para que no de
														// error por modificar el dto
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

	private void validateNewMediador(Activo activo, String codigoMediador, DDTipoRolMediador tipoRol) {
		Filter activoFiltro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Filter tipoRolFiltro = null;
		Boolean esTipoEspejo = false;

		if (DDTipoRolMediador.CODIGO_TIPO_PRIMARIO.equals(tipoRol.getCodigo())) {
			tipoRolFiltro = genericDao.createFilter(FilterType.EQUALS, "tipoRolMediador.codigo",
					DDTipoRolMediador.CODIGO_TIPO_ESPEJO);
		} else {
			esTipoEspejo = true;
			tipoRolFiltro = genericDao.createFilter(FilterType.EQUALS, "tipoRolMediador.codigo",
					DDTipoRolMediador.CODIGO_TIPO_PRIMARIO);
		}
		Order order = new Order(OrderType.DESC, "id");
		List<ActivoInformeComercialHistoricoMediador> listadoHistoricoMediadorRol = genericDao
				.getListOrdered(ActivoInformeComercialHistoricoMediador.class, order, activoFiltro, tipoRolFiltro);
		ActivoInformeComercialHistoricoMediador historicoMediadorRolContrario = null;

		if (listadoHistoricoMediadorRol != null && !listadoHistoricoMediadorRol.isEmpty()) {
			historicoMediadorRolContrario = listadoHistoricoMediadorRol.get(0);

			if (codigoMediador
					.equals(historicoMediadorRolContrario.getMediadorInforme().getCodigoProveedorRem().toString())
					&& historicoMediadorRolContrario.getFechaHasta() == null) {
				throw new JsonViewerException("No se puede asignar el mediador del tipo " + tipoRol.getDescripcion()
						+ " si está asignado como mediador de tipo "
						+ historicoMediadorRolContrario.getTipoRolMediador().getDescripcion());
			}

		} else if (esTipoEspejo) {
			// Solución temporal HREOS-9160
			ActivoInfoComercial infoComercial = activo.getInfoComercial();
			if (infoComercial != null && infoComercial.getMediadorInforme() == null) {
				throw new JsonViewerException("No se puede asignar Api Espejo sin Api Primario asignado");
			}
		}

	}

	@Override
	public Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro) {
		return activoDao.getPropuestas(dtoPropuestaFiltro);
	}

	@Override
	public Page getActivosPublicacion(DtoActivosPublicacion dtoActivosPublicacion) {
		// Búsqueda carterizada
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", adapter.getUsuarioLogado().getId()));
		if (!Checks.esNulo(usuarioCartera)) {
			if (!Checks.esNulo(usuarioCartera.getSubCartera())) {
				dtoActivosPublicacion.setCartera(usuarioCartera.getCartera().getCodigo());
				dtoActivosPublicacion.setSubCartera(usuarioCartera.getSubCartera().getCodigo());
			} else {
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
	public Page getPublicacionGrid(DtoPublicacionGridFilter dto) {	
		Long usuarioId = adapter.getUsuarioLogado().getId();

		return activoDao.getBusquedaPublicacionGrid(dto, usuarioId);
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
	@Transactional
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
	public List<ActivoCalificacionNegativa> getActivoCalificacionNegativaByIdActivo(Long idActivo) {
		// Obtiene el registro de ActivoCalificacionNegativa para el activo dado
		return activoDao.getListActivoCalificacionNegativaByIdActivo(idActivo);
	}

	@Override
	public List<DtoActivoDatosRegistrales> getActivoCalificacionNegativa(Long idActivo) {
		List<ActivoCalificacionNegativa> activoCNList = activoDao.getListActivoCalificacionNegativaByIdActivo(idActivo);
		List<DtoActivoDatosRegistrales> activoCNListDto = new ArrayList<DtoActivoDatosRegistrales>();

		try {

			for (ActivoCalificacionNegativa activo : activoCNList) {
				DtoActivoDatosRegistrales dto = new DtoActivoDatosRegistrales();

				beanUtilNotNull.copyProperty(dto, "idActivo", idActivo);
				beanUtilNotNull.copyProperty(dto, "idMotivo", String.valueOf(activo.getId()));
				if (!Checks.esNulo(activo.getMotivoCalificacionNegativa())) {
					beanUtilNotNull.copyProperty(dto, "motivoCalificacionNegativa",
							activo.getMotivoCalificacionNegativa().getDescripcion());
					beanUtilNotNull.copyProperty(dto, "codigoMotivoCalificacionNegativa",
							activo.getMotivoCalificacionNegativa().getCodigo());
				}
				if (!Checks.esNulo(activo.getEstadoMotivoCalificacionNegativa())) {
					beanUtilNotNull.copyProperty(dto, "estadoMotivoCalificacionNegativa",
							activo.getEstadoMotivoCalificacionNegativa().getDescripcion());
					beanUtilNotNull.copyProperty(dto, "codigoEstadoMotivoCalificacionNegativa",
							activo.getEstadoMotivoCalificacionNegativa().getCodigo());
				}
				if (!Checks.esNulo(activo.getResponsableSubsanar())) {
					beanUtilNotNull.copyProperty(dto, "responsableSubsanar",
							activo.getResponsableSubsanar().getDescripcion());
					beanUtilNotNull.copyProperty(dto, "codigoResponsableSubsanar",
							activo.getResponsableSubsanar().getCodigo());
				}
				beanUtilNotNull.copyProperty(dto, "fechaSubsanacion", activo.getFechaSubsanacion());
				beanUtilNotNull.copyProperty(dto, "descripcionCalificacionNegativa", activo.getDescripcion());

				if (!Checks.esNulo(activo.getHistoricoTramitacionTitulo())) {
					dto.setFechaCalificacionNegativa(activo.getHistoricoTramitacionTitulo().getFechaCalificacion());
					dto.setFechaPresentacionRegistroCN(
							activo.getHistoricoTramitacionTitulo().getFechaPresentacionRegistro());
				}

				activoCNListDto.add(dto);
			}

		} catch (Exception ex) {
			logger.error("Error en activoManager", ex);
		}

		return activoCNListDto;
	}

	@Override
	public List<DtoCalificacionNegativaAdicional> getActivoCalificacionNegativaAdicional(Long idActivo){		
		List<ActivoCalificacionNegativaAdicional> activoCNList = activoDao.getListActivoCalificacionNegativaAdicionalByIdActivo(idActivo);
		List<DtoCalificacionNegativaAdicional> activoCNListDto = new ArrayList<DtoCalificacionNegativaAdicional>();
			
		try {
			
			for (ActivoCalificacionNegativaAdicional activo : activoCNList) {
				DtoCalificacionNegativaAdicional dto = new DtoCalificacionNegativaAdicional();

				beanUtilNotNull.copyProperty(dto, "idActivo", idActivo);
				beanUtilNotNull.copyProperty(dto, "idMotivo", String.valueOf(activo.getId()));
				if(activo.getMotivoCalifNegativa() != null) {
					beanUtilNotNull.copyProperty(dto, "motivoCalificacionNegativa", activo.getMotivoCalifNegativa().getDescripcion());
					beanUtilNotNull.copyProperty(dto, "codigoMotivoCalificacionNegativa", activo.getMotivoCalifNegativa().getCodigo());
				}
				if(activo.getEstadoCalificacionNegativa() !=null) {
					beanUtilNotNull.copyProperty(dto, "estadoMotivoCalificacionNegativa", activo.getEstadoCalificacionNegativa().getDescripcion());
					beanUtilNotNull.copyProperty(dto, "codigoEstadoMotivoCalificacionNegativa", activo.getEstadoCalificacionNegativa().getCodigo());
				}
				if(activo.getResponsableSubsanar() != null){
					beanUtilNotNull.copyProperty(dto, "responsableSubsanar", activo.getResponsableSubsanar().getDescripcion());
					beanUtilNotNull.copyProperty(dto, "codigoResponsableSubsanar", activo.getResponsableSubsanar().getCodigo());
				}
				beanUtilNotNull.copyProperty(dto, "fechaSubsanacion", activo.getFechaSubsanacion());
				beanUtilNotNull.copyProperty(dto, "descripcionCalificacionNegativa", activo.getDescripcion());	
				
				if(activo.getHistoricoTitulo() != null) {
					dto.setFechaCalificacionNegativa(activo.getHistoricoTitulo().getFechaCalificacion());
					dto.setFechaPresentacionRegistroCN(activo.getHistoricoTitulo().getFechaPresentacionRegistro());
				}
		
				
				activoCNListDto.add(dto);
			}
			
		} catch (Exception ex) {
			logger.error("Error en activoManager", ex);
		}


		return activoCNListDto;
	}
	
	@Override
	@Transactional
	public boolean createCalificacionNegativaAdicional(DtoCalificacionNegativaAdicional dto) throws Exception{
		try {
			if (dto != null) {				
				Activo activo = null;
				ActivoTituloAdicional tituloAdicional = null;
				ActivoCalificacionNegativaAdicional activoCalificacionNegativaAd = new ActivoCalificacionNegativaAdicional();
				if (dto.getIdActivo() != null) {
					activo = genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdActivo()));
					tituloAdicional= genericDao.get(ActivoTituloAdicional.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", dto.getIdActivo()));
					if(activo == null || tituloAdicional == null) {
						return false;
					}
					
					if((tituloAdicional == null|| tituloAdicional.getEstadoTitulo() == null)
							|| (tituloAdicional != null && tituloAdicional.getEstadoTitulo() !=null && DDEstadoTitulo.ESTADO_INSCRITO.equals(tituloAdicional.getEstadoTitulo().getCodigo()))) {
						return false;
					}
					activoCalificacionNegativaAd.setActivo(activo);
				} else {
					return false;
				}

				List<ActivoCalificacionNegativaAdicional> activoCalificacionNegativaAdList = genericDao.getList(ActivoCalificacionNegativaAdicional.class, genericDao.createFilter(FilterType.EQUALS, "activo.id",activo.getId()));
				if(!activoCalificacionNegativaAdList.isEmpty()){
					for (ActivoCalificacionNegativaAdicional actCalAd : activoCalificacionNegativaAdList) { 
						if(dto.getMotivoCalificacionNegativa().equalsIgnoreCase(actCalAd.getMotivoCalifNegativa().getCodigo())){
							activoCalificacionNegativaAd = actCalAd;
						}
					}
				}
				activoCalificacionNegativaAd.setActivo(activo);
				
				
				if (dto.getMotivoCalificacionNegativa() != null) {
					activoCalificacionNegativaAd.setMotivoCalifNegativa(genericDao.get(DDMotivoCalificacionNegativa.class,genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMotivoCalificacionNegativa())));
				}
				
				if (dto.getDescripcionCalificacionNegativa()!= null) {
					activoCalificacionNegativaAd.setDescripcion(dto.getDescripcionCalificacionNegativa());
				}
				
				if (dto.getEstadoMotivoCalificacionNegativa() != null) {
					activoCalificacionNegativaAd.setEstadoCalificacionNegativa(genericDao.get(DDEstadoMotivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoMotivoCalificacionNegativa())));
				}
				
				if (dto.getResponsableSubsanar() != null) {
					activoCalificacionNegativaAd.setResponsableSubsanar(genericDao.get(DDResponsableSubsanar.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getResponsableSubsanar())));
				}
				
				if (dto.getDescripcionCalificacionNegativa() != null) {
					activoCalificacionNegativaAd.setDescripcion(dto.getDescripcionCalificacionNegativa());
				}
				
				DDCalificacionNegativa calificacionNegativa = genericDao.get(DDCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo","02"));
				activoCalificacionNegativaAd.setCalificacionNegativa(calificacionNegativa);
				
				if(activoCalificacionNegativaAd.getEstadoCalificacionNegativa()!= null  
					&& DDEstadoMotivoCalificacionNegativa.DD_SUBSANADO_CODIGO.equals(activoCalificacionNegativaAd.getEstadoCalificacionNegativa().getCodigo())) {
					if (dto.getFechaSubsanacion() != null) {
						beanUtilNotNull.copyProperty(activoCalificacionNegativaAd, "fechaSubsanacion", dto.getFechaSubsanacion());
					}
				}
				

				Filter filter = genericDao.createFilter(FilterType.EQUALS, "tituloAdicional.id", tituloAdicional.getId());
			
				Order order = new Order(OrderType.DESC, "id");
				List<ActivoHistoricoTituloAdicional> historicoTramitacionTituloList = genericDao.getListOrdered(ActivoHistoricoTituloAdicional.class, order, filter);
			
				if(!historicoTramitacionTituloList.isEmpty()) {
					activoCalificacionNegativaAd.setHistoricoTitulo(historicoTramitacionTituloList.get(0));
				}
				genericDao.save(ActivoCalificacionNegativaAdicional.class, activoCalificacionNegativaAd);
			
				
				return true;
			}
			
			
		} catch (Exception ex) {
			logger.error("Error en updateCalificacionNegativaAdicional", ex);
			throw new JsonViewerException(ex.getMessage());
		}
		
		return false;
		
	}
	
	@Override
	@Transactional
	public boolean updateCalificacionNegativaAdicional(DtoCalificacionNegativaAdicional dto) {
		try {
			
			if (dto != null) {
				ActivoCalificacionNegativaAdicional activoCalificacionNegativaAd = genericDao.get(ActivoCalificacionNegativaAdicional.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdMotivo())));
				
				
				List<ActivoCalificacionNegativaAdicional> activoCalificacionNegativaAdList = genericDao.getList(ActivoCalificacionNegativaAdicional.class, genericDao.createFilter(FilterType.EQUALS, "activo.id",activoCalificacionNegativaAd.getActivo().getId()));
				if(!activoCalificacionNegativaAdList.isEmpty()){
					if(dto.getMotivoCalificacionNegativa() != null){
						for (ActivoCalificacionNegativaAdicional actCalAd : activoCalificacionNegativaAdList) {
							if(dto.getMotivoCalificacionNegativa().equalsIgnoreCase(actCalAd.getMotivoCalifNegativa().getCodigo())){
								throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_MOTIVO_CALIFICACION));
							}
						}
					}
				}
				
				String codigoMotivoCalificacionNegativaAd = dto.getMotivoCalificacionNegativa();
				if (codigoMotivoCalificacionNegativaAd != null) {
					beanUtilNotNull.copyProperty(activoCalificacionNegativaAd, "motivoCalificacionNegativa", genericDao.get(DDMotivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoMotivoCalificacionNegativaAd)));
				}
				
				String codigoEstadoMotivoCalificacionNegativaAd = dto.getEstadoMotivoCalificacionNegativa();		
				if (codigoEstadoMotivoCalificacionNegativaAd != null) {
					activoCalificacionNegativaAd.setEstadoCalificacionNegativa(genericDao.get(DDEstadoMotivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoEstadoMotivoCalificacionNegativaAd)));
				}
				
				String codigoResponsableSubsanar = dto.getResponsableSubsanar();
				if (codigoResponsableSubsanar != null) {
					beanUtilNotNull.copyProperty(activoCalificacionNegativaAd, "responsableSubsanar",
							genericDao.get(DDResponsableSubsanar.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoResponsableSubsanar)));
				}
				
				beanUtilNotNull.copyProperty(activoCalificacionNegativaAd, "fechaSubsanacion", dto.getFechaSubsanacion());
				
				String descripcionCalificacionNegativa = dto.getDescripcionCalificacionNegativa();
				if(descripcionCalificacionNegativa != null) {
					beanUtilNotNull.copyProperty(activoCalificacionNegativaAd, "descripcion", descripcionCalificacionNegativa);
				}
				
				genericDao.update(ActivoCalificacionNegativaAdicional.class, activoCalificacionNegativaAd);
				return true;
			}

		} catch (Exception ex) {
			logger.error("Error en updateCalificacionNegativaAdicional", ex);
			throw new JsonViewerException(ex.getMessage());
		}
		
		return false;
	}

	@Override
	@Transactional
	public boolean destroyCalificacionNegativaAdicional(DtoCalificacionNegativaAdicional dto) {
		if (dto.getIdMotivo()!= null) {
			genericDao.deleteById(ActivoCalificacionNegativaAdicional.class, Long.valueOf(dto.getIdMotivo()));
			return true;
		}
		return false;

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
				if (!Checks.esNulo(activo.getMotivoCalificacionNegativa())) {
					beanUtilNotNull.copyProperty(dto, "motivoCalificacionNegativa",
							activo.getMotivoCalificacionNegativa().getCodigo());
				}
				if (!Checks.esNulo(activo.getEstadoMotivoCalificacionNegativa())) {
					beanUtilNotNull.copyProperty(dto, "estadoMotivoCalificacionNegativa",
							activo.getEstadoMotivoCalificacionNegativa().getCodigo());
				}
				if (!Checks.esNulo(activo.getResponsableSubsanar())) {
					beanUtilNotNull.copyProperty(dto, "responsableSubsanar",
							activo.getResponsableSubsanar().getCodigo());
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

					if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getFechaVenta())
							&& DDTipoOferta.CODIGO_VENTA
									.equals(activoOferta.getPrimaryKey().getOferta().getTipoOferta().getCodigo())) {
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
					if (!Checks.esNulo(expediente.getFechaInicioAlquiler())
							&& Checks.esNulo(expediente.getFechaFinAlquiler()) && DDTipoOferta.CODIGO_ALQUILER
									.equals(activoOferta.getPrimaryKey().getOferta().getTipoOferta().getCodigo()))
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
	public List<GastosExpediente> crearGastosExpediente(ExpedienteComercial nuevoExpediente)
			throws IllegalAccessException, InvocationTargetException {

		List<GastosExpediente> gastosExpediente = expedienteComercialApi.creaGastoExpediente(nuevoExpediente,
				nuevoExpediente.getOferta(),
				nuevoExpediente.getOferta().getActivosOferta().get(0).getPrimaryKey().getActivo());

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
					&& (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA
							.equals(agrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())
							|| DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER
									.equals(agrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo()))
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

		if (!Checks.esNulo(activoAfecto)) {
			afecto = true;
		}

		return afecto;
	}

	@Override
	public boolean isActivoBloqueadoGencat(Activo activo) {
		boolean bloqueado = false;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId());
		VActivosAfectosGencatBloqueados activoBloqueado = genericDao.get(VActivosAfectosGencatBloqueados.class, filtro);

		if (!Checks.esNulo(activoBloqueado)) {
			bloqueado = true;
		}

		return bloqueado;
	}

	@Override
	public boolean isPisoPiloto(Activo activo) {
		boolean pisoPiloto = false;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activoId", activo.getId());
		List<VActivosAgrupacionLil> agrupacionesActivo = genericDao.getList(VActivosAgrupacionLil.class, filtro);

		for (VActivosAgrupacionLil activoPisoPiloto : agrupacionesActivo) {
			if (!Checks.esNulo(activoPisoPiloto) && !Checks.esNulo(activoPisoPiloto.getEsPisoPiloto())
					&& activoPisoPiloto.getEsPisoPiloto()) {
				pisoPiloto = true;
				break;
			}
		}

		return pisoPiloto;
	}

	@Override
	public boolean necesitaDocumentoInformeOcupacion(Activo activo) {
		ActivoSituacionPosesoria activoSitPos = activo.getSituacionPosesoria();
		boolean tieneAdjunto = false;
		if (!Checks.esNulo(activoSitPos) && (!Checks.esNulo(activoSitPos.getOcupado())
				&& !Checks.esNulo(activoSitPos.getConTitulo()) && (1 == activoSitPos.getOcupado()
						&& DDTipoTituloActivoTPA.tipoTituloNo.equals(activoSitPos.getConTitulo().getCodigo())))) {

			List<DtoAdjunto> listAdjuntos;
			try {
				listAdjuntos = activoAdapter.getAdjuntosActivo(activo.getId());
				if (!Checks.estaVacio(listAdjuntos)) {
					// Buscamos el adjunto de tipo ocupacionDesocupacion mas reciente
					DtoAdjunto adjuntoAux = null;
					for (DtoAdjunto adjunto : listAdjuntos) {

						boolean esOcupacionDesocupacion = DDTipoDocumentoActivo.MATRICULA_INFORME_OCUPACION_DESOCUPACION
								.equals(adjunto.getMatricula());
						Date adjuntoFecha = adjunto.getFechaDocumento();

						if ((adjuntoAux == null && esOcupacionDesocupacion)
								|| (adjuntoAux != null && adjuntoAux.getFechaDocumento() != null && adjuntoFecha != null
										&& adjuntoFecha.after(adjuntoAux.getFechaDocumento()))) {
							adjuntoAux = adjunto;
						}
					}

					long diffInMillies = 0;
					int diff = 0;

					// Si no existe ningun adjunto de tipo ocupacionDesocupacion o si lo hay y tiene
					// una fecha superior a los 30 dias se ha de mostrar el disclaimer
					if (adjuntoAux == null || adjuntoAux.getFechaDocumento() == null) {
						tieneAdjunto = true;
					} else {
						diffInMillies = Math.abs(System.currentTimeMillis() - adjuntoAux.getFechaDocumento().getTime());
						diff = (int) TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
						tieneAdjunto = diff >= 30;
					}

				} else {
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
					|| (activoBancario != null && activoBancario.getClaseActivo() != null
							&& DDClaseActivoBancario.CODIGO_FINANCIERO
									.equals(activoBancario.getClaseActivo().getCodigo()));
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
		// si es activo matriz, hay que devolver los datos de todas sus UAS
		if (activoDao.isActivoMatriz(idActivo)) {
			ActivoAgrupacion agr = activoDao.getAgrupacionPAByIdActivo(idActivo);
			if (!Checks.esNulo(agr)) {
				List<Activo> listaUAs = activoAgrupacionActivoDao.getListUAsByIdAgrupacion(agr.getId());
				List<String> listaIds = new ArrayList<String>();
				listaIds.add(idActivo.toString());
				for (Activo activo : listaUAs) {
					listaIds.add(activo.getId().toString());
				}
				listadoProveedores = activoDao.getListProveedor(listaIds);
			} else {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idFalso.idActivo", idActivo.toString());
				listadoProveedores = genericDao.getList(VBusquedaProveedoresActivo.class, filtro);
			}
		} else {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idFalso.idActivo", idActivo.toString());
			listadoProveedores = genericDao.getList(VBusquedaProveedoresActivo.class, filtro);
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
	public List<DtoActivoTributos> getActivoTributosByActivo(Long idActivo, WebDto dto)
			throws GestorDocumentalException {
		List<DtoActivoTributos> tributos = new ArrayList<DtoActivoTributos>();
		List<ActivoTributos> listTributos = new ArrayList<ActivoTributos>();

		if (!Checks.esNulo(idActivo)) {
			Filter filterTributo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
			Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			listTributos = genericDao.getList(ActivoTributos.class, filterTributo, filtroAuditoria);
		}

		if (!Checks.estaVacio(listTributos)) {
			for (ActivoTributos tributo : listTributos) {
				DtoActivoTributos dtoTributo = new DtoActivoTributos();
				dtoTributo.setIdTributo(tributo.getId());

				if(tributo.getFechaPresentacionRecurso() != null) {
					dtoTributo.setFechaPresentacion(tributo.getFechaPresentacionRecurso().toString());
				}
				if(tributo.getFechaRecepcionPropietario() != null) {
					dtoTributo.setFechaRecPropietario(tributo.getFechaRecepcionPropietario().toString());
				}
				if(tributo.getFechaRecepcionGestoria() != null) {
					dtoTributo.setFechaRecGestoria(tributo.getFechaRecepcionGestoria().toString());
				}
				if(!Checks.esNulo(tributo.getTipoSolicitudTributo())){
					dtoTributo.setTipoSolicitud(tributo.getTipoSolicitudTributo().getCodigo());
				}
				dtoTributo.setObservaciones(tributo.getObservaciones());
				
				if(tributo.getFechaRecepcionRecursoPropietario() != null) {
					dtoTributo.setFechaRecRecursoPropietario(tributo.getFechaRecepcionRecursoPropietario().toString());
				}
				if(tributo.getFechaRecepcionRecursoGestoria() != null) {
					dtoTributo.setFechaRecRecursoGestoria(tributo.getFechaRecepcionRecursoGestoria().toString());
				}
				if(tributo.getFechaRespuestaRecurso() != null) {
					dtoTributo.setFechaRespRecurso(tributo.getFechaRespuestaRecurso().toString());
				}
				if(!Checks.esNulo(tributo.getResultadoSolicitud())){
					dtoTributo.setResultadoSolicitud(tributo.getResultadoSolicitud().getCodigo());
				}
				if (!Checks.esNulo(tributo.getGastoProveedor())) {
					dtoTributo.setNumGastoHaya(tributo.getGastoProveedor().getNumGastoHaya());
				}
				if (!Checks.esNulo(tributo.getNumTributo())) {
					dtoTributo.setNumTributo(tributo.getNumTributo());
				}
				
				if(!Checks.esNulo(tributo.getTipoTributo())) {
					dtoTributo.setTipoTributo(tributo.getTipoTributo().getCodigo());
				}
				
				if(tributo.getFechaRecepcionTributo() != null) {
					dtoTributo.setFechaRecepcionTributo(tributo.getFechaRecepcionTributo().toString());
				}
				if(tributo.getFechaPagoTributo() != null) {
					dtoTributo.setFechaPagoTributo(tributo.getFechaPagoTributo().toString());
				}
				dtoTributo.setImportePagado(tributo.getImportePagado());
				
				if(tributo.getExpediente() != null) {
					dtoTributo.setNumExpediente(tributo.getExpediente());
				}
				if(tributo.getFechaComunicacionDevolucionIngreso() != null) {
					dtoTributo.setFechaComunicacionDevolucionIngreso(tributo.getFechaComunicacionDevolucionIngreso().toString());
				}
				dtoTributo.setImporteRecuperadoRecurso(tributo.getImporteRecuperadoRecurso());
				if(tributo.getTributoExento() != null) {
					if(tributo.getTributoExento()) {
						dtoTributo.setEstaExento(DDSinSiNo.CODIGO_SI);
					}else if(!tributo.getTributoExento()){
						dtoTributo.setEstaExento(DDSinSiNo.CODIGO_NO);
					}
				}
				if(tributo.getMotivoExento() != null) {
					dtoTributo.setMotivoExento(tributo.getMotivoExento().getCodigo());
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
					if (!Checks.esNulo(expediente) && expediente.getEstado() != null) { // Si el expediente está
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
						Reserva reserva = genericDao.get(Reserva.class,
								genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId()));
						if (!Checks.esNulo(reserva) && !Checks.esNulo(reserva.getFechaFirma())) {
							List<ComunicacionGencat> comunicacionesVivas = gencatApi.comunicacionesVivas(expediente);
							boolean provieneOfertaGencat = gencatApi.esOfertaGencat(expediente);
							if (!Checks.estaVacio(comunicacionesVivas) && !provieneOfertaGencat
									&& !DDEstadosExpedienteComercial.EN_TRAMITACION
											.equals(expediente.getEstado().getCodigo())
									&& !DDEstadosExpedienteComercial.PTE_SANCION
											.equals(expediente.getEstado().getCodigo())
									&& ((!Checks.esNulo(expediente.getReserva())
											&& !DDEstadosExpedienteComercial.APROBADO
													.equals(expediente.getEstado().getCodigo()))
											|| (Checks.esNulo(expediente.getReserva())
													&& DDEstadosExpedienteComercial.APROBADO
															.equals(expediente.getEstado().getCodigo()))
											|| DDEstadosExpedienteComercial.ANULADO
													.equals(expediente.getEstado().getCodigo())
											|| DDEstadosExpedienteComercial.ANULADO_PDTE_DEVOLUCION
													.equals(expediente.getEstado().getCodigo())
											|| DDEstadosExpedienteComercial.EN_DEVOLUCION
													.equals(expediente.getEstado().getCodigo()))) {
								if (gencatApi.comprobarExpedienteAnuladoGencat(comunicacionesVivas)) {
									oferta = ofertaAux;
								}
							}

						}

					}
				} else if (DDEstadoOferta.CODIGO_ACEPTADA.equals(ofertaAux.getEstadoOferta().getCodigo())) {
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
	public List<DtoActivoIntegrado> getProveedoresByActivoIntegrado(DtoActivoIntegrado dtoActivoIntegrado)
			throws IllegalAccessException, InvocationTargetException {
		boolean esUA = activoDao.isUnidadAlquilable(Long.parseLong(dtoActivoIntegrado.getIdActivo()));
		ActivoAgrupacion agrupacion = activoDao
				.getAgrupacionPAByIdActivo(Long.parseLong(dtoActivoIntegrado.getIdActivo()));
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
					dto.setPagosRetenidos(1);
				} else {
					dto.setRetenerPagos(false);
					dto.setPagosRetenidos(0);
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
	public DtoPage getListLlavesByActivo(DtoLlaves dto) throws ParseException {
		Page page = activoDao.getLlavesByActivo(dto);

		List<DtoLlaves> llaves = new ArrayList<DtoLlaves>();
		for (ActivoLlave llave : (List<ActivoLlave>) page.getResults()) {
			DtoLlaves dtoLlave = this.llavesToDto(llave);
			if (!Checks.esNulo(llave.getTipoTenedor())) {
				dtoLlave.setTipoTenedor(llave.getTipoTenedor().getDescripcion());
			}
			if (!Checks.esNulo(llave.getCodNoPoseedor())) {
				dtoLlave.setNombreTenedor(llave.getCodNoPoseedor());
			} else {
				if (!Checks.esNulo(llave.getPoseedor())) {
					dtoLlave.setNombreTenedor(llave.getPoseedor().getNombre());
					dtoLlave.setTelefonoTenedor(llave.getPoseedor().getTelefono1());
				}
			}

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
			if (movimiento.getTipoTenedorPoseedor() != null) {
				BeanUtils.copyProperty(dtoMov, "descripcionTipoTenedorPoseedor",
						movimiento.getTipoTenedorPoseedor().getDescripcion());
			}
			if (movimiento.getTipoTenedorPedidor() != null) {
				BeanUtils.copyProperty(dtoMov, "descripcionTipoTenedorPedidor",
						movimiento.getTipoTenedorPedidor().getDescripcion());
			}
			if (movimiento.getCodNoPedidor() != null) {
				BeanUtils.copyProperty(dtoMov, "nombrePedidor", movimiento.getCodNoPedidor());
			} else if (movimiento.getPedidor() != null) {
				BeanUtils.copyProperty(dtoMov, "nombrePedidor", movimiento.getPedidor().getNombre());
			}
			if (movimiento.getCodNoPoseedor() != null) {
				BeanUtils.copyProperty(dtoMov, "nombrePoseedor", movimiento.getCodNoPoseedor());
			} else if (movimiento.getPoseedor() != null) {
				BeanUtils.copyProperty(dtoMov, "nombrePoseedor", movimiento.getPoseedor().getNombre());
			}
			if (!Checks.esNulo(movimiento.getTipoTenedor())) {
				BeanUtils.copyProperty(dtoMov, "descripcionTipoTenedor", movimiento.getTipoTenedor().getDescripcion());
			}
			if (movimiento.getTipoEstado() != null) {
				BeanUtils.copyProperty(dtoMov, "estadoDescripcion", movimiento.getTipoEstado().getDescripcion());
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
		ActivoTasacion tasacionMasReciente =  new ActivoTasacion();
		List<ActivoTasacion> tasacionesActivo = activo.getTasacion();
		if(!Checks.estaVacio(activo.getTasacion())) {
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
				beanUtilNotNull.copyProperty(dto, "situacionComercialCodigo", activo.getSituacionComercial().getCodigo());
				beanUtilNotNull.copyProperty(dto, "situacionComercialDescripcion", activo.getSituacionComercial().getDescripcion());
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

			if (!Checks.esNulo(activo.getVentaSobrePlano())) {
				if (DDSinSiNo.CODIGO_SI.equals(activo.getVentaSobrePlano().getCodigo())) {
					beanUtilNotNull.copyProperty(dto, "ventaSobrePlano", true);
				} else {
					beanUtilNotNull.copyProperty(dto, "ventaSobrePlano", false);
				}

			}

			if (!Checks.esNulo(activo.getActivoAutorizacionTramitacionOfertas())) {
				beanUtilNotNull.copyProperty(dto, "motivoAutorizacionTramitacionCodigo", activo
						.getActivoAutorizacionTramitacionOfertas().getMotivoAutorizacionTramitacion().getCodigo());
				beanUtilNotNull.copyProperty(dto, "motivoAutorizacionTramitacionDescripcion", activo
						.getActivoAutorizacionTramitacionOfertas().getMotivoAutorizacionTramitacion().getDescripcion());
				beanUtilNotNull.copyProperty(dto, "observacionesAutoTram",
						activo.getActivoAutorizacionTramitacionOfertas().getObservacionesAutoTram());
			}
			if (!Checks.esNulo(activo.getTerritorio())) {
				beanUtilNotNull.copyProperty(dto, "direccionComercial", activo.getTerritorio().getCodigo());
				beanUtilNotNull.copyProperty(dto, "direccionComercialDescripcion", activo.getTerritorio().getDescripcion());

			}
			
			if (activo.getNumActivo() != null) {
				ActivoSareb activoSareb = genericDao.get(ActivoSareb.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", activo.getNumActivo()));
				if(activoSareb != null) {
					dto.setImporteComunidadMensualSareb(activoSareb.getImporteComunidadMensualSareb());
					if (activoSareb.getSiniestroSareb() != null) {
						dto.setSiniestroSareb(activoSareb.getSiniestroSareb().getCodigo());
					}
					if(activoSareb.getTipoCorrectivoSareb() != null) {
						dto.setTipoCorrectivoSareb(activoSareb.getTipoCorrectivoSareb().getCodigo());
					}					
					dto.setFechaFinCorrectivoSareb(activoSareb.getFechaFinCorrectivoSareb());
					if(activoSareb.getTipoCuotaComunidad() != null) {
						dto.setTipoCuotaComunidad(activoSareb.getTipoCuotaComunidad().getCodigo());
					}
					if (activoSareb.getGgaaSareb() != null) {
						dto.setGgaaSareb(activoSareb.getGgaaSareb().getCodigo());
					}
					if (activoSareb.getSegmentoSareb() != null) {
						dto.setSegmentacionSareb(activoSareb.getSegmentoSareb().getCodigo());
					}
				}
			}
			
			VHistCampanyaCaixa histCampanyaCaixa = genericDao.get(VHistCampanyaCaixa.class, 
					genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId()));
			
			if (histCampanyaCaixa != null) {
				if (histCampanyaCaixa.getIdCampanyaVenta() != null) {
					dto.setCampanyaVenta(histCampanyaCaixa.getIdCampanyaVenta());
				}
				if (histCampanyaCaixa.getIdCampanyaAlquiler() != null) {
					dto.setCampanyaAlquiler(histCampanyaCaixa.getIdCampanyaAlquiler());
				}				
			}

		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
		}

		if (!Checks.esNulo(activo) && activoDao.isActivoMatriz(activo.getId())) {
			dto.setCamposPropagablesUas(TabActivoService.TAB_COMERCIAL);
		} else {
			// Buscamos los campos que pueden ser propagados para esta pestaña
			dto.setCamposPropagables(TabActivoService.TAB_COMERCIAL);
		}
		dto.setTramitable(this.isTramitable(activo));
		
		if(activo!=null) {
			if(activo.getTieneObraNuevaAEfectosComercializacion()!=null) {
				dto.setActivoObraNuevaComercializacion(activo.getTieneObraNuevaAEfectosComercializacion().getCodigo());
			}
			if(activo.getObraNuevaAEfectosComercializacionFecha()!=null) {
				dto.setActivoObraNuevaComercializacionFecha(activo.getObraNuevaAEfectosComercializacionFecha());
			}
		}
		

		if (activo.getNecesidadIfActivo() != null) {
			dto.setNecesidadIfActivo(activo.getNecesidadIfActivo());
		}

		if (activo != null) {
			ActivoCaixa actCaixa = genericDao.get(ActivoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
			
			if (actCaixa != null) {
				if (actCaixa.getNecesidadArras() != null) {
					dto.setNecesidadArras(actCaixa.getNecesidadArras());
				}
				if (actCaixa.getNecesidadArras() != null 
						&& Boolean.TRUE.equals(actCaixa.getNecesidadArras()) 
						&& actCaixa.getMotivosNecesidadArras() != null) {
					dto.setMotivosNecesidadArras(actCaixa.getMotivosNecesidadArras());
				}
				
				if (actCaixa.getEstadoComercialVenta() != null) {
					dto.setEstadoComercialVentaCodigo(actCaixa.getEstadoComercialVenta().getCodigo());
					dto.setEstadoComercialVentaDescripcion(actCaixa.getEstadoComercialVenta().getDescripcion());
				}
				
				if (actCaixa.getEstadoComercialAlquiler() != null) {
					dto.setEstadoComercialAlquilerCodigo(actCaixa.getEstadoComercialAlquiler().getCodigo());
					dto.setEstadoComercialAlquilerDescripcion(actCaixa.getEstadoComercialAlquiler().getDescripcion());
				}
				
				if (actCaixa.getFechaEstadoComercialVenta() != null) {
					dto.setFechaEstadoComercialVenta(actCaixa.getFechaEstadoComercialVenta());
				}
				
				if (actCaixa.getFechaEstadoComercialAlquiler() != null) {
					dto.setFechaEstadoComercialAlquiler(actCaixa.getFechaEstadoComercialAlquiler());
				}
				
				if(actCaixa.getCanalDistribucionVenta() != null) {
					dto.setCanalPublicacionVentaCodigo(actCaixa.getCanalDistribucionVenta().getCodigo());
				}
				if(actCaixa.getCanalDistribucionAlquiler() != null) {
					dto.setCanalPublicacionAlquilerCodigo(actCaixa.getCanalDistribucionAlquiler().getCodigo());
				}
				if (actCaixa.getTributacionPropuestaClienteExentoIva() != null) {
					dto.setTributacionPropuestaClienteExentoIvaCod(actCaixa.getTributacionPropuestaClienteExentoIva().getCodigo());
					dto.setTributacionPropuestaClienteExentoIvaDesc(actCaixa.getTributacionPropuestaClienteExentoIva().getDescripcion());
				}
				if (actCaixa.getTributacionPropuestaVenta() != null) {
					dto.setTributacionPropuestaVentaCod(actCaixa.getTributacionPropuestaVenta().getCodigo());
					dto.setTributacionPropuestaVentaDesc(actCaixa.getTributacionPropuestaVenta().getDescripcion());
				}
				if (actCaixa.getCarteraConcentrada() != null) {
					dto.setCarteraConcentrada(actCaixa.getCarteraConcentrada());
				}
				if (actCaixa.getActivoAAMM() != null) {
					dto.setActivoAAMM(actCaixa.getActivoAAMM());
				}
				if (actCaixa.getActivoPromocionesEstrategicas() != null) {
					dto.setActivoPromocionesEstrategicas(actCaixa.getActivoPromocionesEstrategicas());
				}
				if (actCaixa.getFechaInicioConcurrencia() != null) {
					dto.setFechaInicioConcurrencia(actCaixa.getFechaInicioConcurrencia());
				}
				if (actCaixa.getFechaFinConcurrencia() != null) {
					dto.setFechaFinConcurrencia(actCaixa.getFechaFinConcurrencia());
				}
			}
		}

		if (activo.getTipoTransmision() != null) {
			dto.setTipoTransmisionCodigo(activo.getTipoTransmision().getCodigo());
			dto.setTipoTransmisionDescripcion(activo.getTipoTransmision().getDescripcion());
		}
		
		return dto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveComercialActivo(DtoComercialActivo dto) throws JsonViewerException {
		if (Checks.esNulo(dto.getId())) {
			return false;
		}

		Activo activo = activoDao.get(Long.parseLong(dto.getId()));
		boolean actualizarHonorarios = false;

		try {
			beanUtilNotNull.copyProperty(activo, "fechaVentaExterna", dto.getFechaVenta());
			beanUtilNotNull.copyProperty(activo, "importeVentaExterna", dto.getImporteVenta());
			if (!Checks.esNulo(dto.getObservaciones())) {
				beanUtilNotNull.copyProperty(activo, "observacionesVentaExterna",
						dto.getObservaciones().replaceAll("(\n|\r)", " "));
			} else {
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
			if (!Checks.esNulo(dto.getDireccionComercial())) {
				DDTerritorio territorio = (DDTerritorio) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTerritorio.class, dto.getDireccionComercial());
				activo.setTerritorio(territorio);
				if (activoDao.isActivoPrincipalAgrupacionRestringida(activo.getId()) != 0) {
					Thread guardadoAsincrono = new Thread(new GuardarActivosRestringidasAsync(activo.getId(),
							genericAdapter.getUsuarioLogado().getUsername()));
					guardadoAsincrono.start();
				}
			}
			
			if(dto.getFechaVenta() != null) {
				recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(activo, null, false,false);
			}
			if (activo.getNumActivo() != null) {
				ActivoSareb activoSareb = genericDao.get(ActivoSareb.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", activo.getNumActivo()));
				if(activoSareb != null) {
					if (dto.getImporteComunidadMensualSareb() != null) {
						activoSareb.setImporteComunidadMensualSareb(dto.getImporteComunidadMensualSareb());
					}
					if(dto.getSiniestroSareb() != null) {
						DDSinSiNo siniestro = (DDSinSiNo) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDSinSiNo.class, dto.getSiniestroSareb());
						activoSareb.setSiniestroSareb(siniestro);
					}
					if(dto.getTipoCorrectivoSareb() != null) {
						DDTipoCorrectivoSareb tipoCorrectivoSareb = (DDTipoCorrectivoSareb) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDTipoCorrectivoSareb.class, dto.getTipoCorrectivoSareb());
						activoSareb.setTipoCorrectivoSareb(tipoCorrectivoSareb);
					}
					if(dto.getFechaFinCorrectivoSareb() != null) {
						activoSareb.setFechaFinCorrectivoSareb(dto.getFechaFinCorrectivoSareb());
					}
					if(dto.getTipoCuotaComunidad() != null) {
						DDTipoCuotaComunidad tipoCuotaComunidad = (DDTipoCuotaComunidad) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDTipoCuotaComunidad.class, dto.getTipoCuotaComunidad());
						
						activoSareb.setTipoCuotaComunidad(tipoCuotaComunidad);
					}
					genericDao.update(ActivoSareb.class, activoSareb);
				}
			}

			if(dto.getActivoObraNuevaComercializacion()!=null ) {
				DDSinSiNo siono = (DDSinSiNo) utilDiccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, dto.getActivoObraNuevaComercializacion());
				if(siono!=null) {
					activo.setTieneObraNuevaAEfectosComercializacion(siono);
					actualizarHonorarios = true;					
				}
				activo.setObraNuevaAEfectosComercializacionFecha(new Date());

			}
			
			if(dto.getFechaVenta() != null) {
				recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(activo, null, false,false);
			}
			
			ActivoCaixa activoCaixa = genericDao.get(ActivoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
			if (activoCaixa != null) {
				if (dto.getTributacionPropuestaClienteExentoIvaCod() != null) {
					DDTributacionPropuestaClienteExentoIva tipoTributPropClExcIva = (DDTributacionPropuestaClienteExentoIva) utilDiccionarioApi.dameValorDiccionarioByCod(DDTributacionPropuestaClienteExentoIva.class, dto.getTributacionPropuestaClienteExentoIvaCod());
					activoCaixa.setTributacionPropuestaClienteExentoIva(tipoTributPropClExcIva);					
				}
				if (dto.getTributacionPropuestaVentaCod() != null) {
					DDTributacionPropuestaVenta tipoTributPropVenta = (DDTributacionPropuestaVenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTributacionPropuestaVenta.class, dto.getTributacionPropuestaVentaCod());
					activoCaixa.setTributacionPropuestaVenta(tipoTributPropVenta);
				}
				if(dto.getCanalPublicacionAlquilerCodigo() != null){
					DDTipoComercializar canalDistAlq = (DDTipoComercializar) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializar.class, dto.getCanalPublicacionAlquilerCodigo());
					activoCaixa.setCanalDistribucionAlquiler(canalDistAlq);
				}
				if(dto.getCanalPublicacionVentaCodigo() != null){
					DDTipoComercializar canalDistVent = (DDTipoComercializar) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializar.class, dto.getCanalPublicacionVentaCodigo());
					activoCaixa.setCanalDistribucionVenta(canalDistVent);
				}
				
				genericDao.update(ActivoCaixa.class, activoCaixa);
			}
		
			if (dto.getTipoTransmisionCodigo() != null) {
				DDTipoTransmision transmision = (DDTipoTransmision) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoTransmision.class, dto.getTipoTransmisionCodigo());
				activo.setTipoTransmision(transmision);
			}
			
		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);
			return false;

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
			return false;
		} catch (Exception e) {
			logger.error("Error el hilo activoManager", e);
			return false;

		}

		activo.setEstaEnPuja(dto.getPuja());
		activoDao.save(activo);

		if (actualizarHonorarios) {
			
			updateHonorarios(activo, activo.getOfertas());
		}
		
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

	@Transactional(readOnly = false)
	public Boolean saveActivoCarga(DtoActivoCargas cargaDto) {

		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

		ActivoCargas cargaSeleccionada = null;
		NMBBienCargas cargaBien = null;
		Activo activo = null;
		if (!Checks.esNulo(cargaDto.getIdActivoCarga())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", cargaDto.getIdActivoCarga());
			cargaSeleccionada = genericDao.get(ActivoCargas.class, filtro);
			activo = cargaSeleccionada.getActivo();
			cargaBien = cargaSeleccionada.getCargaBien();
		} else {
			cargaSeleccionada = new ActivoCargas();
			cargaBien = new NMBBienCargas();
			activo = get(cargaDto.getIdActivo());

			cargaSeleccionada.setActivo(activo);
			DDTipoCarga tipoCargaBien = (DDTipoCarga) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCarga.class,
					"0");
			cargaBien.setTipoCarga(tipoCargaBien);
			cargaBien.setBien(activo.getBien());
			cargaBien.setEconomica(false);
			cargaSeleccionada.setOrigenDato((DDOrigenDato) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDOrigenDato.class, DDOrigenDato.CODIGO_REM));
		}

		activo = cargaSeleccionada.getActivo();

		try {
			beanUtilNotNull.copyProperties(cargaSeleccionada, cargaDto);
			if (cargaBien != null)
				beanUtilNotNull.copyProperties(cargaBien, cargaDto);

			if (!Checks.esNulo(cargaDto.getEstadoCodigo())) {
				DDEstadoCarga estadoCarga = (DDEstadoCarga) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDEstadoCarga.class, cargaDto.getEstadoCodigo());
				cargaSeleccionada.setEstadoCarga(estadoCarga);
			}

			if (!Checks.esNulo(cargaDto.getCodigoImpideVenta())) {
				DDSiNo dd = genericDao.get(DDSiNo.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", cargaDto.getCodigoImpideVenta()));
				cargaSeleccionada.setImpideVenta(dd);
			}

			if (!Checks.esNulo(cargaDto.getEstadoEconomicaCodigo())) {
				DDSituacionCarga situacionCarga = (DDSituacionCarga) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSituacionCarga.class, cargaDto.getEstadoEconomicaCodigo());
				if (cargaBien != null)
					cargaBien.setSituacionCargaEconomica(situacionCarga);
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
			
			// HREOS-15591
			if(!Checks.esNulo(cargaDto.getFechaSolicitudCarta())) {
				cargaSeleccionada.setFechaSolicitudCarta(cargaDto.getFechaSolicitudCarta());
			}
			
			if(!Checks.esNulo(cargaDto.getFechaRecepcionCarta())) {
				cargaSeleccionada.setFechaRecepcionCarta(cargaDto.getFechaRecepcionCarta());
			}
			
			if(!Checks.esNulo(cargaDto.getFechaPresentacionRpCarta())) {
				cargaSeleccionada.setFechaPresentacionRpCarta(cargaDto.getFechaPresentacionRpCarta());
			}

		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
		}
		cargaSeleccionada.setCargaBien(cargaBien);
		if (cargaBien != null)
			genericDao.save(NMBBienCargas.class, cargaBien);
		activoCargasApi.saveOrUpdate(cargaSeleccionada);

		if (!Checks.esNulo(cargaSeleccionada) && !Checks.esNulo(cargaSeleccionada.getActivo())
				&& !Checks.esNulo(cargaSeleccionada.getActivo().getId())) {
			activoCargasDao.calcularEstadoCargaActivo(cargaSeleccionada.getActivo().getId(),
					genericAdapter.getUsuarioLogado().getUsername(), true);
			activoAdapter.actualizarEstadoPublicacionActivo(cargaSeleccionada.getActivo().getId());
		}

		transactionManager.commit(transaction);

		if(activo != null && activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA)){
			Thread llamadaAsincrona = new Thread(new ConvivenciaRecovery(activo.getId(), new ModelMap(), usuarioManager.getUsuarioLogado().getUsername()));
			llamadaAsincrona.start();
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

		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

		ActivoCargas carga = null;
		if (!Checks.esNulo(dto.getIdActivoCarga())) {
			carga = genericDao.get(ActivoCargas.class,
					genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdActivoCarga()));
			if (!Checks.esNulo(carga)) {
				genericDao.deleteById(ActivoCargas.class, carga.getId());
				if (!Checks.esNulo(carga.getActivo()) && !Checks.esNulo(carga.getActivo().getId())) {
					activoCargasDao.calcularEstadoCargaActivo(carga.getActivo().getId(),
							genericAdapter.getUsuarioLogado().getUsername(), true);
					activoAdapter.actualizarEstadoPublicacionActivo(carga.getActivo().getId());
				}
			} else {
				return false;
			}
		}

		transactionManager.commit(transaction);

		if(carga != null){
			if(carga.getActivo() != null && carga.getActivo().getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA)){
				Thread llamadaAsincrona = new Thread(new ConvivenciaRecovery(carga.getActivo().getId(), new ModelMap(), usuarioManager.getUsuarioLogado().getUsername()));
				llamadaAsincrona.start();
			}
		}

		return true;
	}

	@Override
	public void calcularRatingActivo(Long idActivo) {
		activoDao.actualizarRatingActivo(idActivo, usuarioApi.getUsuarioLogado().getUsername());
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
		else if (activo.getTipoUsoDestino() != null
				&& (DDTipoUsoDestino.TIPO_USO_PRIMERA_RESIDENCIA.equals(activo.getTipoUsoDestino().getCodigo())
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
		if (!DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())) {
			if (!Checks.esNulo(activo.getTipoTitulo())) {
				if (DDTipoTituloActivo.tipoTituloJudicial.equals(activo.getTipoTitulo().getCodigo())) {

					if (!Checks.esNulo(activo.getAdjJudicial())
							&& !Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien())) {
						if (!Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien().getLanzamientoNecesario())) {
							if (activo.getAdjJudicial().getAdjudicacionBien().getLanzamientoNecesario()) {
								activo.getSituacionPosesoria().setFechaTomaPosesion(
										activo.getAdjJudicial().getAdjudicacionBien().getFechaRealizacionLanzamiento());
							} else {
								if (!Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien().getFechaRealizacionPosesion())) {
									activo.getSituacionPosesoria().setFechaTomaPosesion(activo.getAdjJudicial().getAdjudicacionBien().getFechaRealizacionPosesion());
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
					if ((DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo()) && 
							(DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())
							||DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(activo.getSubcartera().getCodigo())
							||DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo())
							||DDSubcartera.CODIGO_JAGUAR.equals(activo.getSubcartera().getCodigo())))
							||DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo())) {
						if (activo.getAdjNoJudicial().getFechaPosesion() != null) {
							activo.getSituacionPosesoria().setFechaTomaPosesion(activo.getAdjNoJudicial().getFechaPosesion());
						} else {
							activo.getSituacionPosesoria().setFechaTomaPosesion(null);
						}
					} else {
						activo.getSituacionPosesoria().setFechaTomaPosesion(activo.getAdjNoJudicial().getFechaTitulo());
					}
					
				} else if (DDTipoTituloActivo.UNIDAD_ALQUILABLE.equals(activo.getTipoTitulo().getCodigo())) {
					ActivoAgrupacionActivo aga = activoDao.getActivoAgrupacionActivoPA(activo.getId());	
					
					if (!Checks.esNulo(aga)) {
						Long idAM = activoDao.getIdActivoMatriz(aga.getAgrupacion().getId());
						Activo activoMatriz = get(idAM);
						
						if (!Checks.esNulo(activoMatriz.getSituacionPosesoria().getFechaTomaPosesion())) {
							activo.getSituacionPosesoria().setFechaTomaPosesion(activoMatriz.getSituacionPosesoria().getFechaTomaPosesion());
						} else {
							activo.getSituacionPosesoria().setFechaTomaPosesion(null);
						}
					} else {
						activo.getSituacionPosesoria().setFechaTomaPosesion(null);
					}
					
				}
			}

			if ((Checks.esNulo(situacionActual) && !Checks.esNulo(activo.getSituacionPosesoria()))
					|| !situacionActual.equals(activo.getSituacionPosesoria())) {
				genericDao.save(ActivoSituacionPosesoria.class, activo.getSituacionPosesoria());
			}
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

		if (!Checks.estaVacio(listActHistPatrimonio)) {
			for (ActivoHistoricoPatrimonio activoHistPatrimonio : listActHistPatrimonio) {
				try {
					DtoActivoPatrimonio actPatrimonioDto = new DtoActivoPatrimonio();
					BeanUtils.copyProperties(actPatrimonioDto, activoHistPatrimonio);
					actPatrimonioDto.setIdPatrimonio(
							!Checks.esNulo(activoHistPatrimonio.getId()) ? activoHistPatrimonio.getId().toString()
									: null);
					actPatrimonioDto.setIdActivo(!Checks.esNulo(activoHistPatrimonio.getActivo())
							? activoHistPatrimonio.getActivo().getId().toString()
							: null);
					actPatrimonioDto.setCodigoAdecuacion(!Checks.esNulo(activoHistPatrimonio.getAdecuacionAlquiler())
							? activoHistPatrimonio.getAdecuacionAlquiler().getCodigo()
							: null);
					actPatrimonioDto
							.setDescripcionAdecuacion(!Checks.esNulo(activoHistPatrimonio.getAdecuacionAlquiler())
									? activoHistPatrimonio.getAdecuacionAlquiler().getDescripcion()
									: null);
					actPatrimonioDto
							.setDescripcionAdecuacionLarga(!Checks.esNulo(activoHistPatrimonio.getAdecuacionAlquiler())
									? activoHistPatrimonio.getAdecuacionAlquiler().getDescripcionLarga()
									: null);
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
			String fechaAFormat = formateador.format(fechaActual);

			if (!Checks.esNulo(dto.getCalculo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCalculo());
				impuesto.setCalculoImpuesto(genericDao.get(DDCalculoImpuesto.class, filtro));
			} else {
				if (!Checks.esNulo(impuesto.getFechaFin())) {
					Date fechaFinImpuesto = impuesto.getFechaFin();
					String fechaFormat = formateador.format(fechaFinImpuesto);

					if (fechaAFormat.equals(fechaFormat) || fechaActual.before(fechaFinImpuesto)) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDCalculoImpuesto.CODIGO_VENCIDO);
						impuesto.setCalculoImpuesto(genericDao.get(DDCalculoImpuesto.class, filtro));

					} else {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDCalculoImpuesto.CODIGO_EN_VOLUNTARIA);
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
	@Transactional(readOnly = false)
	public boolean updateCalificacionNegativa(DtoActivoDatosRegistrales dto) {

		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

		try {

			if (!Checks.esNulo(dto)) {
				ActivoCalificacionNegativa activoCalificacionNegativa = genericDao.get(ActivoCalificacionNegativa.class,
						genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdMotivo())));

				// comprobamos el motivo
				List<ActivoCalificacionNegativa> activoCalificacionNegativaList = genericDao
						.getList(ActivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS,
								"activo.id", activoCalificacionNegativa.getActivo().getId()));
				if (!Checks.estaVacio(activoCalificacionNegativaList)) {
					if (!Checks.esNulo(dto.getMotivoCalificacionNegativa())) {
						for (ActivoCalificacionNegativa actCal : activoCalificacionNegativaList) {
							if (dto.getMotivoCalificacionNegativa()
									.equalsIgnoreCase(actCal.getMotivoCalificacionNegativa().getCodigo())) {
								throw new JsonViewerException(
										messageServices.getMessage(AVISO_MENSAJE_MOTIVO_CALIFICACION));
							}
						}
					}
				}

				String codigoMotivoCalificacionNegativa = dto.getMotivoCalificacionNegativa();
				if (!Checks.esNulo(codigoMotivoCalificacionNegativa)) {
					beanUtilNotNull.copyProperty(activoCalificacionNegativa, "motivoCalificacionNegativa",
							genericDao.get(DDMotivoCalificacionNegativa.class, genericDao
									.createFilter(FilterType.EQUALS, "codigo", codigoMotivoCalificacionNegativa)));
				}

				String codigoEstadoMotivoCalificacionNegativa = dto.getEstadoMotivoCalificacionNegativa();
				if (!Checks.esNulo(codigoEstadoMotivoCalificacionNegativa)) {
					activoCalificacionNegativa.setEstadoMotivoCalificacionNegativa(
							genericDao.get(DDEstadoMotivoCalificacionNegativa.class, genericDao.createFilter(
									FilterType.EQUALS, "codigo", codigoEstadoMotivoCalificacionNegativa)));
				}

				String codigoResponsableSubsanar = dto.getResponsableSubsanar();
				if (!Checks.esNulo(codigoResponsableSubsanar)) {
					beanUtilNotNull.copyProperty(activoCalificacionNegativa, "responsableSubsanar",
							genericDao.get(DDResponsableSubsanar.class,
									genericDao.createFilter(FilterType.EQUALS, "codigo", codigoResponsableSubsanar)));
				}

				beanUtilNotNull.copyProperty(activoCalificacionNegativa, "fechaSubsanacion", dto.getFechaSubsanacion());

				String descripcionCalificacionNegativa = dto.getDescripcionCalificacionNegativa();
				if (!Checks.esNulo(descripcionCalificacionNegativa)) {
					beanUtilNotNull.copyProperty(activoCalificacionNegativa, "descripcion",
							descripcionCalificacionNegativa);
				}

				genericDao.update(ActivoCalificacionNegativa.class, activoCalificacionNegativa);

				transactionManager.commit(transaction);

				if(activoCalificacionNegativa.getActivo().getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA)){
					Thread llamadaAsincrona = new Thread(new ConvivenciaRecovery(activoCalificacionNegativa.getActivo().getId(), new ModelMap(), usuarioManager.getUsuarioLogado().getUsername()));
					llamadaAsincrona.start();
				}

				return true;
			}

		} catch (Exception ex) {
			logger.error("Error en updateCalificacionNegativa", ex);
			throw new JsonViewerException(ex.getMessage());
		}

		return false;

	}

	@Override
	@Transactional(readOnly = false)
	public boolean createCalificacionNegativa(DtoActivoDatosRegistrales dto) throws Exception {

		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

		try {

			if (!Checks.esNulo(dto)) {

				Activo activo = null;
				ActivoCalificacionNegativa activoCalificacionNegativa = new ActivoCalificacionNegativa();
				if (!Checks.esNulo(dto.getIdActivo())) {
					activo = genericDao.get(Activo.class,
							genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdActivo()));
					if (!Checks.esNulo(activo.getTitulo()) && !Checks.esNulo(activo.getTitulo().getEstado())
							&& DDEstadoTitulo.ESTADO_INSCRITO.equals(activo.getTitulo().getEstado().getCodigo())) {
						return false;

					}
					activoCalificacionNegativa.setActivo(activo);
				} else {
					return false;
				}

				List<ActivoCalificacionNegativa> activoCalificacionNegativaList = genericDao.getList(
						ActivoCalificacionNegativa.class,
						genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
				if (!Checks.estaVacio(activoCalificacionNegativaList)) {
					for (ActivoCalificacionNegativa actCal : activoCalificacionNegativaList) {
						if (dto.getMotivoCalificacionNegativa()
								.equalsIgnoreCase(actCal.getMotivoCalificacionNegativa().getCodigo())) {
							// HREOS-6156 Al propagar, si tiene el mismo motivo, actualiza los datos de la
							// calificación negativa.
							activoCalificacionNegativa = actCal;
						}
					}
				}
				activoCalificacionNegativa.setActivo(activo);

				if (!Checks.esNulo(dto.getMotivoCalificacionNegativa())) {
					activoCalificacionNegativa.setMotivoCalificacionNegativa(genericDao.get(
							DDMotivoCalificacionNegativa.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMotivoCalificacionNegativa())));
				}

				if (!Checks.esNulo(dto.getDescripcionCalificacionNegativa())) {
					activoCalificacionNegativa.setDescripcion(dto.getDescripcionCalificacionNegativa());
				}

				if (!Checks.esNulo(dto.getEstadoMotivoCalificacionNegativa())) {
					activoCalificacionNegativa.setEstadoMotivoCalificacionNegativa(
							genericDao.get(DDEstadoMotivoCalificacionNegativa.class, genericDao.createFilter(
									FilterType.EQUALS, "codigo", dto.getEstadoMotivoCalificacionNegativa())));
				}

				if (!Checks.esNulo(dto.getResponsableSubsanar())) {
					activoCalificacionNegativa.setResponsableSubsanar(genericDao.get(DDResponsableSubsanar.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getResponsableSubsanar())));
				}

				if (!Checks.esNulo(dto.getDescripcionCalificacionNegativa())) {
					activoCalificacionNegativa.setDescripcion(dto.getDescripcionCalificacionNegativa());
				}

				DDCalificacionNegativa calificacionNegativa = genericDao.get(DDCalificacionNegativa.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", "02"));
				activoCalificacionNegativa.setCalificacionNegativa(calificacionNegativa);

				if (!Checks.esNulo(activoCalificacionNegativa.getEstadoMotivoCalificacionNegativa())
						&& DDEstadoMotivoCalificacionNegativa.DD_SUBSANADO_CODIGO
								.equals(activoCalificacionNegativa.getEstadoMotivoCalificacionNegativa().getCodigo())) {
					if (!Checks.esNulo(dto.getFechaSubsanacion())) {
						beanUtilNotNull.copyProperty(activoCalificacionNegativa, "fechaSubsanacion",
								dto.getFechaSubsanacion());
					}
				}

				Filter filter = genericDao.createFilter(FilterType.EQUALS, "titulo.id", activo.getTitulo().getId());

				Order order = new Order(OrderType.DESC, "id");
				List<HistoricoTramitacionTitulo> historicoTramitacionTituloList = genericDao
						.getListOrdered(HistoricoTramitacionTitulo.class, order, filter);

				if (!Checks.estaVacio(historicoTramitacionTituloList)) {
					activoCalificacionNegativa.setHistoricoTramitacionTitulo(historicoTramitacionTituloList.get(0));
				}
				genericDao.save(ActivoCalificacionNegativa.class, activoCalificacionNegativa);

				transactionManager.commit(transaction);

				if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA)){
					Thread llamadaAsincrona = new Thread(new ConvivenciaRecovery(activo.getId(), new ModelMap(), usuarioManager.getUsuarioLogado().getUsername()));
					llamadaAsincrona.start();
				}

				return true;
			}

		} catch (Exception ex) {
			logger.error("Error en updateCalificacionNegativa", ex);
			throw new JsonViewerException(ex.getMessage());
		}

		return false;

	}

	@Override
	@Transactional(readOnly = false)
	public boolean destroyCalificacionNegativa(DtoActivoDatosRegistrales dto) {

		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

		ActivoCalificacionNegativa activoCalificacionNegativa = genericDao.get(ActivoCalificacionNegativa.class,
				genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dto.getIdMotivo())));

		Activo activo = null;

		if(activoCalificacionNegativa != null){
			activo = activoCalificacionNegativa.getActivo();
		}

		if (!Checks.esNulo(dto.getIdMotivo())) {
			genericDao.deleteById(ActivoCalificacionNegativa.class, Long.valueOf(dto.getIdMotivo()));

			transactionManager.commit(transaction);

			if(activo != null && activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA)){
				Thread llamadaAsincrona = new Thread(new ConvivenciaRecovery(activo.getId(), new ModelMap(), usuarioManager.getUsuarioLogado().getUsername()));
				llamadaAsincrona.start();
			}

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
				comPropietarios.setAsistenciaJuntaObligatoria(actCom.getAsistenciaJuntaObligatoria());
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
	public boolean esCerberus(Long idActivo) {
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);

		return DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo());
	}

	@Override
	public boolean esBBVA(Long idActivo){
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);
		
		return DDCartera.CODIGO_CARTERA_BBVA.equals(activo.getCartera().getCodigo());
	}
	
	@Override
	public boolean esSubcarteraJaipurInmobiliario(Long idActivo){
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);

		return DDSubcartera.CODIGO_JAIPUR_INMOBILIARIO.equals(activo.getSubcartera().getCodigo());
	}

	@Override
	public boolean esSubcarteraAgoraInmobiliario(Long idActivo) {
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);

		return DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(activo.getSubcartera().getCodigo());
	}

	@Override
	public boolean esSubcarteraEgeo(Long idActivo) {
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);

		return DDSubcartera.CODIGO_EGEO.equals(activo.getSubcartera().getCodigo());
	}

	@Override
	public boolean esEgeo(Long idActivo) {
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);

		return DDCartera.CODIGO_CARTERA_EGEO.equals(activo.getCartera().getCodigo());
	}

	@Override
	public boolean esSubcarteraZeus(Long idActivo) {
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);

		return DDSubcartera.CODIGO_ZEUS.equals(activo.getSubcartera().getCodigo());
	}

	@Override
	public boolean esSubcarteraPromontoria(Long idActivo) {
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		Activo activo = genericDao.get(Activo.class, filterAct);

		return DDSubcartera.CODIGO_PROMONTORIA.equals(activo.getSubcartera().getCodigo());
	}

	@Override
	public boolean esSubcarteraApple(Long idActivo) {
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
					logger.error(e.getMessage(), e);
				} catch (InvocationTargetException e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
		return null;
	}

	@Override
	public List<DtoHistoricoDestinoComercial> getListDtoHistoricoDestinoComercialByBeanList(
			List<HistoricoDestinoComercial> hdc) {

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

			Order order = new Order(OrderType.DESC, "fechaInicio");

			List<HistoricoDestinoComercial> historico = genericDao.getListOrdered(HistoricoDestinoComercial.class,
					order, filtroActivo, filtroBorrado);

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
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idActivo", idActivo.toString());
		
		rawDao.addParams(params);

		List<Object> listaObj = rawDao.getExecuteSQLList("SELECT AGR_ID FROM ACT_AGA_AGRUPACION_ACTIVO WHERE ACT_ID = :idActivo AND BORRADO = 0");

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
					logger.error(e.getMessage(), e);
				} catch (InvocationTargetException e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
		return null;
	}

	public List<?> getAllActivosAgrupacionRestringida(Activo activo) {
		if (activo != null) {
			for (ActivoAgrupacionActivo activoAgrupacionActivo : activo.getAgrupaciones()) {
				if (activoAgrupacionActivo.getAgrupacion() != null
						&& (isActivoAgrupacionTipo(activoAgrupacionActivo, DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)
								|| (isActivoAgrupacionTipo(activoAgrupacionActivo, DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER))
								|| (isActivoAgrupacionTipo(activoAgrupacionActivo, DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)))) {
					DtoAgrupacionFilter filter = new DtoAgrupacionFilter();
					filter.setLimit(1000);
					filter.setStart(0);
					Page page = agrupacionAdapter.getListActivosAgrupacionById(filter,
							activoAgrupacionActivo.getAgrupacion().getId(), true);
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
		Boolean esGestoria = false;
		Boolean esGestoriaDelActivo = false;

		try {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			DDIdentificacionGestoria ige = gestorActivoManager.isGestoria(usuarioLogado);
			List<UsuarioCartera> usuarioCartera = genericDao.getList(UsuarioCartera.class,genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
			List<Long> subcarteras = new ArrayList<Long>();
			Activo activo = genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "numActivo", numActivo));
			esGestoria = !Checks.esNulo(ige);
			
			if (activo != null) {
				for (UsuarioCartera uca : usuarioCartera) {
					if (uca.getSubCartera() != null) {
						subcarteras.add(uca.getSubCartera().getId());
					}
				}
				
				if (esGestoria) {
					esGestoriaDelActivo = Long.parseLong(rawDao.getExecuteSQL("SELECT COUNT(*) "
							 + "FROM V_BUSQUEDA_ACTIVOS_GESTORIAS "
							 + "WHERE DD_IGE_ID = "+ige.getId()+ " AND ACT_ID = "+activo.getId())) >= 1;
							 
					if (!esGestoriaDelActivo) {
						return null;
					}
				}
					
				if(usuarioCartera != null && !usuarioCartera.isEmpty()) {
					activo = activoDao.existeActivoUsuarioCarterizado(numActivo, usuarioCartera.get(0).getCartera().getId(), subcarteras);
					if (activo != null) {
						return activo.getId();
					} else {
						return null;
					}

				} else {
					return activo.getId();
				}
			} else {
				return null;
			}
		} catch (Exception e) {
			return null;
		}
	}

	@Override
	public Integer getGeolocalizacion(Activo activo) {
		if (activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null
				&& activo.getLocalizacion().getLocalizacionBien().getProvincia() != null) {
			String codigo = activo.getLocalizacion().getLocalizacionBien().getProvincia().getCodigo();
			if (codigo.equals("0") || codigo.equals("98") || codigo.equals("99")) {
				return 0;
			} else if (codigo.equals("35") || codigo.equals("38")) {
				return 1; // Islas Canarias
			} else {
				return 2; // Península
			}
		} else {
			return 0;
		}
	}

	@Override
	public boolean compruebaParaEnviarEmailAvisoOcupacion(DtoActivoSituacionPosesoria activoDto, Long id) {
		Activo activo = this.get(id);
		ActivoSituacionPosesoria posesoria = activo.getSituacionPosesoria();
		Integer ocupado;
		String conTitulo = "";
		DDTipoTituloActivoTPA tituloActivoTPA = null;
		
		if(activoDto.getConTituloCodigo() != null) {
			Filter tituloActivo = genericDao.createFilter(FilterType.EQUALS, "codigo", activoDto.getConTituloCodigo());
			tituloActivoTPA = genericDao.get(DDTipoTituloActivoTPA.class, tituloActivo);
		}
		
		if (tituloActivoTPA != null) {
			conTitulo = tituloActivoTPA.getCodigo();
		} else if (!Checks.esNulo(posesoria.getConTitulo())) {
			conTitulo = posesoria.getConTitulo().getCodigo();
		}
		
		if (activoDto.getOcupado() != null) {
			ocupado = activoDto.getOcupado();
		} else
			ocupado = posesoria.getOcupado();

		if (!Checks.esNulo(id)) {
			if ((DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())
					&& (activo.getSituacionPosesoria() != null && activo.getSituacionPosesoria().getSitaucionJuridica() != null 
					&& activo.getSituacionPosesoria().getSitaucionJuridica().getIndicaPosesion() != null)
					&& (1 == activo.getSituacionPosesoria().getSitaucionJuridica().getIndicaPosesion()))
					|| (!DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())
							&& (!Checks.esNulo(posesoria) && (!Checks.esNulo(posesoria.getFechaRevisionEstado())
									|| !Checks.esNulo(posesoria.getFechaTomaPosesion()))))) {
				if (!Checks.esNulo(ocupado) && (1 == ocupado && DDTipoTituloActivoTPA.tipoTituloNo.equals(conTitulo))) {
					List<DtoAdjunto> listAdjuntos;
					DtoAdjunto adjuntoAux = null;
					try {
						listAdjuntos = activoAdapter.getAdjuntosActivo(activo.getId());
						Collections.sort(listAdjuntos);
						
						if (!Checks.estaVacio(listAdjuntos)) {
							// Buscamos el adjunto de tipo ocupacionDesocupacion mas reciente
							for (DtoAdjunto adjunto: listAdjuntos) {
								boolean esOcupacionDesocupacion = DDTipoDocumentoActivo.MATRICULA_INFORME_OCUPACION_DESOCUPACION
										.equals(adjunto.getMatricula());
								
								if (esOcupacionDesocupacion) {
									adjuntoAux = adjunto;
									break;
								}
							}
						}
						List<DtoAdjuntoMail> sendAdj = new ArrayList<DtoAdjuntoMail>();

						if (!Checks.esNulo(adjuntoAux)) {
							DtoAdjuntoMail adj = new DtoAdjuntoMail();
							adj.setNombre(adjuntoAux.getNombre());
							FileItem fileItem = null;
							try {
								if (!Checks.esNulo(adjuntoAux.getId())) {
									fileItem = activoAdapter.download(adjuntoAux.getId(), adjuntoAux.getNombre());
								}
							} catch (UserException e) {
								logger.error(e.getMessage(), e);
							} catch (Exception e) {
								logger.error(e.getMessage(), e);
							}
							if (!Checks.esNulo(fileItem)) {
								adj.setAdjunto(new Adjunto(fileItem));
							}

							sendAdj.add(adj);

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
						}else {
							return false;
						}

					} catch (IllegalAccessException e) {
						logger.error(e.getMessage(), e);
					} catch (InvocationTargetException e) {
						logger.error(e.getMessage(), e);
					} catch (GestorDocumentalException e) {
						logger.error(e.getMessage(), e);
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
		DDTipoDocumentoActivo tipoDocu = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", matriculaActivo);
		tipoDocu = genericDao.get(DDTipoDocumentoActivo.class, filtro);
		List<DtoAdjunto> listaAdjuntos = null;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Activo activo = this.get(idActivo);
			try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosActivo(activo);
				if (!Checks.esNulo(listaAdjuntos)) {
					for (DtoAdjunto adj : listaAdjuntos) {
						String matricula = adj.getMatricula();
						if (!Checks.esNulo(matricula) && matricula.equals(tipoDocu.getMatricula())) {
							return true;

						}
					}
				}
			} catch (GestorDocumentalException e) {
				logger.error("Error comprobando el documento de okupación " + e.getMessage());
			}
		}
		return false;
	}

	@SuppressWarnings("resource")
	public FileItem generarUrlGDPR(DtoGenerarDocGDPR dtoGenerarDocGDPR) throws GestorDocumentalException, IOException {

		String fecha = new SimpleDateFormat("yyyyMMdd").format(new Date());
		String documento = "";
		if (!Checks.esNulo(dtoGenerarDocGDPR.getDocumento()))
			documento = dtoGenerarDocGDPR.getDocumento();

		String reservationKey = appProperties.getProperty(KEY_GDPR) + documento + fecha;
		String signature = computeKey(reservationKey);

		String url = appProperties.getProperty(URL_GDPR);
		String gdpr1 = "0";
		String gdpr2 = "0";
		String gdpr3 = "0";
		if (!Checks.esNulo(dtoGenerarDocGDPR.getCesionDatos()) && dtoGenerarDocGDPR.getCesionDatos().equals(true)) {
			gdpr1 = "1";
		}
		if (!Checks.esNulo(dtoGenerarDocGDPR.getComTerceros()) && dtoGenerarDocGDPR.getComTerceros().equals(true)) {
			gdpr2 = "1";
		}
		if (!Checks.esNulo(dtoGenerarDocGDPR.getTransIntern()) && dtoGenerarDocGDPR.getTransIntern().equals(true)) {
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

	private RespuestaDescargarDocumento rellenarRespuestaDescarga(String nombreDocumento) {

		RespuestaDescargarDocumento respuesta = new RespuestaDescargarDocumento();
		respuesta.setNombreDocumento(nombreDocumento + ".pdf");

		return respuesta;
	}

	public Object getBinaryResponse(ServerRequest serverRequest, String fileName, DtoGenerarDocGDPR dtoGenerarDocGDPR,
			String signature) {

		String restClientUrl = serverRequest.getRestClientUrl();

		final Client client = ClientBuilder.newBuilder().register(MultiPartFeature.class).register(JacksonFeature.class)
				.build();
		String url = restClientUrl;
		WebTarget webTarget = client.target(url);
		logger.info("URL: " + url);
		Object response = webTarget.request()
				.post(Entity.entity(serverRequest.getMultipart(), serverRequest.getMultipart().getMediaType()));

		if (response == null)
			return null;
		Response res = (Response) response;
		InputStream is = (InputStream) res.getEntity();
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
			logger.error("RestClientManager : Error al recoger bytes del archivo - " + e);
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
			result = hexString.toString();
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return result;
	}

	private Long getCodRemPrescriptor(DtoGenerarDocGDPR dtoGenerarDocGDPR) {
		Long codRemPrescriptor = null;
		if (!Checks.esNulo(dtoGenerarDocGDPR.getIdExpediente())) {
			ExpedienteComercial expCom = expedienteComercialDao.get(dtoGenerarDocGDPR.getIdExpediente());
			codRemPrescriptor = expCom.getOferta().getPrescriptor().getCodigoProveedorRem();
		} else {
			codRemPrescriptor = dtoGenerarDocGDPR.getCodPrescriptor();
		}

		return codRemPrescriptor;
	}

	@Override
	public ActivoPatrimonio getActivoPatrimonio(Long idActivo) {
		return activoPatrimonioDao.getActivoPatrimonioByActivo(idActivo);
	}

	@Override
	public List<DtoMotivoAnulacionExpediente> getMotivoAnulacionExpediente() {

		List<DtoMotivoAnulacionExpediente> listDtoMotivoAnulacionExpediente = new ArrayList<DtoMotivoAnulacionExpediente>();
		List<DDMotivoAnulacionExpediente> listaDDMotivoAnulacionExpediente = new ArrayList<DDMotivoAnulacionExpediente>();

		Filter filtroMotivoAlquiler = genericDao.createFilter(FilterType.EQUALS, "alquiler", true);
		listaDDMotivoAnulacionExpediente = genericDao.getList(DDMotivoAnulacionExpediente.class, filtroMotivoAlquiler);

		for (DDMotivoAnulacionExpediente tipDocExp : listaDDMotivoAnulacionExpediente) {
			DtoMotivoAnulacionExpediente aux = new DtoMotivoAnulacionExpediente();
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
	public List<DtoMotivoAnulacionExpediente> getMotivoAnulacionExpedienteCaixa() {

		List<DtoMotivoAnulacionExpediente> listDtoMotivoAnulacionExpediente = new ArrayList<DtoMotivoAnulacionExpediente>();
		List<DDMotivoAnulacionExpediente> listaDDMotivoAnulacionExpediente = new ArrayList<DDMotivoAnulacionExpediente>();

		Filter filtroMotivoCaixa = genericDao.createFilter(FilterType.EQUALS, "visibleCaixa", true);
		listaDDMotivoAnulacionExpediente = genericDao.getList(DDMotivoAnulacionExpediente.class, filtroMotivoCaixa);

		for (DDMotivoAnulacionExpediente tipDocExp : listaDDMotivoAnulacionExpediente) {
			DtoMotivoAnulacionExpediente aux = new DtoMotivoAnulacionExpediente();
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

		if (!Checks.esNulo(proveedorActivo.getIdFalso().getIdActivo())) {
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
		List<ComunicacionGencat> listaComunicacionGencat = genericDao.getList(ComunicacionGencat.class,
				genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
		if (!Checks.estaVacio(listaComunicacionGencat)) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public DtoActivoDatosRegistrales getCalificacionNegativoByidActivoIdMotivo(Long idActivo, String idMotivo) {

		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroMotivo = genericDao.createFilter(FilterType.EQUALS, "motivoCalificacionNegativa.codigo", idMotivo);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);

		DtoActivoDatosRegistrales dto = new DtoActivoDatosRegistrales();
		ActivoCalificacionNegativa actCalNeg = genericDao.get(ActivoCalificacionNegativa.class, filtroActivo,
				filtroMotivo, filtroBorrado);
		DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaFormateada = null;
		if (!Checks.esNulo(actCalNeg)) {
			try {
				if (!Checks.esNulo(actCalNeg.getFechaSubsanacion())) {
					fechaFormateada = formatter.parse(formatter.format(actCalNeg.getFechaSubsanacion()));
				}
			} catch (ParseException e) {
				logger.error(e.getMessage(), e);
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
	public boolean getMotivosCalificacionNegativaSubsanados(Long idActivo, String idMotivo) {
		int subsanado = 0;
		boolean resultado = false;

		List<ActivoCalificacionNegativa> motivosCalificacionNegativa = activoDao
				.getListActivoCalificacionNegativaByIdActivoBorradoFalse(idActivo);
		for (ActivoCalificacionNegativa activoCN : motivosCalificacionNegativa) {
			if (!activoCN.getAuditoria().isBorrado() && (DDEstadoMotivoCalificacionNegativa.DD_SUBSANADO_CODIGO
					.equals(activoCN.getEstadoMotivoCalificacionNegativa().getCodigo())
					|| idMotivo.equals(activoCN.getMotivoCalificacionNegativa().getCodigo()))) {

				subsanado = subsanado + 1;
			}
		}
		if (subsanado == motivosCalificacionNegativa.size()) {
			resultado = true;
		}
		return resultado;
	}

	@Override
	public void actualizarMotivoOcultacionUAs(DtoActivoPatrimonio patrimonioDto, Long id) {

		if (DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO.equals(patrimonioDto.getEstadoAlquiler())
				|| DDTipoEstadoAlquiler.ESTADO_ALQUILER_LIBRE.equals(patrimonioDto.getEstadoAlquiler())) {
			if (activoDao.isActivoMatriz(id)) {
				ActivoAgrupacion agrupacionPA = activoDao.getAgrupacionPAByIdActivo(id);
				if (Checks.esNulo(agrupacionPA.getFechaBaja())) {
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
	public void actualizarOfertasTrabajosVivos(Long idActivo) {
		this.actualizarOfertasTrabajosVivos(activoAdapter.getActivoById(idActivo));
	}

	@Override
	public List<ActivoTrabajo> getActivoTrabajos(Long idActivo){
		List<ActivoTrabajo> trabajosDelActivo = null;
		trabajosDelActivo = genericDao.getList(ActivoTrabajo.class, 
				genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo),
				genericDao.createFilter(FilterType.EQUALS, "trabajo.auditoria.borrado", false));
		if(trabajosDelActivo == null)
			trabajosDelActivo = new ArrayList<ActivoTrabajo>();
		return trabajosDelActivo;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void actualizarOfertasTrabajosVivos(Activo activo) {
		Boolean tieneOfertasVivas = false;
		Boolean tieneTrabajosVivos = false;
		List<ActivoTrabajo> trabajosDelActivo = this.getActivoTrabajos(activo.getId());
		tieneOfertasVivas = particularValidator
				.existeActivoConOfertaVivaEstadoExpediente(Long.toString(activo.getNumActivo()));

		for (ActivoTrabajo activoTrabajo : trabajosDelActivo) {
			if (activoTrabajo.getTrabajo() != null) {
				if (activoTrabajo.getTrabajo().getEstado() != null
						&& activoTrabajo.getTrabajo().getSubtipoTrabajo() != null) {
					if (!DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_VENTA
							.equals(activoTrabajo.getTrabajo().getSubtipoTrabajo().getCodigo())
							&& !DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_ALQUILER
									.equals(activoTrabajo.getTrabajo().getSubtipoTrabajo().getCodigo())
							&& (DDEstadoTrabajo.ESTADO_EN_TRAMITE
									.equals(activoTrabajo.getTrabajo().getEstado().getCodigo())
									|| DDEstadoTrabajo.ESTADO_CEE_PENDIENTE_ETIQUETA
											.equals(activoTrabajo.getTrabajo().getEstado().getCodigo())
									|| DDEstadoTrabajo.ESTADO_PENDIENTE_CIERRE_ECONOMICO
											.equals(activoTrabajo.getTrabajo().getEstado().getCodigo())
									|| DDEstadoTrabajo.ESTADO_VALIDADO
											.equals(activoTrabajo.getTrabajo().getEstado().getCodigo()))) {

						tieneTrabajosVivos = true;

						break;
					}
				}
			}
		}
		PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class,
				genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));

		if (!Checks.esNulo(perimetroActivo)) {

			perimetroActivo.setTrabajosVivos(tieneTrabajosVivos);
			perimetroActivo.setOfertasVivas(tieneOfertasVivas);

			genericDao.save(PerimetroActivo.class, perimetroActivo);
		}

		if (activoDao.isUnidadAlquilable(activo.getId())) {
			Boolean uaConTrabajosVivos = false;
			ActivoAgrupacion agrupacionPa = activoDao.getAgrupacionPAByIdActivo(activo.getId());

			Long idAM = activoDao.getIdActivoMatriz(agrupacionPa.getId());

			List<Object[]> listaTrabajosUA = activoDao.getTrabajosUa(idAM, activo.getId());
			if (!Checks.estaVacio(listaTrabajosUA)) {
				for (Object[] trabajoObjeto : listaTrabajosUA) {
					Trabajo trabajoUA = (Trabajo) trabajoObjeto[0];
					if (!Checks.esNulo(trabajoUA)) {
						if (!DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_VENTA
								.equals(trabajoUA.getSubtipoTrabajo().getCodigo())
								&& !DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_ALQUILER
										.equals(trabajoUA.getSubtipoTrabajo().getCodigo())
								&& (DDEstadoTrabajo.ESTADO_EN_TRAMITE.equals(trabajoUA.getEstado().getCodigo())
										|| DDEstadoTrabajo.ESTADO_CEE_PENDIENTE_ETIQUETA
												.equals(trabajoUA.getEstado().getCodigo())
										|| DDEstadoTrabajo.ESTADO_PENDIENTE_CIERRE_ECONOMICO
												.equals(trabajoUA.getEstado().getCodigo())
										|| DDEstadoTrabajo.ESTADO_VALIDADO.equals(trabajoUA.getEstado().getCodigo()))) {
							uaConTrabajosVivos = true;
							break;
						}
					}
				}

				if (!Checks.esNulo(perimetroActivo)) {
					perimetroActivo.setTrabajosVivos(uaConTrabajosVivos);
				}
				genericDao.save(PerimetroActivo.class, perimetroActivo);
			}

			PerimetroActivo perimetroActivoAM = genericDao.get(PerimetroActivo.class, genericDao
					.createFilter(FilterType.EQUALS, "activo.id", activoDao.getIdActivoMatriz(agrupacionPa.getId())));
			tieneOfertasVivas = activoDao.checkOfertasVivasAgrupacion(agrupacionPa.getId());
			tieneTrabajosVivos = activoDao.checkOTrabajosVivosAgrupacion(agrupacionPa.getId());

			if (!tieneOfertasVivas) {
				tieneOfertasVivas = particularValidator.existeActivoConOfertaVivaEstadoExpediente(Long.toString(
						activoDao.getActivoById(activoDao.getIdActivoMatriz(agrupacionPa.getId())).getNumActivo()));
			}
			if (!tieneTrabajosVivos) {
				List<ActivoTrabajo> trabajosDelActivoAM = this.getActivoTrabajos(activo.getId());
				for (ActivoTrabajo activoTrabajoAM : trabajosDelActivoAM) {
					if (!DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_VENTA
							.equals(activoTrabajoAM.getTrabajo().getSubtipoTrabajo().getCodigo())
							&& !DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_ALQUILER
									.equals(activoTrabajoAM.getTrabajo().getSubtipoTrabajo().getCodigo())
							&& (DDEstadoTrabajo.ESTADO_EN_TRAMITE
									.equals(activoTrabajoAM.getTrabajo().getEstado().getCodigo())
									|| DDEstadoTrabajo.ESTADO_CEE_PENDIENTE_ETIQUETA
											.equals(activoTrabajoAM.getTrabajo().getEstado().getCodigo())
									|| DDEstadoTrabajo.ESTADO_PENDIENTE_CIERRE_ECONOMICO
											.equals(activoTrabajoAM.getTrabajo().getEstado().getCodigo())
									|| DDEstadoTrabajo.ESTADO_VALIDADO
											.equals(activoTrabajoAM.getTrabajo().getEstado().getCodigo()))) {

						tieneTrabajosVivos = true;
						break;
					}
				}
			}
			if (!Checks.esNulo(perimetroActivoAM)) {
				perimetroActivoAM.setOfertasVivas(tieneOfertasVivas);
				perimetroActivoAM.setTrabajosVivos(tieneTrabajosVivos);

				genericDao.save(PerimetroActivo.class, perimetroActivoAM);
			}

		}
	}

	@Override
	public void bloquearChecksComercializacionActivo(ActivoAgrupacionActivo aga, DtoActivoFichaCabecera activoDto) {
		if (aga.getPrincipal() == 1) {
			Boolean ofertasVivas = activoDao.existenUAsconOfertasVivas(aga.getAgrupacion().getId());
			Boolean trabajosVivos = activoDao.existenUAsconTrabajos(aga.getAgrupacion().getId());
			if (!Checks.esNulo(ofertasVivas) && ofertasVivas) {
				activoDto.setCheckComercializarReadOnly(false);
			}
			if (!Checks.esNulo(trabajosVivos) && trabajosVivos) {
				activoDto.setCheckGestionarReadOnly(false);
			}
		} else {
			Long idAM = activoDao.getIdActivoMatriz(aga.getAgrupacion().getId());
			PerimetroActivo perimetroActivoAM = genericDao.get(PerimetroActivo.class,
					genericDao.createFilter(FilterType.EQUALS, "activo.id", idAM));
			if (!Checks.esNulo(perimetroActivoAM)) {
				if (!Checks.esNulo(perimetroActivoAM.getAplicaGestion()) && perimetroActivoAM.getAplicaGestion() == 0) {
					activoDto.setCheckGestionarReadOnly(false);
				}
				if (!Checks.esNulo(perimetroActivoAM.getAplicaPublicar()) && !perimetroActivoAM.getAplicaPublicar()) {
					activoDto.setCheckPublicacionReadOnly(false);
				}
				if (!Checks.esNulo(perimetroActivoAM.getAplicaComercializar())
						&& perimetroActivoAM.getAplicaComercializar() == 0) {
					activoDto.setCheckComercializarReadOnly(false);
				}
				if (!Checks.esNulo(perimetroActivoAM.getAplicaFormalizar())
						&& perimetroActivoAM.getAplicaFormalizar() == 0) {
					activoDto.setCheckFormalizarReadOnly(false);
				}
			}
		}
	}

	@Override
	public boolean isActivoMatriz(Long idActivo) {
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
				if (!isActivoMatriz(activo.getActivo().getId()) && (isActivoAlquilado(activo.getActivo())
						|| isOcupadoConTituloOrEstadoAlquilado(activo.getActivo()))) {
					uAsAlquiladas = true;
				}
			}
		}

		return uAsAlquiladas;
	}
	
	@Override
	public boolean isAlquiladoTotalmente(Long idActivoMatriz) {
		boolean uAsAlquiladas = true;
		ActivoAgrupacion agr = activoDao.getAgrupacionPAByIdActivo(idActivoMatriz);
		
		List<ActivoAgrupacionActivo> activos = agr.getActivos();
		
		if (!Checks.estaVacio(activos)) {
			for (ActivoAgrupacionActivo activo : activos) {
				if (!isActivoMatriz(activo.getActivo().getId()) && (!isActivoAlquilado(activo.getActivo()) && !isOcupadoConTituloOrEstadoAlquilado(activo.getActivo()))) {
					uAsAlquiladas = false;
					break;
				}
			}
		}
		
		return uAsAlquiladas;
	}

	@Override
	public List<DDCesionSaneamiento> getPerimetroAppleCesion(String codigoServicer) {

		List<DDCesionSaneamiento> listaPerimetros = new ArrayList<DDCesionSaneamiento>();

		if (!Checks.esNulo(codigoServicer)) {
			listaPerimetros = genericDao.getList(DDCesionSaneamiento.class,
					genericDao.createFilter(FilterType.EQUALS, "servicer.codigo", codigoServicer));
		}

		return listaPerimetros;
	}

	@Transactional(readOnly = false)
	public boolean saveOrUpdateActivoTributo(DtoActivoTributos dto, Long idActivo) throws ParseException {
		ActivoTributos tributo = new ActivoTributos();

		if (!Checks.esNulo(dto.getIdTributo())) {
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
				tributo.setFechaPresentacionRecurso(ft.parse(dto.getFechaPresentacion()));
			}
			if(!Checks.esNulo(dto.getFechaRecPropietario())){
				tributo.setFechaRecepcionPropietario(ft.parse(dto.getFechaRecPropietario()));
			}
			if(!Checks.esNulo(dto.getFechaRecGestoria())){
				tributo.setFechaRecepcionGestoria(ft.parse(dto.getFechaRecGestoria()));
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
				tributo.setFechaRecepcionRecursoPropietario(ft.parse(dto.getFechaRecRecursoPropietario()));
			}
			if(!Checks.esNulo(dto.getFechaRecRecursoGestoria())){
				tributo.setFechaRecepcionRecursoGestoria(ft.parse(dto.getFechaRecRecursoGestoria()));
			}
			if(!Checks.esNulo(dto.getFechaRespRecurso())){
				tributo.setFechaRespuestaRecurso(ft.parse(dto.getFechaRespRecurso()));
			}
			if(!Checks.esNulo(dto.getResultadoSolicitud())){
				Filter filtroResultado = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getResultadoSolicitud());
				DDResultadoSolicitud resultadoSolicitud = genericDao.get(DDResultadoSolicitud.class, filtroResultado);
				
				if(!Checks.esNulo(resultadoSolicitud)){
					tributo.setResultadoSolicitud(resultadoSolicitud);
				}
			}
			if (!Checks.esNulo(dto.getNumGastoHaya())) {
				Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", dto.getNumGastoHaya());
				GastoProveedor gasto = genericDao.get(GastoProveedor.class, filtroGasto);

				if (!Checks.esNulo(gasto)) {
					tributo.setGastoProveedor(gasto);
				}
			}

			if (Checks.esNulo(dto.getNumTributo())) {
				Long numMaxTributo = tributoDaoImpl.getNumMaxTributo();
				tributo.setNumTributo(numMaxTributo + 1);
			} else {
				tributo.setNumTributo(dto.getNumTributo());
			}
	
			if(!Checks.esNulo(dto.getTipoTributo())) {
				DDTipoTributo tipoTributo = genericDao.get(DDTipoTributo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoTributo()));
				tributo.setTipoTributo(tipoTributo);
			}

			if(dto.getFechaRecepcionTributo() != null && !dto.getFechaRecepcionTributo().isEmpty()) {
				tributo.setFechaRecepcionTributo(ft.parse(dto.getFechaRecepcionTributo()));
			}
			if(dto.getFechaPagoTributo() != null && !dto.getFechaPagoTributo().isEmpty()) {
				tributo.setFechaPagoTributo(ft.parse(dto.getFechaPagoTributo()));
			}
			if(dto.getImportePagado() != null) {
				tributo.setImportePagado(dto.getImportePagado());
			}
			
			if(dto.getNumExpediente() != null){
				tributo.setExpediente(dto.getNumExpediente());
			}
			
			if(!Checks.esNulo(dto.getFechaComunicacionDevolucionIngreso())){
				tributo.setFechaComunicacionDevolucionIngreso(ft.parse(dto.getFechaComunicacionDevolucionIngreso()));
			}
			
			if(!Checks.esNulo(dto.getImporteRecuperadoRecurso())){
				tributo.setImporteRecuperadoRecurso(dto.getImporteRecuperadoRecurso());
			}
			
			if(dto.getEstaExento() != null) {
				if(DDSinSiNo.CODIGO_SI.equals(dto.getEstaExento())) {
					tributo.setTributoExento(true);
				}else {
					tributo.setTributoExento(false);
				}
			}
			
			if(dto.getMotivoExento() != null) {
				Filter filtroResultado = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMotivoExento());
				DDMotivoExento motivoexento = genericDao.get(DDMotivoExento.class, filtroResultado);
				
				if(!Checks.esNulo(motivoexento)){
					tributo.setMotivoExento(motivoexento);
				}
			}
					
			if (!Checks.esNulo(tributo.getId())) {
				genericDao.update(ActivoTributos.class, tributo);
			} else {
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

		if (!Checks.esNulo(dto.getIdTributo())) {
			Filter filtroTributo = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTributo());
			ActivoTributos tributo = genericDao.get(ActivoTributos.class, filtroTributo);

			tributo.getAuditoria().setBorrado(true);
			genericDao.update(ActivoTributos.class, tributo);

			Thread hilo = new Thread(activoTributoApi.deleteAdjuntosDeTributo(tributo.getId()));
			hilo.start();

			return true;
		} else {
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

		if (!Checks.esNulo(activoNoTramitable)) {
			tramitable = false;
		}

		return tramitable;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.deleteAdjuntoPlusvalia")
	@Transactional(readOnly = false)
	public boolean deleteAdjuntoPlusvalia(DtoAdjunto dtoAdjunto) {
		boolean borrado = false;
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", dtoAdjunto.getIdEntidad());
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
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

			} else {
				AdjuntoPlusvalias adjuntoPlusvalias = activoPlusvalia.getAdjunto(dtoAdjunto.getId());
				activoPlusvalia.getAdjuntos().remove(adjuntoPlusvalias);
				genericDao.save(ActivoPlusvalia.class, activoPlusvalia);
			}
		} catch (Exception ex) {
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
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id",
				Long.parseLong(webFileItem.getParameter("idEntidad")));
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
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
				gestorDocumentalAdapterApi.crearRelacionPlusvalia(activoPlusvalia, idDocRestClient,
						activoPlusvalia.getActivo().getNumActivo().toString(), usuarioLogado.getUsername(),
						crearRelacionExpedienteDto);

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
		} else {

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

		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", dtoAdjunto.getIdEntidad());
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		ActivoPlusvalia activoPlusvalia = genericDao.get(ActivoPlusvalia.class, filtroActivo, filtroBorrado);
		AdjuntoPlusvalias adjunto = null;
		FileItem fileItem = null;

		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				fileItem = gestorDocumentalAdapterApi.getFileItem(dtoAdjunto.getId(), dtoAdjunto.getNombre());
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
		if (!Checks.esNulo(activoNoTramitable)) {
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
			DDMotivoAutorizacionTramitacion motivoTramitacion = genericDao.get(DDMotivoAutorizacionTramitacion.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMotivoAutorizacionTramitacionCodigo()));
			ActivoAutorizacionTramitacionOfertas activoAuto = activo.getActivoAutorizacionTramitacionOfertas();
			if (Checks.esNulo(activoAuto)) {
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
	public List<DtoHistoricoTramitacionTitulo> getHistoricoTramitacionTitulo(Long id) {
		List<DtoHistoricoTramitacionTitulo> listaDto = new ArrayList<DtoHistoricoTramitacionTitulo>();
		try {
			ActivoTitulo titulo = activoAdapter.getActivoById(id).getTitulo();
			if (!Checks.esNulo(titulo)) {
				Order order = new Order(OrderType.DESC, "id");
				List<HistoricoTramitacionTitulo> listaObjeto = genericDao.getListOrdered(
						HistoricoTramitacionTitulo.class, order,
						genericDao.createFilter(FilterType.EQUALS, "titulo", titulo));
				if (!Checks.esNulo(listaObjeto) && !Checks.estaVacio(listaObjeto)) {
					for (HistoricoTramitacionTitulo htt : listaObjeto) {

						DtoHistoricoTramitacionTitulo aux = new DtoHistoricoTramitacionTitulo();
						beanUtilNotNull.copyProperty(aux, "idActivo", id);
						beanUtilNotNull.copyProperty(aux, "titulo", htt.getTitulo().getId());

						beanUtilNotNull.copyProperty(aux, "estadoPresentacion",
								htt.getEstadoPresentacion().getDescripcion());
						beanUtilNotNull.copyProperty(aux, "codigoEstadoPresentacion",
								htt.getEstadoPresentacion().getCodigo());
						beanUtilNotNull.copyProperty(aux, "fechaPresentacionRegistro",
								htt.getFechaPresentacionRegistro());
						beanUtilNotNull.copyProperty(aux, "idHistorico", htt.getId());
						if (!Checks.esNulo(htt.getFechaCalificacion())) {
							beanUtilNotNull.copyProperty(aux, "fechaCalificacion", htt.getFechaCalificacion());
						}
						if (!Checks.esNulo(htt.getFechaInscripcion())) {
							beanUtilNotNull.copyProperty(aux, "fechaInscripcion", htt.getFechaInscripcion());
						}
						if (!Checks.esNulo(htt.getObservaciones())) {
							beanUtilNotNull.copyProperty(aux, "observaciones", htt.getObservaciones());
						}

						Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", id);
						List<ActivoCalificacionNegativa> ActivoTieneCalificacionNegativa = genericDao
								.getList(ActivoCalificacionNegativa.class, filtroActivo);
						if (ActivoTieneCalificacionNegativa.isEmpty()) {
							beanUtilNotNull.copyProperty(aux, "tieneCalificacionNoSubsanada", 1);
						} else {
							Filter filtroMotivo = genericDao.createFilter(FilterType.EQUALS,
									"estadoMotivoCalificacioNegativa.codigo",
									DDEstadoMotivoCalificacionNegativa.DD_PENDIENTE_CODIGO);
							List<ActivoCalificacionNegativa> actCalNeg = genericDao
									.getList(ActivoCalificacionNegativa.class, filtroActivo, filtroMotivo);

							beanUtilNotNull.copyProperty(aux, "tieneCalificacionNoSubsanada",
									actCalNeg.isEmpty() ? 0 : 1);
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
	public boolean createHistoricoTramtitacionTitulo(DtoHistoricoTramitacionTitulo tramitacionDto, Long idActivo)
			throws HistoricoTramitacionException {

		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

		Activo activo = activoAdapter.getActivoById(idActivo);
		
		HistoricoTramitacionTitulo htt = new HistoricoTramitacionTitulo();
		ActivoTitulo titulo = activoAdapter.getActivoById(idActivo).getTitulo();
		Order order = new Order(OrderType.DESC, "id");
		
		List<HistoricoTramitacionTitulo> listasTramitacion = null;
		
		String estadoTitulo = null;
		
		try {
			if (Checks.esNulo(titulo)) throw new HistoricoTramitacionException(
					"Debe informarse algún dato de 'Tramitación título' para poder crear un registro.");
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "titulo.id", titulo.getId());
			listasTramitacion = genericDao.getListOrdered(HistoricoTramitacionTitulo.class,
					order, filtro);
			
			if (!Checks.estaVacio(listasTramitacion)) {
				if (!Checks.esNulo(listasTramitacion.get(0).getFechaCalificacion()) && listasTramitacion.get(0)
						.getFechaCalificacion().after(tramitacionDto.getFechaPresentacionRegistro())) {
					throw new HistoricoTramitacionException(
							"La fecha de presentación no puede ser menor que la fecha de calificación negativa anterior.");
				} else if (!Checks.esNulo(listasTramitacion.get(0).getFechaPresentacionRegistro()) && listasTramitacion.get(0)
						.getFechaPresentacionRegistro().after(tramitacionDto.getFechaPresentacionRegistro())) {
					throw new HistoricoTramitacionException(
							"La fecha de presentación no puede ser menor que la fecha de presentación anterior.");
				}
			}
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

			beanUtilNotNull.copyProperty(htt, "titulo", titulo);
			if (!Checks.esNulo(tramitacionDto.getFechaPresentacionRegistro())) {
				beanUtilNotNull.copyProperty(htt, "fechaPresentacionRegistro",
						tramitacionDto.getFechaPresentacionRegistro());
			}
			if (!Checks.esNulo(tramitacionDto.getEstadoPresentacion())) {
				DDEstadoPresentacion estadoPresentacion = (DDEstadoPresentacion) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDEstadoPresentacion.class, tramitacionDto.getEstadoPresentacion());
				this.doCheckEstadoTramitacionTitulo(titulo, estadoPresentacion);
				beanUtilNotNull.copyProperty(htt, "estadoPresentacion", estadoPresentacion);
				if (DDEstadoPresentacion.PRESENTACION_EN_REGISTRO.equals(estadoPresentacion.getCodigo())) {
					estadoTitulo = DDEstadoTitulo.ESTADO_EN_TRAMITACION;
				}

				if (DDEstadoPresentacion.INSCRITO.equals(estadoPresentacion.getCodigo())
						&& !Checks.esNulo(tramitacionDto.getFechaInscripcion())) {
					
					htt.getTitulo().setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
					estadoTitulo = DDEstadoTitulo.ESTADO_INSCRITO;
				}
			}


			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager", e);
				return false;
			}

			if (!Checks.esNulo(tramitacionDto.getFechaCalificacion())) {
				beanUtilNotNull.copyProperty(htt, "fechaCalificacion", tramitacionDto.getFechaCalificacion());
			}
			if (!Checks.esNulo(tramitacionDto.getFechaInscripcion())) {
				beanUtilNotNull.copyProperty(htt, "fechaInscripcion", tramitacionDto.getFechaInscripcion());
			}
			if (!Checks.esNulo(tramitacionDto.getObservaciones())) {
				beanUtilNotNull.copyProperty(htt, "observaciones", tramitacionDto.getObservaciones());
			}

		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);
			return false;

		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
			return false;
		}

		DDEstadoTitulo ddEstadoTitulo = genericDao.get(DDEstadoTitulo.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", estadoTitulo));
		if (!Checks.esNulo(ddEstadoTitulo)) {
			htt.getTitulo().setEstado(ddEstadoTitulo);
		}

		genericDao.save(HistoricoTramitacionTitulo.class, htt);

		transactionManager.commit(transaction);

		if(activo != null && activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA)) {
			Thread llamadaAsincrona = new Thread(new ConvivenciaRecovery(activo.getId(), new ModelMap(), usuarioManager.getUsuarioLogado().getUsername()));
			llamadaAsincrona.start();
		}

		return true;
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public boolean createHistoricoTramitacionTituloAdicional(DtoHistoricoTramitacionTituloAdicional tramitacionDto,Long idActivo) throws HistoricoTramitacionException {
		ActivoHistoricoTituloAdicional ahtt = new ActivoHistoricoTituloAdicional();
		//ActivoTituloAdicional tituloAdicional=activoAdapter.getActivoById(idActivo).getTitulo(); genericDao.get(DDEstadoTitulo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoTitulo))
		ActivoTituloAdicional tituloAdicional= genericDao.get(ActivoTituloAdicional.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo));
		Order order = new Order(OrderType.DESC, "id");
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tituloAdicional.activo.id", idActivo);
		
		if (!Checks.esNulo(tituloAdicional) && !Checks.esNulo(tituloAdicional.getId())) {
			filtro = genericDao.createFilter(FilterType.EQUALS, "tituloAdicional.id", tituloAdicional.getId());
		}
		 
		List<ActivoHistoricoTituloAdicional> listasTramitacion = genericDao.getListOrdered(ActivoHistoricoTituloAdicional.class, order, filtro);
		String estadoTitulo = null;
			try {
				if(!Checks.estaVacio(listasTramitacion)) {
					if(!Checks.esNulo(listasTramitacion.get(0).getFechaCalificacion()) && listasTramitacion.get(0).getFechaCalificacion().after(tramitacionDto.getFechaPresentacionRegistro())) {
						throw new HistoricoTramitacionException("La fecha de presentación no puede ser menor que la fecha de calificación negativa anterior.");
					}else if(!Checks.esNulo(listasTramitacion.get(0).getFechaPresentacionRegistro()) && listasTramitacion.get(0).getFechaPresentacionRegistro().after(tramitacionDto.getFechaPresentacionRegistro())){
						throw new HistoricoTramitacionException("La fecha de presentación no puede ser menor que la fecha de presentación anterior.");
					}
					
				}
				beanUtilNotNull.copyProperty(ahtt, "tituloAdicional", tituloAdicional);
				if(!Checks.esNulo(tramitacionDto.getFechaPresentacionRegistro())) {
					beanUtilNotNull.copyProperty(ahtt, "fechaPresentacionRegistro", tramitacionDto.getFechaPresentacionRegistro());
				}
				if(!Checks.esNulo(tramitacionDto.getEstadoPresentacion())) {
					DDEstadoPresentacion estadoPresentacion = (DDEstadoPresentacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPresentacion.class, tramitacionDto.getEstadoPresentacion());
					this.doCheckEstadoTramitacionTituloAdicional(tituloAdicional, estadoPresentacion);
					beanUtilNotNull.copyProperty(ahtt, "estadoPresentacion", estadoPresentacion);
					if (DDEstadoPresentacion.PRESENTACION_EN_REGISTRO.equals(estadoPresentacion.getCodigo())) {
						estadoTitulo = DDEstadoTitulo.ESTADO_EN_TRAMITACION;
					}
					
					if (DDEstadoPresentacion.INSCRITO.equals(estadoPresentacion.getCodigo()) && !Checks.esNulo(tramitacionDto.getFechaInscripcion())) {
						ahtt.getTituloAdicional().setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
						estadoTitulo = DDEstadoTitulo.ESTADO_INSCRITO;
					}
					
					if (DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE.equals(estadoPresentacion.getCodigo())) {
						estadoTitulo = DDEstadoTitulo.ESTADO_SUBSANAR;
					}
				}
				if(!Checks.esNulo(tramitacionDto.getFechaCalificacion())) {
					beanUtilNotNull.copyProperty(ahtt, "fechaCalificacion", tramitacionDto.getFechaCalificacion());
				}
				if(!Checks.esNulo(tramitacionDto.getFechaInscripcion())) {
					beanUtilNotNull.copyProperty(ahtt, "fechaInscripcion", tramitacionDto.getFechaInscripcion());
				}
				if(!Checks.esNulo(tramitacionDto.getObservaciones())) {
					beanUtilNotNull.copyProperty(ahtt, "observaciones", tramitacionDto.getObservaciones());
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
				ahtt.getTituloAdicional().setEstadoTitulo(ddEstadoTitulo);
			}
			
		genericDao.save(ActivoHistoricoTituloAdicional.class, ahtt);
		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateHistoricoTramtitacionTitulo(DtoHistoricoTramitacionTitulo tramitacionDto) throws Exception, HistoricoTramitacionException{

		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
		
		HistoricoTramitacionTitulo htt = genericDao.get(HistoricoTramitacionTitulo.class,genericDao.createFilter(FilterType.EQUALS, "id", tramitacionDto.getIdHistorico()));
		String estadoTitulo = null;
		ActivoTitulo activoTitulo = htt.getTitulo();
		Activo activo = activoTitulo.getActivo();
		Order order = new Order(OrderType.DESC, "id");
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "titulo.activo.id", tramitacionDto.getIdActivo());
		
		if (!Checks.esNulo(activoTitulo) && !Checks.esNulo(activoTitulo.getId())) {
			filtro = genericDao.createFilter(FilterType.EQUALS, "titulo.id", activoTitulo.getId());
		}
		List<HistoricoTramitacionTitulo> listasTramitacion = genericDao.getListOrdered(HistoricoTramitacionTitulo.class,
				order, filtro);
		try {

			if (!Checks.esNulo(tramitacionDto.getFechaPresentacionRegistro())) {
				// Comprobar que la fecha de presentación de una segunda presentación no es
				// inferiór a la de primera calificación o en su defecto de primera presentación
				if (!Checks.estaVacio(listasTramitacion) && listasTramitacion.size() > 1) {
					if (!Checks.esNulo(listasTramitacion.get(1).getFechaCalificacion()) && listasTramitacion.get(1)
							.getFechaCalificacion().after(tramitacionDto.getFechaPresentacionRegistro())) {
						throw new HistoricoTramitacionException(
								"La fecha de presentación no puede ser menor que la fecha de calificación negativa anterior.");
					} else if (!Checks.esNulo(listasTramitacion.get(1).getFechaPresentacionRegistro()) && listasTramitacion
							.get(1).getFechaPresentacionRegistro().after(tramitacionDto.getFechaPresentacionRegistro())) {
						throw new HistoricoTramitacionException(
								"La fecha de presentación no puede ser menor que la fecha de presentación anterior.");
					}
				}
				// Comprobar que no se edite la fecha de presentación no sea menor que la fecha
				// de calificación
				if (!Checks.estaVacio(listasTramitacion)
						&& !Checks.esNulo(tramitacionDto.getFechaPresentacionRegistro())
						&& !Checks.esNulo(listasTramitacion.get(0).getFechaCalificacion())
						&& Checks.esNulo(tramitacionDto.getFechaCalificacion())
						&& tramitacionDto.getFechaPresentacionRegistro()
								.after(listasTramitacion.get(0).getFechaCalificacion())) {
					throw new HistoricoTramitacionException(
							"La fecha de calificación negativa no puede ser menor a la fecha de presentación.");
				}
				// Comprobar que no se edite la fecha de presentación para que sea después de la
				// fecha de inscripción.
				if (!Checks.estaVacio(listasTramitacion)
						&& !Checks.esNulo(tramitacionDto.getFechaPresentacionRegistro())
						&& !Checks.esNulo(listasTramitacion.get(0).getFechaInscripcion())
						&& Checks.esNulo(tramitacionDto.getFechaInscripcion()) && tramitacionDto
								.getFechaPresentacionRegistro().after(listasTramitacion.get(0).getFechaInscripcion())) {
					throw new HistoricoTramitacionException(
							"La fecha de inscripción no puede ser menor a la fecha de presentación.");
				}
			}
			if (!Checks.esNulo(tramitacionDto.getFechaPresentacionRegistro())) {
				beanUtilNotNull.copyProperty(htt, "fechaPresentacionRegistro",
						tramitacionDto.getFechaPresentacionRegistro());
			}
			if (!Checks.esNulo(tramitacionDto.getEstadoPresentacion())) {
				DDEstadoPresentacion estadoPresentacion = (DDEstadoPresentacion) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDEstadoPresentacion.class, tramitacionDto.getEstadoPresentacion());
				beanUtilNotNull.copyProperty(htt, "estadoPresentacion", estadoPresentacion);
				if (DDEstadoPresentacion.PRESENTACION_EN_REGISTRO.equals(estadoPresentacion.getCodigo())) {
					estadoTitulo = DDEstadoTitulo.ESTADO_EN_TRAMITACION;
					htt.setFechaInscripcion(null);
					htt.setFechaCalificacion(null);
					activoTitulo.setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
				}
				if (DDEstadoPresentacion.INSCRITO.equals(estadoPresentacion.getCodigo())
						&& (!Checks.esNulo(tramitacionDto.getFechaInscripcion()) || !Checks.esNulo(htt.getFechaInscripcion()))) {
					if(!Checks.esNulo(tramitacionDto.getFechaInscripcion())) {
						activoTitulo.setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
					} else if (!Checks.esNulo(htt.getFechaInscripcion())){
						activoTitulo.setFechaInscripcionReg(htt.getFechaInscripcion());
					}
					estadoTitulo = DDEstadoTitulo.ESTADO_INSCRITO;
					htt.setFechaCalificacion(null);
				}
				if (DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE.equals(estadoPresentacion.getCodigo())) {
					estadoTitulo = DDEstadoTitulo.ESTADO_SUBSANAR;
					htt.setFechaInscripcion(null);
					activoTitulo.setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
				}
			}
			if (!Checks.esNulo(tramitacionDto.getFechaCalificacion())) {
				beanUtilNotNull.copyProperty(htt, "fechaCalificacion", tramitacionDto.getFechaCalificacion());
			}
			if (!Checks.esNulo(tramitacionDto.getFechaInscripcion())) {
				beanUtilNotNull.copyProperty(htt, "fechaInscripcion", tramitacionDto.getFechaInscripcion());
			}
			if (!Checks.esNulo(tramitacionDto.getObservaciones())) {
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
			DDEstadoTitulo ddEstadoTitulo = genericDao.get(DDEstadoTitulo.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", estadoTitulo));
			if (!Checks.esNulo(ddEstadoTitulo)) {
				activoTitulo.setEstado(ddEstadoTitulo);
			}
		}

		if (!Checks.esNulo(activoTitulo)) {
			genericDao.save(ActivoTitulo.class, activoTitulo);
		}
		genericDao.save(HistoricoTramitacionTitulo.class, htt);

		transactionManager.commit(transaction);

		if(activo != null && activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA)) {
			Thread llamadaAsincrona = new Thread(new ConvivenciaRecovery(activo.getId(), new ModelMap(), usuarioManager.getUsuarioLogado().getUsername()));
			llamadaAsincrona.start();
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateHistoricoTramitacionTituloAdicional(DtoHistoricoTramitacionTituloAdicional tramitacionDto) throws Exception, HistoricoTramitacionException{
		
		ActivoHistoricoTituloAdicional ahtt = genericDao.get(ActivoHistoricoTituloAdicional.class,genericDao.createFilter(FilterType.EQUALS, "id", tramitacionDto.getIdHistorico()));
		String estadoTituloAdicional = null;
		ActivoTituloAdicional activoTituloAdicional = ahtt.getTituloAdicional();
		Order order = new Order(OrderType.DESC, "id");
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tituloAdicional.activo.id", tramitacionDto.getIdActivo());
		List<ActivoHistoricoTituloAdicional> listasTramitacion = genericDao.getListOrdered(ActivoHistoricoTituloAdicional.class, order, filtro);
		try {
				
				if(!Checks.esNulo(tramitacionDto.getFechaPresentacionRegistro())) {
					//Comprobar que la fecha de presentación de una segunda presentación no es inferiór a la de primera calificación o en su defecto de primera presentación
					if(!Checks.estaVacio(listasTramitacion) && listasTramitacion.size() > 1) {
						if(!Checks.esNulo(listasTramitacion.get(1).getFechaCalificacion()) && listasTramitacion.get(1).getFechaCalificacion().after(tramitacionDto.getFechaPresentacionRegistro())) {
							throw new HistoricoTramitacionException("La fecha de presentación no puede ser menor que la fecha de calificación negativa anterior.");
						}else if(!Checks.esNulo(listasTramitacion.get(1).getFechaPresentacionRegistro()) && listasTramitacion.get(1).getFechaPresentacionRegistro().after(tramitacionDto.getFechaPresentacionRegistro())){
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
					beanUtilNotNull.copyProperty(ahtt, "fechaPresentacionRegistro", tramitacionDto.getFechaPresentacionRegistro());
				}
				if(!Checks.esNulo(tramitacionDto.getEstadoPresentacion())) {
					DDEstadoPresentacion estadoPresentacion = (DDEstadoPresentacion) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDEstadoPresentacion.class, tramitacionDto.getEstadoPresentacion());
					beanUtilNotNull.copyProperty(ahtt, "estadoPresentacion", estadoPresentacion);
					if (DDEstadoPresentacion.PRESENTACION_EN_REGISTRO.equals(estadoPresentacion.getCodigo())) {
						estadoTituloAdicional = DDEstadoTitulo.ESTADO_EN_TRAMITACION;
						ahtt.setFechaInscripcion(null);
						ahtt.setFechaCalificacion(null);
						activoTituloAdicional.setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
					}
					if (DDEstadoPresentacion.INSCRITO.equals(estadoPresentacion.getCodigo()) && !Checks.esNulo(tramitacionDto.getFechaInscripcion())) {
						activoTituloAdicional.setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
						estadoTituloAdicional = DDEstadoTitulo.ESTADO_INSCRITO;
						ahtt.setFechaCalificacion(null);
					}
					if (DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE.equals(estadoPresentacion.getCodigo())) {
						estadoTituloAdicional = DDEstadoTitulo.ESTADO_SUBSANAR;
						ahtt.setFechaInscripcion(null);
						activoTituloAdicional.setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
					}
				}
				if(!Checks.esNulo(tramitacionDto.getFechaCalificacion())) {
					beanUtilNotNull.copyProperty(ahtt, "fechaCalificacion", tramitacionDto.getFechaCalificacion());
				}
				if(!Checks.esNulo(tramitacionDto.getFechaInscripcion())) {
					beanUtilNotNull.copyProperty(ahtt, "fechaInscripcion", tramitacionDto.getFechaInscripcion());
					activoTituloAdicional.setFechaInscripcionReg(tramitacionDto.getFechaInscripcion());
				}
				if(!Checks.esNulo(tramitacionDto.getObservaciones())) {
					beanUtilNotNull.copyProperty(ahtt, "observaciones", tramitacionDto.getObservaciones());
				}
				
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager", e);
				return false;

			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager", e);
				return false;
			}
		if (!Checks.esNulo(estadoTituloAdicional)) {
			DDEstadoTitulo ddEstadoTitulo = genericDao.get(DDEstadoTitulo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoTituloAdicional));
			if (!Checks.esNulo(ddEstadoTitulo)) {
				activoTituloAdicional.setEstadoTitulo(ddEstadoTitulo);
			}
		}
		
		if (!Checks.esNulo(activoTituloAdicional)) {
			genericDao.save(ActivoTituloAdicional.class, activoTituloAdicional);
		}
		genericDao.save(ActivoHistoricoTituloAdicional.class, ahtt);
		return true;
		
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public Boolean destroyHistoricoTramtitacionTitulo(DtoHistoricoTramitacionTitulo tramitacionDto) {
		HistoricoTramitacionTitulo htt = genericDao.get(HistoricoTramitacionTitulo.class,
				genericDao.createFilter(FilterType.EQUALS, "id", tramitacionDto.getIdHistorico()));

		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
		Activo activo = null;
		ActivoTitulo titulo = null;

		if (htt != null) {
			if (htt.getTitulo() != null) {
				titulo = htt.getTitulo();
				if (titulo != null) {

					List<ActivoCalificacionNegativa> calNegList = genericDao.getList(ActivoCalificacionNegativa.class,
							genericDao.createFilter(FilterType.EQUALS, "historicoTramitacionTitulo.id", htt.getId()));
					for (ActivoCalificacionNegativa calNeg : calNegList) {
						calNeg.getAuditoria().setBorrado(true);
						calNeg.getAuditoria().setFechaBorrar(new Date());
						calNeg.getAuditoria().setUsuarioBorrar(usuarioApi.getUsuarioLogado().getUsername());

						genericDao.save(ActivoCalificacionNegativa.class, calNeg);
					}
				}

				genericDao.deleteById(HistoricoTramitacionTitulo.class, htt.getId());

				Order order = new Order(OrderType.DESC, "id");
				List<HistoricoTramitacionTitulo> histTraTitList = genericDao.getListOrdered(
						HistoricoTramitacionTitulo.class, order,
						genericDao.createFilter(FilterType.EQUALS, "titulo.id", titulo.getId()));
				String codEstadoPres = "";
				if (!histTraTitList.isEmpty()) {
					HistoricoTramitacionTitulo histTraTit = histTraTitList.get(0);
					if (histTraTit.getEstadoPresentacion() != null) {
						if (DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE
								.equals(histTraTit.getEstadoPresentacion().getCodigo())) {
							codEstadoPres = DDEstadoTitulo.ESTADO_SUBSANAR;
						} else if (DDEstadoPresentacion.PRESENTACION_EN_REGISTRO
								.equals(histTraTit.getEstadoPresentacion().getCodigo())) {
							codEstadoPres = DDEstadoTitulo.ESTADO_EN_TRAMITACION;
						} else if (DDEstadoPresentacion.INSCRITO
								.equals(histTraTit.getEstadoPresentacion().getCodigo())) {
							codEstadoPres = DDEstadoTitulo.ESTADO_INSCRITO;
						}
					}
					DDEstadoTitulo estadoTitulo = (DDEstadoTitulo) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDEstadoTitulo.class, codEstadoPres);
					titulo.setEstado(estadoTitulo);
					genericDao.save(ActivoTitulo.class, titulo);

				}
			}

			if(titulo != null){
				activo = titulo.getActivo();
			}

			transactionManager.commit(transaction);

			if(activo != null && activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA)) {
				Thread llamadaAsincrona = new Thread(new ConvivenciaRecovery(activo.getId(), new ModelMap(), usuarioManager.getUsuarioLogado().getUsername()));
				llamadaAsincrona.start();
			}

			return true;
		}
		return false;

	}	
	
	
	@Override
	@Transactional(readOnly = false)
	public boolean destroyHistoricoTramitacionTituloAdicional(DtoHistoricoTramitacionTituloAdicional tramitacionDto) {
		ActivoHistoricoTituloAdicional ahtt = genericDao.get(ActivoHistoricoTituloAdicional.class, genericDao.createFilter(FilterType.EQUALS, "id", tramitacionDto.getIdHistorico()));
		if (ahtt != null) {
			if (ahtt.getTituloAdicional() != null) {
				ActivoTituloAdicional tituloAdicional = ahtt.getTituloAdicional();
				if (tituloAdicional != null) {
					
					List<ActivoCalificacionNegativaAdicional> calNegList = genericDao.getList(ActivoCalificacionNegativaAdicional.class,
							genericDao.createFilter(FilterType.EQUALS, "historicoTitulo.id", ahtt.getId()));
					for(ActivoCalificacionNegativaAdicional calNeg : calNegList ) {
						calNeg.getAuditoria().setBorrado(true);
						calNeg.getAuditoria().setFechaBorrar(new Date());
						calNeg.getAuditoria().setUsuarioBorrar(usuarioApi.getUsuarioLogado().getUsername());
						
						genericDao.save(ActivoCalificacionNegativaAdicional.class, calNeg);
					}
				}
			
				genericDao.deleteById(ActivoHistoricoTituloAdicional.class, ahtt.getId());
			
				Order order = new Order(OrderType.DESC, "id");
				List<ActivoHistoricoTituloAdicional> histTraTitList = genericDao.getListOrdered(ActivoHistoricoTituloAdicional.class,order, genericDao.createFilter(FilterType.EQUALS, "tituloAdicional.activo.id", tituloAdicional.getActivo().getId()));
				String codEstadoPres = "";
				if(!histTraTitList.isEmpty()) {
					ActivoHistoricoTituloAdicional histTraTit = histTraTitList.get(0);
					if(histTraTit.getEstadoPresentacion() != null) {
						if(DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE.equals(histTraTit.getEstadoPresentacion().getCodigo())){
							codEstadoPres  = DDEstadoTitulo.ESTADO_SUBSANAR;
						}else if(DDEstadoPresentacion.PRESENTACION_EN_REGISTRO.equals(histTraTit.getEstadoPresentacion().getCodigo())){
							codEstadoPres = DDEstadoTitulo.ESTADO_EN_TRAMITACION;
						} else if(DDEstadoPresentacion.INSCRITO.equals(histTraTit.getEstadoPresentacion().getCodigo())) {
							codEstadoPres =	DDEstadoTitulo.ESTADO_INSCRITO;
						}
					}
					DDEstadoTitulo estadoTitulo = (DDEstadoTitulo) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoTitulo.class, codEstadoPres);
					tituloAdicional.setEstadoTitulo(estadoTitulo);
					genericDao.save(ActivoTituloAdicional.class, tituloAdicional);
				}
			} 
			
			return true;
		}
		return false;
	}
	
	@Override
	public List<DtoHistoricoTramitacionTituloAdicional> getHistoricoTramitacionTituloAdicional(Long id){
		List<DtoHistoricoTramitacionTituloAdicional> listaDto = new ArrayList<DtoHistoricoTramitacionTituloAdicional>();
		//
		ActivoTituloAdicional att = genericDao.get(ActivoTituloAdicional.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", id));
		//
		try {
			//ActivoTituloAdicional titulo = ahtt.getTituloAdicional();
			if(att != null) {
				Order order  = new Order(OrderType.DESC, "id");
				List<ActivoHistoricoTituloAdicional> listaObjeto = genericDao.getListOrdered(ActivoHistoricoTituloAdicional.class, order, genericDao.createFilter(FilterType.EQUALS, "tituloAdicional", att));
				if(!Checks.esNulo(listaObjeto) && !Checks.estaVacio(listaObjeto)) {
					for(ActivoHistoricoTituloAdicional ahta: listaObjeto) {
						
						DtoHistoricoTramitacionTituloAdicional aux = new DtoHistoricoTramitacionTituloAdicional();
						//
						beanUtilNotNull.copyProperty(aux, "idActivo", id);
						beanUtilNotNull.copyProperty(aux, "titulo", ahta.getTituloAdicional().getId());
						
						beanUtilNotNull.copyProperty(aux, "estadoPresentacion", ahta.getEstadoPresentacion().getDescripcion());
						beanUtilNotNull.copyProperty(aux, "codigoEstadoPresentacion", ahta.getEstadoPresentacion().getCodigo());
						beanUtilNotNull.copyProperty(aux, "fechaPresentacionRegistro", ahta.getFechaPresentacionRegistro());
						beanUtilNotNull.copyProperty(aux, "idHistorico", ahta.getId());
						if(!Checks.esNulo(ahta.getFechaCalificacion())){
							beanUtilNotNull.copyProperty(aux, "fechaCalificacion", ahta.getFechaCalificacion());
						}
						if(!Checks.esNulo(ahta.getFechaInscripcion())){
							beanUtilNotNull.copyProperty(aux, "fechaInscripcion", ahta.getFechaInscripcion());
						}
						if(!Checks.esNulo(ahta.getObservaciones())){
							beanUtilNotNull.copyProperty(aux, "observaciones", ahta.getObservaciones());
						}
						
						Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", id);
						List<ActivoCalificacionNegativaAdicional> ActivoTieneCalificacionNegativa = genericDao.getList(ActivoCalificacionNegativaAdicional.class, filtroActivo);
						if(ActivoTieneCalificacionNegativa.isEmpty()) {
							beanUtilNotNull.copyProperty(aux, "tieneCalificacionNoSubsanada",1);
						}else {
							Filter filtroMotivo = genericDao.createFilter(FilterType.EQUALS, "motivoCalifNegativa.codigo",DDEstadoMotivoCalificacionNegativa.DD_PENDIENTE_CODIGO);
							List<ActivoCalificacionNegativaAdicional> actCalNeg = genericDao.getList(ActivoCalificacionNegativaAdicional.class, filtroActivo,filtroMotivo);
						
							beanUtilNotNull.copyProperty(aux, "tieneCalificacionNoSubsanada", actCalNeg.isEmpty() ? 0 : 1);
						}
						
						listaDto.add(aux);
					}
				}
			}
		} catch (Exception ex) {
			logger.error("Error en getHistoricoTramitacionTituloAdicional", ex);
		}
		return listaDto;
	}
	
	public void existeCalificacionNegativa(List<DtoHistoricoTramitacionTitulo> listaDto, DtoActivoDatosRegistrales dto) {
		try {
			if (!listaDto.isEmpty()) {
				for (DtoHistoricoTramitacionTitulo item : listaDto) {
					if (item.getCodigoEstadoPresentacion().equals(DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE)) {
						beanUtilNotNull.copyProperty(dto, "fechaPresentacionRegistroCN",
								item.getFechaPresentacionRegistro());
						if (item.getFechaInscripcion() != null) {
							beanUtilNotNull.copyProperty(dto, "fechaCalificacionNegativa", item.getFechaInscripcion());
						} else if (item.getFechaCalificacion() != null) {
							beanUtilNotNull.copyProperty(dto, "fechaCalificacionNegativa", item.getFechaCalificacion());
						}
						break;
					}
				}
			}
		} catch (Exception e) {
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

	@Override
	public boolean isActivoPerteneceAgrupacionRestringida(Activo activo) {
		for (ActivoAgrupacionActivo agrupacion : activo.getAgrupaciones()) {
			if (Checks.esNulo(agrupacion.getAgrupacion().getFechaBaja())) {
				if (!Checks.esNulo(agrupacion.getAgrupacion().getTipoAgrupacion())
						&& (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupacion.getAgrupacion().getTipoAgrupacion().getCodigo())
						|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(agrupacion.getAgrupacion().getTipoAgrupacion().getCodigo())
						|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(agrupacion.getAgrupacion().getTipoAgrupacion().getCodigo()))) {
					return true;
				}
			}
		}
		return false;
	}

	@Override
	public List<DtoHistoricoDiarioGestion> getHistoricoDiarioGestion(Long idActivo) {
		Activo activo = activoDao.getActivoById(idActivo);
		List<DtoHistoricoDiarioGestion> listaDtoHistoricoDiarioGestion = new ArrayList<DtoHistoricoDiarioGestion>();
		if (!Checks.esNulo(activo.getComunidadPropietarios())) {
			Long idComunidadPropietarios = activo.getComunidadPropietarios().getId();
			List<GestionCCPP> listaHistoricoDiarioGestion = genericDao.getList(GestionCCPP.class,
					genericDao.createFilter(FilterType.EQUALS, "comunidadPropietarios.id", idComunidadPropietarios));

			for (GestionCCPP historicoDiarioGestion : listaHistoricoDiarioGestion) {
				DtoHistoricoDiarioGestion dtoHistoricoDiarioGestion = new DtoHistoricoDiarioGestion();

				if (!Checks.esNulo(historicoDiarioGestion.getEstadoLocalizacion())) {
					dtoHistoricoDiarioGestion
							.setEstadoLocDesc(historicoDiarioGestion.getEstadoLocalizacion().getDescripcion());
				}
				if (!Checks.esNulo(historicoDiarioGestion.getSubestadoGestion())) {
					dtoHistoricoDiarioGestion
							.setSubEstadoDesc(historicoDiarioGestion.getSubestadoGestion().getDescripcion());
				}
				if (!Checks.esNulo(historicoDiarioGestion.getUsuario())) {
					dtoHistoricoDiarioGestion.setNombreGestorDesc(historicoDiarioGestion.getUsuario().getUsername());
				}
				dtoHistoricoDiarioGestion.setFechaCambioEstado(historicoDiarioGestion.getFechaInicio());

				listaDtoHistoricoDiarioGestion.add(dtoHistoricoDiarioGestion);
			}

		}
		return listaDtoHistoricoDiarioGestion;

	}

	@Override
	@Transactional(readOnly = false)
	public Boolean crearHistoricoDiarioGestion(DtoComunidadpropietariosActivo activoDto, Long idActivo) {
		Activo activo = activoDao.getActivoById(idActivo);

		if (!Checks.esNulo(activo.getComunidadPropietarios())) {

			Filter filtroComunidadPropietarios = genericDao.createFilter(FilterType.EQUALS, "comunidadPropietarios.id",
					activo.getComunidadPropietarios().getId());
			Filter filtroFechaFin = genericDao.createFilter(FilterType.NULL, "fechaFin");

			GestionCCPP gestionAnterior = genericDao.get(GestionCCPP.class, filtroComunidadPropietarios,
					filtroFechaFin);
			DDEstadoLocalizacion estadoAnterior = null;
			DDSubestadoGestion subEstadoAnterior = null;

			if (!Checks.esNulo(gestionAnterior)) {

				if (!Checks.esNulo(gestionAnterior.getEstadoLocalizacion())) {
					estadoAnterior = gestionAnterior.getEstadoLocalizacion();
				}
				if (!Checks.esNulo(gestionAnterior.getSubestadoGestion())) {
					subEstadoAnterior = gestionAnterior.getSubestadoGestion();
				}
				gestionAnterior.setFechaFin(new Date());
				gestionAnterior.getAuditoria().setUsuarioModificar(usuarioApi.getUsuarioLogado().getUsername());
				gestionAnterior.getAuditoria().setFechaModificar(new Date());

				genericDao.save(GestionCCPP.class, gestionAnterior);
			}

			GestionCCPP gestion = new GestionCCPP();

			gestion.setComunidadPropietarios(activo.getComunidadPropietarios());
			if (!Checks.esNulo(activoDto.getEstadoLocalizacion())) {
				DDEstadoLocalizacion estado = genericDao.get(DDEstadoLocalizacion.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", activoDto.getEstadoLocalizacion()));
				gestion.setEstadoLocalizacion(estado);
			} else {
				gestion.setEstadoLocalizacion(estadoAnterior);
			}

			if (!Checks.esNulo(activoDto.getSubestadoGestion())) {
				DDSubestadoGestion subEstado = genericDao.get(DDSubestadoGestion.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", activoDto.getSubestadoGestion()));
				gestion.setSubestadoGestion(subEstado);
			} else {
				gestion.setSubestadoGestion(subEstadoAnterior);
			}

			gestion.setFechaInicio(new Date());
			gestion.setUsuario(usuarioApi.getUsuarioLogado());

			Auditoria auditoria = new Auditoria();
			auditoria.setFechaCrear(new Date());
			auditoria.setUsuarioCrear(usuarioApi.getUsuarioLogado().getUsername());
			auditoria.setBorrado(false);

			gestion.setAuditoria(auditoria);

			genericDao.save(GestionCCPP.class, gestion);

			return true;

		}
		return false;
	}

	@Override
	public ActivoCrearPeticionTrabajoDto getActivoParaCrearPeticionTrabajobyId(Long idActivo) {
		ActivoCrearPeticionTrabajoDto dto = new ActivoCrearPeticionTrabajoDto();
		Activo activo = activoAdapter.getActivoById(idActivo);
		
		if(activo != null) {
			try {
				beanUtilNotNull.copyProperties(dto, activo);
				if(activo.getTipoActivo() != null && activo.getTipoActivo().getDescripcion() != null) {
					beanUtilNotNull.copyProperty(dto, "tipoActivo", activo.getTipoActivo().getDescripcion());
				}
				if(activo.getTipoActivo() != null && activo.getTipoActivo().getCodigo() != null) {
					beanUtilNotNull.copyProperty(dto, "tipoActivoCodigo", activo.getTipoActivo().getCodigo());
				}
				if(activo.getSubtipoActivo() != null && activo.getSubtipoActivo().getDescripcion() != null) {
					beanUtilNotNull.copyProperty(dto, "subtipoActivo", activo.getSubtipoActivo().getDescripcion());
				}
				if(activo.getSubtipoActivo() != null && activo.getSubtipoActivo().getCodigo() != null) {
					beanUtilNotNull.copyProperty(dto, "subtipoActivoCodigo", activo.getSubtipoActivo().getCodigo());
				}
			}catch (IllegalAccessException e) {
				logger.error(e.getMessage(),e);
			} catch (InvocationTargetException e) {
				logger.error(e.getMessage(),e);
			}
		}
		return dto;
	}
	
	@Override
	public ActivoDto getDatosActivo(Long activoId) {
		ActivoDto activoDto = new ActivoDto();

		Activo activo = activoAdapter.getActivoById(activoId);

		try {
			beanUtilNotNull.copyProperty(activoDto, "activoId", activo.getId());
			beanUtilNotNull.copyProperty(activoDto, "numActivo", activo.getNumActivo());
			if (!Checks.esNulo(activo.getInfoRegistral())
					&& !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien())) {
				beanUtilNotNull.copyProperty(activoDto, "fincaRegistral",
						activo.getInfoRegistral().getInfoRegistralBien().getNumFinca());
			}
			if (!Checks.esNulo(activo.getTipoActivo())) {
				beanUtilNotNull.copyProperty(activoDto, "tipoActivo", activo.getTipoActivo().getDescripcion());
			}
			if (!Checks.esNulo(activo.getSubtipoActivo())) {
				beanUtilNotNull.copyProperty(activoDto, "subtipoActivo", activo.getSubtipoActivo().getDescripcion());
			}

			if (!Checks.esNulo(activo.getMunicipio())) {
				Localidad municipio = genericDao.get(Localidad.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", activo.getMunicipio()));
				if (!Checks.esNulo(municipio)) {
					beanUtilNotNull.copyProperty(activoDto, "municipio", municipio.getDescripcion());
					if (!Checks.esNulo(municipio.getProvincia())) {
						beanUtilNotNull.copyProperty(activoDto, "provincia", municipio.getProvincia().getDescripcion());
					}
				}
			}

		} catch (IllegalAccessException e) {
			logger.error(e.getMessage(), e);
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage(), e);
		}

		return activoDto;
	}

	// Para saber si pertenece a DND comprobar si devuelve un null. De esta forma se
	// evita hacer otra función igual
	// con otro bucle igual para devolver el número de agrupación dnd
	// Comprobar si devuelve null o no para saber si pertenece a agrupación DND.

	@Override
	public Boolean getVisibilidadTabFasesPublicacion(Activo activo) {
		Usuario logedUser = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		Usuario gestorPublicacionActivo = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_GESTOR_PUBLICACION);
		Usuario supervisorPublicacionActivo = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_SUPERVISOR_PUBLICACION);
		Usuario gestorActivo = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO);
		Usuario supervisorActivo = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_SUPERVISOR_ACTIVOS);
		Usuario gestorEdificacion = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES);
		Usuario supervisorEdificacion = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES);
		Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Filter vigenteFilter = genericDao.createFilter(FilterType.NULL, "fechaHasta");
		Order order = new Order(OrderType.DESC, "id");

		List<ActivoInformeComercialHistoricoMediador> listaMediadores = genericDao
				.getListOrdered(ActivoInformeComercialHistoricoMediador.class, order, activoFilter, vigenteFilter);
		ActivoInformeComercialHistoricoMediador mediadorVigente = null;
		if (!Checks.estaVacio(listaMediadores)) {
			mediadorVigente = listaMediadores.get(0);
		}

		if (!Checks.esNulo(gestorPublicacionActivo) && logedUser.equals(gestorPublicacionActivo)) {
			return true;
		} else if (!Checks.esNulo(supervisorPublicacionActivo) && logedUser.equals(supervisorPublicacionActivo)) {
			return true;
		} else if (!Checks.esNulo(gestorActivo) && logedUser.equals(gestorActivo)) {
			return true;
		} else if (!Checks.esNulo(supervisorActivo) && logedUser.equals(supervisorActivo)) {
			return true;
		} else if (!Checks.esNulo(gestorEdificacion) && logedUser.equals(gestorEdificacion)) {
			return true;
		} else if (!Checks.esNulo(supervisorEdificacion) && logedUser.equals(supervisorEdificacion)) {
			return true;
		} else if (!Checks.esNulo(mediadorVigente) && !Checks.esNulo(mediadorVigente.getMediadorInforme())) {
			Long idProveedor = mediadorVigente.getMediadorInforme().getId();
			Filter pvcFilter = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", idProveedor);
			List<ActivoProveedorContacto> listaProveedorContacto = genericDao.getList(ActivoProveedorContacto.class,
					pvcFilter);
			if (!Checks.estaVacio(listaProveedorContacto)) {
				// Puede haber más de un registro en PVC con el mismo PVE_ID
				// pero por lo que he visto entre esos registro solo puede haber uno con
				// DocIdentificativo
				// y ese seria el mediador
				for (ActivoProveedorContacto proveedorContacto : listaProveedorContacto) {
					if (!Checks.esNulo(proveedorContacto) && !Checks.esNulo(proveedorContacto.getDocIdentificativo())) {
						Usuario usuMediadorVigente = proveedorContacto.getUsuario();
						if (!Checks.esNulo(usuMediadorVigente) && usuMediadorVigente.equals(logedUser)) {
							return true;
						}
					}
				}
			}
		}

		return false;
	}

	public void deleteActOfr(Long idActivo, Long idOferta) {
		activoDao.deleteActOfr(idActivo, idOferta);
	}

	@Override
	@Transactional(readOnly = false)
	public void crearRegistroFaseHistorico(Activo activo) {
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Filter filtroFechaFin = genericDao.createFilter(FilterType.NULL, "fechaFin");
		List<HistoricoFasePublicacionActivo> anteriorHistoricoFasePublicacionList = genericDao
				.getList(HistoricoFasePublicacionActivo.class, filtroActivo, filtroFechaFin);
		// La lista debería devolver solo un valor, para que no salte una excepción se
		// coge una lista y el valor 0
		if (!Checks.estaVacio(anteriorHistoricoFasePublicacionList)
				&& !Checks.esNulo(anteriorHistoricoFasePublicacionList.get(0))) {
			HistoricoFasePublicacionActivo anteriorHistoricoFasePublicacion = anteriorHistoricoFasePublicacionList
					.get(0);
			if (!Checks.esNulo(anteriorHistoricoFasePublicacion.getFasePublicacion())
					&& DDFasePublicacion.CODIGO_NO_APLICA
							.equals(anteriorHistoricoFasePublicacion.getFasePublicacion().getCodigo())) {
				return;
			}
			anteriorHistoricoFasePublicacion.setFechaFin(new Date());
			anteriorHistoricoFasePublicacion.getAuditoria()
					.setUsuarioModificar(usuarioApi.getUsuarioLogado().getUsername());
			anteriorHistoricoFasePublicacion.getAuditoria().setFechaModificar(new Date());
			genericDao.save(HistoricoFasePublicacionActivo.class, anteriorHistoricoFasePublicacion);
		}

		HistoricoFasePublicacionActivo nuevoHistoricoFasePublicacion = new HistoricoFasePublicacionActivo();
		nuevoHistoricoFasePublicacion.setActivo(activo);
		DDFasePublicacion nuevaFasePublicacion = genericDao.get(DDFasePublicacion.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", DDFasePublicacion.CODIGO_NO_APLICA));
		if (!Checks.esNulo(nuevaFasePublicacion)) {
			nuevoHistoricoFasePublicacion.setFasePublicacion(nuevaFasePublicacion);
		}

		nuevoHistoricoFasePublicacion.setUsuario(usuarioApi.getUsuarioLogado());
		nuevoHistoricoFasePublicacion.setFechaInicio(new Date());

		Auditoria auditoria = new Auditoria();
		auditoria.setUsuarioCrear(usuarioApi.getUsuarioLogado().getUsername());
		auditoria.setFechaCrear(new Date());

		nuevoHistoricoFasePublicacion.setAuditoria(auditoria);
		nuevoHistoricoFasePublicacion.setSubFasePublicacion(null);

		genericDao.save(HistoricoFasePublicacionActivo.class, nuevoHistoricoFasePublicacion);
	}

	@Override
	public List<DDFasePublicacion> getDiccionarioFasePublicacion() throws Exception {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC, "codigo");
		return genericDao.getListOrdered(DDFasePublicacion.class, order, filtro);
	}

	private void doCheckEstadoTramitacionTitulo(ActivoTitulo titulo, DDEstadoPresentacion estado)
			throws HistoricoTramitacionException {
		List<DtoHistoricoTramitacionTitulo> listaTramitacionTitulo = getHistoricoTramitacionTitulo(
				titulo.getActivo().getId());
		if (!listaTramitacionTitulo.isEmpty()) {
			String estadoPresentacion = listaTramitacionTitulo.get(0) != null
					? listaTramitacionTitulo.get(0).getCodigoEstadoPresentacion()
					: "";
			if (!DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE.equals(estadoPresentacion)) {
				throw new HistoricoTramitacionException(
						HistoricoTramitacionException.getErrorAlAnyadirRegistroAlTitulo(estado.getDescripcion()));

			}

		}
	}

	private void doCheckEstadoTramitacionTituloAdicional(ActivoTituloAdicional titulo, DDEstadoPresentacion estado) throws HistoricoTramitacionException {
		List<DtoHistoricoTramitacionTituloAdicional> listaTramitacionTitulo = getHistoricoTramitacionTituloAdicional(titulo.getActivo().getId());
		if (!listaTramitacionTitulo.isEmpty()) {
			String estadoPresentacion = listaTramitacionTitulo.get(0) != null ? listaTramitacionTitulo.get(0).getCodigoEstadoPresentacion() : "";
			if (!DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE.equals(estadoPresentacion)) {
				throw new HistoricoTramitacionException(HistoricoTramitacionException.getErrorAlAnyadirRegistroAlTitulo(estado.getDescripcion()));
			}
		}
	}
	
	@Override
	public void changeAndSavePlusvaliaEstadoGestionActivoById(Activo activo, String codigo)
			throws PlusvaliaActivoException {
		ActivoPlusvalia activoPlusvalia = activoDao.getPlusvaliaByIdActivo(activo.getId());
		if (activoPlusvalia == null) {
			activoPlusvalia = new ActivoPlusvalia();
			activoPlusvalia.setAuditoria(Auditoria.getNewInstance());
		}
		Filter filtroPlusvalia = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
		DDEstadoGestionPlusv estado = genericDao.get(DDEstadoGestionPlusv.class, filtroPlusvalia);
		activoPlusvalia.setActivo(activo);
		if (estado != null) {
			activoPlusvalia.setEstadoGestion(estado);
			genericDao.save(ActivoPlusvalia.class, activoPlusvalia);
		} else {
			throw new PlusvaliaActivoException(
					PlusvaliaActivoException.getErrorNoExisteEstadoDeGestionPorCodigo(codigo));
		}
	}

	@Override
	public Boolean getMostrarEdicionTabFasesPublicacion(Activo activo) {
		Usuario logedUser = usuarioManager.getUsuarioLogado();
		Usuario gestorPublicacionActivo = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_GESTOR_PUBLICACION);
		Usuario supervisorPublicacionActivo = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_SUPERVISOR_PUBLICACION);
		Usuario gestorActivo = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO);
		Usuario gestorEdificaciones = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES);

		List<Long> idGrpsUsuario = null;

		idGrpsUsuario = extGrupoUsuariosDao.buscaGruposUsuario(logedUser);

		Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Filter vigenteFilter = genericDao.createFilter(FilterType.NULL, "fechaAutorizacionHasta");
		Order order = new Order(OrderType.DESC, "id");

		List<ActivoInfoComercial> listaMediadores = genericDao.getListOrdered(ActivoInfoComercial.class, order,
				activoFilter, vigenteFilter);
		ActivoInfoComercial mediadorVigente = null;

		if (!Checks.estaVacio(listaMediadores)) {
			mediadorVigente = listaMediadores.get(0);
		}

		if (!Checks.esNulo(gestorPublicacionActivo) && logedUser.equals(gestorPublicacionActivo)
				|| !Checks.esNulo(gestorPublicacionActivo) && idGrpsUsuario.contains(gestorPublicacionActivo.getId())) {
			return true;
		} else if (!Checks.esNulo(supervisorPublicacionActivo) && logedUser.equals(supervisorPublicacionActivo)
				|| !Checks.esNulo(supervisorPublicacionActivo)
						&& idGrpsUsuario.contains(supervisorPublicacionActivo.getId())) {
			return true;
		} else if (!Checks.esNulo(gestorActivo) && logedUser.equals(gestorActivo)
				|| !Checks.esNulo(gestorActivo) && idGrpsUsuario.contains(gestorActivo.getId())) {
			return true;
		} else if (!Checks.esNulo(gestorEdificaciones) && logedUser.equals(gestorEdificaciones)
				|| !Checks.esNulo(gestorEdificaciones) && idGrpsUsuario.contains(gestorEdificaciones.getId())) {
			return true;
		} else if (genericAdapter.isSuper(logedUser)) {
			return true;
		} else if (!Checks.esNulo(mediadorVigente) && !Checks.esNulo(mediadorVigente.getMediadorInforme())) {
			Long idProveedor = mediadorVigente.getMediadorInforme().getId();
			Filter pvcFilter = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", idProveedor);
			List<ActivoProveedorContacto> listaProveedorContacto = genericDao.getList(ActivoProveedorContacto.class,
					pvcFilter);
			if (!Checks.estaVacio(listaProveedorContacto)) {
				for (ActivoProveedorContacto proveedorContacto : listaProveedorContacto) {
					if (!Checks.esNulo(proveedorContacto) && !Checks.esNulo(proveedorContacto.getDocIdentificativo())) {
						Usuario usuMediadorVigente = proveedorContacto.getUsuario();
						if (!Checks.esNulo(usuMediadorVigente) && usuMediadorVigente.getId().equals(logedUser.getId())
								|| !Checks.esNulo(usuMediadorVigente)
										&& idGrpsUsuario.contains(usuMediadorVigente.getId())) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	@Override
	public void propagarTerritorioAgrupacionRestringida(Long idActivo) {

		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
		Activo activo = activoDao.getActivoById(idActivo);
		try {
			ActivoAgrupacion agrupacion = getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId())
					.getAgrupacion();
			if (!Checks.esNulo(agrupacion)) {
				List<ActivoAgrupacionActivo> agrupacionActivos = agrupacion.getActivos();
				for (ActivoAgrupacionActivo activoAgrupacionActivo : agrupacionActivos) {
					if (activo != activoAgrupacionActivo.getActivo()) {
						activoAgrupacionActivo.getActivo().setTerritorio(activo.getTerritorio());
					}

				}
			}

			transactionManager.commit(transaction);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			transactionManager.rollback(transaction);
		}
	}

	@Override
	public List<HistoricoPropuestasPreciosDto> getHistoricoSolicitudesPrecios(Long idActivo) {
		List<HistoricoPeticionesPrecios> listHistorico = activoDao.getHistoricoSolicitudesPrecios(idActivo);
		List<HistoricoPropuestasPreciosDto> listDto = new ArrayList<HistoricoPropuestasPreciosDto>();
		Boolean esPrimeroAdvisory = true;
		Boolean esPrimeroCliente = true;

		if (listHistorico != null && !listHistorico.isEmpty()) {
			for (HistoricoPeticionesPrecios historico : listHistorico) {
				HistoricoPropuestasPreciosDto dto = new HistoricoPropuestasPreciosDto();

				dto.setIdPeticion(historico.getId());
				dto.setTipoFecha(historico.getTipoPeticionPrecio().getDescripcion());
				dto.setObservaciones(historico.getObservaciones());
				dto.setIdActivo(idActivo);

				if (historico.getFechaSolicitud() != null) {
					dto.setFechaSolicitud(historico.getFechaSolicitud().toString());
				}

				if (historico.getFechaSancion() != null) {
					dto.setFechaSancion(historico.getFechaSancion().toString());
				}

				if (DDTipoPeticionPrecio.CODIGO_PETICION_ADVISORY.equals(historico.getTipoPeticionPrecio().getCodigo())
						&& esPrimeroAdvisory) {
					dto.setEsEditable(esPrimeroAdvisory);
					esPrimeroAdvisory = false;
				} else if (DDTipoPeticionPrecio.CODIGO_PETICION_ADVISORY
						.equals(historico.getTipoPeticionPrecio().getCodigo())) {
					dto.setEsEditable(esPrimeroAdvisory);
				}

				if (DDTipoPeticionPrecio.CODIGO_PETICION_CLIENTE.equals(historico.getTipoPeticionPrecio().getCodigo())
						&& esPrimeroCliente) {
					dto.setEsEditable(esPrimeroCliente);
					esPrimeroCliente = false;
				} else if (DDTipoPeticionPrecio.CODIGO_PETICION_CLIENTE
						.equals(historico.getTipoPeticionPrecio().getCodigo())) {
					dto.setEsEditable(esPrimeroCliente);
				}

				if (historico.getAuditoria().getUsuarioModificar() != null) {
					dto.setUsuarioModificar(historico.getAuditoria().getUsuarioModificar());
				} else {
					dto.setUsuarioModificar(historico.getAuditoria().getUsuarioCrear());
				}

				listDto.add(dto);
			}
		}

		return listDto;
	}

	@Override
	@Transactional
	public Boolean createHistoricoSolicitudPrecios(HistoricoPropuestasPreciosDto historicoPropuestasPreciosDto)
			throws ParseException {

		HistoricoPeticionesPrecios peticion = new HistoricoPeticionesPrecios();

		if (historicoPropuestasPreciosDto != null) {
			if (historicoPropuestasPreciosDto.getIdActivo() == null) {
				throw new JsonViewerException("No se ha podido asociar la propuetsa a un activo");
			} else {
				Activo activo = genericDao.get(Activo.class,
						genericDao.createFilter(FilterType.EQUALS, "id", historicoPropuestasPreciosDto.getIdActivo()));
				peticion.setActivo(activo);
			}

			if (historicoPropuestasPreciosDto.getTipoFecha() != null) {
				DDTipoPeticionPrecio tipoPeticion = genericDao.get(DDTipoPeticionPrecio.class, genericDao
						.createFilter(FilterType.EQUALS, "codigo", historicoPropuestasPreciosDto.getTipoFecha()));
				peticion.setTipoPeticionPrecio(tipoPeticion);
			}

			if (historicoPropuestasPreciosDto.getFechaSancion() != null
					&& !historicoPropuestasPreciosDto.getFechaSancion().isEmpty()) {
				peticion.setFechaSancion(ft.parse(historicoPropuestasPreciosDto.getFechaSancion()));
			}

			if (historicoPropuestasPreciosDto.getFechaSolicitud() != null
					&& !historicoPropuestasPreciosDto.getFechaSolicitud().isEmpty()) {
				peticion.setFechaSolicitud(ft.parse(historicoPropuestasPreciosDto.getFechaSolicitud()));
			}

			if (historicoPropuestasPreciosDto.getObservaciones() != null) {
				peticion.setObservaciones(historicoPropuestasPreciosDto.getObservaciones());
			}

			genericDao.save(HistoricoPeticionesPrecios.class, peticion);

			return true;
		}

		return false;
	}

	@Override
	@Transactional
	public Boolean updateHistoricoSolicitudPrecios(HistoricoPropuestasPreciosDto historicoPropuestasPreciosDto)
			throws ParseException {

		HistoricoPeticionesPrecios peticion = null;

		if (historicoPropuestasPreciosDto != null) {

			peticion = genericDao.get(HistoricoPeticionesPrecios.class,
					genericDao.createFilter(FilterType.EQUALS, "id", historicoPropuestasPreciosDto.getIdPeticion()));

			if (peticion != null) {
				if (historicoPropuestasPreciosDto.getTipoFecha() != null) {
					DDTipoPeticionPrecio tipoPeticion = genericDao.get(DDTipoPeticionPrecio.class, genericDao
							.createFilter(FilterType.EQUALS, "codigo", historicoPropuestasPreciosDto.getTipoFecha()));
					peticion.setTipoPeticionPrecio(tipoPeticion);
				}

				if (historicoPropuestasPreciosDto.getFechaSancion() != null) {
					peticion.setFechaSancion(ft.parse(historicoPropuestasPreciosDto.getFechaSancion()));
				}

				if (historicoPropuestasPreciosDto.getFechaSolicitud() != null) {
					peticion.setFechaSolicitud(ft.parse(historicoPropuestasPreciosDto.getFechaSolicitud()));
				}

				if (historicoPropuestasPreciosDto.getObservaciones() != null) {
					peticion.setObservaciones(historicoPropuestasPreciosDto.getObservaciones());
				}

				if (historicoPropuestasPreciosDto.getEsEditable() != null
						&& historicoPropuestasPreciosDto.getEsEditable()) {
					peticion.getAuditoria().setFechaCrear(new Date());
				}

				genericDao.save(HistoricoPeticionesPrecios.class, peticion);

				return true;
			}
		}

		return false;
	}

	@Override
	public List<DDTipoSegmento> getComboTipoSegmento(String codSubcartera) {
		List<DDTipoSegmento> tiposSegmento = new ArrayList<DDTipoSegmento>();
		Filter filtroSubcartera;
		List<DDSegmentoCarteraSubcartera> segmentosSubcartera = null;
		if (codSubcartera != null) {
			filtroSubcartera = genericDao.createFilter(FilterType.EQUALS, "subcartera.codigo", codSubcartera);
			segmentosSubcartera = genericDao.getList(DDSegmentoCarteraSubcartera.class, filtroSubcartera);
			if (segmentosSubcartera != null) {
				for (DDSegmentoCarteraSubcartera tipoSegmento : segmentosSubcartera) {
					if (tipoSegmento.getTipoSegmento() != null) {
						tiposSegmento.add(tipoSegmento.getTipoSegmento());
					}
					
				}
			}
		}		
		return tiposSegmento;
	}
	
	@Override
	@Transactional
	public void devolucionFasePublicacionAnterior(Activo activo) {
		if (activo != null) {
			String maxId = activoDao.getUltimaFasePublicacion(activo.getId());
			Filter filtroHist = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(maxId));
			HistoricoFasePublicacionActivo histo = genericDao.get(HistoricoFasePublicacionActivo.class, filtroHist);
			Filter filtroFecha = genericDao.createFilter(FilterType.NULL, "fechaFin");
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			HistoricoFasePublicacionActivo histoActual = genericDao.get(HistoricoFasePublicacionActivo.class, filtroFecha,filtroActivo);
			
			if(histoActual != null) {
				histoActual.setFechaFin(new Date());
				genericDao.update(HistoricoFasePublicacionActivo.class, histoActual);
			}
			HistoricoFasePublicacionActivo histoNuevo = new HistoricoFasePublicacionActivo();
			if(histo.getFasePublicacion() != null) {
				histoNuevo.setFasePublicacion(histo.getFasePublicacion());
			}
			if(histo.getComentario() != null) {
				histoNuevo.setComentario(histo.getComentario());
			}
			if(histo.getSubFasePublicacion() != null) {
				histoNuevo.setSubFasePublicacion(histo.getSubFasePublicacion());
			}
			if(histo.getVersion() != null) {
				histoNuevo.setVersion(histo.getVersion());
			}
			if(histo.getActivo() != null) {
				histoNuevo.setActivo(histo.getActivo());
			}
			Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			histoNuevo.setUsuario(usu);
			histoNuevo.setFechaInicio(new Date());
			Auditoria aut = new Auditoria();
			aut.setFechaCrear(new Date());
			aut.setUsuarioCrear(usu.getUsername());
			histoNuevo.setAuditoria(aut);
			genericDao.save(HistoricoFasePublicacionActivo.class, histoNuevo);
		}
	}
	
	@Override
	public boolean estanTodosActivosVendidos(List<Activo> activos) {
		boolean estanTodosVendidos = false;
		boolean auxiliarSalir = true;
		

		if(activos != null && !activos.isEmpty()) {
			for (Activo activo : activos) {
				if(activo.getSituacionComercial() != null && DDSituacionComercial.CODIGO_VENDIDO.equals(activo.getSituacionComercial().getCodigo())) {
					estanTodosVendidos = true;
					auxiliarSalir = false;
				}
				if(auxiliarSalir) {
					estanTodosVendidos = false;
					break;
				}
				
				auxiliarSalir = true;
			}
		}

		return estanTodosVendidos;
	}
	
	@Override
	public boolean estanTodosActivosAlquilados(List<Activo> activos) {
		boolean todosActivoAlquilados = false;
		boolean auxiliarSalir = true;
		

		if(activos != null && !activos.isEmpty()) {
			for (Activo activo : activos) {
				
				if(activo.getSituacionPosesoria() != null && activo.getSituacionPosesoria().getOcupado() != null
						&& activo.getSituacionPosesoria().getConTitulo() != null &&  activo.getSituacionPosesoria().getOcupado() == 1
						&& DDTipoTituloActivoTPA.tipoTituloSi.equals(activo.getSituacionPosesoria().getConTitulo().getCodigo())
						&& activo.getSituacionPosesoria().getTipoTituloPosesorio() != null 
						&&  DDTipoTituloPosesorio.CODIGO_ARRENDAMIENTO.equals(activo.getSituacionPosesoria().getTipoTituloPosesorio().getCodigo())) {
							todosActivoAlquilados = true;
							auxiliarSalir = false;
				}
				if(auxiliarSalir) {
					todosActivoAlquilados = false;
					break;
				}
				
				auxiliarSalir = true;
			}
		}

		return todosActivoAlquilados;
	}

	
	@Override
	public Boolean isGrupoOficinaKAM() {
		Boolean isGrupoOficinaKAM = false;
		GrupoUsuario grupoOfiKAM = null;
		Usuario logedUser = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if (logedUser != null) {
			grupoOfiKAM = genericDao.get(GrupoUsuario.class, genericDao.createFilter(FilterType.EQUALS, "grupo.username", GRUPO_OFICIONA_KAM), genericDao.createFilter(FilterType.EQUALS, "usuario.username", logedUser.getUsername()));
			if (grupoOfiKAM != null) {
				isGrupoOficinaKAM = true;
			}
		}
		return isGrupoOficinaKAM;
	}


	@Override
	public List<ReqFaseVentaDto> getReqFaseVenta(Long idActivo) {
		List<HistoricoRequisitosFaseVenta> listHistorico = activoDao.getReqFaseVenta(idActivo);
		List<ReqFaseVentaDto> listDto = new ArrayList<ReqFaseVentaDto>();
		
		if(listHistorico != null && !listHistorico.isEmpty()) {
			for(HistoricoRequisitosFaseVenta reqFaseVenta: listHistorico) {
				ReqFaseVentaDto dto = new ReqFaseVentaDto();
				
				dto.setIdReq(reqFaseVenta.getId());
				dto.setPreciomaximo(reqFaseVenta.getPrecioMaxVenta());
				dto.setIdActivo(idActivo);
				
				if(reqFaseVenta.getPrecioMaxVenta() != null) {
					dto.setFechapreciomaximo(reqFaseVenta.getFechaSolicitudPrecioMax().toString());
				}
				
				if(reqFaseVenta.getFechaRespuestaOrganismo() != null) {
					dto.setFecharespuestaorg(reqFaseVenta.getFechaRespuestaOrganismo().toString());
				}
				
				if(reqFaseVenta.getFechaVencimiento() != null) {
					dto.setFechavencimiento(reqFaseVenta.getFechaVencimiento().toString());
				}
				
				dto.setUsuariocrear(reqFaseVenta.getAuditoria().getUsuarioCrear());
				dto.setFechacrear(ft.format(reqFaseVenta.getAuditoria().getFechaCrear()));
				
				listDto.add(dto);
			}
		}
		
		return listDto;
	}

	@Override
	public List<SaneamientoAgendaDto> getSaneamientosAgendaByActivo(Long idActivo) {

		List<SaneamientoAgendaDto> listDto = new ArrayList<SaneamientoAgendaDto>();

		if (idActivo != null) {
			List<ActivoAgendaSaneamiento> aas = genericDao.getList(ActivoAgendaSaneamiento.class,
					genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo));

			if (aas != null && !aas.isEmpty()) {
				for (ActivoAgendaSaneamiento agendaSaneamiento : aas) {
					SaneamientoAgendaDto dto = new SaneamientoAgendaDto();

					dto.setIdActivo(idActivo);
					dto.setIdSan(agendaSaneamiento.getId());
					dto.setObservaciones(agendaSaneamiento.getObservaciones());

					if (agendaSaneamiento.getTipoAgendaSaneamiento() != null) {
						dto.setTipologiaCod(agendaSaneamiento.getTipoAgendaSaneamiento().getCodigo());
						dto.setTipologiaDesc(agendaSaneamiento.getTipoAgendaSaneamiento().getDescripcion());
					}

					if (agendaSaneamiento.getSubtipoAgendaSaneamiento() != null) {
						dto.setSubtipologiacod(agendaSaneamiento.getSubtipoAgendaSaneamiento().getCodigo());
						dto.setSubtipologiaDesc(agendaSaneamiento.getSubtipoAgendaSaneamiento().getDescripcion());
					}

					if (agendaSaneamiento.getAuditoria() != null
							&& agendaSaneamiento.getAuditoria().getUsuarioCrear() != null) {
						dto.setUsuariocrear(agendaSaneamiento.getAuditoria().getUsuarioCrear());
					}

					if (agendaSaneamiento.getFechaAltaSaneamiento() != null) {
						dto.setFechaCrear(agendaSaneamiento.getFechaAltaSaneamiento().toString());
					}

					listDto.add(dto);
				}
			}

		}

		return listDto;
	}

	@Override
	@Transactional
	public Boolean createReqFaseVenta(ReqFaseVentaDto reqFaseVentaDto) throws ParseException {
		
		HistoricoRequisitosFaseVenta requisito = new HistoricoRequisitosFaseVenta();
		
		if(reqFaseVentaDto != null) {
			
			ActivoInfAdministrativa activoInfo = null;
			Date fechaVencimiento = null;
			Double precioMaximo = null;
			
			if(reqFaseVentaDto.getIdActivo() == null) {
				throw new JsonViewerException("No se ha podido asociar el requisito a un activo");
			}else {
				activoInfo = genericDao.get(ActivoInfAdministrativa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", reqFaseVentaDto.getIdActivo()));
				requisito.setActivoInfAdministrativa(activoInfo);
			}
			
			if(reqFaseVentaDto.getFechapreciomaximo() != null && !reqFaseVentaDto.getFechapreciomaximo().isEmpty()) {
				requisito.setFechaSolicitudPrecioMax(ft.parse(reqFaseVentaDto.getFechapreciomaximo()));
			}
			
			if(reqFaseVentaDto.getFecharespuestaorg() != null && !reqFaseVentaDto.getFecharespuestaorg().isEmpty()) {
				requisito.setFechaRespuestaOrganismo(ft.parse(reqFaseVentaDto.getFecharespuestaorg()));
			}
			
			if(reqFaseVentaDto.getFechavencimiento() != null && !reqFaseVentaDto.getFechavencimiento().isEmpty()) {
				fechaVencimiento = ft.parse(reqFaseVentaDto.getFechavencimiento());
				requisito.setFechaVencimiento(fechaVencimiento);
			}
			
			if(reqFaseVentaDto.getPreciomaximo() != null) {
				precioMaximo = reqFaseVentaDto.getPreciomaximo();
				requisito.setPrecioMaxVenta(precioMaximo);
			}
			
			genericDao.save(HistoricoRequisitosFaseVenta.class, requisito);
			
			if(fechaVencimiento != null) {
				activoInfo.setFechaVencimiento(fechaVencimiento);
			}
			
			if(precioMaximo != null) {
				activoInfo.setPrecioMaxVenta(precioMaximo);
			}
			
			genericDao.save(ActivoInfAdministrativa.class, activoInfo);
			return true;
		}
		
		return false;
	}
	
	@Override
	@Transactional
	public Boolean createSaneamientoAgenda(SaneamientoAgendaDto saneamientoAgendaDto) {

		ActivoAgendaSaneamiento agendaSaneamiento = new ActivoAgendaSaneamiento();
		Activo activo = activoDao.get(saneamientoAgendaDto.getIdActivo());
		if (saneamientoAgendaDto != null) {
			if (saneamientoAgendaDto.getIdActivo() == null) {
				throw new JsonViewerException("No se ha podido asociar la agenda a un activo");
			} else {
				agendaSaneamiento.setActivo(activo);
			}

			if (saneamientoAgendaDto.getTipologiaCod() != null) {
				DDTipoAgendaSaneamiento tipoAgenda = genericDao.get(DDTipoAgendaSaneamiento.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", saneamientoAgendaDto.getTipologiaCod()));
				agendaSaneamiento.setTipoAgendaSaneamiento(tipoAgenda);
			}

			if (saneamientoAgendaDto.getSubtipologiacod() != null) {
				DDSubtipoAgendaSaneamiento tipoAgenda = genericDao.get(DDSubtipoAgendaSaneamiento.class, genericDao
						.createFilter(FilterType.EQUALS, "codigo", saneamientoAgendaDto.getSubtipologiacod()));
				agendaSaneamiento.setSubtipoAgendaSaneamiento(tipoAgenda);
			}

			agendaSaneamiento.setObservaciones(saneamientoAgendaDto.getObservaciones());

			agendaSaneamiento.setFechaAltaSaneamiento(new Date());

			genericDao.save(ActivoAgendaSaneamiento.class, agendaSaneamiento);

			ActivoObservacion activoObservacion = new ActivoObservacion();
			activoObservacion.setObservacion(saneamientoAgendaDto.getObservaciones());
			activoObservacion.setFecha(new Date());
			activoObservacion.setUsuario(adapter.getUsuarioLogado());
			activoObservacion.setActivo(activo);
			DDTipoObservacionActivo tipoObservacion = genericDao.get(DDTipoObservacionActivo.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoObservacionActivo.CODIGO_SANEAMIENTO));
			activoObservacion.setTipoObservacion(tipoObservacion);

			activoObservacion = genericDao.save(ActivoObservacion.class, activoObservacion);

			agendaSaneamiento.setActivoObservacion(activoObservacion);
			genericDao.update(ActivoAgendaSaneamiento.class, agendaSaneamiento);

			return true;
		}

		return false;
	}

	@Override
	@Transactional
	public Boolean deleteReqFaseVenta(ReqFaseVentaDto reqFaseVentaDto) {
		
		if(reqFaseVentaDto != null && reqFaseVentaDto.getIdReq() != null) {
			
			HistoricoRequisitosFaseVenta requisito = genericDao.get(HistoricoRequisitosFaseVenta.class, genericDao.createFilter(FilterType.EQUALS, "id", reqFaseVentaDto.getIdReq()));
			List<ReqFaseVentaDto> listRequisitos = getReqFaseVenta(reqFaseVentaDto.getIdActivo());
			
			if(requisito != null) {
				Auditoria.delete(requisito);
				
				genericDao.update(HistoricoRequisitosFaseVenta.class, requisito);
				
				ActivoInfAdministrativa activoInfo = genericDao.get(ActivoInfAdministrativa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", reqFaseVentaDto.getIdActivo()));
				
				if(listRequisitos != null && !listRequisitos.isEmpty() && listRequisitos.size() > 1 
						&& listRequisitos.get(1) != null && listRequisitos.get(0).getIdReq() != reqFaseVentaDto.getIdReq()) {
					
					HistoricoRequisitosFaseVenta requisito2 = genericDao.get(HistoricoRequisitosFaseVenta.class, genericDao.createFilter(FilterType.EQUALS, "id", listRequisitos.get(1).getIdReq()));
					
					activoInfo.setFechaVencimiento(requisito2.getFechaVencimiento());
					activoInfo.setPrecioMaxVenta(requisito2.getPrecioMaxVenta());
					
					genericDao.save(ActivoInfAdministrativa.class, activoInfo);
					
				}else {
					activoInfo.setFechaVencimiento(null);
					activoInfo.setPrecioMaxVenta(null);
				}
			}
			return true;
		}
		
		return false;
	}
	@Override
	@Transactional
	public Boolean deleteSaneamientoAgenda(SaneamientoAgendaDto saneamientoAgendaDto) {

		ActivoAgendaSaneamiento agendaSaneamiento = null;

		if (saneamientoAgendaDto != null) {

			agendaSaneamiento = genericDao.get(ActivoAgendaSaneamiento.class,
					genericDao.createFilter(FilterType.EQUALS, "id", saneamientoAgendaDto.getIdSan()));
			ActivoObservacion activoObservacion = agendaSaneamiento.getActivoObservacion();

			Auditoria.delete(agendaSaneamiento);
			Auditoria.delete(activoObservacion);

			genericDao.update(ActivoAgendaSaneamiento.class, agendaSaneamiento);
			genericDao.update(ActivoObservacion.class, activoObservacion);

			return true;
		}

		return false;
	}

	@Override
	public List<DtoActivoSuministros> getSuministrosActivo(Long idActivo) {
		List<ActivoSuministros> listSuministros = activoDao.getSuministrosByIdActivo(idActivo);
		List<DtoActivoSuministros> listDto = new ArrayList<DtoActivoSuministros>();
		
		if(listSuministros != null && !listSuministros.isEmpty()) {
			for(ActivoSuministros suministro: listSuministros) {
				DtoActivoSuministros dto = new DtoActivoSuministros();
				
				dto.setIdSuministro(suministro.getId().toString());
				dto.setIdActivo(suministro.getActivo().getId());
				
				if(!Checks.esNulo(suministro.getTipoSuministro())) {
					DDTipoSuministro tipoSuministro = genericDao.get(DDTipoSuministro.class, genericDao.createFilter(FilterType.EQUALS, "id", suministro.getTipoSuministro().getId()));
					dto.setTipoSuministro(tipoSuministro.getId());
				}
				if(!Checks.esNulo(suministro.getSubtipoSuministro())) {
					DDSubtipoSuministro subtipoSuministro = genericDao.get(DDSubtipoSuministro.class, genericDao.createFilter(FilterType.EQUALS, "id", suministro.getSubtipoSuministro().getId()));
					dto.setSubtipoSuministro(subtipoSuministro.getId());
				}
				if(!Checks.esNulo(suministro.getCompaniaSuministro())) {
					ActivoProveedor companiaSuministro = genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", suministro.getCompaniaSuministro().getId()));
					dto.setCompaniaSuministro(companiaSuministro.getId());
				}
				if(!Checks.esNulo(suministro.getDomiciliado())) {
					DDSinSiNo domiciliado = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "id", suministro.getDomiciliado().getId()));
					dto.setDomiciliado(domiciliado.getId());
				}
				if(!Checks.esNulo(suministro.getNumContrato())) {
					dto.setNumContrato(suministro.getNumContrato());
				}
				if(!Checks.esNulo(suministro.getNumCups())) {
					dto.setNumCups(suministro.getNumCups());
				}
				if(!Checks.esNulo(suministro.getPeriodicidad())) {
					DDPeriodicidad periodicidad = genericDao.get(DDPeriodicidad.class, genericDao.createFilter(FilterType.EQUALS, "id", suministro.getPeriodicidad().getId()));
					dto.setPeriodicidad(periodicidad.getId());
				}
				if(!Checks.esNulo(suministro.getFechaAlta())) {
					dto.setFechaAlta(suministro.getFechaAlta());
				}
				if(!Checks.esNulo(suministro.getMotivoAlta())) {
					DDMotivoAltaSuministro motivoAlta = genericDao.get(DDMotivoAltaSuministro.class, genericDao.createFilter(FilterType.EQUALS, "id", suministro.getMotivoAlta().getId()));
					dto.setMotivoAlta(motivoAlta.getId());
				}
				if(!Checks.esNulo(suministro.getFechaBaja())) {
					dto.setFechaBaja(suministro.getFechaBaja());
				}
				if(!Checks.esNulo(suministro.getMotivoBaja())) {
					DDMotivoBajaSuministro motivoBaja = genericDao.get(DDMotivoBajaSuministro.class, genericDao.createFilter(FilterType.EQUALS, "id", suministro.getMotivoBaja().getId()));
					dto.setMotivoBaja(motivoBaja.getId());
				}
				if(!Checks.esNulo(suministro.getValidado())) {
					DDSinSiNo validado = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "id", suministro.getValidado().getId()));
					dto.setValidado(validado.getId());
				}
				
				listDto.add(dto);
			}
		}
		
		return listDto;
	}
	
	@Override
	@Transactional
	public Boolean createSuministroActivo(DtoActivoSuministros dtoActivoSuministros) throws ParseException {
		
		ActivoSuministros peticion = new ActivoSuministros();
		
		if(dtoActivoSuministros != null) {
			if(dtoActivoSuministros.getIdActivo() == null) {
				throw new JsonViewerException("Error al crear el suministro.");
			}else {
				Activo activo = genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getIdActivo()));
				peticion.setActivo(activo);
			}
			
			if(!Checks.esNulo(dtoActivoSuministros.getTipoSuministro())) {
				peticion.setTipoSuministro(genericDao.get(DDTipoSuministro.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getTipoSuministro())));
			}
			if(!Checks.esNulo(dtoActivoSuministros.getSubtipoSuministro())) {
				peticion.setSubtipoSuministro(genericDao.get(DDSubtipoSuministro.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getSubtipoSuministro())));
			}
			if(!Checks.esNulo(dtoActivoSuministros.getCompaniaSuministro())) {
				peticion.setCompaniaSuministro(genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getCompaniaSuministro())));
			}
			if(!Checks.esNulo(dtoActivoSuministros.getDomiciliado())) {
				peticion.setDomiciliado(genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getDomiciliado())));
			}
			if(!Checks.esNulo(dtoActivoSuministros.getNumContrato())) {
				peticion.setNumContrato(dtoActivoSuministros.getNumContrato());
			}
			if(!Checks.esNulo(dtoActivoSuministros.getNumCups())) {
				peticion.setNumCups(dtoActivoSuministros.getNumCups());
			}
			if(!Checks.esNulo(dtoActivoSuministros.getPeriodicidad())) {
				peticion.setPeriodicidad(genericDao.get(DDPeriodicidad.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getPeriodicidad())));
			}
			if(!Checks.esNulo(dtoActivoSuministros.getFechaAlta())) {
				peticion.setFechaAlta(dtoActivoSuministros.getFechaAlta());
			}
			if(!Checks.esNulo(dtoActivoSuministros.getMotivoAlta())) {
				peticion.setMotivoAlta(genericDao.get(DDMotivoAltaSuministro.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getMotivoAlta())));
			}
			if(!Checks.esNulo(dtoActivoSuministros.getFechaBaja())) {
				peticion.setFechaBaja(dtoActivoSuministros.getFechaBaja());
			}
			if(!Checks.esNulo(dtoActivoSuministros.getMotivoBaja())) {
				peticion.setMotivoBaja(genericDao.get(DDMotivoBajaSuministro.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getMotivoBaja())));
			}
			if(!Checks.esNulo(dtoActivoSuministros.getValidado())) {
				peticion.setValidado(genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getValidado())));
			}
			
			genericDao.save(ActivoSuministros.class, peticion);

			return true;
		}
		
		return false;
	}

	@Override
	@Transactional
	public Boolean updateSaneamientoAgenda(SaneamientoAgendaDto saneamientoAgendaDto) {

		if (saneamientoAgendaDto != null && saneamientoAgendaDto.getObservaciones() != null) {
			ActivoAgendaSaneamiento agendaSaneamiento = genericDao.get(ActivoAgendaSaneamiento.class,
					genericDao.createFilter(FilterType.EQUALS, "id", saneamientoAgendaDto.getIdSan()));

			ActivoObservacion activoObservacion = agendaSaneamiento.getActivoObservacion();

			agendaSaneamiento.setObservaciones(saneamientoAgendaDto.getObservaciones());
			activoObservacion.setObservacion(saneamientoAgendaDto.getObservaciones());

			genericDao.update(ActivoAgendaSaneamiento.class, agendaSaneamiento);
			genericDao.update(ActivoObservacion.class, activoObservacion);

			return true;
		}

		return false;
	}
	
	@Override
	@Transactional
	public Boolean updateSuministroActivo(DtoActivoSuministros dtoActivoSuministros) throws ParseException {
		
		ActivoSuministros peticion = null;
		
		if(dtoActivoSuministros != null) {
			if(Checks.esNulo(dtoActivoSuministros.getIdSuministro())) {
				throw new JsonViewerException("Error al actualizar el suministro.");
			}else {
				peticion = genericDao.get(ActivoSuministros.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dtoActivoSuministros.getIdSuministro())));
			
				if(peticion != null) {
					if(!Checks.esNulo(dtoActivoSuministros.getTipoSuministro())) {
						peticion.setTipoSuministro(genericDao.get(DDTipoSuministro.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getTipoSuministro())));
					}
					if(!Checks.esNulo(dtoActivoSuministros.getSubtipoSuministro())) {
						peticion.setSubtipoSuministro(genericDao.get(DDSubtipoSuministro.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getSubtipoSuministro())));
					}
					if(!Checks.esNulo(dtoActivoSuministros.getCompaniaSuministro())) {
						peticion.setCompaniaSuministro(genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getCompaniaSuministro())));
					}
					if(!Checks.esNulo(dtoActivoSuministros.getDomiciliado())) {
						peticion.setDomiciliado(genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getDomiciliado())));
					}
					if(!Checks.esNulo(dtoActivoSuministros.getNumContrato())) {
						peticion.setNumContrato(dtoActivoSuministros.getNumContrato());
					}
					if(!Checks.esNulo(dtoActivoSuministros.getNumCups())) {
						peticion.setNumCups(dtoActivoSuministros.getNumCups());
					}
					if(!Checks.esNulo(dtoActivoSuministros.getPeriodicidad())) {
						peticion.setPeriodicidad(genericDao.get(DDPeriodicidad.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getPeriodicidad())));
					}
					if(!Checks.esNulo(dtoActivoSuministros.getFechaAlta())) {
						peticion.setFechaAlta(dtoActivoSuministros.getFechaAlta());
					}
					if(!Checks.esNulo(dtoActivoSuministros.getMotivoAlta())) {
						peticion.setMotivoAlta(genericDao.get(DDMotivoAltaSuministro.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getMotivoAlta())));
					}
					if(!Checks.esNulo(dtoActivoSuministros.getFechaBaja())) {
						peticion.setFechaBaja(dtoActivoSuministros.getFechaBaja());
					}
					if(!Checks.esNulo(dtoActivoSuministros.getMotivoBaja())) {
						peticion.setMotivoBaja(genericDao.get(DDMotivoBajaSuministro.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getMotivoBaja())));
					}
					if(!Checks.esNulo(dtoActivoSuministros.getValidado())) {
						peticion.setValidado(genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoSuministros.getValidado())));
					}
					
					genericDao.save(ActivoSuministros.class, peticion);
					
					return true;
				}
			}
		}
		
		return false;
	}

	@Override
	@Transactional
	public Boolean crearEstadoAdmision(String activoId, String codEstadoAdmision, String codSubestadoAdmision,
			String observaciones) {
		try {
			Long idActivo = Long.parseLong(activoId);
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Filter filtroEstadoAdmision = genericDao.createFilter(FilterType.EQUALS, "codigo", codEstadoAdmision);

			DDEstadoAdmision estadoAdmision = genericDao.get(DDEstadoAdmision.class, filtroBorrado,
					filtroEstadoAdmision);
			DDSubestadoAdmision subestadoAdmision = null;
			Activo activo = get(idActivo);

			if (codSubestadoAdmision != null) {

				Filter filtroSubestadoAdmision = genericDao.createFilter(FilterType.EQUALS, "codigo",
						codSubestadoAdmision);
				subestadoAdmision = genericDao.get(DDSubestadoAdmision.class, filtroBorrado, filtroSubestadoAdmision);
				
			}

			ActivoAgendaEvolucion agendaEvolucion;

			activo.setEstadoAdmision(estadoAdmision);
			agendaEvolucion = new ActivoAgendaEvolucion();
			agendaEvolucion.setActivo(activo);
			agendaEvolucion.setEstadoAdmision(estadoAdmision);
			activo.setSubestadoAdmision(subestadoAdmision);
			agendaEvolucion.setSubEstadoAdmision(subestadoAdmision);
			agendaEvolucion.setFechaAgendaEv(new Date());
			agendaEvolucion.setUsuarioId(adapter.getUsuarioLogado());
			agendaEvolucion.setObservaciones(observaciones);
			genericDao.save(ActivoAgendaEvolucion.class, agendaEvolucion);

			genericDao.update(Activo.class, activo);

			return true;
		} catch (Exception e) {
			logger.error("Error en activoManager", e);
			return false;
		}

	}

	@Transactional
	@Override
	public Boolean deleteActivoComplementoTitulo(DtoActivoComplementoTitulo cargaDto) {
		if (cargaDto.getId() != null) {
			genericDao.deleteById(ActivoComplementoTitulo.class, cargaDto.getId());

			return true;
		}

		return false;
	}

	@Transactional
	@Override
	public Boolean updateActivoComplementoTitulo(DtoActivoComplementoTitulo cargaDto) {
		
		ActivoComplementoTitulo act = null;

		if (cargaDto != null) {

			act = genericDao.get(ActivoComplementoTitulo.class,
					genericDao.createFilter(FilterType.EQUALS, "id", cargaDto.getId()));

			if (act != null) {
				if (cargaDto.getTipoTitulo() != null) {
					DDTipoTituloComplemento ddTipo = genericDao.get(DDTipoTituloComplemento.class, genericDao
							.createFilter(FilterType.EQUALS, "codigo", cargaDto.getTipoTitulo()));
					act.setTituloComplemento(ddTipo);
				}

				if (cargaDto.getFechaSolicitud() != null) {
					act.setFechaSolicitud(cargaDto.getFechaSolicitud());
				}

				if (cargaDto.getFechaTitulo() != null) {
					act.setFechaComplementoTitulo(cargaDto.getFechaTitulo());
				}

				if (cargaDto.getFechaRecepcion() != null) {
					act.setFechaRecepcion(cargaDto.getFechaRecepcion());
				}
				
				if (cargaDto.getFechaInscripcion() != null) {
					act.setFechaInscripcion(cargaDto.getFechaInscripcion());
				}

				if (cargaDto.getObservaciones() != null) {
					act.setObservaciones(cargaDto.getObservaciones());
				}

				genericDao.save(ActivoComplementoTitulo.class, act);

				return true;
			}
		}

		return false;
	}

	@Override
	public List<DtoActivoComplementoTitulo> getListComplementoTituloById(Long id) {
		List<DtoActivoComplementoTitulo> listDto = new ArrayList<DtoActivoComplementoTitulo>();
		
		if (id != null) {			
			List<ActivoComplementoTitulo> act = genericDao.getListOrdered(ActivoComplementoTitulo.class,
					new Order(OrderType.DESC, "fechaAlta"), 
					genericDao.createFilter(FilterType.EQUALS, "activo.id", id));
			
			
			

			if (act != null && !act.isEmpty()) {
				for (ActivoComplementoTitulo cTitulo : act) {
					DtoActivoComplementoTitulo dto = new DtoActivoComplementoTitulo();

					dto.setActivoId(id);
					dto.setId(cTitulo.getId());

					if (cTitulo.getFechaAlta() != null) {
						dto.setFechaAlta(cTitulo.getFechaAlta());
					}

					if (cTitulo.getGestorAlta() != null) {
						dto.setGestorAlta(cTitulo.getGestorAlta().getUsername());
					}

					if (cTitulo.getTituloComplemento() != null) {
						dto.setTipoTitulo(cTitulo.getTituloComplemento().getDescripcion());
					}

					if (cTitulo.getFechaSolicitud() != null) {
						dto.setFechaSolicitud(cTitulo.getFechaSolicitud());
					}

					if (cTitulo.getFechaComplementoTitulo() != null) {
						dto.setFechaTitulo(cTitulo.getFechaComplementoTitulo());
					}

					if (cTitulo.getFechaRecepcion() != null) {
						dto.setFechaRecepcion(cTitulo.getFechaRecepcion());
					}

					if (cTitulo.getFechaInscripcion() != null) {
						dto.setFechaInscripcion(cTitulo.getFechaInscripcion());
					}

					if (cTitulo.getObservaciones() != null) {
						dto.setObservaciones(cTitulo.getObservaciones());
					}
					listDto.add(dto);
				}
			}

		}

		return listDto;
	}

	@Transactional
	@Override
	public Boolean createComplementoTitulo(String activoId, String codTitulo, String fechaSolicitud,
			String fechaTitulo, String fechaRecepcion, String fechaInscripcion, String observaciones) {
		
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaSolicitudF = null;
		Date fechaTituloF = null;
		Date fechaRecepcionF = null;
		Date fechaInscripcionF = null;
		
		
		try {			
			if(fechaSolicitud != null && !fechaSolicitud.isEmpty())
				fechaSolicitudF = df.parse(df.format(ft.parse(fechaSolicitud)));
			
			if(fechaTitulo != null && !fechaTitulo.isEmpty())
				fechaTituloF = df.parse(df.format(ft.parse(fechaTitulo)));
			
			if(fechaRecepcion != null && !fechaRecepcion.isEmpty())
				fechaRecepcionF = df.parse(df.format(ft.parse(fechaRecepcion)));
			
			if(fechaInscripcion != null && !fechaInscripcion.isEmpty())
				fechaInscripcionF = df.parse(df.format(ft.parse(fechaInscripcion)));
					
			Long idActivo = Long.parseLong(activoId);
			
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Filter filtroCodTitulo = genericDao.createFilter(FilterType.EQUALS, "codigo", codTitulo);
			
			DDTipoTituloComplemento ddt =  genericDao.get(DDTipoTituloComplemento.class, filtroBorrado,
					filtroCodTitulo);
			Activo activo = get(idActivo);
			ActivoComplementoTitulo activoComTitulo = new ActivoComplementoTitulo();
			
			activoComTitulo.setActivo(activo);
			activoComTitulo.setTituloComplemento(ddt);
			activoComTitulo.setFechaSolicitud(fechaSolicitudF);
			activoComTitulo.setFechaComplementoTitulo(fechaTituloF);
			activoComTitulo.setFechaRecepcion(fechaRecepcionF);
			activoComTitulo.setFechaInscripcion(fechaInscripcionF);
			activoComTitulo.setObservaciones(observaciones);
			activoComTitulo.setFechaAlta(df.parse(df.format(new Date())));
			activoComTitulo.setGestorAlta(adapter.getUsuarioLogado());
			
			genericDao.save(ActivoComplementoTitulo.class, activoComTitulo);
			
			return true;
		} catch (Exception e) {
			logger.error("Error en activoManager", e);
			return false;
		}
	}
	
	
	@Transactional
	@Override
	public Boolean destroyDeudorById(DtoActivoDeudoresAcreditados dto) {
		if (!Checks.esNulo(dto.getId())) {
			genericDao.deleteById(ActivoDeudoresAcreditados.class, Long.valueOf(dto.getId()));
			return true;
		}

		return false;
	}
	

	@Transactional
	@Override
	public Boolean updateDeudorAcreditado(DtoActivoDeudoresAcreditados dto) {
		
		ActivoDeudoresAcreditados act = null;

		if (dto != null) {
			act = genericDao.get(ActivoDeudoresAcreditados.class,
					genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));

			if (act != null) {
				if (dto.getTipoDocIdentificativoDesc() != null) {
					DDTipoDeDocumento ddTipo = genericDao.get(DDTipoDeDocumento.class, genericDao
							.createFilter(FilterType.EQUALS, "codigo", dto.getTipoDocIdentificativoDesc()));
					act.setTipoDocumento(ddTipo);
				}
				if(dto.getDocIdentificativo()!=null) {
					act.setNumeroDocumentoDeudor(dto.getDocIdentificativo());
				}

				if (dto.getNombre() != null) {
					act.setNombreDeudor(dto.getNombre());
				}

				if (dto.getApellido1()!= null) {
					act.setApellido1Deudor(dto.getApellido1());
				}
				if (dto.getApellido2()!= null) {
					act.setApellido2Deudor(dto.getApellido2());
				}
				
				genericDao.save(ActivoDeudoresAcreditados.class, act);

				return true;
			}
		}
		
		return false;
	}

	@Override
	public List<DtoGastoAsociadoAdquisicion> getListGastosAsociadosAdquisicion(Long id) {
		List<DtoGastoAsociadoAdquisicion> listDto = new ArrayList<DtoGastoAsociadoAdquisicion>();
		
		if (id != null) {
			
			List<GastoAsociadoAdquisicion> act = genericDao.getListOrdered(GastoAsociadoAdquisicion.class,
					new Order(OrderType.DESC, "fechaAltaGastoAsociado"), 
					genericDao.createFilter(FilterType.EQUALS, "activo.id", id));

			if (act != null && !act.isEmpty()) {
				for (GastoAsociadoAdquisicion gaa : act) {
					DtoGastoAsociadoAdquisicion dto = new DtoGastoAsociadoAdquisicion();

					dto.setActivo(id);
					dto.setId(gaa.getId());
					
					if(gaa.getGastoAsociado() != null) {
						dto.setGastoAsociado(gaa.getGastoAsociado().getDescripcion());
					}
					
					if(gaa.getUsuarioGestordeAlta() != null) {
						dto.setUsuarioGestordeAlta(gaa.getUsuarioGestordeAlta().getUsername());
					}
					
					if (gaa.getFechaAltaGastoAsociado() != null) {
						dto.setFechaAltaGastoAsociado(gaa.getFechaAltaGastoAsociado());
					}

					if (gaa.getFechaSolicitudGastoAsociado() != null) {
						dto.setFechaSolicitudGastoAsociado(gaa.getFechaSolicitudGastoAsociado());
					}

					if (gaa.getFechaPagoGastoAsociado() != null) {
						dto.setFechaPagoGastoAsociado(gaa.getFechaPagoGastoAsociado());
					}

					if (gaa.getImporte() != null) {
						dto.setImporte(gaa.getImporte());
					}

					if (gaa.getObservaciones() != null) {
						dto.setObservaciones(gaa.getObservaciones());
					}
					if(gaa.getFactura() != null) {
						dto.setIdFactura(gaa.getFactura().getId());
						dto.setFactura(gaa.getFactura().getNombreAdjuntoGastoAsociado());
						dto.setTipoFactura(gaa.getFactura().getTipoDocumentoGastoAsociado().getDescripcion().replace("Factura gasto Admision", "F.G.A."));
					}
					
					listDto.add(dto);
				}
			}

		}

		return listDto;
	}
	
	@Transactional
	@Override
	public Boolean deleteGastoAsociadoAdquisicion(DtoGastoAsociadoAdquisicion cargaDto) {
		if (cargaDto.getId() != null) {
			genericDao.deleteById(GastoAsociadoAdquisicion.class, cargaDto.getId());
			return true;
		}

		return false;
	}

	@Transactional
	@Override
	public Boolean updateGastoAsociadoAdquisicion(DtoGastoAsociadoAdquisicion cargaDto) {
		GastoAsociadoAdquisicion gas = null;

		if (cargaDto != null) {

			gas = genericDao.get(GastoAsociadoAdquisicion.class,
					genericDao.createFilter(FilterType.EQUALS, "id", cargaDto.getId()));

			if (gas != null) {
				if (cargaDto.getGastoAsociado() != null) {
					DDTipoGastoAsociado ddTipo = genericDao.get(DDTipoGastoAsociado.class, genericDao
							.createFilter(FilterType.EQUALS, "codigo", cargaDto.getGastoAsociado()));
					gas.setGastoAsociado(ddTipo);
				}

				if (cargaDto.getFechaSolicitudGastoAsociado() != null) {
					gas.setFechaSolicitudGastoAsociado(cargaDto.getFechaSolicitudGastoAsociado());
				}

				if (cargaDto.getFechaPagoGastoAsociado() != null) {
					gas.setFechaPagoGastoAsociado(cargaDto.getFechaPagoGastoAsociado());
				}

				if (cargaDto.getImporte() != null) {
					gas.setImporte(cargaDto.getImporte());
				}

				if (cargaDto.getObservaciones() != null) {
					gas.setObservaciones(cargaDto.getObservaciones());
				}

				genericDao.save(GastoAsociadoAdquisicion.class, gas);

				return true;
			}
		}

		return false;
	}



	@Transactional
	@Override
	public Boolean createGastoAsociadoAdquisicion(String activoId, String gastoAsociado,
			String fechaSolicitudGastoAsociado, String fechaPagoGastoAsociado, String importe,
			String observaciones) {
		
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		String importeSinComas = importe.replaceAll(",", ".");
		
		try {			
			Date fechaSolicitudF = ft.parse(fechaSolicitudGastoAsociado);
			Date fechaPagoF = ft.parse(fechaPagoGastoAsociado);
					
			Long idActivo = Long.parseLong(activoId);
			
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Filter filtroCodGasto = genericDao.createFilter(FilterType.EQUALS, "codigo", gastoAsociado);
			DDTipoGastoAsociado ddt =  genericDao.get(DDTipoGastoAsociado.class, filtroBorrado,
					filtroCodGasto);

			Activo activo = get(idActivo);
			
			GastoAsociadoAdquisicion gasto = new GastoAsociadoAdquisicion();
			
			gasto.setActivo(activo);
			gasto.setGastoAsociado(ddt);
			if(fechaSolicitudGastoAsociado != null)
				gasto.setFechaSolicitudGastoAsociado(df.parse(df.format(fechaSolicitudF)));
			if(fechaPagoGastoAsociado != null)
				gasto.setFechaPagoGastoAsociado(df.parse(df.format(fechaPagoF)));
			gasto.setObservaciones(observaciones);
			gasto.setFechaAltaGastoAsociado(df.parse(df.format(new Date())));
			gasto.setUsuarioGestordeAlta(adapter.getUsuarioLogado());
			gasto.setImporte(Double.parseDouble(importeSinComas));
			genericDao.save(GastoAsociadoAdquisicion.class, gasto);

			return true;
		} catch (Exception e) {
			logger.error("Error en activoManager", e);
			return false;
		}
	}
	
	@Transactional
	@Override
	public Boolean createDeudorAcreditado(Long idEntidad, String docIdentificativo,
			String nombre, String apellido1, String apellido2, String tipoDocIdentificativoDesc) {
		
		try {					
			
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);			
			Filter filtroCodTipoDocIdentif = genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDocIdentificativoDesc);
			DDTipoDeDocumento ddt =  genericDao.get(DDTipoDeDocumento.class, filtroBorrado,
					filtroCodTipoDocIdentif);
			Activo activo = get(idEntidad);
			ActivoDeudoresAcreditados actDeudores = new ActivoDeudoresAcreditados();
			if(activo!=null) {
				actDeudores.setActivo(activo);
				
			}
			actDeudores.setFechaAlta(new Date());
			actDeudores.setUsuario(adapter.getUsuarioLogado());
		
			if(tipoDocIdentificativoDesc!=null) {
				actDeudores.setTipoDocumento(ddt);
			}
			if(docIdentificativo!=null) {
				actDeudores.setNumeroDocumentoDeudor(docIdentificativo);
			}
			if(nombre!=null && !nombre.isEmpty()) {
				actDeudores.setNombreDeudor(nombre);
			}
			if(apellido1!=null && !apellido1.isEmpty()) {
				actDeudores.setApellido1Deudor(apellido1);
			}
			if(apellido2!=null && !apellido2.isEmpty()) {
				actDeudores.setApellido2Deudor(apellido2);
			}
			genericDao.save(ActivoDeudoresAcreditados.class, actDeudores);
			
			return true;
		} catch (Exception e) {
			logger.error("Error en activoManager", e);
			return false;
		}
	}
	
	@Override
	public boolean isActivoExisteEnRem(Long idActivo) {
		return activoDao.existeActivo(idActivo);
	}

	@Override
	@Transactional
	public Boolean deleteSuministroActivo(DtoActivoSuministros dtoActivoSuministros) throws ParseException {
		
		ActivoSuministros peticion = null;
		
		if(dtoActivoSuministros != null) {
			if(Checks.esNulo(dtoActivoSuministros.getIdSuministro())) {
				throw new JsonViewerException("Error al borrar el suministro.");
			}else {
				peticion = genericDao.get(ActivoSuministros.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dtoActivoSuministros.getIdSuministro())));
				
				if(peticion != null) {
					Auditoria.delete(peticion);
					
					genericDao.update(ActivoSuministros.class, peticion);
					
					return true;
				}
			}
		}

		return false;
	}

	@Override
	@BusinessOperationDefinition("activoManager.getFileItemOfertante")
	public FileItem getFileItemOfertante(DtoAdjunto dtoAdjunto, AdjuntoComprador adjuntoComprador) {
		
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
	public List<DtoHistoricoOcupadoTitulo> getListHistoricoOcupadoTitulo(Long id) {
		List<DtoHistoricoOcupadoTitulo> listDto = new ArrayList<DtoHistoricoOcupadoTitulo>();
		
		if (id != null) {
			
			List<HistoricoOcupadoTitulo> act = genericDao.getList(HistoricoOcupadoTitulo.class,
					genericDao.createFilter(FilterType.EQUALS, "activo.id", id));

			if (act != null && !act.isEmpty()) {
				for (HistoricoOcupadoTitulo hot : act) {
					DtoHistoricoOcupadoTitulo dto = new DtoHistoricoOcupadoTitulo();

					//dto.getId(id);
					dto.setId(hot.getId());
					
					if (hot.getOcupado() != null) {
						if(hot.getOcupado() == 0){
							dto.setOcupado("No");
						}else{
							dto.setOcupado("Si");
						}
						
					}
					
					if (hot.getConTitulo() != null) {
						if (DDTipoTituloActivoTPA.tipoTituloSi.equals(hot.getConTitulo().getCodigo())){
							dto.setConTitulo(DESC_SI);
						}else if(DDTipoTituloActivoTPA.tipoTituloNo.equals(hot.getConTitulo().getCodigo())) {
							dto.setConTitulo(DESC_NO);
						}else if(DDTipoTituloActivoTPA.tipoTituloNoConIndicios.equals(hot.getConTitulo().getCodigo())) {
							dto.setConTitulo(DESC_NO_CON_INDICIOS);
						}						
					}
					
					if (hot.getFechaHoraAlta() != null) {
						dto.setFechaAlta(hot.getFechaHoraAlta());
						dto.setHoraAlta(hot.getFechaHoraAlta().getHours()+":"+hot.getFechaHoraAlta().getMinutes());
					}

					if (hot.getUsuario() != null) {
						dto.setUsuarioAlta(hot.getUsuario().getUsername());
					}

					if (hot.getLugarModificacion() != null) {
						dto.setLugarModificacion(hot.getLugarModificacion());
					}
					
					
					listDto.add(dto);
				}
			}

		}

		return listDto;
	}

	@Override
	public void updateHonorarios(Activo activo, List<ActivoOferta> listaActivoOfertas) {

		try {

			if (listaActivoOfertas != null && listaActivoOfertas.size() > 0) {

				for (ActivoOferta activoOferta : listaActivoOfertas) {

					Oferta oferta = activoOferta.getPrimaryKey().getOferta();

					if (oferta != null && oferta.getEstadoOferta() != null
							&& DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {

						ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class,
								genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId()));

						if (expediente != null && expediente.getEstado() != null
								&& !DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())) {

							 //ofertaApi.calculaHonorario(oferta, activo);
							 
							 expedienteComercialApi.actualizarGastosExpediente(expediente,oferta,activo);
							 
						}
					}

				}

			}

		} catch (Exception e) {
			logger.error("Error en updateHonorarios", e);
		}

	}
	
	@Override
	public List<DDDistritoCaixa> getComboTipoDistritoByCodPostal(String codPostal) {		
		List<DDDistritoCaixa> tiposDistritoCaixa = new ArrayList<DDDistritoCaixa>();		
		List<CodigoPostalDistrito> listaAux = genericDao.getList(CodigoPostalDistrito.class, genericDao.createFilter(FilterType.EQUALS,"codigoPostal", codPostal));		
		if (listaAux != null) {
			for (CodigoPostalDistrito codigoPostalDistrito : listaAux) {				
				if (codigoPostalDistrito.getDistritoCaixa() != null) {
					tiposDistritoCaixa.add(codigoPostalDistrito.getDistritoCaixa());
				}
			}
		}		
		return tiposDistritoCaixa;
	}

	@Override
	public boolean isIfNecesarioActivo(Activo activo) {
		boolean resultado = false;
		if (this.isIfNecesarioActivoByCartera(activo) && activo.getTipoActivo() != null) {
			String codTipoActivo = activo.getTipoActivo().getCodigo();
			if (this.isIfNecesarioActivoByTipoActivo(activo, codTipoActivo)) {
				resultado = true;
			}else if(this.isIfNecesarioActivoByTipoActivoAndEstadoActivo(activo, codTipoActivo)) {
				resultado = true;
			}
		}			
		return resultado;	
	}
	
	private boolean isIfNecesarioActivoByCartera(Activo activo) {
		if (activo.getCartera() == null) {
			return false;
		}
		String codigoCartera = activo.getCartera().getCodigo();
		if (DDCartera.CODIGO_CARTERA_SAREB.equals(codigoCartera) 
				|| (DDCartera.CODIGO_CARTERA_BBVA.equals(codigoCartera))
				|| (DDCartera.CODIGO_CARTERA_BANKIA.equals(codigoCartera))
				|| (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codigoCartera))
				|| (DDCartera.CODIGO_CARTERA_LIBERBANK.equals(codigoCartera))) {
			return true;
		}
		return false;
	}
	
	private boolean isIfNecesarioActivoByTipoActivo(Activo activo, String codTipoActivo) {
		if (activo.getSubtipoActivo() == null) {
			return false;
		}
		String codSubtipoActivo = activo.getSubtipoActivo().getCodigo();
		if (DDTipoActivo.COD_SUELO.equals(codTipoActivo) || (DDTipoActivo.COD_COMERCIAL.equals(codTipoActivo))
			||	(DDTipoActivo.COD_INDUSTRIAL.equals(codTipoActivo)) || (DDTipoActivo.COD_EDIFICIO_COMPLETO.equals(codTipoActivo)
			&& (DDSubtipoActivo.CODIGO_SUBTIPO_OFICINA_EDIFICIO_COMPLETO.equals(codSubtipoActivo)
			|| DDSubtipoActivo.CODIGO_SUBTIPO_RESIDENCIAL_VIVIENDAS_LOCALES_TRASTEROS_GARAJES.equals(codSubtipoActivo)))) {
			return true;
		}
		return false; 
	}
	
	private boolean isIfNecesarioActivoByTipoActivoAndEstadoActivo(Activo activo, String codTipoActivo) {
		if (activo.getEstadoActivo() == null) {
			return false;
		}
		String codEstadoActivo = activo.getEstadoActivo().getCodigo();
		if (DDTipoActivo.COD_VIVIENDA.equals(codTipoActivo)
			&& (DDEstadoActivo.ESTADO_ACTIVO_TERMINADO.equals(codEstadoActivo)
				||	DDEstadoActivo.ESTADO_ACTIVO_EN_CONSTRUCCION_PARADA.equals(codEstadoActivo))
				||  DDEstadoActivo.ESTADO_ACTIVO_EN_CONSTRUCCION_EN_CURSO.equals(codEstadoActivo)	
				||  DDEstadoActivo.ESTADO_ACTIVO_RUINA.equals(codEstadoActivo)) {
			return true;
		}
		return false;
	}
	
	public List<VGridDescuentoColectivos> getDescuentoColectivos(Long id) throws Exception{
		
		List<VGridDescuentoColectivos> descuentoColectivos = new ArrayList<VGridDescuentoColectivos>();
		if (id != null) {
			descuentoColectivos = genericDao.getList(VGridDescuentoColectivos.class, genericDao.createFilter(FilterType.EQUALS, "activoId", id));
		}		
		return descuentoColectivos;
	}
	
	@Override
	public void rellenarIfNecesario(Activo activo) {		
		activo.setNecesidadIfActivo(this.isIfNecesarioActivo(activo));		
		genericDao.update(Activo.class, activo);
	}

	@Override
	public List<VPreciosVigentesCaixa> getPreciosVigentesCaixaById(Long id) {
		return activoAdapter.getPreciosVigentesCaixaById(id);
	}
	

	@Override
	public List<Activo> getActivosNoPrincipalesByIdAgrupacionAndActivoPrincipal(Long idAgrupacion, Long idActivoPrincipal){

		List<Activo> activos = activoDao.getActivosNoPrincipalesAgrupacion(idAgrupacion, idActivoPrincipal);
		
		return activos;
	}

	@Override
	public Page findTasaciones(DtoFiltroTasaciones dto) {
		return activoDao.findTasaciones(dto);
	}

	@Override
	@Transactional(readOnly = false)
	public void anyadirCanalDistribucionOfertaCaixa(Long idActivo, OfertaCaixa ofertaCaixa, String tipoOferta) {
		Filter filtroActivoCaixa = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		ActivoCaixa activoCaixa = genericDao.get(ActivoCaixa.class, filtroActivoCaixa);
		
		if (activoCaixa != null && ofertaCaixa != null && tipoOferta != null) {
			if(DDTipoOferta.CODIGO_VENTA.equals(tipoOferta)) {
				ofertaCaixa.setCanalDistribucionBc(activoCaixa.getCanalDistribucionVenta());
			} else if (DDTipoOferta.CODIGO_ALQUILER.equals(tipoOferta)
					|| DDTipoOferta.CODIGO_ALQUILER_NO_COMERCIAL.equals(tipoOferta)) {
				ofertaCaixa.setCanalDistribucionBc(activoCaixa.getCanalDistribucionAlquiler());
			}
		}
	}
}


package es.pfsgroup.plugin.rem.adapter;

import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.plugin.rem.model.dd.*;
import es.pfsgroup.plugin.rem.service.*;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTTipoGestorPropiedad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.agenda.adapter.NotificacionAdapter;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.DtoMetadatosEspecificos;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioContratoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAvisadorApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.PerfilApi;
import es.pfsgroup.plugin.rem.api.PresupuestoApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.clienteComercial.dao.ClienteComercialDao;
import es.pfsgroup.plugin.rem.comisionamiento.ComisionamientoApi;
import es.pfsgroup.plugin.rem.exception.RemUserException;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.factory.TabActivoFactoryApi;
import es.pfsgroup.plugin.rem.gestor.GestorExpedienteComercialManager;
import es.pfsgroup.plugin.rem.gestor.dao.GestorExpedienteComercialDao;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTramiteManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseOferta;
import es.pfsgroup.plugin.rem.model.dd.DDDescripcionFotoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDIdentificacionGestoria;
import es.pfsgroup.plugin.rem.model.dd.DDListaEmisiones;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenComprador;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDResponsableDocumentacionCliente;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDTareaDestinoSalto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalificacionEnergetica;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCargaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGastoAsociado;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoInfoComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoObservacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTasacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTenedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;
import es.pfsgroup.plugin.rem.model.dd.DDVinculoCaixa;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionC4C;
import es.pfsgroup.plugin.rem.model.dd.DDTipologiaVentaBc;
import es.pfsgroup.plugin.rem.oferta.NotificationOfertaManager;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PRINCIPAL;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PROPIEDAD;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.SITUACION;
import es.pfsgroup.plugin.rem.rest.dto.FileListResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.restclient.exception.UnknownIdException;
import es.pfsgroup.plugin.rem.thread.ConvivenciaRecovery;
import es.pfsgroup.plugin.rem.thread.EjecutarSPPublicacionAsincrono;
import es.pfsgroup.plugin.rem.trabajo.dao.TrabajoDao;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Service
public class ActivoAdapter {
	
	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoPatrimonioContratoDao actPatrimonioDao;

	@Autowired
	private UpdaterStateApi updaterState;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	@Autowired
	private TareaActivoApi tareaActivoApi;

	@Autowired
	private JBPMActivoTramiteManagerApi jbpmActivoTramiteManagerApi;

	@Autowired
	protected TipoProcedimientoManager tipoProcedimiento;

	@Autowired
	private ActivoAvisadorApi activoAvisadorApi;

	@Resource
	private Properties appProperties;

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private DownloaderFactoryApi downloaderFactoryApi;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private TabActivoFactoryApi tabActivoFactory;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private GestorDocumentalFotosApi gestorDocumentalFotos;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ProveedoresApi proveedoresApi;

	@Autowired
	private NotificationOfertaManager notificationOfertaManager;

    @Autowired
    private NotificacionAdapter notificacionAdapter;

    @Autowired 
    private GestorExpedienteComercialManager gestorExpedienteComercialManager;

    @Autowired
    private ActivoManager activoManager;

    @Autowired
    private ActivoTramiteDao activoTramiteDao;

	@Resource
	private MessageService messageServices;

	@Autowired
	private TrabajoDao trabajoDao;

	@Autowired
	private ActivoPatrimonioDao activoPatrimonio;

	@Autowired
	private GestorExpedienteComercialDao gestorExpedienteComercialDao;

	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private ClienteComercialDao clienteComercialDao;

	@Autowired
    private ActivoAgrupacionDao activoAgrupacionDao;

	@Autowired
	private PresupuestoApi presupuestoManager;
	
	@Autowired
	private ComisionamientoApi comisionamientoApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;

	@Autowired
	private ParticularValidatorApi particularValidatorApi;

	@Autowired
	private InterlocutorCaixaService interlocutorCaixaService;

	@Autowired
	private PerfilApi perfilApi;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	private static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";
	public static final String OFERTA_INCOMPATIBLE_MSG = "El tipo de oferta es incompatible con el destino comercial del activo";
	private static final String AVISO_TITULO_MODIFICADAS_CONDICIONES_JURIDICAS = "activo.aviso.titulo.modificadas.condiciones.juridicas";
	private static final String AVISO_DESCRIPCION_MODIFICADAS_CONDICIONES_JURIDICAS = "activo.aviso.descripcion.modificadas.condiciones.juridicas";
	private static final String UPDATE_ERROR_TRAMITES_PUBLI_ACTIVO ="No se han podido cerrar automaticamente los tr&aacute;mites asociados a los activos.";
	public static final String T_APROBACION_INFORME_COMERCIAL= "T011";
	public static final String CODIGO_ESTADO_PROCEDIMIENTO_EN_TRAMITE = "10";
	public static final String ERROR_CRM_UNKNOWN_ID = "UNKNOWN_ID";
	
	//Se añaden aqui tambien, ya que no se por que esta cogiendo el diccionario de gestores de un .class que no es editable, en vez del .java que si que lo es
	public static final String CODIGO_TIPO_GESTOR_COMERCIAL = "GCOM";
	public static final String CODIGO_SUPERVISOR_COMERCIAL = "SCOM";
	public static final String CODIGO_GESTOR_COMERCIAL_ALQUILER = "GESTCOMALQ";
	public static final String CODIGO_SUPERVISOR_COMERCIAL_ALQUILER = "SUPCOMALQ";
	
	private static final String T017_TRAMITE_BBVA_DESCRIPCION = "Trámite comercial de venta BBVA";
    private static final String CODIGO_TRAMITE_T017 = "T017";
    
    private static final String T017_TRAMITE_VENTA_DESCRIPCION = "Trámite comercial de venta";
	SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yy");

	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	protected static final Log logger = LogFactory.getLog(ActivoAdapter.class);


	public Activo getActivoById(Long id) {
		return activoApi.get(id);
	}

	@Transactional(readOnly = false)
	public boolean saveDistribucion(DtoDistribucion dtoDistribucion, Long idDistribucion) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idDistribucion);
		ActivoDistribucion activoDistribucion = genericDao.get(ActivoDistribucion.class, filtro);

		try {
			beanUtilNotNull.copyProperties(activoDistribucion, dtoDistribucion);
			if (dtoDistribucion.getTipoHabitaculoCodigo() != null) {
				DDTipoHabitaculo tipoHabitaculo = (DDTipoHabitaculo) proxyFactory.proxy(UtilDiccionarioApi.class)
						.dameValorDiccionarioByCod(DDTipoHabitaculo.class, dtoDistribucion.getTipoHabitaculoCodigo());

				activoDistribucion.setTipoHabitaculo(tipoHabitaculo);
			}
			genericDao.save(ActivoDistribucion.class, activoDistribucion);

		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter, saveDistribucion", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter, saveDistribucion", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean saveCatastro(DtoActivoCatastro dtoCatastro, Long idCatastro) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idCatastro);
		ActivoCatastro activoCatastro = genericDao.get(ActivoCatastro.class, filtro);

		try {
			beanUtilNotNull.copyProperties(activoCatastro, dtoCatastro);
			activoCatastro.setResultado(dtoCatastro.getResultadoSiNO());
			genericDao.save(ActivoCatastro.class, activoCatastro);
		
		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter, saveCatastro", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter, saveCatastro", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean saveFoto(DtoFoto dtoFoto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoFoto.getId());
		ActivoFoto activoFoto = genericDao.get(ActivoFoto.class, filtro);
		String descripcion  = null;
		boolean resultado = false;
		try {
			
			beanUtilNotNull.copyProperties(activoFoto, dtoFoto);
			if(!Checks.esNulo(dtoFoto.getOrden())) {
				activoFoto.setOrden(dtoFoto.getOrden());
			}
			if (dtoFoto.getCodigoDescripcionFoto() != null) {
				DDDescripcionFotoActivo ddDescripcionFoto = genericDao.get(DDDescripcionFotoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dtoFoto.getCodigoDescripcionFoto()));
				descripcion = ddDescripcionFoto.getDescripcion();
				activoFoto.setDescripcionFoto(ddDescripcionFoto);
				activoFoto.setDescripcion(descripcion);
			}

			if (gestorDocumentalFotos.isActive()) {
				PRINCIPAL principal = null;
				SITUACION situacion = null;
				if (dtoFoto.getPrincipal() != null) {
					if (dtoFoto.getPrincipal()) {
						principal = PRINCIPAL.SI;
					} else {
						principal = PRINCIPAL.NO;
					}
				}
				if (dtoFoto.getInteriorExterior() != null) {
					if (dtoFoto.getInteriorExterior()) {
						situacion = SITUACION.INTERIOR;
					} else {
						situacion = SITUACION.EXTERIOR;
					}
				}
				FileResponse fileReponse = gestorDocumentalFotos.update(activoFoto.getRemoteId(), dtoFoto.getNombre(),
						null, descripcion, principal, situacion, dtoFoto.getOrden());
				if (fileReponse.getError() != null && !fileReponse.getError().isEmpty()) {
					throw new RuntimeException(fileReponse.getError());
				}
			}
			
			genericDao.save(ActivoFoto.class, activoFoto);

		} catch (Exception e) {
			logger.error(e);
			resultado = false;
		}

		return resultado;

	}

	@Transactional(readOnly = false)
	public boolean saveOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal, Long idActivoOcupanteLegal) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idActivoOcupanteLegal);
		ActivoOcupanteLegal activoOcupanteLegal = genericDao.get(ActivoOcupanteLegal.class, filtro);

		try {
			beanUtilNotNull.copyProperties(activoOcupanteLegal, dtoOcupanteLegal);
			genericDao.save(ActivoOcupanteLegal.class, activoOcupanteLegal);

		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter, saveOcupanteLegal", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter, saveOcupanteLegal", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteDistribucion(DtoDistribucion dtoDistribucion, Long idDistribucion) {
		try {
			genericDao.deleteById(ActivoDistribucion.class, idDistribucion);
		} catch (Exception e) {
			logger.error("Error en ActivoAdapter, deleteDistribucion", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteCatastro(DtoActivoCatastro dtoCatastro, Long idCatastro) {
		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idCatastro);
			ActivoCatastro activoCatastro = genericDao.get(ActivoCatastro.class, filtro);
			if(activoCatastro != null){
				genericDao.deleteById(ActivoCatastro.class, activoCatastro.getId());
			}
			
		} catch (Exception e) {
			logger.error("Error en ActivoAdapter, deleteCatastro", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal, Long idActivoOcupanteLegal) {
		try {
			genericDao.deleteById(ActivoOcupanteLegal.class, idActivoOcupanteLegal);
		} catch (Exception e) {
			logger.error("Error en ActivoAdapter, deleteOcupanteLegal", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteObservacion(Long idObservacion) {
		try {
			genericDao.deleteById(ActivoObservacion.class, idObservacion);

		} catch (Exception e) {
			logger.error("Error en ActivoAdapter, deleteObservacion", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean saveObservacion(DtoObservacion dtoObservacion) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoObservacion.getId()));
		ActivoObservacion activoObservacion = genericDao.get(ActivoObservacion.class, filtro);

		try {
			beanUtilNotNull.copyProperties(activoObservacion, dtoObservacion);
			if(dtoObservacion.getTipoObservacionCodigo() != null) {
				DDTipoObservacionActivo tipoObservacion = (DDTipoObservacionActivo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoObservacionActivo.class,
						dtoObservacion.getTipoObservacionCodigo());
				if(tipoObservacion != null) {
					activoObservacion.setTipoObservacion(tipoObservacion);
				}
			}
			genericDao.save(ActivoObservacion.class, activoObservacion);

		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter, saveObservacionesActivo", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter, saveObservacionesActivo", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createObservacion(DtoObservacion dtoObservacion, Long idActivo) {
		ActivoObservacion activoObservacion = new ActivoObservacion();
		Activo activo = activoApi.get(idActivo);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		try {
			activoObservacion.setObservacion(dtoObservacion.getObservacion());
			activoObservacion.setFecha(new Date());
			activoObservacion.setUsuario(usuarioLogado);
			activoObservacion.setActivo(activo);

			if(dtoObservacion.getTipoObservacionCodigo() != null) {
				DDTipoObservacionActivo tipoObservacion = (DDTipoObservacionActivo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoObservacionActivo.class, dtoObservacion.getTipoObservacionCodigo());
				if(tipoObservacion != null) {
					activoObservacion.setTipoObservacion(tipoObservacion);
				}
			}

			genericDao.save(ActivoObservacion.class, activoObservacion);
		} catch (Exception e) {
			logger.error("Error en ActivoAdapter, createObservacionesActivo", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createCondicionHistorico(DtoCondicionHistorico dtoCondicionHistorico, Long idActivo) {

		ActivoCondicionEspecifica activoCondicionEspecifica = new ActivoCondicionEspecifica();
		Activo activo = activoApi.get(idActivo);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		try {
			activoCondicionEspecifica.setFechaDesde(dtoCondicionHistorico.getFechaAlta());
			activoCondicionEspecifica.setUsuarioAlta(usuarioLogado);
			activoCondicionEspecifica.setTexto(dtoCondicionHistorico.getCondicion());
			activoCondicionEspecifica.setActivo(activo);

			genericDao.save(ActivoCondicionEspecifica.class, activoCondicionEspecifica);
		} catch (Exception e) {
			logger.error("Error en ActivoAdapter, createCondicionHistorico", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createDistribucion(DtoDistribucion dtoDistribucion, Long idActivo) {
		ActivoDistribucion activoDistribucion = new ActivoDistribucion();
		Activo activo = activoApi.get(idActivo);
		ActivoInfoComercial infoComercial = activo.getInfoComercial();

		try {
			beanUtilNotNull.copyProperties(activoDistribucion, dtoDistribucion);
			if (dtoDistribucion.getTipoHabitaculoCodigo() != null) {
				DDTipoHabitaculo tipoHabitaculo = (DDTipoHabitaculo) proxyFactory.proxy(UtilDiccionarioApi.class)
						.dameValorDiccionarioByCod(DDTipoHabitaculo.class, dtoDistribucion.getTipoHabitaculoCodigo());

				activoDistribucion.setTipoHabitaculo(tipoHabitaculo);
			}
			activoDistribucion.setInfoComercial(infoComercial);
			ActivoDistribucion distribucionNueva = genericDao.save(ActivoDistribucion.class, activoDistribucion);

			if(activo.getInfoComercial() != null) {
				if(activo.getInfoComercial().getTipoInfoComercial() != null) {
					ActivoVivienda vivTemp = genericDao.get(ActivoVivienda.class, genericDao.createFilter(FilterType.EQUALS, "informeComercial.id", activo.getInfoComercial().getId()));
					if(DDTipoInfoComercial.COD_VIVIENDA.equals(activo.getInfoComercial().getTipoInfoComercial().getCodigo()) || vivTemp != null) {					
						activo.getInfoComercial().getDistribucion().add(distribucionNueva);						
					}
				}
			}			
			activoApi.saveOrUpdate(activo);
		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter, createDistribucion", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter, createDistribucion", e);
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean createCatastro(DtoActivoCatastro dtoCatastro, Long idActivo) {
		ActivoCatastro activoCatastro = new ActivoCatastro();
		Activo activo = activoApi.get(idActivo);

		try {
			beanUtilNotNull.copyProperties(activoCatastro, dtoCatastro);
			BeanUtils.copyProperty(activoCatastro, "resultadoSiNO", dtoCatastro.getResultadoSiNO());

			activoCatastro.setActivo(activo);
			activoCatastro.setResultado(dtoCatastro.getResultadoSiNO());
			ActivoCatastro catastroNuevo = genericDao.save(ActivoCatastro.class, activoCatastro);

			activo.getCatastro().add(catastroNuevo);
			activoApi.saveOrUpdate(activo);

		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter, createCatastro", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter, createCatastro", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal, Long idActivo) {
		ActivoOcupanteLegal activoOcupanteLegal = new ActivoOcupanteLegal();
		Activo activo = activoApi.get(idActivo);
		ActivoSituacionPosesoria situacionPosesoria = activo.getSituacionPosesoria();

		try {
			beanUtilNotNull.copyProperties(activoOcupanteLegal, dtoOcupanteLegal);
			activoOcupanteLegal.setSituacionPosesoria(situacionPosesoria);
			ActivoOcupanteLegal ocupanteLegalNuevo = genericDao.save(ActivoOcupanteLegal.class, activoOcupanteLegal);

			situacionPosesoria.getActivoOcupanteLegal().add(ocupanteLegalNuevo);
			activo.setSituacionPosesoria(situacionPosesoria);
			activoApi.saveOrUpdate(activo);

		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter, createOcupanteLegal", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter, createOcupanteLegal", e);
		}

		return true;
	}

	public List<DtoActivoCargas> getListCargasById(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoActivoCargas> listaDtoCarga = new ArrayList<DtoActivoCargas>();
		boolean esUA = activoDao.isUnidadAlquilable(activo.getId());
		ActivoAgrupacion agrupacion = activoDao.getAgrupacionPAByIdActivo(activo.getId());
		Activo activoMatriz = null;
		if (!Checks.esNulo(agrupacion)) {
			activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agrupacion.getId());
		}
		
		if (esUA) {
			activo = activoMatriz;
		}
		List<ActivoCargas> listaCargas = null;
		listaCargas = genericDao.getList(ActivoCargas.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()),
				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		if (listaCargas != null) {			
			for (ActivoCargas activoCarga : listaCargas) {
				DtoActivoCargas cargaDto = new DtoActivoCargas();
				try {
					beanUtilNotNull.copyProperties(cargaDto, activoCarga);
					beanUtilNotNull.copyProperties(cargaDto, activoCarga.getCargaBien());
					beanUtilNotNull.copyProperty(cargaDto, "idActivoCarga", activoCarga.getId());

					if (activoCarga.getTipoCargaActivo() != null) {
						beanUtilNotNull.copyProperty(cargaDto, "tipoCargaDescripcion",
								activoCarga.getTipoCargaActivo().getDescripcion());
						beanUtilNotNull.copyProperty(cargaDto, "tipoCargaCodigo",
								activoCarga.getTipoCargaActivo().getCodigo());
					}
					if (activoCarga.getSubtipoCarga() != null) {
						beanUtilNotNull.copyProperty(cargaDto, "subtipoCargaDescripcion",
								activoCarga.getSubtipoCarga().getDescripcion());
						beanUtilNotNull.copyProperty(cargaDto, "subtipoCargaCodigo",
								activoCarga.getSubtipoCarga().getCodigo());
					}
					//HREOS-2733
					if(!Checks.esNulo(activoCarga.getOrigenDato())) {
						beanUtilNotNull.copyProperty(cargaDto, "origenDatoCodigo", activoCarga.getOrigenDato().getCodigo());
						beanUtilNotNull.copyProperty(cargaDto, "origenDatoDescripcion", activoCarga.getOrigenDato().getDescripcion());
					}
					
					if(!Checks.esNulo(activoCarga.getImpideVenta())) {
						beanUtilNotNull.copyProperty(cargaDto, "codigoImpideVenta", activoCarga.getImpideVenta().getCodigo());
					}
					
					if (activoCarga.getCargaBien() != null) {
						// HREOS-1666 - Si tiene F. Cancelacion debe mostrar el
						// estado Cancelado (independientemente del registrado
						// en DD_SIC_ID)
						if (!Checks.esNulo(activoCarga.getTipoCargaActivo())
								&& DDTipoCargaActivo.CODIGO_TIPO_CARGA_REG
										.equals(activoCarga.getTipoCargaActivo().getCodigo())
								&& (!Checks.esNulo(activoCarga.getCargaBien().getFechaCancelacion())
										|| !Checks.esNulo(activoCarga.getFechaCancelacionRegistral()))) {
							DDEstadoCarga estadoCarga = (DDEstadoCarga) utilDiccionarioApi
									.dameValorDiccionarioByCod(DDEstadoCarga.class, DDEstadoCarga.CODIGO_CANCELADA);
							beanUtilNotNull.copyProperty(cargaDto, "estadoDescripcion",
									estadoCarga.getDescripcion());
							beanUtilNotNull.copyProperty(cargaDto, "estadoCodigo", estadoCarga.getCodigo());

							// Fecha de cancelacion de una carga registral
							if (Checks.esNulo(activoCarga.getFechaCancelacionRegistral())) {
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacion",
										activoCarga.getCargaBien().getFechaCancelacion());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionRegistral",
										activoCarga.getCargaBien().getFechaCancelacion());
							} else {
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacion",
										activoCarga.getFechaCancelacionRegistral());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionRegistral",
										activoCarga.getFechaCancelacionRegistral());
							}
							cargaDto.setFechaCancelacionEconomica(null);
						} else {
							if (activoCarga.getEstadoCarga() != null) {
								beanUtilNotNull.copyProperty(cargaDto, "estadoDescripcion",
										activoCarga.getEstadoCarga().getDescripcion());
								beanUtilNotNull.copyProperty(cargaDto, "estadoCodigo",
										activoCarga.getEstadoCarga().getCodigo());		
								if (!Checks.esNulo(activoCarga.getSubestadoCarga())){
								    cargaDto.setSubestadoCodigo(activoCarga.getSubestadoCarga().getCodigo());
								    cargaDto.setSubestadoDescripcion(activoCarga.getSubestadoCarga().getDescripcion());
								}else {
								    DDSubestadoCarga subEstadoSinIndicar = genericDao.get(DDSubestadoCarga.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSubestadoCarga.COD_SCG_SIN_INICIAR));
								    if(!Checks.esNulo(subEstadoSinIndicar)) {
								        cargaDto.setSubestadoCodigo(subEstadoSinIndicar.getCodigo());
								        cargaDto.setSubestadoDescripcion(subEstadoSinIndicar.getDescripcion());
								    }
								}
							}
						}
						
						

						// HREOS-1666 - Si tiene F. Cancelacion debe mostrar el
						// estado Cancelado (independientemente del registrado
						// en DD_SIC_ID)
						if (!Checks.esNulo(activoCarga.getTipoCargaActivo())
								&& DDTipoCargaActivo.CODIGO_TIPO_CARGA_ECO
										.equals(activoCarga.getTipoCargaActivo().getCodigo())
								&& (!Checks.esNulo(activoCarga.getCargaBien().getFechaCancelacion())
										|| !Checks.esNulo(activoCarga.getFechaCancelacionRegistral()))) {
							DDSituacionCarga situacionCancelada = (DDSituacionCarga) utilDiccionarioApi
									.dameValorDiccionarioByCod(DDSituacionCarga.class, DDSituacionCarga.CANCELADA);
							beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaDescripcion",
									situacionCancelada.getDescripcion());
							beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaCodigo",
									situacionCancelada.getCodigo());

							// Fecha de cancelacion de una carga economica
							if (Checks.esNulo(activoCarga.getFechaCancelacionRegistral())) {
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacion",
										activoCarga.getCargaBien().getFechaCancelacion());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionEconomica",
										activoCarga.getCargaBien().getFechaCancelacion());
							} else {
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacion",
										activoCarga.getFechaCancelacionRegistral());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionEconomica",
										activoCarga.getFechaCancelacionRegistral());
							}
							cargaDto.setFechaCancelacionRegistral(null);
						} else {
							if (activoCarga.getCargaBien().getSituacionCargaEconomica() != null) {
								beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaDescripcion",
										activoCarga.getCargaBien().getSituacionCargaEconomica().getDescripcion());
								beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaCodigo",
										activoCarga.getCargaBien().getSituacionCargaEconomica().getCodigo());
							}
						}

						// HREOS-1666 - Si tiene F. Cancelacion debe mostrar el
						// estado Cancelado (independientemente del registrado
						// en DD_SIC_ID)
						if (!Checks.esNulo(activoCarga.getTipoCargaActivo())
								&& DDTipoCargaActivo.CODIGO_TIPO_CARGA_REGECO
										.equals(activoCarga.getTipoCargaActivo().getCodigo())
								&& (!Checks.esNulo(activoCarga.getCargaBien().getFechaCancelacion())
										|| !Checks.esNulo(activoCarga.getFechaCancelacionRegistral()))) {
							if (activoCarga.getEstadoCarga() != null) {
							beanUtilNotNull.copyProperty(cargaDto, "estadoDescripcion",
									activoCarga.getEstadoCarga().getDescripcion());
							beanUtilNotNull.copyProperty(cargaDto, "estadoCodigo",
									activoCarga.getEstadoCarga().getCodigo());
							}
							// Fecha de cancelacion de una carga economica
							if (Checks.esNulo(activoCarga.getFechaCancelacionRegistral())) {
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacion",
										activoCarga.getCargaBien().getFechaCancelacion());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionRegistral",
										activoCarga.getCargaBien().getFechaCancelacion());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionEconomica",
										activoCarga.getCargaBien().getFechaCancelacion());
							} else {
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacion",
										activoCarga.getFechaCancelacionRegistral());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionRegistral",
										activoCarga.getFechaCancelacionRegistral());
								beanUtilNotNull.copyProperty(cargaDto, "fechaCancelacionEconomica",
										activoCarga.getFechaCancelacionRegistral());
							}

						} else {
							if (activoCarga.getEstadoCarga() != null) {
								beanUtilNotNull.copyProperty(cargaDto, "estadoDescripcion",
										activoCarga.getEstadoCarga().getDescripcion());
								beanUtilNotNull.copyProperty(cargaDto, "estadoCodigo",
										activoCarga.getEstadoCarga().getCodigo());								
								if (!Checks.esNulo(activoCarga.getSubestadoCarga())){

								    cargaDto.setSubestadoCodigo(activoCarga.getSubestadoCarga().getCodigo());
								    cargaDto.setSubestadoDescripcion(activoCarga.getSubestadoCarga().getDescripcion());
								}else {
								    DDSubestadoCarga subEstadoSinIndicar = genericDao.get(DDSubestadoCarga.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSubestadoCarga.COD_SCG_SIN_INICIAR));
								    if(!Checks.esNulo(subEstadoSinIndicar)) {
								        cargaDto.setSubestadoCodigo(subEstadoSinIndicar.getCodigo());
								        cargaDto.setSubestadoDescripcion(subEstadoSinIndicar.getDescripcion());
								    }
								}	
							}
							if (activoCarga.getCargaBien().getSituacionCargaEconomica() != null) {
								beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaDescripcion",
										activoCarga.getCargaBien().getSituacionCargaEconomica().getDescripcion());
								beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaCodigo",
										activoCarga.getCargaBien().getSituacionCargaEconomica().getCodigo());
							}
						}
					}

				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}
				listaDtoCarga.add(cargaDto);
			}
		}

		return listaDtoCarga;

	}

	public DtoActivoCargas getCargaById(Long id) {

		DtoActivoCargas dtoCarga = new DtoActivoCargas();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoCargas cargaSeleccionada = (ActivoCargas) genericDao.get(ActivoCargas.class, filtro);

		try {

			beanUtilNotNull.copyProperties(dtoCarga, cargaSeleccionada);
			beanUtilNotNull.copyProperties(dtoCarga, cargaSeleccionada.getCargaBien());

			if (cargaSeleccionada.getTipoCargaActivo() != null) {
				beanUtilNotNull.copyProperty(dtoCarga, "tipoCargaCodigo",
						cargaSeleccionada.getTipoCargaActivo().getCodigo());
				beanUtilNotNull.copyProperty(dtoCarga, "tipoCargaDesc",
						cargaSeleccionada.getTipoCargaActivo().getDescripcion());
				beanUtilNotNull.copyProperty(dtoCarga, "tipoCargaCodigoEconomica",
						cargaSeleccionada.getTipoCargaActivo().getCodigo());
				beanUtilNotNull.copyProperty(dtoCarga, "tipoCargaDescEconomica",
						cargaSeleccionada.getTipoCargaActivo().getDescripcion());
			}

			if (cargaSeleccionada.getSubtipoCarga() != null) {
				beanUtilNotNull.copyProperty(dtoCarga, "subtipoCargaCodigo",
						cargaSeleccionada.getSubtipoCarga().getCodigo());
				beanUtilNotNull.copyProperty(dtoCarga, "subtipoCargaDesc",
						cargaSeleccionada.getSubtipoCarga().getDescripcion());
				beanUtilNotNull.copyProperty(dtoCarga, "subtipoCargaCodigoEconomica",
						cargaSeleccionada.getSubtipoCarga().getCodigo());
				beanUtilNotNull.copyProperty(dtoCarga, "subtipoCargaDescEconomica",
						cargaSeleccionada.getSubtipoCarga().getDescripcion());
			}

			if (cargaSeleccionada.getCargaBien().getSituacionCarga() != null) {
				// HREOS-1666 - Si tiene F. Cancelacion debe mostrar el estado
				// Cancelado (independientemente del registrado en DD_SIC_ID)
				// REG
				if (!Checks.esNulo(cargaSeleccionada.getTipoCargaActivo())
						&& DDTipoCargaActivo.CODIGO_TIPO_CARGA_REG
								.equals(cargaSeleccionada.getTipoCargaActivo().getCodigo())
						&& (!Checks.esNulo(cargaSeleccionada.getCargaBien().getFechaCancelacion())
								|| !Checks.esNulo(cargaSeleccionada.getFechaCancelacionRegistral()))) {
					DDSituacionCarga situacionCancelada = (DDSituacionCarga) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDSituacionCarga.class, DDSituacionCarga.CANCELADA);
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigo", situacionCancelada.getCodigo());

					// Fecha de cancelacion de una carga registral
					if (Checks.esNulo(cargaSeleccionada.getFechaCancelacionRegistral())) {
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacion",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionRegistral",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
					} else {
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacion",
								cargaSeleccionada.getFechaCancelacionRegistral());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionRegistral",
								cargaSeleccionada.getFechaCancelacionRegistral());
					}
					dtoCarga.setFechaCancelacionEconomica(null);
				} else {
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigo",
							cargaSeleccionada.getCargaBien().getSituacionCarga().getCodigo());
				}

				// ECO
				if (!Checks.esNulo(cargaSeleccionada.getTipoCargaActivo())
						&& DDTipoCargaActivo.CODIGO_TIPO_CARGA_ECO
								.equals(cargaSeleccionada.getTipoCargaActivo().getCodigo())
						&& (!Checks.esNulo(cargaSeleccionada.getCargaBien().getFechaCancelacion())
								|| !Checks.esNulo(cargaSeleccionada.getFechaCancelacionRegistral()))) {
					DDSituacionCarga situacionCancelada = (DDSituacionCarga) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDSituacionCarga.class, DDSituacionCarga.CANCELADA);
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigoEconomica",
							situacionCancelada.getCodigo());

					// Fecha de cancelacion de una carga economica
					if (Checks.esNulo(cargaSeleccionada.getFechaCancelacionRegistral())) {
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacion",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionEconomica",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
					} else {
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacion",
								cargaSeleccionada.getFechaCancelacionRegistral());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionEconomica",
								cargaSeleccionada.getFechaCancelacionRegistral());
					}
					dtoCarga.setFechaCancelacionRegistral(null);
				} else {
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigoEconomica",
							cargaSeleccionada.getCargaBien().getSituacionCarga().getCodigo());
				}

				// REGECO
				if (!Checks.esNulo(cargaSeleccionada.getTipoCargaActivo())
						&& DDTipoCargaActivo.CODIGO_TIPO_CARGA_REGECO
								.equals(cargaSeleccionada.getTipoCargaActivo().getCodigo())
						&& (!Checks.esNulo(cargaSeleccionada.getCargaBien().getFechaCancelacion())
								|| !Checks.esNulo(cargaSeleccionada.getFechaCancelacionRegistral()))) {
					DDSituacionCarga situacionCancelada = (DDSituacionCarga) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDSituacionCarga.class, DDSituacionCarga.CANCELADA);
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigo", situacionCancelada.getCodigo());
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigoEconomica",
							situacionCancelada.getCodigo());

					// Fecha de cancelacion de una carga economica
					if (Checks.esNulo(cargaSeleccionada.getFechaCancelacionRegistral())) {
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacion",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionEconomica",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionRegistral",
								cargaSeleccionada.getCargaBien().getFechaCancelacion());
					} else {
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacion",
								cargaSeleccionada.getFechaCancelacionRegistral());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionEconomica",
								cargaSeleccionada.getFechaCancelacionRegistral());
						beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionRegistral",
								cargaSeleccionada.getFechaCancelacionRegistral());
					}
				} else {
					beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigoEconomica",
							cargaSeleccionada.getCargaBien().getSituacionCarga().getCodigo());
				}
			}

			beanUtilNotNull.copyProperty(dtoCarga, "titularEconomica", cargaSeleccionada.getCargaBien().getTitular());
			beanUtilNotNull.copyProperty(dtoCarga, "importeEconomicoEconomica",
					cargaSeleccionada.getCargaBien().getImporteEconomico());

			beanUtilNotNull.copyProperty(dtoCarga, "descripcionCargaEconomica",
					cargaSeleccionada.getDescripcionCarga());

		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter", e);
		}

		return dtoCarga;

	}
	
	public List<DtoNumPlantas> getNumeroPlantasActivo(Long idActivo) {
		List<DtoNumPlantas> listaPlantas = new ArrayList<DtoNumPlantas>();
		Activo activo = activoApi.get(idActivo);
		if (activo.getInfoComercial().getTipoActivo().getCodigo().equals(DDTipoActivo.COD_VIVIENDA)) {
			if(activo.getInfoComercial() != null) {
				if(activo.getInfoComercial().getTipoInfoComercial() != null) {
						
					ActivoVivienda vivienda = genericDao.get(ActivoVivienda.class, genericDao.createFilter(FilterType.EQUALS, "informeComercial.id", activo.getInfoComercial().getId()));
					if(vivienda != null){				
						DtoNumPlantas dtoSotano = new DtoNumPlantas();
						dtoSotano.setNumPlanta(-1L);
						dtoSotano.setDescripcionPlanta("Planta -1");
						dtoSotano.setIdActivo(idActivo);
						listaPlantas.add(dtoSotano);
					
						for (int i = 0; i < vivienda.getNumPlantasInter(); i++) {
							DtoNumPlantas dto = new DtoNumPlantas();
							dto.setNumPlanta(Long.valueOf(i));
							if(i==0) dto.setDescripcionPlanta("Planta Baja");
							else dto.setDescripcionPlanta(i + "ª Planta");
							dto.setIdActivo(idActivo);
							listaPlantas.add(dto);
						}
					}
				}
			}
		}
		return listaPlantas;
	}

	@SuppressWarnings("unchecked")
	public List<DtoDistribucion> getTipoHabitaculoByNumPlanta(Long idActivo, Integer numPlanta) {
		List<String> listaDistribucionesExistentes = new ArrayList<String>();
		List<DtoDistribucion> listaNoExistentes = new ArrayList<DtoDistribucion>();
		Activo activo = activoApi.get(idActivo);
		if (activo.getInfoComercial().getTipoActivo().getCodigo().equals(DDTipoActivo.COD_VIVIENDA)) {
			for (int q = 0; q < activo.getInfoComercial().getDistribucion().size(); q++) {
				ActivoDistribucion activoDistribucion = activo.getInfoComercial().getDistribucion().get(q);
				Integer numPlantaDistro = activoDistribucion.getNumPlanta();

				if ((numPlantaDistro + 1) == (numPlanta + 1)) {
					listaDistribucionesExistentes.add(activoDistribucion.getTipoHabitaculo().getCodigo());
				}
			}

			List<DDTipoHabitaculo> habitaculos = (List<DDTipoHabitaculo>) utilDiccionarioApi.dameValoresDiccionario(DDTipoHabitaculo.class);
			for (DDTipoHabitaculo habitaculo : habitaculos) {
				if (!listaDistribucionesExistentes.contains(habitaculo.getCodigo())) {
					DtoDistribucion dto = new DtoDistribucion();
					DDTipoHabitaculo tipoHabitaculo = habitaculo;
					dto.setTipoHabitaculoCodigo(habitaculo.getCodigo());
					dto.setTipoHabitaculoDescripcion(tipoHabitaculo.getDescripcion());
					listaNoExistentes.add(dto);
				}
			}
		}
		return listaNoExistentes;
	}

	public List<DtoDistribucion> getListDistribucionesById(Long id) {
		Activo activo = activoApi.get(id);
		List<DtoDistribucion> listaDtoDistribucion = new ArrayList<DtoDistribucion>();

		ActivoInfoComercial infoComercial = activo.getInfoComercial();

		if (!Checks.esNulo(infoComercial.getDistribucion())) {
			for (int i = 0; i < infoComercial.getDistribucion().size(); i++) {
				DtoDistribucion distribucionDto = new DtoDistribucion();
				try {
					ActivoDistribucion distribucion = infoComercial.getDistribucion().get(i);
					BeanUtils.copyProperties(distribucionDto, distribucion);
					BeanUtils.copyProperty(distribucionDto, "idDistribucion", distribucion.getId());
					if (!Checks.esNulo(distribucion.getTipoHabitaculo())) {
						distribucionDto.setTipoHabitaculoCodigo(distribucion.getTipoHabitaculo().getCodigo());
						distribucionDto.setTipoHabitaculoDescripcion(distribucion.getTipoHabitaculo().getDescripcion());
					}
				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}
				listaDtoDistribucion.add(distribucionDto);
			}
		}

		return listaDtoDistribucion;
	}

	public List<DtoObservacion> getListObservacionesById(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoObservacion> listaDtoObservaciones = new ArrayList<DtoObservacion>();

		if (activo.getObservacion() != null) {

			for (int i = 0; i < activo.getObservacion().size(); i++) {
				DtoObservacion observacionDto = new DtoObservacion();

				try {
					BeanUtils.copyProperties(observacionDto, activo.getObservacion().get(i));

					if (activo.getObservacion().get(i).getUsuario() != null) {
						String nombreCompleto = activo.getObservacion().get(i).getUsuario().getNombre();
						Long idUsuario = activo.getObservacion().get(i).getUsuario().getId();
						if (activo.getObservacion().get(i).getUsuario().getApellido1() != null) {
							nombreCompleto += activo.getObservacion().get(i).getUsuario().getApellido1();

							if (activo.getObservacion().get(i).getUsuario().getApellido2() != null) {
								nombreCompleto += activo.getObservacion().get(i).getUsuario().getApellido2();
							}
						}

						if(activo.getObservacion().get(i).getTipoObservacion() != null) {
							BeanUtils.copyProperty(observacionDto, "tipoObservacionCodigo", activo.getObservacion().get(i).getTipoObservacion().getCodigo());
						}

						BeanUtils.copyProperty(observacionDto, "nombreCompleto", nombreCompleto);
						BeanUtils.copyProperty(observacionDto, "idUsuario", idUsuario);
					}
				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}
				listaDtoObservaciones.add(observacionDto);
			}
		}

		return listaDtoObservaciones;

	}
	
	@SuppressWarnings("unchecked")
	public DtoPage getListAsociadosById(DtoActivoVistaPatrimonioContrato dto) {
		VActivoPatrimonioContrato activoActual = genericDao.get(VActivoPatrimonioContrato.class, genericDao.createFilter(FilterType.EQUALS, "activo",dto.getActivo()));
		Page page = null;
		List<DtoActivoVistaPatrimonioContrato> lista = null;
		try {
			if(activoActual != null){
				BeanUtils.copyProperty(dto, "idContrato", activoActual.getIdContrato());
				BeanUtils.copyProperty(dto, "nombrePrinex", activoActual.getNombrePrinex());
				BeanUtils.copyProperty(dto, "idContratoAntiguo", activoActual.getIdContratoAntiguo());
				
				Activo activoVista = genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getActivo()));
				
				if(activoVista != null && activoVista.getSubcartera() != null) {
					Boolean esDivarian = DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(activoVista.getSubcartera().getCodigo())
							|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activoVista.getSubcartera().getCodigo());
					dto.setEsDivarian(esDivarian);
				}
				
				page = actPatrimonioDao.getActivosRelacionados(dto);
				lista = new ArrayList<DtoActivoVistaPatrimonioContrato>();
				for (VActivoPatrimonioContrato activo: (List<VActivoPatrimonioContrato>) page.getResults()) {
					DtoActivoVistaPatrimonioContrato dtoActivo =  new DtoActivoVistaPatrimonioContrato();
					BeanUtils.copyProperties(dtoActivo, activo);
					lista.add(dtoActivo);
				}
			}
		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter", e);
		}
		try {
			if(page == null || lista.isEmpty()) {
				throw new NullPointerException();
			}
			return new DtoPage(lista,page.getTotalCount());
		}catch(NullPointerException npe){
			logger.error("Error en ActivoAdapter, page o lista es nula", npe);
			return null;
		}
	}

	public List<VBusquedaAgrupacionByActivo> getListAgrupacionesActivoById(Long id) {

		Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "idActivo", id );
		List<VBusquedaAgrupacionByActivo> agrupacionesActivo = genericDao.getList(VBusquedaAgrupacionByActivo.class, filtroIdActivo);
		
		return agrupacionesActivo;
	}

	public List<VCalculosActivoAgrupacion> getCalculoActivoAgrupacion(Long idActivo){

		List<Long> listaAgrId = activoManager.getIdAgrupacionesActivo(idActivo);
		List<VCalculosActivoAgrupacion> listaCalc = new ArrayList<VCalculosActivoAgrupacion>();

		for(Long agrId: listaAgrId) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idAgrupacion", agrId);

			listaCalc.add(genericDao.get(VCalculosActivoAgrupacion.class, filtro));
		}

		return listaCalc;
	}
	
	

	public List<VBusquedaVisitasDetalle> getListVisitasActivoById(Long id) {

		Activo activo = activoApi.get(id);

		List<VBusquedaVisitasDetalle> visitasDetalles = new ArrayList<VBusquedaVisitasDetalle>();

		if (!Checks.esNulo(activo)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId().toString());
			visitasDetalles = genericDao.getList(VBusquedaVisitasDetalle.class, filtro);
		}

		return visitasDetalles;

	}
	

	public List<DtoActivoCatastro> getListCatastroById(Long id) {
		
		Activo activo = activoApi.get(id);
		// Si es una UA cogemos los datos del activo matriz
		boolean esUA = activoDao.isUnidadAlquilable(activo.getId());
		if(esUA) {
			ActivoAgrupacion agrupacion = activoDao.getAgrupacionPAByIdActivo(activo.getId());
			if (!Checks.esNulo(agrupacion)) {
				Activo activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agrupacion.getId());
				if (!Checks.esNulo(activoMatriz)) {
					activo=activoMatriz;
					}
			}
		}
		List<DtoActivoCatastro> listaDtoCatastro = new ArrayList<DtoActivoCatastro>();

		if (activo.getInfoAdministrativa() != null && activo.getCatastro() != null) {
			for (int i = 0; i < activo.getCatastro().size(); i++) {
				DtoActivoCatastro catastroDto = new DtoActivoCatastro();

				try {
					BeanUtils.copyProperties(catastroDto, activo.getCatastro().get(i));
					BeanUtils.copyProperty(catastroDto, "idCatastro", activo.getCatastro().get(i).getId());
					BeanUtils.copyProperty(catastroDto, "idActivo", activo.getId());
					BeanUtils.copyProperty(catastroDto, "resultadoSiNO", activo.getCatastro().get(i).getResultado());

				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);

				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}

				listaDtoCatastro.add(catastroDto);
			}
		}

		return listaDtoCatastro;
	}

	public DtoActivoValoraciones getValoresPreciosActivoById(Long id) {

		Activo activo = activoApi.get(id);
		DtoActivoValoraciones valoracionesDto = new DtoActivoValoraciones();

		try {
			BeanUtils.copyProperties(valoracionesDto, activo);
			if (activo.getAdjJudicial() != null && activo.getAdjJudicial().getAdjudicacionBien() != null) {
				BeanUtils.copyProperty(valoracionesDto, "importeAdjudicacion",
						activo.getAdjJudicial().getAdjudicacionBien().getImporteAdjudicacion());
			}

			if (activo.getAdjNoJudicial() != null) {
				BeanUtils.copyProperty(valoracionesDto, "valorAdquisicion",
						activo.getAdjNoJudicial().getValorAdquisicion());
			}

			if (activo.getGestorBloqueoPrecio() != null) {
				BeanUtils.copyProperty(valoracionesDto, "gestorBloqueoPrecio",
						activo.getGestorBloqueoPrecio().getApellidoNombre());
			}
		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter", e);
		}

		return valoracionesDto;
	}

	public List<DtoActivoOcupanteLegal> getListOcupantesLegalesById(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoActivoOcupanteLegal> listaDtoOcupanteLegal = new ArrayList<DtoActivoOcupanteLegal>();

		if (activo.getSituacionPosesoria() != null && activo.getSituacionPosesoria().getActivoOcupanteLegal() != null) {

			for (int i = 0; i < activo.getSituacionPosesoria().getActivoOcupanteLegal().size(); i++) {
				DtoActivoOcupanteLegal ocupanteLegalDto = new DtoActivoOcupanteLegal();
				try {
					BeanUtils.copyProperties(ocupanteLegalDto,
							activo.getSituacionPosesoria().getActivoOcupanteLegal().get(i));
					BeanUtils.copyProperty(ocupanteLegalDto, "idActivoOcupanteLegal",
							activo.getSituacionPosesoria().getActivoOcupanteLegal().get(i).getId());
				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}
				listaDtoOcupanteLegal.add(ocupanteLegalDto);

			}
		}

		return listaDtoOcupanteLegal;

	}

	public List<DtoAdmisionDocumento> getListDocumentacionAdministrativaById(Long id) {
		Activo activo = activoApi.get(id);

		List<DtoAdmisionDocumento> listaDtoAdmisionDocumento = new ArrayList<DtoAdmisionDocumento>();
		if(!Checks.esNulo(activo)) {		
			if (!Checks.esNulo(activo.getAdmisionDocumento())) {
	
				for (int i = 0; i < activo.getAdmisionDocumento().size(); i++) {
					DtoAdmisionDocumento adoDto = new DtoAdmisionDocumento();
	
					try {
						BeanUtils.copyProperties(adoDto, activo.getAdmisionDocumento().get(i));
						
						if(!Checks.esNulo(activo.getAdmisionDocumento().get(i).getLetraConsumo())) {
							Filter filtroCodConsumo = genericDao.createFilter(FilterType.EQUALS, "codigo", activo.getAdmisionDocumento().get(i).getLetraConsumo());
							DDTipoCalificacionEnergetica tipoCEE = genericDao.get(DDTipoCalificacionEnergetica.class, filtroCodConsumo);
							adoDto.setTipoLetraConsumoCodigo(Checks.esNulo(tipoCEE) ? null : tipoCEE.getCodigo());
							adoDto.setTipoLetraConsumoDescripcion(Checks.esNulo(tipoCEE) ? null : tipoCEE.getDescripcion());
						}
						BeanUtils.copyProperty(adoDto, "consumo", activo.getAdmisionDocumento().get(i).getConsumo());
						BeanUtils.copyProperty(adoDto, "emision", activo.getAdmisionDocumento().get(i).getEmision());
						BeanUtils.copyProperty(adoDto, "registro", activo.getAdmisionDocumento().get(i).getRegistro());
						adoDto.setDataIdDocumento(activo.getAdmisionDocumento().get(i).getDataIdDocumento());
						
						if (!Checks.esNulo(activo.getAdmisionDocumento().get(i).getConfigDocumento()) 
								&& !Checks.esNulo(activo.getAdmisionDocumento().get(i).getConfigDocumento().getTipoDocumentoActivo())){
								BeanUtils.copyProperty(adoDto, "descripcionTipoDocumentoActivo", activo.getAdmisionDocumento().get(i).getConfigDocumento().getTipoDocumentoActivo().getDescripcion());
								BeanUtils.copyProperty(adoDto, "codigoTipoDocumentoActivo", activo.getAdmisionDocumento().get(i).getConfigDocumento().getTipoDocumentoActivo().getCodigo());
							}						
	
						if (!Checks.esNulo(activo.getAdmisionDocumento().get(i).getTipoCalificacionEnergetica())) {
							BeanUtils.copyProperty(adoDto, "tipoCalificacionCodigo", activo.getAdmisionDocumento().get(i).getTipoCalificacionEnergetica().getCodigo());
							BeanUtils.copyProperty(adoDto, "tipoCalificacionDescripcion", activo.getAdmisionDocumento().get(i).getTipoCalificacionEnergetica().getDescripcion());
						}
					} catch (IllegalAccessException e) {
						logger.error("Error al obtener un listado de documentos administrativos del activo.", e);
					} catch (InvocationTargetException e) {
						logger.error("Error al obtener un listado de documentos administrativos del activo.", e);
					}
	
					listaDtoAdmisionDocumento.add(adoDto);
				}
			}
		} else {
			throw new JsonViewerException("Error al buscar el activo");
		}
		return listaDtoAdmisionDocumento;
	}

	public List<DtoFoto> getFotosById(Long id) {

		Activo activo = activoApi.get(id);

		List<DtoFoto> listaFotos = new ArrayList<DtoFoto>();

		if (activo.getFotos() != null) {

			for (int i = 0; i < activo.getFotos().size(); i++) {
				DtoFoto fotoDto = new DtoFoto();
				try {

					BeanUtils.copyProperties(fotoDto, activo.getFotos().get(i));
					BeanUtils.copyProperty(fotoDto, "fileItem", activo.getFotos().get(i).getAdjunto().getFileItem());
					BeanUtils.copyProperty(fotoDto, "path",
							activo.getFotos().get(i).getAdjunto().getFileItem().getFile().getPath());

				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}
				listaFotos.add(fotoDto);

			}
		}

		return listaFotos;

	}

	public DtoTasacion getTasacionById(Long id) {

		DtoTasacion dtoTasacion = new DtoTasacion();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoTasacion tasacionSeleccionada = (ActivoTasacion) genericDao.get(ActivoTasacion.class, filtro);

		if (tasacionSeleccionada != null) {
			try {
				BeanUtils.copyProperties(dtoTasacion, tasacionSeleccionada);
				BeanUtils.copyProperties(dtoTasacion, tasacionSeleccionada.getValoracionBien());
				if (tasacionSeleccionada.getTipoTasacion() != null) {
					BeanUtils.copyProperty(dtoTasacion, "tipoTasacionCodigo", 
							tasacionSeleccionada.getTipoTasacion().getCodigo());
					BeanUtils.copyProperty(dtoTasacion, "tipoTasacionDescripcion",
							tasacionSeleccionada.getTipoTasacion().getDescripcion());
				}
			} catch (IllegalAccessException e) {
				logger.error("Error en ActivoAdapter", e);
			} catch (InvocationTargetException e) {
				logger.error("Error en ActivoAdapter", e);
			}
		}

		return dtoTasacion;
	}

	public ActivoFoto getFotoActivoById(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);

		return genericDao.get(ActivoFoto.class, filtro);

	}

	public ActivoFoto getFotoActivoByRemoteId(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "remoteId", id);
		return genericDao.get(ActivoFoto.class, filtro);

	}

	public List<ActivoFoto> getListFotosActivoById(Long id) {

	

		Activo activo = this.getActivoById(id);
		if(activo != null && activoDao.isUnidadAlquilable(id)) {
			ActivoAgrupacion activoAgrupacion = activoDao.getAgrupacionPAByIdActivo(id);
			if(activoAgrupacion != null) {
				Activo activoMatriz = activoDao.getActivoById(activoDao.getIdActivoMatriz(activoAgrupacion.getId()));
				if(activoMatriz != null) {
					id = activoMatriz.getId();
					activo = activoMatriz;
				}
			}
		}
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", id);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC, "orden");
		
		List<ActivoFoto> listaActivoFoto = genericDao.getListOrdered(ActivoFoto.class, order, filtro, filtroBorrado);
		

		if (activo != null) {
			if (gestorDocumentalFotos.isActive() && (listaActivoFoto == null || listaActivoFoto.isEmpty())) {
				FileListResponse fileListResponse = null;
				try {
					fileListResponse = gestorDocumentalFotos.get(PROPIEDAD.ACTIVO, activo.getNumActivo());

					if (fileListResponse.getError() == null || fileListResponse.getError().isEmpty()) {
						for (es.pfsgroup.plugin.rem.rest.dto.File fileGD : fileListResponse.getData()) {
							activoApi.uploadFoto(fileGD);
						}
						listaActivoFoto = genericDao.getListOrdered(ActivoFoto.class, order, filtro);
					}
				} catch (Exception e) {
					logger.error("Error obteniendo las fotos del CDN", e);
				}

			}
		}
		return listaActivoFoto;

	}

	public List<ActivoFoto> getListFotosActivoByIdOrderPrincipal(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", id);
		Order order = new Order(OrderType.ASC, "principal, orden");

		return genericDao.getListOrdered(ActivoFoto.class, order, filtro);

	}
	
	public Object getActivos(DtoActivoFilter dtoActivoFiltro) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
				
		if (!Checks.esNulo(usuarioCartera)){
			if(!Checks.esNulo(usuarioCartera.getSubCartera())){
				dtoActivoFiltro.setEntidadPropietariaCodigo(usuarioCartera.getCartera().getCodigo());
				dtoActivoFiltro.setSubcarteraCodigo(usuarioCartera.getSubCartera().getCodigo());
			}else{
				dtoActivoFiltro.setEntidadPropietariaCodigo(usuarioCartera.getCartera().getCodigo());
			}
		}
		
		DDIdentificacionGestoria gestoria = gestorActivoApi.isGestoria(usuarioLogado);
		if (!Checks.esNulo(gestoria)) {
			dtoActivoFiltro.setUsuarioGestoria(true);
			dtoActivoFiltro.setGestoria(gestoria.getId());
		}else {
			dtoActivoFiltro.setUsuarioGestoria(false);
		}
		
		return activoApi.getListActivos(dtoActivoFiltro, usuarioLogado);
	}
	
	public Object getBusquedaActivosGrid(DtoActivoGridFilter dto, boolean devolverPage) {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		DDIdentificacionGestoria gestoria = gestorActivoApi.isGestoria(usuarioLogado);
		dto.setGestoria(gestoria != null ? gestoria.getId() : null);
		
		return activoDao.getBusquedaActivosGrid(dto, usuarioLogado, devolverPage);
	}

	public List<DtoUsuario> getComboUsuarios(Long idTipoGestor) {
		
		List<DespachoExterno> listDespachoExterno = null;
		EXTTipoGestorPropiedad tipoGestorPropiedad = null;
		List<DtoUsuario> listaUsuariosDto = new ArrayList<DtoUsuario>();
		
		if(idTipoGestor != null) {
			
			tipoGestorPropiedad = genericDao.get(EXTTipoGestorPropiedad.class, 
					genericDao.createFilter(FilterType.EQUALS, "clave", EXTTipoGestorPropiedad.TGP_CLAVE_DESPACHOS_VALIDOS),
					genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", idTipoGestor));
			
			if(tipoGestorPropiedad != null) {
				String[] listaTiposDespachos = null;
				listaTiposDespachos = tipoGestorPropiedad.getValor().split(",");
				if(listaTiposDespachos != null && listaTiposDespachos.length > 0) {
					for(String tipoDespacho : listaTiposDespachos){
						DDTipoDespachoExterno ddTiposDespacho = genericDao.get(DDTipoDespachoExterno.class, 
								genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDespacho),
								genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
						
						if(ddTiposDespacho != null){
							Order orden = new Order(OrderType.ASC, "id");
							listDespachoExterno = genericDao.getListOrdered(DespachoExterno.class, orden, 
									genericDao.createFilter(FilterType.EQUALS, "tipoDespacho.codigo", tipoDespacho),
									genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
						}
					}
				}
				
				
				if (listDespachoExterno != null && !listDespachoExterno.isEmpty()) {
					
					for (DespachoExterno despachoExterno : listDespachoExterno) {
						List<Usuario> listaUsuarios = null;
						List<GestorDespacho> listaGestorDespacho = null;
						
						listaGestorDespacho = genericDao.getList(GestorDespacho.class, 
								genericDao.createFilter(FilterType.EQUALS, "despachoExterno", despachoExterno),
								genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
						
						if(listaGestorDespacho != null && !listaGestorDespacho.isEmpty()) {
							listaUsuarios = new ArrayList<Usuario>();
							for(GestorDespacho gestorDespacho : listaGestorDespacho) {
								if(gestorDespacho.getUsuario() != null)
									listaUsuarios.add(gestorDespacho.getUsuario());
								
							}
						}
						
						if (listaUsuarios != null && !listaUsuarios.isEmpty()) {
							for (Usuario usuario : listaUsuarios) {
								
								boolean existe = false;
								for(DtoUsuario dto : listaUsuariosDto) {
									if(dto.getId().equals(usuario.getId()))
										existe = true;
								}
								
								if(!existe) {
									try {
										
										DtoUsuario dtoUsuario = new DtoUsuario();
										BeanUtils.copyProperties(dtoUsuario, usuario);									
										listaUsuariosDto.add(dtoUsuario);
										
									} catch (IllegalAccessException e) {
										logger.error("Error en ActivoAdapter", e);
									} catch (InvocationTargetException e) {
										logger.error("Error en ActivoAdapter", e);
									}
								}
								
							}
						}
					}				
				}
			}		
			if(!listaUsuariosDto.isEmpty())
				Collections.sort(listaUsuariosDto);		
		}
		return listaUsuariosDto;
	}
	
	public List<DtoUsuario> getComboGruposUsuarioGestoria(Usuario usuario, EXTDDTipoGestor tipoGestor){
		if(usuario == null || tipoGestor == null) return null;
		
		List<DtoUsuario> listaGruposDto = new ArrayList<DtoUsuario>();
		List<DespachoExterno> listDespachoExterno = null;
		List<GrupoUsuario> grupos = genericDao.getList(GrupoUsuario.class, genericDao.createFilter(FilterType.EQUALS, "usuario", usuario));
		EXTTipoGestorPropiedad tipoGestorPropiedad = genericDao.get(EXTTipoGestorPropiedad.class, 
				genericDao.createFilter(FilterType.EQUALS, "clave", EXTTipoGestorPropiedad.TGP_CLAVE_DESPACHOS_VALIDOS),
				genericDao.createFilter(FilterType.EQUALS, "tipoGestor", tipoGestor));
		
		if(tipoGestorPropiedad != null) {
			String[] listaTiposDespachos = null;
			listaTiposDespachos = tipoGestorPropiedad.getValor().split(",");
			if(listaTiposDespachos != null && listaTiposDespachos.length > 0) {
				for(String tipoDespacho : listaTiposDespachos){
					DDTipoDespachoExterno ddTiposDespacho = genericDao.get(DDTipoDespachoExterno.class, 
							genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDespacho),
							genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
					
					if(ddTiposDespacho != null){
						Order orden = new Order(OrderType.ASC, "id");
						listDespachoExterno = genericDao.getListOrdered(DespachoExterno.class, orden, 
								genericDao.createFilter(FilterType.EQUALS, "tipoDespacho.codigo", tipoDespacho),
								genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
					}
				}
				
				if (listDespachoExterno != null && !listDespachoExterno.isEmpty()) {
					for (DespachoExterno despachoExterno : listDespachoExterno) {
						List<Usuario> listaUsuarios = null;
						List<GestorDespacho> listaGestorDespacho = null;
						
						for(GrupoUsuario grupo : grupos) {
							listaGestorDespacho = genericDao.getList(GestorDespacho.class, 
									genericDao.createFilter(FilterType.EQUALS, "despachoExterno", despachoExterno),
									genericDao.createFilter(FilterType.EQUALS, "usuario", grupo.getGrupo()));
							
							if(listaGestorDespacho != null && !listaGestorDespacho.isEmpty()) {
								listaUsuarios = new ArrayList<Usuario>();
								for(GestorDespacho gestorDespacho : listaGestorDespacho) {
									if(gestorDespacho.getUsuario() != null)
										listaUsuarios.add(gestorDespacho.getUsuario());
									
								}
							}						
						
							if (listaUsuarios != null && !listaUsuarios.isEmpty()) {
								for (Usuario user : listaUsuarios) {
									
									boolean existe = false;
									for(DtoUsuario dto : listaGruposDto) {
										if(dto.getId().equals(user.getId()))
											existe = true;
									}
									
									if(!existe) {
										try {
											
											DtoUsuario dtoUsuario = new DtoUsuario();
											BeanUtils.copyProperties(dtoUsuario, user);									
											listaGruposDto.add(dtoUsuario);
											
										} catch (IllegalAccessException e) {
											logger.error("Error en ActivoAdapter", e);
										} catch (InvocationTargetException e) {
											logger.error("Error en ActivoAdapter", e);
										}
									}
									
								}
							}
						}
					}
				}
			}
		}

		return listaGruposDto;
	}
	
	public List<DtoUsuario> getComboUsuariosGestoria() {
		Usuario usuario = genericAdapter.getUsuarioLogado();
		EXTDDTipoGestor tipoGestorGestoria = genericDao.get(EXTDDTipoGestor.class, 
				genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION));
		
		return getComboGruposUsuarioGestoria(usuario, tipoGestorGestoria);
	}
	
	public List<DtoListadoGestores> getGestoresActivos(Long idActivo) {
		GestorEntidadDto gestorEntidadDto = new GestorEntidadDto();
		gestorEntidadDto.setIdEntidad(idActivo);
		gestorEntidadDto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO);
		List<GestorEntidadHistorico> gestoresEntidad = gestorActivoApi
				.getListGestoresActivosAdicionalesHistoricoData(gestorEntidadDto);
		
		Boolean incluirVenta = true;
		Boolean incluirAlquiler = true; 
		Activo activo = activoApi.get(idActivo);
		if(activo != null && activo.getActivoPublicacion() != null && activo.getActivoPublicacion().getTipoComercializacion() != null){
			String tipoComercializacion = activoApi.get(idActivo).getActivoPublicacion().getTipoComercializacion().getCodigo();
			if(DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tipoComercializacion) || DDTipoComercializacion.CODIGO_ALQUILER_OPCION_COMPRA.equals(tipoComercializacion)) {
				incluirVenta = false;
				incluirAlquiler = true;
			}else if(DDTipoComercializacion.CODIGO_VENTA.equals(tipoComercializacion)) {
				incluirVenta = true;
				incluirAlquiler = false;
			}
		}
		

		List<DtoListadoGestores> listadoGestoresDto = new ArrayList<DtoListadoGestores>();

		for (GestorEntidadHistorico gestor : gestoresEntidad) {
			if((incluirAlquiler && !incluirVenta && 
					(CODIGO_TIPO_GESTOR_COMERCIAL.equals(gestor.getTipoGestor().getCodigo()) || CODIGO_SUPERVISOR_COMERCIAL.equals(gestor.getTipoGestor().getCodigo()))
				) || (!incluirAlquiler && incluirVenta && 
					(CODIGO_GESTOR_COMERCIAL_ALQUILER.equals(gestor.getTipoGestor().getCodigo()) || CODIGO_SUPERVISOR_COMERCIAL_ALQUILER.equals(gestor.getTipoGestor().getCodigo())))) {
				
			} else {
				DtoListadoGestores dtoGestor = new DtoListadoGestores();
				try {
					BeanUtils.copyProperties(dtoGestor, gestor);
					BeanUtils.copyProperties(dtoGestor, gestor.getUsuario());
					BeanUtils.copyProperties(dtoGestor, gestor.getTipoGestor());
					BeanUtils.copyProperty(dtoGestor, "id", gestor.getId());
					BeanUtils.copyProperty(dtoGestor, "idUsuario", gestor.getUsuario().getId());
					
					GestorSustituto gestorSustituto = getGestorSustitutoVigente(gestor);

					if (!Checks.esNulo(gestorSustituto)) {
						dtoGestor.setApellidoNombre(dtoGestor.getApellidoNombre().concat(" (")
								.concat(gestorSustituto.getUsuarioGestorSustituto().getApellidoNombre()).concat(")"));
					}
				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}

				listadoGestoresDto.add(dtoGestor);
			}
		}

		return listadoGestoresDto;

	}

	public List<DtoListadoGestores> getGestores(Long idActivo) {
		GestorEntidadDto gestorEntidadDto = new GestorEntidadDto();
		gestorEntidadDto.setIdEntidad(idActivo);
		gestorEntidadDto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO);
		List<GestorEntidadHistorico> gestoresEntidad = gestorActivoApi
				.getListGestoresAdicionalesHistoricoData(gestorEntidadDto);
		
		Boolean incluirVenta;
		Boolean incluirAlquiler;
		
		String tipoComercializacion = null;
		if(activoApi.get(idActivo).getActivoPublicacion() != null && activoApi.get(idActivo).getActivoPublicacion().getTipoComercializacion() != null) {
			tipoComercializacion =activoApi.get(idActivo).getActivoPublicacion().getTipoComercializacion().getCodigo();
		}
		
		if(DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tipoComercializacion) || DDTipoComercializacion.CODIGO_ALQUILER_OPCION_COMPRA.equals(tipoComercializacion)) {
			incluirVenta = false;
			incluirAlquiler = true;
		}else if(DDTipoComercializacion.CODIGO_VENTA.equals(tipoComercializacion)) {
			incluirVenta = true;
			incluirAlquiler = false;
		}else {
			incluirVenta = true;
			incluirAlquiler = true;
		}

		List<DtoListadoGestores> listadoGestoresDto = new ArrayList<DtoListadoGestores>();

		for (GestorEntidadHistorico gestor : gestoresEntidad) {
			if((incluirAlquiler && !incluirVenta && 
					(CODIGO_TIPO_GESTOR_COMERCIAL.equals(gestor.getTipoGestor().getCodigo()) || CODIGO_SUPERVISOR_COMERCIAL.equals(gestor.getTipoGestor().getCodigo()))
				) || (!incluirAlquiler && incluirVenta && 
					(CODIGO_GESTOR_COMERCIAL_ALQUILER.equals(gestor.getTipoGestor().getCodigo()) || CODIGO_SUPERVISOR_COMERCIAL_ALQUILER.equals(gestor.getTipoGestor().getCodigo())))) {
				
			} else {
				DtoListadoGestores dtoGestor = new DtoListadoGestores();
				try {
					BeanUtils.copyProperties(dtoGestor, gestor);
					BeanUtils.copyProperties(dtoGestor, gestor.getUsuario());
					BeanUtils.copyProperties(dtoGestor, gestor.getTipoGestor());
					BeanUtils.copyProperty(dtoGestor, "id", gestor.getId());
					BeanUtils.copyProperty(dtoGestor, "idUsuario", gestor.getUsuario().getId());
					
					GestorSustituto gestorSustituto = getGestorSustitutoVigente(gestor);

					if (!Checks.esNulo(gestorSustituto)) {
						dtoGestor.setApellidoNombre(dtoGestor.getApellidoNombre().concat(" (")
								.concat(gestorSustituto.getUsuarioGestorSustituto().getApellidoNombre()).concat(")"));
					}
				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}

				listadoGestoresDto.add(dtoGestor);
			}
		}

		return listadoGestoresDto;

	}

	public Boolean insertarGestorAdicional(GestorEntidadDto dto) {
		dto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO);
		return gestorActivoApi.insertarGestorAdicionalActivo(dto);
	}

	public List<DtoListadoTramites> getTramitesActivo(Long idActivo, WebDto webDto) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo);
		Activo activo = activoApi.get(idActivo);
		List<String> listaCodigosTramite = new ArrayList<String>() {
			{
				add(ActivoTramiteApi.CODIGO_TRAMITE_OBTENCION_DOC);
				add(ActivoTramiteApi.CODIGO_TRAMITE_OBTENCION_DOC_CEE);
				add(ActivoTramiteApi.CODIGO_TRAMITE_ACTUACION_TECNICA);
				add(ActivoTramiteApi.CODIGO_TRAMITE_TASACION);
				add(ActivoTramiteApi.CODIGO_TRAMITE_OBTENCION_DOC_CEDULA);
				add(ActivoTramiteApi.CODIGO_TRAMITE_INFORME);
			}
		};
		List<DtoListadoTramites> listadoTramitesDto = new ArrayList<DtoListadoTramites>();
		List<VBusquedaTramitesActivo> tramitesActivo = genericDao.getList(VBusquedaTramitesActivo.class, filtro);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		boolean esUsuarioBBVA = false;
		if(usuarioCartera != null && usuarioCartera.getCartera() != null) {
			esUsuarioBBVA = DDCartera.CODIGO_CARTERA_BBVA.equals(usuarioCartera.getCartera().getCodigo());
		}
		
		
		for (VBusquedaTramitesActivo tramite : tramitesActivo) {
			
			if((esUsuarioBBVA && !listaCodigosTramite.contains(tramite.getCodigoTipoTramite())) || !esUsuarioBBVA) {
				DtoListadoTramites dtoTramite = new DtoListadoTramites();
				try {
					beanUtilNotNull.copyProperties(dtoTramite, tramite);
					
					if(DDCartera.CODIGO_CARTERA_BBVA.equalsIgnoreCase(activo.getCartera().getCodigo())
							&& CODIGO_TRAMITE_T017.equals(tramite.getCodigoTipoTramite())) {
						beanUtilNotNull.copyProperty(dtoTramite, "nombre", T017_TRAMITE_BBVA_DESCRIPCION);
						beanUtilNotNull.copyProperty(dtoTramite, "tipoTramite", T017_TRAMITE_BBVA_DESCRIPCION);
					}

				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}
				listadoTramitesDto.add(dtoTramite);
			}
						
		}
		if (activoDao.isActivoMatriz(idActivo)) {
			List<DtoListadoTramites> listadoTramitesDtoActivoMatriz = new ArrayList<DtoListadoTramites>();
			for (DtoListadoTramites tramite : listadoTramitesDto ) {
				Filter fTramite = genericDao.createFilter(FilterType.EQUALS, "idTramite", tramite.getIdTramite());
				List<VBusquedaTramitesActivoMatriz> tramiteAM = genericDao.getList(VBusquedaTramitesActivoMatriz.class, fTramite);
				if(tramiteAM.size() == 1) {
						listadoTramitesDtoActivoMatriz.add(tramite);							
				}								
			}
			return listadoTramitesDtoActivoMatriz;
		}
		return listadoTramitesDto;
	}
	public List<DtoPropietario> getListPropietarioById(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoPropietario> listaDtoPropietarios = new ArrayList<DtoPropietario>();
		boolean esUA = activoDao.isUnidadAlquilable(activo.getId());
		ActivoAgrupacion agrupacion = activoDao.getAgrupacionPAByIdActivo(activo.getId());
		Activo activoMatriz = null;
		if (!Checks.esNulo(agrupacion)) {
			activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agrupacion.getId());
		}
		
		if (esUA) {
			activo = activoMatriz;
		}

		for (int i = 0; i < activo.getPropietariosActivo().size(); i++) {
			if (activo.getPropietariosActivo() != null && !activo.getPropietariosActivo().isEmpty()) {
				DtoPropietario propietarioDto = new DtoPropietario();
				ActivoPropietarioActivo propietario = activo.getPropietariosActivo().get(i);
				try {
					BeanUtils.copyProperties(propietarioDto, propietario);
					BeanUtils.copyProperties(propietarioDto, propietario.getPropietario());
					BeanUtils.copyProperty(propietarioDto, "nombreCompleto",
							propietario.getPropietario().getFullName());
					BeanUtils.copyProperty(propietarioDto, "idActivo", propietario.getActivo().getId());
					if (!Checks.esNulo(propietario.getTipoGradoPropiedad()))
						BeanUtils.copyProperty(propietarioDto, "tipoGradoPropiedadCodigo",
								propietario.getTipoGradoPropiedad().getCodigo());
					if (!Checks.esNulo(propietario.getTipoGradoPropiedad()))
						BeanUtils.copyProperty(propietarioDto, "tipoGradoPropiedadDescripcion",
								propietario.getTipoGradoPropiedad().getDescripcion());
					if (!Checks.esNulo(propietario.getPropietario().getLocalidad()))
						BeanUtils.copyProperty(propietarioDto, "localidadCodigo",
								propietario.getPropietario().getLocalidad().getCodigo());
					if (!Checks.esNulo(propietario.getPropietario().getProvincia()))
						BeanUtils.copyProperty(propietarioDto, "provinciaCodigo",
								propietario.getPropietario().getProvincia().getCodigo());
					if (!Checks.esNulo(propietario.getPropietario().getTipoPersona()))
						BeanUtils.copyProperty(propietarioDto, "tipoPersonaCodigo",
								propietario.getPropietario().getTipoPersona().getCodigo());
					if (!Checks.esNulo(propietario.getPropietario().getLocalidadContacto()))
						BeanUtils.copyProperty(propietarioDto, "localidadContactoDescripcion",
								propietario.getPropietario().getLocalidadContacto().getDescripcion());

					if (!Checks.esNulo(propietario.getPropietario().getProvinciaContacto()))
						BeanUtils.copyProperty(propietarioDto, "provinciaContactoDescripcion",
								propietario.getPropietario().getProvinciaContacto().getDescripcion());

					if (!Checks.esNulo(propietario.getPropietario().getTipoDocIdentificativo())) {
						BeanUtils.copyProperty(propietarioDto, "tipoDocIdentificativoCodigo",
								propietario.getPropietario().getTipoDocIdentificativo().getCodigo());
					}
					if (!Checks.esNulo(propietario.getPropietario().getTipoDocIdentificativo())) {
						BeanUtils.copyProperty(propietarioDto, "tipoDocIdentificativoDesc",
								propietario.getPropietario().getTipoDocIdentificativo().getDescripcion());
					}
						BeanUtils.copyProperty(propietarioDto, "tipoPropietario",
							"Principal");
					if (!Checks.esNulo(propietario.getAnyoConcesion())) {
						BeanUtils.copyProperty(propietarioDto, "anyoConcesion",
								propietario.getAnyoConcesion());
					}if (!Checks.esNulo(propietario.getFechaFinConcesion())) {
						BeanUtils.copyProperty(propietarioDto, "fechaFinConcesion",
								propietario.getFechaFinConcesion());
					}

				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}
				listaDtoPropietarios.add(propietarioDto);
			}

		}
		for (int i = 0; i < activo.getCopropietariosActivo().size(); i++) {
			if (activo.getPropietariosActivo() != null && !activo.getCopropietariosActivo().isEmpty()) {
				DtoPropietario propietarioDto = new DtoPropietario();
				ActivoCopropietarioActivo copropietario = activo.getCopropietariosActivo().get(i);
				try {
					BeanUtils.copyProperties(propietarioDto, copropietario);
					BeanUtils.copyProperties(propietarioDto, copropietario.getCoPropietario());
					BeanUtils.copyProperty(propietarioDto, "nombreCompleto",
							copropietario.getCoPropietario().getFullName());
					BeanUtils.copyProperty(propietarioDto, "idActivo", copropietario.getActivo().getId());
					if (!Checks.esNulo(copropietario.getTipoGradoPropiedad()))
						BeanUtils.copyProperty(propietarioDto, "tipoGradoPropiedadCodigo",
								copropietario.getTipoGradoPropiedad().getCodigo());
					if (!Checks.esNulo(copropietario.getTipoGradoPropiedad()))
						BeanUtils.copyProperty(propietarioDto, "tipoGradoPropiedadDescripcion",
								copropietario.getTipoGradoPropiedad().getDescripcion());
					if (!Checks.esNulo(copropietario.getCoPropietario().getLocalidad()))
						BeanUtils.copyProperty(propietarioDto, "localidadCodigo",
								copropietario.getCoPropietario().getLocalidad().getCodigo());
					if (!Checks.esNulo(copropietario.getCoPropietario().getProvincia()))
						BeanUtils.copyProperty(propietarioDto, "provinciaCodigo",
								copropietario.getCoPropietario().getProvincia().getCodigo());
					if (!Checks.esNulo(copropietario.getCoPropietario().getTipoPersona()))
						BeanUtils.copyProperty(propietarioDto, "tipoPersonaCodigo",
								copropietario.getCoPropietario().getTipoPersona().getCodigo());
					if (!Checks.esNulo(copropietario.getCoPropietario().getLocalidadContacto()))
						BeanUtils.copyProperty(propietarioDto, "localidadContactoCodigo",
								copropietario.getCoPropietario().getLocalidadContacto().getCodigo());

					if (!Checks.esNulo(copropietario.getCoPropietario().getProvinciaContacto()))
						BeanUtils.copyProperty(propietarioDto, "provinciaContactoCodigo",
								copropietario.getCoPropietario().getProvinciaContacto().getCodigo());

					if (!Checks.esNulo(copropietario.getCoPropietario().getTipoDocIdentificativo())) {
						BeanUtils.copyProperty(propietarioDto, "tipoDocIdentificativoCodigo",
								copropietario.getCoPropietario().getTipoDocIdentificativo().getCodigo());
					}
					if (!Checks.esNulo(copropietario.getCoPropietario().getTipoDocIdentificativo())) {
						BeanUtils.copyProperty(propietarioDto, "tipoDocIdentificativoDesc",
								copropietario.getCoPropietario().getTipoDocIdentificativo().getDescripcion());
					}
						BeanUtils.copyProperty(propietarioDto, "tipoPropietario",
							"Copropietario");

				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}
				listaDtoPropietarios.add(propietarioDto);
			}

		}

		return listaDtoPropietarios;

	}
	
	public List<DtoActivoDeudoresAcreditados> getListDeudoresById(Long id) {
				
	
		List<DtoActivoDeudoresAcreditados> listaDtoDeudores = new ArrayList<DtoActivoDeudoresAcreditados>();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", id);
		Order order = new Order(OrderType.ASC, "fechaAlta");
		List<ActivoDeudoresAcreditados> listaDeudores =(List<ActivoDeudoresAcreditados>)genericDao.getListOrdered(ActivoDeudoresAcreditados.class, order, filtro);
	
		for (ActivoDeudoresAcreditados deudor : listaDeudores) {
			DtoActivoDeudoresAcreditados dto = new DtoActivoDeudoresAcreditados();
			try {
				BeanUtils.copyProperties(dto,deudor);
				if(deudor.getFechaAlta()!=null) {
				BeanUtils.copyProperty(dto,"fechaAlta",deudor.getFechaAlta());
				}
				if(deudor.getUsuario().getApellidoNombre()!=null) {
				BeanUtils.copyProperty(dto, "gestorAlta",deudor.getUsuario().getApellidoNombre());
				}
				if(deudor.getTipoDocumento().getDescripcion()!=null) {
					BeanUtils.copyProperty(dto, "tipoDocIdentificativoDesc",deudor.getTipoDocumento().getDescripcion());
				}
				if(deudor.getNumeroDocumentoDeudor()!=null) {
					BeanUtils.copyProperty(dto,"docIdentificativo",deudor.getNumeroDocumentoDeudor());
				}
				if(deudor.getNombreDeudor()!=null) {
					BeanUtils.copyProperty(dto,"nombre",deudor.getNombreDeudor());
				}
				if(deudor.getApellido1Deudor()!=null) {
				BeanUtils.copyProperty(dto,"apellido1",deudor.getApellido1Deudor());
				}
				if(deudor.getApellido2Deudor()!=null) {
				BeanUtils.copyProperty(dto,"apellido2",deudor.getApellido2Deudor());
				}
			}catch (IllegalAccessException e) {
				logger.error("Error en ActivoAdapter", e);
			} catch (InvocationTargetException e) {
				logger.error("Error en ActivoAdapter", e);
			}
			listaDtoDeudores.add(dto);
		}
		
		return listaDtoDeudores;

	}

	public List<DtoValoracion> getListValoracionesById(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoValoracion> listaDtoValoracion = new ArrayList<DtoValoracion>();

		for (int i = 0; i < activo.getValoracion().size(); i++) {
			if (activo.getValoracion() != null && !activo.getValoracion().isEmpty()) {
				DtoValoracion valoracionDto = new DtoValoracion();
				try {
					BeanUtils.copyProperties(valoracionDto, activo.getValoracion().get(i));
					BeanUtils.copyProperty(valoracionDto, "tipoPrecioCod",
							activo.getValoracion().get(i).getTipoPrecio().getCodigo());
					BeanUtils.copyProperty(valoracionDto, "tipoPrecioDescripcion",
							activo.getValoracion().get(i).getTipoPrecio().getDescripcion());

				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}
				listaDtoValoracion.add(valoracionDto);
			}

		}

		return listaDtoValoracion;

	}

	public List<DtoTasacion> getListTasacionById(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoTasacion> listaDtoTasacion = new ArrayList<DtoTasacion>();

		if (activo.getTasacion() != null) {
			for (int i = 0; i < activo.getTasacion().size(); i++) {

				DtoTasacion tasacionDto = new DtoTasacion();
				try {
					BeanUtils.copyProperties(tasacionDto, activo.getTasacion().get(i));
					if (activo.getTasacion().get(i).getTipoTasacion() != null) {
						BeanUtils.copyProperty(tasacionDto, "tipoTasacionCodigo",
								activo.getTasacion().get(i).getTipoTasacion().getCodigo());
						BeanUtils.copyProperty(tasacionDto, "tipoTasacionDescripcion",
								activo.getTasacion().get(i).getTipoTasacion().getDescripcion());
					}
					if (activo.getTasacion().get(i).getValoracionBien() != null) {
						BeanUtils.copyProperty(tasacionDto, "fechaValorTasacion",
								activo.getTasacion().get(i).getValoracionBien().getFechaValorTasacion());
						BeanUtils.copyProperty(tasacionDto, "fechaSolicitudTasacion",
								activo.getTasacion().get(i).getValoracionBien().getFechaSolicitudTasacion());
						BeanUtils.copyProperty(tasacionDto, "importeValorTasacion",
								activo.getTasacion().get(i).getImporteTasacionFin());
					}
				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}
				listaDtoTasacion.add(tasacionDto);
			}
		}

		return listaDtoTasacion;

	}
	
	public List<DtoTasacion> getListTasacionByIdGrid(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoTasacion> listaDtoTasacion = new ArrayList<DtoTasacion>();
		if (activo.getTasacion() != null) {
			for (int i = 0; i < activo.getTasacion().size(); i++) {

				DtoTasacion tasacionDto = new DtoTasacion();
				try {
					BeanUtils.copyProperties(tasacionDto, activo.getTasacion().get(i));
					if (activo.getTasacion().get(i).getTipoTasacion() != null) {
						BeanUtils.copyProperty(tasacionDto, "tipoTasacionCodigo",
								activo.getTasacion().get(i).getTipoTasacion().getCodigo());
						BeanUtils.copyProperty(tasacionDto, "tipoTasacionDescripcion",
								activo.getTasacion().get(i).getTipoTasacion().getDescripcion());
					}
					if (activo.getTasacion().get(i).getValoracionBien() != null) {
						BeanUtils.copyProperty(tasacionDto, "fechaValorTasacion",
								activo.getTasacion().get(i).getValoracionBien().getFechaValorTasacion());
						BeanUtils.copyProperty(tasacionDto, "fechaSolicitudTasacion",
								activo.getTasacion().get(i).getValoracionBien().getFechaSolicitudTasacion());
						BeanUtils.copyProperty(tasacionDto, "importeValorTasacion",
								activo.getTasacion().get(i).getImporteTasacionFin());
					}

					if (DDCartera.CODIGO_CARTERA_BBVA.equals(activo.getCartera().getCodigo())) {
						BeanUtils.copyProperty(tasacionDto, "codigoFirma",
								activo.getTasacion().get(i).getCodigoFirmaBbva());
					}


					if(activo.getTasacion().get(i).isIlocalizable() != null) {
						if (activo.getTasacion().get(i).isIlocalizable()) {
							BeanUtils.copyProperty(tasacionDto, "ilocalizable", activo.getTasacion().get(i).isIlocalizable());
						}else if (!activo.getTasacion().get(i).isIlocalizable()) {
							BeanUtils.copyProperty(tasacionDto, "ilocalizable", activo.getTasacion().get(i).isIlocalizable());
						}
						
					}
					
					if (activo.getTasacion().get(i).getIdExternoBbva() != null) {
						BeanUtils.copyProperty(tasacionDto, "externoBbva", activo.getTasacion().get(i).getIdExternoBbva());
					}

					if(activo.getTasacion().get(i).getGastoTasacionActivo() != null &&
							activo.getTasacion().get(i).getGastoTasacionActivo().getGastoProveedor() != null){
						tasacionDto.setIdGasto(activo.getTasacion().get(i).getGastoTasacionActivo().getGastoProveedor().getId());
						tasacionDto.setNumGastoHaya(activo.getTasacion().get(i).getGastoTasacionActivo().getGastoProveedor().getNumGastoHaya());
					}

				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}
				
				if (!Checks.esNulo(tasacionDto.getCodigoFirma())) {
					ActivoProveedor tasadora = this.getTasadoraByCodProveedorUvem(tasacionDto.getCodigoFirma());
					if (!Checks.esNulo(tasadora)) {
						tasacionDto.setNomTasador(tasadora.getNombre());
					}
				}
				listaDtoTasacion.add(tasacionDto);
			}
		}

		return listaDtoTasacion;

	}
	
	/**
	 * Obtiene la tasadora dado un codProveedorUvem
	 * 
	 * @param codProveedorUvem
	 * @return
	 */
	public ActivoProveedor getTasadoraByCodProveedorUvem(String codProveedorUvem) {
		ActivoProveedor tasadora = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codProveedorUvem", codProveedorUvem);
		Filter filtroTasadora = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_TASADORA);
		List<ActivoProveedor> tasadoras = genericDao.getList(ActivoProveedor.class, filtro,filtroTasadora);
		if (!Checks.estaVacio(tasadoras)) {
			tasadora = tasadoras.get(0);
		}
		return tasadora;
	}

	public DtoTramite getTramite(Long idTramite) {
		DtoTramite dtoTramite = new DtoTramite();
		ActivoTramite tramite = activoTramiteApi.get(idTramite);
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
		List<TareaProcedimiento> listaTareas = activoTramiteApi.getTareasActivasByIdTramite(idTramite);

		try {
			beanUtilNotNull.copyProperty(dtoTramite, "idTramite", tramite.getId());
			beanUtilNotNull.copyProperty(dtoTramite, "idTipoTramite", tramite.getTipoTramite().getId());
			
			
			beanUtilNotNull.copyProperty(dtoTramite, "tramiteAlquilerAnulado", false);
			if (!Checks.esNulo(tramite.getTramitePadre()))
				beanUtilNotNull.copyProperty(dtoTramite, "idTramitePadre", tramite.getTramitePadre().getId());
			
			beanUtilNotNull.copyProperty(dtoTramite, "idActivo", tramite.getActivo().getId());

			if(DDCartera.CODIGO_CARTERA_BBVA.equalsIgnoreCase(tramite.getActivo().getCartera().getCodigo())
					&& CODIGO_TRAMITE_T017.equals(tramite.getTipoTramite().getCodigo())) {
				beanUtilNotNull.copyProperty(dtoTramite, "nombre", T017_TRAMITE_BBVA_DESCRIPCION);
				beanUtilNotNull.copyProperty(dtoTramite, "tipoTramite", T017_TRAMITE_BBVA_DESCRIPCION);
			}else if(DDCartera.CODIGO_CARTERA_BANKIA.equalsIgnoreCase(tramite.getActivo().getCartera().getCodigo())
					&& CODIGO_TRAMITE_T017.equals(tramite.getTipoTramite().getCodigo())) {
				beanUtilNotNull.copyProperty(dtoTramite, "nombre", T017_TRAMITE_VENTA_DESCRIPCION + " " + tramite.getActivo().getCartera().getDescripcion());
				beanUtilNotNull.copyProperty(dtoTramite, "tipoTramite", T017_TRAMITE_VENTA_DESCRIPCION + " " + tramite.getActivo().getCartera().getDescripcion());				
			}else {
				beanUtilNotNull.copyProperty(dtoTramite, "tipoTramite", tramite.getTipoTramite().getDescripcion());
				beanUtilNotNull.copyProperty(dtoTramite, "nombre", tramite.getTipoTramite().getDescripcion());	
			}
			
			beanUtilNotNull.copyProperty(dtoTramite, "estado", tramite.getEstadoTramite().getDescripcion());
			if (!Checks.esNulo(tramite.getTrabajo())) {
				beanUtilNotNull.copyProperty(dtoTramite, "idTrabajo", tramite.getTrabajo().getId());
				beanUtilNotNull.copyProperty(dtoTramite, "numTrabajo", tramite.getTrabajo().getNumTrabajo());
				beanUtilNotNull.copyProperty(dtoTramite, "tipoTrabajo",
						tramite.getTrabajo().getTipoTrabajo().getDescripcion());
				beanUtilNotNull.copyProperty(dtoTramite, "subtipoTrabajo",
						tramite.getTrabajo().getSubtipoTrabajo().getDescripcion());
				beanUtilNotNull.copyProperty(dtoTramite, "codigoSubtipoTrabajo",
						tramite.getTrabajo().getSubtipoTrabajo().getCodigo());
			}
			if (!Checks.esNulo(tramite.getActivo().getTipoActivo()))
				beanUtilNotNull.copyProperty(dtoTramite, "tipoActivo",
						tramite.getActivo().getTipoActivo().getDescripcion());
			if (!Checks.esNulo(tramite.getActivo().getSubtipoActivo()))
				beanUtilNotNull.copyProperty(dtoTramite, "subtipoActivo",
						tramite.getActivo().getSubtipoActivo().getDescripcion());
			if (!Checks.esNulo(tramite.getActivo().getCartera())) {
				beanUtilNotNull.copyProperty(dtoTramite, "cartera", tramite.getActivo().getCartera().getDescripcion());
				beanUtilNotNull.copyProperty(dtoTramite, "codigoCartera", tramite.getActivo().getCartera().getCodigo());
			}
			if(!Checks.esNulo(tramite.getActivo().getSubcartera())){
				beanUtilNotNull.copyProperty(dtoTramite, "codigoSubcartera", tramite.getActivo().getSubcartera().getCodigo());
			}
			if (!Checks.esNulo(tramite.getFechaInicio()))
				beanUtilNotNull.copyProperty(dtoTramite, "fechaInicio", formato.format(tramite.getFechaInicio()));
			if (!Checks.esNulo(tramite.getFechaFin()))
				beanUtilNotNull.copyProperty(dtoTramite, "fechaFinalizacion", formato.format(tramite.getFechaFin()));

			if((tramite.getTrabajo() != null) && (tramite.getTrabajo().getAgrupacion() != null)) {
				beanUtilNotNull.copyProperty(dtoTramite, "numActivo", tramite.getTrabajo().getAgrupacion().getNumAgrupRem());
			} else {
				beanUtilNotNull.copyProperty(dtoTramite, "numActivo", tramite.getActivo().getNumActivo());
			}

			beanUtilNotNull.copyProperty(dtoTramite, "esMultiActivo", tramite.getActivos().size() > 1 ? true : false);
			beanUtilNotNull.copyProperty(dtoTramite, "countActivos", tramite.getActivos().size());
			if (!Checks.esNulo(tramite.getTipoTramite())){
				
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				Boolean isProveedor = genericAdapter.isProveedor(usuarioLogado);
				if (!ActivoTramiteApi.CODIGO_TRAMITE_ACTUACION_TECNICA.equals(tramite.getTipoTramite().getCodigo()) || isProveedor) {
					beanUtilNotNull.copyProperty(dtoTramite, "ocultarBotonCierre", true);
				}
				if (!ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA.equals(tramite.getTipoTramite().getCodigo()) 
						&& !ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA_APPLE.equals(tramite.getTipoTramite().getCodigo())) {
					beanUtilNotNull.copyProperty(dtoTramite, "ocultarBotonResolucion", true);
				}
				if (!activoTramiteApi.isTramiteAlquiler(tramite.getTipoTramite()) && !activoTramiteApi.isTramiteAlquilerNoComercial(tramite.getTipoTramite())) {
					beanUtilNotNull.copyProperty(dtoTramite, "ocultarBotonResolucionAlquiler", true);
				}
				if (!ActivoTramiteApi.CODIGO_TRAMITE_PROPUESTA_PRECIOS.equals(tramite.getTipoTramite().getCodigo())) {
					beanUtilNotNull.copyProperty(dtoTramite, "ocultarBotonAnular", true);
				}
				
				if ((!genericAdapter.isSuper(usuarioLogado)) || !(tramite.getTipoTramite().getCodigo().equals("T013"))) {
					dtoTramite.setOcultarBotonLanzarTareaAdministrativa(true);
					beanUtilNotNull.copyProperty(dtoTramite, "ocultarBotonLanzarTareaAdministrativa", true);
					beanUtilNotNull.copyProperty(dtoTramite, "ocultarBotonReactivarTramite", true);
				}
				
				if(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO.equals(tramite.getEstadoTramite().getCodigo())) {
					beanUtilNotNull.copyProperty(dtoTramite, "desactivarBotonLanzarTareaAdministrativa", true);
				}
				
				if (ActivoTramiteApi.CODIGO_TRAMITE_ACTUACION_TECNICA.equals(tramite.getTipoTramite().getCodigo())) {

					List<TareaExterna> tareasTramite = activoTareaExternaApi.getActivasByIdTramiteTodas(idTramite);

					for (TareaExterna tarea : tareasTramite) {
						if (TrabajoApi.CODIGO_T004_AUTORIZACION_BANKIA.equals(tarea.getTareaProcedimiento().getCodigo())) {
							beanUtilNotNull.copyProperty(dtoTramite, "esTareaAutorizacionBankia", true);
						}
					}
				}
				
				if(ActivoTramiteApi.CODIGO_TRAMITE_ACTUACION_TECNICA.equals(tramite.getTipoTramite().getCodigo())){
					List<TareaExterna> tareasTramite = activoTareaExternaApi.getActivasByIdTramiteTodas(idTramite);
					DDCartera cartera = tramite.getActivo().getCartera();
					DDSubcartera subcartera = tramite.getActivo().getSubcartera();
					if((DDCartera.CODIGO_CARTERA_CERBERUS.equals(cartera.getCodigo()) 
							&& (DDSubcartera.CODIGO_JAIPUR_INMOBILIARIO.equals(subcartera.getCodigo()) 
									|| DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(subcartera.getCodigo())
									|| DDSubcartera.CODIGO_EGEO.equals(subcartera.getCodigo())
									|| DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(subcartera.getCodigo())))
					   || (DDCartera.CODIGO_CARTERA_EGEO.equals(cartera.getCodigo())
							   && (DDSubcartera.CODIGO_ZEUS.equals(subcartera.getCodigo())
									   || DDSubcartera.CODIGO_PROMONTORIA.equals(subcartera.getCodigo())))){
						for (TareaExterna tarea : tareasTramite) {
							if (TrabajoApi.CODIGO_T004_AUTORIZACION_PROPIETARIO.equals(tarea.getTareaProcedimiento().getCodigo())
									|| TrabajoApi.CODIGO_T004_SOLICITUD_EXTRAORDINARIA.equals(tarea.getTareaProcedimiento().getCodigo())) {
								dtoTramite.setEsTareaSolicitudOAutorizacion(true);
							}
						}
					}
					
				}
			}
			if(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO.equals(tramite.getEstadoTramite().getCodigo())
				|| DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO.equals(tramite.getEstadoTramite().getCodigo())){
				beanUtilNotNull.copyProperty(dtoTramite, "tramiteAlquilerAnulado", true);	
				beanUtilNotNull.copyProperty(dtoTramite, "tramiteVentaAnulado", true);
			}
				
				
			beanUtilNotNull.copyProperty(dtoTramite, "tieneEC", false);
			if (!Checks.esNulo(tramite.getTrabajo())) {
				// Trabajos asociados con expediente comercial
				Filter filtroEC = genericDao.createFilter(FilterType.EQUALS, "trabajo.id",
						tramite.getTrabajo().getId());
				ExpedienteComercial expedienteComercial = genericDao.get(ExpedienteComercial.class, filtroEC);
				if (!Checks.esNulo(expedienteComercial)) {
					beanUtilNotNull.copyProperty(dtoTramite, "tieneEC", true);
					beanUtilNotNull.copyProperty(dtoTramite, "idExpediente", expedienteComercial.getId());
					if(expedienteComercial.getEstado() != null) {
						beanUtilNotNull.copyProperty(dtoTramite, "descripcionEstadoEC",
								expedienteComercial.getEstado().getDescripcion());
						boolean isGestorBoarding = perteneceGrupoBoarding(genericAdapter.getUsuarioLogado());
						boolean expedienteComercialNoAprobado = expedienteComercialNoAprobado(expedienteComercial.getEstado().getCodigo());
						if(isGestorBoarding && expedienteComercialNoAprobado) {
							dtoTramite.setOcultarBotonResolucion(true);
						} else {
							if (!activoTramiteApi.isTramiteAlquiler(tramite.getTipoTramite()) && !activoTramiteApi.isTramiteAlquilerNoComercial(tramite.getTipoTramite())) {
								dtoTramite.setOcultarBotonResolucion(false);
							}
						}
					}
					beanUtilNotNull.copyProperty(dtoTramite, "numEC", expedienteComercial.getNumExpediente());
				}
				
				beanUtilNotNull.copyProperty(dtoTramite, "esTarifaPlana", tramite.getTrabajo().getEsTarifaPlana());
			}

			beanUtilNotNull.copyProperty(dtoTramite, "estaTareaRespuestaBankiaDevolucion", false);
			beanUtilNotNull.copyProperty(dtoTramite, "estaTareaPendienteDevolucion", false);
			beanUtilNotNull.copyProperty(dtoTramite, "estaEnTareaSiguienteResolucionExpediente", false);
			beanUtilNotNull.copyProperty(dtoTramite, "estaTareaRespuestaBankiaAnulacionDevolucion", false);
			Boolean estaEnTareaReserva = false; 
			if(!Checks.estaVacio(listaTareas)){
				for(TareaProcedimiento tarea : listaTareas){
					if(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION.equals(tarea.getCodigo())){
						beanUtilNotNull.copyProperty(dtoTramite, "estaTareaRespuestaBankiaDevolucion", true);
						beanUtilNotNull.copyProperty(dtoTramite, "estaEnTareaSiguienteResolucionExpediente", true);
					}
					else if(ComercialUserAssigantionService.CODIGO_T013_PENDIENTE_DEVOLUCION.equals(tarea.getCodigo())){
						beanUtilNotNull.copyProperty(dtoTramite, "estaTareaPendienteDevolucion", true);
						beanUtilNotNull.copyProperty(dtoTramite, "estaEnTareaSiguienteResolucionExpediente", true);
					}
					else if(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION.equals(tarea.getCodigo())){
						beanUtilNotNull.copyProperty(dtoTramite, "estaTareaRespuestaBankiaAnulacionDevolucion", true);
						beanUtilNotNull.copyProperty(dtoTramite, "estaEnTareaSiguienteResolucionExpediente", true);
					}
					
					if(ComercialUserAssigantionService.CODIGO_T013_PBC_RESERVA.equals(tarea.getCodigo()) ||
							ComercialUserAssigantionService.CODIGO_T017_PBC_RESERVA.equals(tarea.getCodigo()) ||
							ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA.equals(tarea.getCodigo()) ||
							ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA.equals(tarea.getCodigo()) ||
							ComercialUserAssigantionService.CODIGO_T017_INSTRUCCIONES_RESERVA.equals(tarea.getCodigo()) ||
							ComercialUserAssigantionService.CODIGO_T017_OBTENCION_CONTRATO_RESERVA.equals(tarea.getCodigo())) {
						estaEnTareaReserva = true;
					}
				}
			}
			Trabajo tbj = tramite.getTrabajo();
			if(tbj != null) {
				ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(tbj.getId());
				if(expediente != null ) {
					if(expediente.getEstadoBc() != null) {
						beanUtilNotNull.copyProperty(dtoTramite, "codigoEstadoExpedienteBC", expediente.getEstadoBc().getCodigo());
					}
					if(expediente.getEstado() != null) {
						beanUtilNotNull.copyProperty(dtoTramite, "codigoEstadoExpediente", expediente.getEstado().getCodigo());
					}
				}

			}
			String codigoGestor = gestorActivoApi.getCodigoGestorPorUsuario(usuarioManager.getUsuarioLogado().getId());
			Boolean esGestorAutorizado = !codigoGestor.contains("GBOAR");
			beanUtilNotNull.copyProperty(dtoTramite, "esGestorAutorizado", esGestorAutorizado);
			beanUtilNotNull.copyProperty(dtoTramite, "estaEnTareaReserva", estaEnTareaReserva);
			PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(tramite.getActivo().getId());
			boolean aplicaGestion = !Checks.esNulo(perimetroActivo) && Integer.valueOf(1).equals(perimetroActivo.getAplicaGestion())? true: false;
			beanUtilNotNull.copyProperty(dtoTramite, "activoAplicaGestion", aplicaGestion);
			
		} catch (Exception e) {
			logger.error("Error en ActivoAdapter", e);
		}

		return dtoTramite;
	}

	private boolean expedienteComercialNoAprobado(String codigoEstadoExpedienteComercial) {
		List<String> estadosRestringidos =
				new ArrayList<String>(Arrays.asList(DDEstadosExpedienteComercial.EN_TRAMITACION
													,DDEstadosExpedienteComercial.PTE_SANCION
													,DDEstadosExpedienteComercial.PDTE_RESPUESTA_OFERTANTE_CES
													,DDEstadosExpedienteComercial.CONTRAOFERTADO));
				
				
		return Boolean.TRUE.equals(estadosRestringidos.contains(codigoEstadoExpedienteComercial));
	}

	private boolean perteneceGrupoBoarding(Usuario usuarioLogado) {
		boolean perteneceGruppoBoarding = false;
		
		for (Perfil perfil : usuarioLogado.getPerfiles()) {
			if ("PERFGBOARDING".equals(perfil.getCodigo())){
				perteneceGruppoBoarding = true;
			}
		}
		return perteneceGruppoBoarding;
	}

	public List<DtoListadoTareas> getTareasTramite(Long idTramite) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		List<TareaExterna> tareasTramite = new ArrayList<TareaExterna>();
		ActivoTramite tramite = activoTramiteApi.get(idTramite);

		if (!genericAdapter.isSuper(usuarioLogado)
				&& !gestorActivoApi.isSupervisorActivo(tramite.getActivo(), usuarioLogado))
			tareasTramite = activoTareaExternaApi.getActivasByIdTramite(idTramite, usuarioLogado);
		else
			tareasTramite = activoTareaExternaApi.getActivasByIdTramiteTodas(idTramite);

		List<DtoListadoTareas> tareasTramiteDto = new ArrayList<DtoListadoTareas>();

		for (TareaExterna tarea : tareasTramite) {
			DtoListadoTareas dtoListadoTareas = new DtoListadoTareas();
			TareaActivo tareaActivo = tareaActivoApi.get(tarea.getTareaPadre().getId());

			try {
				beanUtilNotNull.copyProperty(dtoListadoTareas, "id", tarea.getTareaPadre().getId());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "idTareaExterna", tarea.getId());
				if(DDCartera.CODIGO_CARTERA_THIRD_PARTY.equalsIgnoreCase(tramite.getActivo().getCartera().getCodigo()) && 
						DDSubcartera.CODIGO_OMEGA.equals(tramite.getActivo().getSubcartera().getCodigo()) && 
						DDTareaDestinoSalto.CODIGO_RESULTADO_PBC.equalsIgnoreCase(tarea.getTareaProcedimiento().getCodigo())) {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTarea", "PBC Venta");
				} else {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTarea", tarea.getTareaProcedimiento().getDescripcion());
				}
				// beanUtilNotNull.copyProperty(dtoListadoTareas, "idTramite",
				// value);

				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaInicio", tarea.getTareaPadre().getFechaInicio());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaVenc", tarea.getTareaPadre().getFechaVenc());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaFin", tarea.getTareaPadre().getFechaFin());

				if (!Checks.esNulo(tareaActivo.getUsuario())) {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "idGestor", tareaActivo.getUsuario().getId());
					beanUtilNotNull.copyProperty(dtoListadoTareas, "gestor", tareaActivo.getUsuario().getUsername());
					beanUtilNotNull.copyProperty(dtoListadoTareas, "nombreUsuarioGestor", tareaActivo.getUsuario().getApellidoNombre());
				}
				if(!Checks.esNulo(tareaActivo.getSupervisorActivo())){
					beanUtilNotNull.copyProperty(dtoListadoTareas, "idSupervisor", tareaActivo.getSupervisorActivo().getId());
					beanUtilNotNull.copyProperty(dtoListadoTareas, "nombreUsuarioSupervisor", tareaActivo.getSupervisorActivo().getApellidoNombre());
				}
				if (!Checks.esNulo(tareaActivo.getSubtipoTarea())) {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "subtipoTareaCodigoSubtarea",
							tareaActivo.getSubtipoTarea().getCodigoSubtarea());
				}
				beanUtilNotNull.copyProperty(dtoListadoTareas, "codigoTarea",
						tarea.getTareaProcedimiento().getCodigo());

			} catch (IllegalAccessException e) {
				logger.error("Error en ActivoAdapter", e);
			} catch (InvocationTargetException e) {
				logger.error("Error en ActivoAdapter", e);
			}
			tareasTramiteDto.add(dtoListadoTareas);
		}

		return tareasTramiteDto;

	}

	public List<DtoListadoTareas> getTareasTramiteHistorico(Long idTramite) {

		List<TareaActivo> tareasTramite = tareaActivoApi.getTareasActivoByIdTramite(idTramite);
		List<DtoListadoTareas> tareasTramiteDto = new ArrayList<DtoListadoTareas>();

		for (TareaActivo tareaActivo : tareasTramite) {
			DtoListadoTareas dtoListadoTareas = new DtoListadoTareas();

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tareaPadre.id", tareaActivo.getId());
			TareaExterna tareaExterna = genericDao.get(TareaExterna.class, filtro);

			try {
				beanUtilNotNull.copyProperty(dtoListadoTareas, "id", tareaActivo.getId());
				if (!Checks.esNulo(tareaExterna)) {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "idTareaExterna", tareaExterna.getId());
					if(DDCartera.CODIGO_CARTERA_THIRD_PARTY.equalsIgnoreCase(tareaActivo.getActivo().getCartera().getCodigo()) && 
							DDSubcartera.CODIGO_OMEGA.equals(tareaActivo.getActivo().getSubcartera().getCodigo()) && 
							DDTareaDestinoSalto.CODIGO_RESULTADO_PBC.equalsIgnoreCase(tareaExterna.getTareaProcedimiento().getCodigo())) {
						beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTarea", "PBC Venta");
					} else {
						beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTarea", tareaExterna.getTareaProcedimiento().getDescripcion());
					}
				} else {
					if(DDCartera.CODIGO_CARTERA_THIRD_PARTY.equalsIgnoreCase(tareaActivo.getActivo().getCartera().getCodigo()) && 
							DDSubcartera.CODIGO_OMEGA.equals(tareaActivo.getActivo().getSubcartera().getCodigo()) && 
							DDTareaDestinoSalto.CODIGO_RESULTADO_PBC.equalsIgnoreCase(tareaActivo.getCodigoTarea())) {
						beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTarea", "PBC Venta");
					} else {
						beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTarea", tareaActivo.getDescripcionTarea());
					}
				}
		
				if (!Checks.esNulo(tareaExterna)) {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "codigoTarea",tareaExterna.getTareaProcedimiento().getCodigo());
				}
				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaInicio", tareaActivo.getFechaInicio());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaVenc", tareaActivo.getFechaVenc());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaFin", tareaActivo.getFechaFin());

				if (!Checks.esNulo(tareaActivo.getUsuario())) {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "idGestor", tareaActivo.getUsuario().getId());
					beanUtilNotNull.copyProperty(dtoListadoTareas, "gestor", tareaActivo.getUsuario().getUsername());
				}
				beanUtilNotNull.copyProperty(dtoListadoTareas, "subtipoTareaCodigoSubtarea",
						tareaActivo.getSubtipoTarea().getCodigoSubtarea());
				
				if(!Checks.esNulo(tareaActivo.getAuditoria().getUsuarioBorrar())){
					beanUtilNotNull.copyProperty(dtoListadoTareas, "usuarioFinaliza", tareaActivo.getAuditoria().getUsuarioBorrar());
				}

			} catch (IllegalAccessException e) {
				logger.error("Error en ActivoAdapter", e);
			} catch (InvocationTargetException e) {
				logger.error("Error en ActivoAdapter", e);
			}
			tareasTramiteDto.add(dtoListadoTareas);
		}

		return tareasTramiteDto;

	}


	public Long crearTramiteAdmision(Long idActivo) {

		TipoProcedimiento tprc = tipoProcedimiento.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_ADMISION); // Trámite
																		// de
																		// admisión

		ActivoTramite tramite = jbpmActivoTramiteManagerApi.creaActivoTramite(tprc, activoApi.get(idActivo));
		Long idBpm = jbpmActivoTramiteManagerApi.lanzaBPMAsociadoATramite(tramite.getId());

		jbpmActivoTramiteManagerApi.paralizarTareasChecking(tramite);

		return idBpm;
	}

	@Transactional(readOnly = false)
	public Long crearTramiteAprobacionInformeComercial(Long idActivo) {

		TipoProcedimiento tprc = tipoProcedimiento.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_APROBACION_INFORME_COMERCIAL);
		Activo activo =	activoApi.get(idActivo);
		Long idBpm = 0L;
		Boolean tieneTramiteVigente = activoTramiteApi.tieneTramiteVigenteByActivoYProcedimiento(activo.getId(), tprc.getCodigo());
		
		if(!tieneTramiteVigente){
			boolean activoEnAgrupacionObraNuevaOAsistida = activoApi.isIntegradoAgrupacionObraNuevaOrAsistida(activo);
			ActivoTramite tramite;

			if (activoEnAgrupacionObraNuevaOAsistida) {
				Long idSubdivision  = activoAgrupacionDao.getIdSubdivisionByIdActivo(idActivo);
				List<ActivoAgrupacionActivo> agrupaciones = activo.getAgrupaciones();
				String listaIdAgrupacion = "";

				for (ActivoAgrupacionActivo aga : agrupaciones) {

					if (DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA.equals(aga.getAgrupacion().getTipoAgrupacion().getCodigo())
								|| DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(aga.getAgrupacion().getTipoAgrupacion().getCodigo())) {
						if (Checks.esNulo(listaIdAgrupacion)) {
							listaIdAgrupacion += aga.getAgrupacion().getId();
						} else {
							listaIdAgrupacion += ", " + aga.getAgrupacion().getId();
						}
					}
				}

				List<Long> listaIdActivo = activoAgrupacionDao.getListIdActivoByIdSubdivisionAndIdsAgrupacion(idSubdivision, listaIdAgrupacion);

				for (Long id : listaIdActivo) {
					tieneTramiteVigente = activoTramiteApi.tieneTramiteVigenteByActivoYProcedimiento(id, tprc.getCodigo());

					if (!tieneTramiteVigente) {
						tramite = jbpmActivoTramiteManagerApi.creaActivoTramite(tprc, activoApi.get(id));
						if (id.equals(idActivo)) {
							idBpm = jbpmActivoTramiteManagerApi.lanzaBPMAsociadoATramite(tramite.getId());
						} else {
							jbpmActivoTramiteManagerApi.lanzaBPMAsociadoATramite(tramite.getId());
						}

						crearRegistroHistorialComercialConCodigoEstado(activoApi.get(id), DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_EMISION);
					}
				}

			} else {
				tramite = jbpmActivoTramiteManagerApi.creaActivoTramite(tprc, activoApi.get(idActivo));
				idBpm = jbpmActivoTramiteManagerApi.lanzaBPMAsociadoATramite(tramite.getId());

				crearRegistroHistorialComercialConCodigoEstado(activo, DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_EMISION);
			}
		}

		return idBpm;
	}
	
	@Transactional(readOnly = false)
	public Long crearTramiteGencat(Long idActivo) {

		TipoProcedimiento tprc = tipoProcedimiento.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_COMUNICACION_GENCAT);
		
		ActivoTramite tramite = jbpmActivoTramiteManagerApi.creaActivoTramite(tprc, activoApi.get(idActivo));

		return jbpmActivoTramiteManagerApi.lanzaBPMAsociadoATramite(tramite.getId());
	}
	
	public void crearRegistroHistorialComercialConCodigoEstado(Activo activo, String codigoEstado){
		ActivoEstadosInformeComercialHistorico estadoInformeComercialHistorico= new ActivoEstadosInformeComercialHistorico();
		estadoInformeComercialHistorico.setActivo(activo);
		DDEstadoInformeComercial estadoInformeComercial = (DDEstadoInformeComercial) proxyFactory.proxy(UtilDiccionarioApi.class)
				.dameValorDiccionarioByCod(DDEstadoInformeComercial.class, codigoEstado);
		estadoInformeComercialHistorico.setEstadoInformeComercial(estadoInformeComercial);
		estadoInformeComercialHistorico.setFecha(new Date());
		
		genericDao.save(ActivoEstadosInformeComercialHistorico.class, estadoInformeComercialHistorico);
	}

	public List<VAdmisionDocumentos> getListAdmisionCheckDocumentos(Long idActivo) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo.toString());
		Order order = new Order(OrderType.ASC, "descripcionTipoDoc");

		return genericDao.getListOrdered(VAdmisionDocumentos.class, order, filtro);

	}

	public List<VGridOfertasActivosAgrupacionIncAnuladas> getListOfertasActivos(Long idActivo) {

		return activoDao.getListOfertasActivo(idActivo);

	}
	
	public List<VGridOfertasActivosAgrupacion> getListOfertasTramitadasVendidasActivos(Long idActivo) {

		return activoDao.getListOfertasTramitadasPendientesActivo(idActivo);

	}

	public List<VPreciosVigentes> getPreciosVigentesById(Long idActivo) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo.toString());
		
		List<Filter> filters = new ArrayList<Filter>();
		filters.add(filtro);

		Order order = new Order(OrderType.ASC, "orden");
		filters = this.anyadirFiltroPrecioMinimoPorPerfil(filters);
		List<VPreciosVigentes> precios = genericDao.getListOrdered(VPreciosVigentes.class, order, filters);
		
		return precios;

	}

	@Transactional(readOnly = false)
	public boolean saveAdmisionDocumento(DtoAdmisionDocumento dtoAdmisionDocumento) throws RemUserException {

		ActivoAdmisionDocumento activoAdmisionDocumento = null;

		if (dtoAdmisionDocumento.getIdAdmisionDoc() != null) {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdmisionDocumento.getIdAdmisionDoc());
			activoAdmisionDocumento = genericDao.get(ActivoAdmisionDocumento.class, filtro);

			if (!BooleanUtils.toBoolean(dtoAdmisionDocumento.getAplica())) {

				activoAdmisionDocumento.setAplica(false);
				activoAdmisionDocumento.setFechaObtencion(null);
				activoAdmisionDocumento.setFechaSolicitud(null);
				activoAdmisionDocumento.setFechaVerificado(null);
				activoAdmisionDocumento.setEstadoDocumento(null);
				activoAdmisionDocumento.setTipoCalificacionEnergetica(null);
				activoAdmisionDocumento.setNumDocumento(null);
				activoAdmisionDocumento.setFechaEtiqueta(null);
				activoAdmisionDocumento.setFechaEmision(null);
				activoAdmisionDocumento.setFechaCaducidad(null);
				activoAdmisionDocumento.setDataIdDocumento(null);
				activoAdmisionDocumento.setLetraConsumo(null);
				activoAdmisionDocumento.setConsumo(null);
				activoAdmisionDocumento.setEmision(null);
				activoAdmisionDocumento.setRegistro(null);
				activoAdmisionDocumento.setTipoListaEmisiones(null);

			} else {

				rellenaCheckingDocumentoAdmision(activoAdmisionDocumento, dtoAdmisionDocumento);
			}

			genericDao.update(ActivoAdmisionDocumento.class, activoAdmisionDocumento);

		} else {

			activoAdmisionDocumento = new ActivoAdmisionDocumento();

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdmisionDocumento.getIdActivo());
			Activo act = genericDao.get(Activo.class, filtro);
			activoAdmisionDocumento.setActivo(act);
			filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdmisionDocumento.getIdConfiguracionDoc());
			ActivoConfigDocumento tipodoc = null;
			try {
				tipodoc = genericDao.get(ActivoConfigDocumento.class, filtro);
			} catch (Exception e) {
				throw new RemUserException("user.exception.tipodoc.incorrecto", messageServices);
			}
			activoAdmisionDocumento.setNoValidado(false);
			activoAdmisionDocumento.setConfigDocumento(tipodoc);

			rellenaCheckingDocumentoAdmision(activoAdmisionDocumento, dtoAdmisionDocumento);
			
			genericDao.save(ActivoAdmisionDocumento.class, activoAdmisionDocumento);	
		}
		return true;
	}

	private void rellenaCheckingDocumentoAdmision(ActivoAdmisionDocumento activoAdmisionDocumento,
			DtoAdmisionDocumento dtoAdmisionDocumento) {

		try {

			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "fechaObtencion",
					dtoAdmisionDocumento.getFechaObtencion());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "fechaSolicitud",
					dtoAdmisionDocumento.getFechaSolicitud());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "fechaVerificado",
					dtoAdmisionDocumento.getFechaVerificado());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "fechaCaducidad",
					dtoAdmisionDocumento.getFechaCaducidad());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "fechaEtiqueta",
					dtoAdmisionDocumento.getFechaEtiqueta());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "aplica",
					BooleanUtils.toBoolean(dtoAdmisionDocumento.getAplica()));

			if (dtoAdmisionDocumento.getEstadoDocumento() != null) {
				DDEstadoDocumento estadoDocumento = (DDEstadoDocumento) proxyFactory.proxy(UtilDiccionarioApi.class)
						.dameValorDiccionarioByCod(DDEstadoDocumento.class, dtoAdmisionDocumento.getEstadoDocumento());
				activoAdmisionDocumento.setEstadoDocumento(estadoDocumento);
			}
			
			if (dtoAdmisionDocumento.getTipoCalificacionCodigo() != null) {
				DDTipoCalificacionEnergetica calificacion = (DDTipoCalificacionEnergetica) proxyFactory.proxy(UtilDiccionarioApi.class)
						.dameValorDiccionarioByCod(DDTipoCalificacionEnergetica.class, dtoAdmisionDocumento.getTipoCalificacionCodigo());
				activoAdmisionDocumento.setTipoCalificacionEnergetica(calificacion);
			}
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "dataIdDocumento",
					dtoAdmisionDocumento.getDataIdDocumento());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "letraConsumo",
					dtoAdmisionDocumento.getLetraConsumo());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "consumo",
					dtoAdmisionDocumento.getConsumo());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "emision",
					dtoAdmisionDocumento.getEmision());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "registro",
					dtoAdmisionDocumento.getRegistro());
			if (dtoAdmisionDocumento.getLetraEmisiones() != null) {
				DDListaEmisiones emision = (DDListaEmisiones) proxyFactory.proxy(UtilDiccionarioApi.class)
						.dameValorDiccionarioByCod(DDListaEmisiones.class, dtoAdmisionDocumento.getLetraEmisiones());
				activoAdmisionDocumento.setTipoListaEmisiones(emision);
			}

		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter", e);
		}

	}

	public List<DtoAdjunto> getAdjuntosActivo(Long id)
			throws GestorDocumentalException, IllegalAccessException, InvocationTargetException {
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();

		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Activo activo = activoApi.get(id);
			listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosActivo(activo);

			for (DtoAdjunto adj : listaAdjuntos) {
				ActivoAdjuntoActivo adjuntoActivo = activo.getAdjuntoGD(adj.getId());
				if (!Checks.esNulo(adjuntoActivo)) {
					if (!Checks.esNulo(adjuntoActivo.getTipoDocumentoActivo())) {
						adj.setDescripcionTipo(adjuntoActivo.getTipoDocumentoActivo().getDescripcion());
					}
					adj.setContentType(adjuntoActivo.getContentType());
					if (!Checks.esNulo(adjuntoActivo.getAuditoria())) {
						adj.setGestor(adjuntoActivo.getAuditoria().getUsuarioCrear());
					}
					adj.setTamanyo(adjuntoActivo.getTamanyo());
					adj.setFechaDocumento(adjuntoActivo.getFechaDocumento());
				}else {
					//Si en un adjunto que se ha subido al GD desde fuera de REM el tipo de documento es nulo, lo obtenemos a través de la matrícula
					Filter filtroVisible = genericDao.createFilter(FilterType.EQUALS, "visible", true);
					Filter filtroMatricula = genericDao.createFilter(FilterType.EQUALS, "matricula", adj.getMatricula());
					List <DDTipoDocumentoActivo> tipoDocumento = (List<DDTipoDocumentoActivo>) genericDao.getList(DDTipoDocumentoActivo.class, filtroVisible, filtroMatricula); 

					if (!Checks.estaVacio(tipoDocumento)) {
						DDTipoDocumentoActivo tipoDoc = tipoDocumento.get(0);
						adj.setDescripcionTipo(tipoDoc.getDescripcion());
					}
				}
			}

		} else {
			listaAdjuntos = getAdjuntosActivo(id, listaAdjuntos);
		}
		
		listaAdjuntos = perfilApi.devolverAdjuntosPorPerfil(listaAdjuntos);
		
		return listaAdjuntos;
	}

	private List<DtoAdjunto> getAdjuntosActivo(Long id, List<DtoAdjunto> listaAdjuntos)
			throws IllegalAccessException, InvocationTargetException {
		Activo activo = activoApi.get(id);
		

		for (ActivoAdjuntoActivo adjunto : activo.getAdjuntos()) {
			DtoAdjunto dto = new DtoAdjunto();

			BeanUtils.copyProperties(dto, adjunto);
			dto.setIdEntidad(activo.getId());
			dto.setDescripcionTipo(adjunto.getTipoDocumentoActivo().getDescripcion());
			dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());
			dto.setMatricula(adjunto.getTipoDocumentoActivo().getMatricula());
			dto.setFechaDocumento(adjunto.getFechaDocumento());

			listaAdjuntos.add(dto);
		}
		
		return listaAdjuntos;
	}

	public String uploadDocumento(WebFileItem webFileItem, Activo activoEntrada, String matricula, DtoMetadatosEspecificos dtoMetadatos) throws Exception {
		if(webFileItem == null) return null; //No seguimos
		
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		Filter filtro = null;
		DDTipoDocumentoActivo tipoDocumento = null;
		Long idDocRestClient = null;
		String username = usuarioLogado != null ? usuarioLogado.getUsername() : "DEFAULT";
		boolean gestorDocumentalActivado = gestorDocumentalAdapterApi.modoRestClientActivado();
		
		if (activoEntrada == null)
			activoEntrada = activoApi.get(Long.parseLong(webFileItem.getParameter("idEntidad")));
		
		if (matricula == null) 
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
		else 
			filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);		
		
		tipoDocumento = (DDTipoDocumentoActivo) genericDao.get(DDTipoDocumentoActivo.class, filtro);
		
		if(tipoDocumento != null && gestorDocumentalActivado)
			idDocRestClient = gestorDocumentalAdapterApi.upload(activoEntrada, webFileItem, username, tipoDocumento.getMatricula(), dtoMetadatos);
		
		if (gestorDocumentalActivado) {
			activoApi.uploadDocumento(webFileItem, idDocRestClient, activoEntrada, matricula);
		}else {
			activoApi.uploadDocumento(webFileItem, null, activoEntrada, matricula);
		}
		if(tipoDocumento != null && activoEntrada != null) {
			DtoActivoSituacionPosesoria dto = new DtoActivoSituacionPosesoria();
			BeanUtils.copyProperties(dto, activoEntrada.getSituacionPosesoria());
			if (activoEntrada.getSituacionPosesoria().getConTitulo() != null)
				dto.setConTituloCodigo(activoEntrada.getSituacionPosesoria().getConTitulo().getCodigo());
			if(tipoDocumento.getCodigo().equals(DDTipoDocumentoActivo.CODIGO_INFORME_OCUPACION_DESOCUPACION))
				activoApi.compruebaParaEnviarEmailAvisoOcupacion(dto, activoEntrada.getId());
		}
		return null;
	}

	public String upload(WebFileItem webFileItem, DtoMetadatosEspecificos dto) throws Exception {
		return uploadDocumento(webFileItem, null, null, dto);
	}
	
	public void uploadFactura(WebFileItem webFileItem) throws Exception {
		if(webFileItem == null) return; //No seguimos
		GastoAsociadoAdquisicion gas = null;
		Filter filtro = null;
		DDTipoDocumentoGastoAsociado tipoDocGastoAsociado = null;
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		Long idDocRestClient = null;
		String username = usuarioLogado != null ? usuarioLogado.getUsername() : "DEFAULT";
		boolean gestorDocumentalActivado = gestorDocumentalAdapterApi.modoRestClientActivado();
		
		gas = genericDao.get(GastoAsociadoAdquisicion.class, 
				genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(webFileItem.getParameter("idEntidad"))));
		filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
		tipoDocGastoAsociado = genericDao.get(DDTipoDocumentoGastoAsociado.class, filtro);
		if(tipoDocGastoAsociado != null) {
			if(gestorDocumentalActivado) {
				idDocRestClient = gestorDocumentalAdapterApi.upload(gas.getActivo(), webFileItem, username, tipoDocGastoAsociado.getMatricula(), null);
				activoApi.uploadFactura(webFileItem, idDocRestClient, gas, tipoDocGastoAsociado);
			}else {
				activoApi.uploadFactura(webFileItem, null, gas, tipoDocGastoAsociado);
			}
		}
	}

	public FileItem download(Long id,String nombreDocumento) throws UserException,Exception {
		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		return dl.getFileItem(id,nombreDocumento);
	}
	
	public FileItem downloadFactura(Long id,String nombreDocumento) throws UserException,Exception {
		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		return dl.getFileItemFactura(id,nombreDocumento);
	}
	
	public FileItem downloadComunicacionGencat(Long id,String nombreDocumento) throws Exception {
		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		return dl.getFileItemComunicacionGencat(id,nombreDocumento);
	}

	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		boolean borrado = false;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			try {
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());
			} catch (Exception e) {
				logger.error("Error en ActivoAdapter", e);
			}
		} else {
			borrado = activoApi.deleteAdjunto(dtoAdjunto);
		}
		return borrado;
	}
	
	public DtoAviso getAvisosActivoById(Long id) {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		List<DtoAviso> avisos = activoAvisadorApi.getListActivoAvisador(id, usuarioLogado);
		String green = "Incluido en Haz tu Puja hasta 30/11/2018";
		DtoAviso avisosFormateados = new DtoAviso();
		avisosFormateados.setDescripcion("");
		for (int i = 0; i < avisos.size(); i++) {
			if(green.equals(avisos.get(i).getDescripcion())){
				avisosFormateados.setDescripcion(avisosFormateados.getDescripcion() + "<div class='div-aviso green'>"
						+ avisos.get(i).getDescripcion() + "</div>");
			} else {
				avisosFormateados.setDescripcion(avisosFormateados.getDescripcion() + "<div class='div-aviso red'>"
						+ avisos.get(i).getDescripcion() + "</div>");
			}
		}

		return avisosFormateados;

	}

	@Transactional(readOnly = false)
	public boolean deleteFotosActivoById(Long[] id) throws Exception {
		boolean resultado = true;
		
		for (int i = 0; i < id.length; i++) {
			ActivoFoto actvFoto = this.getFotoActivoById(id[i]);
			genericDao.deleteById(ActivoFoto.class, actvFoto.getId());
			if (actvFoto.getRemoteId() != null) {
				try{
					gestorDocumentalFotos.delete(actvFoto.getRemoteId());
				}catch(UnknownIdException e){
					logger.error("la foto no existe en el gestor documental");
				}
			}

		}

		return resultado;

	}

	@Transactional(readOnly = false)
	public void deleteFotoByRemoteId(Long remoteId) throws Exception {
		try {
			ActivoFoto actvFoto = this.getFotoActivoByRemoteId(remoteId);
			if (actvFoto != null) {
				genericDao.deleteById(ActivoFoto.class, actvFoto.getId());
			}
		} catch (Exception e) {
			logger.error("Error borrando la foto", e);
			throw new Exception(e.getMessage());
		}

	}
	
	@Transactional(readOnly = false)
	public boolean deleteCacheFotosActivo(Long idActivo){
		if (gestorDocumentalFotos.isActive()) {
			List<ActivoFoto> listaActivoFoto = this.getListFotosActivoById(idActivo);
			for(ActivoFoto foto : listaActivoFoto){
				foto.getAuditoria().setBorrado(true);
				genericDao.save(ActivoFoto.class, foto);
			}		
		}
		return true;
	}

	public DtoPage findAllHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dtoPresupuestoFiltro) {

		
		Activo activo = getActivoById(Long.parseLong(dtoPresupuestoFiltro.getIdActivo()));
		if(activoDao.isUnidadAlquilable(activo.getId())) {
			activo = getActivoById(activoDao.getIdActivoMatriz(activoDao.getAgrupacionPAByIdActivoConFechaBaja(activo.getId()).getId())); 
			dtoPresupuestoFiltro.setIdActivo(Long.toString(activo.getId()));
			String presupuestoId="";
			if (!Checks.esNulo(activo.getPresupuesto())) {
				List<PresupuestoActivo> presupuestos= activo.getPresupuesto();
				for(PresupuestoActivo presupuesto:presupuestos) {
					Calendar cal1 = Calendar.getInstance();
					Calendar cal2 = Calendar.getInstance();
					cal1.setTime(presupuesto.getFechaAsignacion());
					cal2.setTime(new Date());
					if(cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR)) {
						presupuestoId =Long.toString(presupuesto.getId());
						break;
					}
				}
			}
			dtoPresupuestoFiltro.setIdPresupuesto(presupuestoId);
		}

		List<VBusquedaPresupuestosActivo> presupuestosActivo = presupuestoManager.getListHistoricoPresupuestos(dtoPresupuestoFiltro);

		
		// Gastado + Pendiente de pago
		DtoActivosTrabajoFilter dtoFilter = new DtoActivosTrabajoFilter();

		dtoFilter.setIdActivo(presupuestosActivo.get(0).getIdActivo());
		dtoFilter.setLimit(50000);
		dtoFilter.setStart(0);
		dtoFilter.setEstadoContable("1");

		List<VBusquedaActivosTrabajoPresupuesto> listaTemp = presupuestoManager.getListActivosPresupuesto(dtoFilter);
		
		if(!Checks.estaVacio(listaTemp)){
			for (VBusquedaPresupuestosActivo presupuesto : presupuestosActivo) {
				
				presupuesto.setDispuesto(new Double(0));
				for (VBusquedaActivosTrabajoPresupuesto activoTrabajoTemp : listaTemp) {
					if(activoTrabajoTemp.getEjercicio().equals(presupuesto.getEjercicioAnyo())) {
						presupuesto.setDispuesto(
								presupuesto.getDispuesto() + new Double(activoTrabajoTemp.getImporteParticipa()));
					}
				}

				if (Checks.esNulo(presupuesto.getSumaIncrementos())) {
					presupuesto.setSumaIncrementos(new Double(0));
				}

			}
		}
		

		return new DtoPage(presupuestosActivo, presupuestosActivo.size());

	}

	@SuppressWarnings("unchecked")
	public DtoPresupuestoGraficoActivo findLastPresupuesto(DtoActivosTrabajoFilter dtoFilter) {

		DtoPresupuestoGraficoActivo presupuestoGrafico = new DtoPresupuestoGraficoActivo();

		SimpleDateFormat dfAnyo = new SimpleDateFormat("yyyy"); 
		String ejercicioActual = dfAnyo.format(new Date());
		
		Activo activo = getActivoById(Long.parseLong(dtoFilter.getIdActivo()));
		Boolean esMatrizoUA = false;
		
		if(activoDao.isUnidadAlquilable(activo.getId())) {
			if(!Checks.esNulo(activoDao.getAgrupacionPAByIdActivoConFechaBaja(activo.getId()))){
				activo = getActivoById(activoDao.getIdActivoMatriz(activoDao.getAgrupacionPAByIdActivoConFechaBaja(activo.getId()).getId()));
				esMatrizoUA = true;
				dtoFilter.setIdActivo(Long.toString(activo.getId()));
			}
			
		}else if(activoDao.isActivoMatriz(activo.getId())) {
			esMatrizoUA = true;
		}
		

		Long idPresupuesto = activoApi.getUltimoHistoricoPresupuesto(Long.parseLong(dtoFilter.getIdActivo()));
		DtoHistoricoPresupuestosFilter dtoFiltroHistorico = new DtoHistoricoPresupuestosFilter();
		dtoFiltroHistorico.setIdActivo(dtoFilter.getIdActivo());
		dtoFiltroHistorico.setIdPresupuesto(String.valueOf(idPresupuesto));
		dtoFiltroHistorico.setLimit(1);
		dtoFiltroHistorico.setStart(0);

		// Esta consulta solo deberia obtener 1 registro: el presupuesto para el
		// ultimo ejercicio registrado (y no borrado)
		// NO hay que coger el primer registro que salga en el historico de
		// presupuestos porque si no sale ordenado, no coge el bueno
		// esto se hace gracias a calcular el id de presupuesto con el metodo
		// "getUltimoHistoricoPresupuesto"

		VBusquedaPresupuestosActivo presupuestoActivo = presupuestoManager.getListHistoricoPresupuestos(dtoFiltroHistorico).get(0);
		// Disponible para ejercicio actual
		// Se calcula el disponible, el gasto conforme la lógica anterior, pero optimizando costes
		dtoFilter.setEjercicioPresupuestario(ejercicioActual);
		List<VBusquedaActivosTrabajoPresupuesto> activosTrabajo = presupuestoManager.getListActivosPresupuesto(dtoFilter);
		
		
		if(esMatrizoUA) {
			Page vista = trabajoApi.getActivoMatrizPresupuesto(dtoFilter);
			if (vista.getTotalCount() > 0) {
				
				List<VBusquedaActivoMatrizPresupuesto>  activosMatriz = (List<VBusquedaActivoMatrizPresupuesto>) vista.getResults();
				VBusquedaActivoMatrizPresupuesto activoMatriz = activosMatriz.get(0);
				
				presupuestoGrafico.setDisponible(activoMatriz.getSaldoDisponible());
				presupuestoGrafico.setGastado(activoMatriz.getImporteTrabajos());
				presupuestoGrafico.setDispuesto(activoMatriz.getImporteTrabajosPendientesPago());
				
				
				presupuestoGrafico.setGastado(presupuestoGrafico.getGastado() - presupuestoGrafico.getDispuesto());
				presupuestoGrafico.setPresupuesto(presupuestoGrafico.getDisponible() + presupuestoGrafico.getDispuesto() + presupuestoGrafico.getGastado());
				presupuestoGrafico.setDisponiblePorcentaje(Double.valueOf(((presupuestoGrafico.getDisponible() / presupuestoGrafico.getPresupuesto()) * 100)));
				presupuestoGrafico.setDispuestoPorcentaje(Double.valueOf(((presupuestoGrafico.getDispuesto() / presupuestoGrafico.getPresupuesto()) * 100)));
				presupuestoGrafico.setGastadoPorcentaje(Double.valueOf(((presupuestoGrafico.getGastado() / presupuestoGrafico.getPresupuesto()) * 100)));
				presupuestoGrafico.setEjercicio(presupuestoActivo.getEjercicioAnyo());
				
			}
		}else if (!Checks.estaVacio(activosTrabajo)) {
			presupuestoGrafico.setDisponible(new Double(activosTrabajo.get(0).getSaldoDisponible()));
			presupuestoGrafico.setGastado(Double.valueOf(0));
			presupuestoGrafico.setDispuesto(Double.valueOf(0));
			
			for(VBusquedaActivosTrabajoPresupuesto activoTrabajoTemp : activosTrabajo){
				
				if("1".equals(activoTrabajoTemp.getEstadoContable())){
					presupuestoGrafico.setGastado(
							presupuestoGrafico.getGastado() + new Double(activoTrabajoTemp.getImporteParticipa()));
				}
				
				if("1".equals(activoTrabajoTemp.getEstadoContable()) && DDEstadoTrabajo.ESTADO_PENDIENTE_PAGO.equals(activoTrabajoTemp.getCodigoEstado())){
					presupuestoGrafico.setDispuesto(
							presupuestoGrafico.getDispuesto() + new Double(activoTrabajoTemp.getImporteParticipa()));
				}
			}
			
			presupuestoGrafico.setGastado(presupuestoGrafico.getGastado() - presupuestoGrafico.getDispuesto());
			presupuestoGrafico.setPresupuesto(presupuestoGrafico.getDisponible() + presupuestoGrafico.getDispuesto()
					+ presupuestoGrafico.getGastado());
			presupuestoGrafico.setDisponiblePorcentaje(
					Double.valueOf(((presupuestoGrafico.getDisponible() / presupuestoGrafico.getPresupuesto()) * 100)));
			presupuestoGrafico.setDispuestoPorcentaje(
					Double.valueOf(((presupuestoGrafico.getDispuesto() / presupuestoGrafico.getPresupuesto()) * 100)));
			presupuestoGrafico.setGastadoPorcentaje(
					Double.valueOf(((presupuestoGrafico.getGastado() / presupuestoGrafico.getPresupuesto()) * 100)));

			presupuestoGrafico.setEjercicio(presupuestoActivo.getEjercicioAnyo());

		} else {

			if (presupuestoActivo.getSumaIncrementos() != null) {
				presupuestoGrafico.setDisponible(
						presupuestoActivo.getImporteInicial() + presupuestoActivo.getSumaIncrementos());
			} else {
				presupuestoGrafico.setDisponible(presupuestoActivo.getImporteInicial());
			}
			presupuestoGrafico.setDisponiblePorcentaje(Double.valueOf(100));
			presupuestoGrafico.setEjercicio(presupuestoActivo.getEjercicioAnyo());
			presupuestoGrafico.setDispuesto(Double.valueOf(0));
			presupuestoGrafico.setGastado(Double.valueOf(0));
			presupuestoGrafico.setDispuestoPorcentaje(Double.valueOf(0));
			presupuestoGrafico.setGastadoPorcentaje(Double.valueOf(0));
			presupuestoGrafico.setPresupuesto(presupuestoGrafico.getDisponible());

		}
			
		
		return presupuestoGrafico;

	}

	public List<DtoIncrementoPresupuestoActivo> findAllIncrementosPresupuestoById(Long idPresupuesto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "presupuestoActivo.id", idPresupuesto);
		Order order = new Order(OrderType.DESC, "fechaAprobacion");
		List<DtoIncrementoPresupuestoActivo> listaDto = new ArrayList<DtoIncrementoPresupuestoActivo>();
		
		if(!Checks.esNulo(idPresupuesto)) {
			List<IncrementoPresupuesto> listaPresupuestos = genericDao.getListOrdered(IncrementoPresupuesto.class, order,
					filtro);
			
	
			for (int i = 0; i < listaPresupuestos.size(); i++) {
				DtoIncrementoPresupuestoActivo dtoPresupuesto = new DtoIncrementoPresupuestoActivo();
	
				try {
	
					IncrementoPresupuesto incrementoPresupuesto = listaPresupuestos.get(i);
					BeanUtils.copyProperties(dtoPresupuesto, incrementoPresupuesto);
	
					beanUtilNotNull.copyProperty(dtoPresupuesto, "presupuestoActivoImporte",
							incrementoPresupuesto.getPresupuestoActivo().getImporteInicial());
					if (incrementoPresupuesto.getTrabajo() != null) {
						beanUtilNotNull.copyProperty(dtoPresupuesto, "codigoTrabajo",
								incrementoPresupuesto.getTrabajo().getNumTrabajo());
					}
	
				} catch (IllegalAccessException e) {
					logger.error("Error en ActivoAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("Error en ActivoAdapter", e);
				}
	
				listaDto.add(dtoPresupuesto);
			}
		}

		return listaDto;
	}

	public WebDto getTabActivo(Long id, String tab) throws IllegalAccessException, InvocationTargetException {

		TabActivoService tabActivoService = tabActivoFactory.getService(tab);
		Activo activo = activoApi.get(id);
		
		return tabActivoService.getTabData(activo);

	}

	@Transactional(readOnly = false)
	public boolean saveTabActivo(WebDto dto, Long id, String tab) {

		if (this.saveTabActivoTransactional(dto, id, tab)) {
			if(tab != null && tab.equals("datosbasicos")){
				DtoActivoFichaCabecera dtofichacabecera = (DtoActivoFichaCabecera) dto;
				Activo activo = activoApi.get(id);
				if ((dto instanceof DtoActivoFichaCabecera) 
						&& !Checks.esNulo(dtofichacabecera.getTipoComercializacionCodigo())
						&& activoApi.isActivoPerteneceAgrupacionRestringida(activo)) {
					List<ActivoAgrupacionActivo> agrupacionActivos = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId()).getAgrupacion().getActivos();	
					for (ActivoAgrupacionActivo agrupacionActivo : agrupacionActivos) {
						this.updateGestoresTabActivoTransactional(dto, agrupacionActivo.getActivo().getId());
						this.actualizarEstadoPublicacionActivo(agrupacionActivo.getActivo().getId());
					}
				} else {
					this.updateGestoresTabActivoTransactional(dto, id);
					if(!Checks.esNulo(dtofichacabecera.getCheckGestorComercial()) || !Checks.esNulo(dtofichacabecera.getExcluirValidacionesBool())){
						ArrayList<Long> listaActivo = new ArrayList<Long>();
						listaActivo.add(id);
						this.actualizarEstadoPublicacionActivoPerimetro(listaActivo, new ArrayList<Long>());
					}else {
						this.actualizarEstadoPublicacionActivo(id);
					}
				}
			}

		}
		return true;
	}
	
	@Transactional(readOnly = false)
	public boolean actualizarEstadoPublicacionActivo(Long idActivo) {
		return actualizarEstadoPublicacionActivo(idActivo, false);
	}
	
	@Transactional(readOnly = false)
	public boolean actualizarEstadoPublicacionActivo(Long idActivo, boolean asincrono) {
		ArrayList<Long> listaIdActivo = new ArrayList<Long>();
		listaIdActivo.add(idActivo);
		return this.actualizarEstadoPublicacionActivo(listaIdActivo, asincrono);
	}
	
	@Transactional(readOnly = false)
	public boolean actualizarEstadoPublicacionActivo(ArrayList<Long> listaIdActivo,boolean asincrono){
		boolean resultado = true;
		if(asincrono){
			activoDao.hibernateFlush();
			Thread hilo = new Thread(new EjecutarSPPublicacionAsincrono(genericAdapter.getUsuarioLogado().getUsername(), listaIdActivo));
			hilo.start();
			resultado = true;
		}else{
			if(listaIdActivo != null && !listaIdActivo.isEmpty()){
				boolean isOk = activoEstadoPublicacionApi.actualizarEstadoPublicacionDelActivoOrAgrupacionRestringidaSiPertenece(listaIdActivo,true);
				if(isOk) {
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(listaIdActivo);
				}
			}
		}
		return resultado;
	}
	
	@Transactional(readOnly = false)
	public boolean actualizarEstadoPublicacionActivo(Long idActivo, Boolean asincrono) {
		ArrayList<Long> listaIdActivo = new ArrayList<Long>();
		listaIdActivo.add(idActivo);
		return actualizarEstadoPublicacionActivo(listaIdActivo, asincrono);
		
	}

	@Transactional(readOnly = false)
	public boolean guardarCondicionantesDisponibilidad(Long idActivo, DtoCondicionantesDisponibilidad dto) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		ActivoSituacionPosesoria condicionantesDisponibilidad = genericDao.get(ActivoSituacionPosesoria.class, filtro);
		boolean success = false;
		if (Checks.esNulo(dto) || (Checks.esNulo(dto.getOtro()) && Checks.esNulo(condicionantesDisponibilidad))) {
			success = false;
		} else{
			success = activoApi.saveCondicionantesDisponibilidad(idActivo, dto);
			activoApi.updateCondicionantesDisponibilidad(idActivo);
		}
		if (success) {
			actualizarEstadoPublicacionActivo(idActivo);
		}

		return success;
	}

	@Transactional(readOnly = false)
	public boolean guardarEstadoPublicacionAlquiler(DtoDatosPublicacionActivo dto) {
		if(!Checks.esNulo(dto.getEleccionUsuarioTipoPublicacionAlquiler()) || (!Checks.esNulo(dto.getPublicarAlquiler()) && !dto.getPublicarAlquiler())) {
			boolean success = activoEstadoPublicacionApi.setDatosPublicacionActivo(dto);
			if (success)
				actualizarEstadoPublicacionActivo(dto.getIdActivo());

			return success;
		}else {
			return false;
		}
	}

	@Transactional(readOnly = false)
	public boolean saveTabActivoTransactional(WebDto dto, Long id, String tab) {
		TabActivoService tabActivoService = tabActivoFactory.getService(tab);
		Activo activo = activoApi.get(id);

		if (dto instanceof DtoActivoFichaCabecera) {
			DtoActivoFichaCabecera dtofichacabecera = (DtoActivoFichaCabecera) dto;
			boolean tieneAgrupVenta=false;
			if(DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(dtofichacabecera.getTipoComercializacionCodigo())){
				List<ActivoAgrupacionActivo> agrupaciones = activo.getAgrupaciones();
				for(ActivoAgrupacionActivo agrupActivo : agrupaciones) {
					ActivoAgrupacion agrup= agrupActivo.getAgrupacion();
					if(agrup.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA) 
							&& Checks.esNulo(agrup.getFechaBaja())) {
						tieneAgrupVenta=true;
						break;
					}
				}
			}
			
			if (!tieneAgrupVenta) {
				//si el activo viene de destino comercial = venta y pasa a "alquiler" o "alquiler y venta"
				//en la pestaña patromonio, se desmarca el check de perimetro y el estado alquiler, pasa a libre
				if (activoApi.isActivoPerteneceAgrupacionRestringida(activo)
						&& (tabActivoService instanceof TabActivoDatosBasicos)
						&& !Checks.esNulo(((DtoActivoFichaCabecera) dto).getTipoComercializacionCodigo())) {
					List<ActivoAgrupacionActivo> agrupacionActivos = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId()).getAgrupacion().getActivos();	
					for (ActivoAgrupacionActivo agrupacionActivo : agrupacionActivos) {
						if(agrupacionActivo.getActivo() != null && dto != null && 
							agrupacionActivo.getActivo().getActivoPublicacion() != null && 
						    agrupacionActivo.getActivo().getActivoPublicacion().getTipoComercializacion() != null) {
								guardamosPatrimonio(agrupacionActivo.getActivo(), dto);
						}else {
							logger.error("El activo no tiene registros de publicación o tipo de comercialización");
						}
					}
				} else {
					if(activo != null && dto != null && 
							activo.getActivoPublicacion() != null && 
							activo.getActivoPublicacion().getTipoComercializacion() != null) {
						guardamosPatrimonio(activo, dto);
					}else {
						logger.error("El activo no tiene registros de publicación o tipo de comercialización");
					}
				}
				//-----------------------------------------------------------
				activo = tabActivoService.saveTabActivo(activo, dto);
				activoApi.saveOrUpdate(activo);
				
				if (activoApi.isActivoPerteneceAgrupacionRestringida(activo)
						&& (tabActivoService instanceof TabActivoDatosBasicos)
						&& !Checks.esNulo(((DtoActivoFichaCabecera) dto).getTipoComercializacionCodigo())) {
					List<ActivoAgrupacionActivo> agrupacionActivos = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId()).getAgrupacion().getActivos();	
					for (ActivoAgrupacionActivo agrupacionActivo : agrupacionActivos) {
						// Metodo que recoge funciones que requieren el guardado previo de los datos
						afterSaveTabActivo(dto, agrupacionActivo.getActivo(), tabActivoService);
					}
				} else {
					// Metodo que recoge funciones que requieren el guardado previo de los datos
					afterSaveTabActivo(dto, activo, tabActivoService);
				}

				return true;

			} else {
				throw new JsonViewerException("El activo pertenece a una agrupación comercial-venta, no se puede cambiar el destino comercial a alquiler del activo");
			}

		} else {
			activo = tabActivoService.saveTabActivo(activo, dto);
			activoApi.saveOrUpdate(activo);

			// Metodo que recoge funciones que requieren el guardado previo de los
			// datos
			afterSaveTabActivo(dto, activo, tabActivoService);

			return true;
		}
	}

	private void guardamosPatrimonio(Activo activo, WebDto dto) {
		if(DDTipoComercializacion.CODIGO_VENTA.equals(activo.getActivoPublicacion().getTipoComercializacion().getCodigo())
				&& ((DDTipoComercializacion.CODIGO_SOLO_ALQUILER).equals(((DtoActivoFichaCabecera)dto).getTipoComercializacionCodigo()) 
						|| (DDTipoComercializacion.CODIGO_ALQUILER_VENTA).equals(((DtoActivoFichaCabecera)dto).getTipoComercializacionCodigo()))){
			
			//HREOS-5263: Al cambiar de Venta a Alquiler un activo ponemos por defecto el tipo de alquiler a "No definido".
			Filter filtro0 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoAlquiler.CODIGO_NO_DEFINIDO);
			DDTipoAlquiler tipoAlquiler= genericDao.get(DDTipoAlquiler.class, filtro0);
			activo.setTipoAlquiler(tipoAlquiler);
			
			ActivoPatrimonio actPatrimonio = activoPatrimonio.getActivoPatrimonioByActivo(activo.getId());
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoEstadoAlquiler.ESTADO_ALQUILER_LIBRE);
			DDTipoEstadoAlquiler estadoAlquiler= genericDao.get(DDTipoEstadoAlquiler.class, filtro);
			
			if(!Checks.esNulo(actPatrimonio)){
				actPatrimonio.setCheckHPM(true);
				actPatrimonio.setTipoEstadoAlquiler(estadoAlquiler);
				activoPatrimonio.save(actPatrimonio);
			}else{
				//creamos el registro en la tabla si no existe.
				String username = genericAdapter.getUsuarioLogado().getUsername();
				Date fecha = new Date();
				actPatrimonio = new ActivoPatrimonio();
				actPatrimonio.setActivo(activo);
				actPatrimonio.setCheckHPM(true);
				actPatrimonio.setTipoEstadoAlquiler(estadoAlquiler);
				
				Auditoria auditoria = new Auditoria();
				auditoria.setUsuarioCrear(username);
				auditoria.setFechaCrear(fecha);
				auditoria.setBorrado(false);
				actPatrimonio.setAuditoria(auditoria);
				activoPatrimonio.save(actPatrimonio);
			}
			
		}else if((DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(activo.getActivoPublicacion().getTipoComercializacion().getCodigo()) 
					|| DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(activo.getActivoPublicacion().getTipoComercializacion().getCodigo())) 
				&& (DDTipoComercializacion.CODIGO_VENTA).equals(((DtoActivoFichaCabecera)dto).getTipoComercializacionCodigo())){
			
			ActivoPatrimonio actPatrimonio = activoPatrimonio.getActivoPatrimonioByActivo(activo.getId());
			if(!Checks.esNulo(actPatrimonio)){
				actPatrimonio.setCheckHPM(false);
				activoPatrimonio.save(actPatrimonio);
			}
		}
	}

	@Transactional(readOnly = false)
	public void updateGestoresTabActivoTransactional(WebDto dto, Long id) {

		Activo activo = activoApi.get(id);
		ActivoPatrimonio actPatrimonio = activoPatrimonio.getActivoPatrimonioByActivo(activo.getId());

		if (dto instanceof DtoActivoPatrimonio && !Checks.esNulo(actPatrimonio)
				&& !Checks.esNulo(((DtoActivoPatrimonio) dto).getChkPerimetroAlquiler())) {
			// todos los activos que en REM están marcados dentro del perímetro de alquiler
			// Cuando en REM se marque que un activo entra en el perímetro de alquiler (bien
			// individual o masivamente) REM asignará Gestor y Supervisor de activo de este
			// tipo según cliente y provincia
			if (!Checks.esNulo(((DtoActivoPatrimonio) dto).getChkPerimetroAlquiler())) {
				if (((DtoActivoPatrimonio) dto).getChkPerimetroAlquiler()) {

					// anyadimos el nuevo gestor
					if (!this.anyadirGestor(activo, GestorActivoApi.CODIGO_GESTOR_ALQUILERES))
						logger.error("Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "
								+ GestorActivoApi.CODIGO_GESTOR_ALQUILERES);
					if (!this.anyadirGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_ALQUILERES))
						logger.error("Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "
								+ GestorActivoApi.CODIGO_SUPERVISOR_ALQUILERES);

					// si el codigo del tipo de actvo no es nulo, comprabamos si es de tipo de suelo
					// borramos el gestor/supervisor de suelos en caso contrario el de alquileres.
					if (!Checks.esNulo(activo.getTipoActivo().getCodigo())) {
						if (activo.getTipoActivo().getCodigo().equals(DDTipoActivo.COD_SUELO)) {
							this.borrarGestor(activo, GestorActivoApi.CODIGO_GESTOR_SUELOS);
							this.borrarGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_SUELOS);
						} else {
							this.borrarGestor(activo, GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES);
							this.borrarGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES);
						}
					}

				}

				// Cuando en REM se marque que un activo sale del perímetro de alquiler (bien
				// individual o masivamente) REM eliminará el Gestor y Supervisor de activo de
				// este tipo.

				else if (!((DtoActivoPatrimonio) dto).getChkPerimetroAlquiler()
						&& gestorActivoApi.existeGestorEnActivo(activo, GestorActivoApi.CODIGO_GESTOR_ALQUILERES)) {
					// en este caso si existieran trabajos abiertos REM los reasignará al Gestor de
					// mantenimiento (ACTIVO)

					this.cambiarTrabajosActivosAGestorActivo(activo, GestorActivoApi.CODIGO_GESTOR_ALQUILERES);
					this.borrarGestor(activo, GestorActivoApi.CODIGO_GESTOR_ALQUILERES);
					this.borrarGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_ALQUILERES);

					// si el codigo del tipo de actvo no es nulo, comprabamos si es de tipo de suelo
					// anyadimos el gestor/supervisor de suelos en caso contrario el de alquileres.
					if (!Checks.esNulo(activo.getTipoActivo().getCodigo())) {

						if (activo.getTipoActivo().getCodigo().equals(DDTipoActivo.COD_SUELO)) {

							if (!this.anyadirGestor(activo, GestorActivoApi.CODIGO_GESTOR_SUELOS))
								logger.error(
										"Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "
												+ GestorActivoApi.CODIGO_GESTOR_SUELOS);
							if (!this.anyadirGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_SUELOS))
								logger.error(
										"Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "
												+ GestorActivoApi.CODIGO_SUPERVISOR_SUELOS);
						} else {
							if (!this.anyadirGestor(activo, GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES))
								logger.error(
										"Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "
												+ GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES);
							if (!this.anyadirGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES))
								logger.error(
										"Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "
												+ GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES);

						}
					}
				}
			}
			// Ampliación de [HREOS-4985]
			// Al cambiar el destino comercial de Venta a Alquiler/Alquiler y Venta
		} else if (dto instanceof DtoActivoFichaCabecera
				&& !Checks.esNulo(((DtoActivoFichaCabecera) dto).getTipoComercializacionCodigo())
				&& (((DtoActivoFichaCabecera) dto).getTipoComercializacionCodigo()
						.equals(DDTipoComercializacion.CODIGO_SOLO_ALQUILER)
						|| ((DtoActivoFichaCabecera) dto).getTipoComercializacionCodigo()
								.equals(DDTipoComercializacion.CODIGO_ALQUILER_VENTA))) {

			// anyadimos el nuevo gestor
			if (Checks
					.esNulo(gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ALQUILERES))) {
				if (!this.anyadirGestor(activo, GestorActivoApi.CODIGO_GESTOR_ALQUILERES)) {
					logger.error("Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "
							+ GestorActivoApi.CODIGO_GESTOR_ALQUILERES);
				}
			}
			if (Checks
					.esNulo(gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ALQUILERES))) {
				if (!this.anyadirGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_ALQUILERES)) {
					logger.error("Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "
							+ GestorActivoApi.CODIGO_SUPERVISOR_ALQUILERES);
				}
			}

			// si el codigo del tipo de actvo no es nulo, comprabamos si es de tipo de suelo
			// borramos el gestor/supervisor de suelos en caso contrario el de alquileres.
			if (!Checks.esNulo(activo.getTipoActivo().getCodigo())) {
				if (activo.getTipoActivo().getCodigo().equals(DDTipoActivo.COD_SUELO)) {
					this.borrarGestor(activo, GestorActivoApi.CODIGO_GESTOR_SUELOS);
					this.borrarGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_SUELOS);
				} else {
					this.borrarGestor(activo, GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES);
					this.borrarGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES);
				}
			}
			// Al cambiar el destino comercial a Venta de Alquiler/Alquiler y Venta
		} else if (dto instanceof DtoActivoFichaCabecera
				&& !Checks.esNulo(((DtoActivoFichaCabecera) dto).getTipoComercializacionCodigo())
				&& ((DtoActivoFichaCabecera) dto).getTipoComercializacionCodigo()
						.equals(DDTipoComercializacion.CODIGO_VENTA)) {

			this.cambiarTrabajosActivosAGestorActivo(activo, GestorActivoApi.CODIGO_GESTOR_ALQUILERES);
			this.borrarGestor(activo, GestorActivoApi.CODIGO_GESTOR_ALQUILERES);
			this.borrarGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_ALQUILERES);
			// si el codigo del tipo de actvo no es nulo, comprabamos si es de tipo de suelo
			// anyadimos el gestor/supervisor de suelos en caso contrario el de alquileres.
			if (!Checks.esNulo(activo.getTipoActivo().getCodigo())) {
				if (activo.getTipoActivo().getCodigo().equals(DDTipoActivo.COD_SUELO)) {
					if (Checks.esNulo(
							gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_SUELOS))) {
						if (!this.anyadirGestor(activo, GestorActivoApi.CODIGO_GESTOR_SUELOS)) {
							logger.error(
									"Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "
											+ GestorActivoApi.CODIGO_GESTOR_SUELOS);
						}
					}
					if (Checks.esNulo(
							gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_SUELOS))) {
						if (!this.anyadirGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_SUELOS)) {
							logger.error(
									"Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "
											+ GestorActivoApi.CODIGO_SUPERVISOR_SUELOS);
						}
					}
				} else {
					if (Checks.esNulo(gestorActivoApi.getGestorByActivoYTipo(activo,
							GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES))) {
						if (!this.anyadirGestor(activo, GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES)) {
							logger.error(
									"Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "
											+ GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES);
						}
					}
					if (Checks.esNulo(gestorActivoApi.getGestorByActivoYTipo(activo,
							GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES))) {
						if (!this.anyadirGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES)) {
							logger.error(
									"Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "
											+ GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES);
						}
					}
				}
			}
		}

		// todos los activos existentes en REM que no estén dentro del perímetro de
		// alquiler pero que alguna vez si que lo han estado, en este caso es posible
		// que en algun momento el activo haya estado
		// dentro del perimetro de alquiler por lo que hacemos la siguiente comprobación
		else if (!Checks.esNulo(actPatrimonio) && !Checks.esNulo(actPatrimonio.getCheckHPM())) {
			if (!actPatrimonio.getCheckHPM()) {
				ajustaGestores(activo);
			}
		}
		// todos los activos existentes en REM que no estén dentro del perímetro de
		// alquiler y que nunca lo hayan estado
		else {
			ajustaGestores(activo);
		}
	}

	private void ajustaGestores(Activo activo){

		if(DDTipoActivo.COD_SUELO.equals(activo.getTipoActivo().getCodigo()) && !gestorActivoApi.existeGestorEnActivo(activo, GestorActivoApi.CODIGO_GESTOR_SUELOS)
				&& DDEstadoActivo.ESTADO_ACTIVO_SUELO.equals(activo.getEstadoActivo().getCodigo())){
			// ANYADIR GESTOR Y SUPERVISOR SUELOS
			if(!this.anyadirGestor(activo, GestorActivoApi.CODIGO_GESTOR_SUELOS))
				logger.error("Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "+GestorActivoApi.CODIGO_GESTOR_SUELOS);
			if(!this.anyadirGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_SUELOS))
				logger.error("Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "+GestorActivoApi.CODIGO_SUPERVISOR_SUELOS);

		}else if(gestorActivoApi.existeGestorEnActivo(activo, GestorActivoApi.CODIGO_GESTOR_SUELOS)){
			// Cambiar los gestores
			this.cambiarTrabajosActivosAGestorActivo(activo,GestorActivoApi.CODIGO_GESTOR_SUELOS);
			// BORRAR GESTOR Y SUPERVISOR SUELOS
			this.borrarGestor(activo,GestorActivoApi.CODIGO_GESTOR_SUELOS);
			this.borrarGestor(activo,GestorActivoApi.CODIGO_SUPERVISOR_SUELOS);
		}

		if(!DDTipoActivo.COD_SUELO.equals(activo.getTipoActivo().getCodigo()) && !gestorActivoApi.existeGestorEnActivo(activo, GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES)
				&& (DDEstadoActivo.ESTADO_ACTIVO_EN_CONSTRUCCION_EN_CURSO.equals(activo.getEstadoActivo().getCodigo())
						|| DDEstadoActivo.ESTADO_ACTIVO_RUINA.equals(activo.getEstadoActivo().getCodigo())
						|| DDEstadoActivo.ESTADO_ACTIVO_EN_CONSTRUCCION_PARADA.equals(activo.getEstadoActivo().getCodigo())
						|| DDEstadoActivo.ESTADO_ACTIVO_OBRA_NUEVA_VANDALIZADO.equals(activo.getEstadoActivo().getCodigo())
						|| DDEstadoActivo.ESTADO_ACTIVO_NO_OBRA_NUEVA_VANDALIZADO.equals(activo.getEstadoActivo().getCodigo())
						|| DDEstadoActivo.ESTADO_ACTIVO_EDIFICIO_A_REHABILITAR.equals(activo.getEstadoActivo().getCodigo())
						|| DDEstadoActivo.ESTADO_ACTIVO_NO_OBRA_NUEVA_PDTE_LEGALIZAR.equals(activo.getEstadoActivo().getCodigo())
						|| DDEstadoActivo.ESTADO_ACTIVO_OBRA_NUEVA_PDTE_LEGALIZAR.equals(activo.getEstadoActivo().getCodigo()))){
		
			if(!this.anyadirGestor(activo, GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES))
				logger.error("Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "+GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES);
			if(!this.anyadirGestor(activo, GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES))
				logger.error("Error en ActivoAdpter [saveTabActivoTransactional]: No se ha podido guardar el "+GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES);
		}else if(!DDTipoActivo.COD_SUELO.equals(activo.getTipoActivo().getCodigo()) && gestorActivoApi.existeGestorEnActivo(activo, GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES)
				&& (!DDEstadoActivo.ESTADO_ACTIVO_EN_CONSTRUCCION_EN_CURSO.equals(activo.getEstadoActivo().getCodigo())
						&& !DDEstadoActivo.ESTADO_ACTIVO_RUINA.equals(activo.getEstadoActivo().getCodigo())
						&& !DDEstadoActivo.ESTADO_ACTIVO_EN_CONSTRUCCION_PARADA.equals(activo.getEstadoActivo().getCodigo())
						&& !DDEstadoActivo.ESTADO_ACTIVO_OBRA_NUEVA_VANDALIZADO.equals(activo.getEstadoActivo().getCodigo())
						&& !DDEstadoActivo.ESTADO_ACTIVO_NO_OBRA_NUEVA_VANDALIZADO.equals(activo.getEstadoActivo().getCodigo())
						&& !DDEstadoActivo.ESTADO_ACTIVO_EDIFICIO_A_REHABILITAR.equals(activo.getEstadoActivo().getCodigo())
						&& !DDEstadoActivo.ESTADO_ACTIVO_NO_OBRA_NUEVA_PDTE_LEGALIZAR.equals(activo.getEstadoActivo().getCodigo())
						&& !DDEstadoActivo.ESTADO_ACTIVO_OBRA_NUEVA_PDTE_LEGALIZAR.equals(activo.getEstadoActivo().getCodigo()))){
			// BORRAR GESTOR Y SUPERVISOR EDIFICACIONES
			this.borrarGestor(activo,GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES);
			this.borrarGestor(activo,GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES);
		}else if(DDTipoActivo.COD_SUELO.equals(activo.getTipoActivo().getCodigo())) {
			// Cambiar los gestores
			this.cambiarTrabajosActivosAGestorActivo(activo,GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES);
			// BORRAR GESTOR Y SUPERVISOR EDIFICACIONES
			this.borrarGestor(activo,GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES);
			this.borrarGestor(activo,GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES);
		}
	}

	private boolean anyadirGestor(Activo activo, String tipoGestorCodigo) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", tipoGestorCodigo);
		EXTDDTipoGestor tipoGestor= genericDao.get(EXTDDTipoGestor.class, filtro);

		String username = gestorExpedienteComercialDao.getUsuarioGestor(activo.getId(), tipoGestorCodigo);
		Usuario user = usuarioManager.getByUsername(username);

		if(!Checks.esNulo(user) && !Checks.esNulo(tipoGestor) && !Checks.esNulo(activo)){

			GestorEntidadDto dtoGestor = new GestorEntidadDto();
			dtoGestor.setIdEntidad(activo.getId());
			dtoGestor.setIdUsuario(user.getId());
			dtoGestor.setIdTipoGestor(tipoGestor.getId());

			return this.insertarGestorAdicional(dtoGestor);

		}else{
			return false;
		}
	}

	/*
	 *
	 * Cambiar el Gestor de tipo Suelos o Edificaciones al Gestor de Activos cuando estos deben ser eliminados y tiene trabajos abiertos.
	 * @param activo Activo sobre el que vamos a trabajar
	 * @param tipoGestorCodigo código del tipo de gestor que estamos buscando para quitarle los trabajos activos. (Suelos o Edificaciones)
	 *
	 */
	private void cambiarTrabajosActivosAGestorActivo(Activo activo, String tipoGestorCodigo) {
		if(GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES.equals(tipoGestorCodigo)) {
			for(ActivoTrabajo activoTrabajo : activoApi.getActivoTrabajos(activo.getId())) {
				Usuario  usuGestor = activoTrabajo.getTrabajo().getUsuarioResponsableTrabajo();
				String estadoTrabajo = activoTrabajo.getTrabajo().getEstado().getCodigo();

				if(gestorActivoApi.isGestorEdificaciones(activo, usuGestor) && (
						DDEstadoTrabajo.ESTADO_SOLICITADO.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_EN_TRAMITE.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_IMPOSIBLE_OBTENCION.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_CEE_PENDIENTE_ETIQUETA.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_FINALIZADO_PENDIENTE_VALIDACION.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_PENDIENTE_CIERRE_ECONOMICO.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_VALIDADO.equals(estadoTrabajo)
						)) {
					// Asignar trabajos a gestor Activo
					activoTrabajo.getTrabajo().setUsuarioResponsableTrabajo(gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO));
					trabajoDao.saveOrUpdate(activoTrabajo.getTrabajo());

				}
			}
		}else if(GestorActivoApi.CODIGO_GESTOR_SUELOS.equals(tipoGestorCodigo)) {
			for(ActivoTrabajo activoTrabajo : activoApi.getActivoTrabajos(activo.getId())) {
				Usuario  usuGestor = activoTrabajo.getTrabajo().getUsuarioResponsableTrabajo();
				String estadoTrabajo = activoTrabajo.getTrabajo().getEstado().getCodigo();

				if(gestorActivoApi.isGestorSuelos(activo, usuGestor) && (
						DDEstadoTrabajo.ESTADO_SOLICITADO.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_EN_TRAMITE.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_IMPOSIBLE_OBTENCION.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_CEE_PENDIENTE_ETIQUETA.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_FINALIZADO_PENDIENTE_VALIDACION.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_PENDIENTE_CIERRE_ECONOMICO.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_VALIDADO.equals(estadoTrabajo)
						)) {
					// Asignar trabajos a gestor Activo
					activoTrabajo.getTrabajo().setUsuarioResponsableTrabajo(gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO));
					trabajoDao.saveOrUpdate(activoTrabajo.getTrabajo());

				}
			}
		}else if(GestorActivoApi.CODIGO_GESTOR_ALQUILERES.equals(tipoGestorCodigo)) {
			for(ActivoTrabajo activoTrabajo : activoApi.getActivoTrabajos(activo.getId())) {
				Usuario  usuGestor = activoTrabajo.getTrabajo().getUsuarioResponsableTrabajo();
				String estadoTrabajo = activoTrabajo.getTrabajo().getEstado().getCodigo();

				if(gestorActivoApi.isGestorAlquileres(activo, usuGestor) && (
						DDEstadoTrabajo.ESTADO_SOLICITADO.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_EN_TRAMITE.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_IMPOSIBLE_OBTENCION.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_CEE_PENDIENTE_ETIQUETA.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_FINALIZADO_PENDIENTE_VALIDACION.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_PENDIENTE_CIERRE_ECONOMICO.equals(estadoTrabajo) ||
						DDEstadoTrabajo.ESTADO_VALIDADO.equals(estadoTrabajo)
						)) {
					// Asignar trabajos a gestor Activo
					activoTrabajo.getTrabajo().setUsuarioResponsableTrabajo(gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO));
					trabajoDao.saveOrUpdate(activoTrabajo.getTrabajo());


				}

			}

	}
	}
	
	
	// Metodo que actualize el responsable del trabajo para el activo
	@Transactional(readOnly = false)
	public void cambiarResponsableTrabajosActivos(Activo activo) {
		if (!Checks.esNulo(activo)) {
			Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());	
			Filter trabajoFilter = genericDao.createFilter(FilterType.EQUALS, "trabajo.auditoria.borrado", false);
			List<ActivoTrabajo> listaTrabajos = genericDao.getList(ActivoTrabajo.class, activoFilter, trabajoFilter);
			ActivoPublicacion actPublicacion = genericDao.get(ActivoPublicacion.class, activoFilter);			
			if (DDTipoComercializacion.CODIGO_VENTA.equals(actPublicacion.getTipoComercializacion().getCodigo())) {
				if (!Checks.estaVacio(listaTrabajos)) {
					for (ActivoTrabajo activoTrabajo : listaTrabajos) {
						Usuario usuResponsable = activoTrabajo.getTrabajo().getUsuarioResponsableTrabajo();
						String estadoTrabajo = Checks.esNulo(activoTrabajo.getTrabajo().getEstado()) ? null : activoTrabajo.getTrabajo().getEstado().getCodigo();
						Usuario gestorActivo = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO);
						if (DDEstadoTrabajo.ESTADO_SOLICITADO.equals(estadoTrabajo)
								|| DDEstadoTrabajo.ESTADO_EN_TRAMITE.equals(estadoTrabajo)
								|| DDEstadoTrabajo.ESTADO_IMPOSIBLE_OBTENCION.equals(estadoTrabajo)
								|| DDEstadoTrabajo.ESTADO_CEE_PENDIENTE_ETIQUETA.equals(estadoTrabajo)
								|| DDEstadoTrabajo.ESTADO_FINALIZADO_PENDIENTE_VALIDACION.equals(estadoTrabajo)
								|| DDEstadoTrabajo.ESTADO_PENDIENTE_CIERRE_ECONOMICO.equals(estadoTrabajo)
								|| DDEstadoTrabajo.ESTADO_VALIDADO.equals(estadoTrabajo)) {
							if (!Checks.esNulo(gestorActivo) && !gestorActivo.equals(usuResponsable)) {
								Trabajo trabajo = activoTrabajo.getTrabajo();
								trabajo.setUsuarioResponsableTrabajo(gestorActivo);
								trabajoDao.saveOrUpdate(trabajo);
							}
						} else {
							Trabajo trabajo = activoTrabajo.getTrabajo();
							trabajo.setUsuarioResponsableTrabajo(usuResponsable);
							trabajoDao.saveOrUpdate(trabajo);
						}
					}
				}
			}
		}
	}
 

	private void borrarGestor(Activo activo, String tipoGestorCodigo) {

		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", tipoGestorCodigo);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, f1);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "activo", activo); 
		Filter f3 = genericDao.createFilter(FilterType.EQUALS, "tipoGestor",tipoGestor);

		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		GestorActivo actGest = genericDao.get(GestorActivo.class, f2,f3, filtroBorrado);
		

		if(!Checks.esNulo(actGest) && !Checks.esNulo(activo) && !Checks.esNulo(tipoGestor)){
			GestorEntidadDto dtoGestor = new GestorEntidadDto();
			dtoGestor.setIdEntidad(activo.getId());
			dtoGestor.setIdUsuario(actGest.getUsuario().getId());
			dtoGestor.setIdTipoGestor(tipoGestor.getId());
			dtoGestor.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO);
			gestorActivoApi.borrarGestorAdicionalEntidad(dtoGestor);
		}
	}

	@Transactional(readOnly = false)
	private void afterSaveTabActivo(WebDto dto, Activo activo, TabActivoService tabActivoService) {
		
		if (tabActivoService instanceof TabActivoDatosBasicos) {			

			((TabActivoDatosBasicos) tabActivoService).afterSaveTabActivo(activo, dto);

		} else if (tabActivoService instanceof TabActivoSitPosesoriaLlaves) {
			
			((TabActivoSitPosesoriaLlaves) tabActivoService).afterSaveTabActivo(activo, dto);
			
		}
		
		else if (tabActivoService instanceof TabActivoDatosRegistrales) {
			
			((TabActivoDatosRegistrales) tabActivoService).afterSaveTabActivo(activo, dto);

		}

		// Actualizacion Tipo comercializacion y Estado de disponibilidad
		// comercial del activo
		// Vinculado a varias pestanyas del activo
		updaterState.updaterStateDisponibilidadComercial(activo);

		if(tabActivoService instanceof TabActivoSaneamiento || tabActivoService instanceof TabActivoCargas){
			if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA)){
				Thread llamadaAsincrona = new Thread(new ConvivenciaRecovery(activo.getId(), new ModelMap(), usuarioManager.getUsuarioLogado().getUsername()));
				llamadaAsincrona.start();
			}
		}

	}

	@Transactional(readOnly = false)
	public Oferta createOfertaActivo(DtoOfertasFilter dto) throws Exception {
		Oferta ofertaCreada = null;
		
		List<ActivoOferta> listaActOfr = new ArrayList<ActivoOferta>();

		Activo activo = activoApi.get(dto.getIdActivo());

		// Comprobar el tipo de destino comercial que tiene actualmente el
		// activo y contrastar con la oferta.
		if (!Checks.esNulo(activo.getActivoPublicacion()) && !Checks.esNulo(activo.getActivoPublicacion().getTipoComercializacion())) {
			String comercializacion = activo.getActivoPublicacion().getTipoComercializacion().getCodigo();

			if (DDTipoOferta.CODIGO_VENTA.equals(dto.getTipoOferta())
					&& (!DDTipoComercializacion.CODIGO_VENTA.equals(comercializacion)
							&& !DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(comercializacion))) {
				throw new Exception(ActivoAdapter.OFERTA_INCOMPATIBLE_MSG);
			}

			if (DDTipoOferta.CODIGO_ALQUILER.equals(dto.getTipoOferta())
					&& (!DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(comercializacion)
							&& !DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(comercializacion))) {
				throw new Exception(ActivoAdapter.OFERTA_INCOMPATIBLE_MSG);
			}
		}

		try {
			
			ClienteComercial clienteComercial = new ClienteComercial();

			/*
			 * if(!Checks.esNulo(activo.getAgrupaciones()) &&
			 * activo.getAgrupaciones().size()!=0){ for(ActivoAgrupacionActivo
			 * agrupaciones: activo.getAgrupaciones()){ ActivoAgrupacion
			 * agrupacion = agrupaciones.getAgrupacion();
			 * if(agrupacion.getActivoPrincipal().getId().equals(activo.getId())
			 * ){ oferta.setAgrupacion(agrupacion); } } }
			 */

			String codigoEstado = this.getEstadoNuevaOferta(activo);

			DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDEstadoOferta.class, codigoEstado);
			DDTipoOferta tipoOferta = (DDTipoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoOferta.class,
					dto.getTipoOferta());
			DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getTipoDocumento());
			Long numOferta = activoDao.getNextNumOferta();

			Long clcremid = activoDao.getNextClienteRemId();
			clienteComercial.setNombre(dto.getNombreCliente());
			clienteComercial.setApellidos(dto.getApellidosCliente());
			clienteComercial.setDocumento(dto.getNumDocumentoCliente());
			clienteComercial.setTipoDocumento(tipoDocumento);
			clienteComercial.setRazonSocial(dto.getRazonSocialCliente());
			clienteComercial.setIdClienteRem(clcremid);
			
			
	
 
			if (!Checks.esNulo(dto.getTipoPersona())) {
				//Fleco malformación en envio de datos. 
				String tipo = "";
				if (DDTiposPersona.CODIGO_TIPO_PERSONA_FISICA.equals(dto.getTipoPersona()) || ("01").equals(dto.getTipoPersona()))
						tipo = DDTiposPersona.CODIGO_TIPO_PERSONA_FISICA;
				else if (DDTiposPersona.CODIGO_TIPO_PERSONA_JURIDICA.equals(dto.getTipoPersona()) || ("02").equals(dto.getTipoPersona()))
						tipo = DDTiposPersona.CODIGO_TIPO_PERSONA_JURIDICA;
				DDTiposPersona tipoPersona = genericDao.get(DDTiposPersona.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", tipo));
				if (!Checks.esNulo(tipoPersona)) {
					clienteComercial.setTipoPersona(tipoPersona);
				}
			}
			
			if (!Checks.esNulo(dto.getEstadoCivil())) {
				DDEstadosCiviles estadoCivil = (DDEstadosCiviles) genericDao.get(DDEstadosCiviles.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoCivil()));
				if (!Checks.esNulo(estadoCivil)) {
					clienteComercial.setEstadoCivil(estadoCivil);
				}
			}
			
			if (!Checks.esNulo(dto.getRegimenMatrimonial())) {
				DDRegimenesMatrimoniales regimen = (DDRegimenesMatrimoniales) genericDao.get(DDRegimenesMatrimoniales.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getRegimenMatrimonial()));
				if (!Checks.esNulo(regimen)) {
					clienteComercial.setRegimenMatrimonial(regimen);
				}
			}	
			
			if (!Checks.esNulo(dto.getCesionDatos())) {
				clienteComercial.setCesionDatos(dto.getCesionDatos());
			}
			
			if (!Checks.esNulo(dto.getTransferenciasInternacionales())) {
				clienteComercial.setTransferenciasInternacionales(dto.getTransferenciasInternacionales());
			}
			
			if (!Checks.esNulo(dto.getComunicacionTerceros())) {
				clienteComercial.setComunicacionTerceros(dto.getComunicacionTerceros());
			}
			
			TmpClienteGDPR tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class,
					genericDao.createFilter(FilterType.EQUALS, "numDocumento", dto.getNumDocumentoCliente()));

			List<ClienteComercial> clientes = genericDao.getList(ClienteComercial.class,
					genericDao.createFilter(FilterType.EQUALS, "documento", dto.getNumDocumentoCliente()),
					genericDao.createFilter(FilterType.NOTNULL, "idPersonaHaya"));
			
			if (!Checks.esNulo(tmpClienteGDPR) && !Checks.esNulo(tmpClienteGDPR.getIdPersonaHaya())) {
				clienteComercial.setIdPersonaHaya(String.valueOf(tmpClienteGDPR.getIdPersonaHaya()));
			} else if (!Checks.esNulo(clientes) && !clientes.isEmpty()) {
				clienteComercial.setIdPersonaHaya(clientes.get(0).getIdPersonaHaya());
			}


			clienteComercial.setIdPersonaHayaCaixa(interlocutorCaixaService.getIdPersonaHayaCaixa(null,activo,clienteComercial.getDocumento()));
			clienteComercial.setIdPersonaHayaCaixaRepresentante(interlocutorCaixaService.getIdPersonaHayaCaixa(null,activo,clienteComercial.getDocumentoRepresentante()));

			InfoAdicionalPersona iap = interlocutorCaixaService.getIapCaixaOrDefault(clienteComercial.getInfoAdicionalPersona(),clienteComercial.getIdPersonaHayaCaixa(),clienteComercial.getIdPersonaHaya());

			if(iap == null) {
				iap = new InfoAdicionalPersona();
				iap.setAuditoria(Auditoria.getNewInstance());
				iap.setIdPersonaHaya(clienteComercial.getIdPersonaHaya());
				iap.setEstadoComunicacionC4C(genericDao.get(DDEstadoComunicacionC4C.class, genericDao.createFilter(FilterType.EQUALS, "codigo",DDEstadoComunicacionC4C.C4C_NO_ENVIADO)));
				clienteComercial.setInfoAdicionalPersona(iap);
			}else if(clienteComercial.getInfoAdicionalPersona() == null) {
				clienteComercial.setInfoAdicionalPersona(iap);
			}
			
			if(dto.getVinculoCaixaCodigo() != null) {
				DDVinculoCaixa vinculoCaixa = (DDVinculoCaixa) utilDiccionarioApi.dameValorDiccionarioByCod(DDVinculoCaixa.class,dto.getVinculoCaixaCodigo());
				iap.setVinculoCaixa(vinculoCaixa);
				clienteComercial.setInfoAdicionalPersona(iap);
			}
				
			Filter filtroNuevosCamposClc = null;
			
			if(dto.getFechaNacimientoConstitucion() != null && !dto.getFechaNacimientoConstitucion().equals("")) {
				clienteComercial.setFechaNacimiento(ft.parse(dto.getFechaNacimientoConstitucion()));
			}
			
			if(dto.getPaisNacimientoCompradorCodigo() != null) {
				filtroNuevosCamposClc = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getPaisNacimientoCompradorCodigo());
				DDPaises pais = (DDPaises) genericDao.get(DDPaises.class, filtroNuevosCamposClc);
				clienteComercial.setPaisNacimiento(pais);
			}
			
			if (dto.getProvinciaNacimiento() != null) {
				filtroNuevosCamposClc = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaNacimiento());
				DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtroNuevosCamposClc);
				clienteComercial.setProvinciaNacimiento(provinciaNueva);
			}
			
			if(dto.getLocalidadNacimientoCompradorCodigo() != null) {
				filtroNuevosCamposClc = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getLocalidadNacimientoCompradorCodigo());
				Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtroNuevosCamposClc);
	
				clienteComercial.setLocalidadNacimiento(municipioNuevo);
			}
			
			if(dto.getCodigoPais() != null) {
				filtroNuevosCamposClc = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoPais());
				DDPaises pais = (DDPaises) genericDao.get(DDPaises.class, filtroNuevosCamposClc);
				clienteComercial.setPais(pais);
			}
			if(dto.getProvinciaCodigo() != null) {
				filtroNuevosCamposClc = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
				DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtroNuevosCamposClc);
				clienteComercial.setProvincia(provinciaNueva);
			}
			if(dto.getMunicipioCodigo() != null) {
				filtroNuevosCamposClc = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
				Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtroNuevosCamposClc);
	
				clienteComercial.setMunicipio(municipioNuevo);
			}
			
			if (dto.getCodigoPostalNacimiento() != null) {
				clienteComercial.setCodigoPostal(dto.getCodigoPostalNacimiento());
			}
			
			if (dto.getEmailNacimiento() != null) {
				clienteComercial.setEmail(dto.getEmailNacimiento());
			}
			
			if (dto.getTelefonoNacimiento1() != null) {
				clienteComercial.setTelefono1(dto.getTelefonoNacimiento1());
			}
			
			if (dto.getTelefonoNacimiento2() != null) {
				clienteComercial.setTelefono2(dto.getTelefonoNacimiento2());
			}
			
			clienteComercial.setDireccion(dto.getDireccion());
			
			if(clienteComercial.getInfoAdicionalPersona() != null){
				clienteComercial.getInfoAdicionalPersona().setPrp(dto.getPrp());
			}
			
			genericDao.save(InfoAdicionalPersona.class, iap);
			
			clienteComercial = genericDao.save(ClienteComercial.class, clienteComercial);
			
			Oferta oferta = new Oferta();
			oferta.setVentaDirecta(dto.getVentaDirecta());
			oferta.setOrigen(OfertaApi.ORIGEN_REM);
			
			oferta.setNumOferta(numOferta);
			if (!Checks.esNulo(dto.getImporteOferta())) {
				try{
					oferta.setImporteOferta(Double.valueOf(dto.getImporteOferta()));
				}catch(NumberFormatException ne){
					logger.warn("Formato numero incorrecto");
					oferta.setImporteOferta(Double.valueOf(dto.getImporteOferta().replace(",", ".")));
				}
				
			   
			}
			oferta.setEstadoOferta(estadoOferta);
			oferta.setTipoOferta(tipoOferta);
			oferta.setFechaAlta(new Date());

			if (!Checks.esNulo(dto.getDerechoTanteo())) {
			    oferta.setDesdeTanteo(dto.getDerechoTanteo());
			}
			
			listaActOfr = ofertaApi.buildListaActivoOferta(activo, null, oferta);
			oferta.setActivosOferta(listaActOfr);

			oferta.setCliente(clienteComercial);

			oferta.setPrescriptor((ActivoProveedor) proveedoresApi.searchProveedorCodigo(dto.getCodigoPrescriptor()));
			
			oferta.setTipoAlquiler(activo.getTipoAlquiler());

			if(!Checks.esNulo(dto.getIntencionFinanciar()))
				oferta.setIntencionFinanciar(dto.getIntencionFinanciar()? 1 : 0);
			if(!Checks.esNulo(dto.getCodigoSucursal())) {
				String codigoOficina = activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)? "2038" : 
					activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)? "3058" : "";
				if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA) || activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR))
					oferta.setSucursal((ActivoProveedor) proveedoresApi.searchProveedorCodigoUvem(codigoOficina+dto.getCodigoSucursal()));
			}

			List<OfertasAgrupadasLbk> ofertasAgrupadas = new ArrayList<OfertasAgrupadasLbk>();

			Oferta oferPrincipal = null;
			
			if (!Checks.esNulo(dto.getNumOferPrincipal()) || (Checks.esNulo(dto.getNumOferPrincipal()) && !Checks.esNulo(dto.getClaseOferta()))){
				// Si la oferta que estamos creando va a ser dependiente de otra
				
				if (!Checks.esNulo(dto.getNumOferPrincipal())) {
					oferPrincipal = ofertaApi.getOfertaByNumOfertaRem(dto.getNumOferPrincipal());
					
					// Si la oferta que vamos a poner como principal es agrupada o individual, le cambiamos la clase
					if (!DDClaseOferta.CODIGO_OFERTA_PRINCIPAL.equals(oferPrincipal.getClaseOferta().getCodigo())) {
						ofertaApi.actualizaClaseOferta(oferPrincipal, DDClaseOferta.CODIGO_OFERTA_PRINCIPAL);
					}
				}
				ofertasAgrupadas = ofertaApi.buildListaOfertasAgrupadasLbk(oferPrincipal, oferta, dto.getClaseOferta());
			}
			
			if(Checks.esNulo(dto.getClaseOferta()) && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo()) 
					&& DDTipoOferta.CODIGO_ALQUILER.equals(tipoOferta.getCodigo())) {
				DDClaseOferta clase = null;
				clase = genericDao.get(DDClaseOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDClaseOferta.CODIGO_OFERTA_INDIVIDUAL) );
				if(clase != null) {
					oferta.setClaseOferta(clase);
				}
			}
			oferta.setOfertasAgrupadas(ofertasAgrupadas);
			
			oferta.setOfertaExpress(false);
			String origenLead = comisionamientoApi.calculaLeadOrigin(oferta);
			if(origenLead == null) {
				origenLead = DDOrigenComprador.CODIGO_ORC_HRE;
			}
			DDOrigenComprador origenComprador = genericDao.get(DDOrigenComprador.class, genericDao.createFilter(FilterType.EQUALS, "codigo", origenLead));
			oferta.setOrigenComprador(origenComprador);
			oferta.setGestorComercialPrescriptor(ofertaApi.calcularGestorComercialPrescriptorOferta(oferta));
			
			oferta.setIdOfertaOrigen(dto.getIdOfertaOrigen());
			
			if(Checks.esNulo(dto.getOfrDocRespPrescriptor())) {
				oferta.setOfrDocRespPrescriptor(true);
			} else {
				oferta.setOfrDocRespPrescriptor(dto.getOfrDocRespPrescriptor());
			}
			
			String codigo = null;
			
			if(!oferta.getOfrDocRespPrescriptor()) {
				codigo = DDResponsableDocumentacionCliente.CODIGO_COMPRADORES;
			} else if(oferta.getOfrDocRespPrescriptor() && oferta.getPrescriptor() != null && oferta.getPrescriptor().getCodigoProveedorRem() == 2321) {
				codigo = DDResponsableDocumentacionCliente.CODIGO_GESTORCOMERCIAL;
			} else if(oferta.getOfrDocRespPrescriptor() && oferta.getPrescriptor() != null && oferta.getPrescriptor().getCodigoProveedorRem() != 2321) {
				codigo = DDResponsableDocumentacionCliente.CODIGO_PRESCRIPTOR;
			}
			
			if (codigo != null) {
				DDResponsableDocumentacionCliente respCodCliente = genericDao.get(DDResponsableDocumentacionCliente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigo));
				oferta.setRespDocCliente(respCodCliente);
			}
			
			ofertaCreada = genericDao.save(Oferta.class, oferta);
			
			if(activo != null && activo.getSubcartera() != null &&
					(DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo())
					|| DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))) {
				String codigoBulk = Double.parseDouble(dto.getImporteOferta()) > 750000d 
						? DDSinSiNo.CODIGO_SI : DDSinSiNo.CODIGO_NO;
				
				DDSinSiNo sino = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoBulk));
				OfertaExclusionBulk ofertaExclusionBulk = new OfertaExclusionBulk();
				
				ofertaExclusionBulk.setOferta(ofertaCreada);
				ofertaExclusionBulk.setExclusionBulk(sino);
				ofertaExclusionBulk.setFechaInicio(new Date());
				ofertaExclusionBulk.setUsuarioAccion(genericAdapter.getUsuarioLogado());
				
				genericDao.save(OfertaExclusionBulk.class, ofertaExclusionBulk);
			}
			
			// Actualizamos la situacion comercial del activo
			updaterState.updaterStateDisponibilidadComercialAndSave(activo,false);

			if (!Checks.esNulo(dto.getClaseOferta())) {
				DDClaseOferta claseOferta = (DDClaseOferta) genericDao.get(DDClaseOferta.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getClaseOferta()));
				if (!Checks.esNulo(claseOferta)) {
					oferta.setClaseOferta(claseOferta);
				}
			}
			
			// HREOS-4937 -- 'General Data Protection Regulation'

			// Comprobamos si existe en la tabla CGD_CLIENTE_GDPR un registro con el mismo
			// número y tipo de documento
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numDocumento", dto.getNumDocumentoCliente());
			List<ClienteGDPR> cliGDPR = genericDao.getList(ClienteGDPR.class, filtro);
			
			
			AdjuntoComprador docAdjunto = null;
			if (!Checks.esNulo(dto.getIdDocAdjunto())) {
				docAdjunto = genericDao.get(AdjuntoComprador.class,
						genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdDocAdjunto()));
			}
			// Si existe pasamos la información al histórico y actualizamos el objeto con
			// los nuevos datos
			if (!Checks.estaVacio(cliGDPR)) {
				
				for(ClienteGDPR clc : cliGDPR){
					// Primero historificamos los datos de ClienteGDPR en ClienteCompradorGDPR
					ClienteCompradorGDPR clienteCompradorGDPR = new ClienteCompradorGDPR();
					clienteCompradorGDPR.setTipoDocumento(clc.getTipoDocumento());
					clienteCompradorGDPR.setNumDocumento(clc.getNumDocumento());
					clienteCompradorGDPR.setCesionDatos(clc.getCesionDatos());
					clienteCompradorGDPR.setComunicacionTerceros(clc.getComunicacionTerceros());
					clienteCompradorGDPR.setTransferenciasInternacionales(clc.getTransferenciasInternacionales());
					if (!Checks.esNulo(clc.getAdjuntoComprador())) {
						clienteCompradorGDPR.setAdjuntoComprador(clc.getAdjuntoComprador());
					}

					genericDao.save(ClienteCompradorGDPR.class, clienteCompradorGDPR);

					// Despues se hace el update en ClienteGDPR
					clc.setCesionDatos(dto.getCesionDatos());
					clc.setComunicacionTerceros(dto.getComunicacionTerceros());
					clc.setTransferenciasInternacionales(dto.getTransferenciasInternacionales());
					if (!Checks.esNulo(docAdjunto)) {
						clc.setAdjuntoComprador(docAdjunto);
					}
					genericDao.update(ClienteGDPR.class, clc);

				}

				
				// Si no existe simplemente creamos e insertamos un nuevo objeto ClienteGDPR
			} else {
				ClienteGDPR clienteGDPR =  new ClienteGDPR();
				clienteGDPR.setCliente(clienteComercial);
				clienteGDPR.setTipoDocumento(tipoDocumento);
				clienteGDPR.setNumDocumento(dto.getNumDocumentoCliente());
				clienteGDPR.setCesionDatos(dto.getCesionDatos());
				clienteGDPR.setComunicacionTerceros(dto.getComunicacionTerceros());
				clienteGDPR.setTransferenciasInternacionales(dto.getTransferenciasInternacionales());
				
				if(!Checks.esNulo(tmpClienteGDPR) && !Checks.esNulo(tmpClienteGDPR.getIdAdjunto())) {
					docAdjunto = genericDao.get(AdjuntoComprador.class,
							genericDao.createFilter(FilterType.EQUALS, "id", tmpClienteGDPR.getIdAdjunto()));
				}
				if (!Checks.esNulo(docAdjunto)) {
					clienteGDPR.setAdjuntoComprador(docAdjunto);
				}
				clienteGDPR = genericDao.save(ClienteGDPR.class, clienteGDPR);
				
				clienteComercialDao.deleteTmpClienteByDocumento(clienteGDPR.getNumDocumento());
				
			}			
			
			this.actualizarEstadoPublicacionActivo(activo.getId());
			
			// El envío de correos siempre al final del método
			if(DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())) {
				notificationOfertaManager.enviarPropuestaOfertaTipoAlquiler(oferta);
			}else {
				notificationOfertaManager.sendNotification(oferta);
			}

			boolean esOfertaCaixa = particularValidatorApi.esOfertaCaixa(ofertaCreada != null ? ofertaCreada.getNumOferta().toString() : null);

			if (esOfertaCaixa) {
				createOrUpdateOfertaCaixa(ofertaCreada, dto.getTipologivaVentaCod());
				if (DDEstadoOferta.CODIGO_PDTE_DOCUMENTACION.equals(codigoEstado)) {
					LlamadaPbcDto dtoPbc = new LlamadaPbcDto();
					dtoPbc.setFechaReal(oferta.getFechaAlta().toString());
					dtoPbc.setNumOferta(oferta.getNumOferta());
					dtoPbc.setCodAccion("997");
					ofertaApi.pbcFlush(dtoPbc);
				}
			}
			
			if (dto.getIdActivo() != null && ofertaCreada.getNumOferta() != null && ofertaCreada.getId() != null && dto.getTipoOferta() != null) {
				if (particularValidatorApi.esOfertaCaixa(ofertaCreada != null ? ofertaCreada.getNumOferta().toString() : null)) {
					activoApi.anyadirCanalDistribucionOfertaCaixa(dto.getIdActivo(), ofertaCreada.getOfertaCaixa(), dto.getTipoOferta());
				}
			}
			

		} catch (Exception ex) {
			logger.error("error en activoAdapter", ex);
			return ofertaCreada;
		}
		
		return ofertaCreada;
	}


	@Transactional(readOnly = false)
	public void createOrUpdateOfertaCaixa(final Oferta oferta,String codigoTipologia) {

		OfertaCaixa ofertaCaixa = oferta.getOfertaCaixa();

		if (ofertaCaixa == null){
			ofertaCaixa = new OfertaCaixa();
			ofertaCaixa.setOferta(oferta);
			ofertaCaixa.setAuditoria(Auditoria.getNewInstance());
		}

		if (codigoTipologia != null) {
			Filter codigo = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipologia);
			DDTipologiaVentaBc tipologia = genericDao.get(DDTipologiaVentaBc.class, codigo);
			if (tipologia != null) {
				ofertaCaixa.setTipologiaVentaBc(tipologia);
			}
		}
		genericDao.save(OfertaCaixa.class,ofertaCaixa);
		oferta.setOfertaCaixa(ofertaCaixa);
	}


	@Transactional(readOnly = false)
	public boolean saveLlave(DtoLlaves dto) {
		if (Checks.esNulo(dto.getId())) {
			return false;
		}
		Filter llaveIDFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		ActivoLlave llave = genericDao.get(ActivoLlave.class, llaveIDFilter);

		if (!Checks.esNulo(llave)) {
			try {
				beanUtilNotNull.copyProperty(llave, "numLlave", dto.getNumLlave());
				beanUtilNotNull.copyProperty(llave, "codCentroLlave", dto.getCodCentroLlave());
				beanUtilNotNull.copyProperty(llave, "nomCentroLlave", dto.getNomCentroLlave());
				beanUtilNotNull.copyProperty(llave, "archivo1", dto.getArchivo1());
				beanUtilNotNull.copyProperty(llave, "archivo2", dto.getArchivo2());
				beanUtilNotNull.copyProperty(llave, "archivo3", dto.getArchivo3());
				beanUtilNotNull.copyProperty(llave, "juegoCompleto", dto.getJuegoCompleto());
				if (!Checks.esNulo(llave.getJuegoCompleto()) && llave.getJuegoCompleto() == 1)
					dto.setMotivoIncompleto("");
				beanUtilNotNull.copyProperty(llave, "motivoIncompleto", dto.getMotivoIncompleto());

			} catch (IllegalAccessException e) {
				logger.error("Error en ActivoAdapter", e);
				return false;
			} catch (InvocationTargetException e) {
				logger.error("Error en ActivoAdapter", e);
				return false;
			}
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteLlave(DtoLlaves dto) {
		if (Checks.esNulo(dto.getId())) {
			return false;
		}
		Filter llaveIDFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		ActivoLlave llave = genericDao.get(ActivoLlave.class, llaveIDFilter);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		if (!Checks.esNulo(llave) && !Checks.esNulo(usuarioLogado)) {
			llave.getAuditoria().setBorrado(true);
			llave.getAuditoria().setFechaBorrar(new Date());
			llave.getAuditoria().setUsuarioBorrar(usuarioLogado.getUsername());
		} else {
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createLlave(DtoLlaves dto) {

		ActivoLlave llave = new ActivoLlave();

		Filter activoIdFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdActivo()));
		Activo activo = genericDao.get(Activo.class, activoIdFilter);
		if (Checks.esNulo(activo)) {
			return false;
		}

		try {
			beanUtilNotNull.copyProperty(llave, "activo", activo);
			beanUtilNotNull.copyProperty(llave, "codCentroLlave", dto.getCodCentroLlave());
			beanUtilNotNull.copyProperty(llave, "nomCentroLlave", dto.getNomCentroLlave());
			beanUtilNotNull.copyProperty(llave, "archivo1", dto.getArchivo1());
			beanUtilNotNull.copyProperty(llave, "archivo2", dto.getArchivo2());
			beanUtilNotNull.copyProperty(llave, "archivo3", dto.getArchivo3());
			beanUtilNotNull.copyProperty(llave, "juegoCompleto", dto.getJuegoCompleto());
			if (!Checks.esNulo(dto.getJuegoCompleto()) && dto.getJuegoCompleto() == 0)
				beanUtilNotNull.copyProperty(llave, "motivoIncompleto", dto.getMotivoIncompleto());
			beanUtilNotNull.copyProperty(llave, "numLlave", dto.getNumLlave());

			genericDao.save(ActivoLlave.class, llave);

		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter", e);
			return false;
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter", e);
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createMovimientoLlave(DtoMovimientoLlave dto) {

		ActivoMovimientoLlave movimiento = new ActivoMovimientoLlave();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdLlave()));
		ActivoLlave llave = genericDao.get(ActivoLlave.class, filtro);

		if (Checks.esNulo(llave)) {
			return false;
		}		/*if(!Checks.esNulo(dto.getOfrDocRespPrescriptor())) {
		oferta.setOfrDocRespPrescriptor(true);
	}*/

		DDTipoTenedor tipoTenedor = (DDTipoTenedor) proxyFactory.proxy(UtilDiccionarioApi.class)
				.dameValorDiccionarioByCod(DDTipoTenedor.class, dto.getCodigoTipoTenedor());

		try {
			beanUtilNotNull.copyProperties(movimiento, dto);
			beanUtilNotNull.copyProperty(movimiento, "activoLlave", llave);
			beanUtilNotNull.copyProperty(movimiento, "tipoTenedor", tipoTenedor);

			genericDao.save(ActivoMovimientoLlave.class, movimiento);

		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter", e);
			return false;
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter", e);
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean saveMovimientoLlave(DtoMovimientoLlave dto) {

		if (Checks.esNulo(dto.getId())) {
			return false;
		}
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		ActivoMovimientoLlave movimiento = genericDao.get(ActivoMovimientoLlave.class, filtro);

		if (!Checks.esNulo(movimiento)) {
			try {

				beanUtilNotNull.copyProperties(movimiento, dto);

				if (!Checks.esNulo(dto.getCodigoTipoTenedor())) {
					DDTipoTenedor tipoTenedor = (DDTipoTenedor) proxyFactory.proxy(UtilDiccionarioApi.class)
							.dameValorDiccionarioByCod(DDTipoTenedor.class, dto.getCodigoTipoTenedor());
					movimiento.setTipoTenedor(tipoTenedor);
				}

				// Datos auditoria
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				if (!Checks.esNulo(usuarioLogado)) {
					movimiento.getAuditoria().setFechaModificar(new Date());
					movimiento.getAuditoria().setUsuarioModificar(usuarioLogado.getUsername());
				} else {
					return false;
				}

			} catch (IllegalAccessException e) {
				logger.error("Error en ActivoAdapter", e);
				return false;
			} catch (InvocationTargetException e) {
				logger.error("Error en ActivoAdapter", e);
				return false;
			}
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteMovimientoLlave(DtoMovimientoLlave dto) {

		if (Checks.esNulo(dto.getId())) {
			return false;
		}
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		ActivoMovimientoLlave movimiento = genericDao.get(ActivoMovimientoLlave.class, filtro);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		// Datos auditoria
		if (!Checks.esNulo(movimiento) && !Checks.esNulo(usuarioLogado)) {
			movimiento.getAuditoria().setBorrado(true);
			movimiento.getAuditoria().setFechaBorrar(new Date());
			movimiento.getAuditoria().setUsuarioBorrar(usuarioLogado.getUsername());
		} else {
			return false;
		}

		return true;
	}

	/**
	 * Realiza comprobaciones y acciones a realizar por los datos modificados en
	 * la Ficha Cabecera
	 * 
	 * @param activo
	 */
	

	private String getEstadoNuevaOferta(Activo activo) {
		String codigoEstado = DDEstadoOferta.CODIGO_PENDIENTE;

//		if(DDCartera.CODIGO_CAIXA.equals(activo.getCartera().getCodigo()) &&
//				DDEquipoGestion.CODIGO_MINORISTA.equals(activo.getEquipoGestion().getCodigo())){
//			codigoEstado = DDEstadoOferta.CODIGO_PDTE_DEPOSITO;
//		}

		if (DDCartera.isCarteraBk(activo.getCartera())) {
			codigoEstado = DDEstadoOferta.CODIGO_PDTE_DOCUMENTACION;
		}
		if (activoAgrupacionActivoDao.activoEnAgrupacionLoteComercial(activo.getId())
				|| ofertaApi.isActivoConOfertaYExpedienteBlocked(activo)) { 
			codigoEstado = DDEstadoOferta.CODIGO_CONGELADA;
		}

		return codigoEstado;
	}

	public List<DtoUsuario> getComboUsuariosPorTipoGestorYCarteraDelLoteComercial(ActivoAgrupacion activoAgrupacion, Long tipoGestor) {
		// Obtener una lista de usuarios filtrados por tipo gestor.
		List<DtoUsuario> usuariosPorTipoGestorList = this.getComboUsuarios(tipoGestor);
		if(usuariosPorTipoGestorList == null) {
			return null;
		}

		// Obtener el id de cartera por la agrupación.
		Long idCartera;
		if (activoAgrupacion.getActivoPrincipal() != null && activoAgrupacion.getActivoPrincipal().getCartera() != null) {
			idCartera = activoAgrupacion.getActivoPrincipal().getCartera().getId();
		} else if (activoAgrupacion.getActivos() != null && !activoAgrupacion.getActivos().isEmpty()
				&& activoAgrupacion.getActivos().get(0).getActivo().getCartera() != null) {
			idCartera = activoAgrupacion.getActivos().get(0).getActivo().getCartera().getId();
		} else {
			// Si la agrupación no contiene activos, por lo que no pertenece a una cartera, devolver la lista de usuarios por tipo gestor sólo.
			return usuariosPorTipoGestorList;
		}

		// Contrastar el tipo de cartera de cada usuario contra la cartera de la agrupación.
		List<Long> usuarioIdList = new ArrayList<Long>();
		for(DtoUsuario usuario: usuariosPorTipoGestorList) {
			usuarioIdList.add(usuario.getId());
		}

		List<DtoUsuario> usuariosPorTipoGestorYCarteraList = new ArrayList<DtoUsuario>();

		List<ActivoProveedorContacto> activoProveedorContactoList = proveedoresApi.getActivoProveedorContactoPorIdsUsuarioYCartera(usuarioIdList, idCartera);
		for(ActivoProveedorContacto  activoProveedorContacto: activoProveedorContactoList) {
			DtoUsuario dto = new DtoUsuario();

			dto.setId(activoProveedorContacto.getUsuario().getId());
			dto.setApellidoNombre(activoProveedorContacto.getUsuario().getApellidoNombre());

			usuariosPorTipoGestorYCarteraList.add(dto);
		}

		return usuariosPorTipoGestorYCarteraList;
	}
	
	public void enviarAvisosCambioSituacionLegalActivo(Activo activo, ExpedienteComercial expediente) {
		
		Notificacion notificacion = new Notificacion();
		Usuario destinatario = null;
		
		notificacion.setIdActivo(activo.getId());	
		
		String[] numActivo = {String.valueOf(activo.getNumActivo())};
		notificacion.setDescripcion(messageServices.getMessage(AVISO_DESCRIPCION_MODIFICADAS_CONDICIONES_JURIDICAS, numActivo));
		
		notificacion.setTitulo(messageServices.getMessage(AVISO_TITULO_MODIFICADAS_CONDICIONES_JURIDICAS));	
		if(!Checks.esNulo(expediente.getTrabajo())) {
		// Buscamos el gestor responsable de Haya
			List<ActivoTramite> tramites = activoTramiteApi.getTramitesActivoTrabajoList(expediente.getTrabajo().getId());						
			
			for(TareaActivo tarea: tramites.get(0).getTareas()) {
				
				if(!tarea.getAuditoria().isBorrado() && Checks.esNulo(tarea.getFechaFin())
						&& genericAdapter.isGestorHaya(tarea.getUsuario())) {
	
					if(Checks.esNulo(destinatario)) {
						destinatario = tarea.getUsuario();
					}
												
				}
			}
		}
		if (!Checks.esNulo(destinatario)) {														
			
			notificacion.setDestinatario(destinatario.getId());									
			
			try {
				
				notificacionAdapter.saveNotificacion(notificacion);
				logger.debug("ENVIO NOTIFICACION: [TITULO " + notificacion.getTitulo() + " | ACTIVO " + activo.getNumActivo() + "| DESTINATARIO " + destinatario.getUsername() + " ]");
				
			} catch (ParseException e) {
					logger.error(e.getMessage());
			}
		}
									
		// Si expediente ya ha sido aprobado avisamos al gestor de formalización
		if (DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())
				|| DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())
				|| DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())
				|| DDEstadosExpedienteComercial.ALQUILADO.equals(expediente.getEstado().getCodigo())
				|| DDEstadosExpedienteComercial.EN_DEVOLUCION.equals(expediente.getEstado().getCodigo())
				|| DDEstadosExpedienteComercial.BLOQUEO_ADM.equals(expediente.getEstado().getCodigo())) {
			
			Usuario gestorFormalizacion = gestorExpedienteComercialManager.getGestorByExpedienteComercialYTipo(expediente, "GFORM");
			
			if(!Checks.esNulo(gestorFormalizacion) && !gestorFormalizacion.equals(destinatario)) {
		
				notificacion.setDestinatario(gestorFormalizacion.getId());								
				
				try {
					
					notificacionAdapter.saveNotificacion(notificacion);
					logger.debug("ENVIO NOTIFICACION: [TITULO " + notificacion.getTitulo() + " | ACTIVO " + activo.getNumActivo() + "| DESTINATARIO " + gestorFormalizacion.getUsername() + " ]");
					
				} catch (ParseException e) {
						logger.error(e.getMessage());
				}
			}
		}
	}
	
	@Transactional(readOnly = false)
	public boolean createTasacion(String importeTasacionFin, String tipoTasacionCodigo, String nomTasador, Date fechaValorTasacion, Long idActivo) {
		Activo activo = activoApi.get(idActivo);
		NMBBien bienActivo = activo.getBien();
		NMBValoracionesBien valoracionBienActivo = new NMBValoracionesBien();
		valoracionBienActivo.setBien(bienActivo);
		
		try {
			beanUtilNotNull.copyProperty(valoracionBienActivo, "fechaValorTasacion", fechaValorTasacion);
		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter, createTasacion", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter, createTasacion", e);
		}
		
		genericDao.save(NMBValoracionesBien.class, valoracionBienActivo);
		
		ActivoTasacion activoTasacion = new ActivoTasacion();
		activoTasacion.setActivo(activo);
		activoTasacion.setValoracionBien(valoracionBienActivo);
		
		Filter filtroTipoTasacion = genericDao.createFilter(FilterType.EQUALS, "codigo", tipoTasacionCodigo);
		DDTipoTasacion tipoTasacion = genericDao.get(DDTipoTasacion.class, filtroTipoTasacion);
		activoTasacion.setTipoTasacion(tipoTasacion);
		
		double importeTasacionFinDouble = 0;
		if(!importeTasacionFin.isEmpty()){
			importeTasacionFinDouble = Double.parseDouble(importeTasacionFin);
		}
		activoTasacion.setImporteTasacionFin(importeTasacionFinDouble);
		
		activoTasacion.setNomTasador(nomTasador);
		
		activoTasacion.setCodigoFirma(0L); //No se conoce la procedencia del campo codigoFirma
					
		ActivoTasacion activoTasacionNuevo = genericDao.save(ActivoTasacion.class, activoTasacion);

		activo.getTasacion().add(activoTasacionNuevo);
		activoApi.saveOrUpdate(activo);

		return true;
	}
	
	@Transactional(readOnly = false)
	public boolean saveTasacion(DtoTasacion dtoTasacion) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoTasacion.getId());
		ActivoTasacion activoTasacion = genericDao.get(ActivoTasacion.class, filtro);
		
		if(dtoTasacion.getTipoTasacionCodigo() != null){
			Filter filtroTipoTasacion = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTasacion.getTipoTasacionCodigo());
			DDTipoTasacion tipoTasacion = genericDao.get(DDTipoTasacion.class, filtroTipoTasacion);
			activoTasacion.setTipoTasacion(tipoTasacion);
		}
		
		double importeTasacionFinDouble = 0d;
		if(!dtoTasacion.getImporteTasacionFin().isEmpty()){
			importeTasacionFinDouble = Double.parseDouble(dtoTasacion.getImporteTasacionFin());
		}
		activoTasacion.setImporteTasacionFin(importeTasacionFinDouble);
		activoTasacion.setFechaInicioTasacion(dtoTasacion.getFechaInicioTasacion());
		activoTasacion.setFechaRecepcionTasacion(dtoTasacion.getFechaRecepcionTasacion());
		activoTasacion.setNomTasador(dtoTasacion.getNomTasador());

		NMBValoracionesBien valoracionActivoTasacion = activoTasacion.getValoracionBien();
		try {
			beanUtilNotNull.copyProperty(valoracionActivoTasacion, "fechaValorTasacion", dtoTasacion.getFechaValorTasacion());
		} catch (IllegalAccessException e) {
			logger.error("Error en ActivoAdapter, saveTasacion", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en ActivoAdapter, saveTasacion", e);
		}

		genericDao.save(NMBValoracionesBien.class, valoracionActivoTasacion);
		genericDao.save(ActivoTasacion.class, activoTasacion);

		return true;
	}

	@Transactional(readOnly = true)
	public GestorSustituto getGestorSustitutoVigente(GestorEntidadHistorico gestor) {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal", gestor.getUsuario());

		try {
			List<GestorSustituto> gestoresSustitutos = genericDao.getList(GestorSustituto.class, filter);

			for (GestorSustituto sustituto : gestoresSustitutos) {
				if (!Checks.esNulo(sustituto.getFechaFin())) {
					if (sustituto.getFechaFin().after(new Date()) || DateUtils.isSameDay(sustituto.getFechaFin(), new Date())) {
						if (sustituto.getFechaInicio().before(new Date()) || DateUtils.isSameDay(sustituto.getFechaInicio(), new Date())) {
							if (!sustituto.getAuditoria().isBorrado()) {
							   return sustituto;
							}
						}
					}
				} else {
					return sustituto;
				}
			}
		} catch (Exception e) {
			logger.error("Error en ActivoAdapter", e);
		}

		return null;

	}

	/**
	 * @param activosId
	 * @return
	 */
	@Transactional(readOnly = false)
	public Boolean updateInformeComercialMSV(Long idActivo) throws JsonViewerException {
		Boolean aprobado=false;
		ActivoEstadosInformeComercialHistorico activoEstadosInformeComercialHistorico = new ActivoEstadosInformeComercialHistorico();
		Filter estadoInformeComercialFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_ACEPTACION);
		activoEstadosInformeComercialHistorico.setEstadoInformeComercial(genericDao.get(DDEstadoInformeComercial.class, estadoInformeComercialFilter));
		String username = genericAdapter.getUsuarioLogado().getUsername();
		Date fecha = new Date();

		Activo activo = activoDao.get(idActivo);

		try {
			if(!Checks.esNulo(activo)){

				if(!informeComercialAprobado(activo)) {

					if(!activoApi.checkTiposDistintos(activo)){
						//Si han habido cambios en el historico, los persistimos.
						if(!Checks.esNulo(activoEstadosInformeComercialHistorico) && !Checks.esNulo(activoEstadosInformeComercialHistorico.getEstadoInformeComercial())){
							activoEstadosInformeComercialHistorico.setFecha(fecha);
							if(Checks.esNulo(activoEstadosInformeComercialHistorico.getAuditoria())){
								Auditoria auditoria = new Auditoria();
								auditoria.setUsuarioCrear(username);
								auditoria.setFechaCrear(fecha);
								activoEstadosInformeComercialHistorico.setAuditoria(auditoria);
							}else{
								activoEstadosInformeComercialHistorico.getAuditoria().setUsuarioCrear(username);
								activoEstadosInformeComercialHistorico.getAuditoria().setFechaCrear(fecha);
							}
							activoEstadosInformeComercialHistorico.setActivo(activo);
							genericDao.save(ActivoEstadosInformeComercialHistorico.class, activoEstadosInformeComercialHistorico);
						}
					}

					if(!Checks.esNulo(activo.getInfoComercial())){
						activo.getInfoComercial().getAuditoria().setFechaModificar(fecha);
						if(!Checks.esNulo(genericAdapter.getUsuarioLogado())){
							activo.getInfoComercial().getAuditoria().setUsuarioModificar(username);
						}
						activo.getInfoComercial().setFechaAceptacion(new Date());
						activo.getInfoComercial().setFechaRechazo(null);
					}

					if(!activoEstadoPublicacionApi.isPublicadoVentaByIdActivo(activo.getId())) {
						activo.setFechaPublicable(fecha);
					}

					activoApi.saveOrUpdate(activo);
					
					if (!Checks.esNulo(activo.getTipoActivo()) && DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())
							&& !Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getFechaAceptacion())){
						activoApi.calcularRatingActivo(activo.getId());
					}

					aprobado = publicarActivoConHistorico(username, activo);
					if (aprobado) {
						aprobado = updateTramitesActivo(activo.getId());
					}
				}
			}
		} catch(JsonViewerException e) {
			throw e;
		}		/*if(!Checks.esNulo(dto.getOfrDocRespPrescriptor())) {
		oferta.setOfrDocRespPrescriptor(true);
	}*/

		return aprobado;
	}

	/**
	 * Publica un activo
	 * @param username
	 * @param activo
	 * @return
	 */
	private Boolean publicarActivoConHistorico(String username, Activo activo) {

		return activoDao.publicarActivoConHistorico(activo.getId(),username,null,true);
	}

	/**
	 * Comprueba para un activo si tiene el condicionante de sin informe comercial aprobado marcado en naranja.
	 * @param activo
	 * @return booleano a false si esta en naranja
	 */
	private Boolean informeComercialAprobado(Activo activo) {
		Boolean check = true;
		VSinInformeAprobadoRem vSinInforme = activoApi.getSinInformeAprobadoREM(activo.getId());
		if(!Checks.esNulo(vSinInforme)) {
			if(vSinInforme.getSinInformeAprobadoREM()) {
				check = false;
			}
		}
		return check;
	}

	/**
	 * Comprueba si existen tramites de tipo aprobacion informe comercial en el activo y si estan en tramitacion los cerrara automaticamente
	 * @param activosId
	 * @return booleano true o false
	 */
	@Transactional(readOnly = false)
	public Boolean updateTramitesActivo(Long idActivo) throws JsonViewerException  {
		Boolean resultado = true;
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		List<ActivoTramite> listActTramites =  activoTramiteDao.getListaTramitesActivo(idActivo);

		if(!Checks.estaVacio(listActTramites)) {
			for (ActivoTramite activoTramite : listActTramites) {
				if(T_APROBACION_INFORME_COMERCIAL.equals(activoTramite.getTipoTramite().getCodigo()) && CODIGO_ESTADO_PROCEDIMIENTO_EN_TRAMITE.equals(activoTramite.getEstadoTramite().getCodigo())) {
					try {
						borradoLogicoTareaExternaByIdTramite(activoTramite, usuarioLogado);
						borradoLogicoActivoTramite(usuarioLogado, activoTramite);
					}catch(JsonViewerException e) {
						throw new JsonViewerException(UPDATE_ERROR_TRAMITES_PUBLI_ACTIVO);
					}
				}
			}
		}

		return resultado;
	}

	/**
	 * @param usuarioLogado
	 * @param activoTramite
	 */
	public void borradoLogicoActivoTramite(Usuario usuarioLogado, ActivoTramite activoTramite) {
		DDEstadoProcedimiento estadoTramite = (DDEstadoProcedimiento) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoProcedimiento.class,
						DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO);
		activoTramite.setEstadoTramite(estadoTramite);
		activoTramite.getAuditoria().setBorrado(true);
		activoTramite.getAuditoria().setUsuarioBorrar(usuarioLogado.getNombre());
		activoTramite.getAuditoria().setFechaBorrar(new Date());
		activoTramiteDao.saveOrUpdate(activoTramite);
	}
	
	/**
	 * @param usuarioLogado
	 * @param activoTramite
	 */
	public void cerrarActivoTramite(Usuario usuarioLogado, ActivoTramite activoTramite) {
		DDEstadoProcedimiento estadoTramite = (DDEstadoProcedimiento) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoProcedimiento.class,
						DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO);
		activoTramite.setEstadoTramite(estadoTramite);
		activoTramite.setFechaFin(new Date());
		activoTramite.getAuditoria().setUsuarioModificar(usuarioLogado.getUsername());
		activoTramite.getAuditoria().setFechaModificar(new Date());
		activoTramiteDao.saveOrUpdate(activoTramite);
	}

	/**
	 *
	 * @param activoTramite
	 * @return
	 */
	@Transactional(readOnly = false)
	public void borradoLogicoTareaExternaByIdTramite(ActivoTramite activoTramite, Usuario usuarioLogado) {
		TareaExterna tarExt;
		TareaNotificacion tarea;
		List<TareaActivo>  listaTareas = tareaActivoApi.getTareasActivoByIdTramite(activoTramite.getId());
		if(!Checks.estaVacio(listaTareas)){

			for (TareaActivo tareaActivo : listaTareas) {

				if(Checks.esNulo(tareaActivo.getFechaFin())){
					tarExt  = tareaActivo.getTareaExterna();
					if(!Checks.esNulo(tarExt)) {
						tarExt.getAuditoria().setBorrado(true);
						tarExt.getAuditoria().setFechaBorrar(new Date());
						tarExt.getAuditoria().setUsuarioBorrar(usuarioLogado.getNombre());
						genericDao.update(TareaExterna.class, tarExt);
					}

					tarea = genericDao.get(EXTTareaNotificacion.class, genericDao.createFilter(FilterType.EQUALS, "id", tareaActivo.getId()));
					if(!Checks.esNulo(tarea)) {
						tarea.setFechaFin(new Date());
						tarea.setTareaFinalizada(true);
						tarea.getAuditoria().setBorrado(true);
						tarea.getAuditoria().setUsuarioBorrar(usuarioLogado.getNombre());
						tarea.getAuditoria().setFechaBorrar(new Date());
						genericDao.update(TareaNotificacion.class, tarea);
					}
				}
			}
		}
	}

	public List<DDTipoTituloActivo> getOrigenActivo(Long id) {
		List<DDTipoTituloActivo>  storeOrigenActivos = null;
		if (!Checks.esNulo(id)) {
			storeOrigenActivos = genericDao.getList(DDTipoTituloActivo.class);
				if (!activoDao.isUnidadAlquilable(id)) {
					DDTipoTituloActivo unidadAlquilable =
							(DDTipoTituloActivo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoTituloActivo.class, DDTipoTituloActivo.UNIDAD_ALQUILABLE);
						storeOrigenActivos.remove(unidadAlquilable);
				}
		}		
		return storeOrigenActivos;
	}
	
	public boolean isUnidadAlquilable (Long idActivo) {
		return activoDao.isUnidadAlquilable(idActivo);
	}
	
	public List<DDSiNo> getComboImpideVenta(String codEstadoCarga) {
		List<DDSiNo> listaCombo = new ArrayList<DDSiNo>();
		
		if(Checks.esNulo(codEstadoCarga) || DDEstadoCarga.CODIGO_VIGENTE.equals(codEstadoCarga)) {
			listaCombo = genericDao.getList(DDSiNo.class);
		} else {
			listaCombo = genericDao.getList(DDSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSiNo.NO));
		}
		
		return listaCombo;
	}	
	
	public Boolean deleteAdjuntoTributo(Long idRestTributo) {
		boolean borrado = false;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			try {
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(idRestTributo, usuarioLogado.getUsername());
			} catch (Exception e) {
				logger.error("Error en ActivoAdapter", e);
			}
		}else {
			borrado = true;
		}
		return borrado;
	}

	public List<DtoAdjunto> getAdjuntosActivoPlusvalia(Long id)
			throws GestorDocumentalException, IllegalAccessException, InvocationTargetException {
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		Usuario usuario = genericAdapter.getUsuarioLogado();

		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Activo activo = activoApi.get(id);
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS,"activo.id", id);
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS,"auditoria.borrado", false);
			ActivoPlusvalia activoPlusvalia = genericDao.get(ActivoPlusvalia.class, filtroActivo, filtroBorrado);
			if(!Checks.esNulo(activoPlusvalia)) {
				try {
					listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosPlusvalia(activoPlusvalia);
		
					if(!Checks.estaVacio(listaAdjuntos)) {
						for (DtoAdjunto adj : listaAdjuntos) {
							AdjuntoPlusvalias adjunto = activoPlusvalia.getAdjunto(adj.getId());
							if (!Checks.esNulo(adjunto)) {
								if(!Checks.esNulo(activo.getId())) {
									adj.setIdEntidad(activo.getId());
								}
								if(!Checks.esNulo(adjunto.getNombre())) {
									adj.setNombre(adjunto.getNombre());
								}
								if(!Checks.esNulo(adjunto.getTipoDocPlusvalias())) {
									adj.setDescripcionTipo(adjunto.getTipoDocPlusvalias().getDescripcion());
								}
								if(!Checks.esNulo(adjunto.getFechaDocumento())) {
									adj.setFechaDocumento(adjunto.getFechaDocumento());
								}
								if(!Checks.esNulo(adjunto.getTamanyo())) {
									adj.setTamanyo(adjunto.getTamanyo());
								}
								if(!Checks.esNulo(activo.getAuditoria().getUsuarioCrear())) {
									adj.setGestor(activo.getAuditoria().getUsuarioCrear());
								}
							}
						}
					}
					
				} catch (GestorDocumentalException gex) {
					if (GestorDocumentalException.CODIGO_ERROR_CONTENEDOR_NO_EXISTE.equals(gex.getCodigoError())) {
		
						Integer idPlusvalia;
						try{
							idPlusvalia = gestorDocumentalAdapterApi.crearPlusvalia(activoPlusvalia,usuario.getUsername());
							logger.debug("GESTOR DOCUMENTAL [ crearPlusvalia para " + activoPlusvalia.getId() + "]: ID PLUSVALIA RECIBIDO " + idPlusvalia);
						} catch (GestorDocumentalException gexc) {
							logger.error(gexc.getMessage(),gexc);
						}
		
					}
					throw gex;
				}
			}

		} else {
			listaAdjuntos = getAdjuntosActivoPlusvalia(id, listaAdjuntos);
		}
		return listaAdjuntos;
	}

	private List<DtoAdjunto> getAdjuntosActivoPlusvalia(Long id, List<DtoAdjunto> listaAdjuntos)
			throws IllegalAccessException, InvocationTargetException {
		Activo activo = activoApi.get(id);
		if(!Checks.esNulo(activo)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoPlusvalia activoPlusvalia = genericDao.get(ActivoPlusvalia.class, filtro);
			if(!Checks.esNulo(activoPlusvalia)) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "plusvalia", activoPlusvalia);
		
				for (AdjuntoPlusvalias adjunto : genericDao.getList(AdjuntoPlusvalias.class, filtro)) {
					DtoAdjunto dto = new DtoAdjunto();
					if(!Checks.esNulo(adjunto)) {
						
						BeanUtils.copyProperties(dto, adjunto);
						if(!Checks.esNulo(activo.getId())) {
							dto.setIdEntidad(activo.getId());
						}
						if(!Checks.esNulo(adjunto.getNombre())) {
							dto.setNombre(adjunto.getNombre());
						}
						if(!Checks.esNulo(adjunto.getTipoDocPlusvalias())) {
							dto.setDescripcionTipo(adjunto.getTipoDocPlusvalias().getDescripcion());
						}
						if(!Checks.esNulo(adjunto.getFechaDocumento())) {
							dto.setFechaDocumento(adjunto.getFechaDocumento());
						}
						if(!Checks.esNulo(adjunto.getTamanyo())) {
							dto.setTamanyo(adjunto.getTamanyo());
						}
						if(!Checks.esNulo(activo.getAuditoria().getUsuarioCrear())) {
							dto.setGestor(activo.getAuditoria().getUsuarioCrear());
						}
						listaAdjuntos.add(dto);
					}
				}
			}
		}
		return listaAdjuntos;
	}

	@Transactional(readOnly = false)
	public Oferta clonateOfertaActivo(String idOferta) {
		return genericAdapter.clonateOferta(idOferta, false);		
	}

	@Transactional(readOnly = false)
	public boolean deleteFacturaGastoAsociado(Long idFactura) {
		if(idFactura == null) return false;
		AdjuntoGastoAsociado aga = genericDao.get(AdjuntoGastoAsociado.class, genericDao.createFilter(FilterType.EQUALS, "id", idFactura));
		if(aga == null) return false;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			try {
				if(aga.getIdentificadorGestorDocumental() != null && usuarioLogado != null)
					gestorDocumentalAdapterApi.borrarAdjunto(aga.getIdentificadorGestorDocumental(), usuarioLogado.getUsername());
			} catch (Exception e) {
				logger.error("Error en ActivoAdapter", e);
			}
		}
		genericDao.deleteById(AdjuntoGastoAsociado.class, aga.getId());
		return true;
	}
	
	public List<VPreciosVigentes> getPreciosVigentesByIdAndNotFecha(Long idActivo) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo.toString());
		Filter filtroFecha = genericDao.createFilter(FilterType.NULL, "fechaFin");
		Order order = new Order(OrderType.ASC, "orden");

		return genericDao.getListOrdered(VPreciosVigentes.class, order, filtro, filtroFecha);

	}
	
	public List<VPreciosVigentesCaixa> getPreciosVigentesCaixaById(Long idActivo) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivoCaixa", idActivo.toString());
		Order order = new Order(OrderType.ASC, "ordenCaixa");

		return genericDao.getListOrdered(VPreciosVigentesCaixa.class, order, filtro);
	}

	@Transactional(readOnly = false)
	public boolean actualizarEstadoPublicacionActivoPerimetro(ArrayList<Long> listaIdActivo, ArrayList<Long> listaIdActivoSinVisibilidad){

		activoDao.hibernateFlush();
		Thread hilo = new Thread(new EjecutarSPPublicacionAsincrono(genericAdapter.getUsuarioLogado().getUsername(), listaIdActivo, listaIdActivoSinVisibilidad));
		hilo.start();
		
		return true;
	}
	
	@Transactional(readOnly = false)
	public boolean actualizarEstadoPublicacionSincronoPerimetro(ArrayList<Long> listaIdActivo, ArrayList<Long> listaIdActivoSinVisibilidad){
		boolean resultado = true;
		Set<Long> activosSinRepetidos =  new HashSet<Long>(listaIdActivoSinVisibilidad); 
		if(listaIdActivo != null && !listaIdActivo.isEmpty()){
			resultado = activoEstadoPublicacionApi.actualizarEstadoPublicacionDelActivoOrAgrupacionRestringidaSiPertenece(listaIdActivo,true);
		}
		if(listaIdActivoSinVisibilidad != null && !listaIdActivoSinVisibilidad.isEmpty() && resultado) {
			Set<Long> activosAdicionalesSinRepetidos = this.getActivosAdicionales(activosSinRepetidos); 
			activosSinRepetidos.addAll(activosAdicionalesSinRepetidos);
			List<Long> listaIdActivoSinVisibilidadSinRepetidos = new ArrayList<Long>(activosSinRepetidos);
			recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(listaIdActivoSinVisibilidadSinRepetidos);
		}
		
		return resultado;
	}
	
	private Set<Long> getActivosAdicionales(Set<Long> activosSinRepetidos){
		Set<Long> activosAdicionalesSinRepetidos =  new HashSet<Long>();
		for (Long activoId : activosSinRepetidos) {
			Activo activo = activoDao.getActivoById(activoId);
			if(activo != null) {
				ActivoAgrupacionActivo aga = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId());
				if(aga != null && aga.getAgrupacion() != null) {
					List<Activo> activos = activoApi.getActivosNoPrincipalesByIdAgrupacionAndActivoPrincipal(aga.getAgrupacion().getId(),activo.getId());
					for (Activo activoAgr : activos) {
						activosAdicionalesSinRepetidos.add(activoAgr.getId());
					}
				}
			}
		}
		
		return activosAdicionalesSinRepetidos;
	}
	
	private List<Filter> anyadirFiltroPrecioMinimoPorPerfil(List<Filter>filters){
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		if(perfilApi.usuarioHasPerfil(PerfilApi.COD_PERFIL_USUARIO_BC, usuarioLogado.getUsername())) {
			Filter tipoPrecio = genericDao.createFilter(FilterType.NOT_EQUALS, "codigoTipoPrecio", DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO);
			filters.add(tipoPrecio);
		}
		
		return filters;
	}
}



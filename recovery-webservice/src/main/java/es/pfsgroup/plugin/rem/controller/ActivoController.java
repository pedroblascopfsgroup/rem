package es.pfsgroup.plugin.rem.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.net.MalformedURLException;
import java.net.SocketException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoTrabajoFilter;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.pfs.config.ConfigManager;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewer;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap;
import es.pfsgroup.plugin.rem.activo.ActivoPropagacionUAsFieldTabMap;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.exception.HistoricoTramitacionException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.api.ActivoPropagacionApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.excel.ActivoGridExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.PublicacionExcelReport;
import es.pfsgroup.plugin.rem.exception.RemUserException;
import es.pfsgroup.plugin.rem.factory.observaciones.GridObservacionesApi;
import es.pfsgroup.plugin.rem.factory.observaciones.GridObservacionesFactory;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ACCION_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ENTIDAD_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.REQUEST_STATUS_CODE;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.AuditoriaExportaciones;
import es.pfsgroup.plugin.rem.model.DtoActivoAdministracion;
import es.pfsgroup.plugin.rem.model.DtoActivoCargas;
import es.pfsgroup.plugin.rem.model.DtoActivoCargasTab;
import es.pfsgroup.plugin.rem.model.DtoActivoCatastro;
import es.pfsgroup.plugin.rem.model.DtoActivoComplementoTitulo;
import es.pfsgroup.plugin.rem.model.DtoActivoDatosRegistrales;
import es.pfsgroup.plugin.rem.model.DtoActivoDeudoresAcreditados;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivoGridFilter;
import es.pfsgroup.plugin.rem.model.DtoActivoInformacionAdministrativa;
import es.pfsgroup.plugin.rem.model.DtoActivoInformacionComercial;
import es.pfsgroup.plugin.rem.model.DtoActivoInformeComercial;
import es.pfsgroup.plugin.rem.model.DtoActivoIntegrado;
import es.pfsgroup.plugin.rem.model.DtoActivoOcupanteLegal;
import es.pfsgroup.plugin.rem.model.DtoActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.DtoActivoPlusvalia;
import es.pfsgroup.plugin.rem.model.DtoActivoSaneamiento;
import es.pfsgroup.plugin.rem.model.DtoActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.DtoActivoSuministros;
import es.pfsgroup.plugin.rem.model.DtoActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoActivoTributos;
import es.pfsgroup.plugin.rem.model.DtoActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoActivoVistaPatrimonioContrato;
import es.pfsgroup.plugin.rem.model.DtoActivosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.DtoCalificacionNegativaAdicional;
import es.pfsgroup.plugin.rem.model.DtoComercialActivo;
import es.pfsgroup.plugin.rem.model.DtoComunidadpropietariosActivo;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoCondicionHistorico;
import es.pfsgroup.plugin.rem.model.DtoCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionActivo;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionDq;
import es.pfsgroup.plugin.rem.model.DtoDistribucion;
import es.pfsgroup.plugin.rem.model.DtoFasePublicacionActivo;
import es.pfsgroup.plugin.rem.model.DtoFichaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoFoto;
import es.pfsgroup.plugin.rem.model.DtoGastoAsociadoAdquisicion;
import es.pfsgroup.plugin.rem.model.DtoGenerarDocGDPR;
import es.pfsgroup.plugin.rem.model.DtoHistoricoDestinoComercial;
import es.pfsgroup.plugin.rem.model.DtoHistoricoMediador;
import es.pfsgroup.plugin.rem.model.DtoHistoricoOcupadoTitulo;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoTramitacionTitulo;
import es.pfsgroup.plugin.rem.model.DtoHistoricoTramitacionTituloAdicional;
import es.pfsgroup.plugin.rem.model.DtoImpuestosActivo;
import es.pfsgroup.plugin.rem.model.DtoIncrementoPresupuestoActivo;
import es.pfsgroup.plugin.rem.model.DtoLlaves;
import es.pfsgroup.plugin.rem.model.DtoMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.DtoMovimientoLlave;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoPaginadoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoPlusvaliaFilter;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.plugin.rem.model.DtoPresupuestoGraficoActivo;
import es.pfsgroup.plugin.rem.model.DtoPropietario;
import es.pfsgroup.plugin.rem.model.DtoPropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.DtoPublicacionGridFilter;
import es.pfsgroup.plugin.rem.model.DtoReglasPublicacionAutomatica;
import es.pfsgroup.plugin.rem.model.DtoSubirDocumento;
import es.pfsgroup.plugin.rem.model.DtoTasacion;
import es.pfsgroup.plugin.rem.model.HistoricoOcupadoTitulo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VActivosAgrupacionLil;
import es.pfsgroup.plugin.rem.model.VBusquedaProveedoresActivo;
import es.pfsgroup.plugin.rem.model.VGridBusquedaActivos;
import es.pfsgroup.plugin.rem.model.VGridBusquedaPublicaciones;
import es.pfsgroup.plugin.rem.model.dd.DDCesionSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.rest.dto.HistoricoPropuestasPreciosDto;
import es.pfsgroup.plugin.rem.rest.dto.ReqFaseVentaDto;
import es.pfsgroup.plugin.rem.rest.dto.SaneamientoAgendaDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.service.TabActivoService;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;
import es.pfsgroup.plugin.rem.utils.EmptyParamDetector;
import net.sf.json.JSONObject;

@Controller
public class ActivoController extends ParadiseJsonController {

	protected static final Log logger = LogFactory.getLog(ActivoController.class);
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";
	private static final String RESPONSE_MESSAGE_KEY = "msg";
	private static final String RESPONSE_ERROR_MESSAGE_KEY= "msgError";
	private static final String RESPONSE_TOTALCOUNT_KEY = "totalCount";
	private static final String ERROR_ACTIVO_NOT_EXISTS = "No existe el activo que esta buscando, pruebe con otro Nº de Activo";
	private static final String ERROR_ACTIVO_NO_NUMERICO = "El campo introducido es de carácter numérico";
	private static final String ERROR_GENERICO = "La operación no se ha podido realizar";
	private static final String ERROR_CONEXION_FOTOS = "Ha habido un error al conectar con CRM";
	private static final String ERROR_PRECIO_CERO = "No se puede realizar la operación. Está introduciendo un importe 0";

	@Autowired
	private ActivoAdapter adapter;

	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	@Autowired
	private ActivoPropagacionApi activoPropagacionApi;
	
	@Autowired
	private LogTrustEvento trustMe;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private ConfigManager configManager;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private GridObservacionesFactory gridObservacionesFactory;
	
	@Resource
	private Properties appProperties;

	public ActivoApi getActivoApi() {
		return activoApi;
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTabActivo(Long id, String tab, ModelMap model, HttpServletRequest request) {
		try { 
			model.put(RESPONSE_DATA_KEY, adapter.getTabActivo(id, tab));
		} catch (AccesoActivoException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, tab, ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_USUARIO_SIN_ACCESO);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, tab, ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivos(DtoActivoFilter dtoActivoFiltro, ModelMap model) {
		dtoActivoFiltro.setListPage(true);
		try {
			Page page = (Page)adapter.getActivos(dtoActivoFiltro);
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getBusquedaActivosGrid(DtoActivoGridFilter dto, ModelMap model) {
		try {
			Page page = (Page) adapter.getBusquedaActivosGrid(dto, true);
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDatosBasicos(DtoActivoFichaCabecera activoDto, @RequestParam Long id, ModelMap model) {
		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_DATOS_BASICOS);

			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (JsonViewerException jvex) {
					model.put("success", false);
					model.put("msgError", jvex.getMessage());
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoDatosRegistrales(DtoActivoDatosRegistrales activoDto, @RequestParam Long id, ModelMap model) {
		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_DATOS_REGISTRALES);
			if (success) adapter.actualizarEstadoPublicacionActivo(id);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (JsonViewerException jvex) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, jvex.getMessage());
			logger.error(jvex.getMessage());
			throw new JsonViewerException(jvex.getMessage());
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		} 

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoSaneamiento(DtoActivoSaneamiento activoDto, @RequestParam Long id, ModelMap model) {
		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_SANEAMIENTO);
			if (success) adapter.actualizarEstadoPublicacionActivo(id);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (JsonViewerException jvex) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, jvex.getMessage());
			logger.error(jvex.getMessage());
			throw new JsonViewerException(jvex.getMessage());
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		} 

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoCarga(DtoActivoCargas cargaDto, ModelMap model) {
		try {
			boolean success = activoApi.saveActivoCarga(cargaDto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoCargaTab(DtoActivoCargasTab cargaDto, ModelMap model) {
		try {
			boolean success = activoApi.saveActivoCargaTab(cargaDto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateActivoPropietarioTab(DtoPropietario propietario, ModelMap model) {
		try {
			boolean success = activoApi.updateActivoPropietarioTab(propietario);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createActivoPropietarioTab(DtoPropietario propietario, ModelMap model) {
		try {
			boolean success = activoApi.createActivoPropietarioTab(propietario);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteActivoPropietarioTab(DtoPropietario propietario, ModelMap model) {
		try {
			boolean success = activoApi.deleteActivoPropietarioTab(propietario);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoInformacionAdministrativa(DtoActivoInformacionAdministrativa activoDto, @RequestParam Long id, ModelMap model) {
		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_INFO_ADMINISTRATIVA);
			if (success) adapter.actualizarEstadoPublicacionActivo(id);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoInformacionComercial(DtoActivoInformacionComercial activoDto, @RequestParam Long id, ModelMap model) {
		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_INFORMACION_COMERCIAL);
			if (success) adapter.actualizarEstadoPublicacionActivo(id);
			
			Activo activo = activoApi.get(id);
			// Después de haber guardado los cambios sobre informacion comercial, recalculamos el rating del activo.
			if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoActivo()) && DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())
					&& !Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getFechaAceptacion())){
				activoApi.calcularRatingActivo(id);
			}
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveValoresPreciosActivo(DtoActivoValoraciones valoracionesDto, @RequestParam Long id, ModelMap model) {
		try {
			boolean success = adapter.saveTabActivo(valoracionesDto, id, TabActivoService.TAB_VALORACIONES_PRECIOS);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoAdministracion(DtoActivoAdministracion activoDto, @RequestParam Long id, ModelMap model, HttpServletRequest request) {
		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_ADMINISTRACION);
			if (success) adapter.actualizarEstadoPublicacionActivo(id);
			model.put(RESPONSE_SUCCESS_KEY, success);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, TabActivoService.TAB_ADMINISTRACION, ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, TabActivoService.TAB_ADMINISTRACION, ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoSituacionPosesoria(DtoActivoSituacionPosesoria activoDto, @RequestParam Long id, ModelMap model, HttpServletRequest request) {
		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_SIT_POSESORIA_LLAVES);
			if (success) adapter.actualizarEstadoPublicacionActivo(id);
			model.put(RESPONSE_SUCCESS_KEY, success);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, TabActivoService.TAB_SIT_POSESORIA_LLAVES, ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, TabActivoService.TAB_SIT_POSESORIA_LLAVES, ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoInformeComercial(DtoActivoInformeComercial activoDto, @RequestParam Long id, ModelMap model, HttpServletRequest request) {
		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_INFORME_COMERCIAL);
			if (success) adapter.actualizarEstadoPublicacionActivo(id);
			
			Activo activo = activoApi.get(id);
			// Después de haber guardado los cambios sobre información comercial, recalculamos el rating del activo.
			if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoActivo()) && DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())
					&& !Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getFechaAceptacion())){
				activoApi.calcularRatingActivo(id);
			}
			model.put(RESPONSE_SUCCESS_KEY, success);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, TabActivoService.TAB_INFORME_COMERCIAL, ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, TabActivoService.TAB_INFORME_COMERCIAL, ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoComunidadPropietarios(DtoComunidadpropietariosActivo activoDto, @RequestParam Long id, ModelMap model, HttpServletRequest request) {
		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_COMUNIDAD_PROPIETARIOS);
			if (success) {
				adapter.actualizarEstadoPublicacionActivo(id);	
				if(!Checks.esNulo(activoDto.getEstadoLocalizacion()) || !Checks.esNulo(activoDto.getSubestadoGestion()))  {
					 activoApi.crearHistoricoDiarioGestion(activoDto,id);
				}		
			}

			Activo activo = activoApi.get(id);
			// Después de haber guardado los cambios sobre informacion comercial, recalculamos el rating del activo.
			if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoActivo()) && DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())
					&& !Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getFechaAceptacion())){
				activoApi.calcularRatingActivo(id);
			}
			model.put(RESPONSE_SUCCESS_KEY, success);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, TabActivoService.TAB_COMUNIDAD_PROPIETARIOS, ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, TabActivoService.TAB_COMUNIDAD_PROPIETARIOS, ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListCargasById(Long id, WebDto webDto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getListCargasById(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListDistribucionesById(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getListDistribucionesById(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getNumeroPlantasActivo(Long idActivo, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getNumeroPlantasActivo(idActivo));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTipoHabitaculoByNumPlanta(Long idActivo, Integer numPlanta, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getTipoHabitaculoByNumPlanta(idActivo, numPlanta));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAsociadosById(DtoActivoVistaPatrimonioContrato dto, ModelMap model) {
		try {
			DtoPage page = adapter.getListAsociadosById(dto);
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAgrupacionesActivoById(Long id, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_DATA_KEY, adapter.getListAgrupacionesActivoById(id));
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "listadoAgrupaciones", ACCION_CODIGO.CODIGO_VER);

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListVisitasActivoById(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getListVisitasActivoById(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListOcupantesLegalesById(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getListOcupantesLegalesById(id));

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getOrigenActivo(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getOrigenActivo(id));

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getListLlavesById(DtoLlaves dto, ModelMap model) {
		try {
			DtoPage page = activoApi.getListLlavesByActivo(dto);

			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveLlave(DtoLlaves dto, ModelMap model, HttpServletRequest request) {
		try {
			boolean success = adapter.saveLlave(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);
			trustMe.registrarSuceso(request, Long.valueOf(dto.getIdActivo()), ENTIDAD_CODIGO.CODIGO_ACTIVO, "llave", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			trustMe.registrarError(request, Long.valueOf(dto.getIdActivo()), ENTIDAD_CODIGO.CODIGO_ACTIVO, "llave", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteLlave(DtoLlaves dto, ModelMap model) {
		try {
			boolean success = adapter.deleteLlave(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createLlave(DtoLlaves dto, ModelMap model) {
		try {
			boolean success = adapter.createLlave(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListCatastroById(Long id, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_DATA_KEY, adapter.getListCatastroById(id));
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "catastro", ACCION_CODIGO.CODIGO_VER);

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getValoresPreciosActivoById(@RequestParam Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getValoresPreciosActivoById(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCatastro(DtoActivoCatastro catastroDto, @RequestParam Long idCatastro, ModelMap model, HttpServletRequest request) {
		try {
			boolean success = adapter.saveCatastro(catastroDto, idCatastro);
			model.put(RESPONSE_SUCCESS_KEY, success);
			trustMe.registrarSuceso(request, catastroDto.getIdActivo(), ENTIDAD_CODIGO.CODIGO_ACTIVO, "catastro", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			trustMe.registrarError(request, catastroDto.getIdActivo(), ENTIDAD_CODIGO.CODIGO_ACTIVO, "catastro", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deletePrecioVigente(DtoPrecioVigente precioVigenteDto, ModelMap model) {
		try {
			boolean success = activoApi.deleteValoracionPrecioConGuardadoEnHistorico(precioVigenteDto.getIdPrecioVigente(), true,true);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deletePrecioVigenteSinGuardadoHistorico(DtoPrecioVigente precioVigenteDto, ModelMap model) {
		try {
			boolean success = activoApi.deleteValoracionPrecioConGuardadoEnHistorico(precioVigenteDto.getIdPrecioVigente(), false,true);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView savePrecioVigente(DtoPrecioVigente precioVigenteDto, ModelMap model, HttpServletRequest request) {
		try {
			if(precioVigenteDto.getImporte().equals(0d)) {
				model.put(RESPONSE_SUCCESS_KEY, false);
				model.put(RESPONSE_MESSAGE_KEY, ERROR_PRECIO_CERO);
			} else {
				boolean success = activoApi.savePrecioVigente(precioVigenteDto);
				if (success) {
					adapter.actualizarEstadoPublicacionActivo(precioVigenteDto.getIdActivo());
				}
				model.put(RESPONSE_SUCCESS_KEY, success);
			}
			trustMe.registrarSuceso(request, precioVigenteDto.getIdActivo(), ENTIDAD_CODIGO.CODIGO_ACTIVO, "precio", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			trustMe.registrarError(request, precioVigenteDto.getIdActivo(), ENTIDAD_CODIGO.CODIGO_ACTIVO, "precio", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDistribucion(DtoDistribucion distribucionDto, @RequestParam Long idDistribucion, ModelMap model) {
		try {
			boolean success = adapter.saveDistribucion(distribucionDto, idDistribucion);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}


	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createDistribucion(DtoDistribucion distribucionDto, @RequestParam Long idEntidad, ModelMap model) {
		try {
			boolean success = adapter.createDistribucion(distribucionDto, idEntidad);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}


	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createDistribucionFromRem(String numPlanta, String cantidad, String superficie, Long idActivo, String tipoHabitaculoCodigo, ModelMap model) {
		DtoDistribucion distribucionDto = new DtoDistribucion();
		DDTipoHabitaculo habitaculo = (DDTipoHabitaculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoHabitaculo.class, tipoHabitaculoCodigo);
		distribucionDto.setNumPlanta(numPlanta);
		distribucionDto.setCantidad(cantidad);
		distribucionDto.setSuperficie(superficie);
		distribucionDto.setTipoHabitaculoCodigo(tipoHabitaculoCodigo);
		distribucionDto.setTipoHabitaculoDescripcion(habitaculo.getDescripcion());

		try {
			boolean success = adapter.createDistribucion(distribucionDto, idActivo);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createCatastro(DtoActivoCatastro catastroDto, @RequestParam Long idEntidad, ModelMap model) {
		try {
			boolean success = adapter.createCatastro(catastroDto, idEntidad);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal, @RequestParam Long idEntidad, ModelMap model) {
		try {
			boolean success = adapter.createOcupanteLegal(dtoOcupanteLegal, idEntidad);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal, @RequestParam Long idActivoOcupanteLegal, ModelMap model) {
		try {
			boolean success = adapter.saveOcupanteLegal(dtoOcupanteLegal, idActivoOcupanteLegal);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteDistribucion(DtoDistribucion distribucionDto, @RequestParam Long idDistribucion, ModelMap model) {
		try {
			boolean success = adapter.deleteDistribucion(distribucionDto, idDistribucion);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteCatastro(DtoActivoCatastro catastroDto, @RequestParam Long idCatastro, ModelMap model) {

		try {
			boolean success = adapter.deleteCatastro(catastroDto, idCatastro);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);

	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal, @RequestParam Long idActivoOcupanteLegal, ModelMap model) {
		try {
			boolean success = adapter.deleteOcupanteLegal(dtoOcupanteLegal, idActivoOcupanteLegal);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListObservaciones(Long id, String tab, ModelMap model, HttpServletRequest request) {
		
		GridObservacionesApi observaciones = gridObservacionesFactory.getGridObservacionByCode(tab);
		try {
			model.put(RESPONSE_DATA_KEY, observaciones.getObservacionesById(id));
		}catch(Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
			logger.error(e);
		}
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "observaciones", ACCION_CODIGO.CODIGO_VER);
		return createModelAndViewJson(model);
		
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveObservacion(DtoObservacion dtoObservacion, String tab, ModelMap model) {
		try {
			GridObservacionesApi observaciones = gridObservacionesFactory.getGridObservacionByCode(tab);
			boolean success = observaciones.saveObservacion(dtoObservacion);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createObservacion(DtoObservacion dtoObservacion, Long idEntidad, String tab, ModelMap model) {
		try {
			GridObservacionesApi observaciones = gridObservacionesFactory.getGridObservacionByCode(tab);
			boolean success = observaciones.createObservacion(dtoObservacion, idEntidad);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteObservacionById(@RequestParam Long id, String tab, ModelMap model) {
		try {
			GridObservacionesApi observaciones = gridObservacionesFactory.getGridObservacionByCode(tab);
			boolean success = observaciones.deleteObservacion(id);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createCondicionHistorico(DtoCondicionHistorico dtoCondicionHistorico, Long idEntidad, ModelMap model) {
		try {
			boolean success = adapter.createCondicionHistorico(dtoCondicionHistorico, idEntidad);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListDocumentacionAdministrativaById(Long id, WebDto dto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getListDocumentacionAdministrativaById(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCargaById(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getCargaById(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTasacionById(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getTasacionById(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboUsuarios(Long idTipoGestor, WebDto webDto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getComboUsuarios(idTipoGestor));

		return new ModelAndView("jsonView", model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboUsuariosGestoria(WebDto webDto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getComboUsuariosGestoria());

		return new ModelAndView("jsonView", model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGestoresActivos(Long idActivo, WebDto webDto, ModelMap model, Boolean incluirGestoresInactivos) {
		if (incluirGestoresInactivos) {
			model.put(RESPONSE_DATA_KEY, adapter.getGestores(idActivo));
		} else {
			model.put(RESPONSE_DATA_KEY, adapter.getGestoresActivos(idActivo));
		}

		return new ModelAndView("jsonView", model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGestores(Long idActivo, WebDto webDto, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_DATA_KEY, adapter.getGestores(idActivo));
		trustMe.registrarSuceso(request, idActivo, ENTIDAD_CODIGO.CODIGO_ACTIVO, "gestores", ACCION_CODIGO.CODIGO_VER);

		return new ModelAndView("jsonView", model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getFotoActivoById(Long idFoto, HttpServletRequest request, HttpServletResponse response) {
		ActivoFoto actvFoto = adapter.getFotoActivoById(idFoto);
		if (actvFoto.getRemoteId() != null) {
			return new ModelAndView("redirect:" + actvFoto.getUrl());

		} else {
			FileItem fileItem = adapter.getFotoActivoById(idFoto).getAdjunto().getFileItem();

			try {
				ServletOutputStream salida = response.getOutputStream();

				response.setHeader("Content-disposition", "inline");
				response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
				response.setHeader("Cache-Control", "max-age=0");
				response.setHeader("Expires", "0");
				response.setHeader("Pragma", "public");
				response.setDateHeader("Expires", 0); // prevents caching at the
				// proxy

				if (fileItem.getContentType() != null) {
					response.setContentType(fileItem.getContentType());
				} else {
					response.setContentType("Content-type: image/jpeg");
				}

				// Write
				FileUtils.copy(fileItem.getInputStream(), salida);
				salida.flush();
				salida.close();

			} catch (Exception e) {
				logger.error("error en activoController", e);
			}

			return null;
		}
	}

	
	@RequestMapping(method = RequestMethod.GET)
	@Transactional()
	public ModelAndView getFotosById(Long id, String tipoFoto, WebDto webDto, ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		try {
			List<ActivoFoto> listaActivoFoto = adapter.getListFotosActivoById(id);
			List<DtoFoto> listaFotos = new ArrayList<DtoFoto>();

			if (listaActivoFoto != null) {
				for (ActivoFoto aListaActivoFoto : listaActivoFoto) {
					DtoFoto fotoDto = new DtoFoto();

					if (aListaActivoFoto.getTipoFoto() != null && aListaActivoFoto.getTipoFoto().getCodigo().equals(tipoFoto)) {
						try {
							if (aListaActivoFoto.getRemoteId() != null) {
								BeanUtils.copyProperty(fotoDto, "path", aListaActivoFoto.getUrlThumbnail());
							} else {
								BeanUtils.copyProperty(fotoDto, "path", "/pfs/activo/getFotoActivoById.htm?idFoto=" + aListaActivoFoto.getId());
							}

							BeanUtils.copyProperties(fotoDto, aListaActivoFoto);
							
							if(aListaActivoFoto.getActivo().getSubtipoActivo() != null) {
								BeanUtils.copyProperty(fotoDto, "codigoSubtipoActivo", aListaActivoFoto.getActivo().getSubtipoActivo().getCodigo());
							}
														
							if(aListaActivoFoto.getDescripcionFoto() != null) {
								BeanUtils.copyProperty(fotoDto, "codigoDescripcionFoto", aListaActivoFoto.getDescripcionFoto().getCodigo());
								BeanUtils.copyProperty(fotoDto, "descripcion", aListaActivoFoto.getDescripcionFoto().getDescripcion());
								if (aListaActivoFoto.getDescripcionFoto().getSubtipo() != null) {
									BeanUtils.copyProperty(fotoDto, "codigoSubtipoActivo", aListaActivoFoto.getDescripcionFoto().getSubtipo().getCodigo());
								}
							}

							if (aListaActivoFoto.getPrincipal() != null && aListaActivoFoto.getPrincipal()) {
								if (aListaActivoFoto.getInteriorExterior() != null) {
									if (aListaActivoFoto.getInteriorExterior()) {
										BeanUtils.copyProperty(fotoDto, "tituloFoto", "Principal INTERIOR");

									} else {
										BeanUtils.copyProperty(fotoDto, "tituloFoto", "Principal EXTERIOR");
									}
								}
							}

						} catch (IllegalAccessException e) {
							logger.error("error en activoController", e);

						} catch (InvocationTargetException e) {
							logger.error("error en activoController", e);
						}

						listaFotos.add(fotoDto);
					}
				}
			}

			model.put(RESPONSE_DATA_KEY, listaFotos);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "fotos", ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			return null;
		}

		return new ModelAndView("jsonView", model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateFotosById(DtoFoto dto, ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		try {
			boolean success = true;
			String[] data = request.getParameterValues("data");
			if(!Checks.esNulo(data)) {
				String[] fotos = data[0].substring(1, data[0].length()-1).split(",");
				DtoFoto dtoFoto = null;
				for(String foto: fotos) {
					String[] datosFoto = foto.split(":");				
					dtoFoto = new DtoFoto();
					dtoFoto.setId(Long.valueOf(datosFoto[0].substring(1,datosFoto[0].length()-1)));
					dtoFoto.setOrden(Integer.valueOf(datosFoto[1]) + 1);
					adapter.saveFoto(dtoFoto);
				}
			}else {
				success = adapter.saveFoto(dto);
			}			
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		model.put(RESPONSE_SUCCESS_KEY, true);
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateInformeComercialMSV(@RequestParam Long idActivo, ModelMap model){
		try {
			Boolean success = adapter.updateInformeComercialMSV(idActivo);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (JsonViewerException e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, e.getMessage());
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}


	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView insertarGestorAdicional(Long idActivo, Long usuarioGestor, Long tipoGestor, WebDto webDto, ModelMap model) {
		try {
			GestorEntidadDto dto = new GestorEntidadDto();
			dto.setIdEntidad(idActivo);
			dto.setIdUsuario(usuarioGestor);
			dto.setIdTipoGestor(tipoGestor);

			boolean success = adapter.insertarGestorAdicional(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);
			if (!success) {
				model.put("errorCode", "msg.activo.gestores.noasignar.tramite.multiactivo");
			}
			
			//si es activo matriz, debemos propagar a todas sus UA's
			if(activoDao.isActivoMatriz(idActivo)) {
				ActivoAgrupacion agr = activoDao.getAgrupacionPAByIdActivo(idActivo);
				if(!Checks.esNulo(agr)) {
					propagarCambiosGestoresUAs(agr.getId(), usuarioGestor, tipoGestor, webDto, model);
				}				
			}

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorCode", "msg.operacion.ko");
		}

		return new ModelAndView("jsonView", model);
	}

	private void propagarCambiosGestoresUAs(Long idAgrupacionUAS, Long usuarioGestor, Long tipoGestor,
			WebDto webDto, ModelMap model) {
		List<Activo> listaUAs = activoAgrupacionActivoDao.getListUAsByIdAgrupacion(idAgrupacionUAS);
		for (Activo activo : listaUAs) {
			insertarGestorAdicional(activo.getId(), usuarioGestor, tipoGestor, webDto, model);
		}
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTramites(Long idActivo, WebDto webDto, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_DATA_KEY, adapter.getTramitesActivo(idActivo, webDto));

		return new ModelAndView("jsonView", model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPreciosVigentesById(Long id, WebDto webDto, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_DATA_KEY, adapter.getPreciosVigentesById(id));
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "precios", ACCION_CODIGO.CODIGO_VER);

		return new ModelAndView("jsonView", model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListPropietarioById(Long id, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_DATA_KEY, adapter.getListPropietarioById(id));
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "propietarios", ACCION_CODIGO.CODIGO_VER);

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListDeudoresById(Long id, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_DATA_KEY, adapter.getListDeudoresById(id));
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "deudores", ACCION_CODIGO.CODIGO_VER);

		
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListValoracionesById(Long id, WebDto webDto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getListValoracionesById(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListTasacionById(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getListTasacionById(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListTasacionByIdGrid(Long id, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_DATA_KEY, adapter.getListTasacionByIdGrid(id));
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "tasaciones", ACCION_CODIGO.CODIGO_VER);

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdmisionCheckDocumentos(Long id, WebDto webDto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getListAdmisionCheckDocumentos(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListOfertasActivos(Long id, Boolean incluirOfertasAnuladas, WebDto webDto, ModelMap model) {
		if (incluirOfertasAnuladas) {
			model.put("data", adapter.getListOfertasActivos(id)); 
		}
		else {
			model.put("data", adapter.getListOfertasTramitadasVendidasActivos(id));
		}
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTramite(Long id, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_DATA_KEY, adapter.getTramite(id));
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_TRAMITE, "datosGenerales", ACCION_CODIGO.CODIGO_VER);

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboInferiorMunicipio(String codigoMunicipio, WebDto webDto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, activoApi.getComboInferiorMunicipio(codigoMunicipio));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTareasTramite(Long idTramite, WebDto webDto, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_DATA_KEY, adapter.getTareasTramite(idTramite));
		trustMe.registrarSuceso(request, idTramite, ENTIDAD_CODIGO.CODIGO_TRAMITE, "tareas", ACCION_CODIGO.CODIGO_VER);

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTareasTramiteHistorico(Long idTramite, WebDto webDto, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_DATA_KEY, adapter.getTareasTramiteHistorico(idTramite));
		trustMe.registrarSuceso(request, idTramite, ENTIDAD_CODIGO.CODIGO_TRAMITE, "historicoTareas", ACCION_CODIGO.CODIGO_VER);

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivosTramite(Long idTramite, WebDto webDto, ModelMap model, HttpServletRequest request) {
		List<Activo> listActivos = activoTramiteApi.getActivosTramite(idTramite);
		List<DtoActivoTramite> listDtoActivosTramite = activoTramiteApi.getDtoActivosTramite(listActivos);
		model.put(RESPONSE_DATA_KEY, listDtoActivosTramite);
		model.put(RESPONSE_TOTALCOUNT_KEY, listDtoActivosTramite.size());
		trustMe.registrarSuceso(request, idTramite, ENTIDAD_CODIGO.CODIGO_TRAMITE, "activos", ACCION_CODIGO.CODIGO_VER);

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView crearTramite(Long idActivo, ModelMap model) {
		try {
			if (activoTramiteApi.existeTramiteAdmision(idActivo)) {
				model.put("errorCreacion", "Ya existe un trámite de admisión para este activo");
				model.put(RESPONSE_SUCCESS_KEY, false);
			} else {
				if (activoApi.isVendido(idActivo)) {
					model.put("errorCreacion", "No se puede lanzar un trámite de admisión de un activo vendido");
					model.put(RESPONSE_SUCCESS_KEY, false);
				}else if(activoDao.isUnidadAlquilable(idActivo)) {
					model.put("errorCreacion", "No se puede lanzar un trámite de admisión de una unidad alquilable");
					model.put(RESPONSE_SUCCESS_KEY, false);
				}
				else {
					model.put(RESPONSE_DATA_KEY, adapter.crearTramiteAdmision(idActivo));
				}
			}

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView crearTramiteAprobacionInformeComercial(Long idActivo, ModelMap model) {
		try {
			Long idBpm = adapter.crearTramiteAprobacionInformeComercial(idActivo);
			if (new Long(0).equals(idBpm)) {
				model.put("errorCreacion", "El activo ya tiene un trámite de Aprobación Informe Comercial en trámite");
				model.put(RESPONSE_SUCCESS_KEY, false);
			}
			model.put(RESPONSE_DATA_KEY, idBpm);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView crearTrabajo(DtoFichaTrabajo dtoTrabajo, Long idActivo) {
		boolean success = trabajoApi.saveFichaTrabajo(dtoTrabajo, idActivo);

		return createModelAndViewJson(new ModelMap(RESPONSE_SUCCESS_KEY, success));
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveAdmisionDocumento(DtoAdmisionDocumento dtoAdmisionDocumento, ModelMap model, HttpServletRequest request) {
		try {
			boolean success = adapter.saveAdmisionDocumento(dtoAdmisionDocumento);
			model.put(RESPONSE_SUCCESS_KEY, success);

		}
		catch (RemUserException e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMensaje());
		}


		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(HttpServletRequest request, DtoSubirDocumento dto) {
		ModelMap model = new ModelMap();

		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			adapter.upload(webFileItem, null);
			model.put(RESPONSE_SUCCESS_KEY, true);			
		} catch (GestorDocumentalException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", "Ha habido un problema con la subida del fichero al gestor documental.");

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", "Ha habido un problema con la subida del fichero.");
		}

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getLimiteArchivo(HttpServletRequest request, HttpServletResponse response) {
		String limite = configManager.getConfigByKey("documentos.max.size").getValor();
		ModelMap model = new ModelMap();
		model.put("sucess",true);
		model.put("limite", limite);
		return JsonViewer.createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoActivo(HttpServletRequest request, HttpServletResponse response) {
		ServletOutputStream salida = null;
		
		try {
			Long id = Long.parseLong(request.getParameter("id"));
			String nombreDocumento = request.getParameter("nombreDocumento");
			salida = response.getOutputStream();
			FileItem fileItem = adapter.download(id, nombreDocumento);
			response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
			response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
			response.setHeader("Cache-Control", "max-age=0");
			response.setHeader("Expires", "0");
			response.setHeader("Pragma", "public");
			response.setDateHeader("Expires", 0); // prevents caching at the proxy
			if(!Checks.esNulo(fileItem.getContentType())) {
				response.setContentType(fileItem.getContentType());
			}

			// Write
			FileUtils.copy(fileItem.getInputStream(), salida);

		} catch(UserException ex) {
			try {
				salida.write(ex.toString().getBytes(Charset.forName("UTF-8")));
			} catch (IOException e) {
				logger.error("error en activoController", e);
			}
	
		}
		catch (SocketException e) {
			logger.warn("error en activoController", e);
		}catch (Exception e) {
			logger.error("error en activoController", e);
		}finally {
			try {
				salida.flush();			
				salida.close();
			} catch (IOException e) {
				logger.error("error en activoController", e);
			}
		}		
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAdjunto(DtoAdjunto dtoAdjunto, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, adapter.deleteAdjunto(dtoAdjunto));

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(Long id, ModelMap model, HttpServletRequest request) {
		try {
			model.put(RESPONSE_DATA_KEY, adapter.getAdjuntosActivo(id));

		} catch (GestorDocumentalException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "admisionDocumento", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "admisionDocumento", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAvisosActivoById(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getAvisosActivoById(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView uploadFoto(HttpServletRequest request, HttpServletResponse response) {
		ModelMap model = new ModelMap();

		try {
			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);

			String errores = activoApi.uploadFoto(fileItem);

			model.put("errores", errores);
			model.put(RESPONSE_SUCCESS_KEY, errores == null);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errores", e.getCause());
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteFotosActivoById(@RequestParam Long[] id, ModelMap model) {
		try {
			boolean success = adapter.deleteFotosActivoById(id);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (UserException e) {
			model.put("success", false);
			model.put("error", ERROR_CONEXION_FOTOS);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("error", ERROR_GENERICO);
		}

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView refreshCacheFotos(@RequestParam Long id, ModelMap model) {
		try {
			boolean success = adapter.deleteCacheFotosActivo(id);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (UserException e) {
			model.put("success", false);
			model.put("error", ERROR_CONEXION_FOTOS);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("error", ERROR_GENERICO);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findAllHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto, ModelMap model) {
		try {
			DtoPage page = adapter.findAllHistoricoPresupuestos(dto);

			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	/**
	 * Método que devuelve los incrementos con el idPresupuesto recibido. En caso de ser nulo o 0 el idPresupuesto, devuelve los del último ejercicio del Activo.
	 *
	 * @param idPresupuesto: ID del presupuesto.
	 * @param idActivo: ID del activo.
	 * @return Devuelve los incrementos. Si el idPresupuesto es nulo o 0 devuelve los del último ejercicio del Activo.
	 */
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findAllIncrementosPresupuestoById(Long idPresupuesto, Long idActivo, ModelMap model) {
		try {
			if (idPresupuesto == null || idPresupuesto == 0) {
				idPresupuesto = activoApi.getUltimoHistoricoPresupuesto(idActivo);
			}

			List<DtoIncrementoPresupuestoActivo> listaIncrementos = adapter.findAllIncrementosPresupuestoById(idPresupuesto);
			model.put(RESPONSE_DATA_KEY, listaIncrementos);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findLastPresupuesto(DtoActivosTrabajoFilter dto, ModelMap model) {
		try {
			DtoPresupuestoGraficoActivo presupuesto = adapter.findLastPresupuesto(dto);
			model.put(RESPONSE_DATA_KEY, presupuesto);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void getFotoPrincipalById(Long id, ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		List<ActivoFoto> listaActivoFoto = adapter.getListFotosActivoByIdOrderPrincipal(id);

		if (listaActivoFoto != null && !listaActivoFoto.isEmpty() && listaActivoFoto.get(0).getUrlThumbnail() != null && !listaActivoFoto.get(0).getUrlThumbnail().isEmpty()) {
			try {
				// En primera instancia obtener la foto de la URL
				String requestUrl = listaActivoFoto.get(0).getUrlThumbnail();
				URL url;
				URLConnection URLconn = null;
				String URLcontentType = null;

				try {
					url = new URL(requestUrl);
					URLconn = url.openConnection();
					URLcontentType = URLconn.getContentType();

				} catch (MalformedURLException me) {
					logger.error(me.getMessage(), me);

				} catch (IOException ioe) {
					logger.error(ioe.getMessage(), ioe);
				}

				ServletOutputStream salida = response.getOutputStream();

				response.setHeader("Content-disposition", "inline");
				response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
				response.setHeader("Cache-Control", "max-age=0");
				response.setHeader("Expires", "0");
				response.setHeader("Pragma", "public");
				response.setDateHeader("Expires", 0); // prevents caching at the proxy

				if (!Checks.esNulo(URLcontentType) && !Checks.esNulo(URLconn)) {
					response.setContentType("Content-type: image/jpeg");
					FileUtils.copy(URLconn.getInputStream(), salida);

				} else {
					response.setContentType("Content-type: image/jpeg");
					File file = new File(getClass().getResource("/").getPath() + "sin_imagen.png");
					if(file.createNewFile()) {
						FileUtils.copy((new FileInputStream(file)), salida);
					}
				}

				// Write
				salida.flush();
				salida.close();

			} catch (Exception e) {
				logger.error("error en activoController", e);
			}

		} else {
			try {
				ServletOutputStream salida = response.getOutputStream();

				response.setHeader("Content-disposition", "inline");
				response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
				response.setHeader("Cache-Control", "max-age=0");
				response.setHeader("Expires", "0");
				response.setHeader("Pragma", "public");
				response.setDateHeader("Expires", 0); // prevents caching at the proxy
				response.setContentType("Content-type: image/jpeg");

				File file = new File(getClass().getResource("/").getPath() + "sin_imagen.png");
				if(file.createNewFile()) {
					FileInputStream fis = new FileInputStream(file);
					FileUtils.copy(fis, salida);
				}
				salida.flush();
				salida.close();

			} catch (Exception e) {
				logger.error("error en activoController", e);
			}
		}
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public void generateExcel(DtoActivoGridFilter dtoActivoFilter, HttpServletRequest request, HttpServletResponse response) throws Exception {		
		Usuario usuario = usuarioManager.getUsuarioLogado();
		 List<VGridBusquedaActivos> listaActivos = (List<VGridBusquedaActivos>) adapter.getBusquedaActivosGrid(dtoActivoFilter, false);
		new EmptyParamDetector().isEmpty(listaActivos.size(), "activos", usuario.getUsername());
		ExcelReport report = new ActivoGridExcelReport(listaActivos);
		excelReportGeneratorApi.generateAndSend(report, response);	
	}	
	
	@RequestMapping(method = RequestMethod.POST)
	@Transactional()
	public ModelAndView registrarExportacion(DtoActivoGridFilter dto, Boolean exportar, String buscador, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String intervaloTiempo = !Checks.esNulo(appProperties.getProperty("haya.tiempo.espera.export")) ? appProperties.getProperty("haya.tiempo.espera.export") : "300000";
		ModelMap model = new ModelMap();		 
		Boolean isSuperExport = false;
		Boolean permitido = true;
		String filtros = parameterParser(request.getParameterMap());
		Usuario user = usuarioManager.getUsuarioLogado();
		Long tiempoPermitido = System.currentTimeMillis() - Long.parseLong(intervaloTiempo);
		String cuentaAtras = null;
		try {
			Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", user.getId());
			Filter filtroConsulta = genericDao.createFilter(FilterType.EQUALS, "filtros", filtros);
			Filter filtroAccion = genericDao.createFilter(FilterType.EQUALS, "accion", true);
			Order orden = new Order(OrderType.DESC, "fechaExportacion");
			List<AuditoriaExportaciones> listaExportaciones =  genericDao.getListOrdered(AuditoriaExportaciones.class, orden, filtroUsuario, filtroConsulta, filtroAccion);
			
			if(listaExportaciones != null && !listaExportaciones.isEmpty()) {
				Long ultimaExport = listaExportaciones.get(0).getFechaExportacion().getTime();
				permitido = ultimaExport > tiempoPermitido ? false : true;

				double entero = Math.floor((ultimaExport - tiempoPermitido)/60000);
		        if (entero < 2) {
		        	cuentaAtras = "un minuto";
		        } else {
		        	cuentaAtras = Double.toString(entero);
		        	cuentaAtras = cuentaAtras.substring(0, 1) + " minutos";
		        }
			}
			
			if(permitido) {
				int count = ((Page)adapter.getBusquedaActivosGrid(dto, true)).getTotalCount();
				AuditoriaExportaciones ae = new AuditoriaExportaciones();
				ae.setBuscador(buscador);
				ae.setFechaExportacion(new Date());
				ae.setNumRegistros(Long.valueOf(count));
				ae.setUsuario(user);
				ae.setFiltros(filtros);
				ae.setAccion(exportar);
				genericDao.save(AuditoriaExportaciones.class, ae);
				
				model.put(RESPONSE_SUCCESS_KEY, true);
				model.put(RESPONSE_DATA_KEY, count);
				for(Perfil pef : user.getPerfiles()) {
					if(pef.getCodigo().equals("SUPEREXPORTACTAGR")) {
						isSuperExport = true;
						break;
					}
				}
				if(isSuperExport) {
					model.put("limite", configManager.getConfigByKey("super.limite.exportar.excel.activos").getValor());
					model.put("limiteMax", configManager.getConfigByKey("super.limite.maximo.exportar.excel.activos").getValor());
				}else {
					model.put("limite", configManager.getConfigByKey("limite.exportar.excel.activos").getValor());
					model.put("limiteMax", configManager.getConfigByKey("limite.maximo.exportar.excel.activos").getValor());
				}
			} else {
				model.put("msg", cuentaAtras);
			}
		}catch(Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en activoController::registrarExportacion", e);
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("rawtypes")
	private String parameterParser(Map map) {
		StringBuilder mapAsString = new StringBuilder("{");
	    for (Object key : map.keySet()) {
	    	if(!key.toString().equals("buscador") && !key.toString().equals("exportar"))
	    		mapAsString.append(key.toString() + "=" + ((String[])map.get(key))[0] + ",");
	    }
	    mapAsString.delete(mapAsString.length()-1, mapAsString.length());
	    if(mapAsString.length()>0)
	    	mapAsString.append("}");
	    return mapAsString.toString();
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCondicionantesDisponibilidad(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, activoApi.getCondicionantesDisponibilidad(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCondicionantesDisponibilidad(Long idActivo, DtoCondicionantesDisponibilidad dto, ModelMap model, HttpServletRequest request) {
		try {
			boolean success = adapter.guardarCondicionantesDisponibilidad(idActivo, dto);
			model.put(RESPONSE_SUCCESS_KEY, success);
	
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto, ModelMap model, HttpServletRequest request) {
		try {
			DtoPage page = activoApi.getHistoricoValoresPrecios(dto);
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro, ModelMap model, HttpServletRequest request) {
		try {
			Page page = activoApi.getPropuestas(dtoPropuestaFiltro);
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, Long.valueOf(dtoPropuestaFiltro.getIdActivo()), ENTIDAD_CODIGO.CODIGO_ACTIVO, "propuestas", ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCondicionEspecificaByActivo(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, activoApi.getCondicionEspecificaByActivo(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica, ModelMap model) {
		model.put(RESPONSE_SUCCESS_KEY, activoApi.createCondicionEspecifica(dtoCondicionEspecifica));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView darDeBajaCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica, ModelMap model) {
		model.put(RESPONSE_SUCCESS_KEY, activoApi.darDeBajaCondicionEspecifica(dtoCondicionEspecifica));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_SUCCESS_KEY, activoApi.saveCondicionEspecifica(dtoCondicionEspecifica));
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoEstadosPublicacionVentaByIdActivo(DtoPaginadoHistoricoEstadoPublicacion dto, ModelMap model) {
		DtoPaginadoHistoricoEstadoPublicacion listadoPaginado = activoEstadoPublicacionApi.getHistoricoEstadosPublicacionVentaByIdActivo(dto);
		model.put(RESPONSE_DATA_KEY, listadoPaginado.getListado());
		model.put(RESPONSE_TOTALCOUNT_KEY, listadoPaginado.getTotalCount());
		model.put(RESPONSE_SUCCESS_KEY, true);

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoEstadosPublicacionAlquilerByIdActivo(DtoPaginadoHistoricoEstadoPublicacion dto, ModelMap model) {
		DtoPaginadoHistoricoEstadoPublicacion listadoPaginado = activoEstadoPublicacionApi.getHistoricoEstadosPublicacionAlquilerByIdActivo(dto);
		model.put(RESPONSE_DATA_KEY, listadoPaginado.getListado());
		model.put(RESPONSE_TOTALCOUNT_KEY, listadoPaginado.getTotalCount());
		model.put(RESPONSE_SUCCESS_KEY, true);

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getEstadoInformeComercialByActivo(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, activoApi.getEstadoInformeComercialByActivo(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoMediadorByActivo(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, activoApi.getHistoricoMediadorByActivo(id));

		return createModelAndViewJson(model);
	}

	List<DtoHistoricoMediador> getHistoricoMediadorByActivo(Long id) {
		return activoApi.getHistoricoMediadorByActivo(id);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createHistoricoMediador(DtoHistoricoMediador dto, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, activoApi.createHistoricoMediador(dto));

		} catch (JsonViewerException jvex) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, jvex.getMessage());
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivosPublicacion(DtoActivosPublicacion dtoActivosPublicacion, ModelMap model) {
		try {
			Page page = activoApi.getActivosPublicacion(dtoActivosPublicacion);
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getPublicacionGrid(DtoPublicacionGridFilter dto, ModelMap model) {
		try {
			Page page = activoApi.getPublicacionGrid(dto);
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en ActivoController::getPublicacionGrid", e);
		}
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelPublicaciones(DtoPublicacionGridFilter dto, HttpServletRequest request, HttpServletResponse response) throws Exception {
		dto.setStart(excelReportGeneratorApi.getStart());
		dto.setLimit(excelReportGeneratorApi.getLimit());
		List<VGridBusquedaPublicaciones> listaPublicacionesActivos = (List<VGridBusquedaPublicaciones>) activoApi.getPublicacionGrid(dto).getResults();
		ExcelReport report = new PublicacionExcelReport(listaPublicacionesActivos);
		excelReportGeneratorApi.generateAndSend(report, response);
	}	
	
	@RequestMapping(method = RequestMethod.POST)
	@Transactional()
	public ModelAndView registrarExportacionPublicaciones(DtoPublicacionGridFilter dto, Boolean exportar, String buscador, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String intervaloTiempo = !Checks.esNulo(appProperties.getProperty("haya.tiempo.espera.export")) ? appProperties.getProperty("haya.tiempo.espera.export") : "300000";
		ModelMap model = new ModelMap();		 
		Boolean isSuperExport = false;
		Boolean permitido = true;
		String filtros = parameterParser(request.getParameterMap());
		Usuario user = usuarioManager.getUsuarioLogado();
		Long tiempoPermitido = System.currentTimeMillis() - Long.parseLong(intervaloTiempo);
		String cuentaAtras = null;

		try {
			Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", user.getId());
			Filter filtroConsulta = genericDao.createFilter(FilterType.EQUALS, "filtros", filtros);
			Filter filtroAccion = genericDao.createFilter(FilterType.EQUALS, "accion", true);
			Order orden = new Order(OrderType.DESC, "fechaExportacion");
			List<AuditoriaExportaciones> listaExportaciones =  genericDao.getListOrdered(AuditoriaExportaciones.class, orden, filtroUsuario, filtroConsulta, filtroAccion);
			
			if(listaExportaciones != null && !listaExportaciones.isEmpty()) {
				Long ultimaExport = listaExportaciones.get(0).getFechaExportacion().getTime();
				permitido = ultimaExport > tiempoPermitido ? false : true;

				double entero = Math.floor((ultimaExport - tiempoPermitido)/60000);
		        if (entero < 2) {
		        	cuentaAtras = "un minuto";
		        } else {
		        	cuentaAtras = Double.toString(entero);
		        	cuentaAtras = cuentaAtras.substring(0, 1) + " minutos";
		        }
			}
			if(permitido) {
				int count = activoApi.getPublicacionGrid(dto).getTotalCount();
				AuditoriaExportaciones ae = new AuditoriaExportaciones();
				ae.setBuscador(buscador);
				ae.setFechaExportacion(new Date());
				ae.setNumRegistros(Long.valueOf(count));
				ae.setUsuario(user);
				ae.setFiltros(filtros);
				ae.setAccion(exportar);
				genericDao.save(AuditoriaExportaciones.class, ae);
				model.put(RESPONSE_SUCCESS_KEY, true);
				model.put(RESPONSE_DATA_KEY, count);
				for(Perfil pef : user.getPerfiles()) {
					if(pef.getCodigo().equals("SUPEREXPORTPUBLI")) {
						isSuperExport = true;
						break;
					}
				}
				if(isSuperExport) {
					model.put("limite", configManager.getConfigByKey("super.limite.exportar.excel.publicaciones").getValor());
					model.put("limiteMax", configManager.getConfigByKey("super.limite.maximo.exportar.excel.publicaciones").getValor());
				}else {
					model.put("limite", configManager.getConfigByKey("limite.exportar.excel.publicaciones").getValor());
					model.put("limiteMax", configManager.getConfigByKey("limite.maximo.exportar.excel.publicaciones").getValor());
				}
			} else {
				model.put("msg", cuentaAtras);
			}
		}catch(Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en activoController", e);
		}
		return createModelAndViewJson(model);		
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDatosPublicacionActivo(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, activoEstadoPublicacionApi.getDatosPublicacionActivo(id));
		model.put(RESPONSE_SUCCESS_KEY, true);

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView setDatosPublicacionActivo(DtoDatosPublicacionActivo dto, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, activoEstadoPublicacionApi.setDatosPublicacionActivo(dto));

		} catch (JsonViewerException e) {
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error al guardar los datos de publicacion del activo", e);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createOferta(DtoOfertasFilter dtoOferta, ModelMap model) {
		try {
			//solo son venta directa desde masivo
			dtoOferta.setVentaDirecta(false);
			boolean success = !Checks.esNulo(adapter.createOfertaActivo(dtoOferta));
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			if (e.getMessage().equals(ActivoAdapter.OFERTA_INCOMPATIBLE_MSG)) {
				model.put(RESPONSE_MESSAGE_KEY, ActivoAdapter.OFERTA_INCOMPATIBLE_MSG);
				model.put(RESPONSE_SUCCESS_KEY, false);
			} else {
				logger.error("error en activoController", e);
				model.put(RESPONSE_SUCCESS_KEY, false);
			}
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto, ModelMap model) {
		try {
			List<DtoPropuestaActivosVinculados> dtoActivosVinculados = activoApi.getPropuestaActivosVinculadosByActivo(dto);

			model.put(RESPONSE_DATA_KEY, dtoActivosVinculados);
			if (!Checks.estaVacio(dtoActivosVinculados)) {
				model.put(RESPONSE_TOTALCOUNT_KEY, dtoActivosVinculados.get(0).getTotalCount());
			} else {
				model.put(RESPONSE_TOTALCOUNT_KEY, 0);
			}
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto, ModelMap model) {
		try {
			boolean success = activoApi.createPropuestaActivosVinculadosByActivo(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deletePropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto, ModelMap model) {
		try {
			boolean success = activoApi.deletePropuestaActivosVinculadosByActivo(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView solicitarTasacion(Long idActivo, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, activoApi.solicitarTasacion(idActivo));

		} catch (JsonViewerException jve) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, jve.getMessage());

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en activoController", e);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getSolicitudTasacionBankia(Long id, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY, activoApi.getSolicitudTasacionBankia(id));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (JsonViewerException jve) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_MESSAGE_KEY, jve.getMessage());
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en activoController", e);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getProveedorByActivo(Long idActivo, ModelMap model) {
		try {
			List<VBusquedaProveedoresActivo> lista = activoApi.getProveedorByActivo(idActivo);
			model.put(RESPONSE_DATA_KEY, lista);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGastoByActivo(Long idActivo, Long idProveedor, WebDto dto, ModelMap model) {
		try {
			Page lista = activoApi.getGastoByActivo(idActivo, idProveedor, dto);

			if (lista != null) {
				model.put(RESPONSE_DATA_KEY, lista.getResults());
				model.put(RESPONSE_TOTALCOUNT_KEY, lista.getTotalCount());
			}
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivoTributosById(Long idActivo, WebDto dto, ModelMap model) {
		try {
			List<DtoActivoTributos> lista = activoApi.getActivoTributosByActivo(idActivo, dto);
			model.put(RESPONSE_DATA_KEY, lista);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}
	
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveOrUpdateActivoTributo(DtoActivoTributos activoTributosDto, @RequestParam Long idEntidad, ModelMap model, HttpServletRequest request) {
		try {
			boolean success = activoApi.saveOrUpdateActivoTributo(activoTributosDto, idEntidad);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteActivoTributo(DtoActivoTributos activoTributosDto, @RequestParam Long idTributo, ModelMap model, HttpServletRequest request) {
		try {
			boolean success = activoApi.deleteActivoTributo(activoTributosDto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getReglasPublicacionAutomatica(DtoReglasPublicacionAutomatica dto, ModelMap model) {
		try {
			List<DtoReglasPublicacionAutomatica> dtoReglasPublicacionAutomatica = activoApi.getReglasPublicacionAutomatica(dto);

			model.put(RESPONSE_DATA_KEY, dtoReglasPublicacionAutomatica);
			if (!Checks.estaVacio(dtoReglasPublicacionAutomatica)) {
				model.put(RESPONSE_TOTALCOUNT_KEY, dtoReglasPublicacionAutomatica.get(0).getTotalCount());
			} else {
				model.put(RESPONSE_TOTALCOUNT_KEY, 0);
			}
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createReglaPublicacionAutomatica(DtoReglasPublicacionAutomatica dto, ModelMap model) {
		try {
			boolean success = activoApi.createReglaPublicacionAutomatica(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteReglaPublicacionAutomatica(DtoReglasPublicacionAutomatica dto, ModelMap model) {
		try {
			boolean success = activoApi.deleteReglaPublicacionAutomatica(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getProveedoresByActivoIntegrado(DtoActivoIntegrado dtoActivoIntegrado, ModelMap model) {
		try {
			List<DtoActivoIntegrado> resultados = activoApi.getProveedoresByActivoIntegrado(dtoActivoIntegrado);
			model.put(RESPONSE_DATA_KEY, resultados);

			if (!Checks.estaVacio(resultados)) {
				model.put(RESPONSE_TOTALCOUNT_KEY, resultados.get(0).getTotalCount());
			} else {
				model.put(RESPONSE_TOTALCOUNT_KEY, 0);
			}
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createActivoIntegrado(DtoActivoIntegrado dto, ModelMap model) {
		try {
			boolean success = activoApi.createActivoIntegrado(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivoIntegrado(@RequestParam String id, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY, activoApi.getActivoIntegrado(id));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateActivoIntegrado(DtoActivoIntegrado dto, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY, activoApi.updateActivoIntegrado(dto));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getListHistoricoOcupacionesIlegales(ModelMap model, WebDto dto, Long idActivo) {

		try {

			DtoPage page = activoApi.getListHistoricoOcupacionesIlegales(dto, idActivo);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getListMovimientosLlaveByLlave(ModelMap model, WebDto dto, Long idLlave, Long idActivo) {
		try {
			DtoPage page = activoApi.getListMovimientosLlaveByLlave(dto, idLlave, idActivo);
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createMovimientoLlave(DtoMovimientoLlave dtoMovimiento, ModelMap model) {
		try {
			boolean success = adapter.createMovimientoLlave(dtoMovimiento);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveMovimientoLlave(DtoMovimientoLlave dto, ModelMap model) {
		try {
			boolean success = adapter.saveMovimientoLlave(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteMovimientoLlave(DtoMovimientoLlave dto, ModelMap model) {
		try {
			boolean success = adapter.deleteMovimientoLlave(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComercialActivo(DtoComercialActivo dto, ModelMap model, HttpServletRequest request) {
		try {
			model.put(RESPONSE_DATA_KEY, activoApi.getComercialActivo(dto));
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, Long.valueOf(dto.getId()), ENTIDAD_CODIGO.CODIGO_ACTIVO, "comercial", ACCION_CODIGO.CODIGO_VER);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			trustMe.registrarError(request, Long.valueOf(dto.getId()), ENTIDAD_CODIGO.CODIGO_ACTIVO, "comercial", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveComercialActivo(DtoComercialActivo dto, ModelMap model, HttpServletRequest request) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, activoApi.saveComercialActivo(dto));
			trustMe.registrarSuceso(request, Long.valueOf(dto.getId()), ENTIDAD_CODIGO.CODIGO_ACTIVO, "comercial", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (JsonViewerException jvex) {
			logger.error("error en activoController.saveComercialActivo", jvex);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, jvex.getMessage());
			trustMe.registrarError(request, Long.valueOf(dto.getId()), ENTIDAD_CODIGO.CODIGO_ACTIVO, "comercial", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			trustMe.registrarError(request, Long.valueOf(dto.getId()), ENTIDAD_CODIGO.CODIGO_ACTIVO, "comercial", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteCarga(DtoActivoCargas dtoCarga, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, activoApi.deleteCarga(dtoCarga));

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView comprobarActivoFormalizable(Long numActivo, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, activoApi.esActivoFormalizable(numActivo));

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboUsuariosGestorActivos(WebDto webDto, ModelMap model) {
		EXTDDTipoGestor tipoGestorActivos = (EXTDDTipoGestor) utilDiccionarioApi.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GACT");

		model.put(RESPONSE_DATA_KEY, adapter.getComboUsuarios(tipoGestorActivos.getId()));

		return new ModelAndView("jsonView", model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboSupervisorActivos(WebDto webDto, ModelMap model) {
		EXTDDTipoGestor tipoGestorActivos = (EXTDDTipoGestor) utilDiccionarioApi.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SUPACT");

		model.put(RESPONSE_DATA_KEY, adapter.getComboUsuarios(tipoGestorActivos.getId()));

		return new ModelAndView("jsonView", model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView propagarInformacion(@RequestParam() Long id, @RequestParam() String tab, ModelMap model) {
		List<String> fields = new ArrayList<String>();
		
		if(!activoDao.isActivoMatriz(id)) {
			if(ActivoPropagacionFieldTabMap.map.get(tab) != null) {
				fields.addAll(ActivoPropagacionFieldTabMap.map.get(tab));
			}
		}else {
			if(ActivoPropagacionUAsFieldTabMap.mapUAs.get(tab) != null) {
				fields.addAll(ActivoPropagacionUAsFieldTabMap.mapUAs.get(tab));
			}
		}

		model.put("propagateFields", fields);
		model.put("activos", activoPropagacionApi.getAllActivosAgrupacionPorActivo(activoApi.get(id)));

		return new ModelAndView("jsonView", model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivo(HttpServletRequest request, ModelMap model) {
		if (request != null) {
			try {
				RestRequestWrapper restRequest = new RestRequestWrapper(request);

				ActivoControllerDispatcher dispatcher = new ActivoControllerDispatcher(this);
				dispatcher.dispatchSave(restRequest.getJsonObject(), request);
			} catch (JsonViewerException jvex) {
				model.put(RESPONSE_SUCCESS_KEY, false);
				model.put(RESPONSE_ERROR_MESSAGE_KEY, jvex.getMessage());
				model.put(RESPONSE_MESSAGE_KEY, jvex.getMessage());
			} catch (Exception e) {
				logger.error("No se ha podido guardar el activo", e); 
				model.put(RESPONSE_ERROR_KEY, e.getMessage()); 
			}
		}

		return new ModelAndView("jsonView", model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView checkAndSendMailAvisoOcupacion(HttpServletRequest request, ModelMap model)  {
		return new ModelAndView("jsonView", new ModelMap());
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivosAgrRestringida(HttpServletRequest request, ModelMap model) {
		if (request != null) {
			try {
				RestRequestWrapper restRequest = new RestRequestWrapper(request);
				ActivoControllerDispatcher dispatcher = new ActivoControllerDispatcher(this);
				JSONObject json = restRequest.getJsonObject();

				DtoActivoFichaCabecera dto = activoApi.getActivosAgrupacionRestringida(json.getLong("id"));
				List<VActivosAgrupacionLil> activos = (List<VActivosAgrupacionLil>) dto.getActivosAgrupacionRestringida();

				for(VActivosAgrupacionLil act : activos) {
					json.put("id", act.getActivoId());
					json.put("models.id", act.getActivoId());
					dispatcher.dispatchSave(json, request);
				}

			} catch (JsonViewerException jvex) {
				logger.error("No se ha podido guardar el activo", jvex);
				model.put(RESPONSE_SUCCESS_KEY, false);
				model.put(RESPONSE_ERROR_MESSAGE_KEY, jvex.getMessage());
			} catch (Exception e) {
				logger.error("No se ha podido guardar el activo", e);
				model.put(RESPONSE_ERROR_KEY, e.getMessage());
			}
		}

		return new ModelAndView("jsonView", model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createTasacionActivo(String importeTasacionFin, String tipoTasacionCodigo, String nomTasador, Date fechaValorTasacion, Long idEntidad, ModelMap model) {
		try {
			boolean success = adapter.createTasacion(importeTasacionFin, tipoTasacionCodigo, nomTasador, fechaValorTasacion, idEntidad);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveTasacionActivo(DtoTasacion tasacionDto, ModelMap model, HttpServletRequest request) {
		try {
			boolean success = adapter.saveTasacion(tasacionDto);
			model.put(RESPONSE_SUCCESS_KEY, success);
			trustMe.registrarSuceso(request, tasacionDto.getIdActivo(), ENTIDAD_CODIGO.CODIGO_ACTIVO, "tasacion", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			trustMe.registrarError(request, tasacionDto.getIdActivo(), ENTIDAD_CODIGO.CODIGO_ACTIVO, "tasacion", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDatosPatrimonio(DtoActivoPatrimonio patrimonioDto, @RequestParam Long id, ModelMap model, HttpServletRequest request) {
		try {
			
			boolean success = adapter.saveTabActivo(patrimonioDto, id, TabActivoService.TAB_PATRIMONIO);
			if (success){
				
				adapter.actualizarEstadoPublicacionActivo(id);
				activoApi.actualizarMotivoOcultacionUAs(patrimonioDto, id);
				
			}
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (JsonViewerException jvex) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, jvex.getMessage());
			throw new JsonViewerException(jvex.getMessage());

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "tasacion", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoAdecuacionesAlquilerByActivo(DtoActivoPatrimonio dto, @RequestParam Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, activoApi.getHistoricoAdecuacionesAlquilerByActivo(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getImpuestosByActivo(Long idActivo, ModelMap model) {
		try {
			List<DtoImpuestosActivo> lista = activoApi.getImpuestosByActivo(idActivo);
			model.put(RESPONSE_DATA_KEY, lista);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getImpuestos(DtoProveedorFilter dtoProveedorFiltro, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en activoController", e);
		}

		return createModelAndViewJson(model);

	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createImpuestos(DtoImpuestosActivo dtoImpuestosFilter, ModelMap model) {
		try {
			boolean success = activoApi.createImpuestos(dtoImpuestosFilter);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en activoController", e);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteImpuestos(DtoImpuestosActivo dtoImpuestosFilter, ModelMap model) {
		try {
			boolean success = activoApi.deleteImpuestos(dtoImpuestosFilter);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en activoController", e);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateImpuestos(DtoImpuestosActivo dtoImpuestosFilter, ModelMap model) {
		try {
			boolean succes = activoApi.updateImpuestos(dtoImpuestosFilter);
			model.put("succes", succes);

		} catch (Exception e) {
			model.put("succes", false);
			logger.error("error en activoController", e);
		}

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateCalificacionNegativa(DtoActivoDatosRegistrales dtoActivosDatosRegistrales, ModelMap model) {
		try {
			boolean success = activoApi.updateCalificacionNegativa(dtoActivosDatosRegistrales);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			logger.error("error en updateCalificacionNegativa", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createCalificacionNegativa(@RequestParam Long idEntidadPk, DtoActivoDatosRegistrales dtoActivosDatosRegistrales, ModelMap model) {
		try {
			dtoActivosDatosRegistrales.setIdActivo(idEntidadPk);
			boolean success = activoApi.createCalificacionNegativa(dtoActivosDatosRegistrales);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			logger.error("error en CalificacionNegativa", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView destroyCalificacionNegativa(DtoActivoDatosRegistrales dtoActivosDatosRegistrales, ModelMap model) {
		try {
			boolean success = activoApi.destroyCalificacionNegativa(dtoActivosDatosRegistrales);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en destroyCalificacionNegativa", e);
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivoParaCrearPeticionTrabajo(Long idActivo, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY, activoApi.getActivoParaCrearPeticionTrabajobyId(idActivo));
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivosPropagables(String idActivo, ModelMap model){
		try{
			model.put(RESPONSE_DATA_KEY, activoApi.getActivosPropagables(Long.valueOf(idActivo)));
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@Transactional()
	public boolean actualizarEstadoPublicacionActivo(Long id) {
		return activoAdapter.actualizarEstadoPublicacionActivo(id);

	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoDestinoComercialByActivo(@RequestParam Long id, ModelMap model, WebDto dto) {

		List<DtoHistoricoDestinoComercial> data = activoApi.getDtoHistoricoDestinoComercialByActivo(id);

		model.put("data", data.subList(dto.getStart(), ( (data.size() < (dto.getStart() + dto.getLimit()) ) ? data.size() : (dto.getStart() + dto.getLimit()) ) ));
		model.put("totalCount", data.size());
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivoExists(String numActivo, ModelMap model) {

		try {
			Long idActivo = activoApi.getActivoExists(Long.parseLong(numActivo));

			if(!Checks.esNulo(idActivo)) {
				model.put("success", true);
				model.put("data", idActivo);
			}else {
				model.put("success", false);
				model.put("error", ERROR_ACTIVO_NOT_EXISTS);
			}
		} catch (NumberFormatException e) {
			model.put("success", false);
			model.put("error", ERROR_ACTIVO_NO_NUMERICO);
		} catch(Exception e) {
			logger.error("error obteniendo el activo ",e);
			model.put("success", false);
			model.put("error", ERROR_GENERICO);
		}
		return createModelAndViewJson(model);
	}

	public boolean activoTieneOfertaByTipoOfertaCodigo(List<Oferta> ofertas, String tipoCodigo)
	{
		for(Oferta oferta : ofertas)
		{
			if(ofertaApi.estaViva(oferta) && tipoCodigo.equals(oferta.getTipoOferta().getCodigo()))
			{
				return true;
			}
		}
		return false;
	}


	@RequestMapping(method = RequestMethod.POST)
	public void generarUrlGDPR(DtoGenerarDocGDPR dtoGenerarDocGDPR, HttpServletRequest request, HttpServletResponse response) {
		try {
			FileItem fileItem = activoApi.generarUrlGDPR(dtoGenerarDocGDPR);
			ServletOutputStream salida = response.getOutputStream();

			response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
			response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
			response.setHeader("Cache-Control", "max-age=0");
			response.setHeader("Expires", "0");
			response.setHeader("Pragma", "public");
			response.setDateHeader("Expires", 0); // prevents caching at the proxy
			response.setContentType(fileItem.getContentType());

			// Write
			FileUtils.copy(fileItem.getInputStream(), salida);
			salida.flush();
			salida.close();

		} catch (Exception e) {
			logger.error("Error en ActivoCOntroller", e);
		}
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getMotivoAnulacionExpediente(ModelMap model) {

		try {
			List <DtoMotivoAnulacionExpediente> dto= activoApi.getMotivoAnulacionExpediente();

			model.put("data", dto);
			model.put("success", true);

		} catch (Exception e) {
			logger.error("Error en ActivoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getIsUnidadAlquilable(Long idActivo,ModelMap model) {
		
		try {
			model.put(RESPONSE_DATA_KEY, activoAdapter.isUnidadAlquilable(idActivo));
			model.put("success", true);
			
		}catch (Exception e) {
			logger.error("Error en ActivoController", e);
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getCalificacionNegativaMotivo( Long idActivo, String idMotivo, ModelMap model) {

		try {
			
			DtoActivoDatosRegistrales dtoActCalNeg = activoApi.getCalificacionNegativoByidActivoIdMotivo(idActivo, idMotivo);

			model.put("data", dtoActCalNeg);
			model.put("success", true);

		} catch (Exception e) {
			logger.error("Error en ActivoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getIsActivoMatriz(String idActivo, ModelMap model){
		try{
			model.put(RESPONSE_DATA_KEY, activoDao.isActivoMatriz(Long.parseLong(idActivo)));
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());

		}

		return createModelAndViewJson(model);
	}
	

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivoIdHaya(Long idActivo, ModelMap model){
		try{
			model.put(RESPONSE_DATA_KEY, activoDao.existeactivoIdHAYA(idActivo)); 
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());

		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivoVendido(Long idActivo, ModelMap model){
		try{
			model.put(RESPONSE_DATA_KEY, activoDao.activoEstadoVendido(idActivo));  
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());

		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getPerimetroHaya(Long idActivo, ModelMap model){
		try{
			model.put(RESPONSE_DATA_KEY, activoDao.activoFueraPerimetroHAYA(idActivo)); 
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());

		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivoBBVAoCERBERUS(Long idActivo, ModelMap model){
		try{
			model.put(RESPONSE_DATA_KEY, activoDao.activoPerteneceABBVAAndCERBERUS(idActivo)); 
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());

		}

		return createModelAndViewJson(model);
	}
	
	
	

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCalificacionNegativaMotivo(Long idActivo, String idMotivo, String calificacionNegativa, String estadoMotivoCalificacionNegativa, 
			String responsableSubsanar, String descripcionCalificacionNegativa, String fechaSubsanacion, ModelMap model) {
		
		DtoActivoDatosRegistrales dto = new DtoActivoDatosRegistrales();
		dto.setNumeroActivo(idActivo.toString());
		dto.setMotivoCalificacionNegativa(idMotivo);
		dto.setCodigoMotivoCalificacionNegativa(idMotivo);
		dto.setCalificacionNegativa(calificacionNegativa);
		dto.setEstadoMotivoCalificacionNegativa(estadoMotivoCalificacionNegativa);
		dto.setResponsableSubsanar(responsableSubsanar);
		dto.setDescripcionCalificacionNegativa(descripcionCalificacionNegativa);
		if(!Checks.esNulo(fechaSubsanacion)) {
			
			try {
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
				Date fecha = format.parse(fechaSubsanacion);
				dto.setFechaSubsanacion(fecha);
			} catch (ParseException e) {
				logger.error("Error en ActivoController", e);
			}
			
		}
		
		
		try {
			model.put("success", activoApi.saveCalificacionNegativoMotivo(dto));
		}catch(Exception e) {
			logger.error("Error en ActivoController", e);
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getMotivosCalificacionNegativaSubsanados( Long idActivo, String idMotivo, ModelMap model) {

		try {
			
			boolean resultado = activoApi.getMotivosCalificacionNegativaSubsanados(idActivo,idMotivo);

			model.put("data", resultado);
			model.put("success", true);

		} catch (Exception e) {
			logger.error("Error en ActivoController", e);
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView propagarActivosMatriz(String idActivo, ModelMap model) {

		try {

			model.put(RESPONSE_DATA_KEY, activoApi.getActivosPropagables(Long.valueOf(idActivo)));

		} catch (JsonViewerException jvex) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, jvex.getMessage());
			logger.error(jvex.getMessage(),jvex);
			throw new JsonViewerException(jvex.getMessage());
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCalificacionNegativa(Long id, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY, activoApi.getActivoCalificacionNegativa(id));
			} catch (Exception e) {
				logger.error("error en activoController", e);
				model.put(RESPONSE_SUCCESS_KEY, false);
				model.put(RESPONSE_ERROR_KEY, e.getMessage());
			}
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCalificacionNegativaAdicional(Long id, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY, activoApi.getActivoCalificacionNegativaAdicional(id));
			} catch (Exception e) {
				logger.error("error en activoController", e);
				model.put(RESPONSE_SUCCESS_KEY, false);
				model.put(RESPONSE_ERROR_KEY, e.getMessage());
			}
		return createModelAndViewJson(model);
	}
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createCalificacionNegativaAdicional(@RequestParam Long idEntidadPk, DtoCalificacionNegativaAdicional dto, ModelMap model) {
		try {
			dto.setIdActivo(idEntidadPk);
			boolean success = activoApi.createCalificacionNegativaAdicional(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			logger.error("error en CalificacionNegativaAdicional", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateCalificacionNegativaAdicional(DtoCalificacionNegativaAdicional dto, ModelMap model) {
		try {
			boolean success = activoApi.updateCalificacionNegativaAdicional(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			logger.error("error en updateCalificacionNegativaAdicional", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView destroyCalificacionNegativaAdicional(DtoCalificacionNegativaAdicional dto, ModelMap model) {
		try {
			boolean success = activoApi.destroyCalificacionNegativaAdicional(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en destroyCalificacionNegativaAdicional", e);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getisActivoUa(String idActivo, ModelMap model){
		try{
			model.put(RESPONSE_DATA_KEY, activoDao.isUnidadAlquilable(Long.parseLong(idActivo)));
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public List<DtoActivoDatosRegistrales> getCalificacionNegativabyId(Long id) {
		return activoApi.getActivoCalificacionNegativaCodigos(id);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoTramitacionTitulo(Long id, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY, activoApi.getHistoricoTramitacionTitulo(id));
			} catch (Exception e) {
				logger.error("error en activoController", e);
				model.put(RESPONSE_SUCCESS_KEY, false);
				model.put(RESPONSE_ERROR_KEY, e.getMessage());
			}
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createHistoricoTramtitacionTitulo(DtoHistoricoTramitacionTitulo tramitacionDto, @RequestParam Long idActivo, ModelMap model) {
		try {
			boolean success = activoApi.createHistoricoTramtitacionTitulo(tramitacionDto, idActivo);
			model.put(RESPONSE_SUCCESS_KEY, success);

		}catch (HistoricoTramitacionException histError) {
			model.put(RESPONSE_SUCCESS_KEY, false); 
			model.put(RESPONSE_ERROR_MESSAGE_KEY, histError.getMessage());	
		}catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en activoController", e);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, false);
		}

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createHistoricoTramitacionTituloAdicional(DtoHistoricoTramitacionTituloAdicional tramitacionDto, @RequestParam Long idActivo, ModelMap model) {
		try {
			boolean success = activoApi.createHistoricoTramitacionTituloAdicional(tramitacionDto, idActivo);
			model.put(RESPONSE_SUCCESS_KEY, success);

		}catch (HistoricoTramitacionException histError) {
			model.put(RESPONSE_SUCCESS_KEY, false); 
			model.put(RESPONSE_ERROR_MESSAGE_KEY, histError.getMessage());	
		}catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en activoController", e);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, false);
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateHistoricoTramitacionTituloAdicional(DtoHistoricoTramitacionTituloAdicional tramitacionDto, ModelMap model) {
		try {
			boolean success = activoApi.updateHistoricoTramitacionTituloAdicional(tramitacionDto);
			model.put(RESPONSE_SUCCESS_KEY, success);
			
		}catch (HistoricoTramitacionException histError) {
			model.put(RESPONSE_SUCCESS_KEY, false); 
			model.put(RESPONSE_ERROR_MESSAGE_KEY, histError.getMessage());	

		} catch (Exception e) { 
			if(ActivoManager.ERROR_ANYADIR_PRESTACIONES_EN_REGISTRO.equalsIgnoreCase(e.getMessage())) {
				model.put(RESPONSE_ERROR_MESSAGE_KEY, ActivoManager.ERROR_ANYADIR_PRESTACIONES_EN_REGISTRO);
			}
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView destroyHistoricoTramitacionTituloAdicional(DtoHistoricoTramitacionTituloAdicional tramitacionDto, ModelMap model) {
		try {
			boolean success = activoApi.destroyHistoricoTramitacionTituloAdicional(tramitacionDto);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoTramitacionTituloAdicional(Long id, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY, activoApi.getHistoricoTramitacionTituloAdicional(id));
			} catch (Exception e) {
				logger.error("error en activoController", e);
				model.put(RESPONSE_SUCCESS_KEY, false);
				model.put(RESPONSE_ERROR_KEY, e.getMessage());
			}
		return createModelAndViewJson(model);
	}
	//
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateHistoricoTramtitacionTitulo(DtoHistoricoTramitacionTitulo tramitacionDto, ModelMap model) {
		try {
			boolean success = activoApi.updateHistoricoTramtitacionTitulo(tramitacionDto);
			model.put(RESPONSE_SUCCESS_KEY, success);
			
		}catch (HistoricoTramitacionException histError) {
			model.put(RESPONSE_SUCCESS_KEY, false); 
			model.put(RESPONSE_ERROR_MESSAGE_KEY, histError.getMessage());	

		} catch (Exception e) { 
			if(ActivoManager.ERROR_ANYADIR_PRESTACIONES_EN_REGISTRO.equalsIgnoreCase(e.getMessage())) {
				model.put(RESPONSE_ERROR_MESSAGE_KEY, ActivoManager.ERROR_ANYADIR_PRESTACIONES_EN_REGISTRO);
			}
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPerimetroAppleCesion(ModelMap model,String codigoServicer) {
		
		try {
			List <DDCesionSaneamiento> dto= activoApi.getPerimetroAppleCesion(codigoServicer);

			model.put("data", dto);
			model.put("success", true);

		} catch (Exception e) {
			logger.error("Error en ActivoController", e);
			model.put("success", false);
		}
		return createModelAndViewJson(model);

	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDatosPlusvalia(DtoActivoPlusvalia plusvaliaDto, @RequestParam Long id, ModelMap model, HttpServletRequest request) {
		try {
			
			boolean success = adapter.saveTabActivo(plusvaliaDto, id, TabActivoService.TAB_PLUSVALIA);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (JsonViewerException jvex) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, jvex.getMessage());
			throw new JsonViewerException(jvex.getMessage());

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "plusvalia", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView destroyHistoricoTramtitacionTitulo(DtoHistoricoTramitacionTitulo tramitacionDto,
			ModelMap model) {
		try {
			boolean success = activoApi.destroyHistoricoTramtitacionTitulo(tramitacionDto);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView insertarActAutoTram(DtoComercialActivo dto, ModelMap model, HttpServletRequest request) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, activoApi.insertarActAutoTram(dto));
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorCode", "msg.operacion.ko");
		}
		return new ModelAndView("jsonView", model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListPlusvalia(DtoPlusvaliaFilter dtoPlusvaliaFilter, ModelMap model) {
		try {
			DtoPage page = activoApi.getListPlusvalia(dtoPlusvaliaFilter);
			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("success", false);
			model.put("exception", e.getMessage());
		}
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboApiPrimario(ModelMap model) {			
		try{
			model.put(RESPONSE_DATA_KEY, activoApi.getComboApiPrimario());
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntosPlusvalia(Long id, ModelMap model, HttpServletRequest request) {
		try {
			model.put(RESPONSE_DATA_KEY, adapter.getAdjuntosActivoPlusvalia(id));

		} catch (GestorDocumentalException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", "Ha habido un problema con el gestor documental");
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "admisionDocumento", ACCION_CODIGO.CODIGO_MODIFICAR);
			logger.error("error en activoController (Gestor Documental)", e);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "admisionDocumento", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
    public ModelAndView deleteAdjuntoPlusvalia(DtoAdjunto dtoAdjunto) {
		
		boolean success= false;
		
		try {
			success = activoApi.deleteAdjuntoPlusvalia(dtoAdjunto);
		} catch(Exception ex) {
			logger.error(ex.getMessage());
		}
    	
    	return createModelAndViewJson(new ModelMap("success", success));

    }
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView uploadPlusvalia(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		try {
			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);

			String errores = activoApi.uploadDocumentoPlusvalia(fileItem, null, null);
			model.put("errores", errores);
			model.put(RESPONSE_SUCCESS_KEY, errores == null);

		} catch (GestorDocumentalException eGd) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", eGd.getMessage());
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
			logger.error("Error en uploadPlusvalia", e);
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoPlusvalia (HttpServletRequest request, HttpServletResponse response) {
        
		DtoAdjunto dtoAdjunto = new DtoAdjunto();
		
		dtoAdjunto.setId(Long.parseLong(request.getParameter("id")));
		dtoAdjunto.setIdEntidad(Long.parseLong(request.getParameter("idActivo")));
		String nombreDocumento = request.getParameter("nombreDocumento");
		dtoAdjunto.setNombre(nombreDocumento);
		
       	FileItem fileItem = activoApi.getFileItemPlusvalia(dtoAdjunto);
		
       	try { 

       		if(!Checks.esNulo(fileItem)) {
	       		ServletOutputStream salida = response.getOutputStream();

	       		response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
	       		response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
	       		response.setHeader("Cache-Control", "max-age=0");
	       		response.setHeader("Expires", "0");
	       		response.setHeader("Pragma", "public");
	       		response.setDateHeader("Expires", 0); //prevents caching at the proxy
	       		response.setContentType(fileItem.getContentType());

	       		// Write
	       		FileUtils.copy(fileItem.getInputStream(), salida);
	       		salida.flush();
	       		salida.close();
       		}
       		
       	} catch (Exception e) { 
       		logger.error(e.getMessage(),e);
       	}

	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDatosActivo(@RequestParam Long idActivo, ModelMap model) {

		try {
			model.put("data", activoApi.getDatosActivo(idActivo));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en activoController", e);
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoDiarioGestion(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, activoApi.getHistoricoDiarioGestion(id));

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboImpideVenta(String codEstadoCarga, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, adapter.getComboImpideVenta(codEstadoCarga));

		return new ModelAndView("jsonView", model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView clonateOferta(String idOferta, ModelMap model) {
		try {
			boolean success = !Checks.esNulo(adapter.clonateOfertaActivo(idOferta));
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			if (e.getMessage().equals(ActivoAdapter.OFERTA_INCOMPATIBLE_MSG)) {
				model.put(RESPONSE_MESSAGE_KEY, ActivoAdapter.OFERTA_INCOMPATIBLE_MSG);
				model.put(RESPONSE_SUCCESS_KEY, false);
			} else {
				logger.error("error en activoController", e);
				model.put(RESPONSE_SUCCESS_KEY, false);
			}
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFasePublicacionActivo(DtoFasePublicacionActivo dto, @RequestParam Long id, ModelMap model) {
		try {
			dto.setIdActivo(id);
			model.put(RESPONSE_DATA_KEY, activoEstadoPublicacionApi.saveFasePublicacionActivo(dto));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (JsonViewerException jvex) {
			model.put("success", false);
			model.put("msgError", jvex.getMessage());
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		} 
		
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getFasePublicacionActivo(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, activoEstadoPublicacionApi.getFasePublicacionActivo(id));
		model.put(RESPONSE_SUCCESS_KEY, true);

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoFasesDePublicacionActivo(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, activoEstadoPublicacionApi.getHistoricoFasesDePublicacionActivo(id));
		model.put(RESPONSE_SUCCESS_KEY, true);

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDiccionarioFasePublicacion(ModelMap model) {

		try {
			model.put("data", activoApi.getDiccionarioFasePublicacion());
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en activoController", e);
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoSolicitudesPrecios(ModelMap model, Long id) {
		
		try {
			model.put(RESPONSE_DATA_KEY, activoApi.getHistoricoSolicitudesPrecios(id));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("Error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createHistoricoSolicitudPrecios(HistoricoPropuestasPreciosDto historicoPropuestasPreciosDto,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.createHistoricoSolicitudPrecios(historicoPropuestasPreciosDto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateHistoricoSolicitudPrecios(HistoricoPropuestasPreciosDto historicoPropuestasPreciosDto,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.updateHistoricoSolicitudPrecios(historicoPropuestasPreciosDto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCalidadDatoPublicacionActivo(Long id, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, activoEstadoPublicacionApi.getCalidadDatoPublicacionActivo(id));
		model.put(RESPONSE_SUCCESS_KEY, true);
		
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getReqFaseVenta(ModelMap model, Long id) {
		
		try {
			model.put(RESPONSE_DATA_KEY, activoApi.getReqFaseVenta(id));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("Error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createReqFaseVenta(ReqFaseVentaDto reqFaseVentaDto,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.createReqFaseVenta(reqFaseVentaDto);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("Error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteReqFaseVenta(ReqFaseVentaDto reqFaseVentaDto,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.deleteReqFaseVenta(reqFaseVentaDto);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getSuministrosActivo(ModelMap model, Long id) {
		
		try {
			model.put(RESPONSE_DATA_KEY, activoApi.getSuministrosActivo(id));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("Error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
		
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView crearEstadoAdmision(String activoId, String codEstadoAdmision, String codSubestadoAdmision, String observaciones){
		
		return createModelAndViewJson(new ModelMap("data", activoApi.crearEstadoAdmision(activoId, codEstadoAdmision, codSubestadoAdmision, observaciones)));
		
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getSaneamientosAgendaByActivo(Long idActivo, ModelMap model) {
		try {
			List<SaneamientoAgendaDto> lista = activoApi.getSaneamientosAgendaByActivo(idActivo);
			model.put(RESPONSE_DATA_KEY, lista);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDatoRemCalidadDatoPublicacion(DtoDatosPublicacionDq dtoDq, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, activoEstadoPublicacionApi.saveDatoRemCalidadDatoPublicacion(dtoDq.getActivosSeleccionados(), dtoDq.getDqFase4Descripcion(), dtoDq.isSoyRestringidaQuieroActualizar()));
		} catch (JsonViewerException jvex) {
			model.put(RESPONSE_ERROR_MESSAGE_KEY, jvex.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
		} catch (Exception e) {
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error al guardar Dato dQ", e);
		} 
		
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createSuministroActivo(DtoActivoSuministros dtoActivoSuministros,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.createSuministroActivo(dtoActivoSuministros);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createSaneamientoAgenda(SaneamientoAgendaDto saneamientoAgendaDto,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.createSaneamientoAgenda(saneamientoAgendaDto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateSuministroActivo(DtoActivoSuministros dtoActivoSuministros,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.updateSuministroActivo(dtoActivoSuministros);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteSaneamientoAgenda(SaneamientoAgendaDto saneamientoAgendaDto,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.deleteSaneamientoAgenda(saneamientoAgendaDto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteSuministroActivo(DtoActivoSuministros dtoActivoSuministros,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.deleteSuministroActivo(dtoActivoSuministros);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateSaneamientoAgenda(SaneamientoAgendaDto saneamientoAgendaDto,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.updateSaneamientoAgenda(saneamientoAgendaDto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListComplementoTituloById(Long id,  ModelMap model) { 
		
		try {
			List<DtoActivoComplementoTitulo> listSuccess = activoApi.getListComplementoTituloById(id);
			model.put(RESPONSE_DATA_KEY, listSuccess);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
		}
		
		return createModelAndViewJson(model);
	}
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoSegmento(String codSubcartera, WebDto webDto, ModelMap model) {
		
		model.put(RESPONSE_DATA_KEY, activoApi.getComboTipoSegmento(codSubcartera));
		model.put("success", true);

		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoSegmentoActivo(ModelMap model, String codSubcartera) {
		
		try {
			model.put(RESPONSE_DATA_KEY, activoApi.getComboTipoSegmento(codSubcartera));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("Error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateActivoComplementoTitulo(DtoActivoComplementoTitulo cargaDto,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.updateActivoComplementoTitulo(cargaDto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteActivoComplementoTitulo(DtoActivoComplementoTitulo cargaDto,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.deleteActivoComplementoTitulo(cargaDto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createComplementoTitulo(String activoId, String codTitulo, String fechaSolicitud,
			String fechaTitulo, String fechaRecepcion, String fechaInscripcion, String observaciones, ModelMap model) {
		try {
			Boolean success = activoApi.createComplementoTitulo(activoId,  codTitulo,  fechaSolicitud,
					 fechaTitulo,  fechaRecepcion,  fechaInscripcion,  observaciones);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListGastosAsociadosAdquisicion(Long id,  ModelMap model) { 
		
		try {
			List<DtoGastoAsociadoAdquisicion> listSuccess = activoApi.getListGastosAsociadosAdquisicion(id);
			model.put(RESPONSE_DATA_KEY, listSuccess);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteGastoAsociadoAdquisicion(DtoGastoAsociadoAdquisicion cargaDto,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.deleteGastoAsociadoAdquisicion(cargaDto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateGastoAsociadoAdquisicion(DtoGastoAsociadoAdquisicion cargaDto,  ModelMap model) { 
		
		try {
			Boolean success = activoApi.updateGastoAsociadoAdquisicion(cargaDto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}

			return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView uploadFacturaGastoAsociado(HttpServletRequest request) {
		ModelMap model = new ModelMap();

		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			adapter.uploadFactura(webFileItem);
			model.put(RESPONSE_SUCCESS_KEY, true);			
		} catch (GestorDocumentalException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", "Ha habido un problema con la subida del fichero al gestor documental.");

		} catch (Exception e) {
			logger.error("error en activoController.uloadFacturaGastoAsociado", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", "Ha habido un problema con la subida del fichero.");
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteFacturaGastoAsociado(Long idFactura, ModelMap model) { 
		
		try {
			Boolean success = adapter.deleteFacturaGastoAsociado(idFactura);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController.deleteFacturaGastoAsociado", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void descargarFacturaGastoAsociado(HttpServletRequest request, HttpServletResponse response) {
		ServletOutputStream salida = null;
		
		try {
			Long id = Long.parseLong(request.getParameter("id"));
			String nombreDocumento = request.getParameter("nombreDocumento");
			salida = response.getOutputStream();
			FileItem fileItem = adapter.downloadFactura(id, nombreDocumento);
			response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
			response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
			response.setHeader("Cache-Control", "max-age=0");
			response.setHeader("Expires", "0");
			response.setHeader("Pragma", "public");
			response.setDateHeader("Expires", 0); // prevents caching at the proxy
			if(!Checks.esNulo(fileItem.getContentType())) {
				response.setContentType(fileItem.getContentType());
			}

			// Write
			FileUtils.copy(fileItem.getInputStream(), salida);

		} catch(UserException ex) {
			try {
				salida.write(ex.toString().getBytes(Charset.forName("UTF-8")));
			} catch (IOException e) {
				logger.error("error en activoController", e);
			}
	
		}
		catch (SocketException e) {
			logger.warn("error en activoController", e);
		}catch (Exception e) {
			logger.error("error en activoController", e);
		}finally {
			try {
				salida.flush();			
				salida.close();
			} catch (IOException e) {
				logger.error("error en activoController", e);
			}
		}		
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView destroyDeudorById(DtoActivoDeudoresAcreditados dto, ModelMap model) {
		try {
			boolean success = activoApi.destroyDeudorById(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en destroyDeudorById", e);
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateDeudorAcreditado(DtoActivoDeudoresAcreditados dto, ModelMap model) {
		try {
			boolean success = activoApi.updateDeudorAcreditado(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en updateDeudorAcreditado", e);
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createGastoAsociadoAdquisicion(String activoId, String gastoAsociado, String fechaSolicitudGastoAsociado,
			String fechaPagoGastoAsociado, String importe, String observaciones, ModelMap model) {
		try {
			Boolean success = activoApi.createGastoAsociadoAdquisicion(activoId,  gastoAsociado,  fechaSolicitudGastoAsociado,
					fechaPagoGastoAsociado,  importe,  observaciones);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createDeudorAcreditado(Long idEntidad, String docIdentificativo,
			String nombre, String apellido1, String apellido2, String tipoDocIdentificativoDesc, ModelMap model) {
		try {
			Boolean success = activoApi.createDeudorAcreditado(idEntidad,  docIdentificativo,  nombre,
					apellido1,  apellido2,  tipoDocIdentificativoDesc);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en createDeudorAcreditado", e);
		}

		return createModelAndViewJson(model);
	}
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCalidadDelDatoFiltered(String id, ModelMap model) {
		if (id != null) {
			Long activoId = Long.parseLong(id);
			try {
				model.put(RESPONSE_DATA_KEY, activoEstadoPublicacionApi.getCalidadDatoPublicacionActivoGrid(activoId));
				model.put(RESPONSE_SUCCESS_KEY, true);
			} catch (Exception e) {
				logger.error("error en activoController", e);
				model.put(RESPONSE_SUCCESS_KEY, false);
			}
		}		
		return createModelAndViewJson(model);	
	}		
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getCheckGestionActivo(Long idActivo, ModelMap model){
		try{
			model.put(RESPONSE_DATA_KEY, activoDao.activocheckGestion(idActivo)); 
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());

		}

		return createModelAndViewJson(model);
	}


	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListHistoricoOcupadoTitulo(Long id, ModelMap model){
		try{

			model.put(RESPONSE_DATA_KEY, activoApi.getListHistoricoOcupadoTitulo(id)); 
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());

		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPreciosVigentesCaixaById(Long id, WebDto webDto, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_DATA_KEY, adapter.getPreciosVigentesCaixaById(id));
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_ACTIVO, "precios", ACCION_CODIGO.CODIGO_VER);

		return new ModelAndView("jsonView", model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView findTasaciones(DtoFiltroTasaciones dto, ModelMap model) {
		try {
			Page page = activoApi.findTasaciones(dto);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			model.put("error", e.getMessage());
			model.put("success", false);
		}

		return new ModelAndView("jsonView", model);
	}
}

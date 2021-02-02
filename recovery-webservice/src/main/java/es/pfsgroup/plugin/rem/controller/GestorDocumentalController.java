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

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
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
import es.pfsgroup.plugin.rem.adapter.TrabajoAdapter;
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
import es.pfsgroup.plugin.rem.model.DtoDistribucion;
import es.pfsgroup.plugin.rem.model.DtoFasePublicacionActivo;
import es.pfsgroup.plugin.rem.model.DtoFichaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoFoto;
import es.pfsgroup.plugin.rem.model.DtoGastoAsociadoAdquisicion;
import es.pfsgroup.plugin.rem.model.DtoGenerarDocGDPR;
import es.pfsgroup.plugin.rem.model.DtoHistoricoDestinoComercial;
import es.pfsgroup.plugin.rem.model.DtoHistoricoMediador;
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
import es.pfsgroup.plugin.rem.model.DtoReglasPublicacionAutomatica;
import es.pfsgroup.plugin.rem.model.DtoSubirDocumento;
import es.pfsgroup.plugin.rem.model.DtoTasacion;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VActivosAgrupacionLil;
import es.pfsgroup.plugin.rem.model.VBusquedaProveedoresActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaPublicacionActivo;
import es.pfsgroup.plugin.rem.model.VGridBusquedaActivos;
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
public class GestorDocumentalController extends ParadiseJsonController {

	protected static final Log logger = LogFactory.getLog(GestorDocumentalController.class);
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
	private TrabajoApi trabajoApi;


	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(HttpServletRequest request, DtoSubirDocumento dto) {
		ModelMap model = new ModelMap();
		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			//redireccion de si viene de trabajo o activo
			if(webFileItem.getParameter("entidad") != null) {
				if(webFileItem.getParameter("entidad").equalsIgnoreCase("activo")) {
					adapter.upload(webFileItem);
				}else{
					trabajoApi.upload(webFileItem);
				}
			}
			if(webFileItem.getParameter("entidad") != null && webFileItem.getParameter("idEntidad") != null && dto != null) {
				guardarFormularioSubidaDocumento(webFileItem.getParameter("idEntidad") , webFileItem.getParameter("entidad"), dto);
			}
			
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
	
	@RequestMapping(method = RequestMethod.POST)
	public void guardarFormularioSubidaDocumento(String idEntidad , String entidad, DtoSubirDocumento dto) {
		
		
	}
}

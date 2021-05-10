package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.util.JDBCExceptionReporter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.config.ConfigManager;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.configuracion.api.ConfiguracionApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.MantenimientoExcelReport;
import es.pfsgroup.plugin.rem.excel.TrabajosGastoExcelReport;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ACCION_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ENTIDAD_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.REQUEST_STATUS_CODE;
import es.pfsgroup.plugin.rem.model.ConfiguracionReam;
import es.pfsgroup.plugin.rem.model.DtoActivoCatastro;
import es.pfsgroup.plugin.rem.model.DtoMantenimientoFilter;
import es.pfsgroup.plugin.rem.model.DtoMediadorEvaluaFilter;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoTrabajos;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;

@Controller
public class ConfiguracionController extends ParadiseJsonController {
	
	protected static final Log logger = LogFactory.getLog(ConfiguracionController.class);

	private static final String RESPONSE_SUCCESS_KEY = "success";

	private static final String RESPONSE_DATA_KEY = "data";
	
	private static final String ERROR_REGISTROS_DUPLICADOS= "msg.error.configuracion.mantenimiento.error.duplicados";

	@Autowired
	private ConfiguracionApi configuracionApi;

	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private LogTrustEvento trustMe;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ConfigManager configManager;
	
	@Resource
	private MessageService messageServices;
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getListMantenimiento(DtoMantenimientoFilter dtoMantenimientoFilter, WebDto webDto, ModelMap model) {
		try {			
			model.put("data", configuracionApi.getListMantenimiento(dtoMantenimientoFilter));
		} catch (Exception e) {
			logger.error("Error en ConfiguracionController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPropietariosByCartera(String codCartera){
		if (codCartera != null) {
			return createModelAndViewJson(new ModelMap("data", configuracionApi.getPropietariosByCartera(codCartera)));
		}else {
			return null;
		}		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getSubcarteraFilterByCartera(String codCartera){
		if (codCartera != null) {
			return createModelAndViewJson(new ModelMap("data", configuracionApi.getSubcarteraFilterByCartera(codCartera)));
		}else {
			return null;
		}
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelMantenimientoReport(DtoMantenimientoFilter dtoMantenimientoFilter,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws IOException {
			
		List<DtoMantenimientoFilter> listExcel = configuracionApi.getListMantenimiento(dtoMantenimientoFilter);
		ExcelReport report = new MantenimientoExcelReport(listExcel);			
		excelReportGeneratorApi.generateAndSend(report, response);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteMantenimiento(Long idMantenimiento, ModelMap model) { 
		
		try {
			Boolean success = configuracionApi.deleteMantenimiento(idMantenimiento);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("error en configuracionController.deleteMantenimiento", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createMantenimiento(DtoMantenimientoFilter dtoMantenimientoFilter, ModelMap model) {
				
		try {
			Boolean success = configuracionApi.createMantenimiento(dtoMantenimientoFilter);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (DataIntegrityViolationException e) {
			logger.error("error en configuracionController.createMantenimiento", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("msgError", messageServices.getMessage(ERROR_REGISTROS_DUPLICADOS));
			throw new JsonViewerException(messageServices.getMessage(ERROR_REGISTROS_DUPLICADOS));
		} catch (Exception e) {
			logger.error("error en configuracionController.createMantenimiento", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("msgError", e.getMessage());
		}
		return createModelAndViewJson(model);
	}
	
}

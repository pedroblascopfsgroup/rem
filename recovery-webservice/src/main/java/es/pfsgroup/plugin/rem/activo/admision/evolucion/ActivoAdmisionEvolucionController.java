package es.pfsgroup.plugin.rem.activo.admision.evolucion;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.plugin.rem.activo.admision.evolucion.api.ActivoAdmisionEvolucionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.excel.ActivoAdmisionEvolucionExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoActivoAdmisionEvolucion;
import es.pfsgroup.plugin.rem.utils.EmptyParamDetector;

@Controller
public class ActivoAdmisionEvolucionController extends ParadiseJsonController {

	private final Log logger = LogFactory.getLog(getClass());
	
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";
	private static final String RESPONSE_TOTALCOUNT_KEY = "totalCount";
	
	@Autowired
	private ActivoAdmisionEvolucionApi activoAdmisionEvolucionApi;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	/**
	 * Método que recupera una lista de hacia el grid Evolucion
	 * 
	 * 
	 * @return List
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivoAgendaEvolucion(Long id, ModelMap model){

		model.put(RESPONSE_DATA_KEY,activoAdmisionEvolucionApi.getListActivoAgendaEvolucion(id));
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public void generateExcel(Long id, HttpServletRequest request, HttpServletResponse response) throws Exception {		
		Usuario usuario = usuarioManager.getUsuarioLogado();
		List<DtoActivoAdmisionEvolucion> listaActivoAdmisionEvolucion = activoAdmisionEvolucionApi.getListActivoAgendaEvolucion(id);
		new EmptyParamDetector().isEmpty(listaActivoAdmisionEvolucion.size(), "activoadmisionevolucion", usuario.getUsername());
		Activo activo = activoApi.get(id);
		ExcelReport report = new ActivoAdmisionEvolucionExcelReport(activo.getNumActivo().toString(), listaActivoAdmisionEvolucion);
		excelReportGeneratorApi.generateAndSend(report, response);	
	}

}

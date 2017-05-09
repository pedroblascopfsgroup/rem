package es.pfsgroup.plugin.rem.controller;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.ProvisionGastosApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.ProvisionGastosExcelReport;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastos;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastosFilter;


@Controller
public class ProvisionGastosController extends ParadiseJsonController {

	
	@Autowired
	private ProvisionGastosApi provisionGastosApi;
	
	protected static final Log logger = LogFactory.getLog(ProvisionGastosController.class);

	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;
	

	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findAll(DtoProvisionGastosFilter dto, ModelMap model){	
		
		try {

			DtoPage page = provisionGastosApi.findAll(dto);
			
			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error("Error al consultar las agrupaciones de gastos.", e);
			model.put("success", false);
			model.put("exception", e.getMessage());
		}
		
		return createModelAndViewJson(model);

	}



		
		

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelProvisionGastos(DtoProvisionGastosFilter dtoProvisionGastos, HttpServletRequest request, HttpServletResponse response) throws Exception {
		dtoProvisionGastos.setStart(excelReportGeneratorApi.getStart());
		dtoProvisionGastos.setLimit(excelReportGeneratorApi.getLimit());

		DtoPage page = provisionGastosApi.findAll(dtoProvisionGastos);
		List<DtoProvisionGastos> listaProvisionGastos = (List<DtoProvisionGastos>) page.getResults();

		ExcelReport report = new ProvisionGastosExcelReport(listaProvisionGastos);

		excelReportGeneratorApi.generateAndSend(report, response);
	}

}

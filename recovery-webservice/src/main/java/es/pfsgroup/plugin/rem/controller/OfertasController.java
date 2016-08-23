package es.pfsgroup.plugin.rem.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ComercialApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.OfertasExcelReport;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;

@Controller
public class OfertasController {

	@Autowired 
    private ActivoApi activoApi;
	
	@Autowired
	private ComercialApi comercialApi;
	
	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListOfertas(DtoOfertasFilter dtoOfertasFilter, ModelMap model) {
		try {

			//Page page = comercialApi.getListVisitas(dtoVisitasFilter);
			DtoPage page = comercialApi.getListOfertas(dtoOfertasFilter);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcel(DtoOfertasFilter dtoOfertasFilter, HttpServletRequest request, HttpServletResponse response) throws Exception {

		dtoOfertasFilter.setStart(excelReportGeneratorApi.getStart());
		dtoOfertasFilter.setLimit(excelReportGeneratorApi.getLimit());
		
		
		List<VOfertasActivosAgrupacion> listaOfertas = (List<VOfertasActivosAgrupacion>) comercialApi.getListOfertas(dtoOfertasFilter).getResults();
		
		ExcelReport report = new OfertasExcelReport(listaOfertas);
		
		excelReportGeneratorApi.generateAndSend(report, response);

	}
	
	private ModelAndView createModelAndViewJson(ModelMap model) {

		return new ModelAndView("jsonView", model);
	}
	
	

}

package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ComercialApi;
import es.pfsgroup.plugin.rem.api.VisitaApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.VisitasExcelReport;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.VisitaDto;
import es.pfsgroup.plugin.rem.rest.dto.VisitaRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class VisitasController {

	
	@Autowired 
    private ActivoApi activoApi;
	
	@Autowired
	private ComercialApi comercialApi;
	
	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;
	
	@Autowired
	private RestApi restApi;

	@Autowired 
    private VisitaApi visitaApi;
	
	
	
	/**
	 * Inserta o actualiza una lista de Visitas Ejem: IP:8080/pfs/rest/clientes
	 * HEADERS:
	 * Content-Type - application/json
	 * signature - sdgsdgsdgsdg
	 * 
	 * BODY:
	 * {"id":"111111112112","data": [{"idVisitaWebcom": "1", "idClienteRem": "2", "idActivoHaya": "0", "codEstadoVisita": "05","codDetalleEstadoVisita": "07", "fechaVisita": "448070400", "fecha": "448070400", "idUsuarioRem": "1", "idPrescriptor": "5045", "visitaPrescriptor": false, "idApiResponsable": "1010", "visitaApiResponsable": false, "idApiCustodio": "1008", "visitaApiCustodio": false, "observaciones": "Observaciones" }]}
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/visitas")
	public ModelAndView saveOrUpdateVisita(ModelMap model, RestRequestWrapper request) {
		VisitaRequestDto jsonData = null;
		List<String> errorsList = null;
		Visita visita = null;
		
		VisitaDto visitaDto = null;
		Map<String, Object> map = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		ArrayList<Map<String, Object>> requestMapList = null;
		
		try {

			jsonData = (VisitaRequestDto) request.getRequestData(VisitaRequestDto.class);
			List<VisitaDto> listaVisitaDto = jsonData.getData();			
			requestMapList = request.getRequestMapList();
			if(Checks.esNulo(requestMapList) && requestMapList.isEmpty()){
				throw new Exception("No se han podido recuperar los datos de la petición. Peticion mal estructurada.");
				
			}else{
				
				for(int i=0; i < listaVisitaDto.size();i++){
					
					Visita vis = null;
					errorsList = new ArrayList<String>();
					map = new HashMap<String, Object>();
					visitaDto = listaVisitaDto.get(i);
					
					visita = visitaApi.getVisitaByIdVisitaWebcom(visitaDto.getIdVisitaWebcom());		
					if(Checks.esNulo(visita)){
						errorsList = visitaApi.saveVisita(visitaDto);
						
					}else{
						errorsList = visitaApi.updateVisita(visita, visitaDto, requestMapList.get(i));
						
					}
														
					if(!Checks.esNulo(errorsList) && errorsList.isEmpty()){
						vis = visitaApi.getVisitaByIdVisitaWebcom(visitaDto.getIdVisitaWebcom());	
						map.put("idVisitaWebcom", vis.getIdVisitaWebcom());
						map.put("idVisitaRem", vis.getNumVisitaRem());
						map.put("success", true);
					}else{
						map.put("idVisitaWebcom", visitaDto.getIdVisitaWebcom());
						map.put("idVisitaRem", visitaDto.getIdClienteRem());
						map.put("success", false);
						map.put("errorMessages", errorsList);
					}					
					listaRespuesta.add(map);	
					
				}
			
				model.put("id", jsonData.getId());	
				model.put("data", listaRespuesta);
				model.put("error", "");
				
			}

		} catch (Exception e) {
			e.printStackTrace();
			model.put("id", jsonData.getId());	
			model.put("data", listaRespuesta);
			model.put("error", e.getMessage().toUpperCase());
		}

		return new ModelAndView("jsonView", model);
	}
	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListVisitas(DtoVisitasFilter dtoVisitasFilter, ModelMap model) {
		try {

			//Page page = comercialApi.getListVisitas(dtoVisitasFilter);
			DtoPage page = comercialApi.getListVisitas(dtoVisitasFilter);

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
	public void generateExcel(DtoVisitasFilter dtoVisitasFilter, HttpServletRequest request, HttpServletResponse response) throws Exception {

		dtoVisitasFilter.setStart(excelReportGeneratorApi.getStart());
		dtoVisitasFilter.setLimit(excelReportGeneratorApi.getLimit());
		
		
		List<DtoVisitasFilter> listaVisitas = (List<DtoVisitasFilter>) comercialApi.getListVisitas(dtoVisitasFilter).getResults();
		
		ExcelReport report = new VisitasExcelReport(listaVisitas);
		
		excelReportGeneratorApi.generateAndSend(report, response);

	}
	
	private ModelAndView createModelAndViewJson(ModelMap model) {

		return new ModelAndView("jsonView", model);
	}
	
	


}

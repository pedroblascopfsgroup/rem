package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.OfertasExcelReport;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class OfertasController {

	@Autowired 
    private ActivoApi activoApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	@Autowired
	private RestApi restApi;
	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListOfertas(DtoOfertasFilter dtoOfertasFilter, ModelMap model) {
		try {

			if (dtoOfertasFilter.getSort() == null){
				
				dtoOfertasFilter.setSort("fechaCreacion");

			}
			//Page page = ofertaApi.getListOfertas(dtoOfertasFilter);
			DtoPage page = ofertaApi.getListOfertas(dtoOfertasFilter);

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
		
		
		List<VOfertasActivosAgrupacion> listaOfertas = (List<VOfertasActivosAgrupacion>) ofertaApi.getListOfertas(dtoOfertasFilter).getResults();
		
		ExcelReport report = new OfertasExcelReport(listaOfertas);
		
		excelReportGeneratorApi.generateAndSend(report, response);

	}
	
	private ModelAndView createModelAndViewJson(ModelMap model) {

		return new ModelAndView("jsonView", model);
	}
	
	
	

	/**
	 * Inserta o actualiza una lista de Ofertas Ejem: IP:8080/pfs/rest/ofertas
	 * HEADERS:
	 * Content-Type - application/json
	 * signature - sdgsdgsdgsdg
	 * 
	 * BODY:
	 * {"id":"111111114111","data": [{"idOfertaWebcom": "1000", "idVisitaRem": "1", "idClienteRem": "1000", "idActivoHaya": "1000", "codEstadoOferta": "1000","codTipoOferta": "1000", "fechaAccion": "2016-01-01T10:10:10", "idUsuarioRem": "1000", "importeContraoferta": null, "idProveedorRemPrescriptor": "1000", "idProveedorRemCustodio": "1000", "idProveedorRemResponsable": "1000", "idProveedorRemFdv": "1000" , "importe": "1000.2", "titularesAdicionales": [{"nombre": "Nombre1", "codTipoDocumento": "1000", "documento":"48594626F"}, {"nombre": "Nombre2", "codTipoDocumento": "1001", "documento":"48594628F"}]}]}
	 * @param model
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/ofertas")
	public ModelAndView saveOrUpdateOferta(ModelMap model, RestRequestWrapper request) {
		OfertaRequestDto jsonData = null;
		List<String> errorsList = null;
		Oferta oferta = null;
		
		OfertaDto ofertaDto = null;
		Map<String, Object> map = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		JSONObject jsonFields = null;
		
		try {

			jsonData = (OfertaRequestDto) request.getRequestData(OfertaRequestDto.class);
			List<OfertaDto> listaOfertaDto = jsonData.getData();				
			jsonFields = request.getJsonObject();

			
			if(Checks.esNulo(jsonFields) && jsonFields.isEmpty()){
				throw new Exception("No se han podido recuperar los datos de la petición. Peticion mal estructurada.");
				
			}else{
				
				for(int i=0; i < listaOfertaDto.size();i++){
					
					Oferta ofr = null;
					errorsList = new ArrayList<String>();
					map = new HashMap<String, Object>();
					ofertaDto = listaOfertaDto.get(i);
					
					oferta = ofertaApi.getOfertaByIdOfertaWebcom(ofertaDto.getIdOfertaWebcom());		
					if(Checks.esNulo(oferta)){
						errorsList = ofertaApi.saveOferta(ofertaDto);
						
					}else{
						errorsList = ofertaApi.updateOferta(oferta, ofertaDto, jsonFields.getJSONArray("data").get(i));
						
					}
														
					if(!Checks.esNulo(errorsList) && errorsList.isEmpty()){
						ofr = ofertaApi.getOfertaByIdOfertaWebcom(ofertaDto.getIdOfertaWebcom());	
						map.put("idOfertaWebcom", ofr.getIdWebCom());
						map.put("idOfertaRem", ofr.getNumOferta());
						map.put("success", true);
					}else{
						map.put("idOfertaWebcom", ofertaDto.getIdOfertaWebcom());
						map.put("idOfertaRem", ofertaDto.getIdOfertaRem());
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
	

}

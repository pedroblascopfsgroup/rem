package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.VisitaApi;
import es.pfsgroup.plugin.rem.api.VisitaGencatApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.VisitasExcelReport;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.VisitaDto;
import es.pfsgroup.plugin.rem.rest.dto.VisitaRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import net.sf.json.JSONObject;

@Controller
public class VisitasController {

	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	@Autowired
	private RestApi restApi;

	@Autowired
	private VisitaApi visitaApi;
	
	@Autowired
	private VisitaGencatApi visitaGencatApi;

	private final Log logger = LogFactory.getLog(getClass());

	/**
	 * Inserta o actualiza una lista de Visitas Ejem: IP:8080/pfs/rest/clientes
	 * HEADERS: Content-Type - application/json signature - sdgsdgsdgsdg
	 * 
	 * BODY: {"id":"111111112112","data": [{"idVisitaWebcom": "1",
	 * "idClienteRem": "2", "idActivoHaya": "0", "codEstadoVisita":
	 * "05","codDetalleEstadoVisita": "07", "fechaAccion":
	 * "2016-01-01T10:10:10", "idUsuarioRemAccion": "1",
	 * "idProveedorRemPrescriptor": "5045", "idProveedorRemCustodio": "1010",
	 * "idProveedorRemResponsable": "1010", "idProveedorRemFdv": "1010" ,
	 * "idProveedorRemVisita": "1010", "observaciones": "Observaciones" }]}
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/visitas")
	public void saveOrUpdateVisita(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		VisitaRequestDto jsonData = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		JSONObject jsonFields = null;

		try {

			jsonFields = request.getJsonObject();
			jsonData = (VisitaRequestDto) request.getRequestData(VisitaRequestDto.class);
			List<VisitaDto> listaVisitaDto = jsonData.getData();


			if (Checks.esNulo(jsonFields) && jsonFields.isEmpty()) {
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);

			} else {
				listaRespuesta = visitaApi.saveOrUpdateVisitas(listaVisitaDto, jsonFields);
				model.put("id", jsonFields.get("id"));
				model.put("data", listaRespuesta);
				model.put("error", "null");

			}

		} catch (Exception e) {
			logger.error("Error visitas", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", jsonFields.get("id"));
			model.put("data", listaRespuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
		}

		restApi.sendResponse(response, model,request);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListVisitas(DtoVisitasFilter dtoVisitasFilter, ModelMap model) {
		try {

			if (dtoVisitasFilter.getSort() == null) {

				dtoVisitasFilter.setSort("activo.numActivo, fechaSolicitud");

			}
			// Page page = comercialApi.getListVisitas(dtoVisitasFilter);
			DtoPage page = visitaApi.getListVisitas(dtoVisitasFilter);

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
	public ModelAndView getListVisitasDetalle(DtoVisitasFilter dtoVisitasFilter, ModelMap model) {
		try {

			// if (dtoVisitasFilter.getSort() == null){
			//
			// dtoVisitasFilter.setSort("activo.numActivo, fechaSolicitud");
			//
			// }
			// Page page = comercialApi.getListVisitas(dtoVisitasFilter);
			DtoPage page = visitaApi.getListVisitasDetalle(dtoVisitasFilter);
			
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
	public void generateExcel(DtoVisitasFilter dtoVisitasFilter, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		dtoVisitasFilter.setStart(excelReportGeneratorApi.getStart());
		dtoVisitasFilter.setLimit(excelReportGeneratorApi.getLimit());

		if (dtoVisitasFilter.getSort() == null) {
			dtoVisitasFilter.setSort("activo.numActivo, fechaSolicitud");
		}

		List<DtoVisitasFilter> listaVisitas = (List<DtoVisitasFilter>) visitaApi.getListVisitas(dtoVisitasFilter)
				.getResults();

		ExcelReport report = new VisitasExcelReport(listaVisitas);

		excelReportGeneratorApi.generateAndSend(report, response);

	}

	private ModelAndView createModelAndViewJson(ModelMap model) {

		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getVisitaDetalleById(DtoVisitasFilter dtoVisitasFilter, ModelMap model) {

		try {
			model.put("data", visitaApi.getVisitaDetalle(dtoVisitasFilter));
			model.put("success", true);
		} catch(Exception e) {
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getVisitaByIdComunicacionGencat(Long idComunicacionnGencat,ModelMap model){
		try {
			model.put("data", visitaGencatApi.getVisitaByIdComunicacionGencat(idComunicacionnGencat));
			model.put("success", true);
		} catch (Exception e) {
			model.put("success", false);
			model.put("error", e.getMessage());
		}
		return createModelAndViewJson(model);
	}
}

package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

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
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.OfertasExcelReport;
import es.pfsgroup.plugin.rem.model.DtoDetalleOferta;
import es.pfsgroup.plugin.rem.model.DtoHonorariosOferta;
import es.pfsgroup.plugin.rem.model.DtoOfertantesOferta;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class OfertasController {

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	@Autowired
	private RestApi restApi;

	private final Log logger = LogFactory.getLog(getClass());

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListOfertas(DtoOfertasFilter dtoOfertasFilter, ModelMap model) {
		try {

			if (dtoOfertasFilter.getSort() == null) {

				dtoOfertasFilter.setSort("fechaCreacion");

			}
			// Page page = ofertaApi.getListOfertas(dtoOfertasFilter);
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
	public void generateExcel(DtoOfertasFilter dtoOfertasFilter, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		dtoOfertasFilter.setStart(excelReportGeneratorApi.getStart());
		dtoOfertasFilter.setLimit(excelReportGeneratorApi.getLimit());

		List<VOfertasActivosAgrupacion> listaOfertas = (List<VOfertasActivosAgrupacion>) ofertaApi
				.getListOfertas(dtoOfertasFilter).getResults();

		ExcelReport report = new OfertasExcelReport(listaOfertas);

		excelReportGeneratorApi.generateAndSend(report, response);

	}

	private ModelAndView createModelAndViewJson(ModelMap model) {

		return new ModelAndView("jsonView", model);
	}

	/**
	 * Inserta o actualiza una lista de Ofertas Ejem: IP:8080/pfs/rest/ofertas
	 * HEADERS: Content-Type - application/json signature - sdgsdgsdgsdg
	 * 
	 * BODY: {"id":"111111114111","data": [{"idOfertaWebcom": "1000",
	 * "idVisitaRem": "1", "idClienteRem": "1", "idActivoHaya": "6346320",
	 * "codEstadoOferta": "04","codTipoOferta": "01", "fechaAccion":
	 * "2016-01-01T10:10:10", "idUsuarioRemAccion": "29468",
	 * "importeContraoferta": null, "idProveedorRemPrescriptor": "1000",
	 * "idProveedorRemCustodio": "1000", "idProveedorRemResponsable": "1000",
	 * "idProveedorRemFdv": "1000" , "importe": "1000.2",
	 * "titularesAdicionales": [{"nombre": "Nombre1", "codTipoDocumento": "15",
	 * "documento":"48594626F"}, {"nombre": "Nombre2", "codTipoDocumento": "15",
	 * "documento":"48594628F"}]}]}
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/ofertas")
	public void saveOrUpdateOferta(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		OfertaRequestDto jsonData = null;
		ArrayList<Map<String, Object>> listaRespuesta = null;
		JSONObject jsonFields = null;

		try {

			jsonFields = request.getJsonObject();
			jsonData = (OfertaRequestDto) request.getRequestData(OfertaRequestDto.class);
			List<OfertaDto> listaOfertaDto = jsonData.getData();

			if (Checks.esNulo(jsonFields) && jsonFields.isEmpty()) {
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);

			} else {

				listaRespuesta = ofertaApi.saveOrUpdateOfertas(listaOfertaDto, jsonFields);
				model.put("id", jsonFields.get("id"));
				model.put("data", listaRespuesta);
				model.put("error", "null");

			}

		} catch (Exception e) {
			logger.error("Error ofertas", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", jsonFields.get("id"));
			model.put("data", listaRespuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
		}

		restApi.sendResponse(response, model,request);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDetalleOfertaById(DtoDetalleOferta dto, ModelMap model) {

		try {
			model.put("data", ofertaApi.getDetalleOfertaById(dto));
			model.put("success", true);			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getOfertantesByOfertaId(DtoOfertantesOferta dtoOfertantesOferta, ModelMap model) {

		try {
			model.put("data", ofertaApi.getOfertantesByOfertaId(dtoOfertantesOferta));
			model.put("success", true);			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHonorariosByOfertaId(DtoHonorariosOferta dtoHonorariosOferta, ModelMap model) {

		try {
			model.put("data", ofertaApi.getHonorariosByOfertaId(dtoHonorariosOferta));
			model.put("success", true);			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}

		return createModelAndViewJson(model);
	}
}
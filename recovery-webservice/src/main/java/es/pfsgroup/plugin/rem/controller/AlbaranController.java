package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
import java.text.ParseException;
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

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.plugin.rem.albaran.dto.DtoAlbaranFiltro;
import es.pfsgroup.plugin.rem.api.AlbaranApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.TrabajosPrefacturaExcelReport;
import es.pfsgroup.plugin.rem.model.DtoDetalleAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetallePrefactura;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.VExportTrabajosAlbaranes;
import es.pfsgroup.plugin.rem.model.dd.DDEstEstadoPrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAlbaran;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Controller
public class AlbaranController extends ParadiseJsonController{

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private AlbaranApi albaranApi;
	
	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView findAll(DtoAlbaranFiltro dtoAlbaran, ModelMap model){
		try {
			Page page = albaranApi.findAll(dtoAlbaran);
			
			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			model.put("error", e.getMessage());
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getProveedores(DtoProveedorFilter filtro, ModelMap model) {			
		try{
			model.put("data", albaranApi.getProveedores());
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("error", e.getMessage());
		}
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
//	@RequestMapping(method = RequestMethod.GET)
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView findAllDetalles(DtoDetalleAlbaran detalleAlbaran, ModelMap model) {
		if( detalleAlbaran != null && detalleAlbaran.getNumAlbaran() != null) {
			try {
				Page page = albaranApi.findAllDetalle(detalleAlbaran);
				
				model.put("data", page.getResults());
				model.put("totalCount", page.getTotalCount());
			}catch(Exception e) {
				logger.error(e.getMessage(), e);
				model.put("error", e.getMessage());
				model.put("success", false);
			}
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
//	@RequestMapping(method = RequestMethod.GET)
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView findPrefectura(DtoDetallePrefactura detallePrefectura, ModelMap model) {
		if(detallePrefectura != null && detallePrefectura.getNumPrefactura() != null) {
			try {
				Page page = albaranApi.findPrefectura(detallePrefectura);
				
				model.put("data", page.getResults());
				model.put("totalCount", page.getTotalCount());
			}catch(Exception e) {
				logger.error(e.getMessage(), e);
				model.put("error", e.getMessage());
				model.put("success", false);
			}
		}
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView comprobarValidarAlbaran(Long id, ModelMap model) {
		Boolean comprobar = false;
		try {
			comprobar = albaranApi.validarAlbaran(id);
			model.put("success", comprobar);
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			model.put("error", e.getMessage());
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView comprobarValidarPrefactura(Long id, String lista, ModelMap model) {
		Boolean comprobar = false;
		try {
			comprobar = albaranApi.validarPrefactura(id,lista);
			model.put("success", comprobar);
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			model.put("error", e.getMessage());
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboEstadoAlbaran(ModelMap model) {

		try {
			List<DDEstadoAlbaran> list = albaranApi.getComboEstadoAlbaran();
			model.put("data", list);
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboEstadoPrefactura(ModelMap model) {

		try {
			List<DDEstEstadoPrefactura> list = albaranApi.getComboEstadoPrefactura();
			model.put("data", list);
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboEstadoTrabajo(ModelMap model) {

		try {
			List<DDEstadoTrabajo> list = albaranApi.getComboEstadoTrabajo();
			model.put("data", list);
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipologiaTrabajo(ModelMap model) {

		try {
			List<DDEstadoTrabajo> list = albaranApi.getComboEstadoTrabajo();
			model.put("data", list);
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelTrabajosPrefactura(DtoAlbaranFiltro filtros, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException{
		
		filtros.setStart(excelReportGeneratorApi.getStart());
		filtros.setLimit(excelReportGeneratorApi.getLimit());

		List<VExportTrabajosAlbaranes> listaTrabajos = (List<VExportTrabajosAlbaranes>) albaranApi.obtenerDatosExportarTrabajosPrefactura(filtros).getResults();

		ExcelReport report = new TrabajosPrefacturaExcelReport(listaTrabajos);

		excelReportGeneratorApi.generateAndSend(report, response);
	}
	
}

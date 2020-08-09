package es.pfsgroup.plugin.rem.controller;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.albaran.dto.DtoAlbaranFiltro;
import es.pfsgroup.plugin.rem.api.AlbaranApi;
import es.pfsgroup.plugin.rem.model.DtoAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetalleAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetallePrefactura;
import es.pfsgroup.plugin.rem.model.DtoDiccionario;
import es.pfsgroup.plugin.rem.model.dd.DDEstEstadoPrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAlbaran;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Controller
public class AlbaranController extends ParadiseJsonController{

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private AlbaranApi albaranApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView findAll(DtoAlbaranFiltro dtoAlbaran, ModelMap model){
		try {
			DtoPage page = albaranApi.findAll(dtoAlbaran);
			
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
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView findAllDetalles(DtoDetalleAlbaran detalleAlbaran, Long numAlbaran, ModelMap model) {
		try {
			List<DtoDetalleAlbaran> page = albaranApi.findAllDetalle( numAlbaran);
			
			model.put("data", page);
			model.put("totalCount", page.size());
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			model.put("error", e.getMessage());
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView findPrefectura(DtoDetallePrefactura detallePrefectura, Long numPrefactura, ModelMap model) {
		try {
			List<DtoDetallePrefactura> page = albaranApi.findPrefectura(numPrefactura);
			
			model.put("data", page);
			model.put("totalCount", page.size());
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			model.put("error", e.getMessage());
			model.put("success", false);
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
	public ModelAndView comprobarValidarPrefactura(Long id, ModelMap model) {
		Boolean comprobar = false;
		Double total = 0.0;
		try {
			comprobar = albaranApi.validarPrefactura(id);
			model.put("success", comprobar);
			model.put("data",total);
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			model.put("error", e.getMessage());
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView comprobarValidarTrabajo(Long id, ModelMap model) {
		Boolean comprobar = false;
		try {
			comprobar = albaranApi.validarTrabajo(id);
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
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getTotalAlbaran(Long numAlbaran, ModelMap model) {
		try {
			DtoDetallePrefactura page = albaranApi.getTotalAlbaran(numAlbaran);
			
			model.put("data", page);
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			model.put("error", e.getMessage());
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getTotalPrefactura(Long numPrefactura, ModelMap model) {
		try {
			DtoDetallePrefactura page = albaranApi.getTotalPrefactura(numPrefactura);
			
			model.put("data", page);
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			model.put("error", e.getMessage());
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
}

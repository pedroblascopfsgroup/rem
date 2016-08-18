package es.pfsgroup.plugin.rem.controller;

import java.lang.reflect.InvocationTargetException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomBooleanEditor;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.JsonWriterConfiguratorTemplateRegistry;
import org.springframework.web.servlet.view.json.writer.sojo.SojoConfig;
import org.springframework.web.servlet.view.json.writer.sojo.SojoJsonWriterConfiguratorTemplate;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.framework.paradise.utils.ParadiseCustomDateEditor;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.excel.AgrupacionExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupaciones;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoFoto;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoSubdivisiones;
import es.pfsgroup.plugin.rem.model.VBusquedaAgrupaciones;


@Controller
public class AgrupacionController {
	
	@Autowired
	private AgrupacionAdapter adapter;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired 
    private ActivoAgrupacionApi activoAgrupacionApi;
	
	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;
	
	/**
	 * Método para modificar la plantilla de JSON utilizada en el servlet.
	 * @param request
	 * @param binder
	 * @throws Exception
	 */
	@InitBinder
	protected void initBinder(HttpServletRequest request,  ServletRequestDataBinder binder) throws Exception{
        
	    JsonWriterConfiguratorTemplateRegistry registry = JsonWriterConfiguratorTemplateRegistry.load(request);             
	    registry.registerConfiguratorTemplate(
	         new SojoJsonWriterConfiguratorTemplate(){
	                
	        	 	@Override
	                public SojoConfig getJsonConfig() {
	                    SojoConfig config= new SojoConfig();
                        config.setIgnoreNullValues(true);
                        return config;
	        	 	}
	         }
	   );

	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
        dateFormat.setLenient(false);
        
        //binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
        binder.registerCustomEditor(Date.class, new ParadiseCustomDateEditor(dateFormat, true));
        
        binder.registerCustomEditor(boolean.class, new CustomBooleanEditor("true", "false", true));
        binder.registerCustomEditor(Boolean.class, new CustomBooleanEditor("true", "false", true));
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(false));
        NumberFormat f = NumberFormat.getInstance(Locale.ENGLISH);
    	f.setGroupingUsed(false);
    	f.setMaximumFractionDigits(2);
        f.setMinimumFractionDigits(2);
        binder.registerCustomEditor(double.class, new CustomNumberEditor(Double.class, f, true));
        binder.registerCustomEditor(Double.class, new CustomNumberEditor(Double.class, f, true));       
        
        /*binder.registerCustomEditor(Float.class, new CustomNumberEditor(Float.class, true));
        binder.registerCustomEditor(Long.class, new CustomNumberEditor(Long.class, true));
        binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));*/

        
        
	}
		
	/**
	 * Método que recupera una Agrupación según su id y lo mapea a un DTO
	 * @param id Id del activo
	 * @param pestana Pestaña de la agrupación a cargar. Dependiendo de la pestaña recibida, cargará un DTO u otro
	 * @param model
	 * @return
	 */
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAgrupacionById(Long id, int pestana, ModelMap model){

		model.put("data", adapter.getAgrupacionById(id));

		return createModelAndViewJson(model);
	}
	
	
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivosAgrupacionById(DtoAgrupacionFilter filtro, Long id, ModelMap model){

		Page page = adapter.getListActivosAgrupacionById(filtro, id); 
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAgrupaciones(DtoAgrupacionFilter dtoAgrupacionFilter, ModelMap model){

		Page page = adapter.getListAgrupaciones(dtoAgrupacionFilter);
		
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		//model.put("data", adapter.getListAgrupaciones());
		
		return createModelAndViewJson(model);
		
	}	
	
	private ModelAndView createModelAndViewJson(ModelMap model) {
		
		return new ModelAndView("jsonView", model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createActivoAgrupacion(@RequestParam Long idEntidad, @RequestParam Long numActivo, @RequestParam(required = false) Integer activoPrincipal, ModelMap model){
		
		try {
			adapter.createActivoAgrupacion(numActivo, idEntidad, activoPrincipal);
			model.put("success", true);
			
		} catch (JsonViewerException jvex){
			model.put("success", false);
			model.put("msg", jvex.getMessage());
		}
		
		catch (Exception e) {
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView marcarPrincipal(@RequestParam Long idAgrupacion, @RequestParam Long idActivo, ModelMap model){
		
		try {
			boolean success = adapter.marcarPrincipal(idAgrupacion, idActivo);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteActivoAgrupacion(@RequestParam Long id, ModelMap model){
		
		try {
			boolean success = adapter.deleteActivoAgrupacion(id);
			model.put("success", success);
			
		} catch (JsonViewerException jvex){
			jvex.printStackTrace();
			model.put("success", false);
			model.put("msg", jvex.getMessage());
		}
		catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteActivosAgrupacion(@RequestParam Long[] id, ModelMap model){
		
		try {
			boolean success = adapter.deleteActivosAgrupacion(id);
			model.put("success", success);
			
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAllActivosAgrupacion(@RequestParam Long id, ModelMap model){
		
		try {
			boolean success = adapter.deleteAllActivosAgrupacion(id);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createAgrupacion(DtoAgrupacionesCreateDelete dtoAgrupacion, ModelMap model){
		
		try {
			boolean success = adapter.createAgrupacion(dtoAgrupacion);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAgrupacionById(DtoAgrupacionesCreateDelete dtoAgrupacion, ModelMap model){
		
		try {
			boolean success = adapter.deleteAgrupacionById(dtoAgrupacion);
			model.put("success", success);
		
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListObservacionesAgrupacionById(Long id, ModelMap model){

		model.put("data", adapter.getListObservacionesAgrupacionById(id));
		
		return createModelAndViewJson(model);
		
	}	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListVisitasAgrupacionById(Long id, ModelMap model){

		model.put("data", adapter.getListVisitasAgrupacionById(id));
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListOfertasAgrupacion(Long id, ModelMap model){

		model.put("data", adapter.getListOfertasAgrupacion(id));
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAvisosAgrupacionById(Long id, ModelMap model){
			

	/*	List<DtoAviso> listaAvisos = new ArrayList<DtoAviso>();
		for (AgrupacionAvisadorApi avisador: avisadores) {
			avisador.setAgrupacion(agrupacion);

        }
		*/

		model.put("data", adapter.getAvisosAgrupacionById(id));
		
		return createModelAndViewJson(model);
		
	}	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView procesarMasivo(Long idProcess, Long idOperation, ModelMap model){
		
		model.put("data", adapter.procesarMasivo(idProcess, idOperation));
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveAgrupacion(DtoAgrupaciones dtoAgrupacion, @RequestParam Long id, ModelMap model){
		
		try {
			boolean success = adapter.saveAgrupacion(dtoAgrupacion, id);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveOfertaAgrupacion(DtoOfertaActivo dtoOferta, @RequestParam Long id, ModelMap model){
		
		try {
			boolean success = adapter.saveOfertaAgrupacion(dtoOferta);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView  saveObservacionesAgrupacion(DtoObservacion dtoObservacion, Long idAgrupacion, ModelMap model){
		
		try {
			boolean success = adapter.saveObservacionesAgrupacion(dtoObservacion, idAgrupacion);
			model.put("success", success);
			
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}

	/**
	 * 
	 * @param dtoObservacion
	 * @param id En corresponde con el id de la Agrupacion
	 * @param model
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView  createObservacionesAgrupacion(DtoObservacion dtoObservacion, Long idEntidad, ModelMap model){
		
		try {
			boolean success = adapter.createObservacionesAgrupacion(dtoObservacion, idEntidad);
			model.put("success", success);
		
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteObservacionesAgrupacion(@RequestParam Long id, ModelMap model){
		
		try {
			boolean success = adapter.deleteObservacionAgrupacion(id);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getFotosAgrupacionById(Long id, WebDto webDto, ModelMap model){
				
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		List<DtoFoto> listaDtoFotos = new ArrayList<DtoFoto>();
		
		if (agrupacion.getTipoAgrupacion() != null && agrupacion.getTipoAgrupacion().getCodigo().equals("01")) {
			
			List<ActivoFoto> listaFotos = activoAgrupacionApi.getFotosAgrupacionById(id);

			if (listaFotos != null) {
				
				for (int i = 0; i < listaFotos.size(); i++) {
						
					try {
			
						DtoFoto fotoDto = new DtoFoto();
						
						BeanUtils.copyProperty(fotoDto, "path", "/pfs/activo/getFotoActivoById.htm?idFoto=" + listaFotos.get(i).getId());
						
						BeanUtils.copyProperties(fotoDto, listaFotos.get(i));
						
						listaDtoFotos.add(fotoDto);
			
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					} catch (InvocationTargetException e) {
						e.printStackTrace();
					}
					
				}
				
			}
			
		} else {
			

			List<ActivoFoto> listaFotos = adapter.getFotosActivosAgrupacionById(id);

			if (listaFotos != null) {
				
				for (int i = 0; i < listaFotos.size(); i++) {
						
					try {
			
						DtoFoto fotoDto = new DtoFoto();
						
						BeanUtils.copyProperty(fotoDto, "path", "/pfs/activo/getFotoActivoById.htm?idFoto=" + listaFotos.get(i).getId());
						BeanUtils.copyProperties(fotoDto, listaFotos.get(i));
						BeanUtils.copyProperty(fotoDto, "numeroActivo", listaFotos.get(i).getActivo().getId());
						
						listaDtoFotos.add(fotoDto);
			
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					} catch (InvocationTargetException e) {
						e.printStackTrace();
					}
					
				}
				
			}
			
		}
		
		
		model.put("data", listaDtoFotos);
		
		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getFotosSubdivisionById(DtoSubdivisiones subdivision, ModelMap model){
		
		List<DtoFoto> listaDtoFotos = new ArrayList<DtoFoto>();			
		List<ActivoFoto> listaFotos = activoAgrupacionApi.getFotosSubdivision(subdivision);

		if (listaFotos != null) {
			
			for (int i = 0; i < listaFotos.size(); i++) {
					
				try {
		
					DtoFoto fotoDto = new DtoFoto();
					
					BeanUtils.copyProperty(fotoDto, "id", listaFotos.get(i).getId());
					
					BeanUtils.copyProperties(fotoDto, listaFotos.get(i));
					
					listaDtoFotos.add(fotoDto);
		
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				
			}
			
		}

		model.put("data", listaDtoFotos);
		
		return createModelAndViewJson(model);
	}
	

	/**
	 * Recibe y guarda una foto
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView uploadFoto(HttpServletRequest request, HttpServletResponse response)
		throws Exception {
		
		ModelMap model = new ModelMap();
		
		try {

			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);
			
			String errores = activoAgrupacionApi.uploadFoto(fileItem);			

			model.put("errores", errores);
			model.put("success", errores!=null);
		
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("errores", e.getCause());
		}
		return createModelAndViewJson(model);
		//return JsonViewer.createModelAndViewJson(model);

	} 
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView uploadFotoSubdivision(HttpServletRequest request, HttpServletResponse response)
		throws Exception {
		
		ModelMap model = new ModelMap();
		
		try {

			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);
			
			String errores = activoAgrupacionApi.uploadFotoSubdivision(fileItem);			

			model.put("errores", errores);
			model.put("success", errores!=null);
		
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("errores", e.getCause());
		}
		return createModelAndViewJson(model);
		//return JsonViewer.createModelAndViewJson(model);

	} 
	

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListSubdivisionesAgrupacionById(DtoAgrupacionFilter agrupacionFilter, ModelMap model){

		Page page = activoAgrupacionApi.getListSubdivisionesAgrupacionById(agrupacionFilter);
		
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());
		
		return createModelAndViewJson(model);
		
	}	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivosSubdivisionById(DtoSubdivisiones subdivisionFilter, ModelMap model){
		
		Page page = activoAgrupacionApi.getListActivosSubdivisionById(subdivisionFilter);
		
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());
		
		return createModelAndViewJson(model);
		
	}	
	
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcel(DtoAgrupacionFilter dtoAgrupacionFilter, HttpServletRequest request, HttpServletResponse response) throws Exception {

		dtoAgrupacionFilter.setStart(excelReportGeneratorApi.getStart());
		dtoAgrupacionFilter.setLimit(excelReportGeneratorApi.getLimit());
		
		@SuppressWarnings("unchecked")
		List<VBusquedaAgrupaciones> listaAgrupaciones = (List<VBusquedaAgrupaciones>) adapter.getListAgrupaciones(dtoAgrupacionFilter).getResults();
		
		ExcelReport report = new AgrupacionExcelReport(listaAgrupaciones);
		
		excelReportGeneratorApi.generateAndSend(report, response);

	}
	

}

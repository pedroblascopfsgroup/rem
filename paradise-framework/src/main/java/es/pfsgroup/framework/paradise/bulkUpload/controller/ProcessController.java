package es.pfsgroup.framework.paradise.bulkUpload.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.JsonWriterConfiguratorTemplateRegistry;
import org.springframework.web.servlet.view.json.writer.sojo.SojoConfig;
import org.springframework.web.servlet.view.json.writer.sojo.SojoJsonWriterConfiguratorTemplate;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoAltaProceso;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.JsonViewer;

@Controller
public class ProcessController {
	
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired 
	UploadAdapter uploadAdapter;
	
	@InitBinder
	protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) throws Exception {

		JsonWriterConfiguratorTemplateRegistry registry = JsonWriterConfiguratorTemplateRegistry
				.load(request);
		registry.registerConfiguratorTemplate(new SojoJsonWriterConfiguratorTemplate() {
			@Override
			public SojoConfig getJsonConfig() {
				SojoConfig config = new SojoConfig();
				config.setIgnoreNullValues(true);
				return config;
			}
		});

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		dateFormat.setLenient(false);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(
				dateFormat, false));
	}
	
	
	//	TIPOS DE OPERACIONES
	//	====================
	//	 AGAR:    Agrupar activos (Restringidos)
	//   AGAN:    Agrupar activos (Obra nueva)
	/**
	 * Función que inicia el proceso de carga masiva por separado ( upload del fichero por otro lado )
	 * @param idTipoOperacion
	 * @param nombreFichero
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView initProcess(Long idTipoOperacion, String nombreFichero) throws Exception{
		
		MSVDtoAltaProceso dto = new MSVDtoAltaProceso();
		dto.setIdTipoOperacion(idTipoOperacion);
		dto.setDescripcion(nombreFichero);
		return JsonViewer.createModelAndViewJson(new ModelMap("idProceso", processAdapter.initProcess(dto)));
		
	}

	/**
	 * Función que inicia el proceso de carga masiva haciendo el upload del fichero a la vez
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView initProcessUpload(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		ModelMap model = new ModelMap();
		String result = null;
		Long idProceso = null;
		
		try {			
			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);
			
			MSVDtoAltaProceso dto = new MSVDtoAltaProceso();
			dto.setIdTipoOperacion(Long.parseLong(fileItem.getParameter("idTipoOperacion")));
			dto.setDescripcion(fileItem.getParameter("fileUpload"));	
			
			idProceso = processAdapter.initProcess(dto);	
			
			Map<String, String> parameters = fileItem.getParameters();			
			parameters.put("idProceso", String.valueOf(idProceso));
			parameters.put("idTipoOperacion", fileItem.getParameter("idTipoOperacion"));
			fileItem.setParameters(parameters);
			
			result = processAdapter.subirFicheroParaProcesar(fileItem);
			model.put("success", true);
		
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("errorMessage", e.getCause());
		}
		
		return JsonViewer.createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView mostrarProcesos(){
	
		return JsonViewer.createModelAndViewJson(new ModelMap("data", processAdapter.mostrarProcesos()));
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView liberarFichero(Long id) throws Exception{
	
		return JsonViewer.createModelAndViewJson(new ModelMap("data", processAdapter.liberarFichero(id)));
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTiposOperacion() {
		
		return JsonViewer.createModelAndViewJson(new ModelMap("data", processAdapter.getTiposOperacion()));
		
	}
		
	/**
	 * 
	 * @param request
	 * @param response
	 * @throws Exception 
	 */
	@RequestMapping(method = RequestMethod.GET)
	public void downloadTemplate (HttpServletRequest request, HttpServletResponse response) throws Exception {

		Long idTipoOperacion = null;
		try {
			
			idTipoOperacion = Long.parseLong(request.getParameter("idTipoOperacion"));
			
       		ServletOutputStream salida = response.getOutputStream(); 
       		FileItem fileItem = processAdapter.downloadTemplate(idTipoOperacion);
       		
       		if(fileItem!= null) {
       		
	       		response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
	       		response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
	       		response.setHeader("Cache-Control", "max-age=0");
	       		response.setHeader("Expires", "0");
	       		response.setHeader("Pragma", "public");
	       		response.setDateHeader("Expires", 0); //prevents caching at the proxy
	       		response.setContentType(fileItem.getContentType());       		
	       		// Write
	       		FileUtils.copy(fileItem.getInputStream(), salida);
	       		salida.flush();
	       		salida.close();
       		}
       		
       	} catch (Exception e) { 
       		e.printStackTrace();
       	}

	}

	@RequestMapping(method = RequestMethod.GET)
	public void downloadErrors (HttpServletRequest request, HttpServletResponse response) throws Exception {

		Long idProcess = null;
		try {
			
       		ServletOutputStream salida = response.getOutputStream(); 
			idProcess = Long.parseLong(request.getParameter("idProcess"));
       		FileItem fileItem = processAdapter.downloadErrors(idProcess);
       		
       		if(fileItem!= null) {
	       		response.setHeader("Content-disposition", "attachment; filename='" + fileItem.getFileName()+"'");
	       		response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
	       		response.setHeader("Cache-Control", "max-age=0");
	       		response.setHeader("Expires", "0");
	       		response.setHeader("Pragma", "public");
	       		response.setDateHeader("Expires", 0); //prevents caching at the proxy
	       		response.setContentType(fileItem.getContentType());       		
	       		// Write
	       		FileUtils.copy(fileItem.getInputStream(), salida);
	       		salida.flush();
	       		salida.close();
       		}        		
       	} catch (Exception e) { 
       		e.printStackTrace();
       	}

	}
	
	@RequestMapping(method = RequestMethod.GET)
	public void setStateProcessing (HttpServletRequest request, HttpServletResponse response) throws Exception {
		Long idProcess = Long.parseLong(request.getParameter("idProcess"));
		processAdapter.setStateProcessing(idProcess);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public void setStateProcessed (HttpServletRequest request, HttpServletResponse response) throws Exception {
		Long idProcess = Long.parseLong(request.getParameter("idProcess"));
		processAdapter.setStateProcessed(idProcess);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public void setStateError (HttpServletRequest request, HttpServletResponse response) throws Exception {
		Long idProcess = Long.parseLong(request.getParameter("idProcess"));
		processAdapter.setStateError(idProcess);
	}
	
	
	
}

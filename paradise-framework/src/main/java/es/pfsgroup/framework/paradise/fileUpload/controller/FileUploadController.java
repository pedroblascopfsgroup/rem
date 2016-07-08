package es.pfsgroup.framework.paradise.fileUpload.controller;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindException;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.view.json.JsonWriterConfiguratorTemplateRegistry;
import org.springframework.web.servlet.view.json.writer.sojo.SojoConfig;
import org.springframework.web.servlet.view.json.writer.sojo.SojoJsonWriterConfiguratorTemplate;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.fileUpload.dto.FileUpload;
import es.pfsgroup.framework.paradise.utils.JsonViewer;

@Controller
public class FileUploadController extends SimpleFormController{
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	public FileUploadController(){
		setCommandClass(FileUpload.class);
		setCommandName("fileUploadForm");
	}
 
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

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveBLOB(HttpServletRequest request) {
		
		ModelMap model = new ModelMap();
		Adjunto adj = null;
		
		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());
		} catch (Exception e) {
			model.put("sucess",false);
			model.put("errorMessage", e.getCause());
			return JsonViewer.createModelAndViewJson(model);
		}
		
		model.put("sucess",true);
		model.put("idAjunto", adj.getId());
		return JsonViewer.createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public void findOneBLOB(HttpServletRequest request, HttpServletResponse response) {
	
		Long id = Long.parseLong(request.getParameter("id"));

       	try { 
       		FileItem fileItem = uploadAdapter.findOneBLOB (id);
       		ServletOutputStream salida = response.getOutputStream(); 
       		response.setHeader("Content-disposition", "attachment; filename=blobFile");
       		response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
       		response.setHeader("Cache-Control", "max-age=0");
       		response.setHeader("Expires", "0");
       		response.setHeader("Pragma", "public");
       		response.setDateHeader("Expires", 0); //prevents caching at the proxy
       		// Write
       		FileUtils.copy(fileItem.getInputStream(), salida);
       		salida.flush();
       		salida.close();
       	} catch (Exception e) { 
       		e.printStackTrace();
       	}
		
	}
	
	
}

package es.pfsgroup.plugin.rem.controller;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.FileListResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileSearch;
import es.pfsgroup.plugin.rem.rest.dto.FileUpload;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class FotosController {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RestApi restApi;

	@Autowired
	GestorDocumentalFotosApi gestorDocumentalFotos;

	@RequestMapping(method = RequestMethod.POST, value = "/fotos")
	public void fotos(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		logger.error(
				"############################################### WEBHOOK ##############################################");
		logger.error(request.getBody());
		logger.error(
				"######################################################################################################");
	}

	@RequestMapping(method = RequestMethod.POST, value = "/fotos/subirfoto")
	public void subirFoto(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		logger.error(
				"############################################### GESTOR DOCUMENTAL TEST ##############################################");
		ObjectMapper mapper = new ObjectMapper();
		FileResponse fileReponse;
		try {
			FileUpload toUpload = new FileUpload();
			toUpload.setBasename("test.jpg");
			HashMap<String, String> metadata = new HashMap<String, String>();
			metadata.put("propiedad", "activo");
			metadata.put("idActivoHaya", "4444444");
			metadata.put("tipo", "01");
			metadata.put("descripcion", "desc foto");
			metadata.put("principal", "1");
			metadata.put("tipo", "01");
			toUpload.setMetadata(metadata);
			fileReponse = gestorDocumentalFotos.upload(toUpload, new File("/recovery/app-server/ejem.JPG"));
			restApi.sendResponse(response, mapper.writeValueAsString(fileReponse));
		} catch (JsonGenerationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	@RequestMapping(method = RequestMethod.POST, value = "/fotos/obtenerFotos")
	public void obtenerFotos(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		logger.error(
				"############################################### GESTOR DOCUMENTAL TEST ##############################################");
		FileSearch fs = new FileSearch();
		ObjectMapper mapper = new ObjectMapper();
		try {
			HashMap<String, String> metadata = new HashMap<String, String>();
			metadata.put("propiedad", "activo");
			metadata.put("idActivoHaya", "4444444");
			//fs.setMetadata(metadata);
			//fs.setSince(new Date(2016, 1, 1, 0, 0, 1));
			fs.setId("1");
			FileListResponse resultado = gestorDocumentalFotos.get(fs);
			restApi.sendResponse(response, mapper.writeValueAsString(resultado));
		} catch (JsonGenerationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}

package es.pfsgroup.plugin.rem.controller;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PRINCIPAL;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PROPIEDAD;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.SITUACION;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.TIPO;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.FileListResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.rest.dto.OperationResultResponse;
import es.pfsgroup.plugin.rem.rest.dto.WebHookRequest;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.restclient.exception.RestClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;

@Controller
public class FotosController {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RestApi restApi;

	@Autowired
	GestorDocumentalFotosApi gestorDocumentalFotos;

	@Autowired
	private ServletContext servletContext;

	private ObjectMapper mapper = new ObjectMapper();

	@Autowired
	private ActivoApi activoManager;

	@Autowired
	private ActivoAgrupacionApi activoAgrupacionManager;

	@Autowired
	private ActivoAdapter activoAdapter;

	@RequestMapping(method = RequestMethod.POST, value = "/fotos")
	@Transactional(readOnly = false)
	public void fotos(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		logger.error(
				"############################################### WEBHOOK ##############################################");
		logger.error(request.getBody());
		try {
			WebHookRequest requestData = mapper.readValue(request.getBody(), WebHookRequest.class);
			// modificados o creados
			if (requestData.getModified() != null) {
				for (es.pfsgroup.plugin.rem.rest.dto.File file : requestData.getModified()) {
					if (file.getMetadata().containsKey("propiedad")) {
						if (file.getMetadata().get("propiedad").equals("activo")) {
							activoManager.uploadFoto(file);
						} else if (file.getMetadata().get("propiedad").equals("agrupacion")) {
							activoAgrupacionManager.uploadFoto(file);
						} else if (file.getMetadata().get("propiedad").equals("subdivision")) {
							activoAgrupacionManager.uploadFotoSubdivision(file);
						}
					}

				}
			}
			// borrados
			if (requestData.getDeleted() != null) {
				for (es.pfsgroup.plugin.rem.rest.dto.File file : requestData.getDeleted()) {
					activoAdapter.deleteFotoByRemoteId(file.getId());
				}
			}
		} catch (Exception  e) {
			logger.error(e);
		} 
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
			fileReponse = gestorDocumentalFotos.upload(new File("/recovery/app-server/ejem.JPG"), "test.jpg",
					PROPIEDAD.ACTIVO, new Long(62926), TIPO.WEB, "desc foto", PRINCIPAL.SI, SITUACION.INTERIOR, 1);
			restApi.sendResponse(response, mapper.writeValueAsString(fileReponse));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (RestClientException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (HttpClientException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	@RequestMapping(method = RequestMethod.POST, value = "/fotos/obtenerFotos")
	public void obtenerFotos(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		logger.error(
				"############################################### GESTOR DOCUMENTAL TEST ##############################################");
		ObjectMapper mapper = new ObjectMapper();
		try {
			FileListResponse resultado = gestorDocumentalFotos.get(PROPIEDAD.ACTIVO, new Long(62926));
			// FileListResponse resultado = gestorDocumentalFotos.get(new
			// Long(24));
			/*
			 * FileUpload fUp = new FileUpload(); fUp.setId(new Long(24));
			 * HashMap<String, String> metadata
			 * =resultado.getData().get(0).getMetadata(); metadata.put("orden",
			 * "69"); fUp.setMetadata(metadata);
			 */

			// gestorDocumentalFotos.upload(fUp);
			// resultado = gestorDocumentalFotos.get(new Long(24));
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

	@RequestMapping(method = RequestMethod.POST, value = "/fotos/borrarFoto")
	public void deleteFoto(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		ObjectMapper mapper = new ObjectMapper();
		try {
			OperationResultResponse resultado = gestorDocumentalFotos.delete(new Long(9));
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

	@RequestMapping(method = RequestMethod.POST, value = "/fotos/fueraToken")
	public void fueraToken(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		servletContext.setAttribute("idAuthToken", null);
	}

}

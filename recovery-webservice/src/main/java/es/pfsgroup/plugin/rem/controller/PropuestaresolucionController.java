package es.pfsgroup.plugin.rem.controller;

import java.io.File;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.PropuestaOfertaApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.PropuestaDto;
import es.pfsgroup.plugin.rem.rest.dto.PropuestaRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class PropuestaresolucionController {

		@Autowired
		private RestApi restApi;
		
		@Autowired
		private PropuestaOfertaApi propuestaOfertaApi;
		
		@SuppressWarnings("unchecked")
		@RequestMapping(method = RequestMethod.POST, value = "/propuestaresolucion")
		public void propuestaResolucion(ModelMap model, RestRequestWrapper request,HttpServletResponse response) throws ParseException {	
			
			PropuestaRequestDto jsonData = null;
			PropuestaDto propuestaDto = null;
			
			Map<String, Object> params = null;
			List<Object> dataSource = null;			
			File fileSalidaTemporal = null;			
			
			//VALIDACIÓN DEL JSON ENTRADA
			try {
				jsonData = (PropuestaRequestDto) request.getRequestData(PropuestaRequestDto.class);
				if (Checks.esNulo(jsonData)) {
					model.put("error", RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
					throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
				}
				model.put("id", jsonData.getId());
				propuestaDto = jsonData.getData();
				if (propuestaDto==null || propuestaDto.getOfertaHRE()==null) {
					model.put("error", RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
					throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
				}
			} catch (JsonParseException e1) {
				model.put("error", RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
				e1.printStackTrace();
			} catch (JsonMappingException e1) {
				model.put("error", RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
				e1.printStackTrace();
			} catch (Exception e1){
				model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
				e1.printStackTrace();
			}
			
			//OBTENCION DE LOS DATOS PARA RELLENAR EL DOCUMENTO
			if (model.get("error")==null || model.get("error")=="") {
				params = propuestaOfertaApi.paramsPropuestaSimple(propuestaDto.getOfertaHRE(), model);
			}
			if (model.get("error")==null || model.get("error")=="") {
				dataSource = propuestaOfertaApi.dataSourcePropuestaSimple(propuestaDto.getOfertaHRE(), model);
			}
			
			//GENERACION DEL DOCUMENTO EN PDF		
			if (model.get("error")==null || model.get("error")=="") {
				fileSalidaTemporal = propuestaOfertaApi.getPDFFilePropuestaSimple(params, dataSource, model);
			}

			//ENVIO DE LOS DATOS DEL DOCUMENTO AL CLIENTE
			if (model.get("error")==null || model.get("error")=="") {
				propuestaOfertaApi.sendFileBase64(response, fileSalidaTemporal, model);
			}
			
			//Si no hay error se pone vacio, por coherencia con los otros métodos.
			if (model.get("error")==null) {
				model.put("error", "");
			}
			
			restApi.sendResponse(response, model,request);

		}
			
}

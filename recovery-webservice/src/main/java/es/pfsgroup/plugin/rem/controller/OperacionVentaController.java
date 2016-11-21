package es.pfsgroup.plugin.rem.controller;

import java.io.File;
import java.io.IOException;
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
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.impl.OperacionVentaManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaSimpleDto;
import es.pfsgroup.plugin.rem.rest.dto.PropuestaRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

import es.pfsgroup.plugin.rem.excel.ExcelReportGenerator;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;

@Controller
public class OperacionVentaController {

		final String templateOperacionVenta = "OperativaVenta001";
	
		@Autowired
		private RestApi restApi;
		
		@Autowired
		private OperacionVentaManager operacionVentaManager;
		
		@Autowired 
		private OfertaApi ofertaApi;
		
		@Autowired
		private ExcelReportGeneratorApi excelReportGeneratorApi;
		
		@SuppressWarnings("unchecked")
		@RequestMapping(method = RequestMethod.POST, value = "/operacionventa")
		public void operacionVenta(ModelMap model, RestRequestWrapper request,HttpServletResponse response) throws ParseException {	
			
			PropuestaRequestDto jsonData = null;
			OfertaSimpleDto operacionDto = null;
			
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
				operacionDto = jsonData.getData();
				if (operacionDto==null || operacionDto.getOfertaHRE()==null) {
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
			
			Oferta oferta = null;
			//Primero comprabar que existe OFERTA
			if (model.get("error")==null || model.get("error")=="") {
				oferta = ofertaApi.getOfertaByNumOfertaRem(operacionDto.getOfertaHRE());
				if (oferta==null) {
					model.put("error", RestApi.REST_NO_RELATED_OFFER);				
				}
			}
			
			//Despueś comprabar que existe un ACTIVO relacionado
			Activo activo = null;
			if (model.get("error")==null || model.get("error")=="") {
				activo = oferta.getActivoPrincipal();
				if (activo==null) {
					model.put("error", RestApi.REST_NO_RELATED_ASSET);				
				}
			}
			
			//OBTENCION DE LOS DATOS PARA RELLENAR EL DOCUMENTO
			if (model.get("error")==null || model.get("error")=="") {
				params = operacionVentaManager.paramsHojaDatos(oferta, model);
			}
			if (model.get("error")==null || model.get("error")=="") {
				dataSource = operacionVentaManager.dataSourceHojaDatos(oferta, activo, model);
			}
			
			//GENERACION DEL DOCUMENTO EN PDF		
			if (model.get("error")==null || model.get("error")=="") {
				fileSalidaTemporal = operacionVentaManager.getPDFFile(params, dataSource, templateOperacionVenta, model);
			}

			//ENVIO DE LOS DATOS DEL DOCUMENTO AL CLIENTE
			if (model.get("error")==null || model.get("error")=="") {
				try {
					excelReportGeneratorApi.sendReport(fileSalidaTemporal, response);
				} catch (IOException e) {
					model.put("error",e.getMessage()); //<--- vore este error					
				}
			} 

			//Si hay algún error se envía un JSON(model) con información.
			if (model.get("error")!=null) {				
				restApi.sendResponse(response, model,request);
			}
		}
			
}

package es.pfsgroup.plugin.rem.controller;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GenerarFacturaVentaActivosApi;
import es.pfsgroup.plugin.rem.api.ParamReportsApi;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaSimpleDto;
import es.pfsgroup.plugin.rem.rest.dto.PropuestaRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.utils.FileUtilsREM;

@Controller
public class OperacionVentaController {

		final String templateOperacionVenta = "OperativaVenta001";
		final String templateOperacionVentaShort = "OperativaVenta";

		@Autowired
		private ParamReportsApi paramReportsApi;

		@Autowired
		private ExpedienteComercialApi expedienteComercialApi;

		@Autowired
		private ExcelReportGeneratorApi excelReportGeneratorApi;
		
		@Autowired
		private GenerarFacturaVentaActivosApi facturaVentaApi;
		
		@Autowired
		private ExcelReportGeneratorApi reportApi;

		@SuppressWarnings("unchecked")
		@RequestMapping(method = RequestMethod.POST, value = "/operacionventa")
		public void operacionVenta(ModelMap model, RestRequestWrapper request,HttpServletResponse response) throws ParseException {	

			PropuestaRequestDto jsonData = null;
			OfertaSimpleDto operacionDto = null;	
			
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
			
			operacionVentaPDFByOfertaHRE(operacionDto.getOfertaHRE(), request, response);
		}
		
		@SuppressWarnings("unchecked")
		@RequestMapping(method = RequestMethod.GET)
		public void operacionVentaPDFByOfertaHRE (Long numExpediente, HttpServletRequest request, HttpServletResponse response){	

			ModelMap model = new ModelMap();
			Map<String, Object> params = null;
			List<Object> dataSource = null;			
			File fileSalidaTemporal = null;
			
			ExpedienteComercial expediente = expedienteComercialApi.findOneByNumExpediente(numExpediente);
			
			Oferta oferta = null;
			//Primero comprobar que existe OFERTA
			if (model.get("error")==null || model.get("error")=="") {
				if(!Checks.esNulo(expediente)){
					oferta = expediente.getOferta(); //ofertaApi.getOfertaByNumOfertaRem(ofertaHRE);
					if (oferta==null) {
					model.put("error", RestApi.REST_NO_RELATED_OFFER);
					}
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
			
			//Generamos una lista de PDF por cada activoOferta
			List<File> listaPdf = new ArrayList<File>(); 			
			for(ActivoOferta activoOferta : oferta.getActivosOferta()) {				
				//OBTENCION DE LOS DATOS PARA RELLENAR EL DOCUMENTO
				if (model.get("error")==null || model.get("error")=="") {
					params = paramReportsApi.paramsHojaDatos(activoOferta, model);
				}
				if (model.get("error")==null || model.get("error")=="") {
					dataSource = paramReportsApi.dataSourceHojaDatos(activoOferta, model);
				}
				//GENERACION DEL DOCUMENTO EN PDF		
				if (model.get("error")==null || model.get("error")=="") {
					fileSalidaTemporal = paramReportsApi.getPDFFile(params, dataSource, templateOperacionVenta, model, numExpediente);
					listaPdf.add(fileSalidaTemporal);
				}										
			}
			
			//AGRUPAR TODOS LOS PDF DE SALIDA EN UNO SOLO
			File salida = null;
			if (model.get("error")==null || model.get("error")=="") {
				try {
					salida = File.createTempFile(templateOperacionVentaShort, ".pdf");
					FileUtilsREM.concatenatePdfs(listaPdf, salida);
				} catch (Exception e) {
					model.put("error", e.getLocalizedMessage());
				}
			}

			//ENVIO DE LOS DATOS DEL DOCUMENTO AL CLIENTE
			if (model.get("error")==null || model.get("error")=="") {
				try {
					excelReportGeneratorApi.sendReport(salida, response);
				} catch (IOException e) {
					model.put("error", e.getLocalizedMessage());	
				}
			} 

			//Si hay algún error se envía un JSON(model) con información.
//			if (model.get("error")!=null && model.get("error")!="") {				
//				restApi.sendResponse(response, model,request);
//			}
		}
		

		@RequestMapping(method = RequestMethod.GET)
		public void operacionVentaFacturaPDF(Long numExpediente, HttpServletRequest request, HttpServletResponse response) {
			
			ExpedienteComercial expediente = expedienteComercialApi.findOneByNumExpediente(numExpediente);
			
			try {
				
				File file = facturaVentaApi.getFacturaVenta(expediente);
				reportApi.sendReport(file, response);
			
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
			
}

package es.pfsgroup.plugin.rem.controller;

import java.io.File;
import java.io.IOException;
import java.security.SecureRandom;
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
import com.itextpdf.text.DocumentException;

import es.capgemini.devon.exception.UserException;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GenerarFacturaVentaActivosApi;
import es.pfsgroup.plugin.rem.api.ParamReportsApi;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.expedienteComercial.ExpedienteComercialManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
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
		final String templateOperacionVentaAgrupacion = "OperativaVentaAgrupacion";
		final String templateOperacionVentaShort = "OperativaVenta";

		@Autowired
		private ParamReportsApi paramReportsApi;

		@Autowired
		private ExpedienteComercialApi expedienteComercialManager;

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

				operacionVentaPDFByOfertaHRE(operacionDto.getOfertaHRE(), request, response);	

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

		}
		
		@SuppressWarnings("unchecked")
		@RequestMapping(method = RequestMethod.GET)
		public void operacionVentaPDFByOfertaHRE (Long numExpediente, HttpServletRequest request, HttpServletResponse response){	

			SecureRandom random = new SecureRandom();
			
			File salida = generarPdfOperacionVentaByOfertaHre(numExpediente, null);
			
			//ENVIO DE LOS DATOS DEL DOCUMENTO AL CLIENTE
			try {
				long n = random.nextLong();
	            if (n == Long.MIN_VALUE) {
	                n = 0;      // corner case
	            } else {
	                n = Math.abs(n);
	            }
	            String aleatorio = Long.toString(n);
	            if(aleatorio.length() > 5){
	            	aleatorio = aleatorio.substring(0, 5);
	            }
				String name ="Hoja_Datos_Exp_" + String.valueOf(numExpediente) +"_"+aleatorio +".pdf";
				excelReportGeneratorApi.sendReport(name,salida, response);
			} catch (IOException e) {
				throw new UserException(e.getMessage());
			}
			
			//Si hay algún error se envía un JSON(model) con información.
//			if (model.get("error")!=null && model.get("error")!="") {				
//				restApi.sendResponse(response, model,request);
//			}
		}
		
		@SuppressWarnings("unchecked")
		@RequestMapping(method = RequestMethod.GET)
		public File generarPdfOperacionVentaByOfertaHre(Long numExpediente, ModelMap model) {
			File salida = null;

			if (model == null || (model.get("error")==null || model.get("error")=="")) {
	
				Map<String, Object> params = null;
				List<Object> dataSource = null;			
				File fileSalidaTemporal = null;
				
				ExpedienteComercial expediente = expedienteComercialManager.findOneByNumExpediente(numExpediente);
				
				Oferta oferta = null;
				Activo activo = null;
				//Primero comprobar que existe OFERTA y ACTIVO
				if(!Checks.esNulo(expediente)){
					oferta = expediente.getOferta();					
					activo = oferta.getActivoPrincipal();
					if (activo==null && oferta.getActivosOferta()==null) {
						throw new UserException("No se han encontrado activos relacionada a la oferta");
					}
				}
				
				//Generamos una lista de PDF por cada activoOferta
				List<File> listaPdf = new ArrayList<File>();
				
				//PRIMERO GENERAMOS PDF CABECERA DE LA AGRUPACION (SI TIENE)
				if (oferta!=null) { 
					if (oferta.getActivosOferta().size()>1) {
						params = paramReportsApi.paramsCabeceraHojaDatos(oferta.getActivosOferta().get(0), model);
						dataSource = paramReportsApi.dataSourceHojaDatos(oferta.getActivosOferta().get(0), model);
						//GENERACION DE LA CABECERA DEL DOCUMENTO EN PDF		
						fileSalidaTemporal = paramReportsApi.getPDFFile(params, dataSource, templateOperacionVentaAgrupacion, model, numExpediente);
						listaPdf.add(fileSalidaTemporal);
					}			
				
					for(ActivoOferta activoOferta : oferta.getActivosOferta()) {				
						//OBTENCION DE LOS DATOS PARA RELLENAR EL DOCUMENTO
						params = paramReportsApi.paramsHojaDatos(activoOferta, model);
						dataSource = paramReportsApi.dataSourceHojaDatos(activoOferta, model);
						//GENERACION DEL DOCUMENTO EN PDF		
						fileSalidaTemporal = paramReportsApi.getPDFFile(params, dataSource, templateOperacionVenta, model, numExpediente);
						listaPdf.add(fileSalidaTemporal);			
					}
					
				}
				
				//AGRUPAR TODOS LOS PDF DE SALIDA EN UNO SOLO
				try {
					salida = File.createTempFile(templateOperacionVentaShort, ".pdf");
					FileUtilsREM.concatenatePdfs(listaPdf, salida);
				} catch (IOException ex1) {
					throw new UserException(ex1.getMessage());
				} catch (DocumentException ex2) {
					throw new UserException(ex2.getMessage());
				}
			}else {
				throw new UserException("Existen errores en el modelmap.");
			}
			return salida;
		}

		@RequestMapping(method = RequestMethod.GET)
		public void operacionVentaFacturaPDF(Long numExpediente, HttpServletRequest request, HttpServletResponse response) {
			
			ExpedienteComercial expediente = expedienteComercialManager.findOneByNumExpediente(numExpediente);
			
			try {
				
				File file = facturaVentaApi.getFacturaVenta(expediente);
				reportApi.sendReport(file, response);
			
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
}

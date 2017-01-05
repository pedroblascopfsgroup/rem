package es.pfsgroup.plugin.rem.controller;

import java.io.File;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ParamReportsApi;
import es.pfsgroup.plugin.rem.api.PropuestaOfertaApi;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaSimpleDto;
import es.pfsgroup.plugin.rem.rest.dto.PropuestaRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.utils.FileUtilsREM;

@Controller
public class PropuestaresolucionController {

		final String templatePropuestaSimple = "PropuestaResolucionActivoSimple";
		final String templatePropuestaLote = "PropuestaResolucionAgrupacion";
		final String templatePropuestaActivoLote = "PropuestaResolucionActivoLote";
		
	
		@Autowired
		private RestApi restApi;
		
		@Autowired
		private PropuestaOfertaApi propuestaOfertaApi;
		
		@Autowired
		private ParamReportsApi paramReportsApi;
		
		@Autowired 
		private OfertaApi ofertaApi;
		
		private final Log logger = LogFactory.getLog(getClass());
		
		@SuppressWarnings("unchecked")
		@RequestMapping(method = RequestMethod.POST, value = "/propuestaresolucion")
		public void propuestaResolucion(ModelMap model, RestRequestWrapper request,HttpServletResponse response) throws ParseException {				
			PropuestaRequestDto jsonData = null;
			OfertaSimpleDto propuestaDto = null;			
			Map<String, Object> params = null;
			List<Object> dataSource = null;				
			Map<String, Object> listaRespuesta = null;
			HashMap<String, String> errorsList = null;
			JSONObject jsonFields = null;
			Oferta oferta = null;
			List<ActivoOferta> listaActivos = null;
			ActivoOferta activoOferta = null;
			File file = null;
			List<File> files = new ArrayList<File>();	
					
			try {
				
				jsonFields = request.getJsonObject();
				logger.debug("PETICIÓN: " + jsonFields);
				
				jsonData = (PropuestaRequestDto) request.getRequestData(PropuestaRequestDto.class);
				propuestaDto = jsonData.getData();
	
				if (Checks.esNulo(jsonFields) && jsonFields.isEmpty()) {
					throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
	
				} else {
	
					errorsList = propuestaOfertaApi.validatePropuestaOfertaRequestData(propuestaDto, jsonFields);
					if(!Checks.esNulo(errorsList) && errorsList.isEmpty()){
						
						oferta = ofertaApi.getOfertaByNumOfertaRem(propuestaDto.getOfertaHRE());	
						listaActivos = oferta.getActivosOferta();
						
						if(!Checks.esNulo(listaActivos) && listaActivos.size()==1){
							//SIMPLE
							//OBTENCION DE LOS DATOS PARA RELLENAR EL DOCUMENTO							
							params = propuestaOfertaApi.paramsHojaDatos(listaActivos.get(0), model);
							dataSource = propuestaOfertaApi.dataSourceHojaDatos(listaActivos.get(0), model);
							
							//GENERACION DEL DOCUMENTO EN PDF								
							file = propuestaOfertaApi.getPDFFile(params, dataSource, templatePropuestaSimple, model);
							files.add(file);
							
						}else if(!Checks.esNulo(listaActivos) && listaActivos.size()>1){
							//LOTE 
							//OBTENCION DE LOS DATOS PARA RELLENAR EL DOCUMENTO
							params = propuestaOfertaApi.paramsHojaDatos(listaActivos.get(0),  model);
							dataSource = propuestaOfertaApi.dataSourceHojaDatos(listaActivos.get(0), model);	
							
							//GENERACION DEL DOCUMENTO EN PDF DEL LOTE		
							file = propuestaOfertaApi.getPDFFile(params, dataSource, templatePropuestaLote, model);
							files.add(file);
													
							//GENERAMOS EL DOCUMENTO PDF DE CADA ACTIVO
							for(int i=0; i<listaActivos.size(); i++){							
								activoOferta = listaActivos.get(i);
								params = propuestaOfertaApi.paramsHojaDatos(activoOferta,  model);
								dataSource = propuestaOfertaApi.dataSourceHojaDatos(activoOferta, model);								
								file = propuestaOfertaApi.getPDFFile(params, dataSource, templatePropuestaActivoLote, model);
								files.add(file);
							}
								
						}
						File salida = File.createTempFile("jasper", ".pdf");
						FileUtilsREM.concatenatePdfs(files, salida);
						
						
						//ENVIO DE LOS DATOS DEL DOCUMENTO AL CLIENTE
						listaRespuesta = propuestaOfertaApi.sendFileBase64(response, salida, model);

						model.put("id", jsonFields.get("id"));
						model.put("data", listaRespuesta);
						model.put("error", "");
						
						
					}else{
						model.put("id", jsonFields.get("id"));
						model.put("data", null);
						model.put("error", errorsList);
					}
				}

			} catch (Exception e) {
				logger.error(e);
				request.getPeticionRest().setErrorDesc(e.getMessage());
				model.put("id", jsonFields.get("id"));
				model.put("data", listaRespuesta);
				model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
			} finally {
				logger.debug("RESPUESTA: " + model);
			}
			restApi.sendResponse(response, model,request);

		}
			
}

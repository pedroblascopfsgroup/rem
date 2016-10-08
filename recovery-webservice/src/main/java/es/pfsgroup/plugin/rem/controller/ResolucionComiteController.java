package es.pfsgroup.plugin.rem.controller;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.databind.JsonMappingException;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ResolucionComiteApi;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class ResolucionComiteController {
	
	@Autowired
	private ResolucionComiteApi resolucionComiteApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private RestApi restApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/resolucioncomite")
	public void resolucionComite(ModelMap model, RestRequestWrapper request,HttpServletResponse response) {

		ResolucionComiteRequestDto jsonData = null;
		ResolucionComiteDto resolucionComiteDto = null;
		
		try {
			jsonData = (ResolucionComiteRequestDto) request.getRequestData(ResolucionComiteRequestDto.class);
			resolucionComiteDto = jsonData.getData();
			
			if( Checks.esNulo(jsonData) || resolucionComiteDto == null) {
				throw new Exception("No se han podido recuperar los datos de la petición. Peticion mal estructurada.");
			}
			
			Long ofertaHRE = resolucionComiteDto.getOfertaHRE();
			if (ofertaHRE == null) {
				throw new Exception("No se han podido recuperar los datos de la petición. El valor de ofertaHRE es vacio.");
			} else {
				Oferta oferta = ofertaApi.getOfertaByNumOfertaRem(ofertaHRE);
				if (oferta==null) {
					throw new Exception("No se han podido recuperar los datos de la petición. El valor de ofertaHRE no coincide con ninguna Oferta.");
				}
			}

			if (ResolucionComiteApi.RESOLUCION_APROBADA.equals(resolucionComiteDto.getCodigoResolucion())) {
				resolucionComiteApi.aprobada(resolucionComiteDto);
			} else if (ResolucionComiteApi.RESOLUCION_DENEGADA.equals(resolucionComiteDto.getCodigoResolucion())) {
				resolucionComiteApi.denegada(resolucionComiteDto);
			} else if (ResolucionComiteApi.RESOLUCION_CONTRAOFERTA.equals(resolucionComiteDto.getCodigoResolucion())) {
				resolucionComiteApi.contraofertada(resolucionComiteDto);
			}
			model.put("id", jsonData.getId());	
			
		} catch (JsonMappingException e1) {
			e1.printStackTrace();
			model.put("id", null);	
			model.put("error", "Los datos enviados en la petición no están correctamente formateados. Comprueba que las fecha sean 'yyyy-MM-dd'T'HH:mm:ss'. ");
		} catch (Exception e2) {			
			e2.printStackTrace();
			model.put("id", jsonData.getId());	
			model.put("error", e2.getMessage());
		}
	
		restApi.sendResponse(response, model);
		
	}
	
}
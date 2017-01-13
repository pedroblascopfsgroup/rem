package es.pfsgroup.plugin.rem.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.api.ConfirmarOperacionApi;
import es.pfsgroup.plugin.rem.api.ReintegroApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.ConfirmacionOpDto;
import es.pfsgroup.plugin.rem.rest.dto.ConfirmacionOpRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class ConfirmacionoperacionController {


	@Autowired
	private RestApi restApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ReintegroApi reintegroApi;
	
	@Autowired
	private ConfirmarOperacionApi confirmarOperacionApi;
	

	private final Log logger = LogFactory.getLog(getClass());

	@SuppressWarnings("unchecked")
	@Transactional(readOnly = false)
	@RequestMapping(method = RequestMethod.POST, value = "/confirmacionoperacion")
	public void reservaInmuebleOld(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		ConfirmacionOpRequestDto jsonData = null;
		ConfirmacionOpDto confirmacionOpDto = null;
		JSONObject jsonFields = null;
		HashMap<String, String> errorList = null;

		try {

			jsonFields = request.getJsonObject();
			logger.debug("PETICIÓN: " + jsonFields);

			jsonData = (ConfirmacionOpRequestDto) request.getRequestData(ConfirmacionOpRequestDto.class);
			confirmacionOpDto = jsonData.getData();

			
			errorList = confirmarOperacionApi.validateConfirmarOperacionPostRequestData(confirmacionOpDto, jsonFields);
			if (errorList != null && errorList.isEmpty()) {

				if(!Checks.esNulo(confirmacionOpDto.getResultado()) && confirmacionOpDto.getResultado().equals(Integer.valueOf(0))){
					//Accion realizada y procesada en Uvem. Realizar acciones pertinentes en REM
					
					if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.COBRO_RESERVA)){
						confirmarOperacionApi.cobrarReserva(confirmacionOpDto);
						
					}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.COBRO_VENTA)){					
						confirmarOperacionApi.cobrarVenta(confirmacionOpDto);
						
					}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.DEVOLUCION_RESERVA)){
						confirmarOperacionApi.devolverReserva(confirmacionOpDto);					
						
					}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.REINTEGRO_RESERVA)){					
						confirmarOperacionApi.reintegrarReserva(confirmacionOpDto);

					}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_COBRO_RESERVA)){
						//Not implemented yet
						confirmarOperacionApi.anularCobroReserva(confirmacionOpDto);
						
					}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_COBRO_VENTA)){
						//Not implemented yet
						confirmarOperacionApi.anularCobroVenta(confirmacionOpDto);
						
					}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_DEVOLUCION_RESERVA)){
						//Not implemented yet
						confirmarOperacionApi.anularDevolucionReserva(confirmacionOpDto);
						
					}	
				}

				model.put("id", jsonFields.get("id"));
				model.put("error", "");
			} else {
				model.put("id", jsonFields.get("id"));
				model.put("error", errorList);
			}

		} catch (Exception e) {
			logger.error(e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", jsonFields.get("id"));
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
		} finally {
			logger.debug("RESPUESTA: " + model);
		}

		restApi.sendResponse(response, model, request);
	}
}

package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

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
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ConfirmarOperacionApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.ConfirmacionOpDto;
import es.pfsgroup.plugin.rem.rest.dto.ConfirmacionOpRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Controller
public class ConfirmacionoperacionController {


	@Autowired
	private RestApi restApi;

	@Autowired
	private ConfirmarOperacionApi confirmarOperacionApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private UpdaterStateApi updaterState;
	
	@Autowired
	private ActivoAdapter activoAdapterApi;

	private final Log logger = LogFactory.getLog(getClass());

	@SuppressWarnings("unchecked")
	@Transactional(readOnly = false)
	@RequestMapping(method = RequestMethod.POST, value = "/confirmacionoperacion")
	public void reservaInmuebleOld(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		ConfirmacionOpRequestDto jsonData = null;
		ConfirmacionOpDto confirmacionOpDto = null;
		JSONObject jsonFields = null;
		HashMap<String, String> errorList = null;
		List <ActivoOferta> listaAofr = new ArrayList<ActivoOferta>();
		
		try {

			jsonFields = request.getJsonObject();
			
			jsonData = (ConfirmacionOpRequestDto) request.getRequestData(ConfirmacionOpRequestDto.class);
			confirmacionOpDto = jsonData.getData();

			
			errorList = confirmarOperacionApi.validateConfirmarOperacionPostRequestData(confirmacionOpDto, jsonFields);
			if (errorList != null && errorList.isEmpty()) {

				if(!Checks.esNulo(confirmacionOpDto.getResultado()) && confirmacionOpDto.getResultado().equals(Integer.valueOf(0))){
					//Accion realizada y procesada en Uvem. Realizar acciones pertinentes en REM
					
					if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.COBRO_RESERVA)){
						//Por activo
						confirmarOperacionApi.cobrarReserva(confirmacionOpDto);
						
					}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.COBRO_VENTA)){	
						//Por activo
						confirmarOperacionApi.cobrarVenta(confirmacionOpDto);
						
					}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.DEVOLUCION_RESERVA)){
						//Por activo
						confirmarOperacionApi.devolverReserva(confirmacionOpDto);					
						
					}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.REINTEGRO_RESERVA)){	
						//Por oferta
						confirmarOperacionApi.reintegrarReserva(confirmacionOpDto);
						
					}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_COBRO_RESERVA)){
						//Por activo
						confirmarOperacionApi.anularCobroReserva(confirmacionOpDto);
						
					}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_COBRO_VENTA)){
						//Por activo
						confirmarOperacionApi.anularCobroVenta(confirmacionOpDto);
						
					}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_DEVOLUCION_RESERVA)){
						//Por activo
						confirmarOperacionApi.anularDevolucionReserva(confirmacionOpDto);
					}		
					
					ArrayList<Long> idActivoActualizarPublicacion = new ArrayList<Long>();
					// Actualizamos la situacion comercial del activo
					if(!Checks.esNulo(confirmacionOpDto.getActivo())){
						Activo activo = activoApi.getByNumActivoUvem(confirmacionOpDto.getActivo());
						if(!Checks.esNulo(activo)){
							updaterState.updaterStateDisponibilidadComercialAndSave(activo);
						}
						idActivoActualizarPublicacion.add(activo.getId());
					}else{
						if(!Checks.esNulo(confirmacionOpDto.getOfertaHRE())){
							Oferta oferta = ofertaApi.getOfertaByNumOfertaRem(confirmacionOpDto.getOfertaHRE());
							if (!Checks.esNulo(oferta)) {
								listaAofr = oferta.getActivosOferta();
								if(!Checks.esNulo(listaAofr) && listaAofr.size()>0){
									for(int i = 0; i< listaAofr.size(); i++){
										Activo activo = listaAofr.get(i).getPrimaryKey().getActivo();
										idActivoActualizarPublicacion.add(activo.getId());
										if(!Checks.esNulo(activo)){
											updaterState.updaterStateDisponibilidadComercialAndSave(activo);
										}
									}
								}
							}
						}					
					}	
					activoAdapterApi.actualizarEstadoPublicacionActivo(idActivoActualizarPublicacion,true);
				}

				model.put("id", jsonFields.get("id"));
				model.put("error", "");
			} else {
				model.put("id", jsonFields.get("id"));
				model.put("error", errorList);
			}

		} catch (Exception e) {
			logger.error("Error confirmacion operacion", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", jsonFields.get("id"));
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
		}

		restApi.sendResponse(response, model, request);
	}
}

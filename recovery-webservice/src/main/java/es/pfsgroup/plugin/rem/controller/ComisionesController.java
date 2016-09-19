package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.agenda.adapter.NotificacionAdapter;
import es.pfsgroup.plugin.rem.api.GastosExpedienteApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.ComisionDto;
import es.pfsgroup.plugin.rem.rest.dto.ComisionRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class ComisionesController {

	
	@Autowired
	private GastosExpedienteApi gastosExpedienteApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private NotificacionAdapter notificacionAdapter;
	
	@Autowired
	private RestApi restApi;

	
	
	
	/**
	 * Actualiza una lista de Comisiones para dar aceptación o no a las mismas Ejem: IP:8080/pfs/rest/comisiones
	 * HEADERS:
	 * Content-Type - application/json
	 * signature - sdgsdgsdgsdg
	 * 
	 * BODY:
	 * {"id":"111111112113","data": [{"idVisitaWebcom": "1", "idClienteRem": "2", "idActivoHaya": "0", "codEstadoVisita": "04","codDetalleEstadoVisita": "04", "fecha": "2016-01-01T10:10:10", "idUsuarioRem": "1", "idProveedorRemPrescriptor": "5045",  "idProveedorRemCustodio": "1010", "idProveedorRemResponsable": "1010", "idProveedorRemFdv": "1010" , "idProveedorRemVisita": "1010", "observaciones": "updated1" }]}
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/comisiones")
	public ModelAndView updateAceptacionGasto(ModelMap model, RestRequestWrapper request) {
		ComisionRequestDto jsonData = null;
		List<String> errorsList = null;
		GastosExpediente gasto = null;
		
		ComisionDto comisionDto = null;
		Map<String, Object> map = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		JSONObject jsonFields = null;
		
		try {

			jsonData = (ComisionRequestDto) request.getRequestData(ComisionRequestDto.class);
			List<ComisionDto> listaComisionDto = jsonData.getData();			
			jsonFields = request.getJsonObject();

			
			if(Checks.esNulo(jsonFields) && jsonFields.isEmpty()){
				throw new Exception("No se han podido recuperar los datos de la petición. Peticion mal estructurada.");
				
			}else{
				
				for(int i=0; i < listaComisionDto.size();i++){
					
					errorsList = new ArrayList<String>();
					map = new HashMap<String, Object>();
					comisionDto = listaComisionDto.get(i);
					
					gasto = gastosExpedienteApi.findOne(comisionDto.getIdHonorarioRem());		
					if(Checks.esNulo(gasto)){
						errorsList.add("No existe en REM el idHonorarioRem: " + comisionDto.getIdHonorarioRem() + ". No se actualizará.");

					}else{
						errorsList = gastosExpedienteApi.updateAceptacionGasto(gasto, comisionDto, jsonFields.getJSONArray("data").get(i));
						/*if(!Checks.esNulo(errorsList) && errorsList.isEmpty() && !Checks.esNulo(comisionDto.getAceptacion()) && !comisionDto.getAceptacion()){
							//Si no aceptada -> comunicarlo al gestor comercial del activo para que actúe en consecuencia mediante una tarea
					       
							Notificacion notificacion = new Notificacion();
					        if(!Checks.esNulo(gasto.getExpediente()) && !Checks.esNulo(gasto.getExpediente().getOferta()) 
					        	&& !Checks.esNulo(gasto.getExpediente().getOferta().getActivoPrincipal())){

					        	Activo act = gasto.getExpediente().getOferta().getActivoPrincipal();
					        	if(!Checks.esNulo(act)){
						        	notificacion.setIdActivo(act.getId());
						        	
						        	Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_SUPERVISOR_ADMISION);
									gestor = gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), genericDao.get(EXTDDTipoGestor.class, filtro).getId());
						        	Usuario userDest = gestorActivoApi.getGestorByActivoYTipo(act, GestorActivoApi.CODIGO_GESTOR_MARKETING);
						        	if(!Checks.esNulo(userDest)){
						        		notificacion.setDestinatario(userDest.getId());
						        	}
						        	notificacion.setTitulo("Rechazo honorario");
						        	notificacion.setDescripcion(comisionDto.getObservaciones());
						        	notificacion.setStrFecha(new Date().toString());
						        	
						        	notificacionAdapter.saveNotificacion(notificacion);		
					        	}
				        	}
				        }*/
					}
														
					if(!Checks.esNulo(errorsList) && errorsList.isEmpty() && !Checks.esNulo(gasto)){	
						map.put("idHonorarioWebcom", gasto.getIdWebCom());
						map.put("idHonorarioRem", gasto.getId());
						map.put("success", true);
					}else{
						map.put("idHonorarioWebcom", comisionDto.getIdHonorarioWebcom());
						map.put("idHonorarioRem", comisionDto.getIdHonorarioRem());
						map.put("success", false);
						map.put("errorMessages", errorsList);
					}					
					listaRespuesta.add(map);	
					
				}
			
				model.put("id", jsonData.getId());	
				model.put("data", listaRespuesta);
				model.put("error", "");
				
			}

		} catch (Exception e) {
			e.printStackTrace();
			model.put("id", jsonData.getId());	
			model.put("data", listaRespuesta);
			model.put("error", e.getMessage().toUpperCase());
		}

		return new ModelAndView("jsonView", model);
	}
	

	


}

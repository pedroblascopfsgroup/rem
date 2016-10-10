package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.GastosExpedienteApi;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.ComisionDto;
import es.pfsgroup.plugin.rem.rest.dto.ComisionRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import net.sf.json.JSONObject;

@Controller
public class ComisionesController {

	@Autowired
	private GastosExpedienteApi gastosExpedienteApi;

		@Autowired
	private RestApi restApi;

	private final Log logger = LogFactory.getLog(getClass());

	/**
	 * Actualiza una lista de Comisiones para dar aceptación o no a las mismas
	 * Ejem: IP:8080/pfs/rest/comisiones HEADERS: Content-Type -
	 * application/json signature - sdgsdgsdgsdg
	 * 
	 * BODY: {"id":"111111112113","data": [{"idVisitaWebcom": "1",
	 * "idClienteRem": "2", "idActivoHaya": "0", "codEstadoVisita":
	 * "04","codDetalleEstadoVisita": "04", "fecha": "2016-01-01T10:10:10",
	 * "idUsuarioRem": "1", "idProveedorRemPrescriptor": "5045",
	 * "idProveedorRemCustodio": "1010", "idProveedorRemResponsable": "1010",
	 * "idProveedorRemFdv": "1010" , "idProveedorRemVisita": "1010",
	 * "observaciones": "updated1" }]}
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/comisiones")
	public void updateAceptacionGasto(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		ComisionRequestDto jsonData = null;
		List<String> errorsList = null;
		List<GastosExpediente> listaGastos = null;

		ComisionDto comisionDto = null;
		Map<String, Object> map = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		JSONObject jsonFields = null;

		try {

			jsonData = (ComisionRequestDto) request.getRequestData(ComisionRequestDto.class);
			List<ComisionDto> listaComisionDto = jsonData.getData();
			jsonFields = request.getJsonObject();
			logger.debug("PETICIÓN: " + jsonFields);

			if (Checks.esNulo(jsonFields) && jsonFields.isEmpty()) {
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);

			} else {

				for (int i = 0; i < listaComisionDto.size(); i++) {

					errorsList = new ArrayList<String>();
					map = new HashMap<String, Object>();
					comisionDto = listaComisionDto.get(i);

					// gasto =
					// gastosExpedienteApi.findOne(comisionDto.getIdHonorarioRem());
					listaGastos = gastosExpedienteApi.getListaGastosExpediente(comisionDto);
					if (Checks.esNulo(listaGastos) || (!Checks.esNulo(listaGastos) && listaGastos.size() != 1)) {
						throw new Exception(RestApi.REST_MSG_UNKNOWN_KEY);

						/*
						 * errorsList.add(
						 * "No existe en REM la comisión con los siguientes datos: idOfertaRem-"
						 * + comisionDto.getIdOfertaRem() + " idOfertaWebcom-" +
						 * comisionDto.getIdOfertaWebcom() + " idProveedorRem-"
						 * + comisionDto.getIdProveedorRem() +
						 * " esPrescripcion-" + comisionDto.getEsPrescripcion()
						 * + " esColaboracion-" +
						 * comisionDto.getEsColaboracion() + " esResponsable-" +
						 * comisionDto.getEsResponsable() + " esFdv-" +
						 * comisionDto.getEsFdv() +
						 * ". No se actualizará la comisión.");
						 */

					} else {
						errorsList = gastosExpedienteApi.updateAceptacionGasto(listaGastos.get(0), comisionDto,
								jsonFields.getJSONArray("data").get(i));
						/*
						 * if(!Checks.esNulo(errorsList) && errorsList.isEmpty()
						 * && !Checks.esNulo(comisionDto.getAceptacion()) &&
						 * !comisionDto.getAceptacion()){ //Si no aceptada ->
						 * comunicarlo al gestor comercial del activo para que
						 * actúe en consecuencia mediante una tarea
						 * 
						 * Notificacion notificacion = new Notificacion();
						 * if(!Checks.esNulo(gasto.getExpediente()) &&
						 * !Checks.esNulo(gasto.getExpediente().getOferta()) &&
						 * !Checks.esNulo(gasto.getExpediente().getOferta().
						 * getActivoPrincipal())){
						 * 
						 * Activo act =
						 * gasto.getExpediente().getOferta().getActivoPrincipal(
						 * ); if(!Checks.esNulo(act)){
						 * notificacion.setIdActivo(act.getId());
						 * 
						 * Filter filtro =
						 * genericDao.createFilter(FilterType.EQUALS, "codigo",
						 * GestorActivoApi.CODIGO_SUPERVISOR_ADMISION); gestor =
						 * gestorActivoApi.getGestorByActivoYTipo(tareaActivo.
						 * getActivo(), genericDao.get(EXTDDTipoGestor.class,
						 * filtro).getId()); Usuario userDest =
						 * gestorActivoApi.getGestorByActivoYTipo(act,
						 * GestorActivoApi.CODIGO_GESTOR_MARKETING);
						 * if(!Checks.esNulo(userDest)){
						 * notificacion.setDestinatario(userDest.getId()); }
						 * notificacion.setTitulo("Rechazo honorario");
						 * notificacion.setDescripcion(comisionDto.
						 * getObservaciones()); notificacion.setStrFecha(new
						 * Date().toString());
						 * 
						 * notificacionAdapter.saveNotificacion(notificacion); }
						 * } }
						 */
					}

					if (!Checks.esNulo(errorsList) && errorsList.isEmpty() && !Checks.esNulo(listaGastos)) {
						map.put("idOfertaWebcom", listaGastos.get(0).getExpediente().getOferta().getIdWebCom());
						map.put("idOfertaRem", listaGastos.get(0).getExpediente().getOferta().getNumOferta());
						map.put("success", true);
					} else {
						map.put("idOfertaWebcom", comisionDto.getIdOfertaWebcom());
						map.put("idOfertaRem", comisionDto.getIdOfertaRem());
						map.put("success", false);
						// map.put("errorMessages", errorsList);
					}
					listaRespuesta.add(map);

				}

				model.put("id", jsonData.getId());
				model.put("data", listaRespuesta);
				model.put("error", "null");

			}

		} catch (Exception e) {
			logger.error(e);
			model.put("id", jsonData.getId());
			model.put("data", listaRespuesta);
			model.put("error", e.getMessage().toUpperCase());
		} finally {
			logger.debug("RESPUESTA: " + model);
			logger.debug("ERRORES: " + errorsList);
		}

		restApi.sendResponse(response, model);
	}

}

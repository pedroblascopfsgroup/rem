package es.pfsgroup.plugin.rem.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.rest.api.RestManager;
import es.pfsgroup.plugin.rem.rest.dto.RequestVisitaDto;
import es.pfsgroup.plugin.rem.rest.dto.VisitaDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class VisitasController {

	@Autowired
	private RestManager restManager;
	
	@Autowired 
    private ActivoApi activoApi;

	/**
	 * Inserta o actualiza una visita Ejem:
	 * {"id":"109238120575","data":[{"idClienteRem":"22","idVisitaWebcom":"45",
	 * "idEstadoVisita":"1","idTipoPrescriptor":"1","fecha":"365299200",
	 * "idActivoHaya":"33","idDetalleEstadoVisita":"44","prescriptor":"presc",
	 * "idUsuarioRem":"22"}]}
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/visitas")
	public ModelAndView insertUpdateVisita(ModelMap model, RestRequestWrapper request) {
		try {

			RequestVisitaDto jsonData = (RequestVisitaDto) request.getRequestData(RequestVisitaDto.class);
			for (VisitaDto visita : jsonData.getData()) {
				List<String> error = restManager.validateRequestObject(visita);
				if (error.isEmpty()) {
					
					Visita visitaBbdd = new Visita();
					visitaBbdd.setId(visita.getIdVisitaRem());
					//cli_clientes
					visitaBbdd.setCliente(null);
					
					activoApi.insertOrUpdateVisitaActivo(visitaBbdd);
					
					model.put("id", jsonData.getId());
					model.put("data", "hola mon update");
				} else {
					model.put("id", jsonData.getId());
					model.put("error", error);
				}
			}

		} catch (Exception e) {
			model.put("error", e);
		}

		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET, value = "/visitas")
	public ModelAndView getVisita(ModelMap model, RestRequestWrapper request) {
		try {

			RequestVisitaDto jsonData = (RequestVisitaDto) request.getRequestData(RequestVisitaDto.class);

			model.put("id", jsonData.getId());
			model.put("data", "hola mon get");
		} catch (Exception e) {
			model.put("data", e);
		}

		return new ModelAndView("jsonView", model);
	}

}

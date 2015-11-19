package es.pfsgroup.recovery.cajamar.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.pfsgroup.recovery.hrebcc.api.RiesgoOperacionalApi;
import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.hrebcc.model.DDRiesgoOperacional;

@Controller
public class RiesgoOperacionalController {
	
	private final String JSP_EDITAR_RIESGO_OPERACIONAL = "plugin/cajamarhre/contratos/tabs/editRiesgoOperacional";
	
	@Autowired
	private RiesgoOperacionalApi riesgoOperacionalManager;
	
	@RequestMapping
	public void ActualizarRiesgoOperacional(ActualizarRiesgoOperacionalDto dto) {
		riesgoOperacionalManager.ActualizarRiesgoOperacional(dto);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping 
	public String ObtenerRiesgoOperacionalContrato(Long cntId, ModelMap map) {
		DDRiesgoOperacional riesgoOperacional = riesgoOperacionalManager.ObtenerRiesgoOperacionalContrato(cntId);
		map.put("riesgoOperacional", riesgoOperacional);
		
		return JSP_EDITAR_RIESGO_OPERACIONAL;
	}

}

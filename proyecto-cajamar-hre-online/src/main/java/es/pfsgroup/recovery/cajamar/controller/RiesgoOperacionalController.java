package es.pfsgroup.recovery.cajamar.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.hrebcc.api.RiesgoOperacionalApi;
import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.hrebcc.model.DDRiesgoOperacional;

@Controller
public class RiesgoOperacionalController {
	
	private final String JSP_EDITAR_RIESGO_OPERACIONAL = "plugin/cajamarhre/contratos/tabs/editRiesgoOperacional";
	
	@Autowired
	private RiesgoOperacionalApi riesgoOperacionalManager;
	
	@Autowired
	UtilDiccionarioApi utilDiccionario;
	
	@RequestMapping
	public void ActualizarRiesgoOperacional(ActualizarRiesgoOperacionalDto dto) {
		riesgoOperacionalManager.ActualizarRiesgoOperacional(dto);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping 
	public String ObtenerRiesgoOperacionalContrato(Long cntId, ModelMap map) {
		DDRiesgoOperacional riesgoOperacional = riesgoOperacionalManager.ObtenerRiesgoOperacionalContrato(cntId);
		
		ArrayList<DDRiesgoOperacional> ddRiesgoOperacional = (ArrayList<DDRiesgoOperacional>) utilDiccionario.dameValoresDiccionario(DDRiesgoOperacional.class);
		
		map.put("ddriesgoOperacional", ddRiesgoOperacional);
		map.put("riesgoOperacional", riesgoOperacional);
		
		return JSP_EDITAR_RIESGO_OPERACIONAL;
	}

}

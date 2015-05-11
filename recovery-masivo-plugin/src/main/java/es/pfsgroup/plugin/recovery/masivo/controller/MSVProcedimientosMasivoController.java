package es.pfsgroup.plugin.recovery.masivo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.ProcedimientoApi;

@Controller
public class MSVProcedimientosMasivoController {
	
	public static final String JSON_LISTA_DEUDORES = "plugin/masivo/procedimientoMonitorioMasivo/listaDeudoresProcedimientoJSON";

	@Autowired
	private ApiProxyFactory apiProxyFactory;
	
	/*
	 * Devuelve la lista de deudores de un procedimiento a partir de su id
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String listaDemandadosProcedimientoData(Long id, ModelMap model){
		
		Procedimiento p = apiProxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(id);
		List<Persona> demandados=p.getPersonasAfectadas();
		model.put("demandados", demandados);
		
		return JSON_LISTA_DEUDORES;
	}
}

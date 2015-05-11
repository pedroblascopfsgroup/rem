package es.pfsgroup.recovery.geninformes.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.geninformes.api.GENINFGenerarEscritosApi;
import es.pfsgroup.recovery.geninformes.model.GENINFInformeTPO;

@Controller
public class GENINFGenerarEscritosController {

	@Autowired
	private ApiProxyFactory apiProxy;
	

	public static final String JSP_VENTANA_GENERAR_ESCRITOS = "plugin/geninformes/window/generarEscritos";
	public static final String JSON_ESCRITOS_TIPO_PROC = "plugin/geninformes/window/listaEscritosTipoProcJSON"; 

	@RequestMapping
	public String abreFormSeleccion(Long idAsunto, ModelMap model){
		
//		List<TipoProcedimiento> tiposProcedimiento = new ArrayList<TipoProcedimiento>();
//		Asunto asunto = apiProxy.proxy(AsuntoApi.class).get(idAsunto);
//		List<Procedimiento> procedimientos = asunto.getProcedimientos();
//		for (Procedimiento procedimiento : procedimientos) {
//			tiposProcedimiento.add(procedimiento.getTipoProcedimiento());
//		}
		
//		model.put("tiposProc", tiposProcedimiento);
//		model.put("idAsunto", idAsunto);
		
		return JSP_VENTANA_GENERAR_ESCRITOS;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getEscritos(Long id, ModelMap model) {
		Procedimiento procedimiento = apiProxy.proxy(ProcedimientoApi.class).getProcedimiento(id);
		List<GENINFInformeTPO> listInformeTPO = null;
		if (!Checks.esNulo(procedimiento)) {
			listInformeTPO = apiProxy.proxy(GENINFGenerarEscritosApi.class).getEscritosByTPO(procedimiento.getTipoProcedimiento().getId());			
		}
		model.put("escritos", listInformeTPO);
		return JSON_ESCRITOS_TIPO_PROC;
	}
}

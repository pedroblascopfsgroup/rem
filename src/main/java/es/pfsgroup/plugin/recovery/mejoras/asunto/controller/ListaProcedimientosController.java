package es.pfsgroup.plugin.recovery.mejoras.asunto.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;

@Controller
public class ListaProcedimientosController {
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@RequestMapping
	public String getProcedimientosAsuntoOrdenado (@RequestParam(value = "id", required=true)Long id, ModelMap map){
		
		List<Procedimiento> listado = proxyFactory.proxy(AsuntoApi.class).obtenerActuacionesAsunto(id);
		map.put("listado", listado);
		
		return "asuntos/listadoProcedimientosAsuntoJSON";
	}

	@RequestMapping
	public String getTipoProcedimientosAsunto (@RequestParam(value = "id", required=true)Long id, ModelMap map){
		String encontrado="";
		Long idProcedimiento;
		
		List<Procedimiento> listado = proxyFactory.proxy(AsuntoApi.class).obtenerActuacionesAsunto(id);
		
        for (int i = 0; i < listado.size(); i++) {
            String tipo = listado.get(i).getTipoProcedimiento().getCodigo();
            if (tipo.equals(PluginMejorasBOConstants.MEJ_TIPO_PROCEDIMIENTO_BLOQUEADO)) {
            	encontrado="OK";
            }
        }
		
		map.put("respuesta", encontrado);
		
		return "generico/respuestaJSON";
	}
}

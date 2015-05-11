package es.pfsgroup.recovery.ext.impl.adjunto;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.AsuntoApi;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.ext.api.adjunto.AdjuntoAsuntoApi;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Controller
public class AdjuntoAsuntoController {
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@RequestMapping
	public String getTiposDeFicheroAdjuntoAsunto(ModelMap map,Long idAsunto){
		
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		
		List<Procedimiento> listaProcedimiento = asunto.getProcedimientos();
		
		List<DDTipoActuacion> listaActuaciones = new ArrayList<DDTipoActuacion>();
		for(Procedimiento p:listaProcedimiento){
			listaActuaciones.add(p.getTipoActuacion());
		}
		
		List<DDTipoFicheroAdjunto> lista = proxyFactory.proxy(AdjuntoAsuntoApi.class).getList(listaActuaciones);
		map.put("lista", lista);
		return "plugin/coreextension/asunto/ddTipoFicherosAdjuntosJSON";
	}
	
	@RequestMapping
	public String getTiposDeFicheroAdjuntoProcedimiento(ModelMap map,Long idProcedimiento){
		Procedimiento p = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
		
		List<DDTipoActuacion> listaActuaciones = new ArrayList<DDTipoActuacion>();
		listaActuaciones.add(p.getTipoActuacion());
		List<DDTipoFicheroAdjunto> lista = proxyFactory.proxy(AdjuntoAsuntoApi.class).getList(listaActuaciones);
		
		map.put("lista", lista);
		return "plugin/coreextension/asunto/ddTipoFicherosAdjuntosJSON";
	}
}

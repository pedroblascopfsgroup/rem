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
import es.capgemini.pfs.tipoFicheroAdjuntoEntidad.DDTipoAdjuntoEntidad;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.AsuntoApi;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.ext.api.adjunto.AdjuntoAsuntoApi;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Controller
public class AdjuntoAsuntoController {
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@Autowired
	AdjuntoAsuntoApi adjuntoAsuntoManager;
	
	@SuppressWarnings("unchecked")
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
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getTiposDeFicheroAdjuntoProcedimiento(ModelMap map,Long idProcedimiento){
		Procedimiento p = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
		
		List<DDTipoActuacion> listaActuaciones = new ArrayList<DDTipoActuacion>();
		listaActuaciones.add(p.getTipoActuacion());
		List<DDTipoFicheroAdjunto> lista = proxyFactory.proxy(AdjuntoAsuntoApi.class).getList(listaActuaciones);
		
		map.put("lista", lista);
		return "plugin/coreextension/asunto/ddTipoFicherosAdjuntosJSON";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getTiposDeDocumentoAdjuntoProcedimiento(ModelMap map, String tipoEntidad){
		List<DDTipoAdjuntoEntidad> lista = proxyFactory.proxy(AdjuntoAsuntoApi.class).getListTipoAdjuntoEntidad(tipoEntidad);
		map.put("lista", lista);
		return "plugin/coreextension/asunto/ddTipoDocAdjuntosJSON";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String isFechaCaducidadVisible(String codigoFichero, ModelMap map){
	
		boolean res = adjuntoAsuntoManager.esFechaCaducidadVisible(codigoFichero);		
		
		map.put("fechaCaducidadVisible", res);
		return "plugin/coreextension/asunto/fechaCaducidadVisibleJSON";
	} 
	
}

package es.pfsgroup.procedimiento.asignacion.web;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;

@Controller
public class AsignacionGestoresController {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String listTipoProcedimiento(Long idAsunto, ModelMap model){
		List<TipoProcedimiento> listado = new ArrayList<TipoProcedimiento>();
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		if(asunto.getTipoAsunto() != null){
			if(DDTiposAsunto.CONCURSAL.equals(asunto.getTipoAsunto().getCodigo())){
				listado = listTipoProcedimientoPorTipoActuacion("CO");
			} else {
				listado = listTipoProcedimientoMenosTipoActuacion("CO");
			}
		}
		model.put("listado", listado);
		return "procedimientos/listadoTiposProcedimientoJSON";
		
	}
	
	
	public List<TipoProcedimiento> listTipoProcedimientoPorTipoActuacion(String codActuacion){
		return proxyFactory.proxy(coreextensionApi.class).getListTipoProcedimientosPorTipoActuacion(codActuacion);
	}
	
	
	public List<TipoProcedimiento> listTipoProcedimientoMenosTipoActuacion(String codActuacion){
		return proxyFactory.proxy(coreextensionApi.class).getListTipoProcedimientosMenosTipoActuacion(codActuacion);
	}
	
}

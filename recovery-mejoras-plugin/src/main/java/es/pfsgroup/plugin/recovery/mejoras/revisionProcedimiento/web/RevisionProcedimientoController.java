package es.pfsgroup.plugin.recovery.mejoras.revisionProcedimiento.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.api.revisionProcedimientos.RevisionProcedimientoApi;
import es.pfsgroup.plugin.recovery.mejoras.revisionProcedimiento.dto.RevisionProcedimientoDto;

@Controller
public class RevisionProcedimientoController {

	public static final String JSON_PAGE_REVISION_PROCEDIMIENTO  ="plugin/mejoras/asuntos/revisionProcedimiento";
	public static final String JSON_LIST_TIPO_ACTUACION  ="plugin/mejoras/asuntos/revisionProcedimiento/data/tipoActuacionJSON";
	public static final String JSON_LIST_TIPO_PROCEDIMIENTO  ="plugin/mejoras/asuntos/revisionProcedimiento/data/tipoProcedimientoJSON";
	public static final String JSON_LIST_TIPO_TAREA  ="plugin/mejoras/asuntos/revisionProcedimiento/data/tipoTareaJSON";
	public static final String JSON_INSTRUCCIONES  ="plugin/mejoras/asuntos/revisionProcedimiento/data/instruccionesJSON";
	public static final String JSON_LIST_PROCEDIMIENTOS  ="plugin/mejoras/asuntos/revisionProcedimiento/data/procedimientosJSON";
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@RequestMapping
	public String getPageRevisionProcedimiento(Long idAsunto, ModelMap map){
		List<RevisionProcedimientoDto> listadoProcedimientos = proxyFactory.proxy(RevisionProcedimientoApi.class).getListProcedimientosData(idAsunto);
		map.put("listadoProcedimientos",listadoProcedimientos);
		map.put("idAsunto", idAsunto);
		return JSON_PAGE_REVISION_PROCEDIMIENTO;
	}
	
	// revisionprocedimiento/getListTipoActuacionData
	@RequestMapping
	public String getListTipoActuacionData(ModelMap model){
		List<DDTipoActuacion> list = proxyFactory.proxy(RevisionProcedimientoApi.class).getListTipoActuacion();
		model.put("data", list);
		return JSON_LIST_TIPO_ACTUACION;
	}
	
	@RequestMapping
	public String getListTipoProcedimientoData(ModelMap model, Long idTipoAct){
		List<TipoProcedimiento> list = proxyFactory.proxy(RevisionProcedimientoApi.class).getListTipoProcedimiento(idTipoAct);
		model.put("data", list);
		return JSON_LIST_TIPO_PROCEDIMIENTO;
	}

	@RequestMapping
	public String getListTipoTareaData(ModelMap model, Long idTipoPro){
		List<TareaProcedimiento> list = proxyFactory.proxy(RevisionProcedimientoApi.class).getListTipoTarea(idTipoPro);
		model.put("data", list);
		return JSON_LIST_TIPO_TAREA;
	}

	@RequestMapping
	public String getInstruccionesData(ModelMap model, Long idTipoTar){
		String item = proxyFactory.proxy(RevisionProcedimientoApi.class).getInstrucciones(idTipoTar);
		if (item != null)
			item = item.replaceAll("\n\r", "");
		model.put("data",item);
		return JSON_INSTRUCCIONES;
	}

	@RequestMapping
	public String saveRevisionData(RevisionProcedimientoDto dto){
		
		boolean res = proxyFactory.proxy(RevisionProcedimientoApi.class).saveRevision(dto);
		if(res)
			return "default";
		else{
			return "";
		}
	}
	
	@RequestMapping
	public String getListProcedimientosData(ModelMap model, Long idAsunto){
		List<RevisionProcedimientoDto> listadoProcedimientos = proxyFactory.proxy(RevisionProcedimientoApi.class).getListProcedimientosData(idAsunto);
		
		model.put("listadoProcedimientos",listadoProcedimientos);
		return JSON_LIST_PROCEDIMIENTOS;
	}
	
}

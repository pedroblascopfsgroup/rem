package es.pfsgroup.plugin.recovery.liquidaciones.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.pfsgroup.plugin.recovery.liquidaciones.api.ContabilidadCobrosApi;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.DtoContabilidadCobros;
import es.pfsgroup.plugin.recovery.liquidaciones.excepciones.STAContabilidadException;
import es.pfsgroup.plugin.recovery.liquidaciones.model.ContabilidadCobros;

/**
 * Controlador que atiende las peticiones de la pestaña de Contabilidad Cobros.
 * 
 */
@Controller
public class ContabilidadCobrosController {

	private static final String CONTABILIDAD_COBROS_JSON = "plugin/liquidaciones/listadoContabilidadCobrosJSON";
	private static final String NEW_CONTABILIDAD_COBRO = "plugin/liquidaciones/contabilidadCobro";
	private static final String JSON_RESPUESTA  ="plugin/liquidaciones/respuestaJSON";
	private static final String DEFAULT = "default";

	
	@Autowired
	private ContabilidadCobrosApi contabilidadCobrosApi;
	
	@Autowired
	private DictionaryManager dictionary;
	
	@Resource
	private MessageService messageService;

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListadoContabilidadCobros(ModelMap model, DtoContabilidadCobros dto) {

		List<ContabilidadCobros> list = (List<ContabilidadCobros>) contabilidadCobrosApi.getListadoContabilidadCobros(dto);
		model.put("listado", list);

		return CONTABILIDAD_COBROS_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String showNewContabilidadCobro(ModelMap model, Long idAsunto) {

		List<Dictionary> tipoEntrega = dictionary.getList("DDAdjContableTipoEntrega");
		model.put("ddTipoEntrega", tipoEntrega);
		
		List<Dictionary> conceptoEntrega = dictionary.getList("DDAdjContableConceptoEntrega");
		model.put("ddConceptoEntrega", conceptoEntrega);
		
		model.put("idAsunto", idAsunto);
		
		return NEW_CONTABILIDAD_COBRO;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String showEditContabilidadCobro(ModelMap model, DtoContabilidadCobros dto, Long asunto) {

		List<Dictionary> tipoEntrega = dictionary.getList("DDAdjContableTipoEntrega");
		model.put("ddTipoEntrega", tipoEntrega);
		
		List<Dictionary> conceptoEntrega = dictionary.getList("DDAdjContableConceptoEntrega");
		model.put("ddConceptoEntrega", conceptoEntrega);
		
		ContabilidadCobros cc = (ContabilidadCobros) contabilidadCobrosApi.getContabilidadCobroByID(dto);
		model.put("contabilidadCobro", cc);
		
		model.put("idAsunto", asunto);
		
		return NEW_CONTABILIDAD_COBRO;
	}
	

	@RequestMapping
	public String saveContabilidadCobro(ModelMap model, DtoContabilidadCobros dto) {

		contabilidadCobrosApi.saveContabilidadCobro(dto);
		
		return DEFAULT;
	}
	
	@RequestMapping
	public String deleteContabilidadCobro(ModelMap model, DtoContabilidadCobros dto) {

		contabilidadCobrosApi.deleteContabilidadCobro(dto.getId());
		
		return DEFAULT;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String crearNuevaTarea(ModelMap model, DtoGenerarTarea dto) {
		try{
			contabilidadCobrosApi.crearTarea(dto);
		}catch(STAContabilidadException e){
			model.put("message", messageService.getMessage("contabilidad.cobros.mensaje.error.staContabilidadCobros",null));
			model.put("msgOK", false);
		}
		
		model.put("message", messageService.getMessage("contabilidad.msgNuevaTareaInfo",null));
		model.put("msgOK", true);
		
		return JSON_RESPUESTA;
	}
}

package es.pfsgroup.plugin.recovery.liquidaciones.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.pfsgroup.plugin.recovery.liquidaciones.api.ContabilidadCobrosApi;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.DtoContabilidadCobros;
import es.pfsgroup.plugin.recovery.liquidaciones.model.ContabilidadCobros;

/**
 * Controlador que atiende las peticiones de la pestaña de Contabilidad Cobros.
 * 
 */
@Controller
public class ContabilidadCobrosController {

	static final String CONTABILIDAD_COBROS_JSON = "plugin/liquidaciones/listadoContabilidadCobrosJSON";
	static final String NEW_CONTABILIDAD_COBRO = "plugin/liquidaciones/contabilidadCobro";
	private static final String DEFAULT = "default";

	
	@Autowired
	private ContabilidadCobrosApi contabilidadCobrosManager;
	
	@Autowired
	private DictionaryManager dictionary;

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListadoContabilidadCobros(ModelMap model, DtoContabilidadCobros dto) {

		List<ContabilidadCobros> list = (List<ContabilidadCobros>) contabilidadCobrosManager.getListadoContabilidadCobros(dto);
		model.put("listado", list);

		return CONTABILIDAD_COBROS_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String showNewContabilidadCobro(ModelMap model) {

		List<Dictionary> tipoEntrega = dictionary.getList("DDAdjContableTipoEntrega");
		model.put("ddTipoEntrega", tipoEntrega);
		
		List<Dictionary> conceptoEntrega = dictionary.getList("DDAdjContableConceptoEntrega");
		model.put("ddConceptoEntrega", conceptoEntrega);
		
		return NEW_CONTABILIDAD_COBRO;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String showEditContabilidadCobro(ModelMap model, DtoContabilidadCobros dto) {

		List<Dictionary> tipoEntrega = dictionary.getList("DDAdjContableTipoEntrega");
		model.put("ddTipoEntrega", tipoEntrega);
		
		List<Dictionary> conceptoEntrega = dictionary.getList("DDAdjContableConceptoEntrega");
		model.put("ddConceptoEntrega", conceptoEntrega);
		
		ContabilidadCobros cc = (ContabilidadCobros) contabilidadCobrosManager.getContabilidadCobroByID(dto);
		model.put("contabilidadCobro", cc);
		
		return NEW_CONTABILIDAD_COBRO;
	}
	

	@RequestMapping
	public String saveContabilidadCobro(ModelMap model, DtoContabilidadCobros dto) {

		contabilidadCobrosManager.saveContabilidadCobro(dto);
		
		return DEFAULT;
	}
	
	@RequestMapping
	public String deleteContabilidadCobro(ModelMap model, Long idContabilidadCobro) {

		contabilidadCobrosManager.deleteContabilidadCobro(idContabilidadCobro);
		
		return DEFAULT;
	}
}

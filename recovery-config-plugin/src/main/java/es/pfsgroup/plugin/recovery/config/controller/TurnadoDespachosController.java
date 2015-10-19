package es.pfsgroup.plugin.recovery.config.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnado;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoDto;
import es.pfsgroup.recovery.ext.turnadodespachos.TurnadoDespachosManager;

@Controller
public class TurnadoDespachosController {

	private final Log logger = LogFactory.getLog(getClass());

	private static final String VIEW_ESQUEMA_TURNADO_BUSCADOR = "plugin/config/turnadodespachos/buscadorEsquemas";
	private static final String VIEW_ESQUEMA_TURNADO_SEARCH = "plugin/config/turnadodespachos/busquedaEsquemasJSON";
	private static final String VIEW_ESQUEMA_TURNADO_EDITAR = "plugin/config/turnadodespachos/editarEsquema";
	//private static final String VIEW_ESQUEMA_TURNADO_GUARDAR_JSON = "plugin/config/turnadodespachos/editarEsquema";
	private static final String VIEW_LETRADO_ESQUEMA_TURNADO_GET = "plugin/config/turnadodespachos/esquemaTurnadoJSON";
	private static final String VIEW_ESQUEMA_TURNADO_LETRADO = "plugin/config/turnadodespachos/editarEsquemaLetrado";
	
	private static final String VIEW_DEFAULT = "default";

	private static final String KEY_DATA = "data";
	private static final String KEY_ERRORS = "errors";

	
	@Autowired
	private TurnadoDespachosManager turnadoDespachosManager;

	@RequestMapping
	public String ventanaBusquedaEsquemas(Model model) {
		return VIEW_ESQUEMA_TURNADO_BUSCADOR;
	}
	
	@RequestMapping
	public String ventanaEditarLetrado(Model model) {
		return VIEW_ESQUEMA_TURNADO_LETRADO;
	}
	
	@RequestMapping
	public String buscarEsquemas(EsquemaTurnadoBusquedaDto dto
			, Model model) {
		
		Page page = (Page)turnadoDespachosManager.listaEsquemasTurnado(dto);
		model.addAttribute(KEY_DATA, page);

		return VIEW_ESQUEMA_TURNADO_SEARCH;
	}

	@RequestMapping
	public String editarEsquema(@RequestParam(required=false) Long id
			, Model model) {
		EsquemaTurnado esquema = (id!=null) 
				? turnadoDespachosManager.get(id)
				: new EsquemaTurnado();
		model.addAttribute(KEY_DATA, esquema);
		return VIEW_ESQUEMA_TURNADO_EDITAR;
	}

	@RequestMapping
	public String getEsquemaVigente(EsquemaTurnadoDto dto
			, Model model) {
		EsquemaTurnado esquema = turnadoDespachosManager.getEsquemaVigente();
		model.addAttribute(KEY_DATA, esquema);
		return VIEW_LETRADO_ESQUEMA_TURNADO_GET;
	}
	
	@RequestMapping
	public String guardarEsquema(EsquemaTurnadoDto dto
			, Model model) {
		if (dto.validar()) {
			turnadoDespachosManager.save(dto);
		}
		return VIEW_DEFAULT;
	}

	@RequestMapping
	public String copiarEsquema(Long id, Model model) {
		turnadoDespachosManager.copy(id);
		return VIEW_DEFAULT;
	}

	@RequestMapping
	public String borrarEsquema(Long id, Model model) {
		turnadoDespachosManager.delete(id);
		return VIEW_DEFAULT;
	}

	@RequestMapping
	public String activarEsquema(Long id, Model model) {
		try {
			turnadoDespachosManager.activarEsquema(id);
		} catch (Exception ex) {
			logger.warn("Error al activar el esquema de turnado", ex);
		}
		return VIEW_DEFAULT;
	}
	
}

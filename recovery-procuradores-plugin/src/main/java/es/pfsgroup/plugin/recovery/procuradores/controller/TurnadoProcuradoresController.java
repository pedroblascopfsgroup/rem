package es.pfsgroup.plugin.recovery.procuradores.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.ext.turnadoProcuradores.EsquemaTurnadoProcurador;
import es.pfsgroup.recovery.ext.turnadoProcuradores.TurnadoProcuradoresApi;

/**
 * @author Sergio
 *
 * Controlador para el turnado de procuradores
 */
@Controller
public class TurnadoProcuradoresController {
	
	private static final String VIEW_ESQUEMA_TURNADO_PROCURADORES_BUSCADOR = "plugin/procuradores/turnado/buscadorEsquemasProcuradores";
	private static final String VIEW_ESQUEMA_TURNADO_PROCURADORES_SELECCIONAR_PLAZA = "plugin/procuradores/turnado/seleccionarPlaza";
	private static final String VIEW_ESQUEMA_TURNADO_PROCURADORES_SELECCIONAR_TPO = "plugin/procuradores/turnado/seleccionarTpo";
	private static final String VIEW_ESQUEMA_TURNADO_PROCURADORES_DETALLES_ESQUEMA = "plugin/procuradores/turnado/detalleEsquemaTurnado";
	private static final String JSON_ESQUEMA_TURNADO_COMBOS_BUSQUEDA = "plugin/procuradores/turnado/diccionariosDataJSON";
	private static final String JSON_ESQUEMA_TURNADO_CONFIG = "plugin/procuradores/turnado/esquemaTurnadoConfigJSON";
	
	@Autowired
	TurnadoProcuradoresApi turnadoPocuradoresMang;
	
	@RequestMapping
	public String ventanaBusquedaEsquemasProcuradores(ModelMap map) {
		return VIEW_ESQUEMA_TURNADO_PROCURADORES_BUSCADOR;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String seleccionarPlaza(ModelMap map) {
		List<TipoPlaza> listaPlazas = turnadoPocuradoresMang.getPlazasEsquemaTurnadoProcu();
		
		map.put("listaPlazas", listaPlazas);
		return VIEW_ESQUEMA_TURNADO_PROCURADORES_SELECCIONAR_PLAZA;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String seleccionarTpo(ModelMap map) {
		List<TipoProcedimiento> listaTpo = turnadoPocuradoresMang.getTPOsEsquemaTurnadoProcu();
		
		map.put("listaTpo", listaTpo);
		return VIEW_ESQUEMA_TURNADO_PROCURADORES_SELECCIONAR_TPO;
	}
	
	/**
	 * Abrir ventana detalles del esquema
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openDetalleEsquemaTurnado(@RequestParam(value = "idEsquema", required = true) Long idEsquema, ModelMap map) {
		List<Usuario> listaDespachos = turnadoPocuradoresMang.getDespachosProcuradores();
		EsquemaTurnadoProcurador esquema = turnadoPocuradoresMang.getEsquemaById(idEsquema);
		
		map.put("despachosProcuradores",listaDespachos);
		map.put("despachosProcuradoresSize", listaDespachos.size());
		map.put("idEsquema", esquema.getId());
		map.put("nombreEsquema", esquema.getDescripcion());
		
		return VIEW_ESQUEMA_TURNADO_PROCURADORES_DETALLES_ESQUEMA;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getPlazasGrid(@RequestParam(value = "idEsquema", required = true) Long idEsquema, ModelMap model) {
		model.put("plazasEsquema", turnadoPocuradoresMang.getPlazasGrid(idEsquema));
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getTPOsGrid(@RequestParam(value = "idEsquema", required = true) Long idEsquema,
			@RequestParam(value = "idPlaza", required = true) Long idPlaza, ModelMap model) {
		model.put("tipoProcedimientos", turnadoPocuradoresMang.getTPOsGrid(idEsquema,idPlaza));
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getRangosGrid(@RequestParam(value = "idEsquema", required = true) Long idEsquema,
			@RequestParam(value = "idPlaza", required = true) Long idPlaza,
			@RequestParam(value = "idTPO", required = true) Long idTPO, ModelMap model) {
		model.put("rangosEsquema", turnadoPocuradoresMang.getRangosGrid(idEsquema,(!Checks.esNulo(idPlaza) ? idPlaza  :null ),(!Checks.esNulo(idTPO) ? idTPO  :null )));
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}
	
	/**
	* Metodo que devuelve las plazas para el combo con busqueda de plazas
	* @param query
	* @param model
	* @return
	*/
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getPlazasInstant(String query, ModelMap model) {
		model.put("data", turnadoPocuradoresMang.getPlazas(query));
		return JSON_ESQUEMA_TURNADO_COMBOS_BUSQUEDA;
	}
	   
	/**
	* Metodo que devuelve los tpo para el combo con busqueda de tpos
	* @param query
	* @param model
	* @return
	*/
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getTPOsInstant(String query, ModelMap model) {
		model.put("data", turnadoPocuradoresMang.getTPOs(query));
		return JSON_ESQUEMA_TURNADO_COMBOS_BUSQUEDA;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String addNuevoTPOPlazas(@RequestParam(value = "idEsquema", required = true) Long idEsquema,
			@RequestParam(value = "codTPO", required = true) String codTPO,
			@RequestParam(value = "arrayPlazas", required = true) String[] arrayPlazas ,ModelMap model) {
		//Guardar el tpo para todas las plazas disponibles
		List<Long> idTuplas = turnadoPocuradoresMang.añadirNuevoTpoAPlazas(idEsquema,codTPO,arrayPlazas);
		
		model.put("idTuplas", idTuplas);
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String borrarConfigParaPlazaOTpo(@RequestParam(value = "idEsquema", required = true) Long idEsquema,
			@RequestParam(value = "plazaCod", required = false) String plazaCod,
			@RequestParam(value = "tpoCod", required = false) String tpoCod,
			@RequestParam(value = "arrayPlazas", required = true) String[] arrayPlazas, ModelMap model) {
		//Borrar todo lo relacionado con la plaza en el esquema
		List<Long> idTuplas = turnadoPocuradoresMang.borrarConfigParaPlazaOTpo(idEsquema,plazaCod,tpoCod,arrayPlazas);
		model.put("idTuplas", idTuplas);
		
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}
	

}

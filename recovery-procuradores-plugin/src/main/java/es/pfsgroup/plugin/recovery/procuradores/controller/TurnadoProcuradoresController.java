package es.pfsgroup.plugin.recovery.procuradores.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.utils.UtilDiccionarioManager;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.DDTipoPrcIniciador;
import es.pfsgroup.recovery.ext.turnadoProcuradores.EsquemaPlazasTpo;
import es.pfsgroup.recovery.ext.turnadoProcuradores.EsquemaTurnadoProcurador;
import es.pfsgroup.recovery.ext.turnadoProcuradores.TurnadoHistoricoDto;
import es.pfsgroup.recovery.ext.turnadoProcuradores.TurnadoProcuradorConfig;
import es.pfsgroup.recovery.ext.turnadoProcuradores.TurnadoProcuradoresApi;
import es.pfsgroup.recovery.ext.turnadodespachos.DDEstadoEsquemaTurnado;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto;

/**
 * @author Sergio
 *
 * Controlador para el turnado de procuradores
 */
@Controller
public class TurnadoProcuradoresController {
	
	private static final String VIEW_ESQUEMA_TURNADO_PROCURADORES_BUSCADOR = "plugin/procuradores/turnado/buscadorEsquemasProcuradores";
	private static final String VIEW_ESQUEMA_TURNADO_PROCURADORES_SELECCIONAR_TPO = "plugin/procuradores/turnado/seleccionarTpo";
	private static final String VIEW_ESQUEMA_TURNADO_PROCURADORES_DETALLES_ESQUEMA = "plugin/procuradores/turnado/detalleEsquemaTurnado";
	private static final String JSON_ESQUEMA_TURNADO_COMBOS_BUSQUEDA = "plugin/procuradores/turnado/diccionariosDataJSON";
	private static final String JSON_ESQUEMA_TURNADO_CONFIG = "plugin/procuradores/turnado/esquemaTurnadoConfigJSON";
	private static final String VIEW_ESQUEMA_TURNADO_SEARCH = "plugin/procuradores/turnado/busquedaEsquemasJSON";
	private static final String JSON_DETALLE_HISTORICO_TURNADO = "plugin/procuradores/turnado/detalle/detalleHistoricoTurnadoJSON";
	private static final String VIEW_DETALLE_HISTORICO_TURNADO = "plugin/procuradores/turnado/detalle/buscadorDetalleHistorico";
	
	@Autowired
	TurnadoProcuradoresApi turnadoPocuradoresMang;
	
	@Autowired
	UtilDiccionarioManager utilDiccionarioManager;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String ventanaBusquedaEsquemasProcuradores(ModelMap map) {
		map.put("estadosEsquema", utilDiccionarioManager.dameValoresDiccionario(DDEstadoEsquemaTurnado.class));
		return VIEW_ESQUEMA_TURNADO_PROCURADORES_BUSCADOR;
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
	
	/**
	 * Devuelve los datos para el grid de los rangos de un esquema/configuracion/nueva configuracion
	 * @param idEsquema
	 * @param idsPlazas
	 * @param idsTPOs
	 * @param nuevaConfig
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getRangosGrid(@RequestParam(value = "idEsquema", required = true) Long idEsquema,
			@RequestParam(value = "idsPlazas", required = false) Long[] idsPlazas,
			@RequestParam(value = "idsTPOs", required = false) Long[] idsTPOs,
			@RequestParam(value = "nuevaConfig", required = true) boolean nuevaConfig, ModelMap model) {
		
		List<Long> listIdsPlazas = !Checks.esNulo(idsPlazas) ? new ArrayList<Long>(Arrays.asList(idsPlazas)) : null;
		if(!Checks.estaVacio(listIdsPlazas)) while(listIdsPlazas.remove(null));
		List<Long> listIdsTPOs = !Checks.esNulo(idsTPOs) ? new ArrayList<Long>(Arrays.asList(idsTPOs)) : null;
		if(!Checks.estaVacio(listIdsTPOs)) while(listIdsTPOs.remove(null));
		
		
		//Si es una nueva configuracion y no existen ids de plazas (no hay plazas añadidas), no hace nada
		if(nuevaConfig && Checks.estaVacio(listIdsPlazas)){
			return JSON_ESQUEMA_TURNADO_CONFIG;
		}
		List<EsquemaPlazasTpo> listaConfiguraciones = turnadoPocuradoresMang.getRangosGrid(idEsquema,listIdsPlazas,listIdsTPOs);
		
		//Si es nueva configuracion y existen ids de plazas, devolver solo una configuracion de una plaza-tpo, para evitar duplicados en el grid y generar confusion
		if(nuevaConfig && !Checks.estaVacio(listIdsPlazas)){
			List<EsquemaPlazasTpo> listaResult = null;
			if(!Checks.estaVacio(listaConfiguraciones)){
				listaResult = new ArrayList<EsquemaPlazasTpo>();
				listaResult.add(listaConfiguraciones.get(0));
			}
			model.put("listaConfiguraciones", listaResult);
		}
		else {
			model.put("listaConfiguraciones", listaConfiguraciones);
		}
		
		//Flag nueva config para que el JSON enmascare informacion que no se quiere mostrar en el grid
		model.put("nuevaConfig",nuevaConfig);
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getPlazasInstant(String query, Boolean otrasPlazasPresentes, Boolean plazaDefectoPresente, ModelMap model) {
		model.put("data", turnadoPocuradoresMang.getPlazas(query, otrasPlazasPresentes, plazaDefectoPresente));
		return JSON_ESQUEMA_TURNADO_COMBOS_BUSQUEDA;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getProcedimientosIniciadores(@RequestParam(value = "plazaDefecto", required = true) Boolean plazaDefecto,ModelMap model) {
		List<TipoProcedimiento> listaTposDisponibles = new ArrayList<TipoProcedimiento>();
		//Si la plaza seleccionada anteriormente es la plaza por defecto se filtra la peticion, mostrando solo tipo procedimiento por defecto
		if(plazaDefecto){
			TipoProcedimiento tpo = new TipoProcedimiento();
        	tpo.setDescripcion("PROCEDIMIENTO POR DEFECTO");
        	tpo.setDescripcionLarga("PROCEDIMIENTO POR DEFECTO");
        	tpo.setCodigo("default");
        	tpo.setId(Long.parseLong("-1"));
        	listaTposDisponibles.add(tpo);
		}
		else listaTposDisponibles = turnadoPocuradoresMang.getTPOsEsquemaTurnadoProcu();
		model.put("data", listaTposDisponibles);
		return JSON_ESQUEMA_TURNADO_COMBOS_BUSQUEDA;
	}
	
	/**
	 * Lanza una excepcion controlada si existe una configuracion ya vigente para el esquema y plaza especificados
	 * @param idEsquema
	 * @param idPlaza
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String checkSiPlazaYaTieneConfiguracion(@RequestParam(value = "idEsquema", required = true) Long idEsquema,
			@RequestParam(value = "idPlaza", required = true) Long idPlaza, ModelMap model){
		//Comprobar si ya existe configuracion
		Boolean existeConfiguracion = turnadoPocuradoresMang.checkSiPlazaYaTieneConfiguracion(idEsquema,idPlaza);
		if(existeConfiguracion) throw new BusinessOperationException("Ya existe una configuracion vigente para el esquema y plaza especificados");
		return "default";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String addNuevoTPOPlazas(@RequestParam(value = "idEsquema", required = true) Long idEsquema,
			@RequestParam(value = "idTpo", required = true) Long idTpo,
			@RequestParam(value = "arrayPlazas", required = true) Long[] arrayPlazas ,ModelMap model) {
		//Guardar el tpo para todas las plazas disponibles
		List<Long> idTuplas = turnadoPocuradoresMang.anyadirNuevoTpoAPlazas(idEsquema,idTpo,arrayPlazas);
		
		model.put("idTuplas", idTuplas);
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String borrarConfigParaPlazaOTpo(@RequestParam(value = "idEsquema", required = true) Long idEsquema,
			@RequestParam(value = "idPlaza", required = false) Long idPlaza,
			@RequestParam(value = "idTpo", required = false) Long idTpo,
			@RequestParam(value = "arrayPlazas", required = false) Long[] arrayPlazas, ModelMap model) {
		//Borrar todo lo relacionado con la plaza  o el tpo en el esquema
		List<Long> idTuplas = turnadoPocuradoresMang.borrarConfigParaPlazaOTpo(idEsquema,idPlaza,idTpo,arrayPlazas);
		
		model.put("idTuplas", idTuplas);
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String borrarConfigParaPlazaOTpoLogico(@RequestParam(value = "idEsquema", required = true) Long idEsquema,
			@RequestParam(value = "idPlaza", required = false) Long idPlaza,
			@RequestParam(value = "idTpo", required = false) Long idTpo, ModelMap model) {
		//Borrar todo lo relacionado con la plaza  o el tpo en el esquema
		HashMap<String, List<Long>> map = turnadoPocuradoresMang.borrarConfigParaPlazaOTpoLogico(idEsquema,idPlaza,idTpo);
		
		model.put("idTuplas", map.get("plazasTposBorrados"));
		model.put("idsRangos", map.get("rangosBorrados"));
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String addRangoConfigEsquema(@RequestParam(value = "idConf", required = false) Long idConf,
			@RequestParam(value = "idsplazasTpo", required = false) Long[] idsplazasTpo,
			@RequestParam(value = "impMin", required = true) Double impMin,
			@RequestParam(value = "impMax", required = true) Double impMax,
			@RequestParam(value = "arrayDespachos", required=true) String[] arrayDespachos,ModelMap model){
		
		List<Long> listIdsPlazaTpo = !Checks.esNulo(idsplazasTpo) ? new ArrayList<Long>(Arrays.asList(idsplazasTpo)) : null;
		if(!Checks.estaVacio(listIdsPlazaTpo)) while(listIdsPlazaTpo.remove(null));
		//Añadir nueva regla al esquema
		List<Long> idsRangos = turnadoPocuradoresMang.addRangoConfigEsquema(listIdsPlazaTpo,idConf,impMin,impMax,arrayDespachos);
		model.put("idsRangos", idsRangos);
		
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String updateRangoConfigEsquema(@RequestParam(value = "idConf", required = true) Long idConf,
			@RequestParam(value = "impMin", required = true) Double impMin,
			@RequestParam(value = "impMax", required = true) Double impMax,
			@RequestParam(value = "arrayDespachos", required=true) String[] arrayDespachos,ModelMap model){
		
		//Hacer el update de la regla/reglas como proceda
		HashMap<String, List<String>> map = turnadoPocuradoresMang.updateRangoConfigEsquema(idConf, impMin, impMax, arrayDespachos);
		//Devolver valores que toca a la pantalla
		model.put("modificacionesRangos", map.get("modificaciones"));
		model.put("idsRangosBorrados", map.get("borrados"));
		model.put("idsRangos", map.get("creados"));
		
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String borrarRangoConfigEsquema(@RequestParam(value="idConfig", required = true) Long idConfig,
			@RequestParam(value = "idsplazasTpo", required = false) Long[] idsplazasTpo, ModelMap model){
		
		List<Long> listIdsPlazaTpo = !Checks.esNulo(idsplazasTpo) ? new ArrayList<Long>(Arrays.asList(idsplazasTpo)) : null;
		if(!Checks.estaVacio(listIdsPlazaTpo)) while(listIdsPlazaTpo.remove(null));
		//Borrar todos los rangos asociados al dado
		List<Long> idsRangosBorrados = turnadoPocuradoresMang.borrarRangoConfigEsquema(idConfig,listIdsPlazaTpo);
		
		model.put("idsRangos", idsRangosBorrados);		
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}
	
	/**
	 * Dado el id de un rango, devuelve un string que contiene idRango_NombreDespacho_Porcentaje
	 * @param idConfig
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getIdsRangosRelacionados(@RequestParam(value="idConfig", required = true) Long idConfig, ModelMap model){
		//Obtener todos los ids de los relacionadas al dado
		List<TurnadoProcuradorConfig> listaRangos = turnadoPocuradoresMang.getIdsRangosRelacionados(idConfig, null);
		List<String> idsRangosRelacionados = new ArrayList<String>();
		for(TurnadoProcuradorConfig rango : listaRangos){
			idsRangosRelacionados.add(rango.getUsuario().getId()+"_"+rango.getUsuario().getNombre()+"_"+rango.getPorcentaje());
		}
		
		model.put("idsRangos", idsRangosRelacionados);
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}
	
	@RequestMapping
	@Transactional
	public String cancelarEdicionEsquema(@RequestParam(value = "idsTuplasConfig", required=false) Long[] idsTuplasConfig,
			@RequestParam(value = "idsTuplasBorradasConfig", required=false) Long[] idsTuplasBorradasConfig,
			@RequestParam(value = "idsRangosBorradosConfig", required=false) Long[] idsRangosBorradosConfig,
			@RequestParam(value = "idsRangosCreados", required=false) Long[] idsRangosCreados,
			@RequestParam(value = "idsTuplasConfigDefinitivas", required=false) Long[] idsTuplasConfigDefinitivas,
			@RequestParam(value = "idsTuplasBorradas", required=false) Long[] idsTuplasBorradas,
			@RequestParam(value = "idsRangosBorrados", required=false) Long[] idsRangosBorrados,
			@RequestParam(value = "modificacionesRangos", required=false) String[] modificacionesRangos, ModelMap model){
		
		//Eliminamos fisicamente configuracion añadida en la parte de alta de configuracion
		List<Long> listIdsTC = !Checks.esNulo(idsTuplasConfig) ? new ArrayList<Long>(Arrays.asList(idsTuplasConfig)) : null;
		if(!Checks.estaVacio(listIdsTC)) {
			while(listIdsTC.remove(null));
			turnadoPocuradoresMang.borrarConfigParaPlazaOTpo(listIdsTC);
		}
		//Revivimos las configuraciones eliminadas en la parte de alta de configuracion
		List<Long> listIdsTBC = !Checks.esNulo(idsTuplasBorradasConfig) ? new ArrayList<Long>(Arrays.asList(idsTuplasBorradasConfig)) : null;
		if(!Checks.estaVacio(listIdsTBC)) {
			while(listIdsTBC.remove(null));
			turnadoPocuradoresMang.reactivarPlazasTPO(listIdsTBC);
		}
		//Revivimos los rangos eliminados en la parte de alta de configuracion
		List<Long> listIdsRBC = !Checks.esNulo(idsRangosBorradosConfig) ? new ArrayList<Long>(Arrays.asList(idsRangosBorradosConfig)) : null;
		if(!Checks.estaVacio(listIdsRBC)) {
			while(listIdsRBC.remove(null));
			turnadoPocuradoresMang.reactivarRangos(listIdsRBC);
		}
		
		//Eliminamos ficisamente los rangos creados
		List<Long> listIdsRC = !Checks.esNulo(idsRangosCreados) ? new ArrayList<Long>(Arrays.asList(idsRangosCreados)) : null;
		if(!Checks.estaVacio(listIdsRC)) {
			while(listIdsRC.remove(null));
			turnadoPocuradoresMang.borrarRangosFisico(listIdsRC);
		}
		//Eliminamos fisicamente configuracion añadida 
		List<Long> listIdsTCD = !Checks.esNulo(idsTuplasConfigDefinitivas) ? new ArrayList<Long>(Arrays.asList(idsTuplasConfigDefinitivas)) : null;
		if(!Checks.estaVacio(listIdsTCD)) {
			while(listIdsTCD.remove(null));
			turnadoPocuradoresMang.borrarConfigParaPlazaOTpo(listIdsTCD);
		}
		//Revivimos las configuraciones eliminadas
		List<Long> listIdsTB = !Checks.esNulo(idsTuplasBorradas) ? new ArrayList<Long>(Arrays.asList(idsTuplasBorradas)) : null;
		if(!Checks.estaVacio(listIdsTB)) {
			while(listIdsTB.remove(null));
			turnadoPocuradoresMang.reactivarPlazasTPO(listIdsTB);
		}
		//Revivimos los rangos eliminados
		List<Long> listIdsRB = !Checks.esNulo(idsRangosBorrados) ? new ArrayList<Long>(Arrays.asList(idsRangosBorrados)) : null;
		if(!Checks.estaVacio(listIdsRB)) {
			while(listIdsRB.remove(null));
			turnadoPocuradoresMang.reactivarRangos(listIdsRB);
		}
		
		//Modificamos reglas para deshacer cualquier cambio realizado
		List<String> listModRangos = !Checks.esNulo(modificacionesRangos) ? new ArrayList<String>(Arrays.asList(modificacionesRangos)) : null;
		if(!Checks.estaVacio(listModRangos)) {
			while(listModRangos.remove(null));
			turnadoPocuradoresMang.modificarRangosCancelacion(listModRangos);
		}
		
		return "default";
	}
	
	/**
	 * Devuelve los tipos de procedimientos que estan disponibles para asignar a una plaza
	 * @param idEsquema
	 * @param idPlaza
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getTPODisponiblesByPlaza(@RequestParam(value = "idEsquema", required = true) Long idEsquema,
			@RequestParam(value = "idPlaza", required = true) Long idPlaza, ModelMap model) {
		model.put("tipoProcedimientos", turnadoPocuradoresMang.getTPODisponiblesByPlaza(idEsquema,idPlaza));
		return JSON_ESQUEMA_TURNADO_CONFIG;
	}
	
	@RequestMapping
	public String buscarEsquemas(EsquemaTurnadoBusquedaDto dto, Model model) {
		Page page = (Page)turnadoPocuradoresMang.listaEsquemasTurnado(dto);
		model.addAttribute("data", page);
		return VIEW_ESQUEMA_TURNADO_SEARCH;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String detalleHistoricoTurnado(ModelMap map) {
		map.put("tipoPlaza", utilDiccionarioManager.dameValoresDiccionario(TipoPlaza.class));
		map.put("tipoProcedimiento", utilDiccionarioManager.dameValoresDiccionario(DDTipoPrcIniciador.class));
		return VIEW_DETALLE_HISTORICO_TURNADO;
	}
	
	@RequestMapping
	public String buscarDetalleHistorico(TurnadoHistoricoDto dto, Model model) {
		Page page = (Page)turnadoPocuradoresMang.listaDetalleHistorico(dto);
		model.addAttribute("listaDetalle", page);
		return JSON_DETALLE_HISTORICO_TURNADO;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String exportarExcelElementos(TurnadoHistoricoDto dto, ModelMap model) {
		
		dto.setStart(0);
		dto.setLimit(Integer.MAX_VALUE);
		FileItem fExcel = turnadoPocuradoresMang.generarExcelExportacionElementos(dto);
		model.put("fileItem", fExcel);
		return "plugin/precontencioso/download";
	}
	
}

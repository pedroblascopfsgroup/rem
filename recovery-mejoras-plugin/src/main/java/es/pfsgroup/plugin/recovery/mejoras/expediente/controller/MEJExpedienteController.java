package es.pfsgroup.plugin.recovery.mejoras.expediente.controller;

import java.text.ParseException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.DDDecisionSancion;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.Sancion;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.expediente.MEJExpedienteApi;
import es.pfsgroup.plugin.recovery.mejoras.expediente.dto.MEJExpedienteSancionDto;

@Controller
public class MEJExpedienteController {

	static final String JSON_LISTADO_ZONAS = "plugin/mejoras/expedientes/listadoZonasJSON";
	static final String JSON_LISTADO_DECISION_SANCION = "plugin/mejoras/expedientes/listadoDecisionSancionJSON";
	static final String JSON_LISTADO_ESTADOS_ITINERARIO = "plugin/mejoras/itinerarios/estadosDelItinerarioJSON";
	static final String JSP_POPUP_EDITAR_SANCION = "plugin/mejoras/expedientes/popupSancion";
	
	private static final String DEFAULT = "default";

	@Autowired
	private MEJExpedienteApi mejExpedienteApi;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private ExpedienteDao expedienteDao;

	/**
	 * Obtiene la lista de Contratos asociados aun asunto.
	 * 
	 * @param idAsunto
	 *            el id del asunto
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getZonasInstant(Integer idJerarquia, String query, ModelMap model) {
		List<DDZona> zonas = mejExpedienteApi.getZonasJerarquiaByCodDesc(idJerarquia, query);
		model.put("zonas", zonas);
		return JSON_LISTADO_ZONAS;
	}
	
	/**
	 * Obtiene el diccionario DD_DES_DECISION_SANCION
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListDecisionSancion(ModelMap model) {
		List<DDDecisionSancion> ddecisionsancion = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDDecisionSancion.class);
		model.put("ddecisionsancion", ddecisionsancion);
		return JSON_LISTADO_DECISION_SANCION;
	}
	
	/**
	 * Guarda la entidad sancion y la relacion con el expediente
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String guardaSancionExpediente(ModelMap model, 
			@RequestParam(value = "idExpediente", required = true) Long idExpediente,
			@RequestParam(value = "id", required = true) Long id,
			@RequestParam(value = "fechaElevacion", required = false) String fechaElevacion,
			@RequestParam(value = "fechaSancion", required = false) String fechaSancion,
			@RequestParam(value = "decision", required = false) String decision,
			@RequestParam(value = "nWorkFlow", required = false) String nWorkFlow,
			@RequestParam(value = "observaciones", required = false) String observaciones) {		
		
		MEJExpedienteSancionDto dto = new MEJExpedienteSancionDto();
		dto.setId(id);
		dto.setIdExpediente(idExpediente);
		try {
			dto.setFechaElevacion(DateFormat.toDate(fechaElevacion));
			dto.setFechaSancion(DateFormat.toDate(fechaSancion));
		} catch (ParseException e) {
			dto.setFechaElevacion(null);
			dto.setFechaSancion(null);
		}
		dto.setDecision(decision);
		dto.setnWorkFlow(nWorkFlow);
		dto.setObservaciones(observaciones);
		
		mejExpedienteApi.guardaSancionExpediente(dto);
		return DEFAULT;
	}
	
	/**
	 * Obtiene el itinerario y las fases del expediente
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getItinerarioDelExpediente(ModelMap model, Long idExpediente) {
		
		Expediente exp = expedienteDao.get(idExpediente);
		Itinerario iti = exp.getArquetipo().getItinerario();
		if(!Checks.esNulo(iti)){
			model.put("estadosItinerario", iti.getEstados());
		}
		
		return JSON_LISTADO_ESTADOS_ITINERARIO;	
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editar(@RequestParam(value = "id", required = true) Long id, 
			@RequestParam(value = "idExpediente", required = true) Long idExpediente, ModelMap map){
		Sancion sancion = mejExpedienteApi.getSancionExpedienteById(id);
		map.put("sancion",sancion);
		map.put("idExpediente",idExpediente);
		return JSP_POPUP_EDITAR_SANCION;
		
	}
	
}

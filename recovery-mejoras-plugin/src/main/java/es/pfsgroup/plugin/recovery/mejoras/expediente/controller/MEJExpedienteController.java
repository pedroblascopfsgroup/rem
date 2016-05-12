package es.pfsgroup.plugin.recovery.mejoras.expediente.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.DDDecisionSancion;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.expediente.MEJExpedienteApi;

@Controller
public class MEJExpedienteController {

	static final String JSON_LISTADO_ZONAS = "plugin/mejoras/expedientes/listadoZonasJSON";
	static final String JSON_LISTADO_DECISION_SANCION = "plugin/mejoras/expedientes/listadoDecisionSancionJSON";
	static final String JSON_LISTADO_ESTADOS_ITINERARIO = "plugin/mejoras/itinerarios/estadosDelItinerarioJSON";
	
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
	public String guardaSancionExpediente(@RequestParam(value = "idExpediente", required = false) Long idExpediente, @RequestParam(value = "decionSancion", required = false) String codDecionSancion , String observaciones, ModelMap model) {
		
		mejExpedienteApi.guardaSancionExpediente(idExpediente, codDecionSancion, observaciones);
		
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
	
}

package es.pfsgroup.plugin.recovery.mejoras.expediente.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.expediente.model.DDDecisionSancion;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.expediente.MEJExpedienteApi;

@Controller
public class MEJExpedienteController {

	static final String JSON_LISTADO_ZONAS = "plugin/mejoras/expedientes/listadoZonasJSON";
	static final String JSON_LISTADO_DECISION_SANCION = "plugin/mejoras/expedientes/listadoDecisionSancionJSON";

	@Autowired
	private MEJExpedienteApi mejExpedienteApi;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

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
}

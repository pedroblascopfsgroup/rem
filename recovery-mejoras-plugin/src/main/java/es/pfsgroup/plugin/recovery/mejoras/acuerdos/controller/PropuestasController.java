package es.pfsgroup.plugin.recovery.mejoras.acuerdos.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.termino.TerminoOperacionesManager;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.api.PropuestaApi;
import es.pfsgroup.recovery.api.ExpedienteApi;

@Controller
public class PropuestasController {
	
	static final String JSP_ALTA_PROPUESTA = "plugin/mejoras/acuerdos/editaConclusionesAcuerdo";
	static final String LISTADO_PROPUESTAS_JSON =  "plugin/mejoras/acuerdos/acuerdosJSON";
	
	
	@Autowired 
	private DictionaryManager dictionaryManager; 
	
	@Autowired
	private PropuestaApi propuestaApi;
	
	
	
	
    /**
     * Abre la ventana para crear una nueva propuesta.
     * @param idExpediente
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String abreCrearPropuesta(ModelMap model,Long idExpediente) {
		
		model.put("readOnly", false);
		
		model.put("tiposAcuerdo", dictionaryManager.getList("DDTipoAcuerdo"));
		model.put("solicitantes", dictionaryManager.getList("DDSolicitante"));
		model.put("estados", dictionaryManager.getList("DDEstadoAcuerdo"));
		model.put("tiposPago", dictionaryManager.getList("DDTipoPagoAcuerdo"));
		model.put("periodicidad", dictionaryManager.getList("DDPeriodicidadAcuerdo"));
		
//		model.put("esGestor", procedimientoApi.esGestor(idProcedimiento));
//		model.put("esSupervisor", procedimientoApi.esSupervisor(idProcedimiento));
		
		model.put("idExpediente",idExpediente);
		
		
		return JSP_ALTA_PROPUESTA;
	}
	
	
    /**
     * Obtiene un listado de las propuestas asignadas al expediente.
     * @param idExpediente
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String getPropuestasByExpedienteId(Long id,ModelMap model) {
		
		model.put("acuerdos",propuestaApi.listadoPropuestasByExpedienteId(id));
		
		return LISTADO_PROPUESTAS_JSON;
	}
	

}

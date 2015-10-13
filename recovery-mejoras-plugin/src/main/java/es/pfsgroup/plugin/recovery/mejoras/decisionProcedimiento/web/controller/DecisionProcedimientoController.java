package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.decisionProcedimiento.DecisionProcedimientoManager;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.MEJDecisionProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.MEJProcedimientoApi;

@Controller
public class DecisionProcedimientoController {

	private static final String VENTANA_DECISION = "plugin/mejoras/procedimientos/decision";
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private MEJDecisionProcedimientoManager mejDecisionProcedimientoManager;

	@Autowired
	private ProcedimientoManager prcManager;

	@Autowired
	private DecisionProcedimientoManager decisionProcedimientoManager;
	
	@Autowired
	private DictionaryManager dictionaryManager;
	
	@Autowired
	private ProcedimientoManager procedimientoManager;
	
	@RequestMapping
	public String desparalizarProcedimiento(Long idProcedimiento){
		proxyFactory.proxy(MEJProcedimientoApi.class).desparalizarProcedimiento(idProcedimiento);
		return "default";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String isDesparalizable(Long idProcedimiento,ModelMap map){
		
		boolean res = proxyFactory.proxy(MEJProcedimientoApi.class).isDespararizable(idProcedimiento);
		map.put("isDesparalizable", res);
		return "plugin/mejoras/procedimientos/procedimientoDesparalizableJSON";
	}

	public void setProxyFactory(ApiProxyFactory proxyFactory) {
		this.proxyFactory = proxyFactory;
	}

	public ApiProxyFactory getProxyFactory() {
		return proxyFactory;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String esTramiteSubastaByPrcId(Long prcId, ModelMap map){
		
		boolean res =  proxyFactory.proxy(MEJProcedimientoApi.class).esTramiteSubastaByPrcId(prcId);
		map.put("esTramiteSubasta", res);

		return "plugin/mejoras/procedimientos/procedimientoTSubastaJSON";
	}

	@RequestMapping
    public String aceptarPropuesta(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento, 
    		Long idProcedimiento, 
    		@RequestParam(required=false) Long idDecision) throws Exception {
		
		DecisionProcedimiento dec = null;
		if (idDecision==null) {
	        Procedimiento p = prcManager.getProcedimiento(idProcedimiento);
	        dec = new DecisionProcedimiento();
	        dec.setProcedimiento(p);
		} else {
			dec = decisionProcedimientoManager.get(idDecision);			
		}
        dtoDecisionProcedimiento.setDecisionProcedimiento(dec);
		mejDecisionProcedimientoManager.aceptarPropuesta(dtoDecisionProcedimiento);
		return "default";
	}

	@RequestMapping
    public String crearPropuesta(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento
    		,Long idProcedimiento
    		,@RequestParam(required=false) Long idDecision) throws Exception {
		DecisionProcedimiento dec = null;
		if (idDecision==null) {
	        Procedimiento p = prcManager.getProcedimiento(idProcedimiento);
	        dec = new DecisionProcedimiento();
	        dec.setProcedimiento(p);
		} else {
			dec = decisionProcedimientoManager.get(idDecision);			
		}
        dtoDecisionProcedimiento.setDecisionProcedimiento(dec);
        mejDecisionProcedimientoManager.crearPropuesta(dtoDecisionProcedimiento);
		return "default";
	}
	
	@RequestMapping
	public String rechazarPropuesta(Long id) throws Exception {
		MEJDtoDecisionProcedimiento dto = new MEJDtoDecisionProcedimiento();
		DecisionProcedimiento dec = decisionProcedimientoManager.get(id);
		dto.setDecisionProcedimiento(dec);
        mejDecisionProcedimientoManager.rechazarPropuesta(dto);
		return "default";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String ventanaDecision(
			@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento,
			@RequestParam(value = "isConsulta", required = true) Boolean isConsulta,
			@RequestParam(value = "id", required = false) Long idDecisionProcedimiento,
			ModelMap map) {
		
		DecisionProcedimiento decisionProcedimiento = null;
		if(idDecisionProcedimiento != null) {
			decisionProcedimiento = decisionProcedimientoManager.get(idDecisionProcedimiento);
		}
		else {
			decisionProcedimiento = decisionProcedimientoManager.getInstance(idProcedimiento);
		}
		
		map.put("decisionProcedimiento", decisionProcedimiento);
		map.put("causaDecisionFinalizar", dictionaryManager.getList("DDCausaDecisionFinalizar"));
		map.put("causaDecisionParalizar", dictionaryManager.getList("DDCausaDecisionParalizar"));				
		map.put("estadoDecision", dictionaryManager.getList("DDEstadoDecision"));
		map.put("tiposActuacion", procedimientoManager.getTiposActuacion());
		map.put("tiposProcedimientos", procedimientoManager.getTiposProcedimiento());
		map.put("tiposReclamacion", procedimientoManager.getTiposReclamacion());
		map.put("personas", procedimientoManager.getPersonasAfectadas(idProcedimiento));
		map.put("esGestor", procedimientoManager.esGestor(idProcedimiento));
		map.put("esSupervisor", procedimientoManager.esSupervisor(idProcedimiento));
		map.put("isConsulta", isConsulta);
		map.put("idProcedimiento", idProcedimiento);
		
		return VENTANA_DECISION;
	}
	
}

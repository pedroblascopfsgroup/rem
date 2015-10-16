package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.decisionProcedimiento.DecisionProcedimientoManager;
import es.capgemini.pfs.decisionProcedimiento.dto.DtoDecisionProcedimiento;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.MEJDecisionProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.MEJProcedimientoApi;

@Controller
public class DecisionProcedimientoController {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private MEJDecisionProcedimientoManager mejDecisionProcedimientoManager;

	@Autowired
	private ProcedimientoManager prcManager;

	@Autowired
	private DecisionProcedimientoManager decisionProcedimientoManager;
	
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
	
}

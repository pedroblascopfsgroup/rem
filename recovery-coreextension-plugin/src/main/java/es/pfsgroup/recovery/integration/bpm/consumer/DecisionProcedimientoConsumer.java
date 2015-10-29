package es.pfsgroup.recovery.integration.bpm.consumer;

import java.util.LinkedList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.MEJDecisionProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;
import es.pfsgroup.recovery.integration.bpm.DiccionarioDeCodigos;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;
import es.pfsgroup.recovery.integration.bpm.payload.DecisionProcedimientoPayload;
import es.pfsgroup.recovery.integration.bpm.payload.ProcedimientoDerivadoPayload;

public class DecisionProcedimientoConsumer extends ConsumerAction<DataContainerPayload> {

	protected final Log logger = LogFactory.getLog(getClass());
	
    @Autowired
    private MEJDecisionProcedimientoManager decisionProcedimientoManager;
    
	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
    	
	public DecisionProcedimientoConsumer(Rule<DataContainerPayload> rule, DiccionarioDeCodigos diccionarioCodigos) {
		super(rule);
	}
	
	public DecisionProcedimientoConsumer(List<Rule<DataContainerPayload>> rules, DiccionarioDeCodigos diccionarioCodigos) {
		super(rules);
	}

	private String getGuidProcedimiento(DecisionProcedimientoPayload decisionProcedimientoPayload) {
		return decisionProcedimientoPayload.getProcedimiento().getGuid(); // String.format("%d-EXT", tareaExtenaPayload.getProcedimiento().getIdOrigen());
	}

	@Override
	protected void doAction(DataContainerPayload payload) {

		DecisionProcedimientoPayload decisionProcedimientoPayload = new DecisionProcedimientoPayload(payload);
		String asuGUID = decisionProcedimientoPayload.getProcedimiento().getAsunto().getGuid();
		String prcUUID = getGuidProcedimiento(decisionProcedimientoPayload);
		
		if (payload.getTipo().equals(IntegracionBpmService.TIPO_DATOS_DECISION_PROCEDIMIENTO)) {
			logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] Guardando decisión procedimiento...", asuGUID, prcUUID));
			
			MEJDtoDecisionProcedimiento dtoDecisionProcedimiento = load(decisionProcedimientoPayload);
			
			DecisionProcedimiento dec = null;
			MEJProcedimiento prc = extProcedimientoManager.getProcedimientoByGuid(prcUUID);
			if (prc==null) {
				throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento con guid %s asociado a la decisión no existe", prcUUID)); 
			}
		     
			dec = new DecisionProcedimiento();
		    dec.setProcedimiento(prc);
			
	        dtoDecisionProcedimiento.setDecisionProcedimiento(dec);
			
			decisionProcedimientoManager.aceptarPropuestaSinControl(dtoDecisionProcedimiento);
		}
	}

	private MEJDtoDecisionProcedimiento load(
			DecisionProcedimientoPayload decisionProcedimientoPayload) {
		
		MEJDtoDecisionProcedimiento dtoDecisionProcedimiento = new MEJDtoDecisionProcedimiento();
		dtoDecisionProcedimiento.setCausaDecisionFinalizar(decisionProcedimientoPayload.getCausaDecisionFinalizar());
		dtoDecisionProcedimiento.setCausaDecisionParalizar(decisionProcedimientoPayload.getCausaDecisionParalizar());
		dtoDecisionProcedimiento.setComentarios(decisionProcedimientoPayload.getComentarios());
		dtoDecisionProcedimiento.setFechaParalizacion(decisionProcedimientoPayload.getFechaParalizacion());
		dtoDecisionProcedimiento.setFinalizar(decisionProcedimientoPayload.getFinalizada());
		
		String procGuid = getGuidProcedimiento(decisionProcedimientoPayload);
		MEJProcedimiento prc = extProcedimientoManager.getProcedimientoByGuid(procGuid);
		if (prc==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento con guid %s asociado a la decisión no existe", procGuid)); 
		}
		
		dtoDecisionProcedimiento.setIdProcedimiento(prc.getId());
		dtoDecisionProcedimiento.setParalizar(decisionProcedimientoPayload.getParalizada());
		
		List<DtoProcedimientoDerivado> dtoProcedimientoDerivados = new LinkedList<DtoProcedimientoDerivado>();
		
		for(ProcedimientoDerivadoPayload procedimientoDerivadoPayload : decisionProcedimientoPayload.getProcedimientoDerivado()) {
			
			DtoProcedimientoDerivado dtoProcedimientoDerivado = new DtoProcedimientoDerivado();
			
			List<Long> lPersonas = new LinkedList<Long>();
			
			for(String sPersona : procedimientoDerivadoPayload.getPersonas()) {
				lPersonas.add(Long.valueOf(sPersona));
			}
			
			dtoProcedimientoDerivado.setPersonas((Long[]) lPersonas.toArray());
			dtoProcedimientoDerivado.setId(procedimientoDerivadoPayload.getId());
			
			MEJProcedimiento prcPadre = extProcedimientoManager.getProcedimientoByGuid(procedimientoDerivadoPayload.getGuidProcedimientoPadre());
			if (prcPadre==null) {
				throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento con guid %s asociado al procedimiento derivado s no existe", procedimientoDerivadoPayload.getGuidProcedimientoPadre())); 
			}
			
			dtoProcedimientoDerivado.setProcedimientoPadre(prcPadre.getId());
			dtoProcedimientoDerivado.setTipoActuacion(procedimientoDerivadoPayload.getTipoActuacion());
			dtoProcedimientoDerivado.setTipoReclamacion(procedimientoDerivadoPayload.getTipoReclamacion());
			dtoProcedimientoDerivado.setTipoProcedimiento(procedimientoDerivadoPayload.getTipoProcedimiento());
			dtoProcedimientoDerivado.setPorcentajeRecuperacion(procedimientoDerivadoPayload.getPorcentajeRecuperacion());
			dtoProcedimientoDerivado.setPlazoRecuperacion(procedimientoDerivadoPayload.getPlazoRecuperacion());
			dtoProcedimientoDerivado.setSaldoRecuperacion(procedimientoDerivadoPayload.getSaldoRecuperacion());
			
			dtoProcedimientoDerivados.add(dtoProcedimientoDerivado);
		}

		dtoDecisionProcedimiento.setProcedimientosDerivados((DtoProcedimientoDerivado[]) dtoProcedimientoDerivados.toArray());
		dtoDecisionProcedimiento.setStrEstadoDecision(decisionProcedimientoPayload.getEstadoDecision());		
		
		return dtoDecisionProcedimiento;
	}
}
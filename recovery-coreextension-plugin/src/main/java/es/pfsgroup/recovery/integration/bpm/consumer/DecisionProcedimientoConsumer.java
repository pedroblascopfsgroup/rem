package es.pfsgroup.recovery.integration.bpm.consumer;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.persona.PersonaManager;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procedimientoDerivado.ProcedimientoDerivadoManager;
import es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.ConfiguradorPropuesta;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.MEJDecisionProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;
import es.pfsgroup.recovery.integration.bpm.payload.DecisionProcedimientoPayload;
import es.pfsgroup.recovery.integration.bpm.payload.ProcedimientoDerivadoPayload;

public class DecisionProcedimientoConsumer extends ConsumerAction<DataContainerPayload> {

	protected final Log logger = LogFactory.getLog(getClass());
	
	private final String tratamientoDecision;
	
	private enum TipoTratamiento
	{
	    SOLO_CREAR, CREAR_Y_DERIVAR
	}
	
    @Autowired
    private MEJDecisionProcedimientoManager decisionProcedimientoManager;
    
	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
	
	@Autowired
	private ProcedimientoDerivadoManager procedimientoDerivadoManager;
	
	@Autowired
	private PersonaManager personaManager;

	private ProcedimientoConsumer procedimientoConsumer;

	public DecisionProcedimientoConsumer(Rule<DataContainerPayload> rule, String tratamientoDecision) {
		super(rule);
		this.tratamientoDecision = tratamientoDecision;
	}
	
	public DecisionProcedimientoConsumer(List<Rule<DataContainerPayload>> rules, String tratamientoDecision) {
		super(rules);
		this.tratamientoDecision = tratamientoDecision;
	}

	private String getGuidProcedimiento(DecisionProcedimientoPayload decisionProcedimientoPayload) {
		return decisionProcedimientoPayload.getProcedimiento().getGuid(); // String.format("%d-EXT", tareaExtenaPayload.getProcedimiento().getIdOrigen());
	}
	

	public ProcedimientoConsumer getProcedimientoConsumer() {
		return procedimientoConsumer;
	}

	public void setProcedimientoConsumer(ProcedimientoConsumer procedimientoConsumer) {
		this.procedimientoConsumer = procedimientoConsumer;
	}
	
	@Transactional(readOnly = false)
	private MEJProcedimiento getProcedimiento(DecisionProcedimientoPayload decisionProcedimientoPayload) {
		String prcUUID = getGuidProcedimiento(decisionProcedimientoPayload);
		logger.debug(String.format("[INTEGRACION] PRC[%s] Configurando procedimiento", prcUUID));
		MEJProcedimiento prc = extProcedimientoManager.getProcedimientoByGuid(prcUUID);
		if (prc==null && procedimientoConsumer != null) {
				String errorMsg = String.format("[INTEGRACION] PRC[%s] El procedimiento no existe!, se intenta crear uno nuevo.", prcUUID);
				logger.warn(errorMsg);
				procedimientoConsumer.doAction(decisionProcedimientoPayload.getData());
				prc = extProcedimientoManager.getProcedimientoByGuid(prcUUID);
		}
		if (prc==null) {
			String errorMsg = String.format("[INTEGRACION] PRC[%s] El procedimiento no existe!!, no podemos continuar!.", prcUUID);
			logger.error(errorMsg);
			throw new IntegrationDataException(errorMsg);
		}
		return prc;
	}
	
	@Override
	protected void doAction(DataContainerPayload payload) {

		try {
			DecisionProcedimientoPayload decisionProcedimientoPayload = new DecisionProcedimientoPayload(payload);
			String asuGUID = decisionProcedimientoPayload.getProcedimiento().getAsunto().getGuid();
			String prcUUID = getGuidProcedimiento(decisionProcedimientoPayload);
			
			if (payload.getTipo().equals(IntegracionBpmService.TIPO_DATOS_DECISION_PROCEDIMIENTO)) {
				logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] Guardando decisión procedimiento...", asuGUID, prcUUID));
				
				MEJDtoDecisionProcedimiento dtoDecisionProcedimiento = load(decisionProcedimientoPayload);
				MEJProcedimiento prc = getProcedimiento(decisionProcedimientoPayload); 
						
				dtoDecisionProcedimiento.setIdProcedimiento(prc.getId());
			     
				DecisionProcedimiento dec = decisionProcedimientoManager.getDecisionProcedimientoByGuid(dtoDecisionProcedimiento.getGuid());
				if(dec == null) {
					dec = new DecisionProcedimiento();
			 	}
		        dtoDecisionProcedimiento.setDecisionProcedimiento(dec);
		        
		        ConfiguradorPropuesta configuradorPropuesta = new ConfiguradorPropuesta();
		        
		        switch (TipoTratamiento.valueOf(tratamientoDecision)) {
				case CREAR_Y_DERIVAR:
					
					decisionProcedimientoManager.aceptarPropuestaSinControl(dtoDecisionProcedimiento, configuradorPropuesta);
					break;
				case SOLO_CREAR:
		     
			        configuradorPropuesta.setConfiguracion(ConfiguradorPropuesta.SIN_ENVIO_DATOS);
					configuradorPropuesta.setConfiguracion(ConfiguradorPropuesta.SIN_BPMS);
					decisionProcedimientoManager.aceptarPropuestaSinControl(dtoDecisionProcedimiento, configuradorPropuesta);
					
					break;
				default:
					logger.error("El tipo de tratamiento recibido no corresponde con ninguno de los declarados. La decisión no se ha creado");
					break;
				}
			}
		}
		catch(Exception e) {
			String msg = "[INTEGRACION] La Decisión sobre el Procedimiento no se ha podido crear.";
			logger.error(msg, e);
			throw new IntegrationDataException(msg);
		}
	}

	private MEJDtoDecisionProcedimiento load(
			DecisionProcedimientoPayload decisionProcedimientoPayload) {
		
		MEJDtoDecisionProcedimiento dtoDecisionProcedimiento = new MEJDtoDecisionProcedimiento();
		dtoDecisionProcedimiento.setGuid(decisionProcedimientoPayload.getGuid());
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
		
		if(decisionProcedimientoPayload.getProcedimientoDerivado() != null) {
			List<DtoProcedimientoDerivado> dtoProcedimientoDerivados = new ArrayList<DtoProcedimientoDerivado>();
			
			for(ProcedimientoDerivadoPayload procedimientoDerivadoPayload : decisionProcedimientoPayload.getProcedimientoDerivado()) {
				
				DtoProcedimientoDerivado dtoProcedimientoDerivado = new DtoProcedimientoDerivado();
				
				ProcedimientoDerivado procedimientoDerivado = procedimientoDerivadoManager.getProcedimientoDerivadoByGuid(procedimientoDerivadoPayload.getGuid());
				if(procedimientoDerivado != null) {
					dtoProcedimientoDerivado.setId(procedimientoDerivado.getId());
					dtoProcedimientoDerivado.setProcedimientoDerivado(procedimientoDerivado);
				}
				
				dtoProcedimientoDerivado.setGuid(procedimientoDerivadoPayload.getGuid());
				
				Long[] lPersonas = new Long[procedimientoDerivadoPayload.getPersonas().size()];
				int i = 0;
				
				for(String codClienteEntidad : procedimientoDerivadoPayload.getPersonas()) {
					
					Persona persona = personaManager.getByCodigo(codClienteEntidad);
					if(persona != null) {
						lPersonas[i] = persona.getId();
					}
					else {
						lPersonas[i] = null;
					}
					
					i++;
				}
				
				dtoProcedimientoDerivado.setPersonas(lPersonas);
				
				MEJProcedimiento prcPadre = extProcedimientoManager.getProcedimientoByGuid(procedimientoDerivadoPayload.getGuidProcedimientoPadre());
				if (prcPadre==null) {
					throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento con guid %s asociado al procedimiento derivado s no existe", procedimientoDerivadoPayload.getGuidProcedimientoPadre())); 
				}
				
				dtoProcedimientoDerivado.setProcedimientoPadre(prcPadre.getId());
				
				if(procedimientoDerivadoPayload.getGuidProcedimientoHijo() != null) {
					MEJProcedimiento prcHijo = extProcedimientoManager.getProcedimientoByGuid(procedimientoDerivadoPayload.getGuidProcedimientoHijo());
					if(prcHijo != null) {
						dtoProcedimientoDerivado.setProcedimientoHijo(prcHijo.getId());
					}
				}
				
				dtoProcedimientoDerivado.setTipoActuacion(procedimientoDerivadoPayload.getTipoActuacion());
				dtoProcedimientoDerivado.setTipoReclamacion(procedimientoDerivadoPayload.getTipoReclamacion());
				dtoProcedimientoDerivado.setTipoProcedimiento(procedimientoDerivadoPayload.getTipoProcedimiento());
				dtoProcedimientoDerivado.setPorcentajeRecuperacion(procedimientoDerivadoPayload.getPorcentajeRecuperacion());
				dtoProcedimientoDerivado.setPlazoRecuperacion(procedimientoDerivadoPayload.getPlazoRecuperacion());
				dtoProcedimientoDerivado.setSaldoRecuperacion(procedimientoDerivadoPayload.getSaldoRecuperacion());
				
				dtoProcedimientoDerivados.add(dtoProcedimientoDerivado);
			}
			
			dtoDecisionProcedimiento.setProcedimientosDerivados(dtoProcedimientoDerivados);
		}
		
		dtoDecisionProcedimiento.setStrEstadoDecision(decisionProcedimientoPayload.getEstadoDecision());
		dtoDecisionProcedimiento.setEntidad(decisionProcedimientoPayload.getEntidad());
		
		return dtoDecisionProcedimiento;
	}
}
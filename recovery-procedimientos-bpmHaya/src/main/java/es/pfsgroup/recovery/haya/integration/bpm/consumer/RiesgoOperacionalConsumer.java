package es.pfsgroup.recovery.haya.integration.bpm.consumer;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.contrato.ContratoManager;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.recovery.ext.impl.contrato.EXTContratoManager;
import es.pfsgroup.recovery.haya.integration.bpm.RiesgoOperacionalPayload;
import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.hrebcc.manager.RiesgoOperacionalManager;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;

public class RiesgoOperacionalConsumer extends ConsumerAction<DataContainerPayload> {
	protected final Log logger = LogFactory.getLog(getClass());
	
	public RiesgoOperacionalConsumer(Rule<DataContainerPayload> rules) {
		super(rules);
	}
	
	public RiesgoOperacionalConsumer(List<Rule<DataContainerPayload>> rules) {
		super(rules);
	}
	
	@Autowired
	private RiesgoOperacionalManager riesgoManager;
	@Autowired
	private ContratoManager contratoManager;
	@Autowired
	private EXTContratoManager extContratoManager;

	private ActualizarRiesgoOperacionalDto load(RiesgoOperacionalPayload riesgoPayload) 
	{
		String riesgoGuid = riesgoPayload.getGuid(); //tambien es el nro de contrato
		ActualizarRiesgoOperacionalDto riesgoDto = new ActualizarRiesgoOperacionalDto();
		
		Contrato contrato = new Contrato();
		contrato = extContratoManager.getContraoByNroContrato(riesgoGuid);
		if (contrato == null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El contrato con numero %s no existe", riesgoGuid)); 
		}
		if (contrato.getId() != null) {
			riesgoDto.setIdContrato(Long.valueOf(contrato.getId()));
		}
		
		if (riesgoPayload.getCodigoRiesgoOperacional() != null) {
			riesgoDto.setCodRiesgoOperacional(riesgoPayload.getCodigoRiesgoOperacional());
		}
		
		riesgoDto.setEnviarDatos(false);
		
		return riesgoDto;
	}	

		
	@Override
	protected void doAction(DataContainerPayload payLoad) {
		logger.info("[INTEGRACION] Entro al doaction del consumer de riesgo operacional");
		RiesgoOperacionalPayload riesgoPyload = new RiesgoOperacionalPayload(payLoad);
		
		String guid = riesgoPyload.getGuid(); //el guid es el numero de contrato
		//DDRiesgoOperacional riesgo = riesgoManager.getRiesgoByGuid(riesgoPyload.getGuid());
		if(guid != null) {
			ActualizarRiesgoOperacionalDto riesgoDto = load(riesgoPyload);
			riesgoManager.actualizarRiesgoOperacional(riesgoDto);
		}
	}
}

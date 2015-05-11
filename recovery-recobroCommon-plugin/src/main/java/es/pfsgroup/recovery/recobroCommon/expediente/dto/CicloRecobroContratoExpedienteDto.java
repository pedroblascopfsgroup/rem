package es.pfsgroup.recovery.recobroCommon.expediente.dto;

import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.pfsgroup.recovery.recobroCommon.contrato.model.CicloRecobroContrato;

public class CicloRecobroContratoExpedienteDto extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -2892302940529255574L;
	
	private ExpedienteContrato expedienteContrato;
	
	private List<CicloRecobroContrato> ciclosRecobroContrato;

	public ExpedienteContrato getExpedienteContrato() {
		return expedienteContrato;
	}

	public void setExpedienteContrato(ExpedienteContrato expedienteContrato) {
		this.expedienteContrato = expedienteContrato;
	}

	public List<CicloRecobroContrato> getCiclosRecobroContrato() {
		return ciclosRecobroContrato;
	}

	public void setCiclosRecobroContrato(
			List<CicloRecobroContrato> ciclosRecobroContrato) {
		this.ciclosRecobroContrato = ciclosRecobroContrato;
	}
	
	

}

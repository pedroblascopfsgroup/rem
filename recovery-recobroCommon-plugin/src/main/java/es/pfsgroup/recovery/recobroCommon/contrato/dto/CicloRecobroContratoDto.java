package es.pfsgroup.recovery.recobroCommon.contrato.dto;

import es.capgemini.devon.dto.WebDto;

public class CicloRecobroContratoDto extends WebDto {

	private static final long serialVersionUID = 3304686631954294025L;
	
	private Long idExpediente;
	private Long idCicloRecobroExp;
	private Long idContrato;

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public Long getIdCicloRecobroExp() {
		return idCicloRecobroExp;
	}

	public void setIdCicloRecobroExp(Long idCicloRecobroExp) {
		this.idCicloRecobroExp = idCicloRecobroExp;
	}

	public Long getIdContrato() {
		return idContrato;
	}

	public void setIdContrato(Long idContrato) {
		this.idContrato = idContrato;
	}

	
}

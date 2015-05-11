package es.pfsgroup.recovery.recobroCommon.persona.dto;

import es.capgemini.devon.dto.WebDto;

public class CicloRecobroPersonaDto extends WebDto {

	private static final long serialVersionUID = 3304686631954294025L;
	
	private Long idExpediente;
	private Long idCicloRecobroExp;
	private Long idPersona;

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

	public Long getIdPersona() {
		return idPersona;
	}

	public void setIdPersona(Long idPersona) {
		this.idPersona = idPersona;
	}

}

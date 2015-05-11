package es.pfsgroup.recovery.recobroCommon.adecuaciones.dto;

import es.capgemini.devon.dto.WebDto;

public class AdecuacionesDto extends WebDto{

	private static final long serialVersionUID = -1937871007129547155L;

	private Long id;
	
	private Long idExpediente;
	
	private Long idContrato;
	

	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public Long getIdContrato() {
		return idContrato;
	}

	public void setIdContrato(Long idContrato) {
		this.idContrato = idContrato;
	}

}

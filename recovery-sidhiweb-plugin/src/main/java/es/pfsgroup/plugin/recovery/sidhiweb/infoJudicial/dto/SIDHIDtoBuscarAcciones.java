package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class SIDHIDtoBuscarAcciones extends WebDto{

	private static final long serialVersionUID = -8728414008054642335L;
	
	private Long idExpediente;
	
	private Long idAsunto;
	
	private Date fechaAccion;

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}

	public Long getIdAsunto() {
		return idAsunto;
	}

	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}

	public Date getFechaAccion() {
		return fechaAccion;
	}
}

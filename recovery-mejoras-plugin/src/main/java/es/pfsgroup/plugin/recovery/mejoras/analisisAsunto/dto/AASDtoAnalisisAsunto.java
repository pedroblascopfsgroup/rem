package es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.dto;

import javax.validation.constraints.NotNull;
import es.capgemini.devon.dto.WebDto;

public class AASDtoAnalisisAsunto extends WebDto{
	
	private static final long serialVersionUID = -4866166840930166908L;

	@NotNull(message="plugin.mejoras.analisisAsunto.dto.dtoAnalisisAsunto.id.null")
	private Long idAsunto;
	
	private String observaciones;
	
	
	public Long getIdAsunto() {
		return idAsunto;
	}

	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

}
package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoExpedienteComercialGestionEconomica extends WebDto {
	private static final long serialVersionUID = 0L;

	private Long id;
	private Integer revisadoPorControllers;
	private Date fechaRevision;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Integer getRevisadoPorControllers() {
		return revisadoPorControllers;
	}
	public void setRevisadoPorControllers(Integer revisadoPorControllers) {
		this.revisadoPorControllers = revisadoPorControllers;
	}
	public Date getFechaRevision() {
		return fechaRevision;
	}
	public void setFechaRevision(Date fechaRevision) {
		this.fechaRevision = fechaRevision;
	}
	
	
}

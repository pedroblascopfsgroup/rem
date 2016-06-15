package es.pfsgroup.plugin.recovery.mejoras.expediente.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class MEJExpedienteSancionDto extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long idExpediente;
	
	private Long id;

	private Date fechaElevacion;

	private Date fechaSancion;

	private String decision;

	private String nWorkFlow;

	private String observaciones;

	
	public Long getIdExpediente() {
		return idExpediente;
	}
	
	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Date getFechaElevacion() {
		return fechaElevacion;
	}

	public void setFechaElevacion(Date fechaElevacion) {
		this.fechaElevacion = fechaElevacion;
	}

	public Date getFechaSancion() {
		return fechaSancion;
	}

	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}

	public String getDecision() {
		return decision;
	}

	public void setDecision(String decision) {
		this.decision = decision;
	}

	public String getnWorkFlow() {
		return nWorkFlow;
	}

	public void setnWorkFlow(String nWorkFlow) {
		this.nWorkFlow = nWorkFlow;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

}

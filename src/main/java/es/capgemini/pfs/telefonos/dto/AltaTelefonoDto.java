package es.capgemini.pfs.telefonos.dto;

import es.capgemini.devon.dto.WebDto;

public class AltaTelefonoDto  extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 665741861104071940L;
	
	private Long idCliente;
	private int prioridad;
	private String numero;
	private String origen;
	private Boolean consentimiento;
	private String tipo;
	private String motivo;
	private String estado;
	private Long idTelefono ;
	private String observaciones;
	
	public Long getIdTelefono() {
		return idTelefono;
	}
	public void setIdTelefono(Long idTelefono) {
		this.idTelefono = idTelefono;
	}	
	public int getPrioridad() {
		return prioridad;
	}
	public void setPrioridad(int prioridad) {
		this.prioridad = prioridad;
	}
	public Long getIdCliente() {
		return idCliente;
	}
	public void setIdCliente(Long idCliente) {
		this.idCliente = idCliente;
	}
	public String getNumero() {
		return numero;
	}
	public void setNumero(String numero) {
		this.numero = numero;
	}
	public String getOrigen() {
		return origen;
	}
	public void setOrigen(String origen) {
		this.origen = origen;
	}
	public Boolean getConsentimiento() {
		return consentimiento;
	}
	public void setConsentimiento(Boolean consentimiento) {
		this.consentimiento = consentimiento;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
}

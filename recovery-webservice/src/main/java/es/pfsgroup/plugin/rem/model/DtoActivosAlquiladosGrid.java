package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoActivosAlquiladosGrid extends WebDto {

	private static final long serialVersionUID = 1L;

	private Long id;
	private Long numActivo;
	private String subTipoActivo;
	private String municipio;
	private String direccion;
	private Double rentaMensual;
	private Double deudaActual;
	private String conDeudas;
	private String inquilino;
	private String ofertante;
	private Date fechaFinContrato;
	private String estadoExpediente;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public String getSubTipoActivo() {
		return subTipoActivo;
	}
	public void setSubTipoActivo(String subTipoActivo) {
		this.subTipoActivo = subTipoActivo;
	}
	public String getMunicipio() {
		return municipio;
	}
	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public Double getRentaMensual() {
		return rentaMensual;
	}
	public void setRentaMensual(Double rentaMensual) {
		this.rentaMensual = rentaMensual;
	}
	public Double getDeudaActual() {
		return deudaActual;
	}
	public void setDeudaActual(Double deudaActual) {
		this.deudaActual = deudaActual;
	}
	public String getConDeudas() {
		return conDeudas;
	}
	public void setConDeudas(String conDeudas) {
		this.conDeudas = conDeudas;
	}
	public String getInquilino() {
		return inquilino;
	}
	public void setInquilino(String inquilino) {
		this.inquilino = inquilino;
	}
	public String getOfertante() {
		return ofertante;
	}
	public void setOfertante(String ofertante) {
		this.ofertante = ofertante;
	}
	public Date getFechaFinContrato() {
		return fechaFinContrato;
	}
	public void setFechaFinContrato(Date fechaFinContrato) {
		this.fechaFinContrato = fechaFinContrato;
	}
	public String getEstadoExpediente() {
		return estadoExpediente;
	}
	public void setEstadoExpediente(String estadoExpediente) {
		this.estadoExpediente = estadoExpediente;
	}
}

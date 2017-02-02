package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoFormalizacionFinanciacion extends WebDto {

	private static final long serialVersionUID = 1L;

	private String id; // ID del expediente.
	private String numExpedienteRiesgo;
	private Integer solicitaFinanciacion;
	private String tiposFinanciacionCodigo;
	private String estadosFinanciacion;
	private Double capitalConcedido;
	private Date fechaInicioFinanciacion;
	private Date fechaFinFinanciacion;
	private String entidadFinanciacion;
	private Date fechaInicioExpediente;
	
	
	public String getNumExpedienteRiesgo() {
		return numExpedienteRiesgo;
	}
	public void setNumExpedienteRiesgo(String numExpedienteRiesgo) {
		this.numExpedienteRiesgo = numExpedienteRiesgo;
	}
	public Integer getSolicitaFinanciacion() {
		return solicitaFinanciacion;
	}
	public void setSolicitaFinanciacion(Integer solicitaFinanciacion) {
		this.solicitaFinanciacion = solicitaFinanciacion;
	}
	public String getTiposFinanciacionCodigo() {
		return tiposFinanciacionCodigo;
	}
	public void setTiposFinanciacionCodigo(String tiposFinanciacionCodigo) {
		this.tiposFinanciacionCodigo = tiposFinanciacionCodigo;
	}
	public String getEstadosFinanciacion() {
		return estadosFinanciacion;
	}
	public void setEstadosFinanciacion(String estadosFinanciacion) {
		this.estadosFinanciacion = estadosFinanciacion;
	}
	public Double getCapitalConcedido() {
		return capitalConcedido;
	}
	public void setCapitalConcedido(Double capitalConcedido) {
		this.capitalConcedido = capitalConcedido;
	}
	public Date getFechaInicioFinanciacion() {
		return fechaInicioFinanciacion;
	}
	public void setFechaInicioFinanciacion(Date fechaInicioFinanciacion) {
		this.fechaInicioFinanciacion = fechaInicioFinanciacion;
	}
	public Date getFechaFinFinanciacion() {
		return fechaFinFinanciacion;
	}
	public void setFechaFinFinanciacion(Date fechaFinFinanciacion) {
		this.fechaFinFinanciacion = fechaFinFinanciacion;
	}
	public String getEntidadFinanciacion() {
		return entidadFinanciacion;
	}
	public void setEntidadFinanciacion(String entidadFinanciacion) {
		this.entidadFinanciacion = entidadFinanciacion;
	}
	public Date getFechaInicioExpediente() {
		return fechaInicioExpediente;
	}
	public void setFechaInicioExpediente(Date fechaInicioExpediente) {
		this.fechaInicioExpediente = fechaInicioExpediente;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}


}
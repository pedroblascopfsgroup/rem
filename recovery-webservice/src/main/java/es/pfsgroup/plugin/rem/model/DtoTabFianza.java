package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoTabFianza extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long idFianza;
	private Date agendacionIngreso;
	private Double importeFianza;
	private Date fechaIngreso;
	private String cuentaVirtual;
	private String ibanDevolucion;
	
	public Date getAgendacionIngreso() {
		return agendacionIngreso;
	}
	public void setAgendacionIngreso(Date agendacionIngreso) {
		this.agendacionIngreso = agendacionIngreso;
	}
	public Double getImporteFianza() {
		return importeFianza;
	}
	public void setImporteFianza(Double importeFianza) {
		this.importeFianza = importeFianza;
	}
	public Date getFechaIngreso() {
		return fechaIngreso;
	}
	public void setFechaIngreso(Date fechaIngreso) {
		this.fechaIngreso = fechaIngreso;
	}
	public String getCuentaVirtual() {
		return cuentaVirtual;
	}
	public void setCuentaVirtual(String cuentaVirtual) {
		this.cuentaVirtual = cuentaVirtual;
	}
	public String getIbanDevolucion() {
		return ibanDevolucion;
	}
	public void setIbanDevolucion(String ibanDevolucion) {
		this.ibanDevolucion = ibanDevolucion;
	}
	public Long getIdFianza() {
		return idFianza;
	}
	public void setIdFianza(Long idFianza) {
		this.idFianza = idFianza;
	}


	
}

package es.pfsgroup.plugin.rem.model;


import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de listado del histórico de concurrencia en comercial del activo
 */
public class DtoHistoricoConcurrencia extends WebDto {
	private static final long serialVersionUID = 0L;

	private Long id;
	private Long idActivo;
	private Long numActivo;
	private Long idAgrupacion;
	private Long numAgrupacion;
	private Long numActivoAgrupacion;
	private Double importeMinOferta;
	private Double importeDeposito;
	private Date fechaInicio;
	private Date fechaFin;
	private Boolean concurrencia;
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Date getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public Date getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}
	public Long getIdAgrupacion() {
		return idAgrupacion;
	}
	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public Long getNumAgrupacion() {
		return numAgrupacion;
	}
	public void setNumAgrupacion(Long numAgrupacion) {
		this.numAgrupacion = numAgrupacion;
	}
	public Double getImporteMinOferta() {
		return importeMinOferta;
	}
	public void setImporteMinOferta(Double importeMinOferta) {
		this.importeMinOferta = importeMinOferta;
	}
	public Double getImporteDeposito() {
		return importeDeposito;
	}
	public void setImporteDeposito(Double importeDeposito) {
		this.importeDeposito = importeDeposito;
	}
	public Long getNumActivoAgrupacion() {
		return numActivoAgrupacion;
	}
	public void setNumActivoAgrupacion(Long numActivoAgrupacion) {
		this.numActivoAgrupacion = numActivoAgrupacion;
	}
	public Boolean getConcurrencia() {
		return concurrencia;
	}
	public void setConcurrencia(Boolean concurrencia) {
		this.concurrencia = concurrencia;
	}
	
}
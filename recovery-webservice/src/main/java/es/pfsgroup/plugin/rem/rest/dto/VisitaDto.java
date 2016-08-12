package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

public class VisitaDto implements Serializable{

	private static final long serialVersionUID = 3773651686763584927L;
	
	private Long idVisitaWebcom;
	private Long idClienteRem;
	private Long idActivoHaya;
	private Long idEstadoVisita;
	private Long idDetalleEstadoVisita;
	private Date fecha;
	public Long getIdVisitaWebcom() {
		return idVisitaWebcom;
	}
	public void setIdVisitaWebcom(Long idVisitaWebcom) {
		this.idVisitaWebcom = idVisitaWebcom;
	}
	public Long getIdClienteRem() {
		return idClienteRem;
	}
	public void setIdClienteRem(Long idClienteRem) {
		this.idClienteRem = idClienteRem;
	}
	public Long getIdActivoHaya() {
		return idActivoHaya;
	}
	public void setIdActivoHaya(Long idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}
	public Long getIdEstadoVisita() {
		return idEstadoVisita;
	}
	public void setIdEstadoVisita(Long idEstadoVisita) {
		this.idEstadoVisita = idEstadoVisita;
	}
	public Long getIdDetalleEstadoVisita() {
		return idDetalleEstadoVisita;
	}
	public void setIdDetalleEstadoVisita(Long idDetalleEstadoVisita) {
		this.idDetalleEstadoVisita = idDetalleEstadoVisita;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	
	
}

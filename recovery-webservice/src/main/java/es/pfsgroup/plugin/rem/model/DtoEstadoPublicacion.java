package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para el histórico de estados de las publicaciones de los activos
 * @author Daniel Gutiérrez
 *
 */
public class DtoEstadoPublicacion {
	private Long idActivo;
	private Date fechaDesde;
	private Date fechaHasta;
	private String portal;
	private String tipoPublicacion;
	private String estadoPublicacion;
	private String motivo;
	private Long diasPeriodo;


	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Date getFechaDesde() {
		return fechaDesde;
	}
	public void setFechaDesde(Date fechaDesde) {
		this.fechaDesde = fechaDesde;
	}
	public Date getFechaHasta() {
		return fechaHasta;
	}
	public void setFechaHasta(Date fechaHasta) {
		this.fechaHasta = fechaHasta;
	}
	public String getPortal() {
		return portal;
	}
	public void setPortal(String portal) {
		this.portal = portal;
	}
	public String getTipoPublicacion() {
		return tipoPublicacion;
	}
	public void setTipoPublicacion(String tipoPublicacion) {
		this.tipoPublicacion = tipoPublicacion;
	}
	public String getEstadoPublicacion() {
		return estadoPublicacion;
	}
	public void setEstadoPublicacion(String estadoPublicacion) {
		this.estadoPublicacion = estadoPublicacion;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public Long getDiasPeriodo() {
		return diasPeriodo;
	}
	public void setDiasPeriodo(Long diasPeriodo) {
		this.diasPeriodo = diasPeriodo;
	}

}
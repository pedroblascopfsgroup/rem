package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Pojo para el histórico de estados, venta y alquiler, de las publicaciones de los activos.
 */
public class DtoHistoricoEstadoPublicacion {

	private Long idActivo;
	private Date fechaDesde;
	private Date fechaHasta;
	private Boolean oculto;
	private String tipoPublicacion;
	private String motivo;
	private String usuario;
	private String estadoPublicacion;
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

	public Boolean getOculto() {
		return oculto;
	}

	public void setOculto(Boolean oculto) {
		this.oculto = oculto;
	}

	public String getTipoPublicacion() {
		return tipoPublicacion;
	}

	public void setTipoPublicacion(String tipoPublicacion) {
		this.tipoPublicacion = tipoPublicacion;
	}

	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public String getEstadoPublicacion() {
		return estadoPublicacion;
	}

	public void setEstadoPublicacion(String estadoPublicacion) {
		this.estadoPublicacion = estadoPublicacion;
	}

	public Long getDiasPeriodo() {
		return diasPeriodo;
	}

	public void setDiasPeriodo(Long diasPeriodo) {
		this.diasPeriodo = diasPeriodo;
	}

}
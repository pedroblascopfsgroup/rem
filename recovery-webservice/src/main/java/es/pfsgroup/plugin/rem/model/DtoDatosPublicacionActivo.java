package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

import java.util.Date;

/**
 * Dto para los datos de publicación de los activos.
 */
public class DtoDatosPublicacionActivo extends WebDto {

	private Long idActivo;
	private String estadoPublicacionVenta;
	private String estadoPublicacionAlquiler;
	private Double precioWebVenta;
	private Double precioWebAlquiler;
	private String adecuacionAlquilerCodigo;
	private Integer totalDiasPublicadoVenta;
	private Integer totalDiasPublicadoAlquiler;
	private Boolean publicarVenta;
	private Boolean ocultarVenta;
	private Boolean publicarSinPrecioVenta;
	private Boolean noMostrarPrecioVenta;
	private String motivoOcultacionVentaCodigo;
	private String motivoOcultacionManualVenta;
	private Boolean publicarAlquiler;
	private Boolean ocultarAlquiler;
	private Boolean publicarSinPrecioAlquiler;
	private Boolean noMostrarPrecioAlquiler;
	private String motivoOcultacionAlquilerCodigo;
	private String motivoOcultacionManualAlquiler;
	private Boolean deshabilitarCheckPublicarVenta;
	private Boolean deshabilitarCheckOcultarVenta;
	private Boolean deshabilitarCheckPublicarSinPrecioVenta;
	private Boolean deshabilitarCheckNoMostrarPrecioVenta;
	private Boolean deshabilitarCheckPublicarAlquiler;
	private Boolean deshabilitarCheckOcultarAlquiler;
	private Boolean deshabilitarCheckPublicarSinPrecioAlquiler;
	private Boolean deshabilitarCheckNoMostrarPrecioAlquiler;
	private Date fechaInicioEstadoVenta;
	private Date fechaInicioEstadoAlquiler;
	private String tipoPublicacionVentaCodigo;
	private String tipoPublicacionAlquilerCodigo;
	private String tipoPublicacionVentaDescripcion;
	private String tipoPublicacionAlquilerDescripcion;
	private String eleccionUsuarioTipoPublicacionAlquiler;
	private String motivoPublicacion;


	public String getTipoPublicacionVentaDescripcion() {
		return tipoPublicacionVentaDescripcion;
	}

	public void setTipoPublicacionVentaDescripcion(String tipoPublicacionVentaDescripcion) {
		this.tipoPublicacionVentaDescripcion = tipoPublicacionVentaDescripcion;
	}

	public String getTipoPublicacionAlquilerDescripcion() {
		return tipoPublicacionAlquilerDescripcion;
	}

	public void setTipoPublicacionAlquilerDescripcion(String tipoPublicacionAlquilerDescripcion) {
		this.tipoPublicacionAlquilerDescripcion = tipoPublicacionAlquilerDescripcion;
	}

	public Date getFechaInicioEstadoVenta() {
		return fechaInicioEstadoVenta;
	}

	public void setFechaInicioEstadoVenta(Date fechaInicioEstadoVenta) {
		this.fechaInicioEstadoVenta = fechaInicioEstadoVenta;
	}

	public Date getFechaInicioEstadoAlquiler() {
		return fechaInicioEstadoAlquiler;
	}

	public void setFechaInicioEstadoAlquiler(Date fechaInicioEstadoAlquiler) {
		this.fechaInicioEstadoAlquiler = fechaInicioEstadoAlquiler;
	}

	public String getTipoPublicacionVentaCodigo() {
		return tipoPublicacionVentaCodigo;
	}

	public void setTipoPublicacionVentaCodigo(String tipoPublicacionVentaCodigo) {
		this.tipoPublicacionVentaCodigo = tipoPublicacionVentaCodigo;
	}

	public String getTipoPublicacionAlquilerCodigo() {
		return tipoPublicacionAlquilerCodigo;
	}

	public void setTipoPublicacionAlquilerCodigo(String tipoPublicacionAlquilerCodigo) {
		this.tipoPublicacionAlquilerCodigo = tipoPublicacionAlquilerCodigo;
	}

	public String getAdecuacionAlquilerCodigo() {
		return adecuacionAlquilerCodigo;
	}

	public void setAdecuacionAlquilerCodigo(String adecuacionAlquilerCodigo) {
		this.adecuacionAlquilerCodigo = adecuacionAlquilerCodigo;
	}

	public Double getPrecioWebVenta() {
		return precioWebVenta;
	}

	public void setPrecioWebVenta(Double precioWebVenta) {
		this.precioWebVenta = precioWebVenta;
	}

	public Double getPrecioWebAlquiler() {
		return precioWebAlquiler;
	}

	public void setPrecioWebAlquiler(Double precioWebAlquiler) {
		this.precioWebAlquiler = precioWebAlquiler;
	}

	public Boolean getDeshabilitarCheckPublicarVenta() {
		return deshabilitarCheckPublicarVenta;
	}

	public void setDeshabilitarCheckPublicarVenta(Boolean deshabilitarCheckPublicarVenta) {
		this.deshabilitarCheckPublicarVenta = deshabilitarCheckPublicarVenta;
	}

	public Boolean getDeshabilitarCheckOcultarVenta() {
		return deshabilitarCheckOcultarVenta;
	}

	public void setDeshabilitarCheckOcultarVenta(Boolean deshabilitarCheckOcultarVenta) {
		this.deshabilitarCheckOcultarVenta = deshabilitarCheckOcultarVenta;
	}

	public Boolean getDeshabilitarCheckPublicarSinPrecioVenta() {
		return deshabilitarCheckPublicarSinPrecioVenta;
	}

	public void setDeshabilitarCheckPublicarSinPrecioVenta(Boolean deshabilitarCheckPublicarSinPrecioVenta) {
		this.deshabilitarCheckPublicarSinPrecioVenta = deshabilitarCheckPublicarSinPrecioVenta;
	}

	public Boolean getDeshabilitarCheckNoMostrarPrecioVenta() {
		return deshabilitarCheckNoMostrarPrecioVenta;
	}

	public void setDeshabilitarCheckNoMostrarPrecioVenta(Boolean deshabilitarCheckNoMostrarPrecioVenta) {
		this.deshabilitarCheckNoMostrarPrecioVenta = deshabilitarCheckNoMostrarPrecioVenta;
	}

	public Boolean getDeshabilitarCheckPublicarAlquiler() {
		return deshabilitarCheckPublicarAlquiler;
	}

	public void setDeshabilitarCheckPublicarAlquiler(Boolean deshabilitarCheckPublicarAlquiler) {
		this.deshabilitarCheckPublicarAlquiler = deshabilitarCheckPublicarAlquiler;
	}

	public Boolean getDeshabilitarCheckOcultarAlquiler() {
		return deshabilitarCheckOcultarAlquiler;
	}

	public void setDeshabilitarCheckOcultarAlquiler(Boolean deshabilitarCheckOcultarAlquiler) {
		this.deshabilitarCheckOcultarAlquiler = deshabilitarCheckOcultarAlquiler;
	}

	public Boolean getDeshabilitarCheckPublicarSinPrecioAlquiler() {
		return deshabilitarCheckPublicarSinPrecioAlquiler;
	}

	public void setDeshabilitarCheckPublicarSinPrecioAlquiler(Boolean deshabilitarCheckPublicarSinPrecioAlquiler) {
		this.deshabilitarCheckPublicarSinPrecioAlquiler = deshabilitarCheckPublicarSinPrecioAlquiler;
	}

	public Boolean getDeshabilitarCheckNoMostrarPrecioAlquiler() {
		return deshabilitarCheckNoMostrarPrecioAlquiler;
	}

	public void setDeshabilitarCheckNoMostrarPrecioAlquiler(Boolean deshabilitarCheckNoMostrarPrecioAlquiler) {
		this.deshabilitarCheckNoMostrarPrecioAlquiler = deshabilitarCheckNoMostrarPrecioAlquiler;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getEstadoPublicacionVenta() {
		return estadoPublicacionVenta;
	}

	public void setEstadoPublicacionVenta(String estadoPublicacionVenta) {
		this.estadoPublicacionVenta = estadoPublicacionVenta;
	}

	public String getEstadoPublicacionAlquiler() {
		return estadoPublicacionAlquiler;
	}

	public void setEstadoPublicacionAlquiler(String estadoPublicacionAlquiler) {
		this.estadoPublicacionAlquiler = estadoPublicacionAlquiler;
	}

	public Integer getTotalDiasPublicadoVenta() {
		return totalDiasPublicadoVenta;
	}

	public void setTotalDiasPublicadoVenta(Integer totalDiasPublicadoVenta) {
		this.totalDiasPublicadoVenta = totalDiasPublicadoVenta;
	}

	public Integer getTotalDiasPublicadoAlquiler() {
		return totalDiasPublicadoAlquiler;
	}

	public void setTotalDiasPublicadoAlquiler(Integer totalDiasPublicadoAlquiler) {
		this.totalDiasPublicadoAlquiler = totalDiasPublicadoAlquiler;
	}

	public Boolean getPublicarVenta() {
		return publicarVenta;
	}

	public void setPublicarVenta(Boolean publicarVenta) {
		this.publicarVenta = publicarVenta;
	}

	public Boolean getOcultarVenta() {
		return ocultarVenta;
	}

	public void setOcultarVenta(Boolean ocultarVenta) {
		this.ocultarVenta = ocultarVenta;
	}

	public Boolean getPublicarSinPrecioVenta() {
		return publicarSinPrecioVenta;
	}

	public void setPublicarSinPrecioVenta(Boolean publicarSinPrecioVenta) {
		this.publicarSinPrecioVenta = publicarSinPrecioVenta;
	}

	public Boolean getNoMostrarPrecioVenta() {
		return noMostrarPrecioVenta;
	}

	public void setNoMostrarPrecioVenta(Boolean noMostrarPrecioVenta) {
		this.noMostrarPrecioVenta = noMostrarPrecioVenta;
	}

	public String getMotivoOcultacionVentaCodigo() {
		return motivoOcultacionVentaCodigo;
	}

	public void setMotivoOcultacionVentaCodigo(String motivoOcultacionVentaCodigo) {
		this.motivoOcultacionVentaCodigo = motivoOcultacionVentaCodigo;
	}

	public String getMotivoOcultacionManualVenta() {
		return motivoOcultacionManualVenta;
	}

	public void setMotivoOcultacionManualVenta(String motivoOcultacionManualVenta) {
		this.motivoOcultacionManualVenta = motivoOcultacionManualVenta;
	}

	public Boolean getPublicarAlquiler() {
		return publicarAlquiler;
	}

	public void setPublicarAlquiler(Boolean publicarAlquiler) {
		this.publicarAlquiler = publicarAlquiler;
	}

	public Boolean getOcultarAlquiler() {
		return ocultarAlquiler;
	}

	public void setOcultarAlquiler(Boolean ocultarAlquiler) {
		this.ocultarAlquiler = ocultarAlquiler;
	}

	public Boolean getPublicarSinPrecioAlquiler() {
		return publicarSinPrecioAlquiler;
	}

	public void setPublicarSinPrecioAlquiler(Boolean publicarSinPrecioAlquiler) {
		this.publicarSinPrecioAlquiler = publicarSinPrecioAlquiler;
	}

	public Boolean getNoMostrarPrecioAlquiler() {
		return noMostrarPrecioAlquiler;
	}

	public void setNoMostrarPrecioAlquiler(Boolean noMostrarPrecioAlquiler) {
		this.noMostrarPrecioAlquiler = noMostrarPrecioAlquiler;
	}

	public String getMotivoOcultacionAlquilerCodigo() {
		return motivoOcultacionAlquilerCodigo;
	}

	public void setMotivoOcultacionAlquilerCodigo(String motivoOcultacionAlquilerCodigo) {
		this.motivoOcultacionAlquilerCodigo = motivoOcultacionAlquilerCodigo;
	}

	public String getMotivoOcultacionManualAlquiler() {
		return motivoOcultacionManualAlquiler;
	}

	public void setMotivoOcultacionManualAlquiler(String motivoOcultacionManualAlquiler) {
		this.motivoOcultacionManualAlquiler = motivoOcultacionManualAlquiler;
	}

	public String getEleccionUsuarioTipoPublicacionAlquiler() {
		return eleccionUsuarioTipoPublicacionAlquiler;
	}

	public void setEleccionUsuarioTipoPublicacionAlquiler(String eleccionUsuarioTipoPublicacionAlquiler) {
		this.eleccionUsuarioTipoPublicacionAlquiler = eleccionUsuarioTipoPublicacionAlquiler;
	}

	public String getMotivoPublicacion() {
		return motivoPublicacion;
	}

	public void setMotivoPublicacion(String motivoPublicacion) {
		this.motivoPublicacion = motivoPublicacion;
	}

}
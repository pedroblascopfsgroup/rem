package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para el histórico del mediador de informe comercial del activo.
 *
 */
public class DtoHistoricoMediador {
	private String id;
	private Long idActivo;
	private Date fechaDesde;
	private Date fechaHasta;
	private String codigo;
	private String mediador;
	private String telefono;
	private String email;
	private String responsableCambio;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
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
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getMediador() {
		return mediador;
	}
	public void setMediador(String mediador) {
		this.mediador = mediador;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public void setIdEntidad(Long idEntidad) {
		this.idActivo = idEntidad;
	}
	public String getResponsableCambio() {
		return responsableCambio;
	}
	public void setResponsableCambio(String responsableCambio) {
		this.responsableCambio = responsableCambio;
	}
	
	
}
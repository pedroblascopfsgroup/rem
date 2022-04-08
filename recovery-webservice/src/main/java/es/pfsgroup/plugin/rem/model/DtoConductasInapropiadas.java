package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de conductas inapropiadas
 */
public class DtoConductasInapropiadas extends WebDto {
	private static final long serialVersionUID = 0L;

	private Long id;
	private Long idProveedor;
	private String usuarioAlta;
	private Date fechaAlta;
	private String tipoConducta;
	private String categoriaConducta;
	private String categoriaConductaCodigo;
	private String nivelConducta;
	private String comentarios;
	private String delegacion;
	private String adjunto;
	private String idAdjunto;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdProveedor() {
		return idProveedor;
	}
	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}
	public String getUsuarioAlta() {
		return usuarioAlta;
	}
	public void setUsuarioAlta(String usuarioAlta) {
		this.usuarioAlta = usuarioAlta;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getCategoriaConductaCodigo() {
		return categoriaConductaCodigo;
	}
	public void setCategoriaConductaCodigo(String categoriaConductaCodigo) {
		this.categoriaConductaCodigo = categoriaConductaCodigo;
	}
	public String getComentarios() {
		return comentarios;
	}
	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}
	public String getDelegacion() {
		return delegacion;
	}
	public void setDelegacion(String delegacion) {
		this.delegacion = delegacion;
	}
	public String getTipoConducta() {
		return tipoConducta;
	}
	public void setTipoConducta(String tipoConducta) {
		this.tipoConducta = tipoConducta;
	}
	public String getCategoriaConducta() {
		return categoriaConducta;
	}
	public void setCategoriaConducta(String categoriaConducta) {
		this.categoriaConducta = categoriaConducta;
	}
	public String getNivelConducta() {
		return nivelConducta;
	}
	public void setNivelConducta(String nivelConducta) {
		this.nivelConducta = nivelConducta;
	}
	public String getAdjunto() {
		return adjunto;
	}
	public void setAdjunto(String adjunto) {
		this.adjunto = adjunto;
	}
	public String getIdAdjunto() {
		return idAdjunto;
	}
	public void setIdAdjunto(String idAdjunto) {
		this.idAdjunto = idAdjunto;
	}
}
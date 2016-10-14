package es.pfsgroup.plugin.rem.rest.dto;

import java.util.Date;

import javax.validation.constraints.NotNull;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;

public class NotificacionDto extends RequestDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3044750907326664322L;
	
	@NotNull(groups = { Insert.class})
	private Long idNotificacionWebcom;
	
	private Long idNotificacionRem;
	
	@NotNull(groups = { Insert.class})
	private Long idActivoHaya;
	
	@NotNull(groups = { Insert.class})
	private String codTipoNotificacion;
	
	@NotNull(groups = { Insert.class})
	private String titulo;
	
	private String descripcion;
	
	private Date fechaRealizacion;
	
	@NotNull(groups = { Insert.class})
	private Date fechaAccion;
	
	private Long idUsuarioDestinoRem;
	
	@NotNull(groups = { Insert.class})
	@Diccionary(clase = Usuario.class, foreingField="id",message = "El idUsuarioRemAccion no existe", groups = { Insert.class})
	private Long idUsuarioRemAccion;

	public Long getIdNotificacionWebcom() {
		return idNotificacionWebcom;
	}

	public void setIdNotificacionWebcom(Long idNotificacionWebcom) {
		this.idNotificacionWebcom = idNotificacionWebcom;
	}

	public Long getIdNotificacionRem() {
		return idNotificacionRem;
	}

	public void setIdNotificacionRem(Long idNotificacionRem) {
		this.idNotificacionRem = idNotificacionRem;
	}

	public Long getIdActivoHaya() {
		return idActivoHaya;
	}

	public void setIdActivoHaya(Long idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}

	public String getCodTipoNotificacion() {
		return codTipoNotificacion;
	}

	public void setCodTipoNotificacion(String codTipoNotificacion) {
		this.codTipoNotificacion = codTipoNotificacion;
	}

	public String getTitulo() {
		return titulo;
	}

	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Date getFechaRealizacion() {
		return fechaRealizacion;
	}

	public void setFechaRealizacion(Date fechaRealizacion) {
		this.fechaRealizacion = fechaRealizacion;
	}

	public Long getIdUsuarioDestinoRem() {
		return idUsuarioDestinoRem;
	}

	public void setIdUsuarioDestinoRem(Long idUsuarioDestinoRem) {
		this.idUsuarioDestinoRem = idUsuarioDestinoRem;
	}

	public Long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}

	public void setIdUsuarioRemAccion(Long idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}
	public Date getFechaAccion() {
		return fechaAccion;
	}

	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	
	

}

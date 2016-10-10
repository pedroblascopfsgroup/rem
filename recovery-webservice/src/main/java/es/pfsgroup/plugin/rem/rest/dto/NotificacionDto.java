package es.pfsgroup.plugin.rem.rest.dto;

import java.util.Date;

import javax.validation.constraints.NotNull;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class NotificacionDto extends RequestDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3044750907326664322L;
	
	@NotNull(groups = { Insert.class, Update.class })
	private long idNotificacionWebcom;
	
	@NotNull(groups = { Update.class })
	private long idNotificacionRem;
	
	@NotNull(groups = { Insert.class, Update.class })
	private long idActivoHaya;
	
	@NotNull(groups = { Insert.class, Update.class })
	private String codTipoNotificacion;
	
	@NotNull(groups = { Insert.class, Update.class })
	private String titulo;
	
	private String descripcion;
	
	@NotNull(groups = { Insert.class, Update.class })
	private Date fechaRealizacion;
	
	@NotNull(groups = { Insert.class, Update.class })
	private Date fechaAccion;
	
	private long idUsuarioDestinoRem;
	
	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = Usuario.class, foreingField="id",message = "El idUsuarioRemAccion no existe", groups = { Insert.class,
			Update.class })
	private long idUsuarioRemAccion;

	public long getIdNotificacionWebcom() {
		return idNotificacionWebcom;
	}

	public void setIdNotificacionWebcom(long idNotificacionWebcom) {
		this.idNotificacionWebcom = idNotificacionWebcom;
	}

	public long getIdNotificacionRem() {
		return idNotificacionRem;
	}

	public void setIdNotificacionRem(long idNotificacionRem) {
		this.idNotificacionRem = idNotificacionRem;
	}

	public long getIdActivoHaya() {
		return idActivoHaya;
	}

	public void setIdActivoHaya(long idActivoHaya) {
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

	public long getIdUsuarioDestinoRem() {
		return idUsuarioDestinoRem;
	}

	public void setIdUsuarioDestinoRem(long idUsuarioDestinoRem) {
		this.idUsuarioDestinoRem = idUsuarioDestinoRem;
	}

	public long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}

	public void setIdUsuarioRemAccion(long idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}
	public Date getFechaAccion() {
		return fechaAccion;
	}

	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	
	

}

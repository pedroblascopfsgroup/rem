package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;



/**
 * Dto para las observaciones del activo
 * @author Benjamín Guerrero
 *
 */
public class DtoObservacion extends WebDto {

	private static final long serialVersionUID = 0L;

	private String id;
	private Long idUsuario;
	private String nombreCompleto;
	private String observacion;
	private Date fecha;
	private Date fechaModificacion;

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Long getIdUsuario() {
		return idUsuario;
	}
	public void setIdUsuario(Long idUsuario) {
		this.idUsuario = idUsuario;
	}
	public String getObservacion() {
		return observacion;
	}
	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public Date getFechaModificacion() {
		return fechaModificacion;
	}
	public void setFechaModificacion(Date fechaModificacion) {
		this.fechaModificacion = fechaModificacion;
	}

}
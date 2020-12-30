package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de un activo-agenda-revision-titulo
 *  
 * @author Lara Pablo
 *
 */
public class DtoActivoAgendaRevisionTitulo extends WebDto {
	

	private static final long serialVersionUID = 1L;
	
	private Long idActivoAgendaRevisionTitulo;
	private Long idActivo;
	private String subtipologiaCodigo;
	private String subtipologiaDescripcion;
	private String observaciones;
	private Date fechaAlta;
	private String gestorAlta;
	
	
	public Long getIdActivoAgendaRevisionTitulo() {
		return idActivoAgendaRevisionTitulo;
	}
	public void setIdActivoAgendaRevisionTitulo(Long idActivoAgendaRevisionTitulo) {
		this.idActivoAgendaRevisionTitulo = idActivoAgendaRevisionTitulo;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getSubtipologiaCodigo() {
		return subtipologiaCodigo;
	}
	public void setSubtipologiaCodigo(String subtipologiaCodigo) {
		this.subtipologiaCodigo = subtipologiaCodigo;
	}
	public String getSubtipologiaDescripcion() {
		return subtipologiaDescripcion;
	}
	public void setSubtipologiaDescripcion(String subtipologiaDescripcion) {
		this.subtipologiaDescripcion = subtipologiaDescripcion;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getGestorAlta() {
		return gestorAlta;
	}
	public void setGestorAlta(String gestorAlta) {
		this.gestorAlta = gestorAlta;
	}
	
	

	
}

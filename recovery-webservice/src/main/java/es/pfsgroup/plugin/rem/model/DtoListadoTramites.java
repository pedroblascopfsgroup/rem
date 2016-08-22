package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para mostrar las tramites
 * @author Daniel Gutiérrez
 *
 */
public class DtoListadoTramites extends WebDto {

	private static final long serialVersionUID = 0L;
	
	private Long idTramite;

	private Long idTipoTramite;
	
	private String tipoTramite;
	
	private Long idTramitePadre;

	private Long idActivo;
	
	private String nombre;
	
	private String estado;
	
	private String subtipoTrabajo;
	
	private Date fechaInicio;
	
	private Date fechaFinalizacion;
	
	private DtoListadoTareas[] tareas;
	
	private Long idTrabajo;

	public Long getIdTramite() {
		return idTramite;
	}

	public void setIdTramite(Long idTramite) {
		this.idTramite = idTramite;
	}

	public Long getIdTipoTramite() {
		return idTipoTramite;
	}

	public void setIdTipoTramite(Long idTipoTramite) {
		this.idTipoTramite = idTipoTramite;
	}

	public String getTipoTramite() {
		return tipoTramite;
	}

	public void setTipoTramite(String tipoTramite) {
		this.tipoTramite = tipoTramite;
	}

	public Long getIdTramitePadre() {
		return idTramitePadre;
	}

	public void setIdTramitePadre(Long idTramitePadre) {
		this.idTramitePadre = idTramitePadre;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public String getSubtipoTrabajo() {
		return subtipoTrabajo;
	}

	public void setSubtipoTrabajo(String subtipoTrabajo) {
		this.subtipoTrabajo = subtipoTrabajo;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFinalizacion() {
		return fechaFinalizacion;
	}

	public void setFechaFinalizacion(Date fechaFinalizacion) {
		this.fechaFinalizacion = fechaFinalizacion;
	}

	public DtoListadoTareas[] getTareas() {
		return tareas;
	}

	public void setTareas(DtoListadoTareas[] tareas) {
		this.tareas = tareas;
	}
	
	public Long getIdTrabajo() {
		return idTrabajo;
	}

	public void setIdTrabajo(Long idTrabajo) {
		this.idTrabajo = idTrabajo;
	}

}
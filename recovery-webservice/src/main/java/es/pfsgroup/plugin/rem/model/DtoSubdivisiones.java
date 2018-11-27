package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoSubdivisiones extends WebDto {

	private static final long serialVersionUID = 0L;
	
	
	private Long id;
	private Long agrId;
	private String nombre;
	private Integer numHabitaciones;
	private Integer numPlantas;
	private String tipoSubdivisionCodigo;
	private String tipoSubdivisionDescripcion;
	private Long incluidos;
	private Boolean estadoPublicacionS;

	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public Integer getNumHabitaciones() {
		return numHabitaciones;
	}
	public void setNumHabitaciones(Integer numHabitaciones) {
		this.numHabitaciones = numHabitaciones;
	}
	public Integer getNumPlantas() {
		return numPlantas;
	}
	public void setNumPlantas(Integer numPlantas) {
		this.numPlantas = numPlantas;
	}	
	public String getTipoSubdivisionCodigo() {
		return tipoSubdivisionCodigo;
	}
	public void setTipoSubdivisionCodigo(String tipoSubdivisionCodigo) {
		this.tipoSubdivisionCodigo = tipoSubdivisionCodigo;
	}
	public String getTipoSubdivisionDescripcion() {
		return tipoSubdivisionDescripcion;
	}
	public void setTipoSubdivisionDescripcion(String tipoSubdivisionDescripcion) {
		this.tipoSubdivisionDescripcion = tipoSubdivisionDescripcion;
	}
	public Long getIncluidos() {
		return incluidos;
	}
	public void setIncluidos(Long incluidos) {
		this.incluidos = incluidos;
	}
	public Long getAgrId() {
		return agrId;
	}
	public void setAgrId(Long agrId) {
		this.agrId = agrId;
	}
	public Boolean getEstadoPublicacionS() {
		return estadoPublicacionS;
	}
	public void setEstadoPublicacionS(Boolean estadoPublicacionS) {
		this.estadoPublicacionS = estadoPublicacionS;
	}


}
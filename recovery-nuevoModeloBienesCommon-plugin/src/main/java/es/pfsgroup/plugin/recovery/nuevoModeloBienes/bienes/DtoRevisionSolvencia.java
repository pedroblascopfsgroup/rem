package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes;

import es.capgemini.devon.dto.WebDto;

public class DtoRevisionSolvencia extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5272738519529231117L;

	private Long idPersona;
	private String fechaRevision;
	private String observacionesRevisionSolvencia;
	private String noTieneFincabilidad;
	
	public Long getIdPersona() {
		return idPersona;
	}
	public void setIdPersona(Long idPersona) {
		this.idPersona = idPersona;
	}
	public String getFechaRevision() {
		return fechaRevision;
	}
	public void setFechaRevision(String fechaRevision) {
		this.fechaRevision = fechaRevision;
	}
	public void setObservacionesRevisionSolvencia(
			String observacionesRevisionSolvencia) {
		this.observacionesRevisionSolvencia = observacionesRevisionSolvencia;
	}
	public String getObservacionesRevisionSolvencia() {
		return observacionesRevisionSolvencia;
	}
	public String getNoTieneFincabilidad() {
		return noTieneFincabilidad;
	}
	public void setNoTieneFincabilidad(String noTieneFincabilidad) {
		this.noTieneFincabilidad = noTieneFincabilidad;
	}
	
}

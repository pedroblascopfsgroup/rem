package es.pfsgroup.plugin.controlcalidad.model;


/**
 * Dto para el registro de incidencias de Procedimientos
 * @author Guillem
 *
 */
public class ControlCalidadProcedimientoDto {

	private Long idEntidad;
	
	private Long idBPM;
	 
	private String descripcion;

	public Long getIdEntidad() {
		return idEntidad;
	}

	public void setIdEntidad(Long idEntidad) {
		this.idEntidad = idEntidad;
	}

	public Long getIdBPM() {
		return idBPM;
	}

	public void setIdBPM(Long idBPM) {
		this.idBPM = idBPM;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}	 
	
}

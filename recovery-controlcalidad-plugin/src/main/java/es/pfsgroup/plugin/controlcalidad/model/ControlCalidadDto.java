package es.pfsgroup.plugin.controlcalidad.model;

import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

/**
 * Dto para el registro de incidencias genéricas
 * @author Guillem
 *
 */
public class ControlCalidadDto {

	private Long idEntidad;
	
	private String descripcion;
	 
	private DDTipoEntidad tipoEntidad;
	
	private DDTipoControlCalidad tipoControlCalidad;

	public Long getIdEntidad() {
		return idEntidad;
	}

	public void setIdEntidad(Long idEntidad) {
		this.idEntidad = idEntidad;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public DDTipoEntidad getTipoEntidad() {
		return tipoEntidad;
	}

	public void setTipoEntidad(DDTipoEntidad tipoEntidad) {
		this.tipoEntidad = tipoEntidad;
	}

	public DDTipoControlCalidad getTipoControlCalidad() {
		return tipoControlCalidad;
	}

	public void setTipoControlCalidad(DDTipoControlCalidad tipoControlCalidad) {
		this.tipoControlCalidad = tipoControlCalidad;
	}

}

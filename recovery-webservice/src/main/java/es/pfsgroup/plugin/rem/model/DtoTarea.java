package es.pfsgroup.plugin.rem.model;

import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;

/**
 * Dto para el filtro de tareas
 * @author Daniel Gutiérrez
 *
 */
public class DtoTarea extends DtoBuscarTareaNotificacion {

	private static final long serialVersionUID = 0L;

	private String codEntidad;
	private String descripcionEntidad;
	private String usuarioPendiente;
	private String gestor;

	public String getCodEntidad() {
		return codEntidad;
	}

	public void setCodEntidad(String codEntidad) {
		this.codEntidad = codEntidad;
	}

	public String getDescripcionEntidad() {
		return descripcionEntidad;
	}

	public void setDescripcionEntidad(String descripcionEntidad) {
		this.descripcionEntidad = descripcionEntidad;
	}

	public String getUsuarioPendiente() {
		return usuarioPendiente;
	}

	public void setUsuarioPendiente(String usuarioPendiente) {
		this.usuarioPendiente = usuarioPendiente;
	}

	public String getGestor() {
		return gestor;
	}

	public void setGestor(String gestor) {
		this.gestor = gestor;
	}
	

}
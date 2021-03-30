package es.pfsgroup.plugin.rem.model;

import java.util.List;

/**
 * Dto para los datos de publicación de los activos.
 */
public class DtoDatosPublicacionDq {

	private List<Long> activosSeleccionados;
	private String dqFase4Descripcion;
	private boolean soyRestringidaQuieroActualizar;
	
	public List<Long> getActivosSeleccionados() {
		return activosSeleccionados;
	}
	public void setActivosSeleccionados(List<Long> activosSeleccionados) {
		this.activosSeleccionados = activosSeleccionados;
	}
	public String getDqFase4Descripcion() {
		return dqFase4Descripcion;
	}
	public void setDqFase4Descripcion(String dqFase4Descripcion) {
		this.dqFase4Descripcion = dqFase4Descripcion;
	}
	public boolean isSoyRestringidaQuieroActualizar() {
		return soyRestringidaQuieroActualizar;
	}
	public void setSoyRestringidaQuieroActualizar(boolean soyRestringidaQuieroActualizar) {
		this.soyRestringidaQuieroActualizar = soyRestringidaQuieroActualizar;
	}

}
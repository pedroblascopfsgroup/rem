package es.pfsgroup.recovery.recobroWeb.expediente.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;

public class BusquedaExpIncidenciaDto extends PaginationParamsImpl{

	private static final long serialVersionUID = -3963607084877125848L;

	private String tipoIncidencia;
	
	private String situacionIncidencia;
	
	private String fechaDesdeIncidencia;
	
	private String fechaHastaIncidencia;
	

	public String getTipoIncidencia() {
		return tipoIncidencia;
	}

	public void setTipoIncidencia(String tipoIncidencia) {
		this.tipoIncidencia = tipoIncidencia;
	}

	public String getSituacionIncidencia() {
		return situacionIncidencia;
	}

	public void setSituacionIncidencia(String situacionIncidencia) {
		this.situacionIncidencia = situacionIncidencia;
	}

	public String getFechaDesdeIncidencia() {
		return fechaDesdeIncidencia;
	}

	public void setFechaDesdeIncidencia(String fechaDesdeIncidencia) {
		this.fechaDesdeIncidencia = fechaDesdeIncidencia;
	}

	public String getFechaHastaIncidencia() {
		return fechaHastaIncidencia;
	}

	public void setFechaHastaIncidencia(String fechaHastaIncidencia) {
		this.fechaHastaIncidencia = fechaHastaIncidencia;
	}

}

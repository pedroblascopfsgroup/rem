package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para el historico del diario de gestión del activo.
 *
 */
public class DtoHistoricoDiarioGestion {
	private String id;
	private String estadoLocId;
	private String estadoLocDesc;
	private String subEstadoDesc;
	private String nombreGestorDesc;
	private Date fechaCambioEstado;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getEstadoLocId() {
		return estadoLocId;
	}
	public void setEstadoLocId(String estadoLocId) {
		this.estadoLocId = estadoLocId;
	}
	public String getEstadoLocDesc() {
		return estadoLocDesc;
	}
	public void setEstadoLocDesc(String estadoLocDesc) {
		this.estadoLocDesc = estadoLocDesc;
	}
	public String getSubEstadoDesc() {
		return subEstadoDesc;
	}
	public void setSubEstadoDesc(String subEstadoDesc) {
		this.subEstadoDesc = subEstadoDesc;
	}
	public String getNombreGestorDesc() {
		return nombreGestorDesc;
	}
	public void setNombreGestorDesc(String nombreGestorDesc) {
		this.nombreGestorDesc = nombreGestorDesc;
	}
	public Date getFechaCambioEstado() {
		return fechaCambioEstado;
	}
	public void setFechaCambioEstado(Date fechaCambioEstado) {
		this.fechaCambioEstado = fechaCambioEstado;
	}

	
	
	
}
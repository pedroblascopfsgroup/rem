package es.pfsgroup.plugin.rem.model;


import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de Datos de Contacto > Activos Integrados de la ficha proveedor.
 */
public class DtoActivoIntegrado extends WebDto {
	private static final long serialVersionUID = 0L;

	private String id;
	private String idActivo;
	private String numActivo;
	private String tipoCodigo;
	private String subtipoCodigo;
	private String carteraCodigo;
	private String direccion;
	private String participacion;
	private Date fechaInclusion;
	private Date fechaExclusion;
	private String motivoExclusion;
	private int totalCount;
	
	
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}
	public String getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}
	public String getTipoCodigo() {
		return tipoCodigo;
	}
	public void setTipoCodigo(String tipoCodigo) {
		this.tipoCodigo = tipoCodigo;
	}
	public String getSubtipoCodigo() {
		return subtipoCodigo;
	}
	public void setSubtipoCodigo(String subtipoCodigo) {
		this.subtipoCodigo = subtipoCodigo;
	}
	public String getCarteraCodigo() {
		return carteraCodigo;
	}
	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getParticipacion() {
		return participacion;
	}
	public void setParticipacion(String participacion) {
		this.participacion = participacion;
	}
	public Date getFechaInclusion() {
		return fechaInclusion;
	}
	public void setFechaInclusion(Date fechaInclusion) {
		this.fechaInclusion = fechaInclusion;
	}
	public Date getFechaExclusion() {
		return fechaExclusion;
	}
	public void setFechaExclusion(Date fechaExclusion) {
		this.fechaExclusion = fechaExclusion;
	}
	public String getMotivoExclusion() {
		return motivoExclusion;
	}
	public void setMotivoExclusion(String motivoExclusion) {
		this.motivoExclusion = motivoExclusion;
	}
	
}
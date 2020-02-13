package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_FECHAS_PUB_CANALES_AGR", schema = "${entity.schema}")
public class VFechasPubCanalesAgr implements Serializable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "AGR_ID")
	private Long idAgrupacion;
	
	@Column(name = "FECHA_PRIMERA_PUBLICACION_MIN")
	private Date fechaPrimeraPublicacionMin;
	
	@Column(name = "FECHA_ULTIMA_PUBLICACION_MIN")
	private Date fechaUltimaPublicacionMin;
	
	@Column(name = "FECHA_PRIMERA_PUBLICACION_MAY")
	private Date fechaPrimeraPublicacionMay;
	
	@Column(name = "FECHA_ULTIMA_PUBLICACION_MAY")
	private Date fechaUltimaPublicacionMay;
	
	
	
	public Long getIdAgrupacion() {
		return idAgrupacion;
	}
	
	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}
	
	public Date getFechaPrimeraPublicacionMin() {
		return fechaPrimeraPublicacionMin;
	}
	
	public void setFechaPrimeraPublicacionMin(Date fechaPrimeraPublicacionMin) {
		this.fechaPrimeraPublicacionMin = fechaPrimeraPublicacionMin;
	}
	
	public Date getFechaUltimaPublicacionMin() {
		return fechaUltimaPublicacionMin;
	}
	
	public void setFechaUltimaPublicacionMin(Date fechaUltimaPublicacionMin) {
		this.fechaUltimaPublicacionMin = fechaUltimaPublicacionMin;
	}
	
	public Date getFechaPrimeraPublicacionMay() {
		return fechaPrimeraPublicacionMay;
	}
	
	public void setFechaPrimeraPublicacionMay(Date fechaPrimeraPublicacionMay) {
		this.fechaPrimeraPublicacionMay = fechaPrimeraPublicacionMay;
	}
	
	public Date getFechaUltimaPublicacionMay() {
		return fechaUltimaPublicacionMay;
	}
	
	public void setFechaUltimaPublicacionMay(Date fechaUltimaPublicacionMay) {
		this.fechaUltimaPublicacionMay = fechaUltimaPublicacionMay;
	}
}
	
	
	
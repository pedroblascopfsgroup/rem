package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_FECHAS_PUB_CANALES", schema = "${entity.schema}")
public class VFechasPubCanales implements Serializable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "ACT_ID")
	private Long idActivo;
	
	@Column(name = "FECHA_PRIMERA_PUBLICACION_MIN")
	private Date fechaPrimeraPublicacionMin;
	
	@Column(name = "FECHA_ULTIMA_PUBLICACION_MIN")
	private Date fechaUltimaPublicacionMin;
	
	@Column(name = "FECHA_PRIMERA_PUBLICACION_MAY")
	private Date fechaPrimeraPublicacionMay;
	
	@Column(name = "FECHA_ULTIMA_PUBLICACION_MAY")
	private Date fechaUltimaPublicacionMay;
	
	
	
	public Long getIdActivo() {
		return idActivo;
	}
	
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
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
	
	
	
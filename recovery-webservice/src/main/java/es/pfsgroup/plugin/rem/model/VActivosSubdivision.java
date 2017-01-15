package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_ACTIVOS_SUBDIVISION", schema = "${entity.schema}")
public class VActivosSubdivision implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ACT_ID")
	private Long activoId;
	
	@Column(name = "ID")
	private Long idSubdivision;
	
	@Column(name = "AGR_ID")
	private Long agrupacionId;
	
	@Column(name = "ACT_NUM_ACTIVO")
	private Long numActivo;
	
	@Column(name = "BIE_DREG_NUM_FINCA")
	private String numFinca;	
	
	@Column(name = "DD_TPA_DESCRIPCION")
	private String tipoActivo;	
	
	@Column(name = "DD_SAC_DESCRIPCION")
	private String subtipoActivo;	
	
	@Column(name = "ICO_FECHA_ACEPTACION")
	private Date fechaAceptacionInformeComercial;
	

	public Long getIdSubdivision() {
		return idSubdivision;
	}

	public void setIdSubdivision(Long idSubdivision) {
		this.idSubdivision = idSubdivision;
	}

	public Long getAgrupacionId() {
		return agrupacionId;
	}

	public void setAgrupacionId(Long agrupacionId) {
		this.agrupacionId = agrupacionId;
	}

	public Long getActivoId() {
		return activoId;
	}

	public void setActivoId(Long activoId) {
		this.activoId = activoId;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public String getNumFinca() {
		return numFinca;
	}

	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}

	public String getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public String getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public Date getFechaAceptacionInformeComercial() {
		return fechaAceptacionInformeComercial;
	}

	public void setFechaAceptacionInformeComercial(
			Date fechaAceptacionInformeComercial) {
		this.fechaAceptacionInformeComercial = fechaAceptacionInformeComercial;
	}	



	


}
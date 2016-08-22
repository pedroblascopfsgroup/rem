package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_ACTIVOS_AGRUPACION_TRABAJO", schema = "${entity.schema}")
public class VActivosAgrupacionTrabajo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "AGA_ID")
	private String id;
	
	@Column(name = "ACT_ID")
	private String activoId;	
	
	@Column(name = "ACT_NUM_ACTIVO")
	private Long numActivo;  	
	
	@Column(name = "ACT_NUM_ACTIVO_REM")
	private Long numActivoRem;  
	
    @Column(name = "DD_TPA_DESCRIPCION")
    private String tipoActivoDescripcion;
    
    @Column(name = "DD_SAC_DESCRIPCION")
    private String subtipoActivoDescripcion;
	
	@Column(name = "AGR_ID")
	private Long agrId;
	
	@Column(name = "VAL_NETO_CONTABLE")
	private Double importeNetoContable;	
	
	@Column(name = "SUMA_AGRUP_NETA")
	private Double sumaAgrupacionNetoContable;	
	
	@Column(name = "SITUACION_COMERCIAL")
	private String situacionComercial;
	
	@Column(name = "SPS_OCUPADO")
	private Integer situacionPosesoriaOcupado;
	
	@Column(name = "SPS_CON_TITULO")
	private Integer situacionPosesoriaTitulo;
	
	@Column(name="DD_CRA_DESCRIPCION")
	private String cartera;
	

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getActivoId() {
		return activoId;
	}

	public void setActivoId(String activoId) {
		this.activoId = activoId;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public Long getNumActivoRem() {
		return numActivoRem;
	}

	public void setNumActivoRem(Long numActivoRem) {
		this.numActivoRem = numActivoRem;
	}

	public Long getAgrId() {
		return agrId;
	}

	public void setAgrId(Long agrId) {
		this.agrId = agrId;
	}

	public Double getImporteNetoContable() {
		return importeNetoContable;
	}

	public void setImporteNetoContable(Double importeNetoContable) {
		this.importeNetoContable = importeNetoContable;
	}

	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}

	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}

	public String getSituacionComercial() {
		return situacionComercial;
	}

	public void setSituacionComercial(String situacionComercial) {
		this.situacionComercial = situacionComercial;
	}

	public Integer getSituacionPosesoriaOcupado() {
		return situacionPosesoriaOcupado;
	}

	public void setSituacionPosesoriaOcupado(Integer situacionPosesoriaOcupado) {
		this.situacionPosesoriaOcupado = situacionPosesoriaOcupado;
	}

	public Integer getSituacionPosesoriaTitulo() {
		return situacionPosesoriaTitulo;
	}

	public void setSituacionPosesoriaTitulo(Integer situacionPosesoriaTitulo) {
		this.situacionPosesoriaTitulo = situacionPosesoriaTitulo;
	}

	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}

	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
	}

	public Double getSumaAgrupacionNetoContable() {
		return sumaAgrupacionNetoContable;
	}

	public void setSumaAgrupacionNetoContable(Double sumaAgrupacionNetoContable) {
		this.sumaAgrupacionNetoContable = sumaAgrupacionNetoContable;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}	
	


}
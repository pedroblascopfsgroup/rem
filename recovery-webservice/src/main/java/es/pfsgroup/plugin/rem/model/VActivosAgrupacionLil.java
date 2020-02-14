package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_ACTIVOS_AGRUPACION_LIL", schema = "${entity.schema}")
public class VActivosAgrupacionLil implements Serializable {
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "AGA_ID")
	private Long id;
	
	@Column(name = "ACT_ID")
	private Long activoId;	
	
	@Column(name = "AGA_FECHA_INCLUSION")
   	private Date fechaInclusion;
	
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
	
	@Column(name = "ACTIVO_MATRIZ") //Para identificar un activo matriz en una agrupación de tipo promoción alquiler. 
   	private Integer activoMatriz;
	
   	@Column(name = "BORRADO") 
   	private Integer borrado;

	
   	@Column(name = "ID_PRINEX_HPM")
	private String idPrinexHPM;
   	

	@Column(name = "SITUACION_COMERCIAL")
	private String situacionComercial;
	
	@Column(name = "SPS_OCUPADO")
	private Integer situacionPosesoriaOcupado;
	
	@Column(name = "SPS_CON_TITULO")
	private Integer situacionPosesoriaTitulo;
	
	@Column(name="BIE_LOC_PUERTA")
	private String puerta;
	
	@Column(name = "SDV_NOMBRE")
	private String subdivision;
	
	@Column(name="BIE_DREG_SUPERFICIE_CONSTRUIDA")
	private Float superficieConstruida;
	
	@Column(name = "ES_PISO_PILOTO")
	private Boolean esPisoPiloto;
		

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getActivoId() {
		return activoId;
	}

	public void setActivoId(Long activoId) {
		this.activoId = activoId;
	}

	public Date getFechaInclusion() {
		return fechaInclusion;
	}

	public void setFechaInclusion(Date fechaInclusion) {
		this.fechaInclusion = fechaInclusion;
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

	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}

	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}

	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}

	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
	}

	public Long getAgrId() {
		return agrId;
	}

	public void setAgrId(Long agrId) {
		this.agrId = agrId;
	}

	public Integer getActivoMatriz() {
		return activoMatriz;
	}

	public void setActivoMatriz(Integer activoMatriz) {
		this.activoMatriz = activoMatriz;
	}

	public Integer getBorrado() {
		return borrado;
	}

	public void setBorrado(Integer borrado) {
		this.borrado = borrado;
	}

	public String getIdPrinexHPM() {
		return idPrinexHPM;
	}

	public void setIdPrinexHPM(String idPrinexHPM) {
		this.idPrinexHPM = idPrinexHPM;
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

	public String getPuerta() {
		return puerta;
	}

	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}

	public String getSubdivision() {
		return subdivision;
	}

	public void setSubdivision(String subdivision) {
		this.subdivision = subdivision;
	}

	public Float getSuperficieConstruida() {
		return superficieConstruida;
	}

	public void setSuperficieConstruida(Float superficieConstruida) {
		this.superficieConstruida = superficieConstruida;
	}

	public Boolean getEsPisoPiloto() {
		return esPisoPiloto;
	}

	public void setEsPisoPiloto(Boolean esPisoPiloto) {
		this.esPisoPiloto = esPisoPiloto;
	}
   	
	
	
	
	
}
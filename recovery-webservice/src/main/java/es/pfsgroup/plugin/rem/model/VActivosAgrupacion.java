package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;


@Entity
@Table(name = "V_ACTIVOS_AGRUPACION", schema = "${entity.schema}")
public class VActivosAgrupacion implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "AGA_ID")
	private Long id;
	
	@Column(name = "ACT_ID")
	private Long activoId;	
	
	@Column(name = "ACT_NUM_ACTIVO")
	private Long numActivo; 
		
	@Column(name = "ACT_NUM_ACTIVO_REM")
	private Long numActivoRem;  
	
    @Column(name = "DD_TPA_DESCRIPCION")
    private String tipoActivoDescripcion;
    
    @Column(name = "AGA_FECHA_INCLUSION")
   	private Date fechaInclusion;

    @Column(name = "DD_SAC_DESCRIPCION")
    private String subtipoActivoDescripcion;
	
	@Column(name = "AGR_ID")
	private Long agrId;
	
	@Column(name="BIE_DREG_SUPERFICIE_CONSTRUIDA")
	private Float superficieConstruida;
	
	@Column(name = "VAL_IMPORTE_MINIMO_AUTORIZADO")
	private Double importeMinimoAutorizado;
	
	@Column(name = "VAL_IMPORTE_APROBADO_VENTA")
	private Double importeAprobadoVenta;
	
	@Column(name = "VAL_NETO_CONTABLE")
	private Double importeNetoContable;	
	
	@Column(name = "VAL_IMPORTE_DESCUENTO_PUBLICO")
	private Double importeDescuentoPublicado;
	
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "propietario")
	private ActivoPropietario propietario;
    
    //@OneToOne(fetch = FetchType.LAZY)
    @Column(name = "SDV_NOMBRE")
	private String subdivision;
	
	@Column(name = "numeropropietarios")
	private Long numeroPropietarios;
	
	@Column(name = "principal")
   	private Integer activoPrincipal;
	
	@Column(name = "SITUACION_COMERCIAL")
	private String situacionComercial;
	
	@Column(name = "SPS_OCUPADO")
	private Integer situacionPosesoriaOcupado;
	
	@Column(name = "SPS_CON_TITULO")
	private Integer situacionPosesoriaTitulo;
	
	@Column(name = "direccion")
	private String direccion;
	
	@Column(name="BIE_DREG_NUM_FINCA")
	private String numFinca;
	
	@Column(name="BIE_LOC_PUERTA")
	private String puerta;
	
	@Column(name="PUBLICADO")
	private String publicado;

	@Column(name="COND_PUBL_VENTA")
	private Integer condPublVenta;
	
	@Column(name="COND_PUBL_ALQUILER")
	private Integer condPublAlquiler;

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
	
	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
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

	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}

	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
	}

	public Float getSuperficieConstruida() {
		return superficieConstruida;
	}

	public void setSuperficieConstruida(Float superficieConstruida) {
		this.superficieConstruida = superficieConstruida;
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

	public ActivoPropietario getPropietario() {
		return propietario;
	}

	public void setPropietario(ActivoPropietario propietario) {
		this.propietario = propietario;
	}

	public Long getNumeroPropietarios() {
		return numeroPropietarios;
	}

	public void setNumeroPropietarios(Long numeroPropietarios) {
		this.numeroPropietarios = numeroPropietarios;
	}

	public Date getFechaInclusion() {
		return fechaInclusion;
	}

	public void setFechaInclusion(Date fechaInclusion) {
		this.fechaInclusion = fechaInclusion;
	}

	public Integer getActivoPrincipal() {
		return activoPrincipal;
	}

	public void setActivoPrincipal(Integer activoPrincipal) {
		this.activoPrincipal = activoPrincipal;
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

	public String getSubdivision() {
		return subdivision;
	}

	public void setSubdivision(String subdivision) {
		this.subdivision = subdivision;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getNumFinca() {
		return numFinca;
	}

	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}

	public String getPuerta() {
		return puerta;
	}

	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}

	public Double getImporteMinimoAutorizado() {
		return importeMinimoAutorizado;
	}

	public void setImporteMinimoAutorizado(Double importeMinimoAutorizado) {
		this.importeMinimoAutorizado = importeMinimoAutorizado;
	}

	public Double getImporteAprobadoVenta() {
		return importeAprobadoVenta;
	}

	public void setImporteAprobadoVenta(Double importeAprobadoVenta) {
		this.importeAprobadoVenta = importeAprobadoVenta;
	}

	public Long getNumActivoRem() {
		return numActivoRem;
	}

	public Double getImporteDescuentoPublicado() {
		return importeDescuentoPublicado;
	}

	public void setImporteDescuentoPublicado(Double importeDescuentoPublicado) {
		this.importeDescuentoPublicado = importeDescuentoPublicado;
	}

	public String getPublicado() {
		return publicado;
	}

	public void setPublicado(String publicado) {
		this.publicado = publicado;
	}

	public Integer getCondPublVenta() {
		return condPublVenta;
	}

	public void setCondPublVenta(Integer condPublVenta) {
		this.condPublVenta = condPublVenta;
	}

	public Integer getCondPublAlquiler() {
		return condPublAlquiler;
	}

	public void setCondPublAlquiler(Integer condPublAlquiler) {
		this.condPublAlquiler = condPublAlquiler;
	}
	
}
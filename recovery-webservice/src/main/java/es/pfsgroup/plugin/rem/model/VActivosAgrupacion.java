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

@Entity
@Table(name = "V_ACTIVOS_AGRUPACION", schema = "${entity.schema}")
public class VActivosAgrupacion implements Serializable {
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
	
	@Column(name = "VAL_IMPORTE_APROBADO_RENTA")
	private Double importeAprobadoRenta;
	
//	@Column(name = "VAL_NETO_CONTABLE")
//	private Double importeNetoContable;	
	
	@Column(name = "VAL_IMPORTE_DESCUENTO_PUBLICO")
	private Double importeDescuentoPublicado;
	
	@Column(name="GENCAT")
	private String activoGencat;

//    @ManyToOne(fetch = FetchType.LAZY)
//	@JoinColumn(name = "propietario")
//	private ActivoPropietario propietario;
    
    //@OneToOne(fetch = FetchType.LAZY)
    @Column(name = "SDV_NOMBRE")
	private String subdivision;
	
//	@Column(name = "numeropropietarios")
//	private Long numeroPropietarios;
	
	@Column(name = "principal")
   	private Integer activoPrincipal;
   	
   	@Column(name = "ACTIVO_MATRIZ") //Para identificar un activo matriz en una agrupación de tipo promoción alquiler. 
   	private Integer activoMatriz;
   	
   	@Column(name = "BORRADO") 
   	private Integer borrado;

	@Column(name = "SITUACION_COMERCIAL")
	private String situacionComercial;
	
//	@Column(name = "SPS_OCUPADO")
//	private Integer situacionPosesoriaOcupado;
//	
//	@Column(name = "SPS_CON_TITULO")
//	private Integer situacionPosesoriaTitulo;
//	
	@Column(name = "direccion")
	private String direccion;
	
	@Column(name="BIE_DREG_NUM_FINCA")
	private String numFinca;
	
	@Column(name="BIE_LOC_PUERTA")
	private String puerta;
	
	@Column(name="PUBLICADO")
	private String publicado;

	@Column(name = "COND_PUBL_VENTA")
	private String condPublVenta;

	@Column(name = "COND_PUBL_ALQUILER")
	private String condPublAlquiler;
	
	@Column(name = "ID_PRINEX_HPM")
	private String idPrinexHPM;
	
//	@Column(name ="REG_SUPERFICIE_UTIL")
//	private Float superficieUtil;
//	
//	@Column(name = "REG_SUPERFICIE_ELEM_COMUN")
//	private Float superficieElementoComun;
//	
//	@Column(name = "REG_SUPERFICIE_PARCELA")
//	private Float superficieParcela;
//
//	@Column(name = "ESTADO_TITULO")
//	private String estadoTitulo;
	
	@Column(name = "ES_PISO_PILOTO")
	private Boolean esPisoPiloto;
	
	@Column(name = "AGA_FECHA_ESCRITURACION")
   	private Date fechaEscrituracion;

	
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

//	public Double getImporteNetoContable() {
//		return importeNetoContable;
//	}
//
//	public void setImporteNetoContable(Double importeNetoContable) {
//		this.importeNetoContable = importeNetoContable;
//	}

	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}

	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}

//	public ActivoPropietario getPropietario() {
//		return propietario;
//	}
//
//	public void setPropietario(ActivoPropietario propietario) {
//		this.propietario = propietario;
//	}
//
//	public Long getNumeroPropietarios() {
//		return numeroPropietarios;
//	}
//
//	public void setNumeroPropietarios(Long numeroPropietarios) {
//		this.numeroPropietarios = numeroPropietarios;
//	}

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

//	public Integer getSituacionPosesoriaOcupado() {
//		return situacionPosesoriaOcupado;
//	}
//
//	public void setSituacionPosesoriaOcupado(Integer situacionPosesoriaOcupado) {
//		this.situacionPosesoriaOcupado = situacionPosesoriaOcupado;
//	}
//
//	public Integer getSituacionPosesoriaTitulo() {
//		return situacionPosesoriaTitulo;
//	}
//
//	public void setSituacionPosesoriaTitulo(Integer situacionPosesoriaTitulo) {
//		this.situacionPosesoriaTitulo = situacionPosesoriaTitulo;
//	}

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

	public String getActivoGencat() {
		return activoGencat;
	}

	public void setActivoGencat(String activoGencat) {
		this.activoGencat = activoGencat;
	}

	public String getCondPublVenta() {
		return condPublVenta;
	}

	public void setCondPublVenta(String condPublVenta) {
		this.condPublVenta = condPublVenta;
	}

	public String getCondPublAlquiler() {
		return condPublAlquiler;
	}

	public void setCondPublAlquiler(String condPublAlquiler) {
		this.condPublAlquiler = condPublAlquiler;
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

//	public Float getSuperficieUtil() {
//		return superficieUtil;
//	}
//
//	public void setSuperficieUtil(Float superficieUtil) {
//		this.superficieUtil = superficieUtil;
//	}
//
//	public Float getSuperficieElementoComun() {
//		return superficieElementoComun;
//	}
//
//	public void setSuperficieElementoComun(Float superficieElementoComun) {
//		this.superficieElementoComun = superficieElementoComun;
//	}
//
//	public Float getSuperficieParcela() {
//		return superficieParcela;
//	}
//
//	public void setSuperficieParcela(Float superficieParcela) {
//		this.superficieParcela = superficieParcela;
//	}
//	
//	public String getEstadoTitulo() {
//		return estadoTitulo;
//	}
//
//	public void setEstadoTitulo(String estadoTitulo) {
//		this.estadoTitulo = estadoTitulo;
//	}

	public Double getImporteAprobadoRenta() {
		return importeAprobadoRenta;
	}

	public void setImporteAprobadoRenta(Double importeAprobadoRenta) {
		this.importeAprobadoRenta = importeAprobadoRenta;
	}

	public Boolean getEsPisoPiloto() {
		return esPisoPiloto;
	}

	public void setEsPisoPiloto(Boolean esPisoPiloto) {
		this.esPisoPiloto = esPisoPiloto;
	}

	public Date getFechaEscrituracion() {
		return fechaEscrituracion;
	}

	public void setFechaEscrituracion(Date fechaEscrituracion) {
		this.fechaEscrituracion = fechaEscrituracion;
	}
	
	
}
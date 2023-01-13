package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el Estado de disponibilidad comercial
 */
public class DtoVActivosAgrupacion extends WebDto {
	private static final long serialVersionUID = 1L;
	
	private Long id;
	private Long activoId;	
	private Long numActivo; 
	private Long numActivoRem;  
    private String tipoActivoDescripcion;
   	private Date fechaInclusion;
    private String codigoSubtipoActivo;
    private String subtipoActivo;
	private Long agrId;
	private Float superficieConstruida;
	private Double importeMinimoAutorizado;
	private Double importeAprobadoVenta;
	private Double importeNetoContable;	
	private Double importeDescuentoPublicado;
	private String subdivision;
	private Long numeroPropietarios;
   	private Integer activoPrincipal;
	private String situacionComercial;
	private Integer situacionPosesoriaOcupado;
	private Integer situacionPosesoriaTitulo;
	private String direccion;
	private String numFinca;
	private String puerta;
	private String publicado;
	private Boolean estadoSituacionComercial;
	private Boolean esPisoPiloto;
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
	public Date getFechaInclusion() {
		return fechaInclusion;
	}
	public void setFechaInclusion(Date fechaInclusion) {
		this.fechaInclusion = fechaInclusion;
	}
	public Long getAgrId() {
		return agrId;
	}
	public void setAgrId(Long agrId) {
		this.agrId = agrId;
	}
	public Float getSuperficieConstruida() {
		return superficieConstruida;
	}
	public void setSuperficieConstruida(Float superficieConstruida) {
		this.superficieConstruida = superficieConstruida;
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
	public Double getImporteNetoContable() {
		return importeNetoContable;
	}
	public void setImporteNetoContable(Double importeNetoContable) {
		this.importeNetoContable = importeNetoContable;
	}
	public Double getImporteDescuentoPublicado() {
		return importeDescuentoPublicado;
	}
	public void setImporteDescuentoPublicado(Double importeDescuentoPublicado) {
		this.importeDescuentoPublicado = importeDescuentoPublicado;
	}

	public String getSubdivision() {
		return subdivision;
	}
	public void setSubdivision(String subdivision) {
		this.subdivision = subdivision;
	}
	public Boolean getEstadoSituacionComercial() {
		return estadoSituacionComercial;
	}
	public void setEstadoSituacionComercial(Boolean estadoSituacionComercial) {
		this.estadoSituacionComercial = estadoSituacionComercial;
	}
	public Long getNumeroPropietarios() {
		return numeroPropietarios;
	}
	public void setNumeroPropietarios(Long numeroPropietarios) {
		this.numeroPropietarios = numeroPropietarios;
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
	public String getPublicado() {
		return publicado;
	}
	public void setPublicado(String publicado) {
		this.publicado = publicado;
	}
	public String getCodigoSubtipoActivo() {
		return codigoSubtipoActivo;
	}
	public void setCodigoSubtipoActivo(String codigoSubtipoActivo) {
		this.codigoSubtipoActivo = codigoSubtipoActivo;
	}
	public String getSubtipoActivoDesc() {
		return subtipoActivo;
	}
	public void setSubtipoActivoDesc(String subtipoActivoDesc) {
		this.subtipoActivo = subtipoActivoDesc;
	}
	public Boolean getEsPisoPiloto() {
		return this.esPisoPiloto;
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
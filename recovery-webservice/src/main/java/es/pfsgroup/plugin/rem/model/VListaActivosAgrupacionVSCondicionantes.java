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
@Table(name = "V_LIST_ACT_AGR_VS_COND", schema = "${entity.schema}")
public class VListaActivosAgrupacionVSCondicionantes implements Serializable {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2871493400974118285L;

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SAC_ID")
    private DDSubtipoActivo subtipoActivo;
	
	@Column(name = "AGR_ID")
	private Long agrId;
	
	@Column(name="BIE_DREG_SUPERFICIE_CONSTRUIDA")
	private Float superficieConstruida;
	
	@Column(name = "VAL_IMPORTE_MINIMO_AUTORIZADO")
	private Double importeMinimoAutorizado;
	
	@Column(name = "VAL_IMPORTE_APROBADO_VENTA")
	private Double importeAprobadoVenta;
	
//	@Column(name = "VAL_NETO_CONTABLE")
//	private Double importeNetoContable;	
	
	@Column(name = "VAL_IMPORTE_DESCUENTO_PUBLICO")
	private Double importeDescuentoPublicado;
	
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
	
	@Column(name = "SITUACION_COMERCIAL")
	private String situacionComercial;
	
//	@Column(name = "SPS_OCUPADO")
//	private Integer situacionPosesoriaOcupado;
	
//	@Column(name = "SPS_CON_TITULO")
//	private Integer situacionPosesoriaTitulo;
	
	@Column(name = "direccion")
	private String direccion;
	
	@Column(name="BIE_DREG_NUM_FINCA")
	private String numFinca;
	
	@Column(name="BIE_LOC_PUERTA")
	private String puerta;
	
	@Column(name="PUBLICADO")
	private String publicado;
	
	@Column(name = "RUINA")
	private Boolean ruina;
	
	@Column(name = "PENDIENTE_INSCRIPCION")
	private Boolean pendienteInscripcion;
	
	@Column(name = "OBRANUEVA_SINDECLARAR")
	private Boolean obraNuevaSinDeclarar;
	
	@Column(name = "SIN_TOMA_POSESION_INICIAL")
	private Boolean sinTomaPosesionInicial;
	
	@Column(name = "PROINDIVISO")
	private Boolean proindiviso;
	
	@Column(name = "OBRANUEVA_ENCONSTRUCCION")
	private Boolean obraNuevaEnConstruccion;
	
	@Column(name = "OCUPADO_CONTITULO")
	private Boolean ocupadoConTitulo;
	
	@Column(name = "TAPIADO")
	private Boolean tapiado;
	
	@Column(name = "OTRO")
	private String otro;
	
	@Column(name = "ESTADO_PORTAL_EXTERNO")
	private Boolean portalesExternos;
	
	@Column(name = "OCUPADO_SINTITULO")
	private Boolean ocupadoSinTitulo;
	
	@Column(name = "DIVHORIZONTAL_NOINSCRITA")
	private Boolean divHorizontalNoInscrita;
	
	@Column(name = "ES_CONDICIONADO")
	private Boolean isCondicionado;
	
	@Column(name = "EST_DISP_COM_CODIGO")
	private String estadoCondicionadoCodigo;

	@Column(name = "SIN_INFORME_APROBADO")
	private Boolean sinInformeAprobado;
	
	@Column(name = "CON_CARGAS")
	private Boolean conCargas;
	
	@Column(name = "VANDALIZADO")
	private Boolean vandalizado;

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

	public DDSubtipoActivo getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(DDSubtipoActivo subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
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

//	public Double getImporteNetoContable() {
//		return importeNetoContable;
//	}
//
//	public void setImporteNetoContable(Double importeNetoContable) {
//		this.importeNetoContable = importeNetoContable;
//	}

	public Double getImporteDescuentoPublicado() {
		return importeDescuentoPublicado;
	}

	public void setImporteDescuentoPublicado(Double importeDescuentoPublicado) {
		this.importeDescuentoPublicado = importeDescuentoPublicado;
	}

//	public ActivoPropietario getPropietario() {
//		return propietario;
//	}
//
//	public void setPropietario(ActivoPropietario propietario) {
//		this.propietario = propietario;
//	}

	public String getSubdivision() {
		return subdivision;
	}

	public void setSubdivision(String subdivision) {
		this.subdivision = subdivision;
	}

//	public Long getNumeroPropietarios() {
//		return numeroPropietarios;
//	}
//
//	public void setNumeroPropietarios(Long numeroPropietarios) {
//		this.numeroPropietarios = numeroPropietarios;
//	}

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

	public Boolean getRuina() {
		return ruina;
	}

	public void setRuina(Boolean ruina) {
		this.ruina = ruina;
	}

	public Boolean getPendienteInscripcion() {
		return pendienteInscripcion;
	}

	public void setPendienteInscripcion(Boolean pendienteInscripcion) {
		this.pendienteInscripcion = pendienteInscripcion;
	}

	public Boolean getObraNuevaSinDeclarar() {
		return obraNuevaSinDeclarar;
	}

	public void setObraNuevaSinDeclarar(Boolean obraNuevaSinDeclarar) {
		this.obraNuevaSinDeclarar = obraNuevaSinDeclarar;
	}

	public Boolean getSinTomaPosesionInicial() {
		return sinTomaPosesionInicial;
	}

	public void setSinTomaPosesionInicial(Boolean sinTomaPosesionInicial) {
		this.sinTomaPosesionInicial = sinTomaPosesionInicial;
	}

	public Boolean getProindiviso() {
		return proindiviso;
	}

	public void setProindiviso(Boolean proindiviso) {
		this.proindiviso = proindiviso;
	}

	public Boolean getObraNuevaEnConstruccion() {
		return obraNuevaEnConstruccion;
	}

	public void setObraNuevaEnConstruccion(Boolean obraNuevaEnConstruccion) {
		this.obraNuevaEnConstruccion = obraNuevaEnConstruccion;
	}

	public Boolean getOcupadoConTitulo() {
		return ocupadoConTitulo;
	}

	public void setOcupadoConTitulo(Boolean ocupadoConTitulo) {
		this.ocupadoConTitulo = ocupadoConTitulo;
	}

	public Boolean getTapiado() {
		return tapiado;
	}

	public void setTapiado(Boolean tapiado) {
		this.tapiado = tapiado;
	}

	public String getOtro() {
		return otro;
	}

	public void setOtro(String otro) {
		this.otro = otro;
	}

	public Boolean getPortalesExternos() {
		return portalesExternos;
	}

	public void setPortalesExternos(Boolean portalesExternos) {
		this.portalesExternos = portalesExternos;
	}

	public Boolean getOcupadoSinTitulo() {
		return ocupadoSinTitulo;
	}

	public void setOcupadoSinTitulo(Boolean ocupadoSinTitulo) {
		this.ocupadoSinTitulo = ocupadoSinTitulo;
	}

	public Boolean getDivHorizontalNoInscrita() {
		return divHorizontalNoInscrita;
	}

	public void setDivHorizontalNoInscrita(Boolean divHorizontalNoInscrita) {
		this.divHorizontalNoInscrita = divHorizontalNoInscrita;
	}

	public Boolean getIsCondicionado() {
		return isCondicionado;
	}

	public void setIsCondicionado(Boolean isCondicionado) {
		this.isCondicionado = isCondicionado;
	}

	public String getEstadoCondicionadoCodigo() {
		return estadoCondicionadoCodigo;
	}

	public void setEstadoCondicionadoCodigo(String estadoCondicionadoCodigo) {
		this.estadoCondicionadoCodigo = estadoCondicionadoCodigo;
	}

	public Boolean getSinInformeAprobado() {
		return sinInformeAprobado;
	}

	public void setSinInformeAprobado(Boolean sinInformeAprobado) {
		this.sinInformeAprobado = sinInformeAprobado;
	}

	public Boolean getConCargas() {
		return conCargas;
	}

	public void setConCargas(Boolean conCargas) {
		this.conCargas = conCargas;
	}

	public Boolean getVandalizado() {
		return vandalizado;
	}

	public void setVandalizado(Boolean vandalizado) {
		this.vandalizado = vandalizado;
	}
	
	


}
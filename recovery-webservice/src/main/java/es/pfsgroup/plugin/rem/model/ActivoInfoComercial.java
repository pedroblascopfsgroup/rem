package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConstruccion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoInfoComercial;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;



/**
 * Modelo que gestiona la informacion comercial de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_ICO_INFO_COMERCIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ActivoInfoComercial implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	
	@Id
    @Column(name = "ICO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoInfoComercialGenerator")
    @SequenceGenerator(name = "ActivoInfoComercialGenerator", sequenceName = "S_ACT_ICO_INFO_COMERCIAL")
    private Long id;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_UAC_ID")
    private DDUbicacionActivo ubicacionActivo;   

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ECT_ID")
    private DDEstadoConstruccion estadoConstruccion;   
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ECV_ID")
    private DDEstadoConservacion estadoConservacion; 

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TIC_ID")
    private DDTipoInfoComercial tipoInfoComercial; 
	
	@ManyToOne
    @JoinColumn(name = "ICO_MEDIADOR_ID")
    private ActivoProveedor mediadorInforme;
	
	@OneToOne(mappedBy = "infoComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ICO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoEdificio edificio; 

    @OneToOne(mappedBy = "infoComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ICO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoInfraestructura infraestructura;
    
    @OneToOne(mappedBy = "infoComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ICO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private ActivoCarpinteriaInterior carpinteriaInterior;
    
    @OneToOne(mappedBy = "infoComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ICO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoCarpinteriaExterior carpinteriaExterior;
	
    @OneToOne(mappedBy = "infoComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ICO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoParamentoVertical paramentoVertical;
	
    @OneToOne(mappedBy = "infoComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ICO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoSolado solado;
	
    @OneToOne(mappedBy = "infoComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ICO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoCocina cocina;
	
    @OneToOne(mappedBy = "infoComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ICO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoBanyo banyo;
	
    @OneToOne(mappedBy = "infoComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ICO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoInstalacion instalacion;
	
    @OneToOne(mappedBy = "infoComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ICO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoZonaComun zonaComun;
	
	@Column(name = "ICO_DESCRIPCION")
	private String descripcionComercial;
	
	@Column(name = "ICO_ANO_CONSTRUCCION")
	private Integer anyoConstruccion;
	
	@Column(name = "ICO_ANO_REHABILITACION")
	private Integer anyoRehabilitacion;
	
	@Column(name = "ICO_APTO_PUBLICIDAD")
	private Integer aptoPublicidad;
	
	@Column(name = "ICO_ACTIVOS_VINC")
	private String activosVinculados;
	
	@Column(name = "ICO_FECHA_EMISION_INFORME")
	private Date fechaEmisionInforme;
	
	@Column(name = "ICO_FECHA_ULTIMA_VISITA")
	private Date fechaUltimaVisita;  
	
	@Column(name = "ICO_FECHA_ACEPTACION")
	private Date fechaAceptacion;  
	
	@Column(name = "ICO_FECHA_RECHAZO")
	private Date fechaRechazo;  
	
	@Column(name = "ICO_CONDICIONES_LEGALES")
	private String condicionesLegales;
	
//  Nuevas columnas para Informe Comercial  ------------------------------	
	@Column(name = "ICO_AUTORIZACION_WEB")
	private Boolean autorizacionWeb;

	@Column(name = "ICO_FECHA_AUTORIZ_HASTA")
	private Date fechaAutorizacionHasta;

	@Column(name = "ICO_FECHA_RECEP_LLAVES")
	private Date fechaRecepcionLlaves;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPA_ID")
    private DDTipoActivo tipoActivo;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SAC_ID")
    private DDSubtipoActivo subtipoActivo;
	
// TODO: Confirmar que hay que quitarlo (Estado Activo)
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EAC_ID")
    private DDEstadoActivo estadoActivo;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TVI_ID")
    private DDTipoVia tipoVia;

	@Column(name = "ICO_NOMBRE_VIA")
	private String nombreVia;

	@Column(name = "ICO_NUM_VIA")
	private String numeroVia;

	@Column(name = "ICO_ESCALERA")
	private String escalera;

	@Column(name = "ICO_PLANTA")
	private String planta;
	
	@Column(name = "ICO_PUERTA")
	private String puerta;
	
	@Column(name = "ICO_LATITUD")
	private BigDecimal latitud;

	@Column(name = "ICO_LONGITUD")
	private BigDecimal longitud;

	@Column(name = "ICO_ZONA")
	private String zona;

	@Column(name = "ICO_DISTRITO")
	private String distrito;

	@Column(name = "ICO_CODIGO_POSTAL")
	private String codigoPostal;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_LOC_ID")
    private Localidad localidad;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;

	@Column(name = "ICO_JUSTIFICACION_VENTA")
	private String justificacionVenta;

	@Column(name = "ICO_JUSTIFICACION_RENTA")
	private String justificacionRenta;
	
	@Column(name = "ICO_CUOTACP_ORIENTATIVA")
	private Float cuotaOrientativaComunidad;

	@Column(name = "ICO_DERRAMACP_ORIENTATIVA")
	private Double derramaOrientativaComunidad;
	
	@Column(name = "ICO_FECHA_ESTIMACION_VENTA")
	private Date fechaEstimacionVenta;
	
	@Column(name = "ICO_FECHA_ESTIMACION_RENTA")
	private Date fechaEstimacionRenta;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_UPO_ID")
	private DDUnidadPoblacional unidadPoblacional;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	
	
	

	public Float getCuotaOrientativaComunidad() {
		return cuotaOrientativaComunidad;
	}

	public void setCuotaOrientativaComunidad(Float cuotaOrientativaComunidad) {
		this.cuotaOrientativaComunidad = cuotaOrientativaComunidad;
	}

	public Double getDerramaOrientativaComunidad() {
		return derramaOrientativaComunidad;
	}

	public void setDerramaOrientativaComunidad(Double derramaOrientativaComunidad) {
		this.derramaOrientativaComunidad = derramaOrientativaComunidad;
	}

	public Date getFechaEstimacionVenta() {
		return fechaEstimacionVenta;
	}

	public void setFechaEstimacionVenta(Date fechaEstimacionVenta) {
		this.fechaEstimacionVenta = fechaEstimacionVenta;
	}

	public Date getFechaEstimacionRenta() {
		return fechaEstimacionRenta;
	}

	public void setFechaEstimacionRenta(Date fechaEstimacionRenta) {
		this.fechaEstimacionRenta = fechaEstimacionRenta;
	}

	public DDUnidadPoblacional getUnidadPoblacional() {
		return unidadPoblacional;
	}

	public void setUnidadPoblacional(DDUnidadPoblacional unidadPoblacional) {
		this.unidadPoblacional = unidadPoblacional;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public DDUbicacionActivo getUbicacionActivo() {
		return ubicacionActivo;
	}

	public void setUbicacionActivo(DDUbicacionActivo ubicacionActivo) {
		this.ubicacionActivo = ubicacionActivo;
	}

	public DDEstadoConservacion getEstadoConservacion() {
		return estadoConservacion;
	}

	public void setEstadoConservacion(DDEstadoConservacion estadoConservacion) {
		this.estadoConservacion = estadoConservacion;
	}

	public DDTipoInfoComercial getTipoInfoComercial() {
		return tipoInfoComercial;
	}

	public void setTipoInfoComercial(DDTipoInfoComercial tipoInfoComercial) {
		this.tipoInfoComercial = tipoInfoComercial;
	}

	public DDEstadoConstruccion getEstadoConstruccion() {
		return estadoConstruccion;
	}

	public void setEstadoConstruccion(DDEstadoConstruccion estadoConstruccion) {
		this.estadoConstruccion = estadoConstruccion;
	}

	public ActivoEdificio getEdificio() {
		return edificio;
	}

	public void setEdificio(ActivoEdificio edificio) {
		this.edificio = edificio;
	}

	public ActivoInfraestructura getInfraestructura() {
		return infraestructura;
	}

	public void setInfraestructura(ActivoInfraestructura infraestructura) {
		this.infraestructura = infraestructura;
	}

	public ActivoCarpinteriaInterior getCarpinteriaInterior() {
		return carpinteriaInterior;
	}

	public void setCarpinteriaInterior(ActivoCarpinteriaInterior carpinteriaInterior) {
		this.carpinteriaInterior = carpinteriaInterior;
	}

	public ActivoCarpinteriaExterior getCarpinteriaExterior() {
		return carpinteriaExterior;
	}

	public void setCarpinteriaExterior(ActivoCarpinteriaExterior carpinteriaExterior) {
		this.carpinteriaExterior = carpinteriaExterior;
	}

	public ActivoParamentoVertical getParamentoVertical() {
		return paramentoVertical;
	}

	public void setParamentoVertical(ActivoParamentoVertical paramentoVertical) {
		this.paramentoVertical = paramentoVertical;
	}

	public ActivoSolado getSolado() {
		return solado;
	}

	public void setSolado(ActivoSolado solado) {
		this.solado = solado;
	}

	public ActivoCocina getCocina() {
		return cocina;
	}

	public void setCocina(ActivoCocina cocina) {
		this.cocina = cocina;
	}

	public ActivoBanyo getBanyo() {
		return banyo;
	}

	public void setBanyo(ActivoBanyo banyo) {
		this.banyo = banyo;
	}

	public ActivoInstalacion getInstalacion() {
		return instalacion;
	}

	public void setInstalacion(ActivoInstalacion instalacion) {
		this.instalacion = instalacion;
	}

	public ActivoZonaComun getZonaComun() {
		return zonaComun;
	}

	public void setZonaComun(ActivoZonaComun zonaComun) {
		this.zonaComun = zonaComun;
	}

	public String getDescripcionComercial() {
		return descripcionComercial;
	}

	public void setDescripcionComercial(String descripcionComercial) {
		this.descripcionComercial = descripcionComercial;
	}

	public Integer getAnyoConstruccion() {
		return anyoConstruccion;
	}

	public void setAnyoConstruccion(Integer anyoConstruccion) {
		this.anyoConstruccion = anyoConstruccion;
	}

	public Integer getAnyoRehabilitacion() {
		return anyoRehabilitacion;
	}

	public void setAnyoRehabilitacion(Integer anyoRehabilitacion) {
		this.anyoRehabilitacion = anyoRehabilitacion;
	}

	public Integer getAptoPublicidad() {
		return aptoPublicidad;
	}

	public void setAptoPublicidad(Integer aptoPublicidad) {
		this.aptoPublicidad = aptoPublicidad;
	}

	public String getActivosVinculados() {
		return activosVinculados;
	}

	public void setActivosVinculados(String activosVinculados) {
		this.activosVinculados = activosVinculados;
	}

	public Date getFechaEmisionInforme() {
		return fechaEmisionInforme;
	}

	public void setFechaEmisionInforme(Date fechaEmisionInforme) {
		this.fechaEmisionInforme = fechaEmisionInforme;
	}

	public Date getFechaUltimaVisita() {
		return fechaUltimaVisita;
	}

	public void setFechaUltimaVisita(Date fechaUltimaVisita) {
		this.fechaUltimaVisita = fechaUltimaVisita;
	}

	public ActivoProveedor getMediadorInforme() {
		return mediadorInforme;
	}

	public void setMediadorInforme(ActivoProveedor mediadorInforme) {
		this.mediadorInforme = mediadorInforme;
	}

	public Date getFechaAceptacion() {
		return fechaAceptacion;
	}

	public void setFechaAceptacion(Date fechaAceptacion) {
		this.fechaAceptacion = fechaAceptacion;
	}

	public Date getFechaRechazo() {
		return fechaRechazo;
	}

	public void setFechaRechazo(Date fechaRechazo) {
		this.fechaRechazo = fechaRechazo;
	}

	public String getCondicionesLegales() {
		return condicionesLegales;
	}

	public void setCondicionesLegales(String condicionesLegales) {
		this.condicionesLegales = condicionesLegales;
	}

	
	
	public Boolean getAutorizacionWeb() {
		return autorizacionWeb;
	}

	public void setAutorizacionWeb(Boolean autorizacionWeb) {
		this.autorizacionWeb = autorizacionWeb;
	}

	public Date getFechaAutorizacionHasta() {
		return fechaAutorizacionHasta;
	}

	public void setFechaAutorizacionHasta(Date fechaAutorizacionHasta) {
		this.fechaAutorizacionHasta = fechaAutorizacionHasta;
	}

	public Date getFechaRecepcionLlaves() {
		return fechaRecepcionLlaves;
	}

	public void setFechaRecepcionLlaves(Date fechaRecepcionLlaves) {
		this.fechaRecepcionLlaves = fechaRecepcionLlaves;
	}

	public DDTipoActivo getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(DDTipoActivo tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public DDSubtipoActivo getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(DDSubtipoActivo subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public DDEstadoActivo getEstadoActivo() {
		return estadoActivo;
	}

	public void setEstadoActivo(DDEstadoActivo estadoActivo) {
		this.estadoActivo = estadoActivo;
	}

	public DDTipoVia getTipoVia() {
		return tipoVia;
	}

	public void setTipoVia(DDTipoVia tipoVia) {
		this.tipoVia = tipoVia;
	}

	public String getNombreVia() {
		return nombreVia;
	}

	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
	}

	public String getNumeroVia() {
		return numeroVia;
	}

	public void setNumeroVia(String numeroVia) {
		this.numeroVia = numeroVia;
	}

	public String getEscalera() {
		return escalera;
	}

	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}

	public String getPlanta() {
		return planta;
	}

	public void setPlanta(String planta) {
		this.planta = planta;
	}

	public String getPuerta() {
		return puerta;
	}

	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}

	public BigDecimal getLatitud() {
		return latitud;
	}

	public void setLatitud(BigDecimal latitud) {
		this.latitud = latitud;
	}

	public BigDecimal getLongitud() {
		return longitud;
	}

	public void setLongitud(BigDecimal longitud) {
		this.longitud = longitud;
	}

	public String getZona() {
		return zona;
	}

	public void setZona(String zona) {
		this.zona = zona;
	}

	public String getDistrito() {
		return distrito;
	}

	public void setDistrito(String distrito) {
		this.distrito = distrito;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public Localidad getLocalidad() {
		return localidad;
	}

	public void setLocalidad(Localidad localidad) {
		this.localidad = localidad;
	}

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}
	
	public String getJustificacionVenta() {
		return justificacionVenta;
	}

	public void setJustificacionVenta(String justificacionVenta) {
		this.justificacionVenta = justificacionVenta;
	}

	public String getJustificacionRenta() {
		return justificacionRenta;
	}

	public void setJustificacionRenta(String justificacionRenta) {
		this.justificacionRenta = justificacionRenta;
	}

	
	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	
	

}
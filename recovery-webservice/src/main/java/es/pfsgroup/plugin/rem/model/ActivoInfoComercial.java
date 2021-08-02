package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

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
import javax.persistence.OneToMany;
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
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSiniSiNoIndiferente;

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

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TIC_ID_ANTERIOR")
	private DDTipoInfoComercial tipoInfoComercialAnterior;
	
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
	
	@OneToOne(mappedBy = "informeComercial")
	private ActivoVivienda vivienda;
	
	@OneToOne(mappedBy = "informeComercial")
	private ActivoLocalComercial localComercial;
	
	@OneToOne(mappedBy = "informeComercial")
	private ActivoPlazaAparcamiento plazaAparcamiento;

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

	// Nuevas columnas para Informe Comercial ------------------------------
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
	@JoinColumn(name = "DD_LOC_REGISTRO_ID")
	private Localidad localidadRegistro;

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

	@Column(name = "ICO_INFO_DESCRIPCION")
	private String infoDescripcion;

	@Column(name = "ICO_INFO_DISTRIBUCION_INTERIOR")
	private String infoDistribucionInterior;

	@Version
	private Long version;

	@Embedded
	private Auditoria auditoria;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TVP_ID")
	private DDTipoVpo regimenProteccion;

	@Column(name = "ICO_VALOR_MAX_VPO")
	private Float valorMaximoVpo;

	@Column(name = "ICO_VALOR_ESTIMADO_VENTA")
	private Float valorEstimadoVenta;

	@Column(name = "ICO_VALOR_ESTIMADO_RENTA")
	private Float valorEstimadoRenta;

	@Column(name = "ICO_OCUPADO")
	private Integer ocupado;
	
	@Column(name="ICO_NUM_TERRAZA_DESCUBIERTA")
	private Integer numeroTerrazasDescubiertas;
	
	@Column(name="ICO_DESC_TERRAZA_DESCUBIERTA")
	private String descripcionTerrazasDescubiertas;
	
	@Column(name="ICO_NUM_TERRAZA_CUBIERTA")
	private Integer numeroTerrazasCubiertas;
	
	@Column(name="ICO_DESC_TERRAZA_CUBIERTA")
	private String descripcionTerrazasCubiertas;
	
	@Column(name="ICO_DESPENSA_OTRAS_DEP")
	private Integer despensaOtrasDependencias;
	
	@Column(name="ICO_LAVADERO_OTRAS_DEP")
	private Integer lavaderoOtrasDependencias;
	
	@Column(name="ICO_AZOTEA_OTRAS_DEP")
	private Integer azoteaOtrasDependencias;
	
	@Column(name="ICO_OTROS_OTRAS_DEP")
	private String otrosOtrasDependencias;
	
	@Column(name="ICO_PRESIDENTE_NOMBRE")
	private String nombrePresidenteComunidadEdificio;
	
	@Column(name="ICO_PRESIDENTE_TELF")
	private String telefonoPresidenteComunidadEdificio;
	
	@Column(name="ICO_ADMINISTRADOR_NOMBRE")
	private String nombreAdministradorComunidadEdificio;
	
	@Column(name="ICO_ADMINISTRADOR_TELF")
	private String telefonoAdministradorComunidadEdificio;
	
	@Column(name="ICO_WEBCOM_ID")
	private Long idWebcom;
	
	@OneToMany(mappedBy = "infoComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ICO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoDistribucion> distribucion;
	
	@Column(name = "ICO_EXIS_COM_PROP")
	private Integer existeComunidadEdificio;
	
	@Column(name = "ICO_POSIBLE_HACER_INF")
	private Integer posibleInforme;
	
	@Column(name = "ICO_MOTIVO_NO_HACER_INF")
	private String motivoNoPosibleInforme;
	
	@ManyToOne
	@JoinColumn(name = "ICO_MEDIADOR_ESPEJO_ID")
	private ActivoProveedor mediadorEspejo;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="ICO_ADMITE_MASCOTAS")
	private DDSiniSiNoIndiferente admiteMascotaOtrasCaracteristicas;
	

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
		this.tipoInfoComercialAnterior = this.tipoInfoComercial;
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

	
	public ActivoVivienda getVivienda() {
		return vivienda;
	}

	public void setVivienda(ActivoVivienda vivienda) {
		this.vivienda = vivienda;
	}

	public ActivoLocalComercial getLocalComercial() {
		return localComercial;
	}

	public void setLocalComercial(ActivoLocalComercial localComercial) {
		this.localComercial = localComercial;
	}

	public ActivoPlazaAparcamiento getPlazaAparcamiento() {
		return plazaAparcamiento;
	}

	public void setPlazaAparcamiento(ActivoPlazaAparcamiento plazaAparcamiento) {
		this.plazaAparcamiento = plazaAparcamiento;
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

	public String getInfoDescripcion() {
		return infoDescripcion;
	}

	public void setInfoDescripcion(String infoDescripcion) {
		this.infoDescripcion = infoDescripcion;
	}

	public String getInfoDistribucionInterior() {
		return infoDistribucionInterior;
	}

	public void setInfoDistribucionInterior(String infoDistribucionInterior) {
		this.infoDistribucionInterior = infoDistribucionInterior;
	}

	public DDTipoVpo getRegimenProteccion() {
		return regimenProteccion;
	}

	public void setRegimenProteccion(DDTipoVpo regimenProteccion) {
		this.regimenProteccion = regimenProteccion;
	}

	public Float getValorMaximoVpo() {
		return valorMaximoVpo;
	}

	public void setValorMaximoVpo(Float valorMaximoVpo) {
		this.valorMaximoVpo = valorMaximoVpo;
	}

	public Integer getOcupado() {
		return ocupado;
	}

	public void setOcupado(Integer ocupado) {
		this.ocupado = ocupado;
	}

	public Float getValorEstimadoVenta() {
		return valorEstimadoVenta;
	}

	public void setValorEstimadoVenta(Float valorEstimadoVenta) {
		this.valorEstimadoVenta = valorEstimadoVenta;
	}

	public Float getValorEstimadoRenta() {
		return valorEstimadoRenta;
	}

	public void setValorEstimadoRenta(Float valorEstimadoRenta) {
		this.valorEstimadoRenta = valorEstimadoRenta;
	}

	public Integer getNumeroTerrazasDescubiertas() {
		return numeroTerrazasDescubiertas;
	}

	public void setNumeroTerrazasDescubiertas(Integer numeroTerrazasDescubiertas) {
		this.numeroTerrazasDescubiertas = numeroTerrazasDescubiertas;
	}

	public String getDescripcionTerrazasDescubiertas() {
		return descripcionTerrazasDescubiertas;
	}

	public void setDescripcionTerrazasDescubiertas(String descripcionTerrazasDescubiertas) {
		this.descripcionTerrazasDescubiertas = descripcionTerrazasDescubiertas;
	}

	public Integer getNumeroTerrazasCubiertas() {
		return numeroTerrazasCubiertas;
	}

	public void setNumeroTerrazasCubiertas(Integer numeroTerrazasCubiertas) {
		this.numeroTerrazasCubiertas = numeroTerrazasCubiertas;
	}

	public String getDescripcionTerrazasCubiertas() {
		return descripcionTerrazasCubiertas;
	}

	public void setDescripcionTerrazasCubiertas(String descripcionTerrazasCubiertas) {
		this.descripcionTerrazasCubiertas = descripcionTerrazasCubiertas;
	}

	public Integer getDespensaOtrasDependencias() {
		return despensaOtrasDependencias;
	}

	public void setDespensaOtrasDependencias(Integer despensaOtrasDependencias) {
		this.despensaOtrasDependencias = despensaOtrasDependencias;
	}

	public Integer getLavaderoOtrasDependencias() {
		return lavaderoOtrasDependencias;
	}

	public void setLavaderoOtrasDependencias(Integer lavaderoOtrasDependencias) {
		this.lavaderoOtrasDependencias = lavaderoOtrasDependencias;
	}

	public Integer getAzoteaOtrasDependencias() {
		return azoteaOtrasDependencias;
	}

	public void setAzoteaOtrasDependencias(Integer azoteaOtrasDependencias) {
		this.azoteaOtrasDependencias = azoteaOtrasDependencias;
	}

	public String getOtrosOtrasDependencias() {
		return otrosOtrasDependencias;
	}

	public void setOtrosOtrasDependencias(String otrosOtrasDependencias) {
		this.otrosOtrasDependencias = otrosOtrasDependencias;
	}

	public String getNombrePresidenteComunidadEdificio() {
		return nombrePresidenteComunidadEdificio;
	}

	public void setNombrePresidenteComunidadEdificio(String nombrePresidenteComunidadEdificio) {
		this.nombrePresidenteComunidadEdificio = nombrePresidenteComunidadEdificio;
	}

	public String getTelefonoPresidenteComunidadEdificio() {
		return telefonoPresidenteComunidadEdificio;
	}

	public void setTelefonoPresidenteComunidadEdificio(String telefonoPresidenteComunidadEdificio) {
		this.telefonoPresidenteComunidadEdificio = telefonoPresidenteComunidadEdificio;
	}

	public String getNombreAdministradorComunidadEdificio() {
		return nombreAdministradorComunidadEdificio;
	}

	public void setNombreAdministradorComunidadEdificio(String nombreAdministradorComunidadEdificio) {
		this.nombreAdministradorComunidadEdificio = nombreAdministradorComunidadEdificio;
	}

	public String getTelefonoAdministradorComunidadEdificio() {
		return telefonoAdministradorComunidadEdificio;
	}

	public void setTelefonoAdministradorComunidadEdificio(String telefonoAdministradorComunidadEdificio) {
		this.telefonoAdministradorComunidadEdificio = telefonoAdministradorComunidadEdificio;
	}

	public Long getIdWebcom() {
		return idWebcom;
	}

	public void setIdWebcom(Long idWebcom) {
		this.idWebcom = idWebcom;
	}

	public List<ActivoDistribucion> getDistribucion() {
		return distribucion;
	}

	public void setDistribucion(List<ActivoDistribucion> distribucion) {
		this.distribucion = distribucion;
	}

	public Integer getExisteComunidadEdificio() {
		return existeComunidadEdificio;
	}

	public void setExisteComunidadEdificio(Integer existeComunidadEdificio) {
		this.existeComunidadEdificio = existeComunidadEdificio;
	}

	public Localidad getLocalidadRegistro() {
		return localidadRegistro;
	}

	public void setLocalidadRegistro(Localidad localidadRegistro) {
		this.localidadRegistro = localidadRegistro;
	}

	public Integer getPosibleInforme() {
		return posibleInforme;
	}

	public void setPosibleInforme(Integer posibleInforme) {
		this.posibleInforme = posibleInforme;
	}

	public String getMotivoNoPosibleInforme() {
		return motivoNoPosibleInforme;
	}

	public void setMotivoNoPosibleInforme(String motivoNoPosibleInforme) {
		this.motivoNoPosibleInforme = motivoNoPosibleInforme;
	}

	public ActivoProveedor getMediadorEspejo() {
		return mediadorEspejo;
	}

	public void setMediadorEspejo(ActivoProveedor mediadorEspejo) {
		this.mediadorEspejo = mediadorEspejo;
	}
	
	public DDSiniSiNoIndiferente getAdmiteMascotaOtrasCaracteristicas() {
		return admiteMascotaOtrasCaracteristicas;
	}

	public void setAdmiteMascotaOtrasCaracteristicas(DDSiniSiNoIndiferente admiteMascotaOtrasCaracteristicas) {
		this.admiteMascotaOtrasCaracteristicas = admiteMascotaOtrasCaracteristicas;
	}

	public DDTipoInfoComercial getTipoInfoComercialAnterior() {
		return tipoInfoComercialAnterior;
	}

	public void setTipoInfoComercialAnterior(DDTipoInfoComercial tipoInfoComercialAnterior) {
		this.tipoInfoComercialAnterior = tipoInfoComercialAnterior;
	}
	

}
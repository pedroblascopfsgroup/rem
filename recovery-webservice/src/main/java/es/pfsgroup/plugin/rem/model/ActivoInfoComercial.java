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
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.dd.DDAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDClasificacion;
import es.pfsgroup.plugin.rem.model.dd.DDDisponibilidad;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacionEdificio;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConstruccion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoMobiliario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOcupacional;
import es.pfsgroup.plugin.rem.model.dd.DDExteriorInterior;
import es.pfsgroup.plugin.rem.model.dd.DDRatingCocina;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalefaccion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoClimatizacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoInfoComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPuerta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDUsoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDValoracionUbicacion;
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

	@Column(name = "ICO_DESCRIPCION")
	private String descripcionComercial;

	@Column(name = "ICO_ANO_CONSTRUCCION")
	private Integer anyoConstruccion;

	@Column(name = "ICO_ANO_REHABILITACION")
	private Integer anyoRehabilitacion;

	@Column(name = "ICO_FECHA_ULTIMA_VISITA")
	private Date fechaUltimaVisita;

	@Column(name = "ICO_FECHA_ACEPTACION")
	private Date fechaAceptacion;

	@Column(name = "ICO_FECHA_RECHAZO")
	private Date fechaRechazo;

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

	/*@Column(name = "ICO_ZONA")
	private String zona;

	@Column(name = "ICO_DISTRITO")
	private String distrito;*/

	@Column(name = "ICO_CODIGO_POSTAL")
	private String codigoPostal;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_LOC_ID")
	private Localidad localidad;
	
	/*@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_LOC_REGISTRO_ID")
	private Localidad localidadRegistro;*/

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_PRV_ID")
	private DDProvincia provincia;

	/*@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_UPO_ID")
	private DDUnidadPoblacional unidadPoblacional;*/

	@Version
	private Long version;

	@Embedded
	private Auditoria auditoria;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TVP_ID")
	private DDTipoVpo regimenProteccion;

	@Column(name = "ICO_VALOR_ESTIMADO_VENTA")
	private Float valorEstimadoVenta;

	@Column(name = "ICO_VALOR_ESTIMADO_RENTA")
	private Float valorEstimadoRenta;

	@ManyToOne
	@JoinColumn(name = "ICO_OCUPADO")
	private DDSinSiNo ocupado;
	
	@Column(name="ICO_WEBCOM_ID")
	private Long idWebcom;
	
	@Column(name = "ICO_POSIBLE_HACER_INF")
	private Integer posibleInforme;
	
	@Column(name = "ICO_MOTIVO_NO_HACER_INF")
	private String motivoNoPosibleInforme;
	
	@ManyToOne
	@JoinColumn(name = "ICO_MEDIADOR_ESPEJO_ID")
	private ActivoProveedor mediadorEspejo;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="ICO_ADMITE_MASCOTAS")
	private DDAdmision admiteMascotas;	

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_ESO_ID")
	private DDEstadoOcupacional estadoOcupacional;

	@ManyToOne
	@JoinColumn(name = "ICO_TERRAZA")
	private DDSinSiNo terraza;

	@ManyToOne
	@JoinColumn(name = "ICO_PATIO")
	private DDSinSiNo patio;

	@ManyToOne
	@JoinColumn(name = "ICO_ASCENSOR")
	private DDSinSiNo ascensor;

	@ManyToOne
	@JoinColumn(name = "ICO_REHABILITADO")
	private DDSinSiNo rehabilitado;

	@ManyToOne
	@JoinColumn(name = "ICO_LIC_APERTURA")
	private DDSinSiNo licenciaApertura;

	@ManyToOne
	@JoinColumn(name = "ICO_ANEJO_GARAJE")
	private DDSinSiNo anejoGaraje;

	@ManyToOne
	@JoinColumn(name = "ICO_ANEJO_TRASTERO")
	private DDSinSiNo anejoTrastero;

	@ManyToOne
	@JoinColumn(name = "DD_RAC_ID")
	private DDRatingCocina ratingCocina;

	@ManyToOne
	@JoinColumn(name = "ICO_COCINA_AMUEBLADA")
	private DDSinSiNo cocinaAmueblada;

	@ManyToOne
	@JoinColumn(name = "DD_TCA_ID")
	private DDTipoCalefaccion tipoCalefaccion;

	@ManyToOne
	@JoinColumn(name = "DD_TCL_ID")
	private DDTipoClimatizacion aireAcondicionado;

	@ManyToOne
	@JoinColumn(name = "ICO_ARM_EMPOTRADOS")
	private DDSinSiNo armariosEmpotrados;

	@ManyToOne
	@JoinColumn(name = "DD_EXI_ID")
	private DDExteriorInterior exteriorInterior;

	@ManyToOne
	@JoinColumn(name = "ICO_ZONAS_VERDES")
	private DDSinSiNo zonasVerdes;

	@ManyToOne
	@JoinColumn(name = "ICO_CONSERJE")
	private DDSinSiNo conserje;

	@ManyToOne
	@JoinColumn(name = "ICO_INST_DEPORTIVAS")
	private DDSinSiNo instalacionesDeportivas;

	@ManyToOne
	@JoinColumn(name = "ICO_ACC_MINUSVALIDO")
	private DDSinSiNo accesoMinusvalidos;

	@ManyToOne
	@JoinColumn(name = "ICO_JARDIN")
	private DDDisponibilidad jardin;

	@ManyToOne
	@JoinColumn(name = "ICO_PISCINA")
	private DDDisponibilidad piscina;
	
	@ManyToOne
	@JoinColumn(name = "ICO_GIMNASIO")
	private DDDisponibilidad gimnasio;

	@ManyToOne
	@JoinColumn(name = "DD_ESC_ID")
	private DDEstadoConservacionEdificio estadoConservacionEdificio;

	@ManyToOne
	@JoinColumn(name = "DD_TPU_ID")
	private DDTipoPuerta tipoPuerta;

	@ManyToOne
	@JoinColumn(name = "ICO_PUERTAS_INT")
	private DDEstadoMobiliario estadoPuertasInteriores;

	@ManyToOne
	@JoinColumn(name = "ICO_VENTANAS")
	private DDEstadoMobiliario estadoVentanas;

	@ManyToOne
	@JoinColumn(name = "ICO_PERSIANAS")
	private DDEstadoMobiliario estadoPersianas;

	@ManyToOne
	@JoinColumn(name = "ICO_PINTURA")
	private DDEstadoMobiliario estadoPintura;

	@ManyToOne
	@JoinColumn(name = "ICO_SOLADOS")
	private DDEstadoMobiliario estadoSolados;

	@ManyToOne
	@JoinColumn(name = "ICO_BANYOS")
	private DDEstadoMobiliario estadoBanyos;

	@ManyToOne
	@JoinColumn(name = "DD_VUB_ID")
	private DDValoracionUbicacion valoracionUbicacion;

	@ManyToOne
	@JoinColumn(name = "ICO_SALIDA_HUMOS")
	private DDSinSiNo salidaHumos;

	@ManyToOne
	@JoinColumn(name = "ICO_USO_BRUTO")
	private DDSinSiNo aptoUsoBruto;

	@ManyToOne
	@JoinColumn(name = "DD_CLA_ID")
	private DDClasificacion clasificacion;

	@ManyToOne
	@JoinColumn(name = "DD_USA_ID")
	private DDUsoActivo usoActivo;

	@ManyToOne
	@JoinColumn(name = "ICO_ALMACEN")
	private DDSinSiNo almacen;

	@ManyToOne
	@JoinColumn(name = "ICO_VENTA_EXPO")
	private DDSinSiNo ventaExposicion;

	@ManyToOne
	@JoinColumn(name = "ICO_ENTREPLANTA")
	private DDSinSiNo entreplanta;

	@ManyToOne
	@JoinColumn(name = "ICO_USU_MODIFICACION")
	private Usuario usuarioModificacionInforme;

	@ManyToOne
	@JoinColumn(name = "ICO_USU_INFORME_COMPLETO")
	private Usuario usuarioInformeCompleto;

	@ManyToOne
	@JoinColumn(name = "ICO_VISITABLE")
	private DDSinSiNo visitable;
	
	@Column(name="ICO_FECHA_ENVIO_LLAVES_API")
	private Date envioLlavesApi;

	@Column(name="ICO_NUM_DORMITORIOS")
	private Long numDormitorios;

	@Column(name="ICO_NUM_BANYOS")
	private Long numBanyos;

	@Column(name="ICO_NUM_GARAJE")
	private Long numGaraje;

	@Column(name="ICO_NUM_ASEOS")
	private Long numAseos;

	@Column(name="ICO_ORIENTACION")
	private String orientacion;

	@Column(name="ICO_CALEFACCION")
	private String calefaccion;

	@Column(name="ICO_SUP_TERRAZA")
	private Float superficieTerraza;

	@Column(name="ICO_SUP_PATIO")
	private Float superficiePatio;

	@Column(name="ICO_NUM_PLANTAS_EDI")
	private Long numPlantasEdificio;

	@Column(name="ICO_EDIFICABILIDAD")
	private Float edificabilidad;

	@Column(name="ICO_SUP_PARCELA")
	private Float superficieParcela;

	@Column(name="ICO_URBANIZACION_EJEC")
	private Float urbanizacionEjecutado;

	@Column(name="ICO_MTRS_FACHADA")
	private Float metrosFachada;

	@Column(name="ICO_SUP_ALMACEN")
	private Float superficieAlmacen;

	@Column(name="ICO_SUP_VENTA_EXPO")
	private Float superficieVentaExposicion;

	@Column(name="ICO_ALTURA_LIBRE")
	private Float alturaLibre;

	@Column(name="ICO_EDIFICACION_EJEC")
	private Float edificacionEjecutada;

	@Column(name="ICO_RECEPCION_INFORME")
	private Date recepcionInforme;

	@Column(name="ICO_FECHA_MODIFICACION")
	private Date modificacionInforme;

	@Column(name="ICO_FECHA_INFORME_COMPLETO")
	private Date informeCompleto;

	@Column(name="ICO_VALOR_MIN_VENTA")
	private Float minVenta;

	@Column(name="ICO_VALOR_MAX_VENTA")
	private Float maxVenta;

	@Column(name="ICO_VALOR_MAX_RENTA")
	private Float maxRenta;

	@Column(name="ICO_VALOR_MIN_RENTA")
	private Float minRenta;

	@Column(name="ICO_NUM_SALONES")
	private Long numSalones;

	@Column(name="ICO_NUM_ESTANCIAS")
	private Long numEstancias;

	@Column(name="ICO_NUM_PLANTAS")
	private Long numPlantas;
	
	

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

	public DDTipoInfoComercial getTipoInfoComercialAnterior() {
		return tipoInfoComercialAnterior;
	}

	public void setTipoInfoComercialAnterior(DDTipoInfoComercial tipoInfoComercialAnterior) {
		this.tipoInfoComercialAnterior = tipoInfoComercialAnterior;
	}

	public ActivoProveedor getMediadorInforme() {
		return mediadorInforme;
	}

	public void setMediadorInforme(ActivoProveedor mediadorInforme) {
		this.mediadorInforme = mediadorInforme;
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

	public Date getFechaUltimaVisita() {
		return fechaUltimaVisita;
	}

	public void setFechaUltimaVisita(Date fechaUltimaVisita) {
		this.fechaUltimaVisita = fechaUltimaVisita;
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

	public DDTipoVpo getRegimenProteccion() {
		return regimenProteccion;
	}

	public void setRegimenProteccion(DDTipoVpo regimenProteccion) {
		this.regimenProteccion = regimenProteccion;
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

	public DDSinSiNo getOcupado() {
		return ocupado;
	}

	public void setOcupado(DDSinSiNo ocupado) {
		this.ocupado = ocupado;
	}

	public Long getIdWebcom() {
		return idWebcom;
	}

	public void setIdWebcom(Long idWebcom) {
		this.idWebcom = idWebcom;
	}

	public ActivoProveedor getMediadorEspejo() {
		return mediadorEspejo;
	}

	public void setMediadorEspejo(ActivoProveedor mediadorEspejo) {
		this.mediadorEspejo = mediadorEspejo;
	}

	public DDAdmision getAdmiteMascotas() {
		return admiteMascotas;
	}

	public void setAdmiteMascotas(DDAdmision admiteMascotas) {
		this.admiteMascotas = admiteMascotas;
	}

	public DDEstadoOcupacional getEstadoOcupacional() {
		return estadoOcupacional;
	}

	public void setEstadoOcupacional(DDEstadoOcupacional estadoOcupacional) {
		this.estadoOcupacional = estadoOcupacional;
	}

	public DDSinSiNo getTerraza() {
		return terraza;
	}

	public void setTerraza(DDSinSiNo terraza) {
		this.terraza = terraza;
	}

	public DDSinSiNo getPatio() {
		return patio;
	}

	public void setPatio(DDSinSiNo patio) {
		this.patio = patio;
	}

	public DDSinSiNo getAscensor() {
		return ascensor;
	}

	public void setAscensor(DDSinSiNo ascensor) {
		this.ascensor = ascensor;
	}

	public DDSinSiNo getRehabilitado() {
		return rehabilitado;
	}

	public void setRehabilitado(DDSinSiNo rehabilitado) {
		this.rehabilitado = rehabilitado;
	}

	public DDSinSiNo getLicenciaApertura() {
		return licenciaApertura;
	}

	public void setLicenciaApertura(DDSinSiNo licenciaApertura) {
		this.licenciaApertura = licenciaApertura;
	}

	public DDSinSiNo getAnejoGaraje() {
		return anejoGaraje;
	}

	public void setAnejoGaraje(DDSinSiNo anejoGaraje) {
		this.anejoGaraje = anejoGaraje;
	}

	public DDSinSiNo getAnejoTrastero() {
		return anejoTrastero;
	}

	public void setAnejoTrastero(DDSinSiNo anejoTrastero) {
		this.anejoTrastero = anejoTrastero;
	}

	public DDRatingCocina getRatingCocina() {
		return ratingCocina;
	}

	public void setRatingCocina(DDRatingCocina ratingCocina) {
		this.ratingCocina = ratingCocina;
	}

	public DDSinSiNo getCocinaAmueblada() {
		return cocinaAmueblada;
	}

	public void setCocinaAmueblada(DDSinSiNo cocinaAmueblada) {
		this.cocinaAmueblada = cocinaAmueblada;
	}

	public DDTipoCalefaccion getTipoCalefaccion() {
		return tipoCalefaccion;
	}

	public void setTipoCalefaccion(DDTipoCalefaccion tipoCalefaccion) {
		this.tipoCalefaccion = tipoCalefaccion;
	}

	public DDTipoClimatizacion getAireAcondicionado() {
		return aireAcondicionado;
	}

	public void setAireAcondicionado(DDTipoClimatizacion aireAcondicionado) {
		this.aireAcondicionado = aireAcondicionado;
	}

	public DDSinSiNo getArmariosEmpotrados() {
		return armariosEmpotrados;
	}

	public void setArmariosEmpotrados(DDSinSiNo armariosEmpotrados) {
		this.armariosEmpotrados = armariosEmpotrados;
	}

	public DDExteriorInterior getExteriorInterior() {
		return exteriorInterior;
	}

	public void setExteriorInterior(DDExteriorInterior exteriorInterior) {
		this.exteriorInterior = exteriorInterior;
	}

	public DDSinSiNo getZonasVerdes() {
		return zonasVerdes;
	}

	public void setZonasVerdes(DDSinSiNo zonasVerdes) {
		this.zonasVerdes = zonasVerdes;
	}

	public DDSinSiNo getConserje() {
		return conserje;
	}

	public void setConserje(DDSinSiNo conserje) {
		this.conserje = conserje;
	}

	public DDSinSiNo getInstalacionesDeportivas() {
		return instalacionesDeportivas;
	}

	public void setInstalacionesDeportivas(DDSinSiNo instalacionesDeportivas) {
		this.instalacionesDeportivas = instalacionesDeportivas;
	}

	public DDSinSiNo getAccesoMinusvalidos() {
		return accesoMinusvalidos;
	}

	public void setAccesoMinusvalidos(DDSinSiNo accesoMinusvalidos) {
		this.accesoMinusvalidos = accesoMinusvalidos;
	}

	public DDDisponibilidad getJardin() {
		return jardin;
	}

	public void setJardin(DDDisponibilidad jardin) {
		this.jardin = jardin;
	}

	public DDDisponibilidad getPiscina() {
		return piscina;
	}

	public void setPiscina(DDDisponibilidad piscina) {
		this.piscina = piscina;
	}

	public DDDisponibilidad getGimnasio() {
		return gimnasio;
	}

	public void setGimnasio(DDDisponibilidad gimnasio) {
		this.gimnasio = gimnasio;
	}

	public DDEstadoConservacionEdificio getEstadoConservacionEdificio() {
		return estadoConservacionEdificio;
	}

	public void setEstadoConservacionEdificio(DDEstadoConservacionEdificio estadoConservacionEdificio) {
		this.estadoConservacionEdificio = estadoConservacionEdificio;
	}

	public DDTipoPuerta getTipoPuerta() {
		return tipoPuerta;
	}

	public void setTipoPuerta(DDTipoPuerta tipoPuerta) {
		this.tipoPuerta = tipoPuerta;
	}

	public DDEstadoMobiliario getEstadoPuertasInteriores() {
		return estadoPuertasInteriores;
	}

	public void setEstadoPuertasInteriores(DDEstadoMobiliario estadoPuertasInteriores) {
		this.estadoPuertasInteriores = estadoPuertasInteriores;
	}

	public DDEstadoMobiliario getEstadoVentanas() {
		return estadoVentanas;
	}

	public void setEstadoVentanas(DDEstadoMobiliario estadoVentanas) {
		this.estadoVentanas = estadoVentanas;
	}

	public DDEstadoMobiliario getEstadoPersianas() {
		return estadoPersianas;
	}

	public void setEstadoPersianas(DDEstadoMobiliario estadoPersianas) {
		this.estadoPersianas = estadoPersianas;
	}

	public DDEstadoMobiliario getEstadoPintura() {
		return estadoPintura;
	}

	public void setEstadoPintura(DDEstadoMobiliario estadoPintura) {
		this.estadoPintura = estadoPintura;
	}

	public DDEstadoMobiliario getEstadoSolados() {
		return estadoSolados;
	}

	public void setEstadoSolados(DDEstadoMobiliario estadoSolados) {
		this.estadoSolados = estadoSolados;
	}

	public DDEstadoMobiliario getEstadoBanyos() {
		return estadoBanyos;
	}

	public void setEstadoBanyos(DDEstadoMobiliario estadoBanyos) {
		this.estadoBanyos = estadoBanyos;
	}

	public DDValoracionUbicacion getValoracionUbicacion() {
		return valoracionUbicacion;
	}

	public void setValoracionUbicacion(DDValoracionUbicacion valoracionUbicacion) {
		this.valoracionUbicacion = valoracionUbicacion;
	}

	public DDSinSiNo getSalidaHumos() {
		return salidaHumos;
	}

	public void setSalidaHumos(DDSinSiNo salidaHumos) {
		this.salidaHumos = salidaHumos;
	}

	public DDSinSiNo getAptoUsoBruto() {
		return aptoUsoBruto;
	}

	public void setAptoUsoBruto(DDSinSiNo aptoUsoBruto) {
		this.aptoUsoBruto = aptoUsoBruto;
	}

	public DDClasificacion getClasificacion() {
		return clasificacion;
	}

	public void setClasificacion(DDClasificacion clasificacion) {
		this.clasificacion = clasificacion;
	}

	public DDUsoActivo getUsoActivo() {
		return usoActivo;
	}

	public void setUsoActivo(DDUsoActivo usoActivo) {
		this.usoActivo = usoActivo;
	}

	public DDSinSiNo getAlmacen() {
		return almacen;
	}

	public void setAlmacen(DDSinSiNo almacen) {
		this.almacen = almacen;
	}

	public DDSinSiNo getVentaExposicion() {
		return ventaExposicion;
	}

	public void setVentaExposicion(DDSinSiNo ventaExposicion) {
		this.ventaExposicion = ventaExposicion;
	}

	public DDSinSiNo getEntreplanta() {
		return entreplanta;
	}

	public void setEntreplanta(DDSinSiNo entreplanta) {
		this.entreplanta = entreplanta;
	}

	public Usuario getUsuarioModificacionInforme() {
		return usuarioModificacionInforme;
	}

	public void setUsuarioModificacionInforme(Usuario usuarioModificacionInforme) {
		this.usuarioModificacionInforme = usuarioModificacionInforme;
	}

	public Usuario getUsuarioInformeCompleto() {
		return usuarioInformeCompleto;
	}

	public void setUsuarioInformeCompleto(Usuario usuarioInformeCompleto) {
		this.usuarioInformeCompleto = usuarioInformeCompleto;
	}

	public DDSinSiNo getVisitable() {
		return visitable;
	}

	public void setVisitable(DDSinSiNo visitable) {
		this.visitable = visitable;
	}

	public Date getEnvioLlavesApi() {
		return envioLlavesApi;
	}

	public void setEnvioLlavesApi(Date envioLlavesApi) {
		this.envioLlavesApi = envioLlavesApi;
	}

	public Long getNumDormitorios() {
		return numDormitorios;
	}

	public void setNumDormitorios(Long numDormitorios) {
		this.numDormitorios = numDormitorios;
	}

	public Long getNumBanyos() {
		return numBanyos;
	}

	public void setNumBanyos(Long numBanyos) {
		this.numBanyos = numBanyos;
	}

	public Long getNumGaraje() {
		return numGaraje;
	}

	public void setNumGaraje(Long numGaraje) {
		this.numGaraje = numGaraje;
	}

	public Long getNumAseos() {
		return numAseos;
	}

	public void setNumAseos(Long numAseos) {
		this.numAseos = numAseos;
	}

	public String getOrientacion() {
		return orientacion;
	}

	public void setOrientacion(String orientacion) {
		this.orientacion = orientacion;
	}

	public String getCalefaccion() {
		return calefaccion;
	}

	public void setCalefaccion(String calefaccion) {
		this.calefaccion = calefaccion;
	}

	public Float getSuperficieTerraza() {
		return superficieTerraza;
	}

	public void setSuperficieTerraza(Float superficieTerraza) {
		this.superficieTerraza = superficieTerraza;
	}

	public Float getSuperficiePatio() {
		return superficiePatio;
	}

	public void setSuperficiePatio(Float superficiePatio) {
		this.superficiePatio = superficiePatio;
	}

	public Long getNumPlantasEdificio() {
		return numPlantasEdificio;
	}

	public void setNumPlantasEdificio(Long numPlantasEdificio) {
		this.numPlantasEdificio = numPlantasEdificio;
	}

	public Float getEdificabilidad() {
		return edificabilidad;
	}

	public void setEdificabilidad(Float edificabilidad) {
		this.edificabilidad = edificabilidad;
	}

	public Float getSuperficieParcela() {
		return superficieParcela;
	}

	public void setSuperficieParcela(Float superficieParcela) {
		this.superficieParcela = superficieParcela;
	}

	public Float getUrbanizacionEjecutado() {
		return urbanizacionEjecutado;
	}

	public void setUrbanizacionEjecutado(Float urbanizacionEjecutado) {
		this.urbanizacionEjecutado = urbanizacionEjecutado;
	}

	public Float getMetrosFachada() {
		return metrosFachada;
	}

	public void setMetrosFachada(Float metrosFachada) {
		this.metrosFachada = metrosFachada;
	}

	public Float getSuperficieAlmacen() {
		return superficieAlmacen;
	}

	public void setSuperficieAlmacen(Float superficieAlmacen) {
		this.superficieAlmacen = superficieAlmacen;
	}

	public Float getSuperficieVentaExposicion() {
		return superficieVentaExposicion;
	}

	public void setSuperficieVentaExposicion(Float superficieVentaExposicion) {
		this.superficieVentaExposicion = superficieVentaExposicion;
	}

	public Float getAlturaLibre() {
		return alturaLibre;
	}

	public void setAlturaLibre(Float alturaLibre) {
		this.alturaLibre = alturaLibre;
	}

	public Float getEdificacionEjecutada() {
		return edificacionEjecutada;
	}

	public void setEdificacionEjecutada(Float edificacionEjecutada) {
		this.edificacionEjecutada = edificacionEjecutada;
	}

	public Date getRecepcionInforme() {
		return recepcionInforme;
	}

	public void setRecepcionInforme(Date recepcionInforme) {
		this.recepcionInforme = recepcionInforme;
	}

	public Date getModificacionInforme() {
		return modificacionInforme;
	}

	public void setModificacionInforme(Date modificacionInforme) {
		this.modificacionInforme = modificacionInforme;
	}

	public Date getInformeCompleto() {
		return informeCompleto;
	}

	public void setInformeCompleto(Date informeCompleto) {
		this.informeCompleto = informeCompleto;
	}

	public Float getMinVenta() {
		return minVenta;
	}

	public void setMinVenta(Float minVenta) {
		this.minVenta = minVenta;
	}

	public Float getMaxVenta() {
		return maxVenta;
	}

	public void setMaxVenta(Float maxVenta) {
		this.maxVenta = maxVenta;
	}

	public Float getMaxRenta() {
		return maxRenta;
	}

	public void setMaxRenta(Float maxRenta) {
		this.maxRenta = maxRenta;
	}

	public Float getMinRenta() {
		return minRenta;
	}

	public void setMinRenta(Float minRenta) {
		this.minRenta = minRenta;
	}

	public Long getNumSalones() {
		return numSalones;
	}

	public void setNumSalones(Long numSalones) {
		this.numSalones = numSalones;
	}

	public Long getNumEstancias() {
		return numEstancias;
	}

	public void setNumEstancias(Long numEstancias) {
		this.numEstancias = numEstancias;
	}

	public Long getNumPlantas() {
		return numPlantas;
	}

	public void setNumPlantas(Long numPlantas) {
		this.numPlantas = numPlantas;
	}
	
}
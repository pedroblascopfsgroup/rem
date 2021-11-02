package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
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
import es.pfsgroup.plugin.rem.model.dd.DDBancoOrigen;
import es.pfsgroup.plugin.rem.model.dd.DDCategoriaComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComercialAlquilerCaixa;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComercialVentaCaixa;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTecnicoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSociedadOrigen;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTributacionPropuestaClienteExentoIva;
import es.pfsgroup.plugin.rem.model.dd.DDTributacionPropuestaVenta;

@Entity
@Table(name = "ACT_ACTIVO_CAIXA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoCaixa implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "CBX_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoCaixaGenerator")
    @SequenceGenerator(name = "ActivoCaixaGenerator", sequenceName = "S_ACT_ACTIVO_CAIXA")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ECA_ID")
	private DDEstadoComercialAlquilerCaixa estadoComercialAlquiler;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ECV_ID")
	private DDEstadoComercialVentaCaixa estadoComercialVenta;	
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EAT_ID")
	private DDEstadoTecnicoActivo estadoTecnico;
	
    @Column(name = "FECHA_ECA_EST_COM_ALQUILER")
    private Date fechaEstadoComercialAlquiler;
    
    @Column(name = "FECHA_ECV_EST_COM_VENTA")
    private Date fechaEstadoComercialVenta;
    
    @Column(name = "FECHA_EAT_EST_TECNICO")
    private Date fechaEstadoTecnico;
    
    @Column(name = "CBX_NECESIDAD_ARRAS")
    private Boolean necesidadArras;
    
	@Column(name = "CBX_NEC_FUERZA_PUBL")
	private Boolean necesariaFuerzaPublica;
	
	@Column(name = "CBX_PRECIO_VENT_NEGO")
    private Boolean precioVentaNegociable;
	
	@Column(name = "CBX_PRECIO_ALQU_NEGO")
    private Boolean precioAlquilerNegociable;
	
	@Column(name = "CBX_CAMP_PRECIO_VENT_NEGO")
    private Boolean campanyaPrecioVentaNegociable;
	
	@Column(name = "CBX_CAMP_PRECIO_ALQ_NEGO")
    private Boolean campanyaPrecioAlquilerNegociable;
	
	@Column(name = "CBX_ENTRADA_VOLUN_POSES")
	private Boolean entradaVoluntariaPosesion;
	
    @Column(name = "CBX_FECHA_EST_TIT_ACT_INM")
    private Date fechaEstadoTitularidadActivoInmobiliario;
    
    @Column(name = "CBX_FECHA_EST_POS_ACT_INM")
    private Date fechaEstadoPosesorioActivoInmobiliario;
    
    @Column(name = "CBX_PUBL_PORT_PUBL_VENTA")
    private Boolean publicacionPortalPublicoVenta;
    
    @Column(name = "CBX_PUBL_PORT_PUBL_ALQUILER")
    private Boolean publicacionPortalPublicoAlquiler;
    
    @Column(name = "CBX_PUBL_PORT_INV_VENTA")
    private Boolean publicacionPortalInversorVenta;
    
    @Column(name = "CBX_PUBL_PORT_INV_ALQUILER")
    private Boolean publicacionPortalInversorAlquiler;
    
    @Column(name = "CBX_PUBL_PORT_API_VENTA")
    private Boolean publicacionPortalApiVenta;
    
    @Column(name = "CBX_PUBL_PORT_API_ALQUILER")
    private Boolean publicacionPortalApiAlquiler;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CBX_CANAL_DIST_VENTA")
    private DDTipoComercializar canalDistribucionVenta;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CBX_CANAL_DIST_ALQUILER")
    private DDTipoComercializar canalDistribucionAlquiler;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SOR_ID")
    private DDSociedadOrigen sociedadOrigen;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_BOR_ID")
    private DDBancoOrigen bancoOrigen;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPE_ID")
    private DDTributacionPropuestaClienteExentoIva tributacionPropuestaClienteExentoIva;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPV_ID")
    private DDTributacionPropuestaVenta tributacionPropuestaVenta;
    
	@Column(name = "CBX_CARTERA_CONCENTRADA")
	private Boolean carteraConcentrada;
	
	@Column(name = "CBX_ACTIVO_AAMM")
	private Boolean activoAAMM;
	
	@Column(name = "CBX_ACTIVO_PROM_ESTR")
	private Boolean activoPromocionesEstrategicas;
	
	@Column(name = "CBX_FEC_INI_CONCU")
    private Date fechaInicioConcurrencia;
	
	@Column(name = "CBX_FEC_FIN_CONCU")
    private Date fechaFinConcurrencia;
	
    @Column(name = "MOT_NECESIDAD_ARRAS")
    private String motivosNecesidadArras;
    
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CTC_ID")
    private DDCategoriaComercializacion categoriaComercializacion;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

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

	public DDEstadoComercialAlquilerCaixa getEstadoComercialAlquiler() {
		return estadoComercialAlquiler;
	}

	public void setEstadoComercialAlquiler(DDEstadoComercialAlquilerCaixa estadoComercialAlquiler) {
		this.estadoComercialAlquiler = estadoComercialAlquiler;
	}

	public DDEstadoComercialVentaCaixa getEstadoComercialVenta() {
		return estadoComercialVenta;
	}

	public void setEstadoComercialVenta(DDEstadoComercialVentaCaixa estadoComercialVenta) {
		this.estadoComercialVenta = estadoComercialVenta;
	}

	public DDEstadoTecnicoActivo getEstadoTecnico() {
		return estadoTecnico;
	}

	public void setEstadoTecnico(DDEstadoTecnicoActivo estadoTecnico) {
		this.estadoTecnico = estadoTecnico;
	}

	public Date getFechaEstadoComercialAlquiler() {
		return fechaEstadoComercialAlquiler;
	}

	public void setFechaEstadoComercialAlquiler(Date fechaEstadoComercialAlquiler) {
		this.fechaEstadoComercialAlquiler = fechaEstadoComercialAlquiler;
	}

	public Date getFechaEstadoComercialVenta() {
		return fechaEstadoComercialVenta;
	}

	public void setFechaEstadoComercialVenta(Date fechaEstadoComercialVenta) {
		this.fechaEstadoComercialVenta = fechaEstadoComercialVenta;
	}

	public Date getFechaEstadoTecnico() {
		return fechaEstadoTecnico;
	}

	public void setFechaEstadoTecnico(Date fechaEstadoTecnico) {
		this.fechaEstadoTecnico = fechaEstadoTecnico;
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

	public Boolean getNecesidadArras() {
		return necesidadArras;
	}

	public void setNecesidadArras(Boolean necesidadArras) {
		this.necesidadArras = necesidadArras;
	}

	public Boolean getNecesariaFuerzaPublica() {
		return necesariaFuerzaPublica;
	}

	public void setNecesariaFuerzaPublica(Boolean necesariaFuerzaPublica) {
		this.necesariaFuerzaPublica = necesariaFuerzaPublica;
	}

	public Boolean getPrecioVentaNegociable() {
		return precioVentaNegociable;
	}

	public void setPrecioVentaNegociable(Boolean precioVentaNegociable) {
		this.precioVentaNegociable = precioVentaNegociable;
	}

	public Boolean getPrecioAlquilerNegociable() {
		return precioAlquilerNegociable;
	}

	public void setPrecioAlquilerNegociable(Boolean precioAlquilerNegociable) {
		this.precioAlquilerNegociable = precioAlquilerNegociable;
	}

	public Boolean getCampanyaPrecioVentaNegociable() {
		return campanyaPrecioVentaNegociable;
	}

	public void setCampanyaPrecioVentaNegociable(Boolean campanyaPrecioVentaNegociable) {
		this.campanyaPrecioVentaNegociable = campanyaPrecioVentaNegociable;
	}

	public Boolean getCampanyaPrecioAlquilerNegociable() {
		return campanyaPrecioAlquilerNegociable;
	}

	public void setCampanyaPrecioAlquilerNegociable(Boolean campanyaPrecioAlquilerNegociable) {
		this.campanyaPrecioAlquilerNegociable = campanyaPrecioAlquilerNegociable;
	}

	public Boolean getEntradaVoluntariaPosesion() {
		return entradaVoluntariaPosesion;
	}

	public void setEntradaVoluntariaPosesion(Boolean entradaVoluntariaPosesion) {
		this.entradaVoluntariaPosesion = entradaVoluntariaPosesion;
	}

	public Date getFechaEstadoTitularidadActivoInmobiliario() {
		return fechaEstadoTitularidadActivoInmobiliario;
	}

	public void setFechaEstadoTitularidadActivoInmobiliario(Date fechaEstadoTitularidadActivoInmobiliario) {
		this.fechaEstadoTitularidadActivoInmobiliario = fechaEstadoTitularidadActivoInmobiliario;
	}

	public Date getFechaEstadoPosesorioActivoInmobiliario() {
		return fechaEstadoPosesorioActivoInmobiliario;
	}

	public void setFechaEstadoPosesorioActivoInmobiliario(Date fechaEstadoPosesorioActivoInmobiliario) {
		this.fechaEstadoPosesorioActivoInmobiliario = fechaEstadoPosesorioActivoInmobiliario;
	}

	public Boolean getPublicacionPortalPublicoVenta() {
		return publicacionPortalPublicoVenta;
	}

	public void setPublicacionPortalPublicoVenta(Boolean publicacionPortalPublicoVenta) {
		this.publicacionPortalPublicoVenta = publicacionPortalPublicoVenta;
	}

	public Boolean getPublicacionPortalPublicoAlquiler() {
		return publicacionPortalPublicoAlquiler;
	}

	public void setPublicacionPortalPublicoAlquiler(Boolean publicacionPortalPublicoAlquiler) {
		this.publicacionPortalPublicoAlquiler = publicacionPortalPublicoAlquiler;
	}

	public Boolean getPublicacionPortalInversorVenta() {
		return publicacionPortalInversorVenta;
	}

	public void setPublicacionPortalInversorVenta(Boolean publicacionPortalInversorVenta) {
		this.publicacionPortalInversorVenta = publicacionPortalInversorVenta;
	}

	public Boolean getPublicacionPortalInversorAlquiler() {
		return publicacionPortalInversorAlquiler;
	}

	public void setPublicacionPortalInversorAlquiler(Boolean publicacionPortalInversorAlquiler) {
		this.publicacionPortalInversorAlquiler = publicacionPortalInversorAlquiler;
	}

	public Boolean getPublicacionPortalApiVenta() {
		return publicacionPortalApiVenta;
	}

	public void setPublicacionPortalApiVenta(Boolean publicacionPortalApiVenta) {
		this.publicacionPortalApiVenta = publicacionPortalApiVenta;
	}

	public Boolean getPublicacionPortalApiAlquiler() {
		return publicacionPortalApiAlquiler;
	}

	public void setPublicacionPortalApiAlquiler(Boolean publicacionPortalApiAlquiler) {
		this.publicacionPortalApiAlquiler = publicacionPortalApiAlquiler;
	}

	public DDTipoComercializar getCanalDistribucionVenta() {
		return canalDistribucionVenta;
	}

	public void setCanalDistribucionVenta(DDTipoComercializar canalDistribucionVenta) {
		this.canalDistribucionVenta = canalDistribucionVenta;
	}

	public DDTipoComercializar getCanalDistribucionAlquiler() {
		return canalDistribucionAlquiler;
	}

	public void setCanalDistribucionAlquiler(DDTipoComercializar canalDistribucionAlquiler) {
		this.canalDistribucionAlquiler = canalDistribucionAlquiler;
	}

	public DDSociedadOrigen getSociedadOrigen() {
		return sociedadOrigen;
	}

	public void setSociedadOrigen(DDSociedadOrigen sociedadOrigen) {
		this.sociedadOrigen = sociedadOrigen;
	}

	public DDBancoOrigen getBancoOrigen() {
		return bancoOrigen;
	}

	public void setBancoOrigen(DDBancoOrigen bancoOrigen) {
		this.bancoOrigen = bancoOrigen;
	}

	public DDTributacionPropuestaClienteExentoIva getTributacionPropuestaClienteExentoIva() {
		return tributacionPropuestaClienteExentoIva;
	}

	public void setTributacionPropuestaClienteExentoIva(
			DDTributacionPropuestaClienteExentoIva tributacionPropuestaClienteExentoIva) {
		this.tributacionPropuestaClienteExentoIva = tributacionPropuestaClienteExentoIva;
	}

	public DDTributacionPropuestaVenta getTributacionPropuestaVenta() {
		return tributacionPropuestaVenta;
	}

	public void setTributacionPropuestaVenta(DDTributacionPropuestaVenta tributacionPropuestaVenta) {
		this.tributacionPropuestaVenta = tributacionPropuestaVenta;
	}

	public Boolean getCarteraConcentrada() {
		return carteraConcentrada;
	}

	public void setCarteraConcentrada(Boolean carteraConcentrada) {
		this.carteraConcentrada = carteraConcentrada;
	}

	public Boolean getActivoAAMM() {
		return activoAAMM;
	}

	public void setActivoAAMM(Boolean activoAAMM) {
		this.activoAAMM = activoAAMM;
	}

	public Boolean getActivoPromocionesEstrategicas() {
		return activoPromocionesEstrategicas;
	}

	public void setActivoPromocionesEstrategicas(Boolean activoPromocionesEstrategicas) {
		this.activoPromocionesEstrategicas = activoPromocionesEstrategicas;
	}

	public Date getFechaInicioConcurrencia() {
		return fechaInicioConcurrencia;
	}

	public void setFechaInicioConcurrencia(Date fechaInicioConcurrencia) {
		this.fechaInicioConcurrencia = fechaInicioConcurrencia;
	}

	public Date getFechaFinConcurrencia() {
		return fechaFinConcurrencia;
	}

	public void setFechaFinConcurrencia(Date fechaFinConcurrencia) {
		this.fechaFinConcurrencia = fechaFinConcurrencia;
	}

	public String getMotivosNecesidadArras() {
		return motivosNecesidadArras;
	}

	public void setMotivosNecesidadArras(String motivosNecesidadArras) {
		this.motivosNecesidadArras = motivosNecesidadArras;
	}
	
}

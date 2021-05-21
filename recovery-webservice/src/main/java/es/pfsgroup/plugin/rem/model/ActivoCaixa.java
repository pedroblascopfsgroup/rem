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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComercialAlquilerCaixa;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComercialVentaCaixa;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTecnicoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoNecesidadArras;

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
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MNA_ID")
    private DDMotivoNecesidadArras motivoNecesidadArras;
    
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

	public DDMotivoNecesidadArras getMotivoNecesidadArras() {
		return motivoNecesidadArras;
	}

	public void setMotivoNecesidadArras(DDMotivoNecesidadArras motivoNecesidadArras) {
		this.motivoNecesidadArras = motivoNecesidadArras;
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
	
}

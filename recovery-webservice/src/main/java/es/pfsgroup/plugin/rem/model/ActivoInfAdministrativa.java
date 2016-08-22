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
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;



/**
 * Modelo que gestiona la informacion administrativa de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_ADM_INF_ADMINISTRATIVA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoInfAdministrativa implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ADM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoInfAdministrativaGenerator")
    @SequenceGenerator(name = "ActivoInfAdministrativaGenerator", sequenceName = "S_ACT_ADM_INF_ADMINISTRATIVA")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TVP_ID")
	private DDTipoVpo tipoVpo;
	
	@Column(name = "ADM_SUELO_VPO")
	private Integer sueloVpo;
	
	@Column(name = "ADM_PROMOCION_VPO")
	private Integer promocionVpo;
	
	@Column(name = "ADM_NUM_EXPEDIENTE")
	private String numExpediente;
	
	@Column(name = "ADM_FECHA_CALIFICACION")
	private Date fechaCalificacion;
	
	@Column(name = "ADM_OBLIGATORIO_SOL_DEV_AYUDA")
	private Integer obligatorioSolDevAyuda;
	
	@Column(name = "ADM_OBLIG_AUT_ADM_VENTA")
	private Integer obligatorioAutAdmVenta;
	
	@Column(name = "ADM_DESCALIFICADO")
	private Integer descalificado;
	
	@Column(name = "ADM_MAX_PRECIO_VENTA")
	private Double maxPrecioVenta;
	
	@Column(name = "ADM_OBSERVACIONES")
	private String observaciones;
	
	@Column(name = "ADM_SUJETO_A_EXPEDIENTE")
	private Integer sujetoAExpediente;
	
	@Column(name = "ADM_ORGANISMO_EXPROPIANTE")
	private String organismoExpropiante;
	
	@Column(name = "ADM_FECHA_INI_EXPEDIENTE")
	private Date fechaInicioExpediente;
	
	@Column(name = "ADM_REF_EXPDTE_ADMIN")
	private String refExpedienteAdmin;
	
	@Column(name = "ADM_REF_EXPDTE_INTERNO")
	private String refExpedienteInterno;
	
	@Column(name = "ADM_OBS_EXPROPIACION")
	private String observacionesExpropiacion;
    
    
	
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

	public DDTipoVpo getTipoVpo() {
		return tipoVpo;
	}
	
	public void setTipoVpo(DDTipoVpo tipoVpo) {
		this.tipoVpo = tipoVpo;
	}
	
	public Integer getSueloVpo() {
		return sueloVpo;
	}
	
	public void setSueloVpo(Integer sueloVpo) {
		this.sueloVpo = sueloVpo;
	}
	
	public Integer getPromocionVpo() {
		return promocionVpo;
	}
	
	public void setPromocionVpo(Integer promocionVpo) {
		this.promocionVpo = promocionVpo;
	}
	
	public String getNumExpediente() {
		return numExpediente;
	}
	
	public void setNumExpediente(String numExpediente) {
		this.numExpediente = numExpediente;
	}
	
	public Date getFechaCalificacion() {
		return fechaCalificacion;
	}
	
	public void setFechaCalificacion(Date fechaCalificacion) {
		this.fechaCalificacion = fechaCalificacion;
	}
	
	public Integer getObligatorioSolDevAyuda() {
		return obligatorioSolDevAyuda;
	}
	
	public void setObligatorioSolDevAyuda(Integer obligatorioSolDevAyuda) {
		this.obligatorioSolDevAyuda = obligatorioSolDevAyuda;
	}
	
	public Integer getObligatorioAutAdmVenta() {
		return obligatorioAutAdmVenta;
	}
	
	public void setObligatorioAutAdmVenta(Integer obligatorioAutAdmVenta) {
		this.obligatorioAutAdmVenta = obligatorioAutAdmVenta;
	}
	
	public Integer getDescalificado() {
		return descalificado;
	}
	
	public void setDescalificado(Integer descalificado) {
		this.descalificado = descalificado;
	}
	
	public Double getMaxPrecioVenta() {
		return maxPrecioVenta;
	}
	
	public void setMaxPrecioVenta(Double maxPrecioVenta) {
		this.maxPrecioVenta = maxPrecioVenta;
	}
	
	public String getObservaciones() {
		return observaciones;
	}
	
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	public Integer getSujetoAExpediente() {
		return sujetoAExpediente;
	}

	public void setSujetoAExpediente(Integer sujetoAExpediente) {
		this.sujetoAExpediente = sujetoAExpediente;
	}

	public String getOrganismoExpropiante() {
		return organismoExpropiante;
	}

	public void setOrganismoExpropiante(String organismoExpropiante) {
		this.organismoExpropiante = organismoExpropiante;
	}

	public Date getFechaInicioExpediente() {
		return fechaInicioExpediente;
	}

	public void setFechaInicioExpediente(Date fechaInicioExpediente) {
		this.fechaInicioExpediente = fechaInicioExpediente;
	}

	public String getRefExpedienteAdmin() {
		return refExpedienteAdmin;
	}

	public void setRefExpedienteAdmin(String refExpedienteAdmin) {
		this.refExpedienteAdmin = refExpedienteAdmin;
	}

	public String getRefExpedienteInterno() {
		return refExpedienteInterno;
	}

	public void setRefExpedienteInterno(String refExpedienteInterno) {
		this.refExpedienteInterno = refExpedienteInterno;
	}

	public String getObservacionesExpropiacion() {
		return observacionesExpropiacion;
	}

	public void setObservacionesExpropiacion(String observacionesExpropiacion) {
		this.observacionesExpropiacion = observacionesExpropiacion;
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



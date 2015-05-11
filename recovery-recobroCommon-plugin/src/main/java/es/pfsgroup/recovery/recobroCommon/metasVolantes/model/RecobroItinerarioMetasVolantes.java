package es.pfsgroup.recovery.recobroCommon.metasVolantes.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;

/**
 * Clase que mapea los modelos de facturacion
 * @author Sergio
 *
 */
@Entity
@Table(name = "RCF_ITV_ITI_METAS_VOLANTES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroItinerarioMetasVolantes implements Auditable, Serializable  {
	
	private static final long serialVersionUID = -4807464097772185758L;

	@Id
    @Column(name = "RCF_ITV_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ItinerarioMetasVolantesGenerator")
	@SequenceGenerator(name = "ItinerarioMetasVolantesGenerator", sequenceName = "S_RCF_ITV_ITI_METAS_VOLANTES")
    private Long id;
	
	@Column(name = "RCF_ITV_NOMBRE")
	private String nombre;
	
	@Column(name = "RCF_ITV_FECHA_ALTA")
	private Date fechaAlta;
	
	@Column(name = "RCF_ITV_PLAZO_MAX")
	private Long plazoMaxGestion;
	
	@Column(name = "RCF_ITV_NO_GEST")
	private Long plazoSinGestion;
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_ITV_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<RecobroMetaVolante> metasItinerario;
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_ITV_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<RecobroSubCartera> subCarteras;
	
	@ManyToOne
	@JoinColumn(name = "RCF_DD_ECM_ID")
	private RecobroDDEstadoComponente estado;
	
	@ManyToOne
	@JoinColumn(name = "USU_ID")
	private Usuario propietario;

	@Column(name = "RCF_ITV_PORCENTAJE_CBR_PARCIAl")
	private Float porcentajeCobroParcial;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Long getPlazoMaxGestion() {
		return plazoMaxGestion;
	}

	public void setPlazoMaxGestion(Long plazoMaxGestion) {
		this.plazoMaxGestion = plazoMaxGestion;
	}

	public Long getPlazoSinGestion() {
		return plazoSinGestion;
	}

	public void setPlazoSinGestion(Long plazoSinGestion) {
		this.plazoSinGestion = plazoSinGestion;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public List<RecobroMetaVolante> getMetasItinerario() {
		return metasItinerario;
	}

	public void setMetasItinerario(
			List<RecobroMetaVolante> metasItinerario) {
		this.metasItinerario = metasItinerario;
	}
	
	public List<RecobroSubCartera> getSubCarteras() {
		return subCarteras;
	}

	public void setSubCarteras(List<RecobroSubCartera> subCarteras) {
		this.subCarteras = subCarteras;
	}

	public RecobroDDEstadoComponente getEstado() {
		return estado;
	}

	public void setEstado(RecobroDDEstadoComponente estado) {
		this.estado = estado;
	}

	public Usuario getPropietario() {
		return propietario;
	}

	public void setPropietario(Usuario propietario) {
		this.propietario = propietario;
	}

	public Float getPorcentajeCobroParcial() {
		return porcentajeCobroParcial;
	}

	public void setPorcentajeCobroParcial(Float porcentajeCobroParcial) {
		this.porcentajeCobroParcial = porcentajeCobroParcial;
	}
	
	
}

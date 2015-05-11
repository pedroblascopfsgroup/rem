package es.pfsgroup.recovery.recobroCommon.ranking.model;

import java.io.Serializable;
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
 * Clase que mapea la entidad modelo de ranking
 * @author Sergio
 *
 */
@Entity
@Table(name = "RCF_MOR_MODELO_RANKING", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class RecobroModeloDeRanking  implements Auditable, Serializable {

	private static final long serialVersionUID = -7590165538916230614L;

	@Id
    @Column(name = "RCF_MOR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ModeloRankingGenerator")
	@SequenceGenerator(name = "ModeloRankingGenerator", sequenceName = "S_RCF_MOR_MODELO_RANKING")
    private Long id;
	
    @Column(name = "RCF_MOR_NOMBRE")
    private String nombre;
 
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_MOR_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<RecobroModeloRankingVariable> modeloRankingVariables;
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_MOR_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<RecobroSubCartera> subCarteras;
	
	@ManyToOne
	@JoinColumn(name = "RCF_DD_ECM_ID")
	private RecobroDDEstadoComponente estado;
	
	@ManyToOne
	@JoinColumn(name = "USU_ID")
	private Usuario propietario;


	@Embedded
    private Auditoria auditoria;

	@Version
	private Integer version;
	
	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

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

	public List<RecobroModeloRankingVariable> getModeloRankingVariables() {
		return modeloRankingVariables;
	}

	public void setModeloRankingVariables(List<RecobroModeloRankingVariable> modeloRankingVariables) {
		this.modeloRankingVariables = modeloRankingVariables;
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
	

}

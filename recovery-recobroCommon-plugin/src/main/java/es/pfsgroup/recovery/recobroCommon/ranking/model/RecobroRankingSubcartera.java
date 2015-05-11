package es.pfsgroup.recovery.recobroCommon.ranking.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;

/**
 * Clase que mapea la entidad ranking de subcartera
 * @author Guillem
 *
 */
@Entity
@Table(name = "RAS_RANKING_SUBCARTERA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class RecobroRankingSubcartera  implements Auditable, Serializable {

	private static final long serialVersionUID = -7590165538916230614L;

	@Id
    @Column(name = "RAS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "RankingSubCarteraGenerator")
	@SequenceGenerator(name = "RankingSubCarteraGenerator", sequenceName = "S_RAS_RANKING_SUBCARTERA")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "RCF_SCA_ID", nullable = false)
	private RecobroSubCartera subCartera;
	
	@ManyToOne
	@JoinColumn(name = "RCF_AGE_ID", nullable = false)
	private RecobroAgencia agencia;
	
	@Column(name = "RAS_POSICION")
	private Integer posicion;	
	
	@Column(name = "RAS_PORCENTAJE")
	private Integer porcentaje;

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

	public RecobroSubCartera getSubCartera() {
		return subCartera;
	}

	public void setSubCartera(RecobroSubCartera subCartera) {
		this.subCartera = subCartera;
	}

	public RecobroAgencia getAgencia() {
		return agencia;
	}

	public void setAgencia(RecobroAgencia agencia) {
		this.agencia = agencia;
	}

	public Integer getPosicion() {
		return posicion;
	}

	public void setPosicion(Integer posicion) {
		this.posicion = posicion;
	}

	public Integer getPorcentaje() {
		return porcentaje;
	}

	public void setPorcentaje(Integer porcentaje) {
		this.porcentaje = porcentaje;
	}

}

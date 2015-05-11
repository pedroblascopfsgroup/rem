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

/**
 * Clase que mapea las variables de ranking asociadas al modelo de Ranking
 * @author Sergio
 *
 */
@Entity
@Table(name = "RCF_MRV_MODELO_RANKING_VARS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class RecobroModeloRankingVariable implements Auditable, Serializable  {

	private static final long serialVersionUID = 2775680552446954944L;

	@Id
    @Column(name = "RCF_MRV_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ModeloRankingVariableGenerator")
	@SequenceGenerator(name = "ModeloRankingVariableGenerator", sequenceName = "S_RCF_MRV_MODELO_RANKING_VARS")
    private Long id;
	
    @Column(name = "RCF_MRV_COEFICIENTE")
    private Float coeficiente;
    
	@ManyToOne
	@JoinColumn(name = "RCF_MOR_ID", nullable = false)
	private RecobroModeloDeRanking modeloDeRanking;

	@ManyToOne
	@JoinColumn(name = "RCF_DD_VAR_ID", nullable = false)
	private RecobroDDVariableRanking variableRanking;
	
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

	public RecobroModeloDeRanking getModeloDeRanking() {
		return modeloDeRanking;
	}

	public void setModeloDeRanking(RecobroModeloDeRanking modeloDeRanking) {
		this.modeloDeRanking = modeloDeRanking;
	}

	public RecobroDDVariableRanking getVariableRanking() {
		return variableRanking;
	}

	public void setVariableRanking(RecobroDDVariableRanking variableRanking) {
		this.variableRanking = variableRanking;
	}

	public Float getCoeficiente() {
		return coeficiente;
	}

	public void setCoeficiente(Float coeficiente) {
		this.coeficiente = coeficiente;
	}
	


}

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
 * Clase que mapea la tabla RSD_RANKING_SUBCAR_DETALLE
 * @author javier
 *
 */
@Entity
@Table(name="RSD_RANKING_SUBCAR_DETALLE", schema="${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class RecobroRankingSubcarteraDetalle implements Auditable, Serializable {

	/**
	 * SERIALUID
	 */
	private static final long serialVersionUID = 7123514397582851506L;
	
	@Id
	@Column(name="RSD_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator ="RankingSubcarteraDetalleGenerator")
	@SequenceGenerator(name="RankingSubcarteraDetalleGenerator", sequenceName="S_RSD_RANKING_SUBCAR_DETALLE")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "RCF_SCA_ID", nullable = false)
	private RecobroSubCartera subCartera;
	
	@ManyToOne
	@JoinColumn(name = "RCF_AGE_ID", nullable = false)
	private RecobroAgencia agencia;
	
	@ManyToOne
	@JoinColumn(name ="RCF_DD_VAR_ID", nullable = false)
	private RecobroDDVariableRanking variableRanking;
	
	@Column(name="RSD_PESO", nullable = false)
	private Float peso;
	
	@Column(name="RSD_RESULTADO", nullable = false)
	private Float resultado;
	
	@Column(name="RSD_POSICION", nullable = false)
	private Integer posicion;
	
	@Embedded
	private Auditoria auditoria;
	
	@Version Integer version;

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

	public RecobroDDVariableRanking getVariableRanking() {
		return variableRanking;
	}

	public void setVariableRanking(RecobroDDVariableRanking variableRanking) {
		this.variableRanking = variableRanking;
	}

	public Float getPeso() {
		return peso;
	}

	public void setPeso(Float peso) {
		this.peso = peso;
	}

	public Float getResultado() {
		return resultado;
	}

	public void setResultado(Float resultado) {
		this.resultado = resultado;
	}

	public Integer getPosicion() {
		return posicion;
	}

	public void setPosicion(Integer posicion) {
		this.posicion = posicion;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
	

}

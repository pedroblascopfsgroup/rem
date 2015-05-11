package es.pfsgroup.recovery.recobroCommon.facturacion.model;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que mapea los tramos correctores asociados al modelo de facturación
 * @author Sergio
 *
 */
@Entity
@Table(name = "RCF_COF_CORRECTOR_FACTURA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroCorrectorFacturacion implements Auditable, Serializable  {

	private static final long serialVersionUID = -5890263802940839267L;

	@Id
    @Column(name = "RCF_COF_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ModeloTramoCorrectorGenerator")
	@SequenceGenerator(name = "ModeloTramoCorrectorGenerator", sequenceName = "S_RCF_COF_CORRECTOR_FACTURA")
    private Long id;

	@ManyToOne
	@JoinColumn(name = "RCF_MFA_ID", nullable = true)
	private RecobroModeloFacturacion modeloFacturacion;
	
	@Column(name="RCF_COF_RANKING_POSICION")
	private Integer rankingPosicion;
	
	@Column(name="RCF_COF_OBJETIVO_INICIO")
	private Float objetivoInicio;
	
	@Column(name="RCF_COF_OBJETIVO_FIN")
	private Float objetivoFin;
	
	@Column(name="RCF_COF_COEFICIENTE")
	private Float coeficiente;
		
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public RecobroModeloFacturacion getModeloFacturacion() {
		return modeloFacturacion;
	}

	public void setModeloFacturacion(RecobroModeloFacturacion modeloFacturacion) {
		this.modeloFacturacion = modeloFacturacion;
	}

	public Integer getRankingPosicion() {
		return rankingPosicion;
	}

	public void setRankingPosicion(Integer rankingPosicion) {
		this.rankingPosicion = rankingPosicion;
	}

	public Float getObjetivoInicio() {
		return objetivoInicio;
	}

	public void setObjetivoInicio(Float objetivoInicio) {
		this.objetivoInicio = objetivoInicio;
	}

	public Float getObjetivoFin() {
		return objetivoFin;
	}

	public void setObjetivoFin(Float objetivoFin) {
		this.objetivoFin = objetivoFin;
	}

	public Float getCoeficiente() {
		return coeficiente;
	}

	public void setCoeficiente(Float coeficiente) {
		this.coeficiente = coeficiente;
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

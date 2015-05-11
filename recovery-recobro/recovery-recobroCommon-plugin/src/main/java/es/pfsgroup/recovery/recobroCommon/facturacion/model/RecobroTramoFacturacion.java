package es.pfsgroup.recovery.recobroCommon.facturacion.model;

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

/**
 * Clase que relaciona tramos de facturación para un modelo de facturación
 * @author diana
 *
 */
@Entity
@Table(name = "RCF_TRF_TRAMO_FACTURACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroTramoFacturacion implements Auditable, Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -8619430834740603907L;

	@Id
    @Column(name = "RCF_TRF_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "RecobroTramoFacturacionGenerator")
	@SequenceGenerator(name = "RecobroTramoFacturacionGenerator", sequenceName = "S_RCF_TRF_TRAMO_FACTURACION")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "RCF_MFA_ID", nullable = false)
	private RecobroModeloFacturacion modeloFacturacion; 
	
	@Column(name = "RCF_TRF_DIAS")
	private Integer tramoDias; 
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_TRF_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<RecobroTarifaCobroTramo> tarifasCobrosTramos;
	
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

	public Integer getTramoDias() {
		return tramoDias;
	}

	public void setTramoDias(Integer tramoDias) {
		this.tramoDias = tramoDias;
	}

	public List<RecobroTarifaCobroTramo> getTarifasCobrosTramos() {
		return tarifasCobrosTramos;
	}

	public void setTarifasCobrosTramos(
			List<RecobroTarifaCobroTramo> tarifasCobrosTramos) {
		this.tarifasCobrosTramos = tarifasCobrosTramos;
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

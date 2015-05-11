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
import es.capgemini.pfs.cobropago.model.DDSubtipoCobroPago;

/**
 * Clase que relaciona tipos de cobros asociados a un modelo de facturacion
 * @author diana
 *
 */
@Entity
@Table(name = "RCF_TCF_TIPO_COBRO_FACTURA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class RecobroCobroFacturacion implements Auditable, Serializable{
	
	private static final long serialVersionUID = 7480324749754408586L;

	@Id
    @Column(name = "RCF_TCF_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "RecobroCobroFacturacionGenerator")
	@SequenceGenerator(name = "RecobroCobroFacturacionGenerator", sequenceName = "S_RCF_TCF_TIPO_COBRO_FACTURA")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "RCF_MFA_ID", nullable = false)
	private RecobroModeloFacturacion modeloFacturacion;
	
	@ManyToOne
	@JoinColumn(name = "DD_SCP_ID", nullable = false)
	private DDSubtipoCobroPago tipoCobro;
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_TCF_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<RecobroTarifaCobro> tarifasCobro ; 
	
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

	public DDSubtipoCobroPago getTipoCobro() {
		return tipoCobro;
	}

	public void setTipoCobro(DDSubtipoCobroPago tipoCobro) {
		this.tipoCobro = tipoCobro;
	}

	public List<RecobroTarifaCobro> getTarifasCobro() {
		return tarifasCobro;
	}

	public void setTarifasCobro(List<RecobroTarifaCobro> tarifasCobro) {
		this.tarifasCobro = tarifasCobro;
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

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
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que relaciona cada cobro de un modelo con cada tarifa existente
 * @author diana
 *
 */
@Entity
@Table(name = "RCF_TCC_TARIFAS_CONCEP_COBRO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroTarifaCobro implements Auditable, Serializable{
	
	private static final long serialVersionUID = -5989870554088906198L;

	@Id
    @Column(name = "RCF_TCC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "RecobroTarifaCobroGenerator")
	@SequenceGenerator(name = "RecobroTarifaCobroGenerator", sequenceName = "S_RCF_TCC_TARIFAS_CONCEP_COB")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "RCF_TCF_ID", nullable = false)
	private RecobroCobroFacturacion cobroFacturacion;
	
	@ManyToOne
	@JoinColumn(name = "RCF_DD_COC_ID", nullable = false)
	private RecobroDDConceptoCobro tipoTarifa; 
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_TCC_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	@OrderBy("tramoFacturacion ASC")
	private List<RecobroTarifaCobroTramo> tarifasCobrosTramos;
	
	@Column(name = "RCF_TCC_MIN")
	private Float minimo; 
	
	@Column(name = "RCF_TCC_MAX")
	private Float maximo;
	
	@Column(name = "RCF_TCC_PORCENTAJE_DEFECTO")
	private Float porcentajePorDefecto;
	
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

	public RecobroCobroFacturacion getCobroFacturacion() {
		return cobroFacturacion;
	}

	public void setCobroFacturacion(RecobroCobroFacturacion cobroFacturacion) {
		this.cobroFacturacion = cobroFacturacion;
	}

	public RecobroDDConceptoCobro getTipoTarifa() {
		return tipoTarifa;
	}

	public void setTipoTarifa(RecobroDDConceptoCobro tipoTarifa) {
		this.tipoTarifa = tipoTarifa;
	}

	public List<RecobroTarifaCobroTramo> getTarifasCobrosTramos() {
		return tarifasCobrosTramos;
	}

	public void setTarifasCobrosTramos(
			List<RecobroTarifaCobroTramo> tarifasCobrosTramos) {
		this.tarifasCobrosTramos = tarifasCobrosTramos;
	}

	public Float getMinimo() {
		return minimo;
	}

	public void setMinimo(Float minimo) {
		this.minimo = minimo;
	}

	public Float getMaximo() {
		return maximo;
	}

	public void setMaximo(Float maximo) {
		this.maximo = maximo;
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

	public Float getPorcentajePorDefecto() {
		return porcentajePorDefecto;
	}

	public void setPorcentajePorDefecto(Float porcentajePorDefecto) {
		this.porcentajePorDefecto = porcentajePorDefecto;
	}
		
}

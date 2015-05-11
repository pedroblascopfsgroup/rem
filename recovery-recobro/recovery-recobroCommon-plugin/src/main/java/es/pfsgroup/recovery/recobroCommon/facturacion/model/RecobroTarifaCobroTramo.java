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
 * Clase que relaciona los cobros y tarifas de un modelo de facturación para todos los tramos definidos
 * en el modelo
 * @author diana
 *
 */
@Entity
@Table(name = "RCF_TCT_TARIF_COBRO_TRAMO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroTarifaCobroTramo implements Auditable, Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4388037088192291616L;

	@Id
    @Column(name = "RCF_TCT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "RecobroTarifaCobroTramoGenerator")
	@SequenceGenerator(name = "RecobroTarifaCobroTramoGenerator", sequenceName = "S_RCF_TCT_TARIF_COBRO_TRAMO")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "RCF_TCC_ID", nullable = false)
	private RecobroTarifaCobro tarifaCobro; 
	
	@ManyToOne
	@JoinColumn(name = "RCF_TRF_ID", nullable = false)
	private RecobroTramoFacturacion tramoFacturacion; 
	
	@Column(name = "RCF_TCT_PORCENTAJE")
	private Float porcentaje;
	
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

	public RecobroTarifaCobro getTarifaCobro() {
		return tarifaCobro;
	}

	public void setTarifaCobro(RecobroTarifaCobro tarifaCobro) {
		this.tarifaCobro = tarifaCobro;
	}

	public RecobroTramoFacturacion getTramoFacturacion() {
		return tramoFacturacion;
	}

	public void setTramoFacturacion(RecobroTramoFacturacion tramoFacturacion) {
		this.tramoFacturacion = tramoFacturacion;
	}

	public Float getPorcentaje() {
		return porcentaje;
	}

	public void setPorcentaje(Float porcentaje) {
		this.porcentaje = porcentaje;
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

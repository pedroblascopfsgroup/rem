package es.pfsgroup.recovery.recobroCommon.esquema.model;

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
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;


/**
 * Clase que representa la relación entre carteras y esquemas
 *
 * @author Vanesa
 * 
 */
@Entity
@Table(name = "RCF_ESC_ESQUEMA_CARTERAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroCarteraEsquema implements Auditable, Serializable{
	
	private static final long serialVersionUID = -1934773194960249533L;

	 @Id
	 @Column(name = "RCF_ESC_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "CarterasEsquemaGenerator")
	 @SequenceGenerator(name = "CarterasEsquemaGenerator", sequenceName = "S_RCF_ESC_ESQUEMA_CARTERAS")
	 private Long id;
	 
	 @ManyToOne
	 @JoinColumn(name = "RCF_ESQ_ID", nullable = false)
	 @Where(clause=Auditoria.UNDELETED_RESTICTION)
	 private RecobroEsquema esquema;
	 
	 @ManyToOne
	 @JoinColumn(name = "RCF_CAR_ID", nullable = false)
	 @Where(clause=Auditoria.UNDELETED_RESTICTION)
	 private RecobroCartera cartera;	 

	 @ManyToOne
	 @JoinColumn(name = "DD_TCE_ID", nullable = true)
	 private RecobroDDTipoCarteraEsquema tipoCarteraEsquema;
	 
	 @Column(name = "RCF_ESC_PRIORIDAD")
	 private Integer prioridad;

	 @ManyToOne
	 @JoinColumn(name = "DD_TGC_ID", nullable = true)
	 private RecobroDDTipoGestionCartera tipoGestionCarteraEsquema;

	 @ManyToOne
	 @JoinColumn(name = "DD_AER_ID", nullable = true)
	 private RecobroDDAmbitoExpedienteRecobro ambitoExpedienteRecobro;
	
	 @OneToMany(cascade = CascadeType.ALL)
	 @JoinColumn(name="RCF_ESC_ID")
	 @Where(clause=Auditoria.UNDELETED_RESTICTION)
	 private List<RecobroSubCartera> subcarteras;
		
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
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public RecobroEsquema getEsquema() {
		return esquema;
	}

	public void setEsquema(RecobroEsquema esquema) {
		this.esquema = esquema;
	}

	public RecobroCartera getCartera() {
		return cartera;
	}

	public void setCartera(RecobroCartera cartera) {
		this.cartera = cartera;
	}

	public RecobroDDTipoCarteraEsquema getTipoCarteraEsquema() {
		return tipoCarteraEsquema;
	}

	public void setTipoCarteraEsquema(RecobroDDTipoCarteraEsquema tipoCarteraEsquema) {
		this.tipoCarteraEsquema = tipoCarteraEsquema;
	}

	public Integer getPrioridad() {
		return prioridad;
	}

	public void setPrioridad(Integer prioridad) {
		this.prioridad = prioridad;
	}

	public RecobroDDTipoGestionCartera getTipoGestionCarteraEsquema() {
		return tipoGestionCarteraEsquema;
	}

	public void setTipoGestionCarteraEsquema(
			RecobroDDTipoGestionCartera tipoGestionCarteraEsquema) {
		this.tipoGestionCarteraEsquema = tipoGestionCarteraEsquema;
	}

	public RecobroDDAmbitoExpedienteRecobro getAmbitoExpedienteRecobro() {
		return ambitoExpedienteRecobro;
	}

	public void setAmbitoExpedienteRecobro(
			RecobroDDAmbitoExpedienteRecobro ambitoExpedienteRecobro) {
		this.ambitoExpedienteRecobro = ambitoExpedienteRecobro;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public List<RecobroSubCartera> getSubcarteras() {
		return subcarteras;
	}

	public void setSubcarteras(List<RecobroSubCartera> subcarteras) {
		this.subcarteras = subcarteras;
	}


}

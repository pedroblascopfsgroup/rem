package es.pfsgroup.recovery.recobroCommon.persona.model;

import java.io.Serializable;
import java.util.Date;

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
import es.capgemini.pfs.exceptuar.model.Exceptuacion;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.recovery.recobroCommon.expediente.model.CicloRecobroExpediente;
import es.pfsgroup.recovery.recobroCommon.motivos.model.DDMotivoBaja;

/**
 * 
 * @author diana
 *
 */
@Entity
@Table(name = "CRP_CICLO_RECOBRO_PER", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class CicloRecobroPersona implements Serializable, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -3787855597763239324L;

	@Id
	@Column(name = "CRP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "CicloRecobroPersonaGenerator")
	@SequenceGenerator(name = "CicloRecobroPersonaGenerator", sequenceName = "S_CRP_CICLO_RECOBRO_PER")
	private Long id;
	
	@ManyToOne
    @JoinColumn(name = "PER_ID")
	private Persona persona;
	
	@ManyToOne
    @JoinColumn(name = "CRE_ID")
	private CicloRecobroExpediente cicloRecobroExpediente;
	
	@ManyToOne
    @JoinColumn(name = "DD_MOB_ID")
	private DDMotivoBaja motivoBaja;
	
	@ManyToOne
	@JoinColumn(name="EXC_ID")
	private Exceptuacion exceptuacion;
	
	@Column(name = "CRP_FECHA_ALTA")
	private Date fechaAlta;

	@Column(name = "CRP_FECHA_BAJA")
	private Date fechaBaja;

	@Column(name = "CRP_RIESGO_DIRECTO")
	private Float posVivaNoVencida;

	@Column(name = "CRP_RIESGO_INDIRECTO")
	private Float posVivaVencida;
	
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

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

	public CicloRecobroExpediente getCicloRecobroExpediente() {
		return cicloRecobroExpediente;
	}

	public void setCicloRecobroExpediente(
			CicloRecobroExpediente cicloRecobroExpediente) {
		this.cicloRecobroExpediente = cicloRecobroExpediente;
	}

	public DDMotivoBaja getMotivoBaja() {
		return motivoBaja;
	}

	public void setMotivoBaja(DDMotivoBaja motivoBaja) {
		this.motivoBaja = motivoBaja;
	}

	public Exceptuacion getExceptuacion() {
		return exceptuacion;
	}

	public void setExceptuacion(Exceptuacion exceptuacion) {
		this.exceptuacion = exceptuacion;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Date getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public Float getPosVivaNoVencida() {
		return posVivaNoVencida;
	}

	public void setPosVivaNoVencida(Float posVivaNoVencida) {
		this.posVivaNoVencida = posVivaNoVencida;
	}

	public Float getPosVivaVencida() {
		return posVivaVencida;
	}

	public void setPosVivaVencida(Float posVivaVencida) {
		this.posVivaVencida = posVivaVencida;
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

package es.capgemini.pfs.contrato.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.PersonaManual;

public class ContratoPersonaManual implements Serializable, Auditable {

	private static final long serialVersionUID = 8785355961412808132L;
	
	@Id
	@Column(name="CPM_ID")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name="PEM_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private PersonaManual personaManual;
	
	@ManyToOne
	@JoinColumn(name="CNT_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Contrato contrato;
	
	@OneToOne
	@JoinColumn(name="DD_TIN_ID")
	private DDTipoIntervencion tipoIntervencion;
	
	@Column(name="CPM_ORDEN")
	private Long orden;
	
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

	public PersonaManual getPersonaManual() {
		return personaManual;
	}

	public void setPersonaManual(PersonaManual personaManual) {
		this.personaManual = personaManual;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public DDTipoIntervencion getTipoIntervencion() {
		return tipoIntervencion;
	}

	public void setTipoIntervencion(DDTipoIntervencion tipoIntervencion) {
		this.tipoIntervencion = tipoIntervencion;
	}

	public Long getOrden() {
		return orden;
	}

	public void setOrden(Long orden) {
		this.orden = orden;
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

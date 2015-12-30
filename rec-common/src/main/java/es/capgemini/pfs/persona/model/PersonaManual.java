package es.capgemini.pfs.persona.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.ContratoPersonaManual;

@Entity
@Table(name="PEM_PERSONAS_MANUALES", schema="${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class PersonaManual implements Serializable, Auditable {

	private static final long serialVersionUID = 3627456077315788460L;

	@Id
	@Column(name="PEM_ID")
	private Long id;
	
	
	@OneToMany(mappedBy = "personaManual", fetch = FetchType.LAZY)
	@JoinColumn(name="PEM_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<ContratoPersonaManual> contratosPersonaManual;
	
	@Column(name="PEM_DOC_ID")
	private String docId;
	
	@Column(name="PEM_NOMBRE")
	private String nombre;
	
	@Column(name="PEM_APELLIDO1")
	private String apellido1;
	
	@Column(name="PEM_APELLIDO2")
	private String apellido2;
	
	@Column(name="PEM_NOM50")
	private String nom50;
	
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

	public List<ContratoPersonaManual> getContratosPersonaManual() {
		return contratosPersonaManual;
	}

	public void setContratosPersonaManual(
			List<ContratoPersonaManual> contratosPersonaManual) {
		this.contratosPersonaManual = contratosPersonaManual;
	}

	public String getDocId() {
		return docId;
	}

	public void setDocId(String docId) {
		this.docId = docId;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getApellido1() {
		return apellido1;
	}

	public void setApellido1(String apellido1) {
		this.apellido1 = apellido1;
	}

	public String getApellido2() {
		return apellido2;
	}

	public void setApellido2(String apellido2) {
		this.apellido2 = apellido2;
	}

	public String getNom50() {
		return nom50;
	}

	public void setNom50(String nom50) {
		this.nom50 = nom50;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
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

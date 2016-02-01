package es.capgemini.pfs.telefonos.model;

import java.io.Serializable;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.DDOrigenTelefono;
import es.capgemini.pfs.persona.model.DDTipoTelefono;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.persona.model.PersonasTelefono;

@Entity
@Table(name = "TEL_TELEFONOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class Telefono implements Serializable, Auditable{
	
	
	 /**
	 * 
	 */
	private static final long serialVersionUID = -5515137427647537760L;

	@Id
	 @Column(name = "TEL_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "TelefonoGenerator")
	 @SequenceGenerator(name = "TelefonoGenerator", sequenceName = "S_TEL_TELEFONOS")
	  private Long id;
	  
	  @Column(name="TEL_PRIORIDAD")
	  private Integer prioridad;
	  
	  @Column(name="TEL_TELEFONO")
	  private String telefono;
	  
	  @Column(name="TEL_CONSENTIMIENTO")
	  private Boolean consentimiento;
	  
	  @OneToOne
	  @JoinColumn(name="DD_OTE_ID")
	  private DDOrigenTelefono origenTelefono;
	  
	  @OneToOne
	  @JoinColumn(name="DD_TTE_ID")
	  private DDTipoTelefono tipoTelefono;
	  
	  @OneToOne
	  @JoinColumn(name="DD_MTE_ID")
	  private DDMotivoTelefono motivoTelefono;
	  
	  @OneToOne
	  @JoinColumn(name="DD_ETE_ID")
	  private DDEstadoTelefono estadoTelefono;
	  
	  @OneToMany(fetch = FetchType.LAZY)
	  @JoinColumn(name = "TEL_ID")
	  @Where(clause = Auditoria.UNDELETED_RESTICTION)
	  private List<PersonasTelefono> personasTelefono;
	  
	  @Column(name="TEL_OBSERVACIONES")
	  private String observaciones;
	  
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

	public Integer getPrioridad() {
		return prioridad;
	}

	public void setPrioridad(Integer prioridad) {
		this.prioridad = prioridad;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public Boolean getConsentimiento() {
		return consentimiento;
	}

	public void setConsentimiento(Boolean consentimiento) {
		this.consentimiento = consentimiento;
	}

	public DDOrigenTelefono getOrigenTelefono() {
		return origenTelefono;
	}

	public void setOrigenTelefono(DDOrigenTelefono origenTelefono) {
		this.origenTelefono = origenTelefono;
	}

	public DDTipoTelefono getTipoTelefono() {
		return tipoTelefono;
	}

	public void setTipoTelefono(DDTipoTelefono tipoTelefono) {
		this.tipoTelefono = tipoTelefono;
	}

	public DDMotivoTelefono getMotivoTelefono() {
		return motivoTelefono;
	}

	public void setMotivoTelefono(DDMotivoTelefono motivoTelefono) {
		this.motivoTelefono = motivoTelefono;
	}

	public DDEstadoTelefono getEstadoTelefono() {
		return estadoTelefono;
	}

	public void setEstadoTelefono(DDEstadoTelefono estadoTelefono) {
		this.estadoTelefono = estadoTelefono;
	}

	/**
     * @return personas
     */
	
	public Set<Persona> getPersonas() {
		Set<Persona> personas = new HashSet<Persona>();

		for (PersonasTelefono pt : personasTelefono) {
			personas.add(pt.getPersona());
		}

		return personas;
	}
	
	public List<PersonasTelefono> getPersonasTelefono() {
		return personasTelefono;
	}

	public void setPersonasTelefono(List<PersonasTelefono> personasTelefono) {
		this.personasTelefono = personasTelefono;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
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

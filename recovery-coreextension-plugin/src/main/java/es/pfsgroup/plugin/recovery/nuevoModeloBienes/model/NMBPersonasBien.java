package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBPersonasBienInfo;

@Entity
@Table(name = "BIE_PER", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class NMBPersonasBien implements  Serializable, Auditable, NMBPersonasBienInfo{

	
	private static final long serialVersionUID = 4504581888930635297L;

    @Id
    @Column(name = "BIE_PER_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "NMBPersonasBienGenerator")
    @SequenceGenerator(name = "NMBPersonasBienGenerator", sequenceName = "S_BIE_PER")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "BIE_ID")
	private NMBBien bien;
	
	@ManyToOne
    @JoinColumn(name = "PER_ID")
	private Persona persona;
	
	@Column(name = "BIE_PER_PARTICIPACION")
    private Float participacion;

	@Embedded
    private Auditoria auditoria;
	
	@Version
	private Integer version;
	 
	/**
     * Setea el estado de borrado de la relación.
     * @param borrado Si la tarea estÃ¡ o no borrada
     */
    public void setBorrado(Boolean borrado) {
        auditoria.setBorrado(borrado);
    }
    
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public NMBBien getBien() {
		return bien;
	}

	public void setBien(NMBBien bien) {
		this.bien = bien;
	}

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

	public Float getParticipacion() {
		return participacion;
	}

	public void setParticipacion(Float participacion) {
		this.participacion = participacion;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}

}

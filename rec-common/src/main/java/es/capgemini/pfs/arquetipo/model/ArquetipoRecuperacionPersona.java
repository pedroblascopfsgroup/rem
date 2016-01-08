package es.capgemini.pfs.arquetipo.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;

@Entity
@Table(name = "ARR_ARQ_RECUPERACION_PERSONA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ArquetipoRecuperacionPersona implements Serializable,Auditable{
	

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name="ARR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ArrGenerator")
    @SequenceGenerator(name = "ArrGenerator", sequenceName = "S_ARR_ARQ_RECUPERACION_PERSONA")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name="PER_ID")
	private Persona persona;
	
	@ManyToOne
	@JoinColumn(name="ARQ_ID")
	private Arquetipo arquetipo;
	
	@Column(name="ARQ_NAME")
	private String arquetipoNombre;
	
	@Column(name="ARQ_PRIO")
	private Long arquetipoPrioridad;
	
	@Column(name="ARQ_DATE")
	private Date arquetipoFecha;
	
	@Version
    private Integer version;
	
	@Embedded
	private Auditoria auditoria;

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

	public Arquetipo getArquetipo() {
		return arquetipo;
	}

	public void setArquetipo(Arquetipo arquetipo) {
		this.arquetipo = arquetipo;
	}

	public String getArquetipoNombre() {
		return arquetipoNombre;
	}

	public void setArquetipoNombre(String arquetipoNombre) {
		this.arquetipoNombre = arquetipoNombre;
	}

	public Long getArquetipoPrioridad() {
		return arquetipoPrioridad;
	}

	public void setArquetipoPrioridad(Long arquetipoPrioridad) {
		this.arquetipoPrioridad = arquetipoPrioridad;
	}

	public Date getArquetipoFecha() {
		return arquetipoFecha;
	}

	public void setArquetipoFecha(Date arquetipoFecha) {
		this.arquetipoFecha = arquetipoFecha;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}

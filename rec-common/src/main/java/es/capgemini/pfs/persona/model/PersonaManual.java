package es.capgemini.pfs.persona.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
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
import es.capgemini.pfs.contrato.model.ContratoPersonaManual;
import es.capgemini.pfs.direccion.model.Direccion;

@Entity
@Table(name="PEM_PERSONAS_MANUALES", schema="${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class PersonaManual implements Serializable, Auditable {

	private static final long serialVersionUID = 3627456077315788460L;

	@Id
	@Column(name="PEM_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "PersonaManualGenerator")
	@SequenceGenerator(name = "PersonaManualGenerator", sequenceName = "S_PEM_PERSONAS_MANUALES")
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
	
	@OneToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "DD_PRO_ID")
	private DDPropietario propietario;

	@Column(name="PER_COD_CLIENTE_ENTIDAD")
	private Long codClienteEntidad;
	
	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "DIR_PEM", joinColumns = { @JoinColumn(name = "PEM_ID", unique = true) }, inverseJoinColumns = { @JoinColumn(name = "DIR_ID") })
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<Direccion> direcciones;

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
	
	public DDPropietario getPropietario() {
		return propietario;
	}

	public void setPropietario(DDPropietario propietario) {
		this.propietario = propietario;
	}

	public Long getCodClienteEntidad() {
		return codClienteEntidad;
	}

	public void setCodClienteEntidad(Long codClienteEntidad) {
		this.codClienteEntidad = codClienteEntidad;
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
	
	public List<Direccion> getDirecciones() {
		return direcciones;
	}

	public void setDirecciones(List<Direccion> direcciones) {
		this.direcciones = direcciones;
	}
	
	/**
	 * obtiene el apellido y el nombre.
	 * 
	 * @return apellido nombre
	 */
	public String getApellidoNombre() {
		String r = "";
		if (apellido1 != null && apellido1.trim().length() > 0) {
			r += apellido1.trim() + " ";
		}
		if (apellido2 != null && apellido2.trim().length() > 0) {
			r += apellido2.trim();
		}
		if (r.trim().length() > 0) {
			r += ", ";
		}
		if (nombre != null && nombre.trim().length() > 0) {
			r += nombre.trim();
		}
		return r;
	}

}

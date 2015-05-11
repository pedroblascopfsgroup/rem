package es.capgemini.pfs.persona.model;

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
import es.capgemini.pfs.cliente.model.Cliente;

@Entity
@Table(name = "EXT_ICC_INFO_EXTRA_CLI", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class InfoExtraCliente implements Auditable, Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 7220570877331584075L;

	@Id
	@Column(name = "ICC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "InfoExtraClienteGenerator")
	@SequenceGenerator(name = "InfoExtraClienteGenerator", sequenceName = "S_EXT_ICC_INFO_EXTRA_CLI")
	private Long id;
	
	@ManyToOne
    @JoinColumn(name = "DD_IFX_ID")
	private DDTipoInfoCliente tipoInfoCliente;
	
	@ManyToOne
    @JoinColumn(name = "PER_ID")
	private Persona persona;
	
	@Column(name="ICC_VALUE")
	private String value;
	
	@ManyToOne
    @JoinColumn(name = "CLI_ID")
	private Cliente cliente;
	
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

	public DDTipoInfoCliente getTipoInfoCliente() {
		return tipoInfoCliente;
	}

	public void setTipoInfoCliente(DDTipoInfoCliente tipoInfoCliente) {
		this.tipoInfoCliente = tipoInfoCliente;
	}

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public Cliente getCliente() {
		return cliente;
	}

	public void setCliente(Cliente cliente) {
		this.cliente = cliente;
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

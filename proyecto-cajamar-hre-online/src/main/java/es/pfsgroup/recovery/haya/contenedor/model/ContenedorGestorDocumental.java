package es.pfsgroup.recovery.haya.contenedor.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.persona.model.Persona;

@Entity
@Table(name = "CGD_CONTENEDOR_GESTOR_DOC", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ContenedorGestorDocumental implements Serializable, Auditable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "CGD_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ContenedorGestorDocumentalGenerator")
	@SequenceGenerator(name = "ContenedorGestorDocumentalGenerator", sequenceName = "S_CGD_CONTENEDOR_GESTOR_DOC")
	private Long id;
	
	@OneToOne
    @JoinColumn(name = "ASU_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Asunto asunto;
	
	@OneToOne
    @JoinColumn(name = "CNT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Contrato contrato;
	
	@OneToOne
    @JoinColumn(name = "PER_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Persona persona;
	
	@Column(name ="CGD_CODIGO_TIPO")
	private String codigoTipo;
	
	@Column(name ="CGD_CLASE_EXP")
	private String codigoClase;
	
	@Column(name ="CGD_ID_EXTERNO")
	private Long idExterno;
	
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

	public Asunto getAsunto() {
		return asunto;
	}

	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

	public String getCodigoTipo() {
		return codigoTipo;
	}

	public void setCodigoTipo(String codigoTipo) {
		this.codigoTipo = codigoTipo;
	}

	public String getCodigoClase() {
		return codigoClase;
	}

	public void setCodigoClase(String codigoClase) {
		this.codigoClase = codigoClase;
	}

	public Long getIdExterno() {
		return idExterno;
	}

	public void setIdExterno(Long idExterno) {
		this.idExterno = idExterno;
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

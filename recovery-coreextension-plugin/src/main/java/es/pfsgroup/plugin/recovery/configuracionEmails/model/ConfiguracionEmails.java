/**
 *	Clase que representa la configuración de un email
 * 
 * @author Alberto Campos
 * 
 */
 package es.pfsgroup.plugin.recovery.configuracionEmails.model;
 

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
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;

@Entity
@Table(name = "PCE_CONFIGURACION_EMAILS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ConfiguracionEmails implements Serializable, Auditable  {

	private static final long serialVersionUID = 0L;

    @Id
    @Column(name = "PCE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfiguracionEmailGenerator")
    @SequenceGenerator(name = "ConfiguracionEmailGenerator", sequenceName = "S_PCE_CONFIGURACION_EMAILS")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "TAP_ID")
    private TareaProcedimiento tareaProcedimiento;

    @Column(name = "PCE_DESTINATARIOS")
    private String destinatarios;

    @Column(name = "PCE_SUBJECT")
    private String subject;

    @Column(name = "PCE_CUERPO")
    private String cuerpo;

    @Column(name = "PCE_TFA_LIST")
    private String documentosAdjuntos;

    @Version
    private Integer version;

    /**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the tareaProcedimiento
	 */
	public TareaProcedimiento getTareaProcedimiento() {
		return tareaProcedimiento;
	}

	/**
	 * @param tareaProcedimiento the tareaProcedimiento to set
	 */
	public void setTareaProcedimiento(TareaProcedimiento tareaProcedimiento) {
		this.tareaProcedimiento = tareaProcedimiento;
	}

	/**
	 * @return the destinatarios
	 */
	public String getDestinatarios() {
		return destinatarios;
	}

	/**
	 * @param destinatarios the destinatarios to set
	 */
	public void setDestinatarios(String destinatarios) {
		this.destinatarios = destinatarios;
	}

	/**
	 * @return the subject
	 */
	public String getSubject() {
		return subject;
	}

	/**
	 * @param subject the subject to set
	 */
	public void setSubject(String subject) {
		this.subject = subject;
	}

	/**
	 * @return the cuerpo
	 */
	public String getCuerpo() {
		return cuerpo;
	}

	/**
	 * @param cuerpo the cuerpo to set
	 */
	public void setCuerpo(String cuerpo) {
		this.cuerpo = cuerpo;
	}

	/**
	 * @return the documentosAdjuntos
	 */
	public String getDocumentosAdjuntos() {
		return documentosAdjuntos;
	}

	/**
	 * @param documentosAdjuntos the documentosAdjuntos to set
	 */
	public void setDocumentosAdjuntos(String documentosAdjuntos) {
		this.documentosAdjuntos = documentosAdjuntos;
	}

	/**
	 * @return the version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * @param version the version to set
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}
    
    @Embedded
    private Auditoria auditoria;

	@Override
	public Auditoria getAuditoria() {
		return this.auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;		
	}	
}

package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


/**
 * Modelo que gestiona la tabla Auxiliar Envio de Cierre Oficinas Bankia 
 * 
 * @author Sergio Gomez
 */

@Entity
@Table(name = "ENVIO_CIERRE_OFICINAS_BANKIA", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class EnvioCierreOficinasBankia implements Serializable, Auditable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "ENVIO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EnvioCierreOficinasBankiaGenerator")
    @SequenceGenerator(name = "EnvioCierreOficinasBankiaGenerator", sequenceName = "S_ENVIO_CIERRE_OFICINAS_BANKIA")
	private Long id;
	
	
    @Column(name = "ECO_ID")    
	private Long idExpediente;
	
	
    @Column(name = "OFICINA_ANTERIOR")
	private String oficinaAnterior;
    
    @Column(name = "ENVIADO")
	private Boolean enviado;
    
    @Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public String getOficinaAnterior() {
		return oficinaAnterior;
	}

	public void setOficinaAnterior(String oficinaAnterior) {
		this.oficinaAnterior = oficinaAnterior;
	}

	public Boolean getEnviado() {
		return enviado;
	}

	public void setEnviado(Boolean enviado) {
		this.enviado = enviado;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	
	
	
	
	

}

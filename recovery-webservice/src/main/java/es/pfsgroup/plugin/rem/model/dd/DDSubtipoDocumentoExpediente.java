package es.pfsgroup.plugin.rem.model.dd;

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
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de los subtipos de documentos adjuntados al expediente comercial
 * @author jros
 *
 */
@Entity
@Table(name = "DD_SDE_SUBTIPO_DOC_EXP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubtipoDocumentoExpediente implements Auditable, Dictionary {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 5218121084059952387L;

	@Id
	@Column(name = "DD_SDE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubtipoDocumentoExpedienteGenerator")
	@SequenceGenerator(name = "DDSubtipoDocumentoExpedienteGenerator", sequenceName = "S_DD_SDE_SUBTIPO_DOC_EXP")
	private Long id;
	
	@ManyToOne
    @JoinColumn(name = "DD_TDE_ID")
    private DDTipoDocumentoExpediente tipoDocumentoExpediente; 
	 
	@Column(name = "DD_SDE_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SDE_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SDE_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;
	
	@Transient
	private String codigoTipoDocExpediente;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDTipoDocumentoExpediente getTipoDocumentoExpediente() {
		return tipoDocumentoExpediente;
	}

	public void setTipoDocumentoExpediente(
			DDTipoDocumentoExpediente tipoDocumentoExpediente) {
		this.tipoDocumentoExpediente = tipoDocumentoExpediente;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
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
	
	public String getCodigoTipoDocExpediente() {
		return tipoDocumentoExpediente.getCodigo();
	}
	
	public void setCodigoTipoDocExpediente(String codigoTipoDocExpediente) {
		this.codigoTipoDocExpediente = tipoDocumentoExpediente.getCodigo();
	}
	

}

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de tipos de documentos adjuntos de un tributo
 * 
 * @author Lara Pablo
 *
 */
@Entity
@Table(name = "DD_TDT_TIPO_DOC_TRIBUTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoDocumentoTributos implements Auditable, Dictionary {
	

	
	private static final long serialVersionUID = 1L;	

	@Id
	@Column(name = "DD_TDT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoDocumentoTributosGenerator")
	@SequenceGenerator(name = "DDTipoDocumentoTributosGenerator", sequenceName = "S_DD_TDT_TIPO_DOC_TRIBUTOS")
	private Long id;
	
	@Column(name = "DD_TDT_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TDT_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TDT_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "DD_TDT_MATRICULA_GD")   
	private String matricula;
	
	@Column(name = "DD_TDT_VINCULABLE")
	private Boolean vinculable;
	
	@ManyToOne
    @JoinColumn(name = "DD_TDT_TPD_ID")
	private DDTipoDocumentoActivo tipoDocumentoActivo;
	        
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

	public String getMatricula() {
		return matricula;
	}

	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}

	public Boolean getVinculable() {
		return vinculable;
	}

	public void setVinculable(Boolean vinculable) {
		this.vinculable = vinculable;
	}

	public DDTipoDocumentoActivo getTipoDocumentoActivo() {
		return tipoDocumentoActivo;
	}

	public void setTipoDocumentoActivo(DDTipoDocumentoActivo tipoDocumentoActivo) {
		this.tipoDocumentoActivo = tipoDocumentoActivo;
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

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
 * Modelo que gestiona el Tipo de Documento de la  entodad
 */
@Entity
@Table(name = "DD_TDO_TIPO_DOC_ENTIDAD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoDocumentoEntidad implements Auditable, Dictionary{
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "DD_TDO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoDocumentoEntidadGenerator")
	@SequenceGenerator(name = "DDTipoDocumentoEntidadGenerator", sequenceName = "S_DD_TDO_TIPO_DOC_ENTIDAD")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "DD_TED_ID")
	private DDTipoEntidadDocumental tipoEntidadDocumental; 
	
	@Column(name = "DD_TDO_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TDO_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TDO_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "DD_TDO_MATRICULA")   
	private String matricula;
	    		    
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

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
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

	public DDTipoEntidadDocumental getTipoEntidadDocumental() {
		return tipoEntidadDocumental;
	}

	public void setTipoEntidadDocumental(DDTipoEntidadDocumental tipoEntidadDocumental) {
		this.tipoEntidadDocumental = tipoEntidadDocumental;
	}

	public String getMatricula() {
		return matricula;
	}

	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}
	

}

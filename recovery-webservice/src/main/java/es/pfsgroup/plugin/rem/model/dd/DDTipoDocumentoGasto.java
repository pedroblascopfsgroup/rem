package es.pfsgroup.plugin.rem.model.dd;

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
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de los tipos de documentos de gastos
 * 
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "DD_TPD_TIPOS_DOCUMENTO_GASTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoDocumentoGasto implements Auditable, Dictionary {

    
	/**
	 * 
	 */
	private static final long serialVersionUID = -4760202568628965576L;

	@Id
	@Column(name = "DD_TPD_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoDocumentoGastoGenerator")
	@SequenceGenerator(name = "DDTipoDocumentoGastoGenerator", sequenceName = "S_DD_TPD_TP_DTO_GASTO")
	private Long id;
	 
	@Column(name = "DD_TPD_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TPD_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TPD_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
	@Column(name = "DD_TPD_MATRICULA_GD")   
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
	
	public String getMatricula() {
		return matricula;
	}
	
	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}

}

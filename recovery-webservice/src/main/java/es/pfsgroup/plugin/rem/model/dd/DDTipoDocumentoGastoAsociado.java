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


@Entity
@Table(name = "DD_TPG_TPO_DOC_GASTO_ASOC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoDocumentoGastoAsociado implements Auditable, Dictionary{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4729362446723011871L;

	@Id
	@Column(name = "DD_TPG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoDocumentoGastoAsociado")
	@SequenceGenerator(name = "DDTipoDocumentoGastoAsociado", sequenceName = "S_DD_TPG_TPO_DOC_GASTO_ASOC")
	private Long id;
    
    @Column(name = "DD_TPG_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TPG_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TPG_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "DD_TPG_MATRICULA_GD")
	private String matricula;

	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	@Override
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Override
	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	@Override
	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	@Override
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

	@Override
	public Auditoria getAuditoria() {
		return this.auditoria;
	}
	
	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}


	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

}

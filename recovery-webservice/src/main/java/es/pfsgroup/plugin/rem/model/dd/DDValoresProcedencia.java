package es.pfsgroup.plugin.rem.model.dd;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;

/**
 * 
 * @author Vicente Martinez
 *
 */
@Entity
@Table(name = "DD_VPR_VALORES_PROCEDENCIA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDValoresProcedencia implements Auditable, Dictionary {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -3836191709700209057L;
	@Id
	@Column(name = "DD_VPR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDValoresProcedenciaGenerator")
	@SequenceGenerator(name = "DDValoresProcedenciaGenerator", sequenceName = "S_DD_VPR_VALORES_PROCEDENCIA")
	private Long id;
	 
	@Column(name = "DD_VPR_CODIGO")
	private String codigo;
	 
	@Column(name = "DD_VPR_DESCRIPCION")
	private String descripcion;
	    
	@Column(name = "DD_VPR_DESCRIPCION_LARGA")
	private String descripcionLarga;
	    
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

}

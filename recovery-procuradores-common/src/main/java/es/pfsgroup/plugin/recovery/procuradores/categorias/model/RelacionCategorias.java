package es.pfsgroup.plugin.recovery.procuradores.categorias.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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

/**
 * Clase que modela las {@link RelacionCategorias}.
 * @author anahuac
 *
 */
@Entity
@Table(name = "REL_CATEGORIAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Inheritance(strategy=InheritanceType.JOINED)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public abstract class RelacionCategorias implements Serializable, Auditable{


	private static final long serialVersionUID = 7908560953068325009L;

		
	@Id
	@Column(name = "REL_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "relCATGenerator")
	@SequenceGenerator(name = "relCATGenerator", sequenceName = "S_REL_CATEGORIAS")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "CAT_ID")
	private Categoria categoria;	
	
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

	public Categoria getCategoria() {
		return categoria;
	}

	public void setCategoria(Categoria categoria) {
		this.categoria = categoria;
	}
	
	public abstract Object getEntity();

	
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

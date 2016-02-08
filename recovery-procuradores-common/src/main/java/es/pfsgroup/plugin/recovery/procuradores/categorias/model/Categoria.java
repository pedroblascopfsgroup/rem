package es.pfsgroup.plugin.recovery.procuradores.categorias.model;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


/**
 * Clase que modela las categorias.
 * @author anahuac
 *
 */
@Entity
@Table(name = "CAT_CATEGORIAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class Categoria implements Serializable, Auditable{

	private static final long serialVersionUID = 3352715745813550762L;

	
	
	@Id
	@Column(name = "CAT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "CategoriasGenerator")
	@SequenceGenerator(name = "CategoriasGenerator", sequenceName = "S_CAT_CATEGORIAS")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "CTG_ID")
	private Categorizacion categorizacion;
	
	@Column(name = "CAT_NOMBRE")
	private String nombre; 
	
	@Column(name = "CAT_DESCRIPCION")
	private String descripcion; 
	
	@Column(name = "CAT_ORDEN")
	private Integer orden; 
	
	
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
	
	public Categorizacion getCategorizacion() {
		return categorizacion;
	}

	public void setCategorizacion(Categorizacion categorizacion) {
		this.categorizacion = categorizacion;
	}
	
	
	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

		
	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Integer getOrden() {
		return orden;
	}

	public void setOrden(Integer orden) {
		this.orden = orden;
	}
	
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

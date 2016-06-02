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
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;

/**
 * Clase que modela las categorizaciones.
 * @author manuel
 *
 */
@Entity
@Table(name = "CTG_CATEGORIZACIONES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class Categorizacion implements Serializable, Auditable{

	private static final long serialVersionUID = 8312692433204674843L;

	@Id
	@Column(name = "CTG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "CategorizacionGenerator")
	@SequenceGenerator(name = "CategorizacionGenerator", sequenceName = "S_CTG_CATEGORIZACIONES")
	private Long id;
		
	@ManyToOne
	@JoinColumn(name = "CTG_DESP_EXT_ID")
	private DespachoExterno despachoExterno;
		
	@Column(name = "CTG_NOMBRE")
	private String nombre; 
	
	@Embedded
	private Auditoria auditoria;
		
	@Version
	private Integer version;
	
	@Column(name = "CTG_CODIGO")
	private String codigo; 
	
	
	
	public DespachoExterno getDespachoExterno() {
		return despachoExterno;
	}

	public void setDespachoExterno(DespachoExterno despachoExterno) {
		this.despachoExterno = despachoExterno;
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
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
	
	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

}

package es.pfsgroup.plugin.recovery.procuradores.categorias.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;

/**
 * Clase que modela las {@link RelacionCategoriaResolucion}.
 * @author anahuac
 *
 */
@Entity
@Table(name = "REC_RES_CAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
//@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RelacionCategoriaResolucion  implements Serializable {


	private static final long serialVersionUID = -5197160946795429731L;
	
	@Id
	@Column(name = "REC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "CategoriaResolucionGenerator")
	@SequenceGenerator(name = "CategoriaResolucionGenerator", sequenceName = "S_REC_RES_CAT")
	private Long id;
		
	@ManyToOne
	@JoinColumn(name = "RES_ID")
	private MSVResolucion resolucion;
	
	@ManyToOne
	@JoinColumn(name = "CAT_ID")
	private Categoria categoria;
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public MSVResolucion getResolucion() {
		return resolucion;
	}

	public void setResolucion(MSVResolucion resolucion) {
		this.resolucion = resolucion;
	}
	
	public Categoria getCategoria() {
		return categoria;
	}

	public void setCategoria(Categoria categoria) {
		this.categoria = categoria;
	}

	
}

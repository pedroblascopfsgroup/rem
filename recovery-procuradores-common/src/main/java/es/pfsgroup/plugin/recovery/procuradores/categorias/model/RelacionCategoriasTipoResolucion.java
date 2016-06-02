package es.pfsgroup.plugin.recovery.procuradores.categorias.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;

/**
 * Clase que modela las {@link RelacionCategoriasTipoResolucion}.
 * @author anahuac
 *
 */
@Entity
@Table(name = "REL_CATEGORIAS_TIPORESOL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@PrimaryKeyJoinColumn(name = "REL_ID")
public class RelacionCategoriasTipoResolucion extends RelacionCategorias implements Serializable {


	private static final long serialVersionUID = -5197160946795429731L;

	
	@ManyToOne
	@JoinColumn(name = "TR_ID")	
	private MSVDDTipoResolucion tipoResolucion;
	

	public MSVDDTipoResolucion getMSVDDTipoResolucion() {
		return tipoResolucion;
	}

	public void setMSVDDTipoResolucion(MSVDDTipoResolucion tipoResolucion) {
		this.tipoResolucion = tipoResolucion;
	}

	@Override
	public Object getEntity() {
		return this.tipoResolucion;
	}

	
}

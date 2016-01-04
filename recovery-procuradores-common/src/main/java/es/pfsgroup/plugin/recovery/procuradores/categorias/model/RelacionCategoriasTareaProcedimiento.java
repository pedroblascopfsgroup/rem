package es.pfsgroup.plugin.recovery.procuradores.categorias.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;

/**
 * Clase que modela las {@link RelacionCategoriasTareaProcedimiento}.
 * @author anahuac
 *
 */
@Entity
@Table(name = "REL_CATEGORIAS_TAREASPROC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@PrimaryKeyJoinColumn(name = "REL_ID")
public class RelacionCategoriasTareaProcedimiento extends RelacionCategorias implements Serializable {


	private static final long serialVersionUID = 331730045608427717L;
	
	
	@ManyToOne
	@JoinColumn(name = "TAP_ID")
	private TareaProcedimiento tareaProcedimiento;

			
	public TareaProcedimiento getTareaProcedimiento() {
		return tareaProcedimiento;
	}

	public void setTareaProcedimiento(TareaProcedimiento tareaProcedimiento) {
		this.tareaProcedimiento = tareaProcedimiento;
	}

	@Override
	public Object getEntity() {
		return this.tareaProcedimiento;
	}

}

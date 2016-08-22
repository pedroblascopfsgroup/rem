package es.pfsgroup.framework.paradise.gestorEntidad.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.Asunto;

@Entity
@Table(name = "GAH_GESTOR_ASUNTO_HIST", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@PrimaryKeyJoinColumn(name = "GEH_ID")
public class GestorAsuntoHistorico extends GestorEntidadHistorico implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4121531450027093130L;

	@ManyToOne
	@JoinColumn(name = "ASU_ID")
	private Asunto asunto;

	public Asunto getAsunto() {
		return asunto;
	}

	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}

	
}

package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;

@Entity
@Table(name = "GAH_GESTOR_ACTIVO_HISTORICO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@PrimaryKeyJoinColumn(name = "GEH_ID")
public class GestorActivoHistorico extends GestorEntidadHistorico implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4121531450027093130L;

	@ManyToOne
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	
}

package es.pfsgroup.framework.paradise.gestorEntidad.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.expediente.model.Expediente;

@Entity
@Table(name = "GEH_GESTOR_EXPEDIENTE_HIST", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@PrimaryKeyJoinColumn(name = "GEH_ID")
public class GestorExpedienteHistorico extends GestorEntidadHistorico implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4121531450027093130L;

	@ManyToOne
	@JoinColumn(name = "EXP_ID")
	private Expediente expediente;

	public Expediente getExpediente() {
		return expediente;
	}

	public void setExpediente(Expediente expediente) {
		this.expediente = expediente;
	}

}

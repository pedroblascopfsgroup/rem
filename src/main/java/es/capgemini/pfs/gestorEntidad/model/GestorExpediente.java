package es.capgemini.pfs.gestorEntidad.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;

@Entity
@Table(name = "GAE_GESTOR_ADD_EXPEDIENTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@PrimaryKeyJoinColumn(name="GEE_ID")
public class GestorExpediente extends GestorEntidad implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 970719216228640813L;

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

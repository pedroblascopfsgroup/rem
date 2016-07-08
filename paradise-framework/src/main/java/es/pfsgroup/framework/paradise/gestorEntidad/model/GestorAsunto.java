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
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;

@Entity
@Table(name = "GAA_GESTOR_ADD_ASUNTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@PrimaryKeyJoinColumn(name = "GEE_ID")
public class GestorAsunto extends GestorEntidad implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5826097714081255272L;

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

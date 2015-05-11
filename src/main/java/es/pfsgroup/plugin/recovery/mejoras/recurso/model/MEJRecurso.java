package es.pfsgroup.plugin.recovery.mejoras.recurso.model;

import javax.persistence.Column;
import javax.persistence.Entity;

import es.capgemini.pfs.recurso.model.Recurso;

@Entity
public class MEJRecurso extends Recurso {

	private static final long serialVersionUID = -3067715128864590578L;

	@Column(name = "RCR_SUSPENSIVO")
    private Boolean suspensivo;

	/**
	 * @param suspensivo the suspensivo to set
	 */
	public void setSuspensivo(Boolean suspensivo) {
		this.suspensivo = suspensivo;
	}

	/**
	 * @return the suspensivo
	 */
	public Boolean getSuspensivo() {
		return suspensivo;
	}
}

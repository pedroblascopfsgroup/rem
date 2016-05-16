package es.pfsgroup.plugin.recovery.config.delegaciones.model;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;

public class ZonaUsuarioPerfilDelegaciones extends ZonaUsuarioPerfil {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5146406259602340204L;

	@ManyToOne
	@JoinColumn(name="DEL_ID")
	Delegacion delegacion;

	public Delegacion getDelegacion() {
		return delegacion;
	}

	public void setDelegacion(Delegacion delegacion) {
		this.delegacion = delegacion;
	}
}

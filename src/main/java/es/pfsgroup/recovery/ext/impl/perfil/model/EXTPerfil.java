package es.pfsgroup.recovery.ext.impl.perfil.model;

import javax.persistence.Column;
import javax.persistence.Entity;

import es.capgemini.pfs.users.domain.Perfil;

@Entity
public class EXTPerfil extends Perfil{

	private static final long serialVersionUID = -8207668241016327091L;
	
	@Column(name = "pef_es_carterizado")
	private Boolean esCarterizado;

	/**
	 * @return the esCarterizado
	 */
	public Boolean getEsCarterizado() {
		return esCarterizado;
	}

	/**
	 * @param esCarterizado the esCarterizado to set
	 */
	public void setEsCarterizado(Boolean esCarterizado) {
		this.esCarterizado = esCarterizado;
	}

}

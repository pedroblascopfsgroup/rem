package es.pfsgroup.recovery.ext.impl.procesosJudiciales.model;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;

import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;

@Entity
public class EXTTipoJuzgado extends TipoJuzgado {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -2332361803560142240L;
	
	
	@OneToOne
	@JoinColumn(name = "DIJ_ID")
	private DireccionJuzgado direccion;

	public DireccionJuzgado getDireccion() {
		return direccion;
	}

	public void setDireccion(DireccionJuzgado direccion) {
		this.direccion = direccion;
	}
	
	

}

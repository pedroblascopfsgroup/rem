package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import javax.persistence.Column;

import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBTitularBienInfo;

public class NMBTitularBien implements NMBTitularBienInfo{

	
	
	@Column(name = "BIE_FECHA_INSCRIPCION")
	private Integer participacion;
	
	@Column(name = "BIE_FECHA_INSCRIPCION")
	private Persona persona;

	@Column(name = "BIE_FECHA_INSCRIPCION")
	private NMBBienInfo bien;

	@Override
	public NMBBienInfo getBien() {
		return this.bien;
	}

	@Override
	public Integer getParticipacion() {
		return this.participacion;
	}

	@Override
	public Persona getPersona() {
		return this.persona;
	}

}

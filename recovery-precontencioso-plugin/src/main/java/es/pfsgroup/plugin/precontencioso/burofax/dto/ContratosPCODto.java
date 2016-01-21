package es.pfsgroup.plugin.precontencioso.burofax.dto;

import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDTipoIntervencion;

public class ContratosPCODto {
	private Contrato contrato;
	private DDTipoIntervencion tipoIntervencion;
	private boolean tieneRelacionContratoPersona;
	private boolean tieneRelacionContratoPersonaManual;

	public Contrato getContrato() {
		return contrato;
	}
	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}
	public DDTipoIntervencion getTipoIntervencion() {
		return tipoIntervencion;
	}
	public void setTipoIntervencion(DDTipoIntervencion tipoIntervencion) {
		this.tipoIntervencion = tipoIntervencion;
	}
	public boolean isTieneRelacionContratoPersona() {
		return tieneRelacionContratoPersona;
	}
	public void setTieneRelacionContratoPersona(boolean tieneRelacionContratoPersona) {
		this.tieneRelacionContratoPersona = tieneRelacionContratoPersona;
	}
	public boolean isTieneRelacionContratoPersonaManual() {
		return tieneRelacionContratoPersonaManual;
	}
	public void setTieneRelacionContratoPersonaManual(
			boolean tieneRelacionContratoPersonaManual) {
		this.tieneRelacionContratoPersonaManual = tieneRelacionContratoPersonaManual;
	}
	
}

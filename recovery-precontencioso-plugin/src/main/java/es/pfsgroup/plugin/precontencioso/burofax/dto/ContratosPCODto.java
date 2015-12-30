package es.pfsgroup.plugin.precontencioso.burofax.dto;

import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDTipoIntervencion;

public class ContratosPCODto {
	private Contrato contrato;
	private DDTipoIntervencion tipoIntervencion;
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
	
}

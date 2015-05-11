package es.pfsgroup.plugin.recovery.nuevoModeloBienes.contratos.dto;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.contrato.model.ContratoPersona;

public class NMBDtoIntervinientes  extends WebDto{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 7893635058109807207L;
	
	private ContratoPersona personaContrato;
	private Boolean demandado;
	
	public ContratoPersona getPersonaContrato() {
		return personaContrato;
	}
	public void setPersonaContrato(ContratoPersona personaContrato) {
		this.personaContrato = personaContrato;
	}
	public Boolean getDemandado() {
		return demandado;
	}
	public void setDemandado(Boolean demandado) {
		this.demandado = demandado;
	}
	
	

}

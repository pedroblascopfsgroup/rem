package es.pfsgroup.recovery.recobroCommon.expediente.dto;

import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.expediente.model.ExpedientePersona;
import es.pfsgroup.recovery.recobroCommon.persona.model.CicloRecobroPersona;

public class CicloRecobroPersonaExpedienteDto extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -1469435074931992270L;
	
	private ExpedientePersona expedientePersona;
	
	private List<CicloRecobroPersona> ciclosRecobro;

	public ExpedientePersona getExpedientePersona() {
		return expedientePersona;
	}

	public void setExpedientePersona(ExpedientePersona expedientePersona) {
		this.expedientePersona = expedientePersona;
	}

	public List<CicloRecobroPersona> getCiclosRecobro() {
		return ciclosRecobro;
	}

	public void setCiclosRecobro(List<CicloRecobroPersona> ciclosRecobro) {
		this.ciclosRecobro = ciclosRecobro;
	}
	
	

}

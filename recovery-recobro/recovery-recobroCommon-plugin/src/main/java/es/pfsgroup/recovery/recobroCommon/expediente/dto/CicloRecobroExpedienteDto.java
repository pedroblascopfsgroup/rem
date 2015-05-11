package es.pfsgroup.recovery.recobroCommon.expediente.dto;

import java.util.List;

import es.capgemini.devon.dto.WebDto;

public class CicloRecobroExpedienteDto extends WebDto {

	private static final long serialVersionUID = 3304686631954294025L;
	
	private Long idExpediente;
	
	private List<Long> listaAgencias;

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public List<Long> getListaAgencias() {
		return listaAgencias;
	}

	public void setListaAgencias(List<Long> listaAgencias) {
		this.listaAgencias = listaAgencias;
	}

}

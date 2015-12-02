package es.pfsgroup.concursal.credito.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoBuscarCreditosAsunto extends WebDto{
	private static final long serialVersionUID = -2719865572988229661L;
	
	private Long idAsunto;

	public Long getIdAsunto() {
		return idAsunto;
	}

	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}
}

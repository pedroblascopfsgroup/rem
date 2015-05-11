package es.pfsgroup.recovery.recobroCommon.facturacion.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroDDTipoCobroDto extends WebDto{

	private static final long serialVersionUID = 3736849040100115385L;

	private Long idModFact;
	
	private Boolean habilitados;
	
	private Boolean facturables;

	public Long getIdModFact() {
		return idModFact;
	}

	public void setIdModFact(Long idModFact) {
		this.idModFact = idModFact;
	}

	public Boolean getHabilitados() {
		return habilitados;
	}

	public void setHabilitados(Boolean habilitados) {
		this.habilitados = habilitados;
	}

	public Boolean getFacturables() {
		return facturables;
	}

	public void setFacturables(Boolean facturables) {
		this.facturables = facturables;
	}
	
}

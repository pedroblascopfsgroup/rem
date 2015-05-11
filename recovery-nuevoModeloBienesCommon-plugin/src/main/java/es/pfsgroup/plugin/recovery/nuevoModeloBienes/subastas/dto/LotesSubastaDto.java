package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto;

import java.io.Serializable;

import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;

public class LotesSubastaDto implements Serializable {

	private static final long serialVersionUID = -8492934129430118089L;
	
	private LoteSubasta lote;
	private Integer NumLote;
	
	public LoteSubasta getLote() {
		return lote;
	}
	public void setLote(LoteSubasta lote) {
		this.lote = lote;
	}
	public Integer getNumLote() {
		return NumLote;
	}
	public void setNumLote(Integer numLote) {
		NumLote = numLote;
	}
	
}

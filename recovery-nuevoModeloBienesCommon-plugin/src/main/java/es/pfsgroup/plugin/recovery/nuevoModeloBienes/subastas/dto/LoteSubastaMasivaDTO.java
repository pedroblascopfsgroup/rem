package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto;

import es.capgemini.pfs.oficina.model.Oficina;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;

public class LoteSubastaMasivaDTO {

	private LoteSubasta loteSubasta;
	private Oficina centroGestor;
	
	public LoteSubasta getLoteSubasta() {
		return loteSubasta;
	}
	public void setLoteSubasta(LoteSubasta loteSubasta) {
		this.loteSubasta = loteSubasta;
	}
	public Oficina getCentroGestor() {
		return centroGestor;
	}
	public void setCentroGestor(Oficina centroGestor) {
		this.centroGestor = centroGestor;
	}
	
	public String getCentroGestorString() {
		if (this.getCentroGestor()==null) {
			return null;
		}
		return String.format("%d - %s", this.getCentroGestor().getCodigoOficina(), this.getCentroGestor().getNombre());
	}
	
}

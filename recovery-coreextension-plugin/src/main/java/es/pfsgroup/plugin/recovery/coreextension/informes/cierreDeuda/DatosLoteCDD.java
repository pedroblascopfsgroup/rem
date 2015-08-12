package es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda;
 
import java.util.List;

public class DatosLoteCDD {

	private Long numLote;
	private String sinPostores;
	private String conPostoresDesde;
	private String conPostoresHasta;
	private String valorSubasta;
	private List<InfoBienesCDD> infoBienes;

	public Long getNumLote() {
		return numLote;
	}
	
	public void setNumLote(Long numLote) {
		this.numLote = numLote;
	}
		
	public String getSinPostores() {
		return sinPostores;
	}

	public void setSinPostores(String sinPostores) {
		this.sinPostores = sinPostores;
	}

	public String getConPostoresDesde() {
		return conPostoresDesde;
	}

	public void setConPostoresDesde(String conPostoresDesde) {
		this.conPostoresDesde = conPostoresDesde;
	}

	public String getConPostoresHasta() {
		return conPostoresHasta;
	}

	public void setConPostoresHasta(String conPostoresHasta) {
		this.conPostoresHasta = conPostoresHasta;
	}

	public String getValorSubasta() {
		return valorSubasta;
	}

	public void setValorSubasta(String valorSubasta) {
		this.valorSubasta = valorSubasta;
	}

	public List<InfoBienesCDD> getInfoBienes() {
		return infoBienes;
	}

	public void setInfoBienes(List<InfoBienesCDD> infoBienes) {
		this.infoBienes = infoBienes;
	}

}
package es.pfsgroup.plugin.recovery.coreextension.subasta.dto;

/**
 * Clase que transfiere informaci�n desde la vista hacia el modelo.
 *
 */
public class NMBDtoBuscarLotesSubastas extends NMBDtoBuscarSubastas {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
			
	private String idEstadoInstrucciones;
	private String tipoSubastaDesde;
	private String tipoSubastaHasta;
	private String numeroActivo;
	private String fincaRegistral;
	private String idPlazaJuzgado;
	private String idJuzgado;
	
	public String getIdEstadoInstrucciones() {
		return idEstadoInstrucciones;
	}
	public void setIdEstadoInstrucciones(String idEstadoInstrucciones) {
		this.idEstadoInstrucciones = idEstadoInstrucciones;
	}
	public String getTipoSubastaDesde() {
		return tipoSubastaDesde;
	}
	public void setTipoSubastaDesde(String tipoSubastaDesde) {
		this.tipoSubastaDesde = tipoSubastaDesde;
	}
	public String getTipoSubastaHasta() {
		return tipoSubastaHasta;
	}
	public void setTipoSubastaHasta(String tipoSubastaHasta) {
		this.tipoSubastaHasta = tipoSubastaHasta;
	}
	public String getNumeroActivo() {
		return numeroActivo;
	}
	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}
	public String getIdPlazaJuzgado() {
		return idPlazaJuzgado;
	}
	public void setIdPlazaJuzgado(String idPlazaJuzgado) {
		this.idPlazaJuzgado = idPlazaJuzgado;
	}
	public String getFincaRegistral() {
		return fincaRegistral;
	}
	public void setFincaRegistral(String fincaRegistral) {
		this.fincaRegistral = fincaRegistral;
	}
	public String getIdJuzgado() {
		return idJuzgado;
	}
	public void setIdJuzgado(String idJuzgado) {
		this.idJuzgado = idJuzgado;
	}
	
}
package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto;

import java.io.Serializable;


public class GuardarInstruccionesDto implements Serializable {
	
	private static final long serialVersionUID = 6579481639164851490L;

	private String idLote;
	private String pujaSinPostores;
	private String pujaPostoresDesde;
	private String pujaPostoresHasta;
	private String valorSubasta;
	private String tipoSubasta50;
	private String tipoSubasta60;
	private String tipoSubasta70;
	private String observaciones;
	private String riesgoConsignacion;
	private String deudaJudicial;
	
	public String getIdLote() {
		return idLote;
	}
	public void setIdLote(String idLote) {
		this.idLote = idLote;
	}
	public String getPujaSinPostores() {
		return pujaSinPostores;
	}
	public void setPujaSinPostores(String pujaSinPostores) {
		this.pujaSinPostores = pujaSinPostores;
	}
	public String getPujaPostoresDesde() {
		return pujaPostoresDesde;
	}
	public void setPujaPostoresDesde(String pujaPostoresDesde) {
		this.pujaPostoresDesde = pujaPostoresDesde;
	}
	public String getPujaPostoresHasta() {
		return pujaPostoresHasta;
	}
	public void setPujaPostoresHasta(String pujaPostoresHasta) {
		this.pujaPostoresHasta = pujaPostoresHasta;
	}
	public String getValorSubasta() {
		return valorSubasta;
	}
	public void setValorSubasta(String valorSubasta) {
		this.valorSubasta = valorSubasta;
	}
	public String getTipoSubasta50() {
		return tipoSubasta50;
	}
	public void setTipoSubasta50(String tipoSubasta50) {
		this.tipoSubasta50 = tipoSubasta50;
	}
	public String getTipoSubasta60() {
		return tipoSubasta60;
	}
	public void setTipoSubasta60(String tipoSubasta60) {
		this.tipoSubasta60 = tipoSubasta60;
	}
	public String getTipoSubasta70() {
		return tipoSubasta70;
	}
	public void setTipoSubasta70(String tipoSubasta70) {
		this.tipoSubasta70 = tipoSubasta70;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getRiesgoConsignacion() {
		return riesgoConsignacion;
	}
	public void setRiesgoConsignacion(String riesgoConsignacion) {
		this.riesgoConsignacion = riesgoConsignacion;
	}
	public String getDeudaJudicial() {
		return deudaJudicial;
	}
	public void setDeudaJudicial(String deudaJudicial) {
		this.deudaJudicial = deudaJudicial;
	}

}

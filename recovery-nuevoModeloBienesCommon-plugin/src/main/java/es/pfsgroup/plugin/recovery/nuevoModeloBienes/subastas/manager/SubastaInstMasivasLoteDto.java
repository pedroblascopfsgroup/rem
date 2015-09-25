package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.manager;

import java.util.Date;

public class SubastaInstMasivasLoteDto {

	private String numAutos;
	private Date fechaSubasta;
	private Long idLote;
	private Float pujaSinPostores;
	private Float pujaPostoresDesde;
	private Float pujaPostoresHasta;
	private Float valorSubasta;
	private String instrucciones;
	private Float deudaJudicial;
	
	public String getNumAutos() {
		return numAutos;
	}
	public void setNumAutos(String numAutos) {
		this.numAutos = numAutos;
	}
	public Date getFechaSubasta() {
		return fechaSubasta;
	}
	public void setFechaSubasta(Date fechaSubasta) {
		this.fechaSubasta = fechaSubasta;
	}
	public Long getIdLote() {
		return idLote;
	}
	public void setIdLote(Long idLote) {
		this.idLote = idLote;
	}
	public Float getPujaSinPostores() {
		return pujaSinPostores;
	}
	public void setPujaSinPostores(Float pujaSinPostores) {
		this.pujaSinPostores = pujaSinPostores;
	}
	public Float getPujaPostoresDesde() {
		return pujaPostoresDesde;
	}
	public void setPujaPostoresDesde(Float pujaPostoresDesde) {
		this.pujaPostoresDesde = pujaPostoresDesde;
	}
	public Float getPujaPostoresHasta() {
		return pujaPostoresHasta;
	}
	public void setPujaPostoresHasta(Float pujaPostoresHasta) {
		this.pujaPostoresHasta = pujaPostoresHasta;
	}
	public Float getValorSubasta() {
		return valorSubasta;
	}
	public void setValorSubasta(Float valorSubasta) {
		this.valorSubasta = valorSubasta;
	}
	public String getInstrucciones() {
		return instrucciones;
	}
	public void setInstrucciones(String instrucciones) {
		this.instrucciones = instrucciones;
	}
	public Float getDeudaJudicial() {
		return deudaJudicial;
	}
	public void setDeudaJudicial(Float deudaJudicial) {
		this.deudaJudicial = deudaJudicial;
	}
	
}

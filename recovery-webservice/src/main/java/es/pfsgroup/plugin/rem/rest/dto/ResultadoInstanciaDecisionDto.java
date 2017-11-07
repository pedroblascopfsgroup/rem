package es.pfsgroup.plugin.rem.rest.dto;

public class ResultadoInstanciaDecisionDto {
	
	private Integer longitudMensajeSalida;     
	private String codigoDeOfertaHaya;
	private String codigoComite; //ver ResolucionComiteApi
	private String codigoComiteSuperior;
	
	public Integer getLongitudMensajeSalida() {
		return longitudMensajeSalida;
	}
	public void setLongitudMensajeSalida(Integer longitudMensajeSalida) {
		this.longitudMensajeSalida = longitudMensajeSalida;
	}
	public String getCodigoDeOfertaHaya() {
		return codigoDeOfertaHaya;
	}
	public void setCodigoDeOfertaHaya(String codigoDeOfertaHaya) {
		this.codigoDeOfertaHaya = codigoDeOfertaHaya;
	}
	public String getCodigoComite() {
		return codigoComite;
	}
	public void setCodigoComite(String codigoComite) {
		this.codigoComite = codigoComite;
	}
	public String getCodigoComiteSuperior() {
		return codigoComiteSuperior;
	}
	public void setComiteSuperior(String comiteSuperior) {
		this.codigoComiteSuperior = comiteSuperior;
	}
	
}

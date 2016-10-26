package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class InstanciaDecisionDto {
	
	public final char FINANCIACION_CLIENTE_SI = 'S';
	public final char FINANCIACION_CLIENTE_NO = 'N';
	
	private String codigoDeOfertaHaya; //Campo OFR_NUM_OFERTA de la tabla OFR_OFERTAS
	private char indicadorDeFinanciacionCliente; //'S' or 'N'
	private List<InstanciaDecisionDataDto> data;

	public String getCodigoDeOfertaHaya() {
		return codigoDeOfertaHaya;
	}
	public void setCodigoDeOfertaHaya(String codigoDeOfertaHaya) {
		this.codigoDeOfertaHaya = codigoDeOfertaHaya;
	}
	public boolean isFinanciacionCliente() {
		return ( indicadorDeFinanciacionCliente ==  FINANCIACION_CLIENTE_SI);
	}
	public void setFinanciacionCliente( boolean esFinanciacionCliente) {
		if (esFinanciacionCliente) {
			this.indicadorDeFinanciacionCliente = FINANCIACION_CLIENTE_SI;
		} else {
			this.indicadorDeFinanciacionCliente = FINANCIACION_CLIENTE_NO;
		}
	}
	public List<InstanciaDecisionDataDto> getData() {
		return data;
	}
	public void setData(List<InstanciaDecisionDataDto> data) {
		this.data = data;
	}
}

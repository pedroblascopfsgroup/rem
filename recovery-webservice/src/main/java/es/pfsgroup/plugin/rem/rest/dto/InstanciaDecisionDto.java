package es.pfsgroup.plugin.rem.rest.dto;

import es.pfsgroup.commons.utils.Checks;

public class InstanciaDecisionDto {

	public final short PROPUESTA_VENTA = 1;
	public final short PROPUESTA_CONTRAOFERTA = 3;
	
	public final char FINANCIACION_CLIENTE_SI = 'S';
	public final char FINANCIACION_CLIENTE_NO = 'N';
	
	public final static short TIPO_IMPUESTO_SIN_IMPUESTO = 0;
	public final static short TIPO_IMPUESTO_ITP = 1;
	public final static short TIPO_IMPUESTO_IVA = 2;
	public final static short TIPO_IMPUESTO_IGIC = 3;
	public final static short TIPO_IMPUESTO_IPSI = 4;
	
	private String codigoDeOfertaHaya; //Campo OFR_NUM_OFERTA de la tabla OFR_OFERTAS
	private char indicadorDeFinanciacionCliente; //'S' or 'N'
	private Integer identificadorActivoEspecial;
	private Long importeConSigno; //x100
	private short tipoDeImpuesto;
	private int porcentajeImpuesto;
	
	public String getCodigoDeOfertaHaya() {
		return codigoDeOfertaHaya;
	}
	public void setCodigoDeOfertaHaya(String codigoDeOfertaHaya) {
		this.codigoDeOfertaHaya = codigoDeOfertaHaya;
	}
	public Integer getIdentificadorActivoEspecial() {
		return identificadorActivoEspecial;
	}
	public void setIdentificadorActivoEspecial(Integer identificadorActivoEspecial) {
		this.identificadorActivoEspecial = identificadorActivoEspecial;
	}
	public Long getImporteConSigno() {
		return importeConSigno;
	}
	public void setImporteConSigno(Long importeConSigno) {
		if(!Checks.esNulo(importeConSigno)){
			this.importeConSigno = importeConSigno * 100;
		}else{
			this.importeConSigno = importeConSigno;
		}
	}
	public short getTipoDeImpuesto() {
		return tipoDeImpuesto;
	}
	public void setTipoDeImpuesto(short tipoDeImpuesto) {
		this.tipoDeImpuesto = tipoDeImpuesto;
	}
	public int getPorcentajeImpuesto() {
		return porcentajeImpuesto;
	}
	public void setPorcentajeImpuesto(int porcentajeImpuesto) {
		if(!Checks.esNulo(porcentajeImpuesto)){
			this.porcentajeImpuesto = porcentajeImpuesto*100;
		}else{
			this.porcentajeImpuesto = porcentajeImpuesto;
		}
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
}

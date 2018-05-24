package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class InstanciaDecisionDto {
	
	public final char FINANCIACION_CLIENTE_SI = 'S';
	public final char FINANCIACION_CLIENTE_NO = 'N';
	
	private String codigoDeOfertaHaya; //Campo OFR_NUM_OFERTA de la tabla OFR_OFERTAS
	private char indicadorDeFinanciacionCliente; //'S' or 'N'
	private List<InstanciaDecisionDataDto> data;
	private List<TitularDto> titulares;
	private Double importeReserva = new Double(0);
	private Boolean impuestosReserva;
	private String codTipoArras;
	private String codComiteSuperior;
	//Si la cartera no es BANKIA_HABITAD valdra BANKIA, 
	private String qcenre;
	private short codigoCOTPRA;
	private String codigoProveedorUvem;
	private Boolean ofertaAgrupacion;
	private Integer codigoAgrupacionInmueble;
	
	private Boolean ofertaVentaCartera;
	
	
	

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
	public List<TitularDto> getTitulares() {
		return titulares;
	}
	public void setTitulares(List<TitularDto> titulares) {
		this.titulares = titulares;
	}
	public Double getImporteReserva() {
		return importeReserva;
	}
	public void setImporteReserva(Double importeReserva) {
		this.importeReserva = importeReserva;
	}
	public Boolean getImpuestosReserva() {
		return impuestosReserva;
	}
	public void setImpuestosReserva(Boolean impuestosReserva) {
		this.impuestosReserva = impuestosReserva;
	}
	public String getCodTipoArras() {
		return codTipoArras;
	}
	public void setCodTipoArras(String codTipoArras) {
		this.codTipoArras = codTipoArras;
	}
	public String getQcenre() {
		return qcenre;
	}
	public void setQcenre(String qcenre) {
		this.qcenre = qcenre;
	}
	public short getCodigoCOTPRA() {
		return codigoCOTPRA;
	}
	public void setCodigoCOTPRA(short codigoCOTPRA) {
		this.codigoCOTPRA = codigoCOTPRA;
	}
	public String getCodigoProveedorUvem() {
		return codigoProveedorUvem;
	}
	public void setCodigoProveedorUvem(String codigoProveedorUvem) {
		this.codigoProveedorUvem = codigoProveedorUvem;
	}
	public String getCodComiteSuperior() {
		return codComiteSuperior;
	}
	public void setCodComiteSuperior(String codComiteSuperior) {
		this.codComiteSuperior = codComiteSuperior;
	}
	public Boolean getOfertaAgrupacion() {
		return ofertaAgrupacion;
	}
	public void setOfertaAgrupacion(Boolean ofertaAgrupacion) {
		this.ofertaAgrupacion = ofertaAgrupacion;
	}
	public Integer getCodigoAgrupacionInmueble() {
		return codigoAgrupacionInmueble;
	}
	public void setCodigoAgrupacionInmueble(Integer codigoAgrupacionInmueble) {
		this.codigoAgrupacionInmueble = codigoAgrupacionInmueble;
	}
	public Boolean getOfertaVentaCartera() {
		return ofertaVentaCartera;
	}
	public void setOfertaVentaCartera(Boolean ofertaVentaCartera) {
		this.ofertaVentaCartera = ofertaVentaCartera;
	}
	
	
	
}

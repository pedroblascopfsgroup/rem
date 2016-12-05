package es.pfsgroup.plugin.rem.rest.dto;

public class OfertaUVEMDto {

	private String codOpcion;
	private String codOfertaHRE;
	private String codPrescriptor;
	private String importeReserva;
	private String importeVenta;
	private String entidad; //00000
	private String impuestos;
	private String arras; 
	
	public String getCodOpcion() {
		return codOpcion;
	}
	public void setCodOpcion(String codOpcion) {
		this.codOpcion = codOpcion;
	}
	public String getCodOfertaHRE() {
		return codOfertaHRE;
	}
	public void setCodOfertaHRE(String codOfertaHRE) {
		this.codOfertaHRE = codOfertaHRE;
	}
	public String getCodPrescriptor() {
		return codPrescriptor;
	}
	public void setCodPrescriptor(String codPrescriptor) {
		this.codPrescriptor = codPrescriptor;
	}
	public String getImporteReserva() {
		return importeReserva;
	}
	public void setImporteReserva(String importeReserva) {
		this.importeReserva = importeReserva;
	}
	public String getImporteVenta() {
		return importeVenta;
	}
	public void setImporteVenta(String importeVenta) {
		this.importeVenta = importeVenta;
	}
	public String getEntidad() {
		return entidad;
	}
	public void setEntidad(String entidad) {
		this.entidad = entidad;
	}
	public String getImpuestos() {
		return impuestos;
	}
	public void setImpuestos(String impuestos) {
		this.impuestos = impuestos;
	}
	public String getArras() {
		return arras;
	}
	public void setArras(String arras) {
		this.arras = arras;
	}
	
}

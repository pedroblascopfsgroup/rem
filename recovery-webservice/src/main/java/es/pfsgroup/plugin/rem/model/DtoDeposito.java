package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoDeposito extends WebDto {

	private static final long serialVersionUID = 1L;
	
	private Long id;
	private Double importeDeposito;
	private Date fechaIngresoDeposito;
	private String estadoCodigo;
	private Date fechaDevolucionDeposito;
	private String ibanDevolucionDeposito;
	private Boolean ofertaConDeposito;
	private Boolean usuCrearOfertaDepositoExterno;
	
	private String fechaIngresoDepositoString;
	private String fechaDevolucionDepositoString;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Double getImporteDeposito() {
		return importeDeposito;
	}
	public void setImporteDeposito(Double importeDeposito) {
		this.importeDeposito = importeDeposito;
	}
	public Date getFechaIngresoDeposito() {
		return fechaIngresoDeposito;
	}
	public void setFechaIngresoDeposito(Date fechaIngresoDeposito) {
		this.fechaIngresoDeposito = fechaIngresoDeposito;
	}
	public String getEstadoCodigo() {
		return estadoCodigo;
	}
	public void setEstadoCodigo(String estadoCodigo) {
		this.estadoCodigo = estadoCodigo;
	}
	public Date getFechaDevolucionDeposito() {
		return fechaDevolucionDeposito;
	}
	public void setFechaDevolucionDeposito(Date fechaDevolucionDeposito) {
		this.fechaDevolucionDeposito = fechaDevolucionDeposito;
	}
	public String getIbanDevolucionDeposito() {
		return ibanDevolucionDeposito;
	}
	public void setIbanDevolucionDeposito(String ibanDevolucionDeposito) {
		this.ibanDevolucionDeposito = ibanDevolucionDeposito;
	}
	public Boolean getOfertaConDeposito() {
		return ofertaConDeposito;
	}
	public void setOfertaConDeposito(Boolean ofertaConDeposito) {
		this.ofertaConDeposito = ofertaConDeposito;
	}
	public Boolean getUsuCrearOfertaDepositoExterno() {
		return usuCrearOfertaDepositoExterno;
	}
	public void setUsuCrearOfertaDepositoExterno(Boolean usuCrearOfertaDepositoExterno) {
		this.usuCrearOfertaDepositoExterno = usuCrearOfertaDepositoExterno;
	}
	public String getFechaIngresoDepositoString() {
		return fechaIngresoDepositoString;
	}
	public void setFechaIngresoDepositoString(String fechaIngresoDepositoString) {
		this.fechaIngresoDepositoString = fechaIngresoDepositoString;
	}
	public String getFechaDevolucionDepositoString() {
		return fechaDevolucionDepositoString;
	}
	public void setFechaDevolucionDepositoString(String fechaDevolucionDepositoString) {
		this.fechaDevolucionDepositoString = fechaDevolucionDepositoString;
	}
	
}
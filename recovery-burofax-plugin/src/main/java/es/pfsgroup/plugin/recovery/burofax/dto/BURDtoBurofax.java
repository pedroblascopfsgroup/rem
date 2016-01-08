package es.pfsgroup.plugin.recovery.burofax.dto;

import javax.validation.constraints.NotNull;

import es.capgemini.devon.dto.WebDto;

public class BURDtoBurofax extends WebDto{
	private static final long serialVersionUID = -6428795237765465804L;
	@NotNull(message = "plugin.burofax.dto.nombre.null")
	private String nombre;
	@NotNull(message = "plugin.burofax.dto.apellido1.null")
	private String apellido1;
	@NotNull(message = "plugin.burofax.dto.apellido2.null")
	private String apellido2;
	@NotNull(message = "plugin.burofax.dto.codigopostal.null")
	private String codigopostal;
	@NotNull(message = "plugin.burofax.dto.municipio.null")
	private String municipio;
	@NotNull(message = "plugin.burofax.dto.provincia.null")
	private String provincia;
	@NotNull(message = "plugin.burofax.dto.domicilio.null")
	private String domicilio;
	private String firmante;
	private String cargo;
	private String plaza;
	@NotNull(message = "plugin.burofax.dto.plazo.null")
	private Integer plazo;
	@NotNull(message = "plugin.burofax.dto.tipoIntervencion.null")
	private String tipoIntervencion;
	
	private String numContrato;
	private String numCliente;
	private String dir1;
	private String dir2;
	private String dir3;
	private String modoEntrega;
	
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApellido1() {
		return apellido1;
	}
	public void setApellido1(String apellido1) {
		this.apellido1 = apellido1;
	}
	public String getApellido2() {
		return apellido2;
	}
	public void setApellido2(String apellido2) {
		this.apellido2 = apellido2;
	}
	public String getCodigopostal() {
		return codigopostal;
	}
	public void setCodigopostal(String codigopostal) {
		this.codigopostal = codigopostal;
	}
	public String getMunicipio() {
		return municipio;
	}
	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}
	public String getProvincia() {
		return provincia;
	}
	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}
	public String getDomicilio() {
		return domicilio;
	}
	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
	}
	public void setFirmante(String firmante) {
		this.firmante = firmante;
	}
	public String getFirmante() {
		return firmante;
	}
	public void setCargo(String cargo) {
		this.cargo = cargo;
	}
	public String getCargo() {
		return cargo;
	}
	public void setPlaza(String plaza) {
		this.plaza = plaza;
	}
	public String getPlaza() {
		return plaza;
	}
	public void setPlazo(Integer plazo) {
		this.plazo = plazo;
	}
	public Integer getPlazo() {
		return plazo;
	}
	public void setTipoIntervencion(String tipoIntervencion) {
		this.tipoIntervencion = tipoIntervencion;
	}
	public String getTipoIntervencion() {
		return tipoIntervencion;
	}
	public String getNumContrato() {
		return numContrato;
	}
	public void setNumContrato(String numContrato) {
		this.numContrato = numContrato;
	}
	public String getNumCliente() {
		return numCliente;
	}
	public void setNumCliente(String numCliente) {
		this.numCliente = numCliente;
	}
	public String getDir1() {
		return dir1;
	}
	public void setDir1(String dir1) {
		this.dir1 = dir1;
	}
	public String getDir2() {
		return dir2;
	}
	public void setDir2(String dir2) {
		this.dir2 = dir2;
	}
	public String getDir3() {
		return dir3;
	}
	public void setDir3(String dir3) {
		this.dir3 = dir3;
	}
	public String getModoEntrega() {
		return modoEntrega;
	}
	public void setModoEntrega(String modoEntrega) {
		this.modoEntrega = modoEntrega;
	}
	
	

}

package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class DelegacionDto{
	
	@WebcomRequired
	private LongDataType idDelegacion;
	@WebcomRequired
	private StringDataType codTipoVia;
	@WebcomRequired
	private StringDataType nombreCalle;
	@WebcomRequired
	private StringDataType numeroCalle;
	@WebcomRequired
	private StringDataType escalera;
	@WebcomRequired
	private StringDataType planta;
	@WebcomRequired
	private StringDataType puerta;
	@WebcomRequired
	private StringDataType codMunicipio;
	@WebcomRequired
	private StringDataType codPedania;
	@WebcomRequired
	private StringDataType codProvincia;
	@WebcomRequired
	private StringDataType codigoPostal;
	@WebcomRequired
	private StringDataType telefono1;
	@WebcomRequired
	private StringDataType telefono2;
	@WebcomRequired
	private StringDataType email;
	@WebcomRequired
	private StringDataType piso;
	@WebcomRequired
	private StringDataType otros;
	@WebcomRequired
	private StringDataType codLineaNegocio;
	@WebcomRequired
	private StringDataType arrCodEspecialidad;
	@WebcomRequired
	private StringDataType arrCodIdioma;
	@WebcomRequired
	private LongDataType numComerciales;
	@WebcomRequired
	private StringDataType codGestionCnr;
	@WebcomRequired
	private StringDataType arrCodProvincia;
	@WebcomRequired
	private StringDataType arrCodLocalidad;
	@WebcomRequired
	private StringDataType arrCodigoPostal;
	
	public StringDataType getCodTipoVia() {
		return codTipoVia;
	}
	public void setCodTipoVia(StringDataType codTipoVia) {
		this.codTipoVia = codTipoVia;
	}
	public StringDataType getNombreCalle() {
		return nombreCalle;
	}
	public void setNombreCalle(StringDataType nombreCalle) {
		this.nombreCalle = nombreCalle;
	}
	public StringDataType getNumeroCalle() {
		return numeroCalle;
	}
	public void setNumeroCalle(StringDataType numeroCalle) {
		this.numeroCalle = numeroCalle;
	}
	public StringDataType getEscalera() {
		return escalera;
	}
	public void setEscalera(StringDataType escalera) {
		this.escalera = escalera;
	}
	public StringDataType getPlanta() {
		return planta;
	}
	public void setPlanta(StringDataType planta) {
		this.planta = planta;
	}
	public StringDataType getPuerta() {
		return puerta;
	}
	public void setPuerta(StringDataType puerta) {
		this.puerta = puerta;
	}
	public StringDataType getCodMunicipio() {
		return codMunicipio;
	}
	public void setCodMunicipio(StringDataType codMunicipio) {
		this.codMunicipio = codMunicipio;
	}
	public StringDataType getCodPedania() {
		return codPedania;
	}
	public void setCodPedania(StringDataType codPedania) {
		this.codPedania = codPedania;
	}
	public StringDataType getCodProvincia() {
		return codProvincia;
	}
	public void setCodProvincia(StringDataType codProvincia) {
		this.codProvincia = codProvincia;
	}
	public StringDataType getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(StringDataType codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public StringDataType getTelefono1() {
		return telefono1;
	}
	public void setTelefono1(StringDataType telefono1) {
		this.telefono1 = telefono1;
	}
	public StringDataType getTelefono2() {
		return telefono2;
	}
	public void setTelefono2(StringDataType telefono2) {
		this.telefono2 = telefono2;
	}
	public StringDataType getEmail() {
		return email;
	}
	public void setEmail(StringDataType email) {
		this.email = email;
	}
	public LongDataType getIdDelegacion() {
		return idDelegacion;
	}
	public void setIdDelegacion(LongDataType idDelegacion) {
		this.idDelegacion = idDelegacion;
	}
	public StringDataType getPiso() {
		return piso;
	}
	public void setPiso(StringDataType piso) {
		this.piso = piso;
	}
	public StringDataType getOtros() {
		return otros;
	}
	public void setOtros(StringDataType otros) {
		this.otros = otros;
	}
	public StringDataType getCodLineaNegocio() {
		return codLineaNegocio;
	}
	public void setCodLineaNegocio(StringDataType codLineaNegocio) {
		this.codLineaNegocio = codLineaNegocio;
	}
	public LongDataType getNumComerciales() {
		return numComerciales;
	}
	public void setNumComerciales(LongDataType numComerciales) {
		this.numComerciales = numComerciales;
	}
	public StringDataType getCodGestionCnr() {
		return codGestionCnr;
	}
	public void setCodGestionCnr(StringDataType codGestionCnr) {
		this.codGestionCnr = codGestionCnr;
	}
	public StringDataType getArrCodEspecialidad() {
		return arrCodEspecialidad;
	}
	public void setArrCodEspecialidad(StringDataType arrCodEspecialidad) {
		this.arrCodEspecialidad = arrCodEspecialidad;
	}
	public StringDataType getArrCodIdioma() {
		return arrCodIdioma;
	}
	public void setArrCodIdioma(StringDataType arrCodIdioma) {
		this.arrCodIdioma = arrCodIdioma;
	}
	public StringDataType getArrCodProvincia() {
		return arrCodProvincia;
	}
	public void setArrCodProvincia(StringDataType arrCodProvincia) {
		this.arrCodProvincia = arrCodProvincia;
	}
	public StringDataType getArrCodLocalidad() {
		return arrCodLocalidad;
	}
	public void setArrCodLocalidad(StringDataType arrCodLocalidad) {
		this.arrCodLocalidad = arrCodLocalidad;
	}
	public StringDataType getArrCodigoPostal() {
		return arrCodigoPostal;
	}
	public void setArrCodigoPostal(StringDataType arrCodigoPostal) {
		this.arrCodigoPostal = arrCodigoPostal;
	}
	
}

package es.pfsgroup.plugin.rem.model;


import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de Datos de Contacto > Direcciones y delegaciones de la ficha proveedor.
 */
public class DtoDatosContacto extends WebDto {
	private static final long serialVersionUID = 0L;

	private String id;
	private String tipoLineaDeNegocioCodigo;
	private String tipoLineaDeNegocioDescripcion;
	private String gestionClientesCodigo;
	private String gestionClientesDescripcion;
	private Integer numeroComerciales;
	private String especialidadCodigo;
	private String idiomaCodigo;
	private String provinciaCodigo;
	private String municipioCodigo;
	private String codigoPostalCodigo;
	

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTipoLineaDeNegocioCodigo() {
		return tipoLineaDeNegocioCodigo;
	}
	public void setTipoLineaDeNegocioCodigo(String tipoLineaDeNegocioCodigo) {
		this.tipoLineaDeNegocioCodigo = tipoLineaDeNegocioCodigo;
	}
	public String getTipoLineaDeNegocioDescripcion() {
		return tipoLineaDeNegocioDescripcion;
	}
	public void setTipoLineaDeNegocioDescripcion(String tipoLineaDeNegocioDescripcion) {
		this.tipoLineaDeNegocioDescripcion = tipoLineaDeNegocioDescripcion;
	}
	public String getGestionClientesCodigo() {
		return gestionClientesCodigo;
	}
	public void setGestionClientesCodigo(String gestionClientesCodigo) {
		this.gestionClientesCodigo = gestionClientesCodigo;
	}
	public String getGestionClientesDescripcion() {
		return gestionClientesDescripcion;
	}
	public void setGestionClientesDescripcion(String gestionClientesDescripcion) {
		this.gestionClientesDescripcion = gestionClientesDescripcion;
	}
	public String getEspecialidadCodigo() {
		return especialidadCodigo;
	}
	public void setEspecialidadCodigo(String especialidadCodigo) {
		this.especialidadCodigo = especialidadCodigo;
	}
	public String getIdiomaCodigo() {
		return idiomaCodigo;
	}
	public void setIdiomaCodigo(String idiomaCodigo) {
		this.idiomaCodigo = idiomaCodigo;
	}
	public Integer getNumeroComerciales() {
		return this.numeroComerciales;
	}
	public void setNumeroComerciales(Integer numeroComerciales) {
		this.numeroComerciales = numeroComerciales;
	}
	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}
	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}
	public String getMunicipioCodigo() {
		return municipioCodigo;
	}
	public void setMunicipioCodigo(String municipioCodigo) {
		this.municipioCodigo = municipioCodigo;
	}
	public String getCodigoPostalCodigo() {
		return codigoPostalCodigo;
	}
	public void setCodigoPostalCodigo(String codigoPostalCodigo) {
		this.codigoPostalCodigo = codigoPostalCodigo;
	}
	
}
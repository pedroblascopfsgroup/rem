package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;




/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoAgrupaciones {

	private static final long serialVersionUID = 0L;

	private String nombre;
	private String descripcion;
	private Date fechaAlta;
	private Date fechaBaja;
	private Long numAgrupRem;
	private Long numAgrupUvem;
	private String numeroPublicados;
	private String numeroActivos;
	private String tipoAgrupacionDescripcion;
	private String municipioDescripcion;
	private String provinciaDescripcion;
	private String direccion;
	private String provinciaCodigo;
	private String municipioCodigo;
	private String propietario;
	private String acreedorPDV;
	private String codigoPostal;
	private String tipoAgrupacionCodigo;
	private String estadoObraNuevaCodigo;
	private String cartera;
	private Boolean existeFechaBaja;
	
	
	// MAPEADOS A MANO
	//tipoAgrupacion
	
	
	
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public Date getFechaBaja() {
		return fechaBaja;
	}
	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public Long getNumAgrupRem() {
		return numAgrupRem;
	}
	public void setNumAgrupRem(Long numAgrupRem) {
		this.numAgrupRem = numAgrupRem;
	}
	public Long getNumAgrupUvem() {
		return numAgrupUvem;
	}
	public void setNumAgrupUvem(Long numAgrupUvem) {
		this.numAgrupUvem = numAgrupUvem;
	}
	public String getNumeroPublicados() {
		return numeroPublicados;
	}
	public void setNumeroPublicados(String numeroPublicados) {
		this.numeroPublicados = numeroPublicados;
	}
	public String getNumeroActivos() {
		return numeroActivos;
	}
	public void setNumeroActivos(String numeroActivos) {
		this.numeroActivos = numeroActivos;
	}
	public String getTipoAgrupacionDescripcion() {
		return tipoAgrupacionDescripcion;
	}
	public void setTipoAgrupacionDescripcion(String tipoAgrupacionDescripcion) {
		this.tipoAgrupacionDescripcion = tipoAgrupacionDescripcion;
	}
	public String getMunicipioDescripcion() {
		return municipioDescripcion;
	}
	public void setMunicipioDescripcion(String municipioDescripcion) {
		this.municipioDescripcion = municipioDescripcion;
	}
	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}
	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
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
	public String getPropietario() {
		return propietario;
	}
	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getTipoAgrupacionCodigo() {
		return tipoAgrupacionCodigo;
	}
	public void setTipoAgrupacionCodigo(String tipoAgrupacionCodigo) {
		this.tipoAgrupacionCodigo = tipoAgrupacionCodigo;
	}
	public String getAcreedorPDV() {
		return acreedorPDV;
	}
	public void setAcreedorPDV(String acreedorPDV) {
		this.acreedorPDV = acreedorPDV;
	}
	public String getEstadoObraNuevaCodigo() {
		return estadoObraNuevaCodigo;
	}
	public void setEstadoObraNuevaCodigo(String estadoObraNuevaCodigo) {
		this.estadoObraNuevaCodigo = estadoObraNuevaCodigo;
	}
	public String getCartera() {
		return cartera;
	}
	public void setCartera(String cartera) {
		this.cartera = cartera;
	}
	public Boolean getExisteFechaBaja() {
		if (this.fechaBaja != null)
			return true;
		else
			return false;
	}
	public void setExisteFechaBaja(Boolean existeFechaBaja) {
		this.existeFechaBaja = existeFechaBaja;
	}

	// Mapeados a mano
	//private DDTipoAgrupacion tipoAgrupacion;
	
}
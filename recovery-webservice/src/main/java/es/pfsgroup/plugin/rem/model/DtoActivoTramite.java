package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el listado de Activos del Tramite
 * 
 * @author Bender
 *
 */
public class DtoActivoTramite extends WebDto {

	private static final long serialVersionUID = 0L;

	

	private String numActivo;
	private String numActivoRem;
	private String idSareb;
	private String numActivoUvem;
	private String idRecovery;
	private String ratingCodigo;
	private String ratingDescripcion;
	private String municipioCodigo;
	private String municipioDescripcion;
	private String provinciaCodigo;
	private String provinciaDescripcion;
	private String direccion;
	private String tipoActivoCodigo;
	private String tipoActivoDescripcion;
	private String subtipoActivoCodigo;
	private String subtipoActivoDescripcion;
	private String tipoTituloCodigo;
	private String tipoTituloDescripcion;
	private String subtipoTituloCodigo;
	private String subtipoTituloDescripcion;
	private String entidadPropietariaCodigo;
	private String entidadPropietariaDescripcion;
	private String estadoActivoCodigo;
	private String estadoActivoDescripcion;
	
	
	public String getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}
	public String getNumActivoRem() {
		return numActivoRem;
	}
	public void setNumActivoRem(String numActivoRem) {
		this.numActivoRem = numActivoRem;
	}
	public String getIdSareb() {
		return idSareb;
	}
	public void setIdSareb(String idSareb) {
		this.idSareb = idSareb;
	}
	public String getNumActivoUvem() {
		return numActivoUvem;
	}
	public void setNumActivoUvem(String numActivoUvem) {
		this.numActivoUvem = numActivoUvem;
	}
	public String getIdRecovery() {
		return idRecovery;
	}
	public void setIdRecovery(String idRecovery) {
		this.idRecovery = idRecovery;
	}
	public String getRatingCodigo() {
		return ratingCodigo;
	}
	public void setRatingCodigo(String ratingCodigo) {
		this.ratingCodigo = ratingCodigo;
	}
	public String getRatingDescripcion() {
		return ratingDescripcion;
	}
	public void setRatingDescripcion(String ratingDescripcion) {
		this.ratingDescripcion = ratingDescripcion;
	}
	public String getMunicipioCodigo() {
		return municipioCodigo;
	}
	public void setMunicipioCodigo(String municipioCodigo) {
		this.municipioCodigo = municipioCodigo;
	}
	public String getMunicipioDescripcion() {
		return municipioDescripcion;
	}
	public void setMunicipioDescripcion(String municipioDescripcion) {
		this.municipioDescripcion = municipioDescripcion;
	}
	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}
	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
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
	public String getTipoActivoCodigo() {
		return tipoActivoCodigo;
	}
	public void setTipoActivoCodigo(String tipoActivoCodigo) {
		this.tipoActivoCodigo = tipoActivoCodigo;
	}
	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}
	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}
	public String getSubtipoActivoCodigo() {
		return subtipoActivoCodigo;
	}
	public void setSubtipoActivoCodigo(String subtipoActivoCodigo) {
		this.subtipoActivoCodigo = subtipoActivoCodigo;
	}
	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}
	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
	}
	public String getTipoTituloCodigo() {
		return tipoTituloCodigo;
	}
	public void setTipoTituloCodigo(String tipoTituloCodigo) {
		this.tipoTituloCodigo = tipoTituloCodigo;
	}
	public String getTipoTituloDescripcion() {
		return tipoTituloDescripcion;
	}
	public void setTipoTituloDescripcion(String tipoTituloDescripcion) {
		this.tipoTituloDescripcion = tipoTituloDescripcion;
	}
	public String getSubtipoTituloCodigo() {
		return subtipoTituloCodigo;
	}
	public void setSubtipoTituloCodigo(String subtipoTituloCodigo) {
		this.subtipoTituloCodigo = subtipoTituloCodigo;
	}
	public String getSubtipoTituloDescripcion() {
		return subtipoTituloDescripcion;
	}
	public void setSubtipoTituloDescripcion(String subtipoTituloDescripcion) {
		this.subtipoTituloDescripcion = subtipoTituloDescripcion;
	}
	public String getEntidadPropietariaCodigo() {
		return entidadPropietariaCodigo;
	}
	public void setEntidadPropietariaCodigo(String entidadPropietariaCodigo) {
		this.entidadPropietariaCodigo = entidadPropietariaCodigo;
	}
	public String getEntidadPropietariaDescripcion() {
		return entidadPropietariaDescripcion;
	}
	public void setEntidadPropietariaDescripcion(String entidadPropietariaDescripcion) {
		this.entidadPropietariaDescripcion = entidadPropietariaDescripcion;
	}
	public String getEstadoActivoCodigo() {
		return estadoActivoCodigo;
	}
	public void setEstadoActivoCodigo(String estadoActivoCodigo) {
		this.estadoActivoCodigo = estadoActivoCodigo;
	}
	public String getEstadoActivoDescripcion() {
		return estadoActivoDescripcion;
	}
	public void setEstadoActivoDescripcion(String estadoActivoDescripcion) {
		this.estadoActivoDescripcion = estadoActivoDescripcion;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}



}
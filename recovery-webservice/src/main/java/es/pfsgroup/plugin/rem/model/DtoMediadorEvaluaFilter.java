package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Proveedores.
 * 
 * @author Bender
 */
public class DtoMediadorEvaluaFilter extends WebDto {
	private static final long serialVersionUID = 11991010L;

	private String codigoRem;	
	private String nombreApellidos; 
   	private String codPprovincia;
   	private String codLocalidad;
	private Integer esCustodio;
    private String codEstadoProveedor;
   	private String codCartera;
	private String codCalificacion;
	private Integer esTop;
	private Integer esHomologado;
	
	
	
	public String getCodigoRem() {
		return codigoRem;
	}
	public void setCodigoRem(String codigoRem) {
		this.codigoRem = codigoRem;
	}
	public String getNombreApellidos() {
		return nombreApellidos;
	}
	public void setNombreApellidos(String nombreApellidos) {
		this.nombreApellidos = nombreApellidos;
	}
	public String getCodPprovincia() {
		return codPprovincia;
	}
	public void setCodPprovincia(String codPprovincia) {
		this.codPprovincia = codPprovincia;
	}
	public String getCodLocalidad() {
		return codLocalidad;
	}
	public void setCodLocalidad(String codLocalidad) {
		this.codLocalidad = codLocalidad;
	}
	public Integer getEsCustodio() {
		return esCustodio;
	}
	public void setEsCustodio(Integer esCustodio) {
		this.esCustodio = esCustodio;
	}
	public String getCodEstadoProveedor() {
		return codEstadoProveedor;
	}
	public void setCodEstadoProveedor(String codEstadoProveedor) {
		this.codEstadoProveedor = codEstadoProveedor;
	}
	public String getCodCartera() {
		return codCartera;
	}
	public void setCodCartera(String codCartera) {
		this.codCartera = codCartera;
	}
	public String getCodCalificacion() {
		return codCalificacion;
	}
	public void setCodCalificacion(String codCalificacion) {
		this.codCalificacion = codCalificacion;
	}
	public Integer getEsTop() {
		return esTop;
	}
	public void setEsTop(Integer esTop) {
		this.esTop = esTop;
	}
	public Integer getEsHomologado() {
		return esHomologado;
	}
	public void setEsHomologado(Integer esHomologado) {
		this.esHomologado = esHomologado;
	}
	
}
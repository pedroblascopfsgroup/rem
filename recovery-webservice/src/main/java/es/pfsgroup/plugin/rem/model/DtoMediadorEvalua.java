package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de la lista de mediadores a evaluar.
 *  
 * @author Bender
 */
public class DtoMediadorEvalua extends WebDto {

	private static final long serialVersionUID = 3574101002838449106L;

	private Long id;
	private String codigoRem;	
	private String nombreApellidos; 
   	private String codPprovincia;
   	private String codLocalidad;
	private Date fechaAlta;  
	private Integer esCustodio;
    private String codEstadoProveedor;
   	private String codCartera;
	private String codCalificacion;
	private Integer esTop;
	private String codCalificacionPropuesta;
	private Integer esTopPropuesto;
	private Integer esHomologado;
	
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
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
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
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
	public String getCodCalificacionPropuesta() {
		return codCalificacionPropuesta;
	}
	public void setCodCalificacionPropuesta(String codCalificacionPropuesta) {
		this.codCalificacionPropuesta = codCalificacionPropuesta;
	}
	public Integer getEsTopPropuesto() {
		return esTopPropuesto;
	}
	public void setEsTopPropuesto(Integer esTopPropuesto) {
		this.esTopPropuesto = esTopPropuesto;
	}
	public Integer getEsHomologado() {
		return esHomologado;
	}
	public void setEsHomologado(Integer esHomologado) {
		this.esHomologado = esHomologado;
	}
	
}

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
   	private String codProvincia;
   	private String desProvincia;
   	private String codLocalidad;
   	private String desLocalidad;
	private Date fechaAlta;  
	private Integer esCustodio;
    private String codEstadoProveedor;
    private String desEstadoProveedor;
   	private String codCartera;
   	private String desCartera;
	private String codCalificacion;
	private String desCalificacion;
	private Integer esTop;
	private String codCalificacionPropuesta;
	private String desCalificacionPropuesta;
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
	public String getCodProvincia() {
		return codProvincia;
	}
	public void setCodProvincia(String codProvincia) {
		this.codProvincia = codProvincia;
	}
	public String getDesProvincia() {
		return desProvincia;
	}
	public void setDesProvincia(String desProvincia) {
		this.desProvincia = desProvincia;
	}
	public String getCodLocalidad() {
		return codLocalidad;
	}
	public void setCodLocalidad(String codLocalidad) {
		this.codLocalidad = codLocalidad;
	}
	public String getDesLocalidad() {
		return desLocalidad;
	}
	public void setDesLocalidad(String desLocalidad) {
		this.desLocalidad = desLocalidad;
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
	public String getDesEstadoProveedor() {
		return desEstadoProveedor;
	}
	public void setDesEstadoProveedor(String desEstadoProveedor) {
		this.desEstadoProveedor = desEstadoProveedor;
	}
	public String getCodCartera() {
		return codCartera;
	}
	public void setCodCartera(String codCartera) {
		this.codCartera = codCartera;
	}
	public String getDesCartera() {
		return desCartera;
	}
	public void setDesCartera(String desCartera) {
		this.desCartera = desCartera;
	}
	public String getCodCalificacion() {
		return codCalificacion;
	}
	public void setCodCalificacion(String codCalificacion) {
		this.codCalificacion = codCalificacion;
	}
	public String getDesCalificacion() {
		return desCalificacion;
	}
	public void setDesCalificacion(String desCalificacion) {
		this.desCalificacion = desCalificacion;
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
	public String getDesCalificacionPropuesta() {
		return desCalificacionPropuesta;
	}
	public void setDesCalificacionPropuesta(String desCalificacionPropuesta) {
		this.desCalificacionPropuesta = desCalificacionPropuesta;
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
	
	public void clear(){
		this.id = null;
		this.codigoRem = null;
		this.nombreApellidos = null;
		this.codProvincia = null;
		this.desProvincia = null;
		this.codLocalidad = null;
		this.desLocalidad = null;
		this.fechaAlta  = null;
		this.esCustodio = null;
		this.codEstadoProveedor = null;
		this.desEstadoProveedor = null;
		this.codCartera = null;
		this.desCartera = null;
		this.codCalificacion = null;
		this.desCalificacion = null;
		this.esTop = null;
		this.codCalificacionPropuesta = null;
		this.desCalificacionPropuesta = null;
		this.esTopPropuesto = null;
		this.esHomologado = null;
	}
	

}

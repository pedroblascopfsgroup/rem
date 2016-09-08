package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de las subsanaciones expediente.
 *  
 * @author Luis Caballero
 *
 */
public class DtoSubsanacion extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long idSubsanacion;
	private String estado;
	private String peticionario;
	private String motivo;
	private Date fechaPeticion;
	private String gastosSubsanacion;
	private String gastosInscripcion;
	
	
	public Long getIdSubsanacion() {
		return idSubsanacion;
	}
	public void setIdSubsanacion(Long idSubsanacion) {
		this.idSubsanacion = idSubsanacion;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getPeticionario() {
		return peticionario;
	}
	public void setPeticionario(String peticionario) {
		this.peticionario = peticionario;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public Date getFechaPeticion() {
		return fechaPeticion;
	}
	public void setFechaPeticion(Date fechaPeticion) {
		this.fechaPeticion = fechaPeticion;
	}
	public String getGastosSubsanacion() {
		return gastosSubsanacion;
	}
	public void setGastosSubsanacion(String gastosSubsanacion) {
		this.gastosSubsanacion = gastosSubsanacion;
	}
	public String getGastosInscripcion() {
		return gastosInscripcion;
	}
	public void setGastosInscripcion(String gastosInscripcion) {
		this.gastosInscripcion = gastosInscripcion;
	}
   		
}
